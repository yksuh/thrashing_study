-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/29/14
-- Description: Define step queries for summing up the runtime hours

DROP TABLE RTE_Dmd;
CREATE TABLE RTE_Dmd 	-- Primary key is a dbms.
(
	dbmsName	VARCHAR2(10) NOT NULL PRIMARY KEY, -- dbms name
	loadingHours	NUMBER (10, 3)  		   -- loading time
);
INSERT INTO RTE_Dmd VALUES ('db2',    0.5);  
INSERT INTO RTE_Dmd VALUES ('oracle', 1);    
INSERT INTO RTE_Dmd VALUES ('pgsql',  0.1);     
INSERT INTO RTE_Dmd VALUES ('mysql',  0.017);    
INSERT INTO RTE_Dmd VALUES ('teradata',  0.2);  
INSERT INTO RTE_Dmd VALUES ('sqlserver',  0.1); 
--SELECT runid, sum(HOURS) FROM RTE_S4 where runid IN (611, 989) group by runid
DROP TABLE RTE_Chosen_Runs;
CREATE TABLE RTE_Chosen_Runs AS -- Primary key is runid.
	SELECT runid 
	FROM AZDBLab_ExperimentRun 
	-- non pk runs
	WHERE CURRENTSTAGE like 'Completed' 
	 AND runid IN (689,1289,889,969,611,    949,1291,610,709,989, 849,1270,809,749,1469, 1870,1369,1109,829,1769) 
	-- runs beyond: 28 => sqlserver-611 (80,1),989 (76,2), db2-689(76,1),949(74,2),849(76,4), oracle-889(76,1), 610(80,2), 809(76,4), pgsql-969(76,1), 709(76, 2), 749(76,4), 829(76,8),
	UNION
	SELECT runid 
	FROM AZDBLab_ExperimentRun 
	-- pk runs
	-- runs beyond: 28 => 1129(76,pgsql-1)
	WHERE CURRENTSTAGE like 'Completed' 
	 AND runid IN (1351,1290,1329,1129,869, 1710,1471,1610,1729,1110, 1630,1473,1709,1472,1232, 1869,1470,1609,1749,1649) 
	ORDER BY runid;
ALTER TABLE RTE_Chosen_Runs ADD PRIMARY KEY (runid);

DROP VIEW RTE_S0;
CREATE VIEW RTE_S0 AS 	-- Primary key is a query execution: (qeid)
	SELECT er.DBMSNAME,
	       ex.experimentname as exprName,
	       rl.runid,
	       ROW_NUMBER() OVER ( ORDER BY 1 ) AS rnum, 
	       rl.transactiontime as current_time,
	       rl.currentstage
	from azdblab_runlog rl, 
	     azdblab_experimentrun er, 
	     azdblab_experiment ex,
	     RTE_Chosen_Runs RTE_runs
	where RTE_runs.runid = rl.runid
	  and rl.runid = er.runid 
	  and er.experimentid = ex.experimentid
	  and (ex.experimentname like '%xt%' and (rl.currentstage like 'Analyzed #%' or rl.currentstage like '%Experiment is ready%'))
	order by dbmsName, exprName, runid, current_time;
ALTER VIEW RTE_S0 ADD PRIMARY KEY (runid, rnum) DISABLE;

DROP VIEW RTE_S1;
CREATE VIEW RTE_S1 AS 
	SELECT t1.dbmsName,
               t1.exprName,
	       t1.runid,
	       t1.currentstage,
	       t1.current_time-t0.current_time as diff
	FROM RTE_S0 t0,
	     RTE_S0 t1
	WHERE t0.runid = t1.runid 
	and t1.rnum >= 1
	and t1.rnum-1 = t0.rnum 
	and (t1.exprName like '%xt%' and t1.currentstage like '%Analyzed #%')
	order by t1.runid, t1.rnum asc;
ALTER VIEW RTE_S1 ADD PRIMARY KEY (runid, currentstage) DISABLE;

DROP VIEW RTE_S2;
CREATE VIEW RTE_S2 AS 
	select  t2.dbmsName,
                t2.exprName,
                t2.runid,
	        t2.currentstage,
	        extract( day from t2.diff ) days,
	        extract( hour from t2.diff ) hours,
	        extract( minute from t2.diff ) minutes,
	        extract( second from t2.diff ) seconds
	from RTE_S1 t2;
ALTER VIEW RTE_S2 ADD PRIMARY KEY (runid, currentstage) DISABLE;

DROP VIEW RTE_S3;
CREATE VIEW RTE_S3 AS 
	SELECT t0.dbmsName,
	       t0.exprName,
               t0.runid,
	       --sum(days),
	       --sum(hours),
	       --sum(minutes),
	       --sum(seconds),
	       (sum(days)*24+sum(hours)+(sum(minutes)+round(sum(seconds)/60, 2))/60) as hours
	FROM RTE_S2 t0
	group by t0.dbmsName, t0.exprName, t0.runid;
ALTER VIEW RTE_S3 ADD PRIMARY KEY (runid) DISABLE;
--select * from RTE_S3;

DROP VIEW RTE_S4;
CREATE VIEW RTE_S4 AS 
	SELECT t0.dbmsName,
	       exprName,
               runid,
	       hours+t0.loadingHours as hours
	FROM RTE_Dmd t0,
	     RTE_S3 t1
        WHERE t0.dbmsName = t1.dbmsName;
ALTER VIEW RTE_S4 ADD PRIMARY KEY (runid) DISABLE;
SELECT dbmsname, round(sum(HOURS),2) FROM RTE_S4 group by dbmsname order by dbmsname;
--SELECT * FROM RTE_S4;
--SELECT sum(HOURS) FROM RTE_S4;
--DBMSNAME   ROUND(SUM(HOURS),2)
---------- -------------------
--db2		       1670.91 (-230.70-249.8-299.65=-780.15) = 890.76
--mysql			529.77 
--oracle	       1120.56 (-111.79-133.00-198.32=-443.11)=427.65
--pgsql		       1242.45 (-140.21-114.3-122-114.3-171.82=-662.63)=579.8200000000001
--sqlserver		620.25 (-88.4-82.5=-170.9)=449.35
--SELECT runid, sum(HOURS) FROM RTE_S4 where runid IN (689, 949,849) group by runid
	-- runs beyond: 28 => sqlserver-611 (80,1),989 (76,2), db2-689(76,1),949(74,2),849(76,4), oracle-889(76,1), 610(80,2), 809(76,4), pgsql-969(76,1), 709(76, 2), 749(76,4), 829(76,8),
	-- runs beyond: 28 => 1129(76,pgsql-1)
SQL> SELECT runid, sum(HOURS) FROM RTE_S4 where runid IN (949,689,849) group by runid;

     RUNID SUM(HOURS)
---------- ----------
       949   402.3595 5.43 *28
       689 374.781833
       849 474.460167

SQL> SELECT runid, sum(HOURS) FROM RTE_S4 where runid IN (889,610,809) group by runid;

     RUNID SUM(HOURS)
---------- ----------
       889   177.3275
       610 204.615667
       809    314.501

SQL> SELECT runid, sum(HOURS) FROM RTE_S4 where runid IN (969, 709, 749, 829) group by runid;
SQL> SELECT runid, sum(HOURS) FROM RTE_S4 where runid IN (969, 709, 749, 829,1129) group by runid; 

     RUNID SUM(HOURS)
---------- ----------
       829	222.1
       709   181.4415
       749 192.991667
       969 181.123667
       1129 272.061833
