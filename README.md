# NETFLIX_SQL_PROJECT
This project involves an exploratory analysis of the Netflix dataset, leveraging SQL to extract meaningful insights. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Objectives

- To uncover key trends and patterns in Netflix's catalog, such as title distribution across countries, popular genres, and content trends over time.
- Analyze the distribution of content types (movies vs TV shows).
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:
- **Dataset Link:** [Netflix Dataset Link](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
CREATE TABLE netflix
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
```

## Netflix Queries and Solutions

### 1. Which three countries have the highest number of titles on Netflix?

```sql
SELECT 
    UNNEST(string_to_array(COUNTRY, ',')) AS COUNTRY,
    COUNT(*) AS TITLE_COUNT
FROM NETFLIX
WHERE COUNTRY IS NOT NULL
GROUP BY COUNTRY 
ORDER BY TITLE_COUNT DESC
LIMIT 3;
```

### 2. What is the most common genre listed in the dataset?

```sql
SELECT 
    UNNEST(string_to_array(LISTED_IN, ',')) AS GENRE,
    COUNT(*) AS TITLE_COUNT
FROM NETFLIX
WHERE LISTED_IN IS NOT NULL
GROUP BY GENRE
ORDER BY TITLE_COUNT DESC
LIMIT 3;
```

### 3. How many titles were added to Netflix each month in the dataset?

```sql
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
```

### 4. Which director has the most titles listed on Netflix?

```sql
SELECT 
    UNNEST(string_to_array(DIRECTOR, ',')) AS DIRECTORS,
    COUNT(*) AS TITLE_COUNT
FROM NETFLIX
WHERE DIRECTOR IS NOT NULL
GROUP BY DIRECTORS
ORDER BY TITLE_COUNT DESC
LIMIT 10;
```

### 5. How many TV shows and movies are there in the dataset?

```sql
SELECT 
    TYPE,
    COUNT(*) AS COUNTS
FROM NETFLIX
GROUP BY TYPE;
```

### 6. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```

### 7. Find the Top 5 Countries with the Most Content on Netflix

```sql
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
```

### 8. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### 9. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

### 10. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

### 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

### 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 13. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

**This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.**
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/odutayo-opeyemi/)

