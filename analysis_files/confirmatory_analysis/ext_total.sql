-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/26/14, 09/27/14
-- Description: Define step queries for analyzing DBMS thrashing

-- DBMSes participating in the analysis
-- ExtCnfm_DMD: ExtCnfm_DBMS_Metadata
DROP TABLE ExtCnfm_Dmd CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_Dmd
(
	dbmsname	VARCHAR2(10) NULL PRIMARY KEY
);
INSERT INTO ExtCnfm_Dmd VALUES ('db2');
INSERT INTO ExtCnfm_Dmd VALUES ('oracle');
INSERT INTO ExtCnfm_Dmd VALUES ('pgsql');
INSERT INTO ExtCnfm_Dmd VALUES ('mysql');
INSERT INTO ExtCnfm_Dmd VALUES ('sqlserver');
INSERT INTO ExtCnfm_Dmd VALUES ('teradata');
INSERT INTO ExtCnfm_Dmd VALUES ('javadb');

-- Create a table for chosen labshelf (Get this from GUI)
DROP TABLE ExtCnfm_LabShelf CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_LabShelf AS
	SELECT 700 AS version,	    ---- ___version___ ---	
	'azdblab_xact' AS username, ---- ___username___ ---	
	'azdblab_xact' AS password, ---- ___password___ ---
	'jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook' as connstr
	FROM Dual;
ALTER TABLE ExtCnfm_LabShelf ADD PRIMARY KEY (version);

-- Create a table for runs  (Get this from GUI)
DROP TABLE ExtCnfm_Runs CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun -- pk runs
	-- extra (3129(mysql), 3209(oracle))
	--WHERE runid IN (2309,2469,2889,2789,2809, 2069,2390,2850,2612,2649, 2229,2070,2750,2090,2409, 3009,3010,3029,3011,3150, 2289,2489,2089,2709,2049) 
	WHERE runid IN (3507,3503,3506,3508,3509, 3591,3550,3590,3551,3609, 3749,3678,3729,3676, 3689,3681,3677,3732,3679) 
	UNION
	SELECT runid 
	FROM AZDBLab_ExperimentRun  -- non pk runs
	-- extra (3171(mysql), 3109(pgsql))
	--WHERE runid IN (2389,2609,2949,2829,2909, 2249,2529,2851,2769,2669, 2349,2449,2629,2589,2410, 3089,3069,3049,3070,3189, 2369,2610,2830,2749,2269) 
	WHERE runid IN (3530,3504,3531,3589,3533, 3570,3572,3569,3571,3629, 3790,3713,3812,3710, 3711,3712,3709,3733,3680) 
	ORDER BY runid;
ALTER TABLE ExtCnfm_Runs ADD PRIMARY KEY (runid);

-- Create a table for the number of iterations (Ideally, get this from GUI)
DROP TABLE ExtCnfm_ExecCounts CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_ExecCounts AS
	--SELECT 3 AS numExecutions
	SELECT 5 AS numExecutions
	FROM Dual;
ALTER TABLE ExtCnfm_ExecCounts ADD PRIMARY KEY (numExecutions);

-- Create a table for session duration (Ideally, get this from GUI)
DROP TABLE ExtCnfm_Duration CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_Duration AS
	SELECT 120 AS period -- 120 seconds
	FROM Dual;
ALTER TABLE ExtCnfm_Duration ADD PRIMARY KEY (period);

-- Create a table for thrashing threshold 
DROP TABLE ExtCnfm_TT CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_TT AS
	SELECT 0.2 AS threshold -- 20% down
	FROM Dual;
ALTER TABLE ExtCnfm_TT ADD PRIMARY KEY (threshold);

-- Store the number of rows (step size) in a major step table/view
-- ExtCnfm_RowCount :  ExtCnfm_Row_Count
DROP TABLE ExtCnfm_RowCount CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_RowCount
(
	dbmsName	VARCHAR2(10),
	exprName	VARCHAR2(50),
	stepName	VARCHAR2(50),
	stepResultSize	NUMBER (10, 2),
        PRIMARY KEY (dbmsName, exprName, stepName) 
);

-- Get all batch set runs from the chosen labshelf
-- ExtCnfm_S0_ABSR:  ExtCnfm_S0_All_BatchSetRuns
DROP TABLE ExtCnfm_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_ABSR AS
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
		bs.SHORTTXNRATE as srtTxnRate,	 -- short transaction rate
		bsr.duration			 -- session duration
		--bsr.bufferSpace			
	 FROM  ExtCnfm_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      ExtCnfm_Runs c_run,
	      AZDBLab_BatchSet bs, 	    -- batchset
	      AZDBLab_BatchSetHasResult bsr -- batchset run record
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	       ((bs.XACTSZ = 0 and bs.XLOCKRATIO <> 0) OR (bs.XACTSZ <> 0 AND bs.XLOCKRATIO = 0)) AND
	       -- er.currentstage  ='Completed' AND
               -- er.percentage = 100 AND
	       bsr.batchsetid = bs.batchsetid;
ALTER TABLE ExtCnfm_S0_ABSR ADD PRIMARY KEY (BatchSetRunResID);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0_ABSR';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0_ABSR' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM ExtCnfm_S0_ABSR
	GROUP BY dbms, experimentname, runID;
--select dbms, runid, count(*) as numBSs from ExtCnfm_S0_ABSR group by dbms, runid
--select dbms, count(*) as numBSs from ExtCnfm_S0_ABSR group by dbms;
--select runid, BatchSetID, pctRead, pctUpdate, actRowPool from ExtCnfm_S0_ABSR where runid = 1110 order by runid
--select runid, BatchSetID, pctRead, pctUpdate, actRowPool from ExtCnfm_S0_ABSR where runid = 611 order by runid, pctread, pctupdate, actRowPool

