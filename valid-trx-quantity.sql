SELECT *
FROM core_payments
JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
JOIN core_orders ON core_orders.id = core_payments.order_id
-- JOIN core_orderdetails ON core_orderdetails.order_id = core_orders.id
-- JOIN core_orderlinediscounts ON core_orderlinediscounts.orderline_id = core_orderlines.id
WHERE
core_payments.payment_status = 20003
AND core_payments.is_active = TRUE
AND core_payments.is_test_payment = FALSE
AND core_orderlines.is_active = TRUE
AND core_orderlines.is_free = FALSE
-- AND core_payments.modified BETWEEN '2015-10-01 00:00:00' AND '2015-10-31 23:59:59'