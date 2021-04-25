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