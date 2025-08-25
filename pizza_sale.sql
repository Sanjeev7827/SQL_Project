CREATE DATABASE PizzaHut;
USE PizzaHut;

-- Basic:
-- Retrieve the total number of orders placed.
-- Calculate the total revenue generated from pizza sales.
-- Identify the highest-priced pizza.
-- Identify the most common pizza size ordered.
-- List the top 5 most ordered pizza types along with their quantities.


-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
-- Determine the distribution of orders by hour of the day.
-- Join relevant tables to find the category-wise distribution of pizzas.
-- Group the orders by date and calculate the average number of pizzas ordered per day.
-- Determine the top 3 most ordered pizza types based on revenue.

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
-- Analyze the cumulative revenue generated over time.
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

-- Project start from here
-- Retrieve the total number of orders placed.
SELECT 
    COUNT(*) AS total_orders
FROM
    orders;


-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * o.quantity), 2) AS total_revenue
FROM
    pizzas AS p
        INNER JOIN
    order_details AS o ON p.pizza_id = o.pizza_id;

-- Identify the highest-priced pizza.

SELECT 
    pizza_type_id, price
FROM
    pizzas
ORDER BY price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(*) AS most_common
FROM
    pizzas AS p
        INNER JOIN
    order_details AS o USING (pizza_id)
GROUP BY 1
ORDER BY 2 DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pn.name, COUNT(*) AS most_common_type
FROM
    pizzas AS p
        INNER JOIN
    order_details AS o USING (pizza_id)
        INNER JOIN
    pizza_types AS pn USING (pizza_type_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    category, COUNT(*) AS total_quantity
FROM
    pizzas AS p
        INNER JOIN
    order_details AS o USING (pizza_id)
        INNER JOIN
    pizza_types USING (pizza_type_id)
GROUP BY 1
ORDER BY 2 DESC;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS hour_of_day, COUNT(*) AS order_count
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(*) AS category_distribution
FROM
    pizza_types
GROUP BY 1
ORDER BY 2 DESC;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
with cte AS(
SELECT o.date,sum(od.quantity) AS quantity FROM orders AS o INNER JOIN order_details AS od
USING (order_id)
GROUP BY 1)
SELECT AVG(quantity) AS avg_order_per_day
FROM cte;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT name,ROUND(SUM(price*quantity),2) AS revenue FROM
pizzas AS p
INNER JOIN
order_details AS o ON p.pizza_id = o.pizza_id INNER JOIN pizza_types AS pt
ON p.pizza_type_id=pt.pizza_type_id
GROUP BY name
ORDER BY 2 DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    category,
    ROUND(SUM(price * quantity) / (SELECT 
                    ROUND(SUM(p.price * o.quantity), 2) AS total_revenue
                FROM
                    pizzas AS p
                        INNER JOIN
                    order_details AS o ON p.pizza_id = o.pizza_id),
            2) * 100 AS percentage_of_tota_revenue
FROM
    pizzas AS p
        INNER JOIN
    order_details AS o ON p.pizza_id = o.pizza_id
        INNER JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY category
ORDER BY 2 DESC;

-- Analyze the cumulative revenue generated over time.
with cte AS(
SELECT 
    ot.date AS date, ROUND(SUM(p.price * o.quantity), 2) AS revenue
FROM
    pizzas AS p
        INNER JOIN
    order_details AS o ON p.pizza_id = o.pizza_id
        INNER JOIN
    orders AS ot ON o.order_id = ot.order_id
GROUP BY 1)

select date, sum(revenue) OVER(order by date) AS cum_revenue
from cte;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT pt.category,pt.name,ROUND(SUM(price*quantity),2) AS revenue FROM
pizzas AS p
INNER JOIN
order_details AS o ON p.pizza_id = o.pizza_id INNER JOIN pizza_types AS pt
ON p.pizza_type_id=pt.pizza_type_id
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 3;








