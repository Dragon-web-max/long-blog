package com.mojian.service.impl;

import cn.dev33.satoken.secure.BCrypt;
import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpUtil;
import cn.hutool.json.JSONUtil;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.mojian.common.Constants;
import com.mojian.common.RedisConstants;
import com.mojian.config.properties.*;
import com.mojian.dto.Captcha;
import com.mojian.dto.EmailRegisterDto;
import com.mojian.dto.LoginDTO;
import com.mojian.dto.RegisterDTO;
import com.mojian.dto.user.LoginUserInfo;
import com.mojian.entity.SysConfig;
import com.mojian.entity.SysRole;
import com.mojian.enums.LoginTypeEnum;
import com.mojian.mapper.SysConfigMapper;
import com.mojian.service.AuthService;
import com.mojian.entity.SysUser;
import com.mojian.enums.MenuTypeEnum;
import com.mojian.exception.ServiceException;
import com.mojian.mapper.SysMenuMapper;
import com.mojian.mapper.SysRoleMapper;
import com.mojian.mapper.SysUserMapper;
import com.mojian.utils.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.mp.bean.message.WxMpXmlMessage;
import me.zhyd.oauth.config.AuthConfig;
import me.zhyd.oauth.exception.AuthException;
import me.zhyd.oauth.model.AuthCallback;
import me.zhyd.oauth.model.AuthResponse;
import me.zhyd.oauth.model.AuthUser;
import me.zhyd.oauth.request.*;
import me.zhyd.oauth.utils.AuthStateUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {


    private final SysUserMapper userMapper;

    private final SysRoleMapper roleMapper;

    private final SysMenuMapper menuMapper;

//    private final EmailUtil emailUtil;

    private final RedisUtil redisUtil;

    private final SysUserMapper sysUserMapper;

    private final String[] avatarList = {
            "https://api.dicebear.com/6.x/pixel-art/svg?seed=Raccoon",
            "https://api.dicebear.com/6.x/pixel-art/svg?seed=Kitty",
            "https://api.dicebear.com/6.x/pixel-art/svg?seed=Puppy",
            "https://api.dicebear.com/6.x/pixel-art/svg?seed=Bunny",
            "https://api.dicebear.com/6.x/pixel-art/svg?seed=Fox"
    };
    private final SysRoleMapper sysRoleMapper;

    private final GiteeConfigProperties giteeConfigProperties;

    private final GithubConfigProperties githubConfigProperties;

    private final QqConfigProperties qqConfigProperties;

    private final WeiboConfigProperties weiboConfigProperties;

    private final WechatProperties wechatProperties;

    private final SysConfigMapper sysConfigMapper;


    @Override
    public LoginUserInfo login(LoginDTO loginDTO) {

        SysConfig verifySwitch = sysConfigMapper.selectOne(new LambdaQueryWrapper<SysConfig>().eq(SysConfig::getConfigKey, "slider_verify_switch"));
        if (verifySwitch != null && verifySwitch.getConfigValue().equals("Y")) {
            //校验验证码
            CaptchaUtil.checkImageCode(loginDTO.getNonceStr(), loginDTO.getValue());
        }


        // 查询用户
        SysUser user = userMapper.selectByUsername(loginDTO.getUsername());

        //校验是否能够登录
        validateLogin(loginDTO, user);

        // 执行登录
        StpUtil.login(user.getId());
        String tokenValue = StpUtil.getTokenValue();

        // 返回用户信息
        LoginUserInfo loginUserInfo = BeanCopyUtil.copyObj(user, LoginUserInfo.class);
        loginUserInfo.setToken(tokenValue);

        StpUtil.getSession().set(Constants.CURRENT_USER, loginUserInfo);
        return loginUserInfo;
    }

    private static void validateLogin(LoginDTO loginDTO, SysUser user) {
        if (user == null) {
            throw new ServiceException("登录用户不存在");
        }

        // 验证密码
        if (!BCrypt.checkpw(loginDTO.getPassword(), user.getPassword())) {
            throw new ServiceException("用户名或密码错误");
        }

        // 验证状态
        if (user.getStatus() != 1) {
            throw new ServiceException("账号已被禁用");
        }

        if (user.getUsername().equals(Constants.TEST) && loginDTO.getSource().equalsIgnoreCase("PC")) {
            throw new ServiceException("演示用户不允许门户登录！");
        }
    }

    @Override
    public LoginUserInfo getLoginUserInfo(String source) {
        // 获取当前登录用户ID
        Integer userId = StpUtil.getLoginIdAsInt();
        SysUser user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        LoginUserInfo loginUserInfo = BeanCopyUtil.copyObj(user, LoginUserInfo.class);

        //获取菜单权限列表
        if (source.equalsIgnoreCase(Constants.ADMIN)) {
            List<String> permissions;
            List<String> roles = roleMapper.selectRolesCodeByUserId(userId);
            if (roles.contains(Constants.ADMIN)) {
                permissions = menuMapper.getPermissionList(MenuTypeEnum.BUTTON.getCode());
            } else {
                permissions = menuMapper.getPermissionListByUserId(userId, MenuTypeEnum.BUTTON.getCode());
            }
            loginUserInfo.setRoles(roles);
            loginUserInfo.setPermissions(permissions);
        }

        return loginUserInfo;
    }

    @Override
    public Boolean sendEmailCode(String email) throws MessagingException {
//        emailUtil.sendCode(email);
        return true;
    }

    @Override
    public Boolean registerPwd(RegisterDTO registerDTO) {
        String username=registerDTO.getUsername();
        String password=registerDTO.getPassword();
        // 校验用户名长度（3 - 10 位）
        if (username == null || username.length() < 3 || username.length() > 10) {
            throw new ServiceException("用户名长度需在 3 到 10 位之间");
        }
        // 校验密码长度（6 - 16 位）
        if (password == null || password.length() < 6 || password.length() > 16) {
            throw new ServiceException("密码长度需在 6 到 16 位之间");
        }
        //查找用户名
        SysUser user = userMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
        if (user != null) {
            throw new ServiceException("当前用户名已存在");
        }
        //获取随机头像
        String avatar = avatarList[(int) (Math.random() * avatarList.length)];
        //随机生成用户名
        String nickName = "user_" + getRandomString(6);
        SysUser sysUser = SysUser.builder()
                .username(registerDTO.getUsername())
                .password(BCrypt.hashpw(registerDTO.getPassword()))
                .nickname(nickName)
                .avatar(avatar)
                .status(Constants.YES)
                .build();
        sysUserMapper.insert(sysUser);
        return  true;
    }


    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean register(EmailRegisterDto dto) {

        validateEmailCode(dto);

        SysUser sysUser = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, dto.getEmail()));
        if (sysUser != null) {
            throw new ServiceException("当前邮箱已注册，请前往登录");
        }

        //获取随机头像
        String avatar = avatarList[(int) (Math.random() * avatarList.length)];
        sysUser = SysUser.builder()
                .username(dto.getEmail())
                .password(BCrypt.hashpw(dto.getPassword()))
                .nickname(dto.getNickname())
                .email(dto.getEmail())
                .avatar(avatar)
                .status(Constants.YES)
                .build();
        sysUserMapper.insert(sysUser);

        //添加用户角色信息
        insertRole(sysUser);

        redisUtil.delete(RedisConstants.CAPTCHA_CODE_KEY + dto.getEmail());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean forgot(EmailRegisterDto dto) {
        validateEmailCode(dto);
        SysUser sysUser = sysUserMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, dto.getEmail()));
        if (sysUser == null) {
            throw new ServiceException("当前邮箱未注册，请前往注册");
        }
        sysUser.setPassword(BCrypt.hashpw(dto.getPassword()));
        sysUserMapper.updateById(sysUser);
        redisUtil.delete(RedisConstants.CAPTCHA_CODE_KEY + dto.getEmail());
        return true;
    }

    @Override
    public String getWechatLoginCode() {
        //随机获取4位数字
        String code = "DL" + (int) ((Math.random() * 9 + 1) * 1000);
        redisUtil.set(RedisConstants.WX_LOGIN_USER_CODE + code, "NOT-LOGIN", RedisConstants.MINUTE_EXPIRE, TimeUnit.SECONDS);
        return code;
    }

    @Override
    public LoginUserInfo getWechatIsLogin(String loginCode) {
        Object value = redisUtil.get(RedisConstants.WX_LOGIN_USER + loginCode);

        if (value == null) {
            throw new ServiceException("登录失败");
        }

        LoginUserInfo loginUserInfo = JSONUtil.toBean(JSONUtil.parseObj(value), LoginUserInfo.class);

        StpUtil.login(loginUserInfo.getId());
        loginUserInfo.setToken(StpUtil.getTokenValue());

        return loginUserInfo;
    }

    @Override
    public String wechatLogin(WxMpXmlMessage message) {
        String code = message.getContent().toUpperCase();
        //先判断登录码是否已过期
        Object e = redisUtil.hasKey(RedisConstants.WX_LOGIN_USER_CODE + code);
        if (e == null) {
            return "验证码已过期";
        }
        LoginUserInfo loginUserInfo = wechatLogin(message.getFromUser());
        //修改redis缓存 以便监听是否已经授权成功
        redisUtil.set(RedisConstants.WX_LOGIN_USER + code, JSONUtil.toJsonStr(loginUserInfo), RedisConstants.MINUTE_EXPIRE, TimeUnit.SECONDS);
        return "网站登录成功！(若页面长时间未跳转请刷新验证码)";
    }

    @Override
    public String renderAuth(String source) {
        AuthRequest authRequest = getAuthRequest(source);
        return authRequest.authorize(AuthStateUtils.createState());
    }


    @Override
    public void authLogin(AuthCallback callback,String source, HttpServletResponse httpServletResponse) throws IOException {
        AuthRequest authRequest = getAuthRequest(source);
        AuthResponse<AuthUser> response = authRequest.login(callback);

        if (response.getData() == null) {
            log.info("用户取消了 {} 第三方登录",source);
            return;
        }
        String result = com.alibaba.fastjson.JSONObject.toJSONString(response.getData());
        log.info("第三方登录验证结果:{}", result);

        com.alibaba.fastjson.JSONObject jsonObject = JSON.parseObject(result);
        Object uuid = jsonObject.get("uuid");
        // 获取用户ip信息
        String ipAddress = IpUtil.getIp();
        String ipSource = IpUtil.getIp2region(ipAddress);
        // 判断是否已注册
        SysUser user = userMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, uuid));
        if (ObjectUtils.isEmpty(user)) {
            // 保存账号信息
            user = SysUser.builder()
                    .username(uuid.toString())
                    .password(UUID.randomUUID().toString())
                    .loginType(source)
                    .lastLoginTime(LocalDateTime.now())
                    .ipLocation(ipAddress)
                    .ip(ipSource)
                    .status(Constants.YES)
                    .nickname(source + "-" +getRandomString(6))
                    .avatar(jsonObject.get("avatar").toString())
                    .build();
            userMapper.insert(user);
            //添加角色
            insertRole(user);
        }

        StpUtil.login(user.getId());

    }

    @Override
    public LoginUserInfo appletLogin(String code) {
        String url = "https://api.weixin.qq.com/sns/jscode2session?appid=" + wechatProperties.getAppletAppId()
                + "&secret=" + wechatProperties.getAppletSecret() + "&js_code=" + code + "&grant_type=authorization_code";
        String result = HttpUtil.get(url);
        com.alibaba.fastjson.JSONObject jsonObject = JSON.parseObject(result);
        Object openid = jsonObject.get("openid");
        if (openid == null) {
            throw new ServiceException("登录失败");
        }

        // 查询用户
        SysUser user = userMapper.selectByUsername(openid.toString());

        if (user == null) {
            String ip = IpUtil.getIp();
            String avatar = avatarList[(int) (Math.random() * avatarList.length)];
            user = SysUser.builder()
                    .username(openid.toString())
                    .password(UUID.randomUUID().toString())
                    .loginType(LoginTypeEnum.APPLET.getType())
                    .lastLoginTime(LocalDateTime.now())
                    .ipLocation(IpUtil.getIp2region(ip))
                    .ip(ip)
                    .status(Constants.YES)
                    .nickname("applet-" + getRandomString(6))
                    .avatar(avatar)
                    .build();
            userMapper.insert(user);
            //添加用户角色信息
            this.insertRole(user);
        }else {
            if (user.getStatus() == Constants.NO) {
                throw new ServiceException("账号已被禁用，请联系管理员");
            }
        }

        LoginUserInfo loginUserInfo = BeanCopyUtil.copyObj(user, LoginUserInfo.class);

        StpUtil.login(loginUserInfo.getId());
        loginUserInfo.setToken(StpUtil.getTokenValue());

        return loginUserInfo;
    }

    @Override
    public Captcha getCaptcha() {
        Captcha captcha = new Captcha();
        CaptchaUtil.getCaptcha(captcha);
        return captcha;
    }



    private void validateEmailCode(EmailRegisterDto dto) {
        Object code = redisUtil.get(RedisConstants.CAPTCHA_CODE_KEY + dto.getEmail());
        if (code == null || !code.equals(dto.getCode())) {
            throw new ServiceException("验证码已过期或输入错误");
        }
    }

    private LoginUserInfo wechatLogin(String openId) {

        SysUser user = userMapper.selectByUsername(openId);
        if (ObjectUtils.isEmpty(user)) {
            String ip = IpUtil.getIp();
            String ipSource = IpUtil.getIp2region(ip);

            // 保存账号信息
            user = SysUser.builder()
                    .username(openId)
                    .password(BCrypt.hashpw(openId))
                    .nickname("WECHAT-" + getRandomString(6))
                    .avatar(avatarList[(int) (Math.random() * avatarList.length)])
                    .loginType(LoginTypeEnum.WECHAT.getType())
                    .lastLoginTime(LocalDateTime.now())
                    .ip(ip)
                    .ipLocation(ipSource)
                    .status(Constants.YES)
                    .build();
            userMapper.insert(user);

            //添加用户角色信息
            this.insertRole(user);
        }

        return BeanCopyUtil.copyObj(user, LoginUserInfo.class);
    }

    /**
     * 添加用户角色信息
     * @param user
     */
    private void insertRole(SysUser user) {
        SysRole sysRole = sysRoleMapper.selectOne(new LambdaQueryWrapper<SysRole>().eq(SysRole::getCode, Constants.USER));
        sysRoleMapper.addRoleUser(user.getId(), Collections.singletonList(sysRole.getId()));
    }

    /**
     * 随机生成6位数的字符串
     */
    public static String getRandomString(int length) {
        String str = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm0123456789";
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int number = random.nextInt(str.length());
            sb.append(str.charAt(number));
        }
        return sb.toString();
    }


    private @NotNull AuthRequest getAuthRequest(String source) {
        AuthRequest authRequest = null;
        switch (source) {
            case "gitee":
                authRequest = new AuthGiteeRequest(AuthConfig.builder()
                        .clientId(giteeConfigProperties.getAppId())
                        .clientSecret(giteeConfigProperties.getAppSecret())
                        .redirectUri(giteeConfigProperties.getRedirectUrl())
                        .build());
                break;
            case "qq":
                authRequest = new AuthQqRequest(AuthConfig.builder()
                        .clientId(qqConfigProperties.getAppId())
                        .clientSecret(qqConfigProperties.getAppSecret())
                        .redirectUri(qqConfigProperties.getRedirectUrl())
                        .build());
                break;
            case "weibo":
                authRequest = new AuthWeiboRequest(AuthConfig.builder()
                        .clientId(weiboConfigProperties.getAppId())
                        .clientSecret(weiboConfigProperties.getAppSecret())
                        .redirectUri(weiboConfigProperties.getRedirectUrl())
                        .build());
                break;
            case "github":
                authRequest = new AuthGithubRequest(AuthConfig.builder()
                        .clientId(githubConfigProperties.getAppId())
                        .clientSecret(githubConfigProperties.getAppSecret())
                        .redirectUri(githubConfigProperties.getRedirectUrl())
                        .build());
                break;
            default:
                break;
        }
        if (null == authRequest) {
            throw new AuthException("授权地址无效");
        }
        return authRequest;
    }

}
