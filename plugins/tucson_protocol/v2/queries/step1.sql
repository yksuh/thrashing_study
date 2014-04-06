DROP VIEW __Analysis_S1_QEA_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_QEA_Ver1__ AS
	SELECT qe.dbms,
	       qe.experimentName,
	       qe.runid,
	       qe.querynum,
	       qe.card,
	       qe.measured_time,
	       qea.*
	FROM __Analysis_S1_VQE_Ver1__ qe,
	     AZDBLab_QueryStatEvaluation qea  
	WHERE qe.qeid = qea.queryexecutionid;	
ALTER VIEW __Analysis_S1_QEA_Ver1__ ADD PRIMARY KEY (queryexecutionid) DISABLE;
DROP VIEW __Analysis_S1_TQE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_TQE_Ver1__ AS
	SELECT count(*) AS totalQEs
	FROM __Analysis_S1_VQE_Ver1__;

DROP VIEW __Analysis_S1_QatC_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_QatC_Ver1__ AS
	SELECT DISTINCT dbms,
	       		experimentName,
	 	        runid,
		        querynum,
		        card
	FROM  __Analysis_S1_VQE_Ver1__;
ALTER VIEW __Analysis_S1_QatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card) DISABLE;
DROP VIEW __Analysis_S1_TQC_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_TQC_Ver1__ AS
	SELECT count(*) AS totalQatCs
	FROM __Analysis_S1_QatC_Ver1__;

DROP VIEW __Analysis_S1_MQ_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_MQ_PDE_Ver1__ AS			
	SELECT dbms, 
	       experimentname,
	       runid,
	       COALESCE(SUM(numMissingQueries), 0) AS numMissingQueries
	FROM (
	        (SELECT dbms, 
		        experimentname,
		        runid, 
			(max(querynum)-min(querynum)+1)-count(querynum) AS numMissingQueries 
 		 FROM (SELECT DISTINCT dbms, 
				       experimentname,
		       		       runid, 
	        	     	       querynum 
	      	       FROM __Analysis_S0_AQE_Ver1__)
		 GROUP BY dbms, experimentname, runid)
	     )
	GROUP BY dbms, experimentname, runid;
ALTER VIEW __Analysis_S1_MQ_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE;

DROP VIEW __Analysis_S1_MQ_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_MQ_Ver1__ AS			
	SELECT COALESCE(SUM(numMissingQueries), 0) AS numMissingQueries
	FROM __Analysis_S1_MQ_PDE_Ver1__;

DROP VIEW __Analysis_S1_AF_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_AF_PDE_Ver1__ AS			
	SELECT dbms, 
	       experimentname,
	       runid,
	       COALESCE(SUM(numAspectFailures), 0) AS numAspectFailures
	FROM (
		SELECT qe.dbms, 
		       qe.experimentname,
		       qe.runid,
		       (totalQEs - totalQEAs) as numAspectFailures 
		FROM 
			(SELECT dbms, 
				experimentName, 
				runid,
				count(qeid) AS totalQEs
			 FROM __Analysis_S1_VQE_Ver1__ 
			 GROUP BY dbms, experimentname, runid) qe, 
			(SELECT dbms, 
				experimentName, 
				runid,
				count(queryexecutionid) AS totalQEAs
			 FROM __Analysis_S1_QEA_Ver1__ 
			 GROUP BY dbms, experimentname, runid) qea
		WHERE qe.runid = qea.runid
	     ) t0
	GROUP BY dbms, experimentname, runid;
ALTER VIEW __Analysis_S1_AF_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE;

DROP VIEW __Analysis_S1_AF_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_AF_Ver1__ AS		
	SELECT COALESCE(SUM(numAspectFailures), 0) AS numAspectFailures
	FROM __Analysis_S1_AF_PDE_Ver1__;

