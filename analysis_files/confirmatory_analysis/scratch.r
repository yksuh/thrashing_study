SELECT  abe.dbms,
	abe.runid,
	abe.BatchSetID,
	abe.MPL,		   
	abe.IterNum,
	abe.ELAPSEDTIME,	    
	abe.totalExecXacts,
	abe.totalProcTime
FROM Cnfm_S0_ABE abe 
WHERE runid = 2609 and batchsetid = 4105 and mpl = 900

select *
from Cnfm_ATP_Stat
WHERE runid = 2609 and batchsetid = 4105 and mpl = 900


SELECT  abe.dbms,
	abe.experimentname,
	abe.runid,
	abe.BatchSetID,
	abe.batchSzIncr,
        abe.MPL,		   
	abe.IterNum	     -- iteration number
FROM Cnfm_S0_ABE abe,
     Cnfm_ATP_Stat aas
WHERE abe.runid      = aas.runid 
  and abe.batchsetid = aas.batchsetid 
  and abe.MPL	     = aas.MPL
  and abe.totalExecXacts = 0 
  and aas.AvgATPtime > 0
  and aas.STDATPtime > 0
  and ((aas.AvgATPtime + 2*aas.STDATPtime) > 0 OR (aas.AvgATPtime - 2*aas.STDATPtime) < 0)
;

DBMS
--------------------------------------------------------------------------------
EXPERIMENTNAME
--------------------------------------------------------------------------------
     RUNID BATCHSETID BATCHSZINCR	 MPL	ITERNUM
---------- ---------- ----------- ---------- ----------
mysql
xt-1M-1000-120-2
      2529	 1861	      100	 900	      4

mysql
xt-1M-1000-120-2
      2529	 1861	      100	 900	      1



SELECT	dbms,
	experimentname,
	runid,
	BatchSetID,
	batchSzIncr,
        MPL,		   
	IterNum	    
from Cnfm_S1_EAV 
where runid = 2609 and batchsetid = 4105 and mpl = 900 

Cnfm_S3_0

SELECT  *  
FROM Cnfm_S3_0
WHERE runid = 2609 and batchsetid = 4105 and mpl = 900

