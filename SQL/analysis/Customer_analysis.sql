-- MONTHLY ORDERS TREND

SELECT 
date_format(order_purchase_timestamp, '%Y-%m') as month,
count(*) as total_orders
from orders
group by month
order by month;

-- Top 10 States By Orders

SELECT
    c.customer_state,
    COUNT(*) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 Cities By Orders

SELECT
    c.customer_city,
    COUNT(*) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 10;