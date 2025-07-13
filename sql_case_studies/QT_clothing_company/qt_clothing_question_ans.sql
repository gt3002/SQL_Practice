--## Question and Solution
--## 📈 A. High Level Sales Analysis

--**1. What was the total quantity sold for all products?**
select s.prod_id, pd.product_name, sum(qty) as total_quantity_sold
from sales s join product_details pd on pd.product_id = s.prod_id
group by s.prod_id, pd.product_name;

--**2. What is the total generated revenue for all products before discounts?**
select s.prod_id, pd.product_name, sum(qty * s.price) as total_revenue_before_discount
from sales s join product_details pd on pd.product_id = s.prod_id
group by s.prod_id, pd.product_name;


--**3. What was the total discount amount for all products?**
select s.prod_id, pd.product_name, sum(discount) as total_discount_amount
from sales s join product_details pd on pd.product_id = s.prod_id
group by s.prod_id, pd.product_name;

--## 🧾 B. Transaction Analysis

--**1. How many unique transactions were there?**
select count(distinct txn_id) num_of_unique_transactions from sales;

--**2. What is the average unique products purchased in each transaction?**
select avg(num_of_unique_products) avg_unique_products from(
select txn_id, count(distinct prod_id) num_of_unique_products
from sales
group by txn_id) as txn_prods

--**3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**
select distinct percentile_cont(0.25) within group(order by revenue_per_txn) over() perc_value_25th,
percentile_cont(0.5) within group(order by revenue_per_txn) over() perc_value_50th,
percentile_cont(0.75) within group(order by revenue_per_txn) over() perc_value_75th
from
( select sum((qty * price) - discount) revenue_per_txn
from sales
group by txn_id ) as txn_revenue

--**4. What is the average discount value per transaction?**
select txn_id, cast(avg(discount) as float) avg_discount_value
from sales
group by txn_id;

--**5. What is the percentage split of all transactions for members vs non-members?**
select
case when member = 1 then 'member'
when member = 0 then 'non-member' end as member_type,
total_txns, 
(cast(total_txns as float)/cast((select count(distinct txn_id) from sales)as float)) * 100 as percentage_split
from(
select member, count(distinct txn_id) total_txns
from sales
group by member) as txn_count

--**6. What is the average revenue for member transactions and non-member transactions?**
select member,
avg((qty * price)- discount) as avg_revenue
from sales
group by member;

--## 👚 C. Product Analysis

--**1. What are the top 3 products by total revenue before discount?**
select top 3 prod_id, product_name, sum(qty * pd.price) total_revenue
from product_details pd join sales s
on pd.product_id = s.prod_id
group by prod_id, product_name
order by total_revenue desc;

--**2. What is the total quantity, revenue and discount for each segment?**
select segment_name, sum(qty) total_quantity, sum(s.price * qty) revenue, sum(discount) total_discount
from product_details pd join sales s
on pd.product_id = s.prod_id
group by segment_name;

--**3. What is the top selling product for each segment?**
with cte as(
select segment_name, product_name, sum(qty) total_sales_qty
from product_details pd join sales s
on pd.product_id = s.prod_id
group by segment_name,product_name),

cte2 as(
select *, rank() over(partition by segment_name order by total_sales_qty desc) rank_product
from cte
)
select segment_name, product_name, total_sales_qty from cte2 where rank_product = 1;

--**4. What is the total quantity, revenue and discount for each category?**
select ph.level_text as category_name, sum(qty) total_quantity, sum(qty * s.price) revenue, sum(discount) total_discount
from product_details pd join product_hierarchy ph on ph.id = pd.category_id
join sales s on pd.product_id = s.prod_id
group by level_text;

--**5. What is the top selling product for each category?**
with cte as(
select ph.level_text as category_name, product_name, sum(qty) total_quantity
from product_details pd join product_hierarchy ph on ph.id = pd.category_id
join sales s on pd.product_id = s.prod_id
group by level_text, product_name),
cte2 as(
select *, rank() over(partition by category_name order by total_quantity desc) prd_rnk
from cte
)
select category_name, product_name, total_quantity from cte2 where prd_rnk = 1;

--**6. What is the percentage split of revenue by product for each segment?**
with cte as(
select segment_name, product_name, sum(qty * s.price) revenue
from product_details pd join sales s
on pd.product_id = s.prod_id
group by segment_name,product_name),
--order by segment_name
cte2 as(
select segment_name, round(sum(revenue),2) ttl_revenue_by_sgmnt
from cte
group by segment_name)

select c.segment_name, c.product_name, round(cast(c.revenue as float)/cast(c1.ttl_revenue_by_sgmnt as float) * 100,2) percentage_split
from cte c join cte2 c1 on c.segment_name = c1.segment_name
order by segment_name

--**7. What is the percentage split of revenue by segment for each category?**
with cte as(
select segment_name, category_name, sum(qty * s.price) revenue
from product_details pd join sales s
on pd.product_id = s.prod_id
group by category_name,segment_name),
cte2 as(
select category_name, sum(revenue) total_revenue from cte 
group by category_name
)
select c.category_name, c.segment_name, round(cast(revenue as float) * 100/cast(total_revenue as float),2) perc_split
from cte c join cte2 c1 on c.category_name = c1.category_name

--**8. What is the percentage split of total revenue by category?**

with cte as(
select category_name, cast(sum(qty * s.price) as float) revenue
from product_details pd join sales s
on pd.product_id = s.prod_id
group by category_name),
cte2 as(
select cast(sum(qty * price) as float) total_revenue from sales
)
select category_name, round(cast((revenue * 100/total_revenue) as float),2) as perc_split
from cte,cte2;

--**9. What is the total transaction “penetration” for each product? 
--(hint: penetration = number of transactions where at least 1 quantity of a product was
--purchased divided by total number of transactions)**
with cte as(
select product_name, cast(count(txn_id) as float) ttl_txn
from product_details pd join sales s
on pd.product_id = s.prod_id
where qty > 0
group by product_name)

select product_name, ttl_txn /cast((select count(txn_id) from sales)as float) penetration
from cte;

--**10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?**
with cte as(
select txn_id, product_name, count(txn_id) cc
from product_details pd join sales s
on pd.product_id = s.prod_id
group by txn_id, product_name)
select *
from cte c1 join cte c2 on c1.txn_id = c2.txn_id


--## 📝 Reporting Challenge

--Write a single SQL script that combines all of the previous questions into a scheduled report that the QT team can run at the beginning of each month to calculate the previous month’s values.

--Imagine that the Chief Financial Officer (which is also QT) has asked for all of these questions at the end of every month.

--He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

--Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

--***

--## 💡 Bonus Challenge

--Use a single SQL query to transform the `product_hierarchy` and `product_prices` datasets to the `product_details` table.

--Hint: you may want to consider using a recursive CTE to solve this problem!

--***