DROP VIEW __Analysis_S1_UPV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_UPV_PDE_Ver1__ AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(nUPViolations), 0) AS numUniquePlanViolations
	FROM  (SELECT t2.dbms,
		      t2.experimentname,
		      t1.runid, 
	    	      t1.querynum, 
		      t1.card, 
		      COALESCE(count(t2.qeid), 0) AS nUPViolations
	       FROM  __Analysis_S1_QatC_Ver1__        t1,
		     __Analysis_S1_VQE_Ver1__         t2,
		     AZDBLab_QueryExecutionHasPlan qep
	       WHERE   t1.runid    = t2.runid
		   AND t1.querynum = t2.querynum
		   AND t1.card	    = t2.card
		   AND t2.qeid     = qep.queryExecutionID
	       GROUP BY t2.dbms, t2.experimentname, t1.runid, t1.querynum, t1.card
	       HAVING count(DISTINCT qep.planID) > 1)
	GROUP BY dbms, experimentname, runid;
ALTER VIEW __Analysis_S1_UPV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE;
 
DROP VIEW __Analysis_S1_UPV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_UPV_Ver1__ AS
        SELECT COALESCE(SUM(numUniquePlanViolations), 0) AS numUniqPlanViols	
	FROM __Analysis_S1_UPV_PDE_Ver1__;
DROP TABLE __Analysis_S1_CDP_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S1_CDP_Ver1__ AS
	 SELECT s.runid, 
		s.querynum, 
	        s.card, 
		qp.processid as querypid, 
       		SUM(qp.UTicks+qp.STicks) q_total_time
	 FROM __Analysis_S1_VQE_Ver1__ s,
	      AZDBLab_QueryExecutionProcs qp, 
 	      __Analysis_Qmd_Ver1__ qmd 
	WHERE s.qeid = qp.queryexecutionid AND 
	      s.dbms = qmd.dbmsname AND		
	      qp.processname = qmd.qprocname
	GROUP BY runid, querynum, card, qp.processid
	ORDER BY runid ASC, querynum ASC, card DESC, qp.processid ASC, q_total_time DESC;
ALTER TABLE __Analysis_S1_CDP_Ver1__ ADD PRIMARY KEY (runid, querynum, card, querypid); 

DROP TABLE __Analysis_S1_QProc_QatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S1_QProc_QatC_Ver1__ AS
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.querypid) as querypid
	FROM __Analysis_S1_CDP_Ver1__ t1, 
	     (SELECT DISTINCT t3.runid,
			     t3.querynum, 
			     t3.card, 
		     MAX(t3.q_total_time) AS maxtime 
	      FROM __Analysis_S1_CDP_Ver1__ t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_time = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE __Analysis_S1_QProc_QatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card) ; 

DROP VIEW __Analysis_S1_QProc_QE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_QProc_QE_Ver1__ AS
	SELECT t1.dbms,
	       t1.experimentname,
	       t1.runid,
	       t1.querynum,
	       t1.card,
	       t1.qeid,
	       t2.querypid,
	       (qp.uticks+qp.sticks)/10000 as QueryTime
	FROM  __Analysis_S1_VQE_Ver1__  	   t1,
	      __Analysis_S1_QProc_QatC_Ver1__  t2,
	      AZDBLab_QueryExecutionProcs  qp
	WHERE   t1.runid     = t2.runid
	    AND t1.querynum  = t2.querynum
	    AND t1.card	     = t2.card
	    AND t1.qeid	     = qp.queryexecutionid
	    AND t2.querypid  = qp.processid;
ALTER VIEW __Analysis_S1_QProc_QE_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP VIEW __Analysis_S1_EQTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_EQTV_PDE_Ver1__ AS
	SELECT dbms, 
	       experimentname,
	       runid,
	       COALESCE(SUM(t1.numExcVarPerRun), 0) AS numExcVarPerDBMSPerExp
	FROM  (
		SELECT t0.dbms, 
		       t0.experimentname,
		       t0.runid, 
		       t0.querynum,
		       COALESCE(count(t0.card), 0) AS numExcVarPerRun
		FROM (SELECT dbms,
			     experimentname,
			     runid,
			     querynum,
			     card
		      FROM __Analysis_S1_QProc_QE_Ver1__
		      HAVING TRUNC(STDDEV(queryTime), 0) > CEIL(0.2 * AVG(queryTime))
		      GROUP BY dbms, experimentname, runid, querynum, card) t0
		GROUP BY dbms, experimentname, runid, querynum) t1
	GROUP BY dbms, experimentname, runid;
ALTER VIEW __Analysis_S1_EQTV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_EQTV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_EQTV_Ver1__ AS
	SELECT COALESCE(SUM(numExcVarPerDBMSPerExp), 0) AS excVarQatCs
	FROM __Analysis_S1_EQTV_PDE_Ver1__;

