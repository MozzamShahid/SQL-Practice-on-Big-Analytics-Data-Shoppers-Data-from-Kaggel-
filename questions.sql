-- =====================================================================
--  20 SQL PRACTICE QUESTIONS  —  table: shoppers  (1,000,000 rows)
--  Try each one yourself first. Answers are in solutions.sql.
--  Tip: run DESCRIBE shoppers; to see every column.
-- =====================================================================


-- ---------------------------------------------------------------------
--  LEVEL 1 — BASICS  (SELECT, WHERE, ORDER BY, LIMIT, DISTINCT)
-- ---------------------------------------------------------------------

-- Q1. Show user_id, age, country and monthly_spend for the first 10 shoppers.
-- select user_id, age, country, monthly_spend from shoppers limit 10

-- Q2. How many shoppers live in Japan?
-- select count(country) from shoppers where country = 'Japan'


-- Q3. List every different payment method (preferred_payment_method), alphabetically.
-- select preferred_payment_method from shoppers group by preferred_payment_method order by preferred_payment_method asc


-- Q4. Show the 10 shoppers with the highest monthly_spend
--     (user_id, country, monthly_spend). Highest first.
-- select country, max(monthly_spend) from shoppers group by country limit 10


-- Q5. How many shoppers are aged 25 to 35 (inclusive), live in an 'Urban'
--     area AND use a 'Mobile' device?
--     Hint: BETWEEN
-- select count(*) from shoppers where age between 25 and 35 and device_type = 'Mobile' and urban_rural = 'Urban'

-- ---------------------------------------------------------------------
--  LEVEL 2 — AGGREGATION  (COUNT, AVG, SUM, GROUP BY, HAVING)
-- ---------------------------------------------------------------------

-- Q6. How many shoppers are there for each gender? Sort biggest group first.
-- select gender, count(*) from shoppers group by gender order by count(*) desc 


-- Q7. What is the average income_level for each education_level?
--     Round to whole numbers and sort from highest to lowest.
-- select education_level, round(avg(income_level),0) as income_average from shoppers group by education_level order by income_average desc 

-- Q8. Which product_category_preference is the most popular?
--     Show every category with its count, most popular first.
-- select product_category_preference as pv, count(*) as p from shoppers group by pv order by p desc  


-- Q9. Which combinations of employment_status + urban_rural have
--     MORE than 70,000 shoppers?
--     Hint: HAVING filters groups, WHERE filters rows.
-- select employment_status, urban_rural, count(*) as s from shoppers group by employment_status, urban_rural HAVING s > 70000 order by s desc


-- Q10. For each country, what percentage of shoppers are loyalty program
--      members? (loyalty_program_member is 1 = yes, 0 = no)
--      Hint: the average of a 0/1 column is a fraction.
-- select country, count(*), round(count(*) * 100 /(select count(*) from shoppers), 2) as mv from shoppers where loyalty_program_member = 1 group by country order by mv desc 

-- ---------------------------------------------------------------------
--  LEVEL 3 — LOGIC & DATES  (CASE, NULLIF, date functions)
-- ---------------------------------------------------------------------

-- Q11. Put shoppers into income bands:
--        'Low'       under 50,000
--        'Middle'    50,000 – 99,999
--        'High'      100,000 – 149,999
--        'Very high' 150,000+
--      Show the number of shoppers and the average monthly_spend per band.


-- Q12. Compare weekend shoppers with weekday shoppers (weekend_shopper = 1 / 0):
--      show the label 'Weekend' / 'Weekday' and their average
--      impulse_purchases_per_month.


-- Q13. Ad click-through rate: for each device_type calculate
--      total ad_clicks_per_day / total ad_views_per_day as a percentage.
--      Hint: multiply by 100.0 to avoid integer division; NULLIF protects
--      against dividing by zero.


-- Q14. How many shoppers had their last_purchase_date in each YEAR?
--      Then: how many dates are in the FUTURE (after today)?
--      (Real data often has mistakes like this — spotting them is a skill!)


-- ---------------------------------------------------------------------
--  LEVEL 4 — ADVANCED  (subqueries, CTEs, window functions, JOINs)
-- ---------------------------------------------------------------------

-- Q15. How many shoppers spend MORE than the average monthly_spend of
--      everyone? Hint: a subquery inside WHERE.


-- Q16. Using a CTE (WITH ...), work out the average average_order_value per
--      occupation, then show only occupations that are above the average
--      of all those occupation averages.


-- Q17. Rank occupations by their average income_level using RANK().
--      Show occupation, average income and rank.


-- Q18. Find the top 3 spenders (monthly_spend) in EACH product category.
--      Hint: ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)


-- Q19. For every shopper, show their monthly_spend next to the AVERAGE spend
--      of their country, and the difference. Show the 10 shoppers who spend
--      the most above their country's average.
--      Hint: AVG(...) OVER (PARTITION BY country)


-- Q20. JOIN practice: the data has no "continent" column. Build a small
--      lookup table that maps each country to its continent, JOIN it to
--      shoppers, and count shoppers + average monthly_spend per continent.
--      Countries: USA, Canada, Brazil, UK, Germany, France, India, China,
--                 Japan, Australia


-- =====================================================================
--  BONUS (no answers — explore on your own!)
--  B1. Do people with higher overall_stress_level abandon more carts?
--  B2. Does sleep_quality differ between premium_subscription users and others?
--  B3. Which age (single year) has the highest average social_media_influence_score?
--  B4. Create a VIEW called big_spenders for shoppers spending over 4,000/month.
-- =====================================================================
