/* =========================================================
   1. CREATE DATABASE
   ========================================================= */

CREATE DATABASE IF NOT EXISTS BANK1;

USE BANK1;


/* =========================================================
   2. ENABLE LOCAL CSV IMPORT
   ========================================================= */

SET GLOBAL local_infile = 1;

SET SESSION sql_mode = '';



/* =========================================================
   3. CREATE DISTRICT TABLE
   ========================================================= */

CREATE TABLE DISTRICT (

    District_Code INT PRIMARY KEY,
    
    District_Name VARCHAR(100),
    
    Region VARCHAR(100),
    
    No_of_inhabitants INT,
    
    No_of_municipalities_with_inhabitants_less_499 INT,
    
    No_of_municipalities_with_inhabitants_500_btw_1999 INT,
    
    No_of_municipalities_with_inhabitants_2000_btw_9999 INT,
    
    No_of_municipalities_with_inhabitants_less_10000 INT,
    
    No_of_cities INT,
    
    Ratio_of_urban_inhabitants FLOAT,
    
    Average_salary INT,
    
    No_of_entrepreneurs_per_1000_inhabitants INT,
    
    No_committed_crime_2017 INT,
    
    No_committed_crime_2018 INT

);



/* =========================================================
   4. CREATE ACCOUNT TABLE
   ========================================================= */

CREATE TABLE ACCOUNT (

    account_id INT PRIMARY KEY,
    
    district_id INT,
    
    frequency VARCHAR(40),
    
    `Date` DATE,
    
    Account_type VARCHAR(40),
    
    Card_Assigned VARCHAR(40),
    
    FOREIGN KEY (district_id)
    REFERENCES DISTRICT(District_Code)

);



/* =========================================================
   5. CREATE CLIENT TABLE
   ========================================================= */

CREATE TABLE CLIENT (

    client_id INT PRIMARY KEY,
    
    Sex CHAR(10),
    
    Birth_date DATE,
    
    district_id INT,
    
    FOREIGN KEY (district_id)
    REFERENCES DISTRICT(District_Code)

);



/* =========================================================
   6. CREATE DISPOSITION TABLE
   ========================================================= */

CREATE TABLE DISPOSITION (

    disp_id INT PRIMARY KEY,
    
    client_id INT,
    
    account_id INT,
    
    `type` CHAR(15),
    
    FOREIGN KEY (account_id)
    REFERENCES ACCOUNT(account_id),
    
    FOREIGN KEY (client_id)
    REFERENCES CLIENT(client_id)

);



/* =========================================================
   7. CREATE CARD TABLE
   ========================================================= */

CREATE TABLE CARD (

    card_id INT PRIMARY KEY,
    
    disp_id INT,
    
    `type` CHAR(10),
    
    issued DATE,
    
    FOREIGN KEY (disp_id)
    REFERENCES DISPOSITION(disp_id)

);



/* =========================================================
   8. CREATE LOAN TABLE
   ========================================================= */

CREATE TABLE LOAN (

    loan_id INT,
    
    account_id INT,
    
    `Date` DATE,
    
    amount INT,
    
    duration INT,
    
    payments INT,
    
    `status` VARCHAR(35),
    
    FOREIGN KEY (account_id)
    REFERENCES ACCOUNT(account_id)

);



/* =========================================================
   9. CREATE ORDER TABLE
   ========================================================= */

CREATE TABLE `ORDER` (

    order_id INT PRIMARY KEY,
    
    account_id INT,
    
    bank_to VARCHAR(45),
    
    account_to INT,
    
    amount FLOAT,
    
    FOREIGN KEY (account_id)
    REFERENCES ACCOUNT(account_id)

);



/* =========================================================
   10. CREATE TRANSACTIONS TABLE
   ========================================================= */

CREATE TABLE TRANSACTIONS (

    trans_id INT,
    
    account_id INT,
    
    `Date` DATE,
    
    `Type` VARCHAR(30),
    
    operation VARCHAR(40),
    
    amount INT,
    
    balance FLOAT,
    
    Purpose VARCHAR(40),
    
    bank VARCHAR(45),
    
    `account` INT,
    
    FOREIGN KEY (account_id)
    REFERENCES ACCOUNT(account_id)

);



