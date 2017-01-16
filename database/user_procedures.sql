
DELIMITER |

/* Création d'un utilisateur */
DROP PROCEDURE IF EXISTS addUser|

CREATE PROCEDURE addUser (
    IN n VARCHAR(255),
    IN m VARCHAR(255),
    IN adr VARCHAR(255),
    IN mdp VARCHAR(255),
    IN isAdmin TINYINT(1),
    INOUT id INT)
    BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF EXISTS (SELECT * FROM utilisateur WHERE mail=m) THEN
			/* get id of existing record with same mail */
			SET id = (SELECT idutilisateur FROM utilisateur WHERE mail=m ORDER BY idutilisateur DESC LIMIT 1);
			/* update record */
			UPDATE utilisateur SET nom=n, mail=m, adresse=adr, mot_de_passe=mdp, admin=isAdmin WHERE idutilisateur=id;
		ELSE
			/* insert new user */
        	INSERT INTO utilisateur (nom, mail, adresse, mot_de_passe, admin) VALUES (n, m, adr, mdp, isAdmin);
			/* get generated id */
        	SET id = (SELECT idutilisateur FROM utilisateur WHERE nom=n AND mail=m AND adresse=adr AND mot_de_passe=mdp AND admin=isAdmin ORDER BY idutilisateur DESC LIMIT 1);
		END IF;
        COMMIT;
    END|

/* Suppression d'un utilisateur */
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

/* Authentification d'un utilisateur */
DROP PROCEDURE IF EXISTS checkPassword|

CREATE PROCEDURE checkPassword (
    IN mdp VARCHAR(255),
    IN email VARCHAR(255),
    INOUT ok BOOLEAN)
    BEGIN
        SET ok = (SELECT COUNT(*) FROM utilisateur WHERE mail=email AND mot_de_passe=mdp);
    END|

DELIMITER ;
