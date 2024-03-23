--list of remote 'Data Scientist' jobs by month
SELECT
    TO_CHAR(job_posted_date, 'Month') AS MONTH,
    COUNT(job_id) AS job_post,
    CONCAT(
        ROUND(
            (COUNT(job_id) * 100.0 / (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE job_title_short = 'Data Scientist' 
                      AND job_work_from_home = TRUE
            )), 2
        ), 
        '%'
    ) AS percentage_total
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Scientist'
    AND job_work_from_home = TRUE
GROUP BY
    TO_CHAR(job_posted_date, 'Month')
ORDER BY
    EXTRACT(MONTH FROM MIN(job_posted_date));
