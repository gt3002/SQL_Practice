--CREATE SCHEMA adinsight_analytics;
--GO

CREATE DATABASE adinsight_analytics;

-- Drop table if exists (MSSQL syntax)
IF OBJECT_ID('raw_json_data', 'U') IS NOT NULL
  DROP TABLE adinsight_analytics.raw_json_data;
GO

-- Create table for raw JSON data
CREATE TABLE raw_json_data (
  raw_data NVARCHAR(MAX)
);
GO

-- Create interest map table
CREATE TABLE interest_map (
  id INT PRIMARY KEY,
  interest_name NVARCHAR(255),
  interest_summary NVARCHAR(MAX),
  created_at DATETIME,
  last_modified DATETIME
);
GO

UPDATE interest_map
SET interest_summary = NULL
WHERE interest_summary = '';
GO

-- Create the interest_metrics table
CREATE TABLE interest_metrics (
  month TINYINT,
  year SMALLINT,
  month_year CHAR(7),
  interest_id INT,
  composition FLOAT,
  index_value FLOAT,
  ranking INT,
  percentile_ranking FLOAT
);
GO
--=============================================================================================

--**AdInsight Analytics: Case Study Questions**

--The following are core business questions designed to be explored using SQL queries and logical reasoning.
--These will help AdInsight
--Analytics gain actionable insights into customer behavior and interest segmentation.

-----

--### Data Exploration and Cleansing

--1. Update the `month_year` column in `adinsight_analytics.interest_metrics` to be of `DATE` type, with values
--representing the first day of each month.
Alter table interest_metrics
alter column month_year char(10);

update interest_metrics
set month_year = parse(month_year as date)

Alter table interest_metrics
alter column month_year date;

--2. Count the total number of records for each `month_year` in the `interest_metrics` table, sorted 
--chronologically, ensuring that NULL values (if any) appear at the top.
select month_year, count(*) total_records
from interest_metrics
group by month_year
order by month_year;

select * from interest_metrics where month_year is null;


--3. Based on your understanding, what steps should be taken to handle NULL values in the `month_year` column?


--4. How many `interest_id` values exist in `interest_metrics` but not in `interest_map`? And how many exist in 
--`interest_map` but not in `interest_metrics`?

with cte as(
select count(interest_id) as not_in_interest_map_count
from interest_metrics
where not exists(select id
from interest_map)
),
cte1 as(
select count(id) as not_in_interest_metrics_count
from interest_map
where not exists(select interest_id
from interest_metrics))

select not_in_interest_map_count, not_in_interest_metrics_count from cte, cte1;

--*****

with cte as(
select count(interest_id) i_metrix_count from (
select interest_id
from interest_metrics
EXCEPT 
select id from interest_map) imetrix
),
cte1 as(
select count(id) i_map_count from(
select id
from interest_map
EXCEPT 
select interest_id from interest_metrics) imap
)

select i_metrix_count, i_map_count from cte, cte1;


--5. Summarize the `id` values from the `interest_map` table by total record count.
select interest_name, count(*) total_records
from interest_map
group by interest_name

--6. What type of join is most appropriate between the `interest_metrics` and `interest_map` tables for analysis? 
--Justify your approach and verify it by retrieving data where `interest_id = 21246`, including all columns from 
--`interest_metrics` and all except `id` from `interest_map`.
select interest_metrics.*, interest_name, interest_summary, created_at, last_modified
from interest_map left join interest_metrics
on id = interest_id
where interest_id = 21246;

--7. Are there any rows in the joined data where `month_year` is earlier than `created_at` in `interest_map`? 
--Are these values valid? Why or why not?
select interest_id, month_year,created_at
from interest_metrics left join interest_map
on id = interest_id
where month_year < created_at
order by interest_id

--=============================

--### Interest Analysis

--8. Which interests appear consistently across all `month_year` values in the dataset?
with interests as(
select interest_id, count(distinct month_year) month_count
from interest_metrics
where interest_id is not null
group by interest_id)

select i.interest_id, im.interest_name
from interests i join interest_map im
on i.interest_id = im.id
where month_count = (select count(distinct month_year) from interest_metrics)

--9. Calculate the cumulative percentage of interest records starting from those present in 14 months. 
--What is the `total_months` value where the cumulative percentage surpasses 90%?
with interests as(
select interest_id, count(distinct month_year) month_count
from interest_metrics
where interest_id is not null
group by interest_id),

cum_dist as(
select interest_id, month_count,
CUME_DIST() over(order by month_count) * 100 as cumulative_dist
from interests)

select interest_id, month_count as total_months, cumulative_dist
from cum_dist
where cumulative_dist >= 90


--10. If interests with `total_months` below this threshold are removed, how many records would be excluded?
with interests as(
select interest_id, count(distinct month_year) month_count
from interest_metrics
where interest_id is not null
group by interest_id),

cum_dist as(
select interest_id, month_count,
CUME_DIST() over(order by month_count) * 100 as cumulative_dist
from interests)

select interest_id, month_count as total_months, cumulative_dist--, count(*) num_of_records_removed
from cum_dist
where cumulative_dist < 90

--11. Evaluate whether removing these lower-coverage interests is justified from a business perspective. 
--Provide a comparison between a segment with full 14-month presence and one that would be removed.



--12. After filtering out lower-coverage interests, how many unique interests remain for each month?
with cte as (
select distinct month_year, avg(composition) as average
from interest_metrics
where month_year is not null
group by month_year
--order by month_year2
),
 
