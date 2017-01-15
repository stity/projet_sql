DELIMITER |

DROP PROCEDURE IF EXISTS addPlageHoraire|

CREATE PROCEDURE addPlageHoraire (
    IN nom_ VARCHAR(45),
    IN heure_debut_ TIME,
    IN heure_fin_ TIME,
    IN jour_ INT(11))
    BEGIN
        START TRANSACTION;
        IF NOT EXISTS (SELECT * FROM plage_horaire WHERE nom=nom_ AND jour=jour_) THEN
        	INSERT INTO plage_horaire (nom, heure_debut, heure_fin, jour) VALUES (nom_, heure_debut_, heure_fin_, jour_);
		END IF;
        COMMIT;
    END|

DELIMITER ;

/* Les plages horaires sont celles sur lesquelles les consommation ne sont pas facturées */
CALL addPlageHoraire('week_all', '00:00:00', '23:59:59', 1);
CALL addPlageHoraire('week_day', '06:00:00', '21:00:00', 1);
CALL addPlageHoraire('week_morning', '00:00:00', '06:00:00', 1);
CALL addPlageHoraire('week_evening', '21:00:00', '23:59:59', 1);

CALL addPlageHoraire('week_end_all', '00:00:00', '23:59:59', 2);
CALL addPlageHoraire('week_end_day', '06:00:00', '21:00:00', 2);
CALL addPlageHoraire('week_end_morning', '00:00:00', '06:00:00', 2);
CALL addPlageHoraire('week_end_evening', '21:00:00', '23:59:59', 2);

CALL addPlageHoraire('all_all', '00:00:00', '23:59:59', 3);
CALL addPlageHoraire('all_day', '06:00:00', '21:00:00', 3);
CALL addPlageHoraire('all_morning', '00:00:00', '06:00:00', 3);
CALL addPlageHoraire('all_evening', '21:00:00', '23:59:59', 3);
