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
ORDER BY 
	orderline_id
)

SELECT
	*
FROM
	data
WHERE
	orderline_id IN (
	SELECT
		orderline_id
	FROM 
		data
	GROUP BY
		orderline_id
	HAVING
		COUNT(*) > 1
	)