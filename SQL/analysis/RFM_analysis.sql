-- RFM = Recency, Frequency, Monetary

SELECT
    c.customer_unique_id,

    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp)
         FROM orders),
        MAX(o.order_purchase_timestamp)
    ) AS recency,

    COUNT(DISTINCT o.order_id) AS frequency,

    ROUND(SUM(p.payment_value),2) AS monetary

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN payments p
ON o.order_id = p.order_id

WHERE o.order_status = 'delivered'

GROUP BY c.customer_unique_id;

-- HIGHEST SPENDING CUSTOMERS 
SELECT
    c.customer_unique_id,
    ROUND(SUM(p.payment_value),2) AS total_spent

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN payments p
ON o.order_id = p.order_id

GROUP BY c.customer_unique_id

ORDER BY total_spent DESC

LIMIT 10;

-- MOST FREQUEMT CUSTOMER 
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders_count

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id

ORDER BY orders_count DESC

LIMIT 10;

-- AVERAGE CUSTOMER SPEND 
SELECT
    ROUND(AVG(customer_spend),2) AS avg_customer_spend
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS customer_spend

    FROM customers c

    JOIN orders o
    ON c.customer_id = o.customer_id

    JOIN payments p
    ON o.order_id = p.order_id

    GROUP BY c.customer_unique_id
) t;




-- SEGREGATING CUSTOMERS INTO DIFFERENT CATEGORIES 
WITH rfm AS (
SELECT
    c.customer_unique_id,

    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp)
         FROM orders),
        MAX(o.order_purchase_timestamp)
    ) AS recency,

    COUNT(DISTINCT o.order_id) AS frequency,

    ROUND(SUM(p.payment_value),2) AS monetary

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN payments p
ON o.order_id = p.order_id

WHERE o.order_status = 'delivered'

GROUP BY c.customer_unique_id
)

SELECT
    CASE

        WHEN recency <= 90
             AND monetary >= 500
        THEN 'Champions'

        WHEN recency <= 180
             AND monetary >= 200
        THEN 'Loyal Customers'

        WHEN recency <= 365
        THEN 'Potential Loyalists'

        ELSE 'At Risk'

    END AS customer_segment,

    COUNT(*) AS customers

FROM rfm

GROUP BY customer_segment
ORDER BY customers DESC;