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

import java.util.List;
import java.util.Vector;
import java.sql.PreparedStatement;

import azdblab.Constants;
import azdblab.exception.PausedExecutor.PausedExecutorException;
import azdblab.exception.PausedRun.PausedRunException;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.dataModel.Query;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.utility.watcher.AZDBNotification;
import azdblab.utility.watcher.RegisterMBean;

/**
 * <p>This is an experiment scenario that examines query plan generation 
 * by varying the cardinality of the variable tables. The approach for altering
 * the cardinality is specific to each sub-class.</p>
 * <p>Generally, the set of fixed experiment tables will be created and
 * populated by calling the <code>populateFixedTable</code> method. The 
 * variable tables should be handled by <code>stepA</code>.
 * The actual experiment will then loop on the phases which will each invoke
 * the <code>analyzeQuery</code> method that should be implemented by concrete scenarios.</p>
 * <p>In each <code>analyzeQuery</code>, an individual query is studied. At
 * first, the scenario need to examine the query execution at the "actual"
 * cardinality, thus the scenario call <code>timeQueryExecution</code> to measure the
 * execution time then call <code>recordQueryExecution</code> to store the details of
 * the "optimal" plan into the lab notebook. Since our main goal is to study
 * the query plans at various cardinalities, the scenario first provide a
 * sequence of pre-computed candidate cardinality values by calling
 * <code>generateCandidateCardinalities</code>.
 * The scenario then iterates over these values starting from the maximum and
 * then decrease with calls to <code>stepB</code>, which changes the table
 * cardinality as requested, either physically or virtually, according to the
 * implementations of sub-scenarios. Following <code>stepB</code>, the scenario
 * calls <code>timeQueryExecution</code> to measure the plan execution time and
 * <code>recordQueryExecution</code> to store the detail of the plan execution.</p>
 * <p><code>stepC</code>, <code>stepD</code>, <code>stepE</code>, <code>stepF</code> 
 * and <code>stepG</code> provide extra functionalities for performing experiments. 
 * Subclasses should override them if necessary.
 * </p>
 * <p>The scenario provides the <code>timeQueryExecution</code> method in the
 * experiment since some of the experiment scenarios will study the performance
 * of plans. This method may be called by <code>stepB</code> and
 * <code>stepB</code>. In the case the timing information is not needed in the
 * experiment, subclasses should use the default <code>stepB</code> and
 * <code>stepB</code> implementations which do no timing.</p>
 * 
 * We ensure that all the query executions (10) have the same plan for each cardinality. 
 * @author ruizhang, yksuh
 */
