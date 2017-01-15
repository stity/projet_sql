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
        	SET id = (SELECT idconsommation FROM consommation WHERE date_debut=debut AND conso_data=conso AND idachat=achat ORDER BY idconsommation DESC LIMIT 1);
            COMMIT;
		END IF;
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
        	SET id = (SELECT idsms FROM mms WHERE volume=v AND date=d AND destination=dest AND consommation=conso ORDER BY idmms DESC LIMIT 1);
            COMMIT;
		END IF;
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

DELIMITER;
