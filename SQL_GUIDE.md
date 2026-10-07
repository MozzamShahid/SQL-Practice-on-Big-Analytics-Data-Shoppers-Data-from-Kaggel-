# SQL Practice Guide

Your personal SQL playground: **1,000,000 e-commerce shoppers × 60 columns**, running on **DuckDB**.

---

## 1. Your files

| File | What it is |
|---|---|
| `start-ui.bat` | **Double-click** → opens the visual SQL editor in your browser (http://localhost:4213). Close the black window to stop it. |
| `start-sql.bat` | Double-click → opens the terminal SQL prompt (`.quit` to exit). |
| `shop.duckdb` | The database (table `shoppers`). |
| `questions.sql` | 20 practice questions, easy → advanced, plus bonus ideas. |
| `solutions.sql` | Answers. Try first, peek later! |
| `practice.sql` | 7 warm-up example queries. |
| `e_commerce_...csv` | Original data (untouched — safe backup). |

> ⚠️ Only one program can open `shop.duckdb` at a time. Close the UI before using `start-sql.bat`, and vice versa.

**Broke something?** Rebuild the table from the CSV anytime:
```sql
CREATE OR REPLACE TABLE shoppers AS
SELECT * FROM read_csv_auto('e_commerce_shopper_behaviour_and_lifestyle.csv');
```

---

## 2. The data (`shoppers` table)

**Who they are**
| Column | Values |
|---|---|
| `user_id` | 1 … 1,000,000 (unique) |
| `age` | 18 – 80 |
| `gender` | Male, Female, Non-binary, Other |
| `country` | USA, Canada, Brazil, UK, Germany, France, India, China, Japan, Australia |
| `urban_rural` | Urban, Suburban, Rural |
| `income_level` | 10,000 – 200,000 (yearly income) |
| `employment_status` | Employed, Self-employed, Unemployed, Student, Retired |
| `education_level` | High School, Associate Degree, Bachelor, Master, PhD |
| `occupation` | Engineering, Education, Marketing, Finance, Retail, Healthcare, IT, Other |
| `relationship_status`, `ethnicity`, `language_preference` | text |
| `has_children` | 0 / 1 |
| `household_size` | number |

**How they shop**
| Column | Meaning |
|---|---|
| `device_type` | Mobile, Desktop, Tablet |
| `preferred_payment_method` | Credit Card, Debit Card, PayPal, Apple Pay, Google Pay, Bank Transfer |
| `product_category_preference` | Electronics, Fashion, Beauty, Books, Toys, Sports, Groceries, Home & Kitchen |
| `shopping_time_of_day` | Morning, Afternoon, Evening, Night |
| `budgeting_style` | Strict, Moderate, Loose |
| `weekly_purchases`, `monthly_spend`, `average_order_value` | numbers |
| `cart_abandonment_rate`, `purchase_conversion_rate`, `return_rate`, `notification_response_rate` | percentages (0–100) |
| `impulse_purchases_per_month`, `checkout_abandonments_per_month`, `referral_count` | counts |
| `loyalty_program_member`, `weekend_shopper`, `premium_subscription`, `health_conscious_shopping` | 0 = no, 1 = yes |
| `last_purchase_date` | DATE (2025-01-01 → 2027-01-01 — some are in the future!) |

**Online behaviour:** `daily_session_time_minutes`, `product_views_per_day`, `ad_views_per_day`, `ad_clicks_per_day`, `wishlist_items_count`, `cart_items_average`, `app_usage_frequency`, `account_age_months`, `social_sharing_frequency`, `social_media_influence_score`

**Lifestyle (scores):** `brand_loyalty_score`, `impulse_buying_score`, `environmental_consciousness`, `travel_frequency`, `hobby_count`, `reading_habits`, `exercise_frequency`, `stress_from_financial_decisions`, `overall_stress_level`, `sleep_quality`, `physical_activity_level`, `mental_health_score`

Run `DESCRIBE shoppers;` to see all columns with types.

> ℹ️ This dataset looks **synthetic** (computer-generated): groups are very evenly sized and averages barely differ. Perfect for practising SQL — just don't expect real-world insights.

---

## 3. SQL cheat sheet

### Query skeleton (write in this order)
```sql
SELECT    columns, aggregates
FROM      table
WHERE     row filter
GROUP BY  grouping columns
HAVING    group filter
ORDER BY  sort columns  [ASC | DESC]
LIMIT     n;
```

### …but SQL *runs* it in this order
`FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`

That's why you **can't** use `AVG()` inside `WHERE` (groups don't exist yet) — use `HAVING` instead.

### Filtering
```sql
WHERE age > 30
WHERE country = 'Japan'                -- text uses 'single quotes'
WHERE age BETWEEN 25 AND 35            -- inclusive
WHERE country IN ('UK', 'France')
WHERE occupation LIKE 'Eng%'           -- % = anything
WHERE x IS NULL                        -- never use  = NULL
WHERE a = 1 AND (b = 2 OR c = 3)       -- use brackets with OR!
```

### Aggregate functions
| Function | Does |
|---|---|
| `COUNT(*)` | number of rows |
| `COUNT(DISTINCT col)` | number of unique values |
| `SUM(col)`, `AVG(col)` | total, average |
| `MIN(col)`, `MAX(col)` | smallest, largest |
| `ROUND(x, 2)` | round to 2 decimals |

### CASE (if/else)
```sql
CASE WHEN age < 30 THEN 'Young'
     WHEN age < 60 THEN 'Middle'
     ELSE 'Senior' END AS age_group
```

### Subquery & CTE
```sql
-- subquery
SELECT * FROM shoppers WHERE monthly_spend > (SELECT AVG(monthly_spend) FROM shoppers);

-- CTE = a named temporary result, easier to read
WITH country_avg AS (
    SELECT country, AVG(monthly_spend) AS avg_spend FROM shoppers GROUP BY country
)
SELECT * FROM country_avg WHERE avg_spend > 2500;
```

### JOINs
| Join | Keeps |
|---|---|
| `INNER JOIN` | only rows that match in both tables |
| `LEFT JOIN` | all rows from the left table (NULL where no match) |
| `FULL JOIN` | everything from both |

```sql
SELECT s.user_id, c.continent
FROM shoppers s
JOIN continents c ON s.country = c.country;
```

### Window functions (calculate *without* collapsing rows)
```sql
ROW_NUMBER() OVER (PARTITION BY country ORDER BY monthly_spend DESC)  -- 1,2,3,4…
RANK()       OVER (ORDER BY score DESC)                                -- 1,2,2,4…
DENSE_RANK() OVER (ORDER BY score DESC)                                -- 1,2,2,3…
AVG(monthly_spend) OVER (PARTITION BY country)                         -- group avg on every row
SUM(x) OVER (ORDER BY date)                                            -- running total
LAG(x) OVER (ORDER BY date)                                            -- previous row's value
```

### Dates
```sql
YEAR(last_purchase_date), MONTH(last_purchase_date)
date_trunc('month', last_purchase_date)
CURRENT_DATE
last_purchase_date >= DATE '2026-01-01'
date_diff('day', last_purchase_date, CURRENT_DATE)
```

### Changing data (practise on a copy!)
```sql
CREATE TABLE test AS SELECT * FROM shoppers LIMIT 1000;   -- safe copy
UPDATE test SET age = age + 1 WHERE country = 'UK';
DELETE FROM test WHERE monthly_spend < 100;
CREATE VIEW big_spenders AS SELECT * FROM shoppers WHERE monthly_spend > 4000;
DROP TABLE test;
```

---

## 4. Common mistakes

1. **Column in SELECT but not in GROUP BY** → error. Every non-aggregated column must be grouped.
2. **Integer division:** `5 / 2` may surprise you — use `5 * 1.0 / 2` or `100.0 * a / b` for percentages.
3. **Dividing by zero:** wrap the divisor: `a / NULLIF(b, 0)`.
4. **`= NULL`** never matches → use `IS NULL`.
5. **`"double quotes"`** are for column names, **`'single quotes'`** for text.
6. **`SELECT *` with no LIMIT** on 1M rows → slow browser. Add `LIMIT 100`.
7. **AND/OR without brackets** → wrong rows. Bracket your ORs.

---

## 5. Handy DuckDB extras

```sql
DESCRIBE shoppers;                 -- columns & types
SUMMARIZE shoppers;                -- min/max/avg/nulls for EVERY column (great for exploring!)
SELECT * FROM shoppers USING SAMPLE 10;   -- 10 random rows
SHOW TABLES;
COPY (SELECT ...) TO 'result.csv';        -- export a result
```
Terminal-only commands: `.read file.sql`, `.mode line` (one value per line, good for wide rows), `.timer on`, `.quit`.

---

## 6. Suggested learning path

1. **Week 1:** Questions 1–5 · experiment with WHERE and ORDER BY.
2. **Week 2:** Questions 6–10 · GROUP BY until it feels natural.
3. **Week 3:** Questions 11–14 · CASE and dates.
4. **Week 4:** Questions 15–20 · subqueries, CTEs, windows, JOINs.
5. **Then:** the bonus questions, and invent your own: *"Do Night shoppers abandon more carts?"*

**Golden rule:** before writing SQL, say the question in plain words, then guess the answer's *shape* (one number? one row per country?). That tells you whether you need GROUP BY.

---

## 7. Further learning (free)

- **DuckDB docs (SQL reference):** https://duckdb.org/docs/stable/sql/introduction
- **SQLBolt** — short interactive lessons: https://sqlbolt.com
- **SQLZoo** — practice exercises: https://sqlzoo.net
- **Mode SQL Tutorial** — analytics-focused: https://mode.com/sql-tutorial
- **Select Star SQL** — free interactive book: https://selectstarsql.com
- **LeetCode / HackerRank SQL** — interview-style problems once you're comfortable
