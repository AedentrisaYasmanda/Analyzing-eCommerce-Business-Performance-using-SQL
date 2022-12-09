-- 1. Average Monthly Active User (MAU) per year.

WITH m_act_us AS
(
    SELECT 
        year, 
        ROUND(AVG(monthly_active_users), 0) AS average_monthly_active_users
    FROM 
    (
        SELECT 
            DATE_PART('month',o.order_purchase_timestamp) AS month,
            DATE_PART('year',o.order_purchase_timestamp) AS year,
            COUNT (DISTINCT c.customer_unique_id) AS monthly_active_users
        FROM orders as o
            JOIN customers as c
            ON c.customer_id = o.customer_id
        GROUP BY 1, 2
    )subq
    GROUP BY 1
    ORDER BY 1 ASC
),

-- 2. Total new customers per year.

total_new_customers AS
(
    SELECT 
        DATE_PART ('year', first_time_order) AS year,
        COUNT (1) AS total_new_customers
    FROM 
    (
        SELECT 
            MIN(o.order_purchase_timestamp) AS first_time_order,
            c.customer_unique_id
        FROM orders AS o
            JOIN customers AS c
            ON c.customer_id = o.customer_id
        GROUP BY 2
    )subq
    GROUP BY 1
    ORDER BY 1 ASC
),

-- 3. The number of customers who make repeat orders per year.

cust_repeat_order AS 
(
    SELECT 
        year, 
        COUNT (DISTINCT repeat_customers) AS amount_of_repeat_customers
    FROM 
    (
        SELECT 
            DATE_PART('year', o.order_purchase_timestamp) AS year,
            c.customer_unique_id AS repeat_customers,
            COUNT(o.order_id) AS overall_order
        FROM orders AS o
            JOIN customers AS c
            ON c.customer_id = o.customer_id
        GROUP BY 1, 2
        HAVING COUNT (o.order_id) > 1
    )subq
    GROUP BY 1
),

-- 4. Average order frequency for each year.

average_order_frequency AS
(
    SELECT
        year,
        ROUND (AVG(transaction_frequency), 2) AS avg_freq_orders
    FROM 
    (
        SELECT
            c.customer_unique_id AS customer,
            DATE_PART('year', o.order_purchase_timestamp) AS year,
            COUNT(1) AS transaction_frequency
        FROM orders AS o
            JOIN customers AS c 
            ON c.customer_id = o.customer_id
        GROUP BY 1, 2
    )subq
    GROUP BY 1
    ORDER BY 1 ASC
)

-- 5. Display all metrics from above in a single table. 
SELECT
    mau.year,
    mau.average_monthly_active_users,
    tnc.total_new_customers,
    cro.amount_of_repeat_customers,
    aof.avg_freq_orders
FROM m_act_us as mau
    JOIN total_new_customers AS tnc
    ON tnc.year = mau.year
    
    JOIN cust_repeat_order AS cro
    ON cro.year = mau.year
    
    JOIN average_order_frequency AS aof
    ON aof.year = mau.year
GROUP BY 1,2,3,4,5;
