-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Revision: 09/27/14
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
		(case 
       			when absr.experimentname like  '%pk%' then 1
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
		s3ubs.avgProcTime  as ATP,
		s3ubs.maxMPL
	FROM Analysis_S0_ABSR absr,
	     Analysis_S3_UBS  s3ubs
	WHERE absr.runID      = s3ubs.runID 
          AND absr.batchSetID = s3ubs.batchSetID
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
-- select * from Analysis_RowCount order by dbmsName, exprName, stepResultSize
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Analysis_RowCount group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select dbmsName, exprName, stepName, sum(stepResultSize) as stepSize from Analysis_RowCount where stepName IN ('Analysis_S0', 'Analysis_S4') group by dbmsname, exprName, stepName order by dbmsName, exprName, stepSize desc
-- select stepName, exprName, dbmsName, sum(stepResultSize) as stepSize from Analysis_RowCount where stepName IN ('Analysis_S0', 'Analysis_S4') group by stepName, exprName, dbmsName order by stepName, exprName, dbmsName, stepSize desc
