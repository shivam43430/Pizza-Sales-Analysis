-- Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS total_orders FROM orders;

-- Calculate the total revenue generated from pizza sales.

SELECT SUM(order_details.quantity * pizzas.price) AS total_revenue
  FROM order_details INNER JOIN pizzas ON
  order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.

SELECT pizza_types.name, pizzas.price
  FROM pizza_types INNER JOIN pizzas
  ON pizza_types.pizza_type_id = pizzas.pizza_type_id
  ORDER BY pizzas.price DESC
  LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT pizzas.size, COUNT(*)  AS OCCURENCE
  FROM pizzas INNER JOIN order_details ON
  order_details.pizza_id = pizzas.pizza_id
  GROUP BY pizzas.size
  ORDER BY OCCURENCE DESC
  LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT  pizzas.pizza_type_id, SUM(order_details.quantity) AS total_num
  FROM order_details INNER JOIN pizzas
  ON order_details.pizza_id = pizzas.pizza_id
  GROUP BY pizzas.pizza_type_id
ORDER BY total_num DESC
  LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pt.category, sum(od.quantity) as total_quant
from ((pizza_types as pt join pizzas as pz on
pt.pizza_type_id = pz.pizza_type_id)
join order_details as od on od.pizza_id = pz.pizza_id)
group by pt.category;

-- Determine the distribution of orders by hour of the day.

select EXTRACT(hour from order_time) as hour_day
, count(order_id) as total_orders
from orders
group by hour_day
order by total_orders desc;

-- find the category-wise distribution of pizzas.

SELECT category, COUNT(*) as total_pizza
from pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select X.*, avg(total) over() as average from
(select O.order_date, sum(od.quantity) as total
from orders O join order_details od on
O.order_id=od.order_id
group by O.order_date) as X;

-- Determine the top 3 most ordered pizza types based on revenue.

select pt.name, sum(od.quantity * pz.price) as revenue
from ((pizza_types as pt join pizzas as pz on
pt.pizza_type_id = pz.pizza_type_id)
join order_details as od on od.pizza_id = pz.pizza_id)
group by pt.name order by revenue desc
limit 3;
