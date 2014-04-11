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
package plugins.expired;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;
import java.util.Vector;
import org.w3c.dom.Element;
import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.dataModel.Query;
//import azdblab.labNotebook.dataModel.Run;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.Scenario;

/**
 * <p>This is an experiment scenario that examines query plan generation 
 * by varying the cardinality of the variable tables. The approach for altering
 * the cardinality is specific to each sub-class.</p>
 * Four steps, namely stepA, stepB, stepC, and stepD are provided for
 * implement specific experiment execution steps. Note that in this class, all
 * these steps only provide the default actions, which simply returns as soon as
 * the method is called. It is the responsibilty of each subclass to override
 * these methods to specialize this experiment scenario.
 * <p>Generally, the set of fixed experiment tables will be created and
 * populated by calling the <code>populateFixedTable</code> method. The 
 * variable tables should be handled by <code>stepA</code>.
 * The actual experiment will then loop on the phases which will each invoke
 * the <code>analyzeQuery</code> method.</p>
 * <p>In each <code>analyzeQuery</code>, an individual query is studied. At
 * first, the scenario need to examine the query execution at the "actual"
 * cardinality, thus the scenario call <code>stepB</code> to measure the
 * execution time then call <code>recordQueryExecution</code> to store the details of
 * the "optimal" plan into the lab notebook. Since our main goal is to study
 * the query plans at various cardinalities, the scenario first provide a
 * sequence of pre-computed candidate cardinality values by calling
 * <code>generateCandidateCardinalities</code>.
 * The scenario then iterates over these values starting from the maximum and
 * then decrease with calls to <code>stepC</code>, which changes the table
 * cardinality as requested, either physically or virtually, according to the
 * implementations of sub-scenarios. Following <code>stepC</code>, the scenario
 * calls <code>stepD</code> to measure the plan execution time and
 * <code>recordQueryExecution</code> to store the detail of the plan execution.</p>
 * <p><code>stepE</code>, <code>stepF</code> and <code>stepG</code> provide
 * extra functionalities for performing experiments. Subclasses should override
 * them if necessary.
 * </p>
 * <p>The scenario provides the <code>timeQueryExecution</code> method in the
 * experiment since some of the experiment scenarios will study the performance
 * of plans. This method may be called by <code>stepB</code> and
 * <code>stepD</code>. In the case the timing information is not needed in the
 * experiment, subclasses should use the default <code>stepB</code> and
 * <code>stepD</code> implementations which do no timing.</p>
 * @author ruizhang
 */
public abstract class VaryCardinalityScenario extends Scenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public VaryCardinalityScenario(ExperimentRun expRun) {
		super(expRun);
		planToExecutionTimeMap = new HashMap<Long, Long>();
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
	protected void stepA(int phase_number, Table[] variableTables)
			throws Exception {
	}

	/**
	 * Time the query plan execution. Used for timing the optimal plan.
	 * 
	 * @param sql
	 *            The query string.
	 * @param plan
	 *            The plan selected for the query.
	 * @param cardinality
	 *            The (variable) table cardinality at which the plan was
	 *            selected.
	 * @return The <code>QueryExecutionStat</code> instance containing the timing
	 *         information. By default, null is returned indicating no timing
	 *         data should be stored in the lab notebook.
	 */
	protected QueryExecutionStat stepB(int phaseNumber, String sql, PlanNode plan,
			long cardinality) throws Exception {
		return null;
	}

	/**
	 * <p>
	 * Change the table cardinality to the requested one. The cardinality is
	 * guaranteed to decrease over subsequent calls.
	 * </p>
	 * <p>
	 * Note that at the beginning, <code>requested_cardinality</code> will be
	 * equal to the table's maximum cardinality. So simply cloning the template
	 * table (which could contain the maximum cardinality) is an efficient
	 * approach. Subsequently, as the requested cardinality decreases, rows can
	 * be deleted from the variable table accordingly.
	 * </p>
	 * 
	 * @param requested_cardinality
	 *            Requested table cardinality.
	 * @return false indicating that no further work on this query should be
	 *         done, for example the requested_cardinality is less than the
	 *         actual cardinality.
	 */
	protected boolean stepC(int phaseNumber, Table[] variableTables,
			long requested_cardinality) throws Exception {
		return false;
	}

