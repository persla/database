-- Skapa databas som heter eshop
CREATE DATABASE IF NOT EXISTS eshop;

-- Använd databasen eshop
USE eshop;
--
-- Visa vilka databaser som finns
-- som heter något i stil med *eshop*
SHOW DATABASES LIKE "%eshop%";

-- Skapa en användare user med lösenorder pass och ge tillgång oavsett
-- hostnamn.
CREATE USER IF NOT EXISTS 'user'@'%'
    IDENTIFIED BY 'pass'
;

-- Ge användaren alla rättigheter på databas eshop.
GRANT ALL PRIVILEGES
    ON eshop.*
    TO 'user'@'%'
;

-- Visa vad en användare kan göra mot vilken databas.
SHOW GRANTS FOR 'user'@'%';

--
-- Create scheme for tables in database eshop.
-- By Lars Persson for course databas.
-- 2019-02-28
--
-- Drop table if it exist and create table
SET NAMES 'utf8';


-- DROP TABLE IF EXISTS `plocklista`;
DROP TABLE IF EXISTS `lager`;
-- DROP TABLE IF EXISTS `logg`;
-- DROP TABLE IF EXISTS `fak_till_prod`;
-- DROP TABLE IF EXISTS `ord_till_prod`;
-- DROP TABLE IF EXISTS `faktura`;
-- DROP TABLE IF EXISTS `orderregister`;
DROP TABLE IF EXISTS `kundregister`;
DROP TABLE IF EXISTS `produkt2lager`;
DROP TABLE IF EXISTS `produkt2kategori`;
DROP TABLE IF EXISTS `produktkategori`;
DROP TABLE IF EXISTS `produktregister`;

-------------------------------------------------- CREATE TABLE produktkategori
CREATE TABLE `produktkategori`
(
    `kod` INT AUTO_INCREMENT,
    `kategori` VARCHAR(20),

    PRIMARY KEY (`kod`)
)ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci;

-------------------------------------------------- CREATE TABLE produktregister
CREATE TABLE `produktregister`
(
    `kod` VARCHAR(10),
    `pris` INT,
    `titel` VARCHAR(30),
    `bildlank` VARCHAR(30),
    `beskrivning` VARCHAR(200),


    PRIMARY KEY (`kod`)
)ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci;

-------------------------------------------------- CREATE TABLE produkt2kategori
CREATE TABLE `produkt2kategori`
(
    `rad` INT AUTO_INCREMENT,
    `produktkod` VARCHAR(10),
    `kategori` VARCHAR(20),

    PRIMARY KEY (`rad`)
    -- FOREIGN KEY (`prod_kod`) REFERENCES `produktregister` (`kod`),
    -- FOREIGN KEY (`kategori`) REFERENCES `produktkategori` (`kategori`)
)ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci;

------------------------------------------------------------ CREATE TABLE lager
CREATE TABLE `lager`
(
    `hylla` CHAR(8),
    PRIMARY KEY (`hylla`)
)ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci;

----------------------------------------------------- CREATE TABLE produkt2lager
CREATE TABLE `produkt2lager`
(
    -- `id` INT AUTO_INCREMENT,
    `prod_kod` VARCHAR(10),
    `antal` INT,
    `hylla` CHAR(8),


    PRIMARY KEY (`prod_kod`)
    -- FOREIGN KEY (`prod_kod`) REFERENCES `produktregister` (`kod`)

)ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci;

----------------------------------------------------- CREATE TABLE kundregister
CREATE TABLE `kundregister`
(
    `kundnr` VARCHAR(8),
    `fornamn` VARCHAR(50),
    `efternamn` VARCHAR(50),
    `adress` VARCHAR(50),
    `postnummer` VARCHAR(50),
    `ort` VARCHAR(50),
    `land` VARCHAR(50),
    `telefon` VARCHAR(10),

    PRIMARY KEY (`kundnr`)
)ENGINE INNODB
CHARSET utf8
COLLATE utf8_swedish_ci;
SHOW WARNINGS;
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
SHOW WARNINGS;

--
-- Create PROCEDURE and TRIGGERS database eshop.
-- By Lars Persson for course databas.
-- 2019-02-28
--
-- Drop table if it exist and create table
SET NAMES 'utf8';
DROP TABLE IF EXISTS product_log;
CREATE TABLE product_log
(
    `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `Tidsstämpel` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `Händelse` VARCHAR(100)
);
--------------------------------------------------- PROCEDURE product_create
DROP PROCEDURE IF EXISTS product_create;
DELIMITER ;;
CREATE PROCEDURE product_create(
    a_kod VARCHAR(10),
    a_pris INT,
    a_titel VARCHAR(30),
    a_bildlank VARCHAR(30),
    a_beskrivning VARCHAR(200)
)
BEGIN
    INSERT INTO produktregister VALUES (a_kod, a_pris, a_titel, a_bildlank, a_beskrivning);
END
;;
DELIMITER ;
-------------------------------------------------------------- PROCEDURE invadd
DROP PROCEDURE IF EXISTS invadd;
DELIMITER ;;
CREATE PROCEDURE invadd(
    a_prod_kod VARCHAR(10),
    a_antal INT,
    a_hylla CHAR(8)

)
BEGIN
    INSERT INTO produkt2lager VALUES (a_prod_kod, a_antal, a_hylla);
END
;;
DELIMITER ;

SHOW WARNINGS;
------------------------------------------------------- PROCEDURE show_category
DROP PROCEDURE IF EXISTS show_category;
DELIMITER ;;
CREATE PROCEDURE show_category()
BEGIN
    SELECT * FROM produktkategori;
END
;;
DELIMITER ;
SHOW WARNINGS;
CALL show_category();
-------------------------------------------------------- PROCEDURE show_product
DROP PROCEDURE IF EXISTS show_product;
DELIMITER ;;
CREATE PROCEDURE show_product()
BEGIN

SELECT
    l.kod,
    l.pris,
    l.titel,
    IFNULL(p.antal, 'Ta kontakt') as "antal",
    IFNULL(GROUP_CONCAT(k.kategori), 'Mix av musikgenrer') as "kategori"
FROM produktregister AS l
    LEFT OUTER JOIN produkt2lager AS p
        ON l.kod = p.prod_kod
    LEFT OUTER JOIN produkt2kategori AS k
        ON l.kod = k.produktkod
    GROUP BY kod
;

END
;;
DELIMITER ;
CALL show_product();
------------------------------------------------------ PROCEDURE show_inventory
DROP PROCEDURE IF EXISTS show_inventory;
DELIMITER ;;
CREATE PROCEDURE show_inventory()
BEGIN

SELECT
    p.prod_kod,
    l.titel,
    p.antal,
    p.hylla

FROM produktregister AS l
    RIGHT OUTER JOIN produkt2lager AS p
        ON l.kod = p.prod_kod
;

END
;;
DELIMITER ;
--------------------------------------------------- PROCEDURE search_inventory
DROP PROCEDURE IF EXISTS search_inventory;
DELIMITER ;;
CREATE PROCEDURE search_inventory(
    IN a_search VARCHAR(30)

)
BEGIN
SELECT
    p.prod_kod,
    l.titel,
    p.antal,
    p.hylla

FROM produktregister AS l
    RIGHT OUTER JOIN produkt2lager AS p
        ON l.kod = p.prod_kod
WHERE
    p.prod_kod LIKE a_search OR
    l.titel LIKE a_search OR
    p.hylla LIKE a_search
;
END
;;
DELIMITER ;

------------------------------------------------------------ PROCEDURE show_all
DROP PROCEDURE IF EXISTS show_all;
DELIMITER ;;
CREATE PROCEDURE show_all()
BEGIN
    SELECT * FROM produktregister;
END
;;
DELIMITER ;

----------------------------------------------------------- PROCEDURE show_shelf
DROP PROCEDURE IF EXISTS show_shelf;
    DELIMITER ;;
    CREATE PROCEDURE show_shelf()
    BEGIN
        SELECT * FROM lager;
    END
    ;;
DELIMITER ;
------------------------------------------------------------ PROCEDURE show_log
DROP PROCEDURE IF EXISTS show_log;
DELIMITER ;;
CREATE PROCEDURE show_log(
    IN num INT
    )
BEGIN
    SELECT * FROM product_log LIMIT num;
END
;;
DELIMITER ;

-------------------------------------------------------- PROCEDURE show_all_id
DROP PROCEDURE IF EXISTS show_all_id;
DELIMITER ;;
CREATE PROCEDURE show_all_id(
    a_kod CHAR(10)
)
BEGIN
    SELECT * FROM produktregister
    WHERE kod = a_kod;
END
;;
DELIMITER ;
CALL show_all_id("lp1");

--------------------------------------------------------- PROCEDURE edit_product
DROP PROCEDURE IF EXISTS edit_product;
DELIMITER ;;
CREATE PROCEDURE edit_product(
    a_kod VARCHAR(10),
    a_pris INT,
    a_titel VARCHAR(30),
    a_bildlank VARCHAR(30),
    a_beskrivning VARCHAR(200)
)
BEGIN
    UPDATE produktregister SET
        `kod` = a_kod,
        `pris` = a_pris,
        `titel` = a_titel,
        `bildlank` = a_bildlank,
        `beskrivning` = a_beskrivning
    WHERE
        `kod` = a_kod;
END
;;
DELIMITER ;

----------------------------------------------------- PROCEDURE delete_product
DROP PROCEDURE IF EXISTS delete_product;
DELIMITER ;;
CREATE PROCEDURE delete_product(
    a_kod VARCHAR(10)
)
BEGIN
    DELETE FROM produktregister
    WHERE
        `kod` = a_kod;
END
;;
DELIMITER ;
CALL show_all();

------------------------------------------------------ PROCEDURE reduce_product
DROP PROCEDURE IF EXISTS reduce_product;
DELIMITER ;;
CREATE PROCEDURE reduce_product(
    a_kod VARCHAR(10),
    a_antal int,
    a_hylla CHAR(8)
)
BEGIN
    UPDATE produkt2lager
    SET antal = antal - a_antal
    WHERE
        `prod_kod` = a_kod AND `hylla`  = a_hylla;
END
;;
DELIMITER ;

--------------------------------------------------- TRIGGER log_product_update
DROP TRIGGER IF EXISTS log_product_update;

CREATE TRIGGER log_product_update
AFTER UPDATE
ON produktregister FOR EACH ROW
    INSERT INTO product_log
        (`Händelse`)
    VALUES
        (CONCAT('Detaljer om produktid', ' ' , NEW.kod, ' ', 'uppdaterades.'))
    ;

----------------------------------------------------- TRIGGER log_remove_product
DROP TRIGGER IF EXISTS log_remove_product;

CREATE TRIGGER log_remove_product
AFTER DELETE
    ON produktregister FOR EACH ROW
    INSERT INTO product_log
        (`Händelse`)
    VALUES
        (CONCAT('Produkt med produktid', ' ' , OLD.kod, ' ', 'raderades.'))
    ;
SHOW WARNINGS;
-------------------------------------------------------- TRIGGER insert_product
DROP TRIGGER IF EXISTS insert_product;

CREATE TRIGGER insert_product
AFTER INSERT
    ON produktregister FOR EACH ROW
    INSERT INTO product_log
        (`Händelse`)
    VALUES
        (CONCAT('Ny produkt lades till med produktid', ' ' , NEW.kod, '.'))
    ;
