-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: telephonie
-- ------------------------------------------------------
-- Server version	5.6.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `forfait_etranger`
--

DROP TABLE IF EXISTS `forfait_etranger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forfait_etranger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  `limite_appel` int(11) DEFAULT NULL,
  `limite_sms` int(11) DEFAULT NULL,
  `limite_data` int(11) DEFAULT NULL,
  `bloque` tinyint(2) DEFAULT NULL,
  `plage_horaire` int(11) DEFAULT NULL,
  `prix_hors_forfait_appel` float DEFAULT NULL,
  `prix_hors_forfait_sms` float DEFAULT NULL,
  `prix_hors_forfait_data` float DEFAULT NULL,
  `zone` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forfait_etranger`
--

LOCK TABLES `forfait_etranger` WRITE;
/*!40000 ALTER TABLE `forfait_etranger` DISABLE KEYS */;
/*!40000 ALTER TABLE `forfait_etranger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forfait_etranger_plage_horaire`
--

DROP TABLE IF EXISTS `forfait_etranger_plage_horaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forfait_etranger_plage_horaire` (
  `forfait` int(11) DEFAULT NULL,
  `plage` int(11) DEFAULT NULL,
  KEY `forfait_etranger_plage_horaire_idx` (`plage`),
  CONSTRAINT `forfait_etranger_plage_horaire` FOREIGN KEY (`plage`) REFERENCES `plage_horaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forfait_etranger_plage_horaire`
--

LOCK TABLES `forfait_etranger_plage_horaire` WRITE;
/*!40000 ALTER TABLE `forfait_etranger_plage_horaire` DISABLE KEYS */;
/*!40000 ALTER TABLE `forfait_etranger_plage_horaire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formule`
--

DROP TABLE IF EXISTS `formule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) NOT NULL,
  `prix_mensuel` float NOT NULL,
  `limite_appel` int(11) DEFAULT NULL,
  `limite_sms` int(11) DEFAULT NULL,
  `limite_data` int(11) DEFAULT NULL,
  `plage_horaire` int(11) DEFAULT NULL,
  `prix_hors_forfait_appel` float DEFAULT NULL,
  `prix_hors_forfait_sms` float DEFAULT NULL,
  `prix_hors_forfait_data` float DEFAULT NULL,
  `bloque` tinyint(2) DEFAULT NULL,
  `etrangers` int(11) DEFAULT NULL,
  `prix_base` float DEFAULT NULL,
  `telephone` int(11) DEFAULT NULL,
  `formule_base` int(11) DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formule`
--

LOCK TABLES `formule` WRITE;
/*!40000 ALTER TABLE `formule` DISABLE KEYS */;
/*!40000 ALTER TABLE `formule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formule_plage_horaire`
--

DROP TABLE IF EXISTS `formule_plage_horaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formule_plage_horaire` (
  `formule` int(11) NOT NULL,
  `plage_horaire` int(11) NOT NULL,
  KEY `formule_plage_horaire_plage_horaire_idx` (`plage_horaire`),
  CONSTRAINT `formule_plage_horaire_plage_horaire` FOREIGN KEY (`plage_horaire`) REFERENCES `plage_horaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formule_plage_horaire`
--

LOCK TABLES `formule_plage_horaire` WRITE;
/*!40000 ALTER TABLE `formule_plage_horaire` DISABLE KEYS */;
/*!40000 ALTER TABLE `formule_plage_horaire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pays`
--

DROP TABLE IF EXISTS `pays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pays`
--

LOCK TABLES `pays` WRITE;
/*!40000 ALTER TABLE `pays` DISABLE KEYS */;
/*!40000 ALTER TABLE `pays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plage_horaire`
--

DROP TABLE IF EXISTS `plage_horaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plage_horaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  `heure_debut` time DEFAULT NULL,
  `heure_fin` time DEFAULT NULL,
  `jour` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plage_horaire`
--

LOCK TABLES `plage_horaire` WRITE;
/*!40000 ALTER TABLE `plage_horaire` DISABLE KEYS */;
/*!40000 ALTER TABLE `plage_horaire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zone_geographique`
--

DROP TABLE IF EXISTS `zone_geographique`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zone_geographique` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zone_geographique`
--

LOCK TABLES `zone_geographique` WRITE;
/*!40000 ALTER TABLE `zone_geographique` DISABLE KEYS */;
/*!40000 ALTER TABLE `zone_geographique` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zone_geographique_pays`
--

DROP TABLE IF EXISTS `zone_geographique_pays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zone_geographique_pays` (
  `zone_geographique` int(11) DEFAULT NULL,
  `pays` int(11) DEFAULT NULL,
  KEY `zone_geographique_pays_pays_idx` (`pays`),
  KEY `zone_geographique_pays_zone_idx` (`zone_geographique`),
  CONSTRAINT `zone_geographique_pays_pays` FOREIGN KEY (`pays`) REFERENCES `pays` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `zone_geographique_pays_zone` FOREIGN KEY (`zone_geographique`) REFERENCES `zone_geographique` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zone_geographique_pays`
--

LOCK TABLES `zone_geographique_pays` WRITE;
/*!40000 ALTER TABLE `zone_geographique_pays` DISABLE KEYS */;
/*!40000 ALTER TABLE `zone_geographique_pays` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-09 12:09:14
