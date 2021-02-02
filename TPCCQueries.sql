CREATE TABLE warehouses (
 w_id INTEGER PRIMARY KEY,
 w_name VARCHAR(10) NOT NULL,
 w_street VARCHAR(20) NOT NULL,
 w_city VARCHAR(20) NOT NULL,
 w_country CHAR(9) NOT NULL);
 
 INSERT INTO warehouses 
 (w_id, w_name, w_street, w_city, w_country) 
 VALUES 
 (301, 'Schmedeman', 'Sunbrook', 'Singapore', 'Singapore');
 
CREATE TABLE items (
i_id INTEGER PRIMARY KEY,
i_im_id VARCHAR(50) UNIQUE NOT NULL,
i_name VARCHAR(50)  NOT NULL,
i_price NUMERIC(5, 2)  NOT NULL CHECK(i_price > 0));

INSERT INTO items 
(i_id, i_im_id, i_name, i_price) 
VALUES 
(1, '35356226', 'Indapamide', 95.23);

CREATE TABLE stocks (
w_id INTEGER REFERENCES warehouses(w_id),
i_id INTEGER REFERENCES items(i_id),
s_qty SMALLINT NOT NULL,
PRIMARY KEY (w_id, i_id));

INSERT INTO stocks VALUES (301, 1, 338);
INSERT INTO stocks VALUES (301, 1, 12);
INSERT INTO stocks VALUES (301, 4, 938);

DROP TABLE stocks;
DROP TABLE items;
DROP TABLE warehouses;

% Create and populate the database using the TPCCSchema.sql, TPCCitems.sql, TPCCwarehouses.ql and TPCCstocks.sql

SELECT w.w_name
FROM warehouses w
WHERE w.w_id = 123;

SELECT w.w_name
FROM warehouses w
WHERE w.w_city = 'Singapore';

SELECT s.i_id
FROM stocks s
WHERE s.s_qty BETWEEN 0 AND 10;

SELECT s.i_id
FROM stocks s
WHERE s.s_qty <= 10;

SELECT w.w_city, w.w_name
FROM warehouses w
WHERE w.w_city LIKE 'Si%';

SELECT s1.i_id
FROM stocks s1
WHERE s1.s_qty = ALL (
 SELECT MAX(s2.s_qty) 
 FROM stocks s2);
 
SELECT w.w_id, w.w_name, w.w_city
FROM warehouses w
ORDER BY w.w_name;

SELECT w.w_id, w.w_name, w.w_city 
FROM warehouses w
ORDER BY w.w_city, w.w_name;

SELECT w.w_id, w.w_name
FROM warehouses w
ORDER BY  w.w_city;

SELECT s.i_id 
FROM stocks s 
GROUP BY s.i_id;

SELECT s.i_id, FLOOR(AVG(s.s_qty)) AS average_qty
FROM stocks s
GROUP BY s.i_id;

SELECT s.i_id, FLOOR(AVG(s.s_qty)) AS average_qty
FROM stocks s
GROUP BY s.i_id, s.w_id;

SELECT s.w_id
FROM stocks s
GROUP BY s. w_id
HAVING AVG(s.s_qty) >= 550;

SELECT s.i_id
FROM stocks s, warehouses w
WHERE s.w_id = w.w_id
 AND w.w_city = 'Singapore';
 
SELECT s.i_id
FROM stocks s CROSS JOIN warehouses w
WHERE s.w_id = w.w_id
 AND w.w_city = 'Singapore';

SELECT s.i_id
FROM stocks s JOIN warehouses w
ON s.w_id = w.w_id
WHERE w.w_city = 'Singapore';

SELECT s.i_id
FROM stocks s NATURAL JOIN warehouses w
WHERE w.w_city = 'Singapore';

SELECT s.i_id
FROM stocks s INNER JOIN warehouses w ON s.w_id = w.w_id
WHERE w.w_city = 'Singapore';


SELECT i.i_id, s.w_id
FROM items i LEFT OUTER JOIN stocks s 
ON i.i_id=s.i_id;

SELECT i.i_id, s.w_id
FROM  stocks s RIGHT OUTER JOIN  items i
ON i.i_id=s.i_id;

SELECT i.i_id, s.w_id
FROM  stocks s FULL OUTER JOIN  items i
ON i.i_id=s.i_id;
SELECT s.i_id
FROM stocks s 
WHERE s.w_id IN (
 SELECT w2.w_id 
 FROM warehouses w2 
 WHERE w2.w_city = 'Singapore');
 
SELECT s.i_id
FROM stocks s 
WHERE EXISTS (
 SELECT * 
 FROM warehouses w 
 WHERE s.w_id = w.w_id 
 AND w.w_city = 'Singapore');
 
SELECT i.i_id
FROM items i 
WHERE NOT EXISTS (
   SELECT *
   FROM warehouses w 
   WHERE NOT EXISTS (
      SELECT * 
      FROM stocks s 
      WHERE s.w_id=w.w_id AND s.i_id=i.i_id));

SELECT s.i_id
FROM stocks s, (
 SELECT w.w_id 
 FROM warehouses w 
 WHERE w.w_city = 'Singapore') AS w1
WHERE s.w_id = w1.w_id;

SELECT s.i_id
FROM stocks s INNER JOIN  (
 SELECT w.w_id 
 FROM warehouses w 
 WHERE w.w_city = 'Singapore') AS w1
ON s.w_id = w1.w_id;


