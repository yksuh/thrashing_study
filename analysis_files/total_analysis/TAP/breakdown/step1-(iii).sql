-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/22/14, 09/27/14
-- Description: Define step1-(iii) queries for batchset execution sanity checks

-- Batchset sanity checks
-- (1) Number of Transient Thrashing Violations
DROP TABLE Cnfm_S1_TTV CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S1_TTV AS		
	SELECT  ftpe.dbms,
		ftpe.experimentname,
		ftpe.runid,
		ftpe.BatchSetID
	FROM Cnfm_S0_FTPE ftpe,
	     Cnfm_S0_DBR  dbr
	WHERE ftpe.runid      = dbr.runid 
          and ftpe.batchsetid = dbr.batchsetid 
	  and ftpe.maxMPL < dbr.MPL
	  and dbr.tps > ftpe.tps;
ALTER TABLE Cnfm_S1_TTV ADD PRIMARY KEY (runid, BatchSetID); 
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S1_TTV';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S1_TTV' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S1_TTV
	GROUP BY dbms, experimentname;
--select * from Cnfm_RowCount where stepname = 'Cnfm_S1_TTV'
