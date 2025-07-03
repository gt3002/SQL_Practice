-- ======================================================
-- Table: customers
-- ======================================================
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    country VARCHAR(50),
    score INT,
    CONSTRAINT pk_customers PRIMARY KEY (id)
);

-- Insert customers data
INSERT INTO customers (id, first_name, country, score) VALUES
    (1, 'Maria', 'Germany', 350),
    (2, 'John', 'USA', 900),
    (3, 'Georg', 'UK', 750),
    (4, 'Martin', 'Germany', 500),
    (5, 'Peter', 'USA', 0),
    (6, 'Anita', 'India', 620),
    (7, 'Luis', 'Mexico', 410),
    (8, 'Sophie', 'France', 580),
    (9, 'Liam', 'Canada', 330),
    (10, 'Chen', 'China', 770);

-- ======================================================
-- Table: orders
-- ======================================================
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE,
    sales INT,
    CONSTRAINT pk_orders PRIMARY KEY (order_id)
);

-- Insert orders data
INSERT INTO orders (order_id, customer_id, order_date, sales) VALUES
    (1001, 1, '2021-01-11', 35),
    (1002, 2, '2021-04-05', 15),
    (1003, 3, '2021-06-18', 20),
    (1004, 6, '2021-08-31', 10),
    (1005, 7, '2021-09-15', 50),
    (1006, 8, '2021-10-10', 25),
    (1007, 1, '2021-12-20', 45),
    (1008, 9, '2022-01-03', 30),
    (1009, 10, '2022-02-25', 60),
    (1010, 2, '2022-03-18', 40);

SELECT * from customers;
SELECT * from orders;  --first from is executed then *(everything)

SELECT 'Mr' as first_name from customers; -- Usecase: using latitude and longitude we can find the country and give a column country name

SELECT * from customers where score > 500;

SELECT country, SUM(score) FROM customers group by country HAVING SUM(score)>500;

SELECT country, SUM(score) FROM customers where score>500 group by country HAVING SUM(score)>500; -- from->where->group by-> select
select distinct country from customers;

SELECT TOP 3 * FROM customers;


INSERT INTO customers VALUES(11, 'Anna', 'USA', NULL), (12, 'Sam', NULL, 100);

INSERT INTO customers(id, first_name, country, score)  VALUES(15, 'Max','CANADA',910);

CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15),
);

INSERT INTO persons(id, person_name, birth_date,phone)
SELECT
id, first_name, NULL, 'Unknown' FROM customers where score>700;

UPDATE customers SET score = 0 where id = 6;        --WHERE CONDITION IS MUST IN UPDATE AND DELETE QUERIES

UPDATE customers SET score = 0, country='USA' where id = 6;

UPDATE customers SET score = 0 WHERE score IS NULL;

SELECT * from customers where score IS NULL;

/*It is a good practice to run select query before delete to check whether the data we are going to delete is actual or not */

select * from customers where id>5;

DELETE FROM customers where id>5;

DELETE FROM persons; -- deletes row by row and is slow

TRUNCATE TABLE persons; --faster as deletes all data in one go, especially useful for large tables