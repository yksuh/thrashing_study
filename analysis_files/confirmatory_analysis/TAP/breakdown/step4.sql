-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/27/14, 09/29/14
-- Description: Define step4 queries for computing the final maxMPL on the retained batchsets

-- Step4: Report the DBMS thrashing on the retained batchsets
-- Cnfm_S4:  Cnfm_Step4
DROP TABLE Cnfm_S4 CASCADE CONSTRAINTS;
CREATE TABLE Cnfm_S4  AS
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
		s3ubse.avgProcTime  as ATP,
		s3ubse.maxMPL
	FROM Cnfm_S0_ABSR absr,
	     Cnfm_S3_UBSE s3ubse
	WHERE absr.runID      = s3ubse.runID 
          AND absr.batchSetID = s3ubse.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE Cnfm_S4  ADD PRIMARY KEY (runID, batchSetID);
DELETE FROM Cnfm_RowCount WHERE stepname = 'Cnfm_S4';
INSERT INTO Cnfm_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Cnfm_S4' as stepName,
	       count(*) as stepResultSize
	FROM Cnfm_S4
	GROUP BY dbms, experimentname;
-- select dbms, experimentname, runid, batchsetID, pk, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL from Cnfm_S4 order by dbms, experimentname, runID, batchsetID, numProcessors,  actRowPool, pctRead, pctUpdate
-- select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepName IN ('Cnfm_S0') group by dbmsname
-- select dbmsName, sum(stepResultSize) from Cnfm_RowCount where stepName IN ('Cnfm_S4') group by dbmsname
-- select * from Cnfm_RowCount order by dbmsName, exprName, stepResultSize
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Cnfm_RowCount group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Cnfm_RowCount where stepName IN ('Cnfm_S0', 'Cnfm_S4') group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select stepName, exprName, dbmsName, sum(stepResultSize) as stepSize from Cnfm_RowCount where stepName IN ('Cnfm_S0', 'Cnfm_S4') group by stepName, exprName, dbmsName order by stepName, exprName, dbmsName, stepSize desc
