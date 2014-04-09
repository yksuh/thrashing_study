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
	
	/**
	 * number of queries
	 */
	protected int numOfTerminals = 0;
	private double xactSizeMin;
	private double xactSizeMax;
	private double xactSizeIncr;
	private double xLocksMin;
	private double xLocksMax;
	private double xLocksIncr;
	private double edbSizeMin;
	private double edbSizeMax;
	private double edbSizeIncr;
	private int batchRunTime;
	private double dbmsCacheBufferSize;
	private int mplMin;
	private int mplMax;
	private int mplIncr;
	
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
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10}, 
			new int[] { 0, 0, 0, 0}, 
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
					"BATCHSETID", 
					"DBMSBufferCacheSize", 
					"NumCores", 
					"BatchSizeIncrement", 
					"Duration", 
					"TransactionSize", 
					"ExclusiveLockRatio", 
					"EffectiveDBRatio", 
					"LockWaitTime", 
					"WasThrashed"
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
	 * The definition of the batch internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT,
			new String[] { 
					"BATCHID", 
					"ITERNUM",
					"SUMEXECUTEDXACTS",
					"elapsedTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10,10}, 
			new int[] { 0, 0, 0,0}, 
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
	 * The definition of the clienthasresult internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable CLIENTHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT,
			new String[] { 
					"CLIENTID",
					"ITERNUM",
					"NUMEXECUTEDXACTS"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			null, // unique
			new String[] { "CLIENTID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "CLIENTID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENT, 
							new String[] { "CLIENTID" }, 
							" ON DELETE CASCADE") 
			},
			null);
	
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
					"XACTNUM"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
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
	
	/**
	 * The definition of the statement internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable STATEMENT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT,
			new String[] { 
					"STMTID",
					"XACTID",
					"STMTNUM", 
					"STMTSQL"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
			}, 
			new int[] {10, 10, 10, 4000}, 
			new int[] { 0, 0, 0, 0}, 
			new String[] { "XACTID", "STMTNUM"}, // unique
			new String[] { "STMTID"}, // primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "XACTID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
							new String[] { "XACTID" }, 
							" ON DELETE CASCADE")
			},
			Constants.SEQUENCE_STATEMENT);
	
	
	
	/***
	 * Makes as many sessions to a DBMS as numTerminals specifies
	 * @throws Exception
	 */
//	protected abstract void stepA(int numClients) throws Exception;
//	protected abstract void stepA(int numClients, double edbSz) throws Exception;
	protected abstract void stepA(int batchID, int numClients, double edbSz) throws Exception;
	
	/***
	 * Runs transactions
	 * @throws Exception
	 */
	protected abstract void stepB(int MPL) throws Exception;
	
