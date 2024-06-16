-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_2372_sergexam
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('9043cb7442f0');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_desc` text NOT NULL,
  `created_year` year(4) NOT NULL,
  `publish` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `pages_count` int(11) NOT NULL,
  `rating_sum` int(11) NOT NULL,
  `rating_num` int(11) NOT NULL,
  `skin_id` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_skin_id_oblojka` (`skin_id`),
  CONSTRAINT `fk_books_skin_id_oblojka` FOREIGN KEY (`skin_id`) REFERENCES `oblojka` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Нескучный сад','dfsjjgugte',2022,'харитон','я',192,4,2,'a78eb397-37e4-43a7-ab87-d4ae3cf1b6d0'),(2,'451 градус по Фаренгейту','Роман описывает американское общество близкого будущего, в котором книги находятся под запретом; «пожарные», к числу которых принадлежит и главный герой Гай Монтэг, сжигают любые найденные книги.',1953,'харитон','Рей Бредбери',206,5,1,'a18b76b8-bb95-4878-9fe8-05c159351af3'),(3,'Война и Мир','«Война́ и мир» — роман-эпопея Льва Николаевича Толстого, описывающий русское общество в эпоху войн против Наполеона в 1805—1812 годах.',1912,'харитон','Лев Толстой',980,4,1,'8114b80a-6885-47ed-8c0e-c23abf9f60c6'),(5,'Человек бенззапхазпххзпахазхпах','аукузухкухзк',2022,'харитон','я',4,0,0,'09b8b01a-c0d4-47f3-89c7-9b424275cff8');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_genres_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (5,'Инструкция'),(3,'Комедия'),(4,'Повесть'),(2,'Роман'),(6,'Романтика'),(1,'Фантастика');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genresbooks`
--

DROP TABLE IF EXISTS `genresbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genresbooks` (
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `fk_genresbooks_genre_id_genres` (`genre_id`),
  CONSTRAINT `fk_genresbooks_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_genresbooks_genre_id_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genresbooks`
--

LOCK TABLES `genresbooks` WRITE;
/*!40000 ALTER TABLE `genresbooks` DISABLE KEYS */;
INSERT INTO `genresbooks` VALUES (2,2),(3,2),(1,4),(5,5);
/*!40000 ALTER TABLE `genresbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oblojka`
--

DROP TABLE IF EXISTS `oblojka`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oblojka` (
  `id` varchar(256) NOT NULL,
  `filename` varchar(256) NOT NULL,
  `mime_type` varchar(256) NOT NULL,
  `md5_hash` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oblojka`
--

LOCK TABLES `oblojka` WRITE;
/*!40000 ALTER TABLE `oblojka` DISABLE KEYS */;
INSERT INTO `oblojka` VALUES ('09b8b01a-c0d4-47f3-89c7-9b424275cff8','ava.png','image/png','0e0d417419b78babba5fed9edfd6b1a4'),('8114b80a-6885-47ed-8c0e-c23abf9f60c6','3.jpg','image/jpeg','d088ba474745d46348b7aada0a302906'),('a18b76b8-bb95-4878-9fe8-05c159351af3','2.jpg','image/jpeg','f056794529a1ab6f55b1ce471909b608'),('a78eb397-37e4-43a7-ab87-d4ae3cf1b6d0','logo.png','image/png','cfe2154750ffdeec4aaa5a76e8f99363');
/*!40000 ALTER TABLE `oblojka` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `text` text NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reviews_book_id_books` (`book_id`),
  KEY `fk_reviews_user_id_users` (`user_id`),
  CONSTRAINT `fk_reviews_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_reviews_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,4,'Норм темка не хватает пыва и чипсов только','2024-06-16 12:40:48'),(2,2,1,5,'Лучшее из всего!','2024-06-16 15:47:59'),(3,3,3,4,'Я там был, я все видел сам!','2024-06-16 15:50:56'),(4,1,3,0,'Пробный вариант такое себе(','2024-06-16 15:51:31');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Админ','Может всё'),(2,'Модератор','Может редактировать рецензии'),(3,'Пользователь','Может оставлять рецензии');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(256) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `last_name` varchar(256) NOT NULL,
  `first_name` varchar(256) NOT NULL,
  `middle_name` varchar(256) DEFAULT NULL,
  `roles_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_roles_id_roles` (`roles_id`),
  CONSTRAINT `fk_users_roles_id_roles` FOREIGN KEY (`roles_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user','scrypt:32768:8:1$3Q0rAcJ9GG5ZCG3e$438aee92fcf43e9b277f2ebe21a66b1f2f643de3fdc0daec1010f6771759f120782c808f0550eab6038b55a9f436c436357d9a9302a14d6f7cf851256f80aaae','Администрович','Сергей','В',1),(2,'moder','scrypt:32768:8:1$68RGVUbypSLgIg24$419f08f692be7624b6663a43e2c102e2d2a361549fc6d20b063da18a1b89f99a9e17f4525592d3a3074e3b5dccfc389957109648f01122ba49bae5570f31bdc4','Модератович','Сергей',NULL,2),(3,'polzov','scrypt:32768:8:1$ZodlKBWaK8Ek1oXy$173a98da3422fc5eaa984953aa2ff92189fbed4dfa620513395467e50aafa1067a875383eaeb6dce352a2681c86ce277808f5bfa2196f02482c4ab98bc337357','Обыкновеннович','Сергей',NULL,3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-16 16:31:37
