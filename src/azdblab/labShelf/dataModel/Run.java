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

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.util.Map.Entry;
import java.util.regex.Pattern;

import org.w3c.dom.Element;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;
import azdblab.model.queryAnalyzer.QueryAnalyzer;
import azdblab.swingUI.objectNodes.PausedRunNode;
import azdblab.swingUI.objectNodes.RunningRunNode;

public class Run extends TableDefinition {

	public class RunStatus {
		public String current_stage_;
		public double percentage_;

		public RunStatus(String stage, double percentage) {
			current_stage_ = stage;
			percentage_ = percentage;
		}
	};

	public class ExperimentRunResult {
		/**
		 * A TestResult Object is used to hold the results of an experiment. It
		 * stores both the test number and the result XML for the test with
		 * t_num.
		 * 
		 * @param result
		 *            An input stream that can be used to read the result XML
		 *            for this test.
		 * @param testNumber
		 *            The test number of this test.
		 */
		public ExperimentRunResult(InputStream result) {
			finResultXML = result;
		}

		public ExperimentRunResult(Element result) {
			resultContent = result;
		}

		/**
		 * The file input stream that can be used to read the result of this
		 * test.
		 */
		public InputStream finResultXML;

		public Element resultContent;

	}

	protected String userName;

	protected String notebookName;

	protected String experimentName;

	protected String scenario;

	protected String machineName;

	protected String DBMS;

	protected String startTime;

	protected int run_id_;

	protected int iType;


	public static final int TYPE_COMPLETED = 0;
	public static final int TYPE_RUNNING = 1;
	public static final int TYPE_PENDING = 2;
	public static final int TYPE_PAUSED = 3;
	public static final int TYPE_ABORTED = 4;
	public static final int TYPE_RESUMED = 5;

	// public static int num_queries = -1;

	public Run(String userName, String notebookName, String experimentName,
			String scenario, String machineName, String dbms, String startTime,
			int type, int run_id) {

		this.userName = userName;
		this.notebookName = notebookName;
		this.experimentName = experimentName;
		this.scenario = scenario;
		this.machineName = machineName;
		this.DBMS = dbms;

		this.startTime = startTime;
		this.iType = type;
		run_id_ = run_id;
		// exp_queries_ = new Vector<Query>(getExperimentRunQueries());

	}

