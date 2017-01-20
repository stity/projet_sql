
DELIMITER |

/* Création d'un utilisateur */
DROP PROCEDURE IF EXISTS addForeignForfait|

CREATE PROCEDURE addForeignForfait (
    IN nom_ VARCHAR(45),
    IN limite_appel_ INT(11),
    IN limite_sms_ INT(11),
    IN limite_data_ INT(11),
    IN bloque_ TINYINT(2),
    IN plage_horaire_ VARCHAR(45),
    IN prix_hors_forfait_appel_ FLOAT,
    IN prix_hors_forfait_sms_ FLOAT,
    IN prix_hors_forfait_data_ FLOAT,
    IN id_zone INT(11))
    BEGIN
        DECLARE id_plage_horaire INT;
        DECLARE id_ INT;
        START TRANSACTION;
        SET id_plage_horaire = (SELECT id FROM plage_horaire WHERE nom = plage_horaire_ LIMIT 1);
        IF EXISTS (SELECT * FROM forfait_etranger WHERE nom=nom_) THEN
			SET id_ = (SELECT id FROM forfait_etranger WHERE nom=nom_ ORDER BY id DESC LIMIT 1);
			UPDATE forfait_etranger SET nom=nom_, limite_appel=limite_appel_, limite_sms=limite_sms_, limite_data=limite_data_, bloque=bloque_, prix_hors_forfait_appel=prix_hors_forfait_appel_, prix_hors_forfait_sms=prix_hors_forfait_sms_, prix_hors_forfait_data=prix_hors_forfait_data_, zone=id_zone WHERE id=id_;
            IF NOT EXISTS (SELECT * FROM forfait_etranger_plage_horaire WHERE forfait = id_ AND plage = id_plage_horaire) THEN
                INSERT INTO forfait_etranger_plage_horaire (forfait, plage) VALUES (id_, id_plage_horaire);
            END IF;
		ELSE
        	INSERT INTO forfait_etranger (nom, limite_appel, limite_sms, limite_data, bloque, prix_hors_forfait_appel, prix_hors_forfait_sms, prix_hors_forfait_data, zone) VALUES (nom_, limite_appel_, limite_sms_, limite_data_, bloque_, prix_hors_forfait_appel_, prix_hors_forfait_sms_, prix_hors_forfait_data_, id_zone);
            INSERT INTO forfait_etranger_plage_horaire (forfait, plage) VALUES ((SELECT id FROM forfait_etranger WHERE nom=nom_ LIMIT 1), id_plage_horaire);
		END IF;
        COMMIT;
    END|

DELIMITER ;

CALL addForeignForfait('Europe et DOM-TOM', 1000, 10000, 2000, 0, 'week_all', 0.15, 0.15, 0.15, 1);
CALL addForeignForfait('US et Canada', 500, 5000, 1000, 0, 'week_all', 0.1, 0.1, 0.1, 4);

DELIMITER |

DROP PROCEDURE IF EXISTS deleteFormuleEtranger|

CREATE PROCEDURE deleteFormuleEtranger (
    IN idformule INT)
    BEGIN
        START TRANSACTION;
        IF EXISTS (SELECT * FROM forfait_etranger WHERE id=idformule) THEN
			/* get rid of user */
            DELETE FROM forfait_etranger WHERE id=idformule;
            DELETE FROM formule_forfait_etranger WHERE forfait_etranger=idformule;
		ELSE
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No product found for this id';
		END IF;
        COMMIT;
    END|

DELIMITER ;
