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

INSERT INTO items 
(i_id, i_im_id, i_name, i_price) 
VALUES 
(1, '35356226', 'Indapamide', 95.23);