	public LabShelfManager getLabShelf() {
		return LabShelfManager.getShelf();
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 */
	public void deleteExperimentRunQueries() {

		int run_id_ = User.getUser(userName).getNotebook(notebookName)
				.getExperiment(experimentName).getExperimentRunID(startTime);

		if (run_id_ == -1) {
			Main._logger.reportError("Delete ExperimentRun Queries Err");
			return;
		}

		String[] columnNames = new String[] { "RunID" };
		String[] columnValues = new String[] { String.valueOf(run_id_) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		LabShelfManager.getShelf().deleteRows(QUERY.TableName, columnNames,
				columnValues, dataTypes);
		LabShelfManager.getShelf().commitlabshelf();

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 */
	public void deleteQuery(int queryNumber) {

		// int queryID = LabShelf.getShelf().getUser(userName)
		// .getNotebook(notebookName).getExperiment(experimentName)
		// .getRun(startTime).getQuery(queryNumber).getiQueryID();
		int queryID = getQueryID(userName, notebookName, experimentName,
				startTime, queryNumber);

		if (queryID == -1) {
			Main._logger.reportError("delete Query Result Err.");
			return;
		}

		String query_id = String.valueOf(queryID);

		String[] columnNames = new String[] { "QueryID" };
		String[] columnValues = new String[] { query_id };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		LabShelfManager.getShelf().deleteRows(QUERY.TableName, columnNames,
				columnValues, dataTypes);
		LabShelfManager.getShelf().commitlabshelf();

	}

	public Query getQuery(int queryNumber) {
		List<Query> exp_queries = null;
		int num_queries = -1;
		while (exp_queries == null) {
			exp_queries = getExperimentRunQueries();
			if (num_queries == exp_queries.size()) {
				break;
			} else {
				num_queries = exp_queries.size();
				if (num_queries == 0) {
					num_queries = -1;
				}
				exp_queries = null;

			}
		}

		for (Query q : exp_queries) {
			if (q.getiQueryNumber() == queryNumber) {
				return q;
			}
		}
		Main._logger.reportError("$$$ DEBUG: num of queries in run: "
				+ exp_queries.size());
		return null;
	}

	private int getQueryID(String userName, String notebookName,
			String experimentName, String startTime, int queryNumber) {
		try {
			String sqlID = "SELECT QueryID " + "FROM " + QUERY.TableName + " "
					+ "WHERE RunID = " + run_id_ + " AND QueryNumber = "
					+ queryNumber + "";
			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);
			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			return -1;
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 */
	public azdblab.labShelf.dataModel.Executor.ExecutorState getExecutorState() {

		try {

			String machineNameSQL = "SELECT MachineName, DBMSName FROM "
					+ EXPERIMENTRUN.TableName + " WHERE RunID = " + run_id_;

			ResultSet rsMachineName = LabShelfManager.getShelf()
					.executeQuerySQL(machineNameSQL);

			String machineName = "";
			String dbms = "";

			while (rsMachineName.next()) {
				machineName = rsMachineName.getString(1);
				dbms = rsMachineName.getString(2);
			}

			// rsMachineName.close();

			return azdblab.labShelf.dataModel.Executor.getExecutor(machineName, dbms)
					.getState();
			// return getExecutorState(machineName, dbms);
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 */
	/*
	 * public int getExperimentRunID(String userName, String notebookName,
	 * String experimentName, String startTime) {
	 * 
	 * try {
	 * 
	 * int expID = shelf.getUser(userName).getNotebook(notebookName)
	 * .getExperiment(experimentName).getExperimentID();
	 * 
	 * String sqlID = "SELECT RunID " + "FROM " + EXPERIMENTRUN.TableName + " "
	 * + "WHERE ExperimentID = " + expID + " AND StartTime = '" + startTime +
	 * "'";
	 * 
	 * ResultSet rsID = LabShelf.getShelf().executeQuerySQL( sqlID);
	 * 
	 * if (rsID != null && rsID.next()) { int id = rsID.getInt(1); rsID.close();
	 * return id; } return -1;
	 * 
	 * } catch (SQLException sqlex) { sqlex.printStackTrace(); return -1; }
	 * 
	 * }
	 */

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 */
	public int getExperimentRunID() {

		try {

			int expID = User.getUser(userName).getNotebook(notebookName)
					.getExperiment(experimentName).getExperimentID();

			String sqlID = "SELECT RunID " + "FROM " + EXPERIMENTRUN.TableName
					+ " " + "WHERE ExperimentID = " + expID
//					+ " AND StartTime = '" + startTime + "';
					+ " AND StartTime = " + "to_timestamp('" + startTime + "', '" + Constants.TIMESTAMPFORMAT + "')";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			return -1;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @return
	 * @throws SQLException
	 */
	public List<Query> getExperimentRunQueries() {

		Vector<Query> result = new Vector<Query>();
		String[] selectColumns = new String[] { "QueryID", "QueryNumber",
				"QuerySQL" };
		String[] columnNames = new String[] { "RunID" };
		String[] columnValues = new String[] { String.valueOf(run_id_) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		boolean successful = false;

		while (!successful) {
			// Queries the DBMS for the queries of each test.
			result.clear();
			try {
				ResultSet rs = LabShelfManager.getShelf()
						.executeSimpleOrderedQuery(QUERY.TableName,
								selectColumns, 0,
								GeneralDBMS.I_DATA_TYPE_NUMBER, columnNames,
								columnValues, dataTypes);

				// Places the queries in a Vector
				while (rs.next()) {
					// result.add(new Query(userName, notebookName,
					// experimentName,
					// scenario, machineName, DBMS, startTime, rs.getInt(1), rs
					// .getInt(2), rs.getString(3), this));
					result.add(new Query(userName, notebookName, rs.getInt(1),
							rs.getInt(2), rs.getString(3)));
				}
				successful = true;
				rs.close();
			} catch (SQLException sqlex) {
				sqlex.printStackTrace();
				successful = false;
			}
		}
		return result;
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 * @throws SQLException
	 */
	public ExperimentRunResult getExperimentRunResult() throws SQLException {

		String[] columnNames = new String[] { "RunID" };
		String[] columnValues = new String[] { String.valueOf(run_id_) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		String columnName = "ResultXML";
		columnNames = new String[] { "RunID" };
		dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		return (new ExperimentRunResult(LabShelfManager.getShelf().getDocument(
				EXPERIMENTRUN.TableName, columnName, columnNames, columnValues,
				dataTypes)));

	}

	public List<Integer> getQueryNumsWithAspect(String aspectName) {

		Vector<Integer> result = new Vector<Integer>();

		int aspectID = User.getUser(userName).getAspectID(aspectName);

		if (aspectID == -1) {
			Main._logger.reportError("get Query Num with Aspect Err");
			return null;
		}

		String sqlQuery = "SELECT qr.QueryNumber " + "FROM " + QUERY.TableName
				+ " qr, " + SATISFIESASPECT.TableName + " da "
				+ "WHERE qr.RunID = " + run_id_
				+ " AND qr.QueryID = da.QueryID AND da.AspectID = " + aspectID;

		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sqlQuery);

			while (rs.next()) {
				result.add(rs.getInt(1));
			}

			rs.close();

			return result;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return null;
		}

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 */
	public List<String> getRunHistory(String userName, String notebookName,
			String experimentName, String startTime) {

		try {

			Vector<String> vecLog = new Vector<String>();
			String logSQL = "SELECT TransactionTime, CurrentStage, Percentage FROM "
					+ RUNLOG.TableName + " WHERE RunID = " + run_id_;

			ResultSet rsLog = LabShelfManager.getShelf()
					.executeQuerySQL(logSQL);

			while (rsLog.next()) {
				vecLog.add(new SimpleDateFormat(Constants.TIMEFORMAT).format(rsLog.getTimestamp(1)) + "##" + rsLog.getString(2)
						+ "##" + rsLog.getString(3));
			}
			// rsLog.close();
			return vecLog;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 */
	public RunStatus getRunProgress() {
		try {
			String prog_sql = "SELECT CurrentStage, Percentage "
					+ "FROM AZDBLAB_EXPERIMENTRUN " + "WHERE RunID = "
//					+ run_id_ + " AND " + "StartTime = '" + startTime + "'";
					+ run_id_ + " AND " + "StartTime = " + "to_timestamp('" + startTime + "', '" + Constants.TIMESTAMPFORMAT + "')";

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(prog_sql);

			String stage = "";
			double percentage = -1.0;
			if (rs.next()) {
				stage = rs.getString(1);
				percentage = rs.getDouble(2);
			}
			// rs.close();
			return new RunStatus(stage, percentage);

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @param querySQL
	 */
	public void insertQuery(String userName, String notebookName,
			String experimentName, String startTime, int queryNumber,
			String querySQL) {

		// int runID = getExperimentRunID();
		int queryID = LabShelfManager.getShelf().getSequencialID("SEQ_QUERYID");
		String[] columnNames = new String[] { "QueryID", "RunID",
				"QueryNumber", "QuerySQL" };
		String[] columnValues = new String[] { String.valueOf(queryID),
				String.valueOf(run_id_), queryNumber + "", querySQL };
		// Main._logger.outputLog("query info: " + queryID + "  " + run_id_ +
		// "  " + queryNumber + "  " + querySQL);
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {
			// inserts a query with no result into the DBMS
			LabShelfManager.getShelf().insertTupleToNotebook(QUERY.TableName,
					columnNames, columnValues, dataTypes);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException e) {
			Main._logger.reportError("Failed to insert query");
			e.printStackTrace();
			System.exit(1); // programemer/dbsm error
		}
	}

	public boolean queryExist(String userName, String notebookName,
			String experimentName, String startTime, int queryNumber) {

		int queryID = getQueryID(userName, notebookName, experimentName,
				startTime, queryNumber);

		if (queryID == -1) {
			Main._logger.reportError("query Does NOT Exist.");
			return false;
		}
		return true;

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param transactionTime
	 * @param currentStage
	 * @param percentage
	 */
	public void insertRunLog(String transactionTime, String currentStage,
			double percentage) {
		// int run_id = this.getExperimentRunID();

		// update the runlog by appending the newest event.
		String[] columnsLog = new String[] { "RunID", "TransactionTime",
				"CurrentStage", "Percentage" };
		String[] columnValuesLog = new String[] { String.valueOf(run_id_),
				transactionTime, currentStage, String.valueOf(percentage) };
		int[] dataTypesLog = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
				GeneralDBMS.I_DATA_TYPE_VARCHAR, GeneralDBMS.I_DATA_TYPE_NUMBER };

		try {
			LabShelfManager.getShelf().insertTupleToNotebook(RUNLOG.TableName,
					columnsLog, columnValuesLog, dataTypesLog);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param transactionTime
	 * @param command
	 */
	public void setExecutorCommand(String transactionTime, String command) {

		try {

			String machineNameSQL = "SELECT MachineName, DBMSName FROM "
					+ EXPERIMENTRUN.TableName + " WHERE RunID = " + run_id_;

			ResultSet rsMachineName = LabShelfManager.getShelf()
					.executeQuerySQL(machineNameSQL);

			String machineName = "";
			String dbms = "";

		//	while (rsMachineName.next()) {
			rsMachineName.next();
			machineName = rsMachineName.getString(1);
			dbms = rsMachineName.getString(2);

			azdblab.labShelf.dataModel.Executor.getExecutor(machineName, dbms)
					.updateExecutor(dbms, transactionTime, null, command);

			// rsMachineName.close();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
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
	 * @return the experimentName
	 */
	public String getExperimentName() {
		return experimentName;
	}

	/**
	 * @return the scenario
	 */
	public String getScenario() {
		return scenario;
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
	 * @return the startTime
	 */
	public String getStartTime() {
		return startTime;
	}

	/**
	 * @return the iType
	 */
	public int getiType() {
		return iType;
	}

	public int getRunID() {
		return run_id_;
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param result
	 * @throws FileNotFoundException
	 */
	public void insertExperimentRunResult(FileInputStream result)
			throws FileNotFoundException {

		String clobColumnName = "ResultXML";
		String[] columns = new String[] { "RunID" };
		String[] columnValues = new String[] { String.valueOf(run_id_) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		LabShelfManager.getShelf().updateDocument(EXPERIMENTRUN.TableName,
				clobColumnName, columns, columnValues, dataTypes, result);
		LabShelfManager.getShelf().commitlabshelf();
	}

	// /**
	// * Insert run result into AZDBLAB
	// *
	// * @param result
	// * : experiment run result string
	// */
	// public void insertExperimentRunResult(ByteArrayInputStream content)
	// throws IOException {
	// String clobColumnName = "ResultXML";
	// String[] columns = new String[] { "RunID" };
	// String[] columnValues = new String[] { String.valueOf(run_id_) };
	// int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };
	// // ByteArrayInputStream toValidate = new
	// ByteArrayInputStream((content.toString()).getBytes());
	//
	// /*ByteArrayInputStream toValidate = content;
	// if (true) {
	// if (!XMLHelper.isValid(Constants.CHOSEN_TEST_RESULT_SCHEMA,toValidate)) {
	// Main._logger
	// .reportError("ERROR, the XML output of this scenario is invalid");
	// Main._logger.reportError("XML_SCHEMA:"
	// + Constants.CHOSEN_TEST_RESULT_SCHEMA);
	// } else {
	// Main._logger.outputLog("Successfully validated resultXML file");
	// }
	// }
	// */
	// if(content != null){
	// LabShelfManager.getShelf().updateDocument(EXPERIMENTRUN.TableName,
	// clobColumnName, columns, columnValues, dataTypes, content);
	// LabShelfManager.getShelf().commitlabshelf();
	// }
	// }

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @return
	 */
	public int getExperimentRunQueryNumber() {

		// int run_id_ = LabShelf.getShelf().getUser(userName)
		// .getNotebook(notebookName).getExperiment(experimentName)
		// .getRun(startTime).getExperimentRunID();

		if (run_id_ == -1) {
			Main._logger.reportError("get ExperimentRun Query Number Err.");
			return -1;
		}

		String sql = "SELECT COUNT(QueryNumber) FROM " + QUERY.TableName
				+ " WHERE RunID = " + run_id_;

		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);

			rs.next();

			int count = rs.getInt(1);

			rs.close();

			return count;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 *            start Time of the run
	 * @param transactionTime
	 *            transaction time of the changes
	 * @param currentStage
	 * @param percentage
	 */
	public void updateRunProgress(String transactionTime, String currentStage,
			double percentage) {
		try {
			int run_id_ = User.getUser(userName).getNotebook(notebookName)
					.getExperiment(experimentName)
					.getExperimentRunID(startTime);

			if (run_id_ == -1) {
				Main._logger.reportError("Update Run Err.");
				return;
			}

			// Update the experimentRun item up to date.
			String updateSQL = "UPDATE " + EXPERIMENTRUN.TableName + " "
					+ " SET CurrentStage = '" + currentStage
					+ "', Percentage = " + percentage + " WHERE RunID = "
					+ run_id_;

			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
			// LabShelfManager.getShelf().commitlabshelf();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	// public void analyzeAllQueries(String userName, String notebookName,
	// String experimentName, String startTime) {
	// Main._logger.outputLog("Analyzing all Queries");
	// Vector<Query> vecQueries = new Vector<Query>();
	//
	// vecQueries = getExperimentRunQueries();
	//
	// Vector<Integer> vecID = new Vector<Integer>();
	// Vector<String> vecSQL = new Vector<String>();
	//
	// for (int i = 0; i < vecQueries.size(); i++) {
	//
	// Query tmpQry = vecQueries.get(i);
	//
	// vecID.add(tmpQry.iQueryID);
	//
	// vecSQL.add(tmpQry.strQuerySQL);
	// }
	//
	// for (int i = 0; i < vecID.size(); i++) {
	//
	// QueryAnalyzer qa = new QueryAnalyzer();
	// qa.analyzeQuery(vecSQL.get(i));
	//
	// String sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i) + ", 'NUMCNSEL', "
	// + qa.iNumCnSel + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	//
	// sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i) + ", 'NUMCNFRM', "
	// + qa.iNumCnFrm + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	//
	// if (qa.iNumEqWhere > 0) {
	// sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i) + ", 'NUMEQWHERE', "
	// + qa.iNumEqWhere + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	// }
	//
	// if (qa.iNumInEqWhere > 0) {
	// sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i) + ", 'NUMINEQWHERE', "
	// + qa.iNumInEqWhere + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	// }
	//
	// if (qa.iNumPredicate >= 0) {
	// sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i) + ", 'NUMPRED', "
	// + qa.iNumPredicate + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	// }
	//
	// if (qa.iNumSelfJoin >= 0) {
	// sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i) + ", 'NUMSELFJOIN', "
	// + qa.iNumSelfJoin + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	// }
	//
	// if (qa.num_aggregate_functions_ >= 0) {
	// sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
	// + " VALUES (" + vecID.get(i)
	// + ", 'NUMAGGREGATEFUNCTIONS', "
	// + qa.num_aggregate_functions_ + ")";
	// LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
	// }
	//			
	// //TODO this is the old one
	//
	// LabShelfManager.getShelf().commitlabshelf();
	//
	// }
	//
	// }

	public void analyzeAllQueries(String userName, String notebookName,
			String experimentName, String startTime) {
		Main._logger.outputLog("Analyzing all Queries");
		List<Query> vecQueries = new Vector<Query>();

		vecQueries = getExperimentRunQueries();

		QueryAnalyzer qa = new QueryAnalyzer();

		for (int i = 0; i < vecQueries.size(); i++) {

			Query tmpQry = vecQueries.get(i);
			qa.analyzeQuery(tmpQry);

			String sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
					+ " VALUES (" + tmpQry.iQueryID + ", 'NUMCNSEL', "
					+ qa.iNumCnSel + ")";
			LabShelfManager.getShelf().executeUpdateSQL(sqlParam);

			sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
					+ " VALUES (" + tmpQry.iQueryID + ", 'NUMCNFRM', "
					+ qa.iNumCnFrm + ")";
			LabShelfManager.getShelf().executeUpdateSQL(sqlParam);

			if (qa.iNumEqWhere > 0) {
				sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
						+ " VALUES (" + tmpQry.iQueryID + ", 'NUMEQWHERE', "
						+ qa.iNumEqWhere + ")";
				LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
			}

			if (qa.iNumInEqWhere > 0) {
				sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
						+ " VALUES (" + tmpQry.iQueryID + ", 'NUMINEQWHERE', "
						+ qa.iNumInEqWhere + ")";
				LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
			}

			if (qa.iNumPredicate >= 0) {
				sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
						+ " VALUES (" + tmpQry.iQueryID + ", 'NUMPRED', "
						+ qa.iNumPredicate + ")";
				LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
			}

			if (qa.iNumSelfJoin >= 0) {
				sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
						+ " VALUES (" + tmpQry.iQueryID + ", 'NUMSELFJOIN', "
						+ qa.iNumSelfJoin + ")";
				LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
			}

			if (qa.num_aggregate_functions_ >= 0) {
				sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
						+ " VALUES (" + tmpQry.iQueryID
						+ ", 'NUMAGGREGATEFUNCTIONS', "
						+ qa.num_aggregate_functions_ + ")";
				LabShelfManager.getShelf().executeUpdateSQL(sqlParam);
			}

			sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
					+ " VALUES (" + tmpQry.iQueryID
					+ ", 'NUMZEROSIDEDPKJOINS'," + qa.iZeroSidedPKJoin + ")";
			LabShelfManager.getShelf().executeUpdateSQL(sqlParam);

			sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
					+ " VALUES (" + tmpQry.iQueryID + ", 'NUMONESIDEDPKJOINS',"
					+ qa.iOneSidedPKJoin + ")";
			LabShelfManager.getShelf().executeUpdateSQL(sqlParam);

			sqlParam = "INSERT INTO " + QUERYHASPARAMETER.TableName
					+ " VALUES (" + tmpQry.iQueryID + ", 'NUMTWOSIDEDPKJOINS',"
					+ qa.iTwoSidedPKJoin + ")";
			LabShelfManager.getShelf().executeUpdateSQL(sqlParam);

			LabShelfManager.getShelf().commitlabshelf();
			qa.reset();

		}

	}

	public static int getRunID(int experimentID, String startTime) {
		String sql = "Select runID from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN + " where experimentID = "
//				+ experimentID + " and startTime = '" + startTime + "'";
				+ experimentID + " and startTime = " + "to_timestamp('" + startTime + "', '" + Constants.TIMESTAMPFORMAT + "')";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return rs.getInt(1);
			} else {
				return 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public static Vector<Run> getSpecificRuns(int type) {

		Vector<Run> result = new Vector<Run>();

		if (type == TYPE_PENDING) {

			String sql = "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMSName, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exr.RunID "
					+ "FROM "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_EXPERIMENT
					+ " exp, "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_EXPERIMENTRUN
					+ " exr "
//					+ "WHERE exp.ExperimentID = exr.ExperimentID AND exr.CurrentStage = 'Pending' AND exr.Percentage = 0";
					+ "WHERE exp.ExperimentID = exr.ExperimentID AND exr.CurrentStage = 'Pending' AND exr.Percentage = 0 "
					+ "ORDER BY exr.StartTime asc";

			try {

				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				while (rs == null) {
					LabShelfManager.resetShelf();
					rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				}

				while (rs.next()) {

					String userName = rs.getString(1);
					String notebookName = rs.getString(2);
					String experimentName = rs.getString(3);
					String scenario = rs.getString(4);
					String dbms = rs.getString(5);
					String startTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(6));
					String machineName = rs.getString(9);
					int run_id = rs.getInt(10);

					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime, type,
							run_id));

				}

				rs.close();

				return result;

			} catch (Exception ex) {
				ex.printStackTrace();
				return null;
			}

		}

		String sql = "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMSName, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exe.CurrentStatus, exe.Command, exr.RunID "
				+ "FROM "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENT
				+ " exp, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN
				+ " exr, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXECUTOR
				+ " exe "
//				+ "WHERE exp.ExperimentID = exr.ExperimentID AND exr.MachineName = exe.MachineName AND exr.DBMSName = exe.CurrentDBMSName ";
				+ "WHERE exp.ExperimentID = exr.ExperimentID AND exr.MachineName = exe.MachineName AND exr.DBMSName = exe.CurrentDBMSName "
			    + "ORDER BY exr.StartTime asc";
//		System.out.println(sql);
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs == null) {
				LabShelfManager.resetShelf();
				rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			}
			while (rs.next()) {
				String userName = rs.getString(1);
				String notebookName = rs.getString(2);
				String experimentName = rs.getString(3);
				String scenario = rs.getString(4);
				String dbms = rs.getString(5);
				String startTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(6));
				String currentStage = rs.getString(7);
				// double percentage = rs.getDouble(8);
				String machineName = rs.getString(9);
				String executorStatus = rs.getString(10);
				String command = rs.getString(11);
				int run_id = rs.getInt(12);

//				if (type == TYPE_RUNNING) { // running
//					if ((!currentStage.equals("Pending"))
//							&& (!currentStage.equals("Completed"))
//							&& (!executorStatus.equals("Paused"))
//							&& (!currentStage.equals("Aborted"))) {
//						Run run = new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, TYPE_RUNNING, run_id);
////						boolean paused = false;
////						Statement stmt = LabShelfManager.getShelf().regConnection.createStatement();
////						String sql2 = "select CURRENTSTAGE from azdblab_runlog where runid = " + run_id + " order by TRANSACTIONTIME";
////						ResultSet rs2 = stmt.executeQuery(sql2);
////						while (rs2.next()) {
////							String currStage = rs2.getString(1);
////							if(currStage.contains("paused")){
////								paused = true;
////							}
////							break;
////						}
////						if(paused){
////							System.out.println("paused run!!!!");
////							run.iType = TYPE_PAUSED;
////						}
//						result.add(run);
////						result.add(new Run(userName, notebookName,
////								experimentName, scenario, machineName, dbms,
////								startTime, TYPE_RUNNING, run_id));
//					}
//				} else if (type == TYPE_PAUSED) {
//					if ((!currentStage.equals("Pending"))
//							&& (!currentStage.equals("Completed"))
//							&& (!currentStage.equals("Aborted"))
//							&& (((executorStatus.equals("Paused")) && (command
//									.equals("Resume"))) || ((executorStatus
//									.equals("Terminated"))))) {
//						result.add(new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, TYPE_PAUSED, run_id));
//					}
//				} else if (type == TYPE_ABORTED) {
//					if (currentStage.equals("Aborted")) {
//						result.add(new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, TYPE_ABORTED, run_id));
//					}
//				}
				
				if (type == TYPE_RUNNING) { // running
					if ((!currentStage.equals("Pending"))
					&& (!currentStage.equals("Completed"))
					&& (!(currentStage).toLowerCase().contains("paused"))
//					&& (!currentStage.equals("Resumed"))
					&& (!currentStage.equals("Aborted"))) {
						Run run = new Run(userName, notebookName,
								experimentName, scenario, machineName, dbms,
								startTime, TYPE_RUNNING, run_id);
						result.add(run);
					}
				} else if (type == TYPE_PAUSED) {
//					if (currentStage.toLowerCase().contains("paused") || currentStage.equals("Resumed")) {
//						Run tempRun = new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, TYPE_PAUSED, run_id);
//						if (currentStage.equals("Resumed")){
//							tempRun.iType = TYPE_RESUMED;
//						}
//						result.add(tempRun);
//					}
					if (currentStage.toLowerCase().contains("paused") || currentStage.equals("Running")) {
						Run tempRun = new Run(userName, notebookName,
								experimentName, scenario, machineName, dbms,
								startTime, TYPE_PAUSED, run_id);
						if (currentStage.equals("Running")){
							tempRun.iType = TYPE_RESUMED;
						}
						result.add(tempRun);
					}
				} else if (type == TYPE_ABORTED) {
					if (currentStage.equals("Aborted")) {
						result.add(new Run(userName, notebookName,
								experimentName, scenario, machineName, dbms,
								startTime, TYPE_ABORTED, run_id));
					}
				}
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			if(!ex.getMessage().contains("Exhausted")){
				ex.printStackTrace();
			}
			return null;
		}
		
	}

	/**
	 * This will extract the number of instances process were seen in a
	 * completed run
	 * 
	 * @param saveLocation
	 * @throws Exception
	 */
	public TreeMap<String, Integer> getProcessInformation() throws Exception {
		TreeMap<String, Integer> processMap = new TreeMap<String, Integer>();
		String sql = "Select  qe.procdiff from azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ run_id_ + " and q.queryid = qe.queryid";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
//			String body = rs.getString(1).replace("\n", " ");
			String body =  (LabShelfManager.getShelf().getStringFromClob(rs, 1)).replace("\n", " ");
			body = body.toLowerCase();
			body = body.split("phantom processes:")[0];

			String tmp[] = body.split("started processes:");
			if (tmp.length > 1) {
				String startString = tmp[1];
				startString = startString.replace("[", "");
				Pattern p = Pattern.compile("[0-9]+?\\(");
				String[] processes = p.split(startString.trim());
				for (int i = 0; i < processes.length; i++) {
					String pName = processes[i].split(",")[0].trim();
					if (processMap.containsKey(pName)) {
						Integer oldNum = processMap.get(pName);
						processMap.put(pName, oldNum + 1);
					} else {
						processMap.put(pName, 1);
					}
				}
			}
			body = tmp[0];
			tmp = body.split("stopped processes:");
			if (tmp.length > 1) {
				String stoppedString = tmp[1];
				stoppedString = stoppedString.replace("[", "");
				stoppedString = stoppedString.replace("]", "");
				String[] processes = stoppedString.split(";");
				for (int i = 0; i < processes.length; i++) {
					String pName = processes[i].trim();
					if (processMap.containsKey(pName)) {
						Integer oldNum = processMap.get(pName);
						processMap.put(pName, oldNum + 1);
					} else {
						processMap.put(pName, 1);
					}
				}
			}
			body = tmp[0];
			body = body.replace("existing processes:", "");
			body = body.replace("[", "");
			body = body.replace("]", "");
			Pattern p = Pattern.compile("[0-9]+?\\(");
			String[] result = p.split(body.trim());
			for (int i = 0; i < result.length; i++) {
				String pName = result[i].split(",")[0].trim();
				if (processMap.containsKey(pName)) {
					Integer oldNum = processMap.get(pName);
					processMap.put(pName, oldNum + 1);
				} else {
					processMap.put(pName, 1);
				}
			}
		}
		return processMap;
	}

	public void saveProcessInformation(String saveLocation) throws Exception {
		TreeMap<String, Integer> processMap = getProcessInformation();

		TreeMap<String, Integer> sorted_map = new TreeMap<String, Integer>(
				new ValueComparator(processMap));

		sorted_map.putAll(processMap);

		Iterator<Entry<String, Integer>> it = sorted_map.entrySet().iterator();

		BufferedWriter out = new BufferedWriter(new FileWriter(saveLocation));
		while (it.hasNext()) {
			Entry<String, Integer> ent = (Entry<String, Integer>) it.next();
			if (!ent.getKey().equals("")) {
				out.write(ent.getKey() + ":" + ent.getValue() + "\n");
			}
			it.remove();
		}
		out.close();
	}

//	public void addToAspect(String aspectName) {
//		try {
//			LabShelfManager.getShelf().insertTuple(
//					QueryStatEvaluation.RUNHASASPECT.TableName,
//					QueryStatEvaluation.RUNHASASPECT.columns,
//					new String[] { aspectName, String.valueOf(run_id_) },
//					QueryStatEvaluation.RUNHASASPECT.columnDataTypes);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}

	public boolean isInAspect(String aspectName) {
		try {
			String sql = "Select * from " + Constants.TABLE_PREFIX
					+ Constants.TABLE_RUNHASASPECT + " where aspectName = '"
					+ aspectName + "' and runid = " + run_id_;
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return true;
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public void addComment(String comment) {
		LabShelfManager.getShelf()
				.putDocument(
						Constants.TABLE_PREFIX + Constants.TABLE_COMMENT,
						"Comments",
						new String[] { "RunID", "DateAdded" },
						new String[] {
								String.valueOf(run_id_),
								new SimpleDateFormat(Constants.TIMEFORMAT)
										.format(new Date(System
												.currentTimeMillis())) },
						new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
								GeneralDBMS.I_DATA_TYPE_VARCHAR, }, comment);
		LabShelfManager.getShelf().commit();
	}

	public List<Comment> getAllComments() {
		Vector<Comment> toRet = new Vector<Comment>();
		String sql = "Select Comments, DateAdded from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_COMMENT
				+ " where runID = " + run_id_;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				toRet
						.add(new Comment(run_id_, rs.getString(1), 
								 new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(2))));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public static Vector<Run> getAllRuns() {
		Vector<Run> result = new Vector<Run>();

		String sql = "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMSName, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exe.CurrentStatus, exr.RunID "
				+ "FROM "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENT
				+ " exp, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN
				+ " exr, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXECUTOR
				+ " exe "
				+ "WHERE exp.ExperimentID = exr.ExperimentID AND ((exr.MachineName = exe.MachineName AND exr.DBMSName = exe.CurrentDBMSName) OR exr.CurrentStage = 'Pending')";

		try {

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);

			if (rs == null) {
				// TODO I don't think it should do this.... Maybe return an
				// empty vector but not null
				return null;
			}

			while (rs.next()) {

				String userName = rs.getString(1);
				String notebookName = rs.getString(2);
				String experimentName = rs.getString(3);
				String scenario = rs.getString(4);
				String dbms = rs.getString(5);
				String startTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(6));
				String currentStage = rs.getString(7);
				// double percentage = rs.getDouble(8);
				String machineName = rs.getString(9);
				String executorStatus = rs.getString(10);
				int run_id = rs.getInt(11);

//				if ((!currentStage.equals("Pending"))
//						&& (!currentStage.equals("Completed"))
//						&& (!currentStage.equals("Aborted"))) {
//					if (executorStatus.equals("Paused")
//							|| executorStatus.equals("Terminated")) {
//						result.add(new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, TYPE_PAUSED, run_id));
//					} else {
//						result.add(new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, TYPE_RUNNING, run_id));
//					}
//				} else if (currentStage.equals("Pending")) {
//					result.add(new Run(userName, notebookName, experimentName,
//							scenario, machineName, dbms, startTime, TYPE_PENDING, run_id));
//				} else if (currentStage.equals("Aborted")) {
//					result.add(new Run(userName, notebookName, experimentName,
//							scenario, machineName, dbms, startTime, TYPE_ABORTED, run_id));
//				} else if (currentStage.equals("Completed")) {
//					result.add(new Run(userName, notebookName, experimentName,
//							scenario, machineName, dbms, startTime,
//							TYPE_COMPLETED, run_id));
//				}
				if ((currentStage).toLowerCase().contains("paused") || (currentStage).toLowerCase().contains("resumed")) {
					result.add(new Run(userName, notebookName,
							experimentName, scenario, machineName, dbms,
							startTime, TYPE_PAUSED, run_id));
				} else if (currentStage.equals("Pending")) {
					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime, TYPE_PENDING, run_id));
				} else if (currentStage.equals("Aborted")) {
					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime, TYPE_ABORTED, run_id));
				} else if (currentStage.equals("Completed")) {
					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime,
							TYPE_COMPLETED, run_id));
				}else {
					result.add(new Run(userName, notebookName,
							experimentName, scenario, machineName, dbms,
							startTime, TYPE_RUNNING, run_id));
				}
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	private class ValueComparator implements Comparator<Object> {

		Map<String, Integer> base;

		public ValueComparator(Map<String, Integer> base) {
			this.base = base;
		}

		public int compare(Object a, Object b) {

			if ((Integer) base.get(a) < (Integer) base.get(b)) {
				return 1;
			} else if ((Integer) base.get(a) == (Integer) base.get(b)) {
				return 0;
			} else {
				return -1;
			}
		}
	}
}
