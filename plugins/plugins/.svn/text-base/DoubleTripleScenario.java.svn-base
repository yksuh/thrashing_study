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

import java.util.Vector;

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
 * This experiment scenario studies plan uniqueness at 1M cardinality. We
 * populate 2M table, clone it to variable table, and delete top 10K rows 100
 * times. In turn, we get an 1M plan, update table statistics, and get a query
 * run associated with it. Then, we update the statistics and get another
 * queryexecution. We will do this twice. Lastly, we will clone the max table to
 * the variable table with 1M rows. We will do the same thing before. Then, the
 * total queryexecutions we will earn will be 6 runs. Hopefully, the identical
 * plan should be chosen across all of the six runs.
 * 
 * @author yksuh
 * 
 */
public class DoubleTripleScenario extends ScenarioBasedOnQuery {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public DoubleTripleScenario(ExperimentRun expRun) {
		super(expRun);
		// set version name for this plugin
	}

	/**
	 * <p>
	 * Populate the variable tables. This scenario creates a template table
	 * which has the same schema as the variable table, and then populates the
	 * template table to the maximum cardinality stated by the experiment
	 * specification. For studying the "optimal" plan at the "actual"
	 * cardinality, it then clones part of the template table as the real
	 * variable table such that the variable table will have the same
	 * cardinality as the "actual" cardinality specified by the experiment
	 * specification.
	 * </p>
	 * <p>
	 * More importantly, the content (data) of the cloned variable table should
	 * be identical to as if it had been populated normally. In fact the way the
	 * template table was populated guarantees the partial cloning has the
	 * effect as expected.
	 * </p>
	 * 
	 * @param variableTables
	 *            The array of variable tables to be populated
	 */
	protected void stepA(int phaseNumber, Table[] variableTables)
			throws Exception {
		for (int i = 0; i < variableTables.length; i++) {
			Table curr_table = variableTables[i];
			RepeatableRandom rr = new RepeatableRandom(curr_table
					.getTableSeed());
			rr.setMax(curr_table.hy_max_card);
			// Last parameter (true) ensures that a template at the maximum
			// cardinality will be created first, and then partially cloned at
			// the
			// actual cardinality
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
	 * requested value.
	 * 
	 * @param variableTables
	 *            Variable tables.
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
				experimentSubject.updateTableCardinality(
						curr_table.table_name_with_prefix,
						requested_cardinality, curr_table.hy_max_card);

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

				experimentSubject.updateTableStatistics(curr_table);
			} catch (Exception ex) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Get the number of phases of this scenario.
	 * 
	 * @return The number of phases.
	 */
	protected int getNumOfPhases() {
		return 1;
	}

	/**
	 * Studying a query.
	 * 
	 * @param queryResult
	 *            The XML element to hold the study result.
	 * @param queryNumber
	 *            The number of the query in the experiment.
	 * @param sql
	 *            The SQL query string.
	 * @param method
	 *            Method for constructing candidate cardinality
	 * @param granularity
	 *            Granularity for changing cardinality.
	 * @throws Exception
	 */
	protected void analyzeQuery(int phaseNumber, Query expQuery, String method,
			long granularity) throws Exception {
		int QueryExecutionNumber = 0;
		// populate fixed table
		for (int i = 0; i < myFixedTables.length; i++) {
			Table curr_table = myFixedTables[i];
			experimentSubject
					.updateTableStatistics(curr_table);
		}
		Table[] variable_table = myVariableTables;

		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// first pass
		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// deleting top 10k rows 100 times
		for (int i = 0; i < myVariableTables.length; i++) {
			long min = variable_table[i].hy_min_card;
			long max = variable_table[i].hy_max_card;
			if (Main.verbose) {
				Main._logger
						.outputLog("<First Double> Starting deleting top10K rows at Cardinality = "
								+ max + " (min: " + min + ")");
			}
			// TreeSet<Long> executed_plans = new TreeSet<Long>();
			Vector<Long> vecCardinalities = generateCandidateCardinalities(
					method, min, max, granularity);
			long current_cardinality = -1;
			for (i = 0; i < vecCardinalities.size(); i++) {
				// search the entire space, very slow
				if (Main.verbose) {
					Main._logger.outputLog(".");
				}
				current_cardinality = vecCardinalities.get(i);
				boolean should_continue = stepB(phaseNumber, myVariableTables,
						current_cardinality);
				if (!should_continue) {
					break;
				}
			} // end of for loop for each candidate cardinality
			if (Main.verbose) {
				Main._logger
						.outputLog("\n<First Double>Ending deleting top10K rows at Cardinality = "
								+ current_cardinality);
			}
		}

		int iter = 1;
		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// update the stat
		Main._logger
				.outputLog("<First Double-1>#### update the table stat ###");
		// experimentSubject.updateTableStatistics(myVariableTables[0].table_name_with_prefix,
		// myVariableTables[0].actual_card,
		// true);
		// print the page stat
		Main._logger
				.outputLog("<First Double-1>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);
		// get the first 1M plan
		PlanNode oneMPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		// put in hash table for quicker search later
		long new_plan_code = oneMPlan.myHashCode();
		expQuery.obtainPlanNum(oneMPlan.myHashCode());
		// get runtime associated with the first plan
		QueryExecutionStat opt_qs = timeQueryExecution(expQuery.strQuerySQL,
				oneMPlan, myVariableTables[0].actual_card);
		// create the first query run
		QueryExecution optimalQueryExecution = new QueryExecution(
				myVariableTables.length);
		optimalQueryExecution.plan = oneMPlan;
		optimalQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		optimalQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		optimalQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		if (opt_qs != null) {
			optimalQueryExecution.exec_time = opt_qs.getQueryTime();
		}
		optimalQueryExecution.phaseNumber = phaseNumber;
		recordQueryExecution(optimalQueryExecution, expQuery,
				QueryExecutionNumber, iter++, Constants.SCENARIO_BASED_ON_QUERY);

		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// update the stat
		Main._logger
				.outputLog("<First Double-2>#### update the table stat ###");
		experimentSubject
				.updateTableStatistics(myVariableTables[0]);
		// print page stat
		Main._logger
				.outputLog("<First Double-2>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);

		// get the second 1M plan
		PlanNode secondPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		new_plan_code = secondPlan.myHashCode();
		// get runtime associated with the second plan
		QueryExecutionStat second_qs = timeQueryExecution(expQuery.strQuerySQL,
				secondPlan, myVariableTables[0].actual_card);
		// create the second query run
		QueryExecution secondQueryExecution = new QueryExecution(
				myVariableTables.length);
		secondQueryExecution.plan = secondPlan;
		secondQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		secondQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		secondQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		if (second_qs != null) {
			secondQueryExecution.exec_time = second_qs.getQueryTime();
		}
		secondQueryExecution.phaseNumber = phaseNumber;

		expQuery.obtainPlanNum(new_plan_code);
		recordQueryExecution(secondQueryExecution, expQuery,
				QueryExecutionNumber, iter++, Constants.SCENARIO_BASED_ON_QUERY);

		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// second pass
		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// deleting top 10k rows 100 times
		for (int i = 0; i < myVariableTables.length; i++) {
			long min = variable_table[i].hy_min_card;
			long max = variable_table[i].hy_max_card;
			if (Main.verbose) {
				Main._logger
						.outputLog("<Second Double>Starting deleting top10K rows at Cardinality = "
								+ max + " (min: " + min + ")");
			}
			Vector<Long> vecCardinalities = generateCandidateCardinalities(
					method, min, max, granularity);
			long current_cardinality = -1;
			for (i = 0; i < vecCardinalities.size(); i++) {
				// search the entire space, very slow
				if (Main.verbose) {
					Main._logger.outputLog(".");
				}
				current_cardinality = vecCardinalities.get(i);
				boolean should_continue = stepB(phaseNumber, myVariableTables,
						current_cardinality);
				if (!should_continue) {
					break;
				}
			} // end of for loop for each candidate cardinality
			if (Main.verbose) {
				Main._logger
						.outputLog("\n<Second Double>Ending deleting top10K rows at Cardinality = "
								+ current_cardinality);
			}
		}

		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Main._logger.outputLog("<Second Double-1>#### update the table stat ###");
		// experimentSubject.updateTableStatistics(myVariableTables[0].table_name_with_prefix,
		// myVariableTables[0].actual_card,
		// true);
		Main._logger
				.outputLog("<Second Double-1>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);

		// get the third 1M plan
		PlanNode thirdPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);

		// get runtime associated with the second plan
		QueryExecutionStat third_qs = timeQueryExecution(expQuery.strQuerySQL,
				thirdPlan, myVariableTables[0].actual_card);
		// create the first query run
		QueryExecution thirdQueryExecution = new QueryExecution(
				myVariableTables.length);
		thirdQueryExecution.plan = thirdPlan;
		thirdQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		thirdQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		thirdQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		if (third_qs != null) {
			thirdQueryExecution.exec_time = third_qs.getQueryTime();
		}
		thirdQueryExecution.phaseNumber = phaseNumber;
		expQuery.obtainPlanNum(thirdPlan.myHashCode());
		recordQueryExecution(thirdQueryExecution, expQuery,
				QueryExecutionNumber, iter++, Constants.SCENARIO_BASED_ON_QUERY);

		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// update the stat
		Main._logger
				.outputLog("<Second Double-2>#### update the table stat ###");
		experimentSubject
				.updateTableStatistics(myVariableTables[0]);
		// print page stat
		Main._logger
				.outputLog("<Second Double-2>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);

		// get the fourth 1M plan
		PlanNode fourthPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		new_plan_code = fourthPlan.myHashCode();

		// get runtime associated with the fourth plan
		QueryExecutionStat fourth_qs = timeQueryExecution(expQuery.strQuerySQL,
				fourthPlan, myVariableTables[0].actual_card);
		// create the second query run
		QueryExecution fourthQueryExecution = new QueryExecution(
				myVariableTables.length);
		fourthQueryExecution.plan = fourthPlan;
		fourthQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		fourthQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		fourthQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		if (fourth_qs != null) {
			fourthQueryExecution.exec_time = fourth_qs.getQueryTime();
		}
		fourthQueryExecution.phaseNumber = phaseNumber;
		expQuery.obtainPlanNum(fourthPlan.myHashCode());
		recordQueryExecution(fourthQueryExecution, expQuery,
				QueryExecutionNumber, iter++, Constants.SCENARIO_BASED_ON_QUERY);

		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// third pass
		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// clone the max table (with 2M rows) to a variable table with 1M rows
		for (int i = 0; i < myVariableTables.length; i++) {
			long default_cardinality = variable_table[i].hy_min_card;
			if (Main.verbose) {
				Main._logger.outputLog("<Third Double> Starts to clone "
						+ default_cardinality + " rows ");
			}
			// clone max table
			experimentSubject.copyTable(
					variable_table[i].table_name_with_prefix, "clone_max_"
							+ variable_table[i].table_name_with_prefix);
			// delete 1M
			experimentSubject.updateTableCardinality(
					variable_table[i].table_name_with_prefix,
					default_cardinality, variable_table[i].hy_max_card);
			// update table stat
			experimentSubject
					.updateTableStatistics(variable_table[i]);
			if (Main.verbose) {
				Main._logger.outputLog("\n<Third Double>Ends cloning "
						+ default_cardinality + " rows ");
			}
		}

		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		Main._logger
				.outputLog("<Third Double-1>#### update the table stat ###");
		// experimentSubject.updateTableStatistics(myVariableTables[0].table_name_with_prefix,
		// myVariableTables[0].actual_card,
		// true);
		Main._logger
				.outputLog("<Third Double-1>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);

		// get the fifth 1M plan
		PlanNode fifthPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		new_plan_code = fifthPlan.myHashCode();
		// get runtime associated with the fifth plan
		QueryExecutionStat fifth_qs = timeQueryExecution(expQuery.strQuerySQL,
				fifthPlan, myVariableTables[0].actual_card);
		// create the first query run
		QueryExecution fifthQueryExecution = new QueryExecution(
				myVariableTables.length);
		fifthQueryExecution.plan = fifthPlan;
		fifthQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		fifthQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		fifthQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		if (fifth_qs != null) {
			fifthQueryExecution.exec_time = fifth_qs.getQueryTime();
		}
		fifthQueryExecution.phaseNumber = phaseNumber;
		expQuery.obtainPlanNum(fifthPlan.myHashCode());
		recordQueryExecution(fifthQueryExecution, expQuery,
				QueryExecutionNumber, iter++, Constants.SCENARIO_BASED_ON_QUERY);

		// /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// update the stat
		Main._logger
				.outputLog("<Triple Double-2>#### update the table stat ###");
		experimentSubject
				.updateTableStatistics(myVariableTables[0]);
		// print page stat
		Main._logger
				.outputLog("<Triple Double-2>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);

		// get the sixth 1M plan
		PlanNode sixthPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		// get runtime associated with the fourth plan
		QueryExecutionStat sixth_qs = timeQueryExecution(expQuery.strQuerySQL,
				sixthPlan, myVariableTables[0].actual_card);
		// create the sixth query run
		QueryExecution sixthQueryExecution = new QueryExecution(
				myVariableTables.length);
		sixthQueryExecution.plan = sixthPlan;
		sixthQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		sixthQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		sixthQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		if (sixth_qs != null) {
			sixthQueryExecution.exec_time = sixth_qs.getQueryTime();
		}
		sixthQueryExecution.phaseNumber = phaseNumber;
		expQuery.obtainPlanNum(sixthPlan.myHashCode());
		recordQueryExecution(sixthQueryExecution, expQuery,
				QueryExecutionNumber, iter++, Constants.SCENARIO_BASED_ON_QUERY);
		Main._logger.outputLog("End of All Found Plans");
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
	private Vector<Long> generateCandidateCardinalities(String method,
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

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_DOUBLE_TRIPLE_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_DOUBLE_TRIPLE_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
