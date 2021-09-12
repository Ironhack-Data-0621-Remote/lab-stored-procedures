use saklia;

drop procedure customers_that_rent_action;

-- Create a stored procedure that finds first name, last name, and emails of all the customers who rented `Action movies.
delimiter //
create procedure customers_that_rent_action ()
begin
select  concat(first_name, ' ', last_name) as customer_name, email
    from customer
    where customer_id in (select customer_id from rental
    where inventory_id in (select inventory_id from inventory
    where film_id in (select film_id from film_category
    where category_id in (select category_id from category
    where name = 'Action'))));
end
//
delimiter ;

call customers_that_rent_action();

--
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return 
-- the results for all customers that rented movie of that category/genre.

delimiter //
create procedure customers_that_rent_category (in param varchar(15))
begin
select  concat(first_name, ' ', last_name) as customer_name, email
    from customer
    where customer_id in (select customer_id from rental
    where inventory_id in (select inventory_id from inventory
    where film_id in (select film_id from film_category
    where category_id in (select category_id from category
    where name COLLATE utf8mb4_general_ci = param ))));
end
//
delimiter ;

call customers_that_rent_category('Animation');


--
-- Write a query to check the number of movies released in each movie category.
Select c.name, count(f.film_id)
from film_category f
left join category c
on f.category_id = c.category_id
group by c.name;


--
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
drop procedure film_in_category;


delimiter //
create procedure film_in_category (in param1 int, out param2 float)
begin

select count(*) into param2 from (Select count(f.film_id)
from film_category f
left join category c
on f.category_id = c.category_id
group by c.name
having count(f.film_id) > param1) sub1;

end
// 
delimiter ;

call film_in_category(65, @x);

select @x;
