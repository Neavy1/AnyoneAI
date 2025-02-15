-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
SELECT
    printf('%02d', oo.month_no) AS "month_no",  -- Formato de dos dígitos
    SUBSTR('--JanFebMarAprMayJunJulAugSepOctNovDec', oo.month_no * 3, 3) AS "month",
    ROUND(SUM(CASE WHEN oo.year = '2016' THEN oop.payment_value ELSE 0 END), 10) AS "Year2016",
    ROUND(SUM(CASE WHEN oo.year = '2017' THEN oop.payment_value ELSE 0 END), 10) AS "Year2017",
    ROUND(SUM(CASE WHEN oo.year = '2018' THEN oop.payment_value ELSE 0 END), 10) AS "Year2018"
FROM (
    SELECT
        order_id,
        CAST(STRFTIME('%m', order_delivered_customer_date) AS INTEGER) AS "month_no",
        STRFTIME('%Y', order_delivered_customer_date) AS "year"
    FROM olist_orders
    WHERE order_status = 'delivered' 
    AND order_delivered_customer_date IS NOT NULL
) AS oo
INNER JOIN (
    SELECT
        order_id,
        MIN(payment_value) AS payment_value
    FROM olist_order_payments
    GROUP BY order_id
) AS oop ON oo.order_id = oop.order_id
GROUP BY oo.month_no
ORDER BY oo.month_no;