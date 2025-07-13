--Question:1 Who is the senior most employee based on job tittle?
select * from employee
order by levels desc
limit 1

--Question:2 Which countries have most invoices?
select count(*) as c , billing_country
from invoice
group by billing_country
order by c desc

--Question:3 What are top 3 values of total invoices?
select total from invoice
order by total desc
limit 3

--Question:4 Which city has the best customers? 
--We would like to throw a promotional Music Festival in the city we made the most money.
--Write a query that returns a city  that has a highest sum of invoice totals . 
--Return both the city name and sum of sum of all invoice totals.
select sum(total) as invoice_totals ,billing_city
from invoice
group by billing_city
order by invoice_totals desc

--Question:5 Who is the best customer? The customer who has spent the most money will be declared as the best customer.
--Write a query that returns the best customer.
select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total)as total
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1
 