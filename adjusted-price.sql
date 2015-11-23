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
WHERE adjusted.id = core_orderlines.id
