-- Writer: Young-Kyoon Suh (yksuh@cs.arizona.edu)
-- Date: 04/19/14 (v1.0), 05/07/14 (v2.0)
-- Description: Define tables for DBMS thrashing study
-- For each combination of independent variables except the ones in resource complexity, 
-- we create the very first batchset and keep using it on not only DBMSes but also regarding the ones in resource complexity.
-- This is for fair comparison on the identifical batch set on different DBMSes or system configurations. 

-- Define a BatchSet
DROP TABLE AZDBLAB_BATCHSET CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_BATCHSET(
	BatchSetID 	NUMBER(10) NOT NULL PRIMARY KEY, -- batch set identifier
	ExperimentID	NUMBER(10) NOT NULL,   -- experiment id
	BufferSpace 	NUMBER(10,2) NOT NULL, -- buffer space
	NumCores	NUMBER(10) NOT NULL,   -- number of cores
	BatchSzIncr 	NUMBER(10) NOT NULL,   -- batch size increments
	Duration	NUMBER(10) NOT NULL,   -- session duration 
	XactSz      	NUMBER(10,2) NOT NULL,--# of rows for reads
	XLockRatio 	NUMBER(10,4) NOT NULL,--# of rows for updates
	EffectiveDBSz 	NUMBER(10,2) NOT NULL,--active row pool
	UNIQUE (ExperimentID, BatchSzIncr, XactSz, XLockRatio, EffectiveDBSz), -- as generated transactions will depend on these
	FOREIGN KEY (ExperimentID) REFERENCES AZDBLAB_Experiment(ExperimentID) ON DELETE CASCADE
);

-- Define a batch
DROP TABLE AZDBLAB_BATCH CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_BATCH(
	BatchID NUMBER(10) NOT NULL PRIMARY KEY, -- batch identifier
	BatchSetID NUMBER(10) NOT NULL, -- for identifying this batch in the defined batchset
	MPL NUMBER(10) NOT NULL, 	-- for MPL in this batchset
	FOREIGN KEY (BatchSetID) REFERENCES AZDBLAB_BATCHSET(BatchSetID) ON DELETE CASCADE,
	UNIQUE (BatchSetID, MPL)
);

-- Define a client
DROP TABLE AZDBLAB_CLIENT CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_CLIENT(
	ClientID NUMBER(10) NOT NULL PRIMARY KEY, -- client identifier
	BatchID NUMBER(10) NOT NULL,   -- for identifying this client in the defined batch
	ClientNum NUMBER(10) NOT NULL, -- for MPL in this batchset
	FOREIGN KEY (BatchID) REFERENCES AZDBLAB_BATCH(BatchID) ON DELETE CASCADE,
	UNIQUE (BatchID, ClientNum)
);

-- Define a transaction
DROP TABLE AZDBLAB_TRANSACTION CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_TRANSACTION(
	TransactionID NUMBER(10) NOT NULL PRIMARY KEY, -- transaction identifier
	ClientID NUMBER(10) NOT NULL,		 -- for identifying this transaction of the defined client
	TransactionNum NUMBER(10) NOT NULL,      -- for transaction number
	TransactionStr VARCHAR(1000) NOT NULL,   -- for actual string 
	FOREIGN KEY (ClientID) REFERENCES AZDBLAB_CLIENT(ClientID) ON DELETE CASCADE,
	UNIQUE (ClientID, TransactionNum)
);

-- Define a transaction
DROP TABLE AZDBLAB_COMPLETEDBATCHSETTASK CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_COMPLETEDBATCHSETTASK(
	RunID NUMBER(10) NOT NULL,
	TaskNumber NUMBER(10) NOT NULL,      
	TransactionTime VARCHAR(1000) NOT NULL, 
	FOREIGN KEY (RunID) REFERENCES AZDBLAB_EXPERIMENTRUN(RunID) ON DELETE CASCADE,
	PRIMARY KEY (RunID, TaskNumber)
);

