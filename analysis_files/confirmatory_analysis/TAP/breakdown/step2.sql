-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14, 09/27/14, 09/29/14
-- Description: Define step2 queries for batchset execution sanity checks

-- Step 2: Drop selected batch executions failing to pass saniy checks

-- Gather all the batch executions violating step 1
-- Cnfm_S1_FBE: Cnfm_S1_Failed_Batch_Execution
DROP TABLE Cnfm_S1_FBE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S1_FBE AS
	-- (1) Zero TPS violations
	SELECT ztv.dbms,
	       ztv.experimentname,
	       ztv.runid,
	       ztv.batchsetid,
	       ztv.MPL,
	       ztv.iternum
	FROM Cnfm_S1_ZTV ztv
	UNION
	-- (2) Session duration violations
	SELECT sdv.dbms,
	       sdv.experimentname,
	       sdv.runid,
	       sdv.batchsetid,
	       sdv.MPL,
	       sdv.iternum
	FROM Cnfm_S1_SDV sdv
	UNION
	-- (3) Excessive ATP time violations
	SELECT eav.dbms,
	       eav.experimentname,
	       eav.runid,
	       eav.batchsetid,
	       eav.MPL,
	       eav.iternum
	FROM  Cnfm_S1_EAV eav;
ALTER TABLE Cnfm_S1_FBE ADD PRIMARY KEY (runid, batchsetID, MPL, iternum);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S1_FBE';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S1_FBE' as stepName,
	       COUNT(*) as stepResultSize
	FROM Cnfm_S1_FBE
	GROUP BY dbms, experimentname;
--select * from Cnfm_RowCount where stepname = 'Cnfm_S1_FBE'

-- Cnfm_S2_BE: Cnfm_S2_Batch_Executions
DROP TABLE Cnfm_S2_BE CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S2_BE AS	
	SELECT abe.*
	FROM Cnfm_S0_ABE abe
	WHERE (abe.runid, abe.batchsetid, abe.MPL, abe.iternum) 
		NOT IN (SELECT runid, batchsetid, MPL, iternum FROM Cnfm_S1_FBE);
ALTER TABLE Cnfm_S2_BE ADD PRIMARY KEY (runid, batchsetid, MPL, iternum);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S2_BE';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S2_BE' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S2_BE
	GROUP BY dbms, experimentname;
--select sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S2_BE'
--select sum(stepResultSize) from Cnfm_RowCount where stepname = 'Cnfm_S0_ABE'

