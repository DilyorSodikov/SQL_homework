CREATE DATABASE HOMEWORK_17

-- 1. You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, rovide a zero-dollar value for that day. Assume there is at least one sale for each region

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

;WITH REGIONS AS (
    SELECT DISTINCT Region FROM #RegionSales
),
DISTRIBUTORS AS (
    SELECT DISTINCT Distributor FROM #RegionSales
)
SELECT 
    AL.Region, 
    AL.Distributor, 
    ISNULL(RS.Sales, 0) AS Sales
FROM 
    (SELECT * FROM REGIONS RG CROSS JOIN DISTRIBUTORS DT) AS AL
LEFT JOIN 
    #RegionSales RS
    ON RS.Region = AL.Region AND RS.Distributor = AL.Distributor
ORDER BY AL.Region, AL.Distributor;

-- 2. Find managers with at least five direct reports

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);


SELECT name
FROM Employee
WHERE id IN (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5
);


--3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

SELECT * FROM Products
SELECT * FROM Orders


SELECT product_id, SUM(unit) AS TOTAL
FROM Orders
WHERE DATENAME(MONTH, order_date) = 'FEBRUARY'
GROUP BY product_id
HAVING SUM(unit) >= 100

-- 4. Write an SQL statement that returns the vendor from which each customer has placed the most orders

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
  OrderID    INT PRIMARY KEY,
  CustomerID INT NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);

INSERT INTO Orders (OrderID, CustomerID, [Count], Vendor) VALUES
(1,1001,12,'Direct Parts'),
(2,1001,54,'Direct Parts'),
(3,1001,32,'ACME'),
(4,2002,7,'ACME'),
(5,2002,16,'ACME'),
(6,2002,5,'Direct Parts');

;WITH FIR AS(
    SELECT CustomerID, Vendor, COUNT(OrderID) NUMB
    FROM Orders
    GROUP BY CustomerID, Vendor
),
SEC AS (
      SELECT CustomerID, Vendor
      FROM FIR 
      WHERE NUMB IN(
        SELECT MAX(NUMB) AS MAXIM
        FROM FIR
        GROUP BY CustomerID
      )
)

SELECT * FROM SEC
ORDER BY CustomerID

-- 5. You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'

DECLARE @Check_Prime INT = 97;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;

WHILE @i < @Check_Prime
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0;      
    END

    SET @i = @i + 1;           
END

IF @IsPrime = 1
    PRINT 'THIS IS PRIME NUMBER';
ELSE
    PRINT 'THIS IS NOT PRIME NUMBER';


-- 6. Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

;WITH MOSSIG AS (
    SELECT Device_id, Locations, COUNT(*) AS LOC,
           ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY COUNT(*) DESC) AS RN
    FROM Device
    GROUP BY Device_id, Locations
),
TOPLOC AS (
    SELECT Device_id, Locations
    FROM MOSSIG
    WHERE RN = 1
),
NOFLOC AS (
    SELECT Device_id, COUNT(DISTINCT Locations) AS LOCS
    FROM Device
    GROUP BY Device_id
),
TNOFSIG AS (
    SELECT Device_id, COUNT(*) AS NUMB
    FROM Device
    GROUP BY Device_id
)

SELECT T.Device_id, N.LOCS, T.Locations, TS.NUMB
FROM TOPLOC T
JOIN NOFLOC N ON N.Device_id = T.Device_id
JOIN TNOFSIG TS ON TS.Device_id = T.Device_id;

-- SELECT * FROM Device

-- ;WITH NDEVICE AS(
--     SELECT Device_id
--     FROM Device
--     GROUP BY Device_id
-- ),

-- MOSSIG AS(
--     SELECT Device_id, Locations, COUNT(Locations) AS LOC
--     FROM Device
--     GROUP BY Device_id, Locations
-- ),

-- MAXLOC AS (
--     SELECT Device_id, MAX(LOC) AS MAXIM
--     FROM MOSSIG
--     GROUP BY Device_id
-- ),

