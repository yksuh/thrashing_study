-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14, 09/27/14
-- Description: Define step1-(iii) queries for batchset execution sanity checks

-- Batchset sanity checks
-- (1) Number of Transient Thrashing Violations
DROP TABLE Analysis_S1_TTV CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S1_TTV AS		
	SELECT  ftpe.dbms,
		ftpe.experimentname,
		ftpe.runid,
		ftpe.BatchSetID
	FROM Analysis_S0_FTPE ftpe,
	     Analysis_S0_DBR  dbr
	WHERE ftpe.runid      = dbr.runid 
          and ftpe.batchsetid = dbr.batchsetid 
	  and ftpe.maxMPL < dbr.MPL
	  and dbr.tps > ftpe.tps;
ALTER TABLE Analysis_S1_TTV ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S1_TTV';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_TTV' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S1_TTV
	GROUP BY dbms, experimentname;
--select * from Analysis_RowCount where stepname = 'Analysis_S1_TTV'
