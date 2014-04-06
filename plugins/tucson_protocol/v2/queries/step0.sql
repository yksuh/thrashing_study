DROP TABLE __Analysis_Dmd_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_Dmd_Ver1__
(
	dbmsname	VARCHAR2(10) NOT NULL PRIMARY KEY,
	coef 		NUMBER (10, 3) 
);
INSERT INTO __Analysis_Dmd_Ver1__ VALUES ('db2',    0);
INSERT INTO __Analysis_Dmd_Ver1__ VALUES ('oracle', 1.916);
INSERT INTO __Analysis_Dmd_Ver1__ VALUES ('pgsql',  0.259);
INSERT INTO __Analysis_Dmd_Ver1__ VALUES ('mysql',  0);

DROP TABLE __Analysis_Qmd_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_Qmd_Ver1__
(
	dbmsname	VARCHAR2(10) REFERENCES __Analysis_Dmd_Ver1__(dbmsname) ON DELETE CASCADE,
	qprocname 	VARCHAR2(10) NOT NULL,
	PRIMARY KEY (dbmsname, qprocname)
);
INSERT INTO __Analysis_Qmd_Ver1__ VALUES ('db2',    'db2sysc');
INSERT INTO __Analysis_Qmd_Ver1__ VALUES ('oracle', 'oracle');
INSERT INTO __Analysis_Qmd_Ver1__ VALUES ('pgsql',  'postmaster');
INSERT INTO __Analysis_Qmd_Ver1__ VALUES ('pgsql',  'postgres');	
INSERT INTO __Analysis_Qmd_Ver1__ VALUES ('mysql',  'mysqld');
DROP TABLE __Analysis_Umd_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_Umd_Ver1__
(
	dbmsname 	VARCHAR2(10) REFERENCES __Analysis_Dmd_Ver1__(dbmsname) ON DELETE CASCADE,
	uprocname 	VARCHAR2(10) NOT NULL,
	PRIMARY KEY (dbmsname, uprocname)
);
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2dasstm');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2dasrrm');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2fm');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2fmd');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2fmcd');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2dascln');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2fmp');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2dasstml');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2set');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('db2',    'db2bp');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('oracle', 'oracle');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('pgsql',  'postmaster');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('pgsql',  'postgres');
INSERT INTO __Analysis_Umd_Ver1__ VALUES ('mysql',  'mysqld');
DROP TABLE __Chosen_Users_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Chosen_Users_Ver1__ AS
	SELECT userName 
	FROM AZDBLab_User;
ALTER TABLE __Chosen_Users_Ver1__ ADD PRIMARY KEY (userName);
DROP TABLE __Chosen_Notebooks_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Chosen_Notebooks_Ver1__ AS
	SELECT notebookName 
	FROM AZDBLab_NoteBook;
ALTER TABLE __Chosen_Notebooks_Ver1__ ADD PRIMARY KEY (notebookName);
DROP TABLE __Chosen_LabShelf_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Chosen_LabShelf_Ver1__ AS
	SELECT 600 AS version,
	__username__ AS username,
	__password__ AS password,
	__connect_string__ as connect_string FROM Dual;
	
ALTER TABLE __Chosen_LabShelf_Ver1__ ADD PRIMARY KEY (version);
DROP TABLE __Chosen_Runs_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Chosen_Runs_Ver1__ AS
	SELECT runid 
	FROM AZDBLab_ExperimentRun
	WHERE runid IN (__runidlist__)
	ORDER BY runid;
ALTER TABLE __Chosen_Runs_Ver1__ ADD PRIMARY KEY (runid);
DROP TABLE __Analysis_S0_AQE_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S0_AQE_Ver1__ AS
	SELECT  c_labshelf.version,
	 	ex.experimentid,
		ex.experimentname,
		er.dbmsname as dbms,
		q.runid,
		q.queryNumber AS querynum,
		qe.queryexecutionid AS qeid,
		qe.cardinality AS card,
		qe.iternum AS qenum,
		qe.runtime AS measured_time,
		qp.planid,
		qea.numphantomspresent,
		qea.stoppedprocesses,
		qea.iowait,
		qea.irq,
		qea.softirq
	FROM  AZDBLab_Experiment ex, 
	      AZDBLab_Experimentrun er, 
	      AZDBLab_Query q, 
	      AZDBLab_QueryExecution qe, 
	      AZDBLab_QueryExecutionHasPlan qp, 
	      AZDBLab_QueryStatEvaluation qea,
	      __Chosen_Runs_Ver1__ c_run,
	      __Chosen_LabShelf_Ver1__ c_labshelf
	 WHERE ex.experimentid=er.experimentid AND 
	       er.runid=q.runid AND 
               q.runid = c_run.runid AND
	       q.queryid=qe.queryid AND 
               qe.queryexecutionid=qp.queryexecutionid AND 
	       qe.queryexecutionid=qea.queryexecutionid AND 
	       er.currentstage  ='Completed' AND
               er.percentage = 100;
