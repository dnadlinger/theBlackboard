DROP TABLE IF EXISTS `captchaAuth`;
CREATE TABLE IF NOT EXISTS `captchaAuth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `methodOwner` varchar(30) NOT NULL,
  `methodName` varchar(30) NOT NULL,
  `solution` varchar(10) NOT NULL,
  `solved` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
);