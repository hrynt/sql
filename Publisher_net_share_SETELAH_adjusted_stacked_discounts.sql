
select
        * -- STEP4
        ,case
        when revenueshare_id != 8 or platform_id != 4
        then (publisher_gross_share_after_pg * vendor_percentage_amount) + vendor_fixed_amount 
        else  (publisher_gross_share_after_pg * webstore_percentage_amount) + webstore_fixed_amount
        end as publisher_net_share
     from 
        (
        select 
                step3.* -- STEP3
                -- PAYMENTGATEWAY_COST
                ,(publisher_gross_share * pg_percentage_amount) + pg_fixed_amount as paymentgateway_cost
                ,case when paymentgatewaycosts_id = 2 then publisher_gross_share
                else publisher_gross_share - (publisher_gross_share * pg_percentage_amount) - pg_fixed_amount end as publisher_gross_share_after_pg 


        FROM (
        SELECT 
        step2.*, --STEP2
        -- PUBLISHER GROSS SHARE
        CASE 
        -- DISCOUNT IS NULL 
        when orderlinediscount_id = '{NULL}' then adjusted_final_price
        --NO PARTICIPATION VENDORS
        WHEN step2.vendor_participation = '{1}' THEN adjusted_price
        --PARTICIPATED AND SHARE WITH VENDORS
        WHEN step2.vendor_participation = '{2}' THEN adjusted_final_price
        --PARTICIPATED AND FULL ABSORB        
        WHEN step2.vendor_participation = '{3}' THEN adjusted_final_price
        -- STACKED DISCOUNTS, ONE OF THEM PARTICIPATED ANOTHER ISN'T       
         WHEN step2.vendor_participation = '{1,2}' or step2.vendor_participation = '{2,1}'  THEN   
        core_discounts.perhitungan
        end as publisher_gross_share
        from (

        -- ADJUSTABLE CURRENCY CODE, PRICE, FINAL PRICE
select *, --STEP1
        case 
        when step1.paymentgateway_id not in (1,15) then currency_code
        when step1.paymentgateway_id in (1,15) and localized_currency_code = 'IDR' then localized_currency_code
        when step1.paymentgateway_id in (1,15) and localized_currency_code != 'IDR' then currency_code
        end as adjusted_currency_code,

        case 
        when paymentgateway_id not in (1,15) then price
        when paymentgateway_id in (1,15) and localized_currency_code = 'IDR' then case when step1.currency_code != 'IDR' and step1.price = step1.matrix_usd then step1.matrix_idr else step1.price end -- SALAH HARGA PRICE NYA
        when paymentgateway_id in (1,15) and localized_currency_code != 'IDR' then price
        end as adjusted_price,

        case 
        when paymentgateway_id not in (1,15) then final_price
        when paymentgateway_id in (1,15) and localized_currency_code = 'IDR' then localized_final_price
        when paymentgateway_id in (1,15) and localized_currency_code != 'IDR' then final_price
        end as adjusted_final_price

-- ORDERLINE
from (
                SELECT  
                        -- IDENTIFIER 
                        core_payments.payment_datetime as payment_date
                        ,core_orderlines.id as orderline_id
                        ,ARRAY_AGG(distinct core_orderlinediscounts.id)::INT[] as orderlinediscount_id
                        ,core_paymentgateways.id as paymentgateway_id
                        ,core_paymentgatewayformulas.paymentgateway_id as formulas_paymentgateway_id
                        ,core_vendors.id as vendor_id
                        ,ARRAY_AGG(distinct core_discounts.id)::INT[] as discount_id
                        ,core_revenueshares.id as revenueshare_id -- PEMBEDA WEBSTORE DENGAN PLATFORM LAIN
                        ,core_orders.platform_id as platform_id -- PLATFORM DI REVENUE FORMULA BUKAN DI PAYMENT
                        ,core_paymentgatewaycosts.id as paymentgatewaycosts_id -- MENENTUKAN AGGREEMENT BARU/LAMA
                        ,ARRAY_AGG(distinct core_discounts.vendor_participation)::INT[] AS vendor_participation  --VENDOR IKUT / TIDAK
                        ,core_matrixtiers.USD as matrix_usd
                        ,core_matrixtiers.IDR as matrix_idr
                        ,core_orderlines.localized_currency_code as localized_currency_code
                        ,core_orderlines.localized_final_price as localized_final_price

                        -- KETERANGAN
                        ,core_paymentgateways.name as paymentgateway_name
                        ,core_vendors.name as vendor_name
                        ,core_platforms.name as application
                        ,ARRAY_AGG(distinct core_discounts.name)::CHARACTER VARYING[] as discount_name
                        ,core_orderlines.currency_code as currency_code
                        ,core_orderlines.price as price
                        ,core_orderlines.final_price as final_price
                        ,core_paymentgatewayformulas.min_amount as min_amount
                        ,core_paymentgatewayformulas.max_amount as max_amount
                        ,core_paymentgatewayformulas.percentage_amount as pg_percentage_amount
                        ,core_paymentgatewayformulas.fixed_amount as pg_fixed_amount
                        ,core_paymentgatewayformulas.card_type as card_type
                        ,core_revenueshares.default_percentage_amount as vendor_percentage_amount
                        ,core_revenueshares.default_fixed_amount as vendor_fixed_amount
                        ,core_revenuesformulas.fixed_amount as webstore_fixed_amount
                        ,core_revenuesformulas.percentage_amount webstore_percentage_amount
                
                -- PAYMENTS
                FROM core_orderlines
                join core_payments on core_payments.order_id = core_orderlines.order_id
                left join core_orders on core_orders.id = core_payments.order_id
                left join core_offers on core_offers.id = core_orderlines.offer_id
                left join core_platforms on core_platforms.id = core_orders.platform_id
                LEFT JOIN (
                        -- SINGLE EDITION
                        SELECT core_offers.id AS offer_id, core_brands.id AS brand_id, core_vendors.id AS vendor_id
                        FROM core_offers 
                        JOIN core_offers_items ON core_offers_items.offer_id = core_offers.id
                        JOIN core_items ON core_items.id = core_offers_items.item_id
                        JOIN core_brands ON core_brands.id = core_items.brand_id
                        JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
                        WHERE core_offers.offer_type_id = 1
                        UNION
                        -- SUBSCRIPTION
                        SELECT core_offers.id AS offer_id, core_brands.id AS brand_id, core_vendors.id AS vendor_id
                        FROM core_offers 
                        JOIN core_offers_brands ON core_offers_brands.offer_id = core_offers.id
                        JOIN core_brands ON core_brands.id = core_offers_brands.brand_id
                        JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
                        WHERE core_offers.offer_type_id = 2
                        UNION
                        -- BUNDLE EDITION
                        SELECT core_offers.id AS offer_id, core_brands.id AS brand_id, core_vendors.id AS vendor_id 
                        FROM core_offers 
                        JOIN(
                        SELECT offer_id, MAX(item_id) AS item_id FROM core_offers_items GROUP BY offer_id) core_offers_items 
                        ON core_offers_items.offer_id = core_offers.id
                        JOIN core_items ON core_items.id = core_offers_items.item_id
                        JOIN core_brands ON core_brands.id = core_items.brand_id
                        JOIN core_vendors ON core_vendors.id = core_brands.vendor_id
                        WHERE core_offers.offer_type_id = 3
                ) brand_vendor ON brand_vendor.offer_id = core_orderlines.offer_id
                left join core_vendors on core_vendors.id = brand_vendor.vendor_id

                -- DISCOUNTS
                left join core_orderlinediscounts on core_orderlinediscounts.orderline_id = core_orderlines.id
                left join core_discounts on core_discounts.id = core_orderlinediscounts.discount_id

                -- PAYMENTGATEWAY COST
                left join core_vendors_paymentgatewaycosts on core_vendors_paymentgatewaycosts.vendor_id = core_vendors.id
                and to_char(core_payments.modified, 'YYYY-MM') between to_char(core_vendors_paymentgatewaycosts.valid_from, 'YYYY-MM') 
                and to_char(core_vendors_paymentgatewaycosts.valid_to, 'YYYY-MM')  -- KONDISI MENGAMBIL DATA VALID
                                
                left join core_paymentgatewaycosts on core_paymentgatewaycosts.id = core_vendors_paymentgatewaycosts.paymentgatewaycost_id
                left join core_paymentgateways on core_paymentgateways.id = core_payments.paymentgateway_id

                -- BCA KLIKPAYS
                left join core_paymentbcaklikpays on core_paymentbcaklikpays.payment_id = core_payments.id 
                
                left join core_paymentgatewayformulas on core_paymentgatewayformulas.paymentgateway_id = core_paymentgateways.id
                and core_orderlines.final_price between min_amount and max_amount
--              SEMUA AMBIL FINAL PRICE UNTUK PERHITUNGAN PAYMENTGATEWAY COST MIN DAN MAX
--                         CASE 
--                         WHEN core_discounts.vendor_participation = 1 THEN core_orderlines.price
--                         WHEN core_discounts.vendor_participation = 2 THEN core_orderlines.final_price             
--                         WHEN core_discounts.vendor_participation = 3 THEN core_orderlines.final_price
--                         when core_orderlinediscounts.id is null then core_orderlines.final_price end between min_amount and max_amount
                and coalesce(core_paymentgatewayformulas.card_type::character varying, '0' ) = coalesce (core_paymentbcaklikpays.card_type::character varying,'0')
                left join core_paymentgatewaycosts_formulas on core_paymentgatewaycosts_formulas.paymentgatewayformula_id = core_paymentgatewayformulas.id

                -- REVENUE SHARE
                left join core_vendorrevenueshares on core_vendorrevenueshares.vendor_id = core_vendors.id 
                and to_char(core_payments.modified, 'YYYY-MM') between to_char(core_vendorrevenueshares.valid_from, 'YYYY-MM') 
                and to_char(core_vendorrevenueshares.valid_to, 'YYYY-MM')  -- KONDISI MENGAMBIL DATA VALID
                
                --PERHITUNGAN BUFFET
                left join core_revenueshares on core_revenueshares.id = case when core_offers.offer_type_id = 4 then 9 else core_vendorrevenueshares.revenue_id end 
                
                --TEMPO
                left join core_revenueshares_formulas on core_revenueshares_formulas.revenueshare_id = core_revenueshares.id
                left join core_revenuesformulas on core_revenuesformulas.id = core_revenueshares_formulas.revenueformula_id

                -- ADJUSTED PRICE / FINAL PRICE
                left join(
                select distinct core_matrixtiers.paymentgateway_id as paymentgateway_id, 
                tier_price, 
                (rate_price::json->>'USD')::numeric as USD,
                (rate_price::json->>'IDR')::numeric as IDR
                from core_matrixtiers
                where 1=1
                and valid_to >= '2015-10-31'  -- PARAMETER
                and is_alternate is false ) core_matrixtiers 
                on core_matrixtiers.paymentgateway_id = core_payments.paymentgateway_id
                and core_orderlines.price = core_matrixtiers.tier_price

                
                where 1=1
               and core_payments.payment_period='2015-10'

               --and core_payments.payment_datetime::date between '2015-10-01' and '2015-10-31' -- PARAMETER
               --and core_vendorrevenueshares.valid_to::date >= '2015-10-31' 
--                 and core_payments.is_active is TRUE
--                 and core_payments.payment_status = 20003
--                 and core_orderlines.is_active is true
--                 and core_orderlines.is_free is false 
--                 and core_payments.is_test_payment is false
--                 and core_payments.is_test_payment = false 
                --and core_paymentgateways.id != 3
--                  and core_orderlines.id in (
-- 1755,
-- 1882,
-- 3861,
-- 2635,
-- 2262
--  )
                --and core_orderlines.id in 

               GROUP BY 
               core_payments.payment_datetime,core_orderlines.id, core_orderlines.currency_code,
               core_paymentgateways.id, core_vendors.id, core_revenueshares.id,
               core_orders.platform_id, core_paymentgatewaycosts.id, core_platforms.name,
               core_paymentgatewayformulas.min_amount, core_paymentgatewayformulas.max_amount,
               core_paymentgatewayformulas.percentage_amount, core_paymentgatewayformulas.fixed_amount,
               core_paymentgatewayformulas.card_type, core_revenuesformulas.fixed_amount, core_revenuesformulas.percentage_amount,
               core_paymentgatewayformulas.paymentgateway_id, 
               core_matrixtiers.USD, core_matrixtiers.IDR,core_orderlines.localized_currency_code

                
        ) as step1




                ) as step2
        
        -- PERHITUNGAN STACKED DISCOUNTS
        left join (

   
        select *,  
        case 
        -- 1=1=1
        when discount_rule1 =1 and discount_rule5=1  and discount_rule3=1 and currency_code='USD'  then case when (price - discount1_usd - discount5_usd - discount3_usd) < 0 then 0 else (price - discount1_usd - discount5_usd - discount3_usd) end
        when discount_rule1 =1 and discount_rule5=1  and discount_rule3=1 and currency_code='IDR'  then case when (price - discount1_idr - discount5_idr - discount3_idr) < 0 then 0 else (price - discount1_idr - discount5_idr - discount3_idr) end 
        -- 2=1=1
        when discount_rule1 =2 and discount_rule5=1  and discount_rule3=1 and currency_code='USD'  then case when (price - (price * (discount1_usd/100)) - discount5_usd - discount3_usd) < 0 then 0 else (price - (price * (discount1_usd/100)) - discount5_usd - discount3_usd) end
        when discount_rule1 =2 and discount_rule5=1  and discount_rule3=1 and currency_code='IDR'  then case when (price - (price * (discount1_idr/100)) - discount5_idr - discount3_idr) < 0 then 0 else  (price - (price * (discount1_idr/100)) - discount5_idr - discount3_idr) end 
        -- 2=1=3
        when discount_rule1 =2 and discount_rule5=1  and discount_rule3=3 and currency_code='USD' then discount3_usd
        when discount_rule1 =2 and discount_rule5=1  and discount_rule3=3 and currency_code='IDR' then discount3_idr
        -- 2=2=1
        when discount_rule1 =2 and discount_rule5=2  and discount_rule3=1 and currency_code='USD'  then case when ((price - (price * (discount1_usd/100))) - ((price - (price * (discount1_usd/100))) * (discount5_usd/100)) - discount3_usd) < 0 then 0 else ((price - (price * (discount1_usd/100))) - ((price - (price * (discount1_usd/100))) * (discount5_usd/100)) - discount3_usd) end
        when discount_rule1 =2 and discount_rule5=2  and discount_rule3=1 and currency_code='IDR'  then case when ((price - (price * (discount1_idr/100))) - ((price - (price * (discount1_idr/100))) * (discount5_idr/100)) - discount3_idr) < 0 then 0 else ((price - (price * (discount1_idr/100))) - ((price - (price * (discount1_idr/100))) * (discount5_idr/100)) - discount3_idr) end
        -- 3=1=1
        when discount_rule1 =3 and discount_rule5=1  and discount_rule3=1 and currency_code='USD'  then case when (discount1_usd - discount5_usd - discount3_usd) < 0 then 0 else (discount1_usd - discount5_usd - discount3_usd)  end 
        when discount_rule1 =3 and discount_rule5=1  and discount_rule3=1 and currency_code='IDR'  then case when ( discount1_idr - discount5_idr - discount3_idr) < 0 then 0 else ( discount1_idr - discount5_idr - discount3_idr)  end
        -- 3=2=1
        when discount_rule1 =3 and discount_rule5=2  and discount_rule3=1 and currency_code='USD' then (discount1_usd - ((discount1_usd * (discount5_usd/100)) - discount3_usd))
        when discount_rule1 =3 and discount_rule5=2  and discount_rule3=1 and currency_code='IDR' then (discount1_idr - ((discount1_idr * (discount5_idr/100)) - discount3_idr))
        end as perhitungan

from (
        select 
        core_orderlinediscounts.orderline_id as orderline_id
        ,ARRAY_AGG(core_discounts.vendor_participation)::INT[] AS vendor_participation

        ,case 
        when core_payments.paymentgateway_id not in (1,15) then core_orderlines.currency_code
        when core_payments.paymentgateway_id in (1,15) and localized_currency_code = 'IDR' then localized_currency_code
        when core_payments.paymentgateway_id in (1,15) and localized_currency_code != 'IDR' then core_orderlines.currency_code
        end as currency_code -- INI SEBENERNYA ADJUSTED CURRENCY CODE HANYA PENAMAAN NYA PRICE SAJA

        ,case 
        when core_payments.paymentgateway_id not in (1,15) then price
        when core_payments.paymentgateway_id in (1,15) and localized_currency_code = 'IDR' then 
                case when core_orderlines.currency_code != 'IDR' and core_orderlines.price = core_matrixtiers.matrix_usd 
                then core_matrixtiers.matrix_idr else core_orderlines.price end 
        when core_payments.paymentgateway_id in (1,15) and localized_currency_code != 'IDR' then price
        end as price -- INI SEBENERNYA ADJUSTED PRICE HANYA PENAMAAN NYA PRICE SAJA

        ,max(case when core_discounts.discount_type = 1 then core_discounts.discount_rule else 1 end) as discount_rule1
        ,max(case when core_discounts.discount_type=1 then discount_usd else 0 end) as discount1_usd
        ,max(case when core_discounts.discount_type=1 then discount_idr else 0 end) as discount1_idr
        
        ,max(case when core_discounts.discount_type = 5 then core_discounts.discount_rule else 1 end)as discount_rule5
        ,max(case when core_discounts.discount_type=5 then discount_usd else 0 end) as discount5_usd
        ,max(case when core_discounts.discount_type=5 then discount_idr else 0 end) as discount5_idr

        ,max(case when core_discounts.discount_type = 3 then core_discounts.discount_rule else 1 end) as discount_rule3
        ,max(case when core_discounts.discount_type=3 then discount_usd else 0 end) as discount3_usd
        ,max(case when core_discounts.discount_type=3 then discount_idr else 0 end) as discount3_idr

        from core_orderlines
        join core_payments on core_payments.order_id = core_orderlines.order_id
        left join core_orderlinediscounts on core_orderlines.id = core_orderlinediscounts.orderline_id
        left join core_discounts on core_discounts.id = core_orderlinediscounts.discount_id

        left join(
        select distinct core_matrixtiers.paymentgateway_id as paymentgateway_id, 
        tier_price, 
        (rate_price::json->>'USD')::numeric as matrix_usd,
        (rate_price::json->>'IDR')::numeric as matrix_idr
        from core_matrixtiers
        where 1=1
        and valid_to >= '2015-10-31'  -- PARAMETER
        and is_alternate is false ) core_matrixtiers 
        on core_matrixtiers.paymentgateway_id = core_payments.paymentgateway_id
        and core_orderlines.price = core_matrixtiers.tier_price

        where 1=1
        group by core_orderlinediscounts.orderline_id, 
        core_orderlines.price, core_orderlines.currency_code,
        core_payments.paymentgateway_id,
        localized_currency_code,core_matrixtiers.matrix_usd,
        core_matrixtiers.matrix_idr

        ) as foo 
        where vendor_participation::character varying = '{1,2}' or vendor_participation::character varying = '{2,1}'
        order by discount_rule1,discount_rule5, discount_rule3


        ) core_discounts
        on step2.orderline_id = core_discounts.orderline_id 


                ) as step3
                        ) as step4
