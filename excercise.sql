-- What are all the records in the customers table?
   SELECT * from customers;

-- What are all the records in the orders table?
   SELECT * from orders;

-- What are each customer's name, country, and score?
   SELECT first_name as name, country, score from customers;

-- Which customers have a score that is not zero?
   SELECT * from customers where score <> 0;


-- Which customers are from Germany?
	SELECT * from customers where city='Germany';


-- What are the names and countries of customers from Germany?
   SELECT first_name, country from customers where country='Germany';

-- How can you retrieve all customers ordered by highest score first?
   SELECT* from customers ORDER BY score DESC;

-- How can you retrieve all customers ordered by lowest score first?
   SELECT* from customers ORDER BY score ASC;

-- How can you retrieve all customers ordered alphabetically by country?
   SELECT* from customers ORDER BY country ASC;


-- How can you sort customers by country and then by their score (highest first)?
   SELECT * from customers ORDER BY country ASC, score DESC;


-- Which customers have a non-zero score, sorted from highest to lowest score?
   SELECT * from customers where score != 0 ORDER BY score;

-- What is the total score for each country?
   SELECT country, SUM(score) as 'total_score' from customers GROUP BY(country);


-- Why does this query fail? (Hint: What's missing or incorrect?)
--SELECT country, first_name, SUM(score) AS total_score FROM customers GROUP BY country
  /*In this query we have not specified the first_name column in aggregate function or group by clause
  that's why it is raising error, after removing first_name column from the query it will be executed correctly*/
   

-- What are the total scores and number of customers for each country?
   SELECT country, COUNT(*) as number_of_customers, SUM(score) as total_scores from customers GROUP BY country;

-- What is the average score for each country, and which countries have an average score above 430?
   /*Average score for each country*/
   SELECT country, AVG(score) as average_score from customers GROUP BY country;

   /*Countries having average score > 430*/
   SELECT country, AVG(score) as average_score from customers GROUP BY country HAVING AVG(score)>430;


-- Which countries have an average score above 430, considering only non-zero scores?
   SELECT country, AVG(score) as average_score from customers where score <> 0 GROUP BY country HAVING AVG(score)>430;

-- What are all the unique countries listed in the customers table?
   SELECT DISTINCT country from customers;

-- How can you get only the first 3 customers in the table?
   SELECT TOP 3 * from customers;


-- Who are the top 3 customers with the highest scores?
   SELECT TOP 3 * from customers ORDER BY score DESC;

-- Who are the 2 customers with the lowest scores?
   SELECT TOP 2 * from customers ORDER BY score ASC;

-- What are the two most recent orders placed?
   SELECT TOP 2 * from orders ORDER BY order_date DESC;

-- Which countries have an average score greater than 430 (excluding zero scores), and how can you sort them by highest average?
   SELECT country, AVG(score) as average_score from customers
   where score > 0 GROUP BY country 
   HAVING AVG(score)>430 ORDER BY average_score DESC;



-- Can you run multiple queries at once?
   /* Yes, we can execute multiple queries at once */
   
   
-- How do you return a static number in a query?
   /*to return a static number we write the query like this*/
   SELECT 100 AS static_score;
   --Example:
   SELECT first_name, 100 AS static_score from customers;

-- How do you return a static string in a query?
   --Example:
   SELECT first_name, 'India' AS static_country from customers;

-- How can you add a custom label (like "New Customer") to all rows in your result?
   /* we can add a custom label by using static string with select statement */
   Select 'New Customer' as custom_label, first_name from customers;
