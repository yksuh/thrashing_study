DROP TABLE __Analysis_S2_I_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S2_I_Ver1__ AS
	SELECT t0.*
	FROM __Analysis_S1_VQE_Ver1__ t0
	WHERE qeid NOT IN (SELECT qeid FROM __Analysis_S1_FQE_Ver1__);
ALTER TABLE __Analysis_S2_I_Ver1__ ADD PRIMARY KEY (qeid) DISABLE;
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S2_I_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S2_I_Ver1__
	GROUP BY dbms, experimentname;

DROP VIEW __Analysis_S2_II_Ver2__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S2_II_Ver2__ AS
	SELECT s2i.*
	FROM	__Analysis_S1_QIO_Ver2__ q,
		__Analysis_S1_DIO_PDE_Ver2__ d,
		azdblab_queryexecution qe,
		__Analysis_S2_I_Ver1__ s2i
	WHERE	q.qeid = d.qeid AND
		s2i.qeid = q.qeid AND
		qe.queryexecutionid = q.qeid AND
		qe.runtime <> 0 AND
		1 - q.QueryProcessIO/(qe.runtime*1000-d.DaemonProcessIO) > 0.9;
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S2_II_Ver2' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S2_II_Ver2__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_S3_0_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S3_0_Ver1__ AS
	SELECT DISTINCT dbms, 
			experimentName,  
			runid, 
			querynum, 
			card 
	FROM __Analysis_S2_II_Ver2__ t1
        GROUP BY dbms, experimentName, runid, querynum, card;
ALTER TABLE __Analysis_S3_0_Ver1__ ADD PRIMARY KEY (runid, querynum, card); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_0_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S3_0_Ver1__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_CDP_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_CDP_Ver1__ AS
	 SELECT s.runid, 
		s.querynum, 
	        s.card, 
		qp.processid as querypid, 
       		SUM(qp.uTicks+qp.sTicks) q_total_time
	 FROM __Analysis_S2_II_Ver2__ s,
	      AZDBLab_QueryExecutionProcs qp, 
 	      __Analysis_Qmd_Ver1__ qmd 
	WHERE s.qeid = qp.queryexecutionid AND 
	      s.dbms = qmd.dbmsname AND		
	      qp.processname = qmd.qprocname
	GROUP BY runid, querynum, card, qp.processid
	ORDER BY runid ASC, querynum ASC, card DESC, qp.processid ASC, q_total_time DESC;
ALTER TABLE __Analysis_CDP_Ver1__ ADD PRIMARY KEY (runid, querynum, card, querypid); 
DROP TABLE __Analysis_QProc_QatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_QProc_QatC_Ver1__ AS
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.querypid) as querypid
	FROM __Analysis_CDP_Ver1__ t1, 
	     (SELECT DISTINCT t3.runid,
		     t3.querynum, 
		     t3.card, 
		     MAX(t3.q_total_time) AS maxtime 
	      FROM __Analysis_CDP_Ver1__ t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_time = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE __Analysis_QProc_QatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card);
DROP TABLE __Analysis_S3_I_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S3_I_Ver1__ AS
	SELECT dbms,
	       experimentName,
	       runid,
	       querynum,
	       card, 	    
               AVG(measured_time) as average_measured_time,
	       COUNT(*) as num_executions
	FROM __Analysis_S2_II_Ver2__ 
        WHERE (runid, querynum, card) NOT IN (
				 SELECT DISTINCT runid, querynum, card
        	                 FROM (
				      SELECT t1.qeid, t1.runid, t1.querynum, t1.card
				      FROM __Analysis_S2_II_Ver2__ t1
				      MINUS
				      SELECT t1.qeid, t1.runid, t1.querynum, t1.card
			  	      FROM __Analysis_S2_II_Ver2__ t1, 
				           __Analysis_QProc_QatC_Ver1__ t2,
				      	   AZDBLab_QueryExecutionProcs t3
				      WHERE t1.runid     = t2.runid
				        AND t1.querynum  = t2.querynum
				   	AND t1.card      = t2.card
				   	AND t1.qeid      = t3.queryexecutionid
				   	AND t3.processid = t2.querypid)
				)
        GROUP BY dbms, experimentName, runid, querynum, card;
ALTER TABLE __Analysis_S3_I_Ver1__ ADD PRIMARY KEY (runid, querynum, card);
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_I_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S3_I_Ver1__
	GROUP BY dbms, experimentname;
