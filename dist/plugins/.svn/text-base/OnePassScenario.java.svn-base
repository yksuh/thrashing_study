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

import java.sql.SQLException;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TableNode;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.StateData;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.ScenarioBasedOnQuery;

/**
 * We study plan generation/execution varying the cardinality from the
 * maximum(e.g., 2M) to the minimum(e.g., 10K) by using the left/right state
 * tables at a time (one pass). We'll use the left/right state table to detect a
 * change point, alternatively stepping down by granularity (2M => left, 1.99M
 * => right ...), If we get different plans obtained on the left/right state
 * table at their cardinalities, then we make a query execution NUMQUERYEXECS
 * times.
 * 
 * @author yksuh
 * 
 */
public class OnePassScenario extends ScenarioBasedOnQuery {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public OnePassScenario(ExperimentRun expRun) {
		super(expRun);
		NUMQUERYEXECS = 10;
	}

	private final boolean LEFT = true;
	private final boolean RIGHT = false;

	private StateData evenState;
	private StateData oddState;

	private String maxTableName = "";

	/****
	 * Create a state table
	 * 
	 * @param variableTable
	 * @param state
	 */
	private void initStateTable(Table variableTable, Table[] stateTables,
			int i, boolean state) throws Exception {
		String prefix = "";
		if (state == LEFT) {
			prefix = "l";
		} else {
			prefix = "r";
		}

		// state table population
		Table stateTable = new Table(prefix + variableTable.table_name,
				variableTable.table_prefix, variableTable.actual_card,
				variableTable.hy_min_card, variableTable.hy_max_card,
				variableTable.getTableSeed(), variableTable.getColumns());
		stateTables[i] = stateTable;
	}

	/**
	 * <p>
	 * Populate the variable table(s). This scenario creates a template table
	 * which has the same schema as the variable table, and then populates the
	 * template table to the maximum cardinality stated by the experiment
	 * specification. For studying the "optimal" plan at the "actual"
	 * cardinality, it then clones part of the template table as the real
	 * variable table such that the variable table will have the same
	 * cardinality as the "actual" cardinality specified by the experiment
	 * specification.
	 * </p>
	 * <p>
	 * More importantly, the content (data) of the copied variable table should
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
		evenState = new StateData(variableTables);
		oddState = new StateData(variableTables);

		for (int i = 0; i < variableTables.length; i++) {
			initStateTable(variableTables[i], evenState.table, i, LEFT);
			initStateTable(variableTables[i], oddState.table, i, RIGHT);

			recordRunProgress((int) ((double) (i + 1)
					/ (double) variableTables.length * 100),
					"Populating the max table.");

			RepeatableRandom rr = new RepeatableRandom(variableTables[i]
					.getTableSeed());
			rr.setMax(variableTables[i].hy_max_card);

			// populate the max table using the left(or right) state table
			// definition
			experimentSubject.populateTable(
					variableTables[i].table_name_with_prefix,
					variableTables[i].columns.length,
					variableTables[i].actual_card,
					variableTables[i].hy_max_card, rr, true);

			maxTableName = "clone_max_"
					+ variableTables[i].table_name_with_prefix;
			if (!experimentSubject.tableExists(maxTableName)) {
				throw new SanityCheckException(
						"Sanity check violation on table creation of clone_max_"
								+ maxTableName + ".");
			}

			recordRunProgress((int) ((double) (i + 1)
					/ (double) variableTables.length * 100),
					"Done with the max table population.");
		}
	}

	private void dropStateTables(Table stateTable) throws Exception {
		// drop state table
		experimentSubject.dropTable(stateTable.table_name_with_prefix);
		// sanity check for state table drop
		if (experimentSubject.tableExists(stateTable.table_name_with_prefix)) {
			throw new SanityCheckException("table drop of "
					+ stateTable.table_name_with_prefix);
		}
	}

	protected void experimentCleanUp() throws Exception {
		for (int i = 0; i < myVariableTables.length; i++) {
			dropStateTables(evenState.table[i]);
			dropStateTables(oddState.table[i]);
			// drop max table
			experimentSubject.dropTable(maxTableName);
			if (!experimentSubject.tableExists(maxTableName)) {
				throw new SanityCheckException(
						"Sanity check violation on table creation of clone_max_"
								+ myVariableTables[i].table_name_with_prefix
								+ ".");
			}
			experimentSubject.commit();
		}
		if (evenState.pstmt != null) {
			evenState.pstmt.close();
			evenState.pstmt = null;
		}
		if (oddState.pstmt != null) {
			oddState.pstmt.close();
			oddState.pstmt = null;
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
			if (requested_cardinality < curr_table.hy_min_card) {
				return false;
			}
			// update table cardinality by the requested one
			try {
				// update table cardinality to requested_cardinality
				experimentSubject.copyTable(curr_table.table_name_with_prefix,
						maxTableName, requested_cardinality);
				// update table statistics
				experimentSubject
						.updateTableStatistics(curr_table);
				// commit;
				experimentSubject.commit();
			} catch (Exception ex) {
				experimentSubject.close();
				throw new Exception(ex.getMessage());
			}
		}
		return true;
	}

	private void deleteIncompleteQEs(Query expQuery) throws Exception {
		String strDeleteSQL = "DELETE FROM " + Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYEXECUTION + " qe "
				+ "WHERE qe.queryID = " + expQuery.iQueryID;
		try {
			Main._logger
					.outputLog("<<< DELETE all existing query executions by query number "
							+ expQuery.iQueryNumber
							+ " (query ID = "
							+ expQuery.iQueryID + ") >>>> ");
			Main._logger.outputLog("delete sql: " + strDeleteSQL);
			LabShelfManager.getShelf().executeUpdateQuery(strDeleteSQL);
			LabShelfManager.getShelf().commit();
			Main._logger.outputLog("<<< done >>>> ");
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("Fail to delete incomplete query executions.");
		}
	}
	
	
	
	/**
	 * Replace the even/odd state table name by the original variable table name.
	 * 
	 * @param node the root node
	 * @return the sequence of traversed <code>PlanNode</code> according to
	 *         pre-order.
	 */
	private void restoreVarTableName(PlanNode node, String search, String replacement) {
		if (node instanceof TableNode) {
			String tableName = ((TableNode) node).getTableName();
			Pattern p = Pattern.compile(search, Pattern.CASE_INSENSITIVE);
			Matcher m = p.matcher(tableName);
			tableName = m.replaceAll(replacement);
	        ((TableNode) node).setTableName(tableName);
		} else {
			int numchild = ((OperatorNode) node).getChildNumber();
			for (int i = 0; i < numchild; i++) {
				restoreVarTableName(((OperatorNode) node).getChild(i), search, replacement);
			}
		}
	}
	
