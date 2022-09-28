CREATE DATABASE  IF NOT EXISTS `gpagri` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gpagri`;
-- MySQL dump 10.13  Distrib 8.0.24, for Win64 (x86_64)
--
-- Host: localhost    Database: gpagri
-- ------------------------------------------------------
-- Server version	8.0.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aplicacao`
--

DROP TABLE IF EXISTS `aplicacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aplicacao` (
  `cod_aplicacao` int NOT NULL AUTO_INCREMENT,
  `data` varchar(15) DEFAULT NULL,
  `cod_plantio` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`cod_aplicacao`),
  UNIQUE KEY `nome_UNIQUE` (`nome`),
  KEY `aplicacao_ibfk_1` (`cod_plantio`),
  CONSTRAINT `aplicacao_ibfk_1` FOREIGN KEY (`cod_plantio`) REFERENCES `plantio` (`cod_plantio`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aplicacao`
--

LOCK TABLES `aplicacao` WRITE;
/*!40000 ALTER TABLE `aplicacao` DISABLE KEYS */;
INSERT INTO `aplicacao` VALUES (1,'2022-03-23',1,'1-Furius'),(4,'28/10/2021',10,'1-Fungicida'),(7,'25/03/2022',20,'Aplicacao safra8'),(8,'25/03/2022',20,'Aplicacao 2 safra8'),(9,'25/03/2022',21,'Aplicacao 3 safra8');
/*!40000 ALTER TABLE `aplicacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aplicacao_x_insumo`
--

DROP TABLE IF EXISTS `aplicacao_x_insumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aplicacao_x_insumo` (
  `dosagem` float NOT NULL,
  `cod_insumo` int NOT NULL,
  `cod_aplicacao` int NOT NULL,
  PRIMARY KEY (`cod_aplicacao`,`cod_insumo`),
  KEY `aplicacao_x_insumo_ibfk_1` (`cod_insumo`),
  CONSTRAINT `aplicacao_x_insumo_ibfk_1` FOREIGN KEY (`cod_insumo`) REFERENCES `insumo` (`cod_insumo`),
  CONSTRAINT `aplicacao_x_insumo_ibfk_2` FOREIGN KEY (`cod_aplicacao`) REFERENCES `aplicacao` (`cod_aplicacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aplicacao_x_insumo`
--

LOCK TABLES `aplicacao_x_insumo` WRITE;
/*!40000 ALTER TABLE `aplicacao_x_insumo` DISABLE KEYS */;
INSERT INTO `aplicacao_x_insumo` VALUES (2.35,1,1),(2,2,1),(1.5,3,1),(2.9,7,1),(3,8,1),(2.3,4,4),(1,5,4),(2,9,4),(33,8,7),(10,10,7),(20,10,8),(5,10,9);
/*!40000 ALTER TABLE `aplicacao_x_insumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `campo`
--

DROP TABLE IF EXISTS `campo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `campo` (
  `area` float DEFAULT NULL,
  `cod_campo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cod_propriedade` int NOT NULL,
  PRIMARY KEY (`cod_campo`),
  UNIQUE KEY `nome_UNIQUE` (`nome`),
  KEY `campo_ibfk_1` (`cod_propriedade`),
  CONSTRAINT `campo_ibfk_1` FOREIGN KEY (`cod_propriedade`) REFERENCES `propriedade` (`cod_propriedade`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campo`
--

LOCK TABLES `campo` WRITE;
/*!40000 ALTER TABLE `campo` DISABLE KEYS */;
INSERT INTO `campo` VALUES (60,1,'Barracão sede editado',1),(30,9,'Caçununga',1),(258,61,'Ancho',59),(20,62,'Casdasdasd',59),(10,63,'Campo do asdasf',59),(100,64,'CAmpo do cachorro',1),(10,65,'Faasadasd',1),(20,66,'Campoasdasd',1);
/*!40000 ALTER TABLE `campo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carga`
--

DROP TABLE IF EXISTS `carga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carga` (
  `cod_carga` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `peso` float DEFAULT NULL,
  `umidade` float DEFAULT NULL,
  `impurezas` float DEFAULT NULL,
  `dia` date DEFAULT NULL,
  `cod_colheita` int NOT NULL,
  PRIMARY KEY (`cod_carga`),
  KEY `carga_ibfk_1` (`cod_colheita`),
  CONSTRAINT `carga_ibfk_1` FOREIGN KEY (`cod_colheita`) REFERENCES `colheita` (`cod_colheita`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carga`
--

LOCK TABLES `carga` WRITE;
/*!40000 ALTER TABLE `carga` DISABLE KEYS */;
INSERT INTO `carga` VALUES (2,'carga2-22/11/21',18500,15,1,'2021-11-22',1),(16,'carga3',19860,15.3,1.8,'2021-11-22',1),(18,'carrga5',21080,15,1.6,'2021-11-28',3),(19,'Carga6',19660,14,1.7,'2021-11-29',4),(20,'Carga7',37000,13.8,2,'2021-11-29',5),(21,'Carga8',38524,13.8,1.9,'2021-11-29',5),(31,'Luciano carga 22/02/2022',25000,16,2,'2022-03-25',1);
/*!40000 ALTER TABLE `carga` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `carga_BEFORE_INSERT` BEFORE INSERT ON `carga` FOR EACH ROW BEGIN

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `carga_AFTER_INSERT` AFTER INSERT ON `carga` FOR EACH ROW BEGIN
	UPDATE `colheita` SET `colheita`.`producao` = `colheita`.`producao` + NEW.`peso`
WHERE `colheita`.`cod_colheita` = NEW.`cod_colheita`;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `colheita`
--

DROP TABLE IF EXISTS `colheita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colheita` (
  `nome` varchar(100) NOT NULL,
  `cod_colheita` int NOT NULL AUTO_INCREMENT,
  `data_inicio` varchar(15) DEFAULT NULL,
  `data_fim` varchar(15) DEFAULT NULL,
  `producao` float NOT NULL,
  `cod_plantio` int NOT NULL,
  PRIMARY KEY (`cod_colheita`),
  KEY `colheita_ibfk_1` (`cod_plantio`),
  CONSTRAINT `colheita_ibfk_1` FOREIGN KEY (`cod_plantio`) REFERENCES `plantio` (`cod_plantio`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colheita`
--

LOCK TABLES `colheita` WRITE;
/*!40000 ALTER TABLE `colheita` DISABLE KEYS */;
INSERT INTO `colheita` VALUES ('Colheita1',1,'2022-03-15','2022-03-15',137820,1),('Colheita2',3,'27/11/2021','',21080,10),('Colheita3',4,'29/11/2021',NULL,19660,13),('Colheita4',5,'29/11/2021',NULL,75524,14),('Colheita7',8,'','',0,13);
/*!40000 ALTER TABLE `colheita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cultivar`
--

DROP TABLE IF EXISTS `cultivar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cultivar` (
  `cod_cultivar` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cod_cultura` int NOT NULL,
  PRIMARY KEY (`cod_cultivar`),
  KEY `cultivar_ibfk_1` (`cod_cultura`),
  CONSTRAINT `cultivar_ibfk_1` FOREIGN KEY (`cod_cultura`) REFERENCES `cultura` (`cod_cultura`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultivar`
--

LOCK TABLES `cultivar` WRITE;
/*!40000 ALTER TABLE `cultivar` DISABLE KEYS */;
INSERT INTO `cultivar` VALUES (1,'Soja Potência',1),(4,'Milho',2),(5,'Feijão',3),(6,'Feijão Urutau',3),(7,'Trigo Triticale',4),(8,'Trigo Toruk',4),(9,'Cevada',5),(10,'Centeio',6),(11,'Centeio Teste',6),(12,'Cultivar 1',6),(13,'Soja Raio',1),(14,'Soja Zeus',1);
/*!40000 ALTER TABLE `cultivar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cultura`
--

DROP TABLE IF EXISTS `cultura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cultura` (
  `cod_cultura` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`cod_cultura`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultura`
--

LOCK TABLES `cultura` WRITE;
/*!40000 ALTER TABLE `cultura` DISABLE KEYS */;
INSERT INTO `cultura` VALUES (1,'Soja'),(2,'Milho'),(3,'Feijão'),(4,'Trigo'),(5,'Cevada'),(6,'Centeio');
/*!40000 ALTER TABLE `cultura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insumo`
--

DROP TABLE IF EXISTS `insumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insumo` (
  `cod_insumo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`cod_insumo`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insumo`
--

LOCK TABLES `insumo` WRITE;
/*!40000 ALTER TABLE `insumo` DISABLE KEYS */;
INSERT INTO `insumo` VALUES (1,'TSM Shield'),(2,'TSM Nufor'),(3,'TSM Furius'),(4,'Fungicida'),(5,'Pesticida'),(7,'TSM N-Base'),(8,'TSM Eviction'),(9,'AirQuatio'),(10,'Glifosato');
/*!40000 ALTER TABLE `insumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantio`
--

DROP TABLE IF EXISTS `plantio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantio` (
  `cod_plantio` int NOT NULL AUTO_INCREMENT,
  `data_fim` varchar(15) DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `data_inicio` varchar(15) DEFAULT NULL,
  `cod_safra` int NOT NULL,
  `cod_cultivar` int NOT NULL,
  `cod_talhao` int NOT NULL,
  PRIMARY KEY (`cod_plantio`),
  KEY `plantio_ibfk_1` (`cod_safra`),
  KEY `plantio_ibfk_2` (`cod_talhao`),
  KEY `plantio_ibfk_3` (`cod_cultivar`),
  CONSTRAINT `plantio_ibfk_1` FOREIGN KEY (`cod_safra`) REFERENCES `safra` (`cod_safra`),
  CONSTRAINT `plantio_ibfk_2` FOREIGN KEY (`cod_talhao`) REFERENCES `talhao` (`cod_talhao`),
  CONSTRAINT `plantio_ibfk_3` FOREIGN KEY (`cod_cultivar`) REFERENCES `cultivar` (`cod_cultivar`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantio`
--

LOCK TABLES `plantio` WRITE;
/*!40000 ALTER TABLE `plantio` DISABLE KEYS */;
INSERT INTO `plantio` VALUES (1,'2022-03-29','Plantio 1 editado','2022-03-29',1,1,1),(10,'2022-03-29','Plantio2 editado','2022-03-29',1,10,10),(13,'2021-11-10','Plantio4','2021-11-07',1,6,3),(14,'2021-11-11','Plantio5','2021-11-05',1,14,10),(20,'2021-07-14','Plantio_Safra2','2021-07-06',8,1,1),(21,NULL,'Plantio2_safra2',NULL,8,4,3),(25,'2022-03-29','Apenas outro campo','2022-03-29',1,13,1),(27,'2022-03-29','Apenas outro campo','2022-03-29',1,6,3);
/*!40000 ALTER TABLE `plantio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plantio_x_insumo`
--

DROP TABLE IF EXISTS `plantio_x_insumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plantio_x_insumo` (
  `dosagem` float NOT NULL,
  `cod_plantio` int NOT NULL,
  `cod_insumo` int NOT NULL,
  PRIMARY KEY (`cod_plantio`,`cod_insumo`),
  KEY `plantio_x_insumo_ibfk_2` (`cod_insumo`),
  CONSTRAINT `plantio_x_insumo_ibfk_1` FOREIGN KEY (`cod_plantio`) REFERENCES `plantio` (`cod_plantio`),
  CONSTRAINT `plantio_x_insumo_ibfk_2` FOREIGN KEY (`cod_insumo`) REFERENCES `insumo` (`cod_insumo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plantio_x_insumo`
--

LOCK TABLES `plantio_x_insumo` WRITE;
/*!40000 ALTER TABLE `plantio_x_insumo` DISABLE KEYS */;
INSERT INTO `plantio_x_insumo` VALUES (2.3,1,1),(1.5,1,2),(5.4,1,5),(2.3,1,8),(2,10,1),(4,20,8);
/*!40000 ALTER TABLE `plantio_x_insumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtor`
--

DROP TABLE IF EXISTS `produtor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtor` (
  `nome_usuario` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(100) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cod_produtor` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`cod_produtor`),
  UNIQUE KEY `nome_usuario` (`nome_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtor`
--

LOCK TABLES `produtor` WRITE;
/*!40000 ALTER TABLE `produtor` DISABLE KEYS */;
INSERT INTO `produtor` VALUES ('Gpagri','hilgemberg.igor@gmail.com','gpagri','Igor',1);
/*!40000 ALTER TABLE `produtor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtor_x_propriedade`
--

DROP TABLE IF EXISTS `produtor_x_propriedade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtor_x_propriedade` (
  `cod_propriedade` int NOT NULL,
  `cod_produtor` int NOT NULL,
  PRIMARY KEY (`cod_propriedade`,`cod_produtor`),
  KEY `produtor_x_propriedade_ibfk_2` (`cod_produtor`),
  CONSTRAINT `produtor_x_propriedade_ibfk_1` FOREIGN KEY (`cod_propriedade`) REFERENCES `propriedade` (`cod_propriedade`),
  CONSTRAINT `produtor_x_propriedade_ibfk_2` FOREIGN KEY (`cod_produtor`) REFERENCES `produtor` (`cod_produtor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtor_x_propriedade`
--

LOCK TABLES `produtor_x_propriedade` WRITE;
/*!40000 ALTER TABLE `produtor_x_propriedade` DISABLE KEYS */;
INSERT INTO `produtor_x_propriedade` VALUES (1,1);
/*!40000 ALTER TABLE `produtor_x_propriedade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propriedade`
--

DROP TABLE IF EXISTS `propriedade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propriedade` (
  `area` float DEFAULT NULL,
  `cod_propriedade` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`cod_propriedade`),
  UNIQUE KEY `nome_UNIQUE` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propriedade`
--

LOCK TABLES `propriedade` WRITE;
/*!40000 ALTER TABLE `propriedade` DISABLE KEYS */;
INSERT INTO `propriedade` VALUES (140,1,'Fazenda São Jorge'),(60,59,'Fazenda Estrela Azul');
/*!40000 ALTER TABLE `propriedade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `safra`
--

DROP TABLE IF EXISTS `safra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `safra` (
  `data_fim` datetime DEFAULT NULL,
  `data_inicio` datetime DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `cod_safra` int NOT NULL AUTO_INCREMENT,
  `cod_propriedade` int NOT NULL,
  PRIMARY KEY (`cod_safra`),
  KEY `safra_ibfk_1` (`cod_propriedade`),
  CONSTRAINT `safra_ibfk_1` FOREIGN KEY (`cod_propriedade`) REFERENCES `propriedade` (`cod_propriedade`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `safra`
--

LOCK TABLES `safra` WRITE;
/*!40000 ALTER TABLE `safra` DISABLE KEYS */;
INSERT INTO `safra` VALUES ('2022-03-27 00:00:00','2022-03-27 00:00:00','Safra1',1,1),('2022-02-02 00:00:00','2021-06-25 00:00:00','Safra2',8,1);
/*!40000 ALTER TABLE `safra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `talhao`
--

DROP TABLE IF EXISTS `talhao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `talhao` (
  `area` float DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `cod_talhao` int NOT NULL AUTO_INCREMENT,
  `cod_campo` int NOT NULL,
  PRIMARY KEY (`cod_talhao`),
  UNIQUE KEY `nome_UNIQUE` (`nome`),
  KEY `talhao_ibfk_1` (`cod_campo`),
  CONSTRAINT `talhao_ibfk_1` FOREIGN KEY (`cod_campo`) REFERENCES `campo` (`cod_campo`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `talhao`
--

LOCK TABLES `talhao` WRITE;
/*!40000 ALTER TABLE `talhao` DISABLE KEYS */;
INSERT INTO `talhao` VALUES (10,'Lado esquerdo estrada',1,1),(100,'Lado direito estrada',3,1),(20,'Lado direito',5,9),(50,'Talhão 3',9,9),(200,'Talhão 4 teste',10,9),(10,'Canudos',18,9);
/*!40000 ALTER TABLE `talhao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gpagri'
--

--
-- Dumping routines for database 'gpagri'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-29 10:17:29
