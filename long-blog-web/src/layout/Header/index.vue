<template>
  <header 
    class="site-header" 
    :class="{ 
      'header-hidden': !isHeaderVisible,
      'header-transparent': isHeaderTransparent,
      'header-scrolled': !isHeaderTransparent && isHeaderVisible
    }"
  >
    <nav class="navbar">
      <!-- Logo部分 -->
      <div class="nav-logo">
        <router-link to="/" class="logo">
          <span class="logo-text">LONG</span>
        </router-link>
      </div>

      <!-- 中间导航菜单 -->
      <div class="nav-center">
        <div 
          v-for="item in filteredMenuItems" 
          :key="item.path"
          class="nav-item"
        >
          <router-link 
            :to="item.path"
            class="nav-link"
            :class="{ 'has-dropdown': item.children, 'active': isActive(item) }"
          >
            {{ item.name }}
          </router-link>
          
          <div v-if="item.children" 
               class="dropdown-menu"
          >
            <a
              href="javascript:void(0)"
              v-for="child in item.children"
              :key="child.path"
              class="dropdown-item"
              :class="{ 'active': isChildActive(child) }"
              @click="handleDropdownItemClick(child)"
            >
              {{ child.name }}
            </a>
          </div>
        </div>
      </div>

      <!-- 右侧工具栏 -->
      <div class="nav-right">
        <a href="javascript:void(0)" class="icon-btn" @click="handleSearch">
          <i class="fas fa-search"></i>
        </a>

        <router-link to="/chat" class="icon-btn">
          <i class="fas fa-comments"></i>
        </router-link>

        <router-link to="/notifications" class="icon-btn">
          <i class="far fa-bell"></i>
          <span class="badge" v-if="showBage()" />
        </router-link>

        <div class="theme-toggle">
          <button class="icon-btn" @click="toggleTheme">
            <i :class="isDarkMode ? 'fas fa-sun' : 'fas fa-moon'"></i>
          </button>
        </div>

        <div class="user-info">
          <div v-if="$store.state.userInfo" class="user-section" @mouseleave="startCloseTimer">
            <div class="avatar" @mouseenter="showDropdown = true; clearCloseTimer()">
              <el-avatar :src="$store.state.userInfo.avatar" />
            </div>
            <!-- 用户下拉菜单 -->
            <div class="user-dropdown" v-show="showDropdown" @mouseenter="clearCloseTimer()" @mouseleave="startCloseTimer()">
              <div class="dropdown-header">
                <img :src="$store.state.userInfo.avatar" :alt="$store.state.userInfo.nickname">
                <div class="user-details">
                  <span class="username">{{ $store.state.userInfo.nickname }}</span>
                  <span class="role">{{ $store.state.userInfo.role === 'admin' ? '管理员' : '普通用户' }}</span>
                </div>
              </div>
              <div class="dropdown-divider"></div>
              <router-link to="/user/profile" class="dropdown-item">
                <i class="fas fa-user"></i>
                个人中心
              </router-link>
              <div class="dropdown-item" @click="handleLogout">
                <i class="fas fa-sign-out-alt"></i>
                退出登录
              </div>
            </div>
          </div>
          <div v-else class="avatar" @click="handleLogin">
            <el-avatar class="avatar-icon"
              :src="$store.state.webSiteInfo.touristAvatar" 
            />
          </div>
        </div>

        <!-- 移动端菜单按钮 -->
        <button class="menu-btn" @click="handleOpenMobileMenu">
          <i class="fas fa-bars"></i>
        </button>
      </div>
    </nav>
  </header>
</template>

<script>
import { getThemeMode, setThemeMode } from '@/utils/theme';

