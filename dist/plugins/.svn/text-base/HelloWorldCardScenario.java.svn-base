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

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.ScenarioBasedOnCardinality;

/**
 * This 'Hello World' scenario based on cardinality executes all queries at the
 * same cardinality at a time. We will use from 20K to 10K cardinalities by a granularity of 5K at
 * which the queries are run. The results are inserted into labshelf.
 * (This is made based on 'Exhaustive' scenario.)
 * 
 * @author yksuh
 * 
 */

public class HelloWorldCardScenario extends
		ScenarioBasedOnCardinality {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public HelloWorldCardScenario(ExperimentRun expRun) {
		super(expRun);
		NUMQUERYEXECS = 3;
		Main._logger.outputLog(":: Hello World Cardinality-Based Scenario :: ");
	}

	/**
	 * Populate the variable tables
	 * 
	 * @param phaseNumber
	 *            phase number
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
			// the
			// actual cardinality
			experimentSubject.populateTable(curr_table.table_name_with_prefix,
					curr_table.columns.length, curr_table.actual_card,
					curr_table.hy_max_card, rr, true);
			// For repeatability, ensure statistics are accurate

			// sanity check for clone max table creation
			if (!experimentSubject.tableExists("clone_max_"
					+ curr_table.table_name_with_prefix)) {
				throw new SanityCheckException(
						"Sanity check violation on table creation of clone_max_"
								+ curr_table.table_name_with_prefix + ".");
			}

			// sanity check for variable table creation
			if (!experimentSubject
					.tableExists(curr_table.table_name_with_prefix)) {
				throw new SanityCheckException(
						"Sanity check violation on table creation of "
								+ curr_table.table_name_with_prefix + ".");
			}
			experimentSubject
					.updateTableStatistics(curr_table);
			recordRunProgress((int) ((double) (i + 1)
					/ (double) variableTables.length * 100),
					"Populating Variable Tables");
		}

	}

	/**
	 * Populates cardinalities for the current variable table.
	 * 
	 * @param curr_table
	 * @return cardinality vector
	 * @throws Exception
	 */
	protected Vector<Long> stepB(Table curr_table) throws Exception {
		long min = curr_table.hy_min_card;
		long max = curr_table.hy_max_card;
		if (Main.verbose) {
			Main._logger.outputLog("Generating cardinalities ranging from '"
					+ max + "' down to '" + min + "'");
		}
		Vector<Long> vecCards = generateCandidateCardinalities(
				experimentRun.getSearchMethod(), min, max,
				experimentRun.getSearchGranularity());
		if (vecCards.size() == 0) {
			throw new Exception("no cardinalities generated");
		}
		return vecCards;
	}

	/**
	 * Cleans up incomplete query executions and returns a cardinality that
	 * should be analyzed (or resumed).
	 * 
	 * @param runID
	 * @return
	 * @throws Exception
	 */
	protected void stepC(int runID) throws Exception {
		Vector<Long> cardVec = new Vector<Long>();
		// get stored execution time & plan id
		String strSQL = "SELECT DISTINCT qr.CARDINALITY "
				+ "FROM AZDBLAB_QUERY q, AZDBLAB_QUERYEXECUTION qr "
				+ "WHERE q.runid = " + runID + " AND q.QUERYID = qr.QUERYID "
				+ "GROUP BY qr.CARDINALITY " + "HAVING COUNT(*) < "
				+ numOfQueries * NUMQUERYEXECS + " "
				+ "ORDER BY qr.CARDINALITY DESC ";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(strSQL);
			while (rs.next()) {
				cardVec.add(new Long(rs.getInt(1)));
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("Fail to locate incomplete cardinality.");
		}

		if (cardVec.size() >= 2) { // very rare...
			// print error message
			String strErrorMsg = "More than two cardinalities were not properly executed before...";
			Main._logger.reportError(strErrorMsg);
			throw new Exception(strErrorMsg);
		} else {
			if (cardVec.size() == 1) {
				long card = (Long) cardVec.get(0);
				// clean up all query executions associated with this
				// cardinality
				// 'iterNum = MAXEXECNUM' means a query is finished with a
				// cardinality
				String strDeleteSQL = "DELETE FROM AZDBLAB_QUERYEXECUTION qr "
						+ "WHERE qr.QueryExecutionID "
						+ "IN (SELECT qr.QueryExecutionID FROM AZDBLAB_QUERY q, AZDBLAB_QUERYEXECUTION qr "
						+ "WHERE q.runid = " + runID
						+ " AND q.QUERYID = qr.QUERYID AND qr.CARDINALITY = "
						+ card + ")";
				try {
					LabShelfManager.getShelf().executeUpdateQuery(strDeleteSQL);
					LabShelfManager.getShelf().commit();
				} catch (SQLException e) {
					e.printStackTrace();
					throw new Exception(
							"Fail to delete incomplete query executions.");
				}
			}
			if (cardVec.size() == 0) {
				Main._logger
						.outputLog("Incomplete query executions at a cardinality or inserted query executions do not exist!");
			}
		}
	}

	/**
	 * Run all queries at a given cardinality
	 * 
	 * @param phaseNumber
	 *            The phase number
	 * @param curr_table
	 *            variable table
	 * @param curr_card
	 *            The cardinality at which queries should run
	 * @param cardIdx
	 *            The index of the current cardinality
	 * @throws Exception
	 */
	protected void analyzeCardinality(int phaseNumber, Table curr_table,
			long curr_card, int cardIdx, int numExecs) throws Exception {
		// first update table cardinality by copying
		updateTableCardinality(curr_table, curr_card);

		// sanity check
		long card = experimentSubject
				.getTableCardinality(curr_table.table_name_with_prefix);
		if (card != curr_card) {
			Main._logger.outputLog("Stored cardinality : " + card
					+ ", requested cardinality: " + curr_card);
			throw new SanityCheckException(
					"Requested and table cardinalities are different.");
		} else {
			// looping through every query
			for (int j = 0; j < vecQueries.size(); j++) {
				Query expRunQuery = vecQueries.get(j);
				for (int t = 1; t <= numExecs; t++) {
					if (Main.verbose) {
						Main._logger.outputLog("Running Query # " + (j + 1)
								+ "-" + t + " iteration(s)");
					}
					// get a plan at the current cardinality
					PlanNode queryPlan = experimentSubject
							.getQueryPlan(expRunQuery.strQuerySQL);
					// execute a query at the max
					QueryExecutionStat qes = timeQueryExecution(
							expRunQuery.strQuerySQL, queryPlan,
							curr_card);
					// build a query execution record
					QueryExecution qe = new QueryExecution(
							myVariableTables.length, 
							queryPlan,
							curr_card,
							curr_card,
							myVariableTables[0].table_name, 
							qes, 
							t,
							phaseNumber);
					// insert the record into labshelf
					recordQueryExecution(qe, expRunQuery, cardIdx, t,
							Constants.SCENARIO_BASED_ON_CARDINALITY);
					/***
					 * Young added this. If timeout happens, we do not make Q@C any more. 
					 * Thus, we just insert that record having the timeout, and skip the rest of Q@Cs (mantis:1188).
					 */
					if(qes.getQueryTime() == Constants.MAX_EXECUTIONTIME){
						break;
					}
				}
			}
		}
	}

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_HELLO_WORLD_CARD_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_HELLO_WORLD_CARD_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}