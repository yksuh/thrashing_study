-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/22/14
-- Description: Define step3 queries for dropping batchsets violating sanity checks

-- Get the remaining batch executions after step2
-- Analysis_S3_0:  Analysis_Step3_0
DROP TABLE Analysis_S3_0 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_0 AS	
	SELECT s2be.dbms,
	       s2be.experimentname,
	       s2be.runid,   	
	       s2be.batchSetID, 	
	       s2be.MPL,
	       s2be.batchSzIncr,
	       COALESCE(count(s2be.iternum), 0) as numBEs,
	       avg(totalExecXacts) 		as numExecXacts, 
	       avg(totalProcTime) 		as procTime,
	       avg(totalExecXacts/ELAPSEDTIME)  as tps
	FROM Analysis_S2_BE s2be
	GROUP BY dbms, experimentname, runid, batchsetid, MPL
	Having count(s2be.iternum) > 0;
ALTER TABLE Analysis_S3_0 ADD PRIMARY KEY (runid, batchsetid, MPL);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S3_I';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_I' as stepName,
	       count(distinct batchSetID) as stepResultSize
	FROM Analysis_S3_0
	GROUP BY dbms, experimentname;

-- Step3-I: Drop batchsets that do not have all the MPLs in their batchsets
-- Select only the batchsets having every batch
-- Analysis_S3_I:  Analysis_Step3_I
DROP TABLE Analysis_S3_I CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_I AS
	SELECT  dbms,	       	 -- dbms
		experimentname,  -- experiment name
		runid,	         -- runID
		BatchSetID       -- batchset ID
	FROM Analysis_S3_0 s3_0,
	     Analysis_S0_EBS s0_ebs
	WHERE s3_0.runid      = s0_ebs.runid
	  and s3_0.batchsetid = s0_ebs.batchsetid
	GROUP BY dbms, experimentname, runid, batchsetid 	
	-- every MPL should be retained after step2
	Having count(MPL) = s0_ebs.numEBs
ALTER TABLE Analysis_S3_I ADD PRIMARY KEY (runid, BatchSetID, MPL);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S3_I';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_I' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM Analysis_S3_I
	GROUP BY dbms, experimentname;

-- Step3-II: Drop batchsets failing to pass sanity checks at step1-(iv)
-- Analysis_S3_II:  Analysis_Step3_II
DROP TABLE Analysis_S3_II CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_II AS
	SELECT  s3i.*
	FROM Analysis_S3_I s3i
	MINUS
	SELECT ttv.*
	FROM Analysis_S1_TTV ttv;
ALTER TABLE Analysis_S3_I ADD PRIMARY KEY (runid, BatchSetID, MPL);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S3_II';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_II' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM Analysis_S3_II
	GROUP BY dbms, experimentname;

-- Analysis_S3_BSD:  Analysis_S3_Batchset_Details
DROP TABLE Analysis_S3_BSD CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_BSD AS
	SELECT dbms,
	       experimentname,
	       runid,   	-- runID   
	       batchSetID, 	-- batchsetID
	       sum(procTime) as sumProcTime,
	       sum(numExecXacts) as sumExecXacts,
	       (CASE WHEN sum(numExecXacts) > 0 then sum(procTime)/sum(numExecXacts) ELSE sum(procTime) END) as avgProcTime
	FROM Analysis_S3_II
	GROUP BY batchSetID, runid, dbms;