/* =========================================================
   11. LOAD DISTRICT
   FIRST BECAUSE ACCOUNT AND CLIENT DEPEND ON IT
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/district.csv"

INTO TABLE DISTRICT

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   12. LOAD ACCOUNT
   ACCOUNT DEPENDS ON DISTRICT
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/account_new.csv"

INTO TABLE ACCOUNT

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   13. LOAD CLIENT
   CLIENT DEPENDS ON DISTRICT
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/client.csv"

INTO TABLE CLIENT

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   14. LOAD DISPOSITION
   DEPENDS ON ACCOUNT AND CLIENT
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/disposition.csv"

INTO TABLE DISPOSITION

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   15. LOAD CARD
   DEPENDS ON DISPOSITION
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/card.csv"

INTO TABLE CARD

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   16. LOAD LOAN
   DEPENDS ON ACCOUNT
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/loan.csv"

INTO TABLE LOAN

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   17. LOAD ORDER
   DEPENDS ON ACCOUNT
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/order.csv"

INTO TABLE `ORDER`

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   18. LOAD TRANSACTION FILE 1
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/tranx.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   19. LOAD TRANSACTION FILE 2
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/trnx_16.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   20. LOAD TRANSACTION FILE 3
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/trnx_17.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   21. LOAD TRANSACTION FILE 4
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/trnx_18.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   22. LOAD TRANSACTION FILE 5
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/trnx_19_NEW.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   23. LOAD TRANSACTION FILE 6
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/trnx_20_NEW.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



/* =========================================================
   24. LOAD TRANSACTION FILE 7
   ========================================================= */

LOAD DATA LOCAL INFILE
"C:/Users/Lenovo/Desktop/Overall project/clean_data/trnx_21_NEW.csv"

INTO TABLE TRANSACTIONS

FIELDS TERMINATED BY ','
ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS;



select * from account;
select * from card;
select * from client;
select * from disposition;
select * from district;
select * from loan;
select * from `ORDER`;
select * from transactions;


-- Data validation and data understanding

SELECT 'DISTRICT' AS Table_Name, COUNT(*) AS Total_Rows FROM DISTRICT
UNION ALL
SELECT 'ACCOUNT', COUNT(*) FROM ACCOUNT
UNION ALL
SELECT 'CLIENT', COUNT(*) FROM CLIENT
UNION ALL
SELECT 'DISPOSITION', COUNT(*) FROM DISPOSITION
UNION ALL
SELECT 'CARD', COUNT(*) FROM CARD
UNION ALL
SELECT 'LOAN', COUNT(*) FROM LOAN
UNION ALL
SELECT 'ORDER', COUNT(*) FROM `ORDER`
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM TRANSACTIONS;

SELECT COUNT(*) AS ZERO_DATE_RECORDS
FROM TRANSACTIONS
WHERE `Date` = '0000-00-00';
    
select * from transactions;

SELECT COUNT(*) AS TOTAL_TRANSACTION_ROWS
FROM TRANSACTIONS;

show create table transactions;

SELECT COUNT(*) AS total_rows,
       SUM(`Date` = '0000-00-00') AS zero_date_rows
FROM transactions;

SELECT `Date`, COUNT(*) AS cnt
FROM transactions
GROUP BY `Date`
ORDER BY `Date`;

SELECT 
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    COUNT(*) AS total_rows
FROM transactions;

SELECT *
FROM transactions
WHERE `Date` = '2021-12-19'
LIMIT 5;

SELECT 
    Type,
    operation,
    COUNT(*) AS row_count
FROM transactions
WHERE YEAR(`Date`) = 0
GROUP BY Type, operation
ORDER BY row_count DESC;

SHOW COLUMNS FROM transactions;

select * from transactions;

CREATE TABLE staging_transactions (
    trans_id INT,
    account_id INT,
    Date_text VARCHAR(30),
    Type VARCHAR(30),
    operation VARCHAR(40),
    amount INT,
    balance FLOAT,
    Purpose VARCHAR(40),
    bank VARCHAR(45),
    account INT
);
LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/tranx.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

select * from staging_transactions;

SELECT Date_text
FROM staging_transactions
LIMIT 10;

use bank1;

SELECT
    Date_text,
    COUNT(*) AS cnt
FROM staging_transactions
GROUP BY Date_text
ORDER BY cnt DESC
LIMIT 20;

SELECT
    COUNT(*) AS total_rows,
    SUM(Date_text IS NULL OR Date_text = '') AS blank_dates,
    MIN(Date_text) AS min_date,
    MAX(Date_text) AS max_date
FROM staging_transactions;

CREATE TABLE transactions_clean AS
SELECT
    trans_id,
    account_id,
    STR_TO_DATE(Date_text, '%Y-%m-%d') AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions;

SELECT
    COUNT(*) AS total_rows,
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    SUM(`Date` = '0000-00-00') AS zero_dates
FROM transactions_clean;

SELECT
    COUNT(*) AS total_rows,
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    SUM(`Date` IS NULL) AS null_dates
FROM transactions_clean;

