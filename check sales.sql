SELECT
	*
FROM
	f_sales_new
	JOIN d_date ON d_date.date_key = utc_sales_date_key
WHERE 1=1
	AND d_date.month_key = 201510