-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/22/14
-- Revision: 09/27/14, 09/29/14
-- Description: Define step3 queries for dropping batchsets violating sanity checks

-- Get the remaining batch executions after step2
-- Cnfm_S3_0:  Cnfm_Step3_0
DROP TABLE Cnfm_S3_0 CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_0 AS	
	SELECT s2be.dbms,
	       s2be.experimentname,
	       s2be.runid,   	
	       s2be.batchSetID, 	
	       s2be.batchSzIncr,
	       s2be.MPL,
	       COALESCE(count(s2be.iternum), 0) as numBEs,
	       avg(totalExecXacts) 		as numExecXacts, 
	       avg(totalProcTime) 		as procTime,
	       avg(totalExecXacts/ELAPSEDTIME)  as tps
	FROM Cnfm_S2_BE s2be
	GROUP BY dbms, experimentname, runid, batchsetid, batchSzIncr, MPL
	Having count(s2be.iternum) > 0;
ALTER TABLE Cnfm_S3_0 ADD PRIMARY KEY (runid, batchsetid, MPL);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S3_0';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S3_0' as stepName,
	       count(distinct batchSetID) as stepResultSize
	FROM Cnfm_S3_0
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_0' group by dbmsName
--select sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_0'

-- Step3-I: Drop batchsets that do not have all the MPLs in their batchsets
-- Select only the batchsets having every batch
-- Cnfm_S3_I:  Cnfm_Step3_I
DROP TABLE Cnfm_S3_I CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_I AS
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
	      FROM Cnfm_S3_0
	      GROUP BY dbms, experimentname, runid, batchsetid) t0,
	      Cnfm_S0_EBS t1
	WHERE t0.runid      = t1.runid
	  and t0.batchsetid = t1.batchsetid
	  -- every MPL should be retained after step2
	  and t0.numBatches = t1.numEBs;
ALTER TABLE Cnfm_S3_I ADD PRIMARY KEY (runid, BatchSetID);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S3_I';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S3_I' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM Cnfm_S3_I
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_I' group by dbmsName
--select sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_I'

-- Step3-II: Drop batchsets failing to pass sanity checks at step1-(iii)
-- Cnfm_S3_II:  Cnfm_Step3_II
DROP TABLE Cnfm_S3_II CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_II AS
	SELECT  s3i.*
	FROM Cnfm_S3_I s3i
	MINUS
	SELECT ttv.*
	FROM Cnfm_S1_TTV ttv;
ALTER TABLE Cnfm_S3_II ADD PRIMARY KEY (runid, BatchSetID);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S3_II';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S3_II' as stepName,
	       count(BatchSetID) as stepResultSize
	FROM Cnfm_S3_II
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_II' group by dbmsName
--select sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_II'


-- Cnfm_S3_II_Ext:  Cnfm_Step3_II_Extended
DROP TABLE Cnfm_S3_II_Ext CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_II_Ext AS
	SELECT t0.*
	FROM Cnfm_S3_0 t0, 
	     Cnfm_S3_I s3i
	WHERE t0.runid 	    = s3i.runid
	  and t0.batchsetid = s3i.batchsetid;
ALTER TABLE Cnfm_S3_II_Ext ADD PRIMARY KEY (runid, BatchSetID, MPL);
--select count(*) from Cnfm_S3_II_Ext

-- Cnfm_S3_BSD:  Cnfm_S3_Batchset_Details
DROP TABLE Cnfm_S3_BSD CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_BSD AS
	SELECT t0.dbms,
	       t0.experimentname,
	       t0.runid,   	-- runID   
	       t0.batchSetID, 	-- batchsetID
	       (CASE WHEN sum(t0.numExecXacts) > 0 then sum(t0.procTime)/sum(t0.numExecXacts) ELSE sum(t0.procTime) END) as avgProcTime
	FROM Cnfm_S3_0 t0, 
	     Cnfm_S3_II t1
	WHERE t0.runid = t1.runid and t0.batchsetID = t1.batchSetID
	GROUP BY t0.dbms, t0.experimentname, t0.runid, t0.batchSetID; 
ALTER TABLE Cnfm_S3_BSD ADD PRIMARY KEY (runID, batchSetID);
--select count(*) from Cnfm_S3_BSD

-- Locate an MPL value whose TPS is twice greater than that of the next MPL.
-- Cnfm_S3_TP:  Cnfm_Step3_Thrashing_Points
DROP TABLE Cnfm_S3_TP CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_TP  AS
	SELECT  prev.dbms,
	        prev.experimentname, 
		prev.runID,
		prev.batchSetID,
		prev.MPL
	FROM Cnfm_S3_II_Ext prev,
	     Cnfm_S3_II_Ext next,
	     Cnfm_TT tt
        WHERE prev.runID      = next.runID
	  and prev.batchSetID = next.batchSetID
	  and prev.MPL 	      = next.MPL-next.batchSzIncr
	  --and prev.tps > (1+tt.threshold)*next.tps 
	  and (prev.tps-tt.threshold*prev.tps) > next.tps
	  and prev.tps > (SELECT max(TPS)
			  FROM Cnfm_S3_II_Ext t0
			  WHERE t0.runID     = next.runID
			   AND t0.batchsetID = next.batchSetID
			   AND t0.MPL > next.MPL);
ALTER TABLE Cnfm_S3_TP ADD PRIMARY KEY (runID, batchSetID, MPL);

