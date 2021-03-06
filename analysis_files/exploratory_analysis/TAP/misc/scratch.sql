SELECT --dbms,
       --experimentname,
       runid,      
       batchSetID,    
       MPL,      
       --numExecXacts,
       --procTime,
       round(tps, 5) as tps
FROM Analysis_S0_DBR
WHERE batchsetID IN (5085, 1002)
ORDER BY dbms, batchsetID, runID, MPL

     RUNID BATCHSETID	     MPL	TPS
---------- ---------- ---------- ----------
       689	 4124	     100    7.13619
       689	 4124	     200    6.45919 v
       689	 4124	     300    2.58508
       689	 4124	     400     5.9365
       689	 4124	     500    5.92815
       689	 4124	     600    5.73933
       689	 4124	     700    5.26189
       689	 4124	     800    3.63699
       689	 4124	     900     5.1177
       689	 4124	    1000    4.38322

      1351	 8547	     100    7.63032
      1351	 8547	     200     7.0544
      1351	 8547	     300    6.66918 v
      1351	 8547	     400    4.60522
      1351	 8547	     500    6.40025
      1351	 8547	     600    3.82329
      1351	 8547	     700    4.42638
      1351	 8547	     800    5.37181
      1351	 8547	     900    3.30165
      1351	 8547	    1000     3.6053

      1289	 4124	     100     .00162
      1289	 4124	     200     .00165 v
      1289	 4124	     300     .00001
      1289	 4124	     400     .00005
      1289	 4124	     500     .00042
      1289	 4124	     600     .00033
      1289	 4124	     700     .00078
      1289	 4124	     800     .00069
      1289	 4124	     900     .00042
      1289	 4124	    1000     .00066

      1290	 8547	     100     .13138
      1290	 8547	     200     .12173
      1290	 8547	     300     .10269
      1290	 8547	     400     .10139
      1290	 8547	     500     .10408
      1290	 8547	     600     .10728
      1290	 8547	     700     .10729
      1290	 8547	     800     .10287
      1290	 8547	     900     .10668
      1290	 8547	    1000     .10489

       889	 4124	     100     .06503
       889	 4124	     200     .06209
       889	 4124	     300     .07522
       889	 4124	     400     .06865
       889	 4124	     500     .07462 v
       889	 4124	     600     .05905
       889	 4124	     700     .05384
       889	 4124	     800      .0672
       889	 4124	     900     .05736
       889	 4124	    1000     .05006

      1329	 8547	     100    3.90941
      1329	 8547	     200    3.66859
      1329	 8547	     300    3.66054
      1329	 8547	     400    3.49661
      1329	 8547	     500    3.45286
      1329	 8547	     600    4.31084
      1329	 8547	     700    5.37795
      1329	 8547	     800    5.37819
      1329	 8547	     900    5.16278
      1329	 8547	    1000    5.26383

       969	 4124	     100     .00437
       969	 4124	     200     .00425
       969	 4124	     300     .00346
       969	 4124	     400     .00367
       969	 4124	     500      .0042
       969	 4124	     600      .0034
       969	 4124	     700     .00357
       969	 4124	     800     .00365
       969	 4124	     900     .00314
       969	 4124	    1000     .00353

      1129	 8547	     100     .09022
      1129	 8547	     200      .0955
      1129	 8547	     300     .08908
      1129	 8547	     400     .08673
      1129	 8547	     500     .08582
      1129	 8547	     600     .08215
      1129	 8547	     700     .07829
      1129	 8547	     800     .07446
      1129	 8547	     900     .07257
      1129	 8547	    1000     .07174

80 rows selected.



SELECT --dbms,
       --experimentname,
       runid,      
       batchSetID,    
       maxMPL
FROM Analysis_S0_UBS
WHERE batchsetID IN (8547, 4124) 
--and dbms = 'db2'
ORDER BY dbms, batchsetID, runID
