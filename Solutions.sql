USE sakila;

-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
DROP PROCEDURE IF EXISTS cmr_action_rentals;

DELIMITER //
CREATE PROCEDURE cmr_action_rentals()
BEGIN

SELECT CONCAT(first_name, ' ', last_name) AS name, email 
FROM customer 
WHERE customer_id IN ( 
	SELECT customer_id 
	FROM rental
	WHERE inventory_id IN (
		SELECT inventory_id
		FROM inventory
		WHERE film_id IN (
			SELECT film_id
			FROM film_category
			WHERE category_id IN (
				SELECT category_id
				FROM category
				WHERE name = 'Action'))))
GROUP BY customer_id;

END //
DELIMITER ;

CALL cmr_action_rentals();

-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.

DROP PROCEDURE IF EXISTS cmr_category_rentals;

DELIMITER //
CREATE PROCEDURE cmr_category_rentals(IN cat VARCHAR(20))
BEGIN

SELECT CONCAT(first_name, ' ', last_name) AS name, email 
FROM customer 
WHERE customer_id IN ( 
	SELECT customer_id 
	FROM rental
	WHERE inventory_id IN (
		SELECT inventory_id
		FROM inventory
		WHERE film_id IN (
			SELECT film_id
			FROM film_category
			WHERE category_id IN (
				SELECT category_id
				FROM category
				WHERE category.name COLLATE utf8_unicode_ci = cat)))) -- parameter which was defined above!
GROUP BY customer_id;

END //
DELIMITER ;

CALL cmr_category_rentals('Action');


-- Write a query to check the number of movies released in each movie category.

SELECT c.name, COUNT(fc.film_id) AS nbr_films_released
FROM film_category fc
JOIN category c
USING (category_id)
GROUP BY c.name
ORDER BY 2 DESC;

--
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

DROP PROCEDURE IF EXISTS movies_per_category;

DELIMITER //
CREATE PROCEDURE movies_per_category(IN nbr INT)
BEGIN

SELECT * 
FROM (
SELECT c.name, COUNT(fc.film_id) AS nbr_films_released
FROM film_category fc
JOIN category c
USING (category_id)
GROUP BY c.name
ORDER BY 2 DESC) s1
WHERE nbr_films_released >= nbr;

END //
DELIMITER ;

CALL movies_per_category(70);