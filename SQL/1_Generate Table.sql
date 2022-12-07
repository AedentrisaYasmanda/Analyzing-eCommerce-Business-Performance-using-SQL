CREATE TABLE IF NOT EXISTS geolocations (
	geolocation_zip_code_prefix INT,
    	geolocation_lat DOUBLE PRECISION,
    	geolocation_lng DOUBLE PRECISION,
	geolocation_city VARCHAR(50),
	geolocation_state VARCHAR(50)
);
COPY geolocations
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS customers (
	customer_id VARCHAR(50) NOT NULL,
    	customer_unique_id VARCHAR(50),
    	customer_zip_code_prefix INT,
	customer_city VARCHAR(50),
	customer_state VARCHAR(50),
	PRIMARY KEY (customer_id)
);
COPY customers
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\customers_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS orders (
	order_id VARCHAR(50) NOT NULL,
    	customer_id VARCHAR(50),
    	order_status VARCHAR(50),
	order_purchase_timestamp timestamp without time zone,
    	order_approved_at timestamp without time zone,
    	order_delivered_carrier_date timestamp without time zone,
    	order_delivered_customer_date timestamp without time zone,
    	order_estimated_delivery_date timestamp without time zone,
	PRIMARY KEY (order_id)
);
COPY orders
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\orders_dataset.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

CREATE TABLE IF NOT EXISTS products (
    	nums NUMERIC,
	product_id VARCHAR(100) NOT NULL,
    	product_category_name VARCHAR(50),
    	product_name_lenght DOUBLE PRECISION,
	product_description_lenght DOUBLE PRECISION,
	product_photos_qty DOUBLE PRECISION,
	product_weight_g DOUBLE PRECISION,
	product_length_cm DOUBLE PRECISION,
	product_height_cm DOUBLE PRECISION,
	product_width_cm DOUBLE PRECISION,
    	PRIMARY KEY (product_id)
);
COPY products
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\product_dataset.csv'
DELIMITER ','
CSV HEADER;


CREATE TABLE IF NOT EXISTS sellers (
	seller_id VARCHAR(50) NOT NULL,
    	seller_zip_code_prefix INT,
    	seller_city VARCHAR(50),
	seller_state VARCHAR(50),
	PRIMARY KEY (seller_id)
);
COPY sellers
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE IF NOT EXISTS order_payments (
	order_id VARCHAR(50),
    	payment_sequential INT,
    	payment_type VARCHAR(50),
	payment_installments INT,
	payment_value DOUBLE PRECISION
);
COPY order_payments
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE order_payments ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

CREATE TABLE IF NOT EXISTS order_items (
	order_id VARCHAR(50),
    	order_item_id INT,
    	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	shipping_limit_date timestamp without time zone,
	price DOUBLE PRECISION,
	freight_value DOUBLE PRECISION
);
COPY order_items
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE order_items ADD FOREIGN KEY (order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY (product_id) REFERENCES products;
ALTER TABLE order_items ADD FOREIGN KEY (seller_id) REFERENCES sellers;


CREATE TABLE IF NOT EXISTS order_reviews (
	review_id VARCHAR(250),
    	order_id VARCHAR(250),
    	review_score VARCHAR(250),
	review_comment_title VARCHAR(250),
	review_comment_message VARCHAR(250),
	review_creation_date VARCHAR(250),
	review_answer_timestamp timestamp without time zone
);
COPY order_reviews
FROM 'C:\Users\Asus\Documents\Eden Sukses\Mini Project\A\Dataset\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE order_reviews ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);