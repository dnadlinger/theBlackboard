DROP TABLE IF EXISTS `entries`;
CREATE TABLE IF NOT EXISTS `entries` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `caption` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `author` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `drawingString` text COLLATE latin1_general_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
