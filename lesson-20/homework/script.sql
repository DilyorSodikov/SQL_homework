CREATE DATABASE HOMEWORK_20

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

-- 1. Find customers who purchased at least one item in March 2024 using EXISTS

SELECT DISTINCT CustomerName
FROM #Sales AS S1
WHERE EXISTS (
    SELECT 1
    FROM #Sales S2
    WHERE 
        S2.CustomerName = S1.CustomerName
        AND YEAR(S2.SaleDate) = 2024
        AND MONTH(S2.SaleDate) = 3
)

-- 2. Find the product with the highest total sales revenue using a subquery.

SELECT T1.Product, T1.TOTALSALE
FROM (
    SELECT Product, SUM(Quantity * Price) AS TOTALSALE
    FROM #Sales
    GROUP BY Product
) AS T1
WHERE T1.TOTALSALE = (
    SELECT MAX(T2.TOTAL) 
    FROM (
        SELECT Product, SUM(Quantity * Price) AS TOTAL
        FROM #Sales
        GROUP BY Product
    ) T2
);

-- 3. Find the second highest sale amount using a subquery


SELECT T1.Product, T1.TOTALSALE
FROM (
    SELECT Product, SUM(Quantity * Price) AS TOTALSALE
    FROM #Sales
    GROUP BY Product
) AS T1
WHERE T1.TOTALSALE = (
    SELECT MAX(T2.TOTAL) 
    FROM (
        SELECT Product, SUM(Quantity * Price) AS TOTAL
        FROM #Sales
        GROUP BY Product
    ) T2
    WHERE T2.TOTAL < (
        SELECT MAX(T3.TOTAL) 
        FROM (
            SELECT Product, SUM(Quantity * Price) AS TOTAL
            FROM #Sales
            GROUP BY Product
        ) T3
    )
);
-- 4. Find the total quantity of products sold per month using a subquery

SELECT *
FROM (
    SELECT MONTH(SaleDate) AS OY, SUM(Quantity) AS TOTAL
    FROM #Sales
    GROUP BY MONTH(SaleDate)
) AS T1

 -- 5. Find customers who bought same products as another customer using EXISTS

 SELECT * FROM #Sales

SELECT DISTINCT S1.CustomerName
FROM #Sales S1
WHERE EXISTS(
    SELECT 1 
    FROM #Sales S2
    WHERE

    S2.CustomerName <> S1.CustomerName AND
    S2.Product = S1.Product
 )



-- 6. Return how many fruits does each person have in individual fruit level

create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

SELECT 
    Name,
    COUNT(CASE WHEN Fruit = 'Apple' THEN 1 END) AS Apple,
    COUNT(CASE WHEN Fruit = 'Orange' THEN 1 END) AS Orange,
    COUNT(CASE WHEN Fruit = 'Banana' THEN 1 END) AS Banana
FROM 
    Fruits
GROUP BY 
    Name
ORDER BY 
    Name;

-- 7. Return older people in the family with younger ones

-- create table Family(ParentId int, ChildID int)
-- insert into Family values (1, 2), (2, 3), (3, 4)
-- 1 Oldest person in the family --grandfather 2 Father 3 Son 4 Grandson



CREATE TABLE Family(ParentId INT, ChildID INT);
INSERT INTO Family VALUES (1, 2), (2, 3), (3, 4);


WITH Ancestors AS (
   
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family

    UNION ALL

    
    SELECT a.PID, f.ChildID
    FROM Ancestors a
    JOIN Family f ON a.CHID = f.ParentId
)

SELECT *
FROM Ancestors
ORDER BY PID, CHID;

-- 8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);


SELECT *
FROM #Orders
WHERE DeliveryState = 'TX'
  AND CustomerID IN (
      SELECT DISTINCT CustomerID
      FROM #Orders
      WHERE DeliveryState = 'CA'
  );


-- 9. Insert the names of residents if they are missing

create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')


UPDATE #residents
SET address = 
    STUFF(address, 
          CHARINDEX('age=', address), 
          0, 
          'name=' + fullname + ' '
    )
WHERE address NOT LIKE '%name=%';

-- 10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);



WITH RecursiveRoutes AS (
    
    SELECT 
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        ArrivalCity,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        CAST(r.Route + ' - ' + rt.ArrivalCity AS VARCHAR(MAX)) AS Route,
        rt.ArrivalCity,
        r.Cost + rt.Cost AS Cost
    FROM RecursiveRoutes r
    JOIN #Routes rt
      ON r.ArrivalCity = rt.DepartureCity
    WHERE r.Route NOT LIKE '% ' + rt.ArrivalCity + ' %'  
)


, Filtered AS (
    SELECT Route, Cost
    FROM RecursiveRoutes
    WHERE ArrivalCity = 'Khorezm'
)


SELECT Route, Cost
FROM Filtered
WHERE Cost = (SELECT MIN(Cost) FROM Filtered)
   OR Cost = (SELECT MAX(Cost) FROM Filtered);


-- 11. Rank products based on their order of insertion.

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

WITH Ranked AS (
    SELECT *,
           SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
               OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ProductRank
    FROM #RankingPuzzle
)
SELECT *
FROM Ranked
WHERE Vals <> 'Product';

-- Question 12

-- Find employees whose sales were higher than the average sales in their department

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT *
FROM #EmployeeSales E
WHERE SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = E.Department
      AND SalesMonth = E.SalesMonth
      AND SalesYear = E.SalesYear
);


-- 13. Find employees who had the highest sales in any given month using EXISTS

SELECT E1.*
FROM #EmployeeSales E1
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales E2
    WHERE 
        E2.SalesMonth = E1.SalesMonth
        AND E2.SalesYear = E1.SalesYear
        AND E2.SalesAmount > E1.SalesAmount
);

-- 14. Find employees who made sales in every month using NOT EXISTS

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT DISTINCT E1.EmployeeName
FROM #EmployeeSales E1
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth, SalesYear
        FROM #EmployeeSales
    ) AS AllPeriods
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales E2
        WHERE E2.EmployeeName = E1.EmployeeName
          AND E2.SalesMonth = AllPeriods.SalesMonth
          AND E2.SalesYear = AllPeriods.SalesYear
    )
);
-- 15. Retrieve the names of products that are more expensive than the average price of all products.

SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);


-- 16. Find the products that have a stock count lower than the highest stock count.


SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);


-- 17. Get the names of products that belong to the same category as 'Laptop'.

SELECT Name
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);


-- 18. Retrieve products whose price is greater than the lowest price in the Electronics category.


SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);


-- 19. Find the products that have a higher price than the average price of their respective category.

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');


SELECT *
FROM Products P
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = P.Category
);


-- 20. Find the products that have been ordered at least once.


SELECT DISTINCT P.*
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID;


-- 21. Retrieve the names of products that have been ordered more than the average quantity ordered.

SELECT P.Name
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.Name
HAVING SUM(O.Quantity) > (
    SELECT AVG(TotalQty)
    FROM (
        SELECT SUM(Quantity) AS TotalQty
        FROM Orders
        GROUP BY ProductID
    ) AS AvgTable
);


-- 22. Find the products that have never been ordered.

SELECT *
FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID
    FROM Orders
);


-- 23. Retrieve the product with the highest total quantity ordered.

SELECT TOP 1 P.*, SUM(O.Quantity) AS TotalOrdered
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.Name, P.Category, P.Price, P.Stock
ORDER BY TotalOrdered DESC;



