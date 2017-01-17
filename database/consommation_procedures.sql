
DELIMITER |

/* Consommation */
DROP PROCEDURE IF EXISTS addConso|

CREATE PROCEDURE addConso (
    IN debut DATETIME,
    IN conso INT(11),
    IN achat INT(11),
    INOUT id INT)
    BEGIN
        IF EXISTS (SELECT * FROM consommation WHERE idconsommation=id) THEN
			/* update record */
			UPDATE consommation SET date_debut=debut, conso_data=conso, id_achat=achat WHERE idconsommation=id;
		ELSE
            START TRANSACTION;
			/* insert new user */
        	INSERT INTO consommation (date_debut, conso_data, id_achat) VALUES (debut, conso, achat);
			/* get generated id */
        	SET id = (SELECT idconsommation FROM consommation WHERE date_debut=debut AND conso_data=conso AND id_achat=achat ORDER BY idconsommation DESC LIMIT 1);
            COMMIT;
		END IF;
    END|

DROP PROCEDURE IF EXISTS addConsoFromUser|

CREATE PROCEDURE addConsoFromUser (
    IN debut DATETIME,
    IN conso INT(11),
    IN usermail VARCHAR(255),
    INOUT id INT)
    BEGIN
        CALL getUserId(usermail, @userId);
        CALL getAchatIdFromUser(@userId, @achatId);
        CALL addConso(debut, conso, @achatId, @id);
        SET id = @id;
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
        SET v_counter = 0;
        WHILE v_counter < numberLoop DO
            CALL addSMS(random(1,10), ADDDATE(d, random(1,20)), dest, conso, @smsid);
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
        SET v_counter = 0;
        WHILE v_counter < numberLoop DO
            CALL addMMS(random(1,10), ADDDATE(d, random(1,20)), dest, conso, @smsid);
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
        SET v_counter = 0;
        WHILE v_counter < numberLoop DO
        /* random duration */
            SET dur = (ADDTIME('00:00:00', CONCAT('00:',CONCAT(CONCAT(random(1,30),':'),random(1,59)))));
            CALL addAppel(ADDDATE(debut, random(1,20)), dur, dest, conso, @appelid);
            SET v_counter=v_counter+1;
        END WHILE;
    END|

DELIMITER ;

CALL addConsoFromUser('20161100', 0, 'jean.martin@banane.fr', @consoid);
CALL loopRandomSMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-11-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161100', 0, 'jean.ramos@hotmail.fr', @consoid);
CALL loopRandomSMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-11-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161100', 0, 'rogerdelachance@free.fr', @consoid);
CALL loopRandomSMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-11-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161100', 0, 'rvbtd@free.fr', @consoid);
CALL loopRandomSMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-11-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161100', 0, 'jojomiche@orange.fr', @consoid);
CALL loopRandomSMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-11-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161100', 0, 'admin@admin.fr', @consoid);
CALL loopRandomSMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-11-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-11-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161200', 0, 'jean.martin@banane.fr', @consoid);
CALL loopRandomSMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-12-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161200', 0, 'jean.ramos@hotmail.fr', @consoid);
CALL loopRandomSMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-12-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161200', 0, 'rogerdelachance@free.fr', @consoid);
CALL loopRandomSMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-12-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161200', 0, 'rvbtd@free.fr', @consoid);
CALL loopRandomSMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-12-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161200', 0, 'jojomiche@orange.fr', @consoid);
CALL loopRandomSMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-12-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20161200', 0, 'admin@admin.fr', @consoid);
CALL loopRandomSMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2016-12-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2016-12-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20170100', 0, 'jean.martin@banane.fr', @consoid);
CALL loopRandomSMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2017-01-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20170100', 0, 'jean.ramos@hotmail.fr', @consoid);
CALL loopRandomSMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2017-01-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20170100', 0, 'rogerdelachance@free.fr', @consoid);
CALL loopRandomSMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2017-01-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20170100', 0, 'rvbtd@free.fr', @consoid);
CALL loopRandomSMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2017-01-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20170100', 0, 'jojomiche@orange.fr', @consoid);
CALL loopRandomSMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2017-01-01T08:32:00', 0, @consoid);
CALL addConsoFromUser('20170100', 0, 'admin@admin.fr', @consoid);
CALL loopRandomSMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomMMS(20, '2017-01-01T08:32:00', 0, @consoid);
CALL loopRandomAppel(20, '2017-01-01T08:32:00', 0, @consoid);

