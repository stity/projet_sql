
/* Comprend les procédures pour les forfaits et les promotions */

DELIMITER |

/* Création d'un utilisateur */
DROP PROCEDURE IF EXISTS addFormule|

CREATE PROCEDURE addFormule (
    IN nom_ VARCHAR(45),
    IN prix_mensuel_ INT(11),
    IN limite_appel_ INT(11),
    IN limite_sms_ INT(11),
    IN limite_data_ INT(11),
    IN plage_horaire_ VARCHAR(45), /* On a le nom de la plage horaire */
    IN prix_hors_forfait_appel_ FLOAT,
    IN prix_hors_forfait_sms_ FLOAT,
    IN prix_hors_forfait_data_ FLOAT,
    IN bloque_ TINYINT(2),
    IN etranger_ VARCHAR(45), /* On a le nom du forfait */
    IN prix_base_ INT(11),
    IN id_telephone_ INT(11), /* On a directement l'id */
    IN formule_base_ INT(11),
    IN date_debut_ DATETIME,
    IN date_fin_ DATETIME)
    BEGIN

        DECLARE id_plage_horaire INT;
        DECLARE id_forfait_etranger INT;
        DECLARE id_telephone INT;
        DECLARE id_ INT;

        START TRANSACTION;

        SET id_plage_horaire = (SELECT id FROM plage_horaire WHERE nom = plage_horaire_ LIMIT 1);
        SET id_forfait_etranger = (SELECT id FROM forfait_etranger WHERE nom = etranger_ LIMIT 1);

        IF EXISTS (SELECT * FROM formule WHERE nom=nom_) THEN
            /* L'entrée existe déjà en BDD */
            SET id_ = (SELECT id FROM formule WHERE nom=nom_ ORDER BY id DESC LIMIT 1);
            /* On met à jour les champs qui peuvent l'être */
			UPDATE formule SET nom=nom_, prix_mensuel=prix_mensuel_, limite_appel=limite_appel_, limite_sms=limite_sms_, limite_data=limite_data_, bloque=bloque_, prix_hors_forfait_appel=prix_hors_forfait_appel_, prix_hors_forfait_sms=prix_hors_forfait_sms_, prix_hors_forfait_data=prix_hors_forfait_data_, prix_base=prix_base_, formule_base=formule_base_, date_debut=date_debut_, date_fin=date_fin_ WHERE id=id_;

            /* On ajoute la plage horaire si elle n'était pas associée */
            IF NOT EXISTS (SELECT * FROM formule_plage_horaire WHERE formule = id_ AND plage_horaire = id_plage_horaire) THEN
                INSERT INTO formule_plage_horaire (formule, plage_horaire) VALUES (id_, id_plage_horaire);
            END IF;
            /* On ajoute le téléphone s'il n'était pas associé */
            IF NOT EXISTS (SELECT * FROM formule_telephone WHERE formule = id_ AND telephone = id_telephone) THEN
                INSERT INTO formule_telephone (formule, telephone) VALUES (id_, id_telephone);
            END IF;
            /* On ajoute le forfait étranger s'il n'était pas associé */
            IF NOT EXISTS (SELECT * FROM formule_forfait_etranger WHERE formule = id_ AND forfait_etranger = id_forfait_etranger) THEN
                INSERT INTO formule_forfait_etranger (formule, forfait_etranger) VALUES (id_, id_forfait_etranger);
            END IF;

        ELSE

            /* On ajoute la nouvelle formule */
            INSERT INTO formule (nom, prix_mensuel, limite_appel, limite_sms, limite_data, bloque, prix_hors_forfait_appel, prix_hors_forfait_sms, prix_hors_forfait_data, prix_base, formule_base, date_debut, date_fin) VALUES (nom_, prix_mensuel_, limite_appel_, limite_sms_, limite_data_, bloque_, prix_hors_forfait_appel_, prix_hors_forfait_sms_, prix_hors_forfait_data_, prix_base_, formule_base_, date_debut_, date_fin_);

            SET id_ = (SELECT id FROM formule WHERE nom=nom_ LIMIT 1);

            /* On ajoute la plage horaire si elle n'était pas associée */
            IF NOT EXISTS (SELECT * FROM formule_plage_horaire WHERE formule = id_ AND plage_horaire = id_plage_horaire) THEN
                INSERT INTO formule_plage_horaire (formule, plage_horaire) VALUES (id_, id_plage_horaire);
            END IF;
            /* On ajoute le téléphone s'il n'était pas associé */
            IF NOT EXISTS (SELECT * FROM formule_telephone WHERE formule = id_ AND telephone = id_telephone) THEN
                INSERT INTO formule_telephone (formule, telephone) VALUES (id_, id_telephone);
            END IF;
            /* On ajoute le forfait étranger s'il n'était pas associé */
            IF NOT EXISTS (SELECT * FROM formule_forfait_etranger WHERE formule = id_ AND forfait_etranger = id_forfait_etranger) THEN
                INSERT INTO formule_forfait_etranger (formule, forfait_etranger) VALUES (id_, id_forfait_etranger);
            END IF;

		END IF;

        COMMIT;

    END|

