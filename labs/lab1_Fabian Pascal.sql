/******************************************************************************/
/* Fabian Pascal                                                              */
/* Indicate your student number here: A0224915E                               */
/******************************************************************************/
 SELECT per.empid, per.lname 
 FROM employee per, payroll pay
 WHERE per.empid = pay.empid 
 AND pay.salary = 189170;
 
/******************************************************************************/
/* Answer Question 1.a below                                                  */
/******************************************************************************/
 SELECT emp.empid, emp.lname
 FROM employee emp
 LEFT OUTER JOIN payroll pay
 ON pay.salary = 189170 AND pay.empid = emp.empid
 WHERE pay.empid is NOT NULL;
 
 SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 LEFT OUTER JOIN payroll pay
 ON pay.salary = 189170 AND pay.empid = emp.empid
 WHERE pay.empid is NOT NULL;
			 ',1000);

	

-- Indicate the average measured times for 1000 executions for the query.
-- (replace <time> with the average time reported by test function).

-- Average Planning <0.11> ms
-- Average Execution <1.74> ms

/******************************************************************************/
/* Answer Question 1.b below                                                  */
/******************************************************************************/
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE EXISTS (
	 SELECT * FROM payroll pay
	 WHERE emp.empid = pay.empid
	 AND pay.salary = 189170
 ) ;
 
 SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE EXISTS (
	 SELECT * FROM payroll pay
	 WHERE emp.empid = pay.empid
	 AND pay.salary = 189170
			 )
			 ',1000);

-- Indicate the average measured times for 1000 executions for the query.
-- (replace <time> with the average time reported by test function).

-- Average Planning <0.11> ms
-- Average Execution <1.69> ms

/******************************************************************************/
/* Answer Question 1.c below                                                  */
/******************************************************************************/
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE emp.empid IN (
	 SELECT pay.empid
	 FROM payroll pay
	 WHERE pay.salary = 189170
 );
 
  SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE emp.empid IN (
	 SELECT pay.empid
	 FROM payroll pay
	 WHERE pay.salary = 189170
 )
			 ',1000);

-- Indicate the average measured times for 1000 executions for the query.
-- (replace <time> with the average time reported by test function).

-- Average Planning <0.11> ms
-- Average Execution <1.68> ms

/******************************************************************************/
/* Answer Question 1.d below                                                  */
/******************************************************************************/
SELECT emp.empid, emp.lname
FROM (
	SELECT * FROM payroll WHERE salary = 189170
	 )  pay,  employee emp
