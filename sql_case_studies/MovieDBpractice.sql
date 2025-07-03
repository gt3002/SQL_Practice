-- Movie Database Creation Script

-- 1. Create Database
CREATE DATABASE MovieDB;
USE MovieDB;

-- 2. Movies Table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    release_year INT,
    rating FLOAT
);

-- Insert Data into Movies Table
INSERT INTO Movies (movie_id, title, genre, release_year, rating) VALUES
(1, 'Inception', 'Sci-Fi', 2010, 8.8),
(2, 'Titanic', 'Romance', 1997, 7.8),
(3, 'The Godfather', 'Crime', 1972, 9.2),
(4, 'The Dark Knight', 'Action', 2008, 9.0),
(5, 'Avatar', 'Sci-Fi', 2009, 7.9);

-- 3. Actors Table
CREATE TABLE Actors (
    actor_id INT PRIMARY KEY,
    name VARCHAR(100),
    birth_year INT,
    nationality VARCHAR(50)
);

-- Insert Data into Actors Table
INSERT INTO Actors (actor_id, name, birth_year, nationality) VALUES
(1, 'Leonardo DiCaprio', 1974, 'American'),
(2, 'Christian Bale', 1974, 'British'),
(3, 'Al Pacino', 1940, 'American'),
(4, 'Sam Worthington', 1976, 'Australian'),
(5, 'Morgan Freeman', 1937, 'American');

