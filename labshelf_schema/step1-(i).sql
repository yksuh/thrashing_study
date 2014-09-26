-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14
-- Description: Define step queries for experiment-wide, batch execution, and batchset execution sanity checks

-- Experiment-wide sanity checks
-- (1) Number of Missing Batches
-- Catch all missing batches per dbms per experiment
-- Analysis_S1_MB_PDE : Analysis_S1_Missing_Batches_Per_DBMS_Per_Experiment
DROP VIEW Analysis_S1_MB_PDE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S1_MB_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.batchsetid,
	       -- numMissingBatches = # of generated batches - # of executed batches
	       -- COALESCE because value may be NULL
	       COALESCE(((t1.max_mpl-t1.min_mpl)/t1.batchSzIncr+1)-t2.numEBs, 0) as numMBPerRunBatchSet -- num
	FROM  Analysis_S0_ABS t1,
	      Analysis_S0_EBS t2
	WHERE t1.runid	    = t2.runid and 
	      t1.batchsetid = t2.batchsetid;
ALTER VIEW Analysis_S1_MB_PDE ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_MB_PDE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_MB_PDE' as stepName,
	       SUM(numMBPerRunBatchSet) as stepResultSize
	FROM Analysis_S1_MB_PDE
	GROUP BY dbms, experimentname;
--select * from Analysis_RowCount where stepname = 'Analysis_S1_MB_PDE'
-- (2) Number of Inconsistent Processor Configuration Violations
-- Caught when each executor gets launched 

-- (3) Number of Number of Missed Batch Executions
DROP VIEW Analysis_S1_MBE_PDE CASCADE CONSTRAINTS;
CREATE VIEW Analysis_S1_MBE_PDE AS			
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.batchsetid,
	       -- numMissingBatchExecutions = number of batches * number of executions (3) - # of batch executions
	       -- COALESCE because value may be NULL
	       COALESCE(t1.numBs*t2.numExecutions-t3.numBEPerBS, 0) as numMBEPerRunBatchSet 
	FROM  Analysis_S0_ABS t1,     -- batches
	      Analysis_ExecCounts t2, -- number of executions
	      Analysis_S0_TBS t3      -- total batch executions
	WHERE t1.runid	    = t3.runid and 
	      t1.batchsetid = t3.batchsetid;
ALTER VIEW Analysis_S1_MBE_PDE ADD PRIMARY KEY (runid, batchsetid) DISABLE;
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_MBE_PDE';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_MBE_PDE' as stepName,
	       SUM(numMBEPerRunBatchSet) as stepResultSize
	FROM Analysis_S1_MBE_PDE
	GROUP BY dbms, experimentname;
--select * from Analysis_RowCount where stepname = 'Analysis_S1_MBE_PDE'

-- (4) Number of Other Executor Violations
-- (5) Number of Other DBMS Process Violations
-- Caught when each executor gets launched 
