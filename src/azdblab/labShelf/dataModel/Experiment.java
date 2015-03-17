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

import java.io.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import azdblab.Constants;
import azdblab.exception.analysis.InvalidExperimentRunException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableDefinition;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.XMLHelper;

public class Experiment extends TableDefinition {

	private String userName;

	private String notebookName;

	/**
	 * The name of the experiment.
	 */
	private String experimentName;

	private String scenario;

	/**
	 * The description for this experiment.
	 */
	private String expDescription;

	/**
	 * The DOM document for the experiment.
	 */
	private Element elementExpDescription;

	private int iOptimalCardinality;

	/**
	 * The tests for this experiment.
	 */
	private ExperimentRun myExperimentRun;

	/**
	 * @param strUserName
	 * @param strNotebookName
	 * @param strExperimentName
	 * @param strScenario
	 * @param strExpDBMSName
	 * @param strExpDescription
	 * @param elementExpDescription
	 * @param iOptimalCardinality
	 * @param myExperimentRun
	 */
	public Experiment(String strUserName, String strNotebookName,
			String strExperimentName) {
		this.userName = strUserName;
		this.notebookName = strNotebookName;
		this.experimentName = strExperimentName;
		Document d = null;
		while (d == null) {
			try {
				d = this.getExperimentSource();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				d = null;
			}
		}
		processSourceXML(d);
	}

	/**
	 * Returns the description for this experiment.
	 * 
	 * @return The description for this experiment.
	 */
	public String getDescription() {
		return expDescription;
	}

	/**
	 * Returns the name of the experiment.
	 * 
	 * @return The name of the experiment.
	 */
	public String getExperimentName() {
		return experimentName;
	}

	public String getScenario() {
		return scenario;
	}

	/**
	 * Returns the name of the experiment.
	 * 
	 * @return The name of the experiment.
	 */
	public String getUserName() {
		return userName;
	}

	public String getNotebookName() {
		return notebookName;
	}

	public int getOptimalCardinality() {
		return iOptimalCardinality;
	}

