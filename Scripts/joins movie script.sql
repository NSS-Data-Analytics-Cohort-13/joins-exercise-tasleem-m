--q1 Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT s.film_title, s.release_year, rev.worldwide_gross
FROM specs AS s
INNER JOIN revenue AS rev
USING (movie_id)
ORDER BY rev.worldwide_gross
--answer: Semi-Tough, 1977, 37187139

--q2 What year has the highest average imdb rating?
SELECT s.release_year, ROUND (AVG (rat.imdb_rating), 2) AS avg_rating
FROM specs AS s
INNER JOIN rating AS rat
USING (movie_id)
GROUP BY s.release_year
ORDER BY avg_rating DESC
--answer: 1991

--q3 What is the highest grossing G-rated movie? Which company distributed it?
SELECT s.film_title, rev.worldwide_gross, d.company_name
FROM specs AS s
INNER JOIN revenue AS rev
USING (movie_id)
INNER JOIN distributors AS d
ON s.domestic_distributor_id = d.distributor_id
WHERE s.mpaa_rating = 'G'
ORDER BY rev.worldwide_gross DESC
--answer: Toy Story 4 by Walt Disney

--q4 Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table.
SELECT d.company_name, COUNT(s.film_title) AS count_movies
FROM distributors as d
LEFT JOIN specs AS s
ON d.distributor_id = s.domestic_distributor_id
GROUP BY d.company_name

--q5 Write a query that returns the five distributors with the highest average movie budget.
SELECT d.company_name, ROUND (AVG (rev.film_budget), 2)::MONEY AS avg_budget
FROM specs AS s
INNER JOIN distributors as d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN revenue AS rev
USING (movie_id)
GROUP BY d.company_name
ORDER BY avg_budget DESC
LIMIT 5

--q6 How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT s.film_title, rat.imdb_rating
FROM specs AS s
INNER JOIN distributors as d
ON s.domestic_distributor_id = d.distributor_id
INNER JOIN rating AS rat
USING (movie_id)
WHERE d.headquarters NOT LIKE '%CA'
ORDER BY rat.imdb_rating DESC
--answer: 2; Dirty Dancing

--q7 Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT 'Over two hours' AS movie_length, ROUND (AVG(slt.over_rating), 2) AS avg_rating
FROM (SELECT rat.imdb_rating AS over_rating
		FROM rating AS rat
		INNER JOIN specs AS s
		USING (movie_id)
		WHERE s.length_in_min >= 120 
		GROUP BY rat.imdb_rating) AS slt
UNION ALL
SELECT 'Over two hours' AS movie_length, ROUND (AVG(slt.under_rating), 2) AS avg_rating
FROM (SELECT rat.imdb_rating AS under_rating
		FROM rating AS rat
		INNER JOIN specs AS s
		USING (movie_id)
		WHERE s.length_in_min < 120 
		GROUP BY rat.imdb_rating) AS slt
--answer:Movies over two hours