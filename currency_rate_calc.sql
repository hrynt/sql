-- SELECT * FROM currency_rate_new

SELECT
payment_period,
currency_from,
MAX(CASE WHEN currency_to = 'IDR' THEN rate ELSE 0 END) AS idr,
MAX(CASE WHEN currency_to = 'USD' THEN rate ELSE 0 END) AS usd,
MAX(CASE WHEN currency_to = 'SGD' THEN rate ELSE 0 END) AS sgd
FROM currency_rate 
WHERE 1=1
AND payment_period NOT IN ('2015-10', '2015-11')
AND currency_from IN ('IDR', 'SGD', 'USD', 'PTS') 
AND currency_to IN ('IDR', 'SGD', 'USD', 'PTS') 
GROUP BY
payment_period,
currency_from
ORDER BY payment_period DESC, currency_from--, currency_to