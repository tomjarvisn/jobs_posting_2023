-- this wuery shows the top 10 skills demand skills, the count feature shows how many jobs demand that skill

SELECT
    sd.skills,
    sd.type,
    count(jp.job_id) as demand_count,
    round(avg(jp.salary_year_avg),2) as avg_salary
FROM
    job_postings_fact as jp
INNER JOIN 
    skills_job_dim as sjd
    ON jp.job_id = sjd.job_id
INNER JOIN 
    skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jp.job_work_from_home = TRUE AND
    jp.job_title_short = 'Data Scientist'
GROUP BY
    sd.skills,
    sd.type
ORDER BY
    demand_count DESC
LIMIT
    20;
