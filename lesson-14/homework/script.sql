-- Easy Tasks

-- 1Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)

SELECT id, value
FROM TestMultipleColumns
CROSS APPLY string_split(Name, ',')

-- 2Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)

SELECT * 
FROM TestPercent
WHERE Strs LIKE '%[%]%'

-- 3In this puzzle you will have to split a string based on dot(.).(Splitter)

SELECT id, value
FROM Splitter
CROSS APPLY string_split(Vals, '.')

-- 4Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)

SELECT TRANSLATE('1234ABC123456XYZ1234567890ADS', '123456789', 'XXXXXXXXX') as str

-- 5Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)

SELECT ID, Vals
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2

-- 6Write a SQL query to count the spaces present in the string.(CountSpaces)

SELECT texts, LEN(texts) - LEN(REPLACE(texts, ' ', '')) as space
FROM CountSpaces

-- 7write a SQL query that finds out employees who earn more than their managers.(Employee)

SELECT E1.Id, E1.Name, E1.Salary, E2.Id, E2.Name, E2.Salary
FROM Employee E1
JOIN Employee E2
ON E1.ManagerId = E2.Id
WHERE E1.Salary > E2.Salary


-- 8Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date).(Employees)

SELECT * 
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) >= 10 or DATEDIFF(YEAR, HIRE_DATE, GETDATE()) <= 15


-- Medium Tasks

-- 1Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)

SELECT 
REPLACE(TRIM(TRANSLATE('rtcfvty34redt', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', REPLICATE(' ', LEN('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')))), ' ', '') AS DIGITS,
REPLACE(TRIM(TRANSLATE('rtcfvty34redt', '0123456789', REPLICATE(' ', 10))),' ', '') AS LETTERS


-- 2write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)

SELECT W2.Id
FROM weather W1
JOIN weather W2
ON DATEDIFF(DAY, W1.RecordDate, W2.RecordDate) = 1
WHERE W2.Temperature > W1.Temperature

-- 3Write an SQL query that reports the first login date for each player.(Activity)

SELECT player_id, MIN(event_date) AS FIRSTLOGIN
FROM Activity
GROUP BY player_id

-- 4Your task is to return the third item from that list.(fruits)

WITH FRUIT AS(
    SELECT VALUE,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RN
    FROM fruits
    CROSS APPLY string_split(fruit_list, ',')
)
SELECT VALUE
FROM FRUIT 
WHERE RN =3


-- 5Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)

WITH firstn AS(
    SELECT TOP(LEN('sdgfhsdgfhs@121313131')) ROW_NUMBER() OVER (ORDER BY(SELECT NULL)) as n
    FROM sys.all_objects
),

sendn AS(
    SELECT N,
    SUBSTRING('sdgfhsdgfhs@121313131',n,1) AS CHARAK
    FROM firstn
)

SELECT * FROM sendn


-- 6You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)

SELECT P1.id,CASE WHEN P1.code = 0  THEN P2.code ELSE P1.code END AS CODE
FROM P1
JOIN p2
ON P1.id = p2.id

-- 7Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
-- If the employee has worked for less than 1 year → 'New Hire'
-- If the employee has worked for 1 to 5 years → 'Junior'
-- If the employee has worked for 5 to 10 years → 'Mid-Level'
-- If the employee has worked for 10 to 20 years → 'Senior'
-- If the employee has worked for more than 20 years → 'Veteran'(Employees)

SELECT
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsWorked,
    CASE
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;


-- 8Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)

SELECT *, CASE WHEN VALS LIKE '%[0-9]%' THEN
LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'a') - 1) ELSE NULL
END as number
FROM GetIntegers

-- Difficult Tasks

-- 1In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)

SELECT *, 
CONCAT(SUBSTRING(Vals, CHARINDEX(',', Vals) + 1, 1) ,',',
SUBSTRING(Vals, 1, 1) ,',',
SUBSTRING(Vals, CHARINDEX(',', Vals, CHARINDEX(',', Vals) + 1) + 1, 1)) as Third
FROM MultipleVals

-- 2Write a SQL query that reports the device that is first logged in for each player.(Activity)

SELECT *
FROM Activity A
WHERE event_date =(
    SELECT MIN(event_date) AS FIRSTLOG
    FROM Activity
    WHERE player_id = A.player_id
)


-- 3You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)

WITH NEW AS (
  SELECT Area, FinancialWeek, DayName, 
         ISNULL(SalesLocal, 0) + ISNULL(SalesRemote, 0) AS sales
  FROM WeekPercentagePuzzle
),

DailySales AS (
  SELECT Area, FinancialWeek, DayName, 
         SUM(sales) AS Sumsale
  FROM NEW
  GROUP BY Area, FinancialWeek, DayName
),

WeeklyTotal AS (
  SELECT Area, FinancialWeek, 
         SUM(sales) AS TotalWeekSales
  FROM NEW
  GROUP BY Area, FinancialWeek
)

SELECT 
  d.Area,
  d.FinancialWeek,
  d.DayName,
  d.Sumsale,
  IIF(w.TotalWeekSales = 0, 0, CAST(d.Sumsale * 100.0 / w.TotalWeekSales AS DECIMAL(5,2))) AS PERS
FROM DailySales d
JOIN WeeklyTotal w
  ON d.Area = w.Area AND d.FinancialWeek = w.FinancialWeek
ORDER BY d.Area, d.FinancialWeek, d.DayName;
