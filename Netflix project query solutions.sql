--NETFLIX PROJECT 

CREATE TABLE NETFLIX
(
	show_id	varchar(9),
	type varchar(10),	
	title varchar(150),	
	director varchar(250),		
	casts varchar(1000),		
	country	varchar(150),	
	date_added varchar(50),		
	release_year int,	
	rating varchar(10),		
	duration varchar(15),		
	listed_in varchar(250),		
	description varchar(250)	
);

--What are the top three years with the highest number of titles added to Netflix
--and what are the most common genres for those years?

WITH GODFACTOR AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
        UNNEST(string_to_array(listed_in, ',')) AS genre
    FROM netflix
),
YEARLY_TITLES AS (
    SELECT 
        year_added,
        COUNT(*) AS total_titles
    FROM GODFACTOR
    GROUP BY year_added
    ORDER BY total_titles DESC
    LIMIT 3
),
GENRE_STATS AS (
    SELECT 
        gf.year_added,
        gf.genre,
        COUNT(*) AS genre_count
    FROM GODFACTOR gf
    INNER JOIN YEARLY_TITLES yt ON gf.year_added = yt.year_added
    GROUP BY gf.year_added, gf.genre
)
SELECT 
    gs.year_added,
    yt.total_titles,
    gs.genre,
    gs.genre_count
FROM GENRE_STATS gs
INNER JOIN YEARLY_TITLES yt ON gs.year_added = yt.year_added
ORDER BY yt.total_titles DESC, gs.genre_count DESC;

--1. Which three countries have the highest number of titles on Netflix?
--2. What is the most common genre listed in the dataset?
--3. How many titles were added to Netflix each month in the dataset?
--4. Which director has the most titles listed on Netflix?
--5. How many TV shows and movies are there in the dataset?
--6. List All Movies Released in a Specific Year (e.g., 2020)
--7. Find the Top 5 Countries with the Most Content on Netflix
--8. Find Content Added in the Last 5 Years
--9. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
--10. List All TV Shows with More Than 5 Seasons
--11. List All Movies that are Documentaries
--12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
--13. Find All Content Without a Director
--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords


--1. Which three countries have the highest number of titles on Netflix?
SELECT 
    UNNEST(string_to_array(COUNTRY, ',')) AS COUNTRY,
    COUNT(*) AS TITLE_COUNT
FROM NETFLIX
WHERE COUNTRY IS NOT NULL
GROUP BY COUNTRY 
ORDER BY TITLE_COUNT DESC
LIMIT 3;

--2. What is the most common genre listed in the dataset?
SELECT 
    UNNEST(string_to_array(LISTED_IN, ',')) AS GENRE,
    COUNT(*) AS TITLE_COUNT
FROM NETFLIX
WHERE LISTED_IN IS NOT NULL
GROUP BY GENRE
ORDER BY TITLE_COUNT DESC
LIMIT 3;


--3. How many titles were added to Netflix each month in the dataset?
WITH MonthData AS (
    SELECT 
        TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS MONTH_NAME,
        COUNT(*) AS TITLE_COUNT
    FROM NETFLIX
    WHERE date_added IS NOT NULL
    GROUP BY TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month')
)
SELECT *
FROM MonthData
ORDER BY TO_DATE(MONTH_NAME, 'Month');


--4. Which director has the most titles listed on Netflix?
SELECT 
    UNNEST(string_to_array(DIRECTOR, ',')) AS DIRECTORS,
    COUNT(*) AS TITLE_COUNT
FROM NETFLIX
WHERE DIRECTOR IS NOT NULL
GROUP BY DIRECTORS
ORDER BY TITLE_COUNT DESC
LIMIT 10;


--5. How many TV shows and movies are there in the dataset?
SELECT 
    TYPE,
    COUNT(*) AS COUNTS
FROM NETFLIX
GROUP BY TYPE;


--6. List All Movies Released in a Specific Year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year = 2020;

--7. Find the Top 5 Countries with the Most Content on Netflix
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

--8. Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--9. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

--10. List All TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--13. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;


--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


SELECT * FROM NETFLIX;
