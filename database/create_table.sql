-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Ven 13 Janvier 2017 à 08:52
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

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser`(
    IN n VARCHAR(255),
    IN m VARCHAR(255),
    IN adr VARCHAR(255),
    IN mdp VARCHAR(255),
    INOUT id INT)
BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF EXISTS (SELECT * FROM utilisateur WHERE mail=m) THEN
			/* get id of existing record with same mail */
			SET id = (SELECT idutilisateur FROM utilisateur WHERE mail=m ORDER BY idutilisateur DESC LIMIT 1);
			/* update record */
			UPDATE utilisateur SET nom=n, mail=m, adresse=adr, mot_de_passe=mdp WHERE idutilisateur=id;
		ELSE
			/* insert new user */
        	INSERT INTO utilisateur (nom, mail, adresse, mot_de_passe) VALUES (n, m, adr, mdp);
			/* get generated id */
        	SET id = (SELECT idutilisateur FROM utilisateur WHERE nom=n AND mail=m AND adresse=adr AND mot_de_passe=mdp ORDER BY idutilisateur DESC LIMIT 1);
		END IF;
        COMMIT;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkPassword`(
    IN mdp VARCHAR(255),
    IN email VARCHAR(255),
    INOUT ok BOOLEAN)
BEGIN
        SET ok = (SELECT COUNT(*) FROM utilisateur WHERE mail=email AND mot_de_passe=mdp);
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser`(
    IN id INT)
BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF EXISTS (SELECT * FROM utilisateur WHERE idutilisateur=id) THEN
			/* get rid of user */
            DELETE FROM utilisateur WHERE idutilisateur=id;
		ELSE
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No user found for this id';
		END IF;
        COMMIT;
    END$$

--
-- Fonctions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `addUserF`(
    n VARCHAR(255),
    m VARCHAR(255),
    adr VARCHAR(255),
    mdp VARCHAR(255)) RETURNS int(11)
BEGIN
        DECLARE id INT;
        DECLARE existsAlready BOOLEAN;
        IF EXISTS (SELECT * FROM utilisateur WHERE mail=m) THEN
			/* get id of existing record with same mail */
			SET id = (SELECT idutilisateur FROM utilisateur WHERE mail=m ORDER BY idutilisateur DESC LIMIT 1);
			/* update record */
			UPDATE utilisateur SET nom=n, mail=m, adresse=adr, mot_de_passe=mdp WHERE idutilisateur=id;
		ELSE
			/* insert new user */
        	INSERT INTO utilisateur (nom, mail, adresse, mot_de_passe) VALUES (n, m, adr, mdp);
			/* get generated id */
        	SET id = (SELECT idutilisateur FROM utilisateur WHERE nom=n AND mail=m AND adresse=adr AND mot_de_passe=mdp ORDER BY idutilisateur DESC LIMIT 1);
		END IF;
        RETURN id;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `achat`
--

CREATE TABLE IF NOT EXISTS `achat` (
  `idachat` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `telephone` int(11) DEFAULT NULL,
  `id_utilisateur` int(11) DEFAULT NULL,
  `id_formule` int(11) DEFAULT NULL,
  PRIMARY KEY (`idachat`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `appel`
--

CREATE TABLE IF NOT EXISTS `appel` (
  `idappel` int(11) NOT NULL AUTO_INCREMENT,
  `debut_appel` datetime DEFAULT NULL,
  `duree` time DEFAULT NULL,
  `destination` int(11) DEFAULT NULL,
  `consommation` int(11) DEFAULT NULL,
  PRIMARY KEY (`idappel`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `consommation`
--

CREATE TABLE IF NOT EXISTS `consommation` (
  `idconsommation` int(11) NOT NULL AUTO_INCREMENT,
  `date_debut` datetime DEFAULT NULL,
  `conso_data` int(11) DEFAULT NULL,
  `id_achat` int(11) DEFAULT NULL,
  PRIMARY KEY (`idconsommation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `destination_appel`