CREATE TABLE transactions_backup AS
SELECT *
FROM transactions;
SHOW COLUMNS FROM transactions_clean;

RENAME TABLE transactions TO transactions_old;

RENAME TABLE transactions_clean TO transactions;

select * from transactions;

SELECT
    COUNT(*) AS total_rows,
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    SUM(`Date` IS NULL) AS null_dates
FROM transactions;

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_16.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_17.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_18.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_19_NEW.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_20_NEW.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_21_NEW.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);

SELECT COUNT(*) AS total_rows
FROM staging_transactions;

SELECT
    COUNT(*) AS total_rows,
    SUM(Date_text IS NULL OR Date_text = '') AS blank_dates,
    MIN(Date_text) AS min_date,
    MAX(Date_text) AS max_date
FROM staging_transactions;

select * from transactions;


-- =====================================================
-- TRANSACTIONS TABLE - FINAL DATA LOADING & CLEANING
-- =====================================================


-- 1. Create staging table
-- Date initially stored as VARCHAR to avoid date format issues

CREATE TABLE staging_transactions (
    trans_id INT,
    account_id INT,
    Date_text VARCHAR(30),
    Type VARCHAR(30),
    operation VARCHAR(40),
    amount INT,
    balance FLOAT,
    Purpose VARCHAR(40),
    bank VARCHAR(45),
    account INT
);


-- =====================================================
-- 2. Load all 7 CSV files into staging table
-- =====================================================

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/tranx.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);


LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_16.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);



LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_17.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);


LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_18.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);


LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_19_NEW.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);


LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_20_NEW.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);


LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/Desktop/Overall project/clean_data 111/trnx_21_NEW.csv'
INTO TABLE staging_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(trans_id, account_id, Date_text, Type, operation, amount, balance, Purpose, bank, account);


-- =====================================================
-- 3. Verify staging data
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(Date_text IS NULL OR Date_text = '') AS blank_dates,
    MIN(Date_text) AS min_date,
    MAX(Date_text) AS max_date
FROM staging_transactions;


-- =====================================================
-- 4. Create clean transactions table
-- Convert VARCHAR Date to proper DATE format
-- =====================================================



CREATE TABLE transactions_clean AS
SELECT
    trans_id,
    account_id,
    STR_TO_DATE(Date_text, '%Y-%m-%d') AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions;



CREATE TABLE transactions_clean (
    trans_id INT,
    account_id INT,
    `Date` DATE,
    Type VARCHAR(30),
    operation VARCHAR(40),
    amount INT,
    balance FLOAT,
    Purpose VARCHAR(40),
    bank VARCHAR(45),
    account INT
);

INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    STR_TO_DATE(Date_text, '%Y-%m-%d'),
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id <= 300000;

INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id <= 300000;


INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 300000
  AND trans_id <= 600000;
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 600000
  AND trans_id <= 900000;
  
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 900000
  AND trans_id <= 1200000;


INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 1200000
  AND trans_id <= 1500000;
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 1500000
  AND trans_id <= 1800000;
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text LIKE '____-__-____'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text LIKE '__-__-____'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 1800000;

SELECT
    COUNT(*) AS total_rows,
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    SUM(`Date` IS NULL) AS null_dates
FROM transactions_clean;

SELECT
    Date_text,
    COUNT(*) AS row_count
FROM staging_transactions
GROUP BY Date_text
ORDER BY row_count DESC
LIMIT 20;

TRUNCATE TABLE transactions_clean;

SELECT
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN 'YYYY-MM-DD'
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN 'DD-MM-YYYY'
        ELSE 'OTHER'
    END AS date_format,
    COUNT(*) AS row_count
FROM staging_transactions
GROUP BY date_format;

INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id <= 300000;

INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 300000
  AND trans_id <= 600000;
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 600000
  AND trans_id <= 900000;
  
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 900000
  AND trans_id <= 1200000;
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 1200000
  AND trans_id <= 1500000;
  
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 1500000
  AND trans_id <= 1800000;
  
  INSERT INTO transactions_clean
SELECT
    trans_id,
    account_id,
    CASE
        WHEN Date_text REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(Date_text, '%Y-%m-%d')
        WHEN Date_text REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(Date_text, '%d-%m-%Y')
    END AS `Date`,
    Type,
    operation,
    amount,
    balance,
    Purpose,
    bank,
    account
FROM staging_transactions
WHERE trans_id > 1800000;

SELECT
    COUNT(*) AS total_rows,
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    SUM(`Date` IS NULL) AS null_dates
FROM transactions_clean;

