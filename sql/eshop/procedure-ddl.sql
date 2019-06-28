--
-- Create PROCEDURE, FUNCTIONS and TRIGGERS database eshop.
-- By Lars Persson for course databas.
-- 2019-03-11
--
-- Drop table if it exist and create table
-- SET NAMES 'utf8';
-- DROP TABLE IF EXISTS product_log;
-- CREATE TABLE product_log
-- (
--     `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
--     `Tidsstämpel` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     `Händelse` VARCHAR(100)
-- );
--------------------------------------------------- PROCEDURE product_create
DROP PROCEDURE IF EXISTS product_create;
DELIMITER ;;
CREATE PROCEDURE product_create(
    a_kod VARCHAR(10),
    a_pris INT,
    a_titel VARCHAR(30),
    a_bildlank VARCHAR(30),
    a_beskrivning VARCHAR(200),
    a_category VARCHAR(20),
    a_category1 VARCHAR(20),
    a_category2 VARCHAR(20)
)
BEGIN


    START TRANSACTION;
    INSERT INTO produktregister
    VALUES (a_kod, a_pris, a_titel, a_bildlank, a_beskrivning);

    INSERT INTO produkt2kategori (produktkod, kategori)
    VALUES
    (a_kod, a_category),
    (a_kod, a_category1),
    (a_kod, a_category2)
    ;

    DELETE FROM produkt2kategori
    WHERE produktkod = a_kod and kategori is NULL
    ;

COMMIT;
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
    COALESCE(sum(DISTINCT p.antal), 0) as "antal",
    IFNULL(GROUP_CONCAT(DISTINCT k.kategori), 'Mix av musikgenrer') as "kategori"
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

----------------------------------------------- PROCEDURE show_product_category
DROP PROCEDURE IF EXISTS show_product_category;
DELIMITER ;;
CREATE PROCEDURE show_product_category(
    a_category VARCHAR(20)
)
BEGIN

SELECT
    l.kod,
    l.pris,
    l.titel,
    COALESCE(sum(DISTINCT p.antal), 0) as "antal",
    IFNULL(GROUP_CONCAT(DISTINCT k.kategori), 'Mix av musikgenrer') as "kategori"
FROM produktregister AS l
    LEFT OUTER JOIN produkt2lager AS p
        ON l.kod = p.prod_kod
    LEFT OUTER JOIN produkt2kategori AS k
        ON l.kod = k.produktkod
    where k.kategori = a_category
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

----------------------------------------------------------PROCEDURE show_log_all
DROP PROCEDURE IF EXISTS show_log_all;
DELIMITER ;;
CREATE PROCEDURE show_log_all()
BEGIN
    SELECT * FROM product_log
    ORDER BY id DESC
    LIMIT 0, 20;
END
;;
DELIMITER ;
------------------------------------------------------ PROCEDURE show_log_search
DROP PROCEDURE IF EXISTS show_log_search;
DELIMITER ;;
CREATE PROCEDURE show_log_search(
    IN a_search VARCHAR(30)
)
BEGIN
    SELECT * FROM product_log
    WHERE Händelse LIKE a_search
    -- "%pro%"
    LIMIT 0, 20;
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
SELECT
    l.kod,
    l.pris,
    l.titel,
    l.bildlank,
    l.beskrivning,
    k.kategori as "kategorier",
    COALESCE(sum(DISTINCT p.antal), 0) as "antal",
    IFNULL(GROUP_CONCAT(k.kategori), 'Mix av musikgenrer') as "kategori"
FROM produktregister AS l
    LEFT OUTER JOIN produkt2lager AS p
        ON l.kod = p.prod_kod
    LEFT OUTER JOIN produkt2kategori AS k
        ON l.kod = k.produktkod
        where kod = a_kod
    GROUP BY kod;
    -- SELECT * FROM produktregister
    -- WHERE kod = a_kod;
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
    a_beskrivning VARCHAR(200),
    a_category VARCHAR(20),
    a_category1 VARCHAR(20),
    a_category2 VARCHAR(20)
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

    START TRANSACTION;
        IF a_category IS NULL AND a_category1 IS NULL AND a_category2 IS NULL THEN
           ROLLBACK;

       ELSE
       DELETE FROM produkt2kategori
       WHERE produktkod = a_kod;

       INSERT INTO produkt2kategori (produktkod, kategori)
       VALUES
       (a_kod, a_category),
       (a_kod, a_category1),
       (a_kod, a_category2)
       ;

       DELETE FROM produkt2kategori
       WHERE produktkod = a_kod and kategori is NULL
       ;

           COMMIT;
       END IF;
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

    START TRANSACTION;
    DELETE FROM produktregister
    WHERE
        `kod` = a_kod;

    DELETE FROM produkt2kategori
    WHERE
        `produktkod` = a_kod;

    DELETE FROM produkt2lager
    WHERE
        `prod_kod` = a_kod;
    COMMIT;
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

---------------------------------------------------------PROCEDURE show_customer
DROP PROCEDURE IF EXISTS show_customer;
DELIMITER ;;
CREATE PROCEDURE show_customer()
BEGIN
    SELECT
    kundnr,
    CONCAT(fornamn, ' ' , efternamn) as fornamn,
    CONCAT(adress, ' ' , postnummer, ' ' , ort ) as adress,
    telefon

    FROM kundregister;
END
;;
DELIMITER ;

---------------------------------------------------------PROCEDURE order_create
DROP PROCEDURE IF EXISTS order_create;
DELIMITER ;;
CREATE PROCEDURE order_create(
    a_kundnr VARCHAR(8)
)
BEGIN
    INSERT INTO orderregister(kund_nr) VALUES (a_kundnr);
    -- WHERE
    --     `kund_nr` = a_kundnr;
END
;;
DELIMITER ;

------------------------------------------------------ PROCEDURE show_all_orders
DROP PROCEDURE IF EXISTS show_all_orders;
DELIMITER ;;
CREATE PROCEDURE show_all_orders()

BEGIN
select
l.orderid,
-- l.status_code,
order_status(l.skapad, l.bestalld, l.skickad, l.uppdaterad, l.raderad) AS 'status',
l.kund_nr,
l.skapad,
COUNT(oor.antal) as "antal_rader"
from orderregister as l
LEFT JOIN orderrader as oor
ON  l.orderid = oor.order_id
GROUP BY oor.order_id
ORDER BY l.orderid desc;
END
;;
DELIMITER ;

--------------------------------------------------- PROCEDURE show_all_id_order
DROP PROCEDURE IF EXISTS show_all_id_order;
DELIMITER ;;
CREATE PROCEDURE show_all_id_order(
    a_orderid CHAR(10)
)
BEGIN

select
l.orderid as "order_id",
l.kund_nr as "kund_nr",
order_status(l.skapad, l.bestalld, l.skickad, l.uppdaterad, l.raderad) AS 'status',


-- p.kod as "prod_kod",
-- p.titel as "titel",
-- oor.antal as "antal"
IFNULL(p.kod, 'ingen beställning') as "prod_kod",
IFNULL(p.titel, 'ingen beställning') as "titel",
IFNULL(oor.antal, 'ingen beställning') as "antal"
FROM orderregister AS l
LEFT JOIN orderrader as oor
ON  l.orderid = oor.order_id
LEFT JOIN produktregister AS p
    ON  oor.prod_kod = p.kod
    WHERE orderid = a_orderid;
END
;;
DELIMITER ;

---------------------------------------------- PROCEDURE show_product_for_order

DROP PROCEDURE IF EXISTS show_product_for_order;
DELIMITER ;;
CREATE PROCEDURE show_product_for_order()
BEGIN
    SELECT kod, titel FROM produktregister;
END
;;
DELIMITER ;

-------------------------------------------------------- PROCEDURE insert_order
-- INSERT INTO orderrader (order_id, prod_kod, antal)
-- VALUES (79, 'lp1', 3);

DROP PROCEDURE IF EXISTS insert_order;
DELIMITER ;;
CREATE PROCEDURE insert_order(
    a_order_id INT,
    a_prod_kod CHAR(10),
    a_antal INT

)
BEGIN
    INSERT INTO orderrader VALUES (a_order_id, a_prod_kod, a_antal);

    START TRANSACTION;

    UPDATE orderregister
    SET uppdaterad = now()
        WHERE orderid = a_order_id;

    UPDATE orderregister
    SET bestalld = NULL
        WHERE orderid = a_order_id;

COMMIT;
END
;;
DELIMITER ;

------------------------------------------- PROCEDURE insert_update_time_orderd
DROP PROCEDURE IF EXISTS insert_update_time_orderd;
DELIMITER ;;
CREATE PROCEDURE insert_update_time_orderd(
    IN id INT
)
BEGIN
UPDATE orderregister
SET bestalld = now()
    WHERE orderid = id;
END
;;
DELIMITER ;

------------------------------------------- PROCEDURE insert_update_time_shiped
DROP PROCEDURE IF EXISTS insert_update_time_shiped;
DELIMITER ;;
CREATE PROCEDURE insert_update_time_shiped(
    IN id INT
)
BEGIN
UPDATE orderregister
SET skickad = now()
    WHERE orderid = id;
END
;;
DELIMITER ;
----------------------------------------------------------- PROCEDURE pick_list
DROP PROCEDURE IF EXISTS pick_list;
DELIMITER ;;
CREATE PROCEDURE pick_list(
    IN id INT
)
BEGIN
select
    oor.order_id as "Orderid",
    p.prod_kod as "Produktkod",
    GROUP_CONCAT(distinct p.hylla) as "Hylla",
    oor.antal as "Beställda",
	sum(p.antal) as "Lager",
IF(sum(p.antal)- oor.antal >= 0, "OK!", (CONCAT('OBS! Negativt lagersaldo '
    , ABS(sum(p.antal) - oor.antal), ' produkt/er saknas!'))) as "Lagersaldo"
FROM produkt2lager AS p
   right JOIN orderrader as oor
    ON p.prod_kod = oor.prod_kod
    WHERE
    oor.order_id = id
    group by p.prod_kod, oor.antal
    ;
    -- WHERE orderid = id;
END
;;
DELIMITER ;


--------------------------------------------------------  PROCEDURE search_order
DROP PROCEDURE IF EXISTS search_order;
DELIMITER ;;
CREATE PROCEDURE search_order(
    IN a_search VARCHAR(10)

)
BEGIN
select
l.orderid,
-- l.status_code, count
order_status(l.skapad, l.bestalld, l.skickad, l.uppdaterad, l.raderad) AS 'status',
l.kund_nr,
l.skapad,
COUNT(oor.antal) as "antal_rader"
from orderregister as l
LEFT JOIN orderrader as oor
ON  l.orderid = oor.order_id
GROUP BY oor.order_id
HAVING
    l.orderid LIKE a_search OR
    l.kund_nr LIKE a_search
ORDER BY l.orderid desc
;
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

-------------------------------------------------------- FUNCTION order_status
    DROP FUNCTION IF EXISTS order_status;
    DELIMITER ;;

    CREATE FUNCTION order_status(
        skapad TIMESTAMP,
        bestalld TIMESTAMP,
        skickad TIMESTAMP,
        uppdaterad TIMESTAMP,
        raderad TIMESTAMP

    )
    RETURNS CHAR(10)
    DETERMINISTIC
    BEGIN -- IF a_deleted IS NOT NULL THEN
    	IF raderad IS NOT NULL THEN
            RETURN 'Raderad';
        ELSEIF skickad IS NOT NULL THEN
            RETURN 'Skickad';
    	ELSEIF bestalld IS NOT NULL THEN
            RETURN 'Beställd';
        ELSEIF uppdaterad IS NOT NULL THEN
            RETURN 'Uppdaterad';
    	ELSEIF skapad IS NOT NULL THEN
            RETURN 'Skapad';
        END IF;
        RETURN 'F';
    END
    ;;
    DELIMITER ;


    -- SELECT
    --     skapad,
    --     order_status(skapad, bestalld, skickad, uppdaterad, raderad) AS 'status'
    -- FROM orderregister;


        -- ('trigger after delete account', OLD.id, OLD.balance)
    -- SELECT CONCAT(what, ' ', NEW.kod, ' ','(' ')') as atgard
    -- from product_log;
    -- ;
-- CALL move_money('1111', '2222', 1.5);
-- SELECT * FROM produktregister;
-- SELECT * FROM product_log;
-- SHOW TRIGGERS;
-- SHOW CREATE TRIGGER log_product_update \G;
-- DROP TABLE IF EXISTS `plocklista`;
-- DROP TABLE IF EXISTS `lager`;
-- DROP TABLE IF EXISTS `logg`;
-- DROP TABLE IF EXISTS `fak_till_prod`;
-- DROP TABLE IF EXISTS `ord_till_prod`;
-- DROP TABLE IF EXISTS `faktura`;
-- DROP TABLE IF EXISTS `orderregister`;
-- DROP TABLE IF EXISTS `kundregister`;
-- DROP TABLE IF EXISTS `produkt2lager`;
-- DROP TABLE IF EXISTS `produkt2kategori`;
-- DROP TABLE IF EXISTS `produktkategori`;
-- DROP TABLE IF EXISTS `produktregister`;
--
-- CREATE TABLE `produktkategori`
-- (
--     `kod` INT AUTO_INCREMENT,
--     `kategori` VARCHAR(20),
--
--     PRIMARY KEY (`kod`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `produktregister`
-- (
--     `kod` VARCHAR(10),
--     `pris` INT,
--     `titel` VARCHAR(30),
--     `bildlank` VARCHAR(30),
--     `beskrivning` VARCHAR(200),
--
--
--     PRIMARY KEY (`kod`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `produkt2kategori`
-- (
--     `rad` INT AUTO_INCREMENT,
--     `produktkod` VARCHAR(10),
--     `kategori` VARCHAR(20),
--
--     PRIMARY KEY (`rad`)
--     -- FOREIGN KEY (`prod_kod`) REFERENCES `produktregister` (`kod`),
--     -- FOREIGN KEY (`kategori`) REFERENCES `produktkategori` (`kategori`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `lager`
-- (
--     `hylla` CHAR(8),
--     PRIMARY KEY (`hylla`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `produkt2lager`
-- (
--     -- `id` INT AUTO_INCREMENT,
--     `prod_kod` VARCHAR(10),
--     `antal` INT,
--     `hylla` CHAR(8),
--
--
--     PRIMARY KEY (`prod_kod`)
--     -- FOREIGN KEY (`prod_kod`) REFERENCES `produktregister` (`kod`)
--
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `kundregister`
-- (
--     `kundnr` VARCHAR(8),
--     `fornamn` VARCHAR(50),
--     `efternamn` VARCHAR(50),
--     `adress` VARCHAR(50),
--     `postnummer` VARCHAR(50),
--     `ort` VARCHAR(50),
--     `land` VARCHAR(50),
--     `telefon` VARCHAR(10),
--
--     PRIMARY KEY (`kundnr`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;

-- CREATE TABLE `orderregister`
-- (
--     `referens` INT AUTO_INCREMENT,
--     `kund_nr` VARCHAR(8),
--     `skapad` DATETIME DEFAULT CURRENT_TIMESTAMP,
--     `andrad` DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
--     `makulerad` DATETIME DEFAULT NULL,
--     `levererad` DATETIME DEFAULT NULL,
--
--     PRIMARY KEY (`referens`),
-- 	FOREIGN KEY (`kund_nr`) REFERENCES `kundregister` (`kundnr`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `ord_till_prod`
-- (
--     `id` INT AUTO_INCREMENT,
--     `order_ref` INT,
--     `prod_id` VARCHAR(10),
--     `antal` INT,
--
--     PRIMARY KEY (`id`),
-- 	FOREIGN KEY (`order_ref`) REFERENCES `orderregister` (`referens`),
--     FOREIGN KEY (`prod_id`) REFERENCES `produktregister` (`kod`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `faktura`
-- (
--     `nr` INT AUTO_INCREMENT,
--     `order_ref` INT,
--     `kund_id` VARCHAR(8),
--     `fak_datum` DATETIME DEFAULT CURRENT_TIMESTAMP,
--     `bet_datum` DATETIME DEFAULT NULL,
--
--     PRIMARY KEY (`nr`),
-- 	FOREIGN KEY (`order_ref`) REFERENCES `orderregister` (`referens`),
--     FOREIGN KEY (`kund_id`) REFERENCES `kundregister` (`kundnr`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `fak_till_prod`
-- (
--     `id` INT AUTO_INCREMENT,
--     `fakt_nr` INT,
--     `prod_nr` VARCHAR(10),
--     `antal` INT,
--     `pris` INT,
--
--     PRIMARY KEY (`id`),
-- 	FOREIGN KEY (`fakt_nr`) REFERENCES `faktura` (`nr`),
--     FOREIGN KEY (`prod_nr`) REFERENCES `produktregister` (`kod`)
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- CREATE TABLE `logg`
-- (
--     `order_id` INT,
--     `order_skapad` DATETIME,
--     `order_andrad` DATETIME,
--     `order_makulerad` DATETIME,
--     `order_levererad` DATETIME
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;
--
-- INSERT INTO logg (order_id, order_skapad, order_andrad, order_makulerad, order_levererad)
-- SELECT referens, skapad, andrad, makulerad, levererad FROM orderregister;
--
-- CREATE TABLE `plocklista`
-- (
--     `id` INT AUTO_INCREMENT,
--     `order_id` INT,
--     `hylla_id` CHAR(8),
--     PRIMARY KEY (`id`),
--     FOREIGN KEY (`order_id`) REFERENCES `orderregister` (`referens`),
--     FOREIGN KEY (`hylla_id`) REFERENCES `lagerhylla` (`hylla`)
--
-- )ENGINE INNODB
-- CHARSET utf8
-- COLLATE utf8_swedish_ci;

-- select * from prod_till_kate;
-- select * from produktregister;
-- select * from produktkategori;
-- select * from lager;
-- select * from lagerhylla;
-- select * from orderregister;
-- select * from kundregister;
-- select * from ord_till_prod;
-- select * from faktura;
-- select * from fak_till_prod;
-- select * from logg;
-- select * from plocklista;

-- SET GLOBAL local_infile = 1;
-- SHOW VARIABLES LIKE 'local_infile';
-- DELETE FROM produktregister;
--
-- LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-produkt.csv'
-- INTO TABLE produktregister
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
-- ;
-- SELECT * FROM produktregister;
-- SHOW WARNINGS;
-- DELETE FROM produktkategori;
--
-- LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-kategori.csv'
-- INTO TABLE produktkategori
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
--     (kategori)
-- ;
-- SELECT * FROM produktkategori;
-- SHOW WARNINGS;
-- DELETE FROM kundregister;
--
-- LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-kund.csv'
-- INTO TABLE kundregister
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
-- ;
-- SELECT * FROM kundregister;
-- SHOW WARNINGS;
-- DELETE FROM produkt2kategori;
-- LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-produkt2kategori.csv'
-- INTO TABLE produkt2kategori
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
--     (produktkod, kategori)
-- ;
--
-- SELECT * FROM produkt2kategori
-- WHERE kategori='rock';
-- SHOW WARNINGS;
-- DELETE FROM lager;
-- LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-lager.csv'
-- INTO TABLE lager
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
--     (hylla)
-- ;
--
-- SELECT * FROM lager;
-- SHOW WARNINGS;
-- DELETE FROM produkt2lager;
-- LOAD DATA LOCAL INFILE 'Databasen-eshop-innehall-till-tabeller-produkt2lager.csv'
-- INTO TABLE produkt2lager
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
--
-- ;

-- SELECT * FROM produkt2lager;

-- CALL product_create("cd4", 32, "asdasdasda", "lksajk", "löasöldka");
-- SHOW WARNINGS;
-- SELECT * FROM produktregister;
-- SHOW CREATE PROCEDURE product_create
-- DELETE FROM kurstillfalle;
--
-- LOAD DATA LOCAL INFILE 'kurstillfalle.csv'
-- INTO TABLE kurstillfalle
-- CHARSET utf8
-- FIELDS
--     TERMINATED BY ','
--     ENCLOSED BY '"'
-- LINES
--     TERMINATED BY '\n'
-- IGNORE 1 LINES
--     (kurskod, kursansvarig, lasperiod)
-- ;
--
-- SELECT * FROM kurstillfalle;
