--Basic SQL (SELECT, WHERE, ORDER BY, LIMIT)
--•	List all customers.
select * from Customer;

--•	Show all tracks with their names and unit prices.
select distinct TrackId, name, UnitPrice from track;

--•	List all employees in the sales department.
select * from employee
where title in ('Sales Manager', 'Sales Support Agent');

--•	Retrieve all invoices from the year 2011.
select * from Invoice where year(InvoiceDate) = 2011;

--•	Show all albums by "AC/DC".
select alb.Title
from Artist a join Album alb on a.ArtistId = alb.ArtistId
where a.Name = 'AC/DC';

--•	List tracks with a duration longer than 5 minutes.
select Name, (Milliseconds/60000) as duration_in_mins from Track where (Milliseconds/60000) > 5
order by duration_in_mins;

--•	Get the list of customers from Canada.
select * from Customer where Country = 'Canada';

--•	List 10 most expensive tracks.
select top 10 * from track order by UnitPrice desc;

--•	List employees who report to another employee.
select (e2.FirstName + ' ' + e2.LastName) as employee_name, (e1.FirstName + ' '+ e1.LastName) as reports_to
from Employee e1 join Employee e2
on e1.EmployeeId = e2.ReportsTo

--•	Show the invoice date and total for invoice ID 5.
select InvoiceId, cast(InvoiceDate as date) Date, total from Invoice where InvoiceId = 5


--SQL Joins (INNER, LEFT, RIGHT, FULL)
--•	List all customers with their respective support representative's name.
select (c.FirstName + ' ' + c.LastName) customer_name, (e.FirstName + ' ' + e.LastName) as SupportRepresentative
from Customer c left join Employee e on c.SupportRepId = e.EmployeeId

--•	Get a list of all invoices along with the customer name.
select InvoiceId, (c.FirstName + ' '+c.LastName) customer_name, 
InvoiceDate, BillingAddress, Total
from Invoice i left join Customer c on i.CustomerId = c.CustomerId

--•	Show all tracks along with their album title and artist name.
select t.Name, a.Title as AlbumTitle, art.Name ArtistName
from Track t left join Album a on t.AlbumId = a.AlbumId
join Artist art on a.ArtistId = art.ArtistId

--•	List all playlists and the number of tracks in each.
select p.PlaylistId, p.Name, count(pt.TrackId) num_of_tracks
from Playlist p left join PlaylistTrack pt on p.PlaylistId = pt.PlaylistId
group by p.PlaylistId, p.Name;

--•	Get the name of all employees and their managers (self-join).
select (e2.FirstName + ' ' + e2.LastName) EmployeeName, (e1.FirstName +' '+ e1.LastName) ManagerName, e1.Title
from Employee e1 right join Employee e2
on e1.EmployeeId = e2.ReportsTo

--•	Show all invoices with customer name and billing country.
select i.InvoiceId, (c.FirstName + ' ' + c.LastName) as [Customer Name], i.BillingCountry
from Invoice i left join Customer c on i.CustomerId = c.CustomerId

--•	List tracks along with their genre and media type.
select t.Name TrackName, g.Name Genre, mt.Name MediaType
from Track t join Genre g on t.GenreId = g.GenreId
join MediaType mt on t.MediaTypeId = mt.MediaTypeId

--•	Get a list of albums and the number of tracks in each.
select a.Title, count(t.TrackId) num_of_tracks
from Album a join Track t on a.AlbumId = t.AlbumId
group by t.AlbumId, a.Title;

--•	List all artists with no albums.
select a.Name ArtistName
from Artist a left join Album ab on a.ArtistId = ab.ArtistId
where ab.ArtistId is null;

--•	Find all customers who have never purchased anything.
select (c.FirstName + ' ' + c.LastName) customer_name
from Customer c left join Invoice i on c.CustomerId = i.CustomerId
where i.CustomerId is null;

--Aggregations and Group By
--•	Count the number of customers in each country.
select Country, count(CustomerId) as number_of_customers 
from Customer group by Country;

--•	Total invoice amount by each customer.
select CustomerId, sum(Total) total_invoice_amount
from Invoice
group by CustomerId;

--•	Average track duration per album.
with cte as(
select AlbumId, concat(avg(Milliseconds/60000), ' ', 'minutes') as avg_track_duration
from track 
group by AlbumId)
select cte.albumid, Title, avg_track_duration
from cte join album on cte.albumid = album.albumid;

