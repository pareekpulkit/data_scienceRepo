USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) AS NumRowsInDirecMap
FROM
    director_mapping;
-- Number of Rows in director_mapping : 3867

SELECT 
    COUNT(*) AS NumRowsInGenre
FROM
    genre;
-- Number of Rows in Genre : 14662

SELECT 
    COUNT(*) AS NumRowsInMovie
FROM
    movie;
-- Number of Rows in Movie : 7997

SELECT 
    COUNT(*) AS NumRowsInNames
FROM
    names;
-- Number of Rows in Names : 25735

SELECT 
    COUNT(*) AS NumRowsInRating
FROM
    ratings;
-- Number of Rows in Ratings : 7997

SELECT 
    COUNT(*) AS RoleMapping
FROM
    role_mapping;
-- Number of Rows in Role_Mapping : 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS id_null,
       SUM(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS title_null,
       SUM(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS year_null,
       SUM(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS date_published_null,
       SUM(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS duration_null,
       SUM(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS country_null,
       SUM(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS worlwide_gross_income_null,
       SUM(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS languages_null,
       SUM(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS production_company_null
FROM   movie; 
-- Here as we can see columns country, worlwide_gross_income, languages and production_company has null values. 

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


SELECT year,
       COUNT(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year DESC; 

-- With year number of movies relaesed are decreasing. Maximum are in 2017.

SELECT MONTH(date_published),
       COUNT(id) AS number_of_movies
FROM   movie
GROUP  BY MONTH(date_published)
ORDER  BY MONTH(date_published); 


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT year,
       COUNT(id) AS num_of_movies_in_USAorINDIA
FROM   movie
WHERE  year = 2019
       AND ( country LIKE '%India%'
              OR country LIKE '%USA%' ); 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT g.genre,
       COUNT(m.id) AS movie_per_genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY g.genre
ORDER  BY COUNT(m.id) DESC
LIMIT  1; 
-- Drama genre produced Highest number of movies and they were 4285.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


        
SELECT COUNT(id) AS Movies_with_Single_Genre
FROM   movie
WHERE  id IN (SELECT movie_id
              FROM   genre
              GROUP  BY movie_id
              HAVING COUNT(genre) = 1);         


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


SELECT g.genre,
       ROUND(AVG(m.duration), 2) AS avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY g.genre
ORDER BY avg_duration DESC; 



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


WITH genre_rank_data
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                RANK()
                  OVER (
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank_data
WHERE  genre = "thriller"; 




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings; 


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
-- It's ok if RANK() or DENSE_RANK() is used too

 

WITH movie_rating
     AS (SELECT m.title,
                r.avg_rating,
                RANK()
                  OVER (
                    ORDER BY r.avg_rating DESC) AS movie_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id)
SELECT *
FROM   movie_rating
WHERE  movie_rank <= 10; 


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

SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- Most frequent median ratings are 7,6,8 in respective order.


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


WITH best_prod
     AS (SELECT m.production_company,
                Count(m.id)                    AS movie_count,
                RANK()
                  OVER (
                    ORDER BY Count(m.id) DESC) AS prod_company_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND m.production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   best_prod
WHERE  prod_company_rank = 1;



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


SELECT g.genre,
       COUNT(m.id) AS movie_count
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.country LIKE '%USA%'
       AND MONTH(m.date_published) = 3
       AND m.year = 2017
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY movie_count DESC; 
 
 -- As expected Drama (24) had most number of movies with these qualifications.


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

-- For avg ratings


SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title REGEXP '^The'
       AND r.avg_rating > 8
ORDER  BY r.avg_rating DESC;         
-- For median ratings


SELECT m.title,
       r.median_rating,
       g.genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.title REGEXP '^The'
       AND r.median_rating > 8
ORDER  BY r.median_rating; 



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
        
SELECT r.median_rating,
       COUNT(m.id) AS movie_count_rat8
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND r.median_rating = 8;         
 -- Total of 361 movies were given rating of 8 between 1 April 2018 and 1 April 2019.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

        
WITH vote_data
     AS (SELECT Sum(CASE
                      WHEN Lower(m.languages) LIKE '%german%' THEN r.total_votes
                      ELSE 0
                    END) AS German_Votes,
                Sum(CASE
                      WHEN Lower(m.languages) LIKE '%italian%' THEN
                      r.total_votes
                      ELSE 0
                    END) AS Italian_Votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  Lower(m.languages) LIKE '%german%'
                 OR Lower(m.languages) LIKE '%italian%')
SELECT CASE
         WHEN german_votes > italian_votes THEN "yes"
         ELSE "no"
       END AS Vote_result
FROM   vote_data; 

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


SELECT SUM(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS id_null,
       SUM(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS name_null,
       SUM(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS height_null,
       SUM(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_null,
       SUM(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_null
FROM   names; 

-- Height, date_of_birth abd known_for_movies contain null values

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


WITH top_genre
AS
  (
             SELECT     g.genre,
                        count(m.id) AS movie_per_genre
             FROM       movie m
             INNER JOIN genre g
             ON         m.id = g.movie_id
             INNER JOIN ratings r
             ON         r.movie_id = g.movie_id
             WHERE      r.avg_rating > 8
             GROUP BY   g.genre
             ORDER BY   count(m.id) DESC
             LIMIT      3)
  SELECT     n.name,
             count(d.movie_id) AS movie_count
  FROM       ratings r
  INNER JOIN director_mapping d
  ON         r.movie_id = d.movie_id
  INNER JOIN names n
  ON         d.name_id = n.id
  INNER JOIN genre g
  ON         d.movie_id = g.movie_id
  INNER JOIN top_genre t
  ON         t.genre = g.genre
  WHERE      r.avg_rating > 8
  GROUP BY   n.id
  ORDER BY   movie_count DESC
  LIMIT      3;





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
SELECT n.name,
       COUNT(rm.movie_id) AS movie_count
FROM   ratings r
       INNER JOIN role_mapping rm USING (movie_id)
       INNER JOIN names n
               ON n.id = rm.name_id
WHERE  r.median_rating >= 8
and rm.category = "actor"
GROUP  BY n.name
ORDER  BY movie_count DESC
LIMIT  2; 



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



SELECT     m.production_company,
           SUM(total_votes)                             AS vote_count,
           RANK() over (ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
GROUP BY   m.production_company
LIMIT      3;








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
-- Type your code below:


WITH actor_data
     AS (SELECT n.NAME
                AS
                actor_name,
                Sum(r.total_votes)
                AS
                   total_votes,
                Count(rm.movie_id)
                AS
                   movie_count,
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2)
                AS
                actor_avg_rating
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping rm
                        ON rm.movie_id = r.movie_id
                INNER JOIN names n
                        ON n.id = rm.name_id
         WHERE  rm.category = 'actor'
                AND Lower(m.country) LIKE '%india%'
         GROUP  BY n.NAME)
SELECT *,
       RANK()
         OVER (
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_data
WHERE  movie_count >= 5; 


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

WITH actress_data
AS
  (
             SELECT     n.name                                                          AS actor_name,
                        sum(r.total_votes)                                              AS total_votes,
                        count(rm.movie_id)                                              AS movie_count,
                        round(sum(r.avg_rating * r.total_votes) / sum(r.total_votes),2) AS actress_avg_rating
             FROM       movie m
             INNER JOIN ratings r
             ON         m.id = r.movie_id
             INNER JOIN role_mapping rm
             ON         rm.movie_id = r.movie_id
             INNER JOIN names n
             ON         n.id = rm.name_id
             WHERE      rm.category = 'actress'
             AND        lower(m.languages) LIKE '%hindi%'
             GROUP BY   n.name)
  SELECT   *,
           rank() over (ORDER BY actress_avg_rating DESC) AS actress_rank
  FROM     actress_data
  WHERE    movie_count>=3
  LIMIT    5;





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Movie and their classification 

SELECT m.title,
       r.avg_rating,
       CASE
         WHEN r.avg_rating > 8 THEN "Superhit movies"
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
         ELSE "Flop movies"
       end AS movie_rating_category
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = g.movie_id
WHERE  g.genre = "thriller"; 

-- Number of movies in different category

WITH movie_pop_data
     AS (SELECT m.title,
                r.avg_rating,
                CASE
                  WHEN r.avg_rating > 8 THEN "Superhit movies"
                  WHEN r.avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
                  WHEN r.avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
                  ELSE "Flop movies"
                END AS movie_category
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
                INNER JOIN ratings r
                        ON r.movie_id = g.movie_id
         WHERE  g.genre = "thriller")
SELECT movie_category,
       Count(title) AS movie_count
FROM   movie_pop_data
GROUP  BY movie_category; 




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

SELECT genre,
       ROUND(AVG(duration), 2)                      AS avg_duration,
       SUM(ROUND(AVG(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       AVG(ROUND(AVG(duration), 2))
         over(
           ORDER BY genre ROWS 10 preceding)        AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 






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



WITH top_genre
AS
  (
             SELECT     g.genre,
                        count(g.movie_id) AS movie_per_genre
             FROM       movie m
             INNER JOIN genre g
             ON         m.id = g.movie_id
             INNER JOIN ratings r
             ON         r.movie_id = g.movie_id
             GROUP BY   g.genre
             ORDER BY   count(m.id) DESC
             LIMIT      3),
  correct_income
AS
  (
         SELECT m.id, (
                CASE
                       WHEN locate('INR', m.worlwide_gross_income) > 0 THEN cast(REPLACE(m.worlwide_gross_income,'INR','')/70 AS DECIMAL(12))
                       WHEN locate('$', m.worlwide_gross_income) > 0 THEN cast(REPLACE(m.worlwide_gross_income,'$','') AS     DECIMAL(12))
                       ELSE 0
                end) AS income
         FROM   movie m),
  movie_rank
AS
  (
             SELECT     g.genre,
                        m.year,
                        m.title,
                        m.worlwide_gross_income,
                        dense_rank() over (partition BY m.year ORDER BY c.income DESC) AS movie_rank
             FROM       movie m
             INNER JOIN genre g
             ON         m.id = g.movie_id
             INNER JOIN correct_income c
             ON         m.id = c.id
             WHERE      g.genre IN
                        (
                               SELECT genre
                               FROM   top_genre))
  SELECT *
  FROM   movie_rank
  WHERE  movie_rank <= 5;







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


WITH multi_ling_data
AS
  (
             SELECT     m.production_company,
                        sum(
                        CASE
                                   WHEN locate(',', m.languages) > 0 THEN 1
                                   ELSE 0
                        end) AS movie_count
             FROM       movie m
             INNER JOIN ratings r
             ON         r.movie_id = m.id
             WHERE      r.median_rating >= 8
             AND        m.production_company IS NOT NULL
             GROUP BY   m.production_company)
  SELECT   *,
           rank() over (ORDER BY movie_count DESC) prod_comp_rank
  FROM     multi_ling_data
  WHERE    movie_count > 0
  LIMIT    2;

-- Star Cinema and Twentieth Century Fox are the top two production companies with multilingual movies.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_data
AS
  (
             SELECT     n.name             AS actress_name,
                        sum(total_votes)   AS total_votes,
                        count(rm.movie_id) AS movie_count,
                        avg(r.avg_rating)  AS actress_avg_rating
             FROM       ratings r
             INNER JOIN genre g
             USING      (movie_id)
             INNER JOIN role_mapping rm
             USING      (movie_id)
             INNER JOIN names n
             ON         rm.name_id = n.id
             WHERE      g.genre = 'Drama'
             AND        rm.category = 'actress'
             AND        r.avg_rating > 8
             GROUP BY   n.name)
  SELECT   *,
           rank() over (ORDER BY movie_count DESC) AS actress_rank
  FROM     actress_data
  LIMIT    3;

-- Parvathy Thiruvothu is the top actress with most super hit movies


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


WITH direc_data
AS
  (
             SELECT     dm.name_id,
                        n.name,
                        m.date_published,
                        dm.movie_id,
                        lead(m.date_published,1) over (partition BY dm.name_id ORDER BY dm.name_id,m.date_published) AS date_ahead,
                        r.avg_rating,
                        r.total_votes,
                        m.duration
             FROM       movie m
             INNER JOIN ratings r
             ON         m.id = r.movie_id
             INNER JOIN director_mapping dm
             USING      (movie_id)
             INNER JOIN names n
             ON         n.id = dm.name_id),
  direc_data2
AS
  (
         SELECT d.*,
                datediff(date_ahead,date_published) AS inter_movie_days
         FROM   direc_data d)
  SELECT   name_id              AS director_id,
           name                 AS director_name,
           count(movie_id)      AS num_of_movies,
           avg(inter_movie_days)AS avg_inter_movie_days,
           avg(avg_rating)      AS avg_rating,
           sum(total_votes)     AS total_votes,
           min(avg_rating)      AS min_rating,
           max(avg_rating)      AS max_rating,
           sum(duration)        AS total_duration
  FROM     direc_data2
  GROUP BY name_id,
           name
  ORDER BY num_of_movies DESC
  LIMIT    9;


