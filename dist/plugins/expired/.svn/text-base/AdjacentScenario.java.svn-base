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

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeSet;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

/**
 * This experiment scenario studies plan generation and execution by varying the
 * table cardinality physically from the maximum to the actual, timing each when
 * the plan changes.
 * 
 * @author ruizhang
 * 
 */
public class AdjacentScenario extends VaryCardinalityScenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public AdjacentScenario(ExperimentRun expRun) {
		super(expRun);
			pluginTestSchema = "plugins/xml_schema/testResultAdjacent_02_20_2010_20_20_19.xsd";
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
			// For repeatability, ensure statistics are accurate

			// sanity check for clone max table creation
			if (!experimentSubject.tableExists("clone_max_"
					+ curr_table.table_name_with_prefix)) {
				throw new SanityCheckException("table creation of clone_max_"
						+ curr_table.table_name_with_prefix);
			}

			// sanity check for variable table creation
			if (!experimentSubject
					.tableExists(curr_table.table_name_with_prefix)) {
				throw new SanityCheckException("table creation of "
						+ curr_table.table_name_with_prefix);
			}

			experimentSubject.updateTableStatistics(curr_table);
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
			if (requested_cardinality == curr_table.hy_max_card) {
				experimentSubject.copyTable(curr_table.table_name_with_prefix,
						"clone_max_" + curr_table.table_name_with_prefix); // ft_HT1
																			// is
																			// supposed
																			// to
																			// be
																			// deleted,
																			// not
																			// "clone_max"
																			// table)
				experimentSubject.commit();
			} else {
				String updateSQL = "DELETE FROM "
						+ curr_table.table_name_with_prefix + " WHERE id1 >= "
						+ requested_cardinality;
				try {
					experimentSubject.executeDeleteSQL(updateSQL);
				} catch (SQLException ex) {
					String msg = "failing to execute the following sql stmt: "
							+ updateSQL;
					// System.err.println(msg);
					throw new SQLException(msg);
				}
			}
			// do clone table sanity check for the maximum cardinality
			if (requested_cardinality == curr_table.hy_max_card) {
				if (experimentSubject.getTableCardinality("clone_max_"
						+ curr_table.table_name_with_prefix) != curr_table.hy_max_card) {
					throw new SanityCheckException(
							"table cardinality of clone_max_"
									+ curr_table.table_name_with_prefix);
				}
			}
			// do the variable table sanity check for the requested cardinality
			if (requested_cardinality != experimentSubject
					.getTableCardinality(curr_table.table_name_with_prefix)) {
				throw new SanityCheckException("table cardinality of "
						+ curr_table.table_name_with_prefix);
			}
			experimentSubject.updateTableStatistics(curr_table);
		}
		return true;
	}

	/**
	 * Studies a query
	 */
	protected void analyzeQuery(int phaseNumber, 
//								Element queryResult,
								int queryNumber, 
								String sql, 
								String method, 
								long granularity) throws Exception {
		vecQueryPlans = new Vector<Long>();
		planToExecutionTimeMap.clear();

		if (phaseNumber == 1) {
			for (int i = 0; i < myFixedTables.length; i++) {
				Table curr_table = myFixedTables[i];
				experimentSubject.updateTableStatistics(curr_table);
			}

			// ////////////////////////////////////////////////////////////////////////////////////////////////////////
			// first pass
			// ////////////////////////////////////////////////////////////////////////////////////////////////////////
			// deleting top 10k rows 100 times
			for (int i = 0; i < myVariableTables.length; i++) {
				Table curr_table = myVariableTables[i];
				long min = curr_table.hy_min_card;
				long max = curr_table.hy_max_card;
				if (Main.verbose) {
					Main._logger.outputLog("<1M Plan> Starting deleting top10K rows at Cardinality = "
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
					boolean should_continue = stepB(phaseNumber,
							myVariableTables, current_cardinality);
					if (!should_continue) {
						break;
					}
				} // end of for loop for each candidate cardinality
				if (Main.verbose) {
					Main._logger.outputLog("\n<1M Plan>Ending deleting top10K rows at Cardinality = "
									+ current_cardinality);
				}
			}
			// Main.defaultLogger.logging_normal("<First Pass>#### print table rows and pages ###");
			// experimentSubject.printTableStat(myVariableTables[0].table_name_with_prefix);

			planToPlanNumberMap = new HashMap<Long, Integer>();
			// This is the optimal run according to the optimizer
			PlanNode oneMPlan = experimentSubject.getQueryPlan(sql);

			// Time a query at the actual cardinality
			QueryExecutionStat opt_qs = timeQueryExecution(sql, oneMPlan,
					myVariableTables[0].actual_card);

			// put in hash table for quicker search later
			vecQueryPlans.add(oneMPlan.myHashCode());
			planToPlanNumberMap.put(oneMPlan.myHashCode(), new Integer(0));
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

			// recording the optimal plan result in xml and dbms
//			Element optimalQueryExecutionElement = recordQueryExecution(
//					optimalQueryExecution, queryNumber,
//					MetaData.OPTIMAL_CHANGE_POINT_NUMBER, true);
//			queryResult.appendChild(optimalQueryExecutionElement);
			recordQueryExecution(optimalQueryExecution, 
								queryNumber,
								Constants.OPTIMAL_CHANGE_POINT_NUMBER, 
								true);
//			queryResult.appendChild(optimalQueryExecutionElement);
		} // end if phaseNumber == 1
		Main._logger.outputLog("continue in analyze query");

		// change_points found by exhaustive search and optimal plan
		// find the plan change points while changing the cardinality
		Main._logger.outputLog("before find query runs");
		Vector<QueryExecution> query_runs = findChangePoints(phaseNumber, sql,
				queryNumber, method, granularity);

		// Main.defaultLogger.logging_normal("<< 2) print table rows and pages after finding query runs >> ");
		// experimentSubject.printTableStat(myVariableTables[0].table_name_with_prefix);

		makeQueryExecutions(phaseNumber, sql, query_runs);
		Main._logger.outputLog("after find query runs");
		// adding the change point results to the xml and databasenew_plan_code

		for (int i = 0; i < query_runs.size(); i++) {
			QueryExecution current_point = (QueryExecution) query_runs.get(i);

//			Element queryExecutionElement = recordQueryExecution(current_point,
//					queryNumber, i, false);
//			queryResult.appendChild(queryExecutionElement);
			recordQueryExecution(current_point, 
								 queryNumber, 
								 i, 
								 false);
			current_point.plan.myHashCode();
		}
		Main._logger.outputLog("done recording all query runs");
	}

	/***
	 * The purpose of <code>findChangePoints</code> is to find the minimum
	 * cardinalities for each plan Also, to allow comparison to closest plan A
	 * below it rather than Plan A at 1million This allows us to range
	 * cardinalities all the way down to 1. It also allows us to be less
	 * conservative about which plans are <code>suboptimal</code> If we run the
	 * plans at the minimum cardinality, it is closer to the cardinality for
	 * closest plan A than at max
	 * 
	 * Locates query runs in the specified range.
	 * 
	 * @param phaseNumber
	 *            : phaseNumber. Currently 1
	 * @param sql
	 *            The SQL for the query that is being analyzed.
	 * @param queryNumber
	 *            The query number of the query being analyzed.
	 * @param method
	 *            method used for determining the test cardinalities.
	 * @param granularity
	 *            The granularity of the search.
	 * @return A vector of query runs.
	 * @throws Exception
	 *             If something fails.
	 */
	private Vector<QueryExecution> findChangePoints(int phaseNumber,
			String sql, int queryNumber, String method, long granularity)
			throws Exception {
		set_new_plans_ = new TreeSet<Long>();
		Vector<QueryExecution> resultQueryExecution = new Vector<QueryExecution>();
		int planCount = 1;
		Table[] variable_table = myVariableTables;
		// QueryExecution curr_queryexecution;
		long min = variable_table[0].hy_min_card; // hy_min_card and hy_max_card
		// come from XML file
		long max = variable_table[0].hy_max_card;
		if (Main.verbose) {
			Main._logger.outputLog("Starting Change Point Discovery at Cardinality = "
							+ max + " (min: " + min + ")");
		}
		// TreeSet<Long> executed_plans = new TreeSet<Long>();
		Vector<Long> vecCardinalities = generateCandidateCardinalities(method,
				min, max, granularity);
		long current_cardinality = -1;
		PlanNode prev_node = null;
		for (int i = 0; i < vecCardinalities.size(); i++) {
			// search the entire space, very slow
//			if (Main.verbose) {
//				Main._logger.outputLog(".");
//			}
			current_cardinality = vecCardinalities.get(i);
			QueryExecution curr_queryexecution = new QueryExecution(1); // one
																		// change
																		// point
																		// table

			for (int j = 0; j < variable_table.length; j++) { // for each
				// variable
				// table
				curr_queryexecution.myQueryExecutionTables[j].min_val = current_cardinality;
				curr_queryexecution.myQueryExecutionTables[j].max_val = current_cardinality;
				curr_queryexecution.myQueryExecutionTables[j].table_name = myVariableTables[j].table_name;
				/**********************************************************************/
				curr_queryexecution.phaseNumber = phaseNumber;
				/***********************************************************************/
			}

			boolean should_continue = stepB(phaseNumber, myVariableTables,
					current_cardinality);
			if (!should_continue) {
				break;
			}

			// get a plan at a certain cardinality, 'c'
			PlanNode new_plan_node = experimentSubject.getQueryPlan(sql);
			if (new_plan_node == null) {
				continue;
			}
			long new_plan_code = new_plan_node.myHashCode();
			set_new_plans_.add(new_plan_code);

			/***********************************************************************************
			 * Young's note: Below is the new adjacent scenario we discussed on
			 * Mar 2. *
			 ********************************************************************************/
			// extract the query plan from the DBMS for this cardinality
			// this plan is not equal to the last plan, so this is a change
			// point
			if (vecQueryPlans.size() == 1
					|| (vecQueryPlans.get(vecQueryPlans.size() - 1).longValue()) != new_plan_code) {
				if (vecQueryPlans.size() > 1) {
					// create a query run for lower cardinality
					QueryExecution lower_queryexecution = new QueryExecution(1);
					for (int j = 0; j < variable_table.length; j++) { // for
																		// each
						// variable
						// table
						lower_queryexecution.myQueryExecutionTables[j].min_val = current_cardinality
								+ granularity;
						lower_queryexecution.myQueryExecutionTables[j].max_val = current_cardinality
								+ granularity;
						lower_queryexecution.myQueryExecutionTables[j].table_name = myVariableTables[j].table_name;
						/**********************************************************************/
						lower_queryexecution.phaseNumber = phaseNumber;
						/***********************************************************************/
					}
					QueryExecution upper_queryexecution = resultQueryExecution
							.get(resultQueryExecution.size() - 1);

					PlanNode lower_plan = prev_node;
					if (lower_plan.myHashCode() != upper_queryexecution.plan
							.myHashCode()) {
						if (Main.verbose) {
							throw new Exception(
									"findQueryExecutions: The plan found at lower bound is different from one found at upper bound"
											+ "lower_plan: "
											+ lower_plan.myHashCode()
											+ ", upper_plan: "
											+ upper_queryexecution.plan
													.myHashCode());
						}
					}
					lower_queryexecution.plan = lower_plan;
					lower_queryexecution.planNumber = upper_queryexecution.planNumber;

					if (Main.verbose) {
						Main._logger.outputLog("\nCreate a lower query run (using Plan #"
										+ lower_queryexecution.planNumber
										+ "/<"
										+ lower_queryexecution.plan
												.myHashCode()
										+ ">"
										+ ") with Cardinality = "
										+ lower_queryexecution.myQueryExecutionTables[0].max_val);
					}

					// 1.01M or 1.99M are covered by the below routine
					if (upper_queryexecution.myQueryExecutionTables[0].max_val != lower_queryexecution.myQueryExecutionTables[0].max_val) {
						resultQueryExecution.add(resultQueryExecution.size(),
								lower_queryexecution);
					}
				}

				// create a query run for upper cardinality
				int planNumber = vecQueryPlans.indexOf(new_plan_code);
				if (planNumber == -1) {
					// this is a new plan, never before seen
					planToPlanNumberMap.put(new_plan_code, new Integer(
							planCount));
					curr_queryexecution.planNumber = planCount++;
				} else {
					curr_queryexecution.planNumber = ((Integer) planToPlanNumberMap
							.get(new_plan_code)).intValue();
				}
				if (Main.verbose) {
					Main._logger.outputLog("\nFound change point (using Plan #"
									+ curr_queryexecution.planNumber + "/<"
									+ new_plan_code + ">"
									+ ") with Cardinality = "
									+ current_cardinality);
				}
				curr_queryexecution.plan = new_plan_node;
				vecQueryPlans.add(vecQueryPlans.size(), new_plan_code);
				resultQueryExecution.add(resultQueryExecution.size(),
						curr_queryexecution);
			} // end of if vecQueryPlans.size()==1 ...
			prev_node = new_plan_node;
		} // end of for loop for each candidate cardinality

		if (Main.verbose) {
			Main._logger.outputLog("\nEnding Query Run Discovery at Cardinality = "
							+ current_cardinality);
		}

		// get plan at 1M again
		// Main.defaultLogger.logging_normal("<<< timing 1M plan again at 1M >>>");
		// Main.defaultLogger.logging_normal("<< print table rows and pages before timing 1M plan again at 1M >> ");
		// experimentSubject.printTableStat(myVariableTables[0].table_name_with_prefix);
		// time the query
		QueryExecution oneMPQueryExecutionAtEnd = new QueryExecution(
				myVariableTables.length);
		// get 1M plan
		PlanNode lastOneMP = experimentSubject.getQueryPlan(sql);
		long last_plan_code = lastOneMP.myHashCode();
		set_new_plans_.add(last_plan_code);
		int planNumber = vecQueryPlans.indexOf(last_plan_code);
		if (planNumber == -1) {
			// this is a new plan, never before seen
			planToPlanNumberMap.put(last_plan_code, new Integer(planCount));
			oneMPQueryExecutionAtEnd.planNumber = planCount++;
		} else {
			oneMPQueryExecutionAtEnd.planNumber = ((Integer) planToPlanNumberMap
					.get(last_plan_code)).intValue();
		}
		oneMPQueryExecutionAtEnd.plan = lastOneMP;
		oneMPQueryExecutionAtEnd.myQueryExecutionTables[0].max_val = myVariableTables[0].actual_card;
		oneMPQueryExecutionAtEnd.myQueryExecutionTables[0].min_val = myVariableTables[0].actual_card;
		oneMPQueryExecutionAtEnd.myQueryExecutionTables[0].table_name = myVariableTables[0].table_name;
		oneMPQueryExecutionAtEnd.phaseNumber = phaseNumber;
		// to avoid duplicate query runs at 1M
		QueryExecution last_queryexecution = resultQueryExecution
				.get(resultQueryExecution.size() - 1);
		if (last_queryexecution.myQueryExecutionTables[0].max_val != oneMPQueryExecutionAtEnd.myQueryExecutionTables[0].max_val) {
			vecQueryPlans.add(vecQueryPlans.size(), last_plan_code);
			resultQueryExecution.add(resultQueryExecution.size(),
					oneMPQueryExecutionAtEnd);
		}

		Iterator<Long> iter_new_plans = set_new_plans_.iterator();
		Main._logger.outputLog("All Found Plans");
		while (iter_new_plans.hasNext()) {
			Main._logger.outputLog(iter_new_plans.next().toString());
		}
		Main._logger.outputLog("End of All Found Plans");

		/**************************************************************************************************/
		// remove plans that are below the lowest Plan A.
		// Since A always has to be to the left of the plan to check for
		// suboptimality
		// for (int i = last_plan_A_id - 1; i >= 0; --i) {
		// resultQueryExecution.remove(i);
		// }
		Main._logger.outputLog("Remaining query runs:");
		for (int i = 0; i < resultQueryExecution.size(); ++i) {
			Main._logger.outputLog(resultQueryExecution.get(i).planNumber + "");
		}
		Main._logger.outputLog("");
		// print out a sequence of query run numbers of resultQuerun for sanity
		// check.
		return resultQueryExecution;
	}

	/**
	 * 
	 * @param phaseNumber
	 *            : phaseNumber. Currently 1
	 * @param sql
	 *            The SQL for the query that is being analyzed.
	 * @param resultQueryExecution
	 *            : The vector of QueryExecutions, i.e., the adjacent change
	 *            points
	 * @throws Exception
	 *             If something fails.
	 */

	private void makeQueryExecutions(int phaseNumber, String sql,
			Vector<QueryExecution> resultQueryExecution) throws Exception {
		// set_new_plans_ = new TreeSet<Long>();
		if (Main.verbose) {
			Main._logger.outputLog("Starting a query execution(s) at a change point(s)");
		}
		// Run StepC and time a query at the corresponding cardinality
		QueryExecution curr_queryexecution;
		curr_queryexecution = new QueryExecution(1);
		for (int i = 0; i < resultQueryExecution.size(); ++i) {
			curr_queryexecution = resultQueryExecution.elementAt(i);

			boolean should_continue = stepB(phaseNumber, myVariableTables,
					curr_queryexecution.myQueryExecutionTables[0].max_val);
			if (!should_continue) {
				Main._logger.outputLog("Should break!");
				break;
			}

			PlanNode new_plan_node = experimentSubject.getQueryPlan(sql);
			Main._logger.outputLog("get plan for query: " + sql);
			QueryExecutionStat opt_qs = timeQueryExecution(sql, new_plan_node,
					curr_queryexecution.myQueryExecutionTables[0].max_val);
			if (opt_qs != null) {
				curr_queryexecution.exec_time = opt_qs.getQueryTime();
				curr_queryexecution.proc_diff_ = opt_qs.getProcDiff();
			}
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

	/**
	 * Get the number of phases of this scenario.
	 * 
	 * @return The number of phases.
	 */
	protected int getNumOfPhases() {
		return 1;
	}

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_ADJACENT_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_ADJACENT_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
