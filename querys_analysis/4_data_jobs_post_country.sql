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
    office_work_post DESC
LIMIT
    10;
