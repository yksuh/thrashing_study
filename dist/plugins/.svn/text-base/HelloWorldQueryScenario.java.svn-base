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
package plugins;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.dataModel.Query;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.ScenarioBasedOnQuery;

/**
 * <p>This is a sample code for developing a concrete scenario based on
 * <code>ScenarioBasedQuery</code></p>
 * This scenario simply executes a given query at both max and min cardinalities.
 * (This is made based on 'UniquePlan' scenario.)
 * @author yksuh
 * 
 */
public class HelloWorldQueryScenario extends ScenarioBasedOnQuery {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public HelloWorldQueryScenario(ExperimentRun expRun) {
		super(expRun);
		NUMQUERYEXECS = 3;
		Main._logger.outputLog(":: Hello World Query-Based Scenario :: ");
	}

	/**
	 * Populate the variable tables
	 * 
	 * @param phaseNumber
	 *            Experimental Phase
	 * @param variableTables
	 *            The array of variable tables to be populated
	 */
	protected void stepA(int phaseNumber, Table[] variableTables)
			throws Exception {
		for (int i = 0; i < variableTables.length; i++) {
			Table curr_table = variableTables[i];
			RepeatableRandom rr = new RepeatableRandom(
					curr_table.getTableSeed());
			rr.setMax(curr_table.hy_max_card);
			// Last parameter (true) ensures that a template at the maximum
			// cardinality will be created first, and then partially cloned at
			// the actual cardinality
			experimentSubject.populateTable(curr_table.table_name_with_prefix,
					curr_table.columns.length, curr_table.actual_card,
					curr_table.hy_max_card, rr, true);
			// sanity check for clone max table creation
			if (!experimentSubject.tableExists("clone_max_"
					+ curr_table.table_name_with_prefix)) {
				throw new SanityCheckException(
						"Experiment paused by sanity check violation on table creation of clone_max_"
								+ curr_table.table_name_with_prefix + ".");
			}
			// sanity check for variable table creation
			if (!experimentSubject
					.tableExists(curr_table.table_name_with_prefix)) {
				throw new SanityCheckException(
						"Experiment paused by sanity check violation on table creation of "
								+ curr_table.table_name_with_prefix + ".");
			}
			// For repeatability, ensure statistics are accurate
			experimentSubject
					.updateTableStatistics(curr_table);
			recordRunProgress((int) ((double) (i + 1)
					/ (double) variableTables.length * 100),
					"Populating Variable Tables");
		}
	}

