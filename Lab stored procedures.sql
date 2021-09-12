use sakila;

-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
drop procedure if exists cust_action;

delimiter // 
create procedure cust_action(out params1 varchar(50))
begin
select CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email into params1
from rental r
join customer c
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film_category fc
on i.film_id = fc.film_id
where fc.category_id = 1
group by c.customer_id;
end;
// 
delimiter ;

call cust_action(@x);


-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
drop procedure if exists cust_cat;

delimiter // 
create procedure cust_cat(out param1 float, out cust char)
begin
select CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email 
from rental r
join customer c
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film_category fc
on i.film_id = fc.film_id
where fc.category_id collate utf8mb4_general_ci = param1
group by c.customer_id;
end;
// 
delimiter ;

call cust_cat(@1, @x);


-- Write a query to check the number of movies released in each movie category.
SELECT new_name, count(fc.film_id) as nb_film
FROM film_category fc
JOIN category c
ON fc.category_id = c.category_id
GROUP BY new_name;


-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
drop procedure if exists nb_movie;

delimiter //
create procedure nb_movie (in param1 int, out param2 varchar(20), out param3 int)
begin
SELECT new_name, count(fc.film_id) as nb_film
FROM film_category fc
JOIN category c
ON fc.category_id = c.category_id
GROUP BY new_name
having nb_film collate utf8mb4_general_ci > param1;
end
//
delimiter ;

call nb_movie(70, @x, @y)