	/**
	 * Returns all the tests for this experiment.
	 * 
	 * @return All the tests for this experiment.
	 */
	public ExperimentRun getMyExperimentRun() {
		try {
			return new ExperimentRun(this, elementExpDescription);
		} catch (InvalidExperimentRunException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;
	}

	public void processSourceXML(Document experiment) {

		elementExpDescription = experiment.getDocumentElement();

		// expDescription = ((DeferredTextImpl) elementExpDescription
		// .getChildNodes().item(0)).getData();

		expDescription = (elementExpDescription.getChildNodes().item(0))
				.getTextContent();

		experimentName = experiment.getDocumentElement().getAttribute("name");
		scenario = experiment.getDocumentElement().getAttribute("scenario");

	}

	/**
	 * Updates the experiment inside of the database. Checks to see what tests
	 * have changed.
	 * 
	 * @throws Exception
	 *             If all the tests are different.
	 * 
	 *             public void insertExperiment_ss(String expFileName) throws
	 *             Exception { //case where experiment doesn't exist if
	 *             (!dbController.experimentExists(strUserName, strNotebookName,
	 *             strExperimentName)) { try { String date = (new
	 *             Date(System.currentTimeMillis())).toString();
	 *             dbController.insertExperiment( strUserName, strNotebookName,
	 *             strExperimentName, expFileName, date, new FileInputStream(new
	 *             File(expFileName))); } catch (FileNotFoundException e) {
	 *             throw new ExperimentUpdateException(e.getMessage()); }
	 *             return; }
	 * 
	 *             //case where experiment does exist ExperimentNode old;
	 * 
	 *             old = dbController.getExperimentNode(strUserName,
	 *             strNotebookName, strExperimentName);
	 * 
	 * 
	 *             //comparing the tests in this experiment to the other
	 *             experiment. ExperimentRun[] oldTests = old.getMyTests();
	 *             ExperimentRun[] thisTests = this.getMyTests(); boolean[]
	 *             sameAsOld = new boolean[oldTests.length]; for (int i = 0; i <
	 *             sameAsOld.length; i++) sameAsOld[i] = false;
	 * 
	 *             //checking to see which tests are the same and which are
	 *             different. boolean allSame = true; boolean allDifferent =
	 *             true; for (int i = 0; i < thisTests.length && i <
	 *             oldTests.length; i++) { if (thisTests[i].equals(oldTests[i]))
	 *             { allDifferent = false; sameAsOld[i] = true; } else allSame =
	 *             false; }
	 * 
	 *             //if all tests are different throw an exception. if
	 *             (allDifferent) { throw new
	 *             ExperimentUpdateException("All Tests are different"); } else
	 *             if (!allDifferent && !allSame) { //removing test if their
	 *             definition has changed. for (int i = 0; i < sameAsOld.length;
	 *             i++) if (!sameAsOld[i]) //
	 *             myDBController.deleteTest(strUserName, strNotebookName,
	 *             strExperimentName, i); System.err.println("myDBController.deleteTest(strUserName, strNotebookName, strExperimentName, i) @ line 264 ExperimentNode.java"
	 *             );
	 * 
	 *             //updating the experiment XML in the internal tables. try {
	 *             dbController.updateExperiment( strUserName, strNotebookName,
	 *             strExperimentName, new FileInputStream(new
	 *             File(expFileName))); } catch (FileNotFoundException e) {
	 *             throw new ExperimentUpdateException(e.getMessage()); } } }
	 */

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 */
	public void deleteExperimentRun(String startTime) {

		int runID = getExperimentRunID(userName, notebookName, experimentName,
				startTime);

		if (runID == -1) {
			Main._logger.reportError("delete Test Err.");
			return;
		}

		String[] columnNames = new String[] { "RunID" };
		String[] columnValues = new String[] { String.valueOf(runID) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		LabShelfManager.getShelf().deleteRows(EXPERIMENTRUN.TableName,
				columnNames, columnValues, dataTypes);
		LabShelfManager.getShelf().commitlabshelf();

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 */
	public void deleteRun(String startTime) {

		int expID = getExperimentID(userName, notebookName, experimentName);

		if (expID == -1) {
			Main._logger.reportError("delete runs Query Err.");
			return;
		}

		String[] columnNames = new String[] { "ExperimentID", "StartTime" };
		String[] columnValues = new String[] { String.valueOf(expID), startTime };
		int[] columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		LabShelfManager.getShelf().deleteRows(EXPERIMENTRUN.TableName,
				columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();

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
	public boolean experimentRunExists(String startTime) {

		int runID = getExperimentRunID(userName, notebookName, experimentName,
				startTime);

		if (runID == -1) {
			// System.err.println("test TestExists Query Err.");
			return false;
		}

		return true;

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @returnhe experiment run is null
	 * @throws SQLException
	 */
	public List<Run> getCompletedRuns() throws SQLException {

		Vector<Run> result = new Vector<Run>();

		int expID = getExperimentID(userName, notebookName, experimentName);

		if (expID == -1) {
			Main._logger.reportError("get Experiment Run Err.");
			return null;
		}

		String completedRunSQL = "SELECT exp.Scenario, exr.MachineName, exr.DBMSName, exr.StartTime, exr.RunID FROM "
				+ EXPERIMENT.TableName
				+ " exp, "
				+ EXPERIMENTRUN.TableName
				+ " exr"
				+ " WHERE exp.ExperimentID = "
				+ expID
				+ " AND exr.ExperimentID = "
				+ expID
				+ " AND exr.CurrentStage = 'Completed' AND exr.Percentage = 100 order by exr.DBMSName, exr.RunID asc";

		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(
				completedRunSQL);

		while (rs.next()) {
			result.add(new Run(userName, notebookName, experimentName, rs
					.getString(1), rs.getString(2), rs.getString(3), 
					new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(4)), 0, rs.getInt(5)));
		}

		rs.close();
		/*
		 * for (Run r: result) { r.InitializeRun(); }
		 */
		return result;

	}

	// public Run getRun_new(String startTime) {
	//
	// String sql =
	// "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMS, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exr.RunID "
	// + "FROM "
	// + EXPERIMENT.TableName
	// + " exp, "
	// + EXPERIMENTRUN.TableName
	// + " exr, "
	// + "WHERE exp.ExperimentID = exr.ExperimentID  and exr.startTime = '"
	// + startTime + "'";
	//		
	//		
	// if (currentStage.equals("Pending")) {
	// return new Run(userName, notebookName, experimentName,
	// scenario, machineName, dbms, startTime, Run.TYPE_PENDING, run_id);
	// } else if (currentStage.equals("Aborted")) {
	// return new Run(userName, notebookName, experimentName,
	// scenario, machineName, dbms, startTime, Run.TYPE_ABORTED, run_id);
	// } else if (currentStage.equals("Completed")) {
	// return new Run(userName, notebookName, experimentName,
	// scenario, machineName, dbms, startTime, Run.TYPE_COMPLETED, run_id);
	// }
	// new null
	//
	// }

	public List<Run> getRuns() throws SQLException {
		Vector<Run> result = new Vector<Run>();

		String sql = "SELECT distinct exp.UserName, exp.NotebookName, exp.ExperimentName, exp.Scenario, exr.DBMSName, exr.StartTime, exr.CurrentStage, exr.Percentage, exr.MachineName, exe.CurrentStatus, exr.RunID "
				+ "FROM "
				+ EXPERIMENT.TableName
				+ " exp, "
				+ EXPERIMENTRUN.TableName
				+ " exr, "
				+ EXECUTOR.TableName
				+ " exe "
				+ "WHERE exp.ExperimentID = exr.ExperimentID and exp.userName = '"
				+ userName
				+ "' and exp.notebookName = '"
				+ notebookName
				+ "' and exp.experimentName = '"
				+ experimentName
				+ "' AND ((exr.MachineName = exe.MachineName AND exr.DBMSName = exe.CurrentDBMSName) OR exr.CurrentStage = 'Pending')";

		Main._logger.writeIntoLog(sql);
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
//					&& (!currentStage.equals("Completed"))
//					&& (!currentStage.equals("Aborted"))) {
//					if (executorStatus.equals("Paused")
//					|| executorStatus.equals("Terminated")) {
//						result.add(new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, Run.TYPE_PAUSED, run_id));
//					} else {
//						result.add(new Run(userName, notebookName,
//								experimentName, scenario, machineName, dbms,
//								startTime, Run.TYPE_RUNNING, run_id));
//					}
//				} 
				if (currentStage.equals("Paused")) {
					result.add(new Run(userName, notebookName,
							experimentName, scenario, machineName, dbms,
							startTime, Run.TYPE_PAUSED, run_id));
				}
				else if (currentStage.equals("Pending")) {
					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime,
							Run.TYPE_PENDING, run_id));
				} else if (currentStage.equals("Aborted")) {
					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime,
							Run.TYPE_ABORTED, run_id));
				} else if (currentStage.equals("Completed")) {
					result.add(new Run(userName, notebookName, experimentName,
							scenario, machineName, dbms, startTime,
							Run.TYPE_COMPLETED, run_id));
				} else {
					result.add(new Run(userName, notebookName,
							experimentName, scenario, machineName, dbms,
							startTime, Run.TYPE_RUNNING, run_id));
				}
			}

			rs.close();

			return result;

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
	 * @return
	 */
	public int getExperimentID() {

		try {

			String sqlID = "SELECT ExperimentID " + "FROM "
					+ EXPERIMENT.TableName + " " + "WHERE UserName = '"
					+ userName + "' AND NotebookName = '" + notebookName
					+ "' AND ExperimentName = '" + experimentName + "'";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			if (rsID != null)
				rsID.close();
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
	 * @return
	 * @throws FileNotFoundException
	 */
	public Document getXactExperimentSource() throws FileNotFoundException {

		String columnName = "SourceXML";
		String[] columnNames = new String[] { "UserName", "NotebookName",
				"ExperimentName" };
		String[] columnValues = new String[] { userName, notebookName,
				experimentName };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		// Retrieves the result and validates it.
		InputStream result = LabShelfManager.getShelf().getDocument(
				EXPERIMENT.TableName, columnName, columnNames, columnValues,
				dataTypes);
		// return XMLHelper.validate((getClass().getClassLoader()
		// .getResourceAsStream(MetaData.CHOSEN_EXPERIMENT_SCHEMA)), result);

		// Main._logger.outputLog("schema: " + MetaData.CHOSEN_EXPERIMENT_SCHEMA
		// + ", experimentName: " + experimentName);
		//System.out.println(Constants.CHOSEN_EXPERIMENT_SCHEMA);
		return XMLHelper.validate(new FileInputStream(new File(
				Constants.CHOSEN_XACTEXPERIMENT_SCHEMA)), result);

	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @return
	 * @throws FileNotFoundException
	 */
	public Document getExperimentSource() throws FileNotFoundException {

		String columnName = "SourceXML";
		String[] columnNames = new String[] { "UserName", "NotebookName",
				"ExperimentName" };
		String[] columnValues = new String[] { userName, notebookName,
				experimentName };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		// Retrieves the result and validates it.
		InputStream result = LabShelfManager.getShelf().getDocument(
				EXPERIMENT.TableName, columnName, columnNames, columnValues,
				dataTypes);
		// return XMLHelper.validate((getClass().getClassLoader()
		// .getResourceAsStream(MetaData.CHOSEN_EXPERIMENT_SCHEMA)), result);

		// Main._logger.outputLog("schema: " + MetaData.CHOSEN_EXPERIMENT_SCHEMA
		// + ", experimentName: " + experimentName);
		//System.out.println(Constants.CHOSEN_EXPERIMENT_SCHEMA);
		if(experimentName.contains("tps") || experimentName.contains("xt")){
			return XMLHelper.validate(new FileInputStream(new File(
					Constants.CHOSEN_XACTEXPERIMENT_SCHEMA)), result);	
		}else{
			return XMLHelper.validate(new FileInputStream(new File(
					Constants.CHOSEN_EXPERIMENT_SCHEMA)), result);
		}
		

	}

	public Element getExperimentSpec(String kind) {
		try {
			if (myExperimentRun == null) {
				processSourceXML(this.getExperimentSource());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
		long experimentSpecID = getExperimentSpecID(userName, notebookName,
				experimentName, kind);

		if (experimentSpecID == -1) {
			Main._logger.reportError("Get ExperimentSpecID err.");
			return null;
		}

		String columnName = "SourceXML";
		String[] columnNames = new String[] { "ExperimentSpecID" };
		String[] columnValues = new String[] { String.valueOf(experimentSpecID) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		// Retrieves the result and validates it.
		InputStream result = LabShelfManager.getShelf().getDocument(
				EXPERIMENTSPEC.TableName, columnName, columnNames,
				columnValues, dataTypes);
		if (kind.equals("D")) {
			// return XMLHelper.validate(
			// getClass().getClassLoader().getResourceAsStream(MetaData.CHOSEN_DATA_DEFINITION_SCHEMA),
			// result).getDocumentElement();
			try {
				return XMLHelper.validate(
						new FileInputStream(new File(
								Constants.CHOSEN_DATA_DEFINITION_SCHEMA)),
						result).getDocumentElement();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}
		} else if (kind.equals("Q")) {
			// return XMLHelper.validate(
			// (getClass().getClassLoader()
			// .getResourceAsStream(MetaData.CHOSEN_PREDEFINED_SCHEMA)),
			// result).getDocumentElement();
			try {
				return XMLHelper.validate(
						new FileInputStream(new File(
								Constants.CHOSEN_PREDEFINED_SCHEMA)), result)
						.getDocumentElement();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}
		}

		return null;

	}

	public long getExperimentSpecID(String kind) {

		try {

			int experimentID = getExperimentID(userName, notebookName,
					experimentName);

			String sqlID = "SELECT ExperimentSpecID " + "FROM "
					+ REFERSEXPERIMENTSPEC.TableName + " "
					+ "WHERE ExperimentID = " + experimentID + " AND Kind = '"
					+ kind + "'";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				long id = rsID.getLong(1);
				rsID.close();
				return id;
			}

			if (rsID != null)
				rsID.close();
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
	 * @param dbms
	 * @param startTime
	 * @param currentStage
	 * @param percentage
	 * @throws SQLException
	 */
	public void insertExperimentRun(String dbms, String startTime,
			String currentStage, double percentage) throws SQLException {
		int expID = getExperimentID(userName, notebookName, experimentName);
		//Main._logger.outputLog("getting experiment id .... done! ");
		if (expID == -1) {
			Main._logger.reportError("Insert ExperimentRun Err.");
			return;
		}

		int runID = LabShelfManager.getShelf().getSequencialID("SEQ_RUNID");
		//Main._logger.outputLog("getting run id .... done! ");

		String[] columns = new String[] { "RunID", "ExperimentID", "DBMSName",
				"StartTime", "CurrentStage", "Percentage" };
		String[] columnValues = new String[] { String.valueOf(runID),
				String.valueOf(expID), dbms, startTime, currentStage,
				String.valueOf(percentage) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
				GeneralDBMS.I_DATA_TYPE_VARCHAR, GeneralDBMS.I_DATA_TYPE_NUMBER };

		// Inserts a test into the DBMS with no test result.
		LabShelfManager.getShelf().insertTupleToNotebook(
				EXPERIMENTRUN.TableName, columns, columnValues, dataTypes);
		//Main._logger.outputLog("getting experiment run inserted .... done! ");

		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param dbms
	 * @param startTime
	 * @param currentStage
	 * @param percentage
	 * @param machineName
	 *            - If this pending run can only run on a specific machine, that
	 *            parameter is specified here
	 * @throws SQLException
	 */
	public void insertExperimentRun(String dbms, String startTime,
			String currentStage, double percentage, String machineName)
			throws SQLException {
		int expID = getExperimentID(userName, notebookName, experimentName);
		//Main._logger.outputLog("getting experiment id .... done! ");
		if (expID == -1) {
			Main._logger.reportError("Insert ExperimentRun Err.");
			return;
		}

		int runID = LabShelfManager.getShelf().getSequencialID("SEQ_RUNID");
		//Main._logger.outputLog("getting run id .... done! ");
		String[] columns = new String[] { "RunID", "ExperimentID", "DBMSName",
				"StartTime", "CurrentStage", "Percentage", "MachineName" };
		String[] columnValues = new String[] { String.valueOf(runID),
				String.valueOf(expID), dbms, startTime, currentStage,
				String.valueOf(percentage), machineName };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_VARCHAR };

		// Inserts a test into the DBMS with no test result.
		LabShelfManager.getShelf().insertTupleToNotebook(
				EXPERIMENTRUN.TableName, columns, columnValues, dataTypes);
		//Main._logger.outputLog("getting experiment run inserted .... done! ");

		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * This should be called right after the insertTestSpec is invoked, since
	 * the TestSpecID will have to be passed in here.
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param testSpecID
	 */
	public void insertRefersExperimentSpec(String kind, int experimentSpecID) {

		int experimentID = getExperimentID(userName, notebookName,
				experimentName);

		if (experimentID == -1) {
			Main._logger.reportError("insert Reference Err.");
			return;
		}

		String[] columns = new String[] { "ExperimentID", "Kind",
				"ExperimentSpecID" };
		String[] columnValues = new String[] { String.valueOf(experimentID),
				kind, String.valueOf(experimentSpecID) };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR, GeneralDBMS.I_DATA_TYPE_NUMBER };

		try {
			// Inserts a reference into the DBMS.
			LabShelfManager.getShelf().insertTupleToNotebook(
					REFERSEXPERIMENTSPEC.TableName, columns, columnValues,
					dataTypes);
			LabShelfManager.getShelf().commitlabshelf();
		} catch (SQLException e) {

		}
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param xml_source
	 */
	public void updateExperiment(FileInputStream xml_source) {

		String clobColumnName = "SourceXML";
		String[] columns = new String[] { "UserName", "NotebookName",
				"ExperimentName" };
		String[] columnValues = new String[] { userName, notebookName,
				experimentName };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		// Replaces the content of the current experiment with the XML passed in
		// to this procedure.
		LabShelfManager.getShelf().updateDocument(EXPERIMENT.TableName,
				clobColumnName, columns, columnValues, dataTypes, xml_source);
		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @return
	 */
	public int getExperimentRunID(String startTime) {

		try {

			int expID = getExperimentID(userName, notebookName, experimentName);

			String sqlID = "SELECT RunID " + "FROM " + EXPERIMENTRUN.TableName
					+ " " + "WHERE ExperimentID = " + expID
//					+ " AND StartTime = '" + startTime + "'";
					+ " AND StartTime = to_timestamp('" + startTime + "', '" + Constants.TIMESTAMPFORMAT + "')";
			
			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			if (rsID != null)
				rsID.close();
			return -1;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}

	}

	public long getExperimentSpecID(String userName, String notebookName,
			String experimentName, String kind) {

		try {

			int experimentID = getExperimentID(userName, notebookName,
					experimentName);

			String sqlID = "SELECT ExperimentSpecID " + "FROM "
					+ REFERSEXPERIMENTSPEC.TableName + " "
					+ "WHERE ExperimentID = " + experimentID + " AND Kind = '"
					+ kind + "'";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				long id = rsID.getLong(1);
				rsID.close();
				return id;
			}
			if (rsID != null)
				rsID.close();
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
	public int getExperimentRunID(String userName, String notebookName,
			String experimentName, String startTime) {

		try {

			int expID = getExperimentID(userName, notebookName, experimentName);

			String sqlID = "SELECT RunID " + "FROM " + EXPERIMENTRUN.TableName
					+ " " + "WHERE ExperimentID = " + expID
//					+ " AND StartTime = '" + startTime + "'";
					+ " AND StartTime = to_timestamp('" + startTime + "', '" + Constants.TIMESTAMPFORMAT + "')";

			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);

			if (rsID != null && rsID.next()) {
				int id = rsID.getInt(1);
				rsID.close();
				return id;
			}
			if (rsID != null)
				rsID.close();
			return -1;

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}

	}

	public Run getRun(String startTime) {
		try {
			for (Run r : getRuns()) {
				if (r.getStartTime().equalsIgnoreCase(startTime)) {
					return r;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
		return null;
	}

	public void createMinExperimentRun(String un, String nn, String en,
			String db, Vector<String> vec_selected_runs) {
		try {
			File myResultFile = File.createTempFile("testResult", ".xml",
					new File(Constants.DIRECTORY_TEMP));
			myResultFile.deleteOnExit();
			insertExperimentRun(db, "MIN RUN SUMMARY", "Completed", 100);
			String st = vec_selected_runs.get(0);

			String sql_queries = "SELECT qr.QueryNumber, qr.QuerySQL "
					+ "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er, AZDBLAB_QUERY qr "
					+ "WHERE ex.username = '" + un
					+ "' AND ex.notebookname = '" + nn + "' "
					+ "AND ex.experimentname = '" + en
					+ "' AND ex.experimentid = er.experimentid "
					+ "AND er.starttime = '" + st + "' AND er.runid = qr.runid";
			ResultSet rs_queries = LabShelfManager.getShelf().executeQuerySQL(
					sql_queries);
			HashMap<Integer, Element> map_query_result = new HashMap<Integer, Element>();
			HashMap<Integer, String> map_query_string = new HashMap<Integer, String>();
			Document result_XML = null;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setIgnoringElementContentWhitespace(true);
			DocumentBuilder builder = factory.newDocumentBuilder();
			result_XML = builder.newDocument();
			while (rs_queries.next()) {
				int query_num = rs_queries.getInt(1);
				String query_string = rs_queries.getString(2);
				Element query_result = null;
				query_result = result_XML.createElement("queryResult");
				query_result.setAttribute("sql", query_string);
				map_query_result.put(query_num, query_result);
				map_query_string.put(query_num, query_string);
			}
			rs_queries.close();

			Iterator<Integer> iter_query_string = map_query_string.keySet()
					.iterator();
			while (iter_query_string.hasNext()) {
				int query_num = iter_query_string.next();
				String query_string = map_query_string.get(query_num);
				User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
						.insertQuery(un, nn, en, "MIN RUN SUMMARY", query_num,
								query_string);
			}

			User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
					.analyzeAllQueries(un, nn, en, "MIN RUN SUMMARY");

			String selected_runs = "";
			for (int i = 0; i < vec_selected_runs.size(); i++) {
				selected_runs += "'" + vec_selected_runs.get(i) + "'";
				if (i < vec_selected_runs.size() - 1) {
					selected_runs += ", ";
				}
			}

			// String sql_queryexecution =
			// "SELECT qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality, MIN(qn.RunTime) "
			// +
			// "FROM MetaData_EXPERIMENT ex, MetaData_EXPERIMENTRUN er, MetaData_QUERY qr, MetaData_queryexecution qn, MetaData_QRHASPLAN qp "
			// +
			// "WHERE ex.UserName = '" + un + "' AND ex.NotebookName = '" + nn +
			// "' AND ex.ExperimentName = '" + en +
			// "' AND ex.experimentid = er.experimentid AND er.starttime IN (" +
			// selected_runs +
			// ") AND er.percentage = 100 AND er.currentstage='Completed' " +
			// "AND er.runid = qr.runid AND qr.queryid = qn.queryid AND qn.QueryExecutionID = qp.QueryExecutionID "
			// +
			// "GROUP BY (qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality) "
			// +
			// "ORDER BY qr.QueryNumber, qn.Cardinality";
			String sql_queryexecution = "SELECT qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality, qn.ResultCardinality, MIN(qn.RunTime) "
					+ "FROM MetaData_EXPERIMENT ex, MetaData_EXPERIMENTRUN er, MetaData_QUERY qr, MetaData_QUERYEXECUTION qn, MetaData_QRHASPLAN qp "
					+ "WHERE ex.UserName = '"
					+ un
					+ "' AND ex.NotebookName = '"
					+ nn
					+ "' AND ex.ExperimentName = '"
					+ en
					+ "' AND ex.experimentid = er.experimentid AND er.starttime IN ("
					+ selected_runs
					+ ") AND er.percentage = 100 AND er.currentstage='Completed' "
					+ "AND er.runid = qr.runid AND qr.queryid = qn.queryid AND qn.QueryExecutionID = qp.QueryExecutionID "
					+ "GROUP BY (qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality) "
					+ "ORDER BY qr.QueryNumber, qn.Cardinality";

			ResultSet rs_queryexecution = LabShelfManager.getShelf()
					.executeQuerySQL(sql_queryexecution);

			HashMap<Integer, Vector<Integer>> map_query_runs = new HashMap<Integer, Vector<Integer>>();
			Vector<String> vec_temp_result = new Vector<String>();
			while (rs_queryexecution.next()) {
				int query_number = rs_queryexecution.getInt(1);
				int queryexecution_number = rs_queryexecution.getInt(2);
				long cardinality = rs_queryexecution.getLong(3);
				long result_cardinality = rs_queryexecution.getLong(4);
				// int min_run_time = rs_queryexecution.getInt(4);
				int min_run_time = rs_queryexecution.getInt(5);
				vec_temp_result.add(query_number + "\t" + queryexecution_number
						+ "\t" + cardinality + "\t" + result_cardinality + "\t"
						+ min_run_time);
				if (map_query_runs.containsKey(query_number)) {
					Vector<Integer> vec_runs = map_query_runs.get(query_number);
					vec_runs.add(queryexecution_number);
				} else {
					Vector<Integer> new_runs = new Vector<Integer>();
					new_runs.add(queryexecution_number);
					map_query_runs.put(query_number, new_runs);
				}

				Element query_run_node = null;
				// if (queryexecution_number == -1) {
				// query_run_node = result_XML.createElement("optimalPlan");
				// } else {
				query_run_node = result_XML.createElement("queryexecution");
				// }
				query_run_node.setAttribute("executionTime", min_run_time + "");
				query_run_node.setAttribute("units", "milli seconds");
				query_run_node.setAttribute("planNumber", "999");
				query_run_node.setAttribute("phaseNumber", 1 + "");

				Element table = result_XML.createElement("table");
				table.setAttribute("name", "var_table");
				table.setAttribute("cardinality", cardinality + "");
				query_run_node.appendChild(table);

				Element query_result = map_query_result.get(query_number);
				query_result.appendChild(query_run_node);
			}
			// rs_queryexecution.close();
			rs_queryexecution.close();

			for (int i = 0; i < vec_temp_result.size(); i++) {
				String[] detail = vec_temp_result.get(i).split("\t");
				int query_num = Integer.parseInt(detail[0]);
				int queryexecution_num = Integer.parseInt(detail[1]);
				long cardinality = Long.parseLong(detail[2]);
				long result_cardinality = Long.parseLong(detail[3]);
				// int min_run_time = Integer.parseInt(detail[3]);
				int min_run_time = Integer.parseInt(detail[4]);
				User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
						.getQuery(query_num)
						// .insertqueryexecution(0, query_num,
						// queryexecution_num, cardinality, min_run_time);
						.insertQueryExecution(0, query_num, queryexecution_num,
								cardinality, result_cardinality, min_run_time,
								"", 0, Constants.SCENARIO_BASED_ON_QUERY);
			}

			Iterator<Integer> iter_queries = map_query_runs.keySet().iterator();
			while (iter_queries.hasNext()) {
				int query_num = iter_queries.next();
				Vector<Integer> vec_runs = map_query_runs.get(query_num);
				for (int i = 0; i < vec_runs.size(); i++) {
					int query_run_num = vec_runs.get(i);
					PlanNode plan_node = User.getUser(un).getNotebook(nn)
							.getExperiment(en).getRun(st).getQuery(query_num)
							.getPlan(query_run_num);
					// this is to be altered!!!
					int queryexecution_id = -1;
					User.getUser(un).getNotebook(nn).getExperiment(en).getRun(
							st).getQuery(query_num).insertPlan(query_num,
							query_run_num, queryexecution_id, plan_node);
				}
			}

			Element testResult = result_XML.createElement("testResult");
			result_XML.appendChild(testResult);

			XMLHelper.writeXMLToOutputStream(
					new FileOutputStream(myResultFile), result_XML
							.getDocumentElement());
			XMLHelper.readDocument(myResultFile);

			User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
					.insertExperimentRunResult(
							new FileInputStream(myResultFile));
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		//Main._logger.outputLog("Min Run Computed.");
	}

	public void createMedianExperimentRun(String un, String nn, String en,
			String db, Vector<String> vec_selected_runs) {
		try {
			File myResultFile = File.createTempFile("testResult", ".xml",
					new File(Constants.DIRECTORY_TEMP));
			myResultFile.deleteOnExit();
			insertExperimentRun(db, "MEDIAN RUN SUMMARY", "Completed", 100);
			String st = vec_selected_runs.get(0);
			int num_runs = vec_selected_runs.size();
			String sql_queries = "SELECT qr.QueryNumber, qr.QuerySQL "
					+ "FROM MetaData_EXPERIMENT ex, MetaData_EXPERIMENTRUN er, MetaData_QUERY qr "
					+ "WHERE ex.username = '" + un
					+ "' AND ex.notebookname = '" + nn + "' "
					+ "AND ex.experimentname = '" + en
					+ "' AND ex.experimentid = er.experimentid "
					+ "AND er.starttime = '" + st + "' AND er.runid = qr.runid";
			ResultSet rs_queries = LabShelfManager.getShelf().executeQuerySQL(
					sql_queries);
			HashMap<Integer, Element> map_query_result = new HashMap<Integer, Element>();
			HashMap<Integer, String> map_query_string = new HashMap<Integer, String>();
			Document result_XML = null;
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setIgnoringElementContentWhitespace(true);
			DocumentBuilder builder = factory.newDocumentBuilder();
			result_XML = builder.newDocument();
			while (rs_queries.next()) {
				int query_num = rs_queries.getInt(1);
				String query_string = rs_queries.getString(2);
				Element query_result = null;
				query_result = result_XML.createElement("queryResult");
				query_result.setAttribute("sql", query_string);
				map_query_result.put(query_num, query_result);
				map_query_string.put(query_num, query_string);
			}
			Iterator<Integer> iter_query_string = map_query_string.keySet()
					.iterator();
			while (iter_query_string.hasNext()) {
				int query_num = iter_query_string.next();
				String query_string = map_query_string.get(query_num);
				User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
						.insertQuery(un, nn, en, "MEDIAN RUN SUMMARY",
								query_num, query_string);
			}
			User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
					.analyzeAllQueries(un, nn, en, "MEDIAN RUN SUMMARY");

			String selected_runs = "";
			for (int i = 0; i < vec_selected_runs.size(); i++) {
				selected_runs += "'" + vec_selected_runs.get(i) + "'";
				if (i < vec_selected_runs.size() - 1) {
					selected_runs += ", ";
				}
			}

			String sql_queryexecution = "SELECT qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality, qn.RunTime "
					+ "FROM MetaData_EXPERIMENT ex, MetaData_EXPERIMENTRUN er, MetaData_QUERY qr, MetaData_queryexecution qn, MetaData_QRHASPLAN qp "
					+ "WHERE ex.UserName = '"
					+ un
					+ "' AND ex.NotebookName = '"
					+ nn
					+ "' AND ex.ExperimentName = '"
					+ en
					+ "' AND ex.experimentid = er.experimentid AND er.starttime IN ("
					+ selected_runs
					+ ") AND er.percentage = 100 AND er.currentstage='Completed' "
					+ "AND er.runid = qr.runid AND qr.queryid = qn.queryid AND qn.QueryExecutionID = qp.QueryExecutionID "
					+
					// "GROUP BY (qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality) "
					// +
					"ORDER BY qr.QueryNumber, qn.queryExecutionNumber, qn.Cardinality, qn.RunTime";

			ResultSet rs_queryexecution = LabShelfManager.getShelf()
					.executeQuerySQL(sql_queryexecution);

			HashMap<Integer, Vector<Integer>> map_query_runs = new HashMap<Integer, Vector<Integer>>();
			Vector<String> vec_temp_result = new Vector<String>();
			Vector<Integer> temp_times = new Vector<Integer>();
			int cycle = 0;
			while (rs_queryexecution.next()) {
				int query_number = rs_queryexecution.getInt(1);
				int queryexecution_number = rs_queryexecution.getInt(2);
				long cardinality = rs_queryexecution.getLong(3);
				int run_time = rs_queryexecution.getInt(4);
				temp_times.add(run_time);
				cycle++;
				if (cycle == num_runs) {
					cycle = 0;
					int median_id = temp_times.size() / 2;
					int median_runtime = temp_times.get(median_id);
					double delta_low = ((double) (median_runtime - temp_times
							.get(median_id - 1)) / (double) median_runtime)
							* ((double) (median_runtime - temp_times
									.get(median_id - 1)) / (double) median_runtime);
					if (median_id - 2 > 0) {
						delta_low += ((double) (median_runtime - temp_times
								.get(median_id - 2)) / (double) median_runtime)
								* ((double) (median_runtime - temp_times
										.get(median_id - 2)) / (double) median_runtime);
					}
					double var_low = Math.sqrt(delta_low);
					double delta_up = ((double) (median_runtime - temp_times
							.get(median_id + 1)) / (double) median_runtime)
							* ((double) (median_runtime - temp_times
									.get(median_id + 1)) / (double) median_runtime);
					if (median_id + 2 > temp_times.size() - 1) {
						delta_up += ((double) (median_runtime - temp_times
								.get(median_id + 2)) / (double) median_runtime)
								* ((double) (median_runtime - temp_times
										.get(median_id + 2)) / (double) median_runtime);
					}
					double var_up = -Math.sqrt(delta_up);
					//Main._logger.outputLog(queryexecution_number + "\t"
					//		+ var_low + "\t" + var_up);

					vec_temp_result.add(query_number + "\t"
							+ queryexecution_number + "\t" + cardinality + "\t"
							+ temp_times.get(median_id));
					if (map_query_runs.containsKey(query_number)) {
						Vector<Integer> vec_runs = map_query_runs
								.get(query_number);
						vec_runs.add(queryexecution_number);
					} else {
						Vector<Integer> new_runs = new Vector<Integer>();
						new_runs.add(queryexecution_number);
						map_query_runs.put(query_number, new_runs);
					}

					Element query_run_node = null;

					query_run_node = result_XML.createElement("queryexecution");
					query_run_node.setAttribute("executionTime", temp_times
							.get(median_id)
							+ "");
					query_run_node.setAttribute("units", "milli seconds");
					query_run_node.setAttribute("planNumber",
							queryexecution_number + "");
					query_run_node.setAttribute("phaseNumber", 1 + "");

					Element table = result_XML.createElement("table");
					table.setAttribute("name", "var_table");
					table.setAttribute("cardinality", cardinality + "");
					query_run_node.appendChild(table);

					Element query_result = map_query_result.get(query_number);
					query_result.appendChild(query_run_node);
					temp_times.clear();
				}
			}
			rs_queryexecution.close();

			for (int i = 0; i < vec_temp_result.size(); i++) {
				String[] detail = vec_temp_result.get(i).split("\t");
				int query_num = Integer.parseInt(detail[0]);
				int queryexecution_num = Integer.parseInt(detail[1]);
				long cardinality = Long.parseLong(detail[2]);
				long result_cardinality = Long.parseLong(detail[3]);
				// long test = Long.parseLong(detail[3]);
				// int median_run_time = Integer.parseInt(detail[3]);
				int median_run_time = Integer.parseInt(detail[4]);
				User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
						.getQuery(query_num)
						// .insertqueryexecution(0, query_num,
						// queryexecution_num, cardinality, median_run_time);
						// .insertQueryExecution(0, query_num,
						// queryexecution_num, cardinality, result_cardinality,
						// median_run_time);
						.insertQueryExecution(0, query_num, queryexecution_num,
								cardinality, result_cardinality,
								median_run_time, "", 0,
								Constants.SCENARIO_BASED_ON_QUERY);
			}

			Iterator<Integer> iter_queries = map_query_runs.keySet().iterator();
			while (iter_queries.hasNext()) {
				int query_num = iter_queries.next();
				Vector<Integer> vec_runs = map_query_runs.get(query_num);
				for (int i = 0; i < vec_runs.size(); i++) {
					int query_run_num = vec_runs.get(i);
					PlanNode plan_node = User.getUser(un).getNotebook(nn)
							.getExperiment(en).getRun(st).getQuery(query_num)
							.getPlan(query_run_num);
					// this is to be altered!!!
					int queryexecution_id = -1;
					User.getUser(un).getNotebook(nn).getExperiment(en).getRun(
							st).getQuery(query_num).insertPlan(query_num,
							query_run_num, queryexecution_id, plan_node);
				}
			}

			Element testResult = result_XML.createElement("testResult");
			result_XML.appendChild(testResult);

			XMLHelper.writeXMLToOutputStream(
					new FileOutputStream(myResultFile), result_XML
							.getDocumentElement());
			XMLHelper.readDocument(myResultFile);

			User.getUser(un).getNotebook(nn).getExperiment(en).getRun(st)
					.insertExperimentRunResult(
							new FileInputStream(myResultFile));
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		//Main._logger.outputLog("Median Run Computed.");
	}

	public static int getExperimentID(String userName, String notebookName,
			String experimentName) {
		int toret = -1;
		String strSQL = "SELECT ExperimentID " + "FROM "
				+ Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT + " "
				+ "WHERE UserName = '" + userName + "' AND NotebookName = '"
				+ notebookName + "' AND ExperimentName = '" + experimentName
				+ "'";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(strSQL);
			while (rs.next()) {
				toret = Integer.parseInt(rs.getString(1));
				break;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return toret;
	}
	
	/**
	 * 
	 * @return The number of Queries specified in the experimentSpec
	 */
	public int getNumberQueries() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("queryDefinitionReference");
		if (nlst == null) {
			nlst = elementExpDescription
					.getElementsByTagName("queryDefinition");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("numberQueries"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	/**********************************************************************************
	 * Parsing operationalization parameters
	 */
	/****
	 * Return minimum DBMS buffer cache size
	 * @return
	 */
	public double getDBMSBufferCacheMin() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("dbmsBufferCacheSize");
		if (nlst == null) {
			Main._logger.outputLog("no dbmsBufferCacheSize element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("min"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/****
	 * Return maximum DBMS buffer cache size
	 * @return
	 */
	public double getDBMSBufferCacheMax() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("dbmsBufferCacheSize");
		if (nlst == null) {
			Main._logger.outputLog("no dbmsBufferCacheSize element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("max"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/****
	 * Return the increment of DBMS buffer cache size
	 * @return
	 */
	public double getDBMSBufferCacheIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("dbmsBufferCacheSize");
		if (nlst == null) {
			Main._logger.outputLog("no dbmsBufferCacheSize element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	/****
	 * Checking how many cores should be enabled.
	 * @return
	 */
	public int getNumCores() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("multiCoreConfiguration");
		if (nlst == null) {
			Main._logger.outputLog("no core configuration element!");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("numberCores"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	/*****
	 * Batch run time
	 * @return
	 */
	public int getBatchRunTime() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("duration");
		if (nlst == null) {
			Main._logger.outputLog("no batchRun time element!");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("seconds"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	/**** 
	 * Return minimum transaction size represented by selectivity
	 * @return
	 */
	public double getTransactionSizeMin() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("xactSize");
		if (nlst == null) {
			Main._logger.outputLog("no xactSize element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("min"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/****
	 * Return maximum transaction size represented by selectivity
	 * @return
	 */
	public double getTransactionSizeMax() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("xactSize");
		if (nlst == null) {
			Main._logger.outputLog("no transaction size element!");
		}
		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("max"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/****
	 * Return the increment of transaction size represented by selectivity
	 * @return
	 */
	public int getTransactionSizeIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("xactSize");
		if (nlst == null) {
			Main._logger.outputLog("no transaction size element!");
		}
		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**** 
	 * Return minimum exclusive lock percentage
	 * @return
	 */
	public double getExclusiveLockPctMin() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("xLocks");
		if (nlst == null) {
			Main._logger.outputLog("no xLocks element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("min"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/****
	 * Return maximum transaction size represented by selectivity
	 * @return
	 */
	public double getExclusiveLockPctMax() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("xLocks");
		if (nlst == null) {
			Main._logger.outputLog("no xLocks element!");
		}
		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("max"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/****
	 * Return the increment of transaction size represented by selectivity
	 * @return
	 */
	public double getExclusiveLockPctIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("xLocks");
		if (nlst == null) {
			Main._logger.outputLog("no xLocks element!");
		}
		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	/****
	 * Return minimum MPL
	 * @return minimum MPL
	 */
	public int getMPLMin() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("multiProgrammingLevel");
		if (nlst == null) {
			Main._logger.outputLog("no multiProgrammingLevel element!");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("min"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return maximum MPL
	 * @return maximum MPL
	 */
	public int getMPLMax() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("multiProgrammingLevel");
		if (nlst == null) {
			Main._logger.outputLog("no multiProgrammingLevel element!");
		}
		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("max"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return the increment of MPL
	 * @return the increment of MPL
	 */
	public int getMPLIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("multiProgrammingLevel");
		if (nlst == null) {
			Main._logger.outputLog("no multiProgrammingLevel element!");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return minimum effective DB
	 * @return minimum effective DB
	 */
	public double getEffectiveDBMin() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("effectiveDB");
		if (nlst == null) {
			Main._logger.outputLog("no effective DB element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("min"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	/****
	 * Return maximum effective DB
	 * @return maximum effective DB
	 */
	public double getEffectiveDBMax() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("effectiveDB");
		if (nlst == null) {
			Main._logger.outputLog("no effectiveDB element!");
		}
		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("max"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return the increment of effective DB
	 * @return increment
	 */
	public double getEffectiveDBIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("effectiveDB");
		if (nlst == null) {
			Main._logger.outputLog("no effectiveDB element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return min srtTxnRate
	 * @return min srtTxnRate
	 */
	public double getShortXactRateMin() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("srtTxnRate");
		if (nlst == null) {
			Main._logger.outputLog("no srtTxnRate element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("min"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return max srtTxnRate 
	 * @return max srtTxnRate
	 */
	public double getShortXactRateMax() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("srtTxnRate");
		if (nlst == null) {
			Main._logger.outputLog("no srtTxnRate element!");
		}
		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("max"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/****
	 * Return the increment of short Xact Rate
	 * @return increment
	 */
	public double getShortXactRateIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("srtTxnRate");
		if (nlst == null) {
			Main._logger.outputLog("no short transaction rate element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	/*************************************************************/
	
	/************************************************************
	 * For compatibility with the preliminary studies
	 *************************************************************/
	public int getNumTerminals() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("terminalConfiguration");
		if (nlst == null) {
			Main._logger.outputLog("no terminal configuration element!");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("numberTerminals"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int getNumIncr() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("terminalConfiguration");
		if (nlst == null) {
			Main._logger.outputLog("no terminal configuration element!");
		}

		try {
			return Integer.parseInt(((Element) nlst.item(0))
					.getAttribute("increment"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 1;
	}

	public double getEffectiveDBSize() {
		NodeList nlst = elementExpDescription
				.getElementsByTagName("effectiveDBSz");
		if (nlst == null) {
			Main._logger.outputLog("no effective db size element!");
		}

		try {
			return Double.parseDouble(((Element) nlst.item(0))
					.getAttribute("ratio"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	/*************************************************************/
}