	/**
	 * Studies a query
	 */
	protected void analyzeQuery(int phaseNumber, Query expQuery, String method,
			long granularity) throws Exception {
		// Since change points are not repeatable within inter-runs on some
		// DBMSes,
		// we should delete all incomplete query executions associated the give
		// query if a run is unpaused.
		deleteIncompleteQEs(expQuery);
		int exec_num = 0;
		for (int i = 0; i < myVariableTables.length; i++) {
			// set an equivalent query for left and right states using the
			// passed query
			evenState.setQuery(myVariableTables, expQuery.strQuerySQL);
			oddState.setQuery(myVariableTables, expQuery.strQuerySQL);
			long min = myVariableTables[0].hy_min_card;
			long max = myVariableTables[0].hy_max_card;
			if (Main.verbose) {
				Main._logger
						.outputLog("Starting Change Point Discovery at Cardinality = "
								+ ""
								+ max
								+ " (min: "
								+ min
								+ ") "
								+ " using left/right state tables("
								+ evenState.table[0].table_name_with_prefix
								+ "/"
								+ oddState.table[0].table_name_with_prefix
								+ ")");
			}
			boolean should_continue = false;
			Vector<Long> vecCardinalities = generateCandidateCardinalities(
					method, min, max, granularity);
			for (int j = 0; j < vecCardinalities.size(); j++) {
				if (j % 2 == 0) { // left state
					evenState.card = vecCardinalities.get(j);
					should_continue = stepB(phaseNumber, evenState.table,
							evenState.card);
					if (!should_continue) {
						break;
					}
					// obtain a left plan and make its PreparedStatement ready
					evenState = experimentSubject.getPreparedState(evenState);
				} else { // right state
					oddState.card = vecCardinalities.get(j);
					should_continue = stepB(phaseNumber, oddState.table,
							oddState.card);
					if (!should_continue) {
						break;
					}
					// obtain a right plan and make its PreparedStatement ready
					oddState = experimentSubject.getPreparedState(oddState);
				}
				if (Main.verbose) {
					// just print out . to represent varying cardinalities
					Main._logger.outputLogWithoutNewLine(".", Long
							.toString(vecCardinalities.get(j)));
				}
				// In the beginning, leftState at 2M is not null, but
				// rightState.plan at 1.99M could be null.
				if (oddState.plan != null
//						&& !evenState.plan.equals(oddState.plan)) {
						&& !ArePlansSame(evenState.plan, 
										 oddState.plan, 
										 (evenState.table[0].table_name_with_prefix).toUpperCase(), 
										 (oddState.table[0].table_name_with_prefix).toUpperCase(), 
										 (myVariableTables[0].table_name_with_prefix).toUpperCase())) {
					// we've gotten a change point.
					// prioritize a query execution at a higher cardinality than
					// that at a lower one
					if (evenState.card > oddState.card) {
						// make a query execution
						// if it is made, then increment exec_num.
						if (makeQueryExecution(phaseNumber, exec_num, expQuery,
								evenState)) {
							exec_num++;
						}
						// make a query execution
						if (makeQueryExecution(phaseNumber, exec_num, expQuery,
								oddState)) {
							exec_num++;
						}
					} else {
						// make a query execution
						if (makeQueryExecution(phaseNumber, exec_num, expQuery,
								oddState)) {
							exec_num++;
						}
						// make a query execution
						if (makeQueryExecution(phaseNumber, exec_num, expQuery,
								evenState)) {
							exec_num++;
						}
					}
				} else if (evenState.card == max) {
					// in order for a query to have at least one execution,
					// make a query execution at the maximum cardinality
					// if it is made, then increment exec_num.
					if (makeQueryExecution(phaseNumber, exec_num, expQuery,
							evenState)) {
						exec_num++;
					}
				}
			} // end for cardinality
			if (Main.verbose) {
				Main._logger.outputLog("");
			}
		} // end for variable table
	}

	/****
	 * Check if plans are same 
	 * @param oddPlan  : query plan at odd state
	 * @param evenPlan : query plan at even state
	 * @return true or false
	 */
	private boolean ArePlansSame(PlanNode evenPlan,
			 					 PlanNode oddPlan, 
								 String evenStateTableName,
								 String oddStateTableName,
								 String orgTableName) {
		restoreVarTableName(evenPlan, evenStateTableName, orgTableName);
		restoreVarTableName(oddPlan, oddStateTableName, orgTableName);
		boolean res = evenPlan.equals(oddPlan);
		restoreVarTableName(evenPlan, orgTableName, evenStateTableName);
		restoreVarTableName(oddPlan,  orgTableName, oddStateTableName);
		return res;
	}

	/**
	 * 
	 * @param phaseNumber
	 *            : phaseNumber. Currently 1
	 * @param execNumber
	 *            : execution number
	 * @param expQuery
	 *            : a query in examination
	 * @param StateData
	 *            : left or right state
	 * @throws Exception
	 *             If something fails.
	 */

	private boolean makeQueryExecution(int phaseNumber, // phase number
			int execNumber, // execution number (change point)
			Query expQuery, // query
			StateData state) // left or right
			throws Exception {
		if (state.card == state.alreadyRunCard) {
			return false;
		}

		if (Main.verbose) {
			Main._logger.outputLog("\nMake a query execution at " + state.card
					+ " on " + state.table[0].table_name_with_prefix);
		}

		// just in case where the previous query execution ends up with reset by timeout
//		if(state.pstmt == null || state.pstmt.isClosed()){
		if(state.pstmt == null){
			state = experimentSubject.getPreparedState(state);
		}
		
		// run MAXEXECS times
		for (int k = 1; k <= NUMQUERYEXECS; k++) {// then we should make a query
			// execution with the current
			// variable plan
			Main._logger
					.outputLog("\n###########################################");
			Main._logger.outputLog("####### query execution " + k
					+ "##########");
			Main._logger
					.outputLog("###########################################");
			QueryExecution curr_query_execution = new QueryExecution(
					state.table.length);
						
			// Time a query at the actual cardinality
			QueryExecutionStat curr_qe_stat = timePreparedQueryExecution(
					state.query, state.pstmt, state.plan, state.card);
			// fills fields with corresponding values
			curr_query_execution.plan = state.plan;
			
			/****
			 * Restore the original name for storing the plan
			 * Only applied to onepass scenario 
			 */
			restoreVarTableName(curr_query_execution.plan, 
								(state.table[0].table_name_with_prefix).toUpperCase(), 
								(myVariableTables[0].table_name_with_prefix).toUpperCase());
			
			curr_query_execution.myQueryExecutionTables[0].max_val = state.card;
			curr_query_execution.myQueryExecutionTables[0].min_val = state.card;
			curr_query_execution.myQueryExecutionTables[0].table_name = state.table[0].table_name;
			if (curr_qe_stat != null) {
				curr_query_execution.exec_time = curr_qe_stat.getQueryTime();
				curr_query_execution.proc_diff_ = curr_qe_stat.getProcDiff();
			}
			curr_query_execution.phaseNumber = phaseNumber;
			recordQueryExecution(curr_query_execution, expQuery, execNumber, k,
					Constants.SCENARIO_BASED_ON_QUERY);
			
			/****
			 * Restore state table name for the execution
			 * Only applied to onepass scenario 
			 */
			restoreVarTableName(curr_query_execution.plan, 
								(myVariableTables[0].table_name_with_prefix).toUpperCase(), 
								(state.table[0].table_name_with_prefix).toUpperCase());
			
			/***
			 * Young added this. If timeout happens, we do not make Q@C any more. 
			 * Thus, we just insert that record having the timeout, and skip the rest of Q@Cs (mantis:1188).
			 */
			if(curr_qe_stat.getQueryTime() == Constants.MAX_EXECUTIONTIME){
				break;
			}
		}
		state.alreadyRunCard = state.card;
		if (state.pstmt != null) {
			state.pstmt.close();
			state.pstmt = null;
		}
		return true;
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
		scenarioName = Constants.NAME_ONE_PASS_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_ONE_PASS_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
