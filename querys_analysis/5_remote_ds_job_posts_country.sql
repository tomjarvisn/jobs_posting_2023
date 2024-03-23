-- Query 2: Analysis of Remote Data Scientist Job Posts

-- This query analyzes remote job postings for the role of 'Data' to determine the distribution of job postings.

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
    ) AS fraction_of_post_jobs
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
