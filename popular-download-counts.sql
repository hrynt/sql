SELECT 
	core_useractivities.item_id, 
	count(*) AS download_count
FROM 
	core_useractivities 
WHERE
	core_useractivities.activity_type = 'download'
	AND core_useractivities.download_status = 'success'
	AND core_useractivities.datetime >= current_date - INTERVAL '2 month'
GROUP BY 
	core_useractivities.item_id
