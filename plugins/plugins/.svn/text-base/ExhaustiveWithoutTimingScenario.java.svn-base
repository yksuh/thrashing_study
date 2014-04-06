package plugins;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.ScenarioBasedOnCardinalityWithoutTiming;

public class ExhaustiveWithoutTimingScenario extends ScenarioBasedOnCardinalityWithoutTiming{
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public ExhaustiveWithoutTimingScenario(ExperimentRun expRun) {
		super(expRun);
		// set version name for this plugin
		NUMQUERYEXECS = 1;
	}

	/**
	 * <p>
	 * Populate the variable tables. This scenario creates a template table
	 * which has the same schema as the variable table, and then populates the
	 * template table to the maximum cardinality stated by the experiment
	 * specification. For studying each plan at a cardinality, it then clones
	 * part of the template table as the real variable table such that the
	 * variable table will have the same cardinality as the "actual" cardinality
	 * specified by the experiment specification.
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
	 */
	protected Vector<Long> stepB(Table curr_table) throws Exception {
		long min = curr_table.hy_min_card;
		long max = curr_table.hy_max_card;
		if (Main.verbose) {
			Main._logger.outputLog("Generating cardinalities ranging from '"
					+ max + "' down to '" + min + "'");
		}
		Vector<Long> vecCards = generateCandidateCardinalities(experimentRun
				.getSearchMethod(), min, max, experimentRun
				.getSearchGranularity());
		if (vecCards.size() == 0) {
			throw new Exception("no cardinalities generated");
		}
		return vecCards;
	}

	/**
	 * Cleans up incomplete query executions and returns a cardinality that
	 * should be analyzed (or resumed).
	 * 
	 * @param variableTable
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
			Main._logger.outputLog("sql: " + strSQL);
			// SELECT DISTINCT qr.CARDINALITY FROM AZDBLAB_QUERY q,
			// AZDBLAB_QUERYEXECUTION qr WHERE q.runid = 21 AND q.queryid =
			// qr.queryid GROUP BY qr.CARDINALITY HAVING count(*) < 100 ORDER BY
			// qr.CARDINALITY DESC;
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
				Main._logger.outputLog("<<< DELETE all query executions at "
						+ card + " >>>> ");
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
					Main._logger.outputLog("delete sql: " + strDeleteSQL);
					LabShelfManager.getShelf().executeUpdateQuery(strDeleteSQL);
					LabShelfManager.getShelf().commit();
				} catch (SQLException e) {
					e.printStackTrace();
					throw new Exception(
							"Fail to delete incomplete query executions.");
				}
				Main._logger
						.outputLog("<<< done with deleting all query executions at "
								+ card + " >>>> ");
			}
			if (cardVec.size() == 0) {
				Main._logger
						.outputLog("Incomplete query executions at a cardinality or inserted query executions do not exist!");
			}
		}
	}

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_EXHAUSTIVE_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_EXHAUSTIVE_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