-- NOFLOC AS(
--     SELECT Device_id, COUNT(Locations) AS LOCS
--     FROM MOSSIG
--     GROUP BY Device_id
-- ),

-- MAX_SIG AS(
--     SELECT MG.Device_id ,MG.Locations
--     FROM MOSSIG MG
--     JOIN MAXLOC ML 
--     ON ML.MAXIM = MG.LOC
-- ),

-- TNOFSIG AS(
--     SELECT Device_id, COUNT(Locations) AS NUMB
--     FROM Device
--     GROUP BY Device_id
-- )


-- SELECT ND.Device_id, NL.LOCS, MS.Locations, TN.NUMB
-- FROM NDEVICE ND 
-- JOIN NOFLOC NL 
-- ON NL.Device_id = ND.Device_id
-- JOIN MAX_SIG MS
-- ON MS.Device_id = ND.Device_id
-- JOIN TNOFSIG TN 
-- ON ND.Device_id = TN.Device_id


--7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. Return EmpID, EmpName,Salary in your output

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

SELECT E.EmpID, E.EmpName, E.Salary
FROM Employee E
JOIN (
    SELECT DeptID, AVG(Salary) AS AvgSalary
    FROM Employee
    GROUP BY DeptID
) D ON E.DeptID = D.DeptID
WHERE E.Salary > D.AvgSalary;

--8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.



DROP TABLE IF EXISTS Tickets;

CREATE TABLE Tickets (
    [Ticket ID] VARCHAR(20),
    Number INT
);

INSERT INTO Tickets ([Ticket ID], Number) VALUES
('A23423', 25), ('A23423', 45), ('A23423', 78),
('B35643', 25), ('B35643', 45), ('B35643', 98),
('C98787', 67), ('C98787', 86), ('C98787', 91);


-- Winning Numbers
WITH Winning AS (
  SELECT 25 AS Number
  UNION ALL SELECT 45
  UNION ALL SELECT 78
),

-- Ticket Matches
TicketMatch AS (
  SELECT t.[Ticket ID], COUNT(DISTINCT t.Number) AS Matches
  FROM Tickets t
  JOIN Winning w ON t.Number = w.Number
  GROUP BY t.[Ticket ID]
)

-- Calculate Winnings
SELECT SUM(
  CASE 
    WHEN Matches = 3 THEN 100
    WHEN Matches BETWEEN 1 AND 2 THEN 10
    ELSE 0
  END
) AS TotalWinnings
FROM TicketMatch;


-- 9. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.

-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

WITH Platforms AS (
  SELECT User_id, Spend_date,
    MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS MobileUsed,
    MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS DesktopUsed,
    SUM(Amount) AS TotalSpent
  FROM Spending
  GROUP BY User_id, Spend_date
),

Classified AS (
  SELECT Spend_date,
    CASE 
      WHEN MobileUsed = 1 AND DesktopUsed = 1 THEN 'Both'
      WHEN MobileUsed = 1 THEN 'Mobile'
      WHEN DesktopUsed = 1 THEN 'Desktop'
    END AS Platform,
    TotalSpent,
    User_id
  FROM Platforms
)

SELECT 
  ROW_NUMBER() OVER (ORDER BY Spend_date, Platform) AS Row,
  Spend_date,
  Platform,
  SUM(TotalSpent) AS Total_Amount,
  COUNT(DISTINCT User_id) AS Total_users
FROM Classified
GROUP BY Spend_date, Platform;

--10. Write an SQL Statement to de-group the following data.

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

-- Step 1: Store the max quantity in a variable
DECLARE @MaxQuantity INT;
SELECT @MaxQuantity = MAX(Quantity) FROM Grouped;

-- Step 2: Build numbers from 1 to @MaxQuantity using CTE
WITH Numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM Numbers WHERE n + 1 <= @MaxQuantity
)

-- Step 3: Join to expand grouped rows
SELECT g.Product, 1 AS Quantity
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product
OPTION (MAXRECURSION 1000);