--•	Total number of tracks per genre.
with cte as(
select GenreId, count(TrackId) num_of_tracks
from Track
group by GenreId)
select	Genre.Name as GenreName, num_of_tracks
from cte join Genre on cte.GenreId = Genre.GenreId;

--•	Revenue generated per country.
select BillingCountry, Sum(Total) Revenue
from Invoice
group by BillingCountry;

--•	Average invoice total per billing city.
select BillingCity, AVG(Total) AvgInvoiceTotal
from Invoice
group by BillingCity;

--•	Number of employees per title.
select Title, count(EmployeeId) num_of_emps
from Employee
group by Title;

--•	Find the top 5 selling artists.
with cte as(
select t.AlbumId, sum(i.UnitPrice * Quantity) selling_price_total
from Track t join InvoiceLine i on t.TrackId = i.TrackId
join Album a on a.AlbumId = t.AlbumId
group by t.AlbumId)
select  a.AlbumId, ar.ArtistId, a.Title as AlbumTitle, ar.Name ArtistName, selling_price_total
from cte c join Album a on c.AlbumId = a.AlbumId
join Artist ar on ar.ArtistId = a.ArtistId
order by selling_price_total desc

-----
with cte as(
select AlbumId, count(AlbumId) sold_alb_cnt
from track
group by AlbumId)
select *
from cte c left join Album alb on c.AlbumId = alb.AlbumId
join Artist a on a.ArtistId = alb.ArtistId
order by sold_alb_cnt desc

--•	Number of playlists containing more than 10 tracks.
select count(PlaylistId) num_of_playlist from (
select PlaylistId, count(TrackId) count_track
from PlaylistTrack
group by PlaylistId) as tracks_cnt
where count_track > 10

--•	Top 3 customers by invoice total.
select top 3 (c.FirstName + ' ' + c.LastName) customer_name, Total
from Invoice i join Customer c on i.CustomerId = c.CustomerId
order by Total desc

--Subqueries (Scalar, Correlated, IN, EXISTS)
--•	Get customers who have spent more than the average.
select customerid, total_spent from(
select CustomerId, sum(total) total_spent
from invoice
group by CustomerId ) as customer_spent
where total_spent > (select avg(total) from invoice);

--•	List tracks that are more expensive than the average price.
select Name as TrackName, UnitPrice
from Track
where UnitPrice > (select avg(UnitPrice) from track);

--•	Get albums that have more than 10 tracks.
select t.albumid, a.Title, count(TrackId) num_of_tracks
from track t join Album a on t.AlbumId = a.AlbumId
group by t.AlbumId, a.Title
having count(TrackId) > 10
order by num_of_tracks desc

--•	Find artists with more than 1 album.
select ar.Name, count(a.AlbumId) num_of_albums
from Album a join Artist ar on a.ArtistId = ar.ArtistId
group by a.ArtistId, ar.Name
having count(a.AlbumId) > 1
order by num_of_albums

--•	Get invoices that contain more than 5 line items.
select invoiceid, no_of_line_items from(
select invoiceid, count(InvoiceLineId) no_of_line_items
from InvoiceLine
group by InvoiceId) as invoice_line_cnt
where no_of_line_items > 5
order by no_of_line_items;

--•	Find tracks that do not belong to any playlist.
select t.Name
from Track t 
where not exists (
select 1 from PlaylistTrack pt 
where pt.TrackId = t.trackid
)

--•	List customers with invoices over $15.
select (c.FirstName + ' ' + c.LastName) customer_name, i.Total
from Invoice i join Customer c on i.CustomerId = c.CustomerId
where total > 15

--•	Show customers who have purchased all genres.
select i.CustomerId, count(distinct t.GenreId) num_of_genres_purchased
from invoice i join InvoiceLine il on i.InvoiceId = il.InvoiceId
join track t on il.TrackId = t.TrackId
group by customerid;

--***there are 25 genres and there is no user who purchased all genres
--the user with id 57 is having max num of genre purchased i.e. 12

--•	Find customers who haven’t bought from the 'Rock' genre.
select distinct c.CustomerId, c.FirstName, c.LastName 
from Customer c 
where not exists 
(select 1 from invoice i join InvoiceLine il on i.InvoiceId = il.InvoiceId
join track t on il.TrackId = t.TrackId
join Genre g on t.GenreId = g.GenreId
where i.CustomerId = c.CustomerId and g.Name = 'Rock')

