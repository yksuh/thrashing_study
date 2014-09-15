-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
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
	FROM AZDBLab_ExperimentRun -- 14 runs (8 runs per DBMS) 64 runs = 20% done
	WHERE runid IN (609,610,611,689,709,749,809,829,849,869,889,929,969,989,1110,1109,949,1129,1169) 
	ORDER BY runid;
ALTER TABLE Analysis_Runs ADD PRIMARY KEY (runid);

-- Create a table for the number of iterations (Ideally, get this from GUI)
DROP TABLE Analysis_Iterations CASCADE CONSTRAINTS;
CREATE TABLE Analysis_Iterations AS
	SELECT 3 AS numIters
	FROM Dual;
ALTER TABLE Analysis_Iterations ADD PRIMARY KEY (numIters);

-- Create a table for session duration (Ideally, get this from GUI)
DROP TABLE Analysis_Duration CASCADE CONSTRAINTS;
CREATE TABLE Analysis_Duration AS
	SELECT 120 AS period -- 120 seconds
	FROM Dual;
ALTER TABLE Analysis_Duration ADD PRIMARY KEY (period);

-- Store the number of rows (step size) in a major step table/view
-- Analysis_RowCount :  Analysis_Row_Count
DROP TABLE Analysis_RowCount CASCADE CONSTRAINTS;
CREATE TABLE Analysis_RowCount
(
	dbmsName	VARCHAR2(10),
	exprName	VARCHAR2(50),
	stepName	VARCHAR2(50),
	stepResultSize	NUMBER (10, 2),
        PRIMARY KEY (dbmsName, exprName, stepName) 
);

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
	SELECT  absr.dbms,
		absr.experimentname,
		absr.BatchSetID,
		absr.runid,
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

-- Get all batch runs from the chosen labshelf
-- Analysis_S0_ABR :  Analysis_S0_All_BatchRuns
DROP TABLE Analysis_S0_AB CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_AB AS
	SELECT  distinct 
		absr.dbms,
		absr.experimentname,
		absr.runid,
		absr.BatchSetID,
		b.MPL		   
	FROM  Analysis_S0_ABSR absr, 	-- batchset run records
	      AZDBLab_Batch b 		-- batch
	      -- all batches in a batchset
	 WHERE absr.batchsetid = b.batchsetid;
ALTER TABLE Analysis_S0_AB ADD PRIMARY KEY (runid, BatchSetID, MPL); 

-- Compute the total number of batches by dbms
-- Analysis_S0_DTB: Analysis_S0_DBMS_Total_Batches
DROP VIEW Analysis_S0_DTB CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_DTB AS
	SELECT dbms,
	       experimentName,
	       count(MPL) AS numBTs
	FROM Analysis_S0_BE
	GROUP BY dbms, experimentname;
ALTER VIEW Analysis_S0_DTB ADD PRIMARY KEY (dbms) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_DTB';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_DTB' as stepName,
	       totalBEs as stepResultSize
	FROM Analysis_S0_DTB
	GROUP BY dbms, experimentname;

-- Get the total number of Batches across DBMes
-- Analysis_S0_TBT: Analysis_S0_Total_BaTches
DROP VIEW Analysis_S0_TBT CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_TBT AS
	SELECT SUM(numBTs) AS totalBTs
	FROM Analysis_S0_DTB;

-- Batch Run statistics
-- Compute the total number of batch executions by dbms and experiment
-- Analysis_S0_BE: Analysis_S0_Batch_Executions
DROP VIEW Analysis_S0_BE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_BE AS
	SELECT abr.dbms,
	       abr.experimentName,
	       abr.runid,
	       abr.batchsetid, 
	       abr.mpl,
	       count(distinct iternum) as numBEs
	FROM Analysis_S0_ABR abr
	GROUP BY (abr.dbms, abr.experimentName, abr.runid, abr.batchsetid, abr.mpl);
