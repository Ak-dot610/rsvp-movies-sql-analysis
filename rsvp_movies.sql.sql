USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'movie' AS table_name, COUNT(*) AS row_count FROM movie
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'director_mapping', COUNT(*) FROM director_mapping
UNION ALL
SELECT 'role_mapping', COUNT(*) FROM role_mapping
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings;












-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT * from movie;
select
sum(case when id is null then 1 else 0 end ) as id_null,
sum(case when title is null then 1 else 0 end ) as title_null,
sum(case when year is null then 1 else 0 end ) as year_null,
sum(case when date_published is null then 1 else 0 end ) as date_published_null,
sum(case when duration is null then 1 else 0 end ) as duration_null,
sum(case when country is null then 1 else 0 end ) as country_null,
sum(case when worlwide_gross_income is null then 1 else 0 end ) as worlwide_gross_income_null,
sum(case when languages is null then 1 else 0 end ) as languages_null,
sum(case when production_company is null then 1 else 0 end ) as production_company_null
from movie;






-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
DESCRIBE movie;
SELECT 
    EXTRACT(YEAR FROM date_published) AS year,
    COUNT(*) AS number_of_movies
FROM 
    movie
GROUP BY 
    EXTRACT(YEAR FROM date_published)
ORDER BY 
    year;
    
