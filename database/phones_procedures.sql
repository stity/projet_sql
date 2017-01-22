
DELIMITER |

/* Création d'un utilisateur */
DROP PROCEDURE IF EXISTS addPhone|

CREATE PROCEDURE addPhone (
    IN ecran_ VARCHAR(255),
    IN tv_ TINYINT(2),
    IN appareil_photo_ VARCHAR(255),
    IN video_numerique_ VARCHAR(255),
    IN ram_ VARCHAR(255),
    IN carte_sd_ TINYINT(2),
    IN double_sim_ TINYINT(2),
    IN photo_url_ VARCHAR(255),
    IN modele_ VARCHAR(255),
    IN marque_ VARCHAR(255),
    IN prix_ FLOAT,
    IN stockage_ VARCHAR(255),
    IN capacite_internet_ VARCHAR(255),
    INOUT id INT)
    BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF EXISTS (SELECT * FROM telephone WHERE modele=modele_ AND marque=marque_) THEN
			/* get id of existing record with same mail */
			SET id = (SELECT idtelephone FROM telephone WHERE modele=modele_ AND marque=marque_ ORDER BY idtelephone DESC LIMIT 1);
			/* update record */
			UPDATE telephone SET ecran=ecran_, tv=tv_, appareil_photo=appareil_photo_, video_numerique=video_numerique_, ram=ram_, carte_sd=carte_sd_, double_sim=double_sim_, photo_url=photo_url_, prix=prix_, stockage=stockage_, capacite_internet=capacite_internet_ WHERE idtelephone=id;
		ELSE
        	INSERT INTO telephone (ecran, tv, appareil_photo, video_numerique, ram, carte_sd, double_sim, photo_url, modele, marque, prix, stockage, capacite_internet) VALUES (ecran_, tv_, appareil_photo_, video_numerique_, ram_, carte_sd_, double_sim_, photo_url_, modele_, marque_, prix_, stockage_, capacite_internet_);
        	SET id = (SELECT idtelephone FROM telephone WHERE modele=modele_ AND marque=marque_ ORDER BY idtelephone DESC LIMIT 1);
		END IF;
        COMMIT;
    END|

DROP PROCEDURE IF EXISTS deletePhone|

CREATE PROCEDURE deletePhone (
    IN id INT)
    BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF EXISTS (SELECT * FROM telephone WHERE idtelephone=id) THEN
            DELETE FROM telephone WHERE idtelephone=id;
            DELETE FROM formule_telephone WHERE telephone=id;
		ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No phone found for this id';
		END IF;
        COMMIT;
    END|

DELIMITER ;

CALL addPhone('4,5" soit 11,4cm - Gorilla Glass3', true, '8 mégapixels, Zoom digital x6, Flash LED', '2 mégapixels, 1280x720 pixels', '2Go', true, true, 'http://boulanger.scene7.com/is/image/Boulanger/bfr_overlay?layer=comp&$t1=&$product_id=Boulanger/3700764702628_h_f_l_0&$i1=Boulanger/new_default&wid=350&hei=350', 'Trekker M1 Core', 'Crosscall', 279.00, '16.0 Go (mémoire interner), 128 Go (capacité max cartes mémoires)', 'Bluetooth, Wi-Fi 802.11 b/g/n', @id);
CALL addPhone('5,5"', true, '16 mégapixels, Zoom digital x6, Flash LED', '1280x720 pixels', '3Go', true, false, 'http://img1.lesnumeriques.com/produits/35/24929/lg-g4_aafb49967f246ae1_450x400.jpg', 'G4', 'LG', 275.00, '32.0 Go (mémoire interner), 128 Go (capacité max cartes mémoires)', 'Bluetooth, Wi-Fi 802.11 b/g/n', @id);

