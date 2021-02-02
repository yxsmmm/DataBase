CREATE TABLE warehouse (
	w_id INTEGER PRIMARY KEY,
	w_name VARCHAR(50),
	w_street VARCHAR(50),
	w_city VARCHAR(50),
	w_country VARCHAR(50)
);

CREATE TABLE item (
i_id INTEGER PRIMARY KEY,
i_im_id CHAR(8) UNIQUE NOT NULL,
i_name VARCHAR(50)  NOT NULL,
i_price NUMERIC(5, 2)  NOT NULL CHECK(i_price >0));
				      
CREATE TABLE stock (
w_id INTEGER REFERENCES warehouse(w_id),
i_id INTEGER REFERENCES item(i_id),
s_qty SMALLINT CHECK(s_qty > 0),
PRIMARY KEY (w_id, i_id));				      

	     -- 执行过程 SQL Parser -> SQL Optimizer -> SQL Executioner -> Memory and Storage
	     --PostgreSQL query planner/optimizer tries and creates an optimal execution plan
	     --An execution plan is a tree of physical algebraic operators such as sequential scans, index scans, sorting and aggregation operators, nested loop, hash
	     -- and merge joins
	     --PostgreSQL query planner/optimizer uses the catalogue and statistics to estimate the cost of the possible plans and to find a plan with a estimated least cost
	     
	     --Query Executioner
	     --PostgreSQL query executioner executes the execution plan. It asccesss the data, indexes and stored functions
	     
	     --Timings
	     --The total query runtime includes the planning timem, the execution time and the time spent communicating with the client.
	     
	     
EXPLAIN SELECT w.w_name
FROM warehouse w
WHERE w.w_city = 'Singapore';	     
	     
	     --EXPLAIN displays the execution plan that the PostgreSQL query planner/optimizer generates for the supplied statement
	     --Do a seq scan on warehouse, when insert the data it see the statistics 
	     
	     
SELECT * FROM pg_stats
WHERE tablename='warehouse' 
AND attname='w_city';
	     
	     --System Catalogs and Statistics
	     --PostgreSQL query planner/optimizer uses statistic build and maintained by PostgreSQL
	     
	     
	     
EXPLAIN ANALYZE SELECT w.w_name
FROM warehouse w
WHERE w.w_city = 'Singapore';	
	     
	     -- 如果可以的话每次执行命令前都可以分析，原因在于数据可能随时都有变化
	     -- the oline streaming data is always changing 
	     -- also give the actual total planning and execution times in milliseconds
	     
	     
	     
EXPLAIN ANALYZE SELECT w.w_name
FROM warehouse w
WHERE w.w_city = 'Singapore';
	     
	     --  Sort Method: quicksort  Memory: 25kB
	     -- mergesort 会比quicksort 更好，但是当数据两很小的时候没必要进行mergesort
	     -- 所以数据库管理系统会根据所执行的query还有数据量的大小进行优化，来决定哪种算法以及数据结构用来执行query
	     
	  
EXPLAIN SELECT w.w_name
FROM warehouse w
WHERE w.w_city = 'Singapore'
GROUP BY w.w_name;
	     
	     
	     关键点********* Index
	     -- Index 用Index来实现优化，An index is a data structure that guides the access to the data
	     -- An index may or may not speed-up queries, deletions and updates. It generally slows down insertions and updates since both the data and the index must be updated 
	     -- and possibly re-organized
	     -- PostgreSQL does not offer integrated index data is the index and only cluster indexes data is organised accroding to the index on demand and statically
	     -- Is trade off make access faster but need to maintainance 
	     -- Can have the name directly into the data
	     
	     --Primary Key
	     --PostgreSQL automatically creates an index for each unique and primary key constraint.
-- The index is used to enforce uniqueness (at extra cost for insertions and updates).
	     
	     --PostgreSQL does not create an index for foreign key constraints.
	     --It is up to the designer to decide whether to create an index on the referencing
--columns and what index to create. Insertion and updates of the referenced table
--require a scan of the referencing table. It may be a good idea to create an index on the
--referencing columns. However, foreign key attributes are generally components of a
--composite key and are therefore indexed with a multicolumn index
	     
	     
CREATE VIEW indexinfo AS SELECT 
t.relname AS table_name,
ix.relname AS index_name,
i.indisunique AS is_unique,
i.indisprimary AS is_primary,
regexp_replace(pg_get_indexdef(i.indexrelid), '.*\((.*)\)', '\1') column_names
FROM pg_index i, pg_class t,  pg_class ix 
WHERE t.oid = i.indrelid 
AND ix.oid = i.indexrelid;	     
	     
	     
CREATE INDEX i_i_price ON item(i_price);
	     
	     -- 创建一个index
	 CREATE [UNIQUE] INDEX [name] ON table_name
	     [USING method]
	     ({colunm_name | (expression)})
			      [ WHERE predicate]
			      -- UNIQUE CHECK for duplicate values
			      -- method can be btree, hash and other index types
			      -- predicate defines a partial index
			 
			      --What is a B+Tree index?
			      --What is the difference between a sparse and a dense index?
