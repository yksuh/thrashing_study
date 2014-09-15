-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Description: Define step queries for experiment-wide, batch execution, and batchset execution sanity checks

-- Experiment-wide sanity checks
-- (1) Number of Missing Batches
-- Catch all missing batches per dbms per experiment
-- Analysis_S0_MB_PDE : Analysis_S0_Missing_Batches_Per_DBMS_Per_Experiment
DROP VIEW Analysis_S0_MB_PDE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_MB_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.batchsetid,
	       -- numMissingBatches = the biggest MPL - # of distinct batches
	       -- COALESCE because value may be NULL
	       COALESCE(t1.max_mpl/t1.batchSzIncr-t2.numBs, 0) as numMBPerRunBatchSet 
	FROM (SELECT dbms, 
	             experimentname,
	             runid, 
		     batchsetid, 
		     batchSzIncr,
		     max(MPL) AS max_mpl
 	      FROM (SELECT DISTINCT dbms, 
			       	    experimentname,
	       		       	    runid, 
        	     	       	    BatchSetID,
				    batchSzIncr,
				    MPL 
      	       	    FROM Analysis_S0_ABR)
	      GROUP BY dbms, experimentname, runid, batchsetid, batchSzIncr) t1,
	      Analysis_S0_AB t2
	WHERE t1.runid	    = t2.runid and 
	      t1.batchsetid = t2.batchsetid
ALTER VIEW Analysis_S0_MB_PDE ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_MB_PDE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_MB_PDE' as stepName,
	       SUM(numMBPerRunBatchSet) as stepResultSize
	FROM Analysis_S0_MB_PDE
	GROUP BY dbms, experimentname;


-- Experiment-wide sanity checks
-- (2) Number of Inconsistent Processor Configuration Violations
-- Caught when each executor gets launched 

-- (3) Number of Number of Missed Batch Executions
DROP VIEW Analysis_S0_MBE_PDE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_MBE_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.batchsetid,
	       -- numMissingBatchExecutions = number of batches * number of iterations (3) - # of batch executions
	       -- COALESCE because value may be NULL
	       COALESCE(t1.numBTs*t3.numIters-t2.numBEs, 0) as numMBEPerRunBatchSet 
	FROM (SELECT dbms, 
	             experimentname,
	             runid, 
		     batchsetid
		     count(MPL) AS numBTs
 	      FROM (SELECT DISTINCT dbms, 
			       	    experimentname,
	       		       	    runid, 
        	     	       	    BatchSetID,
				    batchSzIncr,
				    MPL 
      	       	    FROM Analysis_S0_ABR)
	      GROUP BY dbms, experimentname, runid, batchsetid) t1,
	      Analysis_S0_AB t2,
	      Analysis_Iterations t3
	WHERE t1.runid	    = t2.runid and 
	      t1.batchsetid = t2.batchsetid
ALTER VIEW Analysis_S0_MBE_PDE ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_MBE_PDE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_MBE_PDE' as stepName,
	       SUM(numMBEPerRunBatchSet) as stepResultSize
	FROM Analysis_S0_MBE_PDE
	GROUP BY dbms, experimentname;


-- (4) Number of Other Executor Violations
-- (5) Number of Other DBMS Process Violations
-- Caught when each executor gets launched 

-- Batch Execution sanity checks

-- (1) Zero TPS violations
-- Analysis_S0_ZTV: Analysis_S0_Zero_TPS_Violations
DROP TABLE Analysis_S0_ZTV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ZTV AS			
	SELECT abr.dbms,
	       abr.experimentname,
	       abr.runid,
	       abr.batchsetid,
	       abr.mpl,
	       abr.iternum
	FROM Analysis_S0_ABR abr
	WHERE abr.totalExecXacts = 0;
ALTER TABLE Analysis_S0_ZTV ADD PRIMARY KEY (runid, mpl, iternum); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_ZTV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_ZTV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S0_ZTV
	GROUP BY dbms, experimentname;

-- (2) Session duration violations
-- Analysis_S0_SDV: Analysis_S0_Session_Duration_Violations
DROP TABLE Analysis_S0_SDV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_SDV AS			
	SELECT  abr.dbms,
		abr.experimentname,
		abr.runid,
		abr.BatchSetID,
		abr.duration,
		abr.MPL,		   
		abr.IterNum	     -- iteration number
	FROM Analysis_S0_ABR abr,
             Analysis_Duration dur
	WHERE (abr.duration/1000) > dur.period;
ALTER TABLE Analysis_S0_SDV ADD PRIMARY KEY (runid); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_SDV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_SDV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S0_SDV
	GROUP BY dbms, experimentname;

-- (3) Excessive ATP time violations

-- Analysis_ATP_Stat: Analysis_ATP_Statistics_at_MPL
DROP TABLE Analysis_ATP_Stat CASCADE CONSTRAINTS;
CREATE TABLE Analysis_ATP_Stat AS			
	SELECT  abr.runid,
		abr.BatchSetID,
		abr.MPL,		   
		ROUND(AVG(abr.totalProcTime / abr.totalExecXacts), 2) as AvgATPtime
		ROUND(STDDEV(abr.totalProcTime / abr.totalExecXacts), 2) as STDATPtime          
	FROM Analysis_S0_ABR abr
	WHERE abr.totalProcTime > 0;
ALTER TABLE Analysis_ATP_Stat ADD PRIMARY KEY (runid, batchsetID, MPL); 

-- Analysis_S0_EAV: Analysis_S0_Excessive_ATP_time_Violations
DROP TABLE Analysis_S0_EAV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_EAV AS		
	SELECT  abr.dbms,
		abr.experimentname,
		abr.runid,
		abr.BatchSetID,
		abr.duration,
		abr.MPL,		   
		abr.IterNum	     -- iteration number
	FROM Analysis_S0_ABR abr,
             Analysis_ATP_Stat aas
	WHERE abr.runid      = aas.runid 
          and abr.batchsetid = aas.batchsetid 
	  -- ATP time greater than the average + two standard deviations
	  and ROUND(abr.totalProcTime / abr.totalExecXacts, 2) > aas.AvgATPtime + aas.2*STDATPtime
          and abr.totalProcTime > 0
ALTER TABLE Analysis_S0_EAV ADD PRIMARY KEY (runid); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_EAV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_EAV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S0_EAV
	GROUP BY dbms, experimentname;

-- Batchset sanity checks
-- (1) Number of Transient Thrashing Violations
DROP TABLE Analysis_S0_TTV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_TTV AS		
	SELECT  abr.dbms,
		abr.experimentname,
		abr.runid,
		abr.BatchSetID,
		abr.duration,
		abr.MPL,		   
		
	FROM Analysis_S0_FTP ftp
	WHERE abr.runid      = tp.runid 
          and abr.batchsetid = tp.batchsetid 
	  
ALTER TABLE Analysis_S0_EAV ADD PRIMARY KEY (runid); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_EAV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_EAV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S0_EAV
	GROUP BY dbms, experimentname;
