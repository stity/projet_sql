
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

DELIMITER |

/* Créer les associations entre pays et zones géographiques */
DROP PROCEDURE IF EXISTS addLinkPaysZone|

CREATE PROCEDURE addLinkPaysZone (
    IN nom_zone VARCHAR(45),
    IN nom_pays VARCHAR(45))
    BEGIN
        DECLARE id_zone INT(11);
        DECLARE id_pays INT(11);
        START TRANSACTION;
        SET id_zone = (SELECT id FROM zone_geographique WHERE nom = nom_zone LIMIT 1);
        SET id_pays = (SELECT id FROM pays WHERE nom = nom_pays LIMIT 1);
        IF NOT EXISTS (SELECT * FROM zone_geographique_pays WHERE zone_geographique=id_zone AND pays=id_pays) THEN
        	INSERT INTO zone_geographique_pays(zone_geographique, pays) VALUES (id_zone, id_pays);
		END IF;
        COMMIT;
    END|

DELIMITER ;

/* Zone France */
CALL addLinkPaysZone('France','France');

/* Zone Europe */
CALL addLinkPaysZone("Europe/DOM/COM",'Mayote');
CALL addLinkPaysZone('Europe/DOM/COM','Réunion');
CALL addLinkPaysZone('Europe/DOM/COM','Allemagne');
CALL addLinkPaysZone('Europe/DOM/COM','Portugal');
CALL addLinkPaysZone('Europe/DOM/COM','Espagne');
CALL addLinkPaysZone('Europe/DOM/COM','Italie');
CALL addLinkPaysZone('Europe/DOM/COM','Grande Bretagne');

/* Zone Europe élargie */
CALL addLinkPaysZone('Europe élargie','Pologne');
CALL addLinkPaysZone('Europe élargie','Russie');
CALL addLinkPaysZone('Europe élargie','Estonie');
CALL addLinkPaysZone('Europe élargie','Norvège');
CALL addLinkPaysZone('Europe élargie','Finlande');
CALL addLinkPaysZone('Europe élargie','Ukraine');

/* Zone Maghreb */
CALL addLinkPaysZone('Maghreb','Tunisie');
CALL addLinkPaysZone('Maghreb','Maroc');
CALL addLinkPaysZone('Maghreb','Algérie');
CALL addLinkPaysZone('Maghreb','Egypte');

/* Zone Amérique du Nord */
CALL addLinkPaysZone('Amérique du Nord','USA');
CALL addLinkPaysZone('Amérique du Nord','Canada');
CALL addLinkPaysZone('Amérique du Nord','Mexique');
CALL addLinkPaysZone('Amérique du Nord','Cuba');

/* Zone Amérique du Sud */
CALL addLinkPaysZone('Amérique du Sud','Bolivie');
CALL addLinkPaysZone('Amérique du Sud','Equateur');
CALL addLinkPaysZone('Amérique du Sud','Pérou');
CALL addLinkPaysZone('Amérique du Sud','Argentine');
CALL addLinkPaysZone('Amérique du Sud','Brésil');

/* Zone Asie */
CALL addLinkPaysZone('Asie','Chine');
CALL addLinkPaysZone('Asie','Japon');
CALL addLinkPaysZone('Asie','Indonésie');
CALL addLinkPaysZone('Asie','Thaïlande');
CALL addLinkPaysZone('Asie','Corée du Sud');

/* Zone reste du monde */
CALL addLinkPaysZone('Reste du monde','Australie');
CALL addLinkPaysZone('Reste du monde','Afrique du Sud');
CALL addLinkPaysZone('Reste du monde','Rwanda');
CALL addLinkPaysZone('Reste du monde','Syrie');
CALL addLinkPaysZone('Reste du monde','Arabie Saoudite');

/* Réseau satellitaire */
CALL addLinkPaysZone('Réseaux satellitaires','Pôle Nord');
CALL addLinkPaysZone('Réseaux satellitaires','Terre Adélie');
CALL addLinkPaysZone('Réseaux satellitaires','Terres australes');
