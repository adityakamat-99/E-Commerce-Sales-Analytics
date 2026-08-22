/*Data Integrity Audit (CTEs & Conditional Logic)
In real-world data, discrepancies happen. Write a query to find any order_id where 
the total_amount in the orders table does not perfectly match the 
calculated total from the orderdetails table (sum of quantity * price_per_unit).
Skill Highlighted: Common Table Expressions (CTEs), aggregate math, and quality assurance thinking.*/
with cte as(
select
	order_id,
    sum(quantity*price_per_unit) as total_amount
from orderdetails
group by
	order_id
)
select
	c.order_id
from cte as c
inner join orders as o
on c.order_id = o.order_id
where
	c.total_amount != o.total_amount;
    
    
/*High-Value Customer Identification (Joins & Aggregation)
Write a query to identify the top 5 customers who have generated 
the highest total revenue. The output should include the customer's name, location, and their lifetime spend. 
Skill Highlighted: Basic joins between customers and orders, grouping, and ordering.*/
with cte as(
select
	customer_id,
    sum(total_amount) as lifetime_spend
from orders
group by
	customer_id
)
select
	c1.name as Custommer_name,
    c1.location,
    c.lifetime_spend
from cte as c
inner join customers as c1
on c1.customer_id = c.customer_id
order by
	c.lifetime_spend desc
limit 5;



/*Geographic Category Preferences (Window Functions)
Determine the most popular product category in each distinct location. 
The popularity should be based on the total quantity of items sold.
Skill Highlighted: RANK() or DENSE_RANK() window functions partitioned by location.*/
with cte as(
select
	p.category,
    c.location,
    sum(od.quantity) as items_sold,
    dense_rank() over(partition by c.location order by sum(od.quantity) desc) as Category_location_rank
from orders as o
inner join orderdetails as od
on od.order_id = o.order_id
inner join customers as c
on c.customer_id = o.customer_id
inner join products as p
on p.product_id = od.product_id
group by
	p.category,
    c.location
)
select
	category,
    location,
    items_sold
from cte
where Category_location_rank =1;



/*Month-Over-Month Revenue Growth (Date Functions & Lag)
Calculate the total revenue generated each month and the percentage growth (or decline) compared to the previous month.
Skill Highlighted: Date extraction (grouping by year and month) and the LAG() window function.*/
with cte as(
select
	month(order_date) as Month_no,
    monthname(order_date) as Month,
    sum(total_amount) as monthly_revenue,
    lag(sum(total_amount)) over(order by month(order_date) asc) Last_month_revenue
from orders
group by
	month(order_date),
	monthname(order_date)
order by
	month(order_date) 
)
select
	Month,
    concat(round(ifnull((monthly_revenue - Last_month_revenue)*100/monthly_revenue,0),2),"%")as percent_growth
from cte;



/*Market Basket Analysis (Self-Joins)
Identify which pair of products are most frequently purchased together in the exact same
Skill Highlighted: Self-joining the orderdetails table to find permutations of product_id combinations.*/
with cte as(
select
	od.order_id,
    p.name as product_name
from orderdetails as od
inner join products as p
on od.product_id = p.product_id
),cte2 as(
select
	order_id,
    group_concat(product_name order by product_name asc separator ",") as product_combo
from cte
group by
	order_id
)
select
	product_combo,
    count(order_id) as number_of_orders
from cte2
group by
	product_combo
order by
	number_of_orders desc;
    
/*Average Order Value by Demographic (Grouping)
Calculate the Average Order Value (AOV) broken down by customer gender. 
Also, include the total number of orders placed by each gender to provide scale.
Skill Highlighted: Multi-table joins (customers to orders) and basic statistical aggregation.*/

select
	c.Gender,
    round(avg(total_amount),2) as Average_Spend
from orders as o
inner join customers as c
on c.customer_id = o.customer_id
group by
	c.Gender;
    
/*Customer Retention & Purchasing Behavior (Advanced Date Logic)
Find the average number of days it takes for a customer to place their second order 
after their first one. Exclude customers who have only ever placed a single order.
Skill Highlighted: MIN() dates, advanced CTEs, and date difference calculations.*/

with cte as(
select
	customer_id,
    order_date,
    lead(order_date) over(partition by customer_id order by order_date asc) next_order_date,
    row_number() over(partition by customer_id order by order_date asc) as order_rank
from orders
)
select
	customer_id,
    order_date,
    next_order_date,
    datediff(next_order_date,order_date) as Days_in_between
from cte
where order_rank = 1;
