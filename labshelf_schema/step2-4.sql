-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 09/15/14
-- Description: Define step queries for analyzing DBMS thrashing

-- Final results
select version as ver,
       experimentname as expName,
       (case 
       	when experimentname like  '%pk%' then 1
        	else 0
       END ) pk,
         dbms,
       runID,
       numCores as nCores,
       (xactsz*100) as rPct,
       (XLOCKRATIO*100) as uPct,
       (effectiveDBSz*100) as hsr,
       avgProcTime as pt,
       maxMPL
from Analysis_S0_SMR
order by expName asc, dbms asc, runID, nCores, rPct, uPct, hsr;
