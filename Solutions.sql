use sakila;

-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.

delimiter //
create procedure rented_action (out param1 varchar(50), out param2 varchar(50))
begin
with cte_1 as(
	select c.customer_id, concat(c.first_name, ' ', c.last_name) as name, c.email, ca.name as category_name
    from customer c
    join rental r
    on c.customer_id = r.customer_id
	join inventory i
    on r.inventory_id = i.inventory_id
    join film_category f
    on i.film_id = f.film_id
    join category ca
    on f.category_id = ca.category_id
)
select distinct(name), email
from cte_1
where category_name = 'Action'
order by name;
end
//
delimiter ;

call rented_action(@x,@y);

-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.

delimiter //
create procedure rented_category (in param1 varchar(20), out param2 varchar(50), out param3 varchar(50))
begin
with cte_1 as(
	select c.customer_id, concat(c.first_name, ' ', c.last_name) as name, c.email, ca.name as category_name
    from customer c
    join rental r
    on c.customer_id = r.customer_id
	join inventory i
    on r.inventory_id = i.inventory_id
    join film_category f
    on i.film_id = f.film_id
    join category ca
    on f.category_id = ca.category_id
)
select distinct(name), email
from cte_1
where category_name collate utf8mb4_general_ci = param1
order by name;
end
//
delimiter ;

call rented_category('Children', @x, @y);
call rented_category('Action', @x, @y);

-- Write a query to check the number of movies released in each movie category.
select c.name, count(f.film_id) number
from category c
join film_category f
on c.category_id = f.category_id
group by c.name;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

delimiter //
create procedure film_number (in param1 int, out param2 varchar(20), out param3 int)
begin
select c.name, count(f.film_id) number
from category c
join film_category f
on c.category_id = f.category_id
group by c.name
having number collate utf8mb4_general_ci > param1;
end
//
delimiter ;

call film_number(60, @x, @y)