DROP TABLE IF EXISTS `address_book`;
CREATE TABLE `address_book` (
  `id` int(11) AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `birthday` DATE NOT NULL,
  `sex` tinyint NOT NULL,
  `tel` varchar(32) NOT NULL,
  `zip` varchar(8) NOT NULL,
  `address` varchar(255) NOT NULL,
  `is_used` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`name`,`tel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
