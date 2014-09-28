-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/26/14, 09/27/14
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
	--WHERE runid IN (609,610,611,689,709,749,809,829,849,869,889,929,969,989,1110,1109,949,1129,1169) 
	WHERE runid IN (689, 1291, 1610, 1749) 
	ORDER BY runid;
ALTER TABLE Analysis_Runs ADD PRIMARY KEY (runid);

-- Create a table for the number of iterations (Ideally, get this from GUI)
DROP TABLE Analysis_ExecCounts CASCADE CONSTRAINTS;
CREATE TABLE Analysis_ExecCounts AS
	SELECT 3 AS numExecutions
	FROM Dual;
ALTER TABLE Analysis_ExecCounts ADD PRIMARY KEY (numExecutions);

-- Create a table for session duration (Ideally, get this from GUI)
DROP TABLE Analysis_Duration CASCADE CONSTRAINTS;
CREATE TABLE Analysis_Duration AS
	SELECT 120 AS period -- 120 seconds
	FROM Dual;
ALTER TABLE Analysis_Duration ADD PRIMARY KEY (period);

-- Create a table for thrashing threshold 
DROP TABLE Analysis_TT CASCADE CONSTRAINTS;
CREATE TABLE Analysis_TT AS
	SELECT 0.2 AS threshold -- 20% down
	FROM Dual;
ALTER TABLE Analysis_TT ADD PRIMARY KEY (threshold);

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

-- Get all batch set runs from the chosen labshelf
-- Analysis_S0_ABSR:  Analysis_S0_All_BatchSetRuns
DROP TABLE Analysis_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABSR AS
	SELECT  c_labshelf.version,	   	 -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		er.runid,			 -- runid
		bs.BatchSetID,			 -- batchset id
		bsr.BatchSetRunResID,		 -- primary key
		bs.batchSzIncr,			 -- batch increments
		bsr.numCores as numProcessors,	 -- number of processors
		bs.EFFECTIVEDBSZ as actRowPool,  -- active row pool
		bs.XACTSZ*100 as pctRead,	 -- percentage of read
		bs.XLOCKRATIO*100 as pctUpdate,	 -- percentage of write
		bsr.duration			 -- session duration
		--bsr.bufferSpace			
	 FROM  Analysis_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      Analysis_Runs c_run,
	      AZDBLab_BatchSet bs, 	    -- batchset
	      AZDBLab_BatchSetHasResult bsr -- batchset run record
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	       -- er.currentstage  ='Completed' AND
               -- er.percentage = 100 AND
	       bsr.batchsetid = bs.batchsetid;
ALTER TABLE Analysis_S0_ABSR ADD PRIMARY KEY (BatchSetRunResID);
--select runid, count(*) from Analysis_S0_ABSR group by runid;
-- Gather all the batches in the included batchsets
-- Analysis_S0_AB: Analysis_S0_All_Batches
DROP TABLE Analysis_S0_AB CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_AB AS
    SELECT absr.dbms, 
	   absr.experimentname,
	   absr.runid, 
     	   absr.BatchSetID,
	   absr.batchSzIncr,
	   b.batchID,
	   b.MPL 
    FROM Analysis_S0_ABSR absr,
	 AZDBLab_Batch b
    WHERE absr.batchsetID = b.batchsetID;
ALTER TABLE Analysis_S0_AB ADD PRIMARY KEY (runid, batchsetid, MPL);

-- Batch Statistics
-- Compute the total number of batches by dbms, experiment, and run
-- Analysis_S0_ABS: Analysis_S0_All_Batch_Stat
DROP VIEW Analysis_S0_ABS CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_ABS AS
	SELECT ab.dbms,
	       ab.experimentName,
	       ab.runid,
	       ab.batchsetid, 
	       ab.batchSzIncr,
	       min(MPL) as startMPL,
               max(MPL) AS endMPL,
	       count(distinct batchID) AS numBs
	FROM Analysis_S0_AB ab
	GROUP BY dbms, experimentName, runid, batchsetid, batchSzIncr;
ALTER VIEW Analysis_S0_ABS ADD PRIMARY KEY (runid, batchsetid) DISABLE;

-- Get all batch executions from the chosen labshelf
-- Analysis_S0_ABE :  Analysis_S0_All_BatchRuns
DROP TABLE Analysis_S0_ABE CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABE AS
	SELECT  absr.dbms,	       -- dbms
		absr.experimentname,   -- experiment name
		absr.runid,	       -- runID
		absr.BatchSetID,       -- batchset ID
		--absr.BatchSetRunResID, -- batchset run result ID
		--br.BatchRunResID,    -- batch run result ID (batch run ID)
		absr.batchSzIncr,    -- batch increments
		ab.batchID,	     -- batchID		 
		ab.MPL,		     -- MPL
		br.IterNum,	     -- iteration number
		br.ELAPSEDTIME,	     -- batch execution elapsed time
		br.SumExecXacts as totalExecXacts,  -- total executed transactions
		br.SumXactProcTime as totalProcTime -- total processing delay
	FROM  Analysis_S0_ABSR 	     absr, 	-- batchset run records
	      Analysis_S0_AB 	     ab, 	-- batch
	      AZDBLAB_BatchHasResult br		-- batch run records
	 WHERE absr.BatchSetRunResID = br.BatchSetRunResID -- a batchset run
	   AND absr.batchsetid 	     = ab.batchsetid -- all the batchsets 	
	   -- all the batches
	   AND ab.batchID 	     = br.BatchID;