-- 4. MovieActors Table
CREATE TABLE MovieActors (
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

-- Insert Data into MovieActors Table
INSERT INTO MovieActors (movie_id, actor_id) VALUES
(1, 1), (1, 4), (2, 1), (3, 3), (4, 2), (4, 5), (5, 4);

-- 5. Reviews Table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    movie_id INT,
    critic_name VARCHAR(100),
    score FLOAT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Insert Data into Reviews Table
INSERT INTO Reviews (review_id, movie_id, critic_name, score) VALUES
(1, 1, 'Critic A', 9.0), (2, 2, 'Critic B', 8.0), (3, 3, 'Critic C', 9.5),
(4, 4, 'Critic D', 9.1), (5, 5, 'Critic E', 7.7);

-- 6. BoxOffice Table
CREATE TABLE BoxOffice (
    movie_id INT,
    domestic_gross BIGINT,
    international_gross BIGINT,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Insert Data into BoxOffice Table
INSERT INTO BoxOffice (movie_id, domestic_gross, international_gross) VALUES
(1, 300000000, 500000000), (2, 600000000, 1500000000), (3, 250000000, 133000000),
(4, 530000000, 470000000), (5, 760000000, 2040000000);

-- Data Validation
SELECT * FROM Movies;
SELECT * FROM Actors;
SELECT * FROM MovieActors;
SELECT * FROM Reviews;
SELECT * FROM BoxOffice;


-- Practice Questions MovieDB


--1. Which movies from each genre are considered the most critically acclaimed based on their ratings?
WITH C AS(
SELECT genre, title, rating,
RANK() OVER(PARTITION BY genre ORDER BY rating DESC) AS rank
FROM Movies)
SELECT genre, title,rating
FROM C WHERE rank = 1
ORDER BY rating DESC;


--2. Can you find the top 3 movies with the highest audience appreciation, regardless of genre?
SELECT TOP 3 m.title, r.score FROM 
Movies m JOIN Reviews r
ON m.movie_id = r.movie_id
ORDER BY r.score DESC;


--3. Within each release year, which movies performed the best in terms of domestic revenue?
WITH C AS(
SELECT m.title, m.release_year,b.domestic_gross,
RANK() OVER(PARTITION BY m.release_year ORDER BY b.domestic_gross) AS rank
FROM Movies m JOIN BoxOffice b
ON m.movie_id = b.movie_id)
SELECT title, release_year, domestic_gross 
FROM C WHERE rank = 1;


--4. Are there any movies within the same genre that have an equal standing *********************
--when it comes to international box office collections?
WITH C AS(
SELECT m.title,m.genre, m.release_year,b.domestic_gross,
RANK() OVER(PARTITION BY m.genre ORDER BY b.domestic_gross) AS rank
FROM Movies m JOIN BoxOffice b
ON m.movie_id = b.movie_id)
SELECT * FROM C


--5. What are the best-rated movies in each genre according to critics?
WITH C AS(
SELECT m.title,m.genre, r.critic_name,r.score, RANK()
OVER(PARTITION BY m.genre ORDER BY r.score) rank
FROM Movies m JOIN Reviews r
ON m.movie_id = r.movie_id)
SELECT * FROM C WHERE rank=1;

--6. How can we divide the movies into four equal groups based on their domestic earnings? *****
SELECT m.title,m.genre, m.release_year,b.domestic_gross,
NTILE(4) OVER(ORDER BY b.domestic_gross) AS MoviesDivision
FROM Movies m JOIN BoxOffice b
ON m.movie_id = b.movie_id

--7. Can we group movies into three distinct categories according to their international revenue?
SELECT m.title,m.genre, m.release_year,b.international_gross,
NTILE(3) OVER(ORDER BY b.international_gross DESC) AS MoviesDivision
FROM Movies m JOIN BoxOffice b
ON m.movie_id = b.movie_id

--8. How would you classify movies based on how they rank in terms of audience rating?
SELECT title,rating,
CASE 
WHEN rating>= 8 THEN 'High Rated'
WHEN rating<=7.9 AND rating >= 6 THEN 'Medium Rated'
ELSE 'Low Rated'
END AS MovieRatingClassification
FROM Movies ORDER BY rating DESC;


--9. If we split the actors based on the number of movies they've acted in, how many groups would we 
--have if we only had two categories?
WITH C AS (
SELECT DISTINCT a.name,
COUNT(*) OVER (PARTITION BY ma.actor_id) AS CountOfMovies
FROM MovieActors ma JOIN Movies m
ON ma.movie_id = m.movie_id
JOIN Actors a
ON ma.actor_id = a.actor_id)
SELECT *, NTILE(2) OVER(ORDER BY CountOfMovies) Category
FROM C;


--10. Can we divide the movies into ten segments based on their total box office performance?
SELECT m.title,m.genre, m.release_year,
NTILE(10) OVER(ORDER BY (b.international_gross + b.domestic_gross) DESC) AS MoviesDivision
FROM Movies m JOIN BoxOffice b
ON m.movie_id = b.movie_id

--11. How would you determine the relative position of each movie based on its critic score?
SELECT m.title,m.genre,r.score, RANK()
OVER(ORDER BY r.score DESC) RelativePosition
FROM Movies m JOIN Reviews r
ON m.movie_id = r.movie_id;


--12. If we look at the movies within a specific genre, how would you find their relative success in terms of 
--domestic box office collection?*************************
WITH C AS (
SELECT m.title, m.genre, b.domestic_gross,
cume_dist() OVER(PARTITION BY m.genre ORDER BY b.domestic_gross DESC) * 100 AS SuccessPercent
FROM Movies m
JOIN BoxOffice b ON m.movie_id = b.movie_id)
SELECT * FROM C;


--13. Considering the movies from the same year, can you identify how well each one did in terms of overall revenue?
WITH C AS (
SELECT m.title, m.release_year, b.domestic_gross,
RANK() OVER(PARTITION BY m.release_year ORDER BY (b.international_gross + b.domestic_gross) DESC) AS Rank
FROM Movies m
JOIN BoxOffice b ON m.movie_id = b.movie_id
)
SELECT * FROM C;

--14. How would you place actors on a timeline based on their birth years, showing how they compare to one another?
WITH C AS(
SELECT DISTINCT ma.actor_id,a.name,a.birth_year,
COUNT(ma.actor_id) OVER(PARTITION BY ma.actor_id) AS CountOfMovies
FROM MovieActors ma join
Actors a ON ma.actor_id = a.actor_id
JOIN Movies m ON ma.movie_id = m.movie_id)
SELECT *, DENSE_RANK() OVER(ORDER BY CountOfMovies DESC) AS RankBasedOnNumberOfMoviesDone
FROM C;

--15. What is the relative standing of each movie's rating within its genre?
SELECT title, genre,
CUME_DIST() OVER(PARTITION BY genre ORDER BY rating) AS RelativeStanding
FROM Movies;

--16. Can you determine how movies from the same genre compare to one another in terms of ratings?
select title,rating, genre, 
rank() over(partition by genre order by rating desc)
as rank_based_on_rating
from Movies;

--17. How do the movies from each release year compare to one another when we look at international revenue?
select m.title, m.release_year, bo.international_gross,
rank() over(partition by m.release_year order by bo.domestic_gross) as rank_comparison
from Movies m join BoxOffice bo
on m.movie_id = bo.movie_id

--18. Among all movies, how would you rate them based on the number of actors they feature?
with c as(
select m.title, count(ma.actor_id) over(partition by ma.movie_id) as count_of_actors
from MovieActors ma join Movies m
on ma.movie_id = m.movie_id)
select title, count_of_actors,
(case 
when count_of_actors = 1 then 3
else 5
end)
as rating
from c group by title, count_of_actors;

--19. Which critics tend to give higher ratings compared to others, and how do they rank?
select critic_name, score as ratings,
rank() over(order by score desc) as ranking
from Reviews;

--20. How does each movie fare when comparing their total box office income to others?
select m.title, (bo.domestic_gross + bo.international_gross) AS total_box_office,
rank() over(order by (bo.domestic_gross + bo.international_gross)desc) as rank_comparison
from Movies m join BoxOffice bo 
on m.movie_id = bo.movie_id

--21. What are the differences in the way movies are ranked when you consider audience ratings 
--versus the number of awards won?


--22. Can you list the movies that consistently rank high both in domestic gross and in audience appreciation?
select m.title, bo.domestic_gross, m.rating,
rank() over(order by bo.domestic_gross desc, m.rating desc) as rank_comparison
from Movies m join BoxOffice bo 
on m.movie_id = bo.movie_id

--23. What would the movie list look like if we grouped them by their performance within their release year?
SELECT m.title,r.score, RANK()
OVER(PARTITION BY m.release_year ORDER BY r.score) rank
FROM Movies m JOIN Reviews r
ON m.movie_id = r.movie_id

--24. Can we find the top movies from each genre, while also displaying how they compare in terms of 
--critical reception and revenue distribution?
with c as(
select m.title, m.genre, r.score,
rank() over(partition by genre order by (bo.domestic_gross + bo.international_gross) desc, r.score desc) as rank_comparison
from Movies m join BoxOffice bo 
on m.movie_id = bo.movie_id
join Reviews r on m.movie_id = r.movie_id)

select * from c where rank_comparison = 1;

--25. If you were to group actors based on the number of movies they've been in, how would you categorize them?
with c as(
select DISTINCT a.name,
count(ma.movie_id) over(partition by ma.actor_id) num_of_movies
from MovieActors ma join Actors a
on ma.actor_id = a.actor_id
)
select name, num_of_movies, 
case
when num_of_movies>= 3 then 'highly active'
when num_of_movies = 2 then 'moderately active'
when num_of_movies = 1 then 'less active'
else
'no participation'
end as category
from c order by num_of_movies;
