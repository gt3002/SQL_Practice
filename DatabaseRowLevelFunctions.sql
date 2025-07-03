-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(100)
);

-- Insert sample data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES
(1, 'Finance', 'Mumbai'),
(2, 'Engineering', 'Bangalore'),
(3, 'Human Resources', 'Delhi'),
(4, 'Marketing', 'Hyderabad'),
(5, 'Sales', 'Chennai');

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Salary DECIMAL(10,2),
    DateOfJoining DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert sample data into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, Salary, DateOfJoining, DepartmentID) VALUES
(101, 'Rahul', 'Sharma', 'rahul.sharma@example.com', '+91-9876543210', 75000.50, '2019-03-15', 2),
(102, 'Anita', 'Verma', 'anita.verma@example.com', '+91-9876543211', 68000.00, '2020-07-01', 1),
(103, 'Suresh', 'Patil', 'suresh.patil@example.com', NULL, 72000.75, '2018-01-12', 3),
(104, 'Geeta', 'Iyer', 'geeta.iyer@example.com', '+91-9876543212', NULL, '2021-11-30', 2),
(105, 'Karan', 'Mehta', NULL, '+91-9876543213', 54000.00, '2017-06-18', 5),
(106, 'Pooja', 'Singh', 'pooja.singh@example.com', '+91-9876543214', 82000.25, '2022-02-10', 4),
(107, 'Amit', 'Joshi', 'amit.joshi@example.com', NULL, 61000.00, '2023-09-05', 2),
(108, 'Neha', 'Rao', 'neha.rao@example.com', '+91-9876543215', 59000.90, '2016-12-25', 1),
(109, 'Vikram', 'Desai', NULL, '+91-9876543216', NULL, '2015-10-20', 3),
(110, 'Sneha', 'Kapoor', 'sneha.kapoor@example.com', '+91-9876543217', 67000.00, '2019-08-14', 4);

-------------------------------------------------------------------------------------------------------------------------

--Get the full name of each employee in uppercase.
SELECT UPPER(CONCAT(FirstName,' ',LastName)) AS Full_Name FROM Employees;

--Get the length of each employee’s full name.
SELECT EmployeeID, LEN(CONCAT(FirstName,' ',LastName)) AS Lenght_Of_Name FROM Employees;

--Get only the domain part from each employee's email.********************
SELECT EmployeeID, SUBSTRING(Email,CHARINDEX('@', Email) + 1, LEN(Email)) FROM Employees;

--Replace all dots in email addresses with underscores.
SELECT EmployeeID, REPLACE(Email,'.','_') AS New_Email_Format FROM Employees;

--Trim any leading or trailing spaces from first names.
SELECT FirstName,TRIM(FirstName) AS Without_Spaces FROM Employees;

--Find employees whose last name starts with 'S'.
SELECT FirstName,LastName FROM Employees WHERE LEFT(FirstName,1) = 'S';

--Find employees whose email contains 'example'.********************************
SELECT FirstName,LastName FROM Employees ;


--Return the first three letters of each first name.
SELECT FirstName, LEFT(TRIM(FirstName),3) AS first_3_letters FROM Employees;

--Find the position of '@' in each email. (hint: CHARINDEX)
SELECT EmployeeID, CHARINDEX('@', Email) FROM Employees;


--Concatenate first name and last name with a space in between.
SELECT CONCAT(FirstName,' ',LastName) AS FullName FROM Employees;

--Find employees whose last name ends with 'a'.
SELECT FirstName,LastName FROM Employees
WHERE RIGHT(LastName,LEN(LastName)) = 'a';

--Get only the first name in lowercase.
SELECT LOWER(FirstName) as FIRST_NAME FROM EMPLOYEES;

-- Get the number of characters in email addresses
SELECT EmployeeID, LEN(Email) AS EmailLength FROM Employees;

-- Find employees with no email assigned
SELECT * FROM Employees WHERE Email IS NULL;

