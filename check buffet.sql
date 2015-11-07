WITH data AS (
SELECT 
	orderline_id, 
	valid_to_date_key,
	transaction_amount,
	paymentgateway_cost,
	ROUND(SUM(publisher_revenue_share), 4) AS publisher_revenue_share
FROM 
	f_buffet_estimated_revenue 
GROUP BY
	orderline_id,
	valid_to_date_key,
	transaction_amount,
	paymentgateway_cost
UNION ALL
SELECT 
	orderline_id, 
	valid_to_date_key,
	transaction_amount,
	paymentgateway_cost,
	ROUND(SUM(publisher_revenue_share), 4) AS publisher_revenue_share
FROM 
	f_buffet_fixed_revenue 
GROUP BY
	orderline_id, 
	valid_to_date_key,
	transaction_amount,
	paymentgateway_cost
ORDER BY 
	orderline_id
)

SELECT
	LEFT(valid_to_date_key::TEXT, 6) AS period,
	COUNT(*) AS count,
	COUNT(DISTINCT orderline_id) AS count_distinct
FROM
	data
GROUP BY
	period
ORDER BY
	period