	/**
	 * Change the cardinality of variable table by deleting rows to the
	 * requested value
	 * 
	 * @param phaseNumber
	 *            Experimental Phase
	 * @param variableTables
	 *            Variable tables
	 * @param requested_cardinality
	 *            The requested cardinality of the variable table
	 */
	protected boolean stepB(int phaseNumber, Table[] variableTables,
			long requested_cardinality) throws Exception {
		for (int i = 0; i < variableTables.length; i++) {
			Table curr_table = variableTables[i];
			if (requested_cardinality < curr_table.actual_card) {
				return false;
			}
			try {
				// update table cardinality to requested_cardinality
				experimentSubject.copyTable(curr_table.table_name_with_prefix,
						"clone_max_" + curr_table.table_name_with_prefix, requested_cardinality);
				// update table statistics
				experimentSubject
						.updateTableStatistics(curr_table);
//				experimentSubject.updateTableCardinality(
//						curr_table.table_name_with_prefix,
//						requested_cardinality, curr_table.hy_max_card);
				// do clone table sanity check for the maximum cardinality
				if (requested_cardinality == curr_table.hy_max_card) {
					if (experimentSubject.getTableCardinality("clone_max_"
							+ curr_table.table_name_with_prefix) != curr_table.hy_max_card) {
						throw new SanityCheckException(
								"Experiment paused by sanity check violation on "
										+ "table cardinality of clone_max_"
										+ curr_table.table_name_with_prefix
										+ ".");
					}
				}
				// do the variable table sanity check for the requested
				// cardinality
				if (requested_cardinality != experimentSubject
						.getTableCardinality(curr_table.table_name_with_prefix)) {
					throw new SanityCheckException(
							"Experiment paused by sanity check violation on "
									+ "table cardinality of "
									+ curr_table.table_name_with_prefix + ".");
				}
				experimentSubject
						.updateTableStatistics(curr_table);
			} catch (Exception ex) {
				return false;
			}
		}
		return true;
	}
	/**
	 * Analyze a query 
	 * - Execute it at both the min and max cardinalities
	 * 
	 * @param phaseNumber
	 *            Experimental Phase
	 * @param expQuery
	 *            Query instance
	 * @param method
	 *            Method for constructing candidate cardinality
	 * @param granularity
	 *            Granularity for changing cardinality.
	 * @throws Exception
	 */
	protected void analyzeQuery(int phaseNumber, 
								Query expQuery, 
								String method,
								long granularity) throws Exception {
		int exec_number = 0;
		// update statistics on fixed tables
		for (int i = 0; i < myFixedTables.length; i++) {
			// update statistics on a given fixed table
			experimentSubject.updateTableStatistics(myFixedTables[i]);
			// sanity check for table cardinality
			if (myFixedTables[i].actual_card != experimentSubject
					.getTableCardinality(myFixedTables[i].table_name_with_prefix)) {
				throw new SanityCheckException(
						"Experiment paused by sanity check violation on "
								+ "table cardinality of "
								+ myFixedTables[i].table_name_with_prefix + ".");
			}
		}
		/***
		 * 1) Execute a query at the max cardinality
		 */
		// change cardinality of variable tables
		for (int i = 0; i < myVariableTables.length; i++) {
			// print out execution message
			if (Main.verbose) {
				Main._logger.outputLog("Execute the query at Cardinality = " + myVariableTables[i].hy_max_card);
			}
			// change current cardinality to max
			stepB(phaseNumber, myVariableTables, myVariableTables[i].hy_max_card);
		}
		// get a plan at the max cardinality
		PlanNode maxPlan = experimentSubject.getQueryPlan(expQuery.strQuerySQL);
		// for repeatability, execute the query 'NUMQUERYEXECS' times in place
		for(int j=1;j<=NUMQUERYEXECS;j++){
			// execute a query at the max
			QueryExecutionStat qes = timeQueryExecution(expQuery.strQuerySQL, maxPlan, myVariableTables[0].hy_max_card);
			// build a query execution record
			QueryExecution qe = new QueryExecution(myVariableTables.length, 
												   maxPlan, 
												   myVariableTables[0].hy_max_card, 
												   myVariableTables[0].hy_max_card,
												   myVariableTables[0].table_name,
												   qes, 
												   j,
												   phaseNumber);
			// insert the record into labshelf
			recordQueryExecution(qe, expQuery, exec_number, j, Constants.SCENARIO_BASED_ON_QUERY);
			
			/***
			 * Young added this. If timeout happens, we do not make Q@C any more. 
			 * Thus, we just insert that record having the timeout, and skip the rest of Q@Cs (mantis:1188).
			 */
			if(qes.getQueryTime() == Constants.MAX_EXECUTIONTIME){
				break;
			}
		}
		
		System.out.println("query execution at min cardinality ");
		/***
		 * 2) Execute a query at the min cardinality
		 */
		// change cardinality of variable tables
		for (int i = 0; i < myVariableTables.length; i++) {
			// print out execution message
			if (Main.verbose) {
				Main._logger.outputLog("Execute the query at Cardinality = " + myVariableTables[i].hy_min_card);
			}
			// change current cardinality to max
			stepB(phaseNumber, myVariableTables, myVariableTables[i].hy_min_card);
		}
		// increase execution number, since at another cardinality query execution is made
		exec_number++;
		// get a plan at the max cardinality
		PlanNode minPlan = experimentSubject.getQueryPlan(expQuery.strQuerySQL);
		// for repeatability, execute the query 'NUMQUERYEXECS' times in place
		for(int j=1;j<=NUMQUERYEXECS;j++){
			// execute a query at the min
			QueryExecutionStat qes = timeQueryExecution(expQuery.strQuerySQL, minPlan, myVariableTables[0].hy_min_card);
			// build a query execution record
			QueryExecution qe = new QueryExecution(myVariableTables.length, 
								   minPlan, 
								   myVariableTables[0].hy_min_card, 
								   myVariableTables[0].hy_min_card,
								   myVariableTables[0].table_name,
								   qes, 
								   j,
								   phaseNumber);
			// insert the record into labshelf
			recordQueryExecution(qe, expQuery, exec_number, j, Constants.SCENARIO_BASED_ON_QUERY);
			
			/***
			 * Young added this. If timeout happens, we do not make Q@C any more. 
			 * Thus, we just insert that record having the timeout, and skip the rest of Q@Cs (mantis:1188).
			 */
			if(qes.getQueryTime() == Constants.MAX_EXECUTIONTIME){
				break;
			}
		}
	}
	@Override
	protected void setName() {
		scenarioName = Constants.NAME_HELLO_WORLD_QUERY_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_HELLO_WORLD_QUERY_SCENARIO;
	}

	@Override
	protected int getNumOfPhases() {
		return 1;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}