ALTER VIEW Analysis_S0_BE ADD PRIMARY KEY (runid, batchsetid, mpl) DISABLE;

-- Compute the total number of batch executions (BEs) by dbms
-- Analysis_S0_DTBE: Analysis_S0_DBMS_Total_Batch_Executions
DROP VIEW Analysis_S0_DTBE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_DTBE AS
	SELECT dbms,
	       experimentName,
	       sum(numBEs) AS totalBEs
	FROM Analysis_S0_BE
	GROUP BY dbms, experimentname;
ALTER VIEW Analysis_S0_DTBE ADD PRIMARY KEY (dbms) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_DTBE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_DTBE' as stepName,
	       totalBEs as stepResultSize
	FROM Analysis_S0_BE
	GROUP BY dbms, experimentname;

-- Get the total number of BEs across DBMes
-- Analysis_S0_TBE: Analysis_S0_Total_Batch_Executions
DROP VIEW Analysis_S0_TBE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_TBE AS
	SELECT SUM(totalQEs) AS totalBEs
	FROM Analysis_S0_DTBE;

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
ALTER TABLE Analysis_S0_DBR ADD PRIMARY KEY (batchSetID, runID, MPL);

-- Collect the last MPL tried
-- Analysis_S0_MPLEnd:  Analysis_Step0_MPLEnd
DROP TABLE Analysis_S0_MPLEnd CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_MPLEnd  AS
	SELECT batchSetID, 	  -- batchSetID
	       runid,   	  -- runID    (key)
	       max(MPL+batchSzIncr) as endMPL -- MPL
	FROM Analysis_S0_ABR
	GROUP BY BatchSetID, runid;
ALTER TABLE Analysis_S0_MPLEnd ADD PRIMARY KEY (batchSetID, runID);

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
		--(absr.bufferSpace*100) as cacheSize,
		absr.duration,
		bs.XACTSZ*100 as readRowPct,
		bs.XLOCKRATIO*100 as updateRowPct,
		bs.EFFECTIVEDBSZ,
		dbr.MPL,
		dbr.numExecXacts,
		dbr.procTime,
		dbr.tps
	FROM Analysis_S0_ABSR absr,
	     AZDBLab_BatchSet bs,
	     Analysis_S0_DBR dbr
	WHERE absr.batchsetID = bs.batchsetID AND
	      absr.batchsetID = dbr.batchsetID AND
	      absr.runID      = dbr.runID
	Order by batchSetID, runID, MPL;
ALTER TABLE Analysis_S0 ADD PRIMARY KEY (batchSetID, runID, MPL);

-- Get the average values on # of executed xacts and processing time per batchset
-- Analysis_S0_BSD:  Analysis_S0_Batchset_Details
DROP TABLE Analysis_S0_BSD CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_BSD AS
	SELECT batchSetID, 	
	       runid,   	
	       dbms,
	       sum(procTime) as sumProcTime,
	       sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then round(sum(procTime)/sum(numExecXacts),2) ELSE sum(procTime) END) as avgProcTime
--		round(sum(procTime)/sum(numExecXacts),2) as avgProcTime
	FROM Analysis_S0_DBR
	GROUP BY batchSetID, runid, dbms;
