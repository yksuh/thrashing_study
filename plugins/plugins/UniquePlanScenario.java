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
 * populate 2M table, clone it to variable table, and delete top 10k rows of the
 * variable table until hitting 1M cardinality. In turn, we get an 1M plan, and
 * get a query run associated with it.
 * 
 * @author yksuh
 * 
 */
public class UniquePlanScenario extends ScenarioBasedOnQuery {

	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public UniquePlanScenario(ExperimentRun expRun) {
		super(expRun);
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

				experimentSubject
						.updateTableStatistics(curr_table);
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
		for (int i = 0; i < myFixedTables.length; i++) {
			Table curr_table = myFixedTables[i];
			experimentSubject
					.updateTableStatistics(curr_table);

			// sanity check for table cardinality
			if (curr_table.actual_card != experimentSubject
					.getTableCardinality(curr_table.table_name_with_prefix)) {
				throw new SanityCheckException(
						"Experiment paused by sanity check violation on "
								+ "table cardinality of "
								+ curr_table.table_name_with_prefix + ".");
			}
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
						.outputLog("<First Plass> Starting deleting top10K rows at Cardinality = "
								+ max + " (min: " + min + ")");
			}
			// TreeSet<Long> executed_plans = new TreeSet<Long>();
			Vector<Long> vecCardinalities = generateCandidateCardinalities(
					method, min, max, granularity);
			long current_cardinality = -1;
			for (int j = 0; j < vecCardinalities.size(); j++) {
				// search the entire space, very slow
				if (Main.verbose) {
					Main._logger.outputDebugWithoutNewLine(".");
				}
				current_cardinality = vecCardinalities.get(j);

				boolean should_continue = stepB(phaseNumber, myVariableTables,
						current_cardinality);
				if (!should_continue) {
					break;
				}

			} // end of for loop for each candidate cardinality
			if (Main.verbose) {
				Main._logger
						.outputLog("\n<First Pass>Ending deleting top10K rows at Cardinality = "
								+ current_cardinality);
			}
		}

		int exec_number = 0;
		int iter = 1;
		// update statistics
		// first 1M plan
		PlanNode oneMPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		expQuery.obtainPlanNum(oneMPlan.myHashCode());
		// Step B of the scenario.
		QueryExecutionStat opt_qs = timeQueryExecution(expQuery.strQuerySQL,
				oneMPlan, myVariableTables[0].actual_card);
		// Create a change point for the optimal plan.
		QueryExecution optimalQueryExecution = new QueryExecution(
				myVariableTables.length);

		optimalQueryExecution.plan = oneMPlan;
		optimalQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		optimalQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		optimalQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;

		if (opt_qs != null) {
			optimalQueryExecution.exec_time = opt_qs.getQueryTime();
			optimalQueryExecution.proc_diff_ = opt_qs.getProcDiff();
		}
		optimalQueryExecution.phaseNumber = phaseNumber;
		recordQueryExecution(optimalQueryExecution, expQuery, exec_number,
				iter++, Constants.SCENARIO_BASED_ON_QUERY);

		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// second pass
		// ////////////////////////////////////////////////////////////////////////////////////////////////////////
		// deleting top 10k rows 100 times
		for (int i = 0; i < myVariableTables.length; i++) {
			long min = variable_table[i].hy_min_card;
			long max = variable_table[i].hy_max_card;
			if (Main.verbose) {
				Main._logger
						.outputLog("<Second Pass>Starting deleting top10K rows at Cardinality = "
								+ max + " (min: " + min + ")");
			}
			Vector<Long> vecCardinalities = generateCandidateCardinalities(
					method, min, max, granularity);
			long current_cardinality = -1;
			for (int j = 0; j < vecCardinalities.size(); j++) {
				// search the entire space, very slow
				if (Main.verbose) {
					Main._logger.outputDebugWithoutNewLine(".");
				}
				current_cardinality = vecCardinalities.get(j);
				boolean should_continue = stepB(phaseNumber, myVariableTables,
						current_cardinality);
				if (!should_continue) {
					break;
				}
			} // end of for loop for each candidate cardinality
			if (Main.verbose) {
				Main._logger
						.outputLog("\n<Second Plass>Ending deleting top10K rows at Cardinality = "
								+ current_cardinality);
			}
		}

		Main._logger
				.outputLog("<Second Pass>#### print table rows and pages ###");
		experimentSubject
				.printTableStat(myVariableTables[0].table_name_with_prefix);
		// second 1M plan
		PlanNode seconeOneMPlan = experimentSubject
				.getQueryPlan(expQuery.strQuerySQL);
		expQuery.obtainPlanNum(seconeOneMPlan.myHashCode());
		// Create a change point for the optimal plan.
		QueryExecution secondQueryExecution = new QueryExecution(
				myVariableTables.length);
		QueryExecutionStat second_qrs = timeQueryExecution(
				expQuery.strQuerySQL, seconeOneMPlan,
				myVariableTables[0].actual_card);
		if (second_qrs != null) {
			secondQueryExecution.exec_time = second_qrs.getQueryTime();
			secondQueryExecution.proc_diff_ = second_qrs.getProcDiff();
		}
		secondQueryExecution.phaseNumber = phaseNumber;
		secondQueryExecution.plan = seconeOneMPlan;
		secondQueryExecution.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		secondQueryExecution.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		secondQueryExecution.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		recordQueryExecution(secondQueryExecution, expQuery, exec_number,
				iter++, Constants.SCENARIO_BASED_ON_QUERY);
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
		scenarioName = Constants.NAME_UNIQUE_PLAN_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_UNIQUE_PLAN_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