export default {
  name: 'TheHeader',
  data() {
    return {
      searchQuery: '',
      showSearchPanel: false,
      showMobileSearch: false,
      lastScrollTop: 0,
      isHeaderVisible: true,
      isHeaderTransparent: true,
      isDarkMode: getThemeMode() === 'dark',
      menuItems: [
        { name: '首页', path: '/' },
        { 
          name: '文章归档', 
          path: '/archives', 
          children: [
            { name: '归档', path: '/archive' },
            { name: '分类', path: '/categories' },
            { name: '标签', path: '/tags' }
          ]
        },
        { name: '说说', path: '/moments' },
        { name: '热搜', path: '/hotsearch' },
        { name: '资源', path: '/resources' },
        { name: '相册', path: '/photos' },
        { name: '留言板', path: '/messages' },
        { name: '友情链接', path: '/friends' },
        { 
          name: '关于本站', 
          path: '/about', 
          // children: [
          //   { name: '关于我', path: '/about' },
          // ]
        },
      ],
      showDropdown: false,
      showSearch: false,
      unreadCount: 0,
      closeTimer: null
    }
  },
  computed: {
    filteredMenuItems() {
      return this.menuItems.map(item => ({
        ...item,
        path: item.children ? item.children[0].path : item.path
      }))
    }
  },
  methods: {
    toggleTheme() {
      this.isDarkMode = !this.isDarkMode;
      setThemeMode(this.isDarkMode ? 'dark' : 'light');
    },
    handleOpenMobileMenu() {
      this.$store.commit('SET_MOBILE_MENU_VISIBLE', true)
    },
    handleSearch() {
      this.$store.commit('SET_SEARCH_VISIBLE', true)
    },
    handleLogin() {
      // 处理登录逻辑
      this.$router.push('/login')
    },
    closeAllPanels() {
      this.showMobileSearch = false
    },
    closeMobileSearch() {
      this.showMobileSearch = false
      this.searchQuery = ''
    },
    handleMobileSearch(tag) {
      this.searchQuery = tag
      this.$refs.mobileSearchInput.focus()
    },
    isActive(item) {
      if (item.children) {
        // 如果子菜单，检查是否有子菜单项被激活
        return item.children.some(child => this.isChildActive(child))
      }
      // 精确匹配路由路径
      return this.$route.path === item.path
    },
    isChildActive(child) {
      return this.$route.path === child.path
    },
    handleDropdownItemClick(item) {
      if (item.external) {
        window.open(item.path, '_blank')
        return
      }
      this.$router.push(item.path)
    },
    handleLogout() {
      this.$store.dispatch('logout')
      this.$message.success('已退出登录')
      this.showDropdown = false
    },
    showBage() {
      return this.$store.state.isUnread
    },
    handleScroll() {
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
      
      this.isHeaderVisible = true;
      this.lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;

      this.isHeaderTransparent = true;
    },
    startCloseTimer() {
      this.closeTimer = setTimeout(() => {
        this.showDropdown = false;
      }, 300);
    },
    clearCloseTimer() {
      if (this.closeTimer) {
        clearTimeout(this.closeTimer);
        this.closeTimer = null;
      }
      this.showDropdown = true;
    }
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll);
    this.handleScroll(); // Initial check
  },
  watch: {
    '$route'() {
      this.handleScroll(); // Re-check on route change
    }
  },
  beforeDestroy() {
    window.removeEventListener('scroll', this.handleScroll);
    if (this.closeTimer) {
      clearTimeout(this.closeTimer);
    }
  }
}
</script>

<style lang="scss" scoped>
.site-header {
  position: fixed;
  width: 100%;
  top: 0;
  left: 0;
  height: 64px;
  z-index: 1000;
  transition: all 0.3s ease;
  backdrop-filter: blur(8px);
  background-color: rgba(255, 255, 255, 0.2) !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.header-transparent {
  background-color: rgba(255, 255, 255, 0.2) !important;
  backdrop-filter: blur(8px);

  .logo-text,
  .nav-link,
  .icon-btn {
    color: white !important;
  }
  
  .nav-link:hover {
    background-color: transparent !important;
    &:after {
      background-color: white !important;
      width: 80% !important;
    }
  }
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
}

.nav-logo {
  .logo {
    text-decoration: none;
    
    .logo-text {
      font-size: 24px;
      font-weight: 700;
      letter-spacing: 1px;
      color: #333;
    }
  }
}

.nav-center {
  display: flex;
  align-items: center;
  gap: 10px;
  
  .nav-item {
    position: relative;
    
    &:hover {
      .dropdown-menu {
        opacity: 1;
        visibility: visible;
        transform: translateX(-50%) translateY(0);
        pointer-events: auto;
        
        .dropdown-item {
          opacity: 1;
          transform: translateX(0);
        }
      }
    }
  }
  
  .nav-link {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 6px 12px;
    border-radius: 4px;
    color: #fff;
    font-size: 15px;
    text-decoration: none;
    transition: all 0.2s ease;
    position: relative;
    
    &:after {
      content: '';
      position: absolute;
      bottom: -2px;
      left: 50%;
      transform: translateX(-50%);
      width: 0;
      height: 2px;
      background-color: #fff;
      transition: width 0.3s ease;
    }
    
    &:hover, &.active {
      background-color: transparent;
      &:after {
        width: 80%;
      }
    }

    &.active:after {
      width: 80%;
    }
  }
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%) translateY(10px);
  min-width: 240px; /* 增加宽度以容纳横向排列的三个项目 */
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  padding: 10px;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  pointer-events: none;
  margin-top: 10px;
  display: flex;
  flex-direction: row; /* 改为横向排列 */
  justify-content: space-around; /* 均匀分布 */
  align-items: center;
  flex-wrap: nowrap; /* 确保不换行 */
  overflow: hidden;
  backdrop-filter: blur(10px);
  
  &:before {
    display: none; // 移除箭头
  }
  
  .dropdown-item {
    display: block;
    padding: 8px 10px;
    color: #333;
    text-decoration: none;
    transition: all 0.3s ease;
    text-align: center;
    font-size: 15px;
    width: auto; /* 移除100%宽度 */
    border-radius: 8px; /* 添加圆角 */
    
    &:hover {
      background-color: rgba(0, 0, 0, 0.05);
      color: $primary;
    }
    
    &.active {
      color: $primary;
    }
  }
}