--Are PostgreSQL indexes sparse or dense?
			      --What is the difference between a clustered and an unclustered index?
--Are PostgreSQL indexes clustered or unclustered (see CLUSTER)?
			      --What is the dierence between a primary and a secondary index?
--Are PostgreSQL indexes primary or secondary?
			      --What is a covering index?
Can PostgreSQL indexes be covering (see also INCLUDE in PostgreSQL 11)?
		
EXPLAIN ANALYZE SELECT w.w_name
FROM warehouse w
WHERE w.w_id='123';
			      
			      Index Scan using warehouse_pkey on warehouse w  (cost=0.28..8.29 rows=1 width=7) (actual time=0.012..0.013 rows=1 loops=1)
			      现在不用sequential scan直接index scan
			      
			      重点 ***** If the statistics indicate that the percentage of data to retrieve is tiny and if an index is
available, it may provide direct access. The optimizer uses an index scan.
	     
	     
	     创建index来加快查找速度
CREATE INDEX i_w_city ON warehouse(w_city);	     
	     
EXPLAIN ANALYZE SELECT w.w_name
FROM warehouse w
WHERE w.w_city = 'Singapore';	
			      速度快很多！！！ Bitmap Heap Scan on warehouse w  (cost=4.31..12.38 rows=5 width=7) (actual time=0.037..0.038 rows=5 loops=1)
			      If the statistics indicate that the percentage of data to retrieve is average and if an
index is available, a bitmap built on the index may provide somehow direct access. The
optimizer uses a bitmap heap scan.
			      The Bitmap Index Scan is implemented by a Bitmap Index Scan followed by a Bitmap
Heap Scan in PostgreSQL.
			      
			      
CLUSTER warehouse USING i_w_city;	
			      
			      用cluster sort之后再查询也会快一点点
	     
	     
	     
The Condition is not Selective
s.s_qty >= 100:38222 of 44912 rows (85%) are estimated to match the condition.
The optimizer chooses a sequential scan.
The Condition is Moderately Selective
s.s_qty < 100: 6690 of 44912 rows (15%) are estimated to match the condition.
The optimizer chooses a bitmap heap scan.
The Condition is very Selective
s.s_qty >= 100: 37 of 44912 rows (less than 0.001%) are estimated to match the
condition. The optimizer chooses an index scan.	     
	     
	    
			      
			      要学习怎么写	     
CREATE OR REPLACE FUNCTION test(NUMERIC) 
RETURNS SETOF TEXT AS $$
BEGIN
RETURN QUERY EXECUTE 
'EXPLAIN SELECT * 
FROM stock s
WHERE s.s_qty >= ' ||$1 ;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION stat(NUMERIC) 
RETURNS SETOF NUMERIC AS $$
BEGIN
RETURN QUERY EXECUTE 
'SELECT ROUND((COUNT(*)::NUMERIC /(SELECT COUNT(*) 
                                         FROM stock))
                                        *100)
FROM stock s
WHERE s.s_qty >= ' ||$1 ;
END
$$ LANGUAGE plpgsql;	
			      
			      来得到以下结果
			      
 qty stat test
0 100 Seq Scan on stock
100 85 Seq Scan on stock
200 76 Seq Scan on stock
300 66 Seq Scan on stock
400 57 Seq Scan on stock
500 48 Seq Scan on stock
600 38 Bitmap Heap Scan on stock
700 28 Bitmap Heap Scan on stock
800 19 Bitmap Heap Scan on stock
900 10 Bitmap Heap Scan on stock
1000 0 Index Scan using i_s_qty on stock
	     
	     
	     
	     
	     
EXPLAIN SELECT s.s_qty
FROM stock s
WHERE s.w_id='123';

EXPLAIN SELECT s.s_qty
FROM stock s
WHERE s.i_id='7';
			      
			      有可能考 当primary key是（w_id,i_id）的时候 会先按照w_id进行排序 这时候运行第一个 会是bitmap index scan
			      然后 i_id 相互会离得比较远就变成 sequantial scan
	     
     
EXPLAIN SELECT s.i_id
FROM stock s
WHERE s.w_id='123';	     
			      Index only scan, it not looking at data at all, it scan the index only
	     
	     
EXPLAIN SELECT s.w_id
FROM stock s
WHERE s.i_id='7';	     
			      sequantial scan 就是因为primary key的顺序不一样
