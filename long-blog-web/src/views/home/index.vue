<template>
  <div>
    <div class="hero-section">
      <div class="hero-content" :class="{ 'slide-up': isScrolling }">
        <h1 class="main-title">
          {{ mainText }}
        </h1>
        <p class="subtitle">
          {{ displayedSubtitle }}
          <span class="cursor"></span>
        </p>
      </div>
      <div class="scroll-down-indicator" @click="scrollToContent" :class="{ 'slide-down': isScrolling }">
        <i class="fas fa-chevron-down"></i>
      </div>
    </div>
    <div class="home" ref="mainContent">
      <div class="content-layout">
        <main class="home-main-content">
          <Carousel
            v-if="carouselSlides?.length > 0"
            :slides="carouselSlides"
            @click="goToPost"
          />
          <MomentsList />

          <div>
            <el-tabs v-model="activeName" @tab-click="handleClick">
              <el-tab-pane
                v-for="category in categories"
                :key="category.id"
                :name="String(category.id)"
              >
                <template slot="label">
                  <span class="label-info">
                    <i :class="category.icon"></i>
                    {{ category.name }}
                  </span>
                </template>
                <ArticleList
                  :articles="articleList"
                  :loading="loading"
                  :total="total"
                  :params="params"
                  @article-click="goToPost"
                  @page-change="changePage"
                  class="article-list"
                />
              </el-tab-pane>
            </el-tabs>
          </div>
        </main>
        <Sidebar />
      </div>
    </div>
  </div>
</template>

<script>
import ArticleList from "@/components/ArticleList/index.vue";
import Carousel from "@/views/home/components/carousel.vue";
import Sidebar from "@/components/Sidebar/index.vue";
import MomentsList from "@/views/home/components/moments.vue";
import {
  getArticlesApi,
  getCarouselArticlesApi,
  getAllCategoriesApi,
} from "@/api/article";

export default {
  name: "Home",
  components: {
    ArticleList,
    Carousel,
    Sidebar,
    MomentsList,
  },
  data() {
    return {
      total: 0,
      params: {
        pageNum: 1,
        pageSize: 10,
      },
      articleList: [],
      carouselSlides: [],
      loading: false,
      activeName: "all",
      categories: [
        {
          id: "all",
          name: "全部",
          icon: "el-icon-menu",
        },
      ],
      mainText: "欢迎来到我的博客",
      subtitles: [
        "成功是失败者的通行证, 失败是成功者的墓志铭",
        "日复一日的坚持，终将成就非凡的人生",
        "学习是一种习惯，而非一时的努力",
        "生活不止眼前的苟且，还有代码和远方",
      ],
      currentSubtitleIndex: 0,
      displayedSubtitle: "",
      isDeleting: false,
      typeInterval: null,
      isScrolling: false,
    };
  },
  methods: {
    // 循环打字效果
    typingEffect() {
      const currentSubtitle = this.subtitles[this.currentSubtitleIndex];
      const typingSpeed = 100; // 更快的打字速度
      const deletingSpeed = 30; // 更快的删除速度
      const pauseTime = 1500; // 略短的停顿时间
      
      if (this.typeInterval) clearInterval(this.typeInterval);
      
      this.typeInterval = setInterval(() => {
        if (!this.isDeleting) {
          // 打字中
          this.displayedSubtitle = currentSubtitle.substring(0, this.displayedSubtitle.length + 1);
          
          // 如果完成打字，准备删除
          if (this.displayedSubtitle === currentSubtitle) {
            setTimeout(() => {
              this.isDeleting = true;
            }, pauseTime);
            clearInterval(this.typeInterval);
            this.typingEffect();
          }
        } else {
          // 删除中
          this.displayedSubtitle = currentSubtitle.substring(0, this.displayedSubtitle.length - 1);
          
          // 如果删除完毕，切换到下一句
          if (this.displayedSubtitle === '') {
            this.isDeleting = false;
            this.currentSubtitleIndex = (this.currentSubtitleIndex + 1) % this.subtitles.length;
            clearInterval(this.typeInterval);
            this.typingEffect();
          }
        }
      }, this.isDeleting ? deletingSpeed : typingSpeed);
    },
    
    handleScroll() {
      this.isScrolling = window.scrollY > 50;
    },
    
    scrollToContent() {
      this.$refs.mainContent.scrollIntoView({ behavior: 'smooth' });
    },
    
    handleClick(tab) {
      this.params.categoryId = tab.name === "all" ? null : tab.name;
      this.params.pageNum = 1;
      this.getArticleList();
    },

    goToPost(id) {
      this.$router.push(`/post/${id}`);
    },

    changePage(page) {
      this.params.pageNum = page;
      this.getArticleList();
      window.scrollTo({
        top: this.$refs.postsSection?.offsetTop - 80,
        behavior: "smooth",
      });
    },

    getArticleList() {
      this.loading = true;
      getArticlesApi(this.params)
        .then((res) => {
          this.articleList = res.data.records;
          this.total = res.data.total;
        })
        .catch((error) => {
          console.error("Failed to fetch articles:", error);
        })
        .finally(() => {
          this.loading = false;
        });
    },

    getCarouselArticles() {
      getCarouselArticlesApi().then((res) => {
        this.carouselSlides = res.data;
      });
    },

    getAllCategories() {
      getAllCategoriesApi().then((res) => {
        const icons = [
          "el-icon-document",
          "el-icon-collection",
          "el-icon-reading",
          "el-icon-coffee-cup",
          "el-icon-notebook-2",
          "el-icon-edit",
        ];
        const categoriesWithIcons = res.data.map((category) => ({
          ...category,
          icon: icons[Math.floor(Math.random() * icons.length)],
        }));
        this.categories.push(...categoriesWithIcons);
      });
    },
  },
  mounted() {
    this.typingEffect();
    window.addEventListener("scroll", this.handleScroll);
  },
  beforeDestroy() {
    if (this.typeInterval) clearInterval(this.typeInterval);
    window.removeEventListener("scroll", this.handleScroll);
  },
  created() {
    this.getArticleList();
    this.getCarouselArticles();
    this.getAllCategories();
  },
};
</script>