--•	List tracks where unit price is greater than the average unit price of its media type.
select t.Name as Track, t.UnitPrice from track t
where exists (
select 1
from Track t1
group by MediaTypeId
having t.MediaTypeId = t1.MediaTypeId and t.UnitPrice > avg(unitprice) ) 
order by t.UnitPrice;

--Advanced Joins and Set Operations
--•	Get tracks in both 'Rock' and 'Jazz' playlists.
select t.Name
from Track t join Genre g on t.GenreId = g.GenreId
where g.Name = 'Rock'
Intersect
select t.Name
from Track t join Genre g on t.GenreId = g.GenreId
where g.Name = 'Jazz'

--select * from Track where name in ('Believe','Gypsy','Midnight','Surrender' ) order by name;

--•	List all tracks that are in 'Pop' but not in 'Rock' playlists.
select t1.trackID, t1.name from Track t1 where t1.Name in (
select t.Name
from Track t join Genre g on t.GenreId = g.GenreId
where g.Name = 'Pop'
Except
select t.Name
from Track t join Genre g on t.GenreId = g.GenreId
where g.Name = 'Rock'
)

--•	Union customers from USA and Canada.
select * from Customer where Country = 'USA'
Union
select * from Customer where Country = 'Canada'

--•	Intersect customers from Canada and those who bought ‘AC/DC’ albums.
select customerid, Customer.FirstName
from Customer 
where Country = 'Canada'
Intersect
select c.CustomerId, c.FirstName--, country, al.AlbumId, a.ArtistId
from Customer c join invoice i on c.CustomerId = i.CustomerId
join InvoiceLine il on i.InvoiceId = il.InvoiceId
join Track t on il.TrackId = t.TrackId
join Album al on t.AlbumId = al.AlbumId
join Artist a on al.ArtistId = a.ArtistId
where a.Name = 'AC/DC'

--•	Get artists that have albums but no tracks.
select a.ArtistId, a.Name as Artist_name, al.AlbumId, al.Title, t.TrackId
from album al join Artist a on al.ArtistId = a.ArtistId
left join track t on t.AlbumId = al.AlbumId
where t.TrackId is null

--** All the artists having albums are having tracks, there is no artist with album and without any track.

--•	Find employees who are not assigned any customers.
select e.EmployeeId, e.FirstName, e.LastName
from Employee e left join Customer c on e.EmployeeId = c.SupportRepId
where c.SupportRepId is null

--•	List invoices where total is greater than the sum of any other invoice.
select invoiceid, total from Invoice i
where total > all ( select total from invoice where InvoiceId != i.InvoiceId);

--•	Get customers who have made more than 5 purchases using a correlated subquery.
select c.CustomerId, c.FirstName
from customer c where
(select count(i.InvoiceId) from Invoice i 
where i.CustomerId = c.CustomerId) > 5;

--•	List tracks that appear in more than 2 playlists.
select trackid, name from Track t where(
select count(*)
from PlaylistTrack pt
where pt.TrackId = t.TrackId) > 2

--•	Show albums where all tracks are longer than 3 minutes.
select a.AlbumId, a.Title from Album a
where not exists (
select 1
from track t
where a.AlbumId = t.AlbumId and t.Milliseconds < 180000)

--using not in
select a.AlbumId, a.Title from Album a
where a.albumid not in (
select albumid
from track t
where a.AlbumId = t.AlbumId and t.Milliseconds <= 180000)

--Window Functions
--•	Rank customers by total spending.
select CustomerId, sum(total) total_spend,
rank() over(order by sum(total) desc) rnk
from invoice
group by CustomerId;

--•	Show top 3 selling genres per country.
with cte as(
select i.BillingCountry, t.GenreId, sum(i.Total) ttl_sales
from InvoiceLine il join invoice i on il.InvoiceId = i.InvoiceId
join Track t on il.TrackId = t.TrackId
group by i.BillingCountry, t.GenreId
),--order by i.BillingCountry
cte1 as(
select BillingCountry, genreid, ttl_sales,
rank() over(partition by billingcountry order by ttl_sales desc) rnk
from cte c)

select BillingCountry, g.Name as GenreName, ttl_sales Top3Sales
from cte1 c join Genre g on c.GenreId = g.GenreId
where c.rnk < 4

--•	Get running total of invoice amounts by customer.
select CustomerId, InvoiceId, Total, 
sum(total) over(partition by customerid order by total rows between unbounded preceding and current row) running_total
from Invoice

--•	Find the invoice with the highest amount per customer.
select invoiceid, customerid, total as highest_amount from(
select InvoiceId, CustomerId, total,
rank() over(partition by customerid order by total desc) rnk
from invoice) as rnk_customers
where rnk = 1;

