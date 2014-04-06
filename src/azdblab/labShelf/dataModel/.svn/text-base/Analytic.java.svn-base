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
package azdblab.labShelf.dataModel;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;

public class Analytic extends TableDefinition {

	private String userName;
	private String notebookName;
	private String analyticName;
	private String analyticStyle;
	private String analyticDescription;
	private String analyticSQL;

	/**
	 * @param userName
	 * @param notebookName
	 * @param analyticName
	 * @param analyticStyle
	 * @param analyticDescription
	 * @param analyticSQL
	 */
	public Analytic(String userName, String notebookName, String analyticName,
			String analyticStyle, String analyticDescription, String analyticSQL) {
		super();
		this.userName = userName;
		this.notebookName = notebookName;
		this.analyticName = analyticName;
		this.analyticStyle = analyticStyle;
		this.analyticDescription = analyticDescription;
		this.analyticSQL = analyticSQL;
	}

	/**
	 * 
	 * @param testID
	 * @param analyticID
	 * @return
	 */
	public boolean analyticValueExists(int runID, int analyticID) {

		String[] selectColumns = new String[] { "AnalyticValue" };

		String[] columnNames = new String[] { "RunID", "AnalyticID" };

		String[] columnValues = new String[] { String.valueOf(runID),
				String.valueOf(analyticID) };

		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER };

		try {
			// inserts a change point into the the internal tables.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					ANALYTICVALUEOF.TableName, selectColumns, columnNames,
					columnValues, dataTypes);

