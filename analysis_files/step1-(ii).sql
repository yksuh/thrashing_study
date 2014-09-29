-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14, 09/27/14
-- Description: Define step1-(ii) queries for batch execution sanity checks

-- Batch Execution sanity checks

-- (1) Zero TPS violations
-- Analysis_S1_ZTV: Analysis_S1_Zero_TPS_Violations
DROP TABLE Analysis_S1_ZTV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_ZTV AS			
	SELECT abe.dbms,
	       abe.experimentname,
	       abe.runid,
	       abe.batchsetid,
	       abe.batchSzIncr,
	       abe.MPL,
	       abe.iternum
	FROM Analysis_S0_ABE abe, 
	     Analysis_S0_ABS s0abs
	WHERE abe.runid      = s0abs.runid
	  and abe.batchsetid = s0abs.batchsetid
          and abe.MPL 	     = s0abs.startMPL
	  and abe.totalExecXacts = 0;
ALTER TABLE Analysis_S1_ZTV ADD PRIMARY KEY (runid, batchsetid, MPL, iternum); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_ZTV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_ZTV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_ZTV
	GROUP BY dbms, experimentname;
--select dbms, experimentname, avg(MPL) from Analysis_S1_ZTV group by dbms, experimentname
--select dbms, experimentname, min(MPL) from Analysis_S1_ZTV group by dbms, experimentname
--select * from Analysis_RowCount where stepname = 'Analysis_S1_ZTV'

-- (2) Session duration violations
-- Analysis_S1_SDV: Analysis_S1_Session_Duration_Violations
DROP TABLE Analysis_S1_SDV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_SDV AS			
	SELECT  abe.dbms,
		abe.experimentname,
		abe.runid,
		abe.BatchSetID,
		abe.batchSzIncr,
	        abe.MPL,		   
		abe.IterNum,	     -- iteration number
		abe.ELAPSEDTIME
	FROM Analysis_S0_ABE abe,
             Analysis_Duration dur
	WHERE TRUNC(abe.ELAPSEDTIME/1000) > dur.period
	--WHERE TRUNC(abe.ELAPSEDTIME/1000) > dur.period*1.01
	--WHERE TRUNC(abe.ELAPSEDTIME/1000) > dur.period*1.01
	;
ALTER TABLE Analysis_S1_SDV ADD PRIMARY KEY (runid, batchsetID, MPL, IterNum); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_SDV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_SDV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_SDV
	GROUP BY dbms, experimentname;

--select sum(stepResultSize) from Analysis_RowCount where stepname = 'Analysis_S1_SDV'

-- (3) Excessive ATP time violations

-- Analysis_ATP_Stat: Analysis_ATP_Statistics_at_MPL
DROP TABLE Analysis_ATP_Stat CASCADE CONSTRAINTS;
CREATE TABLE Analysis_ATP_Stat AS			
	SELECT  abe.dbms,
	        abe.experimentname,
	        abe.runid,
		abe.BatchSetID,
		abe.MPL,		   
		AVG(abe.totalProcTime / abe.totalExecXacts) as AvgATPtime,
		STDDEV(abe.totalProcTime / abe.totalExecXacts)as STDATPtime          
	FROM Analysis_S0_ABE abe
	WHERE abe.totalProcTime > 0
	GROUP BY dbms, experimentName, runid, batchsetID, MPL;
ALTER TABLE Analysis_ATP_Stat ADD PRIMARY KEY (runid, batchsetID, MPL); 

-- Analysis_S1_EAV: Analysis_S1_Excessive_ATP_time_Violations
DROP TABLE Analysis_S1_EAV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_EAV AS		
	SELECT  abe.dbms,
		abe.experimentname,
		abe.runid,
		abe.BatchSetID,
		abe.batchSzIncr,
	        abe.MPL,		   
		abe.IterNum	     -- iteration number
	FROM Analysis_S0_ABE abe,
             Analysis_ATP_Stat aas
	WHERE abe.runid      = aas.runid 
          and abe.batchsetid = aas.batchsetid 
	  and abe.MPL	     = aas.MPL
	  -- ATP time greater than the average + two standard deviations
	  and (abe.totalProcTime / abe.totalExecXacts) > (aas.AvgATPtime + 2*aas.STDATPtime)
          and abe.totalProcTime > 0;
ALTER TABLE Analysis_S1_EAV ADD PRIMARY KEY (runid, batchsetID, MPL, iternum); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_EAV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_EAV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_EAV
	GROUP BY dbms, experimentname;
--select * from Analysis_RowCount where stepname = 'Analysis_S1_EAV'