--•	Get the dense rank of employees by hire date.
select (FirstName + ' '+ LastName) EmpName, Hiredate,
DENSE_RANK() over(order by hiredate) drnk_by_hire_date
from Employee

--•	List tracks along with their rank based on unit price within each genre.
select Name as track_name, genreid, unitprice,
rank() over(partition by genreid order by unitprice) rnk_track
from track;

--•	Compute average invoice total by country using window functions.
select distinct BillingCountry, avg(total) over(partition by billingcountry) avg_invoice_total
from invoice;

--•	Show lag/lead of invoice totals per customer.
select InvoiceId, customerid, total, lag(total) over(partition by customerid order by total) pre_total,
lead(total) over(partition by customerid order by total) post_total
from Invoice;

--•	List customers and their second highest invoice.
select customerid, firstname+ ' ' + lastname as CustomerName, invoiceid, total from(
select i.invoiceid, i.CustomerId, c.FirstName, c.LastName, total,
rank() over(partition by i.customerid order by total desc) rnk
from invoice i join Customer c on i.CustomerId = c.CustomerId) as rnk_customer_invoice
where rnk = 2;

--•	Get the difference in invoice total from previous invoice for each customer.
select InvoiceId, customerid, total, 
(total - isnull(lag(total) over(partition by customerid order by total),0)) diff_invoice_total
from Invoice;

--CTEs and Recursive Queries
--•	List employees and their managers using recursive CTE.
with cte as(
select e.EmployeeId, e.FirstName, e.ReportsTo, cast(null as nvarchar(20)) as manager_name, 0 as level
from Employee e
where e.ReportsTo is null
union all
select e1.employeeid, e1.firstname, e1.ReportsTo, e2.FirstName, level+ 1 
from Employee e1 join cte c on e1.ReportsTo = c.EmployeeId
join Employee e2 on e1.ReportsTo = e2.EmployeeId
)
select * from cte;

--•	Use CTE to get top 3 customers by total spending.
with cte as(
select top 3 customerid, sum(total) total_spend
from Invoice i
group by CustomerId
order by total_spend desc)
select c.customerid, (ct.FirstName + ' ' + ct.lastname) customer_name, total_spend
from cte c join Customer ct on c.CustomerId = ct.CustomerId;

--•	Create a CTE to list all invoice lines for albums by 'Metallica'.
with cte as(
select il.InvoiceLineId, il.InvoiceId, al.Title, al.ArtistId
from InvoiceLine il join Track t on il.TrackId = t.TrackId
join Album al on t.AlbumId =  al.AlbumId)

select InvoiceId, InvoiceLineId, title as AlbumName
from cte c join Artist a on c.ArtistId = a.ArtistId
where a.Name = 'Metallica'
order by Title

--•	Use a CTE to show all tracks that appear in more than one playlist.
with cte as(
select t.TrackId, t.Name, count(distinct pt.PlaylistId) playlist_count
from track t join PlaylistTrack pt on t.TrackId = pt.TrackId
group by t.TrackId, t.Name)
select * from cte
where playlist_count > 1;

--•	Recursive CTE to list employee hierarchy (if > 2 levels).
with cte as(
select e.EmployeeId, e.FirstName, e.ReportsTo, cast(null as nvarchar(50)) as emp_hierarchy, 0 as level
from Employee e
where e.ReportsTo is null
union all
select e1.employeeid, e1.firstname, e1.ReportsTo, 
cast(concat(emp_hierarchy , '->' , e2.FirstName) as nvarchar(50)) emp_hierarchy , level+ 1 
from Employee e1 join cte c on e1.ReportsTo = c.EmployeeId
join Employee e2 on e1.ReportsTo = e2.EmployeeId
)
select * from cte where level >= 2;

--•	CTE to get all albums with total track time > 30 minutes.
with cte as(
select AlbumId, sum(Milliseconds) total_track_time_ms
from track
group by AlbumId
having sum(Milliseconds) > 1800000)
select a.Title, (total_track_time_ms/60000) as track_time_in_minutes
from cte c join Album a on c.AlbumId = a.AlbumId;

--•	Get top 5 albums by total revenue using CTE and window functions.
with cte as(
select AlbumId, sum(il.unitprice * quantity) total_revenue
from Track t left join InvoiceLine il on t.TrackId = il.TrackId
group by AlbumId)
select top 5 a.Title, total_revenue, row_number() over(order by total_revenue desc) as rnk
from cte c join Album a on  c.AlbumId = a.AlbumId

