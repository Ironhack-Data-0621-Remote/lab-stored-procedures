-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.


-- query from last lab

select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
--

drop procedure action_films;

delimiter //
create procedure action_films ()
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

call action_films();


-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.

drop procedure if exists film_types_proc;

delimiter //
create procedure film_types_proc (in film_type varchar(50))
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8_unicode_ci = film_type
  group by first_name, last_name, email;
end
//
DELIMITER ;


call film_types_proc('Drama');


-- Write a query to check the number of movies released in each movie category.

select c.name, count(f.film_id)
from category c
join film_category fc
on c.category_id = fc.category_id
join film f
on fc.film_id = f.film_id
group by c.name;


-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

drop procedure category_count_proc;

delimiter //
create procedure category_count_proc (in threshold int)
begin
	select cat_name, cnt from
		(
		select c.name as cat_name, count(f.film_id) as cnt
		from category c
		join film_category fc
		on c.category_id = fc.category_id
		join film f
		on fc.film_id = f.film_id
		group by c.name
		) sub
		where cnt > threshold
        order by cnt desc;
end
//
DELIMITER ;

call category_count_proc(50);


