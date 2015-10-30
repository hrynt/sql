﻿CREATE TABLE s_sales (
	order_id INT NOT NULL,
	orderline_id INT NOT NULL,
	payment_id INT NOT NULL,
	date_key INT NOT NULL,
	time_key INT NOT NULL,
	settlement_period_key INT NOT NULL,
	user_id INT NOT NULL,
	offer_id INT NOT NULL,
	paymentgateway_id INT NOT NULL,
	city CHARACTER VARYING NOT NULL,
	country CHARACTER VARYING NOT NULL,
	client_id INT NOT NULL,
	partner_id INT NOT NULL,
	adjusted_currency_code INT NOT NULL,
	discount_group_key INT NOT NULL,
	category_group_key INT NOT NULL,
	quantity INT NOT NULL DEFAULT 1,
	adjusted_currency_gross_sales NUMERIC NOT NULL,
	adjusted_currency_net_sales NUMERIC NOT NULL,
	adjusted_publisher_share NUMERIC NOT NULL,
	adjusted_paymentgateway_cost NUMERIC NOT NULL,
	adjusted_partner_share NUMERIC NOT NULL,
	adjusted_gross_profit NUMERIC NOT NULL,
	to_usd_rate NUMERIC NOT NULL,
	to_idr_rate NUMERIC NOT NULL,
);

CREATE TABLE f_sales (
	order_id INT NOT NULL,
	orderline_id INT NOT NULL,
	payment_id INT NOT NULL,
	date_key INT NOT NULL,
	time_key INT NOT NULL,
	settlement_period_key INT NOT NULL,
	user_key INT NOT NULL,
	offer_key INT NOT NULL,
	paymentgateway_key INT NOT NULL,
	location_key INT NOT NULL,
	client_key INT NOT NULL,
	partner_key INT NOT NULL,
	adjusted_currency_key INT NOT NULL,
	discount_group_key INT NOT NULL,
	category_group_key INT NOT NULL,
	quantity INT NOT NULL DEFAULT 1,
	adjusted_currency_gross_sales NUMERIC NOT NULL,
	adjusted_currency_net_sales NUMERIC NOT NULL,
	adjusted_currency_discount NUMERIC NOT NULL,
	adjusted_publisher_share NUMERIC NOT NULL,
	adjusted_paymentgateway_cost NUMERIC NOT NULL,
	adjusted_partner_share NUMERIC NOT NULL,
	adjusted_gross_profit NUMERIC NOT NULL,
	usd_gross_sales NUMERIC NOT NULL,
	usd_net_sales NUMERIC NOT NULL,
	usd_discount NUMERIC NOT NULL,
	usd_publisher_share NUMERIC NOT NULL,
	usd_paymentgateway_cost NUMERIC NOT NULL,
	usd_partner_share NUMERIC NOT NULL,
	usd_gross_profit NUMERIC NOT NULL,
	idr_gross_sales NUMERIC NOT NULL,
	idr_net_sales NUMERIC NOT NULL,
	idr_discount NUMERIC NOT NULL,
	idr_publisher_share NUMERIC NOT NULL,
	idr_paymentgateway_cost NUMERIC NOT NULL,
	idr_partner_share NUMERIC NOT NULL,
	idr_gross_profit NUMERIC NOT NULL
);

CREATE TABLE f_publisher_share (
	order_id INT NOT NULL,
	orderline_id INT NOT NULL,
	payment_id INT NOT NULL,
	date_key INT NOT NULL,
	time_key INT NOT NULL,
	user_key INT NOT NULL,
	offer_key INT NOT NULL,
	paymentgateway_key INT NOT NULL,
	location_key INT NOT NULL,
	client_key INT NOT NULL,
	partner_key INT NOT NULL,
	adjusted_currency_key INT NOT NULL,
	discount_group_key INT NOT NULL,
	category_group_key INT NOT NULL,
	quantity INT NOT NULL DEFAULT 1,
	adjusted_currency_gross_sales NUMERIC NOT NULL,
	adjusted_currency_net_sales NUMERIC NOT NULL,
	adjusted_currency_discount NUMERIC NOT NULL,
	adjusted_publisher_share NUMERIC NOT NULL,
	adjusted_paymentgateway_cost NUMERIC NOT NULL,
	adjusted_partner_share NUMERIC NOT NULL,
	adjusted_gross_profit NUMERIC NOT NULL,
	usd_gross_sales NUMERIC NOT NULL,
	usd_net_sales NUMERIC NOT NULL,
	usd_discount NUMERIC NOT NULL,
	usd_publisher_share NUMERIC NOT NULL,
	usd_paymentgateway_cost NUMERIC NOT NULL,
	usd_partner_share NUMERIC NOT NULL,
	usd_gross_profit NUMERIC NOT NULL,
	idr_gross_sales NUMERIC NOT NULL,
	idr_net_sales NUMERIC NOT NULL,
	idr_discount NUMERIC NOT NULL,
	idr_publisher_share NUMERIC NOT NULL,
	idr_paymentgateway_cost NUMERIC NOT NULL,
	idr_partner_share NUMERIC NOT NULL,
	idr_gross_profit NUMERIC NOT NULL
)