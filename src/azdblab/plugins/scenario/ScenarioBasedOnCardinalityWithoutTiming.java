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

import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.dataModel.Query;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

/**
 * This experiment scenario tests plan non-monotonicity by looping cardinalities.
 * Per cardinality we will run all queries, and insert the query executions into AZDBLAB. 
 * First, we populate the variable table via <code>stepA</code>, generate necessary cardinalities in <code>stepB</code>,
 * and obtain all queries from a run and initialize an array to internally keep query execution result in <code>stepC</code>.
 * Thereafter, we check whether there exists any incomplete(not yet finished) cardinality in <code>stepD</code>. 
 * If it does, we delete all query executions associated with it and mark the cardinality as one to resume. 
 * In turn, <code>stepE</code> loops from the maximum cardinality down to the minimum cardinality. If a cardinality 
 * is greater than the resume cardinality, the corresponding execution result is read into the internal array. Otherwise, 
 * we start to run all queries by varying the cardinality in a bigger for loop and insert query execution result 
 * (plan and runtime) into AZDBLAB. Finally, <code>stepF</code> creates a test result XML document used for GUI.
 * 
 * We ensure that all the query executions (10) have the same plan for each cardinality. 
 * 
 * 
 * @author yksuh
 *
 */

public abstract class ScenarioBasedOnCardinalityWithoutTiming extends Scenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public ScenarioBasedOnCardinalityWithoutTiming(ExperimentRun expRun) {
		super(expRun);
		// set version name for this plugin
		planToExecutionTimeMap = new HashMap<Long, Long>();
	}
	/**
	 * number of cardinalities
	 */
	protected int numOfCards = 0;
	/**
	 * number of queries
	 */
	protected int numOfQueries = 0;
	
	/**
	 * all cardinalities to be populated
	 */
	protected Vector<Long> vecCardinalities;
	
	/**
	 * all queries
	 */
	protected List<Query> vecQueries;
	/**
	 * Get the number of phases of this scenario.
	 * @return The number of phases.
	 */
	protected int getNumOfPhases() {
		return 1;
	}
	/**
	 * Populate the variable table(s). For efficiency of the following steps,
	 * perhaps populate the variable table(s) at the maximum cardinality,
	 * storing these tables as template tables, and then partially clone the
	 * table(s) as the variable tables.
	 * 
	 * @param phase_number
	 * @param variableTables
	 *            The variable tables to be populated.
	 * @throws Exception
	 *             if something went wrong in this step.
	 */
	protected abstract void stepA(int phase_number, Table[] variableTables) throws Exception;
	
	/**
	 * Populates cardinalities for the current variable table.
	 * @param curr_table
	 * @throws Exception 
	 */
	protected abstract Vector<Long> stepB(Table curr_table) throws Exception;
	/**
	 * Cleans up incomplete query executions.
	 * @param runID
	 * @return
	 * @throws Exception
	 */
	protected abstract void stepC(int runID) throws Exception;
	/**
	 * Setting up the necessary variables for experiment.
	 * 
	 * @throws Exception
	 */
	private void initializeNotebookContent() throws Exception {
		myFixedTables = experimentRun.getFixedTables();
		myVariableTables = experimentRun.getVariableTables();
	}

	/**
	 * Creating and populating experiment tables.
	 * 
	 * @throws Exception
	 */
	private void initializeExperimentTables() throws Exception {
		if (myVariableTables.length != 1) {
			Main._logger.reportError("OneDimensionalExhaustiveAnalyzer: too many or too few variable "
							+ "tables: " + myVariableTables.length);
			System.exit(1);
		}

		// boolean isVariable = false;
		// Set up fixed tables
		for (int i = 0; i < myFixedTables.length; i++) {
			Table curr_table = myFixedTables[i];
			populateFixedTable(curr_table);
			// (int)((double)(i + 1) / (double)myVariableTables.length * 100) =
			// % completed
			recordRunProgress((int) ((double) (i + 1)
					/ (double) myFixedTables.length * 100),
					"Populating Fixed Tables");
		}
	}
	/**
	 * Generating the entire search space of the candidate cardinalities.
	 * 
	 * @param method
	 *            There are two methods, linear and exponential, for changing
	 *            the table cardinality.
	 * @param min
	 *            Minimum cardinality.
	 * @param max
	 *            Maximum cardinality.
	 * @param granularity
	 * @return
	 */
	protected Vector<Long> generateCandidateCardinalities(String method,
			long min, long max, long granularity) {
		Vector<Long> vecCardinalities = new Vector<Long>();
		if (method.equals("linear")) {
			for (long i = max; i >= min; i = i - granularity) {
				vecCardinalities.add(i);
			}
		} else if (method.equals("exponential")) {
			int numInterval = 10;
			int maxExp = (int) (Math.log((double) max) / Math.log(2.0)) + 1;
			long currentMax = max;
			for (int i = maxExp; i > 0; i--) {
				long interval = currentMax - (long) Math.pow(2.0, (i - 1));
				long granExp = interval / numInterval;
				for (int j = 0; j < numInterval; j++) {
					long cardinality = currentMax - j * granExp;
					vecCardinalities.add(cardinality);
				}
				currentMax = (long) Math.pow(2.0, i - 1);
			}
		}
		return vecCardinalities;
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
	
	/**
	 * @see azdblab.plugins.scenario.Scenario#executeSpecificExperiment()
	 */
	protected final void executeSpecificExperiment() throws Exception {
		// initialize labshelf content + experiment tables 
		preStep();
		
		/**
		 * To make sure each stage is free of JDBC bug below, we try each stage 10 times.
		 * ==================================================================================================
		    SELECT PlanTree FROM AZDBLAB_PLAN WHERE PlanID=8515245752388713696
		    Plan Already Existed
		 	insert plan: -1
		 	insert statement for labshelf: INSERT INTO AZDBLAB_QUERYEXECUTIONHASPLAN(QueryExecutionID, PlanID) 
		 																	VALUES (4127, 8515245752388713696)
			done inserting plan
			done with inserting query plan
			before inserting query run stat...
			java.sql.SQLException: Invalid column type
			    at oracle.jdbc.dbaccess.DBError.throwSqlException(DBError.java:134)
			    at oracle.jdbc.dbaccess.DBError.throwSqlException(DBError.java:179)
			    at oracle.jdbc.dbaccess.DBError.throwSqlException(DBError.java:269)
			    at oracle.jdbc.driver.OracleStatement.getLongValue(OracleStatement.java:4375)
			    at oracle.jdbc.driver.OracleResultSetImpl.getLong(OracleResultSetImpl.java:529)
			    at azdblab.labShelf.dataModel.Query.getPlanOpID(Query.java:1133)
			==================================================================================================
		   	After that if any exception still happens, then the exception to make a real pause is thrown.
		*/
		int initStageCnt = 1, initStageWaitTime  = Constants.WAIT_TIME; 
		int main1StageCnt = 1, main1WaitTime	 = Constants.WAIT_TIME;  
		int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;
		
		// Looping on the phases.
		for (int phase = 1; phase <= getNumOfPhases(); phase++) {
			int maxTaskNum = -1, runID = -1, resume_idx = 0;
			
			Main._logger.outputLog("before init stage");
			while(initStageCnt <= Constants.TRY_COUNTS){	
				try {
					// populate variable tables
					stepA(phase, myVariableTables);
					// get runid 
					runID = exp_run_.getRunID();
					// get all queries initialize query execution result array
					vecQueries = exp_run_.getExperimentRunQueries();
					break;
				}catch(Exception ex){
					ex.printStackTrace();
					Main._logger.reportError(ex.getMessage());
					initStageCnt++;
					initStageWaitTime *= 2;
					Main._logger.outputLog("Exponential backoff for init stage is performed for : " + initStageWaitTime + " (ms)");
					try {
						// wait 2^(count) seconds
						Thread.sleep(initStageWaitTime);
					} catch (InterruptedException e) {}
				}
			}
			// if we fail after 10 times, then an exception is eventually made.
			if(initStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC in the init stage is not robust.");
			// reset
			initStageCnt = 1; initStageWaitTime = Constants.WAIT_TIME;
			Main._logger.outputLog("after init stage");
			
			// number of queries 
			numOfQueries = vecQueries.size();
			for (int i = 0; i < myVariableTables.length; i++) {
				Table curr_table = myVariableTables[i];
			
				// populate cardinalities
				vecCardinalities = stepB(curr_table);
				numOfCards = vecCardinalities.size();
				
				boolean pausedByUserRequest = false;
				Main._logger.outputLog("before main1 stage");
				while(main1StageCnt <= Constants.TRY_COUNTS){	
					try{
						// clean up any incomplete query execution at a previous task.
						stepC(runID);	// different from ScenarioBasedOnQuery()
						// 	get the maximum task number
						maxTaskNum = getMaxTaskNum(runID);
						
						if(maxTaskNum > 0){	
							resume_idx = maxTaskNum;
						}
						
						for (int j = resume_idx; j < vecCardinalities.size(); j++) {
							long curr_card = vecCardinalities.get(j);
							Main._logger.outputLog("before analyzing " + curr_card);
	
							if (checkToBePaused()) {
								pausedByUserRequest = true;
								// get out of loop
								break;
							}
							
							if (Main.verbose) {
								Main._logger.outputLog("<Begin>try: " + main1StageCnt+ " Running all queries at '" + curr_card + "'");
							}
							// Run all queries at this specific cardinality
							analyzeCardinality(phase, 
											   curr_table,
											   curr_card, 
											   j,
											   NUMQUERYEXECS);
							// search the entire space, very slow
							if (Main.verbose) {
								Main._logger.outputLog("<End> Running all queries at '" + curr_card + "'");
							}
							
							Main._logger.outputLog("before the insertion of the next task number");
							while(lastStageCnt <= Constants.TRY_COUNTS){	
								try{
									if (Main.verbose) {
										// record progress
										recordRunProgress(Math.min((int) (((double) (j + 1)
												/ (double) vecCardinalities.size()) * 100), 99),
												"Done with all queries runnning at " + curr_card);
									}	
									putNextTaskNum(runID, j+1);
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
							if(lastStageCnt > Constants.TRY_COUNTS) break; 
							lastStageCnt = 1; lastStageWaitTime = Constants.WAIT_TIME;
							Main._logger.outputLog("after the insertion  of the next task number");
						}// end for cardinality
						break;
					}catch(Exception ex){
						ex.printStackTrace();
						Main._logger.reportError(ex.getMessage());
						main1StageCnt++;
						main1WaitTime *= 2;
						Main._logger.outputLog("Exponential backoff for main1 stage is performed for : " + main1WaitTime + " (ms)");
						try {
							Thread.sleep(main1WaitTime);
						} catch (InterruptedException e) {}
					}
				} // end while
				
				// if the pause by user request took place, then an exception is thrown.
				if(pausedByUserRequest){
					Main._logger.outputLog("paused by user request !!!");
					throw new Exception(":: Experiment has been paused by user request :: ");
				}
				
				// if we fail after 10 times, then an exception is eventually thrown.
				if(main1StageCnt > Constants.TRY_COUNTS || lastStageCnt > Constants.TRY_COUNTS){
					throw new Exception("The JDBC in the main1 or last stages is not robust.");
				}
				main1StageCnt = 1; main1WaitTime = Constants.WAIT_TIME;
				Main._logger.outputLog("after main1 stage");
			} // end for variable table
		} // end for phase
	}
	
	protected void dropExperimentTables() throws Exception {
		Main._logger.outputLog("## <EndOfExperiment> Purge Already installed tables ##################");
		// 	find all tables in the experimentSubject
		experimentSubject.dropAllInstalledTables();
		Main._logger.outputLog("######################################################################");
		
		// sanity check on table drop
		for (int i = 0; i < myFixedTables.length; i++) {
			Table curr_table = myFixedTables[i];
			// sanity check for table drop
			if(experimentSubject.tableExists(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("Experiment paused by sanity check violation on table drop of " + curr_table.table_name_with_prefix + ".");
			}
		}
		
		for (int i = 0; i < myVariableTables.length; i++) {
			Table curr_table = myVariableTables[i];
			// sanity check for clone max table drop
			if(experimentSubject.tableExists("clone_max_" + curr_table.table_name_with_prefix)){
				throw new SanityCheckException("Experiment paused by sanity check violation on table drop of clone_max_" + curr_table.table_name_with_prefix + ".");
			}
			// sanity check for variable table drop
			if(experimentSubject.tableExists(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("Experiment paused by sanity check violation on table drop of clone_max_" + curr_table.table_name_with_prefix + ".");
			}
		}
	}
	protected void updateTableCardinality(Table curr_table, long curr_card) throws Exception{
		// update table cardinality by the requested one
		try {
			  // update table cardinality
			  experimentSubject.copyTable(curr_table.table_name_with_prefix, 
					  					  "clone_max_" + curr_table.table_name_with_prefix, 
					  					  curr_card); 
			  // update table statistics
			  experimentSubject.updateTableStatistics(curr_table);
		} catch (Exception ex) {
			throw new Exception(ex.getMessage());
		}
	}
	
	/**
	 * Measuring the running time of a query plan.
	 * <p>
	 * In the case that timing is needed, this should be implemented by calling
	 * <code>experimentSubject.timeQuery</code>. Otherwise, a
	 * <code>QueryStat</code> with 0 as running time, will be simply returned.
	 * 
	 * @param sql
	 *            The query to be executed
	 * @param plan
	 *            the plan to be used for executing the query
	 * @param cardinality
	 *            the cardinality at which the input plan was generated for the
	 *            input query.
	 * @return The <code>QueryStat</code> instance which contains the running
	 *         time.
	 */
	protected QueryExecutionStat timeQueryExecution(String sql, PlanNode plan, long cardinality) throws Exception {
		//Main._logger.outputLog("Time out is : " + Constants.EXP_TIME_OUT);
		//QueryExecutionStat result_queryrxecution_stat = experimentSubject.timeQuery(sql,
		//		plan, cardinality, Constants.EXP_TIME_OUT);
		return new QueryExecutionStat(0, "N/A");
	}
	/**
	 * Run all queries at a given cardinality 
	 * 
	 * @param phaseNumber
	 * 			  The phase number
	 * @param curr_table
	 * 			  variable table
	 * @param curr_card
	 *            The cardinality at which queries should run
	 * @param cardIdx
	 * 			  The index of the current cardinality
	 * @throws Exception
	 */
	protected void analyzeCardinality(int phaseNumber, 
										  Table curr_table,
										  long curr_card, 
										  int cardIdx,
										  int numExecs) throws Exception {
	
//		boolean res = true;
		// first update table cardinality by copying
		updateTableCardinality(curr_table, curr_card);
		
		// sanity check
		long card = experimentSubject.getTableCardinality(curr_table.table_name_with_prefix);
		if(card != curr_card){
			Main._logger.outputLog("Stored cardinality : " + card + ", requested cardinality: " + curr_card);
			throw new SanityCheckException("Requested and table cardinalities are different.");
		}else{
//Main._logger.outputLog("========= Table Metadata ========");
//experimentSubject.printTableStat(curr_table.table_name_with_prefix);
//Main._logger.outputLog("================================");
// search the entire space, very slow
			// looping through every query
			for (int j = 0; j < vecQueries.size(); j++) {
//				if(j == 4){
//					System.out.println("<< Debugging mode >> ");
//				}
				Query expRunQuery = vecQueries.get(j);
//				qerArray[j].vecQueryPlans = new Vector<Long>();
				for (int t = 1; t <= numExecs; t++) { 
// search the entire space, very slow
if (Main.verbose) {
	Main._logger.outputLog("Running Query # " + (j+1) + "-" + t + " iteration(s)");
}
					// get a query plan
					PlanNode queryPlan = experimentSubject.getQueryPlan(expRunQuery.strQuerySQL);
					// make a query execution by a query plan
					QueryExecutionStat qrstat = timeQueryExecution(expRunQuery.strQuerySQL, queryPlan, curr_card);
					// make an query execution record
					QueryExecution curr_card_execution = new QueryExecution(myVariableTables.length);
					curr_card_execution.plan = queryPlan;
					curr_card_execution.planNumber = expRunQuery.obtainPlanNum(queryPlan.myHashCode());
					curr_card_execution.myQueryExecutionTables[0].max_val = curr_card;
					curr_card_execution.myQueryExecutionTables[0].min_val = curr_card;
					curr_card_execution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
					curr_card_execution.phaseNumber = phaseNumber;	
					curr_card_execution.iternum = t;
					if (qrstat != null) {
						curr_card_execution.exec_time = qrstat.getQueryTime();
						curr_card_execution.proc_diff_ = qrstat.getProcDiff();
					}
					recordQueryExecution(curr_card_execution, expRunQuery, cardIdx, t, Constants.SCENARIO_BASED_ON_CARDINALITY);
				}
			}
		}
//		return res;
	}

	/**
	 * The tables that are fixed for this experiment.
	 */
	protected Table[] myFixedTables;

	/**
	 * The query plans that the analyzer has already seen.
	 */
	protected Vector<Long> vecQueryPlans;

	/**
	 * The tables that are variable for this test.
	 */
	protected Table[] myVariableTables;

	/**
	 * The map that associates query plans to query plan numbers.
	 */
	protected HashMap<Long, Integer> planToPlanNumberMap;

	protected HashMap<Integer, TreeSet<Long>> mapQueryToSubOptPlan;

	protected TreeSet<Long> set_new_plans_;

	protected HashMap<Long, Long> planToExecutionTimeMap;
}