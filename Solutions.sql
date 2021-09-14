--
-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
-- 

DROP PROCEDURE IF EXISTS sp1;

DELIMITER //
CREATE PROCEDURE sp1 (	OUT param1 VARCHAR(20)
					)
BEGIN
	SELECT first_name
			, last_name
            , LOWER(email) AS email
	FROM customer
	JOIN rental 
		ON customer.customer_id = rental.customer_id
	JOIN inventory 
		ON rental.inventory_id = inventory.inventory_id
	JOIN film 
		ON film.film_id = inventory.film_id
	JOIN film_category 
		ON film_category.film_id = film.film_id
	JOIN category 
		ON category.category_id = film_category.category_id
	WHERE category.name = "Action"
	GROUP BY first_name
			, last_name
            , email;
END;
// DELIMITER ;

CALL sp1(@x);
-- DROP PROCEDURE sp1;

--
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
--

DROP PROCEDURE IF EXISTS sp2;

DELIMITER //
CREATE PROCEDURE sp2 (	IN param2 VARCHAR(20),
						OUT varpm2 VARCHAR(50)
                    )
BEGIN
	SELECT first_name
			, last_name
            , LOWER(email) AS email
	FROM customer
	JOIN rental 
		ON customer.customer_id = rental.customer_id
	JOIN inventory 
		ON rental.inventory_id = inventory.inventory_id
	JOIN film 
		on film.film_id = inventory.film_id
	JOIN film_category 
		ON film_category.film_id = film.film_id
	JOIN category 
		ON category.category_id = film_category.category_id
	WHERE category.name = param2
	GROUP BY first_name
			, last_name
            , email;
END;
// DELIMITER ;

CALL sp2('Action', @varpm2);
-- DROP PROCEDURE sp2;

/*
-- testing
SHOW VARIABLES LIKE '%char%';

SELECT 	first_name, 
		last_name, 
        LOWER(email) AS email
FROM customer
JOIN rental 
	ON customer.customer_id = rental.customer_id
JOIN inventory 
	ON rental.inventory_id = inventory.inventory_id
JOIN film 
	ON film.film_id = inventory.film_id
JOIN film_category 
	ON film_category.film_id = film.film_id
JOIN category 
	ON category.category_id = film_category.category_id
WHERE category.name = "Action"
GROUP BY first_name, 
		last_name, 
        email;
*/

--
-- Write a query to check the number of movies released in each movie category.
--

SELECT c.name
		, SUM(fc.film_id) AS movies_released
FROM film_category fc
JOIN category c
	ON fc.category_id = c.category_id
GROUP BY 1;

--
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
--

DROP PROCEDURE IF EXISTS sp3;

DELIMITER //
CREATE PROCEDURE sp3 (	IN param3 VARCHAR(20), 
						OUT varpm3 INT
					)
BEGIN
	SELECT * 
    FROM (	SELECT 	c.name AS category 
					, SUM(fc.film_id) AS movies
			FROM film_category fc
			JOIN category c
				ON fc.category_id = c.category_id
			GROUP BY c.name) AS movie_table
	WHERE movies > param3;
END;
  // 
DELIMITER ;

CALL sp3(1000, @x);
-- DROP PROCEDURE sp3;