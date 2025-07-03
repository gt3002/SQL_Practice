-- Create a test database (optional)
DROP DATABASE JoinPracticeDB;
CREATE DATABASE TestDB;
GO
USE TestDB;
GO

-- Drop table if exists
IF OBJECT_ID('dbo.Employees') IS NOT NULL
    DROP TABLE dbo.Employees;
GO

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Age INT,
    Department NVARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE,
    IsActive BIT
);
GO



-- Insert sample data
INSERT INTO Employees VALUES
(1, 'Alice', 'Johnson', 28, 'HR', 50000, '2020-01-15', 1),
(2, 'Bob', 'Smith', 35, 'Finance', 75000, '2019-03-12', 1),
(3, 'Charlie', 'Lee', 40, 'IT', 90000, '2015-06-01', 0),
(4, 'Diana', 'Martinez', 25, 'Marketing', 45000, '2022-08-10', 1),
(5, 'Evan', 'Clark', 50, 'Finance', 120000, '2010-10-23', 0),
(6, 'Fiona', 'Garcia', 30, 'HR', 52000, '2021-11-05', 1),
(7, 'George', 'Lopez', 38, 'IT', 85000, '2018-04-20', 1),
(8, 'Hannah', 'Adams', 27, 'Marketing', 47000, '2023-02-14', 1),
(9, 'Ian', 'Wright', 45, 'IT', 110000, '2012-07-19', 0),
(10, 'Julia', 'Chen', 32, 'Finance', 68000, '2020-12-01', 1);
GO

-------------------------------------------------------------------
  SELECT * FROM Employees;

--Find employees who are older than 30 and work in IT.
  Select FirstName FROM Employees WHERE Age>30 AND Department='IT';

--Get all employees in HR or Marketing departments.
  Select FirstName FROM Employees WHERE Department='HR' OR Department='Marketing';

--Retrieve employees who are active and earn more than 60,000.
  Select * FROM Employees WHERE IsActive=1 AND Salary>60000;

--List inactive employees in the Finance department.
   Select * FROM Employees WHERE Department='Finance' AND IsActive=0;

--Find employees who are not in IT or HR.
  SELECT * FROM Employees WHERE Department NOT IN ('IT', 'HR');  ---recommended not exists/ does not exists

 --Get employees earning more than 70,000.
  Select * FROM Employees WHERE Salary>70000;

--List employees who are not in the Marketing department.
  SELECT * FROM Employees WHERE Department != 'Marketing';

--Find employees hired before 2019.
  SELECT * FROM Employees WHERE HireDate < '01-01-2019';

--Show employees aged less than or equal to 30.
 SELECT * FROM Employees WHERE Age<=30;
 
--List employees with a salary equal to 85000.
SELECT * FROM Employees WHERE Salary=85000;

--Find employees with salary not equal to 50000.
SELECT * FROM Employees WHERE Salary<>50000;

--Show employees whose age is greater than 35.
SELECT * FROM Employees WHERE Age>35;

--Find employees who were hired after 2021.
SELECT * FROM Employees WHERE HireDate > '2021-12-31';

--Get employees where IsActive = 1.
SELECT * FROM Employees WHERE IsActive=1;

--List employees where FirstName = 'Alice'.
SELECT * FROM Employees WHERE FirstName='Alice'

--Find employees whose first name starts with 'A'.
SELECT * FROM Employees WHERE FirstName LIKE 'A%';

--List employees whose last name ends with 'z'.
SELECT * FROM Employees WHERE LastName LIKE '%z';


--Show employees whose first name contains 'an'.
SELECT * FROM Employees WHERE FirstName LIKE '%An%';

--Find employees whose last name includes the letter 'e'.
SELECT * FROM Employees WHERE LastName LIKE '%e%';

--Get employees whose department name starts with 'F'.
SELECT * FROM Employees WHERE Department LIKE 'F%';

--Retrieve employees whose first name does not contain 'i'.
SELECT * FROM Employees WHERE FirstName NOT LIKE '%i%';

--Find employees whose first name has 'o' as the second letter.
SELECT * FROM Employees WHERE FirstName LIKE '_o%';

