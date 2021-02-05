CREATE  TEMPORARY TABLE stock1 AS
SELECT * FROM stock s;

CREATE  TEMPORARY TABLE warehouse1 AS
SELECT * FROM warehouse w;

SELECT w.w_name
FROM  warehouse1 w NATURAL JOIN stock1 s
WHERE w.w_city='Singapore' AND s.i_id=33;


EXPLAIN ANALYZE SELECT w.w_name
FROM  warehouse1 w NATURAL JOIN stock1 s
WHERE w.w_city='Singapore' AND s.i_id=33;

********我们都知道SQL的join关联表的使用方式，但是这次聊的是实现join的算法，join有三种算法，分别是Nested Loop Join，Hash join，Sort Merge Join。分别是三种不同的join algo
NLJ是通过两层循环，用第一张表做Outter Loop，第二张表做Inner Loop，Outter Loop的每一条记录跟Inner Loop的记录作比较，符合条件的就输出

INSERT INTO warehouse1 SELECT * FROM warehouse;

INSERT INTO warehouse1 SELECT * FROM warehouse;

EXPLAIN ANALYZE SELECT w.w_name
FROM  warehouse1 w NATURAL JOIN stock1 s
WHERE w.w_city='Singapore' AND s.i_id=33;
SELECT s.i_id, s.s_qty
FROM warehouse w JOIN stock s ON w.w_id=s.w_id
WHERE w.w_name='Agimba';

EXPLAIN ANALYZE SELECT s.i_id, s.s_qty
FROM warehouse w JOIN stock s ON w.w_id=s.w_id
WHERE w.w_name='Agimba';
SELECT w.w_name, s.i_id, s.s_qty
FROM warehouse w, stock s
WHERE w.w_id=s.w_id;

EXPLAIN ANALYZE SELECT w.w_name, s.i_id, s.s_qty
FROM warehouse w, stock s
WHERE w.w_id=s.w_id;

EXPLAIN SELECT w.w_name, s.i_id, s.s_qty
FROM , stock s, warehouse w
WHERE w.w_id=s.w_id;
CREATE   TABLE warehouse2 AS
SELECT * FROM warehouse;

EXPLAIN SELECT w1.w_name
FROM warehouse2 w1, warehouse2 w2 
WHERE w1.w_name=w2.w_name;
SELECT * FROM pg_statistic s, pg_class t 
WHERE s.starelid = t.oid
AND  t.relname='warehouse2';

DELETE FROM pg_statistic s 
WHERE s.starelid = ANY (
	SELECT t.oid 
	FROM pg_class t 
	WHERE t.relname='warehouse2');

SELECT * FROM pg_statistic s, pg_class t 
WHERE s.starelid = t.oid
AND  t.relname='warehouse2';

EXPLAIN SELECT w1.w_name
FROM warehouse2 w1, warehouse2 w2 
WHERE w1.w_name=w2.w_name;

ANALYZE warehouse2;

SELECT * FROM pg_statistic s, pg_class t 
WHERE s.starelid = t.oid
AND  t.relname='warehouse2';

EXPLAIN SELECT w1.w_name
FROM warehouse2 w1, warehouse2 w2 
WHERE w1.w_name=w2.w_name;

EXPLAIN SELECT w.w_name
FROM warehouse w
WHERE EXISTS (
SELECT *
FROM stock s
WHERE s.w_id = w.w_id);

EXPLAIN SELECT w.w_name
FROM warehouse w
WHERE NOT EXISTS (
SELECT *
FROM stock s
WHERE s.w_id = w.w_id);
EXPLAIN SELECT w.w_name
FROM warehouse w LEFT OUTER JOIN stock s
ON w.w_id = s.w_id
WHERE s.w_id IS NULL;


EXPLAIN SELECT w.w_name
FROM warehouse w
WHERE w.w_id NOT IN  (
SELECT s.w_id
FROM stock s);

EXPLAIN SELECT i.i_name, s.w_id
FROM item i  LEFT OUTER JOIN stock s
ON s.i_id = i.i_id
WHERE i.i_name = 'MECLIZINE HYDROCHLORIDE'

SELECT w.w_name, i.i_name, s.s_qty
FROM warehouse w, stock s, item i
WHERE w.w_id=s.w_id AND s.i_id=i.i_id;

SELECT w.w_name, i.i_name, s.s_qty
FROM warehouse w NATURAL JOIN stock s NATURAL JOIN item i;

SELECT w.w_name, i.i_name, s.s_qty
FROM item i NATURAL JOIN stock s NATURAL JOIN warehouse w;

EXPLAIN ANALYZE SELECT w.w_name, i.i_name, s.s_qty
FROM warehouse w NATURAL JOIN stock s NATURAL JOIN item i;

EXPLAIN ANALYZE CREATE TABLE tall AS SELECT *
FROM warehouse w NATURAL JOIN stock s NATURAL JOIN item i;

EXPLAIN ANALYZE SELECT t.w_name, t.i_name, t.s_qty
FROM tall t;

EXPLAIN ANALYZE SELECT t.w_name, t.i_name, t.s_qty
FROM tall t
WHERE t.w_name='Agimba';

CREATE VIEW vall AS SELECT *
FROM warehouse w NATURAL JOIN stock s NATURAL JOIN item i;

EXPLAIN ANALYZE SELECT v.w_name, v.i_name, v.s_qty
FROM vall v;

EXPLAIN ANALYZE SELECT v.w_name, v.i_name, v.s_qty
FROM vall v
WHERE v.w_name='Agimba';

CREATE MATERIALIZED VIEW mvall AS SELECT *
FROM warehouse w NATURAL JOIN stock s NATURAL JOIN item i;

EXPLAIN ANALYZE SELECT v.w_name, v.i_name, v.s_qty
FROM mvall v;

EXPLAIN ANALYZE SELECT v.w_name, v.i_name, v.s_qty
FROM mvall v
WHERE v.w_name='Agimba';

SELECT * FROM stock s WHERE s.w_id=2 AND s.i_id=1;

EXPLAIN ANALYZE INSERT INTO stock VALUES (2,1,1);

SELECT * FROM stock s WHERE s.w_id=2 AND s.i_id=1;

SELECT * FROM mvall v WHERE v.w_id=2 AND v.i_id=1;

REFRESH MATERIALIZED VIEW mvall;

SELECT * FROM mvall v WHERE v.w_id=2 AND v.i_id=1;
EXPLAIN ANALYZE 
SELECT * FROM mvall v WHERE v.w_id=2 AND v.i_id=1;

CREATE  INDEX mvall_pkey ON mvall(w_id, i_id);

EXPLAIN ANALYZE 
SELECT * FROM mvall v WHERE v.w_id=2 AND v.i_id=1;

PREPARE q AS SELECT s.i_id
FROM stock s
WHERE s.s_qty > 500;

EXPLAIN ANALYZE EXECUTE q;

DEALLOCATE q;
