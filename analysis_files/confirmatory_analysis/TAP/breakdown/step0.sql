-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/26/14, 09/27/14, 09/29/14, 11/08/14
-- Description: Define step queries for confirmatory analysis

-- DBMSes participating in the analysis
-- Cnfm_DMD: Cnfm_DBMS_Metadata
DROP TABLE Cnfm_Dmd CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_Dmd
(
	dbmsname	VARCHAR2(10) NULL PRIMARY KEY
);
INSERT INTO Cnfm_Dmd VALUES ('db2');
INSERT INTO Cnfm_Dmd VALUES ('oracle');
INSERT INTO Cnfm_Dmd VALUES ('pgsql');
INSERT INTO Cnfm_Dmd VALUES ('mysql');
INSERT INTO Cnfm_Dmd VALUES ('sqlserver');
INSERT INTO Cnfm_Dmd VALUES ('teradata');
INSERT INTO Cnfm_Dmd VALUES ('javadb');

-- Create a table for chosen labshelf (Get this from GUI)
DROP TABLE Cnfm_LabShelf CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_LabShelf AS
	SELECT 700 AS version,	    ---- ___version___ ---	
	'azdblab_xact' AS username, ---- ___username___ ---	
	'azdblab_xact' AS password, ---- ___password___ ---
	'jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook' as connstr
	FROM Dual;
ALTER TABLE Cnfm_LabShelf ADD PRIMARY KEY (version);

-- Create a table for runs  (Get this from GUI)
DROP TABLE Cnfm_Runs CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_Runs AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun 
	WHERE runid IN (2389,2609,2949,2829, 2249,2529,2851,2769,2669, 2349,2449,2629,2589,2410, 2369,2610,2830,2749,2269) 
	UNION
	SELECT runid 
	FROM AZDBLab_ExperimentRun 
	WHERE runid IN (2309,2469,2889,2789,2809, 2069,2390,2850,2612,2649, 2229,2070,2750,2090,2409, 2289,2489,2089,2709,2049) 
	ORDER BY runid;
ALTER TABLE Cnfm_Runs ADD PRIMARY KEY (runid);

-- Create a table for the number of iterations (Ideally, get this from GUI)
DROP TABLE Cnfm_ExecCounts CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_ExecCounts AS
	SELECT 5 AS numExecutions
	FROM Dual;
ALTER TABLE Cnfm_ExecCounts ADD PRIMARY KEY (numExecutions);

-- Create a table for session duration (Ideally, get this from GUI)
DROP TABLE Cnfm_Duration CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_Duration AS
	SELECT 120 AS period -- 120 seconds
	FROM Dual;
ALTER TABLE Cnfm_Duration ADD PRIMARY KEY (period);

-- Create a table for thrashing threshold 
DROP TABLE Cnfm_TT CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_TT AS
	SELECT 0.2 AS threshold -- 20% down
	FROM Dual;
ALTER TABLE Cnfm_TT ADD PRIMARY KEY (threshold);

-- Store the number of rows (step size) in a major step table/view
-- Cnfm_RowCount :  Cnfm_Row_Count
DROP TABLE Cnfm_RowCount CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_RowCount
(
	dbmsName	VARCHAR2(10),
	exprName	VARCHAR2(50),
	stepName	VARCHAR2(50),
	stepResultSize	NUMBER (10, 2),
        PRIMARY KEY (dbmsName, exprName, stepName) 
);

-- Get all batch set runs from the chosen labshelf
-- Cnfm_S0_ABSR:  Cnfm_S0_All_BatchSetRuns
DROP TABLE Cnfm_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_ABSR AS
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
	 FROM  Cnfm_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      Cnfm_Runs c_run,
	      AZDBLab_BatchSet bs, 	    -- batchset
	      AZDBLab_BatchSetHasResult bsr -- batchset run record
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	       ((bs.XACTSZ = 0 and bs.XLOCKRATIO <> 0) OR (bs.XACTSZ <> 0 AND bs.XLOCKRATIO = 0)) AND
	       -- er.currentstage  ='Completed' AND
               -- er.percentage = 100 AND
	       bsr.batchsetid = bs.batchsetid;
