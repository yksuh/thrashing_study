package azdblab.plugins.scenario;

import java.sql.SQLException;

import azdblab.Constants;
import azdblab.exception.PausedExecutor.PausedExecutorException;
import azdblab.exception.PausedRun.PausedRunException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

/**
 * This experiment concerns transaction throughput collapse.
 * @author yksuh
 *
 */

public abstract class ScenarioBasedOnBatchSet extends Scenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public ScenarioBasedOnBatchSet(ExperimentRun expRun) {
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
	
	
//	/**
//	 * The definition of the batch set internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable BATCHSET = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET,
//			new String[] { 
//					"BatchSetID", 
//					"RUNID", 
//					"BATCHSETNUM",
//					"AvgXactProcTime", 	// average xact processing time
//					"MaxMPL"			// maximum MPL
//			},
//			new int[] { 
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER
//			}, 
//			new int[] {10, 10, 10,10,10}, 
//			new int[] { 0, 0, 0,1,1}, 
//			new String[] { "RUNID", "BATCHSETNUM"}, // unique
//			new String[] { "BatchSetID" }, 	// primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "RUNID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN, 
//							new String[] { "RUNID" }, 
//							" ON DELETE CASCADE") 
//			},
//			Constants.SEQUENCE_BATCHSET);
	
