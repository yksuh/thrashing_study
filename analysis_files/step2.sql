-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14, 09/27/14, 09/29/14
-- Description: Define step2 queries for batchset execution sanity checks

-- Step 2: Drop selected batch executions failing to pass saniy checks

-- Gather all the batch executions violating step 1
-- Analysis_S1_FBE: Analysis_S1_Failed_Batch_Execution
DROP TABLE Analysis_S1_FBE CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_FBE AS
	-- (1) Zero TPS violations
	SELECT ztv.dbms,
	       ztv.experimentname,
	       ztv.runid,
	       ztv.batchsetid,
	       ztv.MPL,
	       ztv.iternum
	FROM Analysis_S1_ZTV ztv
	UNION
	-- (2) Session duration violations
	SELECT sdv.dbms,
	       sdv.experimentname,
	       sdv.runid,
	       sdv.batchsetid,
	       sdv.MPL,
	       sdv.iternum
	FROM Analysis_S1_SDV sdv
	UNION
	-- (3) Excessive ATP time violations
	SELECT eav.dbms,
	       eav.experimentname,
	       eav.runid,
	       eav.batchsetid,
	       eav.MPL,
	       eav.iternum
	FROM  Analysis_S1_EAV eav;
ALTER TABLE Analysis_S1_FBE ADD PRIMARY KEY (runid, batchsetID, MPL, iternum);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_FBE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_FBE' as stepName,
	       COUNT(*) as stepResultSize
	FROM Analysis_S1_FBE
	GROUP BY dbms, experimentname;
--select * from Analysis_RowCount where stepname = 'Analysis_S1_FBE'

-- Analysis_S2_BE: Analysis_S2_Batch_Executions
DROP TABLE Analysis_S2_BE CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S2_BE AS	
	SELECT abe.*
	FROM Analysis_S0_ABE abe
	WHERE (abe.runid, abe.batchsetid, abe.MPL, abe.iternum) 
		NOT IN (SELECT runid, batchsetid, MPL, iternum FROM Analysis_S1_FBE);
ALTER TABLE Analysis_S2_BE ADD PRIMARY KEY (runid, batchsetid, MPL, iternum);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S2_BE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S2_BE' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S2_BE
	GROUP BY dbms, experimentname;
--select sum(stepResultSize) from Analysis_RowCount where stepname = 'Analysis_S2_BE'
--select sum(stepResultSize) from Analysis_RowCount where stepname = 'Analysis_S0_ABE'

