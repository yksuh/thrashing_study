-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14
-- Description: Define step queries for batch execution sanity checks

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
	FROM Analysis_S0_ABE abe 
	WHERE abe.totalExecXacts = 0;
ALTER TABLE Analysis_S1_ZTV ADD PRIMARY KEY (runid, mpl, iternum); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_ZTV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_ZTV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_ZTV
	GROUP BY dbms, experimentname;

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
		abe.elapsedtime
	FROM Analysis_S0_ABE abe,
             Analysis_Duration dur
	WHERE (abr.elapsedtime/1000) > dur.period;
ALTER TABLE Analysis_S1_SDV ADD PRIMARY KEY (runid); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_SDV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_SDV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_SDV
	GROUP BY dbms, experimentname;

-- (3) Excessive ATP time violations

-- Analysis_ATP_Stat: Analysis_ATP_Statistics_at_MPL
DROP TABLE Analysis_ATP_Stat CASCADE CONSTRAINTS;
CREATE TABLE Analysis_ATP_Stat AS			
	SELECT  abr.runid,
		abr.BatchSetID,
		abr.MPL,		   
		AVG(abr.totalProcTime / abr.totalExecXacts) as AvgATPtime
		STDDEV(abr.totalProcTime / abr.totalExecXacts)as STDATPtime          
	FROM Analysis_S1_ABR abr
	WHERE abr.totalProcTime > 0;
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
	  -- ATP time greater than the average + two standard deviations
	  and (abe.totalProcTime / abe.totalExecXacts) > aas.AvgATPtime + aas.2*STDATPtime
          and abe.totalProcTime > 0
ALTER TABLE Analysis_S1_EAV ADD PRIMARY KEY (runid); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_EAV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_EAV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_EAV
	GROUP BY dbms, experimentname;
