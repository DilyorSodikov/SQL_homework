--Basic level tasks

USE COMPANY;

-- DROP TABLE Employees;
-- CREATE TABLE Employees(
--     EmpID INT,
--     Name VARCHAR(50),
--     Salary DECIMAL(10,2)
-- );



-- INSERT INTO Employees(EmpID, Name, Salary)
-- VALUES
-- (1, 'Aziz', 1000),
-- (2, 'Kamron', 2000),
-- (3, 'Vohib', 30000);

UPDATE Employees
SET Salary = 5000
WHERE EmpID = 1;

DELETE FROM Employees
WHERE EmpID = 2;

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

-- ALTER TABLE Employees
-- ADD Department VARCHAR(50);

ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;


-- CREATE TABLE Departments(
--     DepartmentID INT PRIMARY KEY,
--     DepartmentName VARCHAR(50)
-- )

TRUNCATE TABLE Employees;

SELECT * FROM Employees;

-- Intermediate level tasks
USE COMPANY;

-- INSERT INTO Departments (DepartmentID,DepartmentName)
-- SELECT EmpId, Name FROM Employees;

-- ALTER TABLE Employees
-- ADD Department VARCHAR(50);

-- UPDATE Employees
-- SET Department = 'Management'
-- WHERE Salary > 2000;

-- TRUNCATE TABLE Employees;


-- ALTER TABLE Employees
-- DROP COLUMN Department;

-- EXEC sp_rename 'Employees', 'StaffMembers';

-- DROP TABLE Departments;



-- SELECT * FROM Departments;
SELECT * FROM StaffMembers;


--Hard level tasks

USE COMPANY;


-- CREATE TABLE Products(
--     ProductID INT PRIMARY KEY,
--     ProductName VARCHAR(50),
--     Category VARCHAR(50),
--     Price DECIMAL
-- );

-- ALTER TABLE Products
-- ADD CONSTRAINT Chk_Price Check (Price > 0);


-- ALTER TABLE Products
-- ADD StockQuantity INT DEFAULT(50);

-- EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

-- TRUNCATE TABLE Products;


-- INSERT INTO Products(ProductID, ProductName, ProductCategory, Price)
-- VALUES
-- (4, 'Banan', 'Meva', 9000),
-- (5, 'Piyoz', 'Sabzavot', 2300);
-- (3, 'Olcha', 'Meva', 6000);



-- SELECT * INTO Products_Backup
-- FROM Products;

-- EXEC sp_rename 'Products_Backup', 'Inventory';

-- ALTER TABLE Inventory
-- ALTER COLUMN Price FLOAT;

-- CREATE TABLE Inventory_New (
--     ProductCode INT IDENTITY(1000, 5) PRIMARY KEY,
--     ProductName VARCHAR(50),
--     ProductCategory VARCHAR(50),
--     Price FLOAT,
--     StockQuantity INT
-- );

-- INSERT INTO Inventory_New (ProductName, ProductCategory, Price, StockQuantity)
-- SELECT ProductName, ProductCategory, Price, StockQuantity
-- FROM Inventory;


SELECT * FROM Inventory_New
