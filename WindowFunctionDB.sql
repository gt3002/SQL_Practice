-- Create the EmployeesPerformance table
CREATE TABLE EmployeesPerformance (
    EmpID INT,
    EmpName VARCHAR(100),
    Department VARCHAR(50),
    Salary INT,
    JoiningDate DATE,
    PerformanceRating INT
);

-- Insert sample data
INSERT INTO EmployeesPerformance VALUES
(1, 'Alice', 'Sales', 60000, '2020-03-01', 5),
(2, 'Bob', 'Sales', 55000, '2021-07-15', 4),
(3, 'Charlie', 'HR', 50000, '2019-02-10', 3),
(4, 'Diana', 'HR', 52000, '2020-08-23', 5),
(5, 'Evan', 'IT', 70000, '2018-06-12', 2),
(6, 'Fiona', 'IT', 72000, '2019-11-30', 4),
(7, 'George', 'IT', 68000, '2021-04-18', 5),
(8, 'Hannah', 'Marketing', 48000, '2020-01-20', 3),
(9, 'Ian', 'Marketing', 50000, '2021-05-22', 4),
(10, 'Jane', 'Sales', 58000, '2019-12-01', 3);
----------------------------------------------------------------------------------------------------
--**SQL Window Functions Practice Questions**

--1. Rank employees based on Salary (highest salary = rank 1).
SELECT EmpName,Salary,
RANK() OVER(ORDER BY Salary DESC) AS Rank
FROM EmployeesPerformance;

--2. Dense Rank employees based on PerformanceRating (highest rating first).
SELECT EmpName, PerformanceRating,
DENSE_RANK() OVER(ORDER BY PerformanceRating DESC) AS Rating
FROM EmployeesPerformance;

--3. Assign Row Numbers to employees ordered by JoiningDate.
SELECT EmpName, JoiningDate,
ROW_NUMBER() OVER(ORDER BY JoiningDate) RowNumber
FROM EmployeesPerformance;

--4. Find the employee with the 2nd highest salary using RANK().
WITH C AS(
SELECT EmpName, Salary,
RANK() OVER(ORDER BY Salary DESC) AS Rank
FROM EmployeesPerformance
)
SELECT * FROM C WHERE Rank = 2;

--5. Find the employee with the 2nd highest salary using DENSE_RANK().
WITH C AS(
SELECT EmpName, Salary,
DENSE_RANK() OVER(ORDER BY Salary DESC) AS Rank
FROM EmployeesPerformance
)
SELECT * FROM C WHERE Rank = 2;

--6. Find the 2nd most recent joiner using ROW_NUMBER().
WITH C AS(
SELECT EmpName,JoiningDate,
ROW_NUMBER() OVER(ORDER BY JoiningDate DESC) AS rn
FROM EmployeesPerformance
)
SELECT * FROM C WHERE rn = 2;


--7. Rank employees within each Department based on Salary.
SELECT EmpName, Department, Salary,
RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS Rank
FROM EmployeesPerformance;

--8. Row Number employees within each Department ordered by JoiningDate.
SELECT EmpName, Department, JoiningDate,
ROW_NUMBER() OVER(PARTITION BY Department ORDER BY JoiningDate) AS rn
FROM EmployeesPerformance;

--9. Dense Rank employees within each Department based on PerformanceRating.
SELECT EmpName, Department, JoiningDate,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY JoiningDate) AS rn
FROM EmployeesPerformance;

--10. Find all employees who have the same salary rank.
WITH SameSalaryEmp AS(
SELECT EmpName, Salary,
RANK() OVER(ORDER BY Salary DESC) AS SalaryRank
FROM EmployeesPerformance)
SELECT s1.EmpName, s1.Salary, s1.SalaryRank
FROM SameSalaryEmp s1 JOIN SameSalaryEmp s2
ON s1.SalaryRank = s2.SalaryRank
AND s1.EmpName != s2.EmpName;

