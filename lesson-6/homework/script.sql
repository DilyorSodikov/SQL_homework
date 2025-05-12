-- ================================
-- Puzzle 1: Distinct Value Pairs
-- ================================

CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);

INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

-- ✅ Puzzle 1 Solution
SELECT DISTINCT
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;


-- ==========================================
-- Puzzle 2: Remove Rows Where All = 0
-- ==========================================

CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

INSERT INTO TestMultipleZero (A, B, C, D) VALUES
(0, 0, 0, 1),
(0, 0, 1, 0),
(0, 1, 0, 0),
(1, 0, 0, 0),
(0, 0, 0, 0),
(1, 1, 1, 0);

-- ✅ Puzzle 2 Solution
SELECT *
FROM TestMultipleZero
WHERE A + B + C + D <> 0;


-- ========================================
-- Puzzle 3–6: Work with 'section1' Table
-- ========================================

CREATE TABLE section1 (
    id INT,
    name VARCHAR(20)
);

INSERT INTO section1 (id, name) VALUES
(1, 'Been'),
(2, 'Roma'),
(3, 'Steven'),
(4, 'Paulo'),
(5, 'Genryh'),
(6, 'Bruno'),
(7, 'Fred'),
(8, 'Andro');

-- ✅ Puzzle 3: Odd IDs
SELECT * FROM section1
WHERE id % 2 = 1;

-- ✅ Puzzle 4: Smallest ID
SELECT TOP 1 *
FROM section1
ORDER BY id ASC;

-- ✅ Puzzle 5: Highest ID
SELECT TOP 1 *
FROM section1
ORDER BY id DESC;

-- ✅ Puzzle 6: Name starts with 'b'
SELECT * FROM section1
WHERE name LIKE 'b%';


-- ===================================
-- Puzzle 7: Find Literal Underscore
-- ===================================

CREATE TABLE ProductCodes (
    Code VARCHAR(20)
);

INSERT INTO ProductCodes (Code) VALUES
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

-- ✅ Puzzle 7 Solution: literal "_"
SELECT *
FROM ProductCodes
WHERE Code LIKE '%[_]%';