DROP VIEW __Analysis_S3_II_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S3_II_Ver1__ AS
	SELECT *
	FROM __Analysis_S3_I_Ver1__
	WHERE average_measured_time > 20;
ALTER VIEW __Analysis_S3_II_Ver1__ ADD PRIMARY KEY (runid, querynum, card) DISABLE;
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_II_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S3_II_Ver1__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_S3_III_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S3_III_Ver1__ AS
	SELECT *
	FROM __Analysis_S3_II_Ver1__
	WHERE num_executions >= 6;
ALTER TABLE __Analysis_S3_III_Ver1__ ADD PRIMARY KEY (runid, querynum, card) DISABLE;
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S3_III_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S3_III_Ver1__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_PI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_PI_Ver1__ AS
	SELECT DISTINCT 
	       qe.version,
	       qe.experimentid,
	       qe.experimentname,
	       qatc.runid,
	       qatc.querynum,
	       qatc.card as card,
	       qe.planid,
	       qe.dbms,
	       qe.measured_time,
               qe.iowait,
	       qe.irq,
	       qe.softirq,
	       qe.qeid,
	       qe.qenum,
	       qp.processname as procname,
	       qp.ProcessID as procid,
	       qp.uTicks,
	       qp.sTicks,
	       qp.maj_flt as maj_flt
	FROM __Analysis_S3_III_Ver1__ qatc, 
	     __Analysis_S2_II_Ver2__ qe,
	     AZDBLab_QueryExecutionProcs qp
	WHERE qatc.runid = qe.runid AND 
	      qatc.querynum = qe.querynum AND
	      qatc.card = qe.card AND
	      qe.qeid = qp.queryexecutionid;
ALTER TABLE __Analysis_PI_Ver1__ ADD PRIMARY KEY (qeid, procid) DISABLE; 
DROP TABLE __Analysis_QPI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_QPI_Ver1__ AS
	SELECT qeid,
	       uticks,
	       sticks,
	       maj_flt
	FROM __Analysis_PI_Ver1__ t1, 
	     __Analysis_QProc_QatC_Ver1__ t2
 	WHERE t1.runid    = t2.runid 
          AND t1.querynum = t2.querynum
	  AND t1.card     = t2.card
	  AND t1.procid   = t2.querypid;
ALTER TABLE __Analysis_QPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE;
DROP TABLE __Analysis_EUPI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_EUPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	       	        SUM(uticks) AS uticks,
	  	        SUM(sticks) AS sticks,
		        SUM(maj_flt) AS maj_flt
	FROM __Analysis_PI_Ver1__ t1,
 	     __Analysis_Umd_Ver1__ t2
 	WHERE (t1.procid NOT IN (SELECT DISTINCT querypid
	 			 FROM __Analysis_QProc_QatC_Ver1__
			         WHERE runid    = t1.runid AND
                                       querynum = t1.querynum AND
				       card     = t1.card)) 
	  AND t1.dbms     = t2.dbmsname			   
	  AND t1.procname = t2.uprocname
	GROUP BY qeid;
ALTER TABLE __Analysis_EUPI_Ver1__ ADD PRIMARY KEY (qeid);
DROP VIEW __Analysis_NUPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_NUPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM __Analysis_PI_Ver1__ 
	WHERE qeid NOT IN (SELECT qeid FROM __Analysis_EUPI_Ver1__);
ALTER VIEW __Analysis_NUPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE;
DROP TABLE __Analysis_UPI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_UPI_Ver1__ AS
	SELECT * FROM __Analysis_EUPI_Ver1__
	UNION
	SELECT * FROM __Analysis_NUPI_Ver1__;
ALTER TABLE __Analysis_UPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE;
DROP VIEW __Analysis_EDPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_EDPI_Ver1__ AS
	SELECT DISTINCT qeid, 
		       SUM(uticks) AS uticks, 
		       SUM(sticks) AS sticks, 
		       SUM(maj_flt) AS maj_flt 
	FROM __Analysis_PI_Ver1__ 
	WHERE procname NOT IN (SELECT qprocname 
			       FROM __Analysis_Qmd_Ver1__
			       UNION
			       SELECT uprocname
 			       FROM __Analysis_Umd_Ver1__
			      ) 
        GROUP BY qeid;
ALTER VIEW __Analysis_EDPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW __Analysis_NDPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_NDPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM __Analysis_PI_Ver1__ 
	WHERE qeid NOT IN (SELECT qeid FROM __Analysis_EDPI_Ver1__);