--11. Show each employee’s salary along with the next employee's salary (based on salary descending).
SELECT EmpName, Salary,
LEAD(Salary) OVER(ORDER BY Salary DESC) AS NextSalary
FROM EmployeesPerformance;

--12. Show each employee’s salary along with the previous employee’s salary.
SELECT EmpName, Salary,
LAG(Salary) OVER(ORDER BY Salary) AS NextSalary
FROM EmployeesPerformance;

--13. Find the salary difference between an employee and the next employee.
WITH C AS(
SELECT EmpName, Salary,
LEAD(Salary,1, (select SUM(Salary) FROM EmployeesPerformance)) OVER(ORDER BY Salary) AS NextSalary
FROM EmployeesPerformance)
SELECT *, (Salary-NextSalary) AS SalaryDiff
FROM C;


--14. Find the salary difference between an employee and the previous employee.
WITH C AS(
SELECT EmpName, Salary,
LAG(Salary) OVER(ORDER BY Salary) AS NextSalary
FROM EmployeesPerformance)
SELECT *, (Salary-NextSalary) AS SalaryDiff
FROM C;

--15. For each department, show each employee and the next joining employee.
SELECT EmpName, Department,JoiningDate,
LEAD(EmpName) OVER(PARTITION BY Department ORDER BY JoiningDate) NextJoininigEmp
FROM EmployeesPerformance;

--16. Find who joined immediately before and after each employee.
SELECT EmpName, Department,JoiningDate,
LAG(EmpName) OVER(ORDER BY JoiningDate) EmpJoinedBefore,
LEAD(EmpName) OVER(ORDER BY JoiningDate) EmpJoinedAfter
FROM EmployeesPerformance;

--17. Find employees whose salary increased compared to the previous employee (based on salary order).
WITH C AS(
SELECT EmpName, Salary,
LAG(Salary) OVER(ORDER BY Salary) AS PreviousEmpSalary
FROM EmployeesPerformance)
SELECT * FROM C WHERE Salary > PreviousEmpSalary;

--18. Show employees with lower salaries than the next employee.
WITH C AS(
SELECT EmpName, Salary,
LEAD(Salary) OVER(ORDER BY Salary) AS NextEmpSalary
FROM EmployeesPerformance)
SELECT * FROM C WHERE Salary > NextEmpSalary;

--19. Compare each employee's performance rating with the next employee.
SELECT EmpName, PerformanceRating,
LEAD(Performancerating) OVER(ORDER BY EmpID) AS RatingOfNextEmployee
FROM EmployeesPerformance;

--20. Find the employee whose salary is immediately higher than Bob's salary.
WITH C AS(
SELECT EmpName, Salary,
LAG(EmpName) OVER(ORDER BY Salary DESC) AS Emp
FROM EmployeesPerformance
WHERE EmpName = 'Bob')
SELECT * FROM C


--21. Find cumulative salary total ordered by salary descending.
SELECT EmpName, Salary, 
SUM(Salary) OVER (ORDER BY Salary DESC) AS CumulativeSalary
FROM EmployeesPerformance;

--22. Find cumulative count of employees based on joining date.
SELECT EmpName, JoiningDate, 
COUNT(*) OVER (ORDER BY JoiningDate) AS CumulativeCount
FROM EmployeesPerformance;

--23. Calculate running average salary for all employees.************
WITH CalcRunningAvg AS(
SELECT EmpName,
SUM(Salary) OVER (ORDER BY Salary) AS RunningSalary
FROM EmployeesPerformance)
SELECT EmpName, AVG(RunningSalary) AS AvgRunningSalary
FROM CalcRunningAvg
GROUP BY EmpName;


--24. Find the maximum salary within each department.
WITH C AS(
SELECT EmpName,Department,Salary,
RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS Rank
FROM EmployeesPerformance)
SELECT EmpName,Department,Salary FROM C
WHERE Rank = 1;