-- Gather all the batches in the included batchsets
-- ExtCnfm_S0_AB: ExtCnfm_S0_All_Batches
DROP TABLE ExtCnfm_S0_AB CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_AB AS
    SELECT absr.dbms, 
	   absr.experimentname,
	   absr.runid, 
     	   absr.BatchSetID,
	   absr.batchSzIncr,
	   b.batchID,
	   b.MPL 
    FROM ExtCnfm_S0_ABSR absr,
	 AZDBLab_Batch b
    WHERE absr.batchsetID = b.batchsetID;
ALTER TABLE ExtCnfm_S0_AB ADD PRIMARY KEY (runid, batchsetid, batchID);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0_AB';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0_AB' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S0_AB
	GROUP BY dbms, experimentname;

-- Batch Statistics
-- Compute the total number of batches by dbms, experiment, and run
-- ExtCnfm_S0_ABS: ExtCnfm_S0_All_Batch_Stat
DROP VIEW ExtCnfm_S0_ABS CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S0_ABS AS
	SELECT ab.dbms,
	       ab.experimentName,
	       ab.runid,
	       ab.batchsetid, 
	       ab.batchSzIncr,
	       min(MPL) as startMPL,
               max(MPL) AS endMPL,
	       count(distinct batchID) AS numBs
	FROM ExtCnfm_S0_AB ab
	GROUP BY dbms, experimentName, runid, batchsetid, batchSzIncr;
ALTER VIEW ExtCnfm_S0_ABS ADD PRIMARY KEY (runid, batchsetid) DISABLE;

-- Get all batch executions from the chosen labshelf
-- ExtCnfm_S0_ABE :  ExtCnfm_S0_All_BatchRuns
DROP TABLE ExtCnfm_S0_ABE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_ABE AS
	SELECT  distinct 
		absr.dbms,	       -- dbms
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
	FROM  ExtCnfm_S0_ABSR 	     absr, 	-- batchset run records
	      ExtCnfm_S0_AB 	     ab, 	-- batch
	      AZDBLAB_BatchHasResult br		-- batch run records
	 WHERE absr.BatchSetRunResID = br.BatchSetRunResID -- a batchset run
	   AND absr.batchsetid 	     = ab.batchsetid -- all the batchsets 	
	   -- all the batches
	   AND ab.batchID 	     = br.BatchID;
ALTER TABLE ExtCnfm_S0_ABE ADD PRIMARY KEY (runid, BatchSetID, MPL, IterNum); 
--select count(*) from ExtCnfm_S0_ABE
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0_ABE';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0_ABE' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S0_ABE
	GROUP BY dbms, experimentname;

-- Executed Batch Statistics
-- Compute the total number of executed batches by dbms, experiment, and run
-- ExtCnfm_S0_EBS: ExtCnfm_S0_Executed_Batch_Stat
DROP VIEW ExtCnfm_S0_EBS CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S0_EBS AS
	SELECT abe.dbms,
	       abe.experimentName,
	       abe.runid,
	       abe.batchsetid, 
	       count(distinct abe.batchID) AS numEBs
	FROM ExtCnfm_S0_ABE abe
	GROUP BY dbms, experimentName, runid, batchsetid;
ALTER VIEW ExtCnfm_S0_EBS ADD PRIMARY KEY (runid, batchsetid) DISABLE;

-- Batch Execution statistics
-- Compute the total number of batch executions by dbms and experiment
-- ExtCnfm_S0_ABES: ExtCnfm_S0_Batch_Executions
DROP VIEW ExtCnfm_S0_ABES CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S0_ABES AS
	SELECT abe.dbms,
	       abe.experimentName,
	       abe.runid,
	       abe.batchsetid, 
	       abe.batchid,
	       abe.MPL,
	       count(distinct iternum) as numBEs
	FROM ExtCnfm_S0_ABE abe
	GROUP BY (abe.dbms, abe.experimentName, abe.runid, abe.batchsetid, abe.batchID, abe.MPL);
ALTER VIEW ExtCnfm_S0_ABES ADD PRIMARY KEY (runid, batchsetid, batchID) DISABLE;

-- Compute the total number of batches per batchset
-- ExtCnfm_S0_TNB: ExtCnfm_S0_Total_Number_of_Batches_per_batchset
DROP VIEW ExtCnfm_S0_TNB CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S0_TNB AS
	SELECT dbms,
	       experimentName,	
	       runid,
	       batchsetid,
	       sum(numBEs) AS numBEPerBS
	FROM ExtCnfm_S0_ABES
	GROUP BY dbms, experimentname,runid, batchsetid;
ALTER VIEW ExtCnfm_S0_TNB ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0_TNB';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0_TNB' as stepName,
	       sum(numBEPerBS) as stepResultSize
	FROM ExtCnfm_S0_TNB
	GROUP BY dbms, experimentname;
--select * from ExtCnfm_RowCount where stepname = 'ExtCnfm_S0_TNB'

-- Compute the total number of batches by dbms
-- ExtCnfm_S0_DTB: ExtCnfm_S0_DBMS_Total_Batches
DROP VIEW ExtCnfm_S0_DTB CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S0_DTB AS
	SELECT dbms,
	       experimentName,
	       sum(numBEs) AS numBEPerDBMS
	FROM ExtCnfm_S0_ABES
	GROUP BY dbms, experimentname;
ALTER VIEW ExtCnfm_S0_DTB ADD PRIMARY KEY (dbms) DISABLE;
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0_DTB';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0_DTB' as stepName,
	       sum(numBEPerDBMS) as stepResultSize
	FROM ExtCnfm_S0_DTB
	GROUP BY dbms, experimentname;
--select * from ExtCnfm_rowcount order by dbmsname, stepName, stepResultSize;
-- Get the total number of batch executions across DBMes
-- ExtCnfm_S0_TBE: ExtCnfm_S0_Total_Batch_Executions
DROP VIEW ExtCnfm_S0_TBE CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S0_TBE AS
	SELECT SUM(numBEPerDBMS) AS totalBEs
	FROM ExtCnfm_S0_DTB;
