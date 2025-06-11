CREATE DATABASE HOMEWORK_19

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);

-- Task 1:

-- Create a stored procedure that:

-- Creates a temp table #EmployeeBonus
-- Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
-- (BonusAmount = Salary * BonusPercentage / 100)
-- Then, selects all data from the temp table.


CREATE PROC TASK_1 
AS
BEGIN
    SELECT 
        EP.EmployeeID,
        CONCAT(EP.FirstName ,' ', EP.LastName) AS FULLNAME,
        EP.Department,
        EP.Salary,
        EP.Salary * DB.BonusPercentage / 100 AS BonusAmount
    INTO #EmployeeBonus
    FROM Employees EP
    JOIN DepartmentBonus DB 
    ON DB.Department = EP.Department;

    SELECT * FROM #EmployeeBonus;
END;


EXEC TASK_1;

-- Task 2:

-- Create a stored procedure that:

-- Accepts a department name and an increase percentage as parameters
-- Update salary of all employees in the given department by the given percentage
-- Returns updated employees from that department.


CREATE PROC TASK_2
    @NAME VARCHAR(50),
    @PERCENT INT
AS 
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * @PERCENT/100.0)
    WHERE Department = @NAME;

    SELECT 
        EP.EmployeeID,
        CONCAT(EP.FirstName ,' ', EP.LastName) AS FULLNAME,
        EP.Department,
        EP.Salary
    FROM Employees EP
    WHERE EP.Department = @NAME;
END;

EXEC TASK_2 'SALES', 10




CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);


-- Task 3:

-- Perform a MERGE operation that:

-- Updates ProductName and Price if ProductID matches
-- Inserts new products if ProductID does not exist
-- Deletes products from Products_Current if they are missing in Products_New
-- Return the final state of Products_Current after the MERGE.

SELECT * FROM  Products_Current
SELECT * FROM Products_New


MERGE Products_Current AS PC 
USING Products_New AS PN 
ON PN.ProductID = PC.ProductID

WHEN MATCHED THEN
    UPDATE SET
        PC.ProductName = PN.ProductName,
        PC.Price = PN.Price 

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (PN.ProductID ,PN.ProductName, PN.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


-- Task 4:

-- Tree Node

-- Each node in the tree can be one of three types:

-- "Leaf": if the node is a leaf node.
-- "Root": if the node is the root of the tree.
-- "Inner": If the node is neither a leaf node nor a root node.

IF OBJECT_ID('Tree', 'U') IS NOT NULL
    DROP TABLE Tree;
GO

CREATE TABLE Tree (
    id INT,
    p_id INT
);



TRUNCATE TABLE Tree;

INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

SELECT * FROM Tree


SELECT 
    id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'                      -- No parent → root
        WHEN id NOT IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL)
            THEN 'Leaf'                                    -- Not a parent → leaf
        ELSE 'Inner'                                       -- Has a parent and is also a parent
    END AS type
FROM Tree;



-- Task 5:

-- Confirmation Rate

-- Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.

-- Input:


IF OBJECT_ID('Confirmations', 'U') IS NOT NULL DROP TABLE Confirmations;
IF OBJECT_ID('Signups', 'U') IS NOT NULL DROP TABLE Signups;


CREATE TABLE Signups (
    user_id INT,
    time_stamp DATETIME
);

CREATE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action VARCHAR(20)
);

INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');


INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

SELECT 
    s.user_id,
    ROUND(
        CASE 
            WHEN COUNT(c.action) = 0 THEN 0.0
            ELSE 
                SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 
                / COUNT(c.action)
        END,
    2) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id;

-- Task 6:

-- Find employees with the lowest salary

-- Input:

CREATE TABLE employees1 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees1 (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT *
FROM employees1
WHERE salary = (
    SELECT MIN(salary)
    FROM employees1
);


-- ask 7:

-- Get Product Sales Summary

-- Input:

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

CREATE OR ALTER PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        P.ProductName,
        SUM(S.Quantity) AS TotalQuantitySold,
        SUM(S.Quantity * P.Price) AS TotalSalesAmount,
        MIN(S.SaleDate) AS FirstSaleDate,
        MAX(S.SaleDate) AS LastSaleDate
    FROM Products P
    LEFT JOIN Sales S ON P.ProductID = S.ProductID
    WHERE P.ProductID = @ProductID
    GROUP BY P.ProductName;
END;

EXEC GetProductSalesSummary @ProductID = 1;





