  USE sakila; 
  
  -- 1. Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
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
  
  
  -- 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such 
  -- manner that it can take a string argument for the category name and return the results for all 
  -- customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
  
  drop procedure if exists genre_guide;

  delimiter // 
  CREATE PROCEDURE genre_guide(in param1 varchar(9), OUT customers CHAR)
  BEGIN 
    select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = param1
  group by first_name, last_name, email;
  END; 
  // 
  DELIMITER ; 
  
CALL genre_guide('Action', @x);
-- Action 510 rows 
CALL genre_guide('Children', @x);
-- Children 482 rows
CALL genre_guide('Animation', @x);
-- Animation 500 rows 

-- 3. Write a query to check the number of movies released in each movie category. 


SELECT name, sum(fc.film_id) as movies
FROM film_category fc
JOIN category c
ON fc.category_id = c.category_id
GROUP BY name;

-- 4. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

drop procedure if exists film_category;

DELIMITER //
CREATE PROCEDURE film_category (in param1 varchar(20), OUT releases INT)
BEGIN
SELECT * FROM (SELECT name as category, SUM(fc.film_id) as movies
FROM film_category fc
JOIN category c
ON fc.category_id = c.category_id
GROUP BY name) as movie_table
WHERE movies > param1;
END;
  // 
DELIMITER ;

call film_category(35000, @x);
-- 35000 => 3 rows 