ALTER TABLE Cnfm_S0_ABSR ADD PRIMARY KEY (BatchSetRunResID);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0_ABSR';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0_ABSR' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM Cnfm_S0_ABSR
	GROUP BY dbms, experimentname, runID;
--select dbms, runid, count(*) as numBSs from Cnfm_S0_ABSR group by dbms, runid;
--select dbms, count(*) as numBSs from Cnfm_S0_ABSR group by dbms;
--select runid, BatchSetID, pctRead, pctUpdate, actRowPool from Cnfm_S0_ABSR where runid = 1110 order by runid
--select runid, BatchSetID, pctRead, pctUpdate, actRowPool from Cnfm_S0_ABSR where runid = 611 order by runid, pctread, pctupdate, actRowPool

-- Gather all the batches in the included batchsets
-- Cnfm_S0_AB: Cnfm_S0_All_Batches
DROP TABLE Cnfm_S0_AB CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_AB AS
    SELECT absr.dbms, 
	   absr.experimentname,
	   absr.runid, 
     	   absr.BatchSetID,
	   absr.batchSzIncr,
	   b.batchID,
	   b.MPL 
    FROM Cnfm_S0_ABSR absr,
	 AZDBLab_Batch b
    WHERE absr.batchsetID = b.batchsetID;
ALTER TABLE Cnfm_S0_AB ADD PRIMARY KEY (runid, batchsetid, batchID);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0_AB';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0_AB' as stepName,
	       sum(numBs) as stepResultSize
	FROM (SELECT dbms,
 		     experimentname,
		     runID,
		     batchSetID,
	      	     count(MPL) as numBs
	      FROM Cnfm_S0_AB
	      GROUP BY dbms, experimentname, runID, batchSetID)
	GROUP BY dbms, experimentname, runID;

-- Batch Statistics
-- Compute the total number of batches by dbms, experiment, and run
-- Cnfm_S0_ABS: Cnfm_S0_All_Batch_Stat
DROP VIEW Cnfm_S0_ABS CASCADE CONSTRAINTS;
CREATE VIEW Cnfm_S0_ABS AS
	SELECT ab.dbms,
	       ab.experimentName,
	       ab.runid,
	       ab.batchsetid, 
	       ab.batchSzIncr,
	       min(MPL) as startMPL,
               max(MPL) AS endMPL,
	       count(distinct batchID) AS numBs
	FROM Cnfm_S0_AB ab
	GROUP BY dbms, experimentName, runid, batchsetid, batchSzIncr;
ALTER VIEW Cnfm_S0_ABS ADD PRIMARY KEY (runid, batchsetid) DISABLE;

-- Get all batch executions from the chosen labshelf
-- Cnfm_S0_ABE :  Cnfm_S0_All_BatchRuns
DROP TABLE Cnfm_S0_ABE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_ABE AS
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
	FROM  Cnfm_S0_ABSR 	     absr, 	-- batchset run records
	      Cnfm_S0_AB 	     ab, 	-- batch
	      AZDBLAB_BatchHasResult br		-- batch run records
	 WHERE absr.BatchSetRunResID = br.BatchSetRunResID -- a batchset run
	   AND absr.batchsetid 	     = ab.batchsetid -- all the batchsets 	
	   -- all the batches
	   AND ab.batchID 	     = br.BatchID;
ALTER TABLE Cnfm_S0_ABE ADD PRIMARY KEY (runid, BatchSetID, MPL, IterNum); 
--select count(*) from Cnfm_S0_ABE
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0_ABE';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0_ABE' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S0_ABE
	GROUP BY dbms, experimentname;

