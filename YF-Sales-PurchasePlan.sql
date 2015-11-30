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
    COUNT(DISTINCT CASE
                        WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT <> utc_sales_month_key THEN user_id
                        ELSE NULL
                   END) AS total_return_user,
    COUNT(DISTINCT CASE
                        WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT = utc_sales_month_key THEN user_id
                        ELSE NULL
                   END) AS total_new_user,
    SUM(CASE
            WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT <> utc_sales_month_key THEN quantity
            ELSE 0
        END) AS quantity_return_user,
    SUM(CASE
            WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT = utc_sales_month_key THEN quantity
            ELSE 0
        END) AS quantity_new_user,
    SUM(CASE
            WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT <> utc_sales_month_key THEN local_currency_gross_sales*rate
            ELSE 0
        END)
        AS usd_return_user,
    SUM(CASE
            WHEN TO_CHAR(user_joined_date, 'YYYYMM')::INT = utc_sales_month_key THEN local_currency_gross_sales*rate
            ELSE 0
        END)
      	AS usd_new_user,
    platform_name

FROM
    f_sales_new
    JOIN d_utc_sales_date ON d_utc_sales_date.utc_sales_date_key = f_sales_new.utc_sales_date_key
    JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
    JOIN d_users ON d_users.user_key = f_sales_new.user_key
    JOIN d_clients ON d_clients.client_key = f_sales_new.client_key
    JOIN d_currencies ON d_currencies.currency_key = f_sales_new.currency_key::INTEGER
    JOIN currency_fixed_rate usd ON
                               usd.payment_period = to_char(d_utc_sales_date.utc_sales_date, 'YYYY-MM')
                               AND usd.currency_from = d_currencies.currency_code
                               AND usd.currency_to = 'USD'
GROUP BY
    utc_sales_year,
    utc_sales_month,
    utc_sales_month_name,
    offer_purchase_plan,
    platform_name