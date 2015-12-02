-- KPI - Active Buffet Subscriber
SELECT
    core_platforms.name as platform_name,
    count(core_payments.user_id) as total_active_buffet_subscriber
FROM
    core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
    JOIN (SELECT orderline_id, MAX(valid_to) AS valid_to FROM core_userbuffets GROUP BY orderline_id) core_userbuffets ON core_userbuffets.orderline_id = core_orderlines.id
    left join core_orders on core_orders.id = core_orderlines.order_id
    left join core_platforms on core_platforms.id = core_orders.platform_id
WHERE 1=1
    AND core_payments.payment_status = 20003
    AND core_payments.is_active = TRUE
    AND core_payments.is_test_payment = FALSE
    AND core_offers.offer_type_id = 4
    AND core_userbuffets.valid_to >= NOW()
group by platform_name

-- 	KPI - All Buffet Subscriber
SELECT distinct
    core_platforms.name as platform_name,
    count(core_payments.user_id) as total_all_subscriber
FROM 
    core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
    left join core_orders on core_orders.id = core_orderlines.order_id
    left join core_platforms on core_platforms.id = core_orders.platform_id 
WHERE 1=1
    AND core_payments.payment_status = 20003
    AND core_payments.is_active = TRUE
    AND core_payments.is_test_payment = FALSE
    AND core_offers.offer_type_id = 4
group by platform_name
    
    
-- KPI - Buffet Performance
SELECT distinct
    core_orderlines.id,
    core_payments.modified::DATE AS subscription_date,
    core_payments.user_id AS total_subscribers,
    CASE WHEN core_payments.modified::DATE > first_subscription_date THEN core_payments.user_id END AS renewal_subscriptions,
    CASE WHEN core_payments.modified::DATE = first_subscription_date THEN core_payments.user_id END AS new_subscriptions,
    core_platforms.name as platform_name
FROM 
    core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
    left join core_orders on core_orders.id = core_orderlines.order_id
    left join core_platforms on core_platforms.id = core_orders.platform_id      
    JOIN (
        SELECT 
            core_payments.user_id,
            MIN(core_payments.modified)::DATE AS first_subscription_date
        FROM 
            core_payments
            JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
            JOIN core_offers ON core_offers.id = core_orderlines.offer_id
            
        WHERE 1=1
            AND core_payments.payment_status = 20003
            AND core_payments.is_active = TRUE
            AND core_payments.is_test_payment = FALSE
            AND core_offers.offer_type_id = 4
        GROUP BY 1=1
            ,core_payments.user_id
    ) first_subscription ON first_subscription.user_id = core_payments.user_id
WHERE 1=1
    AND core_payments.payment_status = 20003
    AND core_payments.is_active = TRUE
    AND core_payments.is_test_payment = FALSE
    AND core_offers.offer_type_id = 4
ORDER BY
    subscription_date DESC
    
-- KPI - Buffet Cohort Analysis
SELECT distinct 
    core_orderlines.id,
    first_subscribe_date::DATE,
    CASE WHEN core_payments.modified <= first_subscribe_date + INTERVAL '1 month' - INTERVAL '1 day' THEN core_payments.user_id ELSE null END AS m_0,
    CASE WHEN core_payments.modified > first_subscribe_date + INTERVAL '1 month' - INTERVAL '1 day' AND core_payments.modified <= first_subscribe_date + INTERVAL '2 month' - INTERVAL '1 day' THEN core_payments.user_id ELSE null END AS m_1,
    CASE WHEN core_payments.modified > first_subscribe_date + INTERVAL '2 month' - INTERVAL '1 day' AND core_payments.modified <= first_subscribe_date + INTERVAL '3 month' - INTERVAL '1 day' THEN core_payments.user_id ELSE null END AS m_2,
    core_platforms.name as platform
FROM core_payments
    JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
    JOIN core_offers ON core_offers.id = core_orderlines.offer_id
    JOIN (
        SELECT
            core_payments.user_id,
            MIN(core_payments.modified) AS first_subscribe_date
        FROM core_payments
            JOIN core_orderlines ON core_orderlines.order_id = core_payments.order_id
            JOIN core_offers ON core_offers.id = core_orderlines.offer_id
        WHERE 1=1
            AND core_payments.payment_status = 20003
            AND core_payments.is_active = TRUE
            AND core_payments.is_test_payment = FALSE
            AND core_offers.offer_type_id = 4
        GROUP BY 1=1
            ,core_payments.user_id
    ) first_subscribe ON first_subscribe.user_id = core_payments.user_id
    left join core_orders on core_orders.id = core_orderlines.order_id
    left join core_platforms on core_platforms.id = core_orders.platform_id
WHERE 1=1
    AND core_payments.payment_status = 20003
    AND core_payments.is_active = TRUE
    AND core_payments.is_test_payment = FALSE
    AND core_offers.offer_type_id = 4
ORDER BY
    first_subscribe_date::DATE