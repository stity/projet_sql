DELIMITER |

/* Création d'une zone géographique */
DROP PROCEDURE IF EXISTS addZoneGeographique|

CREATE PROCEDURE addZoneGeographique (
    IN nom_ VARCHAR(45),
    INOUT id INT)
    BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF NOT EXISTS (SELECT * FROM zone_geographique WHERE nom=nom_) THEN
        	INSERT INTO zone_geographique (nom) VALUES (nom_);
        	SET id = (SELECT id FROM zone_geographique WHERE nom=nom_ ORDER BY id DESC LIMIT 1);
		END IF;
        COMMIT;
    END|

DELIMITER ;

CALL addZoneGeographique('France', @id);
CALL addZoneGeographique('Europe/DOM/COM', @id);
CALL addZoneGeographique('Europe élargie', @id);
CALL addZoneGeographique('Maghreb', @id);
CALL addZoneGeographique('Amérique du Nord', @id);
CALL addZoneGeographique('Amérique du Sud', @id);
CALL addZoneGeographique('Asie', @id);
CALL addZoneGeographique('Reste du monde', @id);
CALL addZoneGeographique('Réseaux satellitaires', @id);

DELIMITER |

/* Création de pays dans les zones géographiques */
DROP PROCEDURE IF EXISTS addPays|

CREATE PROCEDURE addPays (
    IN nom_ VARCHAR(45),
    INOUT id INT)
    BEGIN
        DECLARE existsAlready BOOLEAN;
        START TRANSACTION;
        IF NOT EXISTS (SELECT * FROM pays WHERE nom=nom_) THEN
        	INSERT INTO pays (nom) VALUES (nom_);
        	SET id = (SELECT id FROM pays WHERE nom=nom_ ORDER BY id DESC LIMIT 1);
		END IF;
        COMMIT;
    END|

DELIMITER ;

/* Zone France */
CALL addPays('France', @id);

/* Zone Europe */
CALL addPays('Mayote', @id);
CALL addPays('Réunion', @id);
CALL addPays('Allemagne', @id);
CALL addPays('Portugal', @id);
CALL addPays('Espagne', @id);
CALL addPays('Italie', @id);
CALL addPays('Grande Bretagne', @id);

/* Zone Europe élargie */
CALL addPays('Pologne', @id);
CALL addPays('Russie', @id);
CALL addPays('Estonie', @id);
CALL addPays('Norvège', @id);
CALL addPays('Finlande', @id);
CALL addPays('Ukraine', @id);

/* Zone Maghreb */
CALL addPays('Tunisie', @id);
CALL addPays('Maroc', @id);
CALL addPays('Algérie', @id);
CALL addPays('Egypte', @id);

/* Zone Amérique du Nord */
CALL addPays('USA', @id);
CALL addPays('Canada', @id);
CALL addPays('Mexique', @id);
CALL addPays('Cuba', @id);

/* Zone Amérique du Sud */
CALL addPays('Bolivie', @id);
CALL addPays('Equateur', @id);
CALL addPays('Pérou', @id);
CALL addPays('Argentine', @id);
CALL addPays('Brésil', @id);

/* Zone Asie */
CALL addPays('Chine', @id);
CALL addPays('Japon', @id);
CALL addPays('Indonésie', @id);
CALL addPays('Thaïlande', @id);
CALL addPays('Corée du Sud', @id);

/* Zone reste du monde */
CALL addPays('Australie', @id);
CALL addPays('Afrique du Sud', @id);
CALL addPays('Rwanda', @id);
CALL addPays('Syrie', @id);
CALL addPays('Arabie Saoudite', @id);

/* Réseau satellitaire */
CALL addPays('Pôle Nord', @id);
CALL addPays('Terre Adélie', @id);
CALL addPays('Terres australes', @id);
