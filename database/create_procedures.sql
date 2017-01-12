DELIMITER |

/* procedure example */
DROP PROCEDURE IF EXISTS addUser|

CREATE PROCEDURE addUser (
    IN n VARCHAR(255),
    IN m VARCHAR(255),
    IN adr VARCHAR(255),
    IN mdp VARCHAR(255),
    INOUT id INT)
    BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF EXISTS (SELECT * FROM utilisateur WHERE mail=m) THEN
			/* get id of existing record with same mail */
			SET id = (SELECT idutilisateur FROM utilisateur WHERE mail=m ORDER BY idutilisateur DESC LIMIT 1);
			/* update record */
			UPDATE utilisateur SET nom=n, mail=m, adresse=adr, mot_de_passe=mdp WHERE idutilisateur=id;
		ELSE
			/* insert new user */
        	INSERT INTO utilisateur (nom, mail, adresse, mot_de_passe) VALUES (n, m, adr, mdp);
			/* get generated id */
        	SET id = (SELECT idutilisateur FROM utilisateur WHERE nom=n AND mail=m AND adresse=adr AND mot_de_passe=mdp ORDER BY idutilisateur DESC LIMIT 1);
		END IF;
        COMMIT;
    END|

/* function example */
DROP FUNCTION IF EXISTS addUserF|
CREATE FUNCTION addUserF (
    n VARCHAR(255),
    m VARCHAR(255),
    adr VARCHAR(255),
    mdp VARCHAR(255))
    RETURNS INT
    BEGIN
        DECLARE id INT;
        DECLARE existsAlready BOOLEAN;
        IF EXISTS (SELECT * FROM utilisateur WHERE mail=m) THEN
			/* get id of existing record with same mail */
			SET id = (SELECT idutilisateur FROM utilisateur WHERE mail=m ORDER BY idutilisateur DESC LIMIT 1);
			/* update record */
			UPDATE utilisateur SET nom=n, mail=m, adresse=adr, mot_de_passe=mdp WHERE idutilisateur=id;
		ELSE
			/* insert new user */
        	INSERT INTO utilisateur (nom, mail, adresse, mot_de_passe) VALUES (n, m, adr, mdp);
			/* get generated id */
        	SET id = (SELECT idutilisateur FROM utilisateur WHERE nom=n AND mail=m AND adresse=adr AND mot_de_passe=mdp ORDER BY idutilisateur DESC LIMIT 1);
		END IF;
        RETURN id;
    END|

DELIMITER ;

/* procedure call (potential multiple output) */
CALL addUser('joe', 'joe@mail.com', 'joe lives here', 'joe password', @id);
SELECT @id;

/* function call (only one return value) */
SELECT addUserF('joe', 'joe@mail.com', 'joe lives here', 'joe password') as id;
