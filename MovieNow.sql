--Initial data exploration
SELECT * FROM `MovieNow.actors` limit 5;
SELECT * FROM `MovieNow.actsin` limit 5;
SELECT * FROM `MovieNow.customers` limit 5;
SELECT * FROM `MovieNow.movies` limit 5;
SELECT * FROM `MovieNow.renting`;


SELECT *
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.movies` AS m -- Augment the table with information about movies
ON r.movie_id = m.movie_id;



SELECT *
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.movies` AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( -- Select records of movies with at least 4 ratings
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4 )
AND r.date_renting >= '2018-01-01'; -- Select records of movie rentals since 2018-01-01

-- seeing if year of release yields results and also how the results differ by country
SELECT c.country,
  m.year_of_release,
  COUNT(*) AS n_rentals,
  COUNT(DISTINCT r.movie_id) AS n_movies,
  AVG(rating) AS avg_rating
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.customers` AS c
  USING (customer_id)
LEFT JOIN `MovieNow.movies` AS m
  USING (movie_id)
WHERE r.movie_id IN (
  SELECT movie_id
  FROM `MovieNow.renting`
  GROUP BY movie_id
  HAVING COUNT(rating) >=4)
AND r.date_renting >= '2018-01-01'
GROUP BY ROLLUP (m.year_of_release, c.country)
ORDER BY c.country, m.year_of_release


SELECT m.genre, -- For each genre, calculate:
	   AVG(r.rating) AS avg_rating,-- The average rating and use the alias avg_rating
	   COUNT(r.rating) AS n_rating,-- The number of ratings and use the alias n_rating
	   COUNT(*) AS n_rentals,-- The number of movie rentals and use the alias n_rentals
	   COUNT (DISTINCT r.movie_id) AS n_movies -- The number of distinct movies and use the alias n_movies
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.movies` AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
GROUP BY m.genre;


SELECT genre,
	   ROUND(AVG(r.rating),2) AS avg_rating,
	   COUNT(rating) AS n_rating,
     COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.movies` AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg_rating DESC; -- Order the table by decreasing average rating


-- Join the tables
SELECT *
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.actsin` AS ai
ON r.movie_id = ai.movie_id
LEFT JOIN `MovieNow.actors` AS a
ON ai.actor_id = a.actor_id;


SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT (DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.actsin` AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN `MovieNow.actors` AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-01-01'
GROUP BY (a.nationality, a.gender); -- Report results for each combination of the actors' nationality and gender


SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.actsin` AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN `MovieNow.actors` AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-01-01'
GROUP BY GROUPING SETS ((a.nationality, a.gender), (a.nationality), (a.gender), ()) -- Provide results for all aggregation levels represented in a pivot table AS r
LEFT JOIN `MovieNow.movies` AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( -- Select records of movies with at least 4 ratings
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4 )
AND r.date_renting >= '2018-01-01'; -- Select records of movie rentals since 2018-04-01


SELECT m.genre, -- For each genre, calculate:
	   AVG(r.rating) AS avg_rating,-- The average rating and use the alias avg_rating
	   COUNT(r.rating) AS n_rating,-- The number of ratings and use the alias n_rating
	   COUNT(*) AS n_rentals,-- The number of movie rentals and use the alias n_rentals
	   COUNT (DISTINCT r.movie_id) AS n_movies -- The number of distinct movies and use the alias n_movies
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.movies` AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
GROUP BY m.genre;


SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.movies` AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg_rating DESC; -- Order the table by decreasing average rating


-- Join the tables
SELECT *
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.actsin` AS ai
ON r.movie_id = ai.movie_id
LEFT JOIN `MovieNow.actors` AS a
ON ai.actor_id = a.actor_id;


SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT (DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.actsin` AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN `MovieNow.actors` AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-01-01'
GROUP BY (a.nationality, a.gender); -- Report results for each combination of the actors' nationality and gender


SELECT COALESCE(a.nationality, 'All Nationalities'),
       COALESCE(a.gender, 'All Genders'),
	   ROUND(AVG(r.rating),2) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM `MovieNow.renting` AS r
LEFT JOIN `MovieNow.actsin` AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN `MovieNow.actors` AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM `MovieNow.renting`
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-01-01'
GROUP BY CUBE (a.nationality, a.gender); -- Provide results for all aggregation levels represented in a pivot table