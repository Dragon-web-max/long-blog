/*
 Navicat Premium Dump SQL

 Source Server         : kt
 Source Server Type    : MySQL
 Source Server Version : 80021 (8.0.21)
 Source Host           : localhost:3306
 Source Schema         : blog

 Target Server Type    : MySQL
 Target Server Version : 80021 (8.0.21)
 File Encoding         : 65001

 Date: 27/06/2025 09:49:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chat_msg
-- ----------------------------
DROP TABLE IF EXISTS `chat_msg`;
CREATE TABLE `chat_msg`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `chat_id` bigint NULL DEFAULT NULL,
  `sender_id` bigint NOT NULL COMMENT '发送人id',
  `type` enum('text','image') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'text' COMMENT '消息类型',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '内容',
  `is_recalled` tinyint(1) NULL DEFAULT 0 COMMENT '是否撤回',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `ip` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ip地址',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ip归属地',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息是文件时，存的文件名',
  `file_size` double NULL DEFAULT NULL COMMENT '文件大小',
  `duration` int NULL DEFAULT NULL COMMENT '语音时长',
  `reply_id` bigint NULL DEFAULT NULL COMMENT '回复消息id',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '回复消息内容',
  `reply_user_id` bigint NULL DEFAULT NULL COMMENT '回复用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '聊天消息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_msg
-- ----------------------------
INSERT INTO `chat_msg` VALUES (2, NULL, 1, 'text', '大家好~!!', 0, '2025-06-26 13:47:20', '192.168.0.196', '内网IP|内网IP', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `chat_msg` VALUES (3, NULL, 1, 'text', '<img src=\"https://baidubox-emoji.cdn.bcebos.com/imgs/[捂脸].png\" class=\"emoji\" style=\"width: 30px; height: 30px; vertical-align: middle;\">', 0, '2025-06-26 13:47:32', '192.168.0.196', '内网IP|内网IP', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `chat_msg` VALUES (4, NULL, 1811, 'text', '@龙哈哈你好你好', 0, '2025-06-26 14:03:31', '192.168.0.196', '内网IP|内网IP', NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for file_detail
-- ----------------------------
DROP TABLE IF EXISTS `file_detail`;
CREATE TABLE `file_detail`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件id',
  `url` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件访问地址',
  `size` bigint NULL DEFAULT NULL COMMENT '文件大小，单位字节',
  `filename` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `original_filename` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '原始文件名',
  `base_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '基础存储路径',
  `path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '存储路径',
  `ext` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件扩展名',
  `content_type` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'MIME类型',
  `platform` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '存储平台',
  `th_url` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图访问路径',
  `th_filename` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图名称',
  `th_size` bigint NULL DEFAULT NULL COMMENT '缩略图大小，单位字节',
  `th_content_type` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图MIME类型',
  `object_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件所属对象id',
  `object_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件所属对象类型，例如用户头像，评价图片',
  `metadata` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文件元数据',
  `user_metadata` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文件用户元数据',
  `th_metadata` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '缩略图元数据',
  `th_user_metadata` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '缩略图用户元数据',
  `attr` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '附加属性',
  `file_acl` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件ACL',
  `th_file_acl` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缩略图文件ACL',
  `hash_info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '哈希信息',
  `upload_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上传ID，仅在手动分片上传时使用',
  `upload_status` int NULL DEFAULT NULL COMMENT '上传状态，仅在手动分片上传时使用，1：初始化完成，2：上传完成',
  `source` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片来源',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_detail
-- ----------------------------
INSERT INTO `file_detail` VALUES ('22e5df98c7099dd28c21f6fc0ece8dbd', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/91_0f41e491be93636907ef08617f929932_1551843504083.jpg', 262616, '91_0f41e491be93636907ef08617f929932_1551843504083.jpg', '0f41e491be93636907ef08617f929932_1551843504083.jpg', 'local-plus/', '20250626/album-cover/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"album-cover\"}', NULL, NULL, '{}', NULL, NULL, 'album-cover', '2025-06-26 12:29:59');
INSERT INTO `file_detail` VALUES ('7e14e1766df64507bd68db8955c1db49', 'http://127.0.0.1:8800/localFile/local-plus/20250626/photo/11_2a47c217-07d7-4a3a-8f69-c43d34ca9c2c.jpg', 99100, '11_2a47c217-07d7-4a3a-8f69-c43d34ca9c2c.jpg', '2a47c217-07d7-4a3a-8f69-c43d34ca9c2c.jpg', 'local-plus/', '20250626/photo/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"photo\"}', NULL, NULL, '{}', NULL, NULL, 'photo', '2025-06-26 11:20:42');
INSERT INTO `file_detail` VALUES ('a5fb074cbd0c9f7ceca221c213ea52d0', 'http://127.0.0.1:8800/localFile/local-plus/20250626/avatar/04_avatar.jpg', 33336, '04_avatar.jpg', 'avatar.jpg', 'local-plus/', '20250626/avatar/', 'jpg', 'image/jpg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"avatar\"}', NULL, NULL, '{}', NULL, NULL, 'avatar', '2025-06-26 13:46:49');
INSERT INTO `file_detail` VALUES ('adfb9d13f79b0bbf3d78dd5c238eebf4', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/30_头像1.jpg', 53774, '30_头像1.jpg', '头像1.jpg', 'local-plus/', '20250626/album-cover/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"album-cover\"}', NULL, NULL, '{}', NULL, NULL, 'album-cover', '2025-06-26 19:33:40');
INSERT INTO `file_detail` VALUES ('afab646e3061b22a18419b5329154286', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/48_bdg.jpg', 2569437, '48_bdg.jpg', 'bdg.jpg', 'local-plus/', '20250626/album-cover/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"album-cover\"}', NULL, NULL, '{}', NULL, NULL, 'album-cover', '2025-06-26 12:26:40');
INSERT INTO `file_detail` VALUES ('b2889c7eba7e91aeb4a6be69a1f6ee6e', 'http://127.0.0.1:8800/localFile/local-plus/20250626/avatar/48_avatar.jpg', 124083, '48_avatar.jpg', 'avatar.jpg', 'local-plus/', '20250626/avatar/', 'jpg', 'image/jpg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"avatar\"}', NULL, NULL, '{}', NULL, NULL, 'avatar', '2025-06-26 13:46:05');
INSERT INTO `file_detail` VALUES ('b364a17cd4617e175f9f98b450798985', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/98_bdg.jpg', 2569437, '98_bdg.jpg', 'bdg.jpg', 'local-plus/', '20250626/album-cover/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"album-cover\"}', NULL, NULL, '{}', NULL, NULL, 'album-cover', '2025-06-26 11:13:52');
INSERT INTO `file_detail` VALUES ('b5c76665ddac7dbd4933442eeaa05d29', 'http://127.0.0.1:8800/localFile/local-plus/20250626/default/72_头像1.jpg', 53774, '72_头像1.jpg', '头像1.jpg', 'local-plus/', '20250626/default/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"default\"}', NULL, NULL, '{}', NULL, NULL, 'default', '2025-06-26 11:57:20');
INSERT INTO `file_detail` VALUES ('c78897d7db5169bb6eb75cf872592480', 'http://127.0.0.1:8800/localFile/local-plus/20250626/default/02_bdg.jpg', 2569437, '02_bdg.jpg', 'bdg.jpg', 'local-plus/', '20250626/default/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"default\"}', NULL, NULL, '{}', NULL, NULL, 'default', '2025-06-26 11:59:22');
INSERT INTO `file_detail` VALUES ('d50e3dc41308d636b7fa93f1fdcab54b', 'http://127.0.0.1:8800/localFile/local-plus/20250626/article-cover/83_bdg.jpg', 2569437, '83_bdg.jpg', 'bdg.jpg', 'local-plus/', '20250626/article-cover/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"article-cover\"}', NULL, NULL, '{}', NULL, NULL, 'article-cover', '2025-06-26 14:33:41');
INSERT INTO `file_detail` VALUES ('d53abeddf636c1a173cc2b20e5920ef6', 'http://127.0.0.1:8800/localFile/local-plus/20250626/photo/79_728568d4-0a1f-4a61-a13e-73ab4b9f577d.jpg', 697547, '79_728568d4-0a1f-4a61-a13e-73ab4b9f577d.jpg', '728568d4-0a1f-4a61-a13e-73ab4b9f577d.jpg', 'local-plus/', '20250626/photo/', 'jpg', 'image/jpeg', 'local', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', '{\"source\":\"photo\"}', NULL, NULL, '{}', NULL, NULL, 'photo', '2025-06-26 11:20:56');

-- ----------------------------
-- Table structure for file_part_detail
-- ----------------------------
DROP TABLE IF EXISTS `file_part_detail`;
CREATE TABLE `file_part_detail`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分片id',
  `platform` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '存储平台',
  `upload_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上传ID，仅在手动分片上传时使用',
  `e_tag` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分片 ETag',
  `part_number` int NULL DEFAULT NULL COMMENT '分片号。每一个上传的分片都有一个分片号，一般情况下取值范围是1~10000',
  `part_size` bigint NULL DEFAULT NULL COMMENT '文件大小，单位字节',
  `hash_info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '哈希信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件分片信息表，仅在手动分片上传时使用' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of file_part_detail
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (16, 'sys_tag', '标签表', '2024-12-22 10:38:49', NULL);
INSERT INTO `gen_table` VALUES (17, 'sys_web_config', '网站配置表', '2024-12-22 11:55:59', NULL);
INSERT INTO `gen_table` VALUES (18, 'sys_article', '文章标签关联表', '2024-12-22 12:20:29', '2024-12-25 14:32:51');
INSERT INTO `gen_table` VALUES (19, 'sys_category', '分类表', '2024-12-22 13:22:38', NULL);
INSERT INTO `gen_table` VALUES (20, 'sys_friend', '友情链接', '2024-12-22 13:57:02', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NOT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 263 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (178, 16, 'id', '主键', 'int', 'Integer', 'id', '1', '1', '1', '1', '1', '1', 'EQ', 'input', 1);
INSERT INTO `gen_table_column` VALUES (179, 16, 'name', '名称', 'varchar', 'String', 'name', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 2);
INSERT INTO `gen_table_column` VALUES (180, 16, 'sort', '排序', 'int', 'Integer', 'sort', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 3);
INSERT INTO `gen_table_column` VALUES (181, 16, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 4);
INSERT INTO `gen_table_column` VALUES (182, 16, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 5);
INSERT INTO `gen_table_column` VALUES (183, 17, 'id', '主键', 'bigint', 'Long', 'id', '1', '1', '1', '1', '1', '1', 'EQ', 'input', 1);
INSERT INTO `gen_table_column` VALUES (184, 17, 'logo', 'logo(文件UID)', 'varchar', 'String', 'logo', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 2);
INSERT INTO `gen_table_column` VALUES (185, 17, 'name', '网站名称', 'varchar', 'String', 'name', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 3);
INSERT INTO `gen_table_column` VALUES (186, 17, 'summary', '介绍', 'varchar', 'String', 'summary', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 4);
INSERT INTO `gen_table_column` VALUES (187, 17, 'record_num', '备案号', 'varchar', 'String', 'recordNum', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 5);
INSERT INTO `gen_table_column` VALUES (188, 17, 'web_url', '网站地址', 'varchar', 'String', 'webUrl', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 6);
INSERT INTO `gen_table_column` VALUES (189, 17, 'author', '作者', 'varchar', 'String', 'author', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 7);
INSERT INTO `gen_table_column` VALUES (190, 17, 'author_info', '个性签名', 'varchar', 'String', 'authorInfo', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 8);
INSERT INTO `gen_table_column` VALUES (191, 17, 'author_avatar', '作者头像', 'varchar', 'String', 'authorAvatar', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 9);
INSERT INTO `gen_table_column` VALUES (192, 17, 'ali_pay', '支付宝收款码', 'varchar', 'String', 'aliPay', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 10);
INSERT INTO `gen_table_column` VALUES (193, 17, 'weixin_pay', '微信收款码', 'varchar', 'String', 'weixinPay', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 11);
INSERT INTO `gen_table_column` VALUES (194, 17, 'github', 'github地址', 'varchar', 'String', 'github', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 12);
INSERT INTO `gen_table_column` VALUES (195, 17, 'gitee', 'gitee地址', 'varchar', 'String', 'gitee', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 13);
INSERT INTO `gen_table_column` VALUES (196, 17, 'qq_number', 'QQ号', 'varchar', 'String', 'qqNumber', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 14);
INSERT INTO `gen_table_column` VALUES (197, 17, 'qq_group', 'QQ群', 'varchar', 'String', 'qqGroup', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 15);
INSERT INTO `gen_table_column` VALUES (198, 17, 'email', '邮箱', 'varchar', 'String', 'email', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 16);
INSERT INTO `gen_table_column` VALUES (199, 17, 'wechat', '微信', 'varchar', 'String', 'wechat', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 17);
INSERT INTO `gen_table_column` VALUES (200, 17, 'show_list', '显示的列表（用于控制邮箱、QQ、QQ群、Github、Gitee、微信是否显示在前端）', 'varchar', 'String', 'showList', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 18);
INSERT INTO `gen_table_column` VALUES (201, 17, 'login_type_list', '登录方式列表（用于控制前端登录方式，如账号密码,码云,Github,QQ,微信）', 'varchar', 'String', 'loginTypeList', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 19);
INSERT INTO `gen_table_column` VALUES (202, 17, 'open_comment', '是否开启评论(0:否 1:是)', 'tinyint', 'Integer', 'openComment', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 20);
INSERT INTO `gen_table_column` VALUES (203, 17, 'open_admiration', '是否开启赞赏(0:否， 1:是)', 'tinyint', 'Integer', 'openAdmiration', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 21);
INSERT INTO `gen_table_column` VALUES (204, 17, 'tourist_avatar', '游客头像', 'varchar', 'String', 'touristAvatar', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 22);
INSERT INTO `gen_table_column` VALUES (205, 17, 'bulletin', '公告', 'varchar', 'String', 'bulletin', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 23);
INSERT INTO `gen_table_column` VALUES (206, 17, 'about_me', '关于我', 'mediumtext', 'String', 'aboutMe', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 24);
INSERT INTO `gen_table_column` VALUES (207, 17, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 25);
INSERT INTO `gen_table_column` VALUES (208, 17, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 26);
INSERT INTO `gen_table_column` VALUES (209, 18, 'id', '主键id', 'bigint', 'Long', 'id', NULL, '1', '1', '1', '1', '1', 'EQ', 'input', 1);
INSERT INTO `gen_table_column` VALUES (210, 18, 'user_id', '用户id', 'int', 'Integer', 'userId', NULL, '1', '1', '1', '1', '1', 'EQ', 'input', 2);
INSERT INTO `gen_table_column` VALUES (211, 18, 'category_id', '分类id', 'bigint', 'Long', 'categoryId', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 3);
INSERT INTO `gen_table_column` VALUES (212, 18, 'title', '文章标题', 'varchar', 'String', 'title', NULL, '1', '1', '1', '1', '1', 'EQ', 'input', 4);
INSERT INTO `gen_table_column` VALUES (213, 18, 'cover', '文章封面地址', 'varchar', 'String', 'cover', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 5);
INSERT INTO `gen_table_column` VALUES (214, 18, 'summary', '文章简介', 'varchar', 'String', 'summary', NULL, '1', '1', '1', '1', '1', 'EQ', 'input', 6);
INSERT INTO `gen_table_column` VALUES (215, 18, 'content', '文章内容', 'mediumtext', 'String', 'content', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 7);
INSERT INTO `gen_table_column` VALUES (216, 18, 'content_md', '文章内容md格式', 'mediumtext', 'String', 'contentMd', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 8);
INSERT INTO `gen_table_column` VALUES (217, 18, 'read_type', '阅读方式 0无需验证 1：评论阅读 2：点赞阅读 3：扫码阅读', 'int', 'Integer', 'readType', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 9);
INSERT INTO `gen_table_column` VALUES (218, 18, 'is_stick', '是否置顶 0否 1是', 'int', 'Integer', 'isStick', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 10);
INSERT INTO `gen_table_column` VALUES (219, 18, 'is_publish', '是否发布 0：下架 1：发布', 'int', 'Integer', 'isPublish', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 11);
INSERT INTO `gen_table_column` VALUES (220, 18, 'is_original', '是否原创  0：转载 1:原创', 'int', 'Integer', 'isOriginal', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 12);
INSERT INTO `gen_table_column` VALUES (221, 18, 'is_carousel', '是否首页轮播', 'int', 'Integer', 'isCarousel', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 13);
INSERT INTO `gen_table_column` VALUES (222, 18, 'is_recommend', '是否推荐', 'int', 'Integer', 'isRecommend', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 14);
INSERT INTO `gen_table_column` VALUES (223, 18, 'original_url', '转载地址', 'varchar', 'String', 'originalUrl', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 15);
INSERT INTO `gen_table_column` VALUES (224, 18, 'quantity', '文章阅读量', 'bigint', 'Long', 'quantity', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 16);
INSERT INTO `gen_table_column` VALUES (225, 18, 'keywords', '关键词', 'varchar', 'String', 'keywords', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 17);
INSERT INTO `gen_table_column` VALUES (226, 18, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 18);
INSERT INTO `gen_table_column` VALUES (227, 18, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', NULL, '0', '1', '1', '1', '1', 'EQ', 'input', 19);
INSERT INTO `gen_table_column` VALUES (228, 19, 'id', '主键', 'int', 'Integer', 'id', '1', '1', '1', '1', '1', '1', 'EQ', 'input', 1);
INSERT INTO `gen_table_column` VALUES (229, 19, 'name', '名称', 'varchar', 'String', 'name', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 2);
INSERT INTO `gen_table_column` VALUES (230, 19, 'sort', '排序', 'int', 'Integer', 'sort', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 3);
INSERT INTO `gen_table_column` VALUES (231, 19, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 4);
INSERT INTO `gen_table_column` VALUES (232, 19, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 5);
INSERT INTO `gen_table_column` VALUES (233, 20, 'id', '主键ID', 'int', 'Integer', 'id', '1', '1', '1', '1', '1', '1', 'EQ', 'input', 1);
INSERT INTO `gen_table_column` VALUES (234, 20, 'name', '网站名称', 'varchar', 'String', 'name', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 2);
INSERT INTO `gen_table_column` VALUES (235, 20, 'url', '网站地址', 'varchar', 'String', 'url', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 3);
INSERT INTO `gen_table_column` VALUES (236, 20, 'avatar', '网站头像地址', 'varchar', 'String', 'avatar', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 4);
INSERT INTO `gen_table_column` VALUES (237, 20, 'info', '网站描述', 'varchar', 'String', 'info', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 5);
INSERT INTO `gen_table_column` VALUES (238, 20, 'email', '邮箱', 'varchar', 'String', 'email', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 6);
INSERT INTO `gen_table_column` VALUES (239, 20, 'sort', '排序', 'int', 'Integer', 'sort', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 7);
INSERT INTO `gen_table_column` VALUES (240, 20, 'reason', '下架原因', 'varchar', 'String', 'reason', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 8);
INSERT INTO `gen_table_column` VALUES (241, 20, 'status', 'ENUM-状态:\"0,下架;1,申请;2:上架\"', 'int', 'Integer', 'status', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 9);
INSERT INTO `gen_table_column` VALUES (242, 20, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 10);
INSERT INTO `gen_table_column` VALUES (243, 20, 'update_time', '修改时间', 'datetime', 'Date', 'updateTime', '0', '0', '1', '1', '1', '1', 'EQ', 'input', 11);

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_DURABLE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JOB_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DESCRIPTION` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PREV_FIRE_TIME` bigint NULL DEFAULT NULL,
  `PRIORITY` int NULL DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `START_TIME` bigint NOT NULL,
  `END_TIME` bigint NULL DEFAULT NULL,
  `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `MISFIRE_INSTR` smallint NULL DEFAULT NULL,
  `JOB_DATA` blob NULL,
  PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
  INDEX `SCHED_NAME`(`SCHED_NAME` ASC, `JOB_NAME` ASC, `JOB_GROUP` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_album
-- ----------------------------
DROP TABLE IF EXISTS `sys_album`;
CREATE TABLE `sys_album`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相册名',
  `description` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相册描述',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面URL',
  `is_lock` int NULL DEFAULT 0 COMMENT '是否加密 0：否 1：是',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '相册' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_album
-- ----------------------------
INSERT INTO `sys_album` VALUES (6, '1', '1', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/98_bdg.jpg', 0, '', NULL, '2025-06-26 11:14:10');
INSERT INTO `sys_album` VALUES (7, '456', '', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/30_头像1.jpg', 0, '', NULL, '2025-06-26 12:06:07');
INSERT INTO `sys_album` VALUES (8, '1234566', '', 'http://127.0.0.1:8800/localFile/local-plus/20250626/album-cover/91_0f41e491be93636907ef08617f929932_1551843504083.jpg', 0, '', NULL, '2025-06-26 12:33:30');

-- ----------------------------
-- Table structure for sys_article
-- ----------------------------
DROP TABLE IF EXISTS `sys_article`;
CREATE TABLE `sys_article`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int NOT NULL COMMENT '用户id',
  `category_id` bigint NULL DEFAULT NULL COMMENT '分类id',
  `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文章标题',
  `cover` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文章封面地址',
  `summary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文章简介',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文章内容',
  `content_md` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文章内容md格式',
  `read_type` int NULL DEFAULT 0 COMMENT '阅读方式 0无需验证 1：评论阅读 2：点赞阅读 3：扫码阅读',
  `is_stick` int NULL DEFAULT 0 COMMENT '是否置顶 0否 1是',
  `status` int NULL DEFAULT 0 COMMENT '状态 0：下架 1：发布',
  `is_original` int NULL DEFAULT 1 COMMENT '是否原创  0：转载 1:原创',
  `is_carousel` int NULL DEFAULT 0 COMMENT '是否首页轮播',
  `is_recommend` int NULL DEFAULT 0 COMMENT '是否推荐',
  `original_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '转载地址',
  `quantity` bigint NULL DEFAULT 0 COMMENT '文章阅读量',
  `keywords` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关键词',
  `ai_describe` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'Ai生成的简短描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  FULLTEXT INDEX `title`(`title`) WITH PARSER `ngram`
) ENGINE = InnoDB AUTO_INCREMENT = 298 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客文章表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_article
-- ----------------------------
INSERT INTO `sys_article` VALUES (296, 1, 16, '你好这是我的博客', 'http://127.0.0.1:8800/localFile/local-plus/20250626/article-cover/83_bdg.jpg', '此博客与2025年6月26日开始运行', '<p>你好123<br />\n此博客与2025年6月26日开始运行</p>\n', '你好123\n此博客与2025年6月26日开始运行\n', 1, 1, 1, 1, 1, 1, '', 0, '', NULL, '2025-06-26 12:34:01', '2025-06-26 14:33:44');
INSERT INTO `sys_article` VALUES (297, 1, 17, '你好 测试文章', NULL, '测试', '<p>测试测试</p>\n', '测试测试', 1, 0, 1, 1, 0, 0, '', 0, '', NULL, '2025-06-26 19:36:21', NULL);

-- ----------------------------
-- Table structure for sys_article_like
-- ----------------------------
DROP TABLE IF EXISTS `sys_article_like`;
CREATE TABLE `sys_article_like`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int NOT NULL COMMENT '用户id',
  `article_id` int NOT NULL COMMENT '文章id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章点赞表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_article_like
-- ----------------------------
INSERT INTO `sys_article_like` VALUES (4, 1, 296);
INSERT INTO `sys_article_like` VALUES (5, 1811, 296);

-- ----------------------------
-- Table structure for sys_article_tag
-- ----------------------------
DROP TABLE IF EXISTS `sys_article_tag`;
CREATE TABLE `sys_article_tag`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `article_id` int NOT NULL COMMENT '文章id',
  `tag_id` int NOT NULL COMMENT '标签id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1393 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章标签关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_article_tag
-- ----------------------------
INSERT INTO `sys_article_tag` VALUES (1388, 296, 1);
INSERT INTO `sys_article_tag` VALUES (1389, 296, 12);
INSERT INTO `sys_article_tag` VALUES (1390, 297, 13);
INSERT INTO `sys_article_tag` VALUES (1391, 297, 17);
INSERT INTO `sys_article_tag` VALUES (1392, 297, 31);

-- ----------------------------
-- Table structure for sys_category
-- ----------------------------
DROP TABLE IF EXISTS `sys_category`;
CREATE TABLE `sys_category`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_category
-- ----------------------------
INSERT INTO `sys_category` VALUES (13, '生活随笔', 1, '2024-12-22 12:51:31', NULL);
INSERT INTO `sys_category` VALUES (16, '运维部署', 1, '2024-12-22 18:59:28', NULL);
INSERT INTO `sys_category` VALUES (17, '后端开发', 1, NULL, NULL);
INSERT INTO `sys_category` VALUES (19, '网络爬虫', NULL, NULL, NULL);
INSERT INTO `sys_category` VALUES (20, '资源软件', NULL, NULL, NULL);
INSERT INTO `sys_category` VALUES (28, '数据库', NULL, NULL, NULL);
INSERT INTO `sys_category` VALUES (31, '前端开发', NULL, NULL, NULL);
INSERT INTO `sys_category` VALUES (32, '博客文档', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_comment
-- ----------------------------
DROP TABLE IF EXISTS `sys_comment`;
CREATE TABLE `sys_comment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论主键ID，自增唯一标识',
  `article_id` int NOT NULL COMMENT '关联的文章ID，表明该评论所属的文章',
  `user_id` int NOT NULL COMMENT '发表评论的用户ID',
  `reply_user_id` int NULL DEFAULT NULL COMMENT '回复人id',
  `parent_id` int NULL DEFAULT NULL COMMENT '父评论ID，用于实现回复评论的层级结构，若为顶级评论则为NULL',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容，使用utf8mb4字符集以支持更多字符类型',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数，记录该评论获得的点赞数量',
  `is_stick` int NULL DEFAULT 0 COMMENT '是否置顶',
  `ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `browser` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器',
  `system` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统',
  `ip_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip来源',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_comment
-- ----------------------------
INSERT INTO `sys_comment` VALUES (21, 1, 1, NULL, NULL, '![laugh](https://media.giphy.com/media/10JhviFuU2gWD6/giphy.gif)', 0, 0, '127.0.0.1', NULL, NULL, '内网IP|内网IP', NULL);
INSERT INTO `sys_comment` VALUES (22, 1, 1, NULL, NULL, '\\![happy](https://media.giphy.com/media/XR9Dp54ZC4dji/giphy.gif)', 0, 0, '127.0.0.1', NULL, NULL, '内网IP|内网IP', NULL);
INSERT INTO `sys_comment` VALUES (23, 1, 1, NULL, NULL, '![happy](https://media.giphy.com/media/XR9Dp54ZC4dji/giphy.gif)', 0, 0, '127.0.0.1', NULL, NULL, '内网IP|内网IP', NULL);
INSERT INTO `sys_comment` VALUES (25, 292, 1, NULL, NULL, '<span style=\"color: #409eff\">hhhh</span>', 0, 0, '127.0.0.1', NULL, NULL, '内网IP|内网IP', '2024-12-27 20:40:32');
INSERT INTO `sys_comment` VALUES (32, 296, 1811, NULL, NULL, '太棒了！', 0, 0, '192.168.0.196', 'Chrome 137.0.0.0', NULL, '内网IP|内网IP', '2025-06-26 14:04:24');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '滑块验证码开关', 'slider_verify_switch', 'Y', 'Y', NULL, '2025-03-19 16:33:27', '开启：Y,关闭：N');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典名称',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典类型',
  `status` int NOT NULL DEFAULT 1 COMMENT '是否发布(1:是，0:否)',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (26, '登录方式', 'login_type', 1, '登陆方式', '2024-12-28 22:25:17', '2024-12-28 22:25:17', 0);
INSERT INTO `sys_dict` VALUES (31, '反馈类型', 'feedback_type', 1, '反馈类型', '2025-01-12 10:37:00', '2025-01-12 10:37:00', 0);
INSERT INTO `sys_dict` VALUES (32, '反馈状态', 'feedback_status', 1, '', '2025-01-12 10:37:00', '2025-01-12 10:37:00', 0);
INSERT INTO `sys_dict` VALUES (33, '公告位置', 'notice_position', 1, '', '2025-02-11 15:27:51', '2025-02-11 15:27:51', 0);
INSERT INTO `sys_dict` VALUES (34, '是否状态', 'sys_yes_no', 1, '是和否状态', '2025-02-13 14:33:48', '2025-02-13 14:33:47', 0);
INSERT INTO `sys_dict` VALUES (35, '文件类型', 'sys_file_type', 1, '', '2025-02-13 17:10:46', '2025-02-13 17:10:45', 0);
INSERT INTO `sys_dict` VALUES (36, '存储平台', 'sys_file_oss', 1, '', '2025-02-14 08:47:01', '2025-02-14 08:47:01', 0);
INSERT INTO `sys_dict` VALUES (37, '文章状态', 'article_status', 1, NULL, '2025-01-16 09:56:49', '2025-01-16 09:56:49', 0);
INSERT INTO `sys_dict` VALUES (38, '资源分类', 'sys_resource_category', 1, NULL, '2025-03-12 10:04:22', '2025-03-12 10:04:22', 0);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_id` bigint NOT NULL COMMENT '字典类型id',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典标签',
  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典键值',
  `style` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '回显样式',
  `is_default` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否默认（1是 0否）',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` int NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 37, '下架', '0', 'danger', '0', 1, NULL, 1);
INSERT INTO `sys_dict_data` VALUES (2, 37, '上架', '1', 'success', '0', 2, NULL, 1);
INSERT INTO `sys_dict_data` VALUES (3, 37, '草稿', '2', 'warning', '0', 3, NULL, 1);
INSERT INTO `sys_dict_data` VALUES (4, 37, '审核', '3', 'info', '0', 4, NULL, 1);
INSERT INTO `sys_dict_data` VALUES (5, 26, 'QQ', 'qq', 'success', '1', 2, 'QQ登录', 1);
INSERT INTO `sys_dict_data` VALUES (6, 26, '微博', 'weibo', 'danger', '0', 2, '微博登录', 1);
INSERT INTO `sys_dict_data` VALUES (7, 26, '码云', 'gitee', 'danger', '0', 3, 'gitee登录', 1);
INSERT INTO `sys_dict_data` VALUES (8, 26, '微信', 'wechat', 'success', '1', 0, '微信登录', 1);
INSERT INTO `sys_dict_data` VALUES (9, 26, 'github', 'github', 'info', '1', 4, 'github登录', 1);
INSERT INTO `sys_dict_data` VALUES (38, 31, '问题反馈', 'bug', 'danger', '0', 1, '', 1);
INSERT INTO `sys_dict_data` VALUES (39, 31, '功能建议', 'feature', 'success', '0', 2, '', 1);
INSERT INTO `sys_dict_data` VALUES (40, 31, '其他', 'other', 'info', '0', 3, '', 1);
INSERT INTO `sys_dict_data` VALUES (49, 33, '顶部', 'top', 'primary', '0', 1, '', 1);
INSERT INTO `sys_dict_data` VALUES (50, 33, '右侧', 'right', 'info', '0', 2, '', 1);
INSERT INTO `sys_dict_data` VALUES (51, 34, '否', '0', 'danger', '0', 0, '', 1);
INSERT INTO `sys_dict_data` VALUES (52, 34, '是', '1', 'success', '0', 1, '', 1);
INSERT INTO `sys_dict_data` VALUES (53, 35, 'png', 'png', 'primary', '0', 0, '', 1);
INSERT INTO `sys_dict_data` VALUES (54, 35, 'gif', 'gif', 'info', '0', 1, '', 1);
INSERT INTO `sys_dict_data` VALUES (55, 35, 'jpg', 'jpg', 'primary', '0', 2, '', 1);
INSERT INTO `sys_dict_data` VALUES (56, 35, 'jpeg', 'jpeg', 'primary', '0', 3, '', 1);
INSERT INTO `sys_dict_data` VALUES (57, 35, 'doc', 'doc', 'warning', '0', 4, '', 1);
INSERT INTO `sys_dict_data` VALUES (58, 35, 'mp4', 'mp4', 'danger', '0', 5, '', 1);
INSERT INTO `sys_dict_data` VALUES (59, 36, '七牛云', 'qiniu', 'primary', '0', 0, '', 1);
INSERT INTO `sys_dict_data` VALUES (60, 36, '阿里云', 'ali', 'warning', '0', 1, '', 1);
INSERT INTO `sys_dict_data` VALUES (61, 36, '本地云', 'local', 'info', '0', 2, '', 1);
INSERT INTO `sys_dict_data` VALUES (62, 36, '腾讯云', 'tencent', 'primary', '0', 3, '', 1);
INSERT INTO `sys_dict_data` VALUES (63, 36, 'minio', 'minio', 'danger', '0', 4, '', 1);
INSERT INTO `sys_dict_data` VALUES (64, 37, '软件安装包', '1', 'primary', '0', 1, 'zip', 1);
INSERT INTO `sys_dict_data` VALUES (65, 37, 'PDF电子书', '2', 'danger', '0', 3, 'pdf', 1);
INSERT INTO `sys_dict_data` VALUES (66, 37, 'Office文档', '3', 'info', '0', 2, 'doc', 1);

-- ----------------------------
-- Table structure for sys_feedback
-- ----------------------------
DROP TABLE IF EXISTS `sys_feedback`;
CREATE TABLE `sys_feedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '反馈人id',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '反馈类型',
  `content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '反馈内容',
  `email` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `reply_content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '回复内容',
  `status` int NULL DEFAULT 0 COMMENT '状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_feedback
-- ----------------------------

-- ----------------------------
-- Table structure for sys_file_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_file_oss`;
CREATE TABLE `sys_file_oss`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '访问域名',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'access-key',
  `secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'secret-key',
  `bucket` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '空间名',
  `base_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '存储基础路径',
  `platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '存储类型',
  `is_enable` int NULL DEFAULT NULL COMMENT '是否启用存储',
  `storage_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本地存储路径',
  `enable_access` int NULL DEFAULT NULL COMMENT '本地启用访问',
  `path_patterns` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '本地访问路径',
  `region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '仓库所在地域',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '存储平台' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_file_oss
-- ----------------------------
INSERT INTO `sys_file_oss` VALUES (1, 'http://127.0.0.1:8800/localFile/', '', '', '', 'local-plus/', 'local', 1, 'D:/Temp/', 1, 'localFile/**', NULL, '2025-02-14 10:52:33');

-- ----------------------------
-- Table structure for sys_friend
-- ----------------------------
DROP TABLE IF EXISTS `sys_friend`;
CREATE TABLE `sys_friend`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站名称',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站地址',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网站头像地址',
  `info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站描述',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下架原因',
  `status` int NOT NULL DEFAULT 0 COMMENT 'ENUM-状态:\"0,下架;1,申请;2:上架\"',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `url`(`url` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '友情链接' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_friend
-- ----------------------------

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'task.neatNoParams', '* * * * * ? *', '3', '1', '1', '2024-11-17 12:39:45', '2024-11-18 17:26:59', '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'demoTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', '2024-11-17 12:39:45', '2024-11-17 12:39:45', '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'demoTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', '2024-11-17 12:39:45', '2024-11-18 09:27:22', '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_id` bigint NOT NULL COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `stop_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上级资源ID',
  `path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由路径',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单名称',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `icon` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源图标',
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '类型 menu、button',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `redirect` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '重定向地址',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转地址',
  `hidden` int NULL DEFAULT NULL COMMENT '是否隐藏',
  `perm` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `is_external` int NULL DEFAULT 0 COMMENT '是否外链 0:否  1:是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 141 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '权限资源表 ' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '0', '/system', 'Layout', '系统管理', 4, 'Setting', 'CATALOG', '2019-03-28 18:51:08', '2021-12-17 15:26:06', '/system/user', '', 0, NULL, 0);
INSERT INTO `sys_menu` VALUES (2, '1', 'role', '/system/role/index', '角色管理', 2, 'Avatar', 'MENU', '2019-03-30 14:00:03', '2021-11-16 15:40:42', '', '', 0, NULL, 0);
INSERT INTO `sys_menu` VALUES (3, '2', NULL, NULL, '角色列表', 1, '', 'BUTTON', NULL, '2024-11-18 17:56:16', '', NULL, 1, 'system:role', 0);
INSERT INTO `sys_menu` VALUES (4, '0', '/monitor', 'Layout', '监控中心', 5, 'Monitor', 'CATALOG', NULL, '2024-11-17 21:38:25', '/monitor/server', '', 0, NULL, 0);
INSERT INTO `sys_menu` VALUES (7, '6', '', '', '新增', 1, '', 'BUTTON', NULL, '2024-11-16 14:18:24', NULL, '', 1, 'a:b:add', 0);
INSERT INTO `sys_menu` VALUES (8, '2', '', '', '新增角色', 1, '', 'BUTTON', NULL, '2024-11-21 22:16:56', NULL, '', 1, 'sys:role:add', 0);
INSERT INTO `sys_menu` VALUES (9, '1', 'dict', '/system/dict/index', '字典管理', 3, 'Memo', 'MENU', '2024-11-17 21:29:51', '2024-11-17 21:39:06', NULL, '', 0, NULL, 0);
INSERT INTO `sys_menu` VALUES (10, '9', '', '', '新增字典', 1, '', 'BUTTON', '2024-11-17 21:30:23', NULL, NULL, '', 1, 'sys:dict:add', 0);
INSERT INTO `sys_menu` VALUES (11, '9', '', '', '修改字典', 2, '', 'BUTTON', '2024-11-17 21:32:34', '2024-11-18 18:01:35', NULL, '', 1, 'sys:dict:update', 0);
INSERT INTO `sys_menu` VALUES (12, '9', '', '', '删除字典', 3, '', 'BUTTON', '2024-11-17 21:34:33', '2024-11-17 21:39:11', NULL, '', 1, 'sys:dict:delete', 0);
INSERT INTO `sys_menu` VALUES (13, '1', 'menu', '/system/menu/index', '菜单管理', 5, 'Menu', 'MENU', NULL, '2021-11-18 11:26:00', '', 'menu', 0, NULL, 0);
INSERT INTO `sys_menu` VALUES (14, '1', 'user', '/system/user/index', '用户管理', 1, 'User', 'MENU', '2024-11-18 01:10:52', '2024-11-18 01:11:13', NULL, '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (16, '4', 'server', '/monitor/server/index', '服务监控', 1, 'Crop', 'MENU', '2024-11-18 01:18:12', '2024-11-18 01:20:27', NULL, '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (17, '4', 'cache', '/monitor/cache/index', '缓存监控', 2, 'Coin', 'MENU', '2024-11-18 06:56:49', NULL, NULL, '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (18, '4', 'job', '/monitor/job/index', '定时任务', 3, 'AlarmClock', 'MENU', '2024-11-18 06:57:38', NULL, NULL, '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (19, '4', 'job-log', '/monitor/job/log', '调度日志', 4, 'Document', 'MENU', '2024-11-18 06:58:43', '2024-11-18 06:58:55', NULL, '', 1, '', 0);
INSERT INTO `sys_menu` VALUES (27, '14', '', '', '新增用户', 2, '', 'BUTTON', '2024-11-18 09:18:14', '2024-11-21 22:15:30', NULL, '', 1, 'sys:user:add', 0);
INSERT INTO `sys_menu` VALUES (28, '14', '', '', '编辑用户', 2, '', 'BUTTON', '2024-11-18 09:18:38', '2024-11-21 14:38:56', NULL, '', 1, 'sys:user:update', 0);
INSERT INTO `sys_menu` VALUES (29, '14', '', '', '删除用户', 3, '', 'BUTTON', '2024-11-18 09:18:53', '2024-11-21 22:15:43', NULL, '', 1, 'sys:user:delete', 0);
INSERT INTO `sys_menu` VALUES (30, '0', '/tool', 'Layout', '系统工具', 6, 'Suitcase', 'CATALOG', '2024-11-18 09:21:10', '2024-11-18 12:23:55', '/tool/gen', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (31, '30', 'gen', '/tool/gen/index', '代码生成', 1, 'Compass', 'MENU', '2024-11-18 09:21:52', NULL, NULL, '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (32, '1', 'log', '', '日志管理', 5, 'DocumentCopy', 'MENU', '2024-11-18 10:52:47', '2024-11-18 10:58:00', '/system/log/operation', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (33, '32', 'operation', '/system/log/operation/index', '操作日志', 1, 'CircleCheckFilled', 'MENU', '2024-11-18 10:53:10', '2024-11-18 11:05:22', NULL, '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (39, '14', '', '', '用户列表', 1, '', 'BUTTON', '2024-11-18 17:54:15', '2024-11-21 22:07:33', '', '', 1, 'sys:user', 0);
INSERT INTO `sys_menu` VALUES (40, '2', '', '', '修改角色', 2, '', 'BUTTON', '2024-11-18 17:56:10', '2024-11-21 22:04:52', '', '', 1, 'sys:role:update', 0);
INSERT INTO `sys_menu` VALUES (41, '2', '', '', '删除角色', 3, '', 'BUTTON', '2024-11-18 17:56:34', '2024-11-21 22:17:17', '', NULL, 1, 'sys:role:delete', 0);
INSERT INTO `sys_menu` VALUES (43, '2', '', '', '分配权限', 5, '', 'BUTTON', '2024-11-18 17:57:28', NULL, '', NULL, 1, 'sys:role:menus', 0);
INSERT INTO `sys_menu` VALUES (44, '9', '', '', '批量删除', 4, '', 'BUTTON', '2024-11-18 17:58:16', '2024-11-21 22:07:06', '', '', 1, 'sys:dict:deleteBatch', 0);
INSERT INTO `sys_menu` VALUES (48, '13', '', '', '添加菜单', 1, '', 'BUTTON', '2024-11-18 17:56:58', NULL, '', NULL, 1, 'sys:menu:add', 0);
INSERT INTO `sys_menu` VALUES (49, '13', '', '', '修改菜单', 2, '', 'BUTTON', '2024-11-18 17:56:58', NULL, '', NULL, 1, 'sys:menu:update', 0);
INSERT INTO `sys_menu` VALUES (50, '13', '', '', '删除菜单', 3, '', 'BUTTON', '2024-11-21 21:55:49', NULL, '', '', 1, 'sys:menu:delete', 0);
INSERT INTO `sys_menu` VALUES (51, '13', '', '', '菜单列表', 1, '', 'BUTTON', '2024-11-21 21:58:29', NULL, '', '', 1, 'sys:menu', 0);
INSERT INTO `sys_menu` VALUES (52, '14', '', '', '重置密码', 5, '', 'BUTTON', '2024-11-21 22:00:30', NULL, '', '', 1, 'sys:user:reset', 0);
INSERT INTO `sys_menu` VALUES (53, '9', '', '', '字典列表', 1, '', 'BUTTON', '2024-11-18 17:58:16', NULL, '', '', 1, 'sys:dict', 0);
INSERT INTO `sys_menu` VALUES (54, '1', 'profile', '/system/user/profile/index', '个人中心', 99, 'Avatar', 'MENU', '2024-11-21 22:12:18', '2024-11-21 22:12:46', '', '', 1, '', 0);
INSERT INTO `sys_menu` VALUES (55, '33', '', '', '操作日志列表', 1, '', 'BUTTON', '2024-11-18 10:53:10', '2024-11-18 11:05:22', '', '', 1, 'sys:operateLog', 0);
INSERT INTO `sys_menu` VALUES (56, '33', '', '', '删除操作日志', 2, '', 'BUTTON', '2024-11-18 10:53:10', '2024-11-18 11:05:22', '', '', 1, 'sys:operateLog:delete', 0);
INSERT INTO `sys_menu` VALUES (58, '18', '', '', '定时任务列表', 3, '', 'BUTTON', '2024-11-18 17:56:58', '2024-11-21 22:04:42', '', NULL, 1, 'sys:job', 0);
INSERT INTO `sys_menu` VALUES (59, '18', '', '', '添加定时任务', 2, '', 'BUTTON', '2024-11-18 17:56:58', '2024-11-21 22:04:42', '', NULL, 1, 'sys:job:add', 0);
INSERT INTO `sys_menu` VALUES (60, '18', '', '', '修改定时任务', 1, '', 'BUTTON', '2024-11-18 17:56:58', '2024-11-21 22:04:42', '', NULL, 1, 'sys:job:update', 0);
INSERT INTO `sys_menu` VALUES (61, '18', '', '', '删除定时任务', 4, '', 'BUTTON', '2024-11-18 17:56:58', '2024-11-21 22:04:42', '', NULL, 1, 'sys:job:delete', 0);
INSERT INTO `sys_menu` VALUES (62, '18', '', '', '修改任务状态', 1, '', 'BUTTON', '2024-11-18 17:56:58', '2024-11-21 22:04:42', '', NULL, 0, 'sys:job:changeStatus', 0);
INSERT INTO `sys_menu` VALUES (63, '19', '', '', '删除定时任务日志', 1, '', 'BUTTON', '2024-11-21 22:26:56', NULL, '', '', 1, 'sys:jobLog:delete', 0);
INSERT INTO `sys_menu` VALUES (64, '19', '', '', '清空定时任务日志', 2, '', 'BUTTON', '2024-11-21 22:27:09', NULL, '', '', 1, 'sys:jobLog:clean', 0);
INSERT INTO `sys_menu` VALUES (65, '18', '', '', '批量删除定时任务', 1, '', 'BUTTON', '2024-11-21 22:37:01', '2024-11-21 22:38:05', '', '', 1, 'sys:job:deleteBatch', 0);
INSERT INTO `sys_menu` VALUES (66, '19', '', '', '定时任务日志列表', 1, '', 'BUTTON', '2024-11-21 23:09:47', NULL, '', '', 1, 'sys:jobLog', 0);
INSERT INTO `sys_menu` VALUES (67, '4', 'online', '/monitor/online/index', '在线用户', 4, 'Avatar', 'MENU', '2024-12-03 12:40:41', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (68, '0', '/article', 'Layout', '文章管理', 1, 'Document', 'CATALOG', '2024-12-22 10:49:22', '2024-12-22 10:49:37', '/article/index', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (69, '68', 'tag', '/article/tag/index', '标签管理', 2, 'PriceTag', 'MENU', '2024-12-22 10:49:22', '2024-12-22 10:49:37', '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (70, '68', 'category', '/article/category/index', '分类管理', 2, 'Dessert', 'MENU', '2024-12-22 10:49:22', '2024-12-22 10:49:37', '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (71, '68', 'index', '/article/article/index', '文章管理', 1, 'DocumentRemove', 'MENU', '2024-12-25 13:47:27', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (72, '0', '/site', 'Layout', '站点管理', 2, 'DeleteLocation', 'CATALOG', '2024-12-25 16:13:03', '2024-12-25 16:13:33', '/site/config', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (73, '72', 'friend', '/site/friend/index', '友链管理', 2, 'ChromeFilled', 'MENU', '2024-12-25 16:17:24', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (74, '72', 'config', '/site/config/index', '网站配置', 1, 'AddLocation', 'MENU', '2024-12-25 16:35:39', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (75, '71', '', '', '文章列表', 1, '', 'BUTTON', '2024-12-28 22:02:24', NULL, '', '', 1, 'sys:article:list', 0);
INSERT INTO `sys_menu` VALUES (76, '71', '', '', '新增文章', 2, '', 'BUTTON', '2024-12-28 22:02:24', NULL, '', '', 1, 'sys:article:add', 0);
INSERT INTO `sys_menu` VALUES (77, '71', '', '', '修改文章', 3, '', 'BUTTON', '2024-12-28 22:02:24', NULL, '', '', 1, 'sys:article:update', 0);
INSERT INTO `sys_menu` VALUES (78, '71', '', '', '修改状态', 4, '', 'BUTTON', '2024-12-28 22:02:24', NULL, '', '', 1, 'sys:article:updateStatus', 0);
INSERT INTO `sys_menu` VALUES (79, '71', '', '', '删除文章', 2, '', 'BUTTON', '2024-12-28 22:02:24', NULL, '', '', 1, 'sys:article:delete', 0);
INSERT INTO `sys_menu` VALUES (80, '69', '', '', '标签列表', 1, '', 'BUTTON', '2024-12-28 22:05:25', NULL, '', '', 1, 'sys:tag:list', 0);
INSERT INTO `sys_menu` VALUES (81, '69', '', '', '新增标签', 2, '', 'BUTTON', '2024-12-28 22:05:59', NULL, '', '', 1, 'sys:tag:add', 0);
INSERT INTO `sys_menu` VALUES (82, '69', '', '', '修改标签', 3, '', 'BUTTON', '2024-12-28 22:06:26', NULL, '', '', 1, 'sys:tag:update', 0);
INSERT INTO `sys_menu` VALUES (83, '69', '', '', '删除标签', 4, '', 'BUTTON', '2024-12-28 22:06:40', NULL, '', '', 1, 'sys:tag:delete', 0);
INSERT INTO `sys_menu` VALUES (84, '70', '', '', '分类列表', 1, '', 'BUTTON', '2024-12-28 22:07:27', NULL, '', '', 1, 'sys:category:list', 0);
INSERT INTO `sys_menu` VALUES (85, '70', '', '', '新增分类', 2, '', 'BUTTON', '2024-12-28 22:07:40', NULL, '', '', 1, 'sys:category:add', 0);
INSERT INTO `sys_menu` VALUES (86, '70', '', '', '修改分类', 3, '', 'BUTTON', '2024-12-28 22:07:58', NULL, '', '', 1, 'sys:category:update', 0);
INSERT INTO `sys_menu` VALUES (87, '70', '', '', '删除分类', 4, '', 'BUTTON', '2024-12-28 22:08:11', NULL, '', '', 1, 'sys:category:delete', 0);
INSERT INTO `sys_menu` VALUES (88, '74', '', '', '网站列表', 1, '', 'BUTTON', '2024-12-28 22:09:06', NULL, '', '', 1, 'sys:web:config', 0);
INSERT INTO `sys_menu` VALUES (89, '74', '', '', '修改配置', 2, '', 'BUTTON', '2024-12-28 22:09:21', NULL, '', '', 1, 'sys:web:update', 0);
INSERT INTO `sys_menu` VALUES (90, '73', '', '', '友链列表', 1, '', 'BUTTON', '2024-12-28 22:10:26', NULL, '', '', 1, 'sys:friend:list', 0);
INSERT INTO `sys_menu` VALUES (91, '73', '', '', '新增友链', 2, '', 'BUTTON', '2024-12-28 22:10:41', NULL, '', '', 1, 'sys:friend:add', 0);
INSERT INTO `sys_menu` VALUES (92, '73', '', '', '修改友链', 3, '', 'BUTTON', '2024-12-28 22:11:09', NULL, '', '', 1, 'sys:friend:update', 0);
INSERT INTO `sys_menu` VALUES (93, '73', '', '', '删除友链', 4, '', 'BUTTON', '2024-12-28 22:11:21', NULL, '', '', 1, 'sys:friend:delete', 0);
INSERT INTO `sys_menu` VALUES (94, '17', '', '', '清空缓存', 2, '', 'BUTTON', '2024-12-28 22:22:54', NULL, '', '', 1, 'monitor:cache', 0);
INSERT INTO `sys_menu` VALUES (95, '17', '', '', '缓存信息', 1, '', 'BUTTON', '2024-12-28 22:23:36', NULL, '', '', 1, 'monitor:cache:info', 0);
INSERT INTO `sys_menu` VALUES (96, '0', '/comment', 'Layout', '消息管理', 3, 'ChatDotSquare', 'CATALOG', '2025-01-02 09:49:06', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (97, '96', 'comment', '/message/comment/index', '评论管理', 1, 'ChatDotRound', 'MENU', '2024-12-22 10:49:22', '2024-12-22 10:49:37', '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (98, '97', '', '', '评论列表', 1, '', 'BUTTON', '2025-01-02 09:58:33', NULL, '', '', 1, 'sys:comment:list', 0);
INSERT INTO `sys_menu` VALUES (99, '97', '', '', '删除评论', 2, '', 'BUTTON', '2025-01-02 09:58:50', NULL, '', '', 1, 'sys:comment:delete', 0);
INSERT INTO `sys_menu` VALUES (100, '96', 'message', '/message/message/index', '留言管理', 2, 'ChatLineSquare', 'MENU', '2025-01-02 10:07:04', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (101, '100', '', '', '留言列表', 1, '', 'BUTTON', '2025-01-02 10:12:14', NULL, '', '', 1, 'sys:message:list', 0);
INSERT INTO `sys_menu` VALUES (102, '100', '', '', '删除留言', 2, '', 'BUTTON', '2025-01-02 10:22:06', NULL, '', '', 1, 'sys:message:delete', 0);
INSERT INTO `sys_menu` VALUES (103, '71', '', '', '爬取文章', 6, '', 'BUTTON', '2025-01-02 16:34:53', NULL, '', '', 1, 'sys:article:reptile', 0);
INSERT INTO `sys_menu` VALUES (104, '67', '', '', '列表', 1, '', 'BUTTON', '2025-01-03 15:53:46', NULL, '', '', 1, 'monitor:online:list', 0);
INSERT INTO `sys_menu` VALUES (105, '67', '', '', '强退', 2, '', 'BUTTON', '2025-01-03 15:54:03', NULL, '', '', 1, 'monitor:online:forceLogout', 0);
INSERT INTO `sys_menu` VALUES (106, '96', 'feedback', '/message/feedback/index', '反馈管理', 3, 'Checked', 'MENU', '2025-01-12 11:23:23', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (107, '106', '', '', '列表', 1, '', 'BUTTON', '2025-01-12 12:30:48', '2025-01-12 12:31:51', '', '', 1, 'sys:feedback:list', 0);
INSERT INTO `sys_menu` VALUES (108, '106', '', '', '修改', 2, '', 'BUTTON', '2025-01-12 12:31:00', '2025-01-12 12:31:55', '', '', 1, 'sys:feedback:update', 0);
INSERT INTO `sys_menu` VALUES (109, '106', '', '', '删除', 3, '', 'BUTTON', '2025-01-12 12:31:14', '2025-01-12 12:31:19', '', '', 1, 'sys:feedback:delete', 0);
INSERT INTO `sys_menu` VALUES (110, '68', '/moments', '/article/moment/index', '说说管理', 4, 'ChatDotRound', 'MENU', '2025-02-06 10:22:22', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (111, '110', '', '', '新增', 1, '', 'BUTTON', '2025-02-06 10:32:06', NULL, '', '', 1, 'sys:moment:add', 0);
INSERT INTO `sys_menu` VALUES (112, '110', '', '', '修改', 2, '', 'BUTTON', '2025-02-06 10:32:20', NULL, '', '', 1, 'sys:moment:update', 0);
INSERT INTO `sys_menu` VALUES (113, '110', '', '', '删除', 3, '', 'BUTTON', '2025-02-06 10:32:37', NULL, '', '', 1, 'sys:moment:delete', 0);
INSERT INTO `sys_menu` VALUES (114, '72', '/album', '/site/album/index', '相册管理', 1, 'CreditCard', 'MENU', '2025-02-07 10:49:51', '2025-02-07 10:50:23', '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (115, '114', '', '', '列表', 1, '', 'BUTTON', '2025-02-07 15:08:50', NULL, '', '', 1, 'sys:album:list', 0);
INSERT INTO `sys_menu` VALUES (116, '114', '', '', '新增', 2, '', 'BUTTON', '2025-02-07 15:09:03', NULL, '', '', 1, 'sys:album:add', 0);
INSERT INTO `sys_menu` VALUES (117, '114', '', '', '修改', 3, '', 'BUTTON', '2025-02-07 15:09:30', NULL, '', '', 1, 'sys:album:update', 0);
INSERT INTO `sys_menu` VALUES (118, '114', '', '', '删除', 4, '', 'BUTTON', '2025-02-07 15:09:53', NULL, '', '', 1, 'sys:album:delete', 0);
INSERT INTO `sys_menu` VALUES (119, '114', '', '', '新增照片', 5, '', 'BUTTON', '2025-02-07 15:10:39', NULL, '', '', 1, 'sys:photo:add', 0);
INSERT INTO `sys_menu` VALUES (120, '114', '', '', '修改照片', 6, '', 'BUTTON', '2025-02-07 15:10:55', NULL, '', '', 1, 'sys:photo:update', 0);
INSERT INTO `sys_menu` VALUES (121, '114', '', '', '删除照片', 7, '', 'BUTTON', '2025-02-07 15:11:18', NULL, '', '', 1, 'sys:photo:delete', 0);
INSERT INTO `sys_menu` VALUES (122, '114', '', '', '移动照片', 8, '', 'BUTTON', '2025-02-07 15:11:38', NULL, '', '', 1, 'sys:photo:move', 0);
INSERT INTO `sys_menu` VALUES (123, '72', '/notice', '/site/notice/index', '公告管理', 4, 'AlarmClock', 'MENU', '2024-12-25 16:13:03', '2024-12-25 16:13:33', '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (124, '123', '', '', '列表', 1, '', 'BUTTON', '2025-02-11 16:32:27', NULL, '', '', 1, 'sys:notice:list', 0);
INSERT INTO `sys_menu` VALUES (125, '123', '', '', '新增', 2, '', 'BUTTON', '2025-02-11 16:32:37', NULL, '', '', 1, 'sys:notice:add', 0);
INSERT INTO `sys_menu` VALUES (126, '123', '', '', '修改', 3, '', 'BUTTON', '2025-02-11 16:32:49', NULL, '', '', 0, 'sys:notice:update', 0);
INSERT INTO `sys_menu` VALUES (127, '123', '', '', '删除', 4, '', 'BUTTON', '2025-02-11 16:33:01', NULL, '', '', 1, 'sys:notice:delete', 0);
INSERT INTO `sys_menu` VALUES (128, '1', '/file', '/system/file/index', '文件管理', 6, 'Folder', 'MENU', '2025-02-13 16:01:54', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (129, '128', '', '', '列表', 1, '', 'BUTTON', '2025-02-13 17:04:56', NULL, '', '', 1, 'sys:file:list', 0);
INSERT INTO `sys_menu` VALUES (130, '128', '', '', '删除', 2, '', 'BUTTON', '2025-02-13 17:05:09', NULL, '', '', 1, 'sys:file:delete', 0);
INSERT INTO `sys_menu` VALUES (131, '128', '', '', '保存oss配置', 2, '', 'BUTTON', '2025-02-13 17:05:09', NULL, '', '', 1, 'sys:oss:submit', 0);
INSERT INTO `sys_menu` VALUES (136, '1', '/config', '/system/config/index', '参数管理', 4, 'Film', 'MENU', '2025-03-19 15:56:07', NULL, '', '', 0, '', 0);
INSERT INTO `sys_menu` VALUES (137, '136', '', '', '列表', 1, '', 'BUTTON', '2025-03-19 16:55:57', NULL, '', '', 1, 'sys:config:list', 0);
INSERT INTO `sys_menu` VALUES (138, '136', '', '', '添加', 2, '', 'BUTTON', '2025-03-19 16:56:09', NULL, '', '', 1, 'sys:config:add', 0);
INSERT INTO `sys_menu` VALUES (139, '136', '', '', '修改', 3, '', 'BUTTON', '2025-03-19 16:56:20', NULL, '', '', 1, 'sys:config:update', 0);
INSERT INTO `sys_menu` VALUES (140, '136', '', '', '删除', 4, '', 'BUTTON', '2025-03-19 16:56:34', NULL, '', '', 1, 'sys:config:delete', 0);

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '内容',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP来源',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1425 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '留言' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_message
-- ----------------------------
INSERT INTO `sys_message` VALUES (1423, '游客', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Guest', '123', '192.168.0.196', '内网IP|内网IP', NULL, '2025-06-26 11:46:07');
INSERT INTO `sys_message` VALUES (1424, '龙', 'http://127.0.0.1:8800/localFile/local-plus/20250626/avatar/04_avatar.jpg', '欢迎大家来到留言板', '192.168.0.196', '内网IP|内网IP', NULL, '2025-06-26 13:49:25');

-- ----------------------------
-- Table structure for sys_moment
-- ----------------------------
DROP TABLE IF EXISTS `sys_moment`;
CREATE TABLE `sys_moment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户id',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文章内容',
  `images` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '说说' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_moment
-- ----------------------------
INSERT INTO `sys_moment` VALUES (3, 1, '<p>大家好呀~~！！</p><p><br></p><p>这是我的说说</p>', '', '2025-06-26 13:50:41');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '公告内容',
  `is_show` int NULL DEFAULT NULL COMMENT '是否展示',
  `position` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示位置 （top：顶部，right:右侧）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (4, '<p>大家好！欢迎来到我的博客！！<span style=\"color: rgb(255, 77, 79);\">严格声明！！！！</span> <span style=\"color: rgb(255, 77, 79);\"> </span><span style=\"color: rgb(255, 77, 79); font-size: 14px;\">一、严禁违反网络安全法规 二、严禁泄露国家秘密 三、严禁侵犯他人隐私 四、严禁传播违法信息 五、严禁网络攻击 六、严禁制作或传播计算机病毒 七、严禁网络诈骗 八、严禁侵犯知识产权 &nbsp;九、严禁网络谣言 十、严禁破坏网络设施</span></p>', 1, 'top', '2025-06-26 15:51:50');

-- ----------------------------
-- Table structure for sys_notifications
-- ----------------------------
DROP TABLE IF EXISTS `sys_notifications`;
CREATE TABLE `sys_notifications`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知的唯一标识，自增主键',
  `user_id` bigint NULL DEFAULT NULL COMMENT '推送用户id',
  `from_user_id` bigint NULL DEFAULT NULL COMMENT '来自用户id,如评论就存评论的用户id',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知的类型，如 system、comment、like 等',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知的标题',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知的具体内容',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '标记通知是否已读，0 表示未读，1 表示已读',
  `article_id` bigint NULL DEFAULT NULL COMMENT '文章id',
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '跳转链接',
  `create_time` datetime NOT NULL COMMENT '通知的创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '消息通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notifications
-- ----------------------------
INSERT INTO `sys_notifications` VALUES (1, 1, 1811, 'comment', '新评论通知', '太棒了！', 0, 296, NULL, '2025-06-26 14:04:24');

-- ----------------------------
-- Table structure for sys_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operate_log`;
CREATE TABLE `sys_operate_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作用户',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求接口',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方式',
  `operation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作名称',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip来源',
  `spend_time` bigint NULL DEFAULT NULL COMMENT '请求接口耗时',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `params_json` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数',
  `class_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类地址',
  `method_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '方法名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2252 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_operate_log
-- ----------------------------
INSERT INTO `sys_operate_log` VALUES (2249, 'admin', '/sys/user', 'PUT', '修改用户', '192.168.0.196', '内网IP|内网IP', 21, '2025-06-26 11:27:59', '{\"user\":{\"user\":{\"id\":1,\"username\":\"admin\",\"status\":1,\"ip\":\"192.168.0.196\",\"ipLocation\":\"内网IP|内网IP\",\"lastLoginTime\":1750907937000,\"nickname\":\"龙\",\"avatar\":\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\",\"mobile\":\"\",\"sex\":1,\"loginType\":\"email\",\"createTime\":1735280177000,\"updateTime\":1750908479946},\"roleIds\":[1]}}', 'com.mojian.controller.system.SysUserController', 'update');
INSERT INTO `sys_operate_log` VALUES (2250, 'admin', '/sys/user', 'POST', '新增用户', '192.168.0.196', '内网IP|内网IP', 92, '2025-06-26 14:02:24', '{\"sysUserAddDto\":{\"user\":{\"id\":1811,\"username\":\"zhangsan\",\"password\":\"$2a$10$W5ajPCGqqV4S3Fty1/6kQuIyrFxLHa3bIO1DqjXd3lj/p6uK.7P8.\",\"status\":1,\"nickname\":\"煜\",\"mobile\":\"\",\"email\":\"\",\"sex\":1,\"createTime\":1750917744210},\"roleIds\":[15]}}', 'com.mojian.controller.system.SysUserController', 'addUser');
INSERT INTO `sys_operate_log` VALUES (2251, 'admin', '/sys/user/delete/1818', 'DELETE', '批量删除用户', '192.168.0.196', '内网IP|内网IP', 24, '2025-06-26 14:42:56', '{\"ids\":[1818]}', 'com.mojian.controller.system.SysUserController', 'delete');

-- ----------------------------
-- Table structure for sys_photo
-- ----------------------------
DROP TABLE IF EXISTS `sys_photo`;
CREATE TABLE `sys_photo`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `album_id` bigint NOT NULL COMMENT '相册id',
  `description` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片描述',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片地址',
  `record_time` date NULL DEFAULT NULL COMMENT '记录时间',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '照片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_photo
-- ----------------------------
INSERT INTO `sys_photo` VALUES (2, 6, '123456', 'http://127.0.0.1:8800/localFile/local-plus/20250626/photo/79_728568d4-0a1f-4a61-a13e-73ab4b9f577d.jpg', '2025-06-26', 1, '2025-06-26 11:21:02');

-- ----------------------------
-- Table structure for sys_resource
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource`;
CREATE TABLE `sys_resource`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资源名',
  `category` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类',
  `downloads` int NULL DEFAULT NULL COMMENT '下载量',
  `is_free` int NULL DEFAULT NULL COMMENT '是否免费',
  `pay_type` int NULL DEFAULT NULL COMMENT '付费方式',
  `pan_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网盘地址',
  `pan_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网盘验证码',
  `status` int NULL DEFAULT NULL COMMENT '状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资源表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_resource
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  `remarks` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色表 ' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, 'admin', '超级管理员', '拥有一切权限\n', '2024-11-16 12:29:00', '2024-11-16 12:29:00');
INSERT INTO `sys_role` VALUES (14, 'demo', '演示账号', '仅提供演示用，所有按钮权限可看到但不能操作', '2024-11-21 22:59:30', '2024-11-21 22:59:29');
INSERT INTO `sys_role` VALUES (15, 'user', '用户', '门户注册的用户', '2024-12-28 13:32:09', '2024-12-28 13:32:08');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int NULL DEFAULT NULL COMMENT '角色ID',
  `menu_id` int NULL DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_id`(`role_id` ASC, `menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 394 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色-权限资源关联表 ' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (28, 2, 1);
INSERT INTO `sys_role_menu` VALUES (29, 2, 2);
INSERT INTO `sys_role_menu` VALUES (25, 2, 4);
INSERT INTO `sys_role_menu` VALUES (26, 2, 6);
INSERT INTO `sys_role_menu` VALUES (27, 2, 7);
INSERT INTO `sys_role_menu` VALUES (30, 2, 8);
INSERT INTO `sys_role_menu` VALUES (370, 14, 1);
INSERT INTO `sys_role_menu` VALUES (373, 14, 2);
INSERT INTO `sys_role_menu` VALUES (374, 14, 3);
INSERT INTO `sys_role_menu` VALUES (383, 14, 4);
INSERT INTO `sys_role_menu` VALUES (375, 14, 9);
INSERT INTO `sys_role_menu` VALUES (380, 14, 13);
INSERT INTO `sys_role_menu` VALUES (371, 14, 14);
INSERT INTO `sys_role_menu` VALUES (384, 14, 16);
INSERT INTO `sys_role_menu` VALUES (385, 14, 17);
INSERT INTO `sys_role_menu` VALUES (387, 14, 18);
INSERT INTO `sys_role_menu` VALUES (389, 14, 19);
INSERT INTO `sys_role_menu` VALUES (391, 14, 30);
INSERT INTO `sys_role_menu` VALUES (392, 14, 31);
INSERT INTO `sys_role_menu` VALUES (377, 14, 32);
INSERT INTO `sys_role_menu` VALUES (378, 14, 33);
INSERT INTO `sys_role_menu` VALUES (393, 14, 34);
INSERT INTO `sys_role_menu` VALUES (372, 14, 39);
INSERT INTO `sys_role_menu` VALUES (381, 14, 51);
INSERT INTO `sys_role_menu` VALUES (376, 14, 53);
INSERT INTO `sys_role_menu` VALUES (382, 14, 54);
INSERT INTO `sys_role_menu` VALUES (379, 14, 55);
INSERT INTO `sys_role_menu` VALUES (388, 14, 58);
INSERT INTO `sys_role_menu` VALUES (390, 14, 66);
INSERT INTO `sys_role_menu` VALUES (353, 14, 68);
INSERT INTO `sys_role_menu` VALUES (358, 14, 69);
INSERT INTO `sys_role_menu` VALUES (356, 14, 70);
INSERT INTO `sys_role_menu` VALUES (354, 14, 71);
INSERT INTO `sys_role_menu` VALUES (360, 14, 72);
INSERT INTO `sys_role_menu` VALUES (363, 14, 73);
INSERT INTO `sys_role_menu` VALUES (361, 14, 74);
INSERT INTO `sys_role_menu` VALUES (355, 14, 75);
INSERT INTO `sys_role_menu` VALUES (359, 14, 80);
INSERT INTO `sys_role_menu` VALUES (357, 14, 84);
INSERT INTO `sys_role_menu` VALUES (362, 14, 88);
INSERT INTO `sys_role_menu` VALUES (364, 14, 90);
INSERT INTO `sys_role_menu` VALUES (386, 14, 95);
INSERT INTO `sys_role_menu` VALUES (365, 14, 96);
INSERT INTO `sys_role_menu` VALUES (366, 14, 97);
INSERT INTO `sys_role_menu` VALUES (367, 14, 98);
INSERT INTO `sys_role_menu` VALUES (368, 14, 100);
INSERT INTO `sys_role_menu` VALUES (369, 14, 101);

-- ----------------------------
-- Table structure for sys_tag
-- ----------------------------
DROP TABLE IF EXISTS `sys_tag`;
CREATE TABLE `sys_tag`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_tag
-- ----------------------------
INSERT INTO `sys_tag` VALUES (1, 'Spring Boot', 20, '2021-11-12 14:43:27', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (2, 'Elasticsearch', 6, '2021-11-12 14:43:27', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (10, '博客', 9, '2021-11-12 14:43:27', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (12, 'Vue', 18, '2021-12-29 14:01:50', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (13, 'Spring Cloud', 19, '2021-12-29 14:02:32', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (17, 'Redis', 7, '2022-01-25 14:09:03', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (18, 'Linux', 10, '2022-01-25 14:09:17', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (31, 'Mysql', 10, '2022-02-18 16:01:07', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (32, 'Nginx', 5, '2022-04-13 17:48:08', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (51, '异步', 5, '2023-04-03 11:30:54', '2023-06-05 03:00:00');
INSERT INTO `sys_tag` VALUES (57, 'Java Script', 1, '2023-06-27 16:02:33', '2023-06-27 08:02:32');
INSERT INTO `sys_tag` VALUES (59, 'Dcoker', 12, '2023-07-13 15:51:12', '2023-07-13 07:51:12');
INSERT INTO `sys_tag` VALUES (60, 'Aspect', 0, '2023-07-25 17:07:19', '2023-07-25 09:07:18');
INSERT INTO `sys_tag` VALUES (62, 'oauth2', 0, '2023-08-15 09:30:12', '2023-08-15 01:30:11');
INSERT INTO `sys_tag` VALUES (63, '服务器', 0, '2023-09-05 17:28:08', '2023-09-05 09:28:07');
INSERT INTO `sys_tag` VALUES (65, 'Css', 0, '2023-09-25 11:19:00', '2023-09-25 03:18:59');
INSERT INTO `sys_tag` VALUES (66, 'Java', 11, '2023-10-07 09:28:50', '2023-10-07 01:28:50');
INSERT INTO `sys_tag` VALUES (67, 'Juc', 12, '2023-10-07 09:28:55', '2023-10-07 01:28:54');
INSERT INTO `sys_tag` VALUES (69, '高并发', 14, '2023-10-07 09:29:11', '2023-10-07 01:29:11');
INSERT INTO `sys_tag` VALUES (70, '资源', 0, '2023-10-12 10:46:35', '2023-10-12 02:46:34');
INSERT INTO `sys_tag` VALUES (71, 'websoket', 0, '2023-12-14 17:17:58', '2023-12-14 09:17:58');
INSERT INTO `sys_tag` VALUES (72, 'uniapp', 0, '2023-12-26 11:28:20', '2023-12-26 03:28:20');
INSERT INTO `sys_tag` VALUES (73, '宝塔', 0, '2024-02-19 16:17:29', '2024-02-19 08:17:29');
INSERT INTO `sys_tag` VALUES (89, 'vite', 0, '2024-04-12 11:49:23', '2024-04-12 11:49:22');
INSERT INTO `sys_tag` VALUES (90, 'electron', 0, '2024-04-17 16:08:46', '2024-04-17 16:08:46');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录密码',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int NULL DEFAULT 1 COMMENT '状态 0:禁用 1:正常',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip地址',
  `ip_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录系统',
  `last_login_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后登录时间',
  `browser` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '浏览器',
  `nickname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `mobile` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sex` int NULL DEFAULT NULL COMMENT '性别',
  `login_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录方式',
  `signature` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '个性签名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1821 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$GSHv.XwqBkizplz5j2pcmu73IRY2rgtxCYQwAvSXMvu9SryzydLpe', '2024-12-27 14:16:17', '2025-06-26 13:46:05', 1, '192.168.0.197', '内网IP|内网IP', 'Windows', '2025-06-27 08:56:39', 'Chrome', '龙', 'http://127.0.0.1:8800/localFile/local-plus/20250626/avatar/48_avatar.jpg', '', NULL, 1, 'email', NULL);
INSERT INTO `sys_user` VALUES (1811, 'zhangsan', '$2a$10$W5ajPCGqqV4S3Fty1/6kQuIyrFxLHa3bIO1DqjXd3lj/p6uK.7P8.', '2025-06-26 14:02:24', '2025-06-26 14:02:24', 1, '192.168.0.198', '内网IP|内网IP', 'Windows', '2025-06-26 16:09:36', 'Chrome', '煜', NULL, '', '', 1, NULL, NULL);
INSERT INTO `sys_user` VALUES (1812, 'wyh', '$2a$10$e8sTOkiu4gV8d6CQSCBtBOnaK2N3qNbo1TN9jeHtW9ogN90yErtFG', '2025-06-26 14:09:03', '2025-06-26 14:09:03', 1, '192.168.0.196', '内网IP|内网IP', 'Windows', '2025-06-26 14:51:11', 'Chrome', 'user_z9ovZ7', 'https://api.dicebear.com/6.x/pixel-art/svg?seed=Puppy', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (1819, 'lisi', '$2a$10$OwdAOKHNsRIFyBFOyzOZoeqFgheth4rEkpS6IpXQoHyMZaimnHeKS', '2025-06-26 14:43:08', '2025-06-26 14:43:08', 1, '192.168.0.196', '内网IP|内网IP', 'Windows', '2025-06-26 14:43:18', 'Chrome', 'user_81pSZt', 'https://api.dicebear.com/6.x/pixel-art/svg?seed=Fox', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (1820, 'jyh', '$2a$10$8DQqjR6EijbSXNPJ83YZvOnM6iih0vFOt/uocCoosyO2rwR185dR2', '2025-06-26 14:44:40', '2025-06-26 14:44:40', 1, '192.168.0.196', '内网IP|内网IP', 'Windows', '2025-06-26 14:47:20', 'Chrome', '啊浪费了', 'https://api.dicebear.com/6.x/pixel-art/svg?seed=Fox', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int NULL DEFAULT NULL COMMENT '角色ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统管理 - 用户角色关联表 ' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (42, 14, 9);
INSERT INTO `sys_user_role` VALUES (44, 14, 1810);
INSERT INTO `sys_user_role` VALUES (45, 1, 1);
INSERT INTO `sys_user_role` VALUES (46, 15, 1811);

-- ----------------------------
-- Table structure for sys_web_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_web_config`;
CREATE TABLE `sys_web_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'logo(文件UID)',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '网站名称',
  `summary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '介绍',
  `record_num` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备案号',
  `web_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网站地址',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '作者',
  `author_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个性签名',
  `author_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作者头像',
  `ali_pay` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付宝收款码',
  `weixin_pay` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信收款码',
  `github` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'github地址',
  `gitee` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'gitee地址',
  `qq_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'QQ号',
  `qq_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'QQ群',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `wechat` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信',
  `show_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示的列表（用于控制邮箱、QQ、QQ群、Github、Gitee、微信是否显示在前端）',
  `login_type_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录方式列表（用于控制前端登录方式，如账号密码,码云,Github,QQ,微信）',
  `open_comment` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否开启评论(0:否 1:是)',
  `open_admiration` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否开启赞赏(0:否， 1:是)',
  `tourist_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '游客头像',
  `bulletin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公告',
  `about_me` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '关于我',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `open_lantern` int NULL DEFAULT NULL COMMENT '开启灯笼',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '网站配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_web_config
-- ----------------------------
INSERT INTO `sys_web_config` VALUES (1, 'http://127.0.0.1:8800/localFile/local-plus/20250626/default/02_bdg.jpg', '煜龙的博客', '一个专注于技术分享的博客平台', '', '', '煜龙', '在哪里跌倒就在哪里睡一觉。', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix', NULL, NULL, '', '', '522910252', '', '522910252@qq.com', '19555715213', '[\"qq\",\"wechat\",\"email\"]', '[\"qq\",\"wechat\"]', 1, 1, 'https://api.dicebear.com/7.x/avataaars/svg?seed=Guest', '有没有在长沙内推的小伙伴，卑微博主在线求职了，有的话<span style=\"color:red\">VX：1248954763</span> 联系博主', '<p>作者是小菜鸡</p>', '2024-12-22 11:55:25', '2024-12-22 11:55:25', 0);

SET FOREIGN_KEY_CHECKS = 1;
