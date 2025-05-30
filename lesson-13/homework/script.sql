-- Easy Tasks

-- You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.

SELECT 
    CAST(EMPLOYEE_ID AS VARCHAR) + '-' + FIRST_NAME + LAST_NAME AS FULLSMTH
FROM Employees

-- Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'

SELECT PHONE_NUMBER,
REPLACE(PHONE_NUMBER, '124', '999') as new_phone
FROM Employees

-- That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)

SELECT FIRST_NAME, LEN(FIRST_NAME) AS LENNAME
FROM Employees
WHERE LEFT(FIRST_NAME, 1) IN ('A', 'J', 'M')
ORDER BY FIRST_NAME

-- Write an SQL query to find the total salary for each manager ID.(Employees table)

SELECT MANAGER_ID, SUM(SALARY) AS TOTAL
FROM Employees
GROUP BY MANAGER_ID

-- Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table

SELECT Year1,
CASE 
    WHEN Max1 > Max2 AND Max1 > Max3 THEN Max1
    WHEN Max2 > Max1 AND Max2 > Max3 THEN Max2
    ELSE Max3
    END AS MAXN
FROM TestMax

-- Find me odd numbered movies and description is not boring.(cinema)

SELECT movie
FROM cinema
WHERE id % 2 <> 0 AND [description] <> 'BORING'

-- You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)

SELECT Id
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END , Id

-- Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)

SELECT id, 
COALESCE(ssn, passportid,itin) AS EXIST
FROM person

-- Medium Tasks

-- Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)

SELECT FullName,
LEFT(FullName, CHARINDEX(' ',  FullName) - 1) AS FIRST_NAME,
SUBSTRING(FullName, CHARINDEX(' ', FullName) + 1, CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1 ) - CHARINDEX(' ', FullName) - 1) AS  Middlename,
RIGHT(FullName, LEN(FullName) - CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1)) as lastname
FROM Students

-- For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)

SELECT *
FROM Orders 
WHERE DeliveryState = 'TX'
AND CustomerID IN(
    SELECT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
)

-- Write an SQL statement that can group concatenate the following values.(DMLTable)

SELECT 
STRING_AGG(String, ' ') WITHIN GROUP(ORDER BY SequenceNumber) AS FULLNAMES
FROM DMLTable

-- Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM Employees
WHERE LEN(LOWER(FIRST_NAME + LAST_NAME)) - LEN(REPLACE(LOWER(FIRST_NAME + LAST_NAME), 'a', '')) >= 3

-- The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)

SELECT DEPARTMENT_ID,
COUNT(*) as numofemployees,
COUNT(case when DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 END) * 100 / COUNT(*) AS PERSENT
FROM Employees
GROUP BY DEPARTMENT_ID
-- Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)

SELECT JobDescription,
MAX(MissionCount) AS MAXIMUM,
MIN(MissionCount) AS MINIMUM
FROM Personal
GROUP BY JobDescription 

-- Difficult Tasks

-- Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.


WITH T AS (
  SELECT 't' AS ch UNION ALL
  SELECT 'f' UNION ALL
  SELECT '5' UNION ALL
  SELECT '6' UNION ALL
  SELECT 's' UNION ALL
  SELECT 'd' UNION ALL
  SELECT '#' UNION ALL
  SELECT '%' UNION ALL
  SELECT 'O' UNION ALL
  SELECT 'q' UNION ALL
  SELECT 'H'
)
SELECT
  STRING_AGG(CASE WHEN ch LIKE '[A-Z]' THEN ch END, '') AS Uppercase,
  STRING_AGG(CASE WHEN ch LIKE '[a-z]' THEN ch END, '') AS Lowercase,
  STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END, '') AS Numbers,
  STRING_AGG(CASE WHEN ch NOT LIKE '[a-zA-Z0-9]' THEN ch END, '') AS Symbols
FROM T;


-- Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)

SELECT StudentID, FullName,
SUM(Grade) OVER (ORDER BY StudentID) AS TOTAL
FROM Students

-- You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)

SELECT Equation,
  CASE Equation
    WHEN '1+2+3' THEN 6
    WHEN '1+23' THEN 24
    WHEN '12+3' THEN 15
    ELSE NULL
  END AS TotalSum
FROM Equations;



-- Given the following dataset, find the students that share the same birthday.(Student Table)

SELECT StudentName, Birthday
FROM Student
WHERE Birthday IN(
    SELECT Birthday
    FROM Student
    GROUP BY Birthday
    HAVING COUNT(*) > 1
)


-- You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)

SELECT 
CASE WHEN PlayerA > PlayerB THEN PlayerA ELSE PlayerB END AS P1,
CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS P2,
SUM(Score) AS TOTALSCORE
FROM PlayerScores
GROUP BY CASE WHEN PlayerA > PlayerB THEN PlayerA ELSE PlayerB END ,
CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END 
