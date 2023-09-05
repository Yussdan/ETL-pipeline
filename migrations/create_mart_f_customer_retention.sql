CREATE TABLE IF NOT EXISTS mart.f_customer_retention (
    new_customers_count INT4,
    returning_customers_count INT4,
    refunded_customer_count INT4,
    period_name varchar(120),
    period_id INT4,
    item_id INT4,
    new_customers_revenue INT4,
    returning_customers_revenue INT4,
    customers_refunded INT4
);