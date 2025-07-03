use SalesDB;
select * from Sales.Customers;
select * from Sales.Orders;
select * from Sales.Products;

--TASK 1: Calculate the Total Sales Across All Orders
SELECT SUM(Sales) OVER() AS TotalSales FROM Sales.Orders;

--TASK 2: Calculate the Total Sales for Each Product
SELECT ProductID, SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSales FROM Sales.Orders;

--TASK 3: Find the total sales across all orders, additionally providing details such as OrderID and OrderDate
SELECT OrderID, OrderDate, SUM(Sales) OVER() AS TotalSales FROM Sales.Orders;

--TASK 4: Find the total sales across all orders and for each product, additionally providing details 
--such as OrderID and OrderDate
SELECT OrderID, OrderDate, SUM(Sales) OVER() AS TotalSales, 
SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesPerProduct FROM Sales.Orders;

--TASK 5: Find the total sales across all orders, for each product, and for each
--combination of product and order status, additionally providing details such as OrderID and OrderDate
SELECT OrderID, OrderDate, SUM(Sales) OVER() AS TotalSales, 
SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesPerProduct,
SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS TotalSalesPerProductAndOrderStatus
FROM Sales.Orders;

--TASK 6: Rank each order by Sales from highest to lowest
SELECT OrderID,Sales FROM Sales.Orders ORDER BY Sales DESC;

--TASK 7: Calculate Total Sales by Order Status for current and next two orders
SELECT OrderID, SUM(Sales) 
OVER(
PARTITION BY OrderStatus
ORDER BY OrderID
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) 
AS TotalSales FROM Sales.Orders;

--TASK 8: Calculate Total Sales by Order Status for current and previous two orders
SELECT OrderID, SUM(Sales) 
OVER(
PARTITION BY OrderStatus
ORDER BY OrderID
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
AS TotalSales FROM Sales.Orders;

--TASK 9: Calculate Total Sales by Order Status from previous two orders only.
SELECT OrderID, SUM(Sales) 
OVER(
PARTITION BY OrderStatus
ORDER BY OrderID
ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING ) 
AS TotalSales FROM Sales.Orders;


--TASK 10: Calculate cumulative Total Sales by Order Status up to the current order
SELECT OrderID, SUM(Sales) 
OVER(
PARTITION BY OrderStatus
ORDER BY OrderID
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
AS TotalSales FROM Sales.Orders;

--TASK 11: Calculate cumulative Total Sales by Order Status from the start to the current row
SELECT OrderID, SUM(Sales) 
OVER(
PARTITION BY OrderStatus
ORDER BY OrderID
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
AS TotalSales FROM Sales.Orders;

--TASK 12: Rank customers by their total sales
SELECT CustomerID, SUM(Sales) as TotalSales, 
RANK() OVER(ORDER BY SUM(Sales) DESC) AS RankOfCustomers 
FROM Sales.Orders GROUP BY CustomerID;


--TASK 1: Find the Total Number of Orders and the Total Number of Orders for Each Customer
SELECT CustomerID, COUNT(OrderID) OVER() AS TotalOrders, COUNT(OrderID) 
OVER(PARTITION BY CustomerID) AS OrderPerCustomer
FROM Sales.Orders;

--TASK 2: Find the Total Number of Customers, the Total Number of Scores for Customers,
--and the Total Number of Countries
SELECT COUNT(CustomerID) AS TotalCustomers, COUNT(Score) AS TotalNumOfScore,
COUNT(Country) AS TotalNumOfCountry FROM Sales.Customers;

--TASK 3: Check whether the table 'OrdersArchive' contains any duplicate rows*******


--TASK 4: Find the Total Sales Across All Orders and the Total Sales for Each Product
SELECT OrderID, ProductID, SUM(Sales) OVER() AS TotalSales, 
SUM(Sales) OVER(PARTITION BY ProductID) SalesPerProduct
FROM Sales.Orders;

--TASK 5: Find the Percentage Contribution of Each Product's Sales to the Total Sales***********

--TASK 6: Find the Average Sales Across All Orders and the Average Sales for Each Product
SELECT OrderID, ProductID, AVG(Sales) OVER() AS TotalAvgSales, 
AVG(Sales) OVER(PARTITION BY ProductID) AVGSalesPerProduct
FROM Sales.Orders;

--TASK 7: Find the Average Scores of Customers
SELECT AVG(COALESCE(Score,0)) AS AvergaeScore FROM Sales.Customers;

--TASK 8: Find all orders where Sales exceed the average Sales across all orders
SELECT OrderID,Sales
FROM Sales.Orders
WHERE Sales>(SELECT AVG(COALESCE(Sales,0)) FROM Sales.Orders);

--TASK 9: Find the Highest and Lowest Sales across all orders
SELECT MIN(Sales) AS LowestSales, MAX(Sales) AS HighestSales
FROM Sales.Orders;

--TASK 10: Find the Lowest Sales across all orders and by Product
SELECT DISTINCT ProductID, MIN(Sales) OVER() AS LowestSalesAcrossAllOrders,
MIN(Sales) OVER(Partition By ProductID) AS ByProduct FROM Sales.Orders;

--TASK 11: Show the employees who have the highest salaries
SELECT EmployeeID

--TASK 12: Find the deviation of each Sale from the minimum and maximum Sales


--TASK 13: Calculate the moving average of Sales for each Product over time


--TASK 14: Calculate the moving average of Sales for each Product over time, including only the next order
