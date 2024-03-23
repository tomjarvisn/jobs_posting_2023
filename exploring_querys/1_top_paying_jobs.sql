--The query checks out the top 10 paying jobs for a remote 'Data Scientist' in the year 2023

SELECT
    jp.job_id,
    jp.job_title as title,
    cd.name as company,
    jp.salary_year_avg as year_salary,
    jp.job_posted_date ::DATE as posted_date
FROM
    job_postings_fact as jp
LEFT JOIN
    company_dim as cd
    on jp.company_id = cd.company_id
WHERE
    job_title_short = 'Data Scientist' and
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

