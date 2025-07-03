-- Practice Question Case Study 1
use restaurant_case_study
-- 1. Total amount spent by each customer
SELECT s.customer_id, SUM(p.price) AS TotalSpent
FROM sales s 
JOIN menu p
ON p.product_id = s.product_id
GROUP BY s.customer_id;

-- 2. Number of distinct visit days per customer
SELECT customer_id,
COUNT(DISTINCT order_date) AS DistinctVisitDays
FROM sales GROUP BY customer_id;

-- 3. First item purchased by each customern  ---**join
WITH FirstPurchasedItem AS(
SELECT * , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) as 'occurence'
FROM sales)
SELECT customer_id, product_id, order_date FROM FirstPurchasedItem WHERE occurence = 1;

-- 4. Most purchased item and count
SELECT  TOP 1 product_id, COUNT(product_id) as ProductCount
FROM sales
GROUP BY product_id
ORDER BY ProductCount DESC;

-- 5. Most popular item per customer
WITH Item AS(
SELECT s.customer_id, m.product_name, COUNT(m.product_id) AS ItemCount,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY COUNT(m.product_id) DESC) AS ProductRank
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id,s.product_id,m.product_name)
SELECT customer_id, product_name, ItemCount
FROM Item WHERE ProductRank = 1;


-- 6. First item after becoming a member
WITH FirstItem AS(
SELECT s.customer_id,s.product_id,i.product_name, s.order_date , ROW_NUMBER() 
OVER(PARTITION BY s.customer_id ORDER BY s.order_date) as 'occurence'
FROM sales s
JOIN
members m ON s.customer_id = m.customer_id
JOIN menu i ON s.product_id = i.product_id
WHERE s.order_date>=m.join_date
GROUP BY s.customer_id,s.product_id, s.order_date,i.product_name
)
SELECT customer_id, product_id, product_name, order_date FROM FirstItem WHERE occurence = 1;


-- 7. Last item before becoming a member
WITH FirstItem AS(
SELECT s.customer_id,s.product_id,s.order_date , ROW_NUMBER() 
OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) as 'occurence'
FROM sales s
JOIN
members m ON s.customer_id = m.customer_id
WHERE s.order_date<m.join_date
)
SELECT customer_id, product_id, order_date FROM FirstItem WHERE occurence = 1;

-- 8. Items and amount before becoming a member ***sumation of price 
WITH FirstItem AS(
SELECT s.customer_id, s.product_id,i.product_name,i.price, s.order_date, ROW_NUMBER() 
OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) as 'occurence'
FROM sales s
JOIN
members m ON s.customer_id = m.customer_id
JOIN
menu i ON s.product_id = i.product_id
WHERE s.order_date<m.join_date
)
SELECT customer_id, product_id, product_name, price, order_date FROM FirstItem;

-- 9. Loyalty points: 2x for biryani, 1x for others
SELECT s.customer_id,m.product_name,
SUM(
CASE m.product_name
WHEN 'biryani' THEN 2*m.price
ELSE m.price
END
) as LoyaltiPoints FROM
sales s JOIN
menu m ON s.product_id = m.product_id
GROUP BY s.customer_id,m.product_name;

-- 10. Points during first 7 days after joining
SELECT s.customer_id,
SUM(
CASE m.product_name
WHEN 'biryani' THEN 2*m.price
ELSE m.price
END
) as LoyaltiPoints FROM
sales s JOIN
menu m ON s.product_id = m.product_id
JOIN members c ON s.customer_id = c.customer_id
WHERE s.order_date > c.join_date AND s.order_date <= DATEADD(DAY, 7, c.join_date)
GROUP BY s.customer_id;


-- 11. Total spent on biryani
SELECT m.product_name, SUM(m.price) as TotalSpent FROM
sales s JOIN
menu m ON s.product_id = m.product_id
WHERE m.product_name = 'biryani'
GROUP BY m.product_name;

-- 12. Customer with most dosai orders
SELECT s.customer_id AS Customer, COUNT(s.product_id) as NoOfDosaiOrders FROM
sales s JOIN
menu m ON s.product_id = m.product_id
WHERE m.product_name = 'dosai'
GROUP BY s.customer_id
ORDER BY NoOfDosaiOrders DESC
;

-- 13. Average spend per visit
WITH SpendVisit AS (
SELECT s.customer_id, s.order_date, SUM(m.price) as TotalSpent FROM
sales s JOIN
menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, s.order_date
)
SELECT customer_id, AVG(TotalSpent) as AverageSpent
FROM SpendVisit
GROUP BY customer_id;

-- 14. Day with most orders in Jan 2025
SELECT TOP 1 FORMAT(order_date, 'dd MMM') AS DayMonth, COUNT(*) as OrderCount FROM sales
WHERE  YEAR(order_date) = 2025 AND MONTH(order_date)=1
GROUP BY order_date
ORDER BY OrderCount DESC;

-- 15. Customer who spent the least
SELECT TOP 1 s.customer_id,
SUM(m.price) AS TotalSpent
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY TotalSpent;

-- 16. Date with most money spent
SELECT TOP 1 s.order_date,
SUM(m.price) AS TotalSpent
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.order_date
ORDER BY TotalSpent DESC;

-- 17. Customers with multiple orders on same day
SELECT s.customer_id,s.order_date,
COUNT(*) AS NumberofOrders
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id, s.order_date
HAVING COUNT(*)>1;

-- 18. Visits after membership
SELECT s.customer_id, COUNT(*) AS TotalVisits
FROM sales s JOIN members m
ON s.customer_id = m.customer_id
WHERE s.order_date > m.join_date
GROUP BY s.customer_id;

-- 19. Items never ordered
SELECT m.product_id, m.product_name AS item_never_ordered
FROM menu m LEFT JOIN sales s
ON s.product_id = m.product_id
WHERE s.product_id IS NULL;

-- 20. Customers who ordered but never joined
SELECT DISTINCT s.customer_id AS CustomerNeverJoined
FROM sales s LEFT JOIN members m
ON s.customer_id = m.customer_id
WHERE m.customer_id IS NULL;

--OR

SELECT DISTINCT customer_id FROM sales WHERE customer_id
NOT IN(SELECT customer_id FROM members);
