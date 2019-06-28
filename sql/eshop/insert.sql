--
-- Insert csv files into tables in database eshop.
-- By Lars Persson for course databas.
-- 2019-02-24
--
-- Drop table if it exist and create table
SET NAMES 'utf8';

------------------------------------- INSERT csv file INTO TABLE produktregister
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

DELETE FROM produktregister;

LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-produkt.csv'
INTO TABLE produktregister
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;
SELECT * FROM produktregister;

------------------------------------ INSERT csv file INTO TABLE produktkategori
DELETE FROM produktkategori;

LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-kategori.csv'
INTO TABLE produktkategori
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
    (kategori)
;
SELECT * FROM produktkategori;

--------------------------------------- INSERT csv file INTO TABLE kundregister
DELETE FROM kundregister;

LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-kund.csv'
INTO TABLE kundregister
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
;
SELECT * FROM kundregister;

----------------------------------- INSERT csv file INTO TABLE produkt2kategori
DELETE FROM produkt2kategori;
LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-produkt2kategori.csv'
INTO TABLE produkt2kategori
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
    (produktkod, kategori)
;

SELECT * FROM produkt2kategori
WHERE kategori='rock';

---------------------------------------------- INSERT csv file INTO TABLE lager
DELETE FROM lager;
LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-lager.csv'
INTO TABLE lager
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES
    (hylla)
;

SELECT * FROM lager;

-------------------------------------- INSERT csv file INTO TABLE produkt2lager
DELETE FROM produkt2lager;
LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-produkt2lager.csv'
INTO TABLE produkt2lager
CHARSET utf8
FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
LINES
    TERMINATED BY '\n'
IGNORE 1 LINES

;

-- SELECT * FROM produkt2lager;
-- DROP VIEW IF EXISTS v_show_products;
--
-- CREATE VIEW v_show_products
-- AS
-- SELECT
--     l.kod,
--     l.pris,
--     l.titel,
--     p.antal AS "antal",
--     k.kategori AS "kategori"
-- FROM produktregister AS l
--     JOIN produkt2lager AS p
--         ON l.kod = p.prod_kod
--     JOIN produkt2kategori AS k
--         ON l.kod = k.produktkod
-- -- GROUP BY kod
-- ;
-- -- Använd vyn
-- SELECT * FROM v_show_products;
--
-- SELECT kod, pris, titel, antal, GROUP_CONCAT(kategori) as kategori
-- FROM v_show_products
-- GROUP BY kod;
