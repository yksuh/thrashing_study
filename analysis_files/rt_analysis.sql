
DROP TABLE RTE_Dmd;
CREATE TABLE RTE_Dmd 	-- Primary key is a dbms.
(
	dbmsName	VARCHAR2(10) NOT NULL PRIMARY KEY, -- dbms name
	loadingHours	NUMBER (10, 3)  		   -- loading time
);
INSERT INTO RTE_Dmd VALUES ('db2',    1.0);  
INSERT INTO RTE_Dmd VALUES ('oracle', 0.53);    
INSERT INTO RTE_Dmd VALUES ('pgsql',  0.1);     
INSERT INTO RTE_Dmd VALUES ('mysql',  0.017);    
INSERT INTO RTE_Dmd VALUES ('teradata',  0.2);  
INSERT INTO RTE_Dmd VALUES ('sqlserver',  0.1); 

DROP TABLE RTE_Chosen_Runs;
CREATE TABLE RTE_Chosen_Runs AS -- Primary key is runid.
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	--WHERE runid IN (252,256,250,254,257,253,263,264,293,267,270,415,269,285,418,441,516,536,659,682)
	WHERE CURRENTSTAGE like 'Completed'
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
	  and ((ex.experimentname like '%eh%' and (((rl.currentstage like 'Done with%') or (rl.currentstage like 'Completed%'))or (rl.currentstage like '%Populating Variable Tables%'))) or (ex.experimentname like '%op%' and (rl.currentstage like 'Analyzing Query%' or rl.currentstage like '%Done with the max table population%')))
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
	and ((t1.exprName like '%eh%' and (t1.currentstage like 'Done with%' or t1.currentstage like 'Completed%')) or (t1.exprName like '%op%' and t1.currentstage like '%Analyzing Query%'))
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
--SELECT * FROM RTE_S4;
--SELECT sum(HOURS) FROM RTE_S4;
--SELECT dbmsname, round(sum(HOURS),2) FROM RTE_S4 group by dbmsname;
