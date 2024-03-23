--list of remote 'Data Scientist'jobs by country 

SELECT
    job_country AS location,
    COUNT(job_id) AS jobs,
    CONCAT(
        ROUND(
            COUNT(job_id) * 100.0 / (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE job_title_short = 'Data Scientist'
              --  AND job_work_from_home = TRUE
            ), 2
        ), 
        '%'
    ) AS fraction_of_post_jobs,
    ROUND(AVG(salary_year_avg) / 12, 2) AS mean_month_salary
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Scientist'
--    AND job_work_from_home = TRUE
GROUP BY
    job_country
HAVING
    AVG(salary_year_avg) IS NOT NULL
ORDER BY
    jobs DESC
limit 10


--list of all remote jobs by country

SELECT
    job_country AS location,
    COUNT(job_id) AS jobs,
    CONCAT(
        ROUND(
            COUNT(job_id) * 100.0 / (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE job_work_from_home = TRUE
            ), 2
        ), 
        '%'
    ) AS fraction_of_post_jobs,
    ROUND(AVG(salary_year_avg) / 12, 2) AS mean_month_salary
FROM
    job_postings_fact
WHERE
    job_work_from_home = TRUE
GROUP BY
    job_country
HAVING
    AVG(salary_year_avg) IS NOT NULL
ORDER BY
    jobs DESC;

--jobs in locations
SELECT
    job_country,
    count(*)
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Scientist'
GROUP BY
    job_country
ORDER BY
    count(*) DESC
LIMIT
    10;