	/**
	 * Time the query plan execution. Used for timing the plans generated as the
	 * variable table cardinality decreases.
	 * 
	 * @param sql
	 *            The query string.
	 * @param plan
	 *            The plan selected for the query.
	 * @param cardinality
	 *            The (variable) table cardinality at which the plan was
	 *            selected.
	 * @return The <code>QueryExecutionStat</code> instance containing the timing
	 *         information. By default, null is returned indicating no timing
	 *         data should be stored in the lab notebook.
	 */
	protected QueryExecutionStat stepD(int phaseNumber, String sql, PlanNode plan,
			long cardinality) throws Exception {
		return null;
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
		// Looping on the phases.
		for (int phase = 1; phase <= getNumOfPhases(); phase++) {

			stepA(phase, myVariableTables);

			List<Query> experimentRunQueries = exp_run_.getExperimentRunQueries();
			// Run exp_run = dbController.getUser(userName)
			// .getNotebook(notebookName)
			// .getExperiment(experimentName)
			// .getRun(startTime);
			// Looping on the queries
			for (int i = 0; i < experimentRunQueries.size(); i++) {
//				Query expRunQuery = experimentRunQueries.get(i);
//				Element queryResult = null;

				// if(exp_run.getQuery(expRunQuery.iQueryNumber).queryHasResult())
				// {
//				if (expRunQuery.queryHasResult(phase)) {
					// dbController.queryHasResult(
					// userName, notebookName, experimentName, startTime,
					// phase, expRunQuery.iQueryNumber,
					// expRunQuery.strQuerySQL)){
					// get the result from the database
					// queryResult =
					// exp_run.getQuery(expRunQuery.iQueryNumber).getQueryResult();
//					queryResult = expRunQuery.getQueryResult(new int[] { phase });
					// queryResult = dbController.getQueryResult(
					// userName, notebookName, experimentName, startTime,
					// new int[] {phase}, expRunQuery.iQueryNumber);
//					if (Main.verbose) {
//						Main._logger.outputLog("Retrieving Result for Query #"
//								+ expRunQuery.iQueryNumber + ": "
//								+ expRunQuery.strQuerySQL);
//					}
//					queryResult = (Element) myResultXML.importNode(queryResult,
//							true);
//				} else {
//					// Query hasn't yet been analyzed.
//					if (checkToBePaused()) {
////						Main.defaultLogger.logging_normal("paused!!!");
////						return false; // Stop, not finished yet
//						return;
//					}
//					// starts to run new query.
////					queryResult = myResultXML.createElement("queryResult");
////					queryResult.setAttribute("sql", expRunQuery.strQuerySQL);
//					recordRunProgress(Math.min((int) ((double) (i + 1)
//							/ (double) experimentRunQueries.size() * 100), 99),
//							"Analyzing Query # " + i);
//					if (Main.verbose) {
//						Main._logger.outputLog("Analyzing Query #"
//								+ expRunQuery.iQueryNumber + ": "
//								+ expRunQuery.strQuerySQL);
//					}
//					// Study the query.
//					analyzeQuery(phase, 
////								 queryResult, 
//								 expRunQuery.iQueryNumber,
//								 expRunQuery.strQuerySQL, 
//								 experimentRun.getSearchMethod(), 
//								 experimentRun.getSearchGranularity());
////					File queryResultFile = File.createTempFile("queryResult",
////							".xml", new File(MetaData.DIRECTORY_TEMP));
////					queryResultFile.deleteOnExit();
////					XMLHelper.writeXMLToOutputStream(new FileOutputStream(
////							queryResultFile), queryResult);
////					Main._logger.outputLog("before validate query result");
////					XMLHelper.validate(
////							// (getClass().getClassLoader().getResourceAsStream(
////							new FileInputStream(new File(
////									MetaData.CHOSEN_QUERY_RESULT_SCHEMA)),
////							queryResultFile);
////					Main._logger.outputLog("before insert query result");
//					/*
//					 * dbController.getUser(userName) .getNotebook(notebookName)
//					 * .getExperiment(experimentName) .getRun(startTime)
//					 * .getQuery
//					 * (expRunQuery.iQueryNumber).insertQueryResult(phase, new
//					 * FileInputStream(queryResultFile));
//					 */
////					expRunQuery.insertQueryResult(phase, new FileInputStream(
////							queryResultFile));
//					// dbController.insertQueryResult(
//					// userName, notebookName, experimentName, startTime,
//					// phase, expRunQuery.iQueryNumber, new
//					// FileInputStream(queryResultFile));
//				}
//				testResult.appendChild(queryResult);
				Main._logger.outputLog("executing a query");
			}

		}
		// drop all installed tables
		dropExperimentTables();
		finishExperiment();
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
	
	/**
	 * Records a change point in the lab notebook. The result is also recorded
	 * in the XML result.
	 * 
	 * @param current_point
	 *            The current change point.
	 * @param queryNumber
	 *            The query number that this change point is associated with.
	 * @param cp_number
	 *            The change point number for this change point.
	 * 
	 * Young: the below new parameter, 'one1MPlan', indicates whether the give 'current_point' is 
	 * 		  a change point at 1M or not
	 * @param one1MPlan
	 *            denotes whether 'current_point' is a change point at 1M or not
	 * @return The element that stores the result of this change point.
	 */
	/*******************************************************
	private Element recordQueryExecution(QueryExecution current_point, 
								   int queryNumber,
								   int cp_number) {
    *********************************************************/
	protected void recordQueryExecution(QueryExecution current_point, 
										 int queryNumber,
										 int cp_number, 
										 boolean one1MPlan) throws Exception{
	
//		Element query_run = myResultXML.createElement("QueryExecution");
//		
//		/*********************************************************
//		if (current_point.isOptimal) {
//			query_run = myResultXML.createElement("optimalPlan");
//		}
//		**********************************************************/
//		if (one1MPlan) {
//			query_run = myResultXML.createElement("optimalPlan");
//		}else{
//			query_run = myResultXML.createElement("QueryExecution");
//		}
//			
		Query temp_query = exp_run_.getQuery(queryNumber);
//		query_run.setAttribute("executionTime", current_point.exec_time + "");
//		query_run.setAttribute("units", "milli seconds");
//		query_run.setAttribute("planNumber", current_point.planNumber + "");
//		query_run.setAttribute("phaseNumber", current_point.phaseNumber + "");
		
Main._logger.outputLog("****** (queryExecutionNumber, cardinality)*************");
		for (int i = 0; i < current_point.myQueryExecutionTables.length; i++) {
Main._logger.outputLog("("+cp_number+", "+ current_point.myQueryExecutionTables[i].max_val +")");
			int queryexecution_id = temp_query.insertQueryExecution(
					current_point.phaseNumber, 
					queryNumber, 
					cp_number,
					current_point.myQueryExecutionTables[i].max_val,
					current_point.getResultCardinality(),
					current_point.exec_time,"",0, Constants.SCENARIO_BASED_ON_QUERY);
			
			if (queryexecution_id < 0) {
				Main._logger.reportError("queryexecution id cannot be negative!");
				continue;
			}
			
			// dbController.insertQueryExecution(
			// userName, notebookName, experimentName, startTime,
			// current_point.phaseNumber, queryNumber, cp_number,
			// current_point.myQueryExecutionTables[i].max_val,
			// current_point.exec_time);
			if (current_point.phaseNumber != 2) {
				Main._logger.outputLog("before inserting the plan of a change point ... ");
				long planID = temp_query.insertPlan(queryNumber,
												    cp_number, 
												    queryexecution_id,
												    current_point.plan);
				Main._logger.outputLog("done with inserting the plan of a change point ... ");
				
				Main._logger.outputLog("before inserting query run stat... ");
				// insert query run stat
				temp_query.insertQueryExecutionStat(queryexecution_id, planID, current_point.plan);
				Main._logger.outputLog("done with inserting query run stat ... ");
				// dbController.insertPlan(
				// userName, notebookName, experimentName, startTime,
				// queryNumber, cp_number, current_point.plan);
			}
			
//			Element table = myResultXML.createElement("table");
//			table.setAttribute("name",
//					current_point.myQueryExecutionTables[i].table_name);
//			table.setAttribute("cardinality",
//					current_point.myQueryExecutionTables[i].max_val + "");
//			query_run.appendChild(table);
		}
		Main._logger.outputLog("*************************************************");
		
		Main._logger.outputLog("return query_run");
//		return query_run;
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
		Main._logger.outputLog("Time out is : " + Constants.EXP_TIME_OUT);
		QueryExecutionStat result_queryexecution_stat = experimentSubject.timeQuery(sql,
				plan, cardinality, Constants.EXP_TIME_OUT);
		return result_queryexecution_stat;
	}

	/**
	 * Setting up the necessary variables for experiment.
	 * 
	 * @throws Exception
	 */
	private void initializeNotebookContent() throws Exception {
		Element tableSummary = null;
		mapQueryToSubOptPlan = new HashMap<Integer, TreeSet<Long>>();
		myFixedTables = experimentRun.getFixedTables();
		myVariableTables = experimentRun.getVariableTables();
		testResult = myResultXML.createElement("testResult");
		myResultXML.appendChild(testResult);
		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
		/********************** INFORMATION SECTION ************************/
		Element log = myResultXML.createElement("log");
		testResult.appendChild(log);
		Element expTime = myResultXML.createElement("experimentTime");
		expTime.setAttribute("time", sdf.format(new Date(System
				.currentTimeMillis())));
		log.appendChild(expTime);
		Element dbversion = myResultXML.createElement("dbVersion");
		dbversion.setAttribute("version", experimentSubject.getDBVersion());
		log.appendChild(dbversion);
		Element azdblabVersion = myResultXML.createElement("azdblabVersion");
		azdblabVersion.setAttribute("version", Constants.AZDBLAB_VERSION);
		log.appendChild(azdblabVersion);
		Element experiment = myResultXML.createElement("experiment");
		log.appendChild(experiment);
		tableSummary = myResultXML.createElement("tableSummary");
		testResult.appendChild(tableSummary);
		// Building the XML for that summarizes the fixed tables.
		for (int i = 0; i < myFixedTables.length; i++) {
			Element table = myResultXML.createElement("table");
			String table_name = myFixedTables[i].table_name;
			table.setAttribute("name", table_name);
			table.setAttribute("seed", String.valueOf(myFixedTables[i]
					.getTableSeed()));
			table.setAttribute("actualCardinality", myDataDef
					.getTableCardinality(table_name)
					+ "");
			table.setAttribute("type", "fixed");
			tableSummary.appendChild(table);
		}
		// Building the XML for that summarizes the variable tables.
		for (int i = 0; i < myVariableTables.length; i++) {
			Element table = myResultXML.createElement("table");
			String table_name = myVariableTables[i].table_name;
			table.setAttribute("name", table_name);
			table.setAttribute("seed", String.valueOf(myVariableTables[i]
					.getTableSeed()));
			table.setAttribute("actualCardinality", myDataDef
					.getTableCardinality(table_name)
					+ "");
			table.setAttribute("type", "variable");
			tableSummary.appendChild(table);
		}
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
					/ (double) myVariableTables.length * 100),
					"Populating Fixed Tables");
		}
	}

	/**
	 * Result XML Component
	 */
	protected Element testResult = null;

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
