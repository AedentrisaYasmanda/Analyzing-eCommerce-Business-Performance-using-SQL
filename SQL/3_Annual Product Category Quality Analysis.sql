-- 1. Make a table that contains total company revenue/revenue information for each year
CREATE TABLE revenue_each_year AS

SELECT 
    DATE_PART('year', o.order_purchase_timestamp) AS year,
	SUM(ori.price + ori.freight_value) AS income
FROM orders AS o
    JOIN order_items AS ori 
    ON ori.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY year ASC;

-- 2. Create a table that contains information on the total number of canceled orders for each year
CREATE TABLE canceled_orders_each_year AS
SELECT 
    DATE_PART('year', order_purchase_timestamp) AS year,
    COUNT(order_id) AS orders_canceled
FROM orders
WHERE order_status = 'canceled'
GROUP BY 1
ORDER BY year ASC;

-- 3. Create a table containing the names of the product categories that provide the highest total revenue for each year 
CREATE TABLE highest_product_category_by_revenue_each_year AS
SELECT
    year,
    highest_product_category_by_revenue,
    revenue_each_product_category
FROM 
(
   SELECT
		DATE_PART('year', o.order_purchase_timestamp) AS year,
	 	p.product_category_name AS highest_product_category_by_revenue,
	 	SUM(price + freight_value) AS revenue_each_product_category,
	 	RANK() OVER(PARTITION BY DATE_PART('year', o.order_purchase_timestamp)
	                    ORDER BY SUM(ori.price + ori.freight_value) DESC
					) AS levels
    FROM orders o 
        JOIN order_items AS ori 
        ON ori.order_id = o.order_id

        JOIN products AS p 
        ON p.product_id = ori.product_id

     WHERE order_status = 'delivered'
     GROUP BY 1, 2
) AS subq
WHERE levels = 1;            


-- 4. Create a table containing the product category names that have the highest number of canceled orders for each year 
CREATE TABLE highest_canceled_product_category_each_year AS
SELECT
    year,
    highest_canceled_product_per_category,
    amount_of_canceled_product_per_category
FROM 
(
   SELECT
		DATE_PART('year', o.order_purchase_timestamp) AS year,
	 	p.product_category_name AS highest_canceled_product_per_category,
	 	COUNT(o.order_id) AS amount_of_canceled_product_per_category,
	 	RANK() OVER(PARTITION BY DATE_PART('year', o.order_purchase_timestamp)
                        ORDER BY COUNT(o.order_id) DESC
					) AS levels
    FROM orders o 
        JOIN order_items AS ori 
        ON ori.order_id = o.order_id

        JOIN products AS p 
        ON p.product_id = ori.product_id

     WHERE order_status = 'canceled'
     GROUP BY 1, 2
) AS subq
WHERE levels = 1;


-- 5. Combine the information that has been obtained into a single table view 
SELECT
    rey.year,
    hpcbrey.highest_product_category_by_revenue,
    hpcbrey.revenue_each_product_category,
    rey.income AS overall_revenue,
    hcpcey.highest_canceled_product_per_category,
    hcpcey.amount_of_canceled_product_per_category,
    coey.orders_canceled AS overall_orders_canceled
    
FROM revenue_each_year AS rey
    JOIN canceled_orders_each_year AS coey 
    ON coey.year = rey.year
    JOIN highest_product_category_by_revenue_each_year AS hpcbrey 
    ON hpcbrey.year = rey.year
    JOIN highest_canceled_product_category_each_year AS hcpcey 
    ON hcpcey.year = rey.year;