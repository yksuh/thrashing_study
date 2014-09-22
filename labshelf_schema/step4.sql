-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Description: Define step4 queries for computing the final maxMPL on the retained batchsets

-- Generate final table
-- Analysis_S4_SMR:  Analysis_Step4_Summary
DROP TABLE Analysis_S4_SMR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S4_SMR  AS
	SELECT  --distinct 
		absr.version as ver,	    -- labshelf version
		absr.experimentid,
		s3.experimentname as expName,
		(case 
       			when s3iii.experimentname like  '%pk%' then 1
        		else 0
       		END ) pk,
		s3.dbms,
		s3.runid,
		s3.batchSetID,
		absr.numProcessors as nPrcs,
		--absr.bufferSpace,
		absr.duration as sess_dur,
		absr.pctRead,
		absr.pctUpdate,
		absr.actRowPool,
		s3.avgProcTime as ATPTime,
		s3.maxMPL
	FROM Analysis_S0_ABSR absr
	     Analysis_S3_UBS s3
	WHERE absr.batchsetID = s3iii.batchsetID AND
	      absr.runID      = s3iii.runID
	ORDER by expName asc, dbms asc, runid, nPrcs, pctRead, pctUpdate, actRowPool;
ALTER TABLE Analysis_S4_SMR  ADD PRIMARY KEY (runID, batchSetID);