ALTER TABLE __Analysis_S0_AQE_Ver1__ ADD PRIMARY KEY (qeid); 

DROP TABLE __Analysis_RowCount_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_RowCount_Ver1__
(
	dbmsName	VARCHAR2(10),
	exprName	VARCHAR2(50),
	stepName	VARCHAR2(50),
	stepResultSize	NUMBER (10, 2),
        PRIMARY KEY (dbmsName, exprName, stepName) 
);

INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S0_AQE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S0_AQE_Ver1__
	GROUP BY dbms, experimentname;

DROP VIEW __Analysis_S1_VQE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S1_VQE_Ver1__ AS
	SELECT *
	FROM __Analysis_S0_AQE_Ver1__
	WHERE measured_time < 9999999;
ALTER VIEW __Analysis_S1_VQE_Ver1__ ADD PRIMARY KEY (qeid) DISABLE;
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_S1_VQE_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S1_VQE_Ver1__
	GROUP BY dbms, experimentname;
DROP VIEW __Analysis_API_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_API_Ver1__ AS
	SELECT DISTINCT 
	       qe.version,
	       qe.experimentid,
	       qe.experimentname,
	       qe.runid,
	       qe.querynum,
	       qe.card as card,
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
	FROM __Analysis_S1_VQE_Ver1__ qe,
	     AZDBLab_QueryExecutionProcs qp
	WHERE qe.qeid = qp.queryexecutionid;
ALTER VIEW __Analysis_API_Ver1__ ADD PRIMARY KEY (qeid, procid) DISABLE; 

DROP TABLE __Analysis_ACDP_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_ACDP_Ver1__ AS
	 SELECT s.runid, 
		s.querynum, 
	        s.card, 
		qp.processid as querypid, 
       		SUM(qp.uTicks+qp.sTicks) q_total_time
	 FROM __Analysis_S1_VQE_Ver1__ s, 
	      AZDBLab_QueryExecutionProcs qp, 
 	      __Analysis_Qmd_Ver1__ qmd 
	WHERE s.qeid = qp.queryexecutionid AND 
	      s.dbms = qmd.dbmsname AND		
	      qp.processname = qmd.qprocname
	GROUP BY runid, querynum, card, qp.processid
	ORDER BY runid ASC, querynum ASC, card DESC, qp.processid ASC, q_total_time DESC;
ALTER TABLE __Analysis_ACDP_Ver1__ ADD PRIMARY KEY (runid, querynum, card, querypid); 

DROP TABLE __Analysis_AQProc_QatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_AQProc_QatC_Ver1__ AS
	SELECT DISTINCT t1.runid, 
			t1.querynum, 
			t1.card, 
			min(t1.querypid) as querypid
	FROM __Analysis_ACDP_Ver1__ t1, 
	     (SELECT DISTINCT t3.runid,
		     t3.querynum, 
		     t3.card, 
		     MAX(t3.q_total_time) AS maxtime 
	      FROM __Analysis_ACDP_Ver1__ t3 
	      GROUP BY t3.runid, t3.querynum, t3.card) t2 
	WHERE t1.runid = t2.runid AND 
	      t1.querynum = t2.querynum AND 
	      t1.card = t2.card AND 
	      t1.q_total_time = t2.maxtime
	GROUP BY t1.runid, t1.querynum, t1.card;
ALTER TABLE __Analysis_AQProc_QatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card); 

DROP TABLE __Analysis_AEQPI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_AEQPI_Ver1__ AS
	SELECT	qeid, 
		uticks, 
		sticks, 
		maj_flt, 
		t1.procid AS procid
	FROM 	__Analysis_API_Ver1__ t1, 
		__Analysis_AQProc_QatC_Ver1__ t2 
	WHERE	t1.runid = t2.runid AND 
		t1.querynum= t2.querynum AND 
		t1.card = t2.card AND 
		t1.procid = t2.querypid;
ALTER TABLE __Analysis_AEQPI_Ver1__ ADD PRIMARY KEY (qeid); 

DROP VIEW __Analysis_ANQPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_ANQPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt,
			   0 AS procid
	FROM __Analysis_API_Ver1__ 
	WHERE qeid NOT IN (SELECT qeid FROM __Analysis_AEQPI_Ver1__);
