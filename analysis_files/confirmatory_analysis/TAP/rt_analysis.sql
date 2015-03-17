-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/29/14, 11/22/14
-- Description: Define step queries for summing up the runtime hours

DROP TABLE Cnfm_RTE_Dmd;
CREATE TABLE Cnfm_RTE_Dmd 	-- Primary key is a dbms.
(
	dbmsName	VARCHAR2(10) NOT NULL PRIMARY KEY, -- dbms name
	loadingHours	NUMBER (10, 3)  		   -- loading time
);
INSERT INTO Cnfm_RTE_Dmd VALUES ('db2',    0.5);  
INSERT INTO Cnfm_RTE_Dmd VALUES ('oracle', 1);    
INSERT INTO Cnfm_RTE_Dmd VALUES ('pgsql',  0.1);     
INSERT INTO Cnfm_RTE_Dmd VALUES ('mysql',  0.017);    
INSERT INTO Cnfm_RTE_Dmd VALUES ('teradata',  0.2);  
INSERT INTO Cnfm_RTE_Dmd VALUES ('sqlserver',  0.1); 

DROP TABLE Cnfm_RTE_Chosen_Runs;
CREATE TABLE Cnfm_RTE_Chosen_Runs AS -- Primary key is runid.
	SELECT runid 
	FROM AZDBLab_ExperimentRun 
	-- pk runs
	WHERE CURRENTSTAGE like 'Completed' 
	 AND runid IN (2309,2469,2889,2789,2809, 2069,2390,2850,2612,2649, 2229,2070,2750,2090,2409, 3009,3010,3029,3011,3150, 2289,2489,2089,2709,2049) 
	UNION
	SELECT runid 
	FROM AZDBLab_ExperimentRun 
	-- non-pk runs
	WHERE CURRENTSTAGE like 'Completed' 
	 AND runid IN (2389,2609,2949,2829,2909, 2249,2529,2851,2769,2669, 2349,2449,2629,2589,2410, 3089,3069,3049,3070,3189, 2369,2610,2830,2749,2269) 
	ORDER BY runid;
ALTER TABLE Cnfm_RTE_Chosen_Runs ADD PRIMARY KEY (runid);

DROP VIEW Cnfm_RTE_S0;
CREATE VIEW Cnfm_RTE_S0 AS 	-- Primary key is a query execution: (qeid)
	SELECT er.DBMSNAME,
	       ex.experimentname as exprName,
	       rl.runid,
	       ROW_NUMBER() OVER ( ORDER BY 1 ) AS rnum, 
	       rl.transactiontime as current_time,
	       rl.currentstage
	from azdblab_runlog rl, 
	     azdblab_experimentrun er, 
	     azdblab_experiment ex,
	     Cnfm_RTE_Chosen_Runs Cnfm_RTE_runs
	where Cnfm_RTE_runs.runid = rl.runid
	  and rl.runid = er.runid 
	  and er.experimentid = ex.experimentid
	  and (ex.experimentname like '%xt%' and (rl.currentstage like 'Analyzed #%' or rl.currentstage like '%Experiment is ready%'))
	order by dbmsName, exprName, runid, current_time;
ALTER VIEW Cnfm_RTE_S0 ADD PRIMARY KEY (runid, rnum) DISABLE;

DROP VIEW Cnfm_RTE_S1;
CREATE VIEW Cnfm_RTE_S1 AS 
	SELECT t1.dbmsName,
               t1.exprName,
	       t1.runid,
	       t1.currentstage,
	       t1.current_time-t0.current_time as diff
	FROM Cnfm_RTE_S0 t0,
	     Cnfm_RTE_S0 t1
	WHERE t0.runid = t1.runid 
	and t1.rnum >= 1
	and t1.rnum-1 = t0.rnum 
	and (t1.exprName like '%xt%' and t1.currentstage like '%Analyzed #%')
	order by t1.runid, t1.rnum asc;
ALTER VIEW Cnfm_RTE_S1 ADD PRIMARY KEY (runid, currentstage) DISABLE;

DROP VIEW Cnfm_RTE_S2;
CREATE VIEW Cnfm_RTE_S2 AS 
	select  t2.dbmsName,
                t2.exprName,
                t2.runid,
	        t2.currentstage,
	        extract( day from t2.diff ) days,
	        extract( hour from t2.diff ) hours,
	        extract( minute from t2.diff ) minutes,
	        extract( second from t2.diff ) seconds
	from Cnfm_RTE_S1 t2;
ALTER VIEW Cnfm_RTE_S2 ADD PRIMARY KEY (runid, currentstage) DISABLE;

DROP VIEW Cnfm_RTE_S3;
CREATE VIEW Cnfm_RTE_S3 AS 
	SELECT t0.dbmsName,
	       t0.exprName,
               t0.runid,
	       --sum(days),
	       --sum(hours),
	       --sum(minutes),
	       --sum(seconds),
	       (sum(days)*24+sum(hours)+(sum(minutes)+round(sum(seconds)/60, 2))/60) as hours
	FROM Cnfm_RTE_S2 t0
	group by t0.dbmsName, t0.exprName, t0.runid;
ALTER VIEW Cnfm_RTE_S3 ADD PRIMARY KEY (runid) DISABLE;
--select * from Cnfm_RTE_S3;

DROP VIEW Cnfm_RTE_S4;
CREATE VIEW Cnfm_RTE_S4 AS 
	SELECT t0.dbmsName,
	       exprName,
               runid,
	       hours+t0.loadingHours as hours
	FROM Cnfm_RTE_Dmd t0,
	     Cnfm_RTE_S3 t1
        WHERE t0.dbmsName = t1.dbmsName;
ALTER VIEW Cnfm_RTE_S4 ADD PRIMARY KEY (runid) DISABLE;

--SELECT * FROM Cnfm_RTE_S4;
--SELECT sum(HOURS) FROM Cnfm_RTE_S4;
--DBMSNAME   ROUND(SUM(HOURS),2)
---------- -------------------
--db2		       1107.15
--mysql		       1038.08
--oracle	       1020.15
--pgsql		       1037.94
--sqlserver		966.77
