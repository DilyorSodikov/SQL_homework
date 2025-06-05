--  Easy Tasks

-- Create a numbers table using a recursive query from 1 to 1000.

;WITH N AS(
    SELECT 1 AS Numb
    UNION ALL
    SELECT Numb + 1
    FROM N 
    WHERE Numb < 1000
)

SELECT * FROM N
OPTION (MAXRECURSION 1000)
-- Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT T.EmployeeId, ES.FirstName , T.TOTAL
FROM (
    SELECT EmployeeID, SUM(SalesAmount) AS TOTAL
    FROM Sales
    GROUP BY EmployeeID
) AS T
JOIN Employees ES 
ON ES.EmployeeID = T.EmployeeID

-- Create a CTE to find the average salary of employees.(Employees)

;WITH AVERAGE AS(
    SELECT AVG(Salary) AS AVERAGE
    FROM Employees
)

SELECT * FROM AVERAGE

-- Write a query using a derived table to find the highest sales for each product.(Sales, Products)

SELECT T.*
FROM (
    SELECT ProductID, MAX(SalesAmount) AS MAXSALE
    FROM Sales
    GROUP BY ProductID
) AS T
JOIN Products P 
ON P.ProductID = T.ProductID

-- Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.

;WITH MULT AS(
    SELECT 1 AS NUM1
    UNION ALL
    SELECT NUM1 = NUM1 * 2
    FROM MULT
    WHERE NUM1 < 1000000
)

SELECT * FROM MULT
OPTION (MAXRECURSION 1000)

-- Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

;WITH SALE AS (
    SELECT EmployeeID, COUNT(SalesID) AS COUNTEMPL
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(SalesID) > 5
)

SELECT FirstName
FROM Employees 
WHERE EmployeeID IN (
    SELECT EmployeeID FROM SALE 
)

-- Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

;WITH MORE AS(
    SELECT ProductID
    FROM Sales
    WHERE SalesAmount > 500
)

SELECT ProductName, ProductID
FROM Products P
WHERE P.ProductID IN (SELECT * FROM MORE)

-- Create a CTE to find employees with salaries above the average salary.(Employees)

SELECT * FROM Employees

;WITH AVGSAL AS(
    SELECT AVG(Salary) AS AVERAGE
    FROM Employees
)

SELECT *
FROM Employees
WHERE Salary > (SELECT * FROM AVGSAL)


-- Medium Tasks

-- Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

SELECT TOP 5 EP.FirstName ,CT.EmployeeID
FROM (
    SELECT EmployeeID, COUNT(ProductID) AS NUMB
    FROM Sales
    GROUP BY EmployeeID
)as CT 
JOIN Employees EP
ON CT.EmployeeID = EP.EmployeeID
ORDER BY CT.NUMB DESC

-- Write a query using a derived table to find the sales per product category.(Sales, Products)

SELECT PR.CategoryID, SUM(ISNULL(SL.SalesAmount, 0)) AS TOTAL
FROM (
    SELECT CategoryID, ProductID
    FROM Products
) AS PR 
LEFT JOIN Sales SL 
ON SL.ProductID = PR.ProductID
GROUP BY PR.CategoryID

-- Write a script to return the factorial of each value next to it.(Numbers1)

;WITH FactorialCTE AS (
    -- Start with: first step in factorial sequence
    SELECT Number, 1 AS Step, CAST(1 AS BIGINT) AS Factorial
    FROM Numbers1

    UNION ALL

    -- Multiply current factorial by next step value
    SELECT f.Number, f.Step + 1, f.Factorial * (f.Step + 1)
    FROM FactorialCTE f
    WHERE f.Step < f.Number
)

-- Return only the final row per number (where Step = Number)
SELECT Number, Factorial
FROM FactorialCTE
WHERE Step = Number
ORDER BY Number;

-- This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

