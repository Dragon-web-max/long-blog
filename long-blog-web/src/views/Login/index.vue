<template>
  <div>
    <div class="login-container">
      <!-- 登录表单 -->
      <div class="login-body">
        <el-tooltip
          class="item"
          effect="dark"
          content="回到首页"
          placement="top"
        >
          <button class="back-btn" @click="backToHome">
            <i class="el-icon-back"></i>
          </button>
        </el-tooltip>

        <!-- 账号密码登录表单 -->
        <div v-show="currentForm === 'account'" class="form-container">
          <div class="form-header">
            <h2 class="form-title">账号密码登录</h2>
            <p class="form-subtitle">欢迎回来,请输入您的账号</p>
          </div>

          <el-form :model="loginForm" :rules="rules" ref="ruleFrom">
            <el-form-item class="form-item" prop="username">
              <el-input
                prefix-icon="el-icon-user-solid"
                v-model="loginForm.username"
                placeholder="请输入用户名"
                @keyup.enter.native="handleLogin"
                size="large"
              />
            </el-form-item>

            <el-form-item class="form-item" prop="password">
              <el-input
                prefix-icon="el-icon-lock"
                v-model="loginForm.password"
                placeholder="请输入密码"
                @keyup.enter.native="handleLogin"
                show-password
                size="large"
              />
            </el-form-item>

            <div class="form-options">
              <el-checkbox v-model="rememberMe">记住我</el-checkbox>
            </div>

            <el-form-item class="form-item">
              <el-button
                class="submit-btn ripple"
                :loading="loading"
                @click="handleLogin"
                type="primary"
              >
                登 录
              </el-button>
            </el-form-item>
          </el-form>

          <div class="form-switch">
            <a @click="switchForm('register')">立即注册</a>
            <span class="divider-line">|</span>
            <a @click="switchForm('forgot')">忘记密码?</a>
          </div>
        </div>

        <!-- 注册表单 -->
        <div v-show="currentForm === 'register'" class="form-container">
          <div class="form-header">
            <h2 class="form-title">注册账号</h2>
            <p class="form-subtitle">欢迎注册,请输入您的账号</p>
          </div>
          <el-form :model="registerForm" :rules="rules" ref="registerForm">
            <el-form-item lable="昵称" prop="nickname">
              <el-input
                prefix-icon="el-icon-user-solid"
                v-model="registerForm.nickname"
                placeholder="请输入昵称"
              />
            </el-form-item>

            <el-form-item class="form-item" prop="password">
              <el-input
                prefix-icon="el-icon-lock"
                v-model="registerForm.password"
                placeholder="请输入密码"
                show-password
              />
            </el-form-item>

            <el-form-item class="form-item">
              <el-button
                class="submit-btn"
                :loading="loading"
                @click="handleRegister"
              >
                注 册
              </el-button>
            </el-form-item>

            <div class="form-switch">
              已有账号？<a @click="switchForm('account')">立即登录</a>
            </div>
          </el-form>
        </div>

        <!-- 忘记密码表单 -->
        <div v-show="currentForm === 'forgot'" class="form-container">
          <div class="form-header">
            <h2 class="form-title">找回账号</h2>
            <p class="form-subtitle">重置密码,请输入您的邮箱</p>
          </div>
          <el-form :model="forgotForm" :rules="rules" ref="forgotForm">
            <el-form-item class="form-item" prop="email">
              <el-input
                prefix-icon="el-icon-message"
                v-model="forgotForm.email"
                placeholder="请输入注册邮箱"
              />
            </el-form-item>

            <el-form-item class="form-item" prop="code">
              <el-input
                prefix-icon="el-icon-key"
                v-model="forgotForm.code"
                placeholder="请输入验证码"
              >
                <template slot="append">
                  <el-button
                    @click="sendVerificationCode"
                    :disabled="codeSending"
                  >
                    {{ codeButtonText }}
                  </el-button>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item class="form-item" prop="password">
              <el-input
                prefix-icon="el-icon-lock"
                v-model="forgotForm.password"
                placeholder="请输入新密码"
                show-password
              />
            </el-form-item>

            <el-form-item class="form-item">
              <el-button
                class="submit-btn"
                :loading="loading"
                @click="handleResetPassword"
              >
                重置密码
              </el-button>
            </el-form-item>

            <div class="form-switch">
              <a @click="switchForm('account')">返回登录</a>
            </div>
          </el-form>
        </div>
      </div>
    </div>

    <!-- 滑块验证 -->
    <el-dialog
      title="请拖动滑块完成拼图"
      width="360px"
      :visible.sync="isShowSliderVerify"
      :close-on-click-modal="false"
      @close="refresh"
      append-to-body
    >
      <slider-verify
        ref="sliderVerify"
        @success="onSuccess"
        @fail="onFail"
        @again="onAgain"
      />
    </el-dialog>
  </div>
