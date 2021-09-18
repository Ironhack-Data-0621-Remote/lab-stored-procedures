use sakila;

-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
drop procedure if exists customer_action_rentals;

DELIMITER //
create procedure customer_action_rentals()
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
  end //
DELIMITER ;

-- CALL customer_action_rentals();

-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.

drop procedure if exists cmr_category_rentals;

DELIMITER //
create procedure customer_category_rentals(in cat varchar(20))
begin

select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8_unicode_ci = cat
  group by customer_id;
  end //
DELIMITER ;

CALL cmr_category_rentals('Action');


-- Write a query to check the number of movies released in each movie category.

select c.name, COUNT(fc.film_id) AS nbr_released_films
from film_category fc
join category c
using (category_id)
group by c.name
order by 2 desc;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

drop procedure if exists movies_per_category;

DELIMITER //
create procedure movies_per_category(in nbr int)
begin
select * 
from (
select c.name, count(fc.film_id) as number_released_films
from film_category fc
join category c
using (category_id)
group by c.name
order by number_released_films desc) s1
where number_films_released >= nbr;
end //
DELIMITER ;

call movies_per_category(50);