	/**
	 * The definition of the batchset internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHSET = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET,
			new String[] { 
					"BatchSetID", 
					"ExperimentID",		// experiment id 
					"BatchSzIncr", 		// batch size increments
					"XactSz", 			// # of rows for reads
					"XLockRatio", 		// # of rows for writes
					"EffectiveDBSz",	// effective database size (active row pool)
					"ShortTxnRate"	// short transaction rate 
			},
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10,10, 10,10,10,10,10}, 
			new int[] {0,0, 0,0,0,0, 0}, 
			new String[] {"ExperimentID", "BatchSzIncr", "XactSz", "XLockRatio", "EffectiveDBSz", "ShortTxnRate"}, // unique
			new String[] {"BatchSetID" }, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "ExperimentID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT, 
							new String[] { "ExperimentID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_BATCHSET);
	/**
	 * The definition of the batch internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCH = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
			new String[] { 
					"BatchID", 
					"BatchSetID", 
					"MPL"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			new String[] { "BatchSetID", "MPL"}, // unique
			new String[] { "BatchID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BatchSetID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
							new String[] { "BatchSetID" }, 
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
					"ClientID",
					"BatchID", 
					"ClientNum"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10}, 
			new int[] { 0, 0, 0}, 
			new String[] { "BatchID", "ClientNum"}, // unique
			new String[] { "ClientID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BatchID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCH, 
							new String[] { "BatchID" }, 
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
					"TransactionID",
					"ClientID", 
					"TransactionNum",
					"TransactionStr"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
			}, 
			new int[] {10, 10, 10, 2000}, 
			new int[] { 0, 0, 0, 0}, 
			new String[] { "ClientID", "TransactionNum"}, // unique
			new String[] { "TransactionID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "ClientID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENT, 
							new String[] { "ClientID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_TRANSACTION);	
	
	/**
	 * The definition of the batch set parameter internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable COMPLETED_BATCHSETTASK = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_COMPLETED_BATCHSETTASK,
			new String[] { 
					"RunID", 
					"TaskNumber", 
					"TransactionTime"
			}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
			}, 
			new int[] {10, 10, 100}, 
			new int[] { 0, 0, 0}, 
			null, // unique
			new String[] { "RunID", "TaskNumber"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "RunID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN, 
							new String[] { "RunID" }, 
							" ON DELETE CASCADE") 
			},
			null);
//	/**
//	 * The definition of the statement internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable STATEMENT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT,
//			new String[] { 
//					"STMTID",
//					"TransactionID",
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
//			new String[] { "TransactionID", "STMTNUM"}, // unique
//			new String[] { "STMTID"}, // primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "TransactionID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
//							new String[] { "TransactionID" }, 
//							" ON DELETE CASCADE")
//			},
//			Constants.SEQUENCE_STATEMENT);
	
	
	/**
	 * The definition of the batch set internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHSETHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASRESULT,
			new String[] { 
					"BatchSetRunResID", // batchset run result identifier
					"RunID", 			// runID
					"BatchSetID",		// batchset identifier
					"NumCores", 		// number of cores
					"BufferSpace", 		// buffer space
					"Duration", 		// run duration
					"AvgXactProcTime", 	// average xact processing time
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
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10,10,10,10,10,10}, 
			new int[] { 0,  0, 0,0,0, 0,1,1}, 
			new String[] { "BatchSetID", "RunID"}, // unique
			new String[] { "BatchSetRunResID" }, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BatchSetID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
							new String[] { "BatchSetID" }, 
							" ON DELETE CASCADE"),
					new ForeignKey(
							new String[] { "RunID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN, 
							new String[] { "RunID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_BATCHSETHASRESULT);

	/**
	 * The definition of the batch internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable BATCHHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT,
			new String[] { 
					"BatchRunResID", 	// primary key
					"BatchSetRunResID", // partial key
					"BatchID", 			// partial key
					"IterNum", 			// partial key
					"elapsedTime",
					"SumExecXacts",
					"SumXactProcTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10, 10, 10,10}, 
			new int[] { 0, 0, 0, 0, 0, 0,0}, 
			new String[] {"BatchSetRunResID", "BatchID", "IterNum"}, // unique
			new String[] {"BatchRunResID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BatchSetRunResID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASRESULT, 
							new String[] { "BatchSetRunResID" }, 
							" ON DELETE CASCADE"),
					new ForeignKey(
							new String[] { "BatchID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCH, 
							new String[] { "BatchID" }, 
							" ON DELETE CASCADE")
			},
			Constants.SEQUENCE_BATCHHASRESULT);

	/**
	 * The definition of the clienthasresult internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable CLIENTHASRESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT,
			new String[] { 
					"ClientRunResID",
					"BatchRunResID",
					"ClientID",
					"IterNum",
					"NumExecXACTS",
					"SumXactProcTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10, 10, 10}, 
			new int[] {0, 0, 0, 0, 0, 0}, 
			new String[] { "BatchRunResID", "ClientID", "IterNum"}, 	// primary key // unique
			new String[] { "ClientRunResID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "BatchRunResID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT, 
							new String[] { "BatchRunResID" }, 
							" ON DELETE CASCADE"),
					new ForeignKey(
							new String[] { "ClientID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENT, 
							new String[] { "ClientID" }, 
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
					"TransactionRunResID",
					"ClientRunResID",
					"TransactionID",
					"NumExecs",
					"MinXactProcTime",
					"MaxXactProcTime",
					"SumXactProcTime",
					"SumLockWaitTime"}, 
			new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, 
			new int[] {10, 10, 10, 10, 10,10, 10, 10}, 
			new int[] { 0, 0, 0, 0, 0,0, 0, 0}, 
			new String[] { "ClientRunResID", "TransactionID"}, 	// unique
			new String[] { "TransactionRunResID"}, 	// primary key
			new ForeignKey[] { 
					new ForeignKey(
							new String[] { "ClientRunResID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT, 
							new String[] { "ClientRunResID" }, 
							" ON DELETE CASCADE"),
					new ForeignKey(
							new String[] { "TransactionID" }, 
							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
							new String[] { "TransactionID" }, 
							" ON DELETE CASCADE") 
			},
			Constants.SEQUENCE_TRANSACTIONHASRESULT);	
	
	

	/**
	 * The definition of the transactionhasresult internal table.
	 * 
	 * @see InternalTable
	 */
//	public static final InternalTable TRANSACTIONHASRESULT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTIONHASRESULT,
//			new String[] { 
//					"TransactionRunResID",
//					"ClientRunResID",
//					"TransactionID",
//					"XACTIterNum",
//					"RunTime"}, 
//			new int[] { 
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER
//			}, 
//			new int[] {10, 10, 10, 10, 10}, 
//			new int[] { 0, 0, 0, 0, 0}, 
//			new String[] { "ClientRunResID", "TransactionID", "XACTIterNum"}, 	// unique
//			new String[] { "TransactionRunResID"}, 	// primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "ClientRunResID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT, 
//							new String[] { "ClientRunResID" }, 
//							" ON DELETE CASCADE"),
//					new ForeignKey(
//							new String[] { "TransactionID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
//							new String[] { "TransactionID" }, 
//							" ON DELETE CASCADE") 
//			},
//			Constants.SEQUENCE_TRANSACTIONHASRESULT);
//	/**
//	 * The definition of the statementhasresult internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable STATEMENTHASRESULT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_STATEMENTHASRESULT,
//			new String[] { 
//					"TransactionRunResID",
//					"STMTID",
//					"STMTIterNum",
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
//			new String[] { "TransactionRunResID", "STMTID", "STMTIterNum"}, 	// primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "TransactionRunResID"}, 
//							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTIONHASRESULT,
//							new String[] { "TransactionRunResID" }, 
//							" ON DELETE CASCADE"),
//					new ForeignKey(
//							new String[] { "STMTID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT, 
//							new String[] { "STMTID" }, 
//							" ON DELETE CASCADE")
//			},
//			null);
	

//	/**
//	 * The definition of the batch set parameter internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable BATCHSETHASPARAMETER = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASPARAMETER,
//			new String[] { 
//					"BatchSetID", 		// batch set ID
//					"BufferSpace", 		// buffer space
//					"NumCores", 		// number of cores
//					"BatchSzIncr", 		// batch size increments
//					"Duration", 		// run duration
//					"XactSz", 			// # of rows for reads
//					"XLockRatio", 		// # of rows for writes
//					"EffectiveDBSz"	// effective database size (active row pool)	 
//			}, 
//			new int[] { 
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER
//			}, 
//			new int[] {10, 10, 10, 10, 10, 10, 10, 10}, 
//			new int[] { 0, 0, 0, 0, 0, 0, 0, 0}, 
//			null, // unique
//			new String[] { "BatchSetID"}, 	// primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "BatchSetID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
//							new String[] { "BatchSetID" }, 
//							" ON DELETE CASCADE") 
//			},
//			null);
//	
//	/**
//	 * The definition of the batch satisfies aspect internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable BSSATISFIESASPECT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_BSSATISFIESASPECT,
//			new String[] { 
//					"BatchSetID", 
//					"ASPECTID", 
//					"ASPECTVALUE"}, 
//			new int[] { 
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER
//			}, 
//			new int[] {10, 10, 10}, 
//			new int[] { 0, 0, 0}, 
//			null, // unique
//			new String[] { "BatchSetID", "ASPECTID"}, 	// primary key
//			new ForeignKey[] { 
//					new ForeignKey(
//							new String[] { "BatchSetID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
//							new String[] { "BatchSetID" }, 
//							" ON DELETE CASCADE"),
//					new ForeignKey(
//							new String[] { "ASPECTID" }, 
//							Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT, 
//							new String[] { "ASPECTID" }, 
//							" ON DELETE CASCADE") 
//			},
//			null);
	