<style lang="scss" scoped>
.hero-section {
  height: 100vh;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  color: white;
  text-align: center;
  position: relative;
  padding-bottom: 80px; /* 考虑到底部箭头的空间，适当向上调整 */
  // 背景将由全局样式控制
}

.hero-content {
  position: relative;
  z-index: 1;
  transform: translateY(-80px); /* 进一步向上移动 */
  transition: transform 0.8s ease, opacity 0.8s ease;
  
  &.slide-up {
    transform: translateY(-180px);
    opacity: 0;
  }
}

.main-title {
  font-size: 3.5rem;
  margin-bottom: 1.5rem;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}

.subtitle {
  font-size: 1.8rem;
  line-height: 1.5;
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.7);
  min-height: 2.7rem; /* 保持高度固定，防止文本变化导致布局跳动 */
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
}

.cursor {
  display: inline-block;
  width: 12px;
  height: 1.5em;
  background-color: white;
  animation: blink 0.7s infinite;
  vertical-align: text-top;
}

@keyframes blink {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
}

.scroll-down-indicator {
  position: absolute;
  bottom: 6rem; /* 将指示箭头向上移动一点 */
  font-size: 2rem;
  cursor: pointer;
  animation: bounce 2s infinite;
  z-index: 1;
  transition: transform 0.8s ease, opacity 0.8s ease;
  
  &.slide-down {
    transform: translateY(100px);
    opacity: 0;
  }
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-20px);
  }
  60% {
    transform: translateY(-10px);
  }
}

.home {
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  padding: $spacing-lg;

  @include responsive(lg) {
    padding: $spacing-sm;
  }
}

.content-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 320px;
  gap: $spacing-lg * 2;
  padding: 0 $spacing-xl;
  margin-bottom: $spacing-xl * 2;
  min-height: calc(100vh - 80px);
  align-items: start;

  @include responsive(lg) {
    grid-template-columns: 1fr;
    padding: $spacing-sm;
  }
}

.home-main-content {
  min-width: 0;
  width: 100%;
  height: 100%;

  .carousel {
    margin-bottom: $spacing-xl;
    width: 100%;
    max-height: 480px;

    @include responsive(md) {
      margin-bottom: $spacing-xl;
      max-height: 280px;
      :deep(h3) {
        font-size: 1.2em;
      }
    }
  }
}

:deep(.el-tabs__nav-scroll) {
  overflow-x: scroll !important;

  &::-webkit-scrollbar {
    display: none !important;
  }
}
:deep(.el-tabs__nav-wrap::after) {
  display: none;
}
.label-info {
  display: flex;
  align-items: center;
  gap: $spacing-base;
  color: var(--text-primary);
}
</style>