/* 确保在悬停时的过渡效果正确 */
.nav-item {
  &:hover {
    .dropdown-menu {
      opacity: 1;
      visibility: visible;
      transform: translateX(-50%) translateY(0);
      pointer-events: auto;
    }
  }
}

.user-dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  width: 240px;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  overflow: hidden;
  z-index: 1000;
  margin-top: 10px;
  backdrop-filter: blur(8px);
  
  .dropdown-header {
    padding: 16px;
    display: flex;
    align-items: center;
    gap: 12px;
    
    img {
      width: 42px;
      height: 42px;
      border-radius: 50%;
    }
    
    .user-details {
      .username {
        font-weight: 500;
        font-size: 16px;
      }
      
      .role {
        font-size: 13px;
        color: #666;
      }
    }
  }
  
  .dropdown-divider {
    height: 1px;
    background: #eee;
  }
  
  .dropdown-item {
    padding: 12px 16px;
    display: flex;
    align-items: center;
    gap: 12px;
    color: #333;
    text-decoration: none;
    
    &:hover {
      background: rgba(0, 0, 0, 0.05);
    }
  }
}

.nav-right {
  display: flex;
  align-items: center;
  gap: 8px;
  
  .icon-btn {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #666;
    font-size: 16px;
    transition: all 0.2s ease;
    background: transparent;
    border: none;
    cursor: pointer;
    position: relative;
    
    &:hover {
      background-color: rgba(0, 0, 0, 0.05);
      color: #333;
    }
    
    .badge {
      position: absolute;
      top: 2px;
      right: 2px;
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background-color: red;
    }
  }
  
  .avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    overflow: hidden;
    cursor: pointer;
    transition: transform 0.2s;

    &:hover {
      transform: scale(1.05);
    }
  }
}

/* 移动端样式 */
.menu-btn {
  display: none;
  background: transparent;
  border: none;
  padding: 0;
  color: #333;
  font-size: 20px;
  cursor: pointer;
}

@media (max-width: 768px) {
  .nav-center {
    display: none;
  }
  
  .menu-btn {
    display: block;
  }
  
  .nav-right {
    .theme-toggle,
    .icon-btn:not(:last-child) {
      display: none;
    }
  }
}

:root[data-theme='dark'] {
  .site-header {
    background-color: rgba(18, 18, 18, 0.2) !important;
  }
  
  .nav-logo .logo-text,
  .nav-link,
  .icon-btn,
  .dropdown-item {
    color: #e0e0e0;
  }
  
  .nav-link:hover, 
  .nav-link.active,
  .icon-btn:hover,
  .dropdown-item:hover {
    background-color: transparent;
  }
  
  .nav-link:after,
  .dropdown-item:after {
    background-color: $primary;
  }
  
  .dropdown-menu,
  .user-dropdown {
    background: rgba(26, 26, 26, 0.7);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  }
  
  .dropdown-divider {
    background: #333;
  }
}
</style> 