-- Replace the country code in phone numbers with just the number
SELECT EmployeeID, 
       REPLACE(Phone, '+91-', '') AS PhoneWithoutCountryCode 
FROM Employees;

-- Extract first name initials
SELECT EmployeeID, LEFT(FirstName, 1) AS FirstInitial FROM Employees;

-- Find position of '@' in emails using PATINDEX
SELECT EmployeeID, PATINDEX('%@%', Email) AS AtPosition FROM Employees;

-- Remove all hyphens from phone numbers
SELECT EmployeeID, REPLACE(Phone, '-', '') AS PhoneWithoutHyphens FROM Employees;

-- Get last name reversed
SELECT EmployeeID, REVERSE(LastName) AS ReversedLastName FROM Employees;

-- Get first and last three characters of last names
SELECT EmployeeID, 
       LEFT(LastName, 3) AS FirstThree, 
       RIGHT(LastName, 3) AS LastThree 
FROM Employees;

-- Round off salaries to nearest 100
SELECT EmployeeID, ROUND(Salary, -2) AS SalaryRoundedToHundred FROM Employees;

-- Get absolute value of salary differences from 70000
SELECT EmployeeID, ABS(Salary - 70000) AS SalaryDifference FROM Employees;

-- Get square root of salaries
SELECT EmployeeID, SQRT(Salary) AS SalarySquareRoot FROM Employees;

-- Ceiling value of salaries
SELECT EmployeeID, CEILING(Salary) AS SalaryCeil FROM Employees;

-- Floor value of salaries
SELECT EmployeeID, FLOOR(Salary) AS SalaryFloor FROM Employees;

-- Square of salaries
SELECT EmployeeID, POWER(Salary, 2) AS SalarySquared FROM Employees;

-- Return PI()
SELECT PI() AS PI_Value;

-- Generate random number per row
SELECT EmployeeID, RAND(CHECKSUM(NEWID())) AS RandomValue FROM Employees;

-- Multiply salary by 1.10 (10% hike)
SELECT EmployeeID, Salary * 1.10 AS SalaryAfterHike FROM Employees;

-- Divide salary by 30 to get per day salary
SELECT EmployeeID, Salary / 30 AS PerDaySalary FROM Employees;

-- Modulus of EmployeeID by 2
SELECT EmployeeID, EmployeeID % 2 AS ModulusResult FROM Employees;

-- Average salary
SELECT AVG(Salary) AS AverageSalary FROM Employees;

-- Min, Max, Sum of salaries
SELECT MIN(Salary) AS MinSalary, MAX(Salary) AS MaxSalary, SUM(Salary) AS TotalSalaries FROM Employees;

-- Employees with salary greater than average salary
SELECT * FROM Employees WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- Rounded salary to 2 decimal places
SELECT EmployeeID, ROUND(Salary, 2) AS RoundedSalary FROM Employees;

-- Extract year, month, day from DateOfJoining
SELECT EmployeeID, 
       YEAR(DateOfJoining) AS JoinYear, 
       MONTH(DateOfJoining) AS JoinMonth, 
       DAY(DateOfJoining) AS JoinDay 
FROM Employees;

-- Name of the day (Monday, etc.)
SELECT EmployeeID, DATENAME(WEEKDAY, DateOfJoining) AS DayName FROM Employees;

-- Employees joined in last 3 years
SELECT * FROM Employees WHERE DateOfJoining >= DATEADD(YEAR, -3, GETDATE());

-- Number of days since joining
SELECT EmployeeID, DATEDIFF(DAY, DateOfJoining, GETDATE()) AS DaysSinceJoining FROM Employees;

-- Employees who joined on weekend
SELECT * FROM Employees WHERE DATENAME(WEEKDAY, DateOfJoining) IN ('Saturday', 'Sunday');

-- Add 100 days to joining date
SELECT EmployeeID, DATEADD(DAY, 100, DateOfJoining) AS After100Days FROM Employees;

