CREATE DATABASE HOMEWORK_22

CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

--     Easy Questions

-- Compute Running Total Sales per Customer

SELECT 
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales_data
ORDER BY customer_id, order_date;


-- Count the Number of Orders per Product Category

SELECT 
    product_category, 
    COUNT(*) AS order_count
FROM sales_data
GROUP BY product_category;


-- Find the Maximum Total Amount per Product Category

SELECT 
    product_category,
    MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category;


-- Find the Minimum Price of Products per Product Category

SELECT 
    product_category,
    MIN(unit_price) AS min_unit_price
FROM sales_data
GROUP BY product_category;


-- Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

SELECT 
    sale_id,
    order_date,
    customer_id,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg
FROM sales_data;


-- Find the Total Sales per Region

SELECT 
    region,
    SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;


-- Compute the Rank of Customers Based on Their Total Purchase Amount

WITH CustomerTotals AS (
    SELECT 
        customer_id,
        customer_name,
        SUM(total_amount) AS total_spent
    FROM sales_data
    GROUP BY customer_id, customer_name
)
SELECT *,
       RANK() OVER (ORDER BY total_spent DESC) AS customer_rank
FROM CustomerTotals;


-- Calculate the Difference Between Current and Previous Sale Amount per Customer

SELECT 
    customer_id,
    order_date,
    total_amount,
    total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_from_prev
FROM sales_data;


-- Find the Top 3 Most Expensive Products in Each Category

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rn
    FROM sales_data
) t
WHERE rn <= 3;


-- Compute the Cumulative Sum of Sales Per Region by Order Date

SELECT 
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- Compute Cumulative Revenue per Product Category

SELECT 
    product_category,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM sales_data;

-- Here you need to find out the sum of previous values. Please go through the sample input and expected output.

WITH t(ID) AS (
    SELECT 1 UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5
)
SELECT 
    ID,
    SUM(ID) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumPreValues
FROM t;

--Sum of Previous Values to Current Value

CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT 
    Value,
    SUM(Value) OVER (
        ORDER BY Value 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS [Sum of Previous]
FROM OneColumn;



-- Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.For more details please check the sample input and expected output.
CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);
INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');

SELECT 
    Id,
    Vals,
    ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) * 1 + 
    DENSE_RANK() OVER (ORDER BY Id) * 2 - 1 AS RowNumber
FROM Row_Nums;



-- Find customers who have purchased items from more than one product_category

SELECT customer_id
FROM sales_data
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) > 1;


-- Find Customers with Above-Average Spending in Their Region

WITH RegionalAvg AS (
    SELECT region, AVG(total_amount) AS avg_amount
    FROM sales_data
    GROUP BY region
)
SELECT s.*
FROM sales_data s
JOIN RegionalAvg r ON s.region = r.region
WHERE s.total_amount > r.avg_amount;


-- Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.

WITH CustomerRegionSpend AS (
    SELECT 
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS total_spent
    FROM sales_data
    GROUP BY customer_id, customer_name, region
)
SELECT *,
       RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS regional_rank
FROM CustomerRegionSpend;


-- Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

SELECT 
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id ORDER BY order_date
    ) AS cumulative_sales
FROM sales_data;


-- Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

WITH MonthlySales AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS sales_month,
        SUM(total_amount) AS monthly_sales
    FROM sales_data
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT *,
       LAG(monthly_sales) OVER (ORDER BY sales_month) AS prev_month_sales,
       ROUND(
           (monthly_sales - LAG(monthly_sales) OVER (ORDER BY sales_month)) * 100.0 /
           NULLIF(LAG(monthly_sales) OVER (ORDER BY sales_month), 0), 2
       ) AS growth_rate
FROM MonthlySales;


-- Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)

SELECT 
    customer_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
FROM sales_data
WHERE total_amount > LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date);


-- Hard Questions

-- Identify Products that prices are above the average product price

WITH AvgPrice AS (
    SELECT AVG(unit_price) AS avg_price
    FROM sales_data
)
SELECT *
FROM sales_data, AvgPrice
WHERE unit_price > avg_price;

-- In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

SELECT 
    Id, Grp, Val1, Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData;



-- Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

SELECT 
    Id,
    SUM(Cost) AS Cost,
    SUM(DISTINCT Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY Id;



-- From following set of integers, write an SQL statement to determine the expected outputs
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54);

WITH Ordered AS (
    SELECT SeatNumber,
           LAG(SeatNumber) OVER (ORDER BY SeatNumber) AS PrevSeat
    FROM Seats
),
Gaps AS (
    SELECT 
        PrevSeat + 1 AS GapStart,
        SeatNumber - 1 AS GapEnd
    FROM Ordered
    WHERE SeatNumber - PrevSeat > 1
)
SELECT * FROM Gaps;



-- In this puzzle you need to generate row numbers for the given data. The condition is that the first row number for every partition should be even number.For more details please check the sample input and expected output.

WITH Numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn,
           DENSE_RANK() OVER (ORDER BY Id) AS grp_rank
    FROM Row_Nums
)
SELECT 
    Id,
    Vals,
    rn + (grp_rank - 1) * 2 + 1 AS Changed
FROM Numbered;
