-- Easy-Level Tasks



-- Write a query that uses an alias to rename the ProductName column as Name in the Products table.

SELECT ProductName AS Name FROM Products ;

-- Write a query that uses an alias to rename the Customers table as Client for easier reference.

SELECT * FROM Customers AS Client;

-- Use UNION to combine results from two queries that select ProductName from Products and ProductName from Products_Discounted.

SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

-- Write a query to find the intersection of Products and Products_Discounted tables using INTERSECT.

SELECT * FROM Products
INTERSECT
SELECT * FROM Products_Discounted;

-- Write a query to select distinct customer names and their corresponding Country using SELECT DISTINCT.

SELECT DISTINCT Country
FROM Customers;

-- Write a query that uses CASE to create a conditional column that displays 'High' if Price > 1000, and 'Low' if Price <= 1000 from Products table.

SELECT *,
    CASE 
        WHEN Price > 1000 THEN 'High'
        ELSE 'Low'
        END AS [VALUE]
FROM Products;

-- Use IIF to create a column that shows 'Yes' if Stock > 100, and 'No' otherwise (Products_Discounted table, StockQuantity column).

SELECT StockQuantity,
    IIF(StockQuantity>100, 'YES', 'NO') AS Quantity
FROM Products_Discounted;

-- Medium-Level Tasks


-- Use UNION to combine results from two queries that select ProductName from Products and ProductName from OutOfStock tables.

SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM OutOfStock;

-- Write a query that returns the difference between the Products and Products_Discounted tables using EXCEPT.

SELECT * FROM Products
EXCEPT
SELECT * FROM Products_Discounted

-- Create a conditional column using IIF that shows 'Expensive' if the Price is greater than 1000, and 'Affordable' if less, from Products table.

SELECT Price,
    IIF(Price>1000,'Expensive', 'Affordable') AS [Value]
FROM Products;

-- Write a query to find employees in the Employees table who have either Age < 25 or Salary > 60000.

SELECT * FROM Employees
WHERE Age < 25 AND Salary > 60000;

-- Update the salary of an employee based on their department, increase by 10% if they work in 'HR' or EmployeeID = 5

UPDATE Employees
SET Salary = (Salary * 1.10)
WHERE DepartmentName = 'HR' AND EmployeeID = 5;

-- Hard-Level Tasks


-- Use INTERSECT to show products that are common between Products and Products_Discounted tables.

SELECT * FROM Products
INTERSECT
SELECT * FROM Products_Discounted;

-- Write a query that uses CASE to assign 'Top Tier' if SaleAmount > 500, 'Mid Tier' if SaleAmount BETWEEN 200 AND 500, and 'Low Tier' otherwise. (From Sales table)

SELECT *,
    CASE 
        WHEN SaleAmount > 500 THEN 'Top Tier'
        WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
        ELSE 'Low Tier'
    END AS [Value]
FROM Sales;

-- Use EXCEPT to find customers' ID who have placed orders but do not have a corresponding record in the Invoices table.

SELECT CustomerID
FROM Orders
EXCEPT
SELECT CustomerID
FROM Invoices;

-- Write a query that uses a CASE statement to determine the discount percentage based on the quantity purchased. Use orders table. Result set should show customerid, quantity and discount percentage. The discount should be applied as follows: 1 item: 3% Between 1 and 3 items : 5% Otherwise: 7%

SELECT CustomerID, Quantity,
    CASE 
        WHEN Quantity = 1 THEN '3%'
        WHEN Quantity BETWEEN 1 AND 3 THEN '5%'
        ELSE '7%'
    END AS Discount_Percenatge
FROM Orders;

