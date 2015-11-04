select distinct 
        s_sales.orderline_id  as "orderline id"
        ,to_char(d_utc_sales_date.utc_sales_date, 'YYYY-MM') as "period date"
        ,date_trunc('MONTH',d_utc_sales_date.utc_sales_date)::timestamp as "start date"
        ,((date_trunc('MONTH', d_utc_sales_date.utc_sales_date) + INTERVAL '1 MONTH - 1 day'- INTERVAL '1 SECOND'))::timestamp as "end date"
        ,(d_utc_sales_date.utc_sales_date||' '|| d_utc_sales_time.utc_sales_time)::timestamp
        ,d_clients.client_name as application
        ,d_clients.platform_name as platform
        ,1 as qty
        ,coalesce(d_offers.vendor_name_by_finance, d_offers.vendor_name) as publisher
        ,d_offers.brand_name as media
        ,d_offers.item_name as product
        ,d_offers.isbn as ISBN
        ,s_sales.currency_code as "currency code"
        ,s_sales.local_currency_gross_sales as price
        ,s_sales.publisher_gross_share as "real price"
        ,d_offers.offer_price_idr as "normal price idr"
        ,d_offers.offer_price_usd as "normal price usd"
        ,d_offers.offer_price_pts as "normal price pts"
        ,case when paymentgatewaycosts_id = 1 then 'New' else 'Old' end as "aggrement status"
        ,s_sales.publisher_net_share

from s_sales
join d_offers on d_offers.offer_id = s_sales.offer_id
join d_utc_sales_date on d_utc_sales_date.utc_sales_date_key = s_sales.utc_sales_date_key
join d_utc_sales_time on d_utc_sales_time.utc_sales_time_key = s_sales.utc_sales_time_key
join d_clients on d_clients.client_id = s_sales.client_id

where 1=1
and d_utc_sales_date.utc_sales_date::date between '2015-09-01' and '2015-09-30'
limit 500