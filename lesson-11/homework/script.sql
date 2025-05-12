

-- 1. 
SELECT O.OrderID, CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, O.OrderDate
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) > 2022;

-- 2. 
SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Sales', 'Marketing');

-- 3.
SELECT D.DepartmentName, MAX(E.Salary) AS MaxSalary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName;

-- 4. 
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, O.OrderID, O.OrderDate
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.Country = 'USA' AND YEAR(O.OrderDate) = 2023;

-- 5.
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, COUNT(O.OrderID) AS TotalOrders
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;

-- 6.
SELECT P.ProductName, S.SupplierName
FROM Products P
JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE S.SupplierName IN ('Gadget Supplies', 'Clothing Mart');

-- 7.
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, MAX(O.OrderDate) AS MostRecentOrderDate
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;

-- ========== MEDIUM LEVEL TASKS ==========

-- 8. 
SELECT DISTINCT CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, O.TotalAmount AS OrderTotal
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE O.TotalAmount > 500;

-- 9. 
SELECT P.ProductName, S.SaleDate, S.SaleAmount
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
WHERE YEAR(S.SaleDate) = 2022 OR S.SaleAmount > 400;

-- 10. 
SELECT P.ProductName, SUM(S.SaleAmount) AS TotalSalesAmount
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName;

-- 11. 
SELECT E.Name AS EmployeeName, D.DepartmentName, E.Salary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Human Resources' AND E.Salary > 60000;

-- 12. 
SELECT P.ProductName, S.SaleDate, P.StockQuantity
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
WHERE YEAR(S.SaleDate) = 2023 AND P.StockQuantity > 100;

-- 13. 
SELECT E.Name AS EmployeeName, D.DepartmentName, E.HireDate
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales' OR YEAR(E.HireDate) > 2020;

-- ========== HARD LEVEL TASKS ==========

-- 14. 
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, O.OrderID, C.Address, O.OrderDate
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.Country = 'USA' AND C.Address LIKE '[0-9][0-9][0-9][0-9]%';

-- 15. 
SELECT P.ProductName, CAT.CategoryName AS Category, S.SaleAmount
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
JOIN Categories CAT ON P.Category = CAT.CategoryID
WHERE CAT.CategoryName = 'Electronics' OR S.SaleAmount > 350;

-- 16. 
SELECT CAT.CategoryName, COUNT(P.ProductID) AS ProductCount
FROM Products P
JOIN Categories CAT ON P.Category = CAT.CategoryID
GROUP BY CAT.CategoryName;

-- 17. 
SELECT CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName, C.City, O.OrderID, O.TotalAmount AS Amount
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.City = 'Los Angeles' AND O.TotalAmount > 300;

-- 18. 
SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Human Resources', 'Finance')
   OR LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'a','')) 
      - LEN(REPLACE(LOWER(E.Name), 'e','')) 
      - LEN(REPLACE(LOWER(E.Name), 'i','')) 
      - LEN(REPLACE(LOWER(E.Name), 'o','')) 
      - LEN(REPLACE(LOWER(E.Name), 'u','')) >= 4;

-- 19. 
SELECT E.Name AS EmployeeName, D.DepartmentName, E.Salary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Sales', 'Marketing') AND E.Salary > 60000;
