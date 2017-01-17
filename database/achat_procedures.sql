
DELIMITER |

/* Création d'un achat */
DROP PROCEDURE IF EXISTS addAchat|

CREATE PROCEDURE addAchat (
    IN d DATETIME,
    IN tel INT,
    IN utilisateur VARCHAR(255),
    IN formule INT,
    INOUT id INT)
    BEGIN
        START TRANSACTION;
        CALL getUserId(utilisateur, @userid);
        IF NOT EXISTS (SELECT * FROM achat WHERE `date`=d AND telephone=tel AND id_utilisateur=@userid AND id_formule=formule) THEN
			/* nouvel achat */
        	INSERT INTO achat (`date`, telephone, id_utilisateur, id_formule) VALUES (d, tel, utilisateur, formule);
		END IF;
        /* get generated id */
        SET id = (SELECT idachat FROM achat WHERE `date`=d AND telephone=tel AND id_utilisateur=utilisateur AND id_formule=formule ORDER BY idachat DESC LIMIT 1);
        COMMIT;
    END|

/* Création d'un utilisateur */
DROP PROCEDURE IF EXISTS getAchatIdFromUser|

CREATE PROCEDURE getAchatIdFromUser (
    IN utilisateur INT,
    INOUT id INT)
    BEGIN
        /* get id */
        SET id = (SELECT idachat FROM achat WHERE id_utilisateur=utilisateur ORDER BY idachat DESC LIMIT 1);
    END|


DELIMITER ;

/* création des achats */

SET @date = '2017-01-01T12:32:00';
CALL addAchat(ADDDATE(@date, 1), 1, 1, 1, @id);

CALL addAchat(ADDDATE(@date, 2), 1, 2, 1, @id);

CALL addAchat(ADDDATE(@date, 3), 1, 3, 1, @id);

CALL addAchat(ADDDATE(@date, 4), 1, 4, 1, @id);

CALL addAchat(ADDDATE(@date, 5), 1, 5, 1, @id);
