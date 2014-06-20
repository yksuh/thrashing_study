-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 06/17/14
-- Description: Define step queries for analyzing DBMS thrashing

-- DBMSes participating in the analysis
-- Analysis_DMD: Analysis_DBMS_Metadata
DROP TABLE Analysis_Dmd CASCADE CONSTRAINTS;
CREATE TABLE Analysis_Dmd
(
	dbmsname	VARCHAR2(10) NULL PRIMARY KEY
);
INSERT INTO Analysis_Dmd VALUES ('db2');
INSERT INTO Analysis_Dmd VALUES ('oracle');
INSERT INTO Analysis_Dmd VALUES ('pgsql');
INSERT INTO Analysis_Dmd VALUES ('mysql');
INSERT INTO Analysis_Dmd VALUES ('sqlserver');
INSERT INTO Analysis_Dmd VALUES ('teradata');
INSERT INTO Analysis_Dmd VALUES ('javadb');

-- Create a table for chosen labshelf (Get this from GUI)
DROP TABLE Analysis_LabShelf CASCADE CONSTRAINTS;
CREATE TABLE Analysis_LabShelf AS
	SELECT 700 AS version,	    ---- ___version___ ---	
	'azdblab_xact' AS username, ---- ___username___ ---	
	'azdblab_xact' AS password, ---- ___password___ ---
	'jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook' as connstr
	FROM Dual;
ALTER TABLE Analysis_LabShelf ADD PRIMARY KEY (version);

-- Create a table for runs  (Get this from GUI)
DROP TABLE Analysis_Runs CASCADE CONSTRAINTS;
CREATE TABLE Analysis_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	WHERE runid IN (473,472,509) 
	ORDER BY runid;
ALTER TABLE Analysis_Runs ADD PRIMARY KEY (runid);

-- Get all batch runs from the chosen labshelf
-- Analysis_S0_ABSR :  Analysis_S0_All_BatchSet_Runs
DROP TABLE Analysis_S0_ABR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABR AS
	SELECT  c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		er.runid,
		bs.BatchSetID,
		bsr.BatchSetRunResID as bsrResID, -- primary key
		b.batchID,
		br.BatchRunResID AS brResID,    -- batch run result ID
		b.MPL,			     	-- MPL
		br.ITERNUM as brIterNum,	-- iteration number
		br.SumExecXacts as totalExecXacts,    -- total executed transactions
		br.SumXactProcTime as totalProcTime -- total processing delay
	FROM  Analysis_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      Analysis_Runs c_run,
	      AZDBLab_BATCHSET bs, -- batchset
	      AZDBLab_BATCH b,	   -- batch
	      AZDBLab_BATCHSETHASRESULT bsr, -- batchset run record
	      AZDBLAB_BATCHHASRESULT br	     -- batch run record
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	       bsr.batchsetid 	= bs.batchsetid 	AND -- all batchsets
               bsr.BatchSetRunResID = br.BatchSetRunResID AND -- a batchset run
	       bs.batchsetid  = b.batchsetid 	AND -- all batches in a batchset
	       -- each batch
	       br.BatchID = b.batchID; 
	       --AND er.currentstage  ='Completed' 
               --AND er.percentage = 100;
ALTER TABLE Analysis_S0_ABR ADD PRIMARY KEY (brResID); 

DROP TABLE Analysis_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABSR AS
	SELECT version, 
	       experimentid, 
	       experimentname, 
	       dbms, 
	       runid, 
	       BatchSetID, 
               bsrResID, 
               batchID, -- batch ID
               MPL, 
	       round(avg(totalExecXacts),2) as totalExecXacts, 
	       round(avg(totalProcTime),2) as totalProcTime 
	FROM Analysis_S0_ABR
	WHERE
	GROUP BY version, experimentid, experimentname, dbms, runid, BatchSetID, bsrResID, batchID, MPL
ALTER TABLE Analysis_S0_ABSR ADD PRIMARY KEY (batchID); 

DROP TABLE Analysis_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABSR AS
	SELECT version, 
	       experimentid, 
	       experimentname, 
	       dbms, 
	       runid, 
	       BatchSetID, 
               bsrResID, 
               batchID, -- batch ID
               MPL, 
	       round(avg(totalExecXacts),2) as totalExecXacts, 
	       round(avg(totalProcTime),2) as totalProcTime 
	FROM Analysis_S0_ABR
	WHERE
	GROUP BY version, experimentid, experimentname, dbms, runid, BatchSetID, bsrResID, batchID, MPL
ALTER TABLE Analysis_S0_ABSR ADD PRIMARY KEY (batchID); 
	