public abstract class ScenarioBasedOnQuery extends Scenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public ScenarioBasedOnQuery(ExperimentRun expRun) {
		super(expRun);
	}

	/**
	 * Populate the variable table(s) for use in retrieving the optimal plan
	 * using the actual cardinality. For efficiency of the following steps,
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
	   * Change the cardinality of variable table by deleting rows to the requested
	   * value.
	   * @param variableTables Variable tables.
	   * @param requested_cardinality The requested cardinality of the variable
	   * table
	   */
	protected abstract boolean stepB(int phaseNumber, Table[] variableTables, long requested_cardinality) throws Exception;

	/**
	 * Studying a query.
	 *
	 * @param phaseNumber
	 * 			  Current phase
	 * @param expQuery
	 * 			  Query to study (having query number+sql text)
	 * @param method
	 *            Method for constructing candidate cardinality
	 * @param granularity
	 *            Granularity for changing cardinality.
	 * @throws Exception
	 */
	protected abstract void analyzeQuery(int phaseNumber,
										 Query expQuery,
										 String method, 
										 long granularity)
										 throws Exception;
	
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
				throw new SanityCheckException("table drop of " + curr_table.table_name_with_prefix);
			}
		}
		
		for (int i = 0; i < myVariableTables.length; i++) {
			Table curr_table = myVariableTables[i];
			// sanity check for clone max table drop
			if(experimentSubject.tableExists("clone_max_" + curr_table.table_name_with_prefix)){
				throw new SanityCheckException("table drop of clone_max_" + curr_table.table_name_with_prefix);
			}
			// sanity check for variable table drop
			if(experimentSubject.tableExists(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("table drop of " + curr_table.table_name_with_prefix);
			}
		}
	}
  
	
	/**
	 * Get the number of phases of the scenario.
	 * 
	 * @return the number of scenarios.
	 */
	// check the actual scenario instance to see its value. In first round of
	// scenarios, it is =1.
	protected abstract int getNumOfPhases();

	/**
	 * @see azdblab.plugins.scenario.Scenario#executeSpecificExperiment()
	 */
	protected final void executeSpecificExperiment() throws Exception {
		initializeNotebookContent();
		initializeExperimentTables();
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
		int mainStageCnt = 1, mainWaitTime		 = Constants.WAIT_TIME; 
		int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;
		// Looping on the phases.
		for (int phase = 1; phase <= getNumOfPhases(); phase++) {
			int maxTaskNum = -1, runID = -1;
			List<Query> experimentRunQueries = new Vector<Query>();
			
			Main._logger.outputLog("before init stage");
			while(initStageCnt <= Constants.TRY_COUNTS){	
				try {
					// populate variable tables
					stepA(phase, myVariableTables);
					// get runid 
					runID = exp_run_.getRunID();
					// get the maximum task number
					maxTaskNum = getMaxTaskNum(runID);
					// get the queries
					experimentRunQueries = exp_run_.getExperimentRunQueries();
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
			if(initStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC not stable in the init stage");
			// reset
			initStageCnt = 1; initStageWaitTime = Constants.WAIT_TIME;
			Main._logger.outputLog("after init stage");
			// Looping on the queries
			for (int i = 0; i < experimentRunQueries.size(); i++) {
				Query expRunQuery = experimentRunQueries.get(i);
				if(i <= maxTaskNum-1){
					if (Main.verbose) {
						Main._logger.outputLog("Query #" + expRunQuery.iQueryNumber + ": " + expRunQuery.strQuerySQL);
						Main._logger.outputLog("    >>> studied already" );
					}
				}else{
					boolean pausedExecutorByUserRequest = false;
					boolean pausedRunByUserRequest = false;
					Main._logger.outputLog("before analyzing query " + expRunQuery.iQueryNumber);
					while(mainStageCnt <= Constants.TRY_COUNTS){	
						try {
							// check if this run has been paused 
							if (checkToBePaused()){
								pausedRunByUserRequest = true;
								break;
							}
							
							// check if this executor has been paused 
							if (checkExecutorOnPause()) {
								pausedExecutorByUserRequest = true;
								break;
							}
							
							if (Main.verbose) {
								Main._logger.outputLog("try"+mainStageCnt+"=> Analyzing Query #"
										+ expRunQuery.iQueryNumber + ": "
										+ expRunQuery.strQuerySQL);
							}
							
							// Study the query.
							analyzeQuery(phase, 
										 expRunQuery,
										 experimentRun.getSearchMethod(), 
										 experimentRun.getSearchGranularity());
							
							break;
						}catch(Exception ex){
							ex.printStackTrace();
							Main._logger.reportError(ex.getMessage());
							mainStageCnt++;
							mainWaitTime *= 2;
							Main._logger.outputLog("Exponential backoff for main stage is performed for : " + mainWaitTime + " (ms)");
							try {
								Thread.sleep(mainWaitTime);
							} catch (InterruptedException e) {}
						}
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
					
					// if we fail after 10 times, then an exception is eventually made.
					if(mainStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC not robust in the main stage");
					mainStageCnt = 1; mainWaitTime = Constants.WAIT_TIME;
					Main._logger.outputLog("after the analysis");
					
					// insert a completed task associated with the query number
					Main._logger.outputLog("before the insertion of the next task number");
					while(lastStageCnt <= Constants.TRY_COUNTS){	
						try {
							// record progress
							recordRunProgress(Math.min((int) ((double) (i + 1)
									/ (double) experimentRunQueries.size() * 100), 99),
									"Analyzed Query # " + i);
							
							putNextTaskNum(runID, i+1);
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
				} // end else
			} // end for each query (inner for loop) 
		} 
	}
	
	
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

		// Set up fixed tables
		for (int i = 0; i < myFixedTables.length; i++) {
			Table curr_table = myFixedTables[i];
			populateFixedTable(curr_table);
			
			// do sanity check on the table creation
			if(!experimentSubject.tableExists(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("table creation of " + curr_table.table_name_with_prefix);
			}
			// do sanity check on table cardinality
			if(curr_table.hy_max_card != experimentSubject.getTableCardinality(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("population of the cardinality of " + curr_table.table_name_with_prefix);
			}
			  
			// update table statistics
			experimentSubject.updateTableStatistics(curr_table);
			// (int)((double)(i + 1) / (double)myVariableTables.length * 100) =
			// % completed
			recordRunProgress((int) ((double) (i + 1)
					/ (double) myFixedTables.length * 100),
					"Populating Fixed Tables");
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
		Main._logger.outputLog("Time out is : " + Constants.EXP_TIME_OUT + " (secs)");
		QueryExecutionStat result_queryexecution_stat = experimentSubject.timeQuery(sql,
				plan, cardinality, Constants.EXP_TIME_OUT);
		return result_queryexecution_stat;
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
	 * @param PreparedStatement
	 *            a prepared statement from state
	 * @param plan
	 *            the plan to be used for executing the query
	 * @param cardinality
	 *            the cardinality at which the input plan was generated for the
	 *            input query.
	 * @return The <code>QueryStat</code> instance which contains the running
	 *         time.
	 */
	protected QueryExecutionStat timePreparedQueryExecution(String sql, 
															PreparedStatement pstmt, 
															PlanNode plan, 
															long cardinality) throws Exception {
		Main._logger.outputLog("Time out is : " + Constants.EXP_TIME_OUT);
//		pstmt = experimentSubject.get
		QueryExecutionStat result_queryexecution_stat = experimentSubject.timePreparedQuery(sql,pstmt,plan,cardinality,Constants.EXP_TIME_OUT);
		return result_queryexecution_stat;
	}
	/**
	 * The tables that are fixed for this experiment.
	 */
	protected Table[] myFixedTables;
	/**
	 * The tables that are variable for this test.
	 */
	protected Table[] myVariableTables;
}
