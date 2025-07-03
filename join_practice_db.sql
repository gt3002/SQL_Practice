-- Create a fresh database
CREATE DATABASE JoinPracticeDB;
GO
USE JoinPracticeDB;
GO

-- Drop tables if they exist
IF OBJECT_ID('dbo.Customers') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('dbo.Orders') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('dbo.Products') IS NOT NULL DROP TABLE Products;
GO

-- Table 1: Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Country NVARCHAR(50)
);

-- Table 2: Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    --FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    --FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Table 3: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Insert into Customers
INSERT INTO Customers VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'UK'),
(3, 'Charlie', 'Germany'),
(4, 'Diana', 'USA'),
(5, 'Evan', 'France');

-- Insert into Products
INSERT INTO Products VALUES
(101, 'Laptop', 1000),
(102, 'Phone', 500),
(103, 'Tablet', 700),
(104, 'Monitor', 300);

-- Insert into Orders
INSERT INTO Orders VALUES           --(1006, 7, 105, '2023-01-10', 1)
(1007, 1, NULL, '2023-01-10', 1),
(1002, 2, 102, '2023-01-15', 2),
(1003, 1, 103, '2023-02-20', 1),
(1004, 4, 105, '2023-03-05', 1), -- Invalid product ID
(1005, 6, 102, '2023-03-10', 1); -- Invalid customer ID

------------------------------------------------------------JOINS--------------------------------------------------------------------
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Products;

--List all orders with customer names and product names.
SELECT o.OrderID, c.CustomerName, p.ProductName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;


--Show each order with product price included.
SELECT o.OrderID, p.ProductName, p.Price
FROM Orders o 
LEFT JOIN Products p ON o.ProductID = p.ProductID;

--Find all customers who have placed at least one order.
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID

--Show each product that has been ordered and by whom.
SELECT p.ProductID, p.ProductName, c.CustomerName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;

--Display all customers along with order dates and products they bought.
SELECT c.CustomerName, o.OrderDate, p.ProductName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;

--List all customers and their orders (if any).
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID

--Show customers who have not placed any orders.
SELECT CustomerName from Customers where 
CustomerID NOT IN (SELECT CustomerID from Orders WHERE CustomerID IS NOT NULL);

--List all products and their order info (if ordered).
SELECT p.*, o.*
FROM Products p
JOIN Orders o ON o.ProductID = p.ProductID

--Find products that have never been ordered.
SELECT ProductName from Products where 
ProductID NOT IN (SELECT ProductID from Orders WHERE ProductID IS NOT NULL);

SELECT o.*, p.ProductName
FROM Orders o
LEFT JOIN Products p ON o.ProductID = p.ProductID 


--Get all orders and include customer info even if customer doesn't exist in Customers table.
SELECT o.OrderID, o.CustomerID
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID

--Show all orders with product details, even if the product doesn't exist in Products.
SELECT o.*, p.ProductName
FROM Orders o
LEFT JOIN Products p ON o.ProductID = p.ProductID

--Get all customers who placed orders, including products even if they are invalid.
SELECT o.OrderID, c.CustomerName, p.ProductName AS Ordered_Product
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN Products p ON o.ProductID = p.ProductID;

--List all products and any order associated with them.
SELECT p.ProductID,p.ProductName, o.OrderID
FROM Products p
LEFT JOIN Orders o ON o.ProductID = p.ProductID

--Show which orders were made with missing customer info.
SELECT c.CustomerName, o.OrderID
FROM Orders o 
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;  --Left anti join

--List all customers and their orders, including customers and orders that don’t match.
SELECT c.CustomerName, o.OrderID
FROM Orders o 
FULL JOIN Customers c ON o.CustomerID = c.CustomerID;

--Show all orders and products whether matched or not.
SELECT o.OrderID, p.ProductName
FROM Orders o
FULL JOIN Products p ON o.ProductID = p.ProductID; 

--Display all unmatched customers and orders.
SELECT c.CustomerID, o.OrderID
FROM Customers c
FULL JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.CustomerID IS NULL OR o.OrderID IS NULL;

--Show unmatched products and their attempted orders.
SELECT p.ProductID, o.OrderID
FROM Products p
FULL JOIN Orders o ON o.ProductID = p.ProductID
WHERE o.ProductID IS NULL OR o.OrderID IS NULL;

--Show all possible combinations of customers and products.
SELECT c.CustomerName, p.ProductName
FROM Customers c
CROSS JOIN Products p;

--Display all product-customer combinations where country is 'USA'.
SELECT c.CustomerName,c.Country, p.ProductName
FROM Customers c
CROSS JOIN Products p WHERE c.Country = 'USA';

--Show cross join where price is above $500.
SELECT c.CustomerName,c.Country, p.ProductName, p.Price
FROM Customers c
CROSS JOIN Products p WHERE p.Price > 500;

--Count total number of combinations between customers and products.
SELECT COUNT(*) AS Total_Combinations
FROM Customers 
CROSS JOIN Products;

--SELF JOIN ideas (if extended schema) (Optional) Add manager field to Customers and find relationships.