ALTER VIEW __Analysis_NDPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 
DROP TABLE __Analysis_DPI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_DPI_Ver1__ AS
	SELECT * FROM __Analysis_EDPI_Ver1__
	UNION
	SELECT * FROM __Analysis_NDPI_Ver1__;
ALTER TABLE __Analysis_DPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 
DROP TABLE __Analysis_QED_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_QED_Ver1__ AS
	SELECT DISTINCT
		proc.version,
                proc.experimentid,
	        proc.experimentname,
		proc.planid,
		proc.dbms,
		proc.qeid,
		proc.runid,
		proc.querynum,
		proc.card,
		proc.qenum,
		proc.measured_time,
		proc.iowait,
		proc.irq,
		proc.softirq,
		qproc.uticks AS qp_uticks,
		qproc.sticks AS qp_sticks,
		(qproc.uticks+qproc.sticks) AS queryTime,
		qproc.maj_flt AS qp_maj_flt,
		util_proc.uticks AS up_uticks,
		util_proc.sticks AS up_sticks,
		util_proc.maj_flt AS up_maj_flt,
		dproc.uticks AS dp_uticks,
		dproc.sticks AS dp_sticks,
		dproc.maj_flt as dp_maj_flt,
		(qproc.uticks+util_proc.uticks+dproc.uticks) AS overall_uticks,
		(qproc.sticks+util_proc.sticks+dproc.sticks) AS overall_sticks,
		(qproc.maj_flt+util_proc.maj_flt+dproc.maj_flt) AS overall_maj_flt
	FROM	__Analysis_PI_Ver1__ proc,
		__Analysis_QPI_Ver1__ qproc,
		__Analysis_UPI_Ver1__ util_proc,
		__Analysis_DPI_Ver1__ dproc
	WHERE 	proc.qeid  = qproc.qeid
	    AND qproc.qeid = util_proc.qeid
	    AND qproc.qeid = dproc.qeid
	ORDER BY proc.qeid ASC;
ALTER TABLE __Analysis_QED_Ver1__ ADD PRIMARY KEY (qeid); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_QED_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_QED_Ver1__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_S4_CTQatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S4_CTQatC_Ver1__ AS
	SELECT  qed.version,
	        qed.experimentid,
	        qed.experimentname,
		qed.dbms,
		qed.runid,
		qed.querynum,
		qed.card,
		qed.planid,
		MIN(qed.measured_time) as min_meas_time,
		MAX(qed.measured_time) as max_meas_time,
		ROUND(AVG(qed.measured_time),1) as avg_meas_time,
		ROUND(STDDEV(qed.measured_time),1) as std_meas_time,
		ROUND(MEDIAN((qp_uticks+qp_sticks+Dmd.coef*qp_uticks)*10), 1) as med_cqt,
		ROUND(STDDEV((qp_uticks+qp_sticks+Dmd.coef*qp_uticks)*10), 1) as std_cqt,
		ROUND(MEDIAN(qp_uticks), 2) as med_qp_uticks,
		MIN(qp_uticks) as min_qp_uticks,
		MAX(qp_uticks) as max_qp_uticks,
		ROUND(AVG(qp_uticks),2) as avg_qp_uticks,
		ROUND(stddev(qp_uticks),2) as std_qp_uticks,
		MIN(up_maj_flt) as min_up_maj_flt,
		MAX(up_maj_flt) as max_up_maj_flt,
		ROUND(AVG(up_maj_flt),2) as avg_up_maj_flt,
		ROUND(stddev(up_maj_flt),2) as std_up_maj_flt,
		MIN(dp_maj_flt) as min_dp_maj_flt,		
		MAX(dp_maj_flt) as max_dp_maj_flt,
		ROUND(AVG(dp_maj_flt),2) as avg_dp_maj_flt,
		ROUND(stddev(dp_maj_flt),2) as std_dp_maj_flt,
		MIN(qed.iowait) as min_iowait,
		MAX(qed.iowait) as max_iowait,
		ROUND(AVG(qed.iowait),2) as avg_iowait,
		ROUND(stddev(qed.iowait),2) as std_iowait
	FROM __Analysis_QED_Ver1__ qed,		
	     __Analysis_Dmd_Ver1__ Dmd
	WHERE qed.dbms   = Dmd.dbmsname
        GROUP BY qed.version, qed.experimentid, qed.experimentname, qed.dbms, qed.runid, qed.querynum, qed.card, qed.planid;
ALTER TABLE __Analysis_S4_CTQatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S4_CTQatC_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S4_CTQatC_Ver1__
	GROUP BY dbms, experimentname;