			if (rs == null || !rs.next()) {
				return false;
			}
			return true;
		} catch (SQLException sqlex) {
			return false;
		}
	}
	
	public static List<String> getValue(String userName,
			String notebookName, String experimentName, String startTime) {
		Analytic a = new Analytic(null, null, null, null, null, null);
		return a.getAnalyticValue(userName, notebookName, experimentName, startTime);
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param createTime
	 * @param testNumber
	 * @return
	 */
	public List<String> getAnalyticValue(String userName,
			String notebookName, String experimentName, String startTime) {

		Vector<String> result = new Vector<String>();

		if (experimentName != null && experimentName.length() > 0) {

			int expID = User.getUser(userName).getNotebook(notebookName)
					.getExperiment(experimentName).getExperimentID();

			if (expID == -1) {
				Main._logger.reportError("getAnalyticValue Err.");
				return null;
			}

			String sql = "SELECT da.AnalyticName, SUM(av.AnalyticValue) " + " "
					+ "FROM " + DEFINEDANALYTIC.TableName + " da, "
					+ ANALYTICVALUEOF.TableName + " av "
					+ "WHERE da.AnalyticID = av.AnalyticID AND av.RunID IN ("
					+ "SELECT er.RunID " + "FROM " + EXPERIMENTRUN.TableName
					+ " er " + "WHERE er.ExperimentID = " + expID + ") "
					+ "GROUP BY da.AnalyticName";

			try {
				// Queries the DBMS for the test results of an experiment.
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(
						sql);

				if (rs == null) {
					return null;
				}

				String source = " Defined by user " + userName;
				if ((notebookName != null) && (!notebookName.equals(""))) {
					source += " with notebook " + notebookName;
				}

				while (rs.next()) {

					String anlName = rs.getString(1);
					String anlValue = rs.getString(2);

					result
							.add(anlName + "##" + anlValue + "##" + source
									+ "\n");

				}

				return result;

			} catch (SQLException sqlex) {
				// sqlex.printStackTrace();
				return null;
			}

		} else if (notebookName != null && notebookName.length() > 0) {

			String sql = "SELECT da.AnalyticName, SUM(av.AnalyticValue) " + " "
					+ "FROM " + DEFINEDANALYTIC.TableName + " da, "
					+ ANALYTICVALUEOF.TableName + " av "
					+ "WHERE da.AnalyticID = av.AnalyticID AND av.RunID IN ("
					+ "SELECT er.RunID " + "FROM " + EXPERIMENTRUN.TableName
					+ " er, " + EXPERIMENT.TableName + " ex "
					+ "WHERE er.ExperimentID = ex.ExperimentID AND "
					+ "ex.NotebookName = '" + notebookName + "') "
					+ "GROUP BY da.AnalyticName";

			try {
				// Queries the DBMS for the test results of an experiment.
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(
						sql);

				if (rs == null) {
					return null;
				}

				String source = " Defined by user " + userName;
				if ((notebookName != null) && (!notebookName.equals(""))) {
					source += " with notebook " + notebookName;
				}

				while (rs.next()) {

					String anlName = rs.getString(1);
					String anlValue = rs.getString(2);

					result
							.add(anlName + "##" + anlValue + "##" + source
									+ "\n");

				}

				return result;

			} catch (SQLException sqlex) {
				// sqlex.printStackTrace();
				return null;
			}

		} else if (userName != null && userName.length() > 0) {

			String sql = "SELECT da.AnalyticName, SUM(av.AnalyticValue) " + " "
					+ "FROM " + DEFINEDANALYTIC.TableName + " da, "
					+ ANALYTICVALUEOF.TableName + " av "
					+ "WHERE da.AnalyticID = av.AnalyticID AND av.RunID IN ("
					+ "SELECT er.RunID " + "FROM " + EXPERIMENTRUN.TableName
					+ " er, " + EXPERIMENT.TableName + " ex "
					+ "WHERE er.ExperimentID = ex.ExperimentID AND "
					+ "ex.UserName = '" + userName + "') "
					+ "GROUP BY da.AnalyticName";

			try {
				// Queries the DBMS for the test results of an experiment.
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(
						sql);

				if (rs == null) {
					return null;
				}

				String source = " Defined by user " + userName;
				if ((notebookName != null) && (!notebookName.equals(""))) {
					source += " with notebook " + notebookName;
				}

				while (rs.next()) {

					String anlName = rs.getString(1);
					String anlValue = rs.getString(2);

					result
							.add(anlName + "##" + anlValue + "##" + source
									+ "\n");

				}

				return result;

			} catch (SQLException sqlex) {
				// sqlex.printStackTrace();
				return null;
			}

		}

		return null;
	}

	/**
	 * 
	 * @param userName
	 * @param testID
	 * @param analyticName
	 * @param analyticValue
	 */
	public void insertAnalyticValueOf(String userName, int runID,
			String analyticName, String analyticValue) {
		
		int analyticID = User.getUser(userName).getAnalyticID(analyticName);

		if (analyticID == -1) {
			Main._logger.reportError("insert Analytic Value Err.");
			return;
		}

		if (analyticValueExists(runID, analyticID)) {

			Main._logger.outputLog("analytic value already exists.");
			return;

		}

		String[] columnNames = new String[] { "RunID", "AnalyticID",
				"AnalyticValue" };

		String[] columnValues = new String[] { String.valueOf(runID),
				String.valueOf(analyticID), analyticValue };

		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {
			// inserts a change point into the the internal tables.
			LabShelfManager.getShelf().insertTupleToNotebook(
					ANALYTICVALUEOF.TableName, columnNames, columnValues,
					dataTypes);
			LabShelfManager.getShelf().commitlabshelf();

		} catch (SQLException e) {
			Main._logger.reportError("Failed to insert analytic values");
			e.printStackTrace();
			System.exit(1); // programmer/dbsm error
		}

	}

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @return the notebookName
	 */
	public String getNotebookName() {
		return notebookName;
	}

	/**
	 * @return the analyticName
	 */
	public String getAnalyticName() {
		return analyticName;
	}

	/**
	 * @return the analyticStyle
	 */
	public String getAnalyticStyle() {
		return analyticStyle;
	}

	/**
	 * @return the analyticDescription
	 */
	public String getAnalyticDescription() {
		return analyticDescription;
	}

	/**
	 * @return the analyticSQL
	 */
	public String getAnalyticSQL() {
		return analyticSQL;
	}
}