-- Record a statement
--DROP TABLE AZDBLAB_STATEMENT CASCADE CONSTRAINTS;
--CREATE TABLE AZDBLAB_STATEMENT(
--	STMTID NUMBER(10) NOT NULL PRIMARY KEY,
--	TransactionID NUMBER(10) NOT NULL,
--	STMTNUM NUMBER(10) NOT NULL,
--	STMTSQL VARCHAR2(2000) NOT NULL,
--	FOREIGN KEY (TransactionID) REFERENCES AZDBLAB_TRANSACTION(TransactionID) ON DELETE CASCADE,
--	UNIQUE (TransactionID, STMTNUM)
--);

-- Record a batchset run record
DROP TABLE AZDBLAB_BATCHSETHASRESULT CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_BATCHSETHASRESULT(
	BatchSetRunResID NUMBER(10) NOT NULL PRIMARY KEY,
	RunID NUMBER(10) NOT NULL,  	-- experiment run on a specific DBMS
	BatchSetID NUMBER(10) NOT NULL, -- defined existing batchset
	AvgXactProcTime NUMBER(10,2), 	-- avg of xact processing time for all batches in this set
	MaxMPL 		NUMBER(10), 	-- max MPL
	UNIQUE(BatchSetID, RunID),	-- per batchset per run
	FOREIGN KEY (BatchSetID) REFERENCES AZDBLAB_BATCHSET(BatchSetID) ON DELETE CASCADE,
	FOREIGN KEY (RunID) REFERENCES AZDBLAB_EXPERIMENTRUN(RunID) ON DELETE CASCADE
);

-- Record a batch run result
DROP TABLE AZDBLAB_BATCHHASRESULT CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_BATCHHASRESULT(
	BatchRunResID NUMBER(10) NOT NULL PRIMARY KEY, -- batch run result identifier
	BatchSetRunResID NUMBER(10) NOT NULL, -- existing batchset run result identifier
	BatchID NUMBER(10) NOT NULL, -- batch identifier
	IterNum NUMBER(10) NOT NULL, -- iteration number
	ElapsedTime NUMBER(10) NOT NULL, -- actual elapsed tiem	
	SumExecXacts NUMBER(10) NOT NULL, -- number of executed transactions
	SumXactProcTime Number(10), 	 -- sum of xact elapsed time of each client
	UNIQUE(BatchSetRunResID, BatchID, IterNum),
	FOREIGN KEY (BatchSetRunResID) REFERENCES AZDBLAB_BATCHSETHASRESULT(BatchSetRunResID) ON DELETE CASCADE,
	FOREIGN KEY (BatchID) REFERENCES AZDBLAB_BATCH(BatchID) ON DELETE CASCADE
);

-- Record a client's result
DROP TABLE AZDBLAB_CLIENTHASRESULT CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_CLIENTHASRESULT(
	ClientRunResID NUMBER(10) NOT NULL PRIMARY KEY,
	BatchRunResID NUMBER(10) NOT NULL,
	ClientID NUMBER(10) NOT NULL,
	IterNum NUMBER(10)  NOT NULL,
	NumExecXacts NUMBER(10)  NOT NULL,
	SumXactProcTime Number(10), -- sum of (lock wait time: elapsed time - min(elaped time))
	UNIQUE(BatchRunResID, ClientID, IterNum), -- same as batch's IterNum
	FOREIGN KEY (BatchRunResID) REFERENCES AZDBLAB_BATCHHASRESULT(BatchRunResID) ON DELETE CASCADE,
	FOREIGN KEY (ClientID) REFERENCES AZDBLAB_CLIENT(ClientID) ON DELETE CASCADE
);

-- Record a transaction's result
DROP TABLE AZDBLAB_TRANSACTIONHASRESULT CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_TRANSACTIONHASRESULT(
	TransactionRunResID NUMBER(10) NOT NULL,
	ClientRunResID NUMBER(10)  NOT NULL,
	TransactionID NUMBER(10) NOT NULL,
	--XACTIterNum NUMBER(10) NOT NULL,
	--RUNTIME NUMBER(10) NOT NULL,
	NumExecs NUMBER(10) NOT NULL,-- number of executions
	MinXactProcTime Number(10)  NOT NULL, -- min xact proc time
	MaxXactProcTime Number(10)  NOT NULL, -- max xact proc time
	SumXactProcTime Number(10)  NOT NULL, -- sum xact proc time
	SumLockWaitTime Number(10)  NOT NULL, -- sum lock wait proc time (sum of xact proc time - min xact proc time)
	UNIQUE (ClientRunResID, TransactionID),
	FOREIGN KEY (ClientRunResID) REFERENCES AZDBLAB_CLIENTHASRESULT(ClientRunResID) ON DELETE CASCADE,
	FOREIGN KEY (TransactionID) REFERENCES AZDBLAB_TRANSACTION(TransactionID) ON DELETE CASCADE
);

