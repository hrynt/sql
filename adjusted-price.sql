-- non-buffet 2014-01 to 2015-07
UPDATE core_orderlines
SET
  adjusted_currency_code = adjusted.currency_code,
  adjusted_price = adjusted.price,
  adjusted_final_price = adjusted.final_price
FROM (
  SELECT
    core_orderlines.id,
    core_orderlines.currency_code,
    core_orderlines.price,
    core_orderlines.final_price
  FROM
    core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
  WHERE 1=1
    AND core_payments.payment_period IS NOT NULL
    AND core_offers.offer_type_id <> 4
    AND core_payments.payment_period BETWEEN '2014-01' AND '2015-07'
) adjusted
WHERE adjusted.id = core_orderlines.id;

-- non-buffet 2015-08 & 2015-09
UPDATE core_orderlines
SET
  adjusted_currency_code = adjusted.currency_code_temp,
  adjusted_price = adjusted.price_temp,
  adjusted_final_price = adjusted.final_price_temp
FROM (
  SELECT
    core_orderlines.id,
    core_orderlines.currency_code_temp,
    core_orderlines.price_temp,
    core_orderlines.final_price_temp
  FROM
    core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
  WHERE 1=1
    AND core_payments.payment_period IS NOT NULL
    AND core_offers.offer_type_id <> 4
    AND core_payments.payment_period IN ('2015-08', '2015-09')
) adjusted
WHERE adjusted.id = core_orderlines.id;

-- buffet 2015-06 to 2015-09
UPDATE core_orderlines
SET
  adjusted_currency_code = adjusted.currency_code_temp,
  adjusted_price = adjusted.price_temp,
  adjusted_final_price = adjusted.final_price_temp
FROM (
  SELECT
    core_orderlines.id,
    core_orderlines.currency_code_temp,
    core_orderlines.price_temp,
    core_orderlines.final_price_temp
  FROM
    core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
  WHERE 1=1
    AND core_payments.payment_period IS NOT NULL
    AND core_offers.offer_type_id = 4
    AND core_payments.payment_period BETWEEN '2015-06' AND '2015-09'
) adjusted
WHERE adjusted.id = core_orderlines.id;

-- non-buffet 2015-10
UPDATE core_orderlines
SET
  adjusted_currency_code = publisher_calculation.adjusted_currency_code,
  adjusted_price = publisher_calculation.adjusted_price,
  adjusted_final_price = publisher_calculation.adjusted_final_price
FROM publisher_calculation
WHERE publisher_calculation.orderline_id = core_orderlines.id;


