-- SELECT * FROM core_currencyquotes;

SELECT	DISTINCT
	regexp_replace(base_currency, '\r|\n', '', 'g') AS base_currency,
	regexp_replace(counter_currency, '\r|\n', '', 'g') AS counter_currency
FROM 
	(SELECT 'USD' AS counter_currency UNION SELECT 'IDR' UNION SELECT 'SGD') data, 
	(SELECT regexp_replace(base_currency, '\r|\n', '', 'g') AS base_currency FROM (SELECT DISTINCT localized_currency_code AS base_currency FROM core_orderlines WHERE localized_currency_code IS NOT NULL UNION SELECT DISTINCT printed_currency_code FROM core_items WHERE printed_currency_code IS NOT NULL) data) data2
WHERE 1=1
-- 	AND base_currency <> counter_currency
ORDER BY
	counter_currency,
	base_currency