-- Task 1
-- Get an overview by selecting all columns and the first 10 rows
SELECT *
FROM survey
LIMIT 10;

-- Task 2
-- How many unique users answer each question in the survey
SELECT question, 
	COUNT(DISTINCT user_id) AS 'number_of_users'
FROM survey
GROUP BY 1;

-- Task 4
-- Get an overview of the three tables, what are the column names
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- Task 5
-- Join the three tables and define two new columns
SELECT DISTINCT q.user_id,
	h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON h.user_id = p.user_id
LIMIT 10;

-- Task 6
-- Calculating conversion rates based on the new table
WITH funnel AS (
	SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
  	h.number_of_pairs,
  	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz AS 'q'
	LEFT JOIN home_try_on AS 'h'
		ON q.user_id = h.user_id
	LEFT JOIN purchase AS 'p'
		ON h.user_id = p.user_id)
SELECT COUNT(*) AS 'Count', 
	sum(is_home_try_on) AS 'nr_home_try', 
	sum(is_purchase) AS 'nr_of_purchase', 
	1.0 * sum(is_home_try_on) / COUNT(user_id) AS 'quiz_to_home_try_on', 
	1.0 * sum(is_purchase) / sum(is_home_try_on) AS 'home_try_on_to_purchase'
FROM funnel;

-- Conversion rates grouped by number of pairs
WITH funnel AS (
	SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
  	h.number_of_pairs,
  	p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz AS 'q'
	LEFT JOIN home_try_on AS 'h'
		ON q.user_id = h.user_id
	LEFT JOIN purchase AS 'p'
		ON h.user_id = p.user_id)
SELECT number_of_pairs,
	COUNT(*) AS 'number_of_users',
	sum(is_purchase) 'number_of_purchases',
	ROUND(1.0 * sum(is_purchase) / COUNT(*), 2) AS 'purhcase_rate'
FROM funnel
WHERE number_of_pairs = '3 pairs' 
 OR number_of_pairs = '5 pairs'
GROUP BY 1;

-- Additional analysis

-- Do we sell more of women's or men's styles?
SELECT style, COUNT(DISTINCT user_id) AS 'nr_sold',
		ROUND(1.0 * sum(price) / COUNT(DISTINCT user_id), 2) AS 'avg_price_per_style', sum(price) AS 'money_made'
FROM purchase 
GROUP BY 1;

-- Which models are selling best?
SELECT style, model_name, COUNT(*) AS 'nr_sold', price AS 'price_per_unit', sum(price) AS 'money_made'
FROM purchase
GROUP BY 2
ORDER BY 3 DESC;

  