--•	Use CTE to find average track price per genre and filter only those above global average.
with cte as(
select GenreId, AVG(UnitPrice) avg_price
from Track t
group by GenreId)
select g.Name as Genre, avg_price
from cte c join Genre g on c.GenreId = g.GenreId
where avg_price > (select avg(unitprice) from Track)

--•	CTE to find customers with the longest names.
with cte as(
select (c.FirstName + ' ' + c.LastName) customer_name
from Customer c),
cte1 as(
select customer_name, len(customer_name) name_length,
rank() over(order by len(customer_name) desc) rnk
from cte)
select customer_name as [customer with longest name], name_length
from cte1 where rnk = 1;

--•	Create a CTE to rank all albums by number of tracks.
with cte as(
select AlbumId, count(trackid) num_of_tracks
from track
group by AlbumId)
select * , dense_rank() over(order by num_of_tracks desc) rnk_album
from cte;

--Advanced Analytics
--•	Get month-over-month revenue change.
with cte as(
select year(InvoiceDate) [Year], month(InvoiceDate) [Month], sum(total) total_revenue
from Invoice
group by year(InvoiceDate), month(InvoiceDate))
select Year, month, total_revenue,
lag(total_revenue) over(order by year, month) as previous_month_revenue,
((total_revenue-lag(total_revenue) over(order by year, month)) * 100/lag(total_revenue) over(order by year, month)) mom_change_percentage
from cte
order by year, month

--•	Calculate customer lifetime value.
select customerid,
sum(total) / count(distinct month(InvoiceDate)) AS avg_monthly_revenue
from Invoice
group by customerid;

--•	Get retention: how many customers returned for a second purchase?
select count(customerid) as num_of_customers_made_2nd_purchase from (
select customerid, count(InvoiceId) num_of_purchase
from Invoice
group by CustomerId
having count(InvoiceId) > 1) as customer_purchase_count

--•	Identify top selling track in each country.
with cte as(
select i.BillingCountry, t.trackid, t.name, sum(il.UnitPrice * il.Quantity) total_sales
from invoice i join InvoiceLine il on i.InvoiceId =  il.InvoiceId
join Track t on t.TrackId = il.TrackId
group by BillingCountry, t.TrackId, t.Name)
select BillingCountry, Name, total_sales from (
select *, row_number() over(partition by billingcountry order by total_sales desc) as rank_sales
from cte) country_sales_rnk
where rank_sales = 1

--•	Show invoice trends by quarter.
select year(InvoiceDate), datepart(QUARTER, InvoiceDate) invoice_quarter,
count(InvoiceId) invoice_count, sum(total) total_sales
from Invoice
group by year(InvoiceDate), datepart(QUARTER, InvoiceDate)
order by year(InvoiceDate), total_sales;

--•	Count customers acquired per year.
select year(invoicedate) invoice_year, count(distinct CustomerId) customer_acquired
from invoice
group by year(invoicedate);

--•	Find churned customers (no purchases in last 12 months).
with cte as(
select customerid, max(invoicedate) last_purchase_date from(
select InvoiceId, CustomerId, InvoiceDate
from invoice) customer_invoice_info
group by CustomerId)
select CustomerId as churned_customer_id, format(last_purchase_date, 'yyyy-MMM') last_purchased_month
from cte
where datediff(MONTH, last_purchase_date, GETDATE()) >= 12;

--•	Show most played tracks per user (using playlist track if usage data is simulated).
with cte as(
select i.CustomerId, il.InvoiceId, pt.TrackId, t.Name, pt.PlaylistId
from Invoiceline il left join Invoice i on il.InvoiceId = i.InvoiceId
left join track t on t.TrackId = il.TrackId
left join PlaylistTrack pt on pt.TrackId = il.TrackId
--order by CustomerId, pt.PlaylistId, pt.TrackId
)
select customerid, track_name, num_of_times_played from(
select customerid, name as track_name, num_of_times_played, 
rank() over(partition by customerid order by num_of_times_played desc) rnk from(
select customerid, TrackId, Name, count(*) num_of_times_played
from cte 
group by CustomerId, TrackId, Name) as customer_played_track_count) as rnk_tracks
where rnk = 1

