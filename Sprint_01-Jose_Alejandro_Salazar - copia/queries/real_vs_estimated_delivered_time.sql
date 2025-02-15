-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.
SELECT
    printf('%02d', t.month_no) AS "month_no",  -- Formato de dos dígitos
    SUBSTR('--JanFebMarAprMayJunJulAugSepOctNovDec', t.month_no * 3, 3) AS "month",
    ROUND(AVG(CASE WHEN t.year = 2016 THEN t.real_time ELSE NULL END), 10) AS "Year2016_real_time",
    ROUND(AVG(CASE WHEN t.year = 2017 THEN t.real_time ELSE NULL END), 10) AS "Year2017_real_time",
    ROUND(AVG(CASE WHEN t.year = 2018 THEN t.real_time ELSE NULL END), 10) AS "Year2018_real_time",
    ROUND(AVG(CASE WHEN t.year = 2016 THEN t.estimated_time ELSE NULL END), 10) AS "Year2016_estimated_time",
    ROUND(AVG(CASE WHEN t.year = 2017 THEN t.estimated_time ELSE NULL END), 10) AS "Year2017_estimated_time",
    ROUND(AVG(CASE WHEN t.year = 2018 THEN t.estimated_time ELSE NULL END), 10) AS "Year2018_estimated_time"
FROM (
    SELECT
        CAST(STRFTIME('%m', oo.order_purchase_timestamp) AS INTEGER) AS "month_no",
        CAST(STRFTIME('%Y', oo.order_purchase_timestamp) AS INTEGER) AS "year",
        CASE 
            WHEN oo.order_delivered_customer_date IS NOT NULL 
            THEN JULIANDAY(oo.order_delivered_customer_date) - JULIANDAY(oo.order_purchase_timestamp) 
            ELSE NULL 
        END AS "real_time",
        CASE 
            WHEN oo.order_estimated_delivery_date IS NOT NULL 
            THEN JULIANDAY(oo.order_estimated_delivery_date) - JULIANDAY(oo.order_purchase_timestamp) 
            ELSE NULL 
        END AS "estimated_time"
    FROM olist_orders oo
    WHERE oo.order_status = 'delivered' 
    AND oo.order_delivered_customer_date IS NOT NULL
) t
GROUP BY t.month_no
ORDER BY t.month_no;
