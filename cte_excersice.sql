
USE SalesDB;
-- Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'Canada'),
(3, 'Charlie', 'USA'),
(4, 'Diana', 'UK'),
(5, 'Evan', 'USA'),
(6, 'Fiona', 'Germany'),
(7, 'George', 'France'),
(8, 'Hannah', 'USA'),
(9, 'Ian', 'India'),
(10, 'Julia', 'Australia');

-- Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Phone', 800.00),
(3, 'Tablet', 500.00),
(4, 'Monitor', 300.00),
(5, 'Keyboard', 50.00),
(6, 'Mouse', 30.00),
(7, 'Printer', 150.00),
(8, 'Desk', 200.00);

-- Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES --add dumy column for order dependency
(1, 1, '2024-01-05'),
(2, 2, '2024-01-12'),
(3, 1, '2024-03-05'),
(4, 3, '2024-04-10'),
(5, 4, '2024-02-20'),
(6, 5, '2024-03-15'),
(7, 5, '2024-04-01'),
(8, 6, '2024-04-05'),
(9, 7, '2024-01-22'),
(10, 8, '2024-04-11'),
(11, 1, '2024-04-15'),
(12, 8, '2024-03-25'),
(13, 3, '2024-04-20'),
(14, 9, '2024-02-10'),
(15, 5, '2024-04-22');

-- OrderItems
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity) VALUES
(1, 1, 1, 1),
(2, 1, 5, 2),
(3, 2, 2, 1),
(4, 3, 3, 1),
(5, 4, 1, 1),
(6, 5, 4, 1),
(7, 6, 2, 2),
(8, 7, 6, 3),
(9, 8, 5, 1),
(10, 9, 8, 1),
(11, 10, 7, 1),
(12, 11, 1, 2),
(13, 12, 2, 1),
(14, 13, 3, 2),
(15, 14, 4, 1),
(16, 15, 5, 4),
(17, 3, 6, 2),
(18, 7, 7, 1),
(19, 12, 5, 2),
(20, 13, 6, 1);



--Write a CTE to find customers from the "USA" and their order count.
WITH USA_Customer_Order_Count AS
(
   SELECT c.CustomerName, c.Country, COUNT(o.OrderID) as TotalOrders
   FROM Customers c 
   JOIN 
   Orders o
   ON c.CustomerID = o.CustomerID
   WHERE c.Country = 'USA'
   GROUP BY c.CustomerName, c.Country
)
SELECT *
FROM USA_Customer_Order_Count;

--Find all customers who have placed an order of more than 1000 using a subquery in the WHERE clause.
SELECT * FROM Customers
WHERE CustomerID IN(
SELECT o.CustomerID FROM
Orders o JOIN OrderItems oi
ON o.OrderID = oi.OrderID
JOIN Products p
ON oi.ProductID = p.ProductID
GROUP BY o.CustomerID
HAVING SUM(p.Price) > 1000
) 

--Use a subquery in the FROM clause to calculate the total amount spent by each customer.
SELECT c.CustomerID, TotalSpent.TotalAmount FROM Customers c JOIN(
SELECT o.CustomerID, SUM(oi.Quantity * p.Price) AS TotalAmount FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY o.CustomerID)
AS TotalSpent
ON c.CustomerID = TotalSpent.CustomerID;

--Use a subquery in the SELECT clause to fetch the number of orders placed by each customer.
SELECT CustomerID, CustomerName,
(SELECT COUNT(*) 
FROM Orders o 
WHERE o.CustomerID = c.CustomerID) AS TotalOrders
FROM Customers c;

--Write a CTE to get all orders placed after '2024-03-01' and then find their total sum.
WITH C AS(
SELECT o.OrderID, SUM(oi.Quantity * p.Price) AS TotalSum FROM
Orders o JOIN OrderItems oi
ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
WHERE o.OrderDate > '2024-03-01'
GROUP BY o.OrderID
)
SELECT * FROM C;

--Write a CTE that finds each customer's first order date.
WITH FirstOrderDate AS (
SELECT CustomerID, MIN(OrderDate) AS FirstOrder
FROM Orders GROUP BY CustomerID)
SELECT c.CustomerID, c.CustomerName, f.FirstOrder
FROM Customers c
JOIN FirstOrderDate f ON c.CustomerID = f.CustomerID;


--Write a CTE and inside it, join customers with their orders, and then select those who have total spending > 1500.
WITH C AS (
SELECT c.CustomerID, c.CustomerName, SUM(oi.Quantity * p.Price) AS TotalSpent
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
)
SELECT * FROM C
WHERE TotalSpent > 1500;

--Find customers who have never placed an order (using subquery with NOT EXISTS).
SELECT CustomerID, CustomerName FROM Customers
WHERE NOT EXISTS(SELECT CustomerID FROM Orders
WHERE Customers.CustomerID = Orders.CustomerID);

--Use a scalar subquery in the SELECT to add the Average Order Amount for each customer.


--Create a CTE to list orders along with the number of items per order.
WITH C AS(
SELECT o.OrderID, COUNT(oi.OrderItemID) AS NumberOfItems FROM
Orders o JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID
)
SELECT * FROM C;

--Write a recursive CTE to generate a sequence of dates between '2024-01-01' and '2024-01-10'.
WITH C AS(
SELECT '2024-01-01' MyDate
UNION ALL
SELECT DateADD(Day,1,MyDate)
FROM C WHERE MyDate <= '2024-01-10')
SELECT * FROM C;

--Use a subquery to find customers who have more than 2 orders.

--Create a CTE that ranks products by how many times they were ordered.

--Write a query using a CTE to find top 2 customers who spent the most.


--Use a CTE + subquery to find, for each product, the maximum quantity ordered in a single order.

--Find all orders where the ordered product price was greater than the average product price.


/*Write a query where:
First CTE fetches customers and total orders.
Second CTE fetches customers and total amount spent.
Main query joins both CTEs.*/


--Find customers who ordered a Laptop using a subquery inside WHERE.



--Recursive CTE to find order dependency (Suppose orders that reference previous orders - can simulate).


--Write a CTE to calculate moving average of order amounts per customer based on order date.



--Find customers whose every order had an amount greater than 300 (using ALL in a subquery).



--Use EXISTS to find products that are included in at least one order.



--Find the customer(s) who placed the maximum total amount of orders (use subquery with aggregation).