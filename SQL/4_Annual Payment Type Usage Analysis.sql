-- 1. Displays the total usage of each type of payment at all time, sorted from the favorite

SELECT
    payment_type,
    COUNT(order_id) AS usage_per_payment_type
FROM order_payments
GROUP BY 1
ORDER BY 2 DESC;



-- 2. Displays detailed information on the amount of usage for each type of payment for each year
SELECT
	payment_type,
	SUM(CASE WHEN year = 2016 
        THEN usage_per_payment_type ELSE 0 END) AS "year_2016",
	SUM(CASE WHEN year = 2017 
        THEN usage_per_payment_type ELSE 0 END) AS "year_2017",
	SUM(CASE WHEN year = 2018 
        THEN usage_per_payment_type ELSE 0 END) AS "year_2018",
	SUM(usage_per_payment_type) AS amount_of_usage_per_payment_type
FROM 
(
    SELECT
	  	DATE_PART('year', order_purchase_timestamp) AS year,
	 	payment_type,
	 	COUNT(payment_type) AS usage_per_payment_type
	 FROM orders AS o
	    JOIN order_payments AS op 
        ON op.order_id = o.order_id
	 GROUP BY 1, 2
) AS subq

GROUP BY 1
ORDER BY 2 ASC;