--

CREATE TABLE IF NOT EXISTS `destination_appel` (
  `iddestination_appel` int(11) NOT NULL AUTO_INCREMENT,
  `id_zone_geographique` int(11) DEFAULT NULL,
  `id_appel` int(11) DEFAULT NULL,
  PRIMARY KEY (`iddestination_appel`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `destination_mms`
--

CREATE TABLE IF NOT EXISTS `destination_mms` (
  `iddestination_mms` int(11) NOT NULL AUTO_INCREMENT,
  `id_zone_geographique` int(11) DEFAULT NULL,
  `id_mms` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`iddestination_mms`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `destination_sms`
--

CREATE TABLE IF NOT EXISTS `destination_sms` (
  `iddestination_sms` int(11) NOT NULL AUTO_INCREMENT,
  `id_zone_geographique` int(11) DEFAULT NULL,
  `id_sms` int(11) DEFAULT NULL,
  PRIMARY KEY (`iddestination_sms`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `facture`
--

CREATE TABLE IF NOT EXISTS `facture` (
  `idfacture` int(11) NOT NULL AUTO_INCREMENT,
  `consommation` int(11) DEFAULT NULL,
  `prix` int(11) DEFAULT NULL,
  `paye` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`idfacture`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `forfait_etranger`
--

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `forfait_etranger_plage_horaire`
--

CREATE TABLE IF NOT EXISTS `forfait_etranger_plage_horaire` (
  `forfait` int(11) DEFAULT NULL,
  `plage` int(11) DEFAULT NULL,
  KEY `forfait_etranger_plage_horaire_idx` (`plage`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `formule`
--

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `formule_plage_horaire`
--

CREATE TABLE IF NOT EXISTS `formule_plage_horaire` (
  `formule` int(11) NOT NULL,
  `plage_horaire` int(11) NOT NULL,
  KEY `formule_plage_horaire_plage_horaire_idx` (`plage_horaire`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `mms`
--

CREATE TABLE IF NOT EXISTS `mms` (
  `idmms` int(11) NOT NULL AUTO_INCREMENT,
  `volume` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `destination` int(11) DEFAULT NULL,
  `consommation` int(11) DEFAULT NULL,
  PRIMARY KEY (`idmms`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `pays`
--

CREATE TABLE IF NOT EXISTS `pays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `plage_horaire`
--

CREATE TABLE IF NOT EXISTS `plage_horaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  `heure_debut` time DEFAULT NULL,
  `heure_fin` time DEFAULT NULL,
  `jour` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `sms`
--

CREATE TABLE IF NOT EXISTS `sms` (
  `idsms` int(11) NOT NULL AUTO_INCREMENT,
  `volume` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `destination` int(11) DEFAULT NULL,
  `consommation` int(11) DEFAULT NULL,
  PRIMARY KEY (`idsms`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `telephone`
--

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
  PRIMARY KEY (`idtelephone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE IF NOT EXISTS `utilisateur` (
  `idutilisateur` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idutilisateur`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Contenu de la table `utilisateur`
--

INSERT INTO `utilisateur` (`idutilisateur`, `nom`, `mail`, `adresse`, `mot_de_passe`, `admin`) VALUES
(20, 'test', 'test', 'test', 'test', 0),
(21, 'joe', 'joe@mail.com', 'joe lives here', 'joe password', 0);

-- --------------------------------------------------------

--
-- Structure de la table `zone_geographique`
--

CREATE TABLE IF NOT EXISTS `zone_geographique` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `zone_geographique_pays`
--

CREATE TABLE IF NOT EXISTS `zone_geographique_pays` (
  `zone_geographique` int(11) DEFAULT NULL,
  `pays` int(11) DEFAULT NULL,
  KEY `zone_geographique_pays_pays_idx` (`pays`),
  KEY `zone_geographique_pays_zone_idx` (`zone_geographique`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
