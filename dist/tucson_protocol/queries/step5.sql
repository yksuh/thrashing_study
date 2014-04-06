DROP VIEW __Analysis_S5_I_EQTV_PDE_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S5_I_EQTV_PDE_Ver1__ AS
	SELECT dbms, 
	       experimentname,
	       count(t1.numExcVarPerRun) AS numExcVarPerDBMSPerExp
	FROM  (
		SELECT t0.dbms, 
		       t0.experimentname,
		       t0.runid, 
		       COALESCE(count(t0.card), 0) AS numExcVarPerRun
		FROM (SELECT dbms,
			     experimentname,
			     runid,
			     querynum,
			     card
		      FROM __Analysis_QED_Ver1__ qed,
			   __Analysis_Dmd_Ver1__ dmd
		      WHERE qed.dbms = dmd.dbmsname 
		      HAVING TRUNC(STDDEV(querytime+qp_uticks*dmd.coef), 0) > CEIL(0.2 * AVG(querytime+qp_uticks*dmd.coef))
		      GROUP BY dbms, experimentname, runid, querynum, card) t0
		GROUP BY dbms, experimentname, runid) t1
	GROUP BY dbms, experimentname;
ALTER VIEW __Analysis_S5_I_EQTV_PDE_Ver1__ ADD PRIMARY KEY (dbms, experimentname) DISABLE; 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       '__Analysis_S5_I_EQTV_PDE_Ver1__' as stepName,
	       COUNT(*) as stepResultSize
	FROM __Analysis_S5_I_EQTV_PDE_Ver1__
	GROUP BY dbms, experimentname;
DROP VIEW __Analysis_S5_I_EQTV_Ver1__ CASCADE CONSTRAINTS;
CREATE VIEW __Analysis_S5_I_EQTV_Ver1__ AS
	SELECT COALESCE(SUM(numExcVarPerDBMSPerExp), 0) AS excVarQatCs
	FROM __Analysis_S5_I_EQTV_PDE_Ver1__;
DROP TABLE __Analysis_SPQatC_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_SPQatC_Ver1__ AS
	SELECT p1.*, 
	       p2.card as card2, 
	       p2.med_cqt as med_cqt2,
	       p2.std_cqt as std_cqt2
	FROM __Analysis_S4_CTQatC_Ver1__ p1, 		
	     __Analysis_S4_CTQatC_Ver1__ p2 
	WHERE p1.runid    = p2.runid    AND
	      p1.querynum = p2.querynum AND
	      p1.planid   = p2.planid   AND
	      p1.card < p2.card
	ORDER BY p1.runid, p1.querynum, p1.card, p2.card;
ALTER TABLE __Analysis_SPQatC_Ver1__ ADD PRIMARY KEY (runid, querynum, card, card2); 
DROP TABLE __Analysis_S5_II_TSM_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S5_II_TSM_Ver1__ AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM __Analysis_SPQatC_Ver1__
	WHERE med_cqt > med_cqt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE __Analysis_S5_II_TSM_Ver1__ ADD PRIMARY KEY (runid, querynum, card, card2); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       '__Analysis_S5_II_TSM_Ver1__' as stepName,
	       COALESCE(count(*),0) as stepResultSize
	FROM __Analysis_S5_II_TSM_Ver1__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_S5_II_SMVP_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S5_II_SMVP_Ver1__ AS
	 SELECT *
	 FROM (
		SELECT t2.*
 	 	FROM __Analysis_S5_II_TSM_Ver1__ t1,
	     	     __Analysis_QED_Ver1__ t2
		WHERE t1.runid    = t2.runid AND
     	       	      t1.querynum = t2.querynum AND
	              t1.card     = t2.card
		UNION
		SELECT t2.*
		FROM __Analysis_S5_II_TSM_Ver1__ t1,
              	     __Analysis_QED_Ver1__ t2
		WHERE t1.runid    = t2.runid AND
               	      t1.querynum = t2.querynum AND
		      t1.card2    = t2.card  -- higher cardinality
	      ) t0 
         ORDER BY runid, card, querynum asc;
ALTER TABLE __Analysis_S5_II_SMVP_Ver1__ ADD PRIMARY KEY (qeid); 
DROP TABLE __Analysis_S5_II_TRM_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S5_II_TRM_Ver1__ AS
	SELECT dbms, 
	       experimentname, 
	       runid,
	       querynum,
	       card,
	       card2
	FROM __Analysis_SPQatC_Ver1__
	WHERE med_cqt-0.5*std_cqt > med_cqt2+0.5*std_cqt2
	GROUP BY dbms, experimentname,runid,querynum,card,card2;
ALTER TABLE __Analysis_S5_II_TRM_Ver1__ ADD PRIMARY KEY (runid, querynum, card, card2); 
INSERT INTO __Analysis_RowCount_Ver1__ (dbmsName, exprName, stepName, stepResultSize)
	SELECT dbms as dbmsName, 
	       experimentname as exprName,
	       '__Analysis_S5_II_TRM_Ver1__' as stepName,
	       COALESCE(COUNT(*), 0) as stepResultSize
	FROM __Analysis_S5_II_TRM_Ver1__
	GROUP BY dbms, experimentname;
DROP TABLE __Analysis_S5_II_RMVP_Ver1__ CASCADE CONSTRAINTS;
CREATE TABLE __Analysis_S5_II_RMVP_Ver1__ AS
	 SELECT *
	 FROM (
		SELECT t2.*
 	 	FROM __Analysis_S5_II_TRM_Ver1__ t1,
	     	     __Analysis_QED_Ver1__ t2
		WHERE t1.runid    = t2.runid AND
     	       	      t1.querynum = t2.querynum AND
	              t1.card     = t2.card
		UNION
		SELECT t2.*
		FROM __Analysis_S5_II_TRM_Ver1__ t1,
              	     __Analysis_QED_Ver1__ t2
		WHERE t1.runid    = t2.runid AND
               	      t1.querynum = t2.querynum AND
		      t1.card2    = t2.card
	      ) t0 
         ORDER BY runid, card, querynum asc;
ALTER TABLE __Analysis_S5_II_RMVP_Ver1__ ADD PRIMARY KEY (qeid);
SELECT * 
FROM __Analysis_RowCount_Ver1__ 
ORDER BY dbmsname, exprName, stepResultSize desc, stepName asc;
SELECT stepName, sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
GROUP BY stepName
ORDER BY stepResultSize desc, stepName asc;

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S2_I_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S2_II_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S2_III_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S2_IV_Ver1__';
SELECT COUNT(*) FROM __Analysis_S1_VQE_Ver1__;

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S3_I_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S3_II_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S3_III_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S3_IV_Ver1__';
SELECT COUNT(*) FROM __Analysis_ASPQatC_Ver1__;

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S5_II_TSM_Ver1__';

SELECT sum(stepResultSize) as stepResultSize 
FROM __Analysis_RowCount_Ver1__ 
WHERE stepName='__Analysis_S5_II_TRM_Ver1__';