-- Subtract 100 days from joining date
SELECT EmployeeID, DATEADD(DAY, -100, DateOfJoining) AS Before100Days FROM Employees;

-- End of month for joining date
SELECT EmployeeID, EOMONTH(DateOfJoining) AS EndOfJoiningMonth FROM Employees;

-- Truncate date to start of year
SELECT EmployeeID, DATETRUNC(YEAR, DateOfJoining) AS StartOfYear FROM Employees;

-- Experience in years
SELECT EmployeeID, DATEDIFF(YEAR, DateOfJoining, GETDATE()) AS ExperienceYears FROM Employees;

-- Quarter of joining
SELECT EmployeeID, DATEPART(QUARTER, DateOfJoining) AS JoinQuarter FROM Employees;

-- Current date and time
SELECT GETDATE() AS CurrentDateTime;

-- Format date as dd-mm-yyyy
SELECT EmployeeID, FORMAT(DateOfJoining, 'dd-MM-yyyy') AS FormattedDate FROM Employees;

-- Format DateOfJoining as mm/dd/yyyy
SELECT EmployeeID, CONVERT(VARCHAR(10), DateOfJoining, 101) AS USFormatDate FROM Employees;

-- FORMAT to 'MMM yyyy'
SELECT EmployeeID, FORMAT(DateOfJoining, 'MMM yyyy') AS MonthYear FROM Employees;

-- Time difference in minutes
SELECT EmployeeID, DATEDIFF(MINUTE, DateOfJoining, GETDATE()) AS MinutesSinceJoining FROM Employees;

-- Employees who joined in same month as today
SELECT * FROM Employees WHERE MONTH(DateOfJoining) = MONTH(GETDATE());

-- Show date in yyyy-MM-dd format
SELECT EmployeeID, FORMAT(DateOfJoining, 'yyyy-MM-dd') AS ISODate FROM Employees;

-- Extract only month name
SELECT EmployeeID, DATENAME(MONTH, DateOfJoining) AS MonthName FROM Employees;

-- First day of joining month
SELECT EmployeeID, DATEFROMPARTS(YEAR(DateOfJoining), MONTH(DateOfJoining), 1) AS FirstDayOfMonth FROM Employees;

-- Last day of joining year
SELECT EmployeeID, EOMONTH(DATEFROMPARTS(YEAR(DateOfJoining), 12, 1)) AS LastDayOfYear FROM Employees;

-- Employees who joined this year
SELECT * FROM Employees WHERE YEAR(DateOfJoining) = YEAR(GETDATE());

-- Joining date as "dd MMMM, yyyy"
SELECT EmployeeID, FORMAT(DateOfJoining, 'dd MMMM, yyyy') AS FancyDate FROM Employees;

-- Show month and year together
SELECT EmployeeID, FORMAT(DateOfJoining, 'MMMM yyyy') AS MonthYearFormat FROM Employees;

-- Anniversary today (day and month match)
SELECT * FROM Employees WHERE DAY(DateOfJoining) = DAY(GETDATE()) AND MONTH(DateOfJoining) = MONTH(GETDATE());

-- Add 6 months to joining date
SELECT EmployeeID, DATEADD(MONTH, 6, DateOfJoining) AS After6Months FROM Employees;

-- Subtract 3 years from joining date
SELECT EmployeeID, DATEADD(YEAR, -3, DateOfJoining) AS Before3Years FROM Employees;

-- Weekday name of joining
SELECT EmployeeID, DATENAME(WEEKDAY, DateOfJoining) AS WeekDay FROM Employees;

-- ISO week number
SELECT EmployeeID, DATEPART(ISOWK, DateOfJoining) AS ISOWeek FROM Employees;

-- Full formatted string: "Joined on 15th March, 2019 (Friday)"
SELECT EmployeeID, 
       'Joined on ' + FORMAT(DateOfJoining, 'dd') + ' ' +
       DATENAME(MONTH, DateOfJoining) + ', ' + 
       FORMAT(DateOfJoining, 'yyyy') + 
       ' (' + DATENAME(WEEKDAY, DateOfJoining) + ')' AS JoinFullFormat 
