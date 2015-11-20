select "vendor currency", publisher, 
sum("Apple iTunes") "Apple iTunes", sum("Google In-App Billing") "Google In-App Billing", sum("ATM Transfer Web"), sum("ATM Transfer Android"),
sum("CIMB Clicks Web"), sum("CIMB Clicks Android"), sum("Credit Card Android"), sum("Credit Card Web"), sum("Elevenia"), sum("Free Purchase Web"), sum("Klikpay BCA Web"), sum("Mandiri Clickpay Android"), sum("Mandiri Clickpay Web"), sum("Mandiri E-Cash Android"), sum("Mandiri E-Cash Web"), sum("Paypal Android"), sum("Paypal Web"), sum("SCOOP Point Android"), sum("SCOOP Point iOS"), sum("SCOOP Point Web")
from (
select 
"vendor currency"
,publisher
,sum(case when "payment gateway"= 'Apple iTunes' then 1 end) as "Apple iTunes"
,sum(case when "payment gateway"= 'Google In-App Billing' then 1 end) as "Google In-App Billing"
,sum(case when "payment gateway"= 'ATM Transfer' and platform = 'Web' then 1 end) as "ATM Transfer Web"
,sum(case when "payment gateway"= 'ATM Transfer' and platform = 'Android' then 1 end) as "ATM Transfer Android"
,sum(case when "payment gateway"= 'CIMB Clicks' and platform = 'Web' then 1 end) as "CIMB Clicks Web"
,sum(case when "payment gateway"= 'CIMB Clicks' and platform = 'Android' then 1 end) as "CIMB Clicks Android"
,sum(case when "payment gateway"= 'Credit Card' and platform = 'Android' then 1 end) as "Credit Card Android"
,sum(case when "payment gateway"='Credit Card' and platform = 'Web' then 1 end) as "Credit Card Web"
,sum(case when "payment gateway"='Elevenia' then 1 end) as "Elevenia"
,sum(case when "payment gateway"='Free Purchase' and platform = 'Web' then 1 end) as "Free Purchase Web"
,sum(case when "payment gateway"='Klikpay BCA' and platform = 'Web' then 1 end) as "Klikpay BCA Web"
,sum(case when "payment gateway"='Mandiri Clickpay' and platform = 'Android' then 1 end) as "Mandiri Clickpay Android"
,sum(case when "payment gateway"='Mandiri Clickpay' and platform = 'Web' then 1 end) as "Mandiri Clickpay Web"
,sum(case when "payment gateway"='Mandiri E-Cash' and platform = 'Android' then 1 end) as "Mandiri E-Cash Android"
,sum(case when "payment gateway"='Mandiri E-Cash' and platform = 'Web' then 1 end) as "Mandiri E-Cash Web"
,sum(case when "payment gateway"='Paypal' and platform = 'Android' then 1 end) as "Paypal Android"
,sum(case when "payment gateway"='Paypal' and platform = 'Web' then 1 end) as "Paypal Web"
,sum(case when "payment gateway"='SCOOP Point' and platform = 'Android' then 1 end) as "SCOOP Point Android"
,sum(case when "payment gateway"='SCOOP Point' and platform = 'iOS' then 1 end) as "SCOOP Point iOS"
,sum(case when "payment gateway"='SCOOP Point' and platform = 'Web' then 1 end) as "SCOOP Point Web"

from finance_report 
group by "vendor currency",publisher,"payment gateway"
order by publisher
) as foo group by 1, 2