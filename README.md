# Analysis of Remote Data Jobs 💼🌐


## Introduction 🚀
In this project, I analyzed a database of job postings from 2023 related to 'Data' jobs scraped by [Luke Barousse](https://github.com/lukebarousse).

## Background 📊
The [database](https://drive.google.com/drive/folders/1moeWYoUtUklJO6NJdWo9OV8zWjRn0rjN) used for this analysis follows the structure depicted below:
![Data structure](images\table_structure.png)
and the queries from the [sql_load](/sql_load/) folder were utilized.


## Tools Used 🔧
- PostgreSQL: For data storage and querying
- SQL: For data manipulation and analysis
- Visual Studio Code: For coding and writing queries
- Git: Pushing the proyect to github to share it to the comunity


## Analysis 📈

### Query 1: Remote Job Post Ratio by Job Title

#### *"Exploring the Prevalence of Remote Work Across Data Roles"*

```sql
-- Subquery to calculate total job posts by job title
WITH job_posts_count AS (
    SELECT
        job_title_short AS job_title,
        CAST(COUNT(*) AS FLOAT) AS job_posts,
        AVG(salary_year_avg)/12 as month_salary
    FROM
        job_postings_fact
    GROUP BY
        job_title_short
),

-- Subquery to calculate remote job posts by job title
remote_job_posts_count AS (
    SELECT
        job_title_short AS job_title,
        CAST(COUNT(*) AS FLOAT) AS remote_job_posts
    FROM
        job_postings_fact
    WHERE
        job_work_from_home = TRUE
    GROUP BY
        job_title_short
)

-- Main query to calculate remote job post ratio and present results
SELECT
    jp.job_title,
    jp.job_posts,
    rjp.remote_job_posts,
    CONCAT(ROUND(CAST((rjp.remote_job_posts / jp.job_posts * 100) AS NUMERIC), 2), '%') AS remote_post_ratio,
    ROUND(jp.month_salary::NUMERIC, 2) as month_salary
FROM
    job_posts_count AS jp
JOIN
    remote_job_posts_count AS rjp ON jp.job_title = rjp.job_title
ORDER BY
    job_posts DESC;

```

#### *The table illustrates the distribution of job postings across various data roles and compares the prevalence of remote work within each role. Additionally, it provides insight into the average monthly salary for each role.*

| Job Title             | Job Posts | Remote Job Posts | Remote Post Ratio | month_salary   |
|-----------------------|-----------|------------------|-------------------|---------|
| Data Analyst          | 196,593   | 13,331           | 6.78%             | 7,822.98|
| Data Engineer         | 186,679   | 21,261           | 11.39%            | 10,855.57|
| Data Scientist        | 172,726   | 14,534           | 8.41%             | 11,327.46|
| Business Analyst      | 49,160    | 2,786            | 5.67%             | 7,589.25 |
| Software Engineer     | 45,019    | 2,918            | 6.48%             | 9,398.14 |
| Senior Data Engineer  | 44,692    | 6,564            | 14.69%            | 12,155.57|
| Senior Data Scientist | 37,076    | 3,809            | 10.27%            | 12,837.50|
| Senior Data Analyst   | 29,289    | 2,352            | 8.03%             | 9,508.67 |
| Machine Learning Engineer | 14,106 | 1,480            | 10.49%            | 10,565.49|
| Cloud Engineer        | 12,346    | 571              | 4.62%             | 9,272.37 |



### Query 2: Top Demanded Skills for Data Scientists and Mean Salary for Those Posts

#### *"Identifying Key Skills in Demand for Data Scientists"*

```sql
SELECT
    sd.skills,
    sd.type,
    COUNT(jp.job_id) AS jobs_demanded,
    CONCAT(
        ROUND(
            (CAST(COUNT(jp.job_id) AS DECIMAL) /
            (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE job_title_short = 'Data Scientist' 
            )) * 100, 2
        ), 
        '%'
    ) AS Percentage_jobs_demanded  
FROM
    job_postings_fact AS jp
JOIN
    skills_job_dim AS sjd ON jp.job_id = sjd.job_id
JOIN
    skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jp.job_title_short = 'Data Scientist'
GROUP BY
    sd.skill_id
ORDER BY
    jobs_demanded DESC
LIMIT
    12;
```
#### *This table showcases the most sought-after skills for Data Scientists along with their respective demand percentage.*

| Skills      | Type            | Jobs Demanded | Percentage Jobs Demanded |
|-------------|-----------------|---------------|--------------------------|
| Python      | Programming     | 114,016       | 66.01%                   |
| SQL         | Programming     | 79,174        | 45.84%                   |
| R           | Programming     | 59,754        | 34.59%                   |
| Tableau     | Analyst Tools   | 29,513        | 17.09%                   |
| AWS         | Cloud           | 26,311        | 15.23%                   |
| Spark       | Libraries       | 24,353        | 14.10%                   |
| Azure       | Cloud           | 21,698        | 12.56%                   |
| TensorFlow  | Libraries       | 19,193        | 11.11%                   |
| Excel       | Analyst Tools   | 17,601        | 10.19%                   |
| Java        | Programming     | 16,314        | 9.45%                    |
| Power BI    | Analyst Tools   | 15,744        | 9.12%                    |
| Hadoop      | Libraries       | 15,575        | 9.02%                    |


### Query 3: Demand for 'Data' Jobs by Location Relative to Population Density

#### *"Analyzing Data Job Demand Relative to Population Density"*


-- This query shows the demand for data-related jobs (data analysis, data engineer, data scientist) for every location in relation to their population density. 
-- The column 'jobs_ratio_x_100000' shows how many jobs are demanded for this type of work per 100,000 people.
```sql
SELECT
    jp.job_country AS location,
    COUNT(jp.job_id) AS jobs,
    cp.population,
    CAST((CAST(COUNT(jp.job_id) AS FLOAT) / cp.population * 100000) AS INT) as jobs_ratio_x_100000
FROM
    job_postings_fact as jp
JOIN
    country_population as cp
    ON jp.job_country = cp.job_country
WHERE
    jp.job_title_short LIKE '%Data%'
GROUP BY
    jp.job_country,
    cp.population
HAVING
    AVG(salary_year_avg) IS NOT NULL
ORDER BY
    jobs_ratio_x_100000 DESC
LIMIT
    10;
```
#### *This table displays the demand for data-related jobs per 100,000 people in various countries, shedding light on the intensity of demand relative to population density.*

| Location            | Jobs  | Population | Jobs Ratio x 100000 |
|---------------------|-------|------------|---------------------|
| Singapore           | 19,061| 5,879,080  | 324                 |
| Luxembourg          | 1,552 | 732,188    | 212                 |
| Ireland             | 8,109 | 5,008,490  | 162                 |
| U.S. Virgin Islands | 162   | 107,510    | 151                 |
| Portugal            | 11,991| 10,329,506 | 116                 |
| Netherlands         | 17,474| 17,428,712 | 100                 |
| Malta               | 462   | 483,530    | 96                  |
| Switzerland         | 8,438 | 8,988,773  | 94                  |
| Guam                | 158   | 168,775    | 94                  |
| Belgium             | 9,937 | 11,718,855 | 85                  |


### Query 4:All 'Data' Jobs by Country, Remote or Not

"How many data jobs are there in each country, and how many of them are remote?"

```sql
-- Query 5: List of all 'data' Jobs by Country, Remote or Not

-- This query provides a list of all 'data' type jobs by country, whether they are remote or not.

SELECT
    jp.job_country AS location,
    COUNT(job_id) AS office_work_post,
    CONCAT(
        ROUND(
            COUNT(job_id) * 100.0 / (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE 
                 job_title_short LIKE '%Data%'
            ), 2
        ), 
        '%'
    ) AS from_total_posts
FROM
    job_postings_fact as jp
WHERE
    jp.job_title_short LIKE '%Data%'
GROUP BY
    jp.job_country
ORDER BY
    office_work_post DESC;
```


| Location        | Office Work Post | From Total Posts |
|-----------------|------------------|------------------|
| United States   | 216,618          | 32.47%           |
| India           | 46,490           | 6.97%            |
| United Kingdom  | 38,570           | 5.78%            |
| France          | 37,359           | 5.60%            |
| Germany         | 25,622           | 3.84%            |
| Spain           | 20,879           | 3.13%            |
| Singapore       | 19,061           | 2.86%            |
| Netherlands     | 17,474           | 2.62%            |
| Italy           | 13,802           | 2.07%            |
| Canada          | 12,863           | 1.93%            |


### Query 5: Analysis of Remote Data Job Posts

"Which countries have the highest number of 'data' job postings?"

```sql
SELECT
    job_country AS country,
    COUNT(job_id) AS jobs,
    CONCAT(
        ROUND(
            COUNT(job_id) * 100.0 / (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE 
                job_work_from_home = TRUE 
                AND
                 job_title_short LIKE '%Data%'
            ), 2
        ), 
        '%'
    ) AS Percentage_of_post_jobs
FROM
    job_postings_fact
WHERE
    job_work_from_home = TRUE
    AND
    job_title_short LIKE '%Data%'
GROUP BY
    job_country
ORDER BY
    jobs DESC
LIMIT
    10;
```
#### *This tablae shows how the 'data' job posts are distributed arround the world, is pretty obyus that EEUU is the leader in this feild.*

| Country         | Jobs  | Percentage of Post Jobs |
|-----------------|-------|-----------------------|
| United States   | 25,879| 41.84%                |
| India           | 4,961 | 8.02%                 |
| United Kingdom  | 3,518 | 5.69%                 |
| Spain           | 2,439 | 3.94%                 |
| Canada          | 2,159 | 3.49%                 |
| Poland          | 1,573 | 2.54%                 |
| France          | 1,552 | 2.51%                 |
| Mexico          | 1,504 | 2.43%                 |
| Brazil          | 1,269 | 2.05%                 |
| Germany         | 1,249 | 2.02%                 |



### Query 6: Remote 'Data' Jobs Ratio

#### *"Exploring the Distribution of Remote Data Jobs Across Different Countries"*

```sql
WITH remote_work_cte AS (
    -- Subquery to calculate the count of remote 'data' jobs by location
    SELECT
        jp.job_country AS location,
        COUNT(job_id) AS remote_work_posts
    FROM
        job_postings_fact AS jp
    WHERE
        jp.job_work_from_home = TRUE AND
        jp.job_title_short LIKE '%Data%'
    GROUP BY
        jp.job_country
),

office_work_cte AS (
    -- Subquery to calculate the total count of 'data' jobs by location
    SELECT
        jp.job_country AS location,
        COUNT(job_id) AS total_work_post
    FROM
        job_postings_fact AS jp
    WHERE
        jp.job_title_short LIKE '%Data%'
    GROUP BY
        jp.job_country
)

SELECT
    rw.location,
    ow.total_work_post AS total_office_work_posts,
    rw.remote_work_posts,
    CONCAT(ROUND(rw.remote_work_posts::NUMERIC *100/ NULLIF(ow.total_work_post, 0), 2), '%') AS remote_work_ratio
FROM
    remote_work_cte AS rw
JOIN
    office_work_cte AS ow
    ON rw.location = ow.location
WHERE
    remote_work_posts::numeric > 100 -- Filter only locations with more than 100 remote jobs
ORDER BY
    rw.remote_work_posts::NUMERIC *100/ NULLIF(ow.total_work_post, 0)  DESC -- Order by the proportion of remote jobs in descending order
LIMIT
    15;
```

#### *This query offers insights into the distribution of remote data jobs across various countries, highlighting the prevalence of remote work in the data sector. Here's a glimpse into the top 15 locations with significant proportions of remote data jobs:*

| Location   | Total Office Work Posts | Remote Work Posts | Remote Work Ratio |
|------------|-------------------------|-------------------|-------------------|
| Armenia    | 199                     | 111               | 55.78%            |
| Ukraine    | 1301                    | 412               | 31.67%            |
| Turkey     | 1148                    | 304               | 26.48%            |
| Brazil     | 5121                    | 1269              | 24.78%            |
| Bulgaria   | 879                     | 211               | 24.00%            |
| Russia     | 2941                    | 691               | 23.50%            |
| Serbia     | 558                     | 129               | 23.12%            |
| Kazakhstan | 514                     | 118               | 22.96%            |
| Romania    | 2801                    | 640               | 22.85%            |
| Canada     | 12,863                  | 2,159             | 16.78%            |
| Argentina  | 6,425                   | 992               | 15.44%            |
| Slovakia   | 674                     | 104               | 15.43%            |
| Pakistan   | 1,576                   | 236               | 14.97%            |
| Poland     | 10,892                  | 1,573             | 14.44%            |
| Peru       | 4,472                   | 622               | 13.91%            |




## Conclusions 🎉
- If you are new to the data industry, there are lots of opportunities for remote work, particularly in the U.S., where companies offer a whopping 41.84% of remote 'data' job postings in the market.
- Proficiency in key skills like Python or SQL is vital to consider in the data processing world.
- When we check the 'Remote Work Ratio' in Query 6, the ratio is remarkably high. From my point of view, the reason so many companies offer remote work is because they have trouble finding people skilled in data-related tasks. However, this presents an opportunity if you are interested in this field!

