SELECT
    sd.skills,
    sd.type,
    COUNT(jp.job_id) AS jobs_demanded,
    CONCAT(
        ROUND(
            (CAST(COUNT(jp.job_id) AS DECIMAL) /
            (
                SELECT COUNT(*)
                FROM job_postings_fact
                WHERE job_title_short = 'Data Scientist' 
            )) * 100, 2
        ), 
        '%'
    ) AS Percentage_jobs_demanded  
FROM
    job_postings_fact AS jp
JOIN
    skills_job_dim AS sjd ON jp.job_id = sjd.job_id
JOIN
    skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jp.job_title_short = 'Data Scientist'
GROUP BY
    sd.skill_id
ORDER BY
    jobs_demanded DESC
LIMIT
    12;