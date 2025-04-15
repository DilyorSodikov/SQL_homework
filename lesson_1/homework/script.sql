CREATE DATABASE SchoolDB;
USE SchoolDB;

CREATE TABLE Students(
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
);

INSERT INTO Students(StudentID, Name, Age)
VALUES (15,'Dilyor', 21);

INSERT INTO Students(StudentID, Name, Age)
VALUES (16,'Asilbek', 30);

INSERT INTO Students(StudentID, Name, Age)
VALUES (17,'Kamron', 16);

SELECT * FROM Students

-- -- BACKUP DATABASE SchoolDB
-- -- TO DISK = '/var/opt/mssql/data/SchoolDB.bak';