-- Determine the final thrashing point by finding the minimum MPL in a batchset
-- Paradoxically, this minimum MPL gets treated as the maximum MPL tolerated by a DBMS.
-- Cnfm_S3_FTP:  Cnfm_Step3_Final_Thrashing_Point
DROP TABLE Cnfm_S3_FTP CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_FTP  AS
	SELECT  dbms,
		experimentName,
		runID,
		batchSetID,
		min(MPL) as maxMPL
	FROM Cnfm_S3_TP s2i
	GROUP BY dbms, experimentName, runID, batchSetID;
ALTER TABLE Cnfm_S3_FTP ADD PRIMARY KEY (runID, batchSetID);

-- Get the TPS of the maximum MPL per batchset in a run
-- Cnfm_S3_FTPE:  Cnfm_Step3_Final_Thrashing_Point
DROP TABLE Cnfm_S3_FTPE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_FTPE AS
	SELECT  s3ii.dbms,
	        s3ii.experimentname,
	        s3ii.runid,   	
	        s3ii.batchSetID, 
		ftp.maxMPL,	-- thrashing point	
	        s3ii.tps,
		s3ii.numExecXacts,
		s3ii.procTime
	FROM Cnfm_S3_FTP ftp,
	     Cnfm_S3_II_Ext   s3ii
	WHERE ftp.runID	     = s3ii.runID 
	  and ftp.batchSetID = s3ii.batchSetID 
	  and ftp.maxMPL     = s3ii.MPL;
ALTER TABLE Cnfm_S3_FTPE ADD PRIMARY KEY (runID, batchSetID);
--select count(*) from Cnfm_S3_FTPE

-- Step3-III: Drop batchsets revealing transient DBMS thrashing

-- Drop transient thrashing Violations
DROP TABLE Cnfm_S3_TTV CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_TTV AS		
	SELECT distinct 
	       s3ii.dbms,
	       s3ii.experimentname,
	       s3ii.runid,   	
	       s3ii.batchSetID
	FROM Cnfm_S3_FTPE ftpe,
	     Cnfm_S3_II_Ext  s3ii
	WHERE ftpe.runid      = s3ii.runid 
          and ftpe.batchsetid = s3ii.batchsetid
	  and ftpe.maxMPL < s3ii.MPL
	  and s3ii.tps > ftpe.tps;
ALTER TABLE Cnfm_S3_TTV ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S3_TTV';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S3_TTV' as stepName,
	       COALESCE(count(*), 0) as stepResultSize
	FROM Cnfm_S3_TTV
	GROUP BY dbms, experimentname;

-- Cnfm_S3_III: Cnfm_Step3_III
DROP TABLE Cnfm_S3_III CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_III AS		
	SELECT s3ii.*
	FROM Cnfm_S3_II s3ii
	WHERE (runid, batchSetID) NOT IN (SELECT runid, batchsetID FROM Cnfm_S3_TTV);
ALTER TABLE Cnfm_S3_III ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S3_III';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S3_III' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S3_III
	GROUP BY dbms, experimentname;
--select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_III' group by dbmsName
--select sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S3_III'

-- Find a batchset that encountered thrashing
-- Cnfm_S3_TBS:  Cnfm_Step3_Thrashing_Batchset
DROP TABLE Cnfm_S3_TBS CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_TBS  AS
	SELECT  s3iii.dbms,
	        s3iii.experimentname,
		s3iii.runID,
		s3iii.batchSetID,
		ftp.maxMPL
	FROM Cnfm_S3_III s3iii,
	     Cnfm_S3_FTP ftp
	WHERE s3iii.runID = ftp.runID AND 
	      s3iii.batchSetID = ftp.batchSetID;
ALTER TABLE Cnfm_S3_TBS  ADD PRIMARY KEY (runID, batchSetID);

-- Find a batchset that showed no thrashing
-- Cnfm_S3_NBS:  Cnfm_Step3_No_Thrashing_BatchSet
DROP TABLE Cnfm_S3_NBS CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_NBS  AS
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
		FROM Cnfm_S3_III t1
		MINUS
		SELECT  t2.dbms,
			t2.experimentname,
			t2.runID,
			t2.batchSetID
		FROM Cnfm_S3_FTP t2) t0, -- Batchsets no thrashing
		Cnfm_S0_MPLEnd t3
	WHERE t0.runID = t3.runID
	  AND t0.batchSetID = t3.batchSetID;
ALTER TABLE Cnfm_S3_NBS ADD PRIMARY KEY (runID, batchSetID);
--select runid, count(*) as numThrashedBS from Cnfm_S3_TBS group by runid order by runid
--select runid, count(*) as numThrashedBS from Cnfm_S3_NBS group by runid order by runid

-- Gather batchsets with/without thrashing 
-- Cnfm_S3_UBS:  Cnfm_Step3_Union_BatchSet
DROP TABLE Cnfm_S3_UBS CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_UBS  AS
	SELECT *
	FROM Cnfm_S3_TBS
	UNION
	SELECT *
	FROM Cnfm_S3_NBS;
ALTER TABLE Cnfm_S3_UBS ADD PRIMARY KEY (runID, batchSetID);
--select sum(count(batchsetID)) from Cnfm_S3_UBS group by runid

-- Extend the measured stat of all the batchsets
-- Cnfm_S3_UBSE:  Cnfm_Step3_Union_BatchSet_Extended
DROP TABLE Cnfm_S3_UBSE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S3_UBSE  AS
	SELECT  t0.*,
		t1.avgProcTime
	FROM Cnfm_S3_UBS t0, Cnfm_S3_BSD t1
	WHERE t0.runID	    = t1.runID
	  AND t0.batchSetID = t1.batchSetID;
ALTER TABLE Cnfm_S3_UBSE ADD PRIMARY KEY (runID, batchSetID);
