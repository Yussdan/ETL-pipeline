ALTER TABLE mart.f_sales ADD COLUMN IF NOT EXISTS status varchar(256);

DELETE FROM mart.f_sales
WHERE (date_id, item_id, customer_id, city_id, quantity, payment_amount, status) IN (
    SELECT dc.date_id, uol.item_id, uol.customer_id, uol.city_id, uol.quantity, uol.payment_amount, uol.status
    FROM staging.user_order_log uol
    LEFT JOIN mart.d_calendar dc ON uol.date_time::DATE = dc.date_actual
    WHERE uol.date_time::DATE = '{{ds}}'
);

insert into mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount,status)
select dc.date_id, item_id, customer_id, city_id, quantity, CASE WHEN status = 'refunded' THEN payment_amount * -1 ELSE payment_amount END AS payment_amount, status from staging.user_order_log uol
left join mart.d_calendar as dc on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = '{{ds}}';