-- Executed Batch Statistics
-- Compute the total number of executed batches by dbms, experiment, and run
-- Cnfm_S0_EBS: Cnfm_S0_Executed_Batch_Stat
DROP VIEW Cnfm_S0_EBS CASCADE CONSTRAINTS;
CREATE VIEW Cnfm_S0_EBS AS
	SELECT abe.dbms,
	       abe.experimentName,
	       abe.runid,
	       abe.batchsetid, 
	       count(distinct abe.batchID) AS numEBs
	FROM Cnfm_S0_ABE abe
	GROUP BY dbms, experimentName, runid, batchsetid;
ALTER VIEW Cnfm_S0_EBS ADD PRIMARY KEY (runid, batchsetid) DISABLE;

-- Batch Execution statistics
-- Compute the total number of batch executions by dbms and experiment
-- Cnfm_S0_ABES: Cnfm_S0_Batch_Executions
DROP VIEW Cnfm_S0_ABES CASCADE CONSTRAINTS;
CREATE VIEW Cnfm_S0_ABES AS
	SELECT abe.dbms,
	       abe.experimentName,
	       abe.runid,
	       abe.batchsetid, 
	       abe.batchid,
	       abe.MPL,
	       count(distinct iternum) as numBEs
	FROM Cnfm_S0_ABE abe
	GROUP BY (abe.dbms, abe.experimentName, abe.runid, abe.batchsetid, abe.batchID, abe.MPL);
ALTER VIEW Cnfm_S0_ABES ADD PRIMARY KEY (runid, batchsetid, batchID) DISABLE;

-- Compute the total number of batches per batchset
-- Cnfm_S0_TNB: Cnfm_S0_Total_Number_of_Batches_per_batchset
DROP VIEW Cnfm_S0_TNB CASCADE CONSTRAINTS;
CREATE VIEW Cnfm_S0_TNB AS
	SELECT dbms,
	       experimentName,	
	       runid,
	       batchsetid,
	       sum(numBEs) AS numBEPerBS
	FROM Cnfm_S0_ABES
	GROUP BY dbms, experimentname,runid, batchsetid;
ALTER VIEW Cnfm_S0_TNB ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0_TNB';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0_TNB' as stepName,
	       sum(numBEPerBS) as stepResultSize
	FROM Cnfm_S0_TNB
	GROUP BY dbms, experimentname;
--select * from Cnfm_RowCount where stepname = 'Cnfm_S0_TNB'

-- Compute the total number of batches by dbms
-- Cnfm_S0_DTB: Cnfm_S0_DBMS_Total_Batches
DROP VIEW Cnfm_S0_DTB CASCADE CONSTRAINTS;
CREATE VIEW Cnfm_S0_DTB AS
	SELECT dbms,
	       experimentName,
	       sum(numBEs) AS numBEPerDBMS
	FROM Cnfm_S0_ABES
	GROUP BY dbms, experimentname;
ALTER VIEW Cnfm_S0_DTB ADD PRIMARY KEY (dbms) DISABLE;
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0_DTB';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0_DTB' as stepName,
	       sum(numBEPerDBMS) as stepResultSize
	FROM Cnfm_S0_DTB
	GROUP BY dbms, experimentname;
--select * from Cnfm_rowcount order by dbmsname, stepName, stepResultSize;
-- Get the total number of batch executions across DBMes
-- Cnfm_S0_TBE: Cnfm_S0_Total_Batch_Executions
DROP VIEW Cnfm_S0_TBE CASCADE CONSTRAINTS;
CREATE VIEW Cnfm_S0_TBE AS
	SELECT SUM(numBEPerDBMS) AS totalBEs
	FROM Cnfm_S0_DTB;
--select * from Cnfm_S0_TBE

-- Compute the maximum MPL on the raw batchsets
-- Get the average values on # of executed xacts and processing time
-- Cnfm_S0_DBR:  Cnfm_S0_Derived_Batch_Runs
DROP TABLE Cnfm_S0_DBR CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_DBR AS
	SELECT dbms,
	       experimentname,
	       runid,   	
	       batchSetID, 	
	       batchSzIncr,
	       MPL,		
               avg(totalExecXacts) as numExecXacts, 
	       avg(totalProcTime) as procTime,
	       avg(totalExecXacts/ELAPSEDTIME) as tps
	FROM Cnfm_S0_ABE abr
	GROUP BY dbms, experimentname, runid, BatchSetID, dbms, batchSzIncr, MPL
	ORDER BY dbms, experimentname, runid, BatchSetID, dbms, batchSzIncr, MPL asc;
