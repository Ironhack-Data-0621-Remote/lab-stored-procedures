--
-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
-- 
use sakila;

DROP PROCEDURE customer_action_movies;

delimiter //
CREATE PROCEDURE customer_action_movies ()
BEGIN
SELECT CONCAT(cus.first_name, ' ', cus.last_name) AS customer_name, cus.email, c.name 
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category f
ON i.film_id = f.film_id
JOIN category c
ON f.category_id = c.category_id
JOIN customer cus
ON r.customer_id = cus.customer_id
WHERE c.name = 'Action'
GROUP BY 1,2,3;
END
//
delimiter ;

CALL customer_action_movies ();


--
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.
--

DROP PROCEDURE customerlist_filmcategory;

delimiter //
CREATE PROCEDURE customerlist_filmcategory (IN param1 varchar(25))
BEGIN
SELECT CONCAT(cus.first_name, ' ', cus.last_name) AS customer_name, cus.email, c.name 
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film_category f
ON i.film_id = f.film_id
JOIN category c
ON f.category_id = c.category_id
JOIN customer cus
ON r.customer_id = cus.customer_id
WHERE c.name COLLATE utf8mb4_general_ci = param1
GROUP BY 1,2,3;
END
//
delimiter ;

CALL customerlist_filmcategory ("Family");




-- Write a query to check the number of movies released in each movie category.
--

SELECT c.name as category_name, COUNT(c.name) AS total
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
GROUP BY c.name;

--
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
--

-- Below is the query to filter the category based on total amount (e.g. 70)

SELECT * FROM
(
SELECT c.name as category_name, COUNT(c.name) AS total
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
GROUP BY c.name) t1
WHERE total >= 70;

DROP PROCEDURE check_filmcategory;

delimiter //
CREATE PROCEDURE check_filmcategory (IN param1 INT)
BEGIN
SELECT * FROM
(
SELECT c.name as category_name, COUNT(c.name) AS total
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
GROUP BY c.name) t1
WHERE total COLLATE utf8mb4_general_ci >= param1;
END
//
delimiter //

CALL check_filmcategory (70);