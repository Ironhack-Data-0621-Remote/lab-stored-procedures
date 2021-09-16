USE sakila;
-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
drop procedure if exists customer_for_action;
DELIMITER //
create procedure customer_for_action ()
begin
  SELECT concat(upper(substr(first_name,1,1)), lower(substr(first_name,2)), ' ', last_name) AS customer_name, email
  FROM customer c
  JOIN rental r 
  ON c.customer_id = r.customer_id
  JOIN inventory i
  ON r.inventory_id = i.inventory_id
  JOIN film_category fc
  ON i.film_id = fc.film_id
  JOIN category ca
  ON fc.category_id = ca.category_id
  WHERE ca.name = "Action"
  GROUP BY last_name
  ORDER BY last_name;
  end //
DELIMITER ;

call customer_for_action();


--
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
--
drop procedure if exists customer_for_category;
delimiter //
create procedure customer_for_category (in param1 varchar(50))
BEGIN
	SELECT concat(upper(substr(first_name,1,1)), lower(substr(first_name,2)), ' ', last_name) AS customer_name, email
	FROM customer c
	JOIN rental r 
	ON c.customer_id = r.customer_id
	JOIN inventory i
	ON r.inventory_id = i.inventory_id
	JOIN film_category fc
	ON i.film_id = fc.film_id
	JOIN category ca
	ON fc.category_id = ca.category_id
	WHERE name COLLATE utf8_unicode_ci = param1
	GROUP BY last_name
	ORDER BY last_name;
END
// 
delimiter ;

SELECT name FROM category;
call customer_for_category("Children");

--
-- Write a query to check the number of movies released in each movie category.
--
SELECT ca.name AS category, COUNT(fc.film_id) AS number_of_films
FROM category ca
JOIN film_category fc
ON ca.category_id = fc.category_id
GROUP BY category;

--
-- Convert the query in to a stored procedure to filter 
-- only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
--

drop procedure if exists filter_films_more_x;
delimiter //
create procedure filter_films_more_x (in param1 int)
BEGIN
SELECT ca.name AS category, COUNT(fc.film_id) AS number_of_films
FROM category ca
JOIN film_category fc
ON ca.category_id = fc.category_id
GROUP BY category
HAVING number_of_films >= param1;
END
// 
delimiter ;

call filter_films_more_x("65");