--q1 Give the name, release year, and worldwide gross of the lowest grossing movie.
Select s.film_title, s.release_year, r.worldwide_gross
FROM specs AS s
INNER JOIN revenue AS r
USING (movie_id)
ORDER BY r.worldwide_gross
LIMIT 1

--q2 What year has the highest average imdb rating?