	/**
	 * Initialize experiment tables for thrashing study
	 * Populate database
	 * @throws Exception
	 */
	protected void preStep(boolean first) throws Exception {
		initializeNotebookContent();
		// populate fixed tables
		initializeExperimentTables(first);
	}
	
	/******
	 * Study a batch set
	 * @param runID runID
	 * @param numCores number of cores
	 * @param bufferSpace buffer space ratio
	 * @param duration duration
	 * @param transactionSize transaction size
	 * @param eXclusiveLocks exclusive locks
	 * @param effectiveDBSize effective DB size
	 * @param srtTxnRate short Txn rate 
	 * @throws Exception
	 */
	protected abstract void studyBatchSet(int runID,
											int numCores,
											double bufferSpace,
											int duration,
											double transactionSize, 
											double eXclusiveLocks, 
											double effectiveDBSize,
											double srtTxnRate)  throws Exception;

	/****
	 * Store batch set into AZDBLab
	 * @param transactionSize transaction size
	 * @param exclusiveLockRatio exclusive lock ratio
	 * @param effectiveDBRatio effective DB ratio
	 * @return BatchSetID current batch set
	 * @throws Exception
	 */
	protected abstract int stepA(double transactionSize, 
						 double exclusiveLockRatio, 
						 double effectiveDBRatio,
						 double srtTxnRate) throws Exception;
	/***
	 * Initialize as many clients as MPL for each batch in this batch set
	 * @throws Exception
	 */
	protected abstract void stepB(double transactionSize, 
								  double eXclusiveLcks, 
								  double effectiveDBSize) throws Exception;
	/***
	 * Runs transactions per client in a batch
	 * @throws Exception
	 */
	protected abstract int stepC(int batchSetRunResID, int batchID, int numClients, double srtTxnRate, int isoLevel, int iterNum) 
			throws Exception;
	
