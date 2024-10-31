-- R Far DBMS HW4
-- Mike I swear my computer has to be broken
--

-- Alters for constraints 
ALTER TABLE Category 
ADD CHECK (name IN ('Animation', 'Comedy', 'Family', 'Foreign', 'Sci-Fi', 'Travel', 'Children', 'Drama', 'Horror', 'Action', 'Classics', 'Games', 'New', 'Documentary', 'Sports', 'Music')); 

ALTER TABLE film
ADD CHECK (special_features IN ('Behind the Scenes', 'Commentaries', 'Deleted Scenes', 'Trailers'));

ALTER TABLE payment
ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);

ALTER TABLE rental
ADD FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);

ALTER TABLE film ADD CHECK (rental_duration BETWEEN 2 AND 8);

ALTER TABLE film ADD CHECK (rental_rate BETWEEN 0.99 AND 6.99);

ALTER TABLE film ADD CHECK (length BETWEEN 30 AND 200);

ALTER TABLE film ADD CHECK (rating IN ('PG', 'G', 'NC-17', 'PG-13', 'R'));

ALTER TABLE film ADD CHECK (replacement_cost BETWEEN 5.00 AND 100.00);

ALTER TABLE payment ADD CHECK (amount >= 0);

ALTER TABLE film ADD CONSTRAINT check_release_year CHECK (DATE(CONCAT(release_year, '-01-01')) IS NOT NULL);

ALTER TABLE customer ADD CONSTRAINT check_active CHECK (active IN (0, 1));

-- End of constraints

-- Queries
-- 
-- Question 1
SELECT category.name AS category_name, AVG(film.length) AS average_length
FROM film_category
INNER JOIN film ON film_category.film_id = film.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY category.name;

-- Question 2
WITH CategoryAvgLength AS (
    SELECT category.name AS category_name, AVG(film.length) AS avg_length
    FROM category
    LEFT JOIN film_category ON category.category_id = film_category.category_id
    LEFT JOIN film ON film_category.film_id = film.film_id
    GROUP BY category_name
)
SELECT category_name, avg_length
FROM CategoryAvgLength
WHERE avg_length = (SELECT MAX(avg_length) FROM CategoryAvgLength)
   OR avg_length = (SELECT MIN(avg_length) FROM CategoryAvgLength);
   
-- Question 3
SELECT DISTINCT customer.customer_id, customer.first_name, customer.last_name
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Action'
AND customer.customer_id NOT IN (
    SELECT DISTINCT customer2.customer_id
    FROM customer AS customer2
    JOIN rental AS rental2 ON customer2.customer_id = rental2.customer_id
    JOIN inventory AS inventory2 ON rental2.inventory_id = inventory2.inventory_id
    JOIN film AS film2 ON inventory2.film_id = film2.film_id
    JOIN film_category AS film_category2 ON film2.film_id = film_category2.film_id
    JOIN category AS category2 ON film_category2.category_id = category2.category_id
    WHERE category2.name IN ('Comedy', 'Classics')
);

-- Question 4
SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(*) AS movie_count
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN language ON film.language_id = language.language_id
WHERE language.name = 'English'
GROUP BY actor.actor_id
ORDER BY movie_count DESC
LIMIT 1;

-- Question 5
SELECT COUNT(DISTINCT rental.inventory_id) AS distinct_movie_count
FROM rental
JOIN staff ON rental.staff_id = staff.staff_id
WHERE rental.return_date = DATE_ADD(rental.rental_date, INTERVAL 10 DAY)
AND staff.first_name = 'Mike';

-- Question 6
WITH ActorMovieCast AS (
    SELECT f.film_id, a.actor_id, a.first_name, a.last_name
    FROM film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
)
SELECT amc.actor_id, amc.first_name, amc.last_name
FROM ActorMovieCast amc
WHERE amc.film_id = (
    SELECT film_id
    FROM (
        SELECT film_id, COUNT(actor_id) AS cast_count
        FROM film_actor
        GROUP BY film_id
        ORDER BY cast_count DESC
        LIMIT 1
    ) AS largest_cast
)
ORDER BY amc.first_name, amc.last_name;