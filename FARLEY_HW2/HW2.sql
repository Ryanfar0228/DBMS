use hw2;


/*    Average Price of Foods at Each Restaurant  */
SELECT r.name, AVG(f.price) AS Avg_Price
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.name;

/* Maximum Food Price at Each Restaurant */
SELECT r.name, MAX(f.price) AS Max_Price
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.name;

/* Count of Different Food Types Served at Each Restaurant */
SELECT r.name, COUNT(f.type) AS Food_Type_Count
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.name;

/* Average Price of Foods Served by Each Chef */
SELECT c.name AS Chef_Name, AVG(f.price) AS Avg_Price
FROM chefs c
JOIN works w ON c.chefID = w.chefID
JOIN serves s ON w.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY c.name;


/*  Find the Restaurant with the Highest Average Food Price   */
SELECT r.name AS Restaurant, AVG(f.price) AS Avg_Price
FROM restaurants r
JOIN serves s ON r.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY r.name
ORDER BY Avg_Price DESC
LIMIT 1;

/* Bonus */
SELECT c.name AS Chef_Name, AVG(f.price) AS Avg_Food_Price, GROUP_CONCAT(r.name) AS Restaurants
FROM chefs c
JOIN works w ON c.chefID = w.chefID
JOIN restaurants r ON r.restID = w.restID
JOIN serves s ON w.restID = s.restID
JOIN foods f ON s.foodID = f.foodID
GROUP BY c.name
ORDER BY Avg_Food_Price DESC
LIMIT 1;