SELECT 's', COUNT(*) FROM s_sales_new
UNION ALL
SELECT 'f', COUNT(*) FROM f_sales_new;

SELECT COUNT(*) 
FROM s_sales_new f
JOIN d_users ON d_users.user_id = f.user_id AND d_users.current_version = 1
JOIN d_offers ON d_offers.offer_id = f.offer_id AND d_offers.current_version = 1
JOIN d_clients ON d_clients.client_id = f.client_id AND d_clients.current_version = 1
JOIN d_paymentgateways ON d_paymentgateways.paymentgateway_id = f.paymentgateway_id AND d_paymentgateways.current_version = 1
JOIN d_locations ON d_locations.city = f.sales_city AND d_locations.country = f.sales_country
JOIN d_currencies ON d_currencies.currency_code = f.currency_code AND d_currencies.current_version = 1
JOIN d_partners ON d_partners.partner_id = f.partner_id AND d_partners.current_version = 1
JOIN discount_group_key ON discount_group_key.discount_group_id = f.discount_group_id;