---- 1. Create Database

CREATE DATABASE IF NOT EXISTS Banking;
SHOW DATABASES;

---- 2. Creating and populating Customer table

USE Banking;

-- Customer Table
CREATE TABLE `Customer` (
`customer_id` smallint unsigned NOT NULL AUTO_INCREMENT,
`first_name` varchar(50) NOT NULL,
`last_name` varchar(45) NOT NULL,
 PRIMARY KEY (`customer_id`),
 KEY `idx_customer_last_name` (`last_name`),
 KEY `idx_customer_full_name` (`last_name`, `first_name`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Populating customer table
INSERT INTO Banking.Customer(customer_id, first_name, last_name) VALUES
	(1, 'Ben', 'Chang'), (2, 'Gwen', 'Stacy'), (3, 'Peter', 'Parker'), (4, 'Robert', 'Langdon'),
	(5, 'Vivian', 'Banks'), (6, 'Chidi', 'Anagonye'),(7, 'Valerie', 'Frizzle')
	
---- 3
-- a. LAST NAME EXAMPLE	
SELECT c.last_name AS 'Customer Last Name', c.first_name AS 'Customer First Name', c.customer_id AS 'Customer ID'
FROM Banking.Customer c
WHERE c.last_name = 'Parker';

-- b. FIRST NAME AND LAST NAME EXAMPLE
SELECT c.last_name AS 'Customer Last Name', c.first_name AS 'Customer First Name', c.customer_id AS 'Customer ID'
FROM Banking.Customer c
WHERE c.last_name = 'Stacy' AND c.first_name = 'Gwen';;

-- c. CUSTOMER ID EXAMPLE
SELECT c.customer_id AS 'Customer ID', c.first_name AS 'Customer First Name', c.last_name AS 'Customer Last Name'
FROM Banking.Customer c
WHERE c.customer_id = 5;

---- 4. Creating and populating account related tables

-- Account Type Table
CREATE TABLE `Account_Type` (
`account_type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
`account_name` varchar(50) NOT NULL,
 KEY (`account_type_id`)
)ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Populate account type table
INSERT INTO Banking.Account_Type(account_type_id, account_name) VALUES
(1,'Checking'), (2, 'Savings'), (3, 'Mortgage'), (4, 'Credit Card')


-- Account Table

CREATE TABLE `Account`(
`account_id` smallint unsigned NOT NULL AUTO_INCREMENT,
`customer_id` smallint unsigned NOT NULL,
`account_type_id` tinyint unsigned NOT NULL, 
`balance` DECIMAL(9,2) NOT NULL,
 PRIMARY KEY(`account_id`),
 CONSTRAINT `fk_customer_id` FOREIGN KEY(`customer_id`) REFERENCES `Customer`(`customer_id`)ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT `fk_account_type_id` FOREIGN KEY(`account_type_id`) REFERENCES `Account_Type`(`account_type_id`)ON DELETE RESTRICT ON UPDATE CASCADE
 )ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

---- 5.

--- Transaction_Type Table

CREATE TABLE `Transaction_Type` (
`transaction_type_id` smallint unsigned NOT NULL AUTO_INCREMENT,
`transaction_type` varchar(50) NOT NULL,
 KEY (`transaction_type_id`)
)ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


--- Transaction Table

CREATE TABLE `Transaction`(
`transaction_id` smallint unsigned NOT NULL AUTO_INCREMENT,
`from_account_id` smallint unsigned NOT NULL,
`to_account_id` smallint unsigned NOT NULL, 
`transaction_type_id`smallint unsigned NOT NULL,
`amount` decimal(9,2) NOT NULL,
`date` DATETIME DEFAULT CURRENT_TIMESTAMP(),
 PRIMARY KEY(`transaction_id`),
 CONSTRAINT `fk_transaction_type_id` FOREIGN KEY(`transaction_type_id`) REFERENCES `Transaction_Type`(`transaction_type_id`)ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT `fk_from_account_id` FOREIGN KEY(`from_account_id`) REFERENCES `Account`(`account_id`)ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT `fk_to_account` FOREIGN KEY(`to_account_id`) REFERENCES `Account`(`account_id`)ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting Transaction Type Values
INSERT INTO Banking.Transaction_Type(transaction_type_id, transaction_type)VALUES
(1, 'Debit'),(2,'Credit'),(3,'Transfer')

-- 6.

-- Inserting into Bank Accounts
INSERT INTO Banking.Account(account_id, customer_id, account_type_id, balance)VALUES
-- Customer 1: Savings Account
(101,1,2,30000.00), 
-- Customer 1: Checkings Account
(102,1,1,1378.67),
-- Customer 2: Mortgage Account
(103,2,3,-45000.00), 
-- Customer 2: Checking Account
(104,2,1,2000.00),
-- Customer 3: Credit Card
(105,3,4,-500.38),  
-- Customer 3: Savings Account
(106,3,2,567845.43)


-- 7.

-- Populating Transaction Table
INSERT INTO Banking.Transaction(from_account_id, to_account_id, transaction_type_id, amount)VALUES
-- Transfer: Savings -> Checking
(101,102,3,1000.00), 
--  Transfer: Checking -> Credit Card
(102,105,3,350.00),
-- Transfer: Checking -> Mortgage
(104,103,3,1500.00),
-- Transfer: Savings -> Credit Card
(106,105,3,200.00)

-- Transaction Report demonstrating all account types 
SELECT t.transaction_id AS 'Transaction ID', t.amount AS 'Amount',CONCAT(from_cust.first_name, ' ', from_cust.last_name) AS 'From Customer', from_type.account_name AS 'From Account Type',
CONCAT(to_cust.first_name, ' ', to_cust.last_name) AS 'To Customer', to_type.account_name AS 'To Account Type'
FROM Banking.Transaction t
JOIN Banking.Account from_acc 
ON t.from_account_id = from_acc.account_id
JOIN Banking.Account_Type from_type 
ON from_acc.account_type_id = from_type.account_type_id
JOIN Banking.Customer from_cust 
ON from_acc.customer_id = from_cust.customer_id
JOIN Banking.Account to_acc 
ON t.to_account_id = to_acc.account_id
JOIN Banking.Account_Type to_type 
ON to_acc.account_type_id = to_type.account_type_id
JOIN Banking.Customer to_cust 
ON to_acc.customer_id = to_cust.customer_id
ORDER BY t.transaction_id;