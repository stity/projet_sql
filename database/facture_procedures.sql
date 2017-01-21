DELIMITER |

DROP PROCEDURE IF EXISTS generateFacture|

CREATE PROCEDURE generateFacture ()
    BEGIN
        START TRANSACTION;
            /* other sms and mms */
            BEGIN
            DECLARE done INT DEFAULT FALSE;
            DECLARE id_conso INT;
            DECLARE consocursor CURSOR FOR (SELECT idconsommation  FROM consommation WHERE idconsommation NOT IN (SELECT consommation FROM facture));
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

            OPEN consocursor;
            consoLoop : LOOP
                FETCH consocursor into id_conso;
                IF done THEN
                    LEAVE consoLoop;
                END IF;
                CALL getTotalPriceConso(id_conso, @cost);
                INSERT INTO facture (consommation, prix, paye) VALUES (id_conso,@cost,random(1,3)=1);
            END LOOP;

            CLOSE consocursor;
            END;


        COMMIT;
    END|

DELIMITER ;

CALL generateFacture();
