package azdblab.plugins.scenario;

/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
* Young-Kyoon Suh (http://www.cs.arizona.edu/~yksuh/)
*/
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;
import java.util.TreeSet;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.PausedExecutor.PausedExecutorException;
import azdblab.exception.PausedRun.PausedRunException;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TransactionStat;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

/**
 * This experiment concerns transaction throughput collapse.
 * @author yksuh
 *
 */

public abstract class ScenarioBasedOnTransaction extends Scenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public ScenarioBasedOnTransaction(ExperimentRun expRun) {
		super(expRun);
	}
	/***
	 * Number of terminals (left for compatibility but not used)
	 */
	protected int numOfTerminals = 0;
	
//	/**
//	 * all cardinalities to be populated
//	 */
//	protected Vector<Transaction> vecCardinalities;
	
//	/**
//	 * all terminals
//	 */
//	protected List<Terminal> vecTerminals;
	
	
	
	
	/**
	 * The definition of the batch set internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHSET = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET,
			new String[] { 
					"BATCHSETID", 
					"RUNID", 
					"BATCHSETNUM"},
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			new String[] { "RUNID", "BATCHSETNUM"}, // unique
			new String[] { "BATCHSETID" }, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "RUNID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN, 
							new String[] { "RUNID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_BATCHSET);

	/**
	 * The definition of the batch set parameter internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHSETHASPARAMETER = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASPARAMETER,
			new String[] { 
					"BatchSetID", 		// batch set ID
					"BufferSpace", 		// buffer space
					"NumCores", 		// number of cores
					"BatchSzIncr", 		// batch size increments
					"Duration", 		// run duration
					"XactSz", 			// # of shared locks
					"XLockRatio", 		// # of exclusive locks
					"EffectiveDBSz",	// effective database size	 
					"AvgLockWaitTime", 	// lock wait time
					"MaxMPL"			// maximum MPL
			}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
			}, 
			new int[] {10, 10, 10, 10, 10, 10, 10, 10, 10, 10}, 
			new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
			null, // unique
			new String[] { "BATCHSETID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BATCHSETID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
							new String[] { "BATCHSETID" }, 
							" ON DELETE CASCADE") 
			},
			null);
	
	/**
	 * The definition of the batch set parameter internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable COMPLETEDFGTASK = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_COMPLETEDFGTASK,
			new String[] { 
					"BATCHSETID", 
					"TaskNumber", 
					"TRANSACTIONTIME"
			}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
			}, 
			new int[] {10, 10, 100}, 
			new int[] { 0, 0, 0}, 
			null, // unique
			new String[] { "BATCHSETID", "TaskNumber"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BATCHSETID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
							new String[] { "BATCHSETID" }, 
							" ON DELETE CASCADE") 
			},
			null);
	
	/**
	 * The definition of the batch satisfies aspect internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BSSATISFIESASPECT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BSSATISFIESASPECT,
			new String[] { 
					"BATCHSETID", 
					"ASPECTID", 
					"ASPECTVALUE"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			null, // unique
			new String[] { "BATCHSETID", "ASPECTID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BATCHSETID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
							new String[] { "BATCHSETID" }, 
							" ON DELETE CASCADE"),
					new ForeignKey(
							new String[] { "ASPECTID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT, 
							new String[] { "ASPECTID" }, 
							" ON DELETE CASCADE") 
			},
			null);

	/**
	 * The definition of the batch internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCH = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
			new String[] { 
					"BATCHID", 
					"BATCHSETID", 
					"MPL"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			new String[] { "BATCHSETID", "MPL"}, // unique
			new String[] { "BATCHID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BATCHSETID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
							new String[] { "BATCHSETID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_BATCH);	
	/**
	 * The definition of the client internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable CLIENT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_CLIENT,
			new String[] { 
					"CLIENTID",
					"BATCHID", 
					"CLIENTNUM"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			new String[] { "BATCHID", "CLIENTNUM"}, // unique
			new String[] { "CLIENTID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BATCHID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCH, 
							new String[] { "BATCHID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_CLIENT);
	/**
	 * The definition of the transaction internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable TRANSACTION = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION,
			new String[] { 
					"XACTID",
					"CLIENTID", 
					"XACTNUM",
					"XACTSTR"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
			}, 
			new int[] {10, 10, 10, 1000}, 
			new int[] { 0, 0, 0, 0}, 
			new String[] { "CLIENTID", "XACTNUM"}, // unique
			new String[] { "XACTID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "CLIENTID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENT, 
							new String[] { "CLIENTID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_TRANSACTION);	
//	/**
//	 * The definition of the statement internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable STATEMENT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT,
//			new String[] { 
//					"STMTID",
//					"XACTID",
//					"STMTNUM", 
//					"STMTSQL"}, 
//			new int[] { 
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR
//			}, 
//			new int[] {10, 10, 10, 4000}, 
//			new int[] { 0, 0, 0, 0}, 
//			new String[] { "XACTID", "STMTNUM"}, // unique
//			new String[] { "STMTID"}, // primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "XACTID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
//							new String[] { "XACTID" }, 
//							" ON DELETE CASCADE")
//			},
//			Constants.SEQUENCE_STATEMENT);
	/**
	 * The definition of the batch internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT,
			new String[] { 
					"BATCHID", 
					"ITERNUM",
					"SumEXECUTEDXACTS",
					"elapsedTime",
					"SumLockWaitTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10, 10}, 
			new int[] { 0, 0, 0, 0, 1}, 
			null, // unique
			new String[] { "BATCHID", "ITERNUM"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BATCHID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCH, 
							new String[] { "BATCHID" }, 
							" ON DELETE CASCADE") 
			},
			null);

	/**
	 * The definition of the clienthasresult internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable CLIENTHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT,
			new String[] { 
					"CLIRESID",
					"CLIENTID",
					"ITERNUM",
					"NUMEXECUTEDXACTS",
					"LockWaitTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10, 10}, 
			new int[] { 0, 0, 0, 0, 0}, 
			new String[] { "CLIENTID", "ITERNUM"}, 	// primary key // unique
			new String[] { "CLIRESID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "CLIENTID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENT, 
							new String[] { "CLIENTID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_CLIENTHASRESULT);
	

	/**
	 * The definition of the transactionhasresult internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable TRANSACTIONHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTIONHASRESULT,
			new String[] { 
					"XACTRESID",
					"CLIRESID",
					"XACTID",
					"XACTITERNUM",
					"RunTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10, 10}, 
			new int[] { 0, 0, 0, 0, 0}, 
			new String[] { "CLIRESID", "XACTID", "XACTITERNUM"}, 	// unique
			new String[] { "XACTRESID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "CLIRESID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT, 
							new String[] { "CLIRESID" }, 
							" ON DELETE CASCADE"),
					new ForeignKey(
							new String[] { "XACTID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
							new String[] { "XACTID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_TRANSACTIONHASRESULT);	
//	/**
//	 * The definition of the statementhasresult internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable STATEMENTHASRESULT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_STATEMENTHASRESULT,
//			new String[] { 
//					"XACTRESID",
//					"STMTID",
//					"STMTITERNUM",
//					"RunTime",
//					"LockWaitTime"}, 
//			new int[] { 
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER
//			}, 
//			new int[] {10, 10, 10, 10, 10}, 
//			new int[] { 0, 0, 0, 0, 1}, 
//			null, // unique
//			new String[] { "XACTRESID", "STMTID", "STMTITERNUM"}, 	// primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "XACTRESID"}, 
//							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTIONHASRESULT,
//							new String[] { "XACTRESID" }, 
//							" ON DELETE CASCADE"),
//					new ForeignKey(
//							new String[] { "STMTID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT, 
//							new String[] { "STMTID" }, 
//							" ON DELETE CASCADE")
//			},
//			null);
	
	/**
	 * Initialize experiment tables for thrashing study
	 * Populate database
	 * @throws Exception
	 */
	protected void preStep() throws Exception {
		initializeNotebookContent();
		// populate fixed tables
		initializeExperimentTables();
	}
	
	/*****
	 * Analyze a batch set
	 * @param batchSetID batch set ID
	 * @param transactionSize transaction size
	 * @param eXclusiveLocks exclusive locks
	 * @param effectiveDBSize effective DB size
	 * @param totalBatchSets number of batch sets
	 * @throws Exception
	 */
	protected abstract void analyzeBatchSet(int batchSetID, 
											double transactionSize, 
											double eXclusiveLocks, 
											double effectiveDBSize,
										    int totalBatchSets)  throws Exception;
	/****
	 * Store batch set parameters into AZDBLab
	 * @param batchSetID current batch set
	 * @param transactionSize transaction size
	 * @param exclusiveLockRatio exclusive lock ratio
	 * @param effectiveDBRatio effective DB ratio
	 * @throws Exception
	 */
	protected abstract void stepA(int batchSetID, 
						 double transactionSize, 
						 double exclusiveLockRatio, 
						 double effectiveDBRatio) throws Exception;
	/***
	 * Initialize as many clients as MPL for each batch in this batch set
	 * @throws Exception
	 */
	protected abstract void stepB(int batchID, int MPL, 
								  double transactionSize, 
								  double eXclusiveLcks, 
								  double effectiveDBSize) throws Exception;
	/***
	 * Runs transactions per client in a batch
	 * @throws Exception
	 */
	protected abstract void stepC(int MPL) throws Exception;
	/**
	 * @see azdblab.plugins.scenario.Scenario#executeSpecificExperiment()
	 */
	protected final void executeSpecificExperiment() throws Exception {
		int runID = exp_run_.getRunID();
		int maxTaskNum = -1;
		// generate batchsets
		int batchSetNum = 0;
		int totalXactSz = (int)Math.log10(xactSizeMax/xactSizeMin)+1;
		int totalExLcks = (int)((xLocksMax-xLocksMin)/xLocksIncr)+1;
		int totalEDBSize = (int)((edbSizeMax-edbSizeMin)/edbSizeIncr)+1;
		int totalBatchSets = totalXactSz*totalExLcks*totalEDBSize;
		double xactSz=xactSizeMin, xlcks=xLocksMin;
		// transactio size
		//for(double xactSz=xactSizeMin;xactSz<=xactSizeMax;xactSz*=xactSizeIncr){
			// exclusive locks
			//for(double xlcks=xLocksMin;xlcks<=xLocksMax;xlcks+=xLocksIncr){
				// effective db size
				for(double edbSz=edbSizeMin;edbSz<=edbSizeMax;edbSz+=edbSizeIncr){
					// increment batch set
					batchSetNum++;
					
					// Check this batchset
					int batchSetID = -1;	
					ResultSet rs = LabShelfManager.getShelf().executeQuerySQL("SELECT batchSetID from azdblab_batchset where runid = " + runID + " and batchSetNum = " + batchSetNum);
					try{
						while(rs.next()){
							batchSetID = rs.getInt(1);
						}
						rs.close();
					}catch(Exception ex){
						ex.printStackTrace();
					}
					// not existing ...
					if(batchSetID == -1){
						// obtain a new batch set id
						batchSetID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_BATCHSET);
						// insert this batch set into AZDBLab 
						insertBatchSet(batchSetID, runID, batchSetNum);
					}
					Main._logger.outputLog(String.format("BatchSet #%d (%d) in runID (%d) (%.4f/%.2f/%.2f)", batchSetNum, batchSetID, runID, xactSz, xlcks, edbSz));
					
					// get task number 
					maxTaskNum = getMaxTaskNum(runID);
					if(batchSetNum <= maxTaskNum-1){
						Main._logger.outputLog("    >>> studied already" );
					}else{
						int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;
					
						// initialize experiment tables 
						preStep();
						
						// analyze this batch set
						analyzeBatchSet(batchSetID,
										xactSz,
										xlcks,
										edbSz,
										totalBatchSets);
						
						// insert a completed task associated with the query number
						Main._logger.outputLog("before the insertion of the next task number");
						while(lastStageCnt <= Constants.TRY_COUNTS){	
							try {
								// record progress
								recordRunProgress(100, String.format("Done with BatchSet = %d(/%d)", batchSetNum, totalBatchSets));
								// store next task number
								putNextTaskNum(runID, batchSetNum+1);
								break;
							}catch(Exception ex){
								ex.printStackTrace();
								Main._logger.reportError(ex.getMessage());
								lastStageCnt++;
								lastStageWaitTime *= 2;
								Main._logger.outputLog("Exponential backoff for last stage is performed for : " + lastStageWaitTime + " (ms)");
								try {
									Thread.sleep(lastStageWaitTime);
								} catch (InterruptedException e) {}
							}
						}
						// if we fail after 10 times, then an exception is eventually made.
						if(lastStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC in the last stage is not stable.");
						lastStageCnt = 1; lastStageWaitTime = Constants.WAIT_TIME;
						Main._logger.outputLog("after the insertion  of the next task number");
					}
				}
			//}
		//}
	}

	/****
	 * Get fine-grained task number (MPL at a specific batch set)
	 * @param runID
	 * @param BatchSetNum
	 * @return
	 * @throws Exception
	 */
	protected int getMaxFGTaskNum(int batchSetID) throws Exception {
		int res = -1;
		String table_name = Constants.TABLE_PREFIX + Constants.TABLE_COMPLETEDFGTASK;
		String sql = "SELECT max(TASKNUMBER) FROM " + table_name + " WHERE batchSetID = " + batchSetID;
		Main._logger.outputLog("task sql: " + sql);
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			Main._logger.outputLog("current taskNum: " + rs.getInt(1));
			res = rs.getInt(1);
		}
		return res;
	}
	
	/****
	 * Put fine-grained task number (next MPL at the specific batch set)
	 * @param runID
	 * @param BatchSetNum
	 * @param task_num
	 * @throws Exception
	 */
	protected void putNextFGTaskNum(int batchSetID, int task_num) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
		String transactionTime = sdf.format(new Date(System.currentTimeMillis()));
		String table_name = Constants.TABLE_PREFIX + Constants.TABLE_COMPLETEDFGTASK;
		String sql = "INSERT INTO " + table_name + " VALUES(" + batchSetID + "," + task_num + ", to_timestamp('" + transactionTime + "'" + ", '" + Constants.TIMESTAMPFORMAT + "'))";
		Main._logger.outputLog("task sql: " + sql);
		LabShelfManager.getShelf().executeUpdateSQL(sql);
		// LabShelfManager.getShelf().commit();
	}	
	
	/****
	 * Insert batch set into AZDBLab
	 * @param batchSetID batch set ID
	 * @param runID runID
	 * @param batchSetNum batch set number
	 */
	private void insertBatchSet(int batchSetID, int runID, int batchSetNum) {
		// insert a pair of key-value
		try {
			LabShelfManager.getShelf().insertTuple(
						Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
						BATCHSET.columns, 
						new String[] {
								String.valueOf(batchSetID),
								String.valueOf(runID),
								String.valueOf(batchSetNum)
						},
						BATCHSET.columnDataTypes);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException e) {
			Main._logger.reportError(e.getMessage());
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/****
	 * Insert batch set parameter
	 * @param batchSetID batch set ID
	 * @param paramVal parameter key-value map
	 */
	protected void insertBatchSetParam(String[] paramVal) {
		// insert a pair of key-value
		try {
			LabShelfManager.getShelf().insertTuple(
						Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASPARAMETER, 
						BATCHSETHASPARAMETER.columns, 
						new String[] {
								paramVal[0], // batchSetID
								paramVal[1], // DBMS Buffer Cache Size
								paramVal[2], // Number of Cores
								paramVal[3], // BatchSize Increments
								paramVal[4], // Batch Run Time (duration)
								paramVal[5], // Transaction Size (# of locks)
								paramVal[6], // Exclusive ratio (# of write locks)
								paramVal[7], // Effective DB size 
								paramVal[8], // Lock Wait Time
								paramVal[9], // Was Thrashed?
						},
						BATCHSETHASPARAMETER.columnDataTypes);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException e) {
			Main._logger.reportError(e.getMessage());
			// TODO Auto-generated catch block
//			e.printStackTrace();
			String updateSQL = "UPDATE AZDBLAB_BATCHSETHASPARAMETER " + 
							   "SET BufferSpace = " + paramVal[1] + 
							   " and NumCores = " + paramVal[2] + 
							   " and BatchSzIncr = " + paramVal[3] + 
							   " and Duration = " + paramVal[4] + 
							   " and XactSz = " + paramVal[5] + 
							   " and XLockRatio = " + paramVal[6] + 
							   " and EffectiveDBSz = " + paramVal[7] + 
							   " and AvgLockWaitTime = " + paramVal[8]+ 
							   " and MaxMPL = " + paramVal[9] + 
							   " WHERE batchSetID = " + paramVal[0];
			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
		}
	}

	/**
	 * Setting up the necessary variables for experiment.
	 * 
	 * @throws Exception
	 */
	private void initializeNotebookContent() throws Exception {
		myXactTables = experimentRun.getXactTables();
	}

	/**
	 * Creating and populating experiment tables.
	 * 
	 * @throws Exception
	 */
	private void initializeExperimentTables() throws Exception {
		/*if (myXactTables.length != 1) {
			Main._logger.reportError("OneDimensionalExhaustiveAnalyzer: too many or too few variable "
							+ "tables: " + myXactTables.length);
			System.exit(1);
		}*/

		// boolean isVariable = false;
		// Set up fixed tables
		for (int i = 0; i < myXactTables.length; i++) {
			Table curr_table = myXactTables[i];
			populateXactTable(curr_table);
			// (int)((double)(i + 1) / (double)myVariableTables.length * 100) =
			// % completed
			recordRunProgress((int) ((double) (i + 1)
					/ (double) myXactTables.length * 100),
					"Populating Transaction Tables");
		}
	}
	/****
	 * Set parameters specified in the spec
	 */
	protected final void setParameters(double dbmsCacheBuffSz,
									   int nCores,
									   int duration,
									   int bszMin,
									   int bszMax,
									   int bszIncr,
									   double xactSzMin,
									   double xactSzMax,
									   double xactSzIncr,
									   double xlcksMin,
									   double xlcksMax,
									   double xlcksIncr,
									   double edbSzMin,
									   double edbSzMax,
									   double edbSzIncr){
		dbmsCacheBufferSize = dbmsCacheBuffSz;
		numCores = 	nCores;
		batchRunTime = duration;
		mplMin   = bszMin;
		mplMax   = bszMax;
		mplIncr  = bszIncr;
		xactSizeMin   = xactSzMin;
		xactSizeMax   = xactSzMax;
		xactSizeIncr  = xactSzIncr;
		xLocksMin   = xlcksMin;
		xLocksMax   = xlcksMax;
		xLocksIncr  = xlcksIncr;
		edbSizeMin   = edbSzMin;
		edbSizeMax   = edbSzMax;
		edbSizeIncr  = edbSzIncr;
	}
	/****
	 * Drop experiment tables for clean up
	 */
	protected void dropExperimentTables() throws Exception {
		Main._logger.outputLog("## <EndOfExperiment> Purge Already installed tables ##################");
		// 	find all tables in the experimentSubject
		experimentSubject.dropAllInstalledTables();
		Main._logger.outputLog("######################################################################");
		
		// sanity check on table drop
		for (int i = 0; i < myXactTables.length; i++) {
			Table curr_table = myXactTables[i];
			// sanity check for table drop
			if(experimentSubject.tableExists(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("Experiment paused by sanity check violation on table drop of " + curr_table.table_name_with_prefix + ".");
			}
		}
	}
//	/**
//	 * Measuring the transaction per second
//	 * @return The <code>TransactionStat</code> instance which contains number of transactions executed.
//	 */
//	protected TransactionStat makeTransactionProcessing() throws Exception {
//		TransactionStat xact_stat = experimentSubject.runTransactions();
//		return xact_stat;
//	}
	
	/**
	 * The tables that are fixed for this experiment.
	 */
	protected static Table[] myXactTables;
}