--25. Find the minimum performance rating within each department.
WITH C AS(
SELECT EmpName,Department,PerformanceRating,
RANK() OVER(PARTITION BY Department ORDER BY PerformanceRating) AS MinRating
FROM EmployeesPerformance)
SELECT EmpName,Department,PerformanceRating FROM C WHERE MinRating = 1;

--26. Find average salary within each department.
WITH C AS(
SELECT Department,
AVG(Salary) AS AvgSalary
FROM EmployeesPerformance
GROUP BY Department)
SELECT * FROM C;

--27. Find the difference between each employee's salary and department average salary.
WITH C AS(
SELECT EmpName, Department, Salary, 
AVG(Salary) OVER(PARTITION BY Department) AS AvgSalary
FROM EmployeesPerformance)
SELECT *, (Salary-AvgSalary) AS SalaryDiff
FROM C;

--28. Find total salary per department using window function.
SELECT DISTINCT Department,
SUM(Salary) OVER(PARTITION BY Department) AS TotalSalary
FROM EmployeesPerformance
GROUP BY Department, Salary;

--29. Find the employee with the minimum joining date in each department.
WITH C AS(
SELECT Empname, JoiningDate, Department,
RANK() OVER(PARTITION BY Department ORDER BY JoiningDate) AS rank
FROM EmployeesPerformance)
SELECT Empname, JoiningDate, Department FROM C WHERE rank = 1

--30. Find employees earning more than the average salary in their department.
WITH C AS(
SELECT EmpName, Department, Salary, AVG(Salary) OVER (PARTITION BY Department)AS AvgSalary
FROM EmployeesPerformance)
SELECT * FROM C
WHERE Salary > AvgSalary


--31. Find row number of employees partitioned by Department and ordered by Salary descending.
SELECT EmpName, Department, Salary,
ROW_NUMBER() OVER(PARTITION BY Department ORDER BY SALARY DESC) AS RowNumber
FROM EmployeesPerformance;

--32. Find the highest paid employee in each department.
WITH C AS(
SELECT EmpName, Department, Salary,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY SALARY DESC) AS Rank
FROM EmployeesPerformance)
SELECT EmpName, Department, Salary
FROM C WHERE Rank = 1;

--33. Find the second highest paid employee in each department.
WITH C AS(
SELECT EmpName, Department, Salary,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY SALARY DESC) AS Rank
FROM EmployeesPerformance)
SELECT EmpName, Department, Salary,Rank
FROM C WHERE Rank = 2;

--34. List employees who are the newest in their department.
WITH C AS(
SELECT EmpName, Department, JoiningDate,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY JoiningDate DESC) AS Rank
FROM EmployeesPerformance)
SELECT EmpName, Department, JoiningDate,Rank
FROM C WHERE Rank = 1;

--35. Find employees with the highest performance rating per department.
WITH C AS(
SELECT EmpName, Department, PerformanceRating,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY PerformanceRating DESC) AS Rank
FROM EmployeesPerformance)
SELECT EmpName, Department, PerformanceRating
FROM C WHERE Rank = 1;

--36. Find employees whose performance rating is lower than the department average.
WITH C AS(
SELECT Empname, PerformanceRating, Department,
AVG(PerformanceRating) OVER(PARTITION BY Department) AS AvgDepartmentRating
FROM EmployeesPerformance)
SELECT *FROM C
WHERE PerformanceRating < AvgDepartmentRating

--37. Find employees who have the same salary within their department.
WITH C AS(
SELECT EmpName, Salary, Department, 
COUNT(*) OVER (PARTITION BY Department, Salary) AS SameSalaryCount
FROM EmployeesPerformance)
SELECT EmpName, Salary, Department
FROM C WHERE SameSalaryCount > 1;

