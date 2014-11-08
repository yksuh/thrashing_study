SELECT dbms, -- dbms
      experimentname,  -- experiment name
      runid, -- runID
      BatchSetID, -- batchset ID
      count(MPL) as numBatches
FROM Analysis_S3_0
WHERE dbms = 'pgsql'
GROUP BY dbms, experimentname, runid, batchsetid

SELECT dbms, -- dbms
      experimentname,  -- experiment name
      runid, -- runID
      BatchSetID, -- batchset ID
      count(MPL) as numBatches
FROM Analysis_S3_0
WHERE dbms = 'db2'
GROUP BY dbms, experimentname, runid, batchsetid

SELECT sdv.dbms,
       sdv.experimentname,
       sdv.runid,
       sdv.batchsetid,
       sdv.MPL
FROM Analysis_S1_SDV sdv
WHERE dbms = 'pgsql'
having count(*) = 3
group by dbms, experimentname, runid, batchsetid, MPL
