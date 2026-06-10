-- Find Customer First Purchase Month

SELECT
    customer_unique_id,
    MIN(DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m')) AS cohort_month
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
LIMIT 10;

-- Build Cohort Base Table
WITH customer_cohort AS (
SELECT
    c.customer_unique_id,

    MIN(
        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        )
    ) AS cohort_month

FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id
)

SELECT *
FROM customer_cohort
LIMIT 10;


-- Cohort Retention Analysis
WITH customer_cohort AS (
SELECT
    c.customer_unique_id,

    MIN(
        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        )
    ) AS cohort_month

FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id
)

SELECT

    cc.cohort_month,

    PERIOD_DIFF(
        DATE_FORMAT(o.order_purchase_timestamp,'%Y%m'),
        REPLACE(cc.cohort_month,'-','')
    ) AS months_since_first_purchase,

    COUNT(DISTINCT c.customer_unique_id)
    AS customers

FROM customer_cohort cc

JOIN customers c
ON cc.customer_unique_id = c.customer_unique_id

JOIN orders o
ON c.customer_id = o.customer_id

GROUP BY
    cc.cohort_month,
    months_since_first_purchase

ORDER BY
    cc.cohort_month,
    months_since_first_purchase;