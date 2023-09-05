INSERT INTO mart.f_customer_retention
SELECT
    COUNT(distinct new_cus.customer_id) AS new_customers_count,
    COUNT(distinct ret_cus.customer_id) AS returning_customers_count,
    COUNT(distinct ref_cus.customer_id) AS refunded_customer_count,
    'weekly' AS period_name,
    date_id ,
    item_id,
    SUM(CASE WHEN new_cus.customer_id IS NOT NULL THEN new_cus.payment_amount ELSE 0 END) AS new_customers_revenue,
    SUM(CASE WHEN ret_cus.customer_id IS NOT NULL THEN ret_cus.payment_amount ELSE 0 END) AS returning_customers_revenue,
    COUNT(ref_cus.customer_id) AS customers_refunded
FROM mart.f_sales fs2 
LEFT JOIN (
    SELECT customer_id, SUM(payment_amount) AS payment_amount
    FROM mart.f_sales
    GROUP BY customer_id
    HAVING COUNT(customer_id) = 1
) AS new_cus ON fs2.customer_id = new_cus.customer_id
LEFT JOIN (
    SELECT customer_id, SUM(payment_amount) AS payment_amount
    FROM mart.f_sales
    GROUP BY customer_id
    HAVING COUNT(customer_id) > 1
) AS ret_cus ON fs2.customer_id = ret_cus.customer_id
LEFT JOIN (
    SELECT customer_id
    FROM mart.f_sales
    WHERE status = 'refunded'
    GROUP BY customer_id
) AS ref_cus ON fs2.customer_id = ref_cus.customer_id
GROUP BY date_id, item_id;