ALTER TABLE Cnfm_S0_DBR ADD PRIMARY KEY (runID, batchSetID, MPL);
--select dbms, runid, batchsetID, count(MPL) from Cnfm_S0_DBR group by dbms, runid, batchsetID

-- Collect the last MPL tried
-- Cnfm_S0_MPLEnd:  Cnfm_Step0_MPLEnd
DROP TABLE Cnfm_S0_MPLEnd CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_MPLEnd  AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID    (key)
	       batchSetID, 	  -- batchSetID
	       max(MPL+batchSzIncr) as endMPL -- MPL
	FROM Cnfm_S0_ABE
	GROUP BY dbms, experimentname, runid, BatchSetID;
ALTER TABLE Cnfm_S0_MPLEnd ADD PRIMARY KEY (runID, batchsetID);
--select dbms, runid, batchsetID, endMPL from Cnfm_S0_MPLEnd

-- Get the average values on # of executed xacts and processing time per batchset
-- Cnfm_S0_BSD:  Cnfm_S1_Batchset_Details
DROP TABLE Cnfm_S0_BSD CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_BSD AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID   
	       batchSetID, 	
	       --sum(procTime) as sumProcTime,
	       --sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then sum(procTime)/sum(numExecXacts) ELSE sum(procTime) END) as avgProcTime
	FROM Cnfm_S0_DBR
	GROUP BY dbms, experimentname, runid, batchSetID;
ALTER TABLE Cnfm_S0_BSD ADD PRIMARY KEY (runID, batchSetID);
--select dbms, runid, batchsetID, avgProcTime from Cnfm_S0_BSD 

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Cnfm_S0_TP:  Cnfm_Step1_Thrashing_Points
DROP TABLE Cnfm_S0_TP CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_TP  AS
	SELECT  prev.dbms,
	        prev.experimentname,
	        prev.runID,
		prev.batchSetID,
		prev.MPL
	FROM Cnfm_S0_DBR prev,
	     Cnfm_S0_DBR next,
	     Cnfm_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  --and prev.tps > (1+tt.threshold)*next.tps 
	  and (prev.tps-tt.threshold*prev.tps) > next.tps
	  and prev.tps > (SELECT max(TPS)
			  FROM Cnfm_S0_DBR t0
			  WHERE t0.runID = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE Cnfm_S0_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- Cnfm_S0_FTP:  Cnfm_Step0_Final_Thrashing_Point
DROP TABLE Cnfm_S0_FTP CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_FTP  AS
	SELECT  dbms,
		experimentName,
		runID,
		batchSetID,
		min(MPL) as maxMPL
	FROM Cnfm_S0_TP s2i
	GROUP BY dbms, experimentname, runID, batchSetID;
ALTER TABLE Cnfm_S0_FTP ADD PRIMARY KEY (runID, batchSetID);
--select runid, batchsetID, maxMPL from Cnfm_S0_FTP
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0_FTP';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0_FTP' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S0
	GROUP BY dbms, experimentname;

-- Get the TPS of the maximum MPL per batchset in a run
-- Cnfm_S0_FTPE:  Cnfm_Step0_Final_Thrashing_Point
DROP TABLE Cnfm_S0_FTPE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_FTPE AS
	SELECT  dbr.dbms,
	        dbr.experimentname,
	        dbr.runID,
		dbr.batchSetID,
		ftp.maxMPL,	-- thrashing point
		dbr.TPS,
		dbr.numExecXacts,
		dbr.procTime
	FROM Cnfm_S0_FTP ftp,
	     Cnfm_S0_DBR dbr
	WHERE ftp.runID	     = dbr.runID 
	  and ftp.batchSetID = dbr.batchSetID 
	  and ftp.maxMPL     = dbr.MPL;
ALTER TABLE Cnfm_S0_FTPE ADD PRIMARY KEY (runID, batchSetID);
--select runid, batchsetID, maxMPL from Cnfm_S0_FTPE

-- Find a batchset that encountered thrashing
-- Cnfm_S0_TBS:  Cnfm_Step3_Thrashing_Batchset
DROP TABLE Cnfm_S0_TBS CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_TBS  AS
	SELECT  bsd.dbms,
	        bsd.experimentname,
		bsd.runID,
		bsd.batchSetID,
		ftp.maxMPL
	FROM Cnfm_S0_BSD bsd,
	     Cnfm_S0_FTP ftp
	WHERE bsd.runID = ftp.runID AND 
	      bsd.batchSetID = ftp.batchSetID;
ALTER TABLE Cnfm_S0_TBS  ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(batchsetID) as numThrashedBS from Cnfm_S0_TBS group by runid order by runid

-- Find a batchset that showed no thrashing
-- Cnfm_S0_NBS:  Cnfm_Step0_No_Thrashing_BatchSet
DROP TABLE Cnfm_S0_NBS CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_NBS  AS
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
		FROM Cnfm_S0_BSD t1
		MINUS
		SELECT  t2.dbms,
			t2.experimentName, 
			t2.runID,
			t2.batchSetID
		FROM Cnfm_S0_FTP t2) t0, -- Batchsets no thrashing
		Cnfm_S0_MPLEnd t3
	WHERE t0.runID      = t3.runID
	  AND t0.batchSetID = t3.batchSetID;
