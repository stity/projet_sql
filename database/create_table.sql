-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: telephonie
-- ------------------------------------------------------
-- Server version	5.6.17

-- -----------------------------------------------------
-- Schema telephonie
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema telephonie
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `telephonie` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema new_schema1
-- -----------------------------------------------------
USE `telephonie` ;

DROP TABLE IF EXISTS `forfait_etranger`;
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

--
-- Dumping data for table `forfait_etranger`
--

LOCK TABLES `forfait_etranger` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `forfait_etranger_plage_horaire`
--

DROP TABLE IF EXISTS `forfait_etranger_plage_horaire`;
CREATE TABLE `forfait_etranger_plage_horaire` (
  `forfait` int(11) DEFAULT NULL,
  `plage` int(11) DEFAULT NULL,
  KEY `forfait_etranger_plage_horaire_idx` (`plage`),
  CONSTRAINT `forfait_etranger_plage_horaire` FOREIGN KEY (`plage`) REFERENCES `plage_horaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `forfait_etranger_plage_horaire`
--

LOCK TABLES `forfait_etranger_plage_horaire` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `formule`
--

DROP TABLE IF EXISTS `formule`;
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

--
-- Dumping data for table `formule`
--

LOCK TABLES `formule` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `formule_plage_horaire`
--

DROP TABLE IF EXISTS `formule_plage_horaire`;
CREATE TABLE `formule_plage_horaire` (
  `formule` int(11) NOT NULL,
  `plage_horaire` int(11) NOT NULL,
  KEY `formule_plage_horaire_plage_horaire_idx` (`plage_horaire`),
  CONSTRAINT `formule_plage_horaire_plage_horaire` FOREIGN KEY (`plage_horaire`) REFERENCES `plage_horaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `formule_plage_horaire`
--

LOCK TABLES `formule_plage_horaire` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `pays`
--

DROP TABLE IF EXISTS `pays`;
CREATE TABLE `pays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pays`
--

LOCK TABLES `pays` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `plage_horaire`
--

DROP TABLE IF EXISTS `plage_horaire`;
CREATE TABLE `plage_horaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  `heure_debut` time DEFAULT NULL,
  `heure_fin` time DEFAULT NULL,
  `jour` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plage_horaire`
--

LOCK TABLES `plage_horaire` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `zone_geographique`
--

DROP TABLE IF EXISTS `zone_geographique`;
CREATE TABLE `zone_geographique` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zone_geographique`
--

LOCK TABLES `zone_geographique` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `zone_geographique_pays`
--

DROP TABLE IF EXISTS `zone_geographique_pays`;
CREATE TABLE `zone_geographique_pays` (
  `zone_geographique` int(11) DEFAULT NULL,
  `pays` int(11) DEFAULT NULL,
  KEY `zone_geographique_pays_pays_idx` (`pays`),
  KEY `zone_geographique_pays_zone_idx` (`zone_geographique`),
  CONSTRAINT `zone_geographique_pays_pays` FOREIGN KEY (`pays`) REFERENCES `pays` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `zone_geographique_pays_zone` FOREIGN KEY (`zone_geographique`) REFERENCES `zone_geographique` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `zone_geographique_pays`
--

LOCK TABLES `zone_geographique_pays` WRITE;
UNLOCK TABLES;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Table `telephonie`.`appel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`appel` (
  `idappel` INT NOT NULL AUTO_INCREMENT,
  `debut_appel` DATETIME NULL,
  `duree` TIME NULL,
  `destination` INT NULL,
  `consommation` INT NULL,
  PRIMARY KEY (`idappel`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`mms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`mms` (
  `idmms` INT NOT NULL AUTO_INCREMENT,
  `volume` INT NULL,
  `date` DATETIME NULL,
  `destination` INT NULL,
  `consommation` INT NULL,
  PRIMARY KEY (`idmms`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`sms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`sms` (
  `idsms` INT NOT NULL AUTO_INCREMENT,
  `volume` INT NULL,
  `date` DATETIME NULL,
  `destination` INT NULL,
  `consommation` INT NULL,
  PRIMARY KEY (`idsms`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`consommation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`consommation` (
  `idconsommation` INT NOT NULL AUTO_INCREMENT,
  `date_debut` DATETIME NULL,
  `conso_data` INT NULL,
  `id_achat` INT NULL,
  PRIMARY KEY (`idconsommation`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`facture`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`facture` (
  `idfacture` INT NOT NULL AUTO_INCREMENT,
  `consommation` INT NULL,
  `prix` INT NULL,
  `paye` TINYINT(2) NULL,
  PRIMARY KEY (`idfacture`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`utilisateur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`utilisateur` (
  `idutilisateur` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NULL,
  `mail` VARCHAR(255) NULL,
  `adresse` VARCHAR(255) NULL,
  `mot_de_passe` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idutilisateur`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`achat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`achat` (
  `idachat` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NULL,
  `telephone` INT NULL,
  `id_utilisateur` INT NULL,
  `id_formule` INT NULL,
  PRIMARY KEY (`idachat`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`telephone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`telephone` (
  `idtelephone` INT NOT NULL AUTO_INCREMENT,
  `ecran` VARCHAR(255) NULL,
  `tv` TINYINT(2) NULL,
  `appareil_photo` VARCHAR(255) NULL,
  `video_numerique` VARCHAR(255) NULL,
  `ram` VARCHAR(255) NULL,
  `carte_sd` TINYINT(2) NULL,
  `double_sim` TINYINT(2) NULL,
  `photo_url` VARCHAR(255) NULL,
  `modele` VARCHAR(255) NULL,
  `marque` VARCHAR(255) NULL,
  `prix` FLOAT NULL,
  `stockage` VARCHAR(255) NULL,
  `capacite_internet` VARCHAR(255) NULL,
  PRIMARY KEY (`idtelephone`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`destination_sms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`destination_sms` (
  `iddestination_sms` INT NOT NULL AUTO_INCREMENT,
  `id_zone_geographique` INT NULL,
  `id_sms` INT NULL,
  PRIMARY KEY (`iddestination_sms`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`destination_appel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`destination_appel` (
  `iddestination_appel` INT NOT NULL AUTO_INCREMENT,
  `id_zone_geographique` INT NULL,
  `id_appel` INT NULL,
  PRIMARY KEY (`iddestination_appel`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `telephonie`.`destination_mms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telephonie`.`destination_mms` (
  `iddestination_mms` INT NOT NULL AUTO_INCREMENT,
  `id_zone_geographique` INT NULL,
  `id_mms` VARCHAR(45) NULL,
  PRIMARY KEY (`iddestination_mms`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
