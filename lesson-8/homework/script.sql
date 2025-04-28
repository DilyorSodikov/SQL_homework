-- Easy-Level Tasks

-- Using Products table, find the total number of products available in each category.

SELECT Category,
COUNT(*) AS NumProducts
FROM Products
GROUP BY Category;

-- Using Products table, get the average price of products in the 'Electronics' category.

SELECT Category,
AVG(Price) AS AvgPrice
FROM Products
WHERE Category = 'Electronics'
GROUP BY Category;

-- Using Customers table, list all customers from cities that start with 'L'.

SELECT CustomerID
FROM Customers
WHERE City LIKE 'L%';

-- Using Products table, get all product names that end with 'er'.

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er'

-- Using Customers table, list all customers from countries ending in 'A'.

SELECT CustomerID
FROM Customers
WHERE Country LIKE '%a';

-- Using Products table, show the highest price among all products.

SELECT MAX(Price) AS MaxPrice
FROM Products;

-- Using Products table, use IIF to label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.

SELECT ProductName,
    IIF(StockQuantity<30, 'LOW STOCK', 'SUFFICIENT') AS StockValue
FROM Products;

-- Using Customers table, find the total number of customers in each country.

SELECT Country,
COUNT(CustomerID) AS NumCustomer
FROM Customers
GROUP BY Country;

-- Using Orders table, find the minimum and maximum quantity ordered.

SELECT MIN(Quantity) AS MinQuantity,
MAX(Quantity) AS MaxQuantity
FROM Orders;

-- Medium-Level Tasks

-- Using Orders and Invoices tables, list customer IDs who placed orders in 2023 (using EXCEPT) to find those who did not have invoices.

SELECT CustomerID
FROM Orders
WHERE YEAR(OrderDate) = 2023
EXCEPT
SELECT CustomerID
FROM Invoices
WHERE YEAR(InvoiceDate) = 2023;


-- Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.

SELECT ProductName
FROM Products
UNION ALL
SELECT ProductName
FROM Products_Discounted;

-- Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.

SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

-- Using Orders table, find the average order amount by year.

SELECT YEAR(OrderDate) AS OrderYear,
AVG(Quantity) AS AvgQuantity
FROM Orders
GROUP BY YEAR(OrderDate)


-- Using Products table, use CASE to group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.

SELECT *,
CASE 
WHEN Price<100 THEN 'LOW'
WHEN Price>500 THEN 'HIGH'
ELSE 'MID'
END AS PriceValue
FROM Products;

-- Using Customers table, list all unique cities where customers live, sorted alphabetically.

SELECT DISTINCT(City)
FROM Customers
ORDER BY City ASC;

-- Using Sales table, find total sales per product Id.

SELECT ProductID,
SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%OO%';

-- Using Products and Products_Discounted tables, compare product IDs using INTERSECT.

SELECT ProductID
FROM Products
INTERSECT
SELECT ProductID
FROM Products_Discounted;

-- Hard-Level Tasks

-- Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.

SELECT TOP 3 CustomerID, SUM(TotalAmount) AS Totalspent
FROM Invoices
GROUP by CustomerID
ORDER BY Totalspent DESC;

-- Find product ID and productname that are present in Products but not in Products_Discounted.

SELECT ProductName
FROM Products
EXCEPT
SELECT ProductName
FROM Products_Discounted;

-- Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)

SELECT p.ProductName,
       COUNT(s.SaleID) AS NumberOfSales
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;


-- Using Orders table, find top 5 products (by ProductID) with the highest order quantities.

SELECT TOP 5 ProductID,
SUM(Quantity) AS MaxQuantity
FROM Orders
GROUP BY ProductID
ORDER BY MaxQuantity DESC;
