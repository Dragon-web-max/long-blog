<template>
  <div class="comment-section">
    <!-- 评论输入框 -->
    <div class="comment-editor">
      <div class="editor-content">
        <div class="avatar-container">
          <img :src="userAvatar" :alt="userName" />
        </div>
        <div class="input-container">
          <div 
            class="comment-input" 
            contenteditable="true"
            ref="commentInput"
            :placeholder="`写下你的评论...`"
            @input="handleCommentInput"
          ></div>
          <div class="editor-footer">
            <div class="editor-tools">
              <mj-emoji @select="insertEmoji" />
            </div>
            <button 
              class="submit-btn" 
              :disabled="!commentContent.trim() || !canComment" 
              @click="submitComment"
            >
              {{ canComment ? '发表评论' : `${countdown}秒后可评论` }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 评论列表 -->
    <div class="comments-list">
      <div class="list-header">
        <h3>
          全部评论 <span>({{ commentCount }})</span>
        </h3>
        <div class="sort-options">
          <button class="sort-btn" :class="{ active: sortBy === 'newest' }" @click="sortBy = 'newest'">
            最新
          </button>
          <button class="sort-btn" :class="{ active: sortBy === 'hottest' }" @click="sortBy = 'hottest'">
            最热
          </button>
        </div>
      </div>

      <template v-if="sortedComments.length">
        <div v-for="comment in sortedComments" :key="comment.id" :id="`comment-${comment.id}`" class="comment-item">
          <div class="comment-avatar">
            <img :src="comment.avatar" :alt="comment.nickname" />
          </div>
          <div class="comment-content">
            <div class="comment-header">
              <div class="comment-info">
                <span class="nickname">{{ comment.nickname }}</span>
                <span class="author-tag" v-if="comment.userId === articleAuthorId">作者</span>
                <span class="ipSource">
                  IP属地:{{ formatIpSource(comment.ipSource) }}
                </span>
                <span class="time">{{ formatTime(comment.createTime) }}</span>
              </div>
              <div class="comment-actions">
                <!-- <button class="action-btn" @click="likeComment(comment)">
                  <i class="far" :class="comment.isLiked ? 'fas fa-heart' : 'far fa-heart'"></i>
                  <span>{{ comment.likeCount || 0 }}</span>
                </button> -->
                <button class="action-btn" @click="replyTo(comment)">
                  <i class="far fa-comment"></i>
                  <span>回复</span>
                </button>
              </div>
            </div>
            <div class="comment-text markdown-body" v-html="comment.content"></div>

            <!-- 回复列表 -->
            <div v-if="comment.children?.length" class="replies-list">
              <div v-for="reply in comment.children" :key="reply.id" class="reply-item">
                <div class="reply-avatar">
                  <img :src="reply.avatar" :alt="reply.nickname" />
                </div>
                <div class="reply-content">
                  <div class="reply-header">
                    <div class="reply-info">
                      <span class="nickname">{{ reply.nickname }}</span>
                      <span class="author-tag" v-if="reply.userId === articleAuthorId">作者</span>
                      <span class="reply-to">
                        回复
                        <span class="target">@{{ reply.replyNickname }}</span>
                      </span>
                      <span class="ipSource">
                        IP属地:{{ formatIpSource(reply.ipSource) }}
                      </span>
                      <span class="time">{{
                        formatTime(reply.createTime)
                      }}</span>
                    </div>
                    <div class="comment-actions">
                      <button class="action-btn" @click="handleReplyChild(reply)">
                        <i class="far fa-comment"></i>
                        <span>回复</span>
                      </button>
                    </div>
                  </div>
                  <div class="reply-text markdown-body" v-html="reply.content"></div>

                  <!-- 添加子评论的回复框 -->
                  <div  v-if="showReplyBox && activeReplyId === reply.id" class="reply-box">
                    <div 
                      class="reply-input" 
                      contenteditable="true"
                      ref="childReplyInput"
                      @input="handleChildReplyInput"
                      :placeholder="`回复 @${reply.nickname}`"
                    ></div>
                    <div class="editor-footer">
                      <div class="editor-tools">
                        <mj-emoji @select="insertChildReplyEmoji" />
                      </div>
                      <div class="reply-actions">
                        <button class="cancel-btn" @click="cancelReply">
                          取消
                        </button>
                        <button class="submit-btn" :disabled="!replyContent.trim()" @click="submitChildReply(reply)">
                          回复
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 回复框 -->
            <div v-if="replyingTo === comment.id" class="reply-editor">
              <div 
                class="reply-input" 
                contenteditable="true"
                ref="replyInput"
                @input="handleReplyInput"
                :placeholder="`回复 @${comment.nickname}`"
              ></div>
              <div class="editor-footer">
                <div class="editor-tools">
                  <mj-emoji @select="insertReplyEmoji" />
                </div>
                <div class="reply-actions">
                  <button class="cancel-btn" @click="cancelReply">取消</button>
                  <button class="submit-btn" :disabled="!replyContent.trim() || !canComment"
                    @click="submitReply(comment)">
                    {{ canComment ? '回复' : `${countdown}秒后可评论` }}
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="pagination-box">
          <el-pagination background v-if="total" @current-change="handlePageChange" :current-page="params.pageNum"
          :page-size="params.pageSize" layout="prev, pager, next" :total="total">
        </el-pagination>
        </div>

      </template>
      <div v-else class="empty-state">
        <i class="far fa-comments"></i>
        <p>暂无评论，快来抢吧~</p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { getCommentsApi, addCommentApi } from "@/api/article";
import { formatTime } from "@/utils/time.js";
import { getBrowserInfo } from "@/utils/browser.js";

export default {
  name: "Comment",
  props: {
    articleId: {
      type: [String, Number],
      required: true,
    },
    commentCount: {
      type: [String, Number],
      default: 0,
    },
    articleAuthorId: {
      type: [String, Number],
      default: "",
    },
  },
  data() {
    return {
      commentContent: "",
      replyContent: "",
      replyingTo: null,
      params: {
        pageNum: 1,
        pageSize: 10,
        articleId: this.articleId,
      },
      comments: [],
      showEmojiPanel: false,
      sortBy: "newest",
      showReplyBox: false,
      activeReplyId: null,
      browserInfo: null,
      total: 0,
      countdown: 0,
      canComment: true,
    };
  },
  computed: {
    ...mapState(["userInfo"]),
    userAvatar() {
      return (
        this.userInfo?.avatar || this.$store.state.webSiteInfo.touristAvatar
      );
    },
    userName() {
      return this.userInfo?.nickname || "游客";
    },
    sortedComments() {
      return [...this.comments].sort((a, b) => {
        if (this.sortBy === "newest") {
          return new Date(b.createTime) - new Date(a.createTime);
        }
        return b.likeCount - a.likeCount;
      });
    },
  },
  methods: {
    /**
     * 分页
     */
    handlePageChange(page) {
      this.params.pageNum = page;
      this.getComments();
    },
    /**
     * 获取评论
     */
    async getComments() {
      try {
        const res = await getCommentsApi(this.params);
        this.comments = res.data.records;
        this.total = res.data.total;
      } catch (error) {
        this.$message.error("获取评论失败");
      }
    },

    /**
     * 处理主评论输入
     */
    handleCommentInput(e) {
      this.commentContent = e.target.innerHTML;
    },

    /**
     * 处理回复输入
     */
    handleReplyInput(e) {
      this.replyContent = e.target.innerHTML;
    },

    /**
     * 处理子回复输入
     */
    handleChildReplyInput(e) {
      this.replyContent = e.target.innerHTML;
    },

    /**
     * 发表评论
     */
    async submitComment() {
      if (!this.commentContent.trim() || !this.canComment) return;
      if (this.commentContent.trim() === '') {
        this.$message.warning('评论内容不能为空');
        return;
      }
      if (!this.userInfo) {
        this.$message.error('请先登录');
        return;
      }

      try {
        const newComment = {
          content: this.commentContent,
          articleId: this.articleId,
          browser: this.browserInfo?.name + " " + this.browserInfo?.version,
        };

        await addCommentApi(newComment);
        this.getComments();
        this.$message.success("评论成功");
        this.$emit('comment-added');

        // 清空输入框内容
        this.commentContent = "";
        this.$refs.commentInput.innerHTML = "";
        this.start()
        
        this.$nextTick(() => {
          const firstComment = document.querySelector(".comment-item");
          if (firstComment) {
            firstComment.scrollIntoView({ behavior: "smooth", block: "center" });
          }
        });
      } catch (error) {
        console.log(error);
        this.$message.error(error.message);
      }
    },

    /**
     * 回复评论
     * @param comment
     */
    async submitReply(comment) {
      if (!this.replyContent.trim() || !this.canComment) return;
      if (this.replyContent.trim() === '') {
        this.$message.warning('回复内容不能为空');
        return;
      }
      if (!this.userInfo) {
        this.$message.error('请先登录');
        return;
      }
      try {
        // 创建新回复对象
        const newReply = {
          content: this.replyContent,
          replyUserId: comment.userId,
          parentId: comment.id,
          articleId: this.articleId,
        };

        await addCommentApi(newReply);
        this.getComments();
        this.$message.success("回复成功");
        this.$emit('comment-added');

        // 清空输入框内容
        this.replyContent = "";
        this.$refs.replyInput[0].innerHTML = "";
        this.replyingTo = null;
        this.start()

        // 滚动到新回复位置
        this.$nextTick(() => {
          const lastReply = document.querySelector(
            `#comment-${comment.id} .reply-item:last-child`
          );
          if (lastReply) {
            lastReply.scrollIntoView({ behavior: "smooth", block: "center" });
          }
        });
      } catch (error) {
        console.log(error);
        this.$message.error(error.message);
      }
    },

    start() {
      this.canComment = false;
      this.countdown = 5;

      const timer = setInterval(() => {
        this.countdown--;
        if (this.countdown <= 0) {
          clearInterval(timer);
          this.canComment = true;
        }
      }, 1000);
    },
    /**
     * 回复评论
     */
    replyTo(comment) {
      this.showReplyBox = false;
      this.activeReplyId = null;
      this.replyingTo = comment.id;
      this.replyContent = "";
    },
    /**
     * 取消回复
     */
    cancelReply() {
      this.replyingTo = null;
      this.showReplyBox = false;
      this.activeReplyId = null;
      this.replyContent = "";
      // 清空对应输入框的内容
      if (this.$refs.replyInput && this.$refs.replyInput[0]) {
        this.$refs.replyInput[0].innerHTML = "";
      }
      if (this.$refs.childReplyInput && this.$refs.childReplyInput[0]) {
        this.$refs.childReplyInput[0].innerHTML = "";
      }
    },
    /**
     * 点赞评论
     */
    async likeComment(comment) {
      try {
        // 点赞评论的 API 调用
        // await likeComment(comment.id)
        comment.isLiked = !comment.isLiked;
        comment.likeCount += comment.isLiked ? 1 : -1;
      } catch (error) {
        this.$message.error("操作失败");
      }
    },
    /**
     * 切换表情面板
     */
    toggleEmojiPanel() {
      this.showEmojiPanel = !this.showEmojiPanel;
    },
    /**
     * 关闭表情面板
     */
    closeEmojiPanel() {
      this.showEmojiPanel = false;
    },
    /**
     * 插入表情到主评论框
     */
    insertEmoji(emojiUrl) {
      const img = `<img src="${emojiUrl}" class="emoji" style="width: 30px; height: 30px; vertical-align: middle;">`;
      const editor = this.$refs.commentInput;
      editor.focus();
      document.execCommand('insertHTML', false, img);
      this.commentContent = editor.innerHTML;
    },

    /**
     * 插入表情到回复框
     */
    insertReplyEmoji(emojiUrl) {
      const img = `<img src="${emojiUrl}" class="emoji" style="width: 22px; height: 22px; vertical-align: middle;">`;
      const editor = this.$refs.replyInput[0];
      editor.focus();
      document.execCommand('insertHTML', false, img);
      this.replyContent = editor.innerHTML;
    },
    /**
     * 插入表情到子回复框
     */
    insertChildReplyEmoji(emojiUrl) {
      const img = `<img src="${emojiUrl}" class="emoji" style="width: 22px; height: 22px; vertical-align: middle;">`;
      const editor = this.$refs.childReplyInput[0];
      if (!editor) return;
      
      editor.focus();
      document.execCommand('insertHTML', false, img);
      this.replyContent = editor.innerHTML;
    },
    /**
     * 格式化时间
     */
    formatTime(time) {
      return formatTime(time);
    },
    /**
     * 格式化IP来源
     */
    formatIpSource(ipSource) {
      return ipSource ? ipSource.split("|")[1] : "";
    },
    /**
     * 回复子评论
     */
    handleReplyChild(reply) {
      if (!this.userInfo) {
        this.$message.error("请先登录");
        return;
      }
      this.replyingTo = null;
      this.showReplyBox = true;
      this.activeReplyId = reply.id;
      this.replyContent = "";
    },
    /**
     * 提交子评论
     */
    async submitChildReply(reply) {
      if (!this.replyContent.trim()) {
        this.$message.warning('请输入回复内容');
        return;
      }
      if (this.replyContent.trim() === '') {
        this.$message.warning('回复内容不能为空');
        return;
      }

      try {
        const params = {
          articleId: this.articleId,
          content: this.replyContent,
          parentId: reply.parentId || reply.id,
          replyUserId: reply.userId,
        };
        await addCommentApi(params);
        this.$message.success("回复成功");
        this.$emit('comment-added');

        // 清空输入框内容
        this.replyContent = "";
        this.$refs.childReplyInput[0].innerHTML = "";
        this.cancelReply();
        this.getComments();
      } catch (error) {
        console.error("回复失败:", error);
        this.$message.error("回复失败，请重试");
      }
    },
  },
  created() {
    this.getComments();
    this.browserInfo = getBrowserInfo();
  },
};
</script>

<style lang="scss" scoped>
.comment-section {
  margin-top: $spacing-xl;
}

.comment-editor {
  background: var(--card-bg);
  border: 1px solid var(--border-color);

  .editor-content {
    display: flex;
    gap: $spacing-lg;
    padding: $spacing-lg;

    .avatar-container {
      flex-shrink: 0;
      @include responsive(sm) {
        display: none;
      }
      img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
    }

    .input-container {
      flex: 1;
      min-width: 0;

      .comment-input {
        width: 100%;
        min-height: 120px;
        border: 1px solid var(--border-color);
        background: var(--card-bg);
        color: var(--text-primary);
        padding: $spacing-md;
        border-radius: $border-radius-md;
        font-size: 1em;
        line-height: 1.6;
        transition: all 0.3s ease;
        overflow-y: auto;

        &:focus {
          outline: none;
          border-color: $primary;
          box-shadow: 0 0 0 3px rgba($primary, 0.1);
        }

        &:empty:before {
          content: attr(placeholder);
          color: var(--text-secondary);
        }
      }

      .editor-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: $spacing-lg;

        .editor-tools {
          display: flex;
          gap: $spacing-xs;

          .tool-btn {
            padding: $spacing-xs $spacing-sm;
            border: none;
            background: none;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: $border-radius-sm;

            &:hover {
              color: $primary;
              background: var(--hover-bg);
            }
          }
        }

        .submit-btn {
          padding: $spacing-sm $spacing-xl;
          background: $primary;
          color: white;
          border: none;
          border-radius: 20px;
          cursor: pointer;
          transition: all 0.3s ease;

          &:disabled {
            opacity: 0.6;
            cursor: not-allowed;
          }

          &:not(:disabled):hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba($primary, 0.2);
          }
        }
      }
    }
  }
}

