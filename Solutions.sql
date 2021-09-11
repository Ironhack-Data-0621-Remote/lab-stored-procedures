USE sakila;
--
-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
-- 
DELIMITER //
CREATE PROCEDURE action_movie (OUT customers CHAR)
BEGIN
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
END;
  // 
DELIMITER ;

call action_movie(@x);
--
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
--
drop procedure if exists action_movie;

DELIMITER //
CREATE PROCEDURE action_movie (in param1 varchar(20), OUT customers CHAR)
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = param1
  group by first_name, last_name, email;
end;
  // 
DELIMITER ;

call action_movie('Children', @x);
call action_movie('New', @x);

select * from category;
--
-- Write a query to check the number of movies released in each movie category.
--
SELECT name, sum(fc.film_id) as movies_released
FROM film_category fc
JOIN category c
ON fc.category_id = c.category_id
GROUP BY name;

--
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
--
drop procedure if exists release_per_category;

DELIMITER //
CREATE PROCEDURE release_per_category (in param1 varchar(20), OUT releases INT)
begin
SELECT * FROM (SELECT name, sum(fc.film_id) as movies_released
FROM film_category fc
JOIN category c
ON fc.category_id = c.category_id
GROUP BY name) as table1
WHERE movies_released > param1;
end;
  // 
DELIMITER ;

call release_per_category(32000, @x);