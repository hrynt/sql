select distinct vendor_id,publisher_calculation.paymentgatewaycosts_id, revenueshare_id, vendor_percentage_amount, vendor_fixed_amount from publisher_calculation
left join (
select distinct id, share_rate, 
case when is_paymentgateway_include = FALSE then 2  
when is_paymentgateway_include = TRUE then 1 end as paymentgatewaycosts_id 
from core_vendors) core
on core.id = publisher_calculation.vendor_id
where publisher_calculation.paymentgatewaycosts_id != core.paymentgatewaycosts_id
or publisher_calculation.vendor_percentage_amount != core.share_rate