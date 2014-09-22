-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/22/14
-- Description: Store some extra queries that might be needed

-- Prepare for analysis data
-- Analysis_S0: Analysis_Step0
DROP TABLE Analysis_S0 CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0 AS
	SELECT  absr.version,	    -- labshelf version
		absr.experimentid,
		absr.experimentname,
		absr.dbms,
		absr.runid,
		absr.batchSetID,
		absr.numCores,
		--(absr.bufferSpace*100) as cacheSize,
		absr.duration,
		bs.XACTSZ*100 as readRowPct,
		bs.XLOCKRATIO*100 as updateRowPct,
		bs.EFFECTIVEDBSZ,
		dbr.MPL,
		dbr.numExecXacts,
		dbr.procTime,
		dbr.tps
	FROM Analysis_S0_ABSR absr,
	     AZDBLab_BatchSet bs,
	     Analysis_S0_DBR dbr
	WHERE absr.batchsetID = bs.batchsetID AND
	      absr.batchsetID = dbr.batchsetID AND
	      absr.runID      = dbr.runID
	Order by batchSetID, runID, MPL;
ALTER TABLE Analysis_S0 ADD PRIMARY KEY (batchSetID, runID, MPL);
