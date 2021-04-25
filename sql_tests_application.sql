/*
Question 1: Select everything from the 'customers' table
*/

select *
from hiring.customers;


/* 
Question 2: How many customers were created on the first day the application was launched?

Answer: 5
*/

select created_at as date, count(id) as number_created
from hiring.customers
group by created_at
limit 1;


/*
Question 3: Where do most of the customers sign up from?
Answer: Leeds
*/

select cities.name as city, count(customers.id) as customer_number
from hiring.cities as cities, hiring.customers as customers
where cities.id = customers.city_id
group by city
order by customer_number desc;

-- OR

select cities.name as city, count(customers.id) as customer_number
from hiring.cities as cities
left join hiring.customers as customers on cities.id = customers.city_id
group by city
order by customer_number desc;

/*
Question 4: What city has generated the most revenue for the company? (note: the SQL query can contain the revenue for all cities)
Answer: Sheffield
*/
select cities.name as city, round(sum(orders.value),2) as total_revenue
from hiring.cities as cities
left join hiring.customers as customers on cities.id = customers.city_id
left join hiring.orders as orders on customers.id = orders.customer_id
group by city
order by total_revenue desc;

-- OR
select cities.name as city, round(sum(orders.value),2) as total_revenue
from hiring.cities as cities, hiring.customers as customers, hiring.orders as orders
where cities.id = customers.city_id and customers.id = orders.customer_id
group by city
order by total_revenue desc;



/*
Question 5: Return a list of customers with how much they have spent at the company.
The list should be sorted in descending order (with the customer who
spent the most the first result, and the customer who spent the least the
last result). We want to see three columns (customer_id, revenue, their
position in the list).
*/
select customers.id as customer_id, round(sum(orders.value),2) as revenue, rank() over (order by sum(orders.value) desc) position
from hiring.customers as customers
left join hiring.orders as orders on customers.id = orders.customer_id
group by customer_id
order by position;

-- OR

select customers.id as customer_id, round(sum(orders.value),2) as revenue, rank() over (order by sum(orders.value) desc) position
from hiring.customers as customers, hiring.orders as orders
where customers.id = orders.customer_id
group by customer_id
order by position;


/*
Question 6: What is the most popular product (by number of purchases)?
*/

select product_title, count(id) as sales
from hiring.orders
group by product_title
order by sales desc limit 1;


/*
Question 7: What is the average price of each product?
*/

select product_title, round(avg(value),2) as average_price
from hiring.orders
group by product_title
order by average_price desc;



/*
Question 8: Only considering customers who have made multiple purchases, what is
the average time between orders in days?

Answer: 6.39 days ?
*/

-- get average delay for all customers who have ordered more than once
select round(avg(delay_days),2) as overall_delay_average
from(
    -- select customers and their average delay between orders (absolute number in days)
    select customer_id, round(abs(avg(date_diff(created_at, previous, day))),2) as delay_days
    from (
        -- select orders's customer id, date ordered and then previous order by same customer
        select customer_id, created_at,  lag(created_at, 1) over (order by customer_id asc) as previous, 
        from hiring.orders
        -- where customers have placed more than order
        where customer_id in (
            select customer_id
            from hiring.orders as orders
            group by customer_id
            having count(customer_id) > 1 )
        order by customer_id, created_at asc, previous asc )
    group by customer_id
    );

select round(avg(delay_days),2) as overall_delay_average
from(
    -- select customers and their average delay between orders (absolute number in days)
    select customer_id, round(abs(avg(date_diff(created_at, previous, day))),2) as delay_days
    from (
        -- select order's customer id, date ordered and then previous order by same customer
        select customer_id, created_at,  lag(created_at, 1) over (order by customer_id asc) as previous, 
        from hiring.orders
        -- where customers have placed more than 1 order
        having count(customer_id) > 1 )
        order by customer_id, created_at asc, previous asc )
    group by customer_id
    );	
	

/*
Question 9: Select all the customers who have the pattern “an” in their first name (e.g.
Jane) OR the pattern “is” in their first name (e.g. Elise) AND their email ends
in “.com” (e.g. myemail@google.com).
*/
select *
from hiring.customers
where (first_name like '%an%' or first_name like '%is') and email like '%.com';
