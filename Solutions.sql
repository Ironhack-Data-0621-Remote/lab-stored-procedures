use sakila;
-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
drop procedure if exists action_movies_rented;
DELIMITER // 
create procedure action_movies_rented()
begin
select distinct(concat(cu.first_name, " ", cu.last_name)) as customer_name, cu.email
from rental r 
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on i.film_id = fc.film_id
join category c on c.category_id = fc.category_id
join customer cu on cu.customer_id = r.customer_id
where c.name = "Action";
end //
DELIMITER ;
call action_movies_rented;

-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
drop procedure if exists category_rented;
DELIMITER //
create procedure category_rented(in param varchar(20))
begin
select distinct(concat(cu.first_name, " ", cu.last_name)) as customer_name, cu.email
from rental r 
join inventory i on i.inventory_id = r.inventory_id
join film_category fc on i.film_id = fc.film_id
join category c on c.category_id = fc.category_id
join customer cu on cu.customer_id = r.customer_id
where c.name = param;
end //
delimiter ;
call category_rented('documentary') ;

-- Write a query to check the number of movies released in each movie category.
select c.name, count(fc.film_id) as nb_films
from film_category fc
join category c 
on fc.category_id = c.category_id
group by c.name;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
drop procedure if exists category_released;
delimiter //
create procedure category_released (in param int)
begin
select c.name, count(fc.film_id) as nb_films
from film_category fc
join category c 
on fc.category_id = c.category_id
group by c.name
having nb_films > param;
end // 
delimiter ; 
call category_released (61); 