.comments-list {
  margin-top: $spacing-xl;

  .list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: $spacing-lg;
    padding: 0 $spacing-md;

    h3 {
      color: var(--text-primary);
      font-size: 1.2em;
      font-weight: 500;

      span {
        color: var(--text-secondary);
        font-size: 0.9em;
      }
    }

    .sort-options {
      display: flex;
      gap: $spacing-sm;

      .sort-btn {
        padding: $spacing-xs $spacing-md;
        border: none;
        background: none;
        color: var(--text-secondary);
        cursor: pointer;
        transition: all 0.3s ease;
        border-radius: $border-radius-sm;

        &.active {
          color: $primary;
          background: var(--hover-bg);
        }

        &:hover:not(.active) {
          color: $primary;
        }
      }
    }
  }

  .comment-item {
    display: flex;
    gap: $spacing-lg;
    padding: $spacing-md;
    border-bottom: 1px dashed var(--border-color);

    &:last-child {
      border-bottom: none;
    }

    // 添加作者标签样式
    .author-tag {
      display: inline-block;
      padding: 2px 6px;
      font-size: 12px;
      line-height: 1.2;
      color: $primary;
      background: rgba($primary, 0.1);
      border: 1px solid rgba($primary, 0.2);
      border-radius: 4px;
      margin: 0 $spacing-xs;
    }

    .comment-avatar {
      flex-shrink: 0;

      img {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        object-fit: cover;
      }
    }

    .comment-content {
      flex: 1;
      min-width: 0;

      .comment-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: $spacing-sm;

        .comment-info {
          display: flex;
          align-items: center;
          gap: $spacing-sm;

          .nickname {
            color: var(--text-primary);
            font-weight: 500;
          }

          .time {
            color: var(--text-secondary);
            font-size: 0.9em;
          }

          .ipSource {
            color: var(--text-secondary);
            font-size: 0.9em;
          }
        }

        .comment-actions {
          display: flex;
          gap: $spacing-md;

          .action-btn {
            display: flex;
            align-items: center;
            gap: $spacing-xs;
            padding: $spacing-xs $spacing-sm;
            border: none;
            background: none;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9em;

            i {
              transition: all 0.3s ease;
            }

            &:hover {
              color: $primary;
            }

            .fa-heart {
              color: #ff4757;
            }
          }
        }
      }

      .comment-text {
        color: var(--text-primary);
        line-height: 1.6;
        margin-bottom: $spacing-md;
      }
    }
  }

  .replies-list {
    margin-left: $spacing-xl;
    margin-top: $spacing-md;
    padding-left: $spacing-lg;
    border-left: 2px solid var(--border-color);

    .reply-item {
      display: flex;
      gap: $spacing-md;
      padding: $spacing-md 0;

      .reply-avatar {
        flex-shrink: 0;

        img {
          width: 32px;
          height: 32px;
          border-radius: 50%;
          object-fit: cover;
        }
      }

      .reply-content {
        flex: 1;
        min-width: 0;

        .reply-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: $spacing-xs;

          .reply-info {
            display: flex;
            align-items: center;
            gap: $spacing-sm;
            font-size: 0.95em;

            .nickname {
              color: var(--text-primary);
              font-weight: 500;
            }

            .reply-to {
              color: var(--text-secondary);

              .target {
                color: $primary;
              }
            }

            .time {
              color: var(--text-secondary);
              font-size: 0.9em;
            }

            .ipSource {
              color: var(--text-secondary);
              font-size: 0.9em;
            }
          }

          .comment-actions {
            .action-btn {
              display: flex;
              align-items: center;
              gap: 4px;
              padding: 4px 8px;
              border: none;
              background: none;
              color: var(--text-secondary);
              cursor: pointer;
              transition: all 0.3s ease;
              font-size: 0.9em;

              &:hover {
                color: $primary;
              }

              i {
                font-size: 14px;
              }
            }
          }
        }

        .reply-text {
          color: var(--text-primary);
          font-size: 0.95em;
          line-height: 1.6;
        }
      }
    }
  }

  .reply-editor {
    margin-top: $spacing-md;
    background: var(--hover-bg);
    border-radius: $border-radius-lg;
    padding: $spacing-md;

    .reply-input {
      width: 100%;
      min-height: 100px;
      border: 1px solid var(--border-color);
      background: var(--card-bg);
      color: var(--text-primary);
      padding: $spacing-md;
      border-radius: $border-radius-md;
      font-size: 0.95em;
      line-height: 1.6;
      transition: all 0.3s ease;
      overflow-y: auto;

      &:focus {
        outline: none;
        border-color: $primary;
        box-shadow: 0 0 0 3px rgba($primary, 0.1);
      }

      &:empty:before {
        content: attr(placeholder);
        color: var(--text-secondary);
      }
    }

    .editor-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: $spacing-md;

      .editor-tools {
        display: flex;
        gap: $spacing-xs;

        .tool-btn {
          padding: $spacing-xs $spacing-sm;
          border: none;
          background: none;
          color: var(--text-secondary);
          cursor: pointer;
          transition: all 0.3s ease;
          border-radius: $border-radius-sm;

          &:hover {
            color: $primary;
            background: var(--hover-bg);
          }
        }
      }

      .reply-actions {
        display: flex;
        gap: $spacing-sm;

        button {
          padding: $spacing-xs $spacing-lg;
          border: none;
          border-radius: 16px;
          cursor: pointer;
          transition: all 0.3s ease;
          font-size: 0.9em;

          &.cancel-btn {
            background: none;
            color: var(--text-secondary);
            border: 1px solid var(--border-color);

            &:hover {
              color: $primary;
              border-color: $primary;
            }
          }

          &.submit-btn {
            background: $primary;
            color: white;

            &:disabled {
              opacity: 0.6;
              cursor: not-allowed;
            }

            &:not(:disabled):hover {
              transform: translateY(-1px);
              box-shadow: 0 2px 8px rgba($primary, 0.2);
            }
          }
        }
      }
    }
  }

  .empty-state {
    text-align: center;
    padding: $spacing-xl * 2;
    color: var(--text-secondary);

    i {
      font-size: 3em;
      margin-bottom: $spacing-md;
      color: $primary;
      opacity: 0.8;
    }

    p {
      font-size: 1.1em;
    }
  }
}

