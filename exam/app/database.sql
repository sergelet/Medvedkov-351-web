-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
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
-- Table structure for table `Knigi_janr`
--

DROP TABLE IF EXISTS `Knigi_janr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Knigi_janr` (
  `kniga_id` int(100) NOT NULL,
  `janr_id` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Knigi_janr`
--

LOCK TABLES `Knigi_janr` WRITE;
/*!40000 ALTER TABLE `Knigi_janr` DISABLE KEYS */;
INSERT INTO `Knigi_janr` VALUES (2,3),(4,2),(3,2),(3,3),(5,1),(6,2),(7,1),(9,2),(10,3),(8,2),(8,3);
/*!40000 ALTER TABLE `Knigi_janr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cover`
--

DROP TABLE IF EXISTS `cover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cover` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `mimetype` varchar(255) NOT NULL,
  `md5hash` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cover`
--

LOCK TABLES `cover` WRITE;
/*!40000 ALTER TABLE `cover` DISABLE KEYS */;
/*!40000 ALTER TABLE `cover` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `book` int(20) DEFAULT NULL,
  `user` int(20) DEFAULT NULL,
  `rating` int(20) DEFAULT NULL,
  `text` text,
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `book` (`book`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`),
  CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`book`) REFERENCES `knigi` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `janr`
--

DROP TABLE IF EXISTS `janr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `janr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `janr`
--

LOCK TABLES `janr` WRITE;
/*!40000 ALTER TABLE `janr` DISABLE KEYS */;
INSERT INTO `janr` VALUES (1,'Фантастика'),(2,'Фентези'),(3,'хоррор');
/*!40000 ALTER TABLE `janr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knigi`
--

DROP TABLE IF EXISTS `knigi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `knigi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `year` year(4) NOT NULL,
  `publish` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `pages` int(11) NOT NULL,
  `oblojka` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oblojka` (`oblojka`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`oblojka`) REFERENCES `cover` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knigi`
--

LOCK TABLES `knigi` WRITE;
/*!40000 ALTER TABLE `knigi` DISABLE KEYS */;
INSERT INTO `knigi` VALUES (3,'Нескучны','В триллере Франка Тилье «Головоломка» герои Илан и Хоэ, профессиональные охотники за сокровищами, внедряются в таинственную игру, где главный приз составляет триста тысяч евро, а цена ее — человеческая жизнь. Правила игры им неизвестны, они знают лишь ее название: «Паранойя». В горах на территории заброшенной психиатрической лечебницы восемь участников должны бросить вызов своим самым потаенным страхам. Чтобы обрести ключ от заветного сейфа с деньгами, нужно собрать десять черных хрустальных лебедей. Но осторожно: цена такой находки — жизнь. Ваша жизнь.',1999,'харитон','Рей Бредбери',123,NULL),(6,'Медведков Сергей Николаевич','sdasd',1996,'харитон','Лево Толстой',67,NULL),(7,'Ахен','\"В царстве Аэтории, где древняя магия шепчет через деревья, последний драконий наездник, Эйра, отправляется в опасное путешествие, чтобы покончить с темнотой, которая поглотила землю. С ее верным драконом, Тарросом, рядом, она должна преодолевать опасные ландшафты, сражаться с ужасными созданиями и разгадывать тайны забытого пророчества, чтобы спасти Аэторию от вечной ночи.',2004,'харитон','Билли боб',454,NULL),(8,'Валидация','В тёмных коридорах психиатрической больницы «Равенсвуд» происходит нечто страшное. Доктор Эмили Уилсон, пытаясь раскрыть тайну исчезновения пациентов, открывает дверь в ад, где жуткие создания и мрачные силы ждут ее. Теперь она должна бороться за свою жизнь и разгадать страшную правду о Равенсвуде, прежде чем станет слишком поздно.',2023,'харитон','Z',321,NULL),(9,'Медведков Сергей 221-351','ыв',1999,'ыв','ывывы',23,NULL);
/*!40000 ALTER TABLE `knigi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oblojka`
--

DROP TABLE IF EXISTS `oblojka`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oblojka` (
  `id` int(11) NOT NULL,
  `file` int(11) NOT NULL,
  `mimetype` int(11) NOT NULL,
  `MD5` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oblojka`
--

LOCK TABLES `oblojka` WRITE;
/*!40000 ALTER TABLE `oblojka` DISABLE KEYS */;
/*!40000 ALTER TABLE `oblojka` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'Admin','Админ'),(2,'Moderator','модератор'),(3,'USer','Обычный пользователь');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `role_id` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','admin','admin','admin',1),(2,'moderator','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','moder','moder','moder',2),(3,'user','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','user','user','user',3);
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

-- Dump completed on 2024-09-05 19:34:48
