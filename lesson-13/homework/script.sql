-- Easy Tasks

-- You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.

SELECT CONCAT(EMPLOYEE_ID,'-',FIRST_NAME,' ',LAST_NAME) AS info
FROM Employees

-- Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'

SELECT REPLACE(PHONE_NUMBER, '124', '999') AS NEWNUMB
FROM Employees

-- That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)

SELECT FIRST_NAME, LEN(FIRST_NAME) AS 'LEN'
FROM Employees
WHERE 
    FIRST_NAME LIKE 'A%' OR
    FIRST_NAME LIKE 'J%' OR
    FIRST_NAME LIKE 'M%'
ORDER BY FIRST_NAME

-- Write an SQL query to find the total salary for each manager ID.(Employees table)

SELECT MANAGER_ID, SUM(SALARY) AS TOTALSALARY
FROM Employees
GROUP BY MANAGER_ID

-- Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table

SELECT YEAR1, 
CASE 
    WHEN Max1 < Max3 AND Max2 < Max3 THEN Max3
    WHEN Max2 < Max1 AND Max3 < Max1 THEN Max1
    ELSE Max2 
    END AS MAXVAL
FROM TestMax

-- Find me odd numbered movies and description is not boring.(cinema)

SELECT id, [description]
FROM cinema
WHERE id%2 = 1 AND [description] <> 'BORING'

-- You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)

SELECT Id
FROM SingleOrder
ORDER BY CASE 
            WHEN Id=0 THEN 1 ELSE 0 END, Id

-- Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)

SELECT id, COALESCE(ssn, passportid, itin) AS NEWCOL
FROM person

-- Medium Tasks

-- Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)

SELECT 
  StudentID,
  FullName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS Firstname,
  PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS Middlename,
  PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS Lastname
FROM Students;


-- For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)

SELECT CustomerID, OrderID, DeliveryState
FROM Orders 
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
)
AND DeliveryState = 'TX'


-- Write an SQL statement that can group concatenate the following values.(DMLTable)

SELECT STRING_AGG(String, ' ') 
       WITHIN GROUP (ORDER BY SequenceNumber) AS Result
FROM DMLTable;



-- Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.

SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS FULLNAME
FROM Employees
WHERE (LEN(LOWER(CONCAT(FIRST_NAME,' ',LAST_NAME))) - LEN(REPLACE(LOWER(CONCAT(FIRST_NAME,' ',LAST_NAME)), 'a', ''))) > 3

-- The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS NUMOFEMPL
FROM Employees
WHERE DATEDIFF(DAY, HIRE_DATE, GETDATE() )/ 365 >= 3
GROUP BY DEPARTMENT_ID

-- Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)

SELECT JobDescription,
    (SELECT TOP 1 SpacemanID
    FROM Personal P1
    WHERE P1.JobDescription = P.JobDescription
    ORDER BY MissionCount ASC) AS MINCOUNT,

    (SELECT TOP 1 SpacemanID
    FROM Personal P2
    WHERE P2.JobDescription = P.JobDescription
    ORDER BY MissionCount  DESC) AS MAXCOUNT
FROM Personal P
GROUP BY JobDescription
ORDER BY JobDescription

SELECT * FROM Personal


-- Difficult Tasks

-- Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < LEN('tf56sd#%OqH')
),
Chars AS (
    SELECT 
        SUBSTRING('tf56sd#%OqH', n, 1) AS ch,
        ASCII(SUBSTRING('tf56sd#%OqH', n, 1)) AS code
    FROM Numbers
)
SELECT
    STRING_AGG(CASE WHEN code BETWEEN 65 AND 90 THEN ch END, '') AS Uppercase,
    STRING_AGG(CASE WHEN code BETWEEN 97 AND 122 THEN ch END, '') AS Lowercase,
    STRING_AGG(CASE WHEN code BETWEEN 48 AND 57 THEN ch END, '') AS Digits,
    STRING_AGG(CASE 
                 WHEN code NOT BETWEEN 48 AND 57 
                      AND code NOT BETWEEN 65 AND 90 
                      AND code NOT BETWEEN 97 AND 122 
               THEN ch END, '') AS Others
FROM Chars
OPTION (MAXRECURSION 100);


-- Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)


SELECT 
    StudentID,
    FullName,
    Grade,
    SUM(Grade) OVER (ORDER BY StudentID) AS running_total
FROM Students;

-- You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)



-- Given the following dataset, find the students that share the same birthday.(Student Table)

SELECT s.*
FROM Student s
JOIN (
    SELECT Birthday
    FROM Student
    GROUP BY Birthday
    HAVING COUNT(*) > 1
) dup ON s.Birthday = dup.Birthday;


-- You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)

SELECT 
  LEAST(PlayerA, PlayerB) AS Player1,
  GREATEST(PlayerA, PlayerB) AS Player2,
  SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
  LEAST(PlayerA, PlayerB), 
  GREATEST(PlayerA, PlayerB);
