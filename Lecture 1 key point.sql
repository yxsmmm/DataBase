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
