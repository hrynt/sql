SELECT
	utc_sales_year,
	utc_sales_month,
	utc_sales_month_name,
	CASE
   		WHEN offer_purchase_plan = 'Single' THEN 1
   		WHEN offer_purchase_plan = 'Subscription' THEN 2
   		WHEN offer_purchase_plan = 'Buffet' THEN 3
   		WHEN offer_purchase_plan = 'Bundle' THEN 4
  	END
	    AS id_offer_purchase_plan,
	offer_purchase_plan,
	CASE
    	WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT <> utc_sales_month_key THEN 'Return Users'
    	ELSE 'New Users'
  	END
    	AS user_type,
	COUNT(DISTINCT user_id) AS users,
	SUM(quantity) AS quantity,
	SUM(local_currency_gross_sales) AS usd,
	platform_name
FROM
	f_sales_new
	JOIN d_utc_sales_date ON d_utc_sales_date.utc_sales_date_key = f_sales_new.utc_sales_date_key
	JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
	JOIN d_users ON d_users.user_key = f_sales_new.user_key
	JOIN d_clients ON d_clients.client_key = f_sales_new.client_key
GROUP BY
	utc_sales_year,
	utc_sales_month,
	utc_sales_month_name,
	offer_purchase_plan,
	platform_name,
	CASE WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT <> utc_sales_month_key THEN 'Return Users' ELSE 'New Users' END
ORDER BY
	utc_sales_year DESC,
	utc_sales_month DESC