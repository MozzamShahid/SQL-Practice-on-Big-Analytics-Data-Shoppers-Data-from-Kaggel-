-- Run inside DuckDB with:  .read practice.sql   (or copy/paste one query at a time)

-- 1. Basics: look at a few rows
SELECT user_id, age, gender, country, monthly_spend FROM shoppers LIMIT 10;

-- 2. Filtering (WHERE)
SELECT count(*) FROM shoppers WHERE country = 'Germany' AND age < 30;

-- 3. Aggregation (GROUP BY)
SELECT country, count(*) AS shoppers, round(avg(monthly_spend), 0) AS avg_spend
FROM shoppers GROUP BY country ORDER BY avg_spend DESC;

-- 4. HAVING (filter after grouping)
SELECT occupation, avg(income_level) AS avg_income
FROM shoppers GROUP BY occupation HAVING avg(income_level) > 60000;

-- 5. CASE: bucket ages
SELECT CASE WHEN age < 25 THEN '18-24' WHEN age < 40 THEN '25-39'
            WHEN age < 60 THEN '40-59' ELSE '60+' END AS age_group,
       round(avg(impulse_purchases_per_month), 2) AS avg_impulse
FROM shoppers GROUP BY age_group ORDER BY age_group;

-- 6. Window function: top 3 spenders per country
SELECT * FROM (
  SELECT country, user_id, monthly_spend,
         row_number() OVER (PARTITION BY country ORDER BY monthly_spend DESC) AS rnk
  FROM shoppers) WHERE rnk <= 3;

-- 7. Dates: purchases by month
SELECT date_trunc('month', last_purchase_date) AS month, count(*)
FROM shoppers GROUP BY month ORDER BY month;
