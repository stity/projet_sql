
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

CALL addForeignForfait('Europe et DOM-TOM', 300, 100, 200, 0, 'week_all', 0.15, 0.15, 0.15, 2);
CALL addForeignForfait('Europe élargie', 200, 100, 100, 0, 'week_evening', 0.1, 0.1, 0.1, 3);
CALL addForeignForfait('Maghreb', 500, 5000, 1000, 0, 'week_morning', 0.1, 0.1, 0.1, 4);
CALL addForeignForfait('Amérique du Nord', 500, 5000, 1000, 0, 'week_end_day', 0.1, 0.1, 0.1, 5);
CALL addForeignForfait('Amérique du Sud', 500, 5000, 1000, 0, 'week_end_evening', 0.1, 0.1, 0.1, 6);
CALL addForeignForfait('Asie', 500, 5000, 1000, 0, 'all_morning', 0.1, 0.1, 0.1, 7);
CALL addForeignForfait('Reste du monde', 500, 5000, 1000, 0, 'week_all', 0.1, 0.1, 0.1, 8);
CALL addForeignForfait('Réseaux satellitaires', 3, 3, 5, 0, 'never', 1.5, 0.8, 1.1, 9);


DELIMITER |

DROP PROCEDURE IF EXISTS deleteFormuleEtranger|

CREATE PROCEDURE deleteFormuleEtranger (
    IN idformule INT)
    BEGIN
        START TRANSACTION;
        IF EXISTS (SELECT * FROM forfait_etranger WHERE id=idformule) THEN
			/* get rid of user */
            UPDATE forfait_etranger SET is_deleted = true WHERE id=idformule;
		ELSE
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No product found for this id';
		END IF;
        COMMIT;
    END|

DELIMITER ;
