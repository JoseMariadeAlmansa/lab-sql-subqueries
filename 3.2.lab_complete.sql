USE sakila;
#1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT COUNT(inventory_id) as number_of_copies, (SELECT title FROM sakila.film WHERE title='Hunchback Impossible') as 'title'
FROM sakila.inventory;
# 2. List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (SELECT avg(length) FROM film) ORDER BY length desc;
# 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT CONCAT(first_name,' ' ,last_name) AS actor_name FROM sakila.actor
WHERE actor_id IN (
SELECT actor_id FROM sakila.film_actor
WHERE film_id = (SELECT film_id FROM sakila.film WHERE title= 'Alone Trip'));
# We can check Joining the tables to seek the same result
SELECT CONCAT(a.first_name,' ' ,a.last_name) AS actor_name
FROM sakila.actor a
JOIN sakila.film_actor fa USING (actor_id)
JOIN sakila.film f USING (film_id)
WHERE f.title='Alone Trip';
# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title AS 'family_movies' FROM sakila.film
WHERE film_id IN (
SELECT film_id FROM sakila.film_category
WHERE category_id = (SELECT category_id FROM sakila.category WHERE name= 'Family'));
# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT CONCAT(cu.first_name,' ' ,cu.last_name) AS customer_name, cu.email
FROM sakila.customer cu
JOIN sakila.address a USING (address_id)
JOIN sakila.city ci USING (city_id)
JOIN sakila.country co USING (country_id)
WHERE co.country='Canada';
-- -------------------------------------------------------------------------------------------------------------------------------------------
SELECT CONCAT(first_name,' ' ,last_name) AS customer_name, email FROM sakila.customer
WHERE address_id IN (
SELECT address_id FROM sakila.address
WHERE city_id IN (
SELECT city_id FROM sakila.city
WHERE country_id = (SELECT country_id FROM sakila.country WHERE country= 'Canada')));
# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title  FROM sakila.film
WHERE film_id IN (
SELECT film_id  FROM sakila.film_actor
WHERE actor_id IN (
SELECT sub1.actor_id FROM (SELECT COUNT(film_id) AS profilic_actor ,actor_id FROM sakila.film_actor GROUP BY actor_id ORDER BY profilic_actor DESC LIMIT 1)sub1));
# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT title FROM sakila.film
WHERE film_id IN (
SELECT film_id FROM sakila.rental
WHERE customer_id IN(
SELECT sub1.customer_id FROM (SELECT sum(amount) AS profitable_customer, customer_id FROM sakila.payment GROUP BY customer_id ORDER BY profitable_customer DESC LIMIT 1)sub1));

# 8. Customers who spent more than the average payments.
select concat(last_name, ', ', first_name) as Name from sakila.customer
where customer_id in (
	select customer_id
    from rental
    where RENTAL_ID IN( SELECT rental_id FROM sakila.payment 
    where payment.amount > (select avg(payment.amount) from payment)));
/*SELECT CONCAT(first_name,' ' ,last_name) AS 'customer_name' FROM sakila.customer
WHERE customer_id IN (
SELECT customer_id FROM sakila.payment
WHERE (SELECT amount AS profitable_customer, customer_id FROM sakila.payment GROUP BY customer_id ORDER BY profitable_customer DESC) > (SELECT AVG(amount) AS average_amount FROM sakila.payment));
*/