SELECT
    COUNT(*) AS total_rows,
    SUM(DATE_FORMAT(`Date`, '%Y-%m-%d') = DATE_FORMAT(`Date`, '%Y-%m-%d')) AS yyyy_mm_dd_format,
    SUM(`Date` IS NULL) AS null_dates
FROM transactions_clean;

SELECT COUNT(*) AS total_rows
FROM transactions_old;

SHOW TABLES LIKE 'transactions%';

RENAME TABLE transactions_clean TO transactions;


-- Data Cleaning 

 SELECT
    YEAR(`Date`) AS transaction_year,
    COUNT(*) AS total_transactions,
    SUM(bank IS NULL OR TRIM(bank) = '') AS blank_bank
FROM transactions
GROUP BY YEAR(`Date`)
ORDER BY transaction_year;

desc transactions;

SELECT
    YEAR(`Date`) AS transaction_year,
    Type,
    operation,
    COUNT(*) AS blank_bank_rows
FROM transactions
WHERE (bank IS NULL OR TRIM(bank) = '')
  AND YEAR(`Date`) IN (2018, 2019, 2021)
GROUP BY YEAR(`Date`), Type, operation
ORDER BY transaction_year, Type, operation;




select count(*) as purpose_blank from transactions
where purpose is null or trim(purpose)='';

SELECT
    SUM(Purpose IS NULL) AS null_count,
    SUM(TRIM(Purpose) = '') AS blank_count
FROM transactions;
-- purpose_blank=1064156

SELECT
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    COUNT(*) AS total_rows
FROM transactions;

update transactions 
set `date`=case
when year(`date`)=2016 then date_add(`date`,interval 6 Year)
when year(`date`)=2017 then date_add(`date`,interval 4 Year)
when year(`date`)=2018 then date_add(`date`,interval 2 Year)
when year(`date`)=2019 then `date`
when year(`date`)=2020 then date_sub(`date`,interval 2 Year)
when year(`date`)=2021 then date_sub(`date`,interval 4 Year)
end
where trans_id is not null;

select year(`date`) as transaction_year,count(*) as total_number
from transactions 
group by year(`date`)
order by transaction_year ;

-- 2.  2022 → Sky Bank
-- 2021 → DBS Bank
-- 2019 → Northern Bank
-- 2018 → Southern Bank

update transactions
set bank = "Sky Bank"
where year(`date`)=2022 and (bank is null or trim(bank)='');

update transactions
set bank = "DBS Bank"
where year(`date`)=2021 and (bank is null or trim(bank)='');

update transactions
set bank = "Northern Bank"
where year(`date`)=2019 and (bank is null or trim(bank)='');

update transactions
set bank = "Southern Bank"
where year(`date`)=2018 and (bank is null or trim(bank)='');

select year(`date`),bank,count(*) from transactions
group by year(`date`),bank
order by count(*);


-- Account data validation and cleaning
 

SELECT 
    MIN(`Date`) AS min_date,
    MAX(`Date`) AS max_date,
    COUNT(*) AS total_rows
FROM ACCOUNT;


-- in excel add 23 year and now add 1 year total 24 year 

UPDATE ACCOUNT
SET `Date` = DATE_ADD(`Date`, INTERVAL 1 YEAR)
WHERE account_id IS NOT NULL;

-- frequency column in accounts table 

SELECT 
    frequency,
    COUNT(*) AS row_count
FROM ACCOUNT
GROUP BY frequency
ORDER BY frequency;

UPDATE ACCOUNT
SET frequency = 'ISSUANCE AFTER A TRANSACTION'
WHERE frequency = 'ISSUANCE AFTER TRANSACTION';


-- Step: Bank-wise Frequency Analysis

-- Purpose: To analyze existing Bank frequencies for 2017 and 2020 and determine a data-driven basis
--  for filling missing Bank values without modifying existing Bank records.

-- select year(`date`) as transaction_year,bank,count(*)as transaction_count
-- from transactions
-- where bank is not null and bank <> "" and year(`date`) in (2017,2020)
-- group by year(`date`),bank
-- order by transaction_year,transaction_count;


-- Missing Bank Value Identification(*****************************************)

-- Reason

-- To identify missing Bank records with temporary year-based labels while preserving data integrity.
--  These labels can be replaced later if the actual Bank information becomes available.



update transactions
set bank =case
when year(`date`)=2017 then "unknown bank 2017"
when year(`date`)=2020 then "unknown bank 2020"
end 
where (bank is null or bank ="") and year(`date`)in (2017,2020);


-- if 2017 and 2020 bank name is know then run this query 

