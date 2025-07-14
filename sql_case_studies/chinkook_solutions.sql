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
--•	List tracks that appear in more than 2 playlists.
--•	Show albums where all tracks are longer than 3 minutes.


