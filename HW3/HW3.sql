use hw3; /*this is for you mike :) */

ALTER TABLE contain
RENAME COLUMN ï»¿oid TO oid;

ALTER TABLE customers
RENAME COLUMN ï»¿cid TO cid;

-- Question one 
SELECT p.name AS product_name, m.name AS merchant_name, s.quantity_available
FROM products p
JOIN sell s ON p.pid = s.pid
JOIN merchants m ON s.mid = m.mid
WHERE s.quantity_available = 0;

-- Question two
SELECT p.name, p.description
FROM products p
LEFT JOIN sell s ON p.pid = s.pid
WHERE s.pid IS NULL;

-- Question three
SELECT COUNT(DISTINCT pl.cid) AS num_customers
FROM place pl
JOIN orders o ON pl.oid = o.oid
JOIN contain c ON o.oid = c.oid
JOIN products p ON c.pid = p.pid
WHERE p.category = 'SATA'
AND pl.cid NOT IN (
    SELECT DISTINCT pl2.cid
    FROM place pl2
    JOIN orders o2 ON pl2.oid = o2.oid
    JOIN contain c2 ON o2.oid = c2.oid
    JOIN products p2 ON c2.pid = p2.pid
    WHERE p2.category = 'Router'
);

-- Question four
SELECT products.name AS product_name, sell.price AS original_price, (sell.price * 0.8) AS discounted_price
FROM sell
INNER JOIN products ON sell.pid = products.pid
WHERE sell.mid = (SELECT mid FROM merchants WHERE name = 'HP')
  AND products.category = 'Networking';

-- Question five
SELECT DISTINCT customers.fullname AS customer_name, products.name AS product_name, sell.price
FROM customers
INNER JOIN place ON customers.cid = place.cid
INNER JOIN orders ON place.oid = orders.oid
INNER JOIN contain ON orders.oid = contain.oid
INNER JOIN products ON contain.pid = products.pid
INNER JOIN sell ON products.pid = sell.pid
INNER JOIN merchants ON sell.mid = merchants.mid
WHERE customers.fullname = 'Uriel Whitney' AND merchants.name = 'Acer';


-- question six
SELECT YEAR(order_date) AS year, merchants.name AS company, SUM(sell.price * sell.quantity_available) AS total_revenue
FROM place
JOIN orders ON place.oid = orders.oid
JOIN contain ON place.oid = contain.oid
JOIN sell ON contain.pid = sell.pid
JOIN merchants ON sell.mid = merchants.mid
GROUP BY YEAR(order_date), merchants.name
ORDER BY YEAR(order_date) DESC;

-- question seven
SELECT YEAR(order_date) AS year, merchants.name AS company, SUM(sell.price * sell.quantity_available) AS total_revenue
FROM place
JOIN orders ON place.oid = orders.oid
JOIN contain ON place.oid = contain.oid
JOIN sell ON contain.pid = sell.pid
JOIN merchants ON sell.mid = merchants.mid
GROUP BY YEAR(order_date), merchants.name
ORDER BY total_revenue DESC
LIMIT 1;

-- question eight
SELECT AVG(lowest_shipping_cost) AS average_lowest_shipping_cost
FROM (
    SELECT MIN(orders.shipping_cost) AS lowest_shipping_cost
    FROM orders
    GROUP BY orders.oid
) AS lowest_shipping_methods;

-- question nine
WITH totalSales AS (
    SELECT merchants.name AS company, products.category, SUM(sell.price * sell.quantity_available) AS total_sales
    FROM sell
    JOIN products ON sell.pid = products.pid
    JOIN merchants ON sell.mid = merchants.mid
    GROUP BY merchants.name, products.category
)
SELECT totalSales.company, totalSales.category, totalSales.total_sales
FROM totalSales
JOIN (
    SELECT company, MAX(total_sales) AS max_sales
    FROM totalSales
    GROUP BY company
) max_sales_per_company ON totalSales.company = max_sales_per_company.company AND totalSales.total_sales = max_sales_per_company.max_sales;

-- question 10
WITH customerleastmost AS (
    SELECT merchants.name AS company,
           customers.fullname AS customer_name,
           SUM(sell.price * sell.quantity_available) AS total_spent
    FROM place
    JOIN orders ON place.oid = orders.oid
    JOIN contain ON place.oid = contain.oid
    JOIN sell ON contain.pid = sell.pid
    JOIN merchants ON sell.mid = merchants.mid
    JOIN customers ON place.cid = customers.cid
    GROUP BY merchants.name, customers.fullname
)
SELECT customer1.company, customer1.customer_name, customer1.total_spent
FROM customerleastmost customer1
JOIN (
    SELECT company,
           MAX(total_spent) AS max_spent,
           MIN(total_spent) AS min_spent
    FROM customerleastmost
    GROUP BY company
) customer2
ON customer1.company = customer2.company AND (customer1.total_spent = customer2.max_spent OR customer1.total_spent = customer2.min_spent)
ORDER BY company, total_spent DESC;