ALTER TABLE Cnfm_S0_NBS ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(batchsetID) as numThrashedBS from Cnfm_S0_TBS group by runid order by runid
--select runid, count(batchsetID) as numThrashedBS from Cnfm_S0_NBS group by runid order by runid

-- Gather batchsets with/without thrashing 
-- Cnfm_S0_UBS:  Cnfm_Step0_Union_BatchSet
DROP TABLE Cnfm_S0_UBS CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_UBS  AS
	SELECT *
	FROM Cnfm_S0_TBS
	UNION
	SELECT *
	FROM Cnfm_S0_NBS;
ALTER TABLE Cnfm_S0_UBS ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(batchsetID) as numBSs from Cnfm_S0_UBS group by runid order by runid

-- Extend the measured stat of all the batchsets
-- Cnfm_S0_UBSE:  Cnfm_Step0_Union_BatchSet_Extended
DROP TABLE Cnfm_S0_UBSE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0_UBSE  AS
	SELECT  t0.*,
		t1.avgProcTime
	FROM Cnfm_S0_UBS t0, Cnfm_S0_BSD t1
	WHERE t0.runID	    = t1.runID
	  AND t0.batchSetID = t1.batchSetID;
ALTER TABLE Cnfm_S0_UBSE ADD PRIMARY KEY (runID, batchSetID);
-- desc Cnfm_S0_BSD
-- desc Cnfm_S0_UBS
--select runid, count(batchsetID) as numBSs from Cnfm_S0_UBS group by runid order by runid
--select runid, count(batchsetID) as numBSs from Cnfm_S0_UBSE group by runid order by runid
--select runid, count(batchsetID) as numBSs from Cnfm_S0_BSD group by runid order by runid


-- Step0: Report the DBMS thrashing on all the batchsets included in the chosen runs.
-- Cnfm_S0:  Cnfm_Step0_Summary
DROP TABLE Cnfm_S0 CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S0  AS
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
		ubse.avgProcTime  as ATP,
		ubse.maxMPL
	FROM Cnfm_S0_ABSR absr,
	     Cnfm_S0_UBSE ubse
	WHERE absr.runID      = ubse.runID 
	  AND absr.batchSetID = ubse.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE Cnfm_S0  ADD PRIMARY KEY (runID, batchSetID);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S0';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S0' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S0
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepName IN ('Cnfm_S0') group by dbmsname
--select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Cnfm_RowCount where stepName IN ('Cnfm_S0') group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
