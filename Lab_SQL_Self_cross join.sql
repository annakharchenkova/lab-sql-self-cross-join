/*
Lab | SQL Self and cross join

In this lab, you will be using the Sakila database of movie rentals.

Instructions

1. Get all pairs of actors that worked together.
2. Get all pairs of customers that have rented the same film more than 3 times.
3. Get all possible pairs of actors and films.*/

use sakila;
#1. Get all pairs of actors that worked together - self join - film_actor

select fa1.film_id, concat(a1.first_name, ' ', a1.last_name), concat(a2.first_name, ' ', a2.last_name) from actor a1
join film_actor fa1
on fa1.actor_id = a1.actor_id
join film_actor fa2 
on fa1.film_id = fa2.film_id and fa1.actor_id <> fa2.actor_id
join actor as a2 
on a2.actor_id = fa2.actor_id;


#2. Get all pairs of customers that have rented the same film more than 3 times
#when they rent same movie in between them.
#i.e. 1 time - movie No 1, 2nd time - movie 2, 3rd time - movie 3


#creating temporary table 

create table sakila.rent_inventory 
select r.rental_id, r.inventory_id, r.customer_id , i.film_id from rental r
join inventory as i on i.inventory_id = r.inventory_id;

select * from sakila.rent_inventory;

SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', '')); 
#step 1 (just to check)
select t1.customer_id, t2.customer_id, i.film_id from rent_inventory as t1
join rental_inventory t2 on t1.film_id = t2.film_id and t1.customer_id <> t2.customer_id
join inventory i on i.inventory_id = t1.inventory_id
order by t1.customer_id, t2.customer_id
;

#step 2
select t1.customer_id, t2.customer_id, count(i.film_id) from rent_inventory as t1
join rental_inventory t2 on t1.film_id = t2.film_id and t1.customer_id <> t2.customer_id
join inventory i on i.inventory_id = t1.inventory_id
group by t1.customer_id, t2.customer_id
having count(i.film_id)>3
order by t1.customer_id, t2.customer_id
;

#3. Get all possible pairs of actors and films.

select * from 
(select concat(first_name, ' ',last_name) from actor) a
cross join 
(select title from film) f;

