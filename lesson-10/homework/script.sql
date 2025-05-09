-- 🟢 Easy-Level Tasks (10)

-- Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
-- 🔁 Expected Columns: EmployeeName, Salary, DepartmentName

SELECT E.Name, E.Salary, D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 50000;

-- Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
-- 🔁 Expected Columns: FirstName, LastName, OrderDate

SELECT C.FirstName, C.LastName, O.OrderDate
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
WHERE YEAR(O.OrderDate) = 2023;

-- Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
-- 🔁 Expected Columns: EmployeeName, DepartmentName

SELECT E.Name, D.DepartmentName
FROM Employees E
LEFT JOIN Departments D
ON E.DepartmentID = D.DepartmentID;

-- Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
-- 🔁 Expected Columns: SupplierName, ProductName

SELECT S.SupplierName, P.ProductName
FROM Suppliers S
LEFT JOIN Products P 
ON S.SupplierID = P.SupplierID;

-- Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
-- 🔁 Expected Columns: OrderID, OrderDate, PaymentDate, Amount

SELECT O.OrderID, O.OrderDate, P.PaymentDate, P.Amount
FROM Orders O
FULL JOIN Payments P
ON O.OrderID = P.OrderID;

-- Using the Employees table, write a query to show each employee's name along with the name of their manager.
-- 🔁 Expected Columns: EmployeeName, ManagerName

SELECT E1.Name, E2.Name AS MangerName
FROM Employees E1
JOIN Employees E2 
ON E1.ManagerID = E2.EmployeeID;

-- Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
-- 🔁 Expected Columns: StudentName, CourseName

SELECT S.Name, C.CourseName
FROM Students S 
JOIN Enrollments E 
ON S.StudentID = E.StudentID
JOIN Courses C 
ON E.CourseID = C.CourseID
WHERE C.CourseName = 'MATH 101';

-- Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
-- 🔁 Expected Columns: FirstName, LastName, Quantity

SELECT C.FirstName, C.LastName, O.Quantity
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
WHERE O.Quantity > 3;

-- Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
-- 🔁 Expected Columns: EmployeeName, DepartmentName

SELECT E.Name, D.DepartmentName
FROM Employees E
JOIN Departments D 
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'HUMAN RESOURCES';

-- 🟠 Medium-Level Tasks (9)

-- Using the Employees and Departments tables, write a query to return department names that have more than 5 employees.
-- 🔁 Expected Columns: DepartmentName, EmployeeCount

SELECT D.DepartmentName, COUNT(D.DepartmentID) AS NumEmployee
FROM Employees E
JOIN Departments D 
ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(D.DepartmentID) > 5;

-- Using the Products and Sales tables, write a query to find products that have never been sold.
-- 🔁 Expected Columns: ProductID, ProductName

SELECT P.ProductID, P.ProductName
FROM Products P
LEFT JOIN Sales S
ON P.ProductID = S.ProductID
WHERE S.SaleID IS NULL;

-- Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
-- 🔁 Expected Columns: FirstName, LastName, TotalOrders

SELECT C.FirstName, C.LastName, SUM(O.Quantity) AS TotalOrders
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
HAVING SUM(O.Quantity) IS NOT NULL;

-- Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
-- 🔁 Expected Columns: EmployeeName, DepartmentName

SELECT E.Name, D.DepartmentName
FROM Employees E
JOIN Departments D 
ON E.DepartmentID = D.DepartmentID;

-- Using the Employees table, write a query to find pairs of employees who report to the same manager.
-- 🔁 Expected Columns: Employee1, Employee2, ManagerID

SELECT DISTINCT 
    E2.Name AS Manager,
    E1.Name AS Employee1,
    E3.Name AS Employee2
FROM Employees E1
JOIN Employees E2 
ON E1.ManagerID = E2.EmployeeID
JOIN Employees E3 
ON E1.ManagerID = E3.ManagerID
WHERE E1.EmployeeID < E3.EmployeeID;

-- Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
-- 🔁 Expected Columns: OrderID, OrderDate, FirstName, LastName

