CREATE MATERIALIZED VIEW agg_buffet_financeportalreport AS
SELECT
	item_name,
	brand_name,
	d_items.vendor_currency,
	vendor_currency_rate,
	SUM(duration)::TEXT::INTERVAL AS reading_duration,
	SUM(vendor_revenue_payment) AS revenue,
	TO_CHAR(d_date.DATE, 'YYYY-MM') AS dates,
	d_items.vendor_name AS vendor_name,
  d_items.vendor_id,
  TO_CHAR(d_date.date, 'YYYY-MM') AS year_month
FROM
	f_buffet_fixed_revenue
	JOIN d_items ON d_items.item_key = f_buffet_fixed_revenue.item_key
	JOIN d_date ON d_date.date_key = f_buffet_fixed_revenue.valid_to_date_key
GROUP BY
	item_name,
	brand_name,
	d_items.vendor_currency,
	vendor_currency_rate,
	TO_CHAR(d_date.DATE, 'YYYY-MM'),
	d_items.vendor_name,
	d_items.vendor_id

-- detail
SELECT
	item_name,
	brand_name,
	vendor_currency,
	vendor_currency_rate,
	TO_CHAR(reading_duration, 'HH24h MIm SSs') AS reading_duration,
	revenue,
	dates,
	(CASE WHEN 0 = 0 THEN 'ALL' ELSE vendor_name END) AS vendors
FROM
	agg_buffet_financeportalreport
WHERE 1=1
	AND CASE WHEN 0 = 0 THEN 0 ELSE vendor_id END = 0
	AND dates = '2015-09'
ORDER BY
	brand_name ASC,
	item_name DESC

-- summary
SELECT
	dates,
	vendor_name AS vendors,
	vendor_currency,
	COUNT(DISTINCT brand_name) AS accessed_titles,
	COUNT(DISTINCT item_name) AS accessed_edition,
	TO_CHAR(SUM(reading_duration), 'HH24h MIm SSs') AS reading_duration,
	SUM(revenue)AS revenue,
	(CASE WHEN 0 = 0 THEN 'ALL' ELSE vendor_name END) AS vendors2
FROM
	agg_buffet_financeportalreport
WHERE 1=1
	AND CASE WHEN 0 = 0 THEN 0 ELSE vendor_id END = 0
	AND dates = '2015-09'
GROUP BY
	dates,
	vendor_name,
	vendor_currency
ORDER BY
	vendor_name