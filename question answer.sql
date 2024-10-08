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