cte2 as (
select month_year, interest_name, composition
from interest_metrics left join interest_map
on id = interest_id
where interest_name is not null and month_year is not null
),
cte3 as (
select cte2.month_year, cte2.interest_name, cte2.composition, cte.average
from cte join cte2
on cte.month_year = cte2.month_year
where cte2.composition >= cte.average 
--order by month_year2
)
 
select month_year, count(interest_name) as unique_interest_count
from cte3
group by month_year
order by month_year;

---

--### Segment Analysis

--13. From the filtered dataset (interests present in at least 6 months), identify the top 10 and bottom 10 
--interests based on their maximum `composition` value. Also, retain the corresponding `month_year`.
with interests as(
select interest_id, count(distinct month_year) month_count
from interest_metrics
where interest_id is not null
group by interest_id
having count(distinct month_year) > 5
),

compositions as(
select im.interest_id, imap.interest_name, im.month_year, im.composition,
Rank() over(partition by im.interest_id order by composition desc) int_rank
from interest_metrics im join interests i
on im.interest_id = i.interest_id
join interest_map imap on im.interest_id = imap.id),

max_copositions as(
select interest_id, interest_name, month_year, composition from compositions
where int_rank = 1
),

cte as(
select interest_name as top_interests, month_year, composition,
row_number() over(order by composition desc) rn
from max_copositions
),

cte2 as(
select interest_name as bottom_interests, month_year, composition,
row_number() over(order by composition) rn1
from max_copositions
)

select cte.top_interests,cte.composition,cte.month_year,
cte2.bottom_interests, cte2.composition,cte2.month_year from 
cte join cte2 on rn = rn1
where rn < 11 and rn1 < 11
order by rn, rn1

--14. Identify the five interests with the lowest average `ranking` value.
select top 5 interest_id, interest_name, avg(ranking) avg_rank from interest_metrics im join 
interest_map imap on interest_id = id
where interest_id is not null
group by interest_id, interest_name
order by avg(ranking);

--15. Determine the five interests with the highest standard deviation in their `percentile_ranking`.
select top 5 interest_id, round(STDEV(percentile_ranking),2) as std_deviation 
--into #high_std_interests
from interest_metrics
where interest_id is not null
group by interest_id
order by STDEV(percentile_ranking) desc;

select * from #high_std_interests;

--16. For the five interests found in the previous step, report the minimum and maximum `percentile_ranking`
--values and their corresponding `month_year`. What trends or patterns can you infer from these fluctuations?
with cte as(
select hi.interest_id, min(im.percentile_ranking) min_percentile_ranking,
max(im.percentile_ranking) max_percentile_ranking
from #high_std_interests hi left join interest_metrics im
on hi.interest_id = im.interest_id
group by hi.interest_id)

select interest_metrics.interest_id, interest_map.interest_name, interest_metrics.percentile_ranking, interest_metrics.month_year,
(case 
when cte.max_percentile_ranking = interest_metrics.percentile_ranking then 'Maximum'
when cte.min_percentile_ranking = interest_metrics.percentile_ranking then 'Minimum' end)
as rank_type
from interest_metrics join cte on cte.interest_id = interest_metrics.interest_id
join interest_map on id = interest_metrics.interest_id
where interest_metrics.percentile_ranking IN (cte.max_percentile_ranking, cte.min_percentile_ranking)
order by interest_id


--17. Based on composition and ranking data, describe the overall customer profile represented in this segment.
--What types of products/services should be targeted, and what should be avoided?

---

--### Index Analysis

--18. Calculate the average composition for each interest by dividing `composition` by `index_value`,
--rounded to 2 decimal places.
with cte as(
select interest_id, composition/index_value as avg_composition_each_int
from interest_metrics
where interest_id is not null
--order by avg_composition desc
)
select interest_id, round(avg(avg_composition_each_int),2) as avg_comp
--into #avg_compositions
from cte
group by interest_id 
order by interest_id;


--19. For each month, identify the top 10 interests based on this derived average composition.
with cte as(
select ac.interest_id, month_year, avg_comp,
rank() over(partition by month_year order by ac.avg_comp desc) rank_comp
from interest_metrics im join #avg_compositions ac 
on im.interest_id = ac.interest_id
where month_year is not null)

select month_year, interest_id, round(avg_comp,2) avg_comp, rank_comp
--into #top10_monthly_interests
from cte
where rank_comp < 11
order by month_year;

--20. Among these top 10 interests, which interest appears most frequently?
with cte as(
select interest_id, count(interest_id) as interest_frequency
from #top10_monthly_interests
group by interest_id)

select interest_name as most_frequent_interests, interest_frequency
from cte left join interest_map on cte.interest_id = interest_map.id
where interest_frequency = (select max(interest_frequency) from cte)

--21. Calculate the average of these monthly top 10 average compositions across all months.
select month_year, avg(avg_comp) avg_monthly_comp
from #top10_monthly_interests
group by month_year;

--22. From September 2018 to August 2019, calculate a 3-month rolling average of the highest average composition.
--Also, include the top interest names for the current, 1-month-ago, and 2-months-ago periods.
with cte as(
select interest_id, imap.interest_name, month_year, composition
from interest_metrics im join interest_map imap on im.interest_id = imap.id
where month_year is not null and month_year between '2018-09-01' and '2019-08-01')

select month_year, avg(composition) avg_comp
from cte
group by month_year


--23. Provide a plausible explanation for the month-to-month changes in the top average composition. 
--Could it indicate any risks or insights into AdInsight’s business model?

-----