WITH CharSplit AS (
    SELECT
        Id,
        1 AS CharacterPosition,
        SUBSTRING(String, 1, 1) AS Character,
        String
    FROM Example

    UNION ALL

    SELECT
        Id,
        CharacterPosition + 1,
        SUBSTRING(String, CharacterPosition + 1, 1),
        String
    FROM CharSplit
    WHERE CharacterPosition < LEN(String)
)

SELECT Id, CharacterPosition, Character
FROM CharSplit
ORDER BY Id, CharacterPosition
OPTION (MAXRECURSION 0);


-- Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

;WITH DIFF AS(
    SELECT *,DATEDIFF(MONTH, SaleDate, GETDATE()) AS DIFMONTH
    FROM Sales
)
SELECT * FROM DIFF

-- Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

;WITH QuarterlySales AS (
    SELECT 
        EmployeeID,
        DATEPART(YEAR, SaleDate) AS SaleYear,
        DATEPART(QUARTER, SaleDate) AS SaleQuarter,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(YEAR, SaleDate), DATEPART(QUARTER, SaleDate)
),

Filtered AS (
    SELECT *
    FROM QuarterlySales
    WHERE TotalSales > 45000
),

QualifiedEmployees AS (
    SELECT qs.EmployeeID
    FROM QuarterlySales qs
    GROUP BY qs.EmployeeID
    HAVING COUNT(*) = (
        SELECT COUNT(*) FROM Filtered f WHERE f.EmployeeID = qs.EmployeeID
    )
)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    qs.SaleYear,
    qs.SaleQuarter,
    qs.TotalSales
FROM QuarterlySales qs
JOIN QualifiedEmployees qe ON qs.EmployeeID = qe.EmployeeID
JOIN Employees e ON e.EmployeeID = qs.EmployeeID
ORDER BY e.EmployeeID, qs.SaleQuarter;


SELECT * FROM Sales
SELECT * FROM Employees


-- Difficult Tasks

-- This script uses recursion to calculate Fibonacci numbers

;WITH Fibonacci (n, fib1, fib2) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n + 1, fib2, fib1 + fib2
    FROM Fibonacci
    WHERE n < 20
)
SELECT n, fib1 AS Fibonacci_Number
FROM Fibonacci;
 
-- Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT Id, Vals
FROM FindSameCharacters
WHERE LEN(Vals) > 1
  AND LEN(REPLACE(Vals, LEFT(Vals,1), '')) = 0;


-- Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

DECLARE @n INT = 5;

WITH seq (num, str) AS (
    SELECT 1, CAST('1' AS VARCHAR(100))  -- anchor
    UNION ALL
    SELECT num + 1, CAST(str + CAST(num + 1 AS VARCHAR(10)) AS VARCHAR(100))  -- recursive
    FROM seq
    WHERE num + 1 <= @n
)
SELECT str AS SequenceValue
FROM seq
OPTION (MAXRECURSION 1000);

-- Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

SELECT e.*
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) AS s ON e.EmployeeID = s.EmployeeID
WHERE s.TotalSales = (
    SELECT MAX(TotalSales)
    FROM (
        SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) AS totals
);


-- Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

WITH Split AS (
    SELECT PawanName, value
    FROM RemoveDuplicateIntsFromNames
    CROSS APPLY STRING_SPLIT(Pawan_slug_name, '-')
),
Filtered AS (
    SELECT PawanName, value
    FROM Split
    WHERE TRY_CAST(value AS INT) IS NULL  -- Keep non-integers
       OR LEN(value) > 1                  -- Or integers with more than 1 digit
),
DistinctParts AS (
    SELECT PawanName, value,
           ROW_NUMBER() OVER (PARTITION BY PawanName, value ORDER BY value) AS rn
    FROM Filtered
)
SELECT PawanName,
       STRING_AGG(value, '-') AS CleanedSlug
FROM DistinctParts
WHERE rn = 1
GROUP BY PawanName;