	/***
	 * Close a batch
	 * @throws Exception
	 */
	protected abstract void stepD() throws Exception;
	
	/**
	 * @see azdblab.plugins.scenario.Scenario#executeSpecificExperiment()
	 */
	protected final void executeSpecificExperiment() throws Exception {
		int runID = exp_run_.getRunID();
		int maxTaskNum = -1;
		// generate batchsets
		int batchSetNumToRun = 0;
		int totalNumReadSel = (int)Math.log10(mxNumRowsFromSELECT/mnNmRwsFrmSLCT)+1; //3
//		int totalNumUpdateSel = (int)Math.log10(mxNmRwsFrmUPT/mnNmRwsFrmUPT); // 2
		int totalNumUpdateSel = (int)((mxNmRwsFrmUPT-mnNmRwsFrmUPT)/incrNmRwsFrmUPT)+1; // 4
//		int totalActiveRowPools = (int)((mxActRowPlSz/mnActRwPlSz)/actRwPlSzIncr)+1; // 1
		int totalSrtTxnRates = (int)((mxSrtTxnRate-mnSrtTxnRate)/srtTxnRateIncr)+1; // 4
//		int totalBatchSets = totalNumRealSel*totalNumUpdateSel*totalActiveRowPools;
//		int totalBatchSets = totalSrtTxnRates*(totalNumReadSel+totalNumUpdateSel)*totalActiveRowPools;// 4*4*1=16
		int totalBatchSets = (totalNumReadSel+totalNumUpdateSel)*totalSrtTxnRates;// 4*4*1=16
		double dNmRwsFrmSLCT = 0;
				
		boolean firstLoading = true;
		// transaction size
//		for(double currRS=minReadSel;currRS<=maxReadSel;currRS*=xactSizeIncr){
		while(dNmRwsFrmSLCT <= mxNumRowsFromSELECT){
//			if(dNmRwsFrmSLCT == 0) // update only
//				Constants.DEFAULT_UPT_ROWS = mxNumRowsFromSELECT; // set maximum selectivity for update only
			// exclusive locks
//			for(double dNmRwsFrmUPT=mnNmRwsFrmUPT;dNmRwsFrmUPT<=mxNmRwsFrmUPT;dNmRwsFrmUPT*=incrNmRwsFrmUPT){
			for(double dNmRwsFrmUPT=mnNmRwsFrmUPT;dNmRwsFrmUPT<=mxNmRwsFrmUPT;dNmRwsFrmUPT+=incrNmRwsFrmUPT){
				// skip mixed
				if(dNmRwsFrmSLCT == 0 && dNmRwsFrmUPT == 0){
					continue;
				}
				if(dNmRwsFrmSLCT != 0 && dNmRwsFrmUPT != 0){
					if(dNmRwsFrmUPT < mxNmRwsFrmUPT){
						continue;
					}
				}
				
				if(dNmRwsFrmSLCT > 0 && dNmRwsFrmUPT == mxNmRwsFrmUPT){
					dNmRwsFrmUPT = 0; // read only
				}
				
				// effective db size
				for(double dActRowPlSz=mnActRwPlSz;dActRowPlSz<=mxActRowPlSz;dActRowPlSz+=actRwPlSzIncr){
				//double dActRowPlSz=mnActRwPlSz;
					//double dShtTxnRate=mnSrtTxnRate;
					for(double dShtTxnRate=mnSrtTxnRate;dShtTxnRate<=mxSrtTxnRate;dShtTxnRate+=srtTxnRateIncr){
						//if(firstLoading) firstLoading = false;
						batchSetNumToRun++;
						String str = String.format("batchSet #%d (xactSz: %.2f%%, xlocks: %d%%, hotspot ratio: %d%%, " +
								"short txn ratio: %d%%)", 
								batchSetNumToRun, dNmRwsFrmSLCT*100, (int)(dNmRwsFrmUPT*100), (int)(dActRowPlSz*100), (int)(dShtTxnRate*100));
						Main._logger.outputLog(str);
						// get task number 
						maxTaskNum = getMaxTaskNum(runID);
						if(batchSetNumToRun <= maxTaskNum-1){
							Main._logger.outputLog("batchSet #" + batchSetNumToRun +" studied already" );
						} // end if
						else{
							boolean pausedExecutorByUserRequest = false;
							boolean pausedRunByUserRequest = false;
							
							// check if this run has been paused 
							if (checkToBePaused()){
								pausedRunByUserRequest = true;
							}
							
							// check if this executor has been paused 
							if (checkExecutorOnPause()) {
								pausedExecutorByUserRequest = true;
							}
							
							// if the pause by user request took place, then an exception is thrown.
							if(pausedRunByUserRequest || pausedExecutorByUserRequest){
								Main._logger.outputLog("paused by user request !!!");
								if(pausedRunByUserRequest){
									throw new PausedRunException("Run paused by user request");
								}else{
									throw new PausedExecutorException("Executor paused by user request");	
								}
							}
							
							int currTrialCnt = 1, currExpBackoffWaitTime = Constants.WAIT_TIME;
							
							// initialize experiment tables 
							preStep(firstLoading);
							if(!experimentSubject.getDBMSName().toLowerCase().contains("mysql")){
								if(firstLoading) firstLoading = false;
							}
							
							// analyze this batch set
							studyBatchSet(runID,
										numCores,
										dbmsBuffCacheSizeMin, // min buffer cache, deprecate, but will be used for isolation level
										batchRunTime,
										dNmRwsFrmSLCT,
										dNmRwsFrmUPT,
										dActRowPlSz,
										dShtTxnRate);
							
							if(batchSetNumToRun == 1) {
								System.out.println("IL testing done!");
								return;
							}
							
							// insert a completed task associated with the query number
							Main._logger.outputLog("before the insertion of the next task number");
							while(currTrialCnt <= Constants.TRY_COUNTS){	
								try {
									// record progress
									recordRunProgress(100, String.format("Analyzed #%d BatchSet (total: %d)", batchSetNumToRun, totalBatchSets));
									// store next task number
									putNextTaskNum(runID, batchSetNumToRun+1);
									break;
								}catch(Exception ex){
									ex.printStackTrace();
									Main._logger.reportError(ex.getMessage());
									currTrialCnt++;
									currExpBackoffWaitTime *= 2;
									Main._logger.outputLog("Exponential backoff for last stage is performed for : " + currExpBackoffWaitTime + " (ms)");
									try {
										Thread.sleep(currExpBackoffWaitTime);
									} catch (InterruptedException e) {}
								}
							}
							// if we fail after 10 times, then an exception is eventually made.
							if(currTrialCnt > Constants.TRY_COUNTS) throw new Exception("JDBC in the last stage is not stable.");
							currTrialCnt = 1; currExpBackoffWaitTime = Constants.WAIT_TIME;
							Main._logger.outputLog("after the insertion  of the next task number");
							
							// reset experiment subject
							experimentSubject.reset();
						} // short xact rate
					} // else
				} // effective db 
				
				if(dNmRwsFrmSLCT > 0 && dNmRwsFrmUPT == 0){
					dNmRwsFrmUPT = mxNmRwsFrmUPT;
				}
			} // write selectivity
			
			if(dNmRwsFrmSLCT == 0) 
				dNmRwsFrmSLCT = mnNmRwsFrmSLCT;
			else
				dNmRwsFrmSLCT*= incrNmRwsFrmSLCT;
		} // read selectivity
	}

//	/****
//	 * Get fine-grained task number (MPL at a specific batch set)
//	 * @param runID
//	 * @param BatchSetNum
//	 * @return
//	 * @throws Exception
//	 */
//	protected int getMaxFGTaskNum(int BatchSetID) throws Exception {
//		int res = -1;
//		String table_name = Constants.TABLE_PREFIX + Constants.TABLE_COMPLETEDFGTASK;
//		String sql = "SELECT max(TASKNUMBER) FROM " + table_name + " WHERE BatchSetID = " + BatchSetID;
//		Main._logger.outputLog("task sql: " + sql);
//		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
//		while (rs.next()) {
//			Main._logger.outputLog("current taskNum: " + rs.getInt(1));
//			res = rs.getInt(1);
//		}
//		return res;
//	}
//	
//	/****
//	 * Put fine-grained task number (next MPL at the specific batch set)
//	 * @param runID
//	 * @param BatchSetNum
//	 * @param task_num
//	 * @throws Exception
//	 */
//	protected void putNextFGTaskNum(int BatchSetID, int task_num) throws Exception {
//		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
//		String transactionTime = sdf.format(new Date(System.currentTimeMillis()));
//		String table_name = Constants.TABLE_PREFIX + Constants.TABLE_COMPLETEDFGTASK;
//		String sql = "INSERT INTO " + table_name + " VALUES(" + BatchSetID + "," + task_num + ", to_timestamp('" + transactionTime + "'" + ", '" + Constants.TIMESTAMPFORMAT + "'))";
//		Main._logger.outputLog("task sql: " + sql);
//		LabShelfManager.getShelf().executeUpdateSQL(sql);
//		// LabShelfManager.getShelf().commit();
//	}	
	
//	/****
//	 * Insert batch set into AZDBLab
//	 * @param BatchSetID batch set ID
//	 * @param runID runID
//	 * @param batchSetNum batch set number
//	 */
//	private void insertBatchSet(int BatchSetID, int runID, int batchSetNum) {
//		// insert a pair of key-value
//		try {
//			LabShelfManager.getShelf().insertTuple(
//						Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
//						BATCHSET.columns, 
//						new String[] {
//								String.valueOf(BatchSetID),
//								String.valueOf(runID),
//								String.valueOf(batchSetNum),
//								null,
//								null,
//						},
//						BATCHSET.columnDataTypes);
//			LabShelfManager.getShelf().commitlabshelf();
//		} catch (SQLException e) {
//			Main._logger.reportError(e.getMessage());
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}

	/****
	 * Insert a batchset into labshelf
	 * @param BatchSetID batch set ID
	 * @param paramVal parameter key-value map
	 */
	protected void insertBatchSet(String[] paramVal) {
		// insert a pair of key-value
		try {
			String insertSQL = 
						LabShelfManager.getShelf().NewInsertTuple(
						Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET, 
						BATCHSET.columns, 
//						new String[] {
//								paramVal[0], // BatchSetID
//								paramVal[1], // experimentID
//								paramVal[2], // DBMS Buffer Cache Size
//								paramVal[3], // Number of Cores
//								paramVal[4], // BatchSize Increments
//								paramVal[5], // Batch Run Time (duration)
//								paramVal[6], // Transaction Size (# of locks)
//								paramVal[7], // Exclusive ratio (# of write locks)
//								paramVal[8], // Effective DB size 
//						},
						new String[] {
								paramVal[0], // BatchSetID
								paramVal[1], // experimentID
								paramVal[2], // BatchSize Increments
								paramVal[3], // Transaction Size (# of locks)
								paramVal[4], // Exclusive ratio (# of write locks)
								paramVal[5], // Effective DB size 
								paramVal[6], // ShortXactRate
						},
						BATCHSET.columnDataTypes);
			LabShelfManager.getShelf().commit();
Main._logger.outputDebug(insertSQL);			
		} catch (SQLException e) {
			Main._logger.reportError(e.getMessage());
			e.printStackTrace();
//			String updateSQL = "UPDATE " + Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET + " " + 
//							   "SET BufferSpace = " + paramVal[2] + 
//							   ", NumCores = " + paramVal[3] + 
//							   ",  BatchSzIncr = " + paramVal[4] + 
//							   ",  Duration = " + paramVal[5] + 
//							   ",  XactSz = " + paramVal[6] + 
//							   ",  XLockRatio = " + paramVal[7] + 
//							   ",  EffectiveDBSz = " + paramVal[8] +
//							   " WHERE BatchSetID = " + paramVal[0];
//Main._logger.outputDebug(updateSQL);			
//			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
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
	private void initializeExperimentTables(boolean first) throws Exception {
		/*if (myXactTables.length != 1) {
			Main._logger.reportError("OneDimensionalExhaustiveAnalyzer: too many or too few variable "
							+ "tables: " + myXactTables.length);
			System.exit(1);
		}*/

		// boolean isVariable = false;
		// Set up fixed tables
		
		for (int i = 0; i < myXactTables.length; i++) {
			Table curr_table = myXactTables[i];
			if(first){
//				// If a clone table does not exist
//				if(!experimentSubject.tableExists(Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix)){
					populateXactTable(curr_table); // then populate and clone the loaded table to a clone table
					experimentSubject.copyTable(Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix, curr_table.table_name_with_prefix);
//				}else{ // otherwise, just use it for saving loading time
//					experimentSubject.copyTable(curr_table.table_name_with_prefix, Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix);
//				}
			}else{
				Main._logger.outputDebug("cloning chosen!");
				if(!experimentSubject.tableExists(Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix)){
					throw new Exception("No clone table ("+Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix+")");
//					populateXactTable(curr_table);
//					experimentSubject.copyTable(Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix, curr_table.table_name_with_prefix);
				}else{
					// copy the populated tables to cloning tables
					experimentSubject.copyTable(curr_table.table_name_with_prefix, Constants.CLONE_TABLE_PREFIX+curr_table.table_name_with_prefix);
				}
			}
			// (int)((double)(i + 1) / (double)myVariableTables.length * 100) =
			// % completed
//			recordRunProgress((int) ((double) (i + 1)
//					/ (double) myXactTables.length * 100),
//					"Populating Transaction Tables");
		}
	}
	
//	/****
//	 * Set parameters specified in the spec
//	 */
//	protected final void setParameters(double dbmsCacheBuffSz,
//									   int nCores,
//									   int duration,
//									   int bszMin,
//									   int bszMax,
//									   int bszIncr,
//									   double xactSzMin,
//									   double xactSzMax,
//									   double xactSzIncr,
//									   double xlcksMin,
//									   double xlcksMax,
//									   double xlcksIncr,
//									   double edbSzMin,
//									   double edbSzMax,
//									   double edbSzIncr){
//		dbmsCacheBufferSize = dbmsCacheBuffSz;
//		numCores = 	nCores;
//		batchRunTime = duration;
//		mplMin   = bszMin;
//		mplMax   = bszMax;
//		mplIncr  = bszIncr;
//		minReadSel   = xactSzMin;
//		maxReadSel   = xactSzMax;
//		xactSizeIncr  = xactSzIncr;
//		minUpdateSel   = xlcksMin;
//		maxUpdateSel   = xlcksMax;
//		updateSelIncr  = xlcksIncr;
//		minActRowPoolSz   = edbSzMin;
//		maxActRowPoolSz   = edbSzMax;
//		actRowPoolSzIncr  = edbSzIncr;
//	}
	/****
	 * Drop experiment tables for clean up
	 */
	protected void dropExperimentTables() throws Exception {
		Main._logger.outputLog("## <EndOfExperiment> Purge Already installed tables ##################");
		// 	find all tables in the experimentSubject
		experimentSubject.dropAllInstalledTables();
		Main._logger.outputLog("######################################################################");
		
		// sanity check on table drop
//		for (int i = 0; i < myXactTables.length; i++) {
//			Table curr_table = myXactTables[i];
//			// sanity check for table drop
//			if(experimentSubject.tableExists(curr_table.table_name_with_prefix)){
//				throw new SanityCheckException("Experiment paused by sanity check violation on table drop of " + curr_table.table_name_with_prefix + ".");
//			}
//		}
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