DROP VIEW __Analysis_S1_DTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_DTV_PDE_Ver1__ AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(queryexecutionid), 0)  AS numDBMSTimeViolations
	FROM __Analysis_S1_QEA_Ver1__ 
	WHERE (CEIL(measured_time/10)-TRUNC(totalOtherTime/10000, 0)) < 0 
	GROUP BY dbms, experimentname, runid;
ALTER VIEW __Analysis_S1_DTV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_DTV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_DTV_Ver1__ AS
	SELECT COALESCE(SUM(numDBMSTimeViolations), 0) AS DBMSTimeViols
	FROM __Analysis_S1_DTV_PDE_Ver1__;

DROP VIEW __Analysis_S1_ZQTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_ZQTV_PDE_Ver1__ AS
	SELECT dbms,
	       experimentname,
	       runid, 
	       COALESCE(count(qeid), 0)  AS numZeroQueryTimes
	FROM  __Analysis_S1_QProc_QE_Ver1__
	WHERE querytime = 0
	GROUP BY dbms, experimentname, runid;
ALTER VIEW __Analysis_S1_ZQTV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_ZQTV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_ZQTV_Ver1__ AS
	SELECT COALESCE(SUM(numZeroQueryTimes), 0) AS ZeroQueryTimes
	FROM __Analysis_S1_ZQTV_PDE_Ver1__;

DROP VIEW __Analysis_S1_QTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_QTV_PDE_Ver1__ AS
	SELECT qproc.dbms,
	       qproc.experimentname,
	       qproc.runid, 
	       COALESCE(count(qproc.qeid), 0)  AS numQueryTimeViolations
	FROM  __Analysis_S1_QProc_QE_Ver1__ qproc,
	      __Analysis_S1_QEA_Ver1__ qea
	WHERE qproc.qeid = qea.queryexecutionid 
          AND querytime > CEIL(measured_time/10)
	GROUP BY qproc.dbms, qproc.experimentname, qproc.runid;
ALTER VIEW __Analysis_S1_QTV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_QTV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_QTV_Ver1__ AS
	SELECT COALESCE(SUM(numQueryTimeViolations), 0) AS QueryTimeViols
	FROM __Analysis_S1_QTV_PDE_Ver1__;

DROP VIEW __Analysis_S1_HTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_HTV_PDE_Ver1__ AS
	(SELECT dbms,
		experimentname, 
		runid, 
	        COALESCE(count(queryexecutionid), 0) AS numHighTickViolations
	 FROM __Analysis_S1_QEA_Ver1__ 
	 WHERE (userModeTicks+lowPriorityUserModeTicks+systemModeTicks+idleTaskTicks+ioWait+stealStolenTicks) - CEIL(measured_time/10) >= 3
	 GROUP BY dbms, experimentname, runid);
ALTER VIEW __Analysis_S1_HTV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_LTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_LTV_PDE_Ver1__ AS
	(SELECT dbms,
		experimentname, 
		runid, 
	        COALESCE(count(queryexecutionid), 0) AS numLowTickViolations
	 FROM __Analysis_S1_QEA_Ver1__ 
	 WHERE (userModeTicks+lowPriorityUserModeTicks+systemModeTicks+idleTaskTicks+ioWait+stealStolenTicks) - TRUNC(measured_time/10,0) <= -9 
	 GROUP BY dbms, experimentname, runid);
ALTER VIEW __Analysis_S1_LTV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE;
DROP TABLE __Analysis_AEUP_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_AEUP_Ver1__ AS
	SELECT DISTINCT qeid, 
			t1.procid as pid
	FROM __Analysis_API_Ver1__ t1,
 	     __Analysis_Umd_Ver1__ t2
 	WHERE (t1.procid NOT IN (SELECT DISTINCT querypid
	 			 FROM __Analysis_AQProc_QatC_Ver1__
			         WHERE runid    = t1.runid AND
                                       querynum = t1.querynum AND
				       card     = t1.card)) 
	  AND t1.dbms     = t2.dbmsname			   
	  AND t1.procname = t2.uprocname;