//	/**
//	 * Populates transaction tables
//	 * @param curr_table
//	 * @throws Exception 
//	 */
//	protected abstract Vector<Long> stepB() throws Exception;
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

	/**
	 * Initialize notebook content for storing all query execution results.
	 * Populate fixed tables.
	 * @throws Exception
	 */
	protected void preStep() throws Exception {
		initializeNotebookContent();
		// populate fixed tables
		initializeExperimentTables();
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
		// transactio size
		for(double xactSz=xactSizeMin;xactSz<=xactSizeMax;xactSz*=xactSizeIncr){
			// exclusive locks
			for(double xlcks=xLocksMin;xlcks<=xLocksMax;xlcks+=xLocksIncr){
				// effective db size
				for(double edbSz=edbSizeMin;edbSz<=edbSizeMax;edbSz+=edbSizeIncr){
					// increment batch set
					batchSetNum++;
					
					// initialize labshelf content + experiment tables 
					preStep();
					
					// Check this batchset
					int batchSetID = -1;
					ResultSet rs = LabShelfManager.getShelf().executeQuerySQL("SELECT batchSetID from azdblab_batchset where runid = " + runID + " and batchSetNum = " + batchSetNum);
					while(rs.next()){
						batchSetID = rs.getInt(1);
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
						// analyze this batch set
						analyzeBatchSet(batchSetID,
										runID,
										batchSetNum, 
										xactSz,
										xlcks,
										edbSz,
										totalBatchSets);
					}
				}
			}
		}
	}
	
	private void analyzeBatchSet(int batchSetID, 
								 int runID, 
								 int batchSetNum, 
								 double xactSz, 
								 double xlcks, 
								 double edbSz,
							     int totalBatchSets) throws Exception {
		
//		int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;		
//		// run this batch set atomically
//		// run as many transactions as numTerminals specifies 
//		int maxTaskNum = -1; 
//		for(int MPL=mplMin;MPL<=mplMax;MPL+=mplIncr){
//			// get batch ID
//			int batchID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_BATCH);
//			if(MPL <= maxTaskNum-1){
//				Main._logger.outputLog("MPL #" + MPL);
//				Main._logger.outputLog("    >>> studied already" );
//			}else{
//				Main._logger.outputLog("::: MPL="+MPL+" Test :::");
//				stepA(MPL, effectiveDBSz);
//				//recordRunProgress(100, "Done with the initialization of a batch of terminals");
//				
//				// create transactions for each terminal
//				stepB(batchID);
//				
//				
//				// insert a completed task associated with the query number
//				Main._logger.outputLog("before the insertion of the next task number");
//				while(lastStageCnt <= Constants.TRY_COUNTS){	
//					try {
//						// record progress
//						recordRunProgress(100, String.format("Done with BatchSet = %d(/%d)", batchSetNum, totalBatchSets));
//						putNextFGTaskNum(batchSetID, MPL+mplIncr);
//						break;
//					}catch(Exception ex){
//						ex.printStackTrace();
//						Main._logger.reportError(ex.getMessage());
//						lastStageCnt++;
//						lastStageWaitTime *= 2;
//						Main._logger.outputLog("Exponential backoff for last stage is performed for : " + lastStageWaitTime + " (ms)");
//						try {
//							Thread.sleep(lastStageWaitTime);
//						} catch (InterruptedException e) {}
//					}
//				}
//				// if we fail after 10 times, then an exception is eventually made.
//				if(lastStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC in the last stage is not stable.");
//				lastStageCnt = 1; lastStageWaitTime = Constants.WAIT_TIME;
//				Main._logger.outputLog("after the insertion  of the next task number");
//			}
//		}
		
		int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;
		
		// run this batch set atomically
		// run as many transactions as numTerminals specifies 
		for(int MPL=mplMin;MPL<=mplMax;MPL+=mplIncr){
			Main._logger.outputLog("::: MPL="+MPL+" Test :::");
			
			//stepA(MPL, effectiveDBSz);
			//recordRunProgress(100, "Done with the initialization of a batch of terminals");
			
			// create transactions for each terminal
			//stepB(batchID);
		}
		
		// Now, let's insert parameter values into AZDBLab.
		String[] paramVal = new String[BATCHSETHASPARAMETER.columns.length];
		int i=0;
		paramVal[i++] = String.format("%d",   batchSetID);
		paramVal[i++] = String.format("%.2f", dbmsCacheBufferSize);
		paramVal[i++] = String.format("%d",   numCores);
		paramVal[i++] = String.format("%d",   mplIncr);
		paramVal[i++] = String.format("%d",   batchRunTime);
		paramVal[i++] = String.format("%.4f", xactSz);
		paramVal[i++] = String.format("%.2f", xlcks);
		paramVal[i++] = String.format("%.2f", edbSz);
		paramVal[i++] = String.format("%d", 0); // lock wait time
		paramVal[i++] = String.format("%d", 0); // was thrashed
		insertBatchSetParam(paramVal);
		
		// insert a completed task associated with the query number
		Main._logger.outputLog("before the insertion of the next task number");
		while(lastStageCnt <= Constants.TRY_COUNTS){	
			try {
				// record progress
				recordRunProgress(100, String.format("Done with BatchSet = %d(/%d)", batchSetNum, totalBatchSets));
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
	private void insertBatchSetParam(String[] paramVal) {
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
		} catch (SQLException e) {
			Main._logger.reportError(e.getMessage());
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

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