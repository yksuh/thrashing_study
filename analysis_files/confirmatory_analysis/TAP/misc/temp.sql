-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14
-- Description: Define step queries for detecting DBMS thrashing on the raw data

-- Get the average values on # of executed xacts and processing time
-- Analysis_S1_DBR:  Analysis_S1_Derived_Batch_Runs
DROP TABLE Analysis_S1_DBR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_DBR AS
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
ALTER TABLE Analysis_S1_DBR ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Collect the last MPL tried
-- Analysis_S1_MPLEnd:  Analysis_Step0_MPLEnd
DROP TABLE Analysis_S1_MPLEnd CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_MPLEnd  AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID    (key)
	       batchSetID, 	  -- batchSetID
	       max(MPL+batchSzIncr) as endMPL -- MPL
	FROM Analysis_S0_ABE
	GROUP BY dbms, experimentname, runid, BatchSetID;
ALTER TABLE Analysis_S1_MPLEnd ADD PRIMARY KEY (runID, batchsetID);

-- Get the average values on # of executed xacts and processing time per batchset
-- Analysis_S1_BSD:  Analysis_S1_Batchset_Details
DROP TABLE Analysis_S1_BSD CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_BSD AS
	SELECT dbms,
	       experimentname,
	       runid,   	  -- runID   
	       batchSetID, 	
	       --sum(procTime) as sumProcTime,
	       --sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then sum(procTime)/sum(numExecXacts) ELSE sum(procTime) END) as avgProcTime
	FROM Analysis_S1_DBR
	GROUP BY dbms, experimentname, runid, batchSetID;
ALTER TABLE Analysis_S1_BSD ADD PRIMARY KEY (runID, batchSetID);

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Analysis_S1_TP:  Analysis_Step1_Thrashing_Points
DROP TABLE Analysis_S1_TP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_TP  AS
	SELECT  prev.dbms,
	        prev.experimentname,
	        prev.runID,
		prev.batchSetID,
		prev.MPL
	FROM Analysis_S1_DBR prev,
	     Analysis_S1_DBR next,
	     Analysis_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  and prev.tps > (1+tt.threshold)*next.tps 
	  and prev.tps > (SELECT max(TPS)
			  FROM Analysis_S1_DBR t0
			  WHERE t0.runID = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE Analysis_S1_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- Analysis_S1_FTP:  Analysis_Step0_Final_Thrashing_Point
DROP TABLE Analysis_S1_FTP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_FTP  AS
	SELECT  dbms,
		experimentName,
		runID,
		batchSetID,
		min(MPL) as maxMPL
	FROM Analysis_S1_TP s2i
	GROUP BY dbms, experimentname, runID, batchSetID;
ALTER TABLE Analysis_S1_FTP ADD PRIMARY KEY (runID, batchSetID);

-- Get the TPS of the maximum MPL per batchset in a run
-- Analysis_S1_FTPE:  Analysis_Step0_Final_Thrashing_Point
DROP TABLE Analysis_S1_FTPE CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_FTPE AS
	SELECT  dbr.dbms,
	        dbr.experimentname,
	        dbr.runID,
		dbr.batchSetID,
		ftp.maxMPL,	-- thrashing point
		dbr.TPS,
		dbr.numExecXacts,
		dbr.procTime
	FROM Analysis_S1_FTP ftp,
	     Analysis_S1_DBR dbr
	WHERE ftp.runID	     = dbr.runID 
	  and ftp.batchSetID = dbr.batchSetID 
	  and ftp.maxMPL     = dbr.MPL;
ALTER TABLE Analysis_S1_FTPE ADD PRIMARY KEY (runID, batchSetID);

-- Find a batchset that encountered thrashing
-- Analysis_S1_TBS:  Analysis_Step3_Thrashing_Batchset
DROP TABLE Analysis_S1_TBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_TBS  AS
	SELECT  bsd.runID,
		bsd.batchSetID,
		ftp.maxMPL
	FROM Analysis_S1_BSD bsd,
	     Analysis_S1_FTP ftp
	WHERE bsd.runID = ftp.runID AND 
	      bsd.batchSetID = ftp.batchSetID;
ALTER TABLE Analysis_S1_TBS  ADD PRIMARY KEY (runID, batchSetID);

-- Find a batchset that showed no thrashing
-- Analysis_S1_NBS:  Analysis_Step0_No_Thrashing_BatchSet
DROP TABLE Analysis_S1_NBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_NBS  AS
	SELECT  t0.batchSetID,
		t0.runID,
		--s1i.dbms,
		--s1i.avgProcTime,
		t3.endMPL as maxMPL
	FROM
		(SELECT  t1.batchSetID,
			 t1.runID
		FROM Analysis_S1_BSD t1
		MINUS
		SELECT  t2.batchSetID,
			t2.runID
		FROM Analysis_S1_FTP t2) t0, -- Batchsets no thrashing
		Analysis_S1_MPLEnd t3
	WHERE t0.batchSetID = t3.batchSetID
	  AND t0.runID = t3.runID;
ALTER TABLE Analysis_S1_NBS ADD PRIMARY KEY (runID, batchSetID);

-- Gather batchsets with/without thrashing 
-- Analysis_S1_UBS:  Analysis_Step0_Union_BatchSet
DROP TABLE Analysis_S1_UBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_UBS  AS
	SELECT  t0.batchSetID,
		t0.runID,
		t1.dbms,
		t1.avgProcTime,
		t0.maxMPL
	FROM	
		(SELECT *
		 FROM Analysis_S1_TBS
		 UNION
		 SELECT *
		 FROM Analysis_S1_NBS) t0,
		Analysis_S1_BSD t1
	WHERE t0.batchSetID = t1.batchSetID
	  AND t0.runID	    = t1.runID;
ALTER TABLE Analysis_S1_UBS ADD PRIMARY KEY (runID, batchSetID);

-- Step0: Report the DBMS thrashing on all the batchsets included in the chosen runs.
-- Analysis_S0:  Analysis_Step0_Summary
DROP TABLE Analysis_S1_SMR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_SMR  AS
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
	     Analysis_S1_UBS ubs
	WHERE absr.runID      = ubs.runID 
	  AND absr.batchSetID = ubs.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE Analysis_S1_SMR  ADD PRIMARY KEY (runID, batchSetID);