-- Defined a completed task within a batchset (not used)
--DROP TABLE AZDBLAB_COMPLETEDFGTASK CASCADE CONSTRAINTS;
--CREATE TABLE AZDBLAB_COMPLETEDFGTASK(
--	BatchSetID NUMBER(10) NOT NULL,
--	TaskNum NUMBER(10) NOT NULL,
--	TransactionTime VARCHAR(100) NOT NULL,
--	FOREIGN KEY (BatchSetID) REFERENCES AZDBLAB_BATCHSET(BatchSetID) ON DELETE CASCADE,
--	PRIMARY KEY(BatchSetID, TaskNum)
--);


-- Record a batchsetsatisfiesaspect
DROP TABLE AZDBLAB_BSSATISFIESASPECT CASCADE CONSTRAINTS;
CREATE TABLE AZDBLAB_BSSATISFIESASPECT(
	BatchSetID NUMBER(10) NOT NULL,
	AspectID NUMBER(10) NOT NULL,
	AspectValue NUMBER(10) NOT NULL,
	FOREIGN KEY (BatchSetID) REFERENCES AZDBLAB_BATCHSET(BatchSetID) ON DELETE CASCADE,
	FOREIGN KEY (AspectID) REFERENCES AZDBLAB_DEFINEDASPECT(AspectID) ON DELETE CASCADE,
	PRIMARY KEY (BatchSetID, AspectID)
);


-- Record a statement execution result
--DROP TABLE AZDBLAB_STATEMENTHASRESULT CASCADE CONSTRAINTS;
--CREATE TABLE AZDBLAB_STATEMENTHASRESULT(
--	TransactionRunResID NUMBER(10) NOT NULL,
--	STMTID NUMBER(10) NOT NULL,
--	STMTIterNum NUMBER(10) NOT NULL,
--	RUNTIME NUMBER(10) NOT NULL,
--	LockWaitTime NUMBER(10),
--	FOREIGN KEY (TransactionRunResID) REFERENCES AZDBLAB_TRANSACTIONHASRESULT(TransactionRunResID) ON DELETE CASCADE,
--	FOREIGN KEY (STMTID) REFERENCES AZDBLAB_STATEMENT(STMTID) ON DELETE CASCADE,
--	PRIMARY KEY (TransactionRunResID, STMTID, STMTIterNum)
--);

DROP SEQUENCE SEQ_BATCHSET;
CREATE SEQUENCE SEQ_BATCHSET   	START WITH 1 NOMAXVALUE;
DROP SEQUENCE SEQ_BATCH;
CREATE SEQUENCE SEQ_BATCH 	START WITH 1 NOMAXVALUE;
DROP SEQUENCE SEQ_CLIENT;
CREATE SEQUENCE SEQ_CLIENT 	START WITH 1 NOMAXVALUE;
DROP SEQUENCE SEQ_TRANSACTION;
CREATE SEQUENCE SEQ_TRANSACTION START WITH 1 NOMAXVALUE;

DROP SEQUENCE SEQ_BATCHSETRESULT;
CREATE SEQUENCE SEQ_BATCHSETRESULT START WITH 1 NOMAXVALUE;
DROP SEQUENCE SEQ_BATCHRESULT;
CREATE SEQUENCE SEQ_BATCHRESULT    START WITH 1 NOMAXVALUE;
DROP SEQUENCE SEQ_CLIENTRESULT;
CREATE SEQUENCE SEQ_CLIENTRESULT   START WITH 1 NOMAXVALUE;
DROP SEQUENCE SEQ_XACTRESULT;
CREATE SEQUENCE SEQ_XACTRESULT 	   START WITH 1 NOMAXVALUE;

