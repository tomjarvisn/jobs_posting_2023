-- Query 4: Demand for 'Data' Jobs by Location Relative to Population Density

-- This query shows the demand for data-related jobs (data analysis, data engineer, data scientist) for every location in relation to their population density. 
-- The column 'jobs_ratio_x_100000' shows how many jobs are demanded for this type of work per 100,000 people.

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
