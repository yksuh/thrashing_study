select runID, batchSetID, MPL, numExecXacts, round(proctime, 2), tps
from analysis_s0_dbr
order by runID, batchSetID, MPL asc


-- Get all batchset runs from the chosen labshelf
-- Analysis_S0_ABSR:  Analysis_S0_All_BatchSetRuns
DROP TABLE Analysis_S0_ABSR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABSR AS
	SELECT  c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		er.runid,
		bs.BatchSetID,
		bsr.BatchSetRunResID as bsrResID,
		br.BatchRunResID AS brResID,    -- batch run result ID
		br.batchID,			-- batchID
		br.iterNum,			-- iteration number
		br.SumExecXacts as totalExecXacts,  -- total executed transactions
		br.SumXactProcTime as totalProcTime -- total processing delay
	FROM  Analysis_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      Analysis_Runs c_run,
	      AZDBLab_BatchSet bs, 
	      AZDBLab_BatchSetHasResult bsr,
	      AZDBLab_Batch b,
	      AZDBLab_BatchHasResult br
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	      -- er.currentstage  ='Completed' AND 
               -- er.percentage = 100 AND
		-- all batchsets
	       bsr.batchsetid = bs.batchsetid AND
	       
ALTER TABLE Analysis_S0_ABSR ADD PRIMARY KEY (bsrResID); 

-- Get all batch runs from the chosen labshelf
-- Analysis_S0_ABR :  Analysis_S0_All_BatchRuns
DROP TABLE Analysis_S0_ABR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABR AS
	SELECT  absr.bsrResID,			-- batchset run result ID
		br.BatchRunResID AS brResID,    -- batch run result ID
		br.batchID,			-- batchID
		br.iterNum,			-- iteration number
		br.SumExecXacts as totalExecXacts,  -- total executed transactions
		br.SumXactProcTime as totalProcTime -- total processing delay
	FROM  Analysis_S0_ABSR absr, 	 -- batchset run record
	      AZDBLab_BatchHasResult br  -- batch run record
	 WHERE absr.BatchSetRunResID = br.BatchSetRunResID AND -- a batchset run
	       
	       bsr.batchsetid = bs.batchsetid AND -- all batchsets
               bs.batchsetid  = b.batchsetid AND -- all batches in a batchset
	       -- each batch
	       br.BatchID = br.batchID; 
	       --AND er.currentstage  ='Completed' 
               --AND er.percentage = 100;
ALTER TABLE Analysis_S0_ABR ADD PRIMARY KEY (bsrResID, brResID); 

-- Get all batch runs from the chosen labshelf
-- Analysis_S0_ABR :  Analysis_S0_All_BatchRuns
DROP TABLE Analysis_S0_ABR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_ABR AS
	SELECT  c_labshelf.version,	    -- labshelf version
		ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		er.runid,
		bs.BatchSetID,
		bsr.BatchSetRunResID, -- primary key
		bs.batchSzIncr,
		bsr.duration,
		b.batchID,
		b.MPL,		   
		br.BatchRunResID,    -- batch run result ID
		br.IterNum,	     -- iteration number
		br.SumExecXacts as totalExecXacts,  -- total executed transactions
		br.SumXactProcTime as totalProcTime -- total processing delay
	FROM  Analysis_LabShelf c_labshelf,
	      AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      Analysis_Runs c_run,
	      AZDBLab_BatchSet bs, -- batchset
	      AZDBLab_Batch b,	   -- batch
	      AZDBLab_BatchSetHasResult bsr, -- batchset run record
	      AZDBLAB_BatchHasResult br	     -- batch run record
	 WHERE ex.experimentid = er.experimentid AND 
	       er.runid = c_run.runid AND 
               c_run.runid = bsr.runid AND
	       bsr.batchsetid = bs.batchsetid 	AND -- all batchsets
               bsr.BatchSetRunResID = br.BatchSetRunResID AND -- a batchset run
	       bs.batchsetid = b.batchsetid 	AND -- all batches in a batchset
	       -- each batch
	       br.BatchID = b.batchID; 
	       --AND er.currentstage  ='Completed' 
               --AND er.percentage = 100;
ALTER TABLE Analysis_S0_ABR ADD PRIMARY KEY (BatchRunResID); 

-- Get the average values on # of executed xacts and processing time
-- Analysis_S0_DBR:  Analysis_S0_Derived_Batch_Runs
DROP TABLE Analysis_S0_DBR CASCADE CONSTRAINTS;
CREATE TABLE Analysis_S0_DBR AS
	SELECT version, 
	       experimentid, 
	       experimentname, 
	       dbms, 
	       batchSzIncr,
	       runid,   	-- runID    (key)
	       batchSetID, 	-- batchSetID
	       MPL,		-- MPL
               round(avg(totalExecXacts),2) as numExecXacts, 
	       round(avg(totalProcTime),2) as procTime,
	       round(avg(totalExecXacts/duration), 2) as tps
	FROM Analysis_S0_ABR abr
	GROUP BY version, experimentid, experimentname, dbms, batchSzIncr, runid, BatchSetID, MPL
	ORDER BY version, experimentid, experimentname, dbms, batchSzIncr, runid, BatchSetID, MPL asc;
ALTER TABLE Analysis_S0_DBR ADD PRIMARY KEY (runID, batchSetID, MPL);
