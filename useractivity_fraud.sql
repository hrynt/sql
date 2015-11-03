SELECT 
*,
CASE WHEN page_number > '{5000}' THEN 'page > 5000' WHEN page_number <= '{0}' THEN 'page <= 0' WHEN duration > 3600 THEN 'duration > 3600 second' END AS fraud_type
FROM core_useractivities 
WHERE activity_type = 'pageview' AND (page_number > '{5000}' OR page_number <= '{0}' OR duration > 3600)