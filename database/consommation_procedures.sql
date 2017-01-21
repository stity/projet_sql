
DELIMITER |

/* Consommation */
DROP PROCEDURE IF EXISTS addConso|

CREATE PROCEDURE addConso (
    IN debut DATETIME,
    IN conso INT(11),
    IN achat INT(11),
    INOUT id INT)
    BEGIN
        IF NOT EXISTS (SELECT * FROM consommation WHERE idconsommation=id AND date_debut=debut AND id_achat=achat) THEN
            START TRANSACTION;
			/* insert new user */
        	INSERT INTO consommation (date_debut, conso_data, id_achat) VALUES (debut, conso, achat);
			/* get generated id */
        	SET id = (SELECT idconsommation FROM consommation WHERE date_debut=debut AND conso_data=conso AND id_achat=achat ORDER BY idconsommation DESC LIMIT 1);
            COMMIT;
		END IF;
    END|

DROP PROCEDURE IF EXISTS updateConsoData|

CREATE PROCEDURE updateConsoData (
    IN conso INT(11),
    IN id INT)
    BEGIN
        IF EXISTS (SELECT * FROM consommation WHERE idconsommation=id) THEN
			/* update record */
			UPDATE consommation SET conso_data=conso WHERE idconsommation=id;
		ELSE
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching consommation found for this id';
		END IF;
    END|

DROP PROCEDURE IF EXISTS addConsoFromUser|

CREATE PROCEDURE addConsoFromUser (
    IN debut DATETIME,
    IN conso INT(11),
    IN usermail VARCHAR(255),
    INOUT id INT)
    BEGIN
        START TRANSACTION;
        CALL getUserId(usermail, @userId);
        CALL getAchatIdFromUser(@userId, @achatId);
        CALL addConso(debut, conso, @achatId, @id);
        SET id = @id;
        COMMIT;
    END|

/* SMS */
DROP PROCEDURE IF EXISTS addSMS|

CREATE PROCEDURE addSMS (
    IN v INT(11),
    IN d DATETIME,
    IN dest INT(11),
    IN conso INT(11),
    INOUT id INT)
    BEGIN
        IF NOT EXISTS (SELECT * FROM consommation WHERE idconsommation=conso) THEN
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching consommation found for this id';
		ELSE
            START TRANSACTION;
			/* insert new user */
        	INSERT INTO sms (volume, date, destination, consommation) VALUES (v,d,dest,conso);
			/* get generated id */
        	SET id = (SELECT idsms FROM sms WHERE volume=v AND date=d AND destination=dest AND consommation=conso ORDER BY idsms DESC LIMIT 1);
            COMMIT;
		END IF;
    END|

DROP PROCEDURE IF EXISTS loopRandomSMS|

CREATE PROCEDURE loopRandomSMS (
    IN numberLoop INT(11),
    IN d DATETIME,
    IN dest INT(11),
    IN conso INT(11))
    BEGIN
        DECLARE v_counter INT UNSIGNED DEFAULT 0;
        DECLARE randdate DATETIME;
        SET v_counter = 0;
        WHILE v_counter < numberLoop DO
            SET randdate = (ADDDATE(d, random(1,20)));
            SET randdate = (ADDTIME(randdate, CONCAT(CONCAT(random(1,12),':'),CONCAT(CONCAT(random(1,59),':'),random(1,59)))));
            CALL addSMS(random(1,10), randdate, random(1,dest), conso, @smsid);
            SET v_counter=v_counter+1;
        END WHILE;
    END|


/* MMS */
DROP PROCEDURE IF EXISTS addMMS|

CREATE PROCEDURE addMMS (
    IN v INT(11),
    IN d DATETIME,
    IN dest INT(11),
    IN conso INT(11),
    INOUT id INT)
    BEGIN
        IF NOT EXISTS (SELECT * FROM consommation WHERE idconsommation=conso) THEN
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching consommation found for this id';
		ELSE
            START TRANSACTION;
			/* insert new user */
        	INSERT INTO mms (volume, date, destination, consommation) VALUES (v,d,dest,conso);
			/* get generated id */
        	SET id = (SELECT idmms FROM mms WHERE volume=v AND date=d AND destination=dest AND consommation=conso ORDER BY idmms DESC LIMIT 1);
            COMMIT;
		END IF;
    END|


DROP PROCEDURE IF EXISTS loopRandomMMS|

CREATE PROCEDURE loopRandomMMS (
    IN numberLoop INT(11),
    IN d DATETIME,
    IN dest INT(11),
    IN conso INT(11))
    BEGIN
        DECLARE v_counter INT UNSIGNED DEFAULT 0;
        DECLARE randdate DATETIME;
        SET v_counter = 0;
        WHILE v_counter < numberLoop DO
            SET randdate = (ADDDATE(d, random(1,20)));
            SET randdate = (ADDTIME(randdate, CONCAT(CONCAT(random(1,12),':'),CONCAT(CONCAT(random(1,59),':'),random(1,59)))));
            CALL addMMS(random(1,10), randdate, random(1,dest), conso, @smsid);
            SET v_counter=v_counter+1;
        END WHILE;
    END|



/* Appel */
DROP PROCEDURE IF EXISTS addAppel|

CREATE PROCEDURE addAppel (
    IN debut DATETIME,
    IN dur TIME,
    IN dest INT(11),
    IN conso INT(11),
    INOUT id INT)
    BEGIN
        IF NOT EXISTS (SELECT * FROM consommation WHERE idconsommation=conso) THEN
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No matching consommation found for this id';
		ELSE
            START TRANSACTION;
			/* insert new user */
        	INSERT INTO appel (debut_appel, duree, destination, consommation) VALUES (debut, dur ,dest,conso);
			/* get generated id */
        	SET id = (SELECT idappel FROM appel WHERE debut_appel=debut AND duree=dur AND destination=dest AND consommation=conso ORDER BY idappel DESC LIMIT 1);
            COMMIT;
		END IF;
    END|

DROP PROCEDURE IF EXISTS loopRandomAppel|

CREATE PROCEDURE loopRandomAppel (
    IN numberLoop INT,
    IN debut DATETIME,
    IN dest INT(11),
    IN conso INT(11))
    BEGIN
        DECLARE v_counter INT UNSIGNED DEFAULT 0;
        DECLARE dur TIME;
        DECLARE randdate DATETIME;
        SET v_counter = 0;
        WHILE v_counter < numberLoop DO
        /* random duration */
            SET dur = (ADDTIME('00:00:00', CONCAT('00:',CONCAT(CONCAT(random(1,30),':'),random(1,59)))));
            SET randdate = (ADDDATE(debut, random(1,20)));
            SET randdate = (ADDTIME(randdate, CONCAT(CONCAT(random(1,12),':'),CONCAT(CONCAT(random(1,59),':'),random(1,59)))));
            CALL addAppel(randdate, dur, random(1,dest), conso, @appelid);
            SET v_counter=v_counter+1;
        END WHILE;
    END|


DROP PROCEDURE IF EXISTS generateConso|

CREATE PROCEDURE generateConso (
    IN numberLoop INT,
    IN debut DATETIME,
    IN useremail VARCHAR(255),
    IN dest INT(11))
    BEGIN
        START TRANSACTION;
        CALL addConsoFromUser(debut, random(0, 3500), useremail, @consoid);
        CALL loopRandomSMS(numberLoop, ADDTIME(debut, '08:32:00'), dest, @consoid);
        CALL loopRandomMMS(numberLoop, ADDTIME(debut, '08:32:00'), dest, @consoid);
        CALL loopRandomAppel(numberLoop, ADDTIME(debut, '08:32:00'), dest, @consoid);
        COMMIT;
    END|

DROP PROCEDURE IF EXISTS getTotalPriceConso|

