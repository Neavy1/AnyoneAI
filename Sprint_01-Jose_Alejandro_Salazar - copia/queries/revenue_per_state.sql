-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 
SELECT
    oc.customer_state AS "customer_state",
    ROUND(SUM(oop.payment_value), 2) AS "Revenue"  -- Redondeo a 2 decimales
FROM olist_order_payments oop
INNER JOIN olist_orders oo ON oop.order_id = oo.order_id
INNER JOIN olist_customers oc ON oo.customer_id = oc.customer_id
WHERE oo.order_status = 'delivered' 
AND oo.order_delivered_customer_date IS NOT NULL
GROUP BY oc.customer_state
ORDER BY Revenue DESC
LIMIT 10;
