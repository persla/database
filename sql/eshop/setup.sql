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
