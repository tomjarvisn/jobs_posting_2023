-- Query 7: Comparison between Remote and Office 'Data' Jobs

-- This query compares all 'data' jobs against remote jobs to show a ratio between them.

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