ALTER TABLE __Analysis_AEUP_Ver1__ ADD PRIMARY KEY (qeid, pid) DISABLE; 
DROP VIEW __Analysis_S1_QIO_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_QIO_Ver2__ AS 
	SELECT	queryexecutionid AS qeid, 
		blockio_delay AS queryprocessio, 
		blkio_count AS QueryIOCount 
	FROM 	azdblab_queryexecutionprocs qep, 
		__Analysis_AEQPI_Ver1__ q,
		__Analysis_S1_VQE_Ver1__ re
	WHERE	q.qeid = qep.queryexecutionid AND
		re.qeid = qep.queryexecutionid AND
		q.procid = qep.processid;

DROP VIEW __Analysis_AEDep_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_AEDep_Ver1__ AS
	SELECT  queryexecutionid AS qeid, 
		processid AS pid
	FROM	azdblab_queryexecutionprocs qep,
		__Analysis_S1_VQE_Ver1__ vqe
	WHERE	vqe.qeid = qep.queryexecutionid
	MINUS
	SELECT * FROM __Analysis_AEUP_Ver1__
	MINUS
	SELECT qeid, 
	       procid AS pid 
	FROM __Analysis_AEQPI_Ver1__;



DROP VIEW __Analysis_S1_DIO_PDE_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_DIO_PDE_Ver2__ AS 
	SELECT	vqe.dbms,
		vqe.experimentName,
		vqe.runId,
		qep.queryexecutionid as qeid, 
		sum(blockio_delay) AS DaemonProcessIO, 
		sum(blkio_count) AS DaemonIOCount
	FROM	azdblab_queryexecutionprocs qep,
		__Analysis_AEDep_Ver1__ t,
		__Analysis_S1_VQE_Ver1__ vqe
	WHERE	qep.queryexecutionid = t.qeid AND
		qep.processid = t.pid AND
		vqe.qeid = t.qeid
	GROUP BY vqe.dbms, vqe.experimentname, vqe.runId, qep.queryexecutionid;


DROP VIEW __Analysis_S1_DIOV_PDE_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_DIOV_PDE_Ver2__ AS 
	SELECT	dbms,
		experimentName,
		runId,
		COALESCE(count(dio.qeid), 0) numDIOWaitViolations
	FROM 	__Analysis_S1_DIO_PDE_Ver2__ dio,
                AZDBLab_QueryExecution qe
	WHERE   qe.runtime*1000 < dio.DaemonProcessIO AND
		qe.queryexecutionid = dio.qeid
	GROUP BY dbms, experimentName, runId;

DROP VIEW __Analysis_S1_DIOV_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_DIOV_Ver2__ AS 
	SELECT	COALESCE(sum(numDIOWaitViolations), 0) numDIOWaitViolations
	FROM 	__Analysis_S1_DIOV_PDE_Ver2__ dio;

DROP VIEW __Analysis_S1_OTV_PDE_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_OTV_PDE_Ver2__ AS
	SELECT  dbms,
		experimentName,
		runId,
		qep.qeid
	FROM __Analysis_S1_QEA_Ver1__ qea,
	     (SELECT queryexecutionid qeid,
		     SUM(sticks)/10000 sticks,
		     SUM(uticks)/10000 uticks
	      FROM AZDBLab_QueryExecutionProcs
	      GROUP BY queryexecutionid) qep
	WHERE qea.queryexecutionid = qep.qeid AND
	      (qea.systemmodeticks > 10+qep.sticks OR
	      qea.usermodeticks > 10+qep.uticks);

DROP VIEW __Analysis_S1_OTV_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_OTV_Ver2__ AS
	SELECT	COALESCE(count(qeid), 0) numOTViolations
	FROM 	__Analysis_S1_OTV_PDE_Ver2__ dio;


----------------------------------------------------------------------------------
--******************************************************************************--
----------------------------------------------------------------------------------

DROP VIEW __Analysis_S1_NQPV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_NQPV_PDE_Ver1__ AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) numQEsWithoutQProcs
	FROM (
		SELECT dbms, 
		       experimentName, 
        	       runid, 
		       qeid
        	FROM __Analysis_S1_VQE_Ver1__
        	MINUS 
        	SELECT dbms, 
		       experimentName, 
        	       runid, 
		       qeid
      		FROM __Analysis_S1_QProc_QE_Ver1__
     	)
	GROUP BY dbms, experimentName, runid;