DELIMITER ;

CALL addFormule('Formule Larnaque', 20, 2000, 10000, 2000, 'week_all', 0.2, 0.2, 0.2, 0, 'Europe et DOM-TOM', -1, -1, -1, NULL, NULL);
CALL addFormule('Formule Larnaque', 20, 2000, 10000, 2000, 'week_end_all', 0.2, 0.2, 0.2, 0, 'Europe et DOM-TOM', -1, -1, -1, NULL, NULL);
CALL addFormule('Formule Premium', 30, 4000, 20000, 4000, 'week_all', 0.1, 0.1, 0.1, 0, 'Europe et DOM-TOM', -1, -1, -1, NULL, NULL);
CALL addFormule('Formule Premium', 30, 4000, 20000, 4000, 'week_end_all', 0.1, 0.1, 0.1, 0, 'Europe et DOM-TOM', -1, -1, -1, NULL, NULL);
/* Pour créer une promotion, il "suffit" de remplir les champs à -1 et NULL dans les appels précédents */


DELIMITER |

/* Suppression d'un utilisateur */
DROP PROCEDURE IF EXISTS deleteFormule|

CREATE PROCEDURE deleteFormule (
    IN idformule INT)
    BEGIN
        START TRANSACTION;
        IF EXISTS (SELECT * FROM formule WHERE id=idformule) THEN
			/* get rid of user */
            UPDATE formule SET is_deleted = true WHERE id=idformule;
		ELSE
            /* throw error */
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No product found for this id';
		END IF;
        COMMIT;
    END|

DELIMITER ;

DELIMITER |

DROP PROCEDURE IF EXISTS getFormuleForfaitEtranger|

CREATE PROCEDURE getFormuleForfaitEtranger (
    IN idformule INT)
    BEGIN
        SELECT forfait_etranger FROM formule_forfait_etranger WHERE formule=idformule;
    END|


DROP PROCEDURE IF EXISTS addFormuleForfaitEtranger|

CREATE PROCEDURE addFormuleForfaitEtranger (
    IN idFormule INT,
    IN idZone INT)
    BEGIN
        INSERT INTO formule_forfait_etranger (formule, forfait_etranger) VALUES (idFormule, idZone);
    END|

DELIMITER ;
CALL addFormuleForfaitEtranger(1,2);
CALL addFormuleForfaitEtranger(1,3);
CALL addFormuleForfaitEtranger(1,4);
CALL addFormuleForfaitEtranger(1,5);
CALL addFormuleForfaitEtranger(1,6);
CALL addFormuleForfaitEtranger(1,7);
CALL addFormuleForfaitEtranger(1,8);
CALL addFormuleForfaitEtranger(2,2);
CALL addFormuleForfaitEtranger(2,3);
CALL addFormuleForfaitEtranger(2,4);
CALL addFormuleForfaitEtranger(2,5);
CALL addFormuleForfaitEtranger(2,6);
CALL addFormuleForfaitEtranger(2,7);
CALL addFormuleForfaitEtranger(2,8);
DELIMITER |

DROP PROCEDURE IF EXISTS getFormuleTelephone|

CREATE PROCEDURE getFormuleTelephone (
    IN idformule INT)
    BEGIN
        SELECT telephone FROM formule_telephone WHERE formule=idformule;
    END|

DROP PROCEDURE IF EXISTS addFormuleTelephone|

CREATE PROCEDURE addFormuleTelephone (
    IN idFormule INT,
    IN idPhone INT)
    BEGIN
        INSERT INTO formule_telephone (formule, telephone) VALUES (idFormule, idPhone);
    END|
