SELECT
    job_country AS country,
    count(job_id),
    ROUND(AVG(salary_year_avg)/ 12, 2) AS mean_month_salary,
    ROUND(min(salary_year_avg)/ 12, 2) AS min_month_salary,
    ROUND(max(salary_year_avg)/ 12, 2) AS max_month_salary
FROM
    job_postings_fact
WHERE
    job_country IS NOT NULL AND
    job_work_from_home = TRUE AND
    job_title_short LIKE '%Data Scientist%'
GROUP BY
    country
HAVING
    count(job_id) > 20 AND
    AVG(salary_year_avg) IS NOT NULL
ORDER BY
    mean_month_salary desc;

