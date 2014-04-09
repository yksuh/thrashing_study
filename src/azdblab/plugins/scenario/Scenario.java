/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
* Matthew Johnson 
* Rui Zhang (http://www.cs.arizona.edu/people/ruizhang/)
*/
package azdblab.plugins.scenario;

import azdblab.Constants;
import azdblab.exception.PausedExecutor.PausedExecutorException;
import azdblab.exception.PausedRun.PausedRunException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.labShelf.dataModel.Executor.ExecutorState;
import azdblab.labShelf.dataModel.Run.RunStatus;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.Plugin;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.utility.watcher.AZDBNotification;
import azdblab.utility.watcher.RegisterMBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.w3c.dom.Document;

/**
 * <p>
 * The Experiment abstract scenario class.
 * </p>
 * <p>
 * This is a generic class for designing experiment scenarios. It provides a
 * public method <code>executeExperiment</code> for executing experiments. This
 * method invokes, an abstract method <code>executeSpecificExperiment</code>,
 * which contains specific code for executing experiments for particular
 * scenarios; hence, the method needs to be implemented by subclasses.
 * </p>
 * <p>
 * The <code>executeSpecificExperiment</code> method should first check whether
 * the <code>experimentSubject</code> instance is not null, which guarantees the
 * proper execution context of the experiment; this context consists of the
 * protected fields of this class. The <code>executeSpecificExperiment</code>
 * method should regularly call two other methods. It should call the
 * <code>checkToBePaused</code> method to check whether the experiment should be
 * paused or aborted; if so, the <code>executeSpecificExperiment</code> method
 * should return. It should also regularly call the <code>recordProgress</code>
 * method to log the real-time execution progress of the experiment.
 * </p>
 * 
 * <p>
 * The hierarchy of Scenario class is in the following.
 * </p>
 * <p>
 * <code>Scenario</code>(abstract Class) is a super class of
 * <code>ScenarioBasedOnCardinality</code>(abstract class) and
 * <code>ScenarioBasedOnQuery</code>(used to be
 * <code>VaryCardinalityScenario</code>)(abstract class).
 * <code>ScenarioBasedOnCardinality</code> can be extended to a concrete class,
 * for instance, <code>ExhaustiveScenario</code>, and
 * <code>ScenarioBasedOnQuery</code> also can be extended to concrete classes,
 * for example, <code>AdjacentScenario</code> and
 * <code>UniquePlanScenario</code>. Each concrete class has a number of steps.
 * </p>
 * <p>
 * OO Design pattern: "Template Method"
 * </p>
 * <p>
 * Definitions
 * </p>
 * <p>
 * - Some steps in the abstract classes are not abstract.
 * </p>
 * <p>
 * - Some steps in the concrete classes are empty.
 * </p>
 * <p>
 * e.g. void stepC () {};
 * </p>
 * <p>=
 * >Abstract classes have more # of steps(different abstract classes can have
 * different # of steps.).
 * </p>
 * <p>
 * Immediate base subclass of <code>Scenario</code>should define
 * <code>executeSpecificExperiment</code> method.
 * 
 * <p>
 * ScenarioBasedOnQuery: Steps are abstract methods, implemented by subclasses.
 * </p>
 * <p>
 * stepA: populates a variable table.
 * </p>
 * <p>
 * stepB: times a query the populated cardinality.
 * </p>
 * <p>
 * stepC: updates the variable table cardinality.
 * </p>
 * <p>
 * stepD: times a query at a specific cardinality.
 * </p>
 * <p>
 * ScenarioBasedOnCardinality: Steps are abstract methods, implemented by
 * subclasses.
 * </p>
 * <p>
 * stepA: populates variable table.
 * </p>
 * <p>
 * stepB: generates necessary cardinalities.
 * </p>
 * <p>
 * stepC: gets all queries and initialize an internal array for storing query
 * executions.
 * </p>
 * <p>
 * stepD: cleans up all incomplete executions and return the minimum cardinality
 * examined before.
 * </p>
 * <p>
 * stepE: restore previous query executions or runs all queries at a specific
 * cardinality.
 * </p>
 * <p>
 * stepF: collects all query execution results and makes a test result XML file.
 * </p>
 * 
 * @author ruizhang, yksuh
 * 
 */
public abstract class Scenario extends Plugin{
	private boolean paused = false;
	/**
	 * @param expRun
	 *            The experiment run that this scenario will be executing.
	 */
	public Scenario(ExperimentRun expRun) {
		experimentRun = expRun;
		startTime = experimentRun.getStartTime();
		dbmsName = experimentRun.getDBMSName();
		experimentSubject = expRun.getExperimentSubject();
		myDataDef = expRun.getDataDefinition();
		userName = expRun.getUserName();
		notebookName = expRun.getNotebookName();
		experimentName = expRun.getExperimentName();
		exp_run_ = User.getUser(userName).getNotebook(notebookName)
				.getExperiment(experimentName).getRun(startTime);
		recordRunProgress(0, "Experiment is ready and waiting to be run.");
//		setName();
//		setVersion();
//		checkVersion();
	}

	protected abstract void setName();

	protected abstract void setVersion();

	protected void checkVersion() {
		try {
			String sql = "Select * from " + Constants.TABLE_PREFIX
					+ Constants.TABLE_SCENARIOVERSION
					+ " where ScenarioName = '" + scenarioName
					+ "' and Version = '" + versionName + "'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (!rs.next()) {
				Main._logger.reportError("Version mismatch " + scenarioName
						+ " version:" + versionName + " not found in LabShelf");
				// System.exit(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * get the experiment run
	 * 
	 * @return ExperimentRun used in the constructor
	 */
	public ExperimentRun getExperimentRun() {
		return experimentRun;
	}

	/**
	 * Check whether the experiment run should be paused, or aborted during
	 * execution. This request is set by the AZDBLab user and is stored in the
	 * lab notebook. This method should be called from within
	 * <code>executeSpecificExperiment</code>. If <code>checkToBePaused</code>
	 * return true, the <code>executeSpecificExperiment</code> should call
	 * <code>recordProgress</code> and then simply return, effectively
	 * pausing/aborting the experiment.
	 * 
	 * @return false if the experiment doesn't need to be either paused nor
	 *         aborted.
	 */
	protected boolean checkToBePausedOld() {
		RunStatus runStat = exp_run_.getRunProgress();
		if (runStat == null) {
			return false;
		}
		if (runStat.current_stage_.equals("Aborted")) {
			recordRunProgress(lastPercentage,
					"Experiment aborted by user request.");
			return true;
		}
		ExecutorState exeState = exp_run_.getExecutorState();
		if (exeState.strCurrentStatus.equals("Paused")) {
			recordRunProgress(lastPercentage,
					"Paused (by user request)");
			Main._logger
					.outputLog("Experiment has been paused by user request.");
			// Update experiemntrun's currentstage to 'Paused'
			return true;
		}
		return false;
	}
	
	/**
	 * Check whether the experiment run should be paused, or aborted during
	 * execution. This request is set by the AZDBLab user and is stored in the
	 * lab notebook. This method should be called from within
	 * <code>executeSpecificExperiment</code>. If <code>checkToBePaused</code>
	 * return true, the <code>executeSpecificExperiment</code> should call
	 * <code>recordProgress</code> and then simply return, effectively
	 * pausing/aborting the experiment.
	 * 
	 * @return false if the experiment doesn't need to be either paused nor
	 *         aborted.
	 */
	protected boolean checkToBePaused() {
//		ExecutorState exeState = exp_run_.getExecutorState();
//		if (exeState.strCurrentStatus.equals("Paused")) {
////			recordRunProgress(lastPercentage,
////					"Paused (by user request)");
//			Main._logger.outputLog("Executor has been paused by user request.");
//			// Update experiemntrun's currentstage to 'Paused'
//			return true;
//		}
		RunStatus runStat = exp_run_.getRunProgress();
		if (runStat == null) {
			return false;
		}
		if (runStat.current_stage_.equals("Aborted")) {
			recordRunProgress(lastPercentage, "Experiment aborted by user request.");
			return true;
		}
		if (runStat.current_stage_.equals("Paused")) {
//			recordRunProgress(lastPercentage, "Experiment paused by user request.");
			return true;
		}
		return false;
	}
	
	protected boolean checkExecutorOnPause() {
		ExecutorState exeState = exp_run_.getExecutorState();
		if (exeState.strCurrentStatus.equals("Paused")) {
			Main._logger.outputLog("Executor has been paused by user request.");
			return true;
		}
		return false;
	}

	/**
	 * Record the current progress of the experiment in the lab notebook. This
	 * is invoked by <code>executeSpecificExperiment</code> regularly to
	 * indicate the progress.
	 * 
	 * @param percentage
	 *            A number indicating the current progress.
	 * @param current_status
	 *            The string describing what the experiment is doing. Value must
	 *            be between 0 and 100, inclusive. (If not, the method does
	 *            nothing.)
	 */
	protected void recordRunProgress(int percentage, String current_status) {
		if (percentage < 0 || percentage > 100) {
			return;
		}
		lastPercentage = percentage;
		
		Run tempRun = User.getUser(userName).getNotebook(notebookName).getExperiment(
				experimentName).getRun(startTime);
		RunStatus rs = tempRun.getRunProgress();
		if(rs.current_stage_.contains("Paused")){
			paused = true;
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
		String transactionTime = sdf
				.format(new Date(System.currentTimeMillis()));
		exp_run_.insertRunLog(transactionTime, current_status, percentage);
		exp_run_.updateRunProgress(transactionTime, current_status, percentage);
		Main._logger.outputLog(current_status + ": " + percentage
				+ "% is done.");

		// if any paused record exists, then we keep the state.
		if(paused){
			transactionTime = sdf.format(new Date(System.currentTimeMillis()));
			// update run status to paused
			tempRun.insertRunLog(transactionTime, "Paused", rs.percentage_);
			tempRun.updateRunProgress(transactionTime, "Paused", rs.percentage_);		
		}
	}

	/**
	 * Execute particular experiment designed by sub-classes of the
	 * <code>Scenario</code> class. The context is available in the protected
	 * fields. Subsequent calls should start up where the last invocation ended.
	 * 
	 * @throws Exception
	 * @return whether or not the experiment finished (if false, then the
	 *         experiment was paused or exhibited some kind of error)
	 */
	protected abstract void executeSpecificExperiment() throws Exception;

	/**
	 * Execute experiment designed by <code>executeSpecificExperiment</code>.
	 * 
	 * @return The file input stream of the result XML file, or Null if the
	 *         experiment was paused or encountered an error.
	 */
	public final void executeExperiment() throws Exception {
		try {
			// The Xerces code needed to build the DOM
			executeSpecificExperiment();
			// drop all installed tables
			dropExperimentTables();
			finishExperiment();
		} catch (Exception ex) {
			ex.printStackTrace();
//			experimentSubject.dropAllInstalledTables();
			/***
			 * Young: if an exception happens not by user request, we should pause a run
			 */
			if(!(ex instanceof PausedRunException) && !(ex instanceof PausedExecutorException)){
				pauseExperiment(ex.getMessage());
			} 
			throw new Exception("Experiment paused because of " + ex.getMessage());
		}
	}

	/**
	 * This method drops any extra table(s) that may be created by a concrete
	 * scenario. It gets called after the experiment is finished.
	 * 
	 * @throws Exception
	 */
	// protected void experimentCleanUp() throws Exception {}

	protected void finishExperiment() throws Exception {
		recordRunProgress(100, "Experiment completed.");
	}

	/**
	 * Populate the transaction tables.
	 * 
	 * @param table
	 *            The table to be populated.
	 */
	protected void populateXactTable(Table table) throws Exception {
		RepeatableRandom rr = new RepeatableRandom(table.getTableSeed());
		rr.setMax(table.actual_card);
		experimentSubject.populateXactTable(table, rr);
	}
	
	/**
	 * Populate the fixed tables.
	 * 
	 * @param table
	 *            The table to be populated.
	 */
	protected void populateFixedTable(Table table) throws Exception {
		RepeatableRandom rr = new RepeatableRandom(table.getTableSeed());
		rr.setMax(table.actual_card);
		// table.columns.length = number of columns in the table
		experimentSubject.populateTable(table.table_name_with_prefix,
				table.columns.length, table.actual_card, table.hy_max_card, rr,
				false);
//		experimentSubject.updateTableStatistics(table);
	}

	protected void pauseExperiment(String msg) {
		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
		/***
		 * Young: don't pause executor
		 */
//		String transactionTime = sdf
//				.format(new Date(System.currentTimeMillis()));
//		exp_run_.setExecutorCommand(transactionTime, "Pause"); 
		recordRunProgress(lastPercentage, "Paused (because of " + msg + ")");
	}

	protected abstract void dropExperimentTables() throws Exception;

	protected int getMaxTaskNum(int runID) throws Exception {
		int res = -1;
		String table_name = Constants.TABLE_PREFIX
				+ Constants.TABLE_COMPLETED_TASK;
		String sql = "SELECT max(TASKNUMBER) FROM " + table_name
				+ " WHERE RUNID = " + runID;
		Main._logger.outputLog("task sql: " + sql);
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			Main._logger.outputLog("current taskNum: " + rs.getInt(1));
			res = rs.getInt(1);
		}
		return res;
	}

	protected void putNextTaskNum(int runID, int task_num) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
		String transactionTime = sdf
				.format(new Date(System.currentTimeMillis()));
		String table_name = Constants.TABLE_PREFIX
				+ Constants.TABLE_COMPLETED_TASK;
		String sql = "INSERT INTO " + table_name + " VALUES(" + runID + ", "
				+ task_num + ", to_timestamp('" + transactionTime + "'" + ", '" + Constants.TIMESTAMPFORMAT + "'))";
		Main._logger.outputLog("task sql: " + sql);
		LabShelfManager.getShelf().executeUpdateSQL(sql);
		// LabShelfManager.getShelf().commit();
	}

	public static String getXSL() {
		return Constants.RESULT_TRANSFORM_STYLE;
	}

	/*****
	 * Insert query execution record into labshelf
	 * 
	 * @param curr_exec
	 *            : query execution
	 * @param curr_query
	 *            : query
	 * @param exec_number
	 *            : execution number (change point)
	 * @param iterNum
	 *            : iteration number
	 * @throws Exception
	 */
	protected void recordQueryExecution(QueryExecution curr_exec,
			Query curr_query, int exec_number, int iter_num, int type)
			throws Exception {
		Main._logger
				.outputLog("###<BEGIN>INSERT QUERY EXECUTION ################");
		// for (int i = 0; i < curr_exec.myQueryExecutionTables.length; i++) {
		Main._logger.outputLog("(" + exec_number + ", "
				+ curr_exec.myQueryExecutionTables[0].max_val + ")");
		int queryexecution_id = curr_query.insertQueryExecution(
				curr_exec.phaseNumber, curr_query.iQueryNumber, exec_number,
				curr_exec.myQueryExecutionTables[0].max_val, curr_exec
						.getResultCardinality(), curr_exec.exec_time,
				curr_exec.proc_diff_, iter_num, type);
		if (queryexecution_id < 0) {
			Main._logger.reportError("queryexecution id cannot be negative!");
			throw new Exception(
					"queryexecution failure: queryexecution id cannot be negative!");
		}

		if (curr_exec.phaseNumber != 2) {
			Main._logger.outputLog("before inserting query plan");
			long planID = curr_query.insertPlan(curr_query.iQueryNumber,
					exec_number, queryexecution_id, curr_exec.plan);
			Main._logger.outputLog("done with inserting query plan ");
			Main._logger.outputLog("before inserting query run stat... ");
			curr_query.insertQueryExecutionStat(queryexecution_id, planID,
					curr_exec.plan);
			Main._logger.outputLog("done with inserting query run stat ... ");
		}
		// }
		Main._logger
				.outputLog("###<END>INSERT QUERY EXECUTION ###################");
	}

	/*****
	 * Insert tps results into labshelf
	 * @param elapsedTimeMillis 
	 * @param totalXacts 
	 * 
	 * @throws Exception
	 */
	protected void recordTPSResult(int MPL, int totalXacts, long elapsedTimeMillis, double edbSz, int iterNum, double sel) throws Exception {
		Main._logger
				.outputLog("###<BEGIN>INSERT TPS Result ################");
		
		float elapsedTimeSec = elapsedTimeMillis / 1000F;
		float tps = (float)totalXacts / elapsedTimeSec;
		System.out.format("============== %d> TPS RESULTS =====================\n",iterNum);
        System.out.printf("Time: %d ms\n", elapsedTimeMillis);
        System.out.printf("Total transactions: %d\n", totalXacts);
        System.out.printf("Transactions per second: %.2f\n", tps);
//		Main._logger.outputLog("Inserting tps result : " + queryexecution_number + " for query " + queryNumber);
//		Main._logger.outputLog("On LabShelf : " + Constants.getLABNOTEBOOKNAME());
        Main._logger.outputLog("Inserting tps result : " + numTerminals + " for duration " + duration + " (secs)");
//		int			QueryExecutionID		= LabShelfManager.getShelf().getSequencialID("SEQ_QUERYEXECUTIONID");

//        String insertSQL = "INSERT INTO " + Constants.TABLE_TPSRESULT_NAME 
//        		+ "(RUNID,NUMCORES,MPL,DURATION,NUMEXECUTEDXACTS) VALUES (" 
//        		+ exp_run_.getRunID()+","+numCores+","+MPL+","+elapsedTimeMillis+","+totalXacts+")";
//        Main._logger.outputLog(insertSQL);

        
		String[] columnNames = new String[] {"RUNID", 
											 "NUMCORES", 
											 "MPL",
											 "DURATION", 
											 "NUMEXECUTEDXACTS",
											 "EDBSZ",//ver2
											 "ITERNUM",
	 										 "SELECTIVITY"}; // ver3
		String[] columnValues = new String[] { String.valueOf(exp_run_.getRunID()),
											   String.valueOf(numCores),
											   String.valueOf(MPL), 
											   String.valueOf(elapsedTimeMillis),
											   String.valueOf(totalXacts),
											   String.format("%.2f", edbSz),
											   String.valueOf(iterNum),
											   String.format("%.4f", sel)
											   };
		int[] dataTypes = new int[] { 
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, 
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, 
				GeneralDBMS.I_DATA_TYPE_NUMBER, 
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER};
		
		int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;
		Main._logger.outputLog("before inserting tps result");
		while(lastStageCnt <= Constants.TRY_COUNTS){	
		    try {
				//inserts a change point into the the internal tables.
				LabShelfManager.getShelf().insertTupleToNotebook(Constants.TABLE_TPSRESULT_NAME, columnNames, columnValues, dataTypes);
				LabShelfManager.getShelf().commitlabshelf();
				break;
			} catch (SQLException e) {
				e.printStackTrace();
				Main._logger.reportError(e.getMessage());
				lastStageCnt++;
				lastStageWaitTime *= 2;
				Main._logger.outputLog("Exponential backoff for last stage is performed for : " + lastStageWaitTime + " (ms)");
				try {
					Thread.sleep(lastStageWaitTime);
				} catch (InterruptedException ex) {}
			}
		}
		if(lastStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC in the last stage is not stable.");
		Main._logger.outputLog("after inserting tps result");
		Main._logger.outputLog("###<END>INSERT TPS Result ###################");
	}
	
	public String pluginTestSchema = Constants.CHOSEN_TEST_RESULT_SCHEMA;

	/**
	 * Scenario version name
	 */
	public String versionName;
	/**
	 * Initialized in the constructor
	 */
	protected String userName;
	/**
	 * Initialized in the constructor
	 */
	protected String notebookName;
	/**
	 * Initialized in the constructor
	 */
	protected String experimentName;
	/**
	 * Initialized by invoking <code>executeExperiment</code>
	 */
	protected String dbmsName;
	/**
	 * Initialized by invoking <code>executeExperiment</code>
	 */
	protected String startTime;
	/**
	 * Initialized in the constructor
	 */
	protected ExperimentSubject experimentSubject;
	/**
	 * The data definition associated with the experiment.
	 */
	protected DataDefinition myDataDef;
	/**
	 * The result document of this experiment.
	 */
	protected Document myResultXML;
	public static int NUMQUERYEXECS = 1;

	protected String scenarioName;
	/**
	 * The <code>ExperimentRun</code> instance representing this experiment run.
	 */
	protected ExperimentRun experimentRun;
	protected int lastPercentage = 0;
	protected Run exp_run_;

	protected int numTerminals = 0;
	protected int duration = 0;

	protected int numCores;

	protected int numIncr = 0;

	/**
	 * effective db size
	 */
	protected double effectiveDBSz = 1.0;
	
	public static String getDescription(String scenarioName) {
		if (scenarioName.equalsIgnoreCase("doubletripple")) {
			return "This experiment scenario studies plan uniqueness at 1M cardinality.\n"
					+ "We populate 2M table, clone it to variable table, and delete top 10K rows 100 times.\n"
					+ "In turn, we get an 1M plan, update table statistics, and get a query run associated with it.\n"
					+ "Then, we update the statistics and get another queryexecution. \n"
					+ "We will do this twice. Lastly, we will clone the max table to the variable table with 1M rows.\n"
					+ "We will do the same thing before. Then, the total queryexecutions we will earn will be 6 runs.\n"
					+ "Hopefully, the identical plan should be chosen across all of the six runs. ";
		} else if (scenarioName.equalsIgnoreCase("exhaustive")) {
			return "This experiment scenario tests plan non-monotonicity by exhaustively looping\n"
					+ "all cardinalities. Each cardinality we will run all queries and insert the\n"
					+ "query execution result into AZDBLAB.";
		} else if (scenarioName.equalsIgnoreCase("cloneonem")) {
			return "This experiment scenario studies plan uniqueness at 1M cardinality. We\n"
					+ "populate 2M table, and clone it to variable table with as many rows as 1M. In\n"
					+ "turn, we get an 1M plan, and get a query run associated with it.";
		} else if (scenarioName.equalsIgnoreCase("uniqueplan")) {
			return "This experiment scenario studies plan uniqueness at 1M cardinality. We\n"
					+ "populate 2M table, clone it to variable table, and delete top 10k rows of the\n"
					+ "variable table until hitting 1M cardinality. In turn, we get an 1M plan, and\n"
					+ "get a query run associated with it.";
		} else if (scenarioName.equalsIgnoreCase("onepass")) {
			return " We study plan generation/execution varying the cardinality from the\n"
					+ "maximum(e.g., 2M) to the minimum(e.g., 10K) by using the left/right state \n"
					+ "tables at a time (one pass). We'll use the left/right state table to detect\n"
					+ "a change point, alternatively stepping down by granularity (2M => left, 1.99M => right ...),\n"
					+ "If we get different plans obtained on the left/right state table at their cardinalities, \n"
					+ "then we make a query execution NUMQUERYEXECS times. ";
		}else if (scenarioName.equalsIgnoreCase("xactthrashing")) {
			return " We study transaction thrashing. ";
		}

		else {
			return "No description was found, please modify the getDescription method in Scenario.java";
		}
	}

	public void setCores(int cores) {
		numCores  = cores;
	}
	
	public void setTerminals(int numClients) {
		numTerminals  = numClients;
	}
	
	public void setDuration(int seconds) {
		duration  = seconds;
	}
	
	public void setIncrements(int nIncr) {
		numIncr   = nIncr;
	}

	public void setEffectiveDBSz(double effDBSz) {
		effectiveDBSz = effDBSz;
	}
}
