WITH top_paying_jobs AS (
    SELECT
        jp.job_id,
        jp.job_title AS title,
        cd.name AS company,
        jp.salary_year_avg AS year_salary,
        jp.job_posted_date::DATE AS posted_date
    FROM
        job_postings_fact AS jp
    LEFT JOIN
        company_dim AS cd ON jp.company_id = cd.company_id
    WHERE
        job_title_short = 'Data Scientist' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    tpj.*,
    sd.skills,
    sd.type
FROM
    top_paying_jobs AS tpj
INNER JOIN
    skills_job_dim AS sjd ON tpj.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd ON sjd.skill_id = sd.skill_id
ORDER BY
    year_salary DESC;

/*
[
  {
    "job_id": 40145,
    "title": "Staff Data Scientist/Quant Researcher",
    "company": "Selby Jennings",
    "year_salary": "550000.0",
    "posted_date": "2023-08-16",
    "skills": "sql",
    "type": "programming"
  },
  {
    "job_id": 40145,
    "title": "Staff Data Scientist/Quant Researcher",
    "company": "Selby Jennings",
    "year_salary": "550000.0",
    "posted_date": "2023-08-16",
    "skills": "python",
    "type": "programming"
  },
  {
    "job_id": 1714768,
    "title": "Staff Data Scientist - Business Analytics",
    "company": "Selby Jennings",
    "year_salary": "525000.0",
    "posted_date": "2023-09-01",
    "skills": "sql",
    "type": "programming"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "sql",
    "type": "programming"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "python",
    "type": "programming"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "java",
    "type": "programming"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "cassandra",
    "type": "databases"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "spark",
    "type": "libraries"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "hadoop",
    "type": "libraries"
  },
  {
    "job_id": 1131472,
    "title": "Data Scientist",
    "company": "Algo Capital Group",
    "year_salary": "375000.0",
    "posted_date": "2023-07-31",
    "skills": "tableau",
    "type": "analyst_tools"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "azure",
    "type": "cloud"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "aws",
    "type": "cloud"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "tensorflow",
    "type": "libraries"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "keras",
    "type": "libraries"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "pytorch",
    "type": "libraries"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "scikit-learn",
    "type": "libraries"
  },
  {
    "job_id": 126218,
    "title": "Director Level - Product Management - Data Science",
    "company": "Teramind",
    "year_salary": "320000.0",
    "posted_date": "2023-03-26",
    "skills": "datarobot",
    "type": "analyst_tools"
  },
  {
    "job_id": 226011,
    "title": "Distinguished Data Scientist",
    "company": "Walmart",
    "year_salary": "300000.0",
    "posted_date": "2023-08-06",
    "skills": "scala",
    "type": "programming"
  },
  {
    "job_id": 226011,
    "title": "Distinguished Data Scientist",
    "company": "Walmart",
    "year_salary": "300000.0",
    "posted_date": "2023-08-06",
    "skills": "java",
    "type": "programming"
  },
  {
    "job_id": 226011,
    "title": "Distinguished Data Scientist",
    "company": "Walmart",
    "year_salary": "300000.0",
    "posted_date": "2023-08-06",
    "skills": "spark",
    "type": "libraries"
  },
  {
    "job_id": 226011,
    "title": "Distinguished Data Scientist",
    "company": "Walmart",
    "year_salary": "300000.0",
    "posted_date": "2023-08-06",
    "skills": "tensorflow",
    "type": "libraries"
  },
  {
    "job_id": 226011,
    "title": "Distinguished Data Scientist",
    "company": "Walmart",
    "year_salary": "300000.0",
    "posted_date": "2023-08-06",
    "skills": "pytorch",
    "type": "libraries"
  },
  {
    "job_id": 226011,
    "title": "Distinguished Data Scientist",
    "company": "Walmart",
    "year_salary": "300000.0",
    "posted_date": "2023-08-06",
    "skills": "kubernetes",
    "type": "other"
  },
  {
    "job_id": 457991,
    "title": "Head of Battery Data Science",
    "company": "Lawrence Harvey",
    "year_salary": "300000.0",
    "posted_date": "2023-10-02",
    "skills": "python",
    "type": "programming"
  },
  {
    "job_id": 457991,
    "title": "Head of Battery Data Science",
    "company": "Lawrence Harvey",
    "year_salary": "300000.0",
    "posted_date": "2023-10-02",
    "skills": "aws",
    "type": "cloud"
  },
  {
    "job_id": 457991,
    "title": "Head of Battery Data Science",
    "company": "Lawrence Harvey",
    "year_salary": "300000.0",
    "posted_date": "2023-10-02",
    "skills": "gcp",
    "type": "cloud"
  },
  {
    "job_id": 38905,
    "title": "Principal Data Scientist",
    "company": "Storm5",
    "year_salary": "300000.0",
    "posted_date": "2023-11-24",
    "skills": "sql",
    "type": "programming"
  },
  {
    "job_id": 38905,
    "title": "Principal Data Scientist",
    "company": "Storm5",
    "year_salary": "300000.0",
    "posted_date": "2023-11-24",
    "skills": "python",
    "type": "programming"
  },
  {
    "job_id": 38905,
    "title": "Principal Data Scientist",
    "company": "Storm5",
    "year_salary": "300000.0",
    "posted_date": "2023-11-24",
    "skills": "java",
    "type": "programming"
  },
  {
    "job_id": 38905,
    "title": "Principal Data Scientist",
    "company": "Storm5",
    "year_salary": "300000.0",
    "posted_date": "2023-11-24",
    "skills": "c",
    "type": "programming"
  },
  {
    "job_id": 38905,
    "title": "Principal Data Scientist",
    "company": "Storm5",
    "year_salary": "300000.0",
    "posted_date": "2023-11-24",
    "skills": "aws",
    "type": "cloud"
  },
  {
    "job_id": 38905,
    "title": "Principal Data Scientist",
    "company": "Storm5",
    "year_salary": "300000.0",
    "posted_date": "2023-11-24",
    "skills": "gcp",
    "type": "cloud"
  }
]
*/
