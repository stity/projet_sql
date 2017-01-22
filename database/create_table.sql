-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Lun 16 Janvier 2017 à 17:06
-- Version du serveur :  5.6.17
-- Version de PHP :  5.6.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `telephonie`
--
DROP DATABASE IF EXISTS telephonie;
CREATE DATABASE IF NOT EXISTS `telephonie` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `telephonie`;


DROP FUNCTION IF EXISTS `random`;
CREATE DEFINER=`root`@`localhost` FUNCTION `random`(`min` INT, `max` INT) RETURNS INT(11) NOT DETERMINISTIC NO SQL SQL SECURITY DEFINER RETURN FLOOR(min+(max-min)*RAND());

-- --------------------------------------------------------

--
-- Structure de la table `achat`
--

DROP TABLE IF EXISTS `achat`;
CREATE TABLE IF NOT EXISTS `achat` (
  `idachat` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `telephone` int(11) DEFAULT NULL,
  `id_utilisateur` int(11) DEFAULT NULL,
  `id_formule` int(11) DEFAULT NULL,
  PRIMARY KEY (`idachat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `appel`
--

DROP TABLE IF EXISTS `appel`;
CREATE TABLE IF NOT EXISTS `appel` (
  `idappel` int(11) NOT NULL AUTO_INCREMENT,
  `debut_appel` datetime DEFAULT NULL,
  `duree` time DEFAULT NULL,
  `destination` int(11) DEFAULT NULL,
  `consommation` int(11) DEFAULT NULL,
  PRIMARY KEY (`idappel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `consommation`
--

DROP TABLE IF EXISTS `consommation`;
CREATE TABLE IF NOT EXISTS `consommation` (
  `idconsommation` int(11) NOT NULL AUTO_INCREMENT,
  `date_debut` datetime DEFAULT NULL,
  `conso_data` int(11) DEFAULT NULL,
  `id_achat` int(11) DEFAULT NULL,
  PRIMARY KEY (`idconsommation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `facture`
--

DROP TABLE IF EXISTS `facture`;
CREATE TABLE IF NOT EXISTS `facture` (
  `idfacture` int(11) NOT NULL AUTO_INCREMENT,
  `consommation` int(11) DEFAULT NULL,
  `prix` float DEFAULT NULL,
  `paye` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`idfacture`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `forfait_etranger`
--

DROP TABLE IF EXISTS `forfait_etranger`;
CREATE TABLE IF NOT EXISTS `forfait_etranger` (
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
  `is_deleted` tinyint(2) DEFAULT FALSE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `forfait_etranger_plage_horaire`
--

DROP TABLE IF EXISTS `forfait_etranger_plage_horaire`;
CREATE TABLE IF NOT EXISTS `forfait_etranger_plage_horaire` (
  `forfait` int(11) DEFAULT NULL,
  `plage` int(11) DEFAULT NULL,
  KEY `forfait_etranger_plage_horaire_idx` (`plage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `formule`
--

DROP TABLE IF EXISTS `formule`;
CREATE TABLE IF NOT EXISTS `formule` (
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
  `is_deleted` tinyint(2) DEFAULT FALSE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `formule_forfait_etranger`
--

DROP TABLE IF EXISTS `formule_forfait_etranger`;
CREATE TABLE IF NOT EXISTS `formule_forfait_etranger` (
  `formule` int(11) DEFAULT NULL,
  `forfait_etranger` int(11) DEFAULT NULL,
  KEY `formule_forfait_etranger_idx` (`formule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `formule_plage_horaire`
--

DROP TABLE IF EXISTS `formule_plage_horaire`;
CREATE TABLE IF NOT EXISTS `formule_plage_horaire` (
  `formule` int(11) NOT NULL,
  `plage_horaire` int(11) NULL,
  KEY `formule_plage_horaire_plage_horaire_idx` (`plage_horaire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `formule_telephone`
--

DROP TABLE IF EXISTS `formule_telephone`;
CREATE TABLE IF NOT EXISTS `formule_telephone` (
  `formule` int(11) DEFAULT NULL,
  `telephone` int(11) DEFAULT NULL,
  KEY `formule_telephone_idx` (`formule`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `mms`
--

DROP TABLE IF EXISTS `mms`;
CREATE TABLE IF NOT EXISTS `mms` (
  `idmms` int(11) NOT NULL AUTO_INCREMENT,
  `volume` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `destination` int(11) DEFAULT NULL,
  `consommation` int(11) DEFAULT NULL,
  PRIMARY KEY (`idmms`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `pays`
--

DROP TABLE IF EXISTS `pays`;
CREATE TABLE IF NOT EXISTS `pays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `plage_horaire`
--

DROP TABLE IF EXISTS `plage_horaire`;
CREATE TABLE IF NOT EXISTS `plage_horaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  `heure_debut` time DEFAULT NULL,
  `heure_fin` time DEFAULT NULL,
  `jour` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `sms`
--

DROP TABLE IF EXISTS `sms`;
CREATE TABLE IF NOT EXISTS `sms` (
  `idsms` int(11) NOT NULL AUTO_INCREMENT,
  `volume` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `destination` int(11) DEFAULT NULL,
  `consommation` int(11) DEFAULT NULL,
  PRIMARY KEY (`idsms`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `telephone`
--

DROP TABLE IF EXISTS `telephone`;
CREATE TABLE IF NOT EXISTS `telephone` (
  `idtelephone` int(11) NOT NULL AUTO_INCREMENT,
  `ecran` varchar(255) DEFAULT NULL,
  `tv` tinyint(2) DEFAULT NULL,
  `appareil_photo` varchar(255) DEFAULT NULL,
  `video_numerique` varchar(255) DEFAULT NULL,
  `ram` varchar(255) DEFAULT NULL,
  `carte_sd` tinyint(2) DEFAULT NULL,
  `double_sim` tinyint(2) DEFAULT NULL,
  `photo_url` varchar(255) DEFAULT NULL,
  `modele` varchar(255) DEFAULT NULL,
  `marque` varchar(255) DEFAULT NULL,
  `prix` float DEFAULT NULL,
  `stockage` varchar(255) DEFAULT NULL,
  `capacite_internet` varchar(255) DEFAULT NULL,
  `is_deleted` tinyint(2) DEFAULT FALSE,
  PRIMARY KEY (`idtelephone`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE IF NOT EXISTS `utilisateur` (
  `idutilisateur` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idutilisateur`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `zone_geographique`
--

DROP TABLE IF EXISTS `zone_geographique`;
CREATE TABLE IF NOT EXISTS `zone_geographique` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `zone_geographique_pays`
--

DROP TABLE IF EXISTS `zone_geographique_pays`;
CREATE TABLE IF NOT EXISTS `zone_geographique_pays` (
  `zone_geographique` int(11) DEFAULT NULL,
  `pays` int(11) DEFAULT NULL,
  KEY `zone_geographique_pays_pays_idx` (`pays`),
  KEY `zone_geographique_pays_zone_idx` (`zone_geographique`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `forfait_etranger_plage_horaire`
--
ALTER TABLE `forfait_etranger_plage_horaire`
  ADD CONSTRAINT `forfait_etranger_plage_horaire` FOREIGN KEY (`plage`) REFERENCES `plage_horaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `formule_plage_horaire`
--
ALTER TABLE `formule_plage_horaire`
  ADD CONSTRAINT `formule_plage_horaire_plage_horaire` FOREIGN KEY (`plage_horaire`) REFERENCES `plage_horaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `zone_geographique_pays`
--
ALTER TABLE `zone_geographique_pays`
  ADD CONSTRAINT `zone_geographique_pays_pays` FOREIGN KEY (`pays`) REFERENCES `pays` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `zone_geographique_pays_zone` FOREIGN KEY (`zone_geographique`) REFERENCES `zone_geographique` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