</template>

<script>
import { disableScroll, enableScroll } from "@/utils/scroll";
import {
  sendEmailCodeApi,
  registerApi,
  forgotPasswordApi,
  getCaptchaSwitchApi,
} from "@/api/auth";
import { setCookie } from "@/utils/cookie";
import SliderVerify from "./components/SliderVerify.vue";
export default {
  name: "Login",
  components: {
    SliderVerify,
  },
  data() {
    return {
      currentForm: "account",
      loading: false,
      countdown: 0,
      loginForm: {
        username: "",
        password: "",
        source: "PC",
      },
      registerForm: {
        nickname: "",
        password: "",
      },
      forgotForm: {
        email: "",
        code: "",
        password: "",
      },
      codeSending: false,
      codeButtonText: "发送验证码",
      codeTimer: null,
      isShowSliderVerify: false,
      sliderVerify: null,
      rules: {
        nickname: [
          { required: true, message: "请输入昵称", trigger: "blur" },
          {
            min: 3,
            max: 10,
            message: "长度在 3 到 10 个字符",
            trigger: "blur",
          },
        ],
        username: [
          { required: true, message: "请输入用户名", trigger: "blur" },
          {
            min: 3,
            max: 50,
            message: "长度在 3 到 50 个字符",
            trigger: "blur",
          },
        ],
        email: [
          { required: true, message: "请输入邮箱", trigger: "blur" },
          { type: "email", message: "请输入正确的邮箱", trigger: "blur" },
        ],
        password: [
          { required: true, message: "请输入密码", trigger: "blur" },
          {
            min: 6,
            max: 16,
            message: "长度在 6 到 16 个字符",
            trigger: "blur",
          },
        ],
        code: [{ required: true, message: "请输入验证码", trigger: "blur" }],
      },
      rememberMe: false,
    };
  },

  created() {
    this.$nextTick(() => {
      disableScroll();
    });
  },
  methods: {
    /**
     * 滑块验证成功
     */
    async onSuccess(captcha) {
      this.loginForm.nonceStr = captcha.nonceStr;
      this.loginForm.value = captcha.value;
      this.login();
    },
    async login() {
      this.loading = true;
      try {
        await this.$store.dispatch("loginAction", this.loginForm);
        this.$refs.sliderVerify?.verifySuccessEvent();
        this.$message.success("登录成功");
        this.handleClose();
      } catch (error) {
        this.$message.error(error.message || "登录失败，请重试");
        this.refresh();
      } finally {
        this.loading = false;
      }
    },
    /**
     * 滑块验证失败
     */
    onFail() {
      this.$message.error("验证失败，请重试");
    },
    /**
     * 滑块验证重新开始
     */
    onAgain() {
      this.$message.error("验证失败，请重试");
    },
    /**
     * 刷新
     */
    refresh() {
      this.$refs.sliderVerify.refresh();
    },
    /**
     * 切换表单
     * @param form
     */
    switchForm(form) {
      this.currentForm = form;
      this.loading = false;
      this.clearTimer();
    },
    /**
     * 登录
     */
    async handleLogin() {
      this.$refs["ruleFrom"].validate(async (valid) => {
        if (valid) {
          getCaptchaSwitchApi().then((res) => {
            if (!res.data || res.data.configValue === "Y") {
              this.isShowSliderVerify = true;
            } else {
              this.login();
            }
          });
        } else {
          return false;
        }
      });
    },
    /**
     * 注册
     */
    async handleRegister() {
      this.$refs["registerForm"].validate(async (valid) => {
        if (valid) {
          this.loading = true;
          try {
            await registerApi(this.registerForm);
            this.$message.success("注册成功");
            this.switchForm("account");
          } catch (error) {
            this.$message.error(error.message || "注册失败，请重试");
          } finally {
            this.loading = false;
          }
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    /**
     * 忘记密码
     */
    async handleResetPassword() {
      this.$refs["forgotForm"].validate(async (valid) => {
        if (valid) {
          this.loading = true;
          try {
            // 调用重置密码接口
            await forgotPasswordApi(this.forgotForm);
            this.$message.success("密码重置成功");
            this.switchForm("account");
          } catch (error) {
            this.$message.error(error.message || "重置失败，请重试");
          } finally {
            this.loading = false;
          }
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    /**
     * 发送忘记密码邮箱验证码
     */
    async sendVerificationCode() {
      if (this.codeSending) return;

      if (!this.forgotForm.email) {
        this.$message.error("请先输入邮箱");
        return;
      }

      this.codeSending = true;
      this.sendEmailCode(this.forgotForm.email);
    },

    /**
     * 发送邮箱验证码
     */
    sendEmailCode(email) {
      sendEmailCodeApi(email)
        .then((res) => {
          this.$message.success("发送成功，请前往邮箱查看验证码");
          // 开始倒计时
          let countdown = 60;
          this.codeButtonText = `${countdown}秒后重试`;

          this.codeTimer = setInterval(() => {
            countdown--;
            if (countdown <= 0) {
              clearInterval(this.codeTimer);
              this.codeSending = false;
              this.codeButtonText = "发送验证码";
            } else {
              this.codeButtonText = `${countdown}秒后重试`;
            }
          }, 1000);
        })
        .catch((err) => {
          this.$message.error(err.message || "发送失败");
          this.codeSending = false;
        });
    },

    /**
     * 清理定时器
     */
    clearTimer() {
      if (this.codeTimer) {
        clearInterval(this.codeTimer);
      }
    },

    /**
     * 关闭登录弹窗
     */
    handleClose() {
      this.$router.go(-1);
    },

    /**
     * 回到首页
     */
    backToHome() {
      this.$router.push("/");
    },
  },
  beforeDestroy() {
    enableScroll();
    this.clearTimer();
  },
};
</script>
<style scoped lang="scss">
.login-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url("@/assets/login-bg.svg") no-repeat;
  background-size: cover;
  min-height: 100vh;
  z-index: 2000;
}

.login-body {
  width: 420px;
  padding: 32px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
    0 2px 4px -1px rgba(0, 0, 0, 0.06);
  backdrop-filter: blur(8px);
  background: rgba(255, 255, 255, 0.95);
  position: relative;
}

.form-container {
  animation: fadeIn 0.3s ease;
}

.form-item {
  margin-bottom: 20px;

  :deep(.el-input__inner) {
    height: 44px;
    font-size: 14px;

    &::placeholder {
      color: #9ca3af;
    }
  }

  :deep(.el-input__prefix) {
    left: 12px;
    color: #6b7280;
  }
}

.submit-btn {
  width: 100%;
  height: 42px;
  border: none;
  border-radius: 8px;
  background: #6366f1;
  color: #fff;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    background: #4f46e5;
    transform: translateY(-1px);
  }

  &:active {
    transform: translateY(0);
  }
}

.divider {
  margin: 24px 0;
  color: #9ca3af;

  :deep(.el-divider__text) {
    background-color: #fff;
    padding: 0 12px;
    font-size: 14px;
  }
}

.third-party-login {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-bottom: 24px;
}

.login-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.2s;
  background: #f3f4f6;

  &:hover {
    transform: translateY(-2px);
  }

  &.github {
    color: #24292e;
  }
  &.qq {
    color: #12b7f5;
  }
  &.wechat {
    color: #07c160;
  }
  &.gitee {
    color: #c71d23;
  }
  &.weibo {
    color: #e6162d;
  }
}

.form-switch {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 24px;
  color: #6b7280;
  font-size: 14px;

  a {
    color: $primary;
    text-decoration: none;
    font-weight: 500;
    cursor: pointer;

    &:hover {
      color: darken($primary, 10%);
    }
  }
}

.divider-line {
  color: #e5e7eb;
  margin: 0 12px;
}

.qrcode-content {
  padding: 24px;
  text-align: center;
  animation: fadeIn 0.3s ease;
}

.qrcode-box {
  width: 200px;
  height: 200px;
  margin: 0 auto 16px;
  padding: 8px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.qrcode-tip {
  margin: 8px 0;
  color: #6b7280;
  font-size: 14px;
}

.code-text {
  color: #6366f1;
  font-weight: 500;
  i {
    cursor: pointer;
    margin-left: $spacing-sm;
  }
}

.form-header {
  text-align: center;
  margin-bottom: 32px;
}

.form-title {
  font-size: 24px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0 0 8px;
}

.form-subtitle {
  font-size: 14px;
  color: #666;
  margin: 0;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.forgot-link {
  color: $primary;
  font-size: 14px;
  cursor: pointer;

  &:hover {
    color: darken($primary, 10%);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.switch-form-btn {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  background: #f3f4f6;
  border: none;
  color: #6b7280;

  &:hover {
    background: #e5e7eb;
    transform: rotate(180deg);
  }

  i {
    font-size: 20px;
  }
}

.back-btn {
  position: absolute;
  top: 16px;
  right: 60px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  background: #f3f4f6;
  border: none;
  color: #6b7280;
  z-index: 1;

  &:hover {
    background: #e5e7eb;
    transform: translateX(-4px);
    color: #6366f1;
  }

  i {
    font-size: 20px;
  }
}
</style>
