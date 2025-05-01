-- 🟢 Easy (10 puzzles)

-- Using Products, Suppliers table List all combinations of product names and supplier names.

SELECT p.ProductName, s.SupplierName
FROM Products p
JOIN Suppliers s
ON p.SupplierID = s.SupplierID;

-- Using Departments, Employees table Get all combinations of departments and employees.

SELECT *
FROM Departments d
JOIN Employees e
ON d.DepartmentID =  e.DepartmentID;

-- Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name

SELECT p.ProductName, s.SupplierName
FROM Products p 
JOIN Suppliers s
ON p.SupplierID = s.SupplierID;

-- Using Orders, Customers table List customer names and their orders ID.

SELECT c.FirstName , o.OrderID
FROM Customers c
JOIN Orders o
ON C.CustomerID = o.CustomerID;

-- Using Courses, Students table Get all combinations of students and courses.

SELECT * 
FROM Students s 
CROSS JOIN Courses c;

-- Using Products, Orders table Get product names and orders where product IDs match.

SELECT p.ProductName, o.OrderID
FROM Products p
JOIN Orders o
ON p.ProductID = o.ProductID;

-- Using Departments, Employees table List employees whose DepartmentID matches the department.

SELECT e.Name
FROM Employees e
JOIN Departments d
ON E.DepartmentID = D.DepartmentID;

-- Using Students, Enrollments table List student names and their enrolled course IDs.

SELECT s.Name, e.CourseID
FROM Students s
JOIN Enrollments e
ON s.StudentID = e.StudentID

-- Using Payments, Orders table List all orders that have matching payments.

SELECT o.OrderID
FROM Orders o
JOIN Payments p 
ON  o.TotalAmount = p.Amount;

-- Using Orders, Products table Show orders where product price is more than 100.

SELECT o.OrderID
FROM Orders o
JOIN Products p 
ON o.ProductID = p.ProductID
WHERE p.Price > 100;

-- 🟡 Medium (10 puzzles)

-- Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.

SELECT e.Name, d.DepartmentName
FROM Employees e
JOIN Departments d
ON  e.DepartmentID <> d.DepartmentID;

-- Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.

SELECT o.OrderID
FROM Orders o
JOIN Products p
ON o.ProductID = p.ProductID
WHERE o.Quantity > p.StockQuantity;

-- Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.

SELECT C.FirstName, S.ProductID
FROM Customers C
JOIN Sales S
ON C.CustomerID = S.CustomerID
WHERE S.SaleAmount > 500;

-- Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.

SELECT S.Name, C.CourseName
FROM Students S
JOIN Enrollments E
ON S.StudentID = E.StudentID
JOIN Courses C
ON E.CourseID = C.CourseID;

-- Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.

SELECT P.ProductName, S.SupplierName
FROM Products P
JOIN Suppliers S
ON P.SupplierID = S.SupplierID
WHERE S.SupplierName LIKE '%Tech%';

-- Using Orders, Payments table Show orders where payment amount is less than total amount.

SELECT O.OrderID
FROM Orders O
JOIN Payments P
ON O.OrderID = P.OrderID
WHERE P.Amount < O.TotalAmount;

-- Using Employees table List employee names with salaries greater than their manager’s salary.

SELECT E1.Name AS EMPLOYEE, E2.Name AS MANAGER
FROM Employees E1
JOIN Employees E2
ON E1.ManagerID = E2.EmployeeID
WHERE E1.Salary > E2.Salary;

-- Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.

SELECT ProductName
FROM Products P 
JOIN Categories C
ON P.Category = C.CategoryID
WHERE C.CategoryName IN ('ELECTRONICS','FURNITURE');

-- Using Sales, Customers table Show all sales from customers who are from 'USA'.

SELECT S.SaleAmount
FROM Sales S
JOIN Customers C
ON S.CustomerID = C.CustomerID
WHERE C.Country = 'USA';

-- Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.

SELECT O.OrderID
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE C.Country = 'GERMANY' AND O.TotalAmount > 100;

-- 🔴 Hard (5 puzzles)

-- Using Employees table List all pairs of employees from different departments.

SELECT DISTINCT E1.Name, E2.Name
FROM Employees E1
JOIN Employees E2
ON E1.DepartmentID < E2.DepartmentID
WHERE E1.DepartmentID <> E2.DepartmentID;

-- Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).

SELECT PR.ProductName, P.Amount
FROM Payments P
JOIN Orders O
ON P.OrderID = O.OrderID
JOIN Products Pr
ON O.ProductID = Pr.ProductID
WHERE p.Amount = O.Quantity * Pr.Price;

-- Using Students, Enrollments, Courses table Find students who are not enrolled in any course.

SELECT S.Name
FROM Students S
LEFT JOIN Enrollments E ON S.StudentID = E.StudentID
WHERE E.StudentID IS NULL;

-- Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.

SELECT DISTINCT E2.Name
FROM Employees E1
JOIN Employees E2
ON E1.ManagerID = E2.EmployeeID
WHERE E1.Salary <= E2.Salary;

-- Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.

SELECT C.FirstName
FROM Customers C 
JOIN Orders O 
ON C.CustomerID = O.CustomerID
LEFT JOIN Payments P 
ON O.OrderID = P.OrderID
WHERE p.OrderID IS NULL;