FROM Employees;

-- Convert salary to VARCHAR and append "INR"
SELECT EmployeeID, CAST(Salary AS VARCHAR) + ' INR' AS SalaryString FROM Employees;

-- Convert DateOfJoining to string
SELECT EmployeeID, CAST(DateOfJoining AS VARCHAR) AS JoiningDateString FROM Employees;

-- Convert "100.25" to decimal
SELECT CAST('100.25' AS DECIMAL(10,2)) AS ConvertedDecimal;

-- Format date using CONVERT
SELECT EmployeeID, CONVERT(VARCHAR, DateOfJoining, 103) AS FormattedDate FROM Employees; -- dd/mm/yyyy

-- Convert NULL emails to "No Email Provided"
SELECT EmployeeID, ISNULL(Email, 'No Email Provided') AS EmailFixed FROM Employees;

-- Convert phone number to INT (error if non-numeric)
SELECT EmployeeID, TRY_CAST(REPLACE(Phone, '+91-', '') AS INT) AS PhoneAsInt FROM Employees;

-- Cast EmployeeID to VARCHAR and concatenate with name
SELECT CAST(EmployeeID AS VARCHAR) + ' - ' + FirstName + ' ' + LastName AS EmployeeInfo FROM Employees;

-- Add time '09:00:00' to date
SELECT EmployeeID, DATEADD(SECOND, 0, CAST(DateOfJoining AS DATETIME)) + '09:00:00' AS FullDatetime FROM Employees;

-- Cast salary to INT and compare
SELECT EmployeeID, Salary, CAST(Salary AS INT) AS SalaryInt FROM Employees;

-- Difference between CAST and CONVERT (both can change data types, but CONVERT has more formatting options)
SELECT CAST(Salary AS VARCHAR) AS Casted, CONVERT(VARCHAR, Salary) AS Converted FROM Employees;

-- Count employees with NULL salary
SELECT COUNT(*) AS NullSalaryCount FROM Employees WHERE Salary IS NULL;

-- Replace NULL phone with 'N/A'
SELECT EmployeeID, ISNULL(Phone, 'N/A') AS FixedPhone FROM Employees;

-- Use ISNULL to calculate total salaries
SELECT SUM(ISNULL(Salary, 0)) AS TotalSalaries FROM Employees;

-- Use COALESCE for emails
SELECT EmployeeID, COALESCE(Email, 'No Email') AS EmailAddress FROM Employees;

-- Compare ISNULL vs COALESCE
SELECT EmployeeID, ISNULL(NULL, COALESCE(NULL, 'Default')) AS Result FROM Employees;

-- Employees with NULL phone or email
SELECT * FROM Employees WHERE Phone IS NULL OR Email IS NULL;

-- NULLIF example
SELECT EmployeeID, NULLIF(Salary, 0) AS NullIfZeroSalary FROM Employees;

-- ISNULL to calculate average salary
SELECT AVG(ISNULL(Salary, 0)) AS AvgIncludingNulls FROM Employees;

-- Employees where Salary is NOT NULL
SELECT * FROM Employees WHERE Salary IS NOT NULL;

-- 'Missing' for NULL email when concatenating names
SELECT EmployeeID, FirstName + ' ' + LastName + ' - ' + ISNULL(Email, 'Missing') AS EmployeeDetails FROM Employees;

-- Formatted string: "Rahul Sharma from Engineering earns 75K"
SELECT e.FirstName + ' ' + e.LastName + ' from ' + d.DepartmentName + ' earns ' + CAST(CAST(Salary/1000 AS INT) AS VARCHAR) + 'K' AS Summary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Experience in complete years and months
SELECT EmployeeID, 
       DATEDIFF(YEAR, DateOfJoining, GETDATE()) AS Years,
       DATEDIFF(MONTH, DateOfJoining, GETDATE()) % 12 AS Months
FROM Employees;