--select * from ExtCnfm_S0_TBE

-- Compute the maximum MPL on the raw batchsets
-- Get the average values on # of executed xacts and processing time
-- ExtCnfm_S0_DBR:  ExtCnfm_S0_Derived_Batch_Runs
DROP TABLE ExtCnfm_S0_DBR CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_DBR AS
	SELECT dbms,
	       experimentname,
	       runid,   	
	       batchSetID, 	
	       batchSzIncr,
	       MPL,		
               avg(totalExecXacts) as numExecXacts, 
	       avg(totalProcTime) as procTime,
	       avg((totalExecXacts/ELAPSEDTIME)*1000) as tps
	FROM ExtCnfm_S0_ABE abr
	GROUP BY dbms, experimentname, runid, BatchSetID, dbms, batchSzIncr, MPL
	ORDER BY dbms, experimentname, runid, BatchSetID, dbms, batchSzIncr, MPL asc;
ALTER TABLE ExtCnfm_S0_DBR ADD PRIMARY KEY (runID, batchSetID, MPL);
--select dbms, runid, batchsetID, count(MPL) from ExtCnfm_S0_DBR group by dbms, runid, batchsetID

-- Collect the last MPL tried
-- ExtCnfm_S0_MPLEnd:  ExtCnfm_Step0_MPLEnd
DROP TABLE ExtCnfm_S0_MPLEnd CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_MPLEnd  AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID    (key)
	       batchSetID, 	  -- batchSetID
	       max(MPL+batchSzIncr) as endMPL -- MPL
	FROM ExtCnfm_S0_ABE
	GROUP BY dbms, experimentname, runid, BatchSetID;
ALTER TABLE ExtCnfm_S0_MPLEnd ADD PRIMARY KEY (runID, batchsetID);
--select dbms, runid, batchsetID, endMPL from ExtCnfm_S0_MPLEnd

-- Get the average values on # of executed xacts and processing time per batchset
-- ExtCnfm_S0_BSD:  ExtCnfm_S1_Batchset_Details
DROP TABLE ExtCnfm_S0_BSD CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_BSD AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID   
	       batchSetID, 	
	       --sum(procTime) as sumProcTime,
	       --sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then sum(procTime)/sum(numExecXacts) ELSE sum(procTime) END) as avgProcTime
	FROM ExtCnfm_S0_DBR
	GROUP BY dbms, experimentname, runid, batchSetID;