ALTER VIEW __Analysis_S1_NQPV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_NQPV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_NQPV_Ver1__ AS
	SELECT COALESCE(SUM(numQEsWithoutQProcs), 0) AS NoQueryProcViols
	FROM __Analysis_S1_NQPV_PDE_Ver1__;

DROP VIEW __Analysis_S1_OQPV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_OQPV_PDE_Ver1__ AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) as numQEsWithOtherQProcs
	FROM __Analysis_S1_VQE_Ver1__        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     __Analysis_Qmd_Ver1__ 		 qmd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> qmd.dbmsname
	  AND qp.processname = qmd.qprocname  
	GROUP BY dbms, experimentName, runid;
ALTER VIEW __Analysis_S1_OQPV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_OQPV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_OQPV_Ver1__ AS
	SELECT COALESCE(SUM(numQEsWithOtherQProcs), 0) AS OtherQueryProcViols
	FROM __Analysis_S1_OQPV_PDE_Ver1__;

DROP VIEW __Analysis_S1_OUPV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_OUPV_PDE_Ver1__ AS
	SELECT dbms, 
	       experimentName,
	       runid,
	       COALESCE(count(qeid), 0) as numQEsWithOtherUProcs
	FROM __Analysis_S1_VQE_Ver1__        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     __Analysis_Umd_Ver1__ 		 umd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> umd.dbmsname
	  AND qp.processname = umd.uprocname  
	GROUP BY dbms, experimentName, runid;
ALTER VIEW __Analysis_S1_OUPV_PDE_Ver1__ ADD PRIMARY KEY (runid) DISABLE; 

DROP VIEW __Analysis_S1_OUPV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_OUPV_Ver1__ AS
	SELECT COALESCE(SUM(numQEsWithOtherUProcs), 0) AS OtherUtilProcViols
	FROM __Analysis_S1_OUPV_PDE_Ver1__;

DROP TABLE __Analysis_ASPQatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_ASPQatC_Ver1__ AS
	SELECT p1.*, 
	       p2.card as card2, 
	       p2.med_cqt as med_cqt2,
	       p2.std_cqt as std_cqt2
	FROM __Analysis_ACTQatC_Ver1__ p1, 		
	     __Analysis_ACTQatC_Ver1__ p2 
	WHERE p1.runid    = p2.runid    AND
	      p1.querynum = p2.querynum AND
	      p1.planid   = p2.planid   AND
	      p1.card < p2.card
	ORDER BY p1.runid, p1.querynum, p1.card, p2.card;
ALTER TABLE __Analysis_ASPQatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card, card2); 

DROP TABLE __Analysis_ATSM_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_ATSM_Ver1__ AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM __Analysis_ASPQatC_Ver1__
	WHERE med_cqt > med_cqt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE __Analysis_ATSM_Ver1__ ADD PRIMARY KEY (runid, querynum, card, card2); 

INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_ATSM_Ver1' as stepName,
	       COALESCE(count(*),0) as stepResultSize
	FROM __Analysis_ATSM_Ver1__
	GROUP BY dbms, experimentname;

DROP TABLE __Analysis_ATRM_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_ATRM_Ver1__ AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM __Analysis_ASPQatC_Ver1__
	WHERE med_cqt-0.5*std_cqt > med_cqt2+0.5*std_cqt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE __Analysis_ATRM_Ver1__ ADD PRIMARY KEY (runid, querynum, card, card2); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_ATRM_Ver1' as stepName,
	       COALESCE(COUNT(*), 0) as stepResultSize
	FROM __Analysis_ATRM_Ver1__
	GROUP BY dbms, experimentname;

DROP TABLE __Analysis_S1_FQEP1_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S1_FQEP1_Ver1__ AS
	SELECT dbms,
	     experimentname,
	     runid,
	     querynum,
	     card
	FROM __Analysis_S1_QProc_QE_Ver1__
	HAVING TRUNC(STDDEV(queryTime), 0) > CEIL(0.2 * AVG(queryTime))
	GROUP BY dbms, experimentname, runid, querynum, card;

