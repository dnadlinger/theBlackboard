DROP TABLE IF EXISTS `auth`;
CREATE TABLE IF NOT EXISTS `auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `method` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `need_captcha` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);
