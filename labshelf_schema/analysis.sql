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
	WHERE runid IN (549,551,552) 
	ORDER BY runid;
ALTER TABLE Analysis_Runs ADD PRIMARY KEY (runid);

-- Get all batch runs from the chosen labshelf
-- Analysis_S0_ABR :  Analysis_S0_All_BatchSetRuns
DROP TABLE Analysis_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABSR AS
	SELECT  c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		er.runid,
		bs.BatchSetID,
		bsr.BatchSetRunResID, -- primary key
		bs.batchSzIncr,
		bsr.duration,
		bsr.numCores,
		bsr.bufferSpace
	 FROM  Analysis_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      Analysis_Runs c_run,
	      AZDBLab_BatchSet bs, -- batchset
	      AZDBLab_BatchSetHasResult bsr -- batchset run record
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	       -- er.currentstage  ='Completed' AND
               -- er.percentage = 100 AND
	       bsr.batchsetid = bs.batchsetid;
ALTER TABLE Analysis_S0_ABSR ADD PRIMARY KEY (BatchSetRunResID);

-- Get all batch runs from the chosen labshelf
-- Analysis_S0_ABR :  Analysis_S0_All_BatchRuns
DROP TABLE Analysis_S0_ABR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABR AS
	SELECT  absr.BatchSetID,
		absr.runid,
		absr.dbms,
		absr.batchSzIncr,
		absr.duration,
		absr.BatchSetRunResID, -- primary key
		br.BatchRunResID,    -- batch run result ID
		b.batchID,
		b.MPL,		   
		br.IterNum,	     -- iteration number
		br.SumExecXacts as totalExecXacts,  -- total executed transactions
		br.SumXactProcTime as totalProcTime -- total processing delay
	FROM  Analysis_S0_ABSR absr, 	-- batchset run records
	      AZDBLab_Batch b, 		-- batch
	      AZDBLAB_BatchHasResult br	-- batch run records
	 WHERE absr.BatchSetRunResID = br.BatchSetRunResID AND -- a batchset run
	       absr.batchsetid = b.batchsetid AND -- all batches in a batchset
	       b.batchID = br.BatchID;
ALTER TABLE Analysis_S0_ABR ADD PRIMARY KEY (BatchRunResID); 

-- Get the average values on # of executed xacts and processing time
-- Analysis_S0_DBR:  Analysis_S0_Derived_Batch_Runs
DROP TABLE Analysis_S0_DBR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_DBR AS
	SELECT batchSetID, 	-- batchSetID
	       runid,   	-- runID    (key)
	       dbms,
	       batchSzIncr,
	       MPL,		-- MPL
               round(avg(totalExecXacts),2) as numExecXacts, 
	       round(avg(totalProcTime),2) as procTime,
	       round(avg(totalExecXacts/duration), 2) as tps
	FROM Analysis_S0_ABR abr
	GROUP BY BatchSetID, runid, dbms, batchSzIncr, MPL
	ORDER BY BatchSetID, runid, dbms, batchSzIncr, MPL asc;
ALTER TABLE Analysis_S0_DBR ADD PRIMARY KEY (batchSetID, runID, dbms, MPL);

-- Prepare for analysis data
-- Analysis_S0: Analysis_Step0
DROP TABLE Analysis_S0 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0  AS
	SELECT  absr.version,	    -- labshelf version
		absr.experimentid,
		absr.experimentname,
		absr.dbms,
		absr.runid,
		absr.batchSetID,
		absr.numCores,
		(absr.bufferSpace*100) as cacheSize,
		absr.duration,
		bs.XACTSZ*100 as readRowPct,
		bs.XLOCKRATIO*100 as updateRowPct,
		bs.EFFECTIVEDBSZ,
		absr.MPL,
		dbr.numExecXacts,
		dbr.procTime,
		dbr.tps
	FROM Analysis_S0_ABSR absr,
	     AZDBLab_BatchSet bs,
	     Analysis_S0_DBR dbr
	WHERE absr.batchsetID = bs.batchsetID AND
	      absr.runID      = s3.runID AND 
	      absr.batchSetID = s3.batchSetID;
ALTER TABLE Analysis_S4  ADD PRIMARY KEY (runID, batchSetID);


-- Get the average values on # of executed xacts and processing time
-- Analysis_S0_DBR:  Analysis_S0_Derived_Batch_Runs
DROP TABLE Analysis_S1_I CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_I AS
	SELECT batchSetID, 	
	       runid,   	
	       dbms,
	       sum(procTime) as sumProcTime,
	       sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then round(sum(procTime)/sum(numExecXacts),2) ELSE sum(procTime) END) as avgProcTime
--		round(sum(procTime)/sum(numExecXacts),2) as avgProcTime
	FROM Analysis_S0_DBR
	GROUP BY batchSetID, runid, dbms;
ALTER TABLE Analysis_S1_I ADD PRIMARY KEY (runID, batchSetID);

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Analysis_S2_I:  Analysis_Step2_I
DROP TABLE Analysis_S2_I CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S2_I  AS
	SELECT  prev.batchSetID,
		prev.runID,
		prev.dbms,
	        prev.MPL as thrashingPoint,
		prev.tps
	FROM Analysis_S0_DBR prev,
	     Analysis_S0_DBR next
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  and prev.tps > 1.1*next.tps 
	  and prev.tps > (SELECT max(TPS)
			  FROM Analysis_S0_DBR 
			  WHERE next.MPL < MPL);
ALTER TABLE Analysis_S2_I ADD PRIMARY KEY (batchSetID, runID);

-- Find the maximum MPL in a batchset
-- Analysis_S2_II:  Analysis_Step2_II
DROP TABLE Analysis_S2_II CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S2_II  AS
	SELECT  batchSetID,
		runID,
		dbms,
		max(thrashingPoint) as maxMPL
	FROM Analysis_S2_I s2i
	GROUP BY batchSetID, runID, dbms;
ALTER TABLE Analysis_S2_II ADD PRIMARY KEY (batchSetID, runID);

-- Combine the derived values
-- Analysis_S3:  Analysis_Step3
DROP TABLE Analysis_S3 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3  AS
	SELECT  s1i.batchSetID,
		s1i.runID,
		s1i.dbms,
		s1i.avgProcTime,
		s2ii.maxMPL
	FROM Analysis_S1_I s1i,
	     Analysis_S2_II s2ii
	WHERE s1i.runID = s2ii.runID AND 
	      s1i.batchSetID = s2ii.batchSetID;
ALTER TABLE Analysis_S3  ADD PRIMARY KEY (batchSetID, runID);

-- Generate final table
-- Analysis_S4:  Analysis_Step4
DROP TABLE Analysis_S4 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S4  AS
	SELECT  --distinct 
		absr.version,	    -- labshelf version
		absr.experimentid,
		absr.experimentname,
		absr.dbms,
		absr.runid,
		absr.batchSetID,
		absr.numCores,
		absr.bufferSpace,
		absr.duration as session_duration,
		bs.XACTSZ,
		bs.XLOCKRATIO,
		bs.EFFECTIVEDBSZ,
		s3.avgProcTime,
		s3.maxMPL
	FROM Analysis_S0_ABSR absr,
	     AZDBLab_BatchSet bs,
	     Analysis_S3 s3
	WHERE absr.batchsetID = bs.batchsetID AND
	      absr.runID      = s3.runID AND 
	      absr.batchSetID = s3.batchSetID;
ALTER TABLE Analysis_S4  ADD PRIMARY KEY (runID, batchSetID);

-- How to represent no thrashing?
-- Complete the thrashing condition by checking the highest TPS at the thrashing point still lower than any other MPL