ALTER TABLE Analysis_S0_ABE ADD PRIMARY KEY (runid, BatchSetID, MPL, IterNum); 
--select count(*) from Analysis_S0_ABE

-- Executed Batch Statistics
-- Compute the total number of executed batches by dbms, experiment, and run
-- Analysis_S0_EBS: Analysis_S0_Executed_Batch_Stat
DROP VIEW Analysis_S0_EBS CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_EBS AS
	SELECT abe.dbms,
	       abe.experimentName,
	       abe.runid,
	       abe.batchsetid, 
	       count(distinct abe.batchID) AS numEBs
	FROM Analysis_S0_ABE abe
	GROUP BY dbms, experimentName, runid, batchsetid;
ALTER VIEW Analysis_S0_EBS ADD PRIMARY KEY (runid, batchsetid) DISABLE;

-- Batch Execution statistics
-- Compute the total number of batch executions by dbms and experiment
-- Analysis_S0_ABES: Analysis_S0_Batch_Executions
DROP VIEW Analysis_S0_ABES CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_ABES AS
	SELECT abe.dbms,
	       abe.experimentName,
	       abe.runid,
	       abe.batchsetid, 
	       abe.batchid,
	       abe.MPL,
	       count(distinct iternum) as numBEs
	FROM Analysis_S0_ABE abe
	GROUP BY (abe.dbms, abe.experimentName, abe.runid, abe.batchsetid, abe.batchID, abe.MPL);
ALTER VIEW Analysis_S0_ABES ADD PRIMARY KEY (runid, batchsetid, batchID) DISABLE;

-- Compute the total number of batches per batchset
-- Analysis_S0_TNB: Analysis_S0_Total_Number_of_Batches_per_batchset
DROP VIEW Analysis_S0_TNB CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_TNB AS
	SELECT dbms,
	       experimentName,	
	       runid,
	       batchsetid,
	       sum(numBEs) AS numBEPerBS
	FROM Analysis_S0_ABES
	GROUP BY dbms, experimentname,runid, batchsetid;
ALTER VIEW Analysis_S0_TNB ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_TNB';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_TNB' as stepName,
	       sum(numBEPerBS) as stepResultSize
	FROM Analysis_S0_TNB
	GROUP BY dbms, experimentname;
--select * from Analysis_RowCount where stepname = 'Analysis_S0_TNB'

-- Compute the total number of batches by dbms
-- Analysis_S0_DTB: Analysis_S0_DBMS_Total_Batches
DROP VIEW Analysis_S0_DTB CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_DTB AS
	SELECT dbms,
	       experimentName,
	       sum(numBEs) AS numBEPerDBMS
	FROM Analysis_S0_ABES
	GROUP BY dbms, experimentname;
ALTER VIEW Analysis_S0_DTB ADD PRIMARY KEY (dbms) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0_DTB';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_DTB' as stepName,
	       sum(numBEPerDBMS) as stepResultSize
	FROM Analysis_S0_DTB
	GROUP BY dbms, experimentname;
--select * from analysis_rowcount order by dbmsname, stepName, stepResultSize;
-- Get the total number of batch executions across DBMes
-- Analysis_S0_TBE: Analysis_S0_Total_Batch_Executions
DROP VIEW Analysis_S0_TBE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S0_TBE AS
	SELECT SUM(numBEPerDBMS) AS totalBEs
	FROM Analysis_S0_DTB;
--select * from Analysis_S0_TBE

-- Compute the maximum MPL on the raw batchsets
-- Get the average values on # of executed xacts and processing time
-- Analysis_S0_DBR:  Analysis_S0_Derived_Batch_Runs
DROP TABLE Analysis_S0_DBR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_DBR AS
	SELECT dbms,
	       experimentname,
	       runid,   	
	       batchSetID, 	
	       batchSzIncr,
	       MPL,		
               avg(totalExecXacts) as numExecXacts, 
	       avg(totalProcTime) as procTime,
	       avg(totalExecXacts/ELAPSEDTIME) as tps
	FROM Analysis_S0_ABE abr
	GROUP BY dbms, experimentname, runid, BatchSetID, dbms, batchSzIncr, MPL
	ORDER BY dbms, experimentname, runid, BatchSetID, dbms, batchSzIncr, MPL asc;