-- Department-wise average salary
SELECT d.DepartmentName, AVG(e.Salary) AS AverageSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- Employees with more than average experience
SELECT * 
FROM Employees
WHERE DATEDIFF(YEAR, DateOfJoining, GETDATE()) > (SELECT AVG(DATEDIFF(YEAR, DateOfJoining, GETDATE())) FROM Employees);

-- How many employees missing phone/email/salary
SELECT 
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS MissingPhone,
    SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS MissingEmail,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS MissingSalary
FROM Employees;

-- Employees joined before 2020 and NULL email
SELECT * FROM Employees WHERE DateOfJoining < '2020-01-01' AND Email IS NULL;

-- Salary formatted with commas
SELECT EmployeeID, FORMAT(Salary, 'N2') AS FormattedSalary FROM Employees;

-- Employees with phone numbers containing '9876'
SELECT * FROM Employees WHERE Phone LIKE '%9876%';

-- Department name along with employees
SELECT e.*, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Employees joined per quarter
SELECT DATEPART(QUARTER, DateOfJoining) AS Quarter, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DATEPART(QUARTER, DateOfJoining);

-- First and last character of last name
SELECT EmployeeID, LEFT(LastName, 1) AS FirstChar, RIGHT(LastName, 1) AS LastChar FROM Employees;

-- LEN vs DATALENGTH
SELECT EmployeeID, LEN(FirstName) AS LengthChars, DATALENGTH(FirstName) AS DataBytes FROM Employees;

-- Joining date formatted like 15 March 2019
SELECT EmployeeID, FORMAT(DateOfJoining, 'dd MMMM yyyy') AS FormattedJoinDate FROM Employees;

-- Employees whose names have vowels only
SELECT * FROM Employees WHERE FirstName NOT LIKE '%[^aeiouAEIOU]%';

-- Employees who joined same month as today
SELECT * FROM Employees WHERE MONTH(DateOfJoining) = MONTH(GETDATE());

-- -- Convert salary to VARCHAR and append "INR"
SELECT EmployeeID, CAST(Salary AS VARCHAR) + ' INR' AS SalaryString FROM Employees;

-- Convert DateOfJoining to string
SELECT EmployeeID, CAST(DateOfJoining AS VARCHAR) AS JoiningDateString FROM Employees;

-- Convert "100.25" to decimal
SELECT CAST('100.25' AS DECIMAL(10,2)) AS ConvertedDecimal;

-- Format date using CONVERT
SELECT EmployeeID, CONVERT(VARCHAR, DateOfJoining, 103) AS FormattedDate FROM Employees; -- dd/mm/yyyy

-- Convert NULL emails to "No Email Provided"
SELECT EmployeeID, ISNULL(Email, 'No Email Provided') AS EmailFixed FROM Employees;

-- Convert phone number to INT (error if non-numeric)
SELECT EmployeeID, TRY_CAST(REPLACE(Phone, '+91-', '') AS INT) AS PhoneAsInt FROM Employees;

-- Cast EmployeeID to VARCHAR and concatenate with name
SELECT CAST(EmployeeID AS VARCHAR) + ' - ' + FirstName + ' ' + LastName AS EmployeeInfo FROM Employees;

-- Add time '09:00:00' to date
SELECT EmployeeID, DATEADD(SECOND, 0, CAST(DateOfJoining AS DATETIME)) + '09:00:00' AS FullDatetime FROM Employees;

-- Cast salary to INT and compare
SELECT EmployeeID, Salary, CAST(Salary AS INT) AS SalaryInt FROM Employees;

-- Difference between CAST and CONVERT (both can change data types, but CONVERT has more formatting options)
SELECT CAST(Salary AS VARCHAR) AS Casted, CONVERT(VARCHAR, Salary) AS Converted FROM Employees;

-- Count employees with NULL salary
SELECT COUNT(*) AS NullSalaryCount FROM Employees WHERE Salary IS NULL;

-- Replace NULL phone with 'N/A'
SELECT EmployeeID, ISNULL(Phone, 'N/A') AS FixedPhone FROM Employees;

-- Use ISNULL to calculate total salaries
SELECT SUM(ISNULL(Salary, 0)) AS TotalSalaries FROM Employees;

-- Use COALESCE for emails
SELECT EmployeeID, COALESCE(Email, 'No Email') AS EmailAddress FROM Employees;

-- Compare ISNULL vs COALESCE
SELECT EmployeeID, ISNULL(NULL, COALESCE(NULL, 'Default')) AS Result FROM Employees;

-- Employees with NULL phone or email
SELECT * FROM Employees WHERE Phone IS NULL OR Email IS NULL;

-- NULLIF example
SELECT EmployeeID, NULLIF(Salary, 0) AS NullIfZeroSalary FROM Employees;

-- ISNULL to calculate average salary
SELECT AVG(ISNULL(Salary, 0)) AS AvgIncludingNulls FROM Employees;

-- Employees where Salary is NOT NULL
SELECT * FROM Employees WHERE Salary IS NOT NULL;

-- 'Missing' for NULL email when concatenating names
SELECT EmployeeID, FirstName + ' ' + LastName + ' - ' + ISNULL(Email, 'Missing') AS EmployeeDetails FROM Employees;

-- Formatted string: "Rahul Sharma from Engineering earns 75K"
SELECT e.FirstName + ' ' + e.LastName + ' from ' + d.DepartmentName + ' earns ' + CAST(CAST(Salary/1000 AS INT) AS VARCHAR) + 'K' AS Summary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Experience in complete years and months
SELECT EmployeeID, 
       DATEDIFF(YEAR, DateOfJoining, GETDATE()) AS Years,
       DATEDIFF(MONTH, DateOfJoining, GETDATE()) % 12 AS Months
FROM Employees;

-- Department-wise average salary
SELECT d.DepartmentName, AVG(e.Salary) AS AverageSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- Employees with more than average experience
SELECT * 
FROM Employees
WHERE DATEDIFF(YEAR, DateOfJoining, GETDATE()) > (SELECT AVG(DATEDIFF(YEAR, DateOfJoining, GETDATE())) FROM Employees);

-- How many employees missing phone/email/salary
SELECT 
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS MissingPhone,
    SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS MissingEmail,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS MissingSalary
FROM Employees;

-- Employees joined before 2020 and NULL email
SELECT * FROM Employees WHERE DateOfJoining < '2020-01-01' AND Email IS NULL;

-- Salary formatted with commas
SELECT EmployeeID, FORMAT(Salary, 'N2') AS FormattedSalary FROM Employees;

-- Employees with phone numbers containing '9876'
SELECT * FROM Employees WHERE Phone LIKE '%9876%';

-- Department name along with employees
SELECT e.*, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Employees joined per quarter
SELECT DATEPART(QUARTER, DateOfJoining) AS Quarter, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DATEPART(QUARTER, DateOfJoining);

-- First and last character of last name
SELECT EmployeeID, LEFT(LastName, 1) AS FirstChar, RIGHT(LastName, 1) AS LastChar FROM Employees;

-- LEN vs DATALENGTH
SELECT EmployeeID, LEN(FirstName) AS LengthChars, DATALENGTH(FirstName) AS DataBytes FROM Employees;

-- Joining date formatted like 15 March 2019
SELECT EmployeeID, FORMAT(DateOfJoining, 'dd MMMM yyyy') AS FormattedJoinDate FROM Employees;

-- Employees whose names have vowels only
SELECT * FROM Employees WHERE FirstName NOT LIKE '%[^aeiouAEIOU]%';

-- Employees who joined same month as today
SELECT * FROM Employees WHERE MONTH(DateOfJoining) = MONTH(GETDATE());

-- Number of characters in full name excluding spaces
SELECT EmployeeID, LEN(REPLACE(FirstName + LastName, ' ', '')) AS FullNameLength FROM Employees;