--38. Find how many employees joined before each employee in the same department.
SELECT EmpName, Department, JoiningDate,
COUNT(*) OVER (PARTITION BY Department ORDER BY JoiningDate 
ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS EmpJoinedBefore
FROM EmployeesPerformance;

--39. Find difference in joining date between each employee and the next one in their department.
WITH C AS(
SELECT EmpName, Department, JoiningDate,
LEAD(JoiningDate) OVER (PARTITION BY Department ORDER BY JoiningDate) AS  NextDate
FROM EmployeesPerformance)
SELECT *,DATEDIFF(DAY,JoiningDate,NextDate) AS DateDifference FROM C;

--40. Rank employees across the company based on performance, break ties alphabetically by name.
SELECT EmpName, PerformanceRating,
RANK() OVER(ORDER BY PerformanceRating DESC,EmpName) AS rank
FROM EmployeesPerformance

--41. Find each employee’s salary compared to the maximum salary across all employees.
WITH C AS(
SELECT EmpName, Salary,
MAX(Salary) OVER() AS MaxSalary
FROM EmployeesPerformance)
SELECT *, (MaxSalary-Salary) AS SalaryDifference
FROM C;

--42. Find employees who are the second most recent joiners in the company.
WITH C AS(
SELECT EmpName, JoiningDate,
DENSE_RANK() OVER(ORDER BY JoiningDate DESC) AS rank
FROM EmployeesPerformance)
SELECT EmpName, JoiningDate FROM C
WHERE rank = 2;

--43. Find cumulative sum of performance ratings.
SELECT EmpName,PerformanceRating,
SUM(Performancerating) OVER(ORDER BY PerformanceRating ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
AS CumulativeSum FROM EmployeesPerformance;

--44. Show the performance rating of the employee who joined just before each employee.**********
SELECT EmpName,PerformanceRating,JoiningDate,
LAG(PerformanceRating) OVER(ORDER BY JoiningDate) PreviousEmpRating
FROM EmployeesPerformance;

--45. Find employees who have better performance than the employee who joined just before them.
WITH C AS(
SELECT EmpName, Department, JoiningDate, PerformanceRating,
LAG(PerformanceRating) OVER (PARTITION BY Department ORDER BY JoiningDate) AS EmpPerformanceRating
FROM EmployeesPerformance)
SELECT * FROM C WHERE PerformanceRating > EmpPerformanceRating

--46. Find each employee’s rank in company tenure (JoiningDate ASC).
SELECT EmpName,JoiningDate,
RANK() OVER(ORDER BY JoiningDate) AS RankInCompanyTenure
FROM EmployeesPerformance;

--47. Find salary gap between an employee and the previous higher salary employee.
WITH C AS(
SELECT EmpName,Salary,
LAG(Salary) OVER(ORDER BY Salary DESC) PreviousEmpSalary
FROM EmployeesPerformance)
SELECT *, (PreviousEmpSalary-salary) AS GapBetweenSalaries
FROM C;

--48. Show which employees are earning more than their previous colleague in the same department.
WITH C AS(
SELECT EmpName,Salary,Department,
LAG(Salary) OVER(PARTITION BY Department ORDER BY JoiningDate DESC) PreviousEmpSalary
FROM EmployeesPerformance)
SELECT EmpName,Salary,Department FROM C
WHERE Salary > PreviousEmpSalary;

--49. Find employees who had the same joining year.
WITH C AS(
SELECT EmpName, Joiningdate,
COUNT(*) OVER(PARTITION BY YEAR(JoiningDate)) AS SameYearCount
FROM EmployeesPerformance)
SELECT EmpName, Joiningdate
FROM C WHERE SameYearCount > 1;


--50. Compare each employee's salary with the average salary across the company (without group by).
WITH C AS(
SELECT EmpName, Salary,
AVG(Salary) OVER() AS AverageSalary
FROM EmployeesPerformance)
SELECT EmpName, Salary, (Salary-AverageSalary) AS SalaryDiff FROM C;


