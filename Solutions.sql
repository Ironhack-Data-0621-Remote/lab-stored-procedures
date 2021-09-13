USE sakila;
-- Convert the query into a simple stored procedure. Use the following query:
SELECT first_name, last_name, email
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Action"
GROUP BY first_name, last_name, email;
-- Stored procedure:
DROP PROCEDURE customers_rented_movies_category;
DELIMITER //
CREATE PROCEDURE customers_rented_movies_category()
BEGIN
SELECT first_name, last_name, email
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = "Action"
GROUP BY first_name, last_name, email;
END //
DELIMITER ;
CALL customers_rented_movies_category();
-- Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
-- For eg., it could be action, animation, children, classics, etc.
DROP PROCEDURE customers_rented_movies_category;
DELIMITER //
CREATE PROCEDURE customers_rented_movies_category(in param1 varchar(20))
BEGIN
SELECT first_name, last_name, email
FROM customer 
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name COLLATE utf8mb4_general_ci = param1
GROUP BY first_name, last_name, email;
END //
DELIMITER ;
CALL customers_rented_movies_category("Animation");
-- Write a query to check the number of movies released in each movie category. 
SELECT category_id, COUNT(film_id) AS cat_num_released
FROM film_category
GROUP BY category_id;
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
DROP PROCEDURE more_movies_released;
DELIMITER //
CREATE PROCEDURE more_movies_released(in param1 int)
BEGIN
SELECT category_id, COUNT(film_id) AS cat_num_released
FROM film_category
GROUP BY category_id
HAVING cat_num_released > param1;
END //
DELIMITER ;
-- Pass that number as an argument in the stored procedure.
CALL more_movies_released(60);