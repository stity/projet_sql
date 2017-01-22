
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

DROP PROCEDURE IF EXISTS editUser|

CREATE PROCEDURE editUser (
    IN n VARCHAR(255),
    IN m VARCHAR(255),
    IN adr VARCHAR(255),
    IN mdp VARCHAR(255),
    IN isAdmin TINYINT(1),
    IN id_ INT(11))
    BEGIN
        START TRANSACTION;
        IF EXISTS (SELECT * FROM utilisateur WHERE idutilisateur=id_) THEN
        	UPDATE utilisateur SET nom=n, mail=m, adresse=adr, mot_de_passe=mdp, admin=isAdmin WHERE idutilisateur=id_;
        END IF;
        COMMIT;
    END|

/* Récupération de l'ID d'un utilisateur */
DROP PROCEDURE IF EXISTS getUserId |

CREATE PROCEDURE getUserId (
    IN m VARCHAR(255),
    INOUT id INT)
    BEGIN
        /* get id of existing record with same mail */
        SET id = (SELECT idutilisateur FROM utilisateur WHERE mail=m ORDER BY idutilisateur DESC LIMIT 1);
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
            DELETE FROM achat WHERE id_utilisateur=id;
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

CALL addUser('Jean Martin', 'jean.martin@banane.fr', '2 rue de la source 54821 NULLPART', 'secret', 0, @id);
CALL addUser('Jean Ramos', 'jean.ramos@hotmail.fr', '4 impasse des muguets 15541 Champoux', 'ramos69', 0, @id);
CALL addUser('Roger De La Chance', 'rogerdelachance@free.fr', '4bis rue du trefle 75421 Ferrache', 'chanceux77713', 0, @id);
CALL addUser('Hervé Boutade', 'rvbtd@free.fr', '452 Hameaux des oliviers 22511 Cabords', 'rvb93', 0, @id);
CALL addUser('Michelle Jonas', 'jojomiche@orange.fr', '3 rue du tapis rouge 45121 Cannes', 'mimiche', 0, @id);
CALL addUser('admin', 'admin@admin.fr', '36 avenue guy de collongue 69130 Ecully', 'admin', 1, @id);
