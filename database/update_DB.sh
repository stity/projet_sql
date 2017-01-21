cat  create_table.sql plage_horaire_procedures.sql phones_procedures.sql user_procedures.sql geographie_procedures.sql achat_procedures.sql consommation_procedures.sql  foreign_forfait_procedures.sql forfait_procedures.sql facture_procedures.sql > temp.sql
mysql --default-character-set=utf8 -h localhost -u root --password='' telephonie < temp.sql