WHERE pay.empid = emp.empid;

  SELECT test('
			 SELECT emp.empid, emp.lname
FROM (
	SELECT * FROM payroll WHERE salary = 189170
	 )  pay,  employee emp
WHERE pay.empid = emp.empid;
			  ',1000);



-- Indicate the average measured time for 1000 executions for the query.
-- (replace <time> with the average time reported by test function).

-- Average Planning <0.11> ms
-- Average Execution <1.69> ms

/******************************************************************************/
/* Answer Question 1.e below                                                  */
/******************************************************************************/
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE NOT EXISTS (
	 SELECT * FROM payroll pay
	 WHERE pay.empid = emp.empid
	 AND pay.salary != 189170
 );
 
 SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE NOT EXISTS (
	 SELECT * FROM payroll pay
	 WHERE pay.empid = emp.empid
	 AND pay.salary != 189170
 );
			 ',1000);
 

-- Indicate the average measured times for 1000 executions for the query.
-- (replace <time> with the average time reported by test function).

-- Average Planning <0.14> ms
-- Average Execution <4.08> ms

/******************************************************************************/
/* Answer Question 2 below (new query)                                        */
/******************************************************************************/
 

 SELECT emp.empid, emp.lname
 FROM employee emp
 LEFT OUTER JOIN payroll pay
 ON pay.salary = 189170 AND pay.empid = emp.empid
 WHERE NOT EXISTS (
	 SELECT * FROM payroll pay
	 WHERE NOT EXISTS (SELECT * FROM payroll pay WHERE pay.empid != emp.empid)
	 AND pay.salary != 189170  
 ) 
 AND pay.empid is NOT NULL;
 
  SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 LEFT OUTER JOIN payroll pay
 ON pay.salary = 189170 AND pay.empid = emp.empid
 WHERE NOT EXISTS (
	 SELECT * FROM payroll pay
	 WHERE NOT EXISTS (SELECT * FROM payroll pay WHERE pay.empid != emp.empid)
	 AND pay.salary != 189170  
 ) 
 AND pay.empid is NOT NULL;',1000);
 

-- Indicate the average measured times for 1000 executions for the query.
-- (replace <time> with the average time reported by test function).
-- <242.37> ms

/******************************************************************************/
/* Answer Question 3 below (constraints or indexes)                           */
/******************************************************************************/

<constraints or indexes>

-- Indicate the new average measured times for 1000 executions for each of the 
-- five queries. 
-- (replace <time> with the average time reported by test function).

-- Q1.a 
-- Average Planning <0.14> ms
-- Average Execution <0.05> ms
--ALTER TABLE employee DROP CONSTRAINT employee_pkey;
 ALTER TABLE employee ADD PRIMARY KEY (empid, lname);
 CREATE INDEX i_salary ON payroll(salary);
 CREATE INDEX i_empid ON payroll(empid);

-- DROP INDEX i_salary
 
 SELECT emp.empid, emp.lname
 FROM employee emp
 LEFT OUTER JOIN payroll pay
 ON pay.salary = 189170 AND pay.empid = emp.empid
 WHERE pay.empid is NOT NULL;
 
  SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 LEFT OUTER JOIN payroll pay
 ON pay.salary = 189170 AND pay.empid = emp.empid
 WHERE pay.empid is NOT NULL;
			 ',1000);

 
-- Q1.b 
-- Average Planning <0.14> ms
-- Average Execution <0.05> ms


 --ALTER TABLE employee ADD PRIMARY KEY (empid);
 --ALTER TABLE payroll ADD CONSTRAINT payroll_fkey FOREIGN KEY (empid) REFERENCES employee (empid);
 --ALTER TABLE employee DROP CONSTRAINT employee_pkey;
 --ALTER TABLE payroll DROP CONSTRAINT payroll_fkey;
 -- DROP INDEX i_salary
 ALTER TABLE employee ADD PRIMARY KEY (empid, lname);
 CREATE INDEX i_salary ON payroll(salary);
 CREATE INDEX i_empid ON payroll(empid);

  SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE EXISTS (
	 SELECT * FROM payroll pay
	 WHERE emp.empid = pay.empid
	 AND pay.salary = 189170
 ) ;
 
 SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE EXISTS (
	 SELECT * FROM payroll pay
	 WHERE emp.empid = pay.empid
	 AND pay.salary = 189170
			 )
			 ',1000);
-- Q1.c 
-- Average Planning <0.14> ms
-- Average Execution <0.05> ms
-- ALTER TABLE employee DROP CONSTRAINT employee_pkey;
-- DROP INDEX i_salary;
-- DROP INDEX i_empid;
 
 ALTER TABLE employee ADD PRIMARY KEY (empid, lname);
 CREATE INDEX i_salary ON payroll(salary);
 CREATE INDEX i_empid ON payroll(empid);
-- CREATE INDEX i_empid ON payroll(empid);
 
 EXPLAIN ANALYSE SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE emp.empid IN (
	 SELECT pay.empid
	 FROM payroll pay
	 WHERE pay.salary = 189170
 );
 
  SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE emp.empid IN (
	 SELECT pay.empid
	 FROM payroll pay
	 WHERE pay.salary = 189170
 )
			 ',1000);
 
-- Q1.d 
-- Average Planning <0.13> ms
-- Average Execution <0.05> ms

 ALTER TABLE employee ADD PRIMARY KEY (empid, lname);
 CREATE INDEX i_salary ON payroll(salary);
 CREATE INDEX i_empid ON payroll(empid);
 
SELECT emp.empid, emp.lname
FROM (
	SELECT * FROM payroll WHERE salary = 189170
	 )  pay,  employee emp
WHERE pay.empid = emp.empid;

  SELECT test('
			 SELECT emp.empid, emp.lname
FROM (
	SELECT * FROM payroll WHERE salary = 189170
	 )  pay,  employee emp
WHERE pay.empid = emp.empid;
			  ',1000);

-- Q1.e 
-- Average Planning <0.17> ms
-- Average Execution <3.95> ms
CREATE INDEX i_salary ON payroll(salary);
CREATE INDEX i_empid ON payroll(empid)


SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE NOT EXISTS (
	 SELECT * FROM payroll pay
	 WHERE pay.empid = emp.empid
	 AND pay.salary != 189170
 );
 
 SELECT test('
 SELECT emp.empid, emp.lname
 FROM employee emp
 WHERE NOT EXISTS (
	 SELECT * FROM payroll pay
	 WHERE pay.empid = emp.empid
	 AND pay.salary != 189170
 );
			 ',1000);