ALTER TABLE Analysis_S0_DBR ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Collect the last MPL tried
-- Analysis_S0_MPLEnd:  Analysis_Step0_MPLEnd
DROP TABLE Analysis_S0_MPLEnd CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_MPLEnd  AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID    (key)
	       batchSetID, 	  -- batchSetID
	       max(MPL+batchSzIncr) as endMPL -- MPL
	FROM Analysis_S0_ABE
	GROUP BY dbms, experimentname, runid, BatchSetID;
ALTER TABLE Analysis_S0_MPLEnd ADD PRIMARY KEY (runID, batchsetID);

-- Get the average values on # of executed xacts and processing time per batchset
-- Analysis_S0_BSD:  Analysis_S1_Batchset_Details
DROP TABLE Analysis_S0_BSD CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_BSD AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID   
	       batchSetID, 	
	       --sum(procTime) as sumProcTime,
	       --sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then sum(procTime)/sum(numExecXacts) ELSE sum(procTime) END) as avgProcTime
	FROM Analysis_S0_DBR
	GROUP BY dbms, experimentname, runid, batchSetID;
ALTER TABLE Analysis_S0_BSD ADD PRIMARY KEY (runID, batchSetID);

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Analysis_S0_TP:  Analysis_Step1_Thrashing_Points
DROP TABLE Analysis_S0_TP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_TP  AS
	SELECT  prev.dbms,
	        prev.experimentname,
	        prev.runID,
		prev.batchSetID,
		prev.MPL
	FROM Analysis_S0_DBR prev,
	     Analysis_S0_DBR next,
	     Analysis_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  and prev.tps > (1+tt.threshold)*next.tps 
	  and prev.tps > (SELECT max(TPS)
			  FROM Analysis_S0_DBR t0
			  WHERE t0.runID = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE Analysis_S0_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- Analysis_S0_FTP:  Analysis_Step0_Final_Thrashing_Point
DROP TABLE Analysis_S0_FTP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_FTP  AS
	SELECT  dbms,
		experimentName,
		runID,
		batchSetID,
		min(MPL) as maxMPL
	FROM Analysis_S0_TP s2i
	GROUP BY dbms, experimentname, runID, batchSetID;
ALTER TABLE Analysis_S0_FTP ADD PRIMARY KEY (runID, batchSetID);

-- Get the TPS of the maximum MPL per batchset in a run
-- Analysis_S0_FTPE:  Analysis_Step0_Final_Thrashing_Point
DROP TABLE Analysis_S0_FTPE CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_FTPE AS
	SELECT  dbr.dbms,
	        dbr.experimentname,
	        dbr.runID,
		dbr.batchSetID,
		ftp.maxMPL,	-- thrashing point
		dbr.TPS,
		dbr.numExecXacts,
		dbr.procTime
	FROM Analysis_S0_FTP ftp,
	     Analysis_S0_DBR dbr
	WHERE ftp.runID	     = dbr.runID 
	  and ftp.batchSetID = dbr.batchSetID 
	  and ftp.maxMPL     = dbr.MPL;
ALTER TABLE Analysis_S0_FTPE ADD PRIMARY KEY (runID, batchSetID);

-- Find a batchset that encountered thrashing
-- Analysis_S0_TBS:  Analysis_Step3_Thrashing_Batchset
DROP TABLE Analysis_S0_TBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_TBS  AS
	SELECT  bsd.runID,
		bsd.batchSetID,
		ftp.maxMPL
	FROM Analysis_S0_BSD bsd,
	     Analysis_S0_FTP ftp
	WHERE bsd.runID = ftp.runID AND 
	      bsd.batchSetID = ftp.batchSetID;
ALTER TABLE Analysis_S0_TBS  ADD PRIMARY KEY (runID, batchSetID);

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
ALTER TABLE Analysis_S0_NBS ADD PRIMARY KEY (runID, batchSetID);

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
ALTER TABLE Analysis_S0_UBS ADD PRIMARY KEY (runID, batchSetID);

-- Step0: Report the DBMS thrashing on all the batchsets included in the chosen runs.
-- Analysis_S0:  Analysis_Step0_Summary
DROP TABLE Analysis_S0 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0  AS
	SELECT  --distinct 
		--absr.version as ver,	    -- labshelf version
		absr.dbms,
		absr.experimentid,
		absr.experimentname,
		(case 
       			when experimentname like  '%pk%' then 1
        		else 0
       		END ) pk,
		absr.runid,
		absr.batchSetID,
		absr.numProcessors,
		--absr.bufferSpace,
		absr.duration,
		absr.actRowPool,
		absr.pctRead,
		absr.pctUpdate,
		ubs.avgProcTime  as ATP,
		ubs.maxMPL
	FROM Analysis_S0_ABSR absr,
	     Analysis_S0_UBS ubs
	WHERE absr.runID      = ubs.runID 
	  AND absr.batchSetID = ubs.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE Analysis_S0  ADD PRIMARY KEY (runID, batchSetID);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S0';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S0
	GROUP BY dbms, experimentname;
