--Easy-level tasks

--CREATE DATABASE hw_lesson_3;

USE hw_lesson_3;

-- CREATE TABLE Products (
--     ProductID INT,
--     ProductName NVARCHAR(100),
--     Price NVARCHAR(50)  -- Text format to avoid bulk insert conversion issues
-- );

-- INSERT INTO Products(ProductID, ProductName, Price)
-- VALUES
-- (1, 'Computer', 10000),
-- (2, 'Pen', 1000),
-- (3, 'Bottle', 3000);

-- CREATE TABLE Example_1(
--     Quantity INT,
--     Name VARCHAR(50) NOT NULL
-- );

-- CREATE TABLE Example_2(
--     Quantity INT,
--     Name VARCHAR(50) NULL
-- );

-- ALTER TABLE Products
-- ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- CREATE TABLE Categories(
--     CategoryID INT PRIMARY KEY,
--     CategoryName VARCHAR(50) UNIQUE
-- );

-- CREATE TABLE Example_3(
--     CustomerID INT IDENTITY(1,1) PRIMARY KEY,
--     Name VARCHAR(50)
-- );
-- Drop the table if it already exists

-- Create a new version of the Products table

-- Medium-level tasks

-- BULK INSERT Products
-- FROM '/var/opt/mssql/data/Email_Info.csv'
-- WITH (
--     FIELDTERMINATOR = ',',
--     ROWTERMINATOR = '\n',
--     FIRSTROW = 2
-- );

-- ALTER TABLE Products
-- ADD CategoryID INT;

-- ALTER TABLE Products
-- ADD CONSTRAINT FK_Products_Catgories FOREIGN KEY (CategoryID)
-- REFERENCES Categories(CategoryID);


-- INSERT INTO Categories (CategoryID, CategoryName)
-- VALUES 
-- (1, 'Electronics'),
-- (2, 'Mobile Devices');

-- INSERT INTO Products (ProductID, ProductName, Price, CategoryID)
-- VALUES
-- (1, 'Laptop', 1200.50, 1),
-- (2, 'Smartphone', 850.00, 2),
-- (3, 'Mouse', 25.99, 1),
-- (4, 'Monitor', 199.90, 1);

-- ALTER TABLE Products
-- ADD CONSTRAINT CHK_PRICE CHECK (Price > 0);

-- ALTER TABLE Products
-- ADD Stock INT NOT NULL DEFAULT 0;

-- SELECT ProductName, ISNULL(Stock, 0) AS Stock
-- FROM Products;

--Hard-level tasks

-- CREATE TABLE Customers(
--     Age INT, CHECK (Age > 0)
-- );

-- ALTER TABLE Customers
-- ADD Numbers INT IDENTITY(100,10)



-- INSERT INTO Customers(Age,OrderID,ProductID)
-- VALUES
-- (15,3,10),
-- (23,4,7),
-- (31,4,6);

-- ALTER TABLE Customers ALTER COLUMN OrderID INT NOT NULL;
-- ALTER TABLE Customers ALTER COLUMN ProductID INT NOT NULL;



-- ALTER TABLE Customers
-- ADD CONSTRAINT PK_Customers PRIMARY KEY (OrderID, ProductID);


-- SELECT COALESCE(Age, OrderID, 'No Contact') FROM Customers;

-- CREATE TABLE Employees (
--     EmpID INT PRIMARY KEY,
--     FullName VARCHAR(100),
--     Email VARCHAR(100) UNIQUE
-- );

-- CREATE TABLE Orders (
--     OrderID INT PRIMARY KEY,
--     CustomerID INT,
--     FOREIGN KEY (CustomerID)
--     REFERENCES Example_3(CustomerID)
--     ON DELETE CASCADE
--     ON UPDATE CASCADE
-- );





-- SELECT * FROM Products;
-- SELECT * FROM Categories;
