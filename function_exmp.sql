--------------String Functions--------------------
SELECT * FROM Customers;
Select CONCAT(first_name, '-', country) as full_info
from customers;

Select LOWER(first_name) as lower_case_name
from customers;

Select UPPER (first_name) as lower_case_name
from customers;

select '123-456-7890' as phone,
REPLACE('123-456-7890','-','/') as clean_phone;

select 'report.txt' as old_filename,
REPLACE('report.txt','.txt','.csv') as new_filename;

SELECT first_name, LEN(first_name) AS name_length FROM customers;

SELECT first_name, LEFT(TRIM(first_name),2) AS first_2_chars FROM customers;

SELECT first_name, RIGHT(first_name,2) AS last_2_chars FROM customers;

SELECT first_name, SUBSTRING(TRIM(first_name),2,LEN(first_name)) as trimmed_name from customers;

SELECT first_name, UPPER(LOWER(first_name)) AS nesting from customers;

-------------------------------------NUMERIC FUNCTIONS--------------------------------------------------

SELECT order_id, order_date, '2025-08-20' as 'HardCoded',
GETDATE() as Today
From Orders;


SELECT order_id, order_date,
EOMONTH(order_date) as end_of_month
From Orders;

SELECT YEAR(order_date) as OrderYear,
COUNT(*) AS TotalOrders
From orders
GROUP BY Year(order_date);

SELECT MONTH(order_date) as OrderMonth,
COUNT(*) AS TotalOrders
From orders
GROUP BY MONTH(order_date);

SELECT * FROM orders
WHERE MONTH(order_date)=2;

SELECT order_id, order_date,
FORMAT(order_date,'MM-dd-yyyy') AS USA_Format,
FORMAT(order_date,'dd-MM-yyyy') AS Euro_Format,
FORMAT(order_date,'dd') as dd,
FORMAT(order_date,'ddd') as ddd,
FORMAT(order_date,'dddd') as dddd,
FORMAT(order_date,'MM') as MM,
FORMAT(order_date,'MMM') as MMM,
FORMAT(order_date,'MMMM') as MMMM
From orders;

SELECT order_id, order_date,
'Day ' + FORMAT(order_date, 'ddd MMM')
+ ' Q ' + DATENAME(quarter, order_date) + ' '+
FORMAT(order_date, 'yyyy hh:mm:ss tt') AS 
CustomFormat FROM Orders;

---CONVERT() DEMONSTARTION-------------------------
SELECT 
CONVERT (INT, '123') AS [String to INT Convert],
CONVERT (DATE, '2025-08-20') AS [String to Date Convert],
order_date,
CONVERT (DATE, order_date) AS [Datetime to Date Convert],
CONVERT (VARCHAR, order_date, 32) AS [USA Std. Style:32],
CONVERT (VARCHAR, order_date,34) AS [Euro Std. Style:34]
FROM orders;

-------CAST()----------------------------------------

SELECT
CAST('123' AS INT) AS [String to Int],
CAST(123 AS VARCHAR) AS [Int to String],
CAST('2025-08-20' AS DATE) AS [String to Date],
CAST('2025-08-20' AS datetime2) AS [String to DATETIME],
order_date,
CAST(order_date AS DATE) AS [DateTime to date]
From orders;

------DATEADD-------------------------------------
SELECT 
order_id,
order_date,
DATEADD(day, -10, order_date) AS TenDaysBefore,
DATEADD(MONTH, 3, order_date) AS ThreeMonthsLater,
DATEADD(Year, 2, order_date) AS TwoYearsLater
From orders;

------------------------------------------------------------
Use SalesDB;

Select 
EmployeeID,
BirthDate,
DATEDIFF(YEAR,BirthDate, GETDATE()) AS Age
from Sales.Employees;

SELECT 
MONTH(OrderDate) AS OrderMonth,
AVG(DATEDIFF(day,OrderDate,GETDATE())) AS AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

SELECT
CustomerID, FirstName,LastName,
FirstName + ' ' + COALESCE(LastName,' ') AS
Full_Name,
Score,
COALESCE(Score,0) + 10 AS Score_With_Bonus
From Sales.Customers;

SELECT * FROM Sales.Customers
WHERE Score IS NULL;

SELECT * FROM Sales.Customers
WHERE Score IS NOT NULL;
----------------------------------------------------------------------------
SELECT
CustomerID,
FirstName,
LastName,
Country,
CASE
	WHEN Country = 'Germany' THEN 'DE'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'n/a'
END AS CountryAbbr
FROM Sales.Customers;
---------------------------------------------------------------------------------
SELECT
CustomerID,
FirstName,
LastName,
Country,
CASE
	WHEN Country = 'Germany' THEN 'DE'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'n/a'
END AS CountryAbbr,
CASE Country
	WHEN 'Germany' THEN 'DE'
	WHEN 'USA' THEN 'US'
	ELSE 'n/a'
END AS CountryAbbr2
FROM Sales.Customers;
--------------------------------------------------------------------------------------------------------