--•	Simulate cohort analysis by signup month.
with cte as(
select customerid, year(min(invoicedate)) year_of_month, DATENAME(MONTH, (min(invoicedate))) signup_month
from Invoice
group by CustomerId)
select year_of_month, signup_month, count(customerid) num_of_customers_acquired
from cte
group by year_of_month, signup_month
order by year_of_month


--•	Calculate total revenue per artist using joins and group by.
select a.ArtistId, a.Name, isnull(sum(il.Quantity * il.UnitPrice), 0) total_revenue
from Artist a left join Album al on a.ArtistId  = al.ArtistId
left join track t on t.AlbumId = al.AlbumId
left join InvoiceLine il on t.TrackId = il.TrackId
group by a.artistid, a.Name
order by a.ArtistId

--Data Validation and Integrity Checks
--•	Find invoice lines with NULL unit price.
select * from InvoiceLine where UnitPrice is null;

--•	Detect duplicate tracks (by name, album, duration).
select Name as duplicateTrackName, AlbumId, count(TrackId) cnt
from Track
group by Name, AlbumId--, Milliseconds
having count(trackid) > 1

--***there is no duplicate track if we see the duration too along with name and album

--•	List tracks with unit price < 0.
select trackid, Name, UnitPrice
from Track
where UnitPrice < 0;

--•	Find customers with missing emails.
select customerid, (FirstName + ' ' + LastName) customer_name
from Customer 
where Email is null or Email = ''

--•	Check for invoices without invoice lines.
select i.*, il.InvoiceLineId
from Invoice i left join InvoiceLine il on i.InvoiceId = il.InvoiceId
where i.InvoiceId is null

--•	Validate if total in invoices match the sum of invoice lines.
select i.invoiceid, sum(il.Quantity * il.UnitPrice) invoice_line_total, i.Total invoice_total
from Invoice i join InvoiceLine il on i.InvoiceId = il.InvoiceId
group by i.invoiceid, i.Total

--•	Find tracks assigned to multiple genres (data anomaly).
select TrackId, GenreId, count(distinct GenreId)
from track
group by TrackId, GenreId
having count(distinct GenreId) >1

--•	Check for albums without artists.
select *
from Album
where ArtistId is null or ArtistId = '';

--•	List employees who support more than 20 customers.
select e.EmployeeId, (e.firstname + ' '+ e.lastname) emp_name, count(c.CustomerId) support_customers_count
from Employee e join Customer c on e.EmployeeId = c.SupportRepId
group by EmployeeId, e.firstname, e.lastname
having count(c.CustomerId) > 20

--•	Show customers who have the same first and last names.
select CustomerId, FirstName, LastName
from Customer c where 
FirstName in (select firstname from Customer c1 where c1.CustomerId != c.CustomerId) and
LastName in (select lastname from Customer c2 where c2.CustomerId != c.CustomerId);

--Business Scenarios
--•	Recommend top 3 tracks for a customer based on genre preference. ****
with cte as(
select i.CustomerId, t.GenreId, t.TrackId
from Invoice i join invoiceline il on i.InvoiceId = il.InvoiceId
join track t on t.TrackId = il.TrackId),
--order by CustomerId
cte1 as(
select CustomerId, GenreId from(
select CustomerId, GenreId,row_number() over(partition by customerid order by count(genreid) desc) rnk_genre
from cte
group by CustomerId,GenreId) rnk_genre
where rnk_genre < 4),
cte2 as(
select t.TrackId, t.name, t.GenreId, sum(il.UnitPrice * il.Quantity) total_sales
from InvoiceLine il join track t on il.TrackId = t.TrackId
group by t.TrackId, t.name, t.GenreId
),
cte3 as(
select c1.CustomerId, c2.TrackId, c2.Name, c2.total_sales,
ROW_NUMBER() over(partition by customerid order by total_sales desc) rnk_track
from cte1 c1 join cte2 c2 on c1.GenreId = c2.genreid
where c2.TrackId not in(select TrackId from cte where cte.CustomerId = c1.CustomerId)
)

select CustomerId, name as track_name, total_sales
from cte3
where rnk_track < 4;



--•	Identify slow-moving tracks (not sold in last 12 months).


--•	Get summary of purchases per customer per genre.
--•	Find the artist with highest average track duration.
--•	Show difference in price between highest and lowest track per genre.
--•	Find customers who buy only once vs those who buy multiple times.
--•	List countries with the most revenue per capita (assume fixed population per country).
--•	Recommend albums with similar genre to customer past purchases.
--•	Estimate revenue impact if top 10% customers churn.
--•	Calculate the average invoice total per support rep’s customer group.
