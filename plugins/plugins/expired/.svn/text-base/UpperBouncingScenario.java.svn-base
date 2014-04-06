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

import java.io.IOException;

import azdblab.Constants;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

public class UpperBouncingScenario extends VaryCardinalityScenario {
	public UpperBouncingScenario(ExperimentRun expRun) {
		super(expRun);
	}

	protected void stepA(int phaseNumber, Table[] variableTables)
			throws Exception {
		for (int i = 0; i < variableTables.length; i++) {
			Table curr_table = variableTables[i];
			RepeatableRandom rr = new RepeatableRandom(curr_table
					.getTableSeed());
			// Last parameter (true) ensures that a template at the maximum
			// cardinality will be created first, and then partially cloned at
			// the
			// actual cardinality
			experimentSubject.populateTable(curr_table.table_name_with_prefix,
					curr_table.columns.length, curr_table.actual_card,
					curr_table.hy_max_card, rr, false);
			// For repeatability, ensure statistics are accurate
			experimentSubject.updateTableStatistics(curr_table);
			recordRunProgress((int) ((double) (i + 1)
					/ (double) variableTables.length * 100),
					"Populating Variable Tables");
		}
	}

	/**
	 * Timing query plan execution by calling <code>timeQueryExecution</code>
	 * provided by the superclass.
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
	protected QueryExecutionStat stepB(int phaseNumber, String sql,
			PlanNode plan, long cardinality) throws Exception {
		experimentSubject.close();
		try {
			Runtime.getRuntime().exec("/var/lib/pgsql/pgsqlbouncing").waitFor();
		} catch (IOException ioex) {
			ioex.printStackTrace();
		}
		// experimentSubject.open();
		QueryExecutionStat result_queryexecutionstat = timeQueryExecution(sql,
				plan, cardinality);
		planToExecutionTimeMap.put(plan.myHashCode(), result_queryexecutionstat
				.getQueryTime());
		return result_queryexecutionstat;
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
	protected boolean stepC(int phaseNumber, Table[] variableTables,
			long requested_cardinality) throws Exception {
		for (int i = 0; i < variableTables.length; i++) {
			Table curr_table = variableTables[i];
			experimentSubject.updateTableStatistics(curr_table);
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

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_UPPER_BOUNCING_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_UPPER_BOUNCING_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