--Find customers who have never ordered anything.*************************************
SELECT CustomerName from Customers where CustomerID NOT IN 
(SELECT CustomerID from Orders WHERE CustomerID IS NOT NULL);

--or

SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

--List products never ordered.
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;
   --or
SELECT ProductName from Products where ProductID NOT IN 
(SELECT ProductID from Orders WHERE ProductID IS NOT NULL);

--Show orders with invalid customers.
SELECT o.*
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.CustomerID IS NULL OR c.CustomerID IS NULL;

--Find orders with invalid product references
SELECT o.*
FROM Orders o
LEFT JOIN Products p ON o.ProductID = p.ProductID
WHERE o.ProductID IS NULL;


--List customers who ordered ‘Laptop’.
SELECT c.CustomerID, c.CustomerName, p.ProductName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductID =  o.ProductID
WHERE p.ProductName = 'Laptop';

--Show total quantity ordered for each product.
SELECT p.ProductName, SUM(COALESCE(o.Quantity, 0)) as Total_Quantity
FROM  Products p 
JOIN Orders o
ON p.ProductID =  o.ProductID GROUP BY p.ProductName;

--Get customer names and total amount spent.
SELECT c.CustomerName, SUM(o.Quantity*p.Price) as Total_Amount
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductID =  o.ProductID
GROUP BY c.CustomerName;

--Show each product with number of times ordered.
SELECT p.ProductID, COUNT(o.ProductID) as Product_Ordered_Count
FROM  Products p 
Left JOIN Orders o
ON p.ProductID =  o.ProductID GROUP BY p.ProductID;

--Find customers with multiple orders.
SELECT CustomerID, COUNT(CustomerID)
FROM Orders GROUP BY CustomerID
HAVING COUNT(CustomerID) > 1;

--Show latest order for each customer. *********************
SELECT c.CustomerID, MAX(o.OrderDate) AS Latest_Order_Date
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID;
--or
SELECT CustomerID,MAX(OrderDate) AS Latest_Order_Date from Orders
GROUP BY CustomerID;


--List all products with total revenue generated.--INNER JOIN
SELECT o.ProductID, SUM(p.Price) as Total_Revenue
FROM Orders o 
LEFT JOIN Products p ON o.ProductID =  p.ProductID
GROUP BY o.ProductID;


--Display all customers and their first order (if any)*********
SELECT c.CustomerID, MIN(o.OrderDate) AS First_Order_Date
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID Group By c.CustomerID;


--Find products ordered by customers from the UK.
SELECT p.ProductID, p.ProductName, c.CustomerName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
WHERE c.Country = 'UK';

--Show the most expensive product each customer has ordered.
SELECT c.CustomerID, Max(p.Price) as Highest_Price
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductID =  o.ProductID
GROUP BY c.CustomerID;

--Show customers who ordered both ‘Phone’ and ‘Tablet’************************
SELECT c.CustomerName,p.ProductName
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
WHERE p.ProductName IN ('Phone','Tablet')
GROUP BY CustomerName
HAVING COUNT(DISTINCT p.ProductName) > 1;

--Find which customer has spent the most.**********************************
SELECT  o.CustomerID, SUM(o.Quantity * p.Price) as Total_Spent
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY o.CustomerID ORDER BY Total_Spent;

--List customers who have placed more than 1 order.
SELECT  o.CustomerID, COUNT(o.CustomerID)
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY o.CustomerID HAVING COUNT(o.CustomerID)>1;

--Count number of orders per country.***********************************************
SELECT c.Country, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Country;

--Get product details for orders made in March 2023.  --can use string date comparison
SELECT  p.ProductID, p.ProductName, o.OrderDate
FROM Orders o 
JOIN Products p ON o.ProductID = p.ProductID
WHERE MONTH(o.OrderDate) = 3;

--Show all customers who ordered something after Feb 2023.
SELECT  c.CustomerName, o.OrderDate
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
Where o.OrderDate > '2023-02-28'   --****Not taking 29 date in the date given noted

--List orders with quantities more than 1.
SELECT  o.*
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
Where o.Quantity > 1;

--Get total orders placed per customer with total quantity.
SELECT  c.CustomerName, COUNT(o.OrderID) as Total_Orders, 
SUM(o.Quantity) as total_quantity
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName

--Show customers and their average order value.---order value = quantity * price
SELECT  c.CustomerName, AVG(o.Quantity * p.Price) as AverageValue
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductID = o.ProductID
GROUP BY c.CustomerName


--Show all products with unit price above 700 and their orders.

SELECT p.ProductID, p.ProductName, p.Price, o.OrderID, o.Quantity
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
WHERE p.Price > 700;


--Retrieve all customers whose total spend exceeds $1500.


--List all orders where the quantity is not between 1 and 2.
SELECT OrderID, CustomerID, ProductID, OrderDate, Quantity
FROM Orders
WHERE Quantity NOT BETWEEN 1 AND 2;

--Show all customers who have either ordered nothing or ordered invalid products.
SELECT c.CustomerID, c.CustomerName, p.ProductID,o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Products p ON p.ProductID = o.ProductID
WHERE o.CustomerID IS NULL OR o.ProductID IS NULL;



