-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/27/14, 09/29/14
-- Description: Define step4 queries for computing the final maxMPL on the retained batchsets

-- Step4: Report the DBMS thrashing on the retained batchsets
-- Analysis_S4:  Analysis_Step4
DROP TABLE Analysis_S4 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S4  AS
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
	FROM Analysis_S0_ABSR absr,
	     Analysis_S3_UBSE s3ubse
	WHERE absr.runID      = s3ubse.runID 
          AND absr.batchSetID = s3ubse.batchSetID
	ORDER by dbms, experimentname, pk, runid, batchsetid, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL;
ALTER TABLE Analysis_S4  ADD PRIMARY KEY (runID, batchSetID);
DELETE FROM Analysis_RowCount WHERE stepname = 'Analysis_S4';
INSERT INTO Analysis_RowCount (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S4' as stepName,
	       count(*) as stepResultSize
	FROM Analysis_S4
	GROUP BY dbms, experimentname;
-- select dbms, experimentname, runid, batchsetID, pk, numProcessors, actRowPool, pctRead, pctUpdate, ATP, maxMPL from Analysis_S4 order by dbms, experimentname, runID, batchsetID, numProcessors,  actRowPool, pctRead, pctUpdate
-- select dbmsName, sum(stepResultSize) from Analysis_RowCount where stepName IN ('Analysis_S0') group by dbmsname
-- select dbmsName, sum(stepResultSize) from Analysis_RowCount where stepName IN ('Analysis_S4') group by dbmsname
-- select * from Analysis_RowCount order by dbmsName, exprName, stepResultSize
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Analysis_RowCount group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Analysis_RowCount where stepName IN ('Analysis_S0', 'Analysis_S4') group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select stepName, exprName, dbmsName, sum(stepResultSize) as stepSize from Analysis_RowCount where stepName IN ('Analysis_S0', 'Analysis_S4') group by stepName, exprName, dbmsName order by stepName, exprName, dbmsName, stepSize desc