CREATE PROCEDURE getTotalPriceConso (
    IN consoId INT,
    INOUT cost FLOAT)
    BEGIN
        DECLARE numberFrenchSMS INT;
        DECLARE numberFrenchMMS INT;
        START TRANSACTION;
            /* initiate cost */
            SET cost = 0;
            /* get formule parameters */
            SELECT formule.id, prix_mensuel, limite_appel, limite_sms, limite_data, prix_hors_forfait_appel, prix_hors_forfait_sms, prix_hors_forfait_data, plage_horaire
                INTO @formule_id, @prix_mensuel, @limite_appel, @limite_sms, @limite_data, @prix_appel, @prix_sms, @prix_data, @plage_horaire
                FROM consommation, achat, formule
                WHERE (consommation.id_achat=achat.idachat
                       AND achat.id_formule = formule.id
                       AND consommation.idconsommation=consoId);
            SET cost = cost + @prix_mensuel;

            /* french sms and mms */
            /* get the number of sms and mms sent outside every unlimited period to a french phone for the right month*/
            SET numberFrenchSMS = (SELECT SUM(volume) FROM  /*get sum of the remaining volume of sms and mms */
                                   (SELECT volume,isInPlageHoraire(date, formule_plage_horaire.plage_horaire) as appartient_plage
                                        FROM (SELECT CONCAT('m',idmms) as id, volume, date, destination
                                              FROM mms WHERE consommation=consoId
                                              UNION ALL /* union des sms (dont l'id est préfixé par s) et des mms (dont l'id est préfixé par m) */
                                              SELECT CONCAT('s',idsms) as id, volume, date , destination
                                              FROM sms WHERE consommation=consoId) u,
                                        formule_plage_horaire
                                    WHERE formule_plage_horaire.formule=@formule_id /*récupération des plages horaires correspondant à la formule */
                                    GROUP BY u.id /* pour chaque sms/mms...*/
                                    HAVING SUM(appartient_plage)=0)  /* ... on regarde si la date d'envoi est compris dans au moins une plage */
                                   temp);
            IF numberFrenchSMS > @limite_sms THEN
                SET cost = cost+(numberFrenchSMS-@limit_sms)*@prix_sms;
            END IF;

            /* other sms and mms */
            BEGIN
            DECLARE done INT DEFAULT FALSE;
            DECLARE enumber_sms INT;
            DECLARE elimite_sms INT;
            DECLARE eprix_hors_forfait_sms FLOAT;
            DECLARE smscursor CURSOR FOR (SELECT SUM(volume),limite_sms, prix_hors_forfait_sms FROM
                (SELECT sms.volume, limite_sms, prix_hors_forfait_sms, isInPlageHoraire(sms.date, forfait_etranger_plage_horaire.plage) AS appartient_plage, forfait_etranger.id as id_forfait
                FROM formule_forfait_etranger,
                     forfait_etranger,
                     (SELECT CONCAT('m',idmms) as id, volume, date, destination FROM mms WHERE consommation=consoId
                      UNION ALL
                      SELECT CONCAT('s',idsms) as id, volume, date, destination FROM sms WHERE consommation=consoId)
                     sms,
                     zone_geographique_pays,
                     forfait_etranger_plage_horaire
                WHERE (formule_forfait_etranger.formule = @formule_id
                       AND formule_forfait_etranger.forfait_etranger = forfait_etranger.id
                       AND zone_geographique_pays.pays = sms.destination
                       AND forfait_etranger.zone = zone_geographique_pays.zone_geographique
                       AND forfait_etranger_plage_horaire.forfait= forfait_etranger.id)
                GROUP BY sms.id
                HAVING SUM(appartient_plage)=0)
                limited_sms
                GROUP BY id_forfait);
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

            OPEN smscursor;
            smsLoop : LOOP
                FETCH smscursor into enumber_sms, elimite_sms, eprix_hors_forfait_sms;
                IF done THEN
                    LEAVE smsLoop;
                END IF;
                IF enumber_sms > elimite_sms THEN
                    SET cost = cost + (enumber_sms - elimite_sms)*eprix_hors_forfait_sms;
                END IF;
            END LOOP;

            CLOSE smscursor;
            END;
        COMMIT;
    END|


DELIMITER ;

SET @dest_max = (SELECT COUNT(*) FROM pays);
CALL generateConso(20, '20161100', 'jean.martin@banane.fr', @dest_max);
CALL generateConso(20, '20161100', 'jean.ramos@hotmail.fr', @dest_max);
CALL generateConso(20, '20161100', 'rogerdelachance@free.fr', @dest_max);
CALL generateConso(20, '20161100', 'rvbtd@free.fr', @dest_max);
CALL generateConso(20, '20161100', 'jojomiche@orange.fr', @dest_max);
CALL generateConso(20, '20161100', 'admin@admin.fr', @dest_max);
CALL generateConso(20, '20161200', 'jean.martin@banane.fr', @dest_max);
CALL generateConso(20, '20161200', 'jean.ramos@hotmail.fr', @dest_max);
CALL generateConso(20, '20161200', 'rogerdelachance@free.fr', @dest_max);
CALL generateConso(20, '20161200', 'rvbtd@free.fr', @dest_max);
CALL generateConso(20, '20161200', 'jojomiche@orange.fr', @dest_max);
CALL generateConso(20, '20161200', 'admin@admin.fr', @dest_max);
CALL generateConso(20, '20170100', 'jean.martin@banane.fr', @dest_max);
CALL generateConso(20, '20170100', 'jean.ramos@hotmail.fr', @dest_max);
CALL generateConso(20, '20170100', 'rogerdelachance@free.fr', @dest_max);
CALL generateConso(20, '20170100', 'rvbtd@free.fr', @dest_max);
CALL generateConso(20, '20170100', 'jojomiche@orange.fr', @dest_max);
CALL generateConso(20, '20170100', 'admin@admin.fr', @dest_max);
