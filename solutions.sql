-- =====================================================================
--  SOLUTIONS for questions.sql
--  There is often more than one correct answer — if yours gives the same
--  result, it is right!
-- =====================================================================

-- Q1
SELECT user_id, age, country, monthly_spend
FROM shoppers
LIMIT 10;

-- Q2
SELECT COUNT(*) AS japan_shoppers
FROM shoppers
WHERE country = 'Japan';

-- Q3
SELECT DISTINCT preferred_payment_method
FROM shoppers
ORDER BY preferred_payment_method;

-- Q4
SELECT user_id, country, monthly_spend
FROM shoppers
ORDER BY monthly_spend DESC
LIMIT 10;

-- Q5
SELECT COUNT(*) AS young_urban_mobile
FROM shoppers
WHERE age BETWEEN 25 AND 35
  AND urban_rural = 'Urban'
  AND device_type = 'Mobile';

-- Q6
SELECT gender, COUNT(*) AS shoppers
FROM shoppers
GROUP BY gender
ORDER BY shoppers DESC;

-- Q7
SELECT education_level, ROUND(AVG(income_level)) AS avg_income
FROM shoppers
GROUP BY education_level
ORDER BY avg_income DESC;

-- Q8
SELECT product_category_preference, COUNT(*) AS shoppers
FROM shoppers
GROUP BY product_category_preference
ORDER BY shoppers DESC;

-- Q9
SELECT employment_status, urban_rural, COUNT(*) AS shoppers
FROM shoppers
GROUP BY employment_status, urban_rural
HAVING COUNT(*) > 70000
ORDER BY shoppers DESC;

-- Q10
SELECT country,
       ROUND(AVG(loyalty_program_member) * 100, 1) AS pct_loyalty_members
FROM shoppers
GROUP BY country
ORDER BY pct_loyalty_members DESC;

-- Q11
SELECT CASE
         WHEN income_level < 50000  THEN 'Low'
         WHEN income_level < 100000 THEN 'Middle'
         WHEN income_level < 150000 THEN 'High'
         ELSE 'Very high'
       END AS income_band,
       COUNT(*)                   AS shoppers,
       ROUND(AVG(monthly_spend))  AS avg_monthly_spend
FROM shoppers
GROUP BY income_band
ORDER BY MIN(income_level);          -- keeps bands in natural order

-- Q12
SELECT CASE WHEN weekend_shopper = 1 THEN 'Weekend' ELSE 'Weekday' END AS shopper_type,
       ROUND(AVG(impulse_purchases_per_month), 2) AS avg_impulse_purchases
FROM shoppers
GROUP BY shopper_type;

-- Q13
SELECT device_type,
       ROUND(SUM(ad_clicks_per_day) * 100.0
             / NULLIF(SUM(ad_views_per_day), 0), 2) AS click_through_pct
FROM shoppers
GROUP BY device_type
ORDER BY click_through_pct DESC;

-- Q14 (part 1)
SELECT YEAR(last_purchase_date) AS purchase_year, COUNT(*) AS shoppers
FROM shoppers
GROUP BY purchase_year
ORDER BY purchase_year;

-- Q14 (part 2)
SELECT COUNT(*) AS future_dates
FROM shoppers
WHERE last_purchase_date > CURRENT_DATE;

-- Q15
SELECT COUNT(*) AS above_average_spenders
FROM shoppers
WHERE monthly_spend > (SELECT AVG(monthly_spend) FROM shoppers);

-- Q16
WITH occ AS (
    SELECT occupation, AVG(average_order_value) AS avg_aov
    FROM shoppers
    GROUP BY occupation
)
SELECT occupation, ROUND(avg_aov, 2) AS avg_order_value
FROM occ
WHERE avg_aov > (SELECT AVG(avg_aov) FROM occ)
ORDER BY avg_aov DESC;

-- Q17
SELECT occupation,
       ROUND(AVG(income_level)) AS avg_income,
       RANK() OVER (ORDER BY AVG(income_level) DESC) AS income_rank
FROM shoppers
GROUP BY occupation
ORDER BY income_rank;

-- Q18
SELECT *
FROM (
    SELECT product_category_preference, user_id, monthly_spend,
           ROW_NUMBER() OVER (PARTITION BY product_category_preference
                              ORDER BY monthly_spend DESC, user_id) AS rn
    FROM shoppers
) ranked
WHERE rn <= 3
ORDER BY product_category_preference, rn;

-- Q19
SELECT user_id, country, monthly_spend,
       ROUND(AVG(monthly_spend) OVER (PARTITION BY country)) AS country_avg,
       monthly_spend - ROUND(AVG(monthly_spend) OVER (PARTITION BY country)) AS diff
FROM shoppers
ORDER BY diff DESC, user_id
LIMIT 10;

-- Q20  (option A: a lookup "table" made on the fly with VALUES)
WITH continents(country, continent) AS (
    VALUES ('USA','North America'), ('Canada','North America'),
           ('Brazil','South America'),
           ('UK','Europe'), ('Germany','Europe'), ('France','Europe'),
           ('India','Asia'), ('China','Asia'), ('Japan','Asia'),
           ('Australia','Oceania')
)
SELECT c.continent,
       COUNT(*)                   AS shoppers,
       ROUND(AVG(s.monthly_spend)) AS avg_monthly_spend
FROM shoppers s
JOIN continents c ON s.country = c.country
GROUP BY c.continent
ORDER BY shoppers DESC;

-- Q20  (option B: a real table saved in the database)
-- CREATE TABLE continents (country VARCHAR, continent VARCHAR);
-- INSERT INTO continents VALUES ('USA','North America'), ('Canada','North America'), ... ;
-- Then the same SELECT ... JOIN as above.
-- (DROP TABLE continents;  removes it again.)
