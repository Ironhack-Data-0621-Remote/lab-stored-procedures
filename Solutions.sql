USE sakila;

# First part
DELIMITER //
CREATE PROCEDURE action_customers()
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
END
//
DELIMITER ;

CALL action_customers();

# Second part
DELIMITER //
CREATE PROCEDURE r_category(in cat varchar(30))
BEGIN
	select first_name, last_name, email
	from customer
	join rental on customer.customer_id = rental.customer_id
	join inventory on rental.inventory_id = inventory.inventory_id
	join film on film.film_id = inventory.film_id
	join film_category on film_category.film_id = film.film_id
	join category on category.category_id = film_category.category_id
	where category.name = cat
	group by first_name, last_name, email;
END
//
DELIMITER ;

CALL r_category("Action");

# Third part
drop procedure if exists film_cat;
DELIMITER //
CREATE PROCEDURE film_cat(in number int)
BEGIN
	select c.name, count(fc.film_id) as n_films
	from film_category fc
	join category c on fc.category_id = c.category_id
	group by c.name
	having n_films > number;
END
//
DELIMITER ;

CALL film_cat(40);