ALTER TABLE Analysis_S0_BSD ADD PRIMARY KEY (runID, batchSetID);

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Analysis_S0_TP:  Analysis_Step0_Thrashing_Points
DROP TABLE Analysis_S0_TP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_TP  AS
	SELECT  prev.batchSetID,
		prev.runID,
		prev.dbms,
	        prev.MPL
	FROM Analysis_S0_DBR prev,
	     Analysis_S0_DBR next
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  and prev.tps > 1.2*next.tps 
	  and prev.tps > (SELECT max(TPS)
			  FROM Analysis_S0_DBR t0
			  WHERE t0.runID = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE Analysis_S0_TP ADD PRIMARY KEY (batchSetID, runID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- Analysis_S0_FTP:  Analysis_Step0_Final_Thrashing_Point
DROP TABLE Analysis_S0_FTP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_FTP  AS
	SELECT  batchSetID,
		runID,
		dbms,
		min(MPL) as maxMPL
	FROM Analysis_S0_TP s2i
	GROUP BY batchSetID, runID, dbms;
ALTER TABLE Analysis_S0_FTP ADD PRIMARY KEY (batchSetID, runID);

-- Find a batchset that encountered thrashing
-- Analysis_S0_TBS:  Analysis_Step3_Thrashing_Batchset
DROP TABLE Analysis_S0_TBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_TBS  AS
	SELECT  bsd.batchSetID,
		bsd.runID,
		ftp.maxMPL
	FROM Analysis_S0_BSD bsd,
	     Analysis_S0_FTP ftp
	WHERE bsd.runID = ftp.runID AND 
	      bsd.batchSetID = ftp.batchSetID;
ALTER TABLE Analysis_S0_TBS  ADD PRIMARY KEY (batchSetID, runID);

-- Find a batchset that showed no thrashing
-- Analysis_S0_NBS:  Analysis_Step0_No_Thrashing_BatchSet
DROP TABLE Analysis_S0_NBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_NBS  AS
	SELECT  t0.batchSetID,
		t0.runID,
		--s1i.dbms,
		--s1i.avgProcTime,
		t3.endMPL as maxMPL
	FROM
		(SELECT  t1.batchSetID,
			 t1.runID
		FROM Analysis_S0_BSD t1
		MINUS
		SELECT  t2.batchSetID,
			t2.runID
		FROM Analysis_S0_FTP t2) t0, -- Batchsets no thrashing
		Analysis_S0_MPLEnd t3
	WHERE t0.batchSetID = t3.batchSetID
	  AND t0.runID = t3.runID;
ALTER TABLE Analysis_S0_NBS ADD PRIMARY KEY (batchSetID, runID);

-- Gather batchsets with/without thrashing 
-- Analysis_S0_UBS:  Analysis_Step0_Union_BatchSet
DROP TABLE Analysis_S0_UBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_UBS  AS
	SELECT  t0.batchSetID,
		t0.runID,
		t1.dbms,
		t1.avgProcTime,
		t0.maxMPL
	FROM	
		(SELECT *
		 FROM Analysis_S0_TBS
		 UNION
		 SELECT *
		 FROM Analysis_S0_NBS) t0,
		Analysis_S0_BSD t1
	WHERE t0.batchSetID = t1.batchSetID
	  AND t0.runID	    = t1.runID;
ALTER TABLE Analysis_S0_UBS ADD PRIMARY KEY (batchSetID, runID);

-- Generate final table
-- Analysis_S0_SMR:  Analysis_Step0_Summary
DROP TABLE Analysis_S0_SMR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_SMR  AS
	SELECT  --distinct 
		absr.version as ver,	    -- labshelf version
		absr.experimentid,
		absr.experimentname as expName,
		(case 
       			when experimentname like  '%pk%' then 1
        		else 0
       		END ) pk,
		absr.dbms,
		absr.runid,
		absr.batchSetID,
		absr.numCores as nPrcs,
		absr.bufferSpace,
		absr.duration as session_duration,
		(bs.xactsz*100) as rPct,
		(bs.XLOCKRATIO*100) as uPct,
		(effectiveDBSz*100) as ARP,
		s3.avgProcTime  as ATP,
		s3.maxMPL
	FROM Analysis_S0_ABSR absr,
	     AZDBLab_BatchSet bs,
	     Analysis_S0_UBS s3
	WHERE absr.batchsetID = bs.batchsetID AND
	      absr.runID      = s3.runID AND 
	      absr.batchSetID = s3.batchSetID
	ORDER by expName asc, dbms asc, runid, nPrcs, rPct, uPct, hsr;
ALTER TABLE Analysis_S0_SMR  ADD PRIMARY KEY (runID, batchSetID);
