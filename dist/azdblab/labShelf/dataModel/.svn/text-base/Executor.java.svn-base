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
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;

public class Executor extends TableDefinition {

	public class ExecutorState {
		public String strCurrentStatus;
		public String strCommand;

		public ExecutorState(String status, String command) {
			strCurrentStatus = status;
			strCommand = command;
		}

	}

	private String machineName;
	private String DBMS;
	private ExecutorState state;

	public static final int TYPE_RUNNING = 1;
	public static final int TYPE_PAUSED = 3;
	
	/**
	 * @param machineName
	 * @param dBMS
	 * @param status
	 * @param command
	 */
	public Executor(String machineName, String dBMS, String status,
			String command) {
		this.machineName = machineName;
		DBMS = dBMS;
		state = new ExecutorState(status, command);
	}

	/**
	 * 
	 * @param machineName
	 * @return
	 */
	public List<String> getExecutorHistory() {

		try {
			
			Vector<String> vecLog = new Vector<String>();
			String logSQL = "SELECT TransactionTime, CurrentStatus, Command FROM "
				+ EXECUTORLOG.TableName
				+ " WHERE MachineName = '"
				+ machineName + "' ORDER BY SUBSTR(TransactionTime,4,100) DESC";

			ResultSet rsLog = LabShelfManager.getShelf().executeQuerySQL(logSQL);

			while (rsLog.next()) {
				vecLog.add(new SimpleDateFormat(Constants.TIMEFORMAT).format(rsLog.getTimestamp(1)) + "##" + rsLog.getString(2)
						+ "##" + rsLog.getString(3));
			}

			return vecLog;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param machineName
	 * @param DBMS
	 * @return
	 */
	public ExecutorState getExecutorState(String machineName, String DBMS) {
		try {
			String state_sql = 
				"SELECT CurrentStatus, Command " +
				"FROM " + TableDefinition.EXECUTOR.TableName + " " +
				"WHERE MachineName='" + machineName +
				"' AND CurrentDBMSName='" + DBMS + "'";
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(state_sql);

			String status = "";
			String command = "";

			if (rs.next()) {
				status = rs.getString(1);
				command = rs.getString(2);
			}

			rs.close();

			return new ExecutorState(status, command);

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param machineName
	 * @param transactionTime
	 * @param currentStatus
	 * @param command
	 */
	public void insertExecutorLog(String machineName, String transactionTime,
			String currentStatus, String command) {

		String[] columnsLog = new String[] { "MachineName", "DBMSName", "TransactionTime",
				"CurrentStatus", "Command" };
		String[] columnValuesLog = new String[] { machineName, DBMS, transactionTime,
				currentStatus, command };
		int[] dataTypesLog = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {
			LabShelfManager.getShelf().insertTupleToNotebook(
					EXECUTORLOG.TableName, columnsLog, columnValuesLog,
					dataTypesLog);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException sqlex) {
			Main._logger.reportError("\t ********** " + machineName + ", "
					+ transactionTime + ", " + currentStatus + ", " + command
					+ " *******");
			sqlex.printStackTrace();
		}

	}

	/**
	 * 
	 * @param machineName
	 * @param DBMS
	 * @param transactionTime
	 * @param currentStatus
	 * @param command
	 */
	public void updateExecutor(String DBMS, String transactionTime,
			String currentStatus, String command) {

		String updateExecutorSQL = "UPDATE " + EXECUTOR.TableName + " SET ";

		if (currentStatus != null) {
			updateExecutorSQL += " CurrentStatus = '" + currentStatus + "',";
		}

		if (command != null) {
			updateExecutorSQL += " Command = '" + command + "'";
		}

		updateExecutorSQL += " WHERE MachineName = '" + machineName
				+ "' AND CurrentDBMSName = '" + DBMS + "'";

		LabShelfManager.getShelf().executeUpdateSQL(updateExecutorSQL);
//		LabShelfManager.getShelf().commitlabshelf();

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param machineName
	 */
	public void updateExperimentRunMachineName(String userName,
			String notebookName, String experimentName, String startTime) {

		int runID = User.getUser(userName)
				.getNotebook(notebookName).getExperiment(experimentName)
				.getExperimentRunID(startTime);

		if (runID == -1) {
			Main._logger.reportError("Update Experiment Run MachineName Err.");
			return;
		}

		// Update the experimentRun item up to date.
		String updateSQL = "UPDATE " + EXPERIMENTRUN.TableName + " "
				+ " SET MachineName = '" + machineName + "'"
				+ " WHERE RunID = " + runID;

		LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
//		LabShelfManager.getShelf().commitlabshelf();

	}

	

	/**
	 * @return the machineName
	 */
	public String getMachineName() {
		return machineName;
	}

	/**
	 * @return the dBMS
	 */
	public String getDBMS() {
		return DBMS;
	}

	/**
	 * @return the state
	 */
	public ExecutorState getState() {
		return state;
	}
	
	public static Executor getExecutor(String machineName, String dbms) {
		for (Executor e : getAllExecutors()) {
			if (e.getMachineName().equals(machineName) && e.getDBMS().equals(dbms)) {
				return e;
			}
		}

		return null;
	}
	
	public static Vector<Executor> getAllExecutors() {

		Vector<Executor> result = new Vector<Executor>();

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR,
					new String[] { "MachineName", "CurrentDBMSName", "CurrentStatus",
							"Command" }, null, null, null);

			while (rs.next()) {

				Executor newexenode = new Executor(rs.getString(1), rs
						.getString(2), rs.getString(3), rs.getString(4));
				result.add(newexenode);

			}

			rs.close();

			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}
}
