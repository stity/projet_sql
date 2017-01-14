DELIMITER |

DROP PROCEDURE IF EXISTS deleteUser|

CREATE PROCEDURE deleteUser (
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
    END|

DROP PROCEDURE IF EXISTS checkPassword|

CREATE PROCEDURE checkPassword (
    IN mdp VARCHAR(255),
    IN email VARCHAR(255),
    INOUT ok BOOLEAN)
    BEGIN
        SET ok = (SELECT COUNT(*) FROM utilisateur WHERE mail=email AND mot_de_passe=mdp);
    END|

DELIMITER ;