DROP VIEW __Analysis_S1_FQE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_FQE_Ver1__ AS
	SELECT t1.dbms,
	       t1.experimentname,
	       qeid
	FROM  __Analysis_S1_FQEP1_Ver1__ t0, 
	      __Analysis_S1_VQE_Ver1__ t1
	WHERE t0.runid = t1.runid AND
	      t0.querynum = t1.querynum AND
	      t0.card     = t1.card
	UNION
	SELECT dbms,
	       experimentname,
	       queryexecutionid
	FROM __Analysis_S1_QEA_Ver1__ 
	WHERE (CEIL(measured_time/10)-TRUNC(totalOtherTime/10000, 0)) < 0
	UNION
	SELECT dbms,
	       experimentname,
	       qeid
	FROM  __Analysis_S1_QProc_QE_Ver1__
	WHERE querytime = 0
	UNION
	SELECT dbms,
	       experimentName,
	       dio.qeid
	FROM __Analysis_S1_DIO_PDE_Ver2__ dio,
             AZDBLab_QueryExecution qe
        WHERE qe.runtime*1000 < dio.DaemonProcessIO AND
	      qe.queryexecutionid = dio.qeid
	UNION  
	SELECT dbms,
	       experimentName,
	       qeid
	FROM __Analysis_S1_OTV_PDE_Ver2__ qea
	UNION
	SELECT qproc.dbms,
	       qproc.experimentname,
	       qproc.qeid
	FROM  __Analysis_S1_QProc_QE_Ver1__ qproc,
	      __Analysis_S1_QEA_Ver1__ qea
	WHERE qproc.qeid = qea.queryexecutionid 
	  AND querytime > CEIL(measured_time/10)
	UNION
	SELECT dbms,
	       experimentname,
	       qeid
	FROM (
		SELECT dbms,
	       	       experimentname,
		       qeid
        	FROM __Analysis_S1_VQE_Ver1__
        	MINUS 
        	SELECT dbms,
	       	       experimentname,
		       qeid
      		FROM __Analysis_S1_QProc_QE_Ver1__
     	)
	UNION
	SELECT qe.dbms,
	       qe.experimentname,
               qeid
	FROM __Analysis_S1_VQE_Ver1__        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     __Analysis_Qmd_Ver1__ 		 qmd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> qmd.dbmsname
	  AND qp.processname = qmd.qprocname
	UNION
	SELECT qe.dbms,
	       qe.experimentname,
               qeid
	FROM __Analysis_S1_VQE_Ver1__        qe,
	     AZDBLab_QueryExecutionProcs qp,
	     __Analysis_Umd_Ver1__ 		 umd
	WHERE qe.qeid = qp.queryexecutionid 
	  AND qe.dbms <> umd.dbmsname
	  AND qp.processname = umd.uprocname;
ALTER VIEW __Analysis_S1_FQE_Ver1__ ADD PRIMARY KEY (qeid) DISABLE;
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_FQE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S1_FQE_Ver1__
	GROUP BY dbms, experimentname;
DROP VIEW __Analysis_S1_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_Ver1__ AS
	SELECT DISTINCT numMissingQueries,
		       numAspectFailures, 
		       numUniqPlanViols,
		       excVarQatCs,
		       DBMSTimeViols,
		       ZeroQueryTimes,
		       QueryTimeViols,
		       NoQueryProcViols,
		       OtherQueryProcViols,
		       OtherUtilProcViols,
		       totalQatCs,
		       totalQEs,
                       numDIOWaitViolations,
		       numOTViolations
	FROM __Analysis_S1_MQ_Ver1__ mq,
	     __Analysis_S1_AF_Ver1__ qea,
	     __Analysis_S1_UPV_Ver1__ upv,
	     __Analysis_S1_EQTV_Ver1__ evp, 
	     __Analysis_S1_DTV_Ver1__ dtv,
	     __Analysis_S1_ZQTV_Ver1__ qtv,
	     __Analysis_S1_QTV_Ver1__ qtv,
	     __Analysis_S1_NQPV_Ver1__ nqpv,
	     __Analysis_S1_OQPV_Ver1__ oqpv,
	     __Analysis_S1_OUPV_Ver1__ oupv,
	     __Analysis_S1_TQE_Ver1__ tqe,
	     __Analysis_S1_TQC_Ver1__ tqatc,
	     __Analysis_S1_DIOV_Ver2__,
	     __Analysis_S1_OTV_Ver2__;