ALTER VIEW __Analysis_ANQPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 
DROP VIEW __Analysis_AQPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_AQPI_Ver1__ AS
	SELECT * FROM __Analysis_AEQPI_Ver1__
	UNION
	SELECT * FROM __Analysis_ANQPI_Ver1__;
ALTER VIEW __Analysis_AQPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP TABLE __Analysis_AEUPI_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_AEUPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	       	        SUM(uticks) AS uticks,
	  	        SUM(sticks) AS sticks,
		        SUM(maj_flt) AS maj_flt
	FROM __Analysis_API_Ver1__ t1,
 	     __Analysis_Umd_Ver1__ t2
 	WHERE (t1.procid NOT IN (SELECT DISTINCT querypid
	 			 FROM __Analysis_AQProc_QatC_Ver1__
			         WHERE runid    = t1.runid AND
                                       querynum = t1.querynum AND
				       card     = t1.card)) 
	  AND t1.dbms     = t2.dbmsname			   
	  AND t1.procname = t2.uprocname
	GROUP BY qeid;
ALTER TABLE __Analysis_AEUPI_Ver1__ ADD PRIMARY KEY (qeid); 
DROP VIEW __Analysis_ANUPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_ANUPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM __Analysis_API_Ver1__ 
	WHERE qeid NOT IN (SELECT qeid FROM __Analysis_AEUPI_Ver1__);
ALTER VIEW __Analysis_ANUPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP VIEW __Analysis_AUPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_AUPI_Ver1__ AS
	SELECT * FROM __Analysis_AEUPI_Ver1__
	UNION
	SELECT * FROM __Analysis_ANUPI_Ver1__;
ALTER VIEW __Analysis_AUPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP VIEW __Analysis_AEDPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_AEDPI_Ver1__ AS
	SELECT DISTINCT qeid, 
		       SUM(uticks) AS uticks, 
		       SUM(sticks) AS sticks, 
		       SUM(maj_flt) AS maj_flt 
	FROM __Analysis_API_Ver1__ 
	WHERE procname NOT IN (SELECT qprocname 
			       FROM __Analysis_Qmd_Ver1__
			       UNION
			       SELECT uprocname
 			       FROM __Analysis_Umd_Ver1__
			      ) 
        GROUP BY qeid;
ALTER VIEW __Analysis_AEDPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP VIEW __Analysis_ANDPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_ANDPI_Ver1__ AS
	SELECT DISTINCT qeid, 
	  	           0 AS uticks, 
	                   0 AS sticks, 
	 	           0 AS maj_flt 
	FROM __Analysis_API_Ver1__ 
	WHERE qeid NOT IN (SELECT qeid FROM __Analysis_AEDPI_Ver1__);
ALTER VIEW __Analysis_ANDPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP VIEW __Analysis_ADPI_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_ADPI_Ver1__ AS
	SELECT * FROM __Analysis_AEDPI_Ver1__
	UNION
	SELECT * FROM __Analysis_ANDPI_Ver1__;
ALTER VIEW __Analysis_ADPI_Ver1__ ADD PRIMARY KEY (qeid) DISABLE; 

DROP TABLE __Analysis_AQED_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_AQED_Ver1__ AS
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
	FROM	__Analysis_API_Ver1__   proc,
		__Analysis_AQPI_Ver1__ qproc,
		__Analysis_AUPI_Ver1__ util_proc,
		__Analysis_ADPI_Ver1__ dproc
	WHERE 	proc.qeid  = qproc.qeid
	    AND qproc.qeid = util_proc.qeid
	    AND qproc.qeid = dproc.qeid
	ORDER BY proc.qeid ASC;
ALTER TABLE __Analysis_AQED_Ver1__ ADD PRIMARY KEY (qeid); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_AQED_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_AQED_Ver1__
	GROUP BY dbms, experimentname; 
DROP TABLE __Analysis_ACTQatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_ACTQatC_Ver1__ AS
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
		ROUND(MEDIAN((qp_uticks+qp_sticks)*10), 1) as med_cqt,
		ROUND(STDDEV((qp_uticks+qp_sticks)*10), 1) as std_cqt,
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
	FROM __Analysis_AQED_Ver1__ qed
	GROUP BY qed.version, qed.experimentid, qed.experimentname, qed.dbms, qed.runid, qed.querynum, qed.card, qed.planid;
ALTER TABLE __Analysis_ACTQatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       'Analysis_ACTQatC_Ver1' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_ACTQatC_Ver1__
	GROUP BY dbms, experimentname;

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