ALTER TABLE Analysis_S3_BSD ADD PRIMARY KEY (runID, batchSetID);

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Analysis_S3_TP:  Analysis_Step3_Thrashing_Points
DROP TABLE Analysis_S3_TP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_TP  AS
	SELECT  prev.runID,
		prev.batchSetID,
		prev.dbms,
	        prev.MPL
	FROM Analysis_S3_II prev,
	     Analysis_S3_II next,
	     Analysis_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  and prev.tps > (1+tt.threshold)*next.tps 
	  and prev.tps > (SELECT max(TPS)
			  FROM Analysis_S3_II t0
			  WHERE t0.runID     = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE Analysis_S3_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- Analysis_S3_FTP:  Analysis_Step3_Final_Thrashing_Point
DROP TABLE Analysis_S3_FTP CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_FTP  AS
	SELECT  batchSetID,
		runID,
		min(MPL) as maxMPL
	FROM Analysis_S3_TP s2i
	GROUP BY batchSetID, runID, dbms;
ALTER TABLE Analysis_S3_FTP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Get the TPS of the maximum MPL per batchset in a run
-- Analysis_S3_FTPE:  Analysis_Step3_Final_Thrashing_Point
DROP TABLE Analysis_S3_FTPE CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_FTPE AS
	SELECT  s3ii.dbms,
	        s3ii.experimentname,
	        s3ii.runid,   	
	        s3ii.batchSetID, 	
	        s3ii.numExecXacts,
		s3ii.procTime,
		s3ii.tps,
	        ftp.maxMPL,	-- thrashing point
	FROM Analysis_S3_FTP ftp,
	     Analysis_S3_II   s3ii
	WHERE ftp.runID	     = s3ii.runID 
	  and ftp.batchSetID = s3ii.batchSetID 
	  and ftp.maxMPL     = s3ii.MPL;
ALTER TABLE Analysis_S3_FTP ADD PRIMARY KEY (runID, batchSetID, maxMPL);

-- Step3-III: Drop batchsets revealing transient DBMS thrashing
-- Drop transient thrashing Violations
DROP TABLE Analysis_S3_III CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_III AS		
	SELECT distinct 
	       s3ii.*
	FROM Analysis_S3_FTPE ftpe,
	     Analysis_S3_II  s3ii,
	     Analysis_S3_0   s3_0
	WHERE ftpe.runid      = s3ii.runid 
          and ftpe.batchsetid = s3ii.batchsetid 
	  and s3ii.runid      = s3_0.runid
	  and s3ii.batchsetid = s3_0.batchsetid
	  and ftpe.maxMPL < s3_0.MPL
	  and ftpe.tps > s3_0.tps;
ALTER TABLE Analysis_S3_III ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S3_III';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_III' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S3_III
	GROUP BY dbms, experimentname;

-- Find a batchset that showed no thrashing
-- Analysis_S3_NBS:  Analysis_Step3_No_Thrashing_BatchSet
DROP TABLE Analysis_S3_NBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_NBS  AS
	SELECT  t0.batchSetID,
		t0.runID,
		t3.endMPL as maxMPL
	FROM
		(SELECT  t1.batchSetID,
			 t1.runID
		FROM Analysis_S3_BSD t1
		MINUS
		SELECT  t2.batchSetID,
			t2.runID
		FROM Analysis_S3_FTP t2) t0, -- Batchsets no thrashing
		Analysis_S1_MPLEnd t3
	WHERE t0.batchSetID = t3.batchSetID
	  AND t0.runID = t3.runID;
ALTER TABLE Analysis_S3_NBS ADD PRIMARY KEY (batchSetID, runID);

-- Gather batchsets with/without thrashing 
-- Analysis_S3_UBS:  Analysis_Step3_Union_BatchSet
DROP TABLE Analysis_S3_UBS CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S3_UBS  AS
	SELECT  t1.dbms,
		t1.experimentname,
	        t0.runID,
		t0.batchSetID,
		t1.avgProcTime,
		t0.maxMPL
	FROM	
		(SELECT *
		 FROM Analysis_S3_FTP -- thrashing batchsets
		 UNION
		 SELECT *
		 FROM Analysis_S3_NBS) t0,
		Analysis_S3_BSD t1
	WHERE t0.runID	    = t1.runID
	  AND t0.batchSetID = t1.batchSetID;
ALTER TABLE Analysis_S3_UBS ADD PRIMARY KEY (runID, batchSetID);
