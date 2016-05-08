##############################################################################
# Convert Old YabbSE table to phpBB 2 tables. Specific to intothepit.org     #
# Author  :   SweetmanC                                                      #
# Origin Date    :   11 Nov 06                                               #
# Completed Date: 10 Feb 12                                                  #
# Converts Users/Categories/Forums/Topics/Posts                              #
# The below Script needs to be run on the live SQL server before uploading   #
# the new data into the tables.This is so the old topics/forum ids are first.#
--#############################################################################
#
 
use phpbb_2;

--#=======================================
--# USER DATA CONVERSION
--#=======================================
DROP TABLE IF EXISTS `phpbb_users`;

CREATE TABLE `phpbb_users` (
   `user_id` mediumint(8) NOT NULL default '0',
   `user_active` tinyint(1) default '1',
   `username` varchar(25) NOT NULL default '',
   `user_password` varchar(32) NOT NULL default '',
   `user_session_time` int(11) NOT NULL default '0',
   `user_session_page` smallint(5) NOT NULL default '0',
   `user_lastvisit` int(11) NOT NULL default '0',
   `user_regdate` int(11) NOT NULL default '0',
   `user_level` tinyint(4) default '0',
   `user_posts` mediumint(8) unsigned NOT NULL default '0',
   `user_timezone` decimal(5,2) NOT NULL default '0.00',
   `user_style` tinyint(4) default NULL,
   `user_lang` varchar(255) default NULL,
   `user_dateformat` varchar(14) NOT NULL default 'd M Y H:i',
   `user_new_privmsg` smallint(5) unsigned NOT NULL default '0',
   `user_unread_privmsg` smallint(5) unsigned NOT NULL default '0',
   `user_last_privmsg` int(11) NOT NULL default '0',
   `user_login_tries` smallint(5) unsigned NOT NULL default '0',
   `user_last_login_try` int(11) NOT NULL default '0',
   `user_emailtime` int(11) default NULL,
   `user_viewemail` tinyint(1) default NULL,
   `user_attachsig` tinyint(1) default NULL,
   `user_allowhtml` tinyint(1) default '1',
   `user_allowbbcode` tinyint(1) default '1',
   `user_allowsmile` tinyint(1) default '1',
   `user_allowavatar` tinyint(1) NOT NULL default '1',
   `user_allow_pm` tinyint(1) NOT NULL default '1',
   `user_allow_viewonline` tinyint(1) NOT NULL default '1',
   `user_notify` tinyint(1) NOT NULL default '1',
   `user_notify_pm` tinyint(1) NOT NULL default '0',
   `user_popup_pm` tinyint(1) NOT NULL default '0',
   `user_rank` int(11) default '0',
   `user_avatar` varchar(100) default NULL,
   `user_avatar_type` tinyint(4) NOT NULL default '0',
   `user_email` varchar(255) default NULL,
   `user_icq` varchar(15) default NULL,
   `user_website` varchar(100) default NULL,
   `user_from` varchar(100) default NULL,
   `user_sig` text,
   `user_sig_bbcode_uid` varchar(10) default NULL,
   `user_aim` varchar(255) default NULL,
   `user_yim` varchar(255) default NULL,
   `user_msnm` varchar(255) default NULL,
   `user_occ` varchar(100) default NULL,
   `user_interests` varchar(255) default NULL,
   `user_actkey` varchar(32) default NULL,
   `user_newpasswd` varchar(32) default NULL,
   `user_colour` varchar(6) NOT NULL default '',
   `group_id` mediumint(8) NOT NULL default '0',
   PRIMARY KEY  (`user_id`),
   KEY `user_session_time` (`user_session_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


INSERT INTO `phpbb_users` ( `user_id`,`username`,`user_email`,`user_icq`,
                              `user_website`,`user_from`,`user_sig`,
                              `user_aim`,`user_yim`,`user_msnm`,`user_active`,`user_regdate`)
   SELECT `ID_MEMBER`,`realName`,`emailAddress`,`ICQ`,`websiteUrl`,
            `location`,`signature`,`AIM`,`YIM`,`MSN`, 1, `dateRegistered`
   FROM intothep_originalforums.members;

--#=======================================
--# CATEGORY DATA CONVERSION
--#=======================================
DROP TABLE IF EXISTS `phpbb_categories`;

CREATE TABLE `phpbb_categories` (
   `cat_id` mediumint(8) unsigned NOT NULL auto_increment,
   `cat_title` varchar(100) default NULL,
   `cat_order` mediumint(8) unsigned NOT NULL default '0',
   PRIMARY KEY  (`cat_id`),
   KEY `cat_order` (`cat_order`)
) TYPE=MyISAM AUTO_INCREMENT=10 ;

INSERT INTO `phpbb_categories` (`cat_id`,`cat_title`)
   SELECT `ID_CAT`, `name` FROM intothep_originalforums.categories;


--#=======================================
--# Forum DATA CONVERSION
--#=======================================
DROP TABLE IF EXISTS `phpbb_forums`;

CREATE TABLE `phpbb_forums` (
   `forum_id` smallint(5) unsigned NOT NULL default '0',
   `cat_id` mediumint(8) unsigned NOT NULL default '0',
   `forum_name` varchar(150) default NULL,
   `forum_desc` text,
   `forum_status` tinyint(4) NOT NULL default '0',
   `forum_order` mediumint(8) unsigned NOT NULL default '1',
   `forum_posts` mediumint(8) unsigned NOT NULL default '0',
   `forum_topics` mediumint(8) unsigned NOT NULL default '0',
   `forum_last_post_id` mediumint(8) unsigned NOT NULL default '0',
   `prune_next` int(11) default NULL,
   `prune_enable` tinyint(1) NOT NULL default '0',
   `auth_view` tinyint(2) NOT NULL default '0',
   `auth_read` tinyint(2) NOT NULL default '0',
   `auth_post` tinyint(2) NOT NULL default '0',
   `auth_reply` tinyint(2) NOT NULL default '0',
   `auth_edit` tinyint(2) NOT NULL default '0',
   `auth_delete` tinyint(2) NOT NULL default '0',
   `auth_sticky` tinyint(2) NOT NULL default '0',
   `auth_announce` tinyint(2) NOT NULL default '0',
   `auth_vote` tinyint(2) NOT NULL default '0',
   `auth_pollcreate` tinyint(2) NOT NULL default '0',
   `auth_attachments` tinyint(2) NOT NULL default '0',
   `auth_download` tinyint(2) NOT NULL default '0',
   PRIMARY KEY  (`forum_id`),
   KEY `forums_order` (`forum_order`),
   KEY `cat_id` (`cat_id`),
   KEY `forum_last_post_id` (`forum_last_post_id`)
) TYPE=MyISAM;

INSERT INTO `phpbb_forums` (`forum_id`, `cat_id`, `forum_name`, `forum_desc`,
                              `forum_posts`, `forum_topics`)
      SELECT `ID_BOARD`, `ID_CAT`, `name`, `description`, `numPosts`, `numTopics`
      FROM intothep_originalforums.boards;



--#=======================================
--# TOPIC DATA CONVERSION
--#=======================================
DROP TABLE IF EXISTS `phpbb_topics`;

CREATE TABLE `phpbb_topics` (
   `topic_id` mediumint(8)  NOT NULL auto_increment,
   `forum_id` smallint(8)  NOT NULL default '0',
   `topic_title` char(60) NOT NULL default '',
   `topic_poster` mediumint(8) NOT NULL default '0',
   `topic_time` int(11) NOT NULL default '0',
   `topic_views` mediumint(8) NOT NULL default '0',
   `topic_replies` mediumint(8)  NOT NULL default '0',
   `topic_status` tinyint(3) NOT NULL default '0',
   `topic_vote` tinyint(1) NOT NULL default '0',
   `topic_type` tinyint(3) NOT NULL default '0',
   `topic_first_post_id` mediumint(8)  NOT NULL default '0',
   `topic_last_post_id` mediumint(8)  NOT NULL default '0',
   `topic_moved_id` mediumint(8)  NOT NULL default '0',
   `topic_attachment` tinyint(1) NOT NULL default '0',
   PRIMARY KEY  (`topic_id`),
   KEY `forum_id` (`forum_id`),
   KEY `topic_moved_id` (`topic_moved_id`),
   KEY `topic_status` (`topic_status`),
   KEY `topic_type` (`topic_type`)
) TYPE=MyISAM AUTO_INCREMENT=103 ;

    -- go get a coffee, this query will take a long time....
INSERT INTO `phpbb_topics` (`topic_id`,`forum_id`,`topic_title`,`topic_poster`,
                              `topic_time`,`topic_views`,`topic_replies`,
                              `topic_first_post_id`, `topic_last_post_id`)
   SELECT s1.ID_TOPIC, ID_BOARD, subject, s1.ID_MEMBER, posterTime, numViews,
            numReplies, ID_FIRST_MSG, ID_LAST_MSG
   FROM   intothep_originalforums.messages s1, intothep_originalforums.topics
   WHERE  ID_MSG=(SELECT MIN(s2.ID_MSG)
               FROM intothep_originalforums.messages s2
               WHERE s1.ID_TOPIC = s2.ID_TOPIC)
   AND s1.ID_TOPIC = intothep_originalforums.topics.ID_TOPIC;


--#=======================================
--# CONVERT POST DATA
--#=======================================
DROP TABLE IF EXISTS `phpbb_posts`;

CREATE TABLE `phpbb_posts` (
    `post_id` mediumint(8) unsigned NOT NULL auto_increment,
    `topic_id` mediumint(8) unsigned NOT NULL default '0',
    `forum_id` smallint(5) unsigned NOT NULL default '0',
    `poster_id` mediumint(8) NOT NULL default '0',
    `post_time` int(11) NOT NULL default '0',
    `poster_ip` varchar(8) NOT NULL default '',
    `post_username` varchar(25) default NULL,
    `enable_bbcode` tinyint(1) NOT NULL default '1',
    `enable_html` tinyint(1) NOT NULL default '0',
    `enable_smilies` tinyint(1) NOT NULL default '1',
    `enable_sig` tinyint(1) NOT NULL default '1',
    `post_edit_time` int(11) default NULL,
    `post_edit_count` smallint(5) unsigned NOT NULL default '0',
    `post_attachment` tinyint(1) NOT NULL default '0',
    PRIMARY KEY  (`post_id`),
    KEY `forum_id` (`forum_id`),
    KEY `topic_id` (`topic_id`),
    KEY `poster_id` (`poster_id`),
    KEY `post_time` (`post_time`)
) TYPE=MyISAM AUTO_INCREMENT=1139;

INSERT INTO `phpbb_posts` ( `post_id` ,`topic_id`,`forum_id`,`poster_id`,
                              `post_time`,`poster_ip` ,`post_username` ,
                              `enable_bbcode` ,`enable_html` , `enable_smilies` ,
                              `enable_sig` ,`post_edit_time`,`post_edit_count` ,
                              `post_attachment`)
    SELECT messages.ID_MSG, messages.ID_TOPIC, topics.ID_BOARD, messages.ID_MEMBER,
            messages.posterTime, ' ', messages.posterName,
            1, 0, 1, 1, messages.modifiedTime, 0,0
    FROM intothep_originalforums.messages, intothep_originalforums.topics
    WHERE intothep_originalforums.messages.ID_TOPIC = intothep_originalforums.topics.ID_TOPIC;


DROP TABLE IF EXISTS `phpbb_posts_text`;

CREATE TABLE `phpbb_posts_text` (
   `post_id` mediumint(8) unsigned NOT NULL default '0',
   `bbcode_uid` varchar(10) NOT NULL default '',
   `post_subject` varchar(60) default NULL,
   `post_text` text,
   PRIMARY KEY  (`post_id`)
) TYPE=MyISAM;


INSERT INTO `phpbb_posts_text` (`post_id`,`post_subject`,`post_text`)
   SELECT messages.ID_MSG, messages.subject, messages.body
   FROM intothep_originalforums.messages;

--#=======================================
--# CORRECT CHARACTER ISSUES IN POSTS
--#=======================================
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "<br>", "\n");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "<br />", "\n");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&lt;br /&gt;", "\n");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&lt;br&gt;", "\n");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&lt;", "<");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&gt;", ">");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&nbsp;", " ");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&#039;", "'");
--UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&quot;", "\"");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "&amp;", "&");

--#=======================================
--# HALF ASSED CORRECT BBCODE
--#=======================================
UPDATE phpbb_posts_text SET bbcode_uid = "34ce617bcd";
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[b]", "[b:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/b]", "[/b:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[i]", "[i:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/i]", "[/i:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[u]", "[u:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/u]", "[/u:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[code]", "[code:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/code]", "[/code:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[img]", "[img:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/img]", "[/img:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[b]", "[b:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/b]", "[/b:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[s]", "[s:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/s]", "[/s:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[center]", "");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/center]", "");
--# JUST FOR SPUD
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[color=#FFFF00]", "[color=#FFFF00:34ce617bcd]");
UPDATE phpbb_posts_text SET post_text = REPLACE(post_text, "[/color]", "[/color:34ce617bcd]");