ALTER TABLE ExtCnfm_S0_BSD ADD PRIMARY KEY (runID, batchSetID);
--select dbms, runid, batchsetID, avgProcTime from ExtCnfm_S0_BSD 

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- ExtCnfm_S0_TP:  ExtCnfm_Step1_Thrashing_Points
DROP TABLE ExtCnfm_S0_TP CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_TP  AS
	SELECT  prev.dbms,
	        prev.experimentname,
	        prev.runID,
		prev.batchSetID,
		prev.MPL
	FROM ExtCnfm_S0_DBR prev,
	     ExtCnfm_S0_DBR next,
	     ExtCnfm_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  --and prev.tps > (1+tt.threshold)*next.tps 
	  and (prev.tps-tt.threshold*prev.tps) > next.tps
	  and prev.tps > (SELECT max(TPS)
			  FROM ExtCnfm_S0_DBR t0
			  WHERE t0.runID = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE ExtCnfm_S0_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- ExtCnfm_S0_FTP:  ExtCnfm_Step0_Final_Thrashing_Point
DROP TABLE ExtCnfm_S0_FTP CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_FTP  AS
	SELECT  dbms,
		experimentName,
		runID,
		batchSetID,
		min(MPL) as maxMPL
	FROM ExtCnfm_S0_TP s2i
	GROUP BY dbms, experimentname, runID, batchSetID;
ALTER TABLE ExtCnfm_S0_FTP ADD PRIMARY KEY (runID, batchSetID);
--select runid, batchsetID, maxMPL from ExtCnfm_S0_FTP
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0_FTP';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0_FTP' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S0_FTP
	GROUP BY dbms, experimentname;

-- Get the TPS of the maximum MPL per batchset in a run
-- ExtCnfm_S0_FTPE:  ExtCnfm_Step0_Final_Thrashing_Point
DROP TABLE ExtCnfm_S0_FTPE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_FTPE AS
	SELECT  dbr.dbms,
	        dbr.experimentname,
	        dbr.runID,
		dbr.batchSetID,
		ftp.maxMPL,	-- thrashing point
		dbr.TPS,
		dbr.numExecXacts,
		dbr.procTime
	FROM ExtCnfm_S0_FTP ftp,
	     ExtCnfm_S0_DBR dbr
	WHERE ftp.runID	     = dbr.runID 
	  and ftp.batchSetID = dbr.batchSetID 
	  and ftp.maxMPL     = dbr.MPL;
ALTER TABLE ExtCnfm_S0_FTPE ADD PRIMARY KEY (runID, batchSetID);
--select runid, batchsetID, maxMPL from ExtCnfm_S0_FTPE

-- Find a batchset that encountered thrashing
-- ExtCnfm_S0_TBS:  ExtCnfm_Step3_Thrashing_Batchset
DROP TABLE ExtCnfm_S0_TBS CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_TBS  AS
	SELECT  bsd.dbms,
	        bsd.experimentname,
		bsd.runID,
		bsd.batchSetID,
		ftp.maxMPL
	FROM ExtCnfm_S0_BSD bsd,
	     ExtCnfm_S0_FTP ftp
	WHERE bsd.runID = ftp.runID AND 
	      bsd.batchSetID = ftp.batchSetID;
ALTER TABLE ExtCnfm_S0_TBS  ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(batchsetID) as numThrashedBS from ExtCnfm_S0_TBS group by runid order by runid

-- Find a batchset that showed no thrashing
-- ExtCnfm_S0_NBS:  ExtCnfm_Step0_No_Thrashing_BatchSet
DROP TABLE ExtCnfm_S0_NBS CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_NBS  AS
	SELECT  t0.dbms,
		t0.experimentname, 
		t0.runID,
		t0.batchSetID,
		--s1i.dbms,
		--s1i.avgProcTime,
		t3.endMPL as maxMPL
	FROM
		(SELECT  t1.dbms,
			 t1.experimentName, 
			 t1.runID,
			 t1.batchSetID
		FROM ExtCnfm_S0_BSD t1
		MINUS
		SELECT  t2.dbms,
			t2.experimentName, 
			t2.runID,
			t2.batchSetID
		FROM ExtCnfm_S0_FTP t2) t0, -- Batchsets no thrashing
		ExtCnfm_S0_MPLEnd t3
	WHERE t0.runID      = t3.runID
	  AND t0.batchSetID = t3.batchSetID;
ALTER TABLE ExtCnfm_S0_NBS ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(batchsetID) as numThrashedBS from ExtCnfm_S0_TBS group by runid order by runid
--select runid, count(batchsetID) as numThrashedBS from ExtCnfm_S0_NBS group by runid order by runid

-- Gather batchsets with/without thrashing 
-- ExtCnfm_S0_UBS:  ExtCnfm_Step0_Union_BatchSet
DROP TABLE ExtCnfm_S0_UBS CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_UBS  AS
	SELECT *
	FROM ExtCnfm_S0_TBS
	UNION
	SELECT *
	FROM ExtCnfm_S0_NBS;
ALTER TABLE ExtCnfm_S0_UBS ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(batchsetID) as numBSs from ExtCnfm_S0_UBS group by runid order by runid

-- Extend the measured stat of all the batchsets
-- ExtCnfm_S0_UBSE:  ExtCnfm_Step0_Union_BatchSet_Extended
DROP TABLE ExtCnfm_S0_UBSE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0_UBSE  AS
	SELECT  t0.*,
		t1.avgProcTime
	FROM ExtCnfm_S0_UBS t0, ExtCnfm_S0_BSD t1
	WHERE t0.runID	    = t1.runID
	  AND t0.batchSetID = t1.batchSetID;
ALTER TABLE ExtCnfm_S0_UBSE ADD PRIMARY KEY (runID, batchSetID);
-- desc ExtCnfm_S0_BSD
-- desc ExtCnfm_S0_UBS
--select runid, count(batchsetID) as numBSs from ExtCnfm_S0_UBS group by runid order by runid
--select runid, count(batchsetID) as numBSs from ExtCnfm_S0_UBSE group by runid order by runid
--select runid, count(batchsetID) as numBSs from ExtCnfm_S0_BSD group by runid order by runid

-- Step0: Report the DBMS thrashing on all the batchsets included in the chosen runs.
-- ExtCnfm_S0:  ExtCnfm_Step0_Summary
DROP TABLE ExtCnfm_S0 CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S0  AS
	SELECT  --distinct 
		--absr.version as ver,	    -- labshelf version
		absr.dbms,
		absr.experimentid,
		absr.experimentname,
		absr.runid,
		absr.batchSetID,
		(case 
       			when absr.experimentname like  '%pk%' then 1
        		else 0
       		END ) pk,
		absr.numProcessors,
		--absr.bufferSpace,
		absr.duration,
		absr.actRowPool,
		absr.pctRead,
		absr.pctUpdate,
		absr.srtTxnRate,
		ubse.avgProcTime  as ATP,
		ubse.maxMPL
	FROM ExtCnfm_S0_ABSR absr,
	     ExtCnfm_S0_UBSE ubse
	WHERE absr.runID      = ubse.runID 
	  AND absr.batchSetID = ubse.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE ExtCnfm_S0  ADD PRIMARY KEY (runID, batchSetID);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S0';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S0' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S0
	GROUP BY dbms, experimentname;
--select sum(stepResultSize) from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S0')
--select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S0') group by dbmsname
--select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S0') group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc

-- Description: Define step1 queries for experiment-wide, batch execution, and batchset execution sanity checks

-- Experiment-wide sanity checks
-- (1) Number of Missing Batches
-- Catch all missing batches per dbms per experiment
-- ExtCnfm_S1_MB_PDE : ExtCnfm_S1_Missing_Batches_Per_DBMS_Per_Experiment
DROP VIEW ExtCnfm_S1_MB_PDE CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S1_MB_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.batchsetid,
	       -- numMissingBatches = # of generated batches - # of executed batches
	       -- COALESCE because value may be NULL
	       COALESCE(((t1.endMPL-t1.startMPL)/t1.batchSzIncr+1)-t2.numEBs, 0) as numMBPerRunBatchSet -- num
	FROM  ExtCnfm_S0_ABS t1,
	      ExtCnfm_S0_EBS t2
	WHERE t1.runid	    = t2.runid and 
	      t1.batchsetid = t2.batchsetid;
ALTER VIEW ExtCnfm_S1_MB_PDE ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_MB_PDE';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_MB_PDE' as stepName,
	       SUM(numMBPerRunBatchSet) as stepResultSize
	FROM ExtCnfm_S1_MB_PDE
	GROUP BY dbms, experimentname;
--select * from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_MB_PDE'

-- (2) Number of Inconsistent Processor Configuration Violations
-- Caught when each executor gets launched 

-- (3) Number of Number of Missed Batch Executions
DROP VIEW ExtCnfm_S1_MBE_PDE CASCADE CONSTRAINTS;
CREATE VIEW ExtCnfm_S1_MBE_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.batchsetid,
	       -- numMissingBatchExecutions = number of batches * number of executions (3) - # of batch executions
	       -- COALESCE because value may be NULL
	       COALESCE(t1.numBs*t2.numExecutions-t3.numBEPerBS, 0) as numMBEPerRunBatchSet 
	FROM  ExtCnfm_S0_ABS t1,     -- batches
	      ExtCnfm_ExecCounts t2, -- number of executions
	      ExtCnfm_S0_TNB t3      -- total batch executions
	WHERE t1.runid	    = t3.runid and 
	      t1.batchsetid = t3.batchsetid;
ALTER VIEW ExtCnfm_S1_MBE_PDE ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_MBE_PDE';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_MBE_PDE' as stepName,
	       SUM(numMBEPerRunBatchSet) as stepResultSize
	FROM ExtCnfm_S1_MBE_PDE
	GROUP BY dbms, experimentname;
--select * from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_MBE_PDE'

-- (4) Number of Other Executor Violations
-- (5) Number of Other DBMS Process Violations
-- Caught when each executor gets launched 

-- Description: Define step1-(ii) queries for batch execution sanity checks

-- Batch Execution sanity checks

-- (1) Zero TPS violations
-- ExtCnfm_S1_ZTV: ExtCnfm_S1_Zero_TPS_Violations
DROP TABLE ExtCnfm_S1_ZTV CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S1_ZTV AS			
	SELECT abe.dbms,
	       abe.experimentname,
	       abe.runid,
	       abe.batchsetid,
	       abe.batchSzIncr,
	       abe.MPL,
	       abe.iternum
	FROM ExtCnfm_S0_ABE abe, 
	     ExtCnfm_S0_ABS s0abs
	WHERE abe.runid      = s0abs.runid
	  and abe.batchsetid = s0abs.batchsetid
          and abe.MPL 	     = s0abs.startMPL
	  and abe.totalExecXacts = 0;
ALTER TABLE ExtCnfm_S1_ZTV ADD PRIMARY KEY (runid, batchsetid, MPL, iternum); 
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_ZTV';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_ZTV' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S1_ZTV
	GROUP BY dbms, experimentname;
--select dbms, experimentname, avg(MPL) from ExtCnfm_S1_ZTV group by dbms, experimentname
--select dbms, experimentname, min(MPL) from ExtCnfm_S1_ZTV group by dbms, experimentname
--select * from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_ZTV'

-- (2) Session duration violations
-- ExtCnfm_S1_SDV: ExtCnfm_S1_Session_Duration_Violations
DROP TABLE ExtCnfm_S1_SDV CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S1_SDV AS			
	SELECT  abe.dbms,
		abe.experimentname,
		abe.runid,
		abe.BatchSetID,
		abe.batchSzIncr,
	        abe.MPL,		   
		abe.IterNum,	     -- iteration number
		abe.ELAPSEDTIME
	FROM ExtCnfm_S0_ABE abe,
             ExtCnfm_Duration dur
	--WHERE TRUNC(abe.ELAPSEDTIME/1000) > dur.period
	WHERE TRUNC(abe.ELAPSEDTIME/1000) > dur.period*1.01
	--WHERE TRUNC(abe.ELAPSEDTIME/1000) > dur.period*1.01
	;
ALTER TABLE ExtCnfm_S1_SDV ADD PRIMARY KEY (runid, batchsetID, MPL, IterNum); 
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_SDV';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_SDV' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S1_SDV
	GROUP BY dbms, experimentname;

--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_SDV'

-- (3) Excessive ATP time violations

-- ExtCnfm_ATP_Stat: ExtCnfm_ATP_Statistics_at_MPL
DROP TABLE ExtCnfm_ATP_Stat CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_ATP_Stat AS			
	SELECT  abe.dbms,
	        abe.experimentname,
	        abe.runid,
		abe.BatchSetID,
		abe.MPL,		   
		AVG(abe.totalProcTime / abe.totalExecXacts) as AvgATPtime,
		STDDEV(abe.totalProcTime / abe.totalExecXacts)as STDATPtime          
	FROM ExtCnfm_S0_ABE abe
	--WHERE abe.totalProcTime > 0
	WHERE abe.totalExecXacts > 0
	GROUP BY dbms, experimentName, runid, batchsetID, MPL;
ALTER TABLE ExtCnfm_ATP_Stat ADD PRIMARY KEY (runid, batchsetID, MPL); 

-- ExtCnfm_S1_EAV: ExtCnfm_S1_Excessive_ATP_time_Violations
DROP TABLE ExtCnfm_S1_EAV CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S1_EAV AS		
	SELECT  abe.dbms,
		abe.experimentname,
		abe.runid,
		abe.BatchSetID,
		abe.batchSzIncr,
	        abe.MPL,		   
		abe.IterNum	     -- iteration number
	FROM ExtCnfm_S0_ABE abe,
             ExtCnfm_ATP_Stat aas
	WHERE abe.runid      = aas.runid 
         and abe.batchsetid = aas.batchsetid 
	 and abe.MPL	     = aas.MPL
	-- ATP time greater than the average + two standard deviations
	--  and (abe.totalProcTime / abe.totalExecXacts) > (aas.AvgATPtime + 2*aas.STDATPtime)
          and abe.totalExecXacts > 0
	-- ATP time greater or less than the average from two standard deviations
	  and ((abe.totalProcTime / abe.totalExecXacts) > (aas.AvgATPtime + 2*aas.STDATPtime) OR (abe.totalProcTime / abe.totalExecXacts) < (aas.AvgATPtime - 2*aas.STDATPtime))
	UNION
	SELECT  abe.dbms,
		abe.experimentname,
		abe.runid,
		abe.BatchSetID,
		abe.batchSzIncr,
	        abe.MPL,		   
		abe.IterNum	     -- iteration number
	FROM ExtCnfm_S0_ABE abe,
             ExtCnfm_ATP_Stat aas
	WHERE abe.runid      = aas.runid 
          and abe.batchsetid = aas.batchsetid 
	  and abe.MPL	     = aas.MPL
	  and abe.totalExecXacts = 0
	  and ((aas.AvgATPtime + 2*aas.STDATPtime) > 0 OR (aas.AvgATPtime - 2*aas.STDATPtime) < 0)
	;
ALTER TABLE ExtCnfm_S1_EAV ADD PRIMARY KEY (runid, batchsetID, MPL, iternum); 
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_EAV';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_EAV' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S1_EAV
	GROUP BY dbms, experimentname;
--select dbmsname, sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_EAV' group by dbmsname
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_EAV'

-- Description: Define step1-(iii) queries for batchset execution sanity checks
-- Batchset sanity checks
-- (1) Number of Transient Thrashing Violations
DROP TABLE ExtCnfm_S1_TTV CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S1_TTV AS		
	SELECT  ftpe.dbms,
		ftpe.experimentname,
		ftpe.runid,
		ftpe.BatchSetID
	FROM ExtCnfm_S0_FTPE ftpe,
	     ExtCnfm_S0_DBR  dbr
	WHERE ftpe.runid      = dbr.runid 
          and ftpe.batchsetid = dbr.batchsetid 
	  and ftpe.maxMPL < dbr.MPL
	  and dbr.tps > ftpe.tps;
ALTER TABLE ExtCnfm_S1_TTV ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_TTV';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_TTV' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S1_TTV
	GROUP BY dbms, experimentname;
--select * from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_TTV'

-- Step 2: Drop selected batch executions failing to pass saniy checks

-- Gather all the batch executions violating step 1
-- ExtCnfm_S1_FBE: ExtCnfm_S1_Failed_Batch_Execution
DROP TABLE ExtCnfm_S1_FBE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S1_FBE AS
	-- (1) Zero TPS violations
	SELECT ztv.dbms,
	       ztv.experimentname,
	       ztv.runid,
	       ztv.batchsetid,
	       ztv.MPL,
	       ztv.iternum
	FROM ExtCnfm_S1_ZTV ztv
	UNION
	-- (2) Session duration violations
	SELECT sdv.dbms,
	       sdv.experimentname,
	       sdv.runid,
	       sdv.batchsetid,
	       sdv.MPL,
	       sdv.iternum
	FROM ExtCnfm_S1_SDV sdv
	UNION
	-- (3) Excessive ATP time violations
	SELECT eav.dbms,
	       eav.experimentname,
	       eav.runid,
	       eav.batchsetid,
	       eav.MPL,
	       eav.iternum
	FROM  ExtCnfm_S1_EAV eav;
ALTER TABLE ExtCnfm_S1_FBE ADD PRIMARY KEY (runid, batchsetID, MPL, iternum);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S1_FBE';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S1_FBE' as stepName,
	       COUNT(*) as stepResultSize
	FROM ExtCnfm_S1_FBE
	GROUP BY dbms, experimentname;
--select * from ExtCnfm_RowCount where stepname = 'ExtCnfm_S1_FBE'

-- ExtCnfm_S2_BE: ExtCnfm_S2_Batch_Executions
DROP TABLE ExtCnfm_S2_BE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S2_BE AS	
	SELECT abe.*
	FROM ExtCnfm_S0_ABE abe
	WHERE (abe.runid, abe.batchsetid, abe.MPL, abe.iternum) 
		NOT IN (SELECT runid, batchsetid, MPL, iternum FROM ExtCnfm_S1_FBE);
ALTER TABLE ExtCnfm_S2_BE ADD PRIMARY KEY (runid, batchsetid, MPL, iternum);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S2_BE';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S2_BE' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S2_BE
	GROUP BY dbms, experimentname;
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S2_BE'
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S0_ABE'

-- Description: Define step3 queries for dropping batchsets violating sanity checks

-- Get the remaining batch executions after step2
-- ExtCnfm_S3_0:  ExtCnfm_Step3_0
DROP TABLE ExtCnfm_S3_0 CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_0 AS	
	SELECT s2be.dbms,
	       s2be.experimentname,
	       s2be.runid,   	
	       s2be.batchSetID, 	
	       s2be.batchSzIncr,
	       s2be.MPL,
	       COALESCE(count(s2be.iternum), 0) as numBEs,
	       avg(totalExecXacts) 		as numExecXacts, 
	       avg(totalProcTime) 		as procTime,
	       avg(totalExecXacts/ELAPSEDTIME*1000)  as tps
	FROM ExtCnfm_S2_BE s2be
	GROUP BY dbms, experimentname, runid, batchsetid, batchSzIncr, MPL
	Having count(s2be.iternum) > 0;
ALTER TABLE ExtCnfm_S3_0 ADD PRIMARY KEY (runid, batchsetid, MPL);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S3_0';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S3_0' as stepName,
	       count(distinct batchSetID) as stepResultSize
	FROM ExtCnfm_S3_0
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_0' group by dbmsName
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_0'

-- Step3-I: Drop batchsets that do not have all the MPLs in their batchsets
-- Select only the batchsets having every batch
-- ExtCnfm_S3_I:  ExtCnfm_Step3_I
DROP TABLE ExtCnfm_S3_I CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_I AS
	SELECT t0.dbms,
	       t0.experimentName,
	       t0.runid,
	       t0.batchSetID
	FROM 
	      (SELECT dbms, -- dbms
		      experimentname,  -- experiment name
		      runid, -- runID
		      BatchSetID, -- batchset ID
		      count(MPL) as numBatches
	      FROM ExtCnfm_S3_0
	      GROUP BY dbms, experimentname, runid, batchsetid) t0,
	      ExtCnfm_S0_EBS t1
	WHERE t0.runid      = t1.runid
	  and t0.batchsetid = t1.batchsetid
	  -- every MPL should be retained after step2
	  and t0.numBatches = t1.numEBs;
ALTER TABLE ExtCnfm_S3_I ADD PRIMARY KEY (runid, BatchSetID);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S3_I';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S3_I' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM ExtCnfm_S3_I
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_I' group by dbmsName
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_I'

-- Step3-II: Drop batchsets failing to pass sanity checks at step1-(iv)
-- ExtCnfm_S3_II:  ExtCnfm_Step3_II
DROP TABLE ExtCnfm_S3_II CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_II AS
	SELECT  s3i.*
	FROM ExtCnfm_S3_I s3i
	MINUS
	SELECT ttv.*
	FROM ExtCnfm_S1_TTV ttv;
ALTER TABLE ExtCnfm_S3_II ADD PRIMARY KEY (runid, BatchSetID);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S3_II';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S3_II' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM ExtCnfm_S3_II
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_II' group by dbmsName
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_II'


-- ExtCnfm_S3_II_Ext:  ExtCnfm_Step3_II_Extended
DROP TABLE ExtCnfm_S3_II_Ext CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_II_Ext AS
	SELECT t0.*
	FROM ExtCnfm_S3_0 t0, 
	     ExtCnfm_S3_I s3i
	WHERE t0.runid 	    = s3i.runid
	  and t0.batchsetid = s3i.batchsetid;
ALTER TABLE ExtCnfm_S3_II_Ext ADD PRIMARY KEY (runid, BatchSetID, MPL);
--select count(*) from ExtCnfm_S3_II_Ext

-- ExtCnfm_S3_BSD:  ExtCnfm_S3_Batchset_Details
DROP TABLE ExtCnfm_S3_BSD CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_BSD AS
	SELECT t0.dbms,
	       t0.experimentname,
	       t0.runid,   	-- runID   
	       t0.batchSetID, 	-- batchsetID
	       (CASE WHEN sum(t0.numExecXacts) > 0 then sum(t0.procTime)/sum(t0.numExecXacts) ELSE sum(t0.procTime) END) as avgProcTime
	FROM ExtCnfm_S3_0 t0, 
	     ExtCnfm_S3_II t1
	WHERE t0.runid = t1.runid and t0.batchsetID = t1.batchSetID
	GROUP BY t0.dbms, t0.experimentname, t0.runid, t0.batchSetID; 
ALTER TABLE ExtCnfm_S3_BSD ADD PRIMARY KEY (runID, batchSetID);
--select count(*) from ExtCnfm_S3_BSD

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- ExtCnfm_S3_TP:  ExtCnfm_Step3_Thrashing_Points
DROP TABLE ExtCnfm_S3_TP CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_TP  AS
	SELECT  prev.dbms,
	        prev.experimentname, 
		prev.runID,
		prev.batchSetID,
		prev.MPL
	FROM ExtCnfm_S3_II_Ext prev,
	     ExtCnfm_S3_II_Ext next,
	     ExtCnfm_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  --and prev.tps > (1+tt.threshold)*next.tps 
	  and (prev.tps-tt.threshold*prev.tps) > next.tps
	  and prev.tps > (SELECT max(TPS)
			  FROM ExtCnfm_S3_II_Ext t0
			  WHERE t0.runID     = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE ExtCnfm_S3_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- ExtCnfm_S3_FTP:  ExtCnfm_Step3_Final_Thrashing_Point
DROP TABLE ExtCnfm_S3_FTP CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_FTP  AS
	SELECT  dbms,
		experimentName,
		runID,
		batchSetID,
		min(MPL) as maxMPL
	FROM ExtCnfm_S3_TP s2i
	GROUP BY dbms, experimentName, runID, batchSetID;
ALTER TABLE ExtCnfm_S3_FTP ADD PRIMARY KEY (runID, batchSetID);
--select dbms, count(batchSetID) from ExtCnfm_S3_FTP where maxMPL < 300 group by dbms
--select sum(count(batchSetID)) from ExtCnfm_S3_FTP where maxMPL < 300 group by dbms

-- Get the TPS of the maximum MPL per batchset in a run
-- ExtCnfm_S3_FTPE:  ExtCnfm_Step3_Final_Thrashing_Point
DROP TABLE ExtCnfm_S3_FTPE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_FTPE AS
	SELECT  s3ii.dbms,
	        s3ii.experimentname,
	        s3ii.runid,   	
	        s3ii.batchSetID, 
		ftp.maxMPL,	-- thrashing point	
	        s3ii.tps,
		s3ii.numExecXacts,
		s3ii.procTime
	FROM ExtCnfm_S3_FTP ftp,
	     ExtCnfm_S3_II_Ext   s3ii
	WHERE ftp.runID	     = s3ii.runID 
	  and ftp.batchSetID = s3ii.batchSetID 
	  and ftp.maxMPL     = s3ii.MPL;
ALTER TABLE ExtCnfm_S3_FTPE ADD PRIMARY KEY (runID, batchSetID);
--select count(*) from ExtCnfm_S3_FTPE

-- Step3-III: Drop batchsets revealing transient DBMS thrashing

-- Drop transient thrashing Violations
DROP TABLE ExtCnfm_S3_TTV CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_TTV AS		
	SELECT distinct 
	       s3ii.dbms,
	       s3ii.experimentname,
	       s3ii.runid,   	
	       s3ii.batchSetID
	FROM ExtCnfm_S3_FTPE ftpe,
	     ExtCnfm_S3_II_Ext  s3ii
	WHERE ftpe.runid      = s3ii.runid 
          and ftpe.batchsetid = s3ii.batchsetid
	  and ftpe.maxMPL < s3ii.MPL
	  and s3ii.tps > ftpe.tps;
ALTER TABLE ExtCnfm_S3_TTV ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S3_TTV';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S3_TTV' as stepName,
	       COALESCE(count(*), 0) as stepResultSize
	FROM ExtCnfm_S3_TTV
	GROUP BY dbms, experimentname;

-- ExtCnfm_S3_III: ExtCnfm_Step3_III
DROP TABLE ExtCnfm_S3_III CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_III AS		
	SELECT s3ii.*
	FROM ExtCnfm_S3_II s3ii
	WHERE (runid, batchSetID) NOT IN (SELECT runid, batchsetID FROM ExtCnfm_S3_TTV);
ALTER TABLE ExtCnfm_S3_III ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S3_III';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S3_III' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S3_III
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_III' group by dbmsName
--select sum(stepResultSize) from ExtCnfm_RowCount where stepname = 'ExtCnfm_S3_III'

-- Find a batchset that encountered thrashing
-- ExtCnfm_S3_TBS:  ExtCnfm_Step3_Thrashing_Batchset
DROP TABLE ExtCnfm_S3_TBS CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_TBS  AS
	SELECT  s3iii.dbms,
	        s3iii.experimentname,
		s3iii.runID,
		s3iii.batchSetID,
		ftp.maxMPL
	FROM ExtCnfm_S3_III s3iii,
	     ExtCnfm_S3_FTP ftp
	WHERE s3iii.runID = ftp.runID AND 
	      s3iii.batchSetID = ftp.batchSetID;
ALTER TABLE ExtCnfm_S3_TBS  ADD PRIMARY KEY (runID, batchSetID);

-- Find a batchset that showed no thrashing
-- ExtCnfm_S3_NBS:  ExtCnfm_Step3_No_Thrashing_BatchSet
DROP TABLE ExtCnfm_S3_NBS CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_NBS  AS
	SELECT  t0.dbms,
	        t0.experimentname,
	        t0.runID,
		t0.batchSetID,
		t3.endMPL as maxMPL
	FROM
		(SELECT  t1.dbms,
			 t1.experimentname,
			 t1.runID,
			 t1.batchSetID
		FROM ExtCnfm_S3_III t1
		MINUS
		SELECT  t2.dbms,
			t2.experimentname,
			t2.runID,
			t2.batchSetID
		FROM ExtCnfm_S3_FTP t2) t0, -- Batchsets no thrashing
		ExtCnfm_S0_MPLEnd t3
	WHERE t0.runID = t3.runID
	  AND t0.batchSetID = t3.batchSetID;
ALTER TABLE ExtCnfm_S3_NBS ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(*) as numThrashedBS from ExtCnfm_S3_TBS group by runid order by runid
--select runid, count(*) as numThrashedBS from ExtCnfm_S3_NBS group by runid order by runid

-- Gather batchsets with/without thrashing 
-- ExtCnfm_S3_UBS:  ExtCnfm_Step3_Union_BatchSet
DROP TABLE ExtCnfm_S3_UBS CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_UBS  AS
	SELECT *
	FROM ExtCnfm_S3_TBS
	UNION
	SELECT *
	FROM ExtCnfm_S3_NBS;
ALTER TABLE ExtCnfm_S3_UBS ADD PRIMARY KEY (runID, batchSetID);
--select sum(count(batchsetID)) from ExtCnfm_S3_UBS group by runid

-- Extend the measured stat of all the batchsets
-- ExtCnfm_S3_UBSE:  ExtCnfm_Step3_Union_BatchSet_Extended
DROP TABLE ExtCnfm_S3_UBSE CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S3_UBSE  AS
	SELECT  t0.*,
		t1.avgProcTime
	FROM ExtCnfm_S3_UBS t0, ExtCnfm_S3_BSD t1
	WHERE t0.runID	    = t1.runID
	  AND t0.batchSetID = t1.batchSetID;
ALTER TABLE ExtCnfm_S3_UBSE ADD PRIMARY KEY (runID, batchSetID);

-- Description: Define step4 queries for computing the final maxMPL on the retained batchsets

-- Step4: Report the DBMS thrashing on the retained batchsets
-- ExtCnfm_S4:  ExtCnfm_Step4
DROP TABLE ExtCnfm_S4 CASCADE CONSTRAINTS;
CREATE TABLE ExtCnfm_S4  AS
	SELECT  --distinct 
		--absr.version as ver,	    -- labshelf version
		absr.dbms,
		absr.experimentid,
		absr.experimentname,
		absr.runid,
		absr.batchSetID,
		(case 
       			when absr.experimentname like  '%pk%' then 1
        		else 0
       		END ) pk,
		absr.numProcessors,
		--absr.bufferSpace,
		absr.duration,
		absr.actRowPool,
		absr.pctRead,
		absr.pctUpdate,
		absr.srtTxnRate,
		s3ubse.avgProcTime  as ATP,
		s3ubse.maxMPL
	FROM ExtCnfm_S0_ABSR absr,
	     ExtCnfm_S3_UBSE s3ubse
	WHERE absr.runID      = s3ubse.runID 
          AND absr.batchSetID = s3ubse.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE ExtCnfm_S4  ADD PRIMARY KEY (runID, batchSetID);
DELETE FROM ExtCnfm_RowCount WHERE stepname = 'ExtCnfm_S4';
INSERT INTO ExtCnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'ExtCnfm_S4' as stepName,
	       count(*) as stepResultSize
	FROM ExtCnfm_S4
	GROUP BY dbms, experimentname;
-- select dbms, experimentname, runid, batchsetID, pk, numProcessors, actRowPool, pctRead, pctUpdate, round(ATP, 3), maxMPL from ExtCnfm_S4 order by dbms, experimentname, runID, batchsetID, numProcessors,  actRowPool, pctRead, pctUpdate
-- select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S0') group by dbmsname
-- select sum(stepResultSize) from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S4')
-- select dbmsName, sum(stepResultSize) from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S4') group by dbmsname
-- select * from ExtCnfm_RowCount order by dbmsName, exprName, stepResultSize
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from ExtCnfm_RowCount group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S0', 'ExtCnfm_S4') group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select stepName, exprName, dbmsName, sum(stepResultSize) as stepSize from ExtCnfm_RowCount where stepName IN ('ExtCnfm_S0', 'ExtCnfm_S4') group by stepName, exprName, dbmsName order by stepName, exprName, dbmsName, stepSize desc