@include responsive(sm) {
  .comment-editor {
    .editor-header {
      .user-info .tip {
        display: none;
      }
    }
  }

  .comments-list {
    .comment-item {
      padding: $spacing-md;
      gap: $spacing-md;

      .comment-avatar img {
        width: 40px;
        height: 40px;
      }
    }

    .replies-list {
      margin-left: $spacing-lg;
      padding-left: $spacing-md;
    }
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.reply-btn {
  color: #409eff;
  cursor: pointer;
  margin-left: 10px;
  font-size: 12px;
}

.reply-btn:hover {
  color: #66b1ff;
}

.reply-box {
  margin: 10px 0;
  background: var(--hover-bg);
  border-radius: $border-radius-lg;
  padding: $spacing-md;

  .reply-input {
    width: 100%;
    min-height: 80px;
    border: 1px solid var(--border-color);
    background: var(--card-bg);
    color: var(--text-primary);
    padding: $spacing-md;
    border-radius: $border-radius-md;
    font-size: 0.95em;
    line-height: 1.6;
    transition: all 0.3s ease;
    overflow-y: auto;

    &:focus {
      outline: none;
      border-color: $primary;
      box-shadow: 0 0 0 3px rgba($primary, 0.1);
    }

    &:empty:before {
      content: attr(placeholder);
      color: var(--text-secondary);
    }
  }

  .editor-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: $spacing-md;

    .editor-tools {
      display: flex;
      gap: $spacing-xs;

      .tool-btn {
        padding: $spacing-xs $spacing-sm;
        border: none;
        background: none;
        color: var(--text-secondary);
        cursor: pointer;
        transition: all 0.3s ease;
        border-radius: $border-radius-sm;

        &:hover {
          color: $primary;
          background: var(--hover-bg);
        }
      }
    }

    .reply-actions {
      display: flex;
      gap: $spacing-sm;

      button {
        padding: $spacing-xs $spacing-lg;
        border: none;
        border-radius: 16px;
        cursor: pointer;
        transition: all 0.3s ease;
        font-size: 0.9em;

        &.cancel-btn {
          background: none;
          color: var(--text-secondary);
          border: 1px solid var(--border-color);

          &:hover {
            color: $primary;
            border-color: $primary;
          }
        }

        &.submit-btn {
          background: $primary;
          color: white;

          &:disabled {
            opacity: 0.6;
            cursor: not-allowed;
          }

          &:not(:disabled):hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba($primary, 0.2);
          }
        }
      }
    }
  }
}

.emoji-container {
  position: absolute;
  bottom: 100%;
  left: 0;
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  margin-bottom: 8px;
}

.emoji-wrapper {
  width: 360px;
  height: 300px;
  /* 固定高度 */
  overflow-y: auto;
  /* 内容超出时显示滚动条 */
  padding: 8px;
}

.emoji-category {
  margin-bottom: 12px;
}

.emoji-category-title {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
  padding-left: 4px;
}

.emoji-list {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.emoji-item {
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: background-color 0.2s;
  font-size: 20px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.emoji-item:hover {
  background-color: #f0f0f0;
}

/* 自定义滚动条样式 */
.emoji-wrapper::-webkit-scrollbar {
  width: 6px;
}

.emoji-wrapper::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 3px;
}

.emoji-wrapper::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.comment-text,
.reply-text {
  color: var(--text-primary);
  line-height: 1.6;

  :deep(img) {
    // 使用 :deep 来处理 v-html 渲染的内容
    max-width: 200px;
    max-height: 150px;
    object-fit: cover;
    border-radius: $border-radius-sm;
    vertical-align: middle;
  }
}
</style>