--Show employees whose last name is exactly 5 characters long.
SELECT * FROM Employees WHERE LEN(LastName)=5;

--List employees whose names begin with ‘J’ and end with ‘a’.
SELECT * FROM Employees WHERE FirstName LIKE 'J%' AND FirstName LIKE '%a';

--Get employees whose salary is between 60,000 and 90,000.
SELECT * FROM Employees WHERE Salary BETWEEN 68000 AND 85000;


--Find employees aged between 30 and 40.
SELECT * FROM Employees WHERE Age BETWEEN 30 AND 40;

--Show employees hired between 2018-01-01 and 2021-12-31.
SELECT * FROM Employees WHERE HireDate BETWEEN '2018-01-01' AND '2021-12-31';

--Find employees with age not between 30 and 40.
SELECT * FROM Employees WHERE Age NOT BETWEEN 30 AND 40;

--Get employees whose salary is not between 45000 and 80000.
SELECT * FROM Employees WHERE Salary NOT BETWEEN 45000 AND 80000;

--List employees in IT department with salary over 100,000.
SELECT * FROM Employees WHERE Department='IT' AND Salary<=100000;

--Find employees aged under 30 who are in HR.
SELECT * FROM Employees WHERE Age<30 AND Department='HR';

--Get inactive employees hired before 2015.
SELECT * FROM Employees WHERE HireDate<'2015-01-01' AND IsActive=0;

--List active employees whose first name contains ‘e’.
SELECT * FROM Employees WHERE IsActive=1 AND FirstName LIKE '%e%';

--Find Finance employees earning more than 60,000 and active.
SELECT * FROM Employees WHERE HireDate<'2015-01-01' AND IsActive=0;

--Show Marketing employees not hired in 2022.
SELECT * FROM Employees WHERE HireDate <'2022-01-01' AND HireDate >'2022-12-31';

--Get employees hired after 2020 who are under 35 years old.
SELECT * FROM Employees WHERE Age < 35 AND YEAR(HireDate) > 2020;

--Retrieve employees in HR or Finance with salary under 60,000.
SELECT * FROM Employees WHERE Salary < 60000 AND Department='HR' OR Department='Finance';


--List employees with first name containing 'ia' and aged over 30.
SELECT * FROM Employees WHERE Age <= 30 AND FirstName LIKE '%ia%';

--Find employees in IT or Marketing and salary above 80,000.
SELECT * FROM Employees WHERE Salary > 80000  AND Department='IT' OR Department='Marketing';

--Get employees hired between 2010 and 2020 and inactive.
SELECT * FROM Employees WHERE IsActive = 1 AND (YEAR(HireDate) BETWEEN 2010 AND 2020);


--Show employees who are either in HR or have a salary over 100,000.
SELECT * FROM Employees WHERE Department='HR' OR Salary <=100000

--List all employees except those in IT or with salary > 100,000.
SELECT * FROM Employees WHERE Department !='IT' AND Salary < 100000;

--Retrieve active employees with even-numbered ages.
SELECT * FROM Employees WHERE Age%2 = 0;

--Find employees whose last name includes both 'a' and 'z'.
SELECT * FROM Employees WHERE LastName LIKE 'a' AND LastName LIKE 'h';

--Show employees who joined on Valentine's Day.
SELECT * FROM Employees WHERE DAY(HireDate)=14 AND MONTH(HireDate) = 02;

--Find all employees whose salary is a round number (ends in 000).
SELECT * FROM Employees WHERE Salary LIKE '%000.00';

--List employees in HR whose names start with 'F' or 'A'.
SELECT * FROM Employees WHERE Department='HR' AND FirstName LIKE 'F%' OR FirstName LIKE 'A%';

--Get employees aged 35 or above and not in Finance.
SELECT * FROM Employees WHERE Age > 35 AND Department != 'Finance';

--Find employees with salary not in the range of 45k to 70k and hired after 2019.
SELECT * FROM Employees WHERE HireDate > '2019-12-31' AND (Salary < 450000 OR Salary > 70000);

 