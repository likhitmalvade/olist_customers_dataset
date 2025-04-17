--What is the total revenue generated over time?

SELECT SUM(price) as total_revenue 
FROM order_items


--Which payment type is most commonly used?
SELECT payment_type, count(*) as payment_type_count 
FROM order_payments
GROUP BY 1
ORDER BY 2 DESC;

--What are the monthly sales trends?

SELECT
EXTRACT (YEAR FROM order_purchase_timestamp) as year,
EXTRACT (MONTH FROM order_purchase_timestamp) as month,
count(order_id) AS sales_qty
FROM orders
GROUP BY 1,2
ORDER BY 2
;



--How many unique customers placed orders?

SELECT COUNT(DISTINCT(customer_id)) 
FROM orders

--Which states or cities have the most customers?

SELECT c.customer_city, c.customer_state, COUNT(o.*) FROM
customer c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5
;


--What are the peak order months or days of the week?
SELECT 
order_purchase_timestamp AS total_order,
COUNT(*)
FROM orders
GROUP BY total_order
ORDER BY COUNT(*) DESC
LIMIT 10
;

--Which product categories generate the most revenue?

SELECT pt.product_category_name_english, COUNT(oi.*) AS total_orders
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
JOIN product_translation pt ON pt.product_category_name = p.product_category_name
GROUP BY pt.product_category_name_english
ORDER BY total_orders DESC
LIMIT 5
;


--How accurate is the estimated delivery date vs actual delivery date?

SELECT
EXTRACT (YEAR FROM order_purchase_timestamp) AS year,
EXTRACT (MONTH FROM order_purchase_timestamp) AS month,
AVG(order_estimated_delivery_date - order_delivered_customer_date) AS delivery_diff_days
FROM orders
WHERE order_status = 'delivered'
GROUP BY 2, 1
ORDER BY 1, 2
;

--What is the number of products per seller?
SELECT s.seller_id, COUNT(product_id) AS products_per_seller
FROM sellers s
JOIN order_items p
ON p.seller_id = s.seller_id
GROUP BY 1
;
--Which sellers have the highest average review score?

SELECT s.seller_id, ROUND(AVG(orv.review_score), 2) AS avg_score
FROM sellers s
JOIN order_items oi ON oi.seller_id = s.seller_id
JOIN orders o ON o.order_id = oi.order_id
JOIN order_reviews orv  ON orv.order_id = o.order_id
GROUP BY 1
ORDER BY 2 DESC
;

--What’s the average delivery time by state or region?
SELECT c.customer_state, c.customer_city, 
AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_time
FROM customer c
JOIN orders o ON o.customer_id = c.customer_id 
WHERE order_status = 'delivered'
GROUP BY 1,2
ORDER BY 1,2,3
;


--What is the average review score by product category?

SELECT p.product_category_name, ROUND(AVG(orv.review_score),2) AS avg_review_score 
FROM order_items oi
JOIN
 	order_reviews orv ON orv.order_id = oi.order_id
JOIN 
	products p ON p.product_id = oi.product_id
GROUP BY 1
ORDER BY 1,2


--How many orders have 1-star vs 5-star reviews?

SELECT review_score,  COUNT(*) FROM order_reviews
WHERE review_score = 1
OR review_score = 5
GROUP BY 1
;

--How does delivery time affect review scores?
SELECT orv.review_score, AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_time 
FROM orders o 
JOIN order_reviews orv ON orv.order_id = o.order_id
GROUP BY 1
ORDER BY 1 DESC
;