SELECT O.OrderID, O.OrderDate, C.FirstName, C.LastName
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 2022;

-- Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
-- 🔁 Expected Columns: EmployeeName, Salary, DepartmentName

SELECT E.Name, E.Salary, D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales' AND E.Salary > 60000;

-- Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
-- 🔁 Expected Columns: OrderID, OrderDate, PaymentDate, Amount

SELECT O.OrderID, O.OrderDate, P.PaymentDate, P.Amount
FROM Orders O
JOIN Payments P
ON O.OrderID = P.OrderID;

-- Using the Products and Orders tables, write a query to find products that were never ordered.
-- 🔁 Expected Columns: ProductID, ProductName

SELECT P.ProductID, P.ProductName
FROM Products P
LEFT JOIN Orders O 
ON P.ProductID = O.ProductID
WHERE O.OrderID IS NULL;







-- 🔴 Hard-Level Tasks (9)

-- Using the Employees table, write a query to find employees whose salary is greater than the average salary in their own departments.
-- 🔁 Expected Columns: EmployeeName, Salary

SELECT E.Name AS EmployeeName, E.Salary
FROM Employees E
JOIN (
  SELECT DepartmentID, AVG(Salary) AS AvgSalary
  FROM Employees
  GROUP BY DepartmentID
) AS DeptAvg
ON E.DepartmentID = DeptAvg.DepartmentID
WHERE E.Salary > DeptAvg.AvgSalary;

-- Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
-- 🔁 Expected Columns: OrderID, OrderDate

SELECT O.OrderID
FROM Orders O
LEFT JOIN Payments P 
ON O.OrderID = P.OrderID
WHERE YEAR(o.OrderDate) < 2020 AND P.PaymentID IS NULL;

-- Using the Products and Categories tables, write a query to return products that do not have a matching category.
-- 🔁 Expected Columns: ProductID, ProductName

SELECT P.ProductID, P.ProductName
FROM Products P 
LEFT JOIN Categories C 
ON P.Category = C.CategoryID
WHERE C.CategoryID IS NULL;

-- Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
-- 🔁 Expected Columns: Employee1, Employee2, ManagerID, Salary

SELECT DISTINCT 
    E1.Name AS Employee1, 
    E2.Name AS Employee2, 
    E1.ManagerID AS ManagerID,
    E1.Salary AS Salary1, 
    E2.Salary AS Salary2
FROM Employees E1
JOIN Employees E2 
    ON E1.ManagerID = E2.ManagerID 
    AND E1.EmployeeID < E2.EmployeeID
WHERE E1.Salary > 60000 
  AND E2.Salary > 60000;

-- Using the Employees and Departments tables, write a query to return employees who work in departments which name starts with the letter 'M'.
-- 🔁 Expected Columns: EmployeeName, DepartmentName

SELECT E.Name
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName LIKE 'M%';

-- Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
-- 🔁 Expected Columns: SaleID, ProductName, SaleAmount

SELECT S.SaleID, P.ProductName, S.SaleAmount
FROM Sales S
JOIN Products P 
ON S.ProductID = P.ProductID
WHERE S.SaleAmount > 500;

-- Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
-- 🔁 Expected Columns: StudentID, StudentName

SELECT S.StudentID, S.Name
FROM Students S
LEFT JOIN Enrollments E 
ON S.StudentID = E.StudentID
LEFT JOIN Courses C 
ON C.CourseID = S.StudentID AND C.CourseName = 'MATH 101'
WHERE C.CourseName IS NULL;

-- Using the Orders and Payments tables, write a query to return orders that are missing payment details.
-- 🔁 Expected Columns: OrderID, OrderDate, PaymentID

SELECT O.OrderID, O.OrderDate, P.PaymentID
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL


-- Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
-- 🔁 Expected Columns: ProductID, ProductName, CategoryName

SELECT P.ProductID, P.ProductName, C.CategoryName
FROM Products P
JOIN Categories C
ON P.Category = C.CategoryID
WHERE C.CategoryName IN ('ELECTRONICS', 'FURNITURE')
