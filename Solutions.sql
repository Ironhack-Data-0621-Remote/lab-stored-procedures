use sakila;
-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
drop procedure if exists action_movies;

DELIMITER //
create procedure action_movies ()
begin
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;
end
//
delimiter ;

--
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
drop procedure if exists action_movies;

DELIMITER //
create procedure action_movies ()
begin
select category.name 
from ( select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email
) sub1;
end
//
delimiter ;


--
-- Write a query to check the number of movies released in each movie category.
select c.name, count(fc.film_id)
from category c
join film_category fc
on c.category_id = fc.category_id
group by c.name;

--
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
drop procedure if exists movies_category;

DELIMITER //
create procedure movies_categories ()
begin


select c.name, count(fc.film_id) as num_film
from category c
join film_category fc
on c.category_id = fc.category_id
where num_film > 50
group by c.name
;

end
//
delimiter ;