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