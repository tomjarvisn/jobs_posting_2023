-- Query 1: Remote Job Post Ratio by Job Title

-- This query analyzes job postings for each job to determine the percentage of remote job posts for each job title.


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
