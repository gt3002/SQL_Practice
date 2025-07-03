-- Create Tables
CREATE TABLE Employees_USA (
    EmpID INT,
    EmpName VARCHAR(50)
);

CREATE TABLE Employees_UK (
    EmpID INT,
    EmpName VARCHAR(50)
);

CREATE TABLE Project_A (
    EmpID INT,
    ProjectName VARCHAR(50)
);

CREATE TABLE Project_B (
    EmpID INT,
    ProjectName VARCHAR(50)
);

-- Insert Data into Employees_USA
INSERT INTO Employees_USA VALUES 
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

-- Insert Data into Employees_UK
INSERT INTO Employees_UK VALUES 
(3, 'Charlie'),
(4, 'Diana'),
(5, 'Ethan'),
(6, 'Fiona');

-- Insert Data into Project_A
INSERT INTO Project_A VALUES
(1, 'AI Research'),
(2, 'Web Dev'),
(3, 'Data Analysis');

-- Insert Data into Project_B
INSERT INTO Project_B VALUES
(2, 'Web Dev'),
(3, 'Security Audit'),
(5, 'Cloud Migration');


---------------------------------------------------------------------------------------------


--List all unique employee names from both USA and UK.
SELECT EmpName FROM Employees_USA
UNION
SELECT EmpName FROM Employees_UK;


--Get all unique employee IDs from both countries.
SELECT EmpID FROM Employees_USA
UNION
SELECT EmpID FROM Employees_UK;


--Show distinct employee names who worked on either Project A or Project B.
SELECT DISTINCT E.EmpName FROM (
SELECT EmpID,EmpName FROM Employees_USA
UNION
SELECT EmpID ,EmpName FROM Employees_UK) E
INNER JOIN(
SELECT EmpID FROM Project_A
UNION
SELECT EmpID FROM Project_A) P
ON P.EmpID = E.EmpID;

--Retrieve all employee IDs who worked on either project, no duplicates.
SELECT EmpID FROM Project_A
UNION
SELECT EmpID FROM Project_B;

--Combine all unique project names from both Project A and Project B.
SELECT ProjectName FROM Project_A
UNION
SELECT ProjectName FROM Project_B;

--Get all employee names from USA and UK, including duplicates.
SELECT EmpName FROM Employees_USA
UNION ALL
SELECT EmpName FROM Employees_UK;


--List all employee IDs from Project A and Project B, even duplicates.
SELECT EmpID FROM Project_A
UNION ALL
SELECT EmpID FROM Project_B;


--Combine all project names from both tables without removing duplicates.
SELECT ProjectName FROM Project_A
UNION ALL
SELECT ProjectName FROM Project_B;


--Show all employee names from both countries, even if repeated.
SELECT EmpName FROM Employees_USA
UNION ALL
SELECT EmpName FROM Employees_UK;


--Retrieve all project assignments with duplication allowed.
SELECT * FROM Project_A
UNION ALL
SELECT * FROM Project_B;


--List employees who are in both USA and UK tables.--- INER JOIN CAN BE USED HERE 
SELECT EmpName FROM Employees_USA
INTERSECT
SELECT EmpName FROM Employees_UK;


--Show employee IDs that are in both Project A and Project B.
SELECT EmpID FROM Project_A
INTERSECT
SELECT EmpID FROM Project_B;


--Find employee names common to both USA and UK.
SELECT EmpName FROM Employees_USA
INTERSECT
SELECT EmpName FROM Employees_UK;

--Retrieve employees who worked on both projects.--INNER JOIN CAN BE USED
SELECT EmpID FROM Project_A
INTERSECT
SELECT EmpID FROM Project_B;

--Get project names common to both Project A and Project B.
SELECT ProjectName FROM Project_A
INTERSECT
SELECT ProjectName FROM Project_B;


--Find employees who are only in USA and not in UK.
SELECT EmpName FROM Employees_USA
EXCEPT
SELECT EmpName FROM Employees_UK;

--Get employees who worked only in Project A but not Project B.
SELECT EmpID FROM Project_A
EXCEPT
SELECT EmpID FROM Project_B;


--Show employees who are only in UK and not USA.
SELECT EmpName FROM Employees_UK
EXCEPT
SELECT EmpName FROM Employees_USA;


--Retrieve project names from Project B that are not in Project A.
SELECT ProjectName FROM Project_B
EXCEPT
SELECT ProjectName FROM Project_A;


--List employee IDs present in Project A but missing from Project B.
SELECT EmpID FROM Project_A
EXCEPT
SELECT EmpID FROM Project_B;

--Find names of employees who are in UK but not in USA, and also worked on Project B. --LEFT ANTI JOIN
SELECT UK.EmpName FROM Employees_UK UK
LEFT JOIN Employees_USA USA ON
UK.EmpID = USA.EmpID
INNER JOIN Project_B PB ON UK.EmpID = PB.EmpID
WHERE USA.EmpID IS NULL;

--Combine USA and UK employees, then filter only those who didn’t work on either project.
SELECT EmpName FROM 
(
SELECT EmpName FROM Employees_UK
UNION
SELECT EmpName FROM Employees_USA
) E
LEFT JOIN
(
SELECT EmpID FROM Project_A
UNION
SELECT EmpID FROM Project_A
) 


--Show all employees who worked on either project but exclude those in both countries. --LEFT ANTI JOIN


--Get project names from both projects where at least one employee worked in both countries. --INTERSECT or INNER JOIN CAN BE USED
SELECT UK.EmpName FROM Employees_UK UK
JOIN Employees_USA USA ON
UK.EmpID = USA.EmpID
INNER JOIN Project_B PB ON UK.EmpID = PB.EmpID;

--Retrieve unique employee IDs across all four tables.
SELECT EmpID FROM Employees_USA
UNION
SELECT EmpID FROM Employees_UK
UNION
SELECT EmpID FROM Project_A
UNION
SELECT EmpID FROM Project_B;
