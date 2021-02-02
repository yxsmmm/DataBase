CREATE TABLE warehouses (
 w_id INTEGER PRIMARY KEY,
 w_name VARCHAR(10) NOT NULL，
 w_street VARCHAR(20) NOT NULL,
 w_city VARCHAR(20) NOT NULL,
 w_country CHAR(9) NOT NULL);
  -- VARCHAR 就是普通的string 长度为10 characters
  -- 和 CHAR 的区别是 CHAR的长度固定
 
 INSERT INTO warehouses 
 (w_id, w_name, w_street, w_city, w_country) 
 VALUES 
 (301, 'Schmedeman', 'Sunbrook', 'Singapore', 'Singapore');
 
CREATE TABLE items (
i_id INTEGER PRIMARY KEY,
i_im_id VARCHAR(50) UNIQUE NOT NULL,
i_name VARCHAR(50)  NOT NULL,
i_price NUMERIC(5, 2)  NOT NULL CHECK(i_price > 0));
-- 问题：为什么选择 i_id 为primary key？ 一般情况所有 UNIQUE and NOT NULL 的都可以作为 primary key 我们称之为candidate key
-- 但是这里考虑的是stability 稳定性，意思是所选择的primary key最好是固定的
-- 而且不会轻易改变的数据， 例如员工id不会轻易变化，但是office的location会

-- 备注 Integrity Constrains in SQL
-- PRIMARY KEY, UNIQUE, NOT NULL, FOREIGN KEY, CHECK
                                      -- FOREIGN KEYs are reference the PRIMARY KEY this is always the case
                                      -- Table CHECK constraints, CHECK constrains with general SQL statement and ASSERTION
                                      -- constraints are not available in database management system,check 只能用在简单的语句中
                                      -- CHECK 语句针对所有的sql执行语句例如 insertion，deletion or update.
                                      -- Voilate the constraints 会导致系统不会执行并且通知用户
SELECT w.w_name
FROM warehouses w
WHERE w.w_id = 123;
                                      -- Point Query returns at most one record based on an equality condition
                                      -- Will return 0 or 1 because w_id is the primary key
INSERT INTO items 
(i_id, i_im_id, i_name, i_price) 
VALUES 
(1, '35356226', 'Indapamide', 95.23);
                                      
                                      
SELECT w.w_name
FROM warehouses w
WHERE w.w_city = 'Singapore';             
                                      -- Multipoint Query 0 to many
                                      
SELECT s.i_id
FROM stocks s
WHERE s.s_qty BETWEEN 0 AND 10;

SELECT s.i_id
FROM stocks s
WHERE s.s_qty <= 10;
                                      --Range Query 0 to many
                                      
SELECT w.w_city, w.w_name
FROM warehouses w
WHERE w.w_city LIKE 'Si%';           
                                      -- Prefix Match Query
                                      
SELECT s1.i_id
FROM stocks s1
WHERE s1.s_qty = ALL (
 SELECT MAX(s2.s_qty) 
 FROM stocks s2);
                                      -- Nested query MAX is aggregate function 聚合函数
                                      

SELECT w.w_id, w.w_name, w.w_city
FROM warehouses w
ORDER BY w.w_name;

SELECT w.w_id, w.w_name, w.w_city 
FROM warehouses w
ORDER BY w.w_city, w.w_name;
                                      -- First order crossing to the city

SELECT w.w_id, w.w_name
FROM warehouses w
ORDER BY  w.w_city;
                                      -- we can order the things not printing
                                      
                                      
SELECT s.i_id 
FROM stocks s 
GROUP BY s.i_id;

SELECT s.i_id, FLOOR(AVG(s.s_qty)) AS average_qty
FROM stocks s
GROUP BY s.i_id;

SELECT s.i_id, FLOOR(AVG(s.s_qty)) AS average_qty
FROM stocks s
GROUP BY s.i_id, s.w_id;
                         -- grouping query partitions the records into groups. 
                         -- 算平均数 FLOOR is rounding function
                         -- only one copy no need to compute the average
SELECT s.w_id
FROM stocks s
GROUP BY s. w_id
HAVING AVG(s.s_qty) >= 550;     
                         -- average all the quantities in the warehouse

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
                         -- all the three queries doing the same thing, , 就等同于 CROSS JOIN 和 JOIN

SELECT s.i_id
FROM stocks s NATURAL JOIN warehouses w
WHERE w.w_city = 'Singapore';

SELECT s.i_id
FROM stocks s INNER JOIN warehouses w ON s.w_id = w.w_id
WHERE w.w_city = 'Singapore';            
                         
                         -- ALL the same
SELECT s.i_id
FROM stocks s 
WHERE s.w_id IN (
 SELECT w2.w_id 
 FROM warehouses w2 
 WHERE w2.w_city = 'Singapore'); 
                         -- 等下尝试用在question 2 里面 uncorrelated nested query
                         
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
    -- find the items everywhere
    
    -- Negation Using NOT IN, <> ALL, NOT EXISTS and EXCEPT(MINUS) increases the expressive power of SQL

    
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
    
    -- there can be nested queries in the SELECT and FROM clause
    
    