SELECT 
    EXTRACT(MONTH FROM date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM 
    movie
GROUP BY 
    EXTRACT(MONTH FROM date_published)
ORDER BY 
    month_num;











/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    COUNT(*) AS number_of_movies
FROM 
    movie
WHERE 
    YEAR(date_published) = 2019
    AND country IN ('USA','India');
    
   /* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre
ORDER BY genre;











/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre, COUNT(DISTINCT movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) AS movies_with_one_genre
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(DISTINCT genre) = 1
) AS single_genre_movies;











/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, 
    AVG(m.duration) AS avg_duration
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
GROUP BY 
    g.genre
ORDER BY 
    avg_duration DESC;









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_counts AS (
  SELECT genre, COUNT(DISTINCT movie_id) AS movie_count
  FROM genre
  GROUP BY genre
),
genre_ranked AS (
  SELECT 
    genre,
    movie_count,
    RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
  FROM genre_counts
)
SELECT * FROM genre_ranked WHERE genre = 'Thriller';











/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;







    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
WITH ranked_movies AS (
    SELECT m.title, r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM ratings r
    JOIN movie m ON r.movie_id = m.id
)
SELECT * FROM ranked_movies WHERE movie_rank <= 10;









/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating,
    COUNT(DISTINCT movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;











/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH hit_movie AS (
    SELECT 
        m.production_company,
        r.movie_id
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8
      AND m.production_company IS NOT NULL
      AND m.production_company <> ''
),
prod_counts AS (
    SELECT 
        production_company,
        COUNT(DISTINCT movie_id) AS movie_count
    FROM hit_movie
    GROUP BY production_company
),
ranked_prods AS (
    SELECT 
        production_company,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS prod_company_rank
    FROM prod_counts
)
SELECT 
    production_company,
    movie_count,
    prod_company_rank
FROM ranked_prods
ORDER BY prod_company_rank, production_company;

SHOW Tables;








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
    g.genre,
    COUNT(DISTINCT m.id) AS movie_count
FROM
    movie m
JOIN
    genre g ON m.id = g.movie_id
JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.country = 'USA'
    AND r.total_votes < 1000
    AND m.date_published BETWEEN '2017-03-01' AND '2017-03-31'
GROUP BY
    g.genre
ORDER BY
    movie_count DESC;










-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    m.title,
    r.avg_rating,
    g.genre
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
JOIN
    ratings r ON m.id = r.movie_id
WHERE 
    m.title LIKE 'The%' 
    AND r.avg_rating > 8
ORDER BY 
    m.title, g.genre;










-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    COUNT(DISTINCT m.id) AS movie_count
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
    AND r.median_rating = 8;









-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
    m.country,
    SUM(r.total_votes) AS total_votes
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.country IN ('Germany', 'Italy')
GROUP BY 
    m.country;









-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;









/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genre AS (
    SELECT 
        g.genre,
        COUNT(DISTINCT g.movie_id) AS movie_count
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),

top_genre_movies AS (
    SELECT DISTINCT g.movie_id, g.genre
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    JOIN top_genre tg ON g.genre = tg.genre
    WHERE r.avg_rating > 8
),

director_movies AS (
    SELECT
        tg.genre,
        n.name AS director_name,
        dm.movie_id
    FROM top_genre_movies tg
    JOIN director_mapping dm ON tg.movie_id = dm.movie_id
    JOIN names n ON dm.name_id = n.id
),

director_counts AS (
    SELECT
        genre,
        director_name,
        COUNT(DISTINCT movie_id) AS movie_count,
        RANK() OVER (PARTITION BY genre ORDER BY COUNT(DISTINCT movie_id) DESC) AS director_rank
    FROM director_movies
    GROUP BY genre, director_name
)

SELECT 
    director_name,
    movie_count
FROM director_counts
WHERE director_rank <= 3
ORDER BY genre, director_rank;










/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH actor_movies AS (
    SELECT
        rm.name_id,
        rm.movie_id
    FROM role_mapping rm
    JOIN ratings r ON rm.movie_id = r.movie_id
    WHERE
        r.median_rating >= 8
        AND rm.category IN ('actor', 'actress')
),
actor_movie_counts AS (
    SELECT
        am.name_id,
        COUNT(DISTINCT am.movie_id) AS movie_count
    FROM actor_movies am
    GROUP BY am.name_id
),
top_actors AS (
    SELECT 
        amc.name_id,
        amc.movie_count,
        RANK() OVER (ORDER BY amc.movie_count DESC) AS actor_rank
    FROM actor_movie_counts amc
)
SELECT
    n.name AS actor_name,
    ta.movie_count
FROM top_actors ta
JOIN names n ON ta.name_id = n.id
WHERE ta.actor_rank <= 2
ORDER BY ta.actor_rank;









/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_votes AS (
    SELECT 
        m.production_company,
        SUM(r.total_votes) AS vote_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.production_company IS NOT NULL AND m.production_company <> ''
    GROUP BY m.production_company
),
ranked_productions AS (
    SELECT 
        production_company,
        vote_count,
        RANK() OVER (ORDER BY vote_count DESC) AS prod_comp_rank
    FROM prod_votes
)
SELECT 
    production_company,
    vote_count,
    prod_comp_rank
FROM ranked_productions
WHERE prod_comp_rank <= 3
ORDER BY prod_comp_rank;











/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:WITH indian_actor_movies AS (
SELECT 
    n.name AS actor_name,
    aa.total_votes,
    aa.movie_count,
    aa.actor_avg_rating
FROM (
    SELECT
        iam.name_id,
        COUNT(DISTINCT iam.movie_id) AS movie_count,
        SUM(iam.avg_rating * iam.total_votes) / SUM(iam.total_votes) AS actor_avg_rating,
        SUM(iam.total_votes) AS total_votes
    FROM (
        SELECT
            rm.name_id,
            rm.movie_id,
            r.avg_rating,
            r.total_votes
        FROM role_mapping rm
        JOIN movie m ON rm.movie_id = m.id
        JOIN ratings r ON rm.movie_id = r.movie_id
        WHERE m.country = 'India'
          AND rm.category IN ('actor', 'actress')
          AND r.total_votes > 0
    ) iam
    GROUP BY iam.name_id
    HAVING movie_count >= 5
) aa
JOIN names n ON aa.name_id = n.id
ORDER BY aa.actor_avg_rating DESC, aa.total_votes DESC
LIMIT 1;











-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH hindi_actress_movies AS (
    SELECT
        rm.name_id,
        rm.movie_id,
        r.avg_rating,
        r.total_votes
    FROM role_mapping rm
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON rm.movie_id = r.movie_id
    WHERE 
        m.country = 'India' 
        AND rm.category = 'actress'
        AND r.total_votes > 0
        AND m.languages LIKE '%Hindi%'  -- check if "Hindi" is listed in languages column
),
actress_agg AS (
    SELECT
        name_id,
        COUNT(DISTINCT movie_id) AS movie_count,
        SUM(avg_rating * total_votes) AS weighted_rating_sum,
        SUM(total_votes) AS total_votes
    FROM hindi_actress_movies
    GROUP BY name_id
    HAVING movie_count >= 3
),
actress_ratings AS (
    SELECT
        name_id,
        movie_count,
        total_votes,
        weighted_rating_sum / total_votes AS actress_avg_rating
    FROM actress_agg
),
ranked_actresses AS (
    SELECT
        ar.name_id,
        n.name AS actress_name,
        ar.total_votes,
        ar.movie_count,
        ar.actress_avg_rating,
        RANK() OVER (ORDER BY ar.actress_avg_rating DESC, ar.total_votes DESC) AS actress_rank
    FROM actress_ratings ar
    JOIN names n ON ar.name_id = n.id
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    actress_rank
FROM ranked_actresses
WHERE actress_rank <= 5
ORDER BY actress_rank, actress_name;










/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
SELECT
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        WHEN r.avg_rating < 5 THEN 'Flop'
        ELSE 'Unrated'
    END AS movie_category
FROM
    movie m
JOIN
    genre g ON m.id = g.movie_id
JOIN
    ratings r ON m.id = r.movie_id
WHERE
    g.genre = 'Thriller'
    AND r.total_votes >= 25000
ORDER BY
    r.avg_rating DESC;










/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_avg AS (
    SELECT 
        g.genre,
        AVG(m.duration) AS avg_duration
    FROM 
        genre g
    JOIN 
        movie m ON g.movie_id = m.id
    GROUP BY 
        g.genre
)
SELECT
    genre,
    ROUND(avg_duration, 2) AS avg_duration,
    ROUND(SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING), 2) AS running_total_duration,
    ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM 
    genre_avg
ORDER BY 
    genre;










-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genres AS (
    -- Find top 3 genres by movie count
    SELECT
        genre,
        COUNT(DISTINCT movie_id) AS movie_count
    FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
genre_movies AS (
    -- Join movies with genres, filtering only top 3 genres and cleaning gross income
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        -- Remove '$' and commas, cast to unsigned integer for numeric operations
        CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ',', '') AS UNSIGNED) AS gross_income
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN top_genres tg ON g.genre = tg.genre
    WHERE m.worlwide_gross_income IS NOT NULL
      AND m.worlwide_gross_income <> ''
),
ranked_movies AS (
    -- Rank movies by genre and year by gross_income descending
    SELECT
        genre,
        year,
        movie_name,
        gross_income AS worldwide_gross_income,
        RANK() OVER (PARTITION BY genre, year ORDER BY gross_income DESC) AS movie_rank
    FROM genre_movies
)
SELECT 
    genre,
    year,
    movie_name,
    CONCAT('$', FORMAT(worldwide_gross_income, 0)) AS worldwide_gross_income,
    movie_rank
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;











-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_hits AS (
    SELECT
        m.production_company,
        m.id AS movie_id
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE
        r.median_rating >= 8
        AND m.production_company IS NOT NULL 
        AND m.production_company <> ''
        AND POSITION(',' IN m.languages) > 0   -- multilingual movie if languages contain comma
),
ranked_productions AS (
    SELECT
        production_company,
        COUNT(DISTINCT movie_id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(DISTINCT movie_id) DESC) AS prod_comp_rank
    FROM multilingual_hits
    GROUP BY production_company
)
SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM ranked_productions
WHERE prod_comp_rank <= 2
ORDER BY prod_comp_rank;












-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH superhit_drama_movies AS (
    SELECT
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN ratings r ON m.id = r.movie_id
    WHERE 
        g.genre = 'Drama'
        AND r.avg_rating > 8
        AND r.total_votes > 0
),

actress_movies AS (
    SELECT
        rm.name_id,
        sdm.movie_id,
        sdm.avg_rating,
        sdm.total_votes
    FROM role_mapping rm
    JOIN superhit_drama_movies sdm ON rm.movie_id = sdm.movie_id
    WHERE rm.category = 'actress'
),

actress_aggregates AS (
    SELECT
        name_id,
        COUNT(DISTINCT movie_id) AS movie_count,
        SUM(avg_rating * total_votes) AS weighted_rating_sum,
        SUM(total_votes) AS total_votes
    FROM actress_movies
    GROUP BY name_id
),

actress_ratings AS (
    SELECT
        name_id,
        movie_count,
        total_votes,
        CAST(weighted_rating_sum AS DECIMAL(10,4)) / total_votes AS actress_avg_rating
    FROM actress_aggregates
),

ranked_actresses AS (
    SELECT
        ar.name_id,
        n.name AS actress_name,
        ar.total_votes,
        ar.movie_count,
        ar.actress_avg_rating,
        RANK() OVER (
            ORDER BY ar.actress_avg_rating DESC,
                     ar.total_votes DESC,
                     n.name ASC
        ) AS actress_rank
    FROM actress_ratings ar
    JOIN names n ON ar.name_id = n.id
)

SELECT
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM ranked_actresses
WHERE actress_rank <= 3
ORDER BY actress_rank;









/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_movies AS (
    SELECT 
        dm.name_id AS director_id,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM director_mapping dm
    JOIN movie m ON dm.movie_id = m.id
    LEFT JOIN ratings r ON m.id = r.movie_id
    WHERE m.date_published IS NOT NULL
),
director_movies_ordered AS (
    SELECT
        director_id,
        movie_id,
        date_published,
        duration,
        avg_rating,
        total_votes,
        LEAD(date_published) OVER (PARTITION BY director_id ORDER BY date_published) AS next_date
    FROM director_movies
),
director_movie_gaps AS (
    SELECT
        director_id,
        DATEDIFF(next_date, date_published) AS gap_days
    FROM director_movies_ordered
    WHERE next_date IS NOT NULL
),
director_stats AS (
    SELECT
        dmg.director_id,
        -- Number of movies per director from director_movies CTE
        (SELECT COUNT(DISTINCT movie_id) FROM director_movies dm WHERE dm.director_id = dmg.director_id) AS number_of_movies,
        AVG(dmg.gap_days) AS avg_inter_movie_days
    FROM director_movie_gaps dmg
    GROUP BY dmg.director_id
),
director_aggregates AS (
    SELECT
        director_id,
        COUNT(DISTINCT movie_id) AS number_of_movies,
        AVG(avg_rating) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
    FROM director_movies
    GROUP BY director_id
),
director_combined AS (
    SELECT
        da.director_id,
        COALESCE(ds.number_of_movies, da.number_of_movies) AS number_of_movies,
        ds.avg_inter_movie_days,
        da.avg_rating,
        da.total_votes,
        da.min_rating,
        da.max_rating,
        da.total_duration
    FROM director_aggregates da
    LEFT JOIN director_stats ds ON da.director_id = ds.director_id
),
ranked_directors AS (
    SELECT
        dc.director_id,
        n.name AS director_name,
        dc.number_of_movies,
        ROUND(COALESCE(dc.avg_inter_movie_days, 0), 2) AS avg_inter_movie_days,
        ROUND(COALESCE(dc.avg_rating, 0), 2) AS avg_rating,
        COALESCE(dc.total_votes, 0) AS total_votes,
        ROUND(COALESCE(dc.min_rating, 0), 2) AS min_rating,
        ROUND(COALESCE(dc.max_rating, 0), 2) AS max_rating,
        COALESCE(dc.total_duration, 0) AS total_duration,
        RANK() OVER (ORDER BY dc.number_of_movies DESC) AS director_rank
    FROM director_combined dc
    JOIN names n ON dc.director_id = n.id
)

SELECT
    director_id,
    director_name,
    number_of_movies,
    avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM ranked_directors
WHERE director_rank <= 9
ORDER BY director_rank;

















