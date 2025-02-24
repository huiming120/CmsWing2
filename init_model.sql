/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : cmswing

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 20/02/2025 14:48:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cms_attachment
-- ----------------------------
DROP TABLE IF EXISTS `cms_attachment`;
CREATE TABLE `cms_attachment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名字',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '附件描述',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件存储地址',
  `url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件网络地址',
  `size` int(10) UNSIGNED NOT NULL COMMENT '文件大小(kb)',
  `mime` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '文件类型',
  `location` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '文件上传类型(local、kodo、obs、oss、cos)',
  `upload_user_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '上传者uuid',
  `upload_ip` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上传者ip地址',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  `remark` json NULL COMMENT '备注信息,方便审核通过时更新相应信息{from:上传来源(admin,avatar,form),其他信息}',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cms_attachment_name`(`name`) USING BTREE,
  INDEX `cms_attachment_description`(`description`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_classify
-- ----------------------------
DROP TABLE IF EXISTS `cms_classify`;
CREATE TABLE `cms_classify`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标识',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `pid` int(11) NULL DEFAULT 0 COMMENT '上级分类ID',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序（同级有效）',
  `list_row` int(11) NULL DEFAULT 15 COMMENT '列表每页行数',
  `meta_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'SEO的网页标题',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关键字',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `template_index` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '频道页模板',
  `template_lists` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列表页模板',
  `template_detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详情页模板',
  `models_uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联模型UUID',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '允许发布的内容类型',
  `allow_publish` tinyint(1) NULL DEFAULT 0 COMMENT '是否允许发布内容',
  `display` int(11) NULL DEFAULT NULL COMMENT '可见性',
  `reply` tinyint(1) NULL DEFAULT 1 COMMENT '是否允许回复',
  `check` tinyint(1) NULL DEFAULT 1 COMMENT '发布的文章是否需要审核',
  `sub` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '子分类',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_comments
-- ----------------------------
DROP TABLE IF EXISTS `cms_comments`;
CREATE TABLE `cms_comments`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `member_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户关联uuid',
  `doc_id` int(11) NOT NULL COMMENT '文档关联id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cms_comments_doc_id`(`doc_id`) USING BTREE,
  INDEX `cms_comments_member_uuid`(`member_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_comments_reply
-- ----------------------------
DROP TABLE IF EXISTS `cms_comments_reply`;
CREATE TABLE `cms_comments_reply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '回复内容',
  `comments_id` int(11) NOT NULL COMMENT '评论关联id',
  `member_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户关联uuid',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cms_comments_reply_comments_id`(`comments_id`) USING BTREE,
  INDEX `cms_comments_reply_member_uuid`(`member_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_doc
-- ----------------------------
DROP TABLE IF EXISTS `cms_doc`;
CREATE TABLE `cms_doc`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `user_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '作者uuid',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容标题',
  `classify_id` int(11) NOT NULL DEFAULT 0 COMMENT '分类ID',
  `classify_sub` json NULL COMMENT '子分类',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `root` int(11) NULL DEFAULT 0 COMMENT '根节点',
  `pid` int(11) NULL DEFAULT 0 COMMENT '所属ID',
  `models_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '模型UUID',
  `type` int(11) NOT NULL DEFAULT 2 COMMENT '内容类型（1-目录，2-主题，3-段落）',
  `position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '推荐位(1-列表推荐，2-频道页推荐，4-首页推荐）',
  `ext_link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '如果填写链接,会跳转到这个链接,不填不跳转',
  `cover_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `display` tinyint(1) NULL DEFAULT 1 COMMENT '可见性',
  `deadline` datetime(0) NULL DEFAULT NULL COMMENT '截止时间',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `level` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '优先级（越高排序越靠前）',
  `status` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '数据状态（0-禁用，1-正常，2-待审核，3-草稿）',
  `template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模板详情',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序同级有效越小越靠前',
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `cms_doc_classify_id`(`classify_id`) USING BTREE,
  INDEX `cms_doc_pid`(`pid`) USING BTREE,
  INDEX `cms_doc_models_uuid`(`models_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_doc_article
-- ----------------------------
DROP TABLE IF EXISTS `cms_doc_article`;
CREATE TABLE `cms_doc_article`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `doc_id` int(11) NOT NULL COMMENT '主表id',
  `content_type` enum('html','amis') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'html' COMMENT '文章内容类型(html|amis)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章内容',
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cms_doc_article_doc_id`(`doc_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_doc_download
-- ----------------------------
DROP TABLE IF EXISTS `cms_doc_download`;
CREATE TABLE `cms_doc_download`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `doc_id` int(11) NOT NULL COMMENT '主表id',
  `content` json NOT NULL COMMENT '下载内容',
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '下载介绍',
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cms_doc_download_doc_id`(`doc_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_doc_picture
-- ----------------------------
DROP TABLE IF EXISTS `cms_doc_picture`;
CREATE TABLE `cms_doc_picture`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `doc_id` int(11) NOT NULL COMMENT '主表id',
  `content` json NOT NULL COMMENT '图片内容',
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cms_doc_picture_doc_id`(`doc_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cms_template
-- ----------------------------
DROP TABLE IF EXISTS `cms_template`;
CREATE TABLE `cms_template`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板目录',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作者',
  `sys` tinyint(1) NULL DEFAULT 0 COMMENT '系统模板',
  `isu` tinyint(1) NULL DEFAULT 0 COMMENT '正在使用',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '版本号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cms_template_uuid`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cms_template
-- ----------------------------
INSERT INTO `cms_template` VALUES (1, '2024-11-19 10:04:12', '2025-02-18 15:01:26', '默认模板', 'default', 'arterli', 1, 1, '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '1.0');

-- ----------------------------
-- Table structure for cms_template_list
-- ----------------------------
DROP TABLE IF EXISTS `cms_template_list`;
CREATE TABLE `cms_template_list`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `template_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '模板UUID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'index' COMMENT '类型',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名称',
  `isd` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认',
  `isu` tinyint(1) NULL DEFAULT 0 COMMENT '使用中',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'UUID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cms_template_list_uuid`(`uuid`) USING BTREE,
  INDEX `cms_template_list_template_uuid`(`template_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cms_template_list
-- ----------------------------
INSERT INTO `cms_template_list` VALUES (1, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认首页模板', 'index', 'default', 1, 1, 'e90bba0b-d935-4c74-b9bd-48c89cb119d0');
INSERT INTO `cms_template_list` VALUES (2, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认列表模板', 'list', 'default', 1, 0, '6f181771-516b-40a4-9bd1-099d14b9d3d7');
INSERT INTO `cms_template_list` VALUES (3, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认详情模板', 'detail', 'default', 1, 0, '850f07f4-be83-4def-ad1e-545bfa5bfb2a');
INSERT INTO `cms_template_list` VALUES (4, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认公共基础模板', 'inc', 'base', 1, 0, 'd6fe605d-f944-40db-8397-24c56cf95a7b');
INSERT INTO `cms_template_list` VALUES (5, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认公共头部模板', 'inc', 'header', 1, 0, 'ee06d0be-2e85-40a7-ab63-6ff3138c5a6a');
INSERT INTO `cms_template_list` VALUES (6, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认公共底部模板', 'inc', 'footer', 1, 0, 'e4168d2a-2412-4e7e-b2e4-0f324687caff');
INSERT INTO `cms_template_list` VALUES (7, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认评论模板', 'comment', 'index', 1, 0, 'f9674bf0-dea9-4a3a-9a2a-73c62925ec31');
INSERT INTO `cms_template_list` VALUES (8, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认评论列表模板', 'comment', 'ajax_list', 1, 0, '8767580b-5045-4211-9998-254bc3ffb626');
INSERT INTO `cms_template_list` VALUES (9, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认评论编辑模板', 'comment', 'ajax_edit', 1, 0, '0702b28c-9060-4db6-ba2f-7c3532f60f53');
INSERT INTO `cms_template_list` VALUES (10, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认评论回复模板', 'comment', 'ajax_reply', 1, 0, '24067d9f-7b5d-4e67-a7fc-ab3e3df9305c');
INSERT INTO `cms_template_list` VALUES (11, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认评论回复编辑模板', 'comment', 'ajax_reply_edit', 1, 0, '088ed0df-d6ff-4ea0-9434-37d6e3007163');
INSERT INTO `cms_template_list` VALUES (12, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '公共404模板', 'inc', '404', 1, 0, '7f117a5a-11be-4c4c-96a9-c39a166bfdff');
INSERT INTO `cms_template_list` VALUES (13, '2025-02-18 14:55:33', '2025-02-18 14:55:33', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '默认公共会员侧边栏', 'inc', 'sidebar', 0, 0, 'c27dfa64-b172-4b7a-9698-6fe33b1aff64');
INSERT INTO `cms_template_list` VALUES (14, '2025-02-18 14:57:09', '2025-02-18 14:57:09', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '登录弹框模板', 'mc', 'login_modal', 0, 0, 'd3571054-e792-4d90-96cc-10e8353ee64b');
INSERT INTO `cms_template_list` VALUES (15, '2025-02-18 14:57:33', '2025-02-18 14:57:33', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '登录页面模板', 'mc', 'login_view', 0, 0, 'e647cc7f-2d7e-4876-bef6-c6d8052082db');
INSERT INTO `cms_template_list` VALUES (16, '2025-02-18 14:58:07', '2025-02-18 14:58:07', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '会员中心', 'mc', 'index', 0, 0, '9704fdea-8bb1-49f1-acbd-d6a95cb76850');
INSERT INTO `cms_template_list` VALUES (17, '2025-02-18 14:58:35', '2025-02-18 14:58:35', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '会员信息设置', 'mc', 'setup_index', 0, 0, 'ebd37849-9bc5-44f2-9812-6682f82ee6f8');
INSERT INTO `cms_template_list` VALUES (18, '2025-02-18 14:59:03', '2025-02-18 14:59:03', '1f8dda2a-6e9e-4762-a273-1bc138ec9ffa', '会员评论管理', 'mc', 'comment', 0, 0, '35ce3332-df5a-472c-ab2b-d9ec13fad189');

-- ----------------------------
-- Table structure for form
-- ----------------------------
DROP TABLE IF EXISTS `form`;
CREATE TABLE `form`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名字',
  `begin_at` datetime(0) NOT NULL COMMENT '活动开始时间',
  `end_at` datetime(0) NOT NULL COMMENT '活动结束时间',
  `config` json NOT NULL COMMENT '活动配置',
  `fields` json NOT NULL COMMENT '字段数组',
  `amis` json NULL COMMENT 'amis框架页面json配置',
  `temp` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模板',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for form_data
-- ----------------------------
DROP TABLE IF EXISTS `form_data`;
CREATE TABLE `form_data`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `form_id` int(11) NOT NULL COMMENT '所属表单id',
  `member_uuid` char(36) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户关联uuid(如果表单没限制登录默认36个0)',
  `data` json NOT NULL COMMENT '数据',
  `status` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态(0-未审核 1-审核中 2-审核成功 3-审核失败)',
  `ip` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '提交者ip地址',
  `member_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '游客' COMMENT '用户名',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `form_data_form_id`(`form_id`) USING BTREE,
  INDEX `form_data_member_uuid`(`member_uuid`) USING BTREE,
  INDEX `form_data_ip`(`ip`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mc_member
-- ----------------------------
DROP TABLE IF EXISTS `mc_member`;
CREATE TABLE `mc_member`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机',
  `state` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'UUid',
  `third` json NULL COMMENT '第三方扩展',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `sys_user_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '绑定的管理员账号uuid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `mc_member_uuid`(`uuid`) USING BTREE,
  UNIQUE INDEX `mc_member_username`(`username`) USING BTREE,
  UNIQUE INDEX `mc_member_mobile`(`mobile`) USING BTREE,
  UNIQUE INDEX `mc_member_email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for special
-- ----------------------------
DROP TABLE IF EXISTS `special`;
CREATE TABLE `special`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `title` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '专题标题',
  `description` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '描述',
  `thumb` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '封面图',
  `banners` json NULL COMMENT '轮播图',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序(越大越靠前)',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态(未上线前端不可见)',
  `temp` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模板',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `special_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for special_data
-- ----------------------------
DROP TABLE IF EXISTS `special_data`;
CREATE TABLE `special_data`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `special_id` int(10) UNSIGNED NOT NULL COMMENT '所属专题id',
  `doc_id` int(11) NOT NULL COMMENT '稿件id',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序(越大越靠前)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `special_data_special_id_doc_id`(`special_id`, `doc_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_application
-- ----------------------------
DROP TABLE IF EXISTS `sys_application`;
CREATE TABLE `sys_application`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用标识',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名称',
  `intro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'intro',
  `explain` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '说明',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作者',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '版本',
  `sys` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_application_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_application
-- ----------------------------
INSERT INTO `sys_application` VALUES (1, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'sys', '系统应用', '系统应用', '系统应用', 'arterli', '1.0', 1);
INSERT INTO `sys_application` VALUES (2, '2024-11-19 10:04:12', '2024-12-26 14:16:57', 'mc', '用户中心', '用户注册、登录相关', '用户注册、登录相关', 'arterli', '1.0', 0);
INSERT INTO `sys_application` VALUES (3, '2024-11-19 10:04:12', '2024-12-26 14:17:40', 'cms', '内容管理系统', '对外网站功能', '对外网站功能', 'arterli', '1.0', 0);
INSERT INTO `sys_application` VALUES (4, '2024-12-30 16:19:42', '2025-01-15 10:17:08', 'form', '表单', '表单相关功能应用,如问卷、报名、联系我们等功能', '表单功能相关(依赖mc应用)\r\n\r\n模型\r\n\r\nform、formData\r\n\r\n文件\r\n\r\napp/controller/form/*\r\napp/pages/form/*\r\napp/view/form/*\r\n', 'ph', '1.0', 0);
INSERT INTO `sys_application` VALUES (5, '2025-01-15 10:19:05', '2025-01-15 10:19:05', 'special', '专题', '专题相关功能', '专题相关功能(依赖cms应用)', 'ph', '1.0', 0);
INSERT INTO `sys_application` VALUES (6, '2025-01-26 14:28:59', '2025-01-26 14:28:59', 'wall', '签到墙活动', '签到墙活动应用', NULL, 'ph', '1.0', 0);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置key',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名称',
  `value` json NOT NULL COMMENT '配置value',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_config_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config`(`id`, `createdAt`, `updatedAt`, `name`, `label`, `value`) VALUES (1, '2024-11-19 10:04:12', '2024-12-30 10:07:34', 'objectStorage', '对象储存配置', '{\"cos\": {\"path\": \"upload\"}, \"obs\": {\"path\": \"upload\", \"Bucket\": \"\", \"AccessKey\": \"小明\"}, \"oss\": {\"path\": \"upload\", \"Bucket\": \"cmswing\", \"Region\": \"oss-cn-shanghai\", \"domain\": \"\", \"AccessKey\": \"\", \"SecretKey\": \"\"}, \"kodo\": {\"path\": \"upload\", \"AccessKey\": \"123456\"}, \"type\": \"local\", \"local\": {\"path\": \"upload\", \"domain\": \"\"}}');
INSERT INTO `sys_config`(`id`, `createdAt`, `updatedAt`, `name`, `label`, `value`) VALUES (2, '2024-11-19 10:04:12', '2025-02-21 11:39:02', 'egg', 'Config 配置', '{\"cors\": {\"origin\": \"*\", \"allowMethods\": \"GET, PUT, POST, DELETE, PATCH\"}, \"keys\": \"CMSWING_1728858853816_3360\", \"cluster\": {\"listen\": {\"port\": 7001, \"hostname\": \"127.0.0.1\"}}, \"multipart\": {\"mode\": \"file\", \"fileSize\": \"100mb\", \"whitelist\": [\".jpg\", \".jpeg\", \".png\", \".gif\", \".bmp\", \".wbmp\", \".webp\", \".tif\", \".psd\", \".svg\", \".js\", \".jsx\", \".json\", \".css\", \".less\", \".html\", \".htm\", \".xml\", \".zip\", \".gz\", \".tgz\", \".gzip\", \".mp3\", \".mp4\", \".avi\", \".tar\", \".pdf\", \".xlsx\", \".txt\"]}}');
INSERT INTO `sys_config`(`id`, `createdAt`, `updatedAt`, `name`, `label`, `value`) VALUES (3, '2024-11-19 10:04:12', '2025-02-21 11:30:29', 'cms', 'CMS配置', '{\"icp\": \"湘ICP备xxxxxxxxx号\", \"name\": \"cmswing\", \"tongji\": \"\", \"keywords\": \"nodejs,cms,eggjs\", \"grayTheme\": false, \"openLogin\": true, \"openSearch\": true, \"description\": \"企业级 Node.js WEB开发框架,使用 Egg.js 和 GraphQ 构建更好的 NodeJS 应用程序，帮助开发人员降低开发和维护成本！\", \"agreementUrl\": \"/\", \"openRegister\": true}');
INSERT INTO `sys_config`(`id`, `createdAt`, `updatedAt`, `name`, `label`, `value`) VALUES (4, '2025-01-24 11:14:40', '2025-02-21 11:31:39', 'sms', '短信配置', '{\"enable\": false, \"SignName\": \"测试\", \"accessKeyId\": \"短信accessKeyId\", \"TemplateCode\": \"通用短信模板id\", \"secretAccessKey\": \"短信secretAccessKey\"}');
INSERT INTO `sys_config`(`id`, `createdAt`, `updatedAt`, `name`, `label`, `value`) VALUES (5, '2025-01-24 11:15:09', '2025-02-21 11:31:57', 'nodemailer', '邮箱配置', '{\"auth\": {\"pass\": \"邮箱服务授权码\", \"user\": \"邮箱服务账号\"}, \"enable\": false, \"service\": \"qq\"}');
INSERT INTO `sys_config`(`id`, `createdAt`, `updatedAt`, `name`, `label`, `value`) VALUES (6, '2025-01-24 11:15:43', '2025-02-21 11:32:13', 'wxauth', '微信公众号配置', '{\"appid\": \"公众号appid\", \"appsecret\": \"公众号appsecret\"}');

-- ----------------------------
-- Table structure for sys_models
-- ----------------------------
DROP TABLE IF EXISTS `sys_models`;
CREATE TABLE `sys_models`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模型名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模型说明',
  `oldName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改变后的模型名称',
  `paranoid` tinyint(1) NULL DEFAULT 0 COMMENT '偏执表',
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所属应用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_models_uuid`(`uuid`) USING BTREE,
  INDEX `sys_models_name`(`name`) USING BTREE,
  INDEX `sys_models_app`(`app`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_models
-- ----------------------------
INSERT INTO `sys_models` VALUES (1, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'sys_models', '模型管理', 'sys_models', 0, 'sys');
INSERT INTO `sys_models` VALUES (2, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'sys_user', '系统用户', 'sys_user', 1, 'sys');
INSERT INTO `sys_models` VALUES (3, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'sys_models_fields', '模型字段表', 'sys_models_fields', 0, 'sys');
INSERT INTO `sys_models` VALUES (4, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'sys_models_indexes', '模型索引', 'sys_models_indexes', 0, 'sys');
INSERT INTO `sys_models` VALUES (5, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'sys_models_associate', '模型关联', 'sys_models_associate', 0, 'sys');
INSERT INTO `sys_models` VALUES (6, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'sys_routes', '路由管理', 'sys_routes', 0, 'sys');
INSERT INTO `sys_models` VALUES (7, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'sys_routes_classify', '路由分类', 'sys_routes_classify', 0, 'sys');
INSERT INTO `sys_models` VALUES (8, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '161f3657-96b0-4a44-b872-92e42f446039', 'sys_user_group', '系统用户组', 'sys_user_group', 0, 'sys');
INSERT INTO `sys_models` VALUES (9, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'sys_role', '角色表', 'sys_role', 0, 'sys');
INSERT INTO `sys_models` VALUES (10, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '603a57cd-64c0-49bf-8019-05676ae6622f', 'sys_user_role', '用户角色中间表', 'sys_user_role', 0, 'sys');
INSERT INTO `sys_models` VALUES (11, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 'sys_openApi', '开放接口', 'sys_openApi', 0, 'sys');
INSERT INTO `sys_models` VALUES (12, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'cms_doc', 'cms内容主表', 'cms_doc', 1, 'cms');
INSERT INTO `sys_models` VALUES (13, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'cms_classify', 'cms分类', 'cms_classify', 0, 'cms');
INSERT INTO `sys_models` VALUES (14, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'cms_doc_article', '文章', 'cms_doc_article', 1, 'cms');
INSERT INTO `sys_models` VALUES (15, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '4e0da60c-13af-4965-8f35-e2b13742398e', 'cms_doc_picture', '图片', 'cms_doc_picture', 1, 'cms');
INSERT INTO `sys_models` VALUES (16, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'cms_doc_download', '下载', 'cms_doc_download', 1, 'cms');
INSERT INTO `sys_models` VALUES (17, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'sys_navigation', '系统导航', 'sys_navigation', 0, 'sys');
INSERT INTO `sys_models` VALUES (18, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'mc_member', '会员管理', 'mc_member', 0, 'mc');
INSERT INTO `sys_models` VALUES (19, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'cms_comments', 'cms评论', 'cms_comments', 0, 'cms');
INSERT INTO `sys_models` VALUES (20, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'cms_comments_reply', 'cms评论回复', 'cms_comments_reply', 0, 'cms');
INSERT INTO `sys_models` VALUES (21, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'cms_template', 'cms模板管理', 'cms_template', 0, 'cms');
INSERT INTO `sys_models` VALUES (22, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'cms_template_list', '模板文件', 'cms_template_list', 0, 'cms');
INSERT INTO `sys_models` VALUES (23, '2024-11-19 10:04:12', '2024-11-19 10:04:12', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'sys_application', '应用表', 'sys_application', 0, 'sys');
INSERT INTO `sys_models` VALUES (24, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'sys_config', '系统配置', '', 0, 'sys');
INSERT INTO `sys_models` VALUES (25, '2024-11-19 10:04:12', '2024-11-19 10:04:12', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'cms_attachment', '附件表', '', 0, 'cms');
INSERT INTO `sys_models` VALUES (26, '2024-12-30 16:33:01', '2025-01-06 14:08:23', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'form', '表单表', 'form_form', 0, 'form');
INSERT INTO `sys_models` VALUES (27, '2025-01-06 14:29:57', '2025-01-06 14:29:57', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'form_data', '表单数据表', NULL, 0, 'form');
INSERT INTO `sys_models` VALUES (28, '2025-01-15 10:23:07', '2025-01-15 10:23:07', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'special', '专题表', NULL, 0, 'special');
INSERT INTO `sys_models` VALUES (29, '2025-01-15 10:37:36', '2025-01-15 10:37:36', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'special_data', '专题稿件数据', NULL, 0, 'special');
INSERT INTO `sys_models` VALUES (30, '2025-01-26 14:59:19', '2025-01-26 14:59:19', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'wall', '签到墙活动表', NULL, 0, 'wall');
INSERT INTO `sys_models` VALUES (31, '2025-02-06 19:03:37', '2025-02-06 19:03:37', '09023791-7045-4e86-b4da-6ac0072ef574', 'wall_award', '签到墙奖品表', NULL, 0, 'wall');
INSERT INTO `sys_models` VALUES (32, '2025-02-06 19:15:41', '2025-02-06 19:15:41', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'wall_qd_data', '签到墙签到数据', NULL, 0, 'wall');

-- ----------------------------
-- Table structure for sys_models_associate
-- ----------------------------
DROP TABLE IF EXISTS `sys_models_associate`;
CREATE TABLE `sys_models_associate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `type` enum('HasOne','BelongsTo','HasMany','BelongsToMany') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联类型',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `models_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'models_uuid',
  `parent_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '父表',
  `targetKey` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '父键',
  `through_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '中间表',
  `throughKey` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '中间键',
  `child_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '子表',
  `foreignKey` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '子键',
  `constraints` tinyint(1) NOT NULL DEFAULT 0 COMMENT '约束',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `alias` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '别名(多态关联时名字要唯一)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_models_associate_uuid`(`uuid`) USING BTREE,
  INDEX `sys_models_associate_models_uuid`(`models_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_models_associate
-- ----------------------------
INSERT INTO `sys_models_associate` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '95cc6b92-0438-4de8-ab67-93a7d90830c9', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '352abc9a-3a68-4358-adc7-fc5093b96bf3', '', '', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', '1cb0cd12-fdb3-4549-96ce-0e4faf8b4a01', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (2, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', 'b1518c16-6e11-4da0-bc29-4a3631a592d4', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '352abc9a-3a68-4358-adc7-fc5093b96bf3', '', '', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', '1cb0cd12-fdb3-4549-96ce-0e4faf8b4a01', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (3, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', 'ccc710a9-a5de-462c-ad9a-724bb7c71c21', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '352abc9a-3a68-4358-adc7-fc5093b96bf3', '', '', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'aad47105-7def-4f21-99c6-9bdf35564fd3', 0, 2, NULL);
INSERT INTO `sys_models_associate` VALUES (4, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '98bae2bb-907c-47fa-8bd9-11ab41badc07', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '352abc9a-3a68-4358-adc7-fc5093b96bf3', '', '', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'aad47105-7def-4f21-99c6-9bdf35564fd3', 0, 3, NULL);
INSERT INTO `sys_models_associate` VALUES (5, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', 'b153efc9-7387-4e66-9cd9-fe8d9f8cf89a', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '352abc9a-3a68-4358-adc7-fc5093b96bf3', '', '', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', '98eb4b7f-783c-4c96-b3b4-f746efd5a966', 0, 4, NULL);
INSERT INTO `sys_models_associate` VALUES (6, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '24318cd9-97da-4fc8-b5f7-1ec755bb73f8', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', '352abc9a-3a68-4358-adc7-fc5093b96bf3', '', '', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', '98eb4b7f-783c-4c96-b3b4-f746efd5a966', 0, 5, NULL);
INSERT INTO `sys_models_associate` VALUES (7, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '135623ec-d171-49ad-b7ff-d827098926b4', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', '870c8f23-5cdb-4166-b9db-6bcfca01b405', '', '', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', '66f7ea13-f4d9-4038-9c01-1f49cbe074f3', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (8, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '02012cde-cccb-4575-b07a-8f24aaf4ea16', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', '870c8f23-5cdb-4166-b9db-6bcfca01b405', '', '', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', '66f7ea13-f4d9-4038-9c01-1f49cbe074f3', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (9, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '917d0d01-135a-4feb-b0dc-d308afa57a0e', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '161f3657-96b0-4a44-b872-92e42f446039', '66a1d422-0df7-44ec-8282-09b69bad5837', '', '', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '0fa0ab46-7b2a-4ca7-9767-e6b805ccaefd', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (10, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', 'ee9af462-8aef-4e28-b32b-4e400cb68a37', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '161f3657-96b0-4a44-b872-92e42f446039', '66a1d422-0df7-44ec-8282-09b69bad5837', '', '', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '0fa0ab46-7b2a-4ca7-9767-e6b805ccaefd', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (11, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsToMany', '7cac613f-2ec2-47de-a09d-cfde207d0612', '603a57cd-64c0-49bf-8019-05676ae6622f', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '43efd819-a9dc-4ed5-a9c1-cb6997d0b488', '603a57cd-64c0-49bf-8019-05676ae6622f', 'e71d5649-c9df-48b6-9c03-7cb8a470d953', 'c6f54355-e957-4f8c-93f8-c8357dd78088', '11e833b3-873f-4387-9aec-552913e07f4f', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (12, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsToMany', 'b8b83815-e809-4f0d-b253-9165f0407802', '603a57cd-64c0-49bf-8019-05676ae6622f', 'c6f54355-e957-4f8c-93f8-c8357dd78088', '11e833b3-873f-4387-9aec-552913e07f4f', '603a57cd-64c0-49bf-8019-05676ae6622f', '5bc2df53-43f0-4d58-bca0-d9abe9ce15d1', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '43efd819-a9dc-4ed5-a9c1-cb6997d0b488', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (13, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', 'e74ed060-226e-4b08-8bcb-68a93fd0c9da', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'dffec419-25af-4505-8214-8dcbb07726a4', '', '', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'fdc613ac-9f2f-4ac0-b81b-60f1400cb5bd', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (14, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', 'f80c3203-bb65-4396-8a68-464d36069ca2', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'dffec419-25af-4505-8214-8dcbb07726a4', '', '', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'fdc613ac-9f2f-4ac0-b81b-60f1400cb5bd', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (15, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasOne', 'faf5b78b-d0f9-419a-baa9-0e34b41e9340', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', 'e86401ba-85cb-47f7-9f53-853e26b939bd', '938fc47b-eeec-4095-974e-b77d0405f76a', 0, 2, NULL);
INSERT INTO `sys_models_associate` VALUES (16, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '324fa196-1e3d-408a-b085-79aa3ed18bdd', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', 'e86401ba-85cb-47f7-9f53-853e26b939bd', '938fc47b-eeec-4095-974e-b77d0405f76a', 0, 3, NULL);
INSERT INTO `sys_models_associate` VALUES (17, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasOne', '5a5fbce4-da0a-4238-83fd-6d76e4930521', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'f8e68c51-54f5-4db5-bf52-b84b053eb76c', 0, 4, NULL);
INSERT INTO `sys_models_associate` VALUES (18, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '3fa52464-4836-48ed-b3b4-453dea7bae73', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'f8e68c51-54f5-4db5-bf52-b84b053eb76c', 0, 5, NULL);
INSERT INTO `sys_models_associate` VALUES (19, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasOne', 'e35c6e34-55a5-470e-ae98-e2f2abc878b6', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', '4e0da60c-13af-4965-8f35-e2b13742398e', '428b44c7-3af7-4ec0-aca4-16544f0e2e2c', 0, 6, NULL);
INSERT INTO `sys_models_associate` VALUES (20, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', 'c74f0932-3e31-4afe-8997-5681e8798afc', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', '4e0da60c-13af-4965-8f35-e2b13742398e', '428b44c7-3af7-4ec0-aca4-16544f0e2e2c', 0, 7, NULL);
INSERT INTO `sys_models_associate` VALUES (21, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '4859d90f-a263-484c-9ae1-d89a4aa1cd15', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '43efd819-a9dc-4ed5-a9c1-cb6997d0b488', '', '', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '7717d475-5f9d-4472-b951-7610cdb35714', 0, 8, NULL);
INSERT INTO `sys_models_associate` VALUES (22, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', 'c317c40f-1a58-4ec3-a10e-03b08645db8d', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '440166cc-cf10-44af-b8b5-b51ad699ffb3', '43efd819-a9dc-4ed5-a9c1-cb6997d0b488', '', '', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '7717d475-5f9d-4472-b951-7610cdb35714', 0, 9, NULL);
INSERT INTO `sys_models_associate` VALUES (23, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', 'b79ab109-61c4-498b-8d06-ebf1d1141700', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', '1f1d61a4-492f-44af-820d-f97dfac5c4bb', '', '', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', '38f7732b-cea7-4881-9fde-9be7bbb591fe', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (24, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '719aba74-1d7e-4159-8f41-ffca51813b70', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', '1f1d61a4-492f-44af-820d-f97dfac5c4bb', '', '', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', '38f7732b-cea7-4881-9fde-9be7bbb591fe', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (25, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '4671d9b8-05ee-4a53-8de0-be8d03b93cd7', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', '710aacae-a6e4-498a-917e-abf54fb6ed70', 0, 2, NULL);
INSERT INTO `sys_models_associate` VALUES (26, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '62b8a5c0-543a-4d89-b9bf-a4455bccc562', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '', '', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', '710aacae-a6e4-498a-917e-abf54fb6ed70', 0, 3, NULL);
INSERT INTO `sys_models_associate` VALUES (27, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', 'b74a3a8d-fa53-46c4-8cff-9f56e4fa3363', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'e5cd5423-192f-4b07-9cf5-dbc4eb653cef', '', '', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', '2618f1a0-9801-4148-9964-87a782a30b58', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (28, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '58ca5aff-3a6d-48de-9e61-8c633b30d2ec', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'e5cd5423-192f-4b07-9cf5-dbc4eb653cef', '', '', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', '2618f1a0-9801-4148-9964-87a782a30b58', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (29, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '4ec81bef-ae2a-4242-a463-e9e21d36009b', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', '1f1d61a4-492f-44af-820d-f97dfac5c4bb', '', '', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', '0392493c-37c7-4368-aa5c-3ed8bdcf75b4', 0, 2, NULL);
INSERT INTO `sys_models_associate` VALUES (30, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', 'bda4aa8b-d59e-4305-8365-a06846cd3a89', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', '1f1d61a4-492f-44af-820d-f97dfac5c4bb', '', '', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', '0392493c-37c7-4368-aa5c-3ed8bdcf75b4', 0, 3, NULL);
INSERT INTO `sys_models_associate` VALUES (31, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'HasMany', '9754cee1-ebed-4f7f-afb9-971ac818a476', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', '79a3ba5d-e3d8-4e73-8607-bf5f795a5723', '', '', '53b2557e-7e75-4480-a97a-dd451b206f2e', '794d6903-d2ec-42ae-b034-77605dc0d035', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (32, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'BelongsTo', '661c95dc-dd29-451c-a0f5-6a162a7fc041', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', '79a3ba5d-e3d8-4e73-8607-bf5f795a5723', '', '', '53b2557e-7e75-4480-a97a-dd451b206f2e', '794d6903-d2ec-42ae-b034-77605dc0d035', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (33, '2025-01-06 14:42:13', '2025-01-06 14:44:53', 'HasMany', 'f3698eff-b85a-43f0-90a8-ee4232bff23b', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', '8ed11294-156d-4c66-96a8-6921c4f047dc', NULL, NULL, 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', '12aecd34-1cff-45fe-8085-8fe0af57e961', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (34, '2025-01-06 14:42:13', '2025-01-06 14:44:53', 'BelongsTo', '5df4d16c-44bb-4af5-a2ca-6908512897d4', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', '8ed11294-156d-4c66-96a8-6921c4f047dc', NULL, NULL, 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', '12aecd34-1cff-45fe-8085-8fe0af57e961', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (35, '2025-01-06 14:44:53', '2025-01-06 14:44:53', 'HasMany', '825aee65-430d-48c9-8e60-774558a0bcaf', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', '1f1d61a4-492f-44af-820d-f97dfac5c4bb', NULL, NULL, 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', '15e6f645-9074-44f6-8b1f-b2e56bcdeb3e', 0, 2, NULL);
INSERT INTO `sys_models_associate` VALUES (36, '2025-01-06 14:44:53', '2025-01-06 14:44:53', 'BelongsTo', '079db4c2-cda6-447f-998d-b89d5670dfbc', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', '1f1d61a4-492f-44af-820d-f97dfac5c4bb', NULL, NULL, 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', '15e6f645-9074-44f6-8b1f-b2e56bcdeb3e', 0, 3, NULL);
INSERT INTO `sys_models_associate` VALUES (41, '2025-01-15 02:47:10', '2025-01-21 11:08:32', 'BelongsToMany', '283a7149-5d70-45d2-8274-861117efb416', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', '77555168-0e71-44cd-a4e3-f9f83f9885d6', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'b435ea21-5ce1-463d-bbae-2a7cb4ce1631', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (42, '2025-01-15 02:47:10', '2025-01-21 11:08:32', 'BelongsToMany', '835c5611-cedd-4a68-9e43-87906b44c94b', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'db672817-1ca2-4e52-b3aa-2be3126aa8cb', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', '77555168-0e71-44cd-a4e3-f9f83f9885d6', 0, 1, NULL);
INSERT INTO `sys_models_associate` VALUES (43, '2025-01-20 17:13:50', '2025-01-21 11:08:32', 'HasMany', 'fec4075d-f2df-435d-ad8a-d715c78eb03c', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', NULL, NULL, '92e665fa-2592-4834-92b3-f4249f0f65bc', 'db672817-1ca2-4e52-b3aa-2be3126aa8cb', 0, 2, 'special_data2');
INSERT INTO `sys_models_associate` VALUES (44, '2025-01-20 17:13:50', '2025-01-21 11:08:32', 'BelongsTo', '3619ee42-991e-45b6-8906-d9c92ebb0abb', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', '648bf1c2-37ef-49f5-9888-8a74667cc2b6', NULL, NULL, '92e665fa-2592-4834-92b3-f4249f0f65bc', 'db672817-1ca2-4e52-b3aa-2be3126aa8cb', 0, 3, 'cms_doc2');
INSERT INTO `sys_models_associate` VALUES (45, '2025-02-06 19:13:33', '2025-02-06 19:13:33', 'HasMany', 'c11ed2ba-91ff-404c-b716-364145ba98ba', '09023791-7045-4e86-b4da-6ac0072ef574', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'b900e935-c736-4202-974e-6d4fcf8644a7', NULL, NULL, '09023791-7045-4e86-b4da-6ac0072ef574', 'd66b38ec-ce4f-4691-bc07-76d78afd93df', 0, 0, NULL);
INSERT INTO `sys_models_associate` VALUES (46, '2025-02-06 19:13:33', '2025-02-06 19:13:33', 'BelongsTo', 'ffd0c2b9-6c4c-4afe-8d18-8770ed0f0b18', '09023791-7045-4e86-b4da-6ac0072ef574', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'b900e935-c736-4202-974e-6d4fcf8644a7', NULL, NULL, '09023791-7045-4e86-b4da-6ac0072ef574', 'd66b38ec-ce4f-4691-bc07-76d78afd93df', 0, 1, NULL);

-- ----------------------------
-- Table structure for sys_models_fields
-- ----------------------------
DROP TABLE IF EXISTS `sys_models_fields`;
CREATE TABLE `sys_models_fields`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `models_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '关联sys_models的uuid',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段名',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字段说明',
  `type` enum('STRING','TEXT','BOOLEAN','INTEGER','BIGINT','FLOAT','DOUBLE','DECIMAL','ENUM','DATE','DATEONLY','UUID','JSON') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '字段类型',
  `enumValue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '枚举值',
  `uuidtype` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'uuid类型',
  `booleantype` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'BOOLEAN类型',
  `defaultValue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '默认值',
  `lengths` int(11) NULL DEFAULT NULL COMMENT '长度',
  `point` int(11) NULL DEFAULT NULL COMMENT '小数点',
  `primaryKey` tinyint(1) NULL DEFAULT 0 COMMENT '主键',
  `defaulttonow` tinyint(1) NULL DEFAULT 0 COMMENT '默认当前时间',
  `allowNull` tinyint(1) NULL DEFAULT 0 COMMENT '必填',
  `where` tinyint(1) NULL DEFAULT 1 COMMENT '查询',
  `add` tinyint(1) NULL DEFAULT 1 COMMENT '添加',
  `edit` tinyint(1) NULL DEFAULT 1 COMMENT '编辑',
  `autoIncrement` tinyint(1) NULL DEFAULT 0 COMMENT '自动递增',
  `unsigned` tinyint(1) NULL DEFAULT 0 COMMENT '无符号',
  `zerofill` tinyint(1) NULL DEFAULT 0 COMMENT '零填充',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `createdAt` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_models_fields_uuid`(`uuid`) USING BTREE,
  INDEX `sys_models_fields_models_uuid_name`(`models_uuid`, `name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 327 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_models_fields
-- ----------------------------
INSERT INTO `sys_models_fields` VALUES (1, '352abc9a-3a68-4358-adc7-fc5093b96bf3', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', 'true', 'hjkhklhkj', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (2, '3f06979a-a244-477f-bba7-876525e8631c', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'name', '模型名称', 'STRING', '', '', '', '', 50, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (3, 'caf99fa5-ceca-4a2d-a53d-9549481a1e60', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'desc', '模型说明', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (4, '28b49b08-d219-4cdc-857b-9b4bfcfee083', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'oldName', '改变后的模型名称', 'STRING', '', '', '', '', 50, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (5, 'd28b7e96-f33b-4a7e-837d-26ac67a708c1', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'paranoid', '偏执表', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (6, '8ba0e0dc-6f95-4018-bd6a-31e846c08168', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'uuid', 'uuid', 'UUID', 'STRING', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-25 10:25:21');
INSERT INTO `sys_models_fields` VALUES (7, '1cb0cd12-fdb3-4549-96ce-0e4faf8b4a01', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'models_uuid', '关联sys_models的uuid', 'UUID', 'STRING', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-25 10:25:21');
INSERT INTO `sys_models_fields` VALUES (8, 'd27f4186-21c7-42fe-ae2f-206997c1d1ac', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'name', '字段名', 'STRING', 'STRING', '', '', '', 50, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-25 10:25:21');
INSERT INTO `sys_models_fields` VALUES (9, '8928c1fe-42a7-4a0d-a791-982dc729e88d', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'comment', '字段说明', 'STRING', 'STRING', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-25 10:25:21');
INSERT INTO `sys_models_fields` VALUES (10, '4922d37e-34c0-4230-80c2-51d93cf1ea6d', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'type', '字段类型', 'ENUM', 'STRING\nTEXT\nBOOLEAN\nINTEGER\nBIGINT\nFLOAT\nDOUBLE\nDECIMAL\nENUM\nDATE\nDATEONLY\nUUID\nJSON', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (11, '50da994c-94c7-4413-a2c8-17826d0e655a', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'enumValue', '枚举值', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (12, '5e3baebe-2e84-44df-8a2f-1d17dae79343', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'uuidtype', 'uuid类型', 'STRING', '', '', '', '', 50, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (13, '479494ab-884d-4513-a100-5520f5307a21', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'booleantype', 'BOOLEAN类型', 'STRING', '', '', '', '', 50, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (14, '4de145f7-71df-4b15-9f84-1bf924d43fa7', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'defaultValue', '默认值', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (15, 'ad93f0ed-5036-47a5-9062-2784669c05fd', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'lengths', '长度', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (16, 'cd4bcf09-7197-4eef-9341-1c1518d0815d', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'point', '小数点', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 11, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (17, 'cef4b042-191b-4298-9fae-3f2789044f16', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'primaryKey', '主键', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 12, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (18, '46495752-0c35-4c73-bcc4-cd21beea84ec', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'defaulttonow', '默认当前时间', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 13, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (19, 'c701ac22-cfb9-483f-9be4-7e0545e0e755', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'allowNull', '必填', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 14, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (20, '8d84e287-ac1d-4077-bb03-8acd2b8da968', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'where', '查询', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 15, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (21, 'c1c32bca-4c98-48e6-83c4-d4305ecabde9', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'add', '添加', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 16, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (22, '9cee790d-2cc6-4a58-9c75-01a13dc2c5a4', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'edit', '编辑', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 17, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (23, 'be3ffe92-2b67-4792-993f-1f1f776034bd', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'autoIncrement', '自动递增', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 18, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (24, '3a67375f-fb7d-4fb7-85b3-03dc373397c7', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'unsigned', '无符号', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 19, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (25, '5abc5e41-cf59-40e0-9876-d2b4f201346f', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'zerofill', '零填充', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 20, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (26, '3bc0fc62-3862-4280-b13d-66cb307f0f35', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'sort', '排序', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 21, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (27, '3f5379a9-dc39-4e94-ae0d-293a7174810c', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'username', '用户名', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (28, 'd052e3ba-8478-4cd9-9748-092f61f5c2ea', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'password', '密码', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (29, '1f46c57f-98e5-40ed-a054-c2c7a4f93087', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'email', '邮箱', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (30, 'ba961c9a-1158-438f-9118-c6a21961deff', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'mobile', '手机号', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (31, 'ace45352-7c85-4018-8283-8e4b3fc215d8', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'state', '状态false禁用true正常', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (32, '0fa0ab46-7b2a-4ca7-9767-e6b805ccaefd', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'group_uuid', '组织id', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (33, '0caf3a1b-bd7e-436f-a149-1f627e521390', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'admin', '系统管理员', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (34, '10f1962f-14f4-428c-8dcc-9c2960cdb672', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (35, '4a9e9b88-b9a9-41e0-9ef0-f4e6d1630295', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (36, '197a93b2-9d26-46c9-8903-00b45c01fa74', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (37, 'a2eb767c-eb92-4570-9fe1-9848e984e921', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (38, 'f6e98f30-19b8-4712-be01-67dba2bef4be', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (39, '6ecd6c32-a676-41b5-90a1-76efd89f56fd', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (40, 'af4964f4-4fa7-4939-8b52-477d9d7d8135', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-25 10:25:21');
INSERT INTO `sys_models_fields` VALUES (41, '2c54a6d1-fdbb-4231-9603-407ce9d412c6', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 22, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (42, '3e837249-cea6-4255-89e2-c26b6d4ffd0c', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 23, '2024-11-01 14:17:42', '2024-11-25 10:25:22');
INSERT INTO `sys_models_fields` VALUES (43, '08587797-0f85-4eab-9dab-156cc4f3d471', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (44, '38a88620-2826-4848-9b41-510ac4f9d934', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (45, 'd8c90399-8ed1-4380-b9a8-7e518980748c', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (46, 'de27163e-58e9-4f07-865a-473784c4d4e7', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (47, 'aad47105-7def-4f21-99c6-9bdf35564fd3', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'models_uuid', '关联模型uuid', 'UUID', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (48, '4a6877b1-3930-4d0e-b04b-2e46c58f1d73', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'unique', '唯一', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (49, 'a40fb0bd-7c70-45e8-9951-3d37ce48f8e7', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'fields', '索引字段', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (50, '48c57a35-5668-4c8b-8a94-72319b171023', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 'sort', '排序', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (51, 'bca90cf5-5031-43db-86f0-d031c4b8b4ed', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (52, 'fec99159-9ab1-40d0-8df2-e90ab4f36337', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (53, '8ec961d3-fa59-4502-ad6d-7bf9a4448be6', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (54, 'd2fc23c9-3156-488e-a897-02af979df5fc', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'type', '关联类型', 'ENUM', 'HasOne\nBelongsTo\nHasMany\nBelongsToMany', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (55, 'aa901e67-c8c6-4fcc-a153-9a8d5d3bd677', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 4, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (56, '98eb4b7f-783c-4c96-b3b4-f746efd5a966', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'models_uuid', 'models_uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (57, '45cc7509-f57c-414c-902e-c38528a30b05', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'parent_uuid', '父表', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (58, 'd8b15aef-39f8-4754-bd8b-7cd3de1ba886', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'through_uuid', '中间表', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (59, '8c87d9c9-38f2-4ecc-8ec7-7fc088d4343c', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'child_uuid', '子表', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (60, 'b5d8409e-c169-4e72-b2b4-54c7a96ca405', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'targetKey', '父键', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (61, '0180e390-258d-423c-9355-fdfac30fe959', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'foreignKey', '子键', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 11, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (62, '53007e0c-c953-41e4-8c14-13adbb142d45', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'constraints', '约束', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 13, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (63, '2cc0754b-0589-4cd7-9a83-e86526324f2b', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'sort', '排序', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 14, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (64, '1205dace-1645-41c7-8ceb-b60d0b2ae34d', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (65, 'f36e1a2c-ccb4-40b6-9532-a84b580379d0', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (66, 'e1b087bd-7831-4f92-8c69-1bc9d92db511', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (67, '361afe62-918e-4a44-bc61-78d8eb63632a', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (68, '4a8490e1-98b1-4304-82a5-621dbe80b340', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (69, 'a5c34247-5e29-4e1e-9967-b97f57cf2939', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (70, '66bc6b1c-cbcc-49d8-b8cb-8fc457d64da4', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'name', '分类名称', 'STRING', '', '', '', '', 20, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (71, '870c8f23-5cdb-4166-b9db-6bcfca01b405', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (72, 'cc59d62a-0635-4731-9eda-9ce4174bf710', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'middleware', '在 Router 里面可以配置多个 Middleware', 'STRING', '', '', '', '', 1000, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (73, '7dd38cb0-90e4-424f-bcdc-40ae864f6f44', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'remarks', '备注', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (74, '70ba4ed8-cc3e-4e65-a566-ad3b2ff8eb76', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'sort', '越小越靠前', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (75, '5c94f2c0-c3af-448f-aef6-3b2f48ef166d', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 'sys', '是否系统', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (76, 'ee0fab53-587c-45af-b650-7440138c03a4', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (77, '2756d89d-96ac-44b2-a045-9239b6885d09', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'name', '名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (78, '5eaacd09-4575-4fa5-b4fc-381d9f84764b', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'path', '路由 URL 路径', 'STRING', '', '', '', '空字符串', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (79, '6c095d0a-dbe7-4afa-92bd-229ecae8d072', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'icon', '配置菜单的图标', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (80, 'effa6f8b-6ed1-483c-a61c-34b20e4f1a99', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'verb', '用户触发动作，支持 get，post 等所有 HTTP 方法', 'ENUM', 'head\noptions\nget\nput\npost\npatch\ndel\nredirect\nresources', '', '', 'get', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (81, '898214e3-3502-4e99-98eb-9172f470201b', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'middleware', '在 Router 里面可以配置多个 Middleware', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (82, 'eb1cfa94-1d82-41fb-92bb-a56eec1d4865', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'ignoreMiddleware', '排除模块统一设置的middleware', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (83, 'c60a826c-675a-4af1-8094-b61573e1b2ce', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'controller', '控制器', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (84, 'f0d1ee2d-7f6a-44ae-9553-6fc4174c77fa', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'action', '控制器方法', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 11, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (85, '6254d0e8-4ae6-4f05-9146-1704cb8debfb', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'admin', '控制器/页面', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 12, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (86, '8d609825-d311-43d2-932c-fa17efed888b', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'role', '是否为角色权限节点', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 13, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (87, '66f7ea13-f4d9-4038-9c01-1f49cbe074f3', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'class_uuid', '关联classify的uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 14, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (88, '9f232701-4b5d-4b2c-9d50-991f42bac8ad', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'puuid', '路由父uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 15, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (89, '703dfae2-e02c-49f8-b68c-55b7c00f504a', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'sort', '排序', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 16, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (90, '7fda5436-6ff1-4f01-b12e-98bd97089861', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'linkType', '链接类型', 'ENUM', 'schemaApi\nlink', '', '', 'schemaApi', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 17, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (91, '20bea8cf-5d1e-4da9-a04f-4a8f5be7ee55', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'link', '页面地址', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 18, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (92, '0c00b894-7fec-4643-8356-9656d9fc23d8', '161f3657-96b0-4a44-b872-92e42f446039', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (93, '9d2c9528-173b-4dfb-99c5-433555ec0392', '161f3657-96b0-4a44-b872-92e42f446039', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (94, '934ed99d-6384-4536-bc4b-8e593d287b69', '161f3657-96b0-4a44-b872-92e42f446039', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (95, '6a389e3d-537d-46b8-b30f-506e042a473d', '161f3657-96b0-4a44-b872-92e42f446039', 'name', '分组名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (96, '66a1d422-0df7-44ec-8282-09b69bad5837', '161f3657-96b0-4a44-b872-92e42f446039', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (97, '9fbdf2f6-db95-4835-be61-d0f9033e2a10', '161f3657-96b0-4a44-b872-92e42f446039', 'desc', '分组说明', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (98, '02ad96b8-990b-468b-b3bd-c7ef444b0638', '161f3657-96b0-4a44-b872-92e42f446039', 'puuid', '父uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (99, '71672ccb-b5fd-4bcc-96af-7b264ef2920a', '161f3657-96b0-4a44-b872-92e42f446039', 'sort', '排序', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (100, 'c02f1930-e09e-418e-a658-ba00bbfa2f54', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (101, '7c574dca-e951-47a8-b934-ff49181d7cc3', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (102, 'f7195e35-3649-4f81-9fc3-db1b592c50cc', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (103, 'c3fdaa14-632a-4111-bb4e-99ead88d3028', '603a57cd-64c0-49bf-8019-05676ae6622f', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (104, 'e3574cd3-fa1c-473a-ac52-b9809d5d94b7', '603a57cd-64c0-49bf-8019-05676ae6622f', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (105, 'c4d96145-b380-4e74-8c9d-ce48ddd50d9f', '603a57cd-64c0-49bf-8019-05676ae6622f', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (106, 'ae19e125-9181-4080-83ed-844099b37e22', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'name', '角色名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (107, '11e833b3-873f-4387-9aec-552913e07f4f', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (108, '4a1e8424-015e-42e1-ad43-259f79cd1a3a', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'desc', '角色说明', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (109, 'edb0ee22-0998-4d51-b364-51be6dfbcc67', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'r_uuids', '路由节点', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (110, 'a48b10e7-b963-430f-be6a-c36c3246ce85', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'g_uuids', 'graphql节点', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (111, '99343dd9-7bd8-4975-ad49-748dde241850', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 'state', '状态', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (112, '5bc2df53-43f0-4d58-bca0-d9abe9ce15d1', '603a57cd-64c0-49bf-8019-05676ae6622f', 'role_uuid', '角色uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (113, 'e71d5649-c9df-48b6-9c03-7cb8a470d953', '603a57cd-64c0-49bf-8019-05676ae6622f', 'user_uuid', '用户uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (114, '43efd819-a9dc-4ed5-a9c1-cb6997d0b488', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (115, '506883c7-3c15-4a15-84ba-946ccf435f22', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'throughKey', '中间键', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (116, 'ca8d2436-8f83-409b-9566-cae090053dce', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (117, '33368ff6-086f-4b35-86b7-1339d3989092', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (118, '190f99a2-af6b-4f07-a110-1b95f2a0a24e', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (119, '0e0ab960-4e59-4081-8e70-83f29ed3f1dc', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 'open_uuids', '开放接口节点', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (120, '4d59ff4f-b57a-4e06-8df6-1d33d9b792b3', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (121, '648bf1c2-37ef-49f5-9888-8a74667cc2b6', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-25 10:00:38');
INSERT INTO `sys_models_fields` VALUES (122, 'fbeae93e-b96f-4fbb-beaf-af00a9179667', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-25 10:00:38');
INSERT INTO `sys_models_fields` VALUES (123, '80b4a6de-f8fd-4488-974b-aafbb5bd89cf', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-25 10:00:38');
INSERT INTO `sys_models_fields` VALUES (124, '7717d475-5f9d-4472-b951-7610cdb35714', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'user_uuid', '作者uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (125, 'ec2e3d64-1b70-4555-94c0-507d0cd79090', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'title', '内容标题', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (126, 'fdc613ac-9f2f-4ac0-b81b-60f1400cb5bd', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'classify_id', '分类ID', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (127, '65676e29-8371-4276-9c99-b4d780a7c036', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'classify_sub', '子分类', 'JSON', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (128, '91d32c08-e059-4170-bf2d-5d6c8cff1273', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'description', '描述', 'STRING', '', '', '', '', 1000, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (129, '3a42ef33-2502-4397-adb5-ebfc49b39cab', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'root', '根节点', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (130, 'd35f5fea-2e83-41c6-b9bb-ecb9f70de225', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'pid', '所属ID', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (131, '4fd1820b-0e1c-48aa-8e54-736b14fbd899', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'models_uuid', '模型UUID', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (132, 'be5511cc-4aa8-46fb-b9ac-ff8ee9333dc6', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'type', '内容类型（1-目录，2-主题，3-段落）', 'INTEGER', '', '', '', '2', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 11, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (133, '6d55220b-5a49-4d81-9a70-28431f8a4394', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'position', '推荐位(1-列表推荐，2-频道页推荐，4-首页推荐）', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 12, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (134, '1dc99159-5242-428f-992d-24d482fd75d3', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'ext_link', '如果填写链接,会跳转到这个链接,不填不跳转', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 13, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (135, '0ea9a8c3-cb9f-43fc-a35f-717f5239bdef', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'cover_url', '封面', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 14, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (136, '405cabf0-46dc-405a-af5f-7bb7dd725f95', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'display', '可见性', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 15, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (137, '6ffc4763-1ffb-4cef-82e4-fc602d171607', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'deadline', '截止时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 16, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (138, '9436ee08-210a-489b-b168-6b4607695cec', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'view', '浏览量', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 17, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (139, '1cde64fd-1247-4ad8-b59e-59dff36d1099', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'level', '优先级（越高排序越靠前）', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 18, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (140, '392ea8e4-35e2-4cd6-863b-315fb9dcf808', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'status', '数据状态（0-禁用，1-正常，2-待审核，3-草稿）', 'INTEGER', '', '', '', '1', 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 19, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (141, 'dffec419-25af-4505-8214-8dcbb07726a4', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (142, '40c4ec8a-15af-4277-8dbe-f8f9aedc8521', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (143, 'a646230e-0a4a-4f4c-be20-c7640f441a66', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (144, '0e1905f1-4fb3-4f00-8496-8063f11682f8', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'name', '标识', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (145, '9a0946b8-00a4-466b-ab59-87b395ccc6f7', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'title', '标题', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (146, '1003d9ac-82c3-4cd8-8d14-372b5a0360ac', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'pid', '上级分类ID', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (147, '15f7c362-049d-4ac4-a414-9692316159c6', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'sort', '排序（同级有效）', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (148, '7261e63d-2397-492d-9266-7167072324a0', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'list_row', '列表每页行数', 'INTEGER', '', '', '', '15', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (149, '3b2915f3-779f-4096-8c7c-51bcb08cec53', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'meta_title', 'SEO的网页标题', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (150, '688b3a5e-b3f1-4f0e-b539-846ce617c279', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'keywords', '关键字', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (151, '7fab317f-06a3-4bfd-91d0-83c42d554130', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'description', '描述', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (152, '429a4e2e-99e6-4ca6-b53d-d1ea03b85fe1', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'template_index', '频道页模板', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 11, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (153, 'b1cb4343-26a9-4f31-bce5-4685bfa31ac7', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'template_lists', '列表页模板', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 12, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (154, '0b1456a8-0e03-431c-8a25-9d585fa9374f', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'template_detail', '详情页模板', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 13, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (155, 'b3a0acb7-df6c-406a-9b16-f3636ac15eeb', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'models_uuid', '关联模型UUID', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 14, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (156, '79ed22db-985e-4259-bf5f-2e87cc1d2291', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'type', '允许发布的内容类型', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 15, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (157, 'ff1ca958-7d17-41b8-88b8-842db2199420', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'allow_publish', '是否允许发布内容', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 16, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (158, '796f62ab-852c-458d-889e-233ee0caf6d2', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'display', '可见性', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 17, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (159, '5d0ce5d1-ee7a-42b3-a2ce-090ab0b8f9c2', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'reply', '是否允许回复', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 18, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (160, '1224c706-e11b-4787-8dea-10a0d1e83644', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'check', '发布的文章是否需要审核', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 19, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (161, 'd40e526a-24cf-43cf-8b2e-4ecda4a9bc41', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'sub', '子分类', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 20, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (162, 'c39836ad-96a8-44c9-a41a-c6e4e9494e6a', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'status', '状态', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 21, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (163, '5e902fcf-4fe8-41e7-8306-2b183faf4ed6', 'a73f9f46-bcb7-4816-a2b8-f12d9082721b', 'icon', '分类图片', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 22, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (164, '3f8478b9-3da6-4ce1-a381-5e88d8b20d40', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-25 10:01:24');
INSERT INTO `sys_models_fields` VALUES (165, 'e3b63cca-5eee-4431-9012-0cad847624b5', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-25 10:01:24');
INSERT INTO `sys_models_fields` VALUES (166, '61b3a90e-4b31-46fd-a410-52aa199451b8', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-25 10:01:24');
INSERT INTO `sys_models_fields` VALUES (167, '938fc47b-eeec-4095-974e-b77d0405f76a', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'doc_id', '主表id', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-25 10:01:24');
INSERT INTO `sys_models_fields` VALUES (168, 'ccebdea8-e6c0-4462-b375-51b3aaa52045', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'content', '文章内容', 'TEXT', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-25 10:01:24');
INSERT INTO `sys_models_fields` VALUES (169, '79fd2eb6-6049-489a-98c5-f6fd914ffdda', '4e0da60c-13af-4965-8f35-e2b13742398e', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-21 14:42:40');
INSERT INTO `sys_models_fields` VALUES (170, 'a9b3850f-7586-49f4-98cc-531ca27018af', '4e0da60c-13af-4965-8f35-e2b13742398e', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-21 14:42:40');
INSERT INTO `sys_models_fields` VALUES (171, 'a988ce25-cb3e-462f-9034-596b4d13d7e7', '4e0da60c-13af-4965-8f35-e2b13742398e', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-21 14:42:40');
INSERT INTO `sys_models_fields` VALUES (172, '428b44c7-3af7-4ec0-aca4-16544f0e2e2c', '4e0da60c-13af-4965-8f35-e2b13742398e', 'doc_id', '主表id', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-21 14:42:40');
INSERT INTO `sys_models_fields` VALUES (173, '2cd026cc-cd34-47fc-9be4-a2d054777421', '4e0da60c-13af-4965-8f35-e2b13742398e', 'content', '图片内容', 'JSON', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-21 14:42:40');
INSERT INTO `sys_models_fields` VALUES (174, 'f01ae6fc-5490-4c90-b10e-4ee9086ce5ac', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-21 15:36:01');
INSERT INTO `sys_models_fields` VALUES (175, '31c2813f-7db7-4c7c-b38a-ec0dd65c2481', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-21 15:36:01');
INSERT INTO `sys_models_fields` VALUES (176, 'a24a9042-8309-495c-af0a-ecf0a1da1518', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-21 15:36:01');
INSERT INTO `sys_models_fields` VALUES (177, 'f8e68c51-54f5-4db5-bf52-b84b053eb76c', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'doc_id', '主表id', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-21 15:36:01');
INSERT INTO `sys_models_fields` VALUES (178, 'c22c64f0-2d19-46fa-bab3-9000ca7e4e1f', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'content', '下载内容', 'JSON', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-21 15:36:01');
INSERT INTO `sys_models_fields` VALUES (179, 'f5434b81-2901-4311-89a3-d1cb2d96b002', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (180, 'f402f35f-e861-4ec1-a4d2-46a072001fe6', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (181, '87ccc5a3-bb12-48c3-9a00-8127f62618c1', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (182, 'c1d7e791-4816-4911-a11b-35c77f892919', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'pid', '上级导航ID', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (183, '40c95ea3-8860-4ec5-aa27-20a099cb1e81', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'title', '导航标题', 'STRING', '', '', '', '', 30, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (184, '4c25d575-c819-4c0a-9ac8-59bd0072ec77', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'url', '导航链接', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (185, '6a198de9-4641-4b2e-a293-96cfbd98644f', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'sort', '排序', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (186, '18f87f8d-b7b3-4a32-ac65-fcf18afdc950', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'target', '是否新窗口打开', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (187, '56fce0ad-af0e-4f24-a879-b10771680be2', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'status', '状态', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (188, '63f10648-cfe1-49f6-b612-d407ee1d3928', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'template', '模板详情', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 20, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (189, 'c74cb193-7f76-4315-b2e3-5837ff51897d', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 'desc', '下载介绍', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-21 15:36:01');
INSERT INTO `sys_models_fields` VALUES (190, '8adf75f7-a2d2-4799-9296-82797677b8ca', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (191, '86232a92-e2a2-42fa-ae67-1e8843e9feca', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (192, '685feec1-4e19-49f5-999f-9f91f43f1d65', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (193, '2c58c8a1-d78b-4bd1-978e-b06a5a106286', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'username', '用户名', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (194, '5a42b88a-28c3-4fbd-a0ef-a718632ef350', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'password', '密码', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (195, '710c87a3-f49e-4881-b8dd-3abe9f32261c', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'email', '邮箱', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (196, '149f41d0-a665-4664-b321-f7c818043729', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'mobile', '手机', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (197, '38c3ba68-4abc-4083-9ca1-b2e2cbfdff53', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'state', '状态', 'BOOLEAN', '', '', 'true', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (198, '1f1d61a4-492f-44af-820d-f97dfac5c4bb', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'uuid', 'UUid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-12-30 09:51:47');
INSERT INTO `sys_models_fields` VALUES (199, '2553efbc-0797-4593-babb-4fe326e1726a', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'third', '第三方扩展', 'JSON', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-12-30 09:51:48');
INSERT INTO `sys_models_fields` VALUES (200, '0e45b0dd-535f-4c5e-885e-f610581211ad', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'avatar', '头像', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-12-30 09:51:48');
INSERT INTO `sys_models_fields` VALUES (201, 'e5cd5423-192f-4b07-9cf5-dbc4eb653cef', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-25 09:57:35');
INSERT INTO `sys_models_fields` VALUES (202, '2a975afc-b7b5-49d2-a5aa-7d914309867d', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-25 09:57:35');
INSERT INTO `sys_models_fields` VALUES (203, '3e5c6cfb-9c16-4aab-9687-7645715f10d5', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-25 09:57:35');
INSERT INTO `sys_models_fields` VALUES (204, 'cdb06630-5a71-4bd6-b3e2-e1c4737ed68c', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'content', '内容', 'TEXT', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-25 09:57:35');
INSERT INTO `sys_models_fields` VALUES (205, '38f7732b-cea7-4881-9fde-9be7bbb591fe', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'member_uuid', '用户关联uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-25 09:57:35');
INSERT INTO `sys_models_fields` VALUES (206, '710aacae-a6e4-498a-917e-abf54fb6ed70', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 'doc_id', '文档关联id', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-25 09:57:35');
INSERT INTO `sys_models_fields` VALUES (207, '558f01ea-7826-40e4-adad-1082e2471785', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-25 09:58:07');
INSERT INTO `sys_models_fields` VALUES (208, '28a23daa-cdc1-4db8-b6e4-7e2a6a13e445', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-25 09:58:07');
INSERT INTO `sys_models_fields` VALUES (209, '4ae68fb5-9537-46cc-8ab2-b4e389295bea', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-25 09:58:07');
INSERT INTO `sys_models_fields` VALUES (210, 'd3e0a035-8695-4586-96b2-8ffd75fe8c0c', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'content', '回复内容', 'TEXT', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-25 09:58:07');
INSERT INTO `sys_models_fields` VALUES (211, '2618f1a0-9801-4148-9964-87a782a30b58', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'comments_id', '评论关联id', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-25 09:58:07');
INSERT INTO `sys_models_fields` VALUES (212, '0392493c-37c7-4368-aa5c-3ed8bdcf75b4', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 'member_uuid', '用户关联uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-25 09:58:07');
INSERT INTO `sys_models_fields` VALUES (213, 'cf8ea282-2ba5-48e8-9c34-fdda28414a8b', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'tags', '标签', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 21, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (214, '2e3d2392-1793-442d-a8f0-6528efee65f3', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 'sort', '排序同级有效越小越靠前', 'INTEGER', '', '', '', '0', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 22, '2024-11-01 14:17:42', '2024-11-25 10:00:39');
INSERT INTO `sys_models_fields` VALUES (215, 'f52730d3-e2d9-44c1-8db7-c681c3f27d80', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (216, '8ca08b74-dab4-4e7c-af70-33f1b4b3b992', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (217, '055c602a-9c6d-4fbe-b909-e030d14ba9a4', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (218, 'ac50e1a4-ae4b-48c2-8d0f-fbdc65c3dc10', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'name', '模板名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (219, 'c4421b48-ed5c-40fc-83d0-9d248f085a91', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'path', '模板目录', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (220, 'dab2019d-be18-445e-aa7b-8f9e2ae94697', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'author', '作者', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (221, 'ef69db62-a170-46eb-a914-c2940af130d1', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'sys', '系统模板', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (222, 'a776374d-a152-4582-ae3c-43f6de8ab34e', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'isu', '正在使用', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (223, '79a3ba5d-e3d8-4e73-8607-bf5f795a5723', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'uuid', 'uuid', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (224, '0edda2c7-6630-4ca2-9982-bd18f10306ae', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 'version', '版本号', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (225, 'c177eeb5-1545-4c0f-8814-beda0d6710da', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (226, '4e1173ce-85a4-4291-acd4-f53901d52337', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (227, 'ec3d0c68-c8ca-4b1b-bd5a-d6dea468d67f', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (228, '794d6903-d2ec-42ae-b034-77605dc0d035', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'template_uuid', '模板UUID', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (229, '605eb3d3-d777-4a9c-9dff-04021d33c557', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'title', '模板名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (230, '6d4a1a9c-1aed-4337-be2e-3764da4d6ed1', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'type', '类型', 'STRING', '', '', '', 'index', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (231, '8f894586-1320-4155-aab0-541bb2f25ffa', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'name', '文件名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (232, 'f116e258-ca4d-42b9-86d5-999e5b0d6c63', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'isd', '是否默认', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (233, '4516c690-e7dd-4dea-b1a3-9fccd111cfaa', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'isu', '使用中', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (234, 'ac63efc4-feac-4aac-9983-3bcb62ec16e2', '53b2557e-7e75-4480-a97a-dd451b206f2e', 'uuid', 'UUID', 'UUID', '', 'UUIDV4', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (235, '2c98667b-5f26-4d87-95db-0ca08a577e23', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'is_menu', '是否是菜单', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 19, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (236, 'df03ee3a-9402-454a-9392-51234a5c342c', '12595142-74b1-40c3-ab20-b76ea941bcfa', 'type', '位置类型', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-25 10:09:30');
INSERT INTO `sys_models_fields` VALUES (237, '93c72c02-03d1-4cdb-a7c8-3229d6164115', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (238, '592cfa59-20f3-4bc7-9881-7a5a3a166c45', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (239, 'b82595cc-3c62-4735-89ba-d57e96d035df', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (240, '2d8fb9e1-ddc0-46e0-a0d1-29a15c49221d', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'name', '应用标识', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (241, '417f3edd-f3dd-487d-9e4c-a1092947e70b', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'title', '应用名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (242, '948321e3-5227-4930-8283-2d4620fb54d7', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'intro', 'intro', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (243, 'ef1c782e-f723-433f-8ffa-928209ee07ea', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'explain', '说明', 'TEXT', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (244, '55857f33-228c-4f79-bebd-74c98eb5037c', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'author', '作者', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 7, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (245, '582deb0d-71d7-423b-b8d7-8e725b90e758', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'version', '版本', 'STRING', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (246, 'dcf10ba7-3cab-46e2-acd8-c65083185922', '8940f820-eb65-41e6-af3e-e958ac77edd7', 'sys', '是否系统', 'BOOLEAN', '', '', 'false', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (247, '73f3ab14-6c3e-4583-af5c-e00a6d0e71d6', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 'app', '所属应用', 'STRING', '', '', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (248, '08d5b377-e0b2-4a7b-8dd7-442097401af7', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (249, 'bdbe86b8-290a-4d9f-bea8-a16ceafb781c', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (250, '223a84dc-05e8-4709-89a1-d54c9560445d', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (251, '70b5c4da-6eca-4c3f-aa2c-b67c99df60e7', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'name', '配置key', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (252, '11af8e16-fe5d-4f76-927d-ff4960d1a7a0', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'label', '配置名称', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (253, 'b4cf1497-e351-4de4-b09b-34d5881c374a', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 'value', '配置value', 'JSON', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-11-01 14:17:42');
INSERT INTO `sys_models_fields` VALUES (254, '51ae3cf2-d880-414e-94ab-d361337b5961', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 'app', '应用标识', 'STRING', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 20, '2024-11-01 14:17:42', '2024-12-26 16:37:21');
INSERT INTO `sys_models_fields` VALUES (255, 'b582d81f-93af-4232-af8f-69a0b28670f3', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 'content_type', '文章内容类型(html|amis)', 'ENUM', 'html\namis', '', '', 'html', 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 4, '2024-11-01 14:17:42', '2024-11-25 10:01:24');
INSERT INTO `sys_models_fields` VALUES (256, 'aed97a74-e930-4af9-8588-01669f840643', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'id', '主键', 'INTEGER', '', '', '', '', 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (257, '7b3757bc-52b0-40ba-b772-1e3c54c9b992', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'createdAt', '创建时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (258, '44eab3eb-f280-47b2-8f18-a0498eb604a8', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'updatedAt', '更新时间', 'DATE', '', '', '', '', 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (259, '1c853747-efa7-4d68-ac4a-dd7a893adc82', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'name', '文件名字', 'STRING', '', '', '', '', 50, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (260, '5a5aa0a6-36cb-4149-818d-ed50ef7e8243', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'description', '附件描述', 'STRING', '', '', '', '', 100, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (261, 'eaebffbf-b4fe-4dd6-87b3-47bbf26f4b45', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'path', '文件存储地址', 'STRING', '', '', '', '', 200, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (262, '087fddce-0285-4531-99ff-faab263c366d', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'url', '文件网络地址', 'STRING', '', '', '', '', 300, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 6, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (263, '2935f89b-5bc0-44bd-ad1d-02790400f6c9', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'size', '文件大小(kb)', 'INTEGER', '', '', '', '', 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 7, '2024-11-01 14:17:42', '2024-12-27 14:55:41');
INSERT INTO `sys_models_fields` VALUES (264, 'ad6ed725-31f4-4a97-877d-2dd91843e455', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'mime', '文件类型', 'STRING', '', '', '', '空字符串', 150, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-11-01 14:17:42', '2024-12-27 14:55:42');
INSERT INTO `sys_models_fields` VALUES (265, '2e6cafbb-f14f-4dec-835e-7bcd782599d2', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'location', '文件上传类型(local、kodo、obs、oss、cos)', 'STRING', '', '', '', 'local', 16, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 9, '2024-11-01 14:17:42', '2024-12-27 14:55:42');
INSERT INTO `sys_models_fields` VALUES (266, '3e66c817-6a94-4ce1-aa2d-95d183f0c390', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'upload_user_uuid', '上传者uuid', 'UUID', '', 'none', '', '', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 10, '2024-11-01 14:17:42', '2024-12-27 14:55:42');
INSERT INTO `sys_models_fields` VALUES (267, 'e48b3a02-3739-4d98-94b0-7526e5f97f03', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'upload_ip', '上传者ip地址', 'STRING', '', '', '', '', 24, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 11, '2024-11-01 14:17:42', '2024-12-27 14:55:42');
INSERT INTO `sys_models_fields` VALUES (268, 'ab1ef7ac-342e-4e63-a650-1ad4ac4f2660', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'status', '状态', 'BOOLEAN', NULL, NULL, 'true', NULL, NULL, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 12, '2024-12-26 14:51:58', '2024-12-27 14:55:42');
INSERT INTO `sys_models_fields` VALUES (269, '69a8ef6d-288e-49a2-8e49-eb84ae8ef8e2', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 'remark', '备注信息,方便审核通过时更新相应信息{from:上传来源(admin,avatar,form),其他信息}', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 13, '2024-12-27 14:55:42', '2024-12-27 14:55:42');
INSERT INTO `sys_models_fields` VALUES (270, 'c622d014-e965-4469-b45b-d65930bda9fd', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 'sys_user_uuid', '绑定的管理员账号uuid', 'UUID', NULL, 'none', NULL, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, 0, 11, '2024-12-30 09:51:48', '2024-12-30 09:51:48');
INSERT INTO `sys_models_fields` VALUES (271, '8ed11294-156d-4c66-96a8-6921c4f047dc', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2024-12-30 16:33:01', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (272, '60396c7c-56bb-43b1-9f3d-561e8aa8a3f0', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2024-12-30 16:33:01', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (273, '9688959d-e61b-485d-9ec4-367f017fbf1b', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2024-12-30 16:33:01', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (274, '261e4af9-11e2-4058-a76d-fba1ed0351e5', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'begin_at', '活动开始时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1, 1, 0, 0, 0, 4, '2024-12-30 16:35:22', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (275, 'ecbdeda7-59ba-41b0-ade1-85abb3a619e8', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'end_at', '活动结束时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, 1, 1, 0, 0, 0, 5, '2024-12-30 16:35:22', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (276, '792582ea-08a7-48dc-9b54-544a101e240d', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'title', '活动名字', 'STRING', NULL, NULL, NULL, NULL, 200, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2024-12-30 16:37:54', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (277, '7e3ce073-ba7d-4144-b96a-015eecc16551', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'config', '活动配置', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 6, '2024-12-30 16:42:28', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (278, '32a154b0-9e98-4f20-b8a4-87f31a70236a', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'fields', '字段数组', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 7, '2024-12-30 16:42:28', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (279, '5a8c845d-b210-46e5-b04d-f3c08026bf70', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'amis', 'amis框架页面json配置', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 8, '2024-12-30 16:42:28', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (280, '3e90d0eb-164f-44f2-961c-8cede306bd5e', '3ec9af37-5fa3-46d1-8b79-b4da5db4eab2', 'temp', '模板', 'STRING', NULL, NULL, NULL, '空字符串', 50, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2024-12-30 16:42:28', '2025-01-06 14:09:09');
INSERT INTO `sys_models_fields` VALUES (281, 'c61bed8d-9278-4429-a3b8-b524de0781b1', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2025-01-06 14:29:57', '2025-01-09 11:28:44');
INSERT INTO `sys_models_fields` VALUES (282, 'e52d0699-3ad1-4b2f-9dbd-1927eeb6aed4', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2025-01-06 14:29:57', '2025-01-09 11:28:44');
INSERT INTO `sys_models_fields` VALUES (283, '8a3d2233-8f8b-4a41-8ea4-adb956df703e', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2025-01-06 14:29:57', '2025-01-09 11:28:44');
INSERT INTO `sys_models_fields` VALUES (284, '12aecd34-1cff-45fe-8085-8fe0af57e961', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'form_id', '所属表单id', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2025-01-06 14:39:03', '2025-01-09 11:28:44');
INSERT INTO `sys_models_fields` VALUES (285, '15e6f645-9074-44f6-8b1f-b2e56bcdeb3e', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'member_uuid', '用户关联uuid(如果表单没限制登录默认36个0)', 'UUID', NULL, 'UUIDV4', NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2025-01-06 14:39:03', '2025-01-09 11:28:44');
INSERT INTO `sys_models_fields` VALUES (286, '7b502a59-e7af-4509-b219-502c5541502d', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'data', '数据', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 6, '2025-01-06 14:39:03', '2025-01-09 11:28:45');
INSERT INTO `sys_models_fields` VALUES (287, 'e64507af-fe3a-4ea4-8432-4898018393fe', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'status', '状态(0-未审核 1-审核中 2-审核成功 3-审核失败)', 'INTEGER', NULL, NULL, NULL, '0', NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 7, '2025-01-06 14:39:03', '2025-01-09 11:28:45');
INSERT INTO `sys_models_fields` VALUES (288, '3da3f3a0-486c-4e06-b1f2-1af225b49e71', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'ip', '提交者ip地址', 'STRING', NULL, NULL, NULL, NULL, 24, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 8, '2025-01-07 10:41:19', '2025-01-09 11:28:45');
INSERT INTO `sys_models_fields` VALUES (289, 'c6c5a667-a290-4f02-950d-49dc49d9df10', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 'member_name', '用户名', 'STRING', NULL, NULL, NULL, '游客', 20, NULL, 0, 0, 0, 0, 1, 1, 0, 0, 0, 5, '2025-01-09 11:28:44', '2025-01-09 11:28:44');
INSERT INTO `sys_models_fields` VALUES (290, '77555168-0e71-44cd-a4e3-f9f83f9885d6', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, '2025-01-15 10:23:07', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (291, '87614d93-d80a-4ede-ac71-6826e73d93f2', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2025-01-15 10:23:07', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (292, '21ce643c-8419-4dfe-ab7b-61a829ffb952', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2025-01-15 10:23:07', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (293, '09a1e23f-50f0-4a83-b8b2-030c76c8c7c3', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'title', '专题标题', 'STRING', NULL, NULL, NULL, NULL, 128, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2025-01-15 10:34:46', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (294, '67de8727-1233-4a50-8395-15ba2a2fbc6e', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'description', '描述', 'STRING', NULL, NULL, NULL, '空字符串', 1000, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 4, '2025-01-15 10:34:46', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (295, '57fa56f2-b230-48d2-9f6c-8fa729abb7bc', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'thumb', '封面图', 'STRING', NULL, NULL, NULL, '空字符串', 256, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 5, '2025-01-15 10:34:46', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (296, '5ed97092-6a66-4625-ba73-a7b3ce2c8c48', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'banners', '轮播图', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 6, '2025-01-15 10:34:46', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (297, 'baecfbcc-c1ea-4db9-b0ab-e636f0c5c152', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'sort', '排序(越大越靠前)', 'INTEGER', NULL, NULL, NULL, '0', NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 7, '2025-01-15 10:34:47', '2025-01-16 09:31:29');
INSERT INTO `sys_models_fields` VALUES (298, 'dd7b3140-b469-404b-9867-e7327ac62c27', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'status', '状态(未上线前端不可见)', 'BOOLEAN', NULL, NULL, 'false', NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 8, '2025-01-15 10:34:47', '2025-01-16 09:31:30');
INSERT INTO `sys_models_fields` VALUES (299, '9b685af2-27e9-45b0-a837-c73250c93d11', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2025-01-15 10:37:36', '2025-01-15 15:44:35');
INSERT INTO `sys_models_fields` VALUES (300, '8c359f21-11cf-4428-bb9f-241ae020c868', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2025-01-15 10:37:36', '2025-01-15 15:44:35');
INSERT INTO `sys_models_fields` VALUES (301, '60b52804-47e1-45fa-8cb5-c08768ad18e3', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2025-01-15 10:37:36', '2025-01-15 15:44:35');
INSERT INTO `sys_models_fields` VALUES (302, 'b435ea21-5ce1-463d-bbae-2a7cb4ce1631', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'special_id', '所属专题id', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 3, '2025-01-15 10:40:28', '2025-01-15 15:44:35');
INSERT INTO `sys_models_fields` VALUES (303, 'db672817-1ca2-4e52-b3aa-2be3126aa8cb', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'doc_id', '稿件id', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 4, '2025-01-15 10:40:28', '2025-01-15 15:44:35');
INSERT INTO `sys_models_fields` VALUES (304, 'bd26e8d1-61b9-43b7-a051-18d32cc1b977', '92e665fa-2592-4834-92b3-f4249f0f65bc', 'sort', '排序(越大越靠前)', 'INTEGER', NULL, NULL, NULL, '0', NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 5, '2025-01-15 10:40:28', '2025-01-15 15:44:35');
INSERT INTO `sys_models_fields` VALUES (305, 'fc83c34d-ba8d-417c-a20b-5069b7416c93', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 'temp', '模板', 'STRING', NULL, NULL, NULL, '空字符串', 50, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 9, '2025-01-16 09:31:30', '2025-01-16 09:31:30');
INSERT INTO `sys_models_fields` VALUES (306, '9d517a88-8293-47bd-bab9-ebe2e287ca13', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 'alias', '别名(多态关联时名字要唯一)', 'STRING', NULL, NULL, NULL, NULL, 48, NULL, 0, 0, 0, 1, 1, 1, 0, 0, 0, 12, '2025-01-21 09:56:54', '2025-01-21 09:57:06');
INSERT INTO `sys_models_fields` VALUES (307, 'b900e935-c736-4202-974e-6d4fcf8644a7', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2025-01-26 14:59:19', '2025-01-26 15:02:33');
INSERT INTO `sys_models_fields` VALUES (308, '7222acfc-3a52-4169-8f00-8ab11f1d0aaf', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2025-01-26 14:59:19', '2025-01-26 15:02:33');
INSERT INTO `sys_models_fields` VALUES (309, '78e2b057-91c3-4974-88ac-bf2eb3d9ac0d', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2025-01-26 14:59:19', '2025-01-26 15:02:34');
INSERT INTO `sys_models_fields` VALUES (310, 'c00ae8d2-5cd4-40fa-8765-23fa3f413d7a', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'title', '活动标题', 'STRING', NULL, NULL, NULL, NULL, 200, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2025-01-26 15:02:34', '2025-01-26 15:02:34');
INSERT INTO `sys_models_fields` VALUES (311, 'a265cde6-c037-411f-8ee6-13ab84f3cbaa', 'b124c6e9-3856-412d-a146-1d80fe5079d5', 'config', '活动配置', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2025-01-26 15:02:34', '2025-01-26 15:02:34');
INSERT INTO `sys_models_fields` VALUES (312, '3a4e2f07-666b-4732-b890-772db16a35f3', '09023791-7045-4e86-b4da-6ac0072ef574', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2025-02-06 19:03:38', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (313, '58df931a-eb79-453e-ad97-4e6232694251', '09023791-7045-4e86-b4da-6ac0072ef574', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2025-02-06 19:03:38', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (314, '7f0ce331-75fd-4777-9fda-d2baf8a3aea8', '09023791-7045-4e86-b4da-6ac0072ef574', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2025-02-06 19:03:38', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (315, 'd66b38ec-ce4f-4691-bc07-76d78afd93df', '09023791-7045-4e86-b4da-6ac0072ef574', 'wall_id', '签到墙活动id', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2025-02-06 19:11:14', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (316, '498031e6-b980-4cd5-bec2-3b9592927469', '09023791-7045-4e86-b4da-6ac0072ef574', 'name', '奖品名字', 'STRING', NULL, NULL, NULL, '', 100, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2025-02-06 19:11:14', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (317, '7cfeb748-8137-4533-8e85-d6ec1e0d1a90', '09023791-7045-4e86-b4da-6ac0072ef574', 'count', '奖品数量', 'INTEGER', NULL, NULL, NULL, '0', NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 5, '2025-02-06 19:11:14', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (318, 'f3c9d893-91b7-42ef-9c4e-8c2162446972', '09023791-7045-4e86-b4da-6ac0072ef574', 'index', '抽奖轮次', 'INTEGER', NULL, NULL, NULL, '1', NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 6, '2025-02-06 19:11:14', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (319, '7e65031a-82f3-49cc-9b44-d14d5fe1b416', '09023791-7045-4e86-b4da-6ac0072ef574', 'config', '奖品其他配置', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 0, 1, 1, 0, 0, 0, 7, '2025-02-06 19:11:14', '2025-02-06 19:11:14');
INSERT INTO `sys_models_fields` VALUES (320, '2c835077-3c17-4e81-a815-8b57242840ed', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'id', '主键', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, '2025-02-06 19:15:41', '2025-02-06 19:21:23');
INSERT INTO `sys_models_fields` VALUES (321, '8d703511-ab03-416b-8f39-4f63f4d501c5', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'createdAt', '创建时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, '2025-02-06 19:15:41', '2025-02-06 19:21:23');
INSERT INTO `sys_models_fields` VALUES (322, '1303d947-d098-4cf8-894d-6c0cb90ec01d', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'updatedAt', '更新时间', 'DATE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, '2025-02-06 19:15:41', '2025-02-06 19:21:23');
INSERT INTO `sys_models_fields` VALUES (323, 'cf64c8b9-7cfe-4cf2-83ab-1953b871ab27', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'wall_id', '签到墙活动id', 'INTEGER', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 3, '2025-02-06 19:21:23', '2025-02-06 19:21:23');
INSERT INTO `sys_models_fields` VALUES (324, '8b5122e3-898e-4bf1-89e3-ba66a73cc598', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'openid', '用户微信id', 'UUID', NULL, 'UUIDV4', NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 4, '2025-02-06 19:21:23', '2025-02-06 19:21:23');
INSERT INTO `sys_models_fields` VALUES (325, 'a8651a96-f855-43dd-afaa-0389fd06d62b', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'award_id', '中奖奖品id(未中奖为0)', 'INTEGER', NULL, NULL, NULL, '0', NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 5, '2025-02-06 19:21:23', '2025-02-06 19:21:23');
INSERT INTO `sys_models_fields` VALUES (326, '07230101-fab6-42f6-93a1-b4f97a1c2efe', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 'data', '用户数据', 'JSON', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 1, 1, 1, 1, 0, 0, 0, 6, '2025-02-06 19:21:23', '2025-02-06 19:21:23');

-- ----------------------------
-- Table structure for sys_models_indexes
-- ----------------------------
DROP TABLE IF EXISTS `sys_models_indexes`;
CREATE TABLE `sys_models_indexes`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `models_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '关联模型uuid',
  `unique` tinyint(1) NOT NULL DEFAULT 0 COMMENT '唯一',
  `fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '索引字段',
  `sort` int(11) NOT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_models_indexes_uuid`(`uuid`) USING BTREE,
  INDEX `sys_models_indexes_models_uuid`(`models_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_models_indexes
-- ----------------------------
INSERT INTO `sys_models_indexes` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '80ab55dc-0722-45ae-8808-a768cc5a9c6b', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 1, '352abc9a-3a68-4358-adc7-fc5093b96bf3', 0);
INSERT INTO `sys_models_indexes` VALUES (2, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '92798fb2-2a35-46f2-bf37-dc7ad397baef', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 0, '3f06979a-a244-477f-bba7-876525e8631c', 1);
INSERT INTO `sys_models_indexes` VALUES (3, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'b53b40b1-c7ce-4c14-8bff-32ff7a046b40', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 1, '8ba0e0dc-6f95-4018-bd6a-31e846c08168', 0);
INSERT INTO `sys_models_indexes` VALUES (4, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '75158ea1-9edd-4d95-bc58-cc26cf209b6d', 'ef0a5dad-2ec1-41d2-9b50-ac9633e5f3a8', 0, '1cb0cd12-fdb3-4549-96ce-0e4faf8b4a01,d27f4186-21c7-42fe-ae2f-206997c1d1ac', 1);
INSERT INTO `sys_models_indexes` VALUES (5, '2024-11-19 10:04:13', '2024-12-30 11:32:16', '555372d3-d9a1-4fbc-a4ee-8d98ba66e34b', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 1, '3f5379a9-dc39-4e94-ae0d-293a7174810c', 0);
INSERT INTO `sys_models_indexes` VALUES (6, '2024-11-19 10:04:13', '2024-12-30 11:32:16', '7132b1a5-5673-4585-b2cd-0c7cd7d5ca15', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 0, '0fa0ab46-7b2a-4ca7-9767-e6b805ccaefd', 1);
INSERT INTO `sys_models_indexes` VALUES (7, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'c09c3e36-ef21-4e1e-8b3c-f254b6d7e628', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 1, 'de27163e-58e9-4f07-865a-473784c4d4e7', 0);
INSERT INTO `sys_models_indexes` VALUES (8, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '8ef07715-cbdc-4121-bac3-3ba7f5c100ab', 'b19cea90-d4c1-45b2-9e1e-e9ccb91ccc4e', 0, 'aad47105-7def-4f21-99c6-9bdf35564fd3', 1);
INSERT INTO `sys_models_indexes` VALUES (9, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '31860b79-c4fe-46d9-a2f1-717c0b9b8581', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 1, 'aa901e67-c8c6-4fcc-a153-9a8d5d3bd677', 0);
INSERT INTO `sys_models_indexes` VALUES (10, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '82a60e91-d826-4f2b-ad78-3c0083a6324a', '67218318-57ca-41e0-9ce0-95d6e3bd01c4', 0, '98eb4b7f-783c-4c96-b3b4-f746efd5a966', 1);
INSERT INTO `sys_models_indexes` VALUES (11, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'febb9d78-4daf-483f-9131-fe82e245e4af', 'a6142c33-b86a-4e0a-ab45-6ea68c03d321', 1, '870c8f23-5cdb-4166-b9db-6bcfca01b405', 0);
INSERT INTO `sys_models_indexes` VALUES (12, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'ea5a154c-5e40-4e1f-ba97-e04e54a7c604', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 1, 'ee0fab53-587c-45af-b650-7440138c03a4', 0);
INSERT INTO `sys_models_indexes` VALUES (13, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '97efa2a6-9c50-4969-80fb-085227840895', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 0, '9f232701-4b5d-4b2c-9d50-991f42bac8ad', 1);
INSERT INTO `sys_models_indexes` VALUES (14, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '6b114f33-eb31-4387-b28d-b6f23c37cabc', '161f3657-96b0-4a44-b872-92e42f446039', 1, '66a1d422-0df7-44ec-8282-09b69bad5837', 0);
INSERT INTO `sys_models_indexes` VALUES (15, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '0d776191-514f-4b99-b0d4-e686757d673a', '161f3657-96b0-4a44-b872-92e42f446039', 0, '02ad96b8-990b-468b-b3bd-c7ef444b0638', 1);
INSERT INTO `sys_models_indexes` VALUES (16, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '47cbc077-793b-407f-8b08-7d2c9cd2a8cd', 'c6f54355-e957-4f8c-93f8-c8357dd78088', 1, '11e833b3-873f-4387-9aec-552913e07f4f', 0);
INSERT INTO `sys_models_indexes` VALUES (17, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '2ac9345b-341b-4699-9597-1d4605baf7f6', '603a57cd-64c0-49bf-8019-05676ae6622f', 0, '5bc2df53-43f0-4d58-bca0-d9abe9ce15d1', 0);
INSERT INTO `sys_models_indexes` VALUES (18, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '0776d06a-f174-49bf-b310-6c5c2e8ab1d2', '603a57cd-64c0-49bf-8019-05676ae6622f', 0, 'e71d5649-c9df-48b6-9c03-7cb8a470d953', 1);
INSERT INTO `sys_models_indexes` VALUES (19, '2024-11-19 10:04:13', '2024-12-30 11:32:16', 'b05a123d-6cd2-4c54-a2c3-f1dd9423c8f8', '440166cc-cf10-44af-b8b5-b51ad699ffb3', 1, '43efd819-a9dc-4ed5-a9c1-cb6997d0b488', 2);
INSERT INTO `sys_models_indexes` VALUES (20, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'a0ab7770-4378-4732-bfe0-b9b6528a387a', 'ca731164-4846-4fb9-a9d4-a7741b0bfafd', 1, '4d59ff4f-b57a-4e06-8df6-1d33d9b792b3', 0);
INSERT INTO `sys_models_indexes` VALUES (21, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'b14acf2f-39ad-4cb5-a17d-b0bf549d8258', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 0, 'fdc613ac-9f2f-4ac0-b81b-60f1400cb5bd', 0);
INSERT INTO `sys_models_indexes` VALUES (22, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '0a22fe25-3d1e-4633-ace3-f2bfb197a800', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 0, 'd35f5fea-2e83-41c6-b9bb-ecb9f70de225', 1);
INSERT INTO `sys_models_indexes` VALUES (23, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '249e2fb6-f6ee-479c-a9d1-b3de10d1655c', 'd0806a84-19fa-43cd-b85b-18a1999acbe8', 0, '4fd1820b-0e1c-48aa-8e54-736b14fbd899', 2);
INSERT INTO `sys_models_indexes` VALUES (24, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '08ee3223-f212-4cd2-9287-f3e494f6a89e', 'e86401ba-85cb-47f7-9f53-853e26b939bd', 1, '938fc47b-eeec-4095-974e-b77d0405f76a', 0);
INSERT INTO `sys_models_indexes` VALUES (25, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '98d7a81c-edf1-4f30-bafc-72c31e7f6080', '4e0da60c-13af-4965-8f35-e2b13742398e', 1, '428b44c7-3af7-4ec0-aca4-16544f0e2e2c', 0);
INSERT INTO `sys_models_indexes` VALUES (26, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '68c075b7-280c-42de-84db-b9dfabb38728', 'aac4b5a3-89f2-4c41-9213-39f43dcc0860', 1, 'f8e68c51-54f5-4db5-bf52-b84b053eb76c', 0);
INSERT INTO `sys_models_indexes` VALUES (27, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '2995a370-2891-4dcf-80dd-96666a185ffa', '12595142-74b1-40c3-ab20-b76ea941bcfa', 0, 'c1d7e791-4816-4911-a11b-35c77f892919', 0);
INSERT INTO `sys_models_indexes` VALUES (28, '2024-11-19 10:04:13', '2025-01-21 16:51:42', '283f55e0-e6b1-400d-9092-7ab1677f5d3c', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 1, '1f1d61a4-492f-44af-820d-f97dfac5c4bb', 0);
INSERT INTO `sys_models_indexes` VALUES (29, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '519b16a5-2d45-4d64-b590-548c08c262e6', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 0, '710aacae-a6e4-498a-917e-abf54fb6ed70', 0);
INSERT INTO `sys_models_indexes` VALUES (30, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '0f03a4ae-8b57-4dea-93a2-7aaabefa1f9b', '6f45d480-ac5d-49fd-a36b-1265aa65c07e', 0, '38f7732b-cea7-4881-9fde-9be7bbb591fe', 1);
INSERT INTO `sys_models_indexes` VALUES (31, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '217cfc78-5cfa-4af4-a961-03d863785a4c', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 0, '2618f1a0-9801-4148-9964-87a782a30b58', 0);
INSERT INTO `sys_models_indexes` VALUES (32, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '051147a2-ebdd-40a2-b0fa-03b5dd031dbc', '7d611f59-0461-4a81-a9ad-6ceaa578d89b', 0, '0392493c-37c7-4368-aa5c-3ed8bdcf75b4', 1);
INSERT INTO `sys_models_indexes` VALUES (33, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '2fab6dfd-b36f-40dd-bec4-044c10f57102', '0f4dcc6a-defa-4046-a106-6a4c4a7b9c9c', 1, '79a3ba5d-e3d8-4e73-8607-bf5f795a5723', 0);
INSERT INTO `sys_models_indexes` VALUES (34, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'cd777ea5-353e-4d1c-8d47-bcf6d05a963d', '53b2557e-7e75-4480-a97a-dd451b206f2e', 0, '794d6903-d2ec-42ae-b034-77605dc0d035', 0);
INSERT INTO `sys_models_indexes` VALUES (35, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'd1f12034-0e31-4218-8578-d03b5cc80f9e', '53b2557e-7e75-4480-a97a-dd451b206f2e', 1, 'ac63efc4-feac-4aac-9983-3bcb62ec16e2', 1);
INSERT INTO `sys_models_indexes` VALUES (36, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '93d0bbe5-2204-4905-b438-a52e53671656', '8940f820-eb65-41e6-af3e-e958ac77edd7', 1, '2d8fb9e1-ddc0-46e0-a0d1-29a15c49221d', 0);
INSERT INTO `sys_models_indexes` VALUES (37, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '6f05b20d-f427-49fb-8a3a-929e843137f4', '1796faf3-5ec8-42ee-8db9-9cf86af0fe12', 0, '73f3ab14-6c3e-4583-af5c-e00a6d0e71d6', 2);
INSERT INTO `sys_models_indexes` VALUES (38, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '9f05c7ce-b677-4fd6-bf6e-c9eebf872cbc', 'd749c0ee-f449-45c8-a5b1-0cf5f07d6d64', 1, '70b5c4da-6eca-4c3f-aa2c-b67c99df60e7', 0);
INSERT INTO `sys_models_indexes` VALUES (39, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'f7a687aa-4f56-4a1c-89cf-8702b671ca11', 'bff1476c-5357-4d00-9a04-f18e1d8c7eae', 0, '51ae3cf2-d880-414e-94ab-d361337b5961', 2);
INSERT INTO `sys_models_indexes` VALUES (40, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '45da7999-5c92-488a-b05b-82e22a71b4d7', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 0, '1c853747-efa7-4d68-ac4a-dd7a893adc82', 0);
INSERT INTO `sys_models_indexes` VALUES (41, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '36035c66-ca81-46cd-9448-ec138f1c8f55', 'd347e0b9-a113-4051-addb-2a0db8f36c78', 0, '5a5aa0a6-36cb-4149-818d-ed50ef7e8243', 1);
INSERT INTO `sys_models_indexes` VALUES (42, '2024-12-30 11:31:55', '2025-01-21 16:51:42', '02a02911-b7a8-49f5-ad3f-c68aa040601b', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 1, '2c58c8a1-d78b-4bd1-978e-b06a5a106286', 1);
INSERT INTO `sys_models_indexes` VALUES (43, '2025-01-06 14:39:39', '2025-01-07 10:41:42', '943e6837-524d-41f3-968f-e5364a3da853', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 0, '12aecd34-1cff-45fe-8085-8fe0af57e961', 0);
INSERT INTO `sys_models_indexes` VALUES (44, '2025-01-06 14:39:39', '2025-01-07 10:41:42', 'a5aaa97d-c214-4f16-a422-342dbf8668e3', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 0, '15e6f645-9074-44f6-8b1f-b2e56bcdeb3e', 1);
INSERT INTO `sys_models_indexes` VALUES (45, '2025-01-07 10:41:42', '2025-01-07 10:41:42', '408a9751-49b4-4476-afaf-f4a2aa3ecd44', 'a351c95e-aeaf-4326-8ce0-9567c2c7af30', 0, '3da3f3a0-486c-4e06-b1f2-1af225b49e71', 2);
INSERT INTO `sys_models_indexes` VALUES (46, '2025-01-15 10:35:16', '2025-01-15 10:35:16', '5dd06220-bcae-4955-85a4-9a3787606aea', 'bdf63bd8-6471-4311-8755-ad148e0a0bd0', 0, 'dd7b3140-b469-404b-9867-e7327ac62c27', 0);
INSERT INTO `sys_models_indexes` VALUES (47, '2025-01-15 10:40:51', '2025-01-15 10:40:51', 'f8d5f458-893f-441b-add0-aaea62ec06fc', '92e665fa-2592-4834-92b3-f4249f0f65bc', 1, 'b435ea21-5ce1-463d-bbae-2a7cb4ce1631,db672817-1ca2-4e52-b3aa-2be3126aa8cb', 0);
INSERT INTO `sys_models_indexes` VALUES (48, '2025-01-21 16:51:42', '2025-01-21 16:51:42', '9c4b2e74-defd-45a0-a189-ded9fa51a63c', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 1, '149f41d0-a665-4664-b321-f7c818043729', 2);
INSERT INTO `sys_models_indexes` VALUES (49, '2025-01-21 16:51:42', '2025-01-21 16:51:42', '0ba4aba5-7049-40d0-bd1d-d93538e69ec2', 'bbd1ba38-99cb-4c6f-84ba-23e438638a26', 1, '710c87a3-f49e-4881-b8dd-3abe9f32261c', 3);
INSERT INTO `sys_models_indexes` VALUES (50, '2025-02-06 19:11:47', '2025-02-06 19:11:47', '0714e77c-0c4a-4a38-afdd-c58f891b5c6d', '09023791-7045-4e86-b4da-6ac0072ef574', 0, 'd66b38ec-ce4f-4691-bc07-76d78afd93df', 0);
INSERT INTO `sys_models_indexes` VALUES (51, '2025-02-06 19:22:06', '2025-02-06 19:22:06', '803ab3b0-5be5-4f91-a1e2-1cfcaea6b439', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 1, '8b5122e3-898e-4bf1-89e3-ba66a73cc598,cf64c8b9-7cfe-4cf2-83ab-1953b871ab27', 0);
INSERT INTO `sys_models_indexes` VALUES (52, '2025-02-06 19:22:06', '2025-02-06 19:22:06', '8bac737f-dcfe-4039-9e1c-dd6f24bf400c', '0261456c-3801-4e0d-a6fe-db79e9df7d14', 0, 'cf64c8b9-7cfe-4cf2-83ab-1953b871ab27', 1);

-- ----------------------------
-- Table structure for sys_navigation
-- ----------------------------
DROP TABLE IF EXISTS `sys_navigation`;
CREATE TABLE `sys_navigation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `pid` int(11) NULL DEFAULT 0 COMMENT '上级导航ID',
  `title` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '导航标题',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '导航链接',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  `target` tinyint(1) NULL DEFAULT 0 COMMENT '是否新窗口打开',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '位置类型',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_navigation_pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_navigation
-- ----------------------------
INSERT INTO `sys_navigation` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 0, '首页', '/', NULL, 0, 1, 'header');

-- ----------------------------
-- Table structure for sys_openapi
-- ----------------------------
DROP TABLE IF EXISTS `sys_openapi`;
CREATE TABLE `sys_openapi`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `open_uuids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '开放接口节点',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT 'uuid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_open_api_uuid`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_openapi
-- ----------------------------
INSERT INTO `sys_openapi` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '', '16736061-6c6d-4f33-88af-4032ec94eb7d');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色说明',
  `r_uuids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '路由节点',
  `g_uuids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'graphql节点',
  `state` tinyint(1) NULL DEFAULT 1 COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_role_uuid`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '2024-11-19 10:04:13', '2025-01-08 16:33:42', '系统管理员', '9f42247a-46e7-4b9c-8d05-660573cf5b2b', '系统管理员', '740d33b4-3cc1-4022-bce0-d49ff11a2978,e232f3ac-9081-4151-8ad2-9674e4db8d45,3632bf23-e4a9-4b0d-af83-9b2f02316894,2aab780a-0fa4-46b7-b94b-5c374a391ed9,73dc4727-4985-4c91-8feb-28fc3a6c4296,f6f71ab9-feef-43da-823a-cdf0a686a8c8,f015a652-70ed-43dc-9066-a13e33c80d49,8bce1410-e917-4ff5-8de5-ad1cf7d7584f,c5f8768a-f1f4-406b-b587-755e03332823,823cebf1-907b-415b-b4fb-de2ad56d51d9,e3ed0596-b2ac-453f-96c3-bb0a0df310f8,3875cb33-900a-47ab-b8c6-989f28093616,14ff665f-d269-4e73-a92f-a6123beb3fbb,c4be3ef0-4e44-4d6c-b66f-c02dac0c9e34,f51bfdba-4d28-4da0-9815-0eb6b9d51613,28a77709-e078-4150-aa5b-5c6e7583436a,e4944075-2f8a-4272-b546-07212be1e36e,8fc3ad21-c92c-4de2-be10-f0a57a7d88e5,200bc50e-59a7-4548-9965-0e5f704fd721,ac1b6b88-5c20-4085-95f2-fab6a385b1ff,f2bcb02e-769c-4b7d-8378-7909dff9e50a,0401d923-2fa3-4b57-a62d-8afa7f3eb10d,83650b01-98ce-418e-aa93-d0a96aa16ca0,610c4563-0c2c-4187-9fdf-9e9cdde7bb69,70870f97-ee19-495e-8326-4efe0166437b,1319d800-090b-4d3a-8bd6-7e776821fb05,61e8fbb6-ccc1-428c-a5ee-4df47afdd3d6,a786208b-71f3-4e04-b140-ee29cb10812b,99844a9b-5c26-477c-b91e-e831b64cd525,31709085-24db-4d99-b529-093ecb0405d3,135f7c98-6e44-4b8b-a76d-863821203d46,492db2de-0bd3-4050-a5d1-15d8192bf1cf,045e4001-f740-4e4f-8878-34b875f1bd1a,20ab6174-7a28-4637-a68f-c0d7bbf29f3c,7c360902-ba2a-49eb-a9f4-9c9334616efb,197babdc-4666-418d-bd55-b5aad784fa39,bf46002c-0907-493d-a021-5d77a475f1ae,a6ed311a-f95c-48f2-ad7a-f0faf76abf77,28bc57ac-c0eb-4ea2-91f1-324c7394298b,fec429c3-7851-4900-ade7-cbb34cbd8ead,aa8a6e25-53fb-4ee2-ae97-fb4683137926,82708cbc-ce22-49e7-bb1a-b6a7a46aeb6c,a568df82-5598-4913-8c25-5a72f2357c1f,c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13,9bbc93c1-dfc1-414d-bada-a864abcad7bb,a5b0b9eb-eff5-46e8-82d3-771ca44b4e09,772a6f34-1895-4a02-baca-c6983e3c36da,0027dce7-a5f6-42e8-857b-703f17510cdf,e81edc8b-c937-4d40-98f7-2f5ec424acd3,4d74f821-4f96-47ed-9458-644397b0bf5a,f9ffdd85-b55b-4e49-90ea-9ac51bf4bfb3', 'queryType,SysModels_findAll,SysModels_findByPk,SysModels_findOne,SysModels_findAndCountAll,SysUser_findByPk,SysUser_findOne,SysUser_findAndCountAll,SysModelsFields_findAll,SysModelsFields_findByPk,SysModelsFields_findOne,SysModelsFields_findAndCountAll,SysModelsIndexes_findAll,SysModelsIndexes_findByPk,SysModelsIndexes_findOne,SysModelsIndexes_findAndCountAll,SysModelsAssociate_findAll,SysModelsAssociate_findByPk,SysModelsAssociate_findOne,SysModelsAssociate_findAndCountAll,SysRoutes_findAll,SysRoutes_findByPk,SysRoutes_findOne,SysRoutes_findAndCountAll,SysRoutesClassify_findAll,SysRoutesClassify_findByPk,SysRoutesClassify_findOne,SysRoutesClassify_findAndCountAll,SysUserGroup_findAll,SysUserGroup_findByPk,SysUserGroup_findOne,SysUserGroup_findAndCountAll,SysRole_findAll,SysRole_findByPk,SysRole_findOne,SysRole_findAndCountAll,SysUserRole_findAll,SysUserRole_findByPk,SysUserRole_findOne,SysUserRole_findAndCountAll,mutationType,SysModels_create,SysModels_destroy,SysModels_update,SysUser_create,SysUser_destroy,SysUser_update,SysModelsFields_create,SysModelsFields_destroy,SysModelsFields_update,SysModelsIndexes_create,SysModelsIndexes_destroy,SysModelsIndexes_update,SysModelsAssociate_create,SysModelsAssociate_destroy,SysModelsAssociate_update,SysRoutes_create,SysRoutes_destroy,SysRoutes_update,SysRoutesClassify_create,SysRoutesClassify_destroy,SysRoutesClassify_update,SysUserGroup_create,SysUserGroup_destroy,SysUserGroup_update,SysRole_create,SysRole_destroy,SysRole_update,SysUserRole_create,SysUserRole_destroy,SysUserRole_update', 1);
INSERT INTO `sys_role` VALUES (2, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '开发', '2154b89e-8a29-4758-b77f-1e54a9f397e2', '开发', '740d33b4-3cc1-4022-bce0-d49ff11a2978,e232f3ac-9081-4151-8ad2-9674e4db8d45,ca05ecef-b079-462b-ac1b-9283f6ec4375,3632bf23-e4a9-4b0d-af83-9b2f02316894,2aab780a-0fa4-46b7-b94b-5c374a391ed9,f6f71ab9-feef-43da-823a-cdf0a686a8c8,823cebf1-907b-415b-b4fb-de2ad56d51d9,e3ed0596-b2ac-453f-96c3-bb0a0df310f8,3875cb33-900a-47ab-b8c6-989f28093616,14ff665f-d269-4e73-a92f-a6123beb3fbb,c4be3ef0-4e44-4d6c-b66f-c02dac0c9e34,f51bfdba-4d28-4da0-9815-0eb6b9d51613,28a77709-e078-4150-aa5b-5c6e7583436a,e4944075-2f8a-4272-b546-07212be1e36e,8fc3ad21-c92c-4de2-be10-f0a57a7d88e5,73dc4727-4985-4c91-8feb-28fc3a6c4296,8bce1410-e917-4ff5-8de5-ad1cf7d7584f,70870f97-ee19-495e-8326-4efe0166437b,1319d800-090b-4d3a-8bd6-7e776821fb05,61e8fbb6-ccc1-428c-a5ee-4df47afdd3d6,a786208b-71f3-4e04-b140-ee29cb10812b,99844a9b-5c26-477c-b91e-e831b64cd525,31709085-24db-4d99-b529-093ecb0405d3,3632bf23-e4a9-4b0d-af83-9b2f02316894', 'SysModels_create,SysModels_destroy,SysModels_update,SysModels_findAll,SysModels_findByPk,SysModels_findOne,SysModels_findAndCountAll', 1);
INSERT INTO `sys_role` VALUES (3, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '管理员', '8cf0b447-b49f-4886-bc45-922bc00da975', NULL, NULL, NULL, 1);

-- ----------------------------
-- Table structure for sys_routes
-- ----------------------------
DROP TABLE IF EXISTS `sys_routes`;
CREATE TABLE `sys_routes`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '路由 URL 路径',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置菜单的图标',
  `verb` enum('head','options','get','put','post','patch','del','redirect','resources') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'get' COMMENT '用户触发动作，支持 get，post 等所有 HTTP 方法',
  `middleware` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '在 Router 里面可以配置多个 Middleware',
  `ignoreMiddleware` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '排除模块统一设置的middleware',
  `controller` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '控制器',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '控制器方法',
  `admin` tinyint(1) NULL DEFAULT 1 COMMENT '控制器/页面',
  `role` tinyint(1) NULL DEFAULT 1 COMMENT '是否为角色权限节点',
  `class_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '关联classify的uuid',
  `puuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '路由父uuid',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  `linkType` enum('schemaApi','link') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'schemaApi' COMMENT '链接类型',
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '页面地址',
  `is_menu` tinyint(1) NULL DEFAULT 0 COMMENT '是否是菜单',
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用标识',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_routes_uuid`(`uuid`) USING BTREE,
  INDEX `sys_routes_puuid`(`puuid`) USING BTREE,
  INDEX `sys_routes_app`(`app`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_routes
-- ----------------------------
INSERT INTO `sys_routes` VALUES (1, '2024-11-19 10:04:13', '2025-01-26 14:33:02', '740d33b4-3cc1-4022-bce0-d49ff11a2978', '应用', '', '', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '0', 0, 'schemaApi', '', 1, 'sys');
INSERT INTO `sys_routes` VALUES (2, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '3632bf23-e4a9-4b0d-af83-9b2f02316894', '系统', '', '', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '0', 1, 'schemaApi', '', 1, 'sys');
INSERT INTO `sys_routes` VALUES (3, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'e232f3ac-9081-4151-8ad2-9674e4db8d45', '首页', '/', 'fa-solid fa-house-chimney', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '740d33b4-3cc1-4022-bce0-d49ff11a2978', 0, 'schemaApi', '/pages/index.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (4, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', '模型管理', '/sys/models', 'fa-solid fa-database', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '73dc4727-4985-4c91-8feb-28fc3a6c4296', 1, 'schemaApi', '/pages/sys/models/index.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (5, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'c5f8768a-f1f4-406b-b587-755e03332823', '路由管理', '/sys/routes', 'fa-solid fa-route', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '73dc4727-4985-4c91-8feb-28fc3a6c4296', 2, 'schemaApi', '/pages/sys/routes/index.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (6, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '70870f97-ee19-495e-8326-4efe0166437b', '更新字段', '/admin/sys/models/updateFields', '', 'post', '', '', 'sys.models', 'updateFields', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (7, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '1319d800-090b-4d3a-8bd6-7e776821fb05', '获取索引', '/admin/sys/models/indexes', '', 'get', '', '', 'sys.models', 'indexes', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 4, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (8, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '61e8fbb6-ccc1-428c-a5ee-4df47afdd3d6', '更新索引', '/admin/sys/models/updateIndexes', '', 'post', '', '', 'sys.models', 'updateIndexes', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 5, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (9, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'a786208b-71f3-4e04-b140-ee29cb10812b', '获取关联模型', '/admin/sys/models/associate', '', 'get', '', '', 'sys.models', 'associate', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 6, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (10, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '99844a9b-5c26-477c-b91e-e831b64cd525', '更新关联模型', '/admin/sys/models/updateAssociate', '', 'post', '', '', 'sys.models', 'updateAssociate', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 7, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (11, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '31709085-24db-4d99-b529-093ecb0405d3', '添加模型', '/admin/sys/models/addModels', '', 'post', '', '', 'sys.models', 'addModels', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 8, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (12, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '135f7c98-6e44-4b8b-a76d-863821203d46', '路由列表', '/admin/sys/routes/routesList', '', 'get', '', '', 'sys.routes', 'routesList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (13, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '492db2de-0bd3-4050-a5d1-15d8192bf1cf', '添加路由', '/admin/sys/routes/addRoutes', '', 'post', '', '', 'sys.routes', 'addRoutes', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 4, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (14, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '045e4001-f740-4e4f-8878-34b875f1bd1a', '编辑路由', '/admin/sys/routes/editRoutes', '', 'post', '', '', 'sys.routes', 'editRoutes', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 5, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (15, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '20ab6174-7a28-4637-a68f-c0d7bbf29f3c', '删除路由', '/admin/sys/routes/delRoutes', '', 'get', '', '', 'sys.routes', 'delRoutes', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 6, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (16, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '7c360902-ba2a-49eb-a9f4-9c9334616efb', '获取上级路由', '/admin/sys/routes/topRoutes', '', 'get', '', '', 'sys.routes', 'topRoutes', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 7, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (17, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '73dc4727-4985-4c91-8feb-28fc3a6c4296', '开发管理', '', 'fa-brands fa-dev', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3632bf23-e4a9-4b0d-af83-9b2f02316894', 3, 'schemaApi', '', 1, 'sys');
INSERT INTO `sys_routes` VALUES (18, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '197babdc-4666-418d-bd55-b5aad784fa39', '视图编辑页面', '/admin/sys/routes/editPages', '', 'post', '', '', 'sys.routes', 'editPages', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 8, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (19, '2024-11-19 10:04:13', '2025-01-26 14:33:05', 'bf46002c-0907-493d-a021-5d77a475f1ae', '路由排序', '/admin/sys/routes/saveOrder', '', 'post', '', '', 'sys.routes', 'saveOrder', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 9, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (20, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '2aab780a-0fa4-46b7-b94b-5c374a391ed9', '权限管理', '', 'fa-solid fa-shield-virus', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3632bf23-e4a9-4b0d-af83-9b2f02316894', 2, 'schemaApi', '', 1, 'sys');
INSERT INTO `sys_routes` VALUES (21, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', '系统用户', '/sys/user', 'fa-solid fa-user-group', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '2aab780a-0fa4-46b7-b94b-5c374a391ed9', 0, 'schemaApi', '/pages/sys/user.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (22, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'f015a652-70ed-43dc-9066-a13e33c80d49', '角色管理', '/sys/role', 'fa-solid fa-user-shield', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '2aab780a-0fa4-46b7-b94b-5c374a391ed9', 1, 'schemaApi', '/pages/sys/role.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (23, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '200bc50e-59a7-4548-9965-0e5f704fd721', '路由权限节点', '/admin/sys/role/routingNode', '', 'get', '', '', 'sys.role', 'routingNode', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f015a652-70ed-43dc-9066-a13e33c80d49', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (24, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'ac1b6b88-5c20-4085-95f2-fab6a385b1ff', 'graphQL权限节点', '/admin/sys/role/graphQL', '', 'get', '', '', 'sys.role', 'graphQL', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f015a652-70ed-43dc-9066-a13e33c80d49', 1, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (25, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'f2bcb02e-769c-4b7d-8378-7909dff9e50a', '添加角色', '/admin/sys/role/addRole', '', 'post', '', '', 'sys.role', 'addRole', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f015a652-70ed-43dc-9066-a13e33c80d49', 2, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (26, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '0401d923-2fa3-4b57-a62d-8afa7f3eb10d', '角色列表', '/admin/sys/role/roleList', '', 'get', '', '', 'sys.role', 'roleList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f015a652-70ed-43dc-9066-a13e33c80d49', 3, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (27, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '83650b01-98ce-418e-aa93-d0a96aa16ca0', '更新角色', '/admin/sys/role/update', '', 'post', '', '', 'sys.role', 'update', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f015a652-70ed-43dc-9066-a13e33c80d49', 4, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (28, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '610c4563-0c2c-4187-9fdf-9e9cdde7bb69', '删除角色', '/admin/sys/role/del', '', 'get', '', '', 'sys.role', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f015a652-70ed-43dc-9066-a13e33c80d49', 5, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (29, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '823cebf1-907b-415b-b4fb-de2ad56d51d9', '分组列表', '/admin/sys/user/groupList', '', 'get', '', '', 'sys.user', 'groupList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (30, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'e3ed0596-b2ac-453f-96c3-bb0a0df310f8', '添加分组', '/admin/sys/user/groupAdd', '', 'post', '', '', 'sys.user', 'groupAdd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 1, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (31, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '3875cb33-900a-47ab-b8c6-989f28093616', '编辑分组', '/admin/sys/user/groupEdit', '', 'post', '', '', 'sys.user', 'groupEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 2, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (32, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '14ff665f-d269-4e73-a92f-a6123beb3fbb', '删除分组', '/admin/sys/user/groupDel', '', 'get', '', '', 'sys.user', 'groupDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 3, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (33, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'c4be3ef0-4e44-4d6c-b66f-c02dac0c9e34', '用户列表', '/admin/sys/user/userList', '', 'get', '', '', 'sys.user', 'userList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 4, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (34, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'f51bfdba-4d28-4da0-9815-0eb6b9d51613', '添加用户', '/admin/sys/user/userAdd', '', 'post', '', '', 'sys.user', 'userAdd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 5, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (35, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '28a77709-e078-4150-aa5b-5c6e7583436a', '编辑用户', '/admin/sys/user/userEdit', '', 'post', '', '', 'sys.user', 'userEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 6, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (36, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'e4944075-2f8a-4272-b546-07212be1e36e', '删除用户', '/admin/sys/user/userDel', '', 'get', '', '', 'sys.user', 'userDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 7, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (37, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '8fc3ad21-c92c-4de2-be10-f0a57a7d88e5', '获取角色', '/admin/sys/user/roleList', '', 'get', '', '', 'sys.user', 'roleList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f6f71ab9-feef-43da-823a-cdf0a686a8c8', 8, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (38, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '7c521a78-823f-40e9-98f1-e018d6dc8098', '开放接口', '/sys/openApi', 'fa-solid fa-network-wired', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '2aab780a-0fa4-46b7-b94b-5c374a391ed9', 2, 'schemaApi', '/pages/sys/openApi.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (39, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '5db7f488-1be5-467b-ac22-22b456fa7b21', '添加分类', '/admin/sys/routes/addClassify', '', 'post', '', '', 'sys.routes', 'addClassify', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 2, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (40, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'a4ee857d-6ce5-4729-8ec4-7c68f0812d4a', '编辑分类', '/admin/sys/routes/editClassify', '', 'post', '', '', 'sys.routes', 'editClassify', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 3, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (41, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 'CMS管理', '', 'fa-solid fa-book-atlas', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '740d33b4-3cc1-4022-bce0-d49ff11a2978', 1, 'schemaApi', '', 1, 'cms');
INSERT INTO `sys_routes` VALUES (42, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '994e88d4-39a4-495c-bb57-9c8b220924e5', '内容管理', '/cms/doc', 'fa-solid fa-pen-nib', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 0, 'schemaApi', '/pages/cms/doc.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (43, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', '分类管理', '/cms/classify', 'fa-solid fa-layer-group', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 1, 'schemaApi', '/pages/cms/classify.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (44, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'f0840f4a-05aa-4715-8c75-dd9557558068', '回收站', '/cms/recycle', 'fa-solid fa-recycle', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 4, 'schemaApi', '/pages/cms/recycle.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (45, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '4a3b18dc-b940-4641-b37c-76e2cea8f48d', '分类列表', '/admin/cms/classify/index', '', 'get', '', '', 'cms.classify', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (46, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '2264cc0a-47b5-4c47-801d-0bb417fb2cfb', '获取上级分类', '/admin/cms/classify/topClassify', '', 'get', '', '', 'cms.classify', 'topClassify', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', 1, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (47, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'e125570a-64f3-490a-bcb0-2d583ec995fb', '添加分类', '/admin/cms/classify/classifyAdd', '', 'post', '', '', 'cms.classify', 'classifyAdd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (48, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '8908d97a-87b5-401e-9119-1ba6e0861f2d', '编辑分类', '/admin/cms/classify/classifyEdit', '', 'post', '', '', 'cms.classify', 'classifyEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (49, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '2af26b1a-711c-4083-aab8-437c11e71dda', '删除分类', '/admin/cms/classify/classifyDel', '', 'get', '', '', 'cms.classify', 'classifyDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', 4, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (50, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'a2da1360-3fce-457a-b144-ad6a3601fe5a', '分类排序', '/admin/cms/classify/saveOrder', '', 'post', '', '', 'cms.classify', 'saveOrder', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f60b69c5-4fa0-408c-bf1b-cc169920fb3b', 5, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (51, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '1cf3d2e7-d626-4bbb-aaf2-8a7cc62153c3', '全部分类', '/admin/cms/doc/topClassify', '', 'get', '', '', 'cms.doc', 'topClassify', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (52, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'ef668817-5ac9-485d-968e-7fd73e6b5cf5', '内容列表', '/admin/cms/doc/index', '', 'get', '', '', 'cms.doc', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 4, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (53, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'f3a2f89c-2799-428f-8d9c-b37689efa897', '获取子分类', '/admin/cms/doc/classifySub', '', 'get', '', '', 'cms.doc', 'classifySub', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 5, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (54, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '7561ecfb-7d16-4155-982f-f67754199619', '子分类表单', '/admin/cms/doc/classifySubFrom', '', 'get', '', '', 'cms.doc', 'classifySubFrom', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 6, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (55, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '470704bf-d301-4d02-b408-f4d1baf58aac', '模型表单', '/admin/cms/doc/getContent', '', 'get', '', '', 'cms.doc', 'getContent', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 7, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (56, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'd9d14fd3-6a22-45d8-9e08-2b8e34687aca', '添加内容', '/admin/cms/doc/docAdd', '', 'post', '', '', 'cms.doc', 'docAdd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 8, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (57, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '22494650-550d-4500-82cd-989180dc9505', '上级文档', '/admin/cms/doc/pdoc', '', 'get', '', '', 'cms.doc', 'pdoc', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 9, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (58, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '43376bb2-83b9-451a-ad12-311bfa16cbdd', '编辑文档', '/admin/cms/doc/docEdit', '', 'post', '', '', 'cms.doc', 'docEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 10, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (59, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '4f33e729-cb8a-4237-b0d5-cec25dbcebf1', '删除文档', '/admin/cms/doc/docDel', '', 'get', '', '', 'cms.doc', 'docDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 11, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (60, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '926d2ddf-551b-4b87-8d70-471294398c5c', '获取所属分类', '/admin/cms/doc/selectClassify', '', 'get', '', '', 'cms.doc', 'selectClassify', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 12, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (61, '2024-11-19 10:04:13', '2024-12-30 10:56:28', 'b95be4ff-869f-4066-9d48-3143b4289783', 'cms', '', '', 'get', '', '', '', '', 0, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '0', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (62, '2024-11-19 10:04:13', '2024-12-30 10:57:05', '82b67b52-48cf-4c73-97ed-2995c91c6d02', 'cms详情', '/cms/detail/:id', '', 'get', '', '', 'cms.web', 'detail', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'b95be4ff-869f-4066-9d48-3143b4289783', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (63, '2024-11-19 10:04:13', '2024-12-30 10:56:53', 'f07f1bab-5200-44d9-a74a-5a45b21d2142', 'cms首页', '/', '', 'get', '', '', 'cms.web', 'index', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'b95be4ff-869f-4066-9d48-3143b4289783', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (64, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '583e62ee-ea44-48f9-9b40-61d9b2d3d6b6', '系统管理', '', 'fa-solid fa-cubes', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3632bf23-e4a9-4b0d-af83-9b2f02316894', 1, 'schemaApi', '', 1, 'sys');
INSERT INTO `sys_routes` VALUES (65, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', '网站导航管理', '/sys/navigation', 'fa-solid fa-bars', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 6, 'schemaApi', '/pages/sys/navigation.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (66, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'ec8396b8-cb2d-4678-b5c4-f0131ebae417', '导航列表', '/admin/sys/navigation/index', '', 'get', '', '', 'sys.navigation', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (67, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '2bf43e0a-dc45-4aff-b358-dba528018353', '获取全部导航节点', '/admin/sys/navigation/topNavigation', '', 'get', '', '', 'sys.navigation', 'topNavigation', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', 1, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (68, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '1f7de75e-78d1-4bef-b216-bf859a3e87ff', '添加导航', '/admin/sys/navigation/navigationAdd', '', 'post', '', '', 'sys.navigation', 'navigationAdd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', 2, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (69, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '5b62519c-cd93-42e9-abbd-e45afede34ab', '编辑导航', '/admin/sys/navigation/navigationEdit', '', 'post', '', '', 'sys.navigation', 'navigationEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', 3, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (70, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'a29eb821-c694-4ed2-9ecd-5670b8321d51', '删除导航', '/admin/sys/navigation/navigationDel', '', 'get', '', '', 'sys.navigation', 'navigationDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', 4, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (71, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '0d6ef1bd-dba8-421c-950b-fbeb277d98c9', '排序', '/admin/sys/navigation/saveOrder', '', 'post', '', '', 'sys.navigation', 'saveOrder', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b303244c-9fac-4fb0-8f56-75fe4a5f3687', 5, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (72, '2024-11-19 10:04:13', '2024-12-30 10:57:01', '7ebc20ee-ef8b-4a26-b62e-bbfecb35afbe', 'cms列表', '/cms/list/:id', '', 'get', '', '', 'cms.web', 'list', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'b95be4ff-869f-4066-9d48-3143b4289783', 1, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (73, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'c97b54dd-a9e4-41b1-9517-8356505e65b2', '对象储存', '/sys/objectStorage', 'fa-solid fa-boxes-packing', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '73dc4727-4985-4c91-8feb-28fc3a6c4296', 3, 'schemaApi', '/pages/sys/objectStorage.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (74, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '52962835-0f8a-4e95-88ac-83410bcdc20c', '获取对象储存配置', '/admin/sys/objectStorage/objectStorageConfig', '', 'get', '', '', 'sys.objectStorage', 'objectStorageConfig', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c97b54dd-a9e4-41b1-9517-8356505e65b2', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (75, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '883ae755-d8a9-4ba9-af41-55c79c0c8fd3', '编辑配置', '/admin/sys/objectStorage/edit', '', 'post', '', '', 'sys.objectStorage', 'edit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c97b54dd-a9e4-41b1-9517-8356505e65b2', 1, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (76, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '7c6869d0-ddbd-4d8e-9ab4-6054f76042f8', 'Config 配置', '/sys/config', 'fa-solid fa-gear', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '583e62ee-ea44-48f9-9b40-61d9b2d3d6b6', 0, 'schemaApi', '/pages/sys/config.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (77, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'a6ed311a-f95c-48f2-ad7a-f0faf76abf77', 'MCenter', '', 'fa-solid fa-users', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3632bf23-e4a9-4b0d-af83-9b2f02316894', 0, 'schemaApi', '', 1, 'mc');
INSERT INTO `sys_routes` VALUES (78, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '28bc57ac-c0eb-4ea2-91f1-324c7394298b', '会员管理', '/mc/member', 'fa-solid fa-users-rectangle', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'a6ed311a-f95c-48f2-ad7a-f0faf76abf77', 0, 'schemaApi', '/pages/mc/member.json', 1, 'mc');
INSERT INTO `sys_routes` VALUES (79, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '3cf946a1-ee6e-42db-a8e9-4ad45bc8831c', '登录/注册', '/mc/login', '', 'get', '', 'mc.authMcToken', 'mc.index', 'login', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '0', 0, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (80, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '4cdd68af-7c28-4da8-8a9e-7851f80f9713', '登录接口', '/mc/loginPost', '', 'post', '', 'mc.authMcToken', 'mc.index', 'lginPost', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '3cf946a1-ee6e-42db-a8e9-4ad45bc8831c', 0, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (81, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'b5408317-a7a9-45f7-a14e-27f922768bd1', '会员注册', '/mc/signup', '', 'post', '', 'mc.authMcToken', 'mc.index', 'signup', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '3cf946a1-ee6e-42db-a8e9-4ad45bc8831c', 1, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (82, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'fe48c36e-05f0-4d8e-bbbe-0b9091378444', '退出登录', '/mc/logout', '', 'get', '', '', 'mc.index', 'logout', 1, 1, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '3cf946a1-ee6e-42db-a8e9-4ad45bc8831c', 2, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (83, '2024-11-19 10:04:13', '2024-12-30 10:58:00', '9df155b0-54ac-4050-a050-0ad742e4eb18', '会员中心', '/mc/index', '', 'get', '', '', 'mc.index', 'index', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '0', 1, 'schemaApi', '', 1, 'mc');
INSERT INTO `sys_routes` VALUES (84, '2024-11-19 10:04:13', '2024-12-30 10:58:27', '938fe349-6fee-43a9-8df0-fd8bd5281016', '会员设置', '/mc/setup', '', 'get', '', '', 'mc.setup', 'index', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '0', 3, 'schemaApi', '', 1, 'mc');
INSERT INTO `sys_routes` VALUES (85, '2024-11-19 10:04:13', '2024-12-30 10:58:32', '781b0489-4a79-4153-a0f9-06c64170d6e8', '上传头像', '/mc/setup/avatar', '', 'post', '', '', 'mc.setup', 'avatar', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 0, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (86, '2024-11-19 10:04:13', '2024-12-30 10:58:37', '9be5d585-7d18-4aa7-b204-0626f4ec632c', '更新会员信息', '/mc/setup/updateInfo', '', 'post', '', '', 'mc.setup', 'updateInfo', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 1, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (87, '2024-11-19 10:04:13', '2024-12-30 10:58:42', 'c6b3eed1-0cc7-4339-b55e-4d7c76792799', '更新邮箱', '/mc/setup/upEmail', '', 'post', '', '', 'mc.setup', 'upEmail', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 2, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (88, '2024-11-19 10:04:13', '2024-12-30 10:58:46', '85c698d9-6cb1-4f49-a3ee-39f184253826', '更新密码', '/mc/setup/upPassword', '', 'post', '', '', 'mc.setup', 'upPassword', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 3, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (89, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'cd820dc6-7088-488e-aa3e-f63f1b07dbe9', '评论管理', '/cms/comments', 'fa-solid fa-comments', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 3, 'schemaApi', '/pages/cms/comments.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (90, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 'cms评论', '', '', 'get', '', '', '', '', 0, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'b95be4ff-869f-4066-9d48-3143b4289783', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (91, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '7e2e27e1-77a0-4911-b030-96c1d9fb30f2', '添加评论', '/cms/comments/add', '', 'post', 'mc.authMcToken', '', 'cms.comments', 'add', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (92, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '10a7b4ec-0a1b-496e-89bb-af75c472f99a', '添加回复', '/cms/comments/replyAdd', '', 'post', 'mc.authMcToken', '', 'cms.comments', 'replyAdd', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (93, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '63a6b950-455e-429b-802b-fed8c12ce5ef', 'ajax获取评论内容', '/cms/comments/ajaxList', '', 'get', '', '', 'cms.comments', 'ajaxList', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (94, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '734dc692-b837-4060-a613-ce09b4df42f8', 'ajax回复评论', '/cms/comments/modalCommentReply', '', 'get', 'mc.authMcToken', '', 'cms.comments', 'modalCommentReply', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (95, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '4d316773-95ab-4e1b-8781-3523f0066480', '评论列表', '/admin/cms/comments/adminList', '', 'get', '', '', 'cms.comments', 'adminList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cd820dc6-7088-488e-aa3e-f63f1b07dbe9', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (96, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '7ff5e064-eb5f-4179-95aa-e4f98f93181e', '批量删除', '/admin/cms/comments/adminBulkDel', '', 'post', '', '', 'cms.comments', 'adminBulkDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cd820dc6-7088-488e-aa3e-f63f1b07dbe9', 1, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (97, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'd58b542a-ff2d-4006-b6a5-a8bce6a5f1f5', '删除单条评论', '/admin/cms/comments/adminDel', '', 'get', '', '', 'cms.comments', 'adminDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cd820dc6-7088-488e-aa3e-f63f1b07dbe9', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (98, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '42b6b485-0033-4b50-9d20-5363e3ef3573', '排序', '/admin/cms/doc/saveOrder', '', 'post', '', '', 'cms.doc', 'saveOrder', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (99, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'ac813b26-b80c-498e-ae15-e06c97530ee3', '删除评论', '/cms/comments/del', '', 'get', 'mc.authMcToken', '', 'cms.comments', 'del', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (100, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'f7282af9-43ef-4daf-ac72-8042c2521a56', 'ajax编辑评论', '/cms/comments/modalCommentEdit', '', 'get', 'mc.authMcToken', '', 'cms.comments', 'modalCommentEdit', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (101, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'e5a053e6-f53e-4cb4-be21-3285c40a9496', '编辑评论', '/cms/comments/edit', '', 'post', 'mc.authMcToken', '', 'cms.comments', 'edit', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (102, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'c6d4b929-5244-4e65-bfc8-a4fb0fb07711', '删除回复', '/cms/comments/replyDel', '', 'get', 'mc.authMcToken', '', 'cms.comments', 'replyDel', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (103, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '91072ee6-2ce4-4d6d-94a5-6c54755ca401', 'ajax编辑回复', '/cms/comments/modalCommentReplyEdit', '', 'get', 'mc.authMcToken', '', 'cms.comments', 'modalCommentReplyEdit', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (104, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'd023ca51-547d-41f2-9c47-22788c05643e', '编辑回复', '/cms/comments/replyEdit', '', 'post', 'mc.authMcToken', '', 'cms.comments', 'replyEdit', 1, 1, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'df1cd882-409c-42cc-a259-bfc2f2d20ba3', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (105, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '364cf1a7-06f7-402a-a1a9-e41b00f3a067', '批量删除', '/admin/cms/doc/bulkDel', '', 'post', '', '', 'cms.doc', 'bulkDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (106, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'f1d1dd33-be9c-46ee-b7de-4243f06e7e38', '回收站列表', '/admin/cms/recycle/index', '', 'get', '', '', 'cms.recycle', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f0840f4a-05aa-4715-8c75-dd9557558068', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (107, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '42a56206-34ee-424f-a746-85e26088611b', '删除文档', '/admin/cms/recycle/del', '', 'get', '', '', 'cms.recycle', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f0840f4a-05aa-4715-8c75-dd9557558068', 1, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (108, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'c1c232e0-f972-4f30-b84f-b58f9774ede0', '批量删除', '/admin/cms/recycle/bulkDel', '', 'post', '', '', 'cms.recycle', 'bulkDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f0840f4a-05aa-4715-8c75-dd9557558068', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (109, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '7ddca162-2176-4c6b-b9c4-eb6617fcc2b8', '恢复文档', '/admin/cms/recycle/restore', '', 'get', '', '', 'cms.recycle', 'restore', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f0840f4a-05aa-4715-8c75-dd9557558068', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (110, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'ae87c0f7-0bad-4599-abc1-1dba32dbb8a2', '批量恢复', '/admin/cms/recycle/bulkRestore', '', 'post', '', '', 'cms.recycle', 'bulkRestore', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'f0840f4a-05aa-4715-8c75-dd9557558068', 4, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (111, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'fec429c3-7851-4900-ade7-cbb34cbd8ead', '会员列表', '/admin/mc/member/list', '', 'get', '', '', 'mc.member', 'list', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '28bc57ac-c0eb-4ea2-91f1-324c7394298b', 0, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (112, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'aa8a6e25-53fb-4ee2-ae97-fb4683137926', '添加会员', '/admin/mc/member/add', '', 'post', '', '', 'mc.member', 'add', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '28bc57ac-c0eb-4ea2-91f1-324c7394298b', 1, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (113, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '82708cbc-ce22-49e7-bb1a-b6a7a46aeb6c', '编辑会员', '/admin/mc/member/edit', '', 'post', '', '', 'mc.member', 'edit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '28bc57ac-c0eb-4ea2-91f1-324c7394298b', 2, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (114, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'a568df82-5598-4913-8c25-5a72f2357c1f', '删除会员', '/admin/mc/member/del', '', 'get', '', '', 'mc.member', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '28bc57ac-c0eb-4ea2-91f1-324c7394298b', 3, 'schemaApi', '', 0, 'mc');
INSERT INTO `sys_routes` VALUES (115, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', '模板管理', '/cms/template', 'fa-solid fa-code', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 5, 'schemaApi', '/pages/cms/template.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (116, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'd3ae5a1a-5937-4730-9223-2c44d8ac7ce5', '模板列表', '/admin/cms/template', '', 'get', '', '', 'cms.template', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (117, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '5f6a52cb-02a8-4d4f-8c12-07d49de2d283', '添加模板', '/admin/cms/template/add', '', 'post', '', '', 'cms.template', 'add', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 1, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (118, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '7e4ffa63-5073-43f6-9813-95d73f4132ce', '编辑模板', '/cms/template/:uuid', '', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 2, 'schemaApi', '/pages/cms/templateEdit.json', 0, 'cms');
INSERT INTO `sys_routes` VALUES (119, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'e015adf3-bc53-4afe-ad1c-73d75ad9bb51', '模板详情', '/admin/cms/template/info', '', 'get', '', '', 'cms.template', 'info', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (120, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '8227a516-85b2-4321-b10b-7abbdc8590e9', '模板列表', '/admin/cms/template/list', '', 'get', '', '', 'cms.template', 'list', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '7e4ffa63-5073-43f6-9813-95d73f4132ce', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (121, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'e3fcb7ba-0e04-423a-810e-e28be1103578', '添加模板', '/admin/cms/template/listadd', '', 'post', '', '', 'cms.template', 'listadd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '7e4ffa63-5073-43f6-9813-95d73f4132ce', 1, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (122, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '81e816b8-2ef0-4565-bc1c-6b47075ad6aa', '编辑模板文件', '/admin/cms/template/listedit', '', 'post', '', '', 'cms.template', 'listedit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '7e4ffa63-5073-43f6-9813-95d73f4132ce', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (123, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '9569c4e6-5e78-485f-90e9-6b9880c0a282', '删除模板文件', '/admin/cms/template/listdel', '', 'get', '', '', 'cms.template', 'listdel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '7e4ffa63-5073-43f6-9813-95d73f4132ce', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (124, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '60abe343-9962-42e5-b3a7-1babe4caa281', '使用首页模板', '/admin/cms/template/listuse', '', 'get', '', '', 'cms.template', 'listuse', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '7e4ffa63-5073-43f6-9813-95d73f4132ce', 4, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (125, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '9a5ee2dc-058c-416c-b2a5-3a853ed0d7f4', '编辑模板', '/admin/cms/template/edit', '', 'post', '', '', 'cms.template', 'edit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 4, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (126, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'c091b22b-1013-4c5b-adcd-9a509cafd2fb', '删除模板', '/admin/cms/template/del', '', 'get', '', '', 'cms.template', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 5, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (127, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '5ef2e0fb-6f55-4b60-8746-77fa51f2e773', '使用模板', '/admin/cms/template/use', '', 'get', '', '', 'cms.template', 'use', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 6, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (128, '2024-11-19 10:04:13', '2025-01-26 14:33:05', 'e98243f4-70d9-49ca-a374-b480d0ab55ce', '导出模板', '/admin/cms/template/export', '', 'get', '', '', 'cms.template', 'export', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 7, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (129, '2024-11-19 10:04:13', '2025-01-26 14:33:05', 'cdcf4c23-f1b8-4b73-bc3b-7bfa4c2378aa', '导入模板', '/admin/cms/template/import', '', 'post', '', '', 'cms.template', 'import', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 8, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (130, '2024-11-19 10:04:13', '2025-01-26 14:33:05', '00c400a2-63dc-468a-9f4a-c56457d69009', '获取模板', '/admin/cms/template/getTemplate', '', 'get', '', '', 'cms.template', 'getTemplate', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'da683795-5e01-4470-8fbc-ac1b8fff2aa4', 9, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (131, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '9854cf99-9933-44cf-b6bb-e58c58a33547', 'CMS管理', '', '', 'get', '', '', '', '', 0, 1, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '0', 2, 'schemaApi', '', 1, 'mc');
INSERT INTO `sys_routes` VALUES (132, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '51b6a4e0-8c94-4047-b8dc-5f3c14c07191', '评论管理', '/mc/cms/comment', '', 'get', '', '', 'cms.comments', 'mcComment', 1, 1, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '9854cf99-9933-44cf-b6bb-e58c58a33547', 0, 'schemaApi', '', 1, 'mc');
INSERT INTO `sys_routes` VALUES (133, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '3ad18fdb-1bea-484a-b443-a64041b374d2', '配置管理', '/sys/setup', 'fa-solid fa-kitchen-set', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '73dc4727-4985-4c91-8feb-28fc3a6c4296', 4, 'schemaApi', '/pages/sys/setup.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (134, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'ab0076a0-9ba5-4ab4-9ef3-33571ae806d8', '配置列表', '/admin/sys/setup', '', 'get', '', '', 'sys.config', 'setup', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3ad18fdb-1bea-484a-b443-a64041b374d2', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (135, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '45bff19c-c659-4e8d-8a6a-48df2a856c9c', '添加配置', '/admin/sys/setupAdd', '', 'post', '', '', 'sys.config', 'setupAdd', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3ad18fdb-1bea-484a-b443-a64041b374d2', 1, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (136, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '8e513bfa-3a16-4ef5-91ec-94d0cc644deb', '编辑配置', '/admin/sys/setupEdit', '', 'post', '', '', 'sys.config', 'setupEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3ad18fdb-1bea-484a-b443-a64041b374d2', 2, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (137, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'aa9167d4-0c4e-4ea2-97b2-2b60825448dc', '删除配置', '/admin/sys/setupDel', '', 'get', '', '', 'sys.config', 'setupDel', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '3ad18fdb-1bea-484a-b443-a64041b374d2', 3, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (138, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '3574841e-30a0-407a-bbe2-6a06187ea51e', 'CMS配置', '/cms/config', 'fa-solid fa-gear', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 7, 'schemaApi', '/pages/cms/config.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (139, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '8d960fd1-2500-4e47-ac16-e909401cabbb', '应用管理', '/sys/application', 'fa-brands fa-app-store', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '73dc4727-4985-4c91-8feb-28fc3a6c4296', 0, 'schemaApi', '/pages/sys/application.json', 1, 'sys');
INSERT INTO `sys_routes` VALUES (140, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'dc57a554-7950-4f74-acc9-dd79a51ed792', '获取应用', '/admin/sys/routes/application', '', 'get', '', '', 'sys.routes', 'application', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c5f8768a-f1f4-406b-b587-755e03332823', 1, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (141, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '6739cee2-8e6b-4a51-8f2f-f824067445dd', '模型列表', '/admin/sys/models', '', 'get', '', '', 'sys.models', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 2, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (142, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '82b50233-32a2-458c-a940-f17c369146e7', '获取应用', '/admin/sys/models/application', '', 'get', '', '', 'sys.models', 'application', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 3, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (143, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '8c686c6d-bc0d-465c-bf54-66dd2b7f09ae', '应用列表', '/admin/sys/application', '', 'get', '', '', 'sys.application', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8d960fd1-2500-4e47-ac16-e909401cabbb', 0, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (144, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '50e92d9a-0527-4167-9e8e-30becce7d55b', '添加应用', '/admin/sys/application/add', '', 'post', '', '', 'sys.application', 'add', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8d960fd1-2500-4e47-ac16-e909401cabbb', 4, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (145, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '9e0421ab-4726-41d7-a76f-5f21f42993e7', '编辑应用', '/admin/sys/application/edit', '', 'post', '', '', 'sys.application', 'edit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8d960fd1-2500-4e47-ac16-e909401cabbb', 5, 'schemaApi', '', 0, 'sys');
INSERT INTO `sys_routes` VALUES (146, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', '附件管理', '/cms/attachment', 'fa-solid fa-file-arrow-up', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'cb56c9d4-544b-49c3-ada1-200c6c155413', 2, 'schemaApi', '/pages/cms/attachment.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (147, '2024-11-19 10:04:13', '2025-01-26 14:33:03', 'c04a0248-940c-4699-83fc-f5f2a86b2103', '附件列表', '/admin/cms/attachment/list', '', 'get', '', '', 'cms.attachment', 'list', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 0, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (148, '2024-11-19 10:04:13', '2025-01-26 14:33:03', '6c1292f3-2053-4425-a482-4d44d33ebcb8', '新增附件', '/admin/cms/attachment/add', '', 'post', '', '', 'cms.attachment', 'add', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 2, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (149, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '787178df-f317-423b-8303-2e6f6a4c97a1', '删除附件', '/admin/cms/attachment/del', '', 'post', '', '', 'cms.attachment', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 3, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (150, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '43af6778-912d-4b97-b651-8e01ab0cdedc', '编辑附件', '/admin/cms/attachment/edit', '', 'post', '', '', 'cms.attachment', 'edit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 4, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (151, '2024-11-19 10:04:13', '2025-01-26 14:33:04', 'e0b829a7-79bc-417e-af38-43139ee995ad', '编辑附件上传', '/admin/cms/attachment/editUpload/:id', '', 'post', '', '', 'cms.attachment', 'editUpload', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 5, 'schemaApi', '', 0, 'cms');
INSERT INTO `sys_routes` VALUES (152, '2024-11-19 10:04:13', '2025-01-26 14:33:04', '9809c524-c86d-41ff-b5d5-30f79e584cae', '附件选取', '/cms/attachment/select', '', 'get', '', '', '', '', 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 6, 'schemaApi', '/pages/cms/attachment_sel.json', 1, 'cms');
INSERT INTO `sys_routes` VALUES (153, '2024-11-21 10:40:56', '2025-01-26 14:33:03', '8c67affd-2aa9-45ed-b929-09cc0bc23f63', '文档快速编辑', '/admin/cms/doc/quickDocEdit', NULL, 'post', NULL, NULL, 'cms.doc', 'quickDocEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '994e88d4-39a4-495c-bb57-9c8b220924e5', 1, 'schemaApi', NULL, 0, 'cms');
INSERT INTO `sys_routes` VALUES (154, '2024-11-21 15:01:29', '2024-11-21 15:01:29', 'bb274366-fb91-4258-aeea-998290b4a553', 'cms搜索', '/cms/search', NULL, 'get', NULL, NULL, 'cms.web', 'search', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'b95be4ff-869f-4066-9d48-3143b4289783', 0, 'schemaApi', NULL, 0, 'cms');
INSERT INTO `sys_routes` VALUES (155, '2024-11-26 15:00:27', '2025-01-26 14:33:04', '7af86d3d-7178-41fb-bb41-4a6bcb6a2400', '导出表数据', '/admin/sys/models/exportData', NULL, 'post', NULL, NULL, 'sys.models', 'exportData', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 1, 'schemaApi', NULL, 0, 'sys');
INSERT INTO `sys_routes` VALUES (156, '2024-12-11 14:23:54', '2025-01-24 09:39:25', '66b63331-b630-4875-b6ce-b1a109f59b37', '发送短信验证码', '/mc/sendSms', NULL, 'post', NULL, 'mc.authMcToken', 'mc.index', 'sendSms', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '0', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (157, '2024-12-11 15:30:21', '2024-12-11 15:30:21', '5afcf0d0-459f-4949-9a23-3e55b6565d2e', '更新手机号', '/mc/setup/upMobile', NULL, 'post', NULL, NULL, 'mc.setup', 'upMobile', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (158, '2024-12-17 10:31:34', '2024-12-17 10:31:34', 'bd81ae6e-7792-4334-a943-1d8c6359d204', '激活邮箱', '/mc/setup/upEmailActiveLink', NULL, 'get', NULL, NULL, 'mc.setup', 'upEmailActiveLink', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (159, '2024-12-18 14:15:33', '2024-12-18 14:15:33', '82cbe41d-9e76-47f1-b958-712a342530f9', '绑定微信', '/mc/setup/bindWechat', NULL, 'get', NULL, NULL, 'mc.setup', 'bindWechat', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '938fe349-6fee-43a9-8df0-fd8bd5281016', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (160, '2024-12-18 16:03:29', '2024-12-18 16:03:29', '138e3b1b-7e0c-4be6-9f3b-ff876e380545', '重置密码', '/mc/resetPassword', NULL, 'post', NULL, 'mc.authMcToken', 'mc.index', 'resetPassword', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '3cf946a1-ee6e-42db-a8e9-4ad45bc8831c', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (161, '2024-12-25 14:01:35', '2025-01-26 14:33:03', '763c6d86-76f5-4aa9-9f80-451f938f9775', '删除应用', '/admin/sys/application/del', NULL, 'post', NULL, NULL, 'sys.application', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8d960fd1-2500-4e47-ac16-e909401cabbb', 1, 'schemaApi', NULL, 0, 'sys');
INSERT INTO `sys_routes` VALUES (162, '2024-12-25 14:02:49', '2025-01-26 14:33:04', '67f430ec-623e-43a0-b373-20515c797d96', '导出应用', '/admin/sys/application/export', NULL, 'get', NULL, NULL, 'sys.application', 'export', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8d960fd1-2500-4e47-ac16-e909401cabbb', 2, 'schemaApi', NULL, 0, 'sys');
INSERT INTO `sys_routes` VALUES (163, '2024-12-25 16:46:08', '2025-01-26 14:33:04', '005205f7-26b2-4c55-b455-1e97543ef41e', '导入应用', '/admin/sys/application/import', NULL, 'post', NULL, NULL, 'sys.application', 'import', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8d960fd1-2500-4e47-ac16-e909401cabbb', 3, 'schemaApi', NULL, 0, 'sys');
INSERT INTO `sys_routes` VALUES (164, '2024-12-26 16:40:16', '2024-12-26 16:40:16', '1b162c88-1936-4ebd-916c-cc5ad9acd33b', '附件', '', NULL, 'get', NULL, NULL, NULL, NULL, 0, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '0', 0, 'schemaApi', NULL, 0, 'cms');
INSERT INTO `sys_routes` VALUES (165, '2024-12-26 16:41:24', '2024-12-26 16:41:24', '1a4c008a-fef2-4b3f-9f86-047780b3d956', '获取附件文件', '/cms/attachment/getFile/:id', NULL, 'get', NULL, NULL, 'cms.attachment', 'getFile', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '1b162c88-1936-4ebd-916c-cc5ad9acd33b', 0, 'schemaApi', NULL, 0, 'cms');
INSERT INTO `sys_routes` VALUES (166, '2024-12-27 11:08:24', '2025-01-26 14:33:03', '0dde876d-e6d1-4434-ab06-dac316fb464f', '切换附件状态', '/admin/cms/attachment/toggleStatus/:id', NULL, 'post', NULL, NULL, 'cms.attachment', 'toggleStatus', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'b3b2867c-2c8b-4fad-88a3-cb62151c7699', 1, 'schemaApi', NULL, 0, 'cms');
INSERT INTO `sys_routes` VALUES (167, '2024-12-30 16:26:13', '2025-01-26 14:33:03', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', '表单管理', '', 'fa-solid fa-table', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '740d33b4-3cc1-4022-bce0-d49ff11a2978', 2, 'schemaApi', NULL, 1, 'form');
INSERT INTO `sys_routes` VALUES (168, '2024-12-30 16:47:37', '2025-01-26 14:33:03', '9bbc93c1-dfc1-414d-bada-a864abcad7bb', '表单列表管理', '/admin/form/list', 'fa-solid fa-list-ul', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 0, 'schemaApi', '/pages/form/list.json', 1, 'form');
INSERT INTO `sys_routes` VALUES (169, '2024-12-30 16:55:38', '2025-01-26 14:33:03', 'a5b0b9eb-eff5-46e8-82d3-771ca44b4e09', '表单列表', '/admin/form/list', NULL, 'get', NULL, NULL, 'form.admin', 'list', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 1, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (170, '2024-12-31 10:22:32', '2025-01-26 14:33:03', '772a6f34-1895-4a02-baca-c6983e3c36da', '添加表单', '/admin/form/add', NULL, 'post', NULL, NULL, 'form.admin', 'add', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 2, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (171, '2024-12-31 10:56:56', '2025-01-26 14:33:03', '0027dce7-a5f6-42e8-857b-703f17510cdf', '编辑表单', '/admin/form/edit', NULL, 'post', NULL, NULL, 'form.admin', 'edit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 3, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (172, '2024-12-31 11:05:59', '2025-01-26 14:33:03', 'e81edc8b-c937-4d40-98f7-2f5ec424acd3', '删除表单', '/admin/form/del', NULL, 'post', NULL, NULL, 'form.admin', 'del', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 4, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (173, '2025-01-02 16:29:01', '2025-01-02 16:29:01', 'c2ddd2a1-046f-455b-9a4e-79350bbc175a', '表单', '', NULL, 'get', NULL, NULL, NULL, NULL, 0, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '0', 0, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (174, '2025-01-02 16:43:47', '2025-01-03 09:46:06', '5025250f-df1b-404d-a481-e89772f1dba8', '表单前端页面', '/form/index', NULL, 'get', '', NULL, 'form.index', 'index', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'c2ddd2a1-046f-455b-9a4e-79350bbc175a', 0, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (175, '2025-01-06 15:02:58', '2025-01-26 14:33:03', '4d74f821-4f96-47ed-9458-644397b0bf5a', '表单数据列表管理', '/admin/form/dataList/:form_id', 'fa-solid fa-list-check', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 5, 'schemaApi', '/pages/form/dataList.json', 0, 'form');
INSERT INTO `sys_routes` VALUES (176, '2025-01-06 15:04:19', '2025-01-26 14:33:04', 'f9ffdd85-b55b-4e49-90ea-9ac51bf4bfb3', '表单数据列表', '/admin/form/dataList/:form_id', NULL, 'get', NULL, NULL, 'form.admin', 'dataList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 6, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (177, '2025-01-06 15:11:58', '2025-01-06 15:37:12', 'c7ede46f-2f67-4ba2-ba51-c497f229db98', '表单数据提交', '/form/submit', NULL, 'post', '', NULL, 'form.index', 'submit', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'c2ddd2a1-046f-455b-9a4e-79350bbc175a', 0, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (178, '2025-01-06 15:12:54', '2025-01-14 13:40:21', 'c5d9aee5-7a7d-41b0-90ed-14e03fc8b997', '表单个人提交数据列表', '/form/list', NULL, 'get', '', NULL, 'form.index', 'list', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'c2ddd2a1-046f-455b-9a4e-79350bbc175a', 0, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (179, '2025-01-09 11:40:21', '2025-01-26 14:33:04', '495d9bd5-bf18-40f5-ba9c-b9800cba9b32', '表单数据修改', '/admin/form/dataEdit', NULL, 'post', NULL, NULL, 'form.admin', 'dataEdit', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', 'c8e534ee-6bf4-4e54-80c1-5e0e00ee3b13', 7, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (180, '2025-01-13 11:41:26', '2025-01-13 11:41:26', '2a1be329-1dd2-40e1-bb17-288916eb20b2', '图形验证码', '/mc/captcha', NULL, 'get', NULL, 'mc.authMcToken', 'mc.index', 'captcha', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '0', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (181, '2025-01-14 13:41:26', '2025-01-14 13:41:26', '456bb090-3f84-4720-9bc6-f003fe4da8dc', '表单数据删除', '/form/del', NULL, 'post', NULL, NULL, 'form.index', 'del', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'c2ddd2a1-046f-455b-9a4e-79350bbc175a', 0, 'schemaApi', NULL, 0, 'form');
INSERT INTO `sys_routes` VALUES (182, '2025-01-15 11:14:48', '2025-01-26 14:33:03', '9ab8bc55-79c2-4567-8863-80c810d67586', '专题管理', '', 'fa-solid fa-newspaper', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '740d33b4-3cc1-4022-bce0-d49ff11a2978', 3, 'schemaApi', NULL, 1, 'special');
INSERT INTO `sys_routes` VALUES (183, '2025-01-15 11:18:08', '2025-01-26 14:33:03', '683acb14-87be-486c-b192-5a118d817e70', '专题列表管理', '/admin/special/list', 'fa-solid fa-list-ul', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '9ab8bc55-79c2-4567-8863-80c810d67586', 0, 'schemaApi', '/pages/special/list.json', 1, 'special');
INSERT INTO `sys_routes` VALUES (184, '2025-01-15 11:21:01', '2025-01-26 14:33:03', '0fd3fee0-f0a6-4082-b07e-298ecbfbaa4f', '专题列表', '/admin/special/list', NULL, 'get', NULL, NULL, 'special.admin', 'list', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '9ab8bc55-79c2-4567-8863-80c810d67586', 1, 'schemaApi', NULL, 0, 'special');
INSERT INTO `sys_routes` VALUES (185, '2025-01-15 11:22:05', '2025-01-15 11:22:05', '70d0ff3c-9d3c-4b1b-b267-5b6a5a49abb8', '专题', '', NULL, 'get', NULL, NULL, NULL, NULL, 0, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '0', 0, 'schemaApi', NULL, 0, 'special');
INSERT INTO `sys_routes` VALUES (186, '2025-01-15 11:22:54', '2025-01-22 09:44:24', 'cd3e108b-222f-47bd-a5b4-9cdaf614ca20', '专题首页', '/special.html', NULL, 'get', NULL, NULL, 'special.index', 'index', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '70d0ff3c-9d3c-4b1b-b267-5b6a5a49abb8', 0, 'schemaApi', NULL, 0, 'special');
INSERT INTO `sys_routes` VALUES (187, '2025-01-15 11:23:33', '2025-01-15 11:23:33', '039bd5a8-f84b-466f-98a4-71891e02e435', '专题详情', '/special/:id', NULL, 'get', NULL, NULL, 'special.index', 'info', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '70d0ff3c-9d3c-4b1b-b267-5b6a5a49abb8', 0, 'schemaApi', NULL, 0, 'special');
INSERT INTO `sys_routes` VALUES (188, '2025-01-20 10:04:32', '2025-01-26 14:33:03', 'f269ab47-1b31-45e5-9dcc-fdb1e43d5985', '专题数据列表管理', '/admin/special/dataList/:special_id', 'fa-solid fa-list-check', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '9ab8bc55-79c2-4567-8863-80c810d67586', 2, 'schemaApi', '/pages/special/dataList.json', 0, 'special');
INSERT INTO `sys_routes` VALUES (189, '2025-01-20 10:06:10', '2025-01-26 14:33:03', '24f44944-1360-4c79-9087-fc542ac3331c', '专题数据列表', '/admin/special/dataList/:special_id', NULL, 'get', NULL, NULL, 'special.admin', 'dataList', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '9ab8bc55-79c2-4567-8863-80c810d67586', 3, 'schemaApi', NULL, 0, 'special');
INSERT INTO `sys_routes` VALUES (190, '2025-01-24 09:45:55', '2025-01-24 09:45:55', '24b81aef-f61f-4d5d-863e-edfcd64d27a6', '手机短信登录', '/mc/loginByMobileCode', NULL, 'post', NULL, 'mc.authMcToken', 'mc.index', 'loginByMobileCode', 1, 0, '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', '3cf946a1-ee6e-42db-a8e9-4ad45bc8831c', 0, 'schemaApi', NULL, 0, 'mc');
INSERT INTO `sys_routes` VALUES (191, '2025-01-26 14:32:47', '2025-01-26 14:34:54', '08e29e88-dc61-4de4-983a-306c5c6c179a', '签到墙活动管理', '', 'fa-solid fa-globe', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '740d33b4-3cc1-4022-bce0-d49ff11a2978', 4, 'schemaApi', NULL, 1, 'wall');
INSERT INTO `sys_routes` VALUES (192, '2025-01-26 14:36:34', '2025-01-26 14:36:50', '5a1b9ce5-dc93-4897-b66e-870963e31d5b', '签到墙活动列表管理', '/admin/wall/list', 'fa-solid fa-list-ul', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '08e29e88-dc61-4de4-983a-306c5c6c179a', 0, 'schemaApi', '/pages/wall/list.json', 1, 'wall');
INSERT INTO `sys_routes` VALUES (193, '2025-02-06 19:27:02', '2025-02-06 19:28:45', 'b533a5e8-1549-4b57-b5f1-b049ea7fddd6', '签到墙奖品管理', '/admin/wall/awardList/:wall_id', 'fa-solid fa-list-check', 'get', NULL, NULL, NULL, NULL, 0, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '08e29e88-dc61-4de4-983a-306c5c6c179a', 0, 'schemaApi', '/pages/wall/awardList.json', 0, 'wall');
INSERT INTO `sys_routes` VALUES (194, '2025-02-07 10:35:04', '2025-02-07 10:35:04', 'aba384b9-393d-4c31-a055-657720d2dfda', '签到墙', '', NULL, 'get', NULL, NULL, NULL, NULL, 0, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', '0', 0, 'schemaApi', NULL, 0, 'wall');
INSERT INTO `sys_routes` VALUES (195, '2025-02-07 10:36:07', '2025-02-07 10:36:07', '429bc2f7-bc8b-43c6-9440-c70104b023f5', '签到墙前端页面', '/wall/index', NULL, 'get', NULL, NULL, 'wall.index', 'index', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'aba384b9-393d-4c31-a055-657720d2dfda', 0, 'schemaApi', NULL, 0, 'wall');
INSERT INTO `sys_routes` VALUES (196, '2025-02-07 10:37:29', '2025-02-07 10:37:29', '86a89271-a6e7-4862-85c2-11470dee039b', '签到', '/wall/sign', NULL, 'post', NULL, NULL, 'wall.index', 'sign', 1, 0, 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', 'aba384b9-393d-4c31-a055-657720d2dfda', 0, 'schemaApi', NULL, 0, 'wall');
INSERT INTO `sys_routes` VALUES (197, '2025-02-08 10:29:27', '2025-02-08 10:29:27', '271fce8d-da0f-4c83-bed4-ab1362507c00', '签到墙大屏页面', '/admin/wall/index', NULL, 'get', NULL, NULL, 'wall.admin', 'index', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '08e29e88-dc61-4de4-983a-306c5c6c179a', 0, 'schemaApi', NULL, 0, 'wall');
INSERT INTO `sys_routes` VALUES (198, '2025-02-08 10:30:39', '2025-02-08 10:30:39', '0b888a8b-7e67-4310-8fd8-f638bede7275', '签到墙抽奖页面', '/admin/wall/lottery', NULL, 'get', NULL, NULL, 'wall.admin', 'lottery', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '08e29e88-dc61-4de4-983a-306c5c6c179a', 0, 'schemaApi', NULL, 0, 'wall');
INSERT INTO `sys_routes` VALUES (199, '2025-02-08 10:33:05', '2025-02-08 10:33:05', '3b3887b3-ff22-4a32-9e5c-bdbf352044c7', '签到墙抽奖', '/admin/wall/lottery', NULL, 'post', NULL, NULL, 'wall.admin', 'lotteryPost', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '08e29e88-dc61-4de4-983a-306c5c6c179a', 0, 'schemaApi', NULL, 0, 'wall');
INSERT INTO `sys_routes` VALUES (200, '2025-02-17 10:58:17', '2025-02-17 10:58:17', '759a325c-e1d0-4bb3-8b5b-f49800e276ef', '同步模型到数据库', '/admin/sys/models/sync', NULL, 'post', NULL, NULL, 'sys.models', 'sync', 1, 1, '8f5757a3-8af9-45db-8819-d767aaddfadb', '8bce1410-e917-4ff5-8de5-ad1cf7d7584f', 0, 'schemaApi', NULL, 0, 'sys');

-- ----------------------------
-- Table structure for sys_routes_classify
-- ----------------------------
DROP TABLE IF EXISTS `sys_routes_classify`;
CREATE TABLE `sys_routes_classify`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `middleware` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '在 Router 里面可以配置多个 Middleware',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `sort` int(11) NULL DEFAULT 0 COMMENT '越小越靠前',
  `sys` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_routes_classify_uuid`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_routes_classify
-- ----------------------------
INSERT INTO `sys_routes_classify` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '后台', '8f5757a3-8af9-45db-8819-d767aaddfadb', 'sys.authAdminToken,sys.rbac', '系统后台', 0, 1);
INSERT INTO `sys_routes_classify` VALUES (2, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '前台', 'dc92053d-d9cf-48ae-b0c1-6c237b5010ca', NULL, '系统前台', 1, 1);
INSERT INTO `sys_routes_classify` VALUES (3, '2024-11-19 10:04:13', '2024-11-19 10:04:13', 'MCenter', '1cfc8cb1-ca26-4d5e-8499-cc0222bbc4c9', 'mc.authMcToken', '会员中心(MCenter),Member Center 简称 MC,整个系统的会员管理系统。', 0, 1);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `state` tinyint(1) NULL DEFAULT 1 COMMENT '状态false禁用true正常',
  `group_uuid` char(36) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '组织id',
  `admin` tinyint(1) NULL DEFAULT 0 COMMENT '系统管理员',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `uuid` char(36) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'uuid',
  `deletedAt` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_user_username`(`username`) USING BTREE,
  UNIQUE INDEX `sys_user_uuid`(`uuid`) USING BTREE,
  INDEX `sys_user_group_uuid`(`group_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'b8888b7fe57b23cc1ce661138e5233d5', '271628543@qq.com', '18681851637', 1, '9decbce5-3006-482b-9c0a-c85aa534c766', 1, '2024-12-30 08:00:00', '2024-12-30 08:00:00', '32316132-086b-44cc-baa9-419618531dff', NULL);

-- ----------------------------
-- Table structure for sys_user_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_group`;
CREATE TABLE `sys_user_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分组名称',
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'uuid',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分组说明',
  `puuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '父uuid',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_user_group_uuid`(`uuid`) USING BTREE,
  INDEX `sys_user_group_puuid`(`puuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_group
-- ----------------------------
INSERT INTO `sys_user_group` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '管理员', '9decbce5-3006-482b-9c0a-c85aa534c766', NULL, '0', 0);
INSERT INTO `sys_user_group` VALUES (2, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '编辑', '984a0cba-7e19-49a3-92b3-6aa497367a66', NULL, '0', 0);
INSERT INTO `sys_user_group` VALUES (3, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '游客', '7e0e06c5-dd3e-4779-89bf-646c49fd5c6b', NULL, '0', 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `role_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色uuid',
  `user_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户uuid',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sys_user_role_role_uuid`(`role_uuid`) USING BTREE,
  INDEX `sys_user_role_user_uuid`(`user_uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, '2024-11-19 10:04:13', '2024-11-19 10:04:13', '2154b89e-8a29-4758-b77f-1e54a9f397e2', '19789f2a-7abc-434e-9fe1-ed66db1cf8f3');
INSERT INTO `sys_user_role` VALUES (2, '2024-12-30 11:25:17', '2024-12-30 11:25:17', '9f42247a-46e7-4b9c-8d05-660573cf5b2b', '32316132-086b-44cc-baa9-419618531dff');
INSERT INTO `sys_user_role` VALUES (3, '2024-12-30 13:34:34', '2024-12-30 13:34:34', '9f42247a-46e7-4b9c-8d05-660573cf5b2b', '35ded470-93e8-4279-a396-f5cbbc525317');
INSERT INTO `sys_user_role` VALUES (4, '2024-12-30 13:34:34', '2024-12-30 13:34:34', '8cf0b447-b49f-4886-bc45-922bc00da975', '35ded470-93e8-4279-a396-f5cbbc525317');

-- ----------------------------
-- Table structure for wall
-- ----------------------------
DROP TABLE IF EXISTS `wall`;
CREATE TABLE `wall`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动标题',
  `config` json NOT NULL COMMENT '活动配置',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wall_award
-- ----------------------------
DROP TABLE IF EXISTS `wall_award`;
CREATE TABLE `wall_award`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `wall_id` int(11) NOT NULL COMMENT '签到墙活动id',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '奖品名字',
  `count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '奖品数量',
  `index` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '抽奖轮次',
  `config` json NOT NULL COMMENT '奖品其他配置',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `wall_award_wall_id`(`wall_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wall_qd_data
-- ----------------------------
DROP TABLE IF EXISTS `wall_qd_data`;
CREATE TABLE `wall_qd_data`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createdAt` datetime(0) NOT NULL COMMENT '创建时间',
  `updatedAt` datetime(0) NOT NULL COMMENT '更新时间',
  `wall_id` int(11) NOT NULL COMMENT '签到墙活动id',
  `openid` char(36) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '用户微信id',
  `award_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '中奖奖品id(未中奖为0)',
  `data` json NOT NULL COMMENT '用户数据',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `wall_qd_data_openid_wall_id`(`openid`, `wall_id`) USING BTREE,
  INDEX `wall_qd_data_wall_id`(`wall_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