-- update transactions
-- set bank="actual bank name"
-- where bank= "unknown bank 2017";

-- validation

select year(`date`) as transaction_year,bank,count(*) as transaction_count
from transactions
where year(`date`)in(2017,2020)
group by year(`date`),bank
order by transaction_year,transaction_count;


-- To handle unavailable Bank information by assigning temporary year-based labels while preserving existing Bank values. 
-- These labels can be replaced later if the actual Bank information becomes available.

SELECT COUNT(*) AS remaining_missing_bank
FROM transactions
WHERE bank IS NULL OR bank = '';

-- purpose column

select purpose ,count(*) as transaction_count
from transactions
group by purpose
order by transaction_count desc;

-- Missing Transaction Purpose Handling 

select count(*) from transactions
where purpose is null or purpose="";

update transactions
set purpose="unknown purpose"
where purpose is null or purpose="";


-- bank cleaning

-- 1️⃣ Current bank values verify
--         ↓
-- 2️⃣ bank = NULL करणे
--         ↓
-- 3️⃣ Verify all bank values are NULL
--         ↓
-- 4️⃣ Duplicate trans_id पुन्हा analyze करणे
--         ↓
-- 5️⃣ Duplicate rows compare करणे
--         ↓
-- 6️⃣ Exact duplicates remove/handle करणे
--         ↓
-- 7️⃣ Clean transaction table validate करणे
--         ↓
-- 8️⃣ Correct logic ने 6 Banks assign करणे
--         ↓
-- 9️⃣ Bank = exactly 6 values validate
--         ↓
-- 🔟 Final transaction validation

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

select bank,count(*)as transaction_count,SUM(bank IS NULL) AS null_bank_rows
from transactions
group by bank
order by transaction_count desc;

update transactions
set bank=null ;

-- check duplicate trans_id

select count(distinct trans_id)as unique_trans_id from transactions;

SELECT
    COUNT(*) AS duplicate_trans_ids,
    SUM(
        CASE
            WHEN account_count = 1
             AND date_count = 1
             AND type_count = 1
             AND operation_count = 1
             AND amount_count = 1
             AND balance_count = 1
             AND purpose_count = 1
            THEN 1
            ELSE 0
        END
    ) AS same_data,
    SUM(
        CASE
            WHEN account_count > 1
              OR date_count > 1
              OR type_count > 1
              OR operation_count > 1
              OR amount_count > 1
              OR balance_count > 1
              OR purpose_count > 1
            THEN 1
            ELSE 0
        END
    ) AS different_data
FROM (
    SELECT
        trans_id,
        COUNT(*) AS total_rows,
        COUNT(DISTINCT account_id) AS account_count,
        COUNT(DISTINCT `date`) AS date_count,
        COUNT(DISTINCT type) AS type_count,
        COUNT(DISTINCT operation) AS operation_count,
        COUNT(DISTINCT amount) AS amount_count,
        COUNT(DISTINCT balance) AS balance_count,
        COUNT(DISTINCT Purpose) AS purpose_count
    FROM TRANSACTIONS
    GROUP BY trans_id
    HAVING COUNT(*) > 1
) AS x;
 
 SELECT COUNT(DISTINCT trans_id) AS rows_after_duplicate_removal
FROM TRANSACTIONS;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trans_id) AS unique_trans_ids
FROM TRANSACTIONS;

-- remove duplicate trans_id when whole row is same

create table transactions_clean
select distinct * from transactions; 

-- checking 

select count(*)as total_rows,count(distinct trans_id)as unique_trans_id
from transactions_clean;

SELECT DISTINCT bank
FROM transactions_backup
WHERE bank IS NOT NULL
ORDER BY bank;

--  bank value update

update transactions_clean
set bank = case 
when year(`date`)=2017 then 'YES BANK'
when year(`date`)=2018 then 'SOUTHERN BANK'
when year(`date`)=2019 then 'NORTHERN BANK'
when year(`date`)=2020 then 'QT BANK'
when year(`date`)=2021 then 'DBS BANK'
when year(`date`)=2022 then 'SKY BANK'
end;

SELECT
    YEAR(`date`) AS transaction_year,
    bank,
    COUNT(*) AS row_count
FROM TRANSACTIONS_CLEAN
GROUP BY YEAR(`date`), bank
ORDER BY transaction_year;

 

-- DROP TABLE IF EXISTS transactions;
-- DROP TABLE IF EXISTS transactions_old;
-- DROP TABLE IF EXISTS transactions_clean;
-- DROP TABLE IF EXISTS staging_transactions;
-- SHOW TABLES LIKE 'transactions_clean';