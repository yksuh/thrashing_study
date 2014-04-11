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

import java.io.FileInputStream;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;

public class Notebook extends TableDefinition {

	private String user_name_;
	private String notebook_name_;
	private String create_date_;
	private String description_;

	// private Set<Experiment> experiments;

	public Notebook(String strUserName, String strNotebookName,
			String strDateCreate, String strDescription) {
		user_name_ = strUserName;
		notebook_name_ = strNotebookName;
		create_date_ = strDateCreate;
		description_ = strDescription;
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param analyticName
	 */
	public void deleteAnalytic(String analyticName) {

		boolean hasNotebook = false;

		if ((notebook_name_ != null) && (!notebook_name_.equals(""))) {
			hasNotebook = true;
		}

		String[] columnNames = null;
		String[] columnValues = null;
		int[] columnDataTypes = null;

		if (hasNotebook) {
			columnNames = new String[] { "UserName", "NotebookName",
					"AnalyticName" };
			columnValues = new String[] { user_name_, notebook_name_,
					analyticName };
			columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR };

		} else {
			columnNames = new String[] { "UserName", "AnalyticName" };
			columnValues = new String[] { user_name_, analyticName };
			columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR };
		}

		// This delete cascades
		LabShelfManager.getShelf().deleteRows(DEFINEDANALYTIC.TableName,
				columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param aspectName
	 */
	public void deleteAspect(String aspectName) {

		boolean hasNotebook = false;

		if ((notebook_name_ != null) && (!notebook_name_.equals(""))) {
			hasNotebook = true;
		}

		String[] columnNames = null;
		String[] columnValues = null;
		int[] columnDataTypes = null;

		if (hasNotebook) {
			columnNames = new String[] { "UserName", "NotebookName",
					"AspectName" };
			columnValues = new String[] { user_name_, notebook_name_,
					aspectName };
			columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR };

		} else {
			columnNames = new String[] { "UserName", "AspectName" };
			columnValues = new String[] { user_name_, aspectName };
			columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR };
		}

		// This delete cascades
		LabShelfManager.getShelf().deleteRows(DEFINEDASPECT.TableName,
				columnNames, columnValues, columnDataTypes);
		// myLabShelf.deleteRows(ASPECTVALUE.TableName, columnNames,
		// columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @return
	 */
	public List<Experiment> getAllExperiments() {
		Vector<Experiment> result = new Vector<Experiment>();

		Vector<String> vecExperimentNames = new Vector<String>();
		try {
			String sql = "Select ExperimentName, Scenario from "
					+ Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT
					+ " where userName = '" + user_name_
					+ "' and notebookName = '" + notebook_name_ + "' order by experimentName";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				vecExperimentNames.add(rs.getString(1));
			}

			rs.close();

			for (int i = 0; i < vecExperimentNames.size(); i++) {
				result.add(new Experiment(user_name_, notebook_name_,
						vecExperimentNames.get(i)));
			}
			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return result;
		}
	}

	public Experiment getExperiment(String experimentName) {
		for (Experiment e : getAllExperiments()) {
			if (e.getExperimentName().equals(experimentName)) {
				return e;
			}
		}
		return null;
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param analyticName
	 * @param analyticStyle
	 * @param createDate
	 * @param analyticDescription
	 * @param analyticSQL
	 * @return
	 */
	public boolean insertAnalytic(String analyticName, String analyticStyle,
			String createDate, String analyticDescription, String analyticSQL) {

		int analyticID = LabShelfManager.getShelf().getSequencialID(
				"SEQ_ANALYTICID");

		String clobColumnName = "AnalyticSQL";

		String[] columnNames = new String[] { "AnalyticID", "UserName",
				"NotebookName", "AnalyticName", "Style", "CreateDate",
				"Description" };

		String[] columnValues = new String[] { String.valueOf(analyticID),
				user_name_, notebook_name_, analyticName, analyticStyle,
				createDate, analyticDescription };

		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_DATE,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		LabShelfManager.getShelf().putDocument(DEFINEDANALYTIC.TableName,
				clobColumnName, columnNames, columnValues, dataTypes,
				analyticSQL);
		LabShelfManager.getShelf().commitlabshelf();

		return true;

	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param aspectName
	 * @param aspectStyle
	 * @param aspectDescription
	 * @param aspectSQL
	 * @return
	 */
	public boolean insertAspect(String aspectName, String aspectStyle,
			String aspectDescription, String aspectSQL) {

		int aspectID = LabShelfManager.getShelf().getSequencialID(
				"SEQ_ASPECTID");

		String clobColumnName = "AspectSQL";

		String[] columnNames = new String[] { "AspectID", "UserName",
				"NotebookName", "AspectName", "Style", "Description" };

		String[] columnValues = new String[] { String.valueOf(aspectID),
				user_name_, notebook_name_, aspectName, aspectStyle,
				aspectDescription };

		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		LabShelfManager.getShelf()
				.putDocument(DEFINEDASPECT.TableName, clobColumnName,
						columnNames, columnValues, dataTypes, aspectSQL);
		LabShelfManager.getShelf().commitlabshelf();

		return true;
	}

	/**
	 * @return the strUserName
	 */
	public String getUserName() {
		return user_name_;
	}

	/**
	 * @return the strNotebookName
	 */
	public String getNotebookName() {
		return notebook_name_;
	}

	/**
	 * @return the strDateCreate
	 */
	public String getCreateDate() {
		return create_date_;
	}

	/**
	 * @return the strDescription
	 */
	public String getDescription() {
		return description_;
	}

	/**
	 * 
	 * @param userName
	 * @param testID
	 * @param analyticName
	 * @param analyticValue
	 */
	public void insertAnalyticValueOf(int runID, String analyticName,
			String analyticValue) {

		int analyticID = User.getUser(user_name_).getAnalyticID(analyticName);

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

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 */
	public void deleteExperiment(String experimentName, String scenario) {
		String[] columnNames = new String[] { "UserName", "NotebookName",
				"ExperimentName", "Scenario" };
		String[] columnValues = new String[] { user_name_, notebook_name_,
				experimentName, scenario };
		int[] columnDataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		LabShelfManager.getShelf().deleteRows(EXPERIMENT.TableName,
				columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();

	}

	public List<Analytic> getAnalytics() {
		List<Analytic> analytics = LabShelfManager.getShelf().getAllAnalytics();
		Vector<Analytic> result = new Vector<Analytic>();
		for (Analytic a : analytics) {
			if (a.getNotebookName().equals(this.getNotebookName())
					&& a.getUserName().equals(this.getUserName())) {
				result.add(a);
			}
		}
		return result;
	}

	/**
	 * 
	 * @param scenarioName
	 * @param experimentName
	 * @param sourceFileName
	 * @param createDate
	 * @param xml_source
	 */
	public void insertExperiment(String scenarioName, String experimentName,
			String sourceFileName, String createDate, FileInputStream xml_source) {

		int experimentID = LabShelfManager.getShelf().getSequencialID(
				"SEQ_EXPERIMENTID");

		String clobColumnName = "SourceXML";
		String[] columns = new String[] { "ExperimentID", "UserName",
				"NotebookName", "ExperimentName", "Scenario", "SourceFileName",
				"CreateDate" };
		String[] columnValues = new String[] { String.valueOf(experimentID),
				user_name_, notebook_name_, experimentName, scenarioName,
				sourceFileName, createDate };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_DATE };

		// Upload the experiment into the DBMS.
		LabShelfManager.getShelf().putDocument(EXPERIMENT.TableName,
				clobColumnName, columns, columnValues, dataTypes, xml_source);
		LabShelfManager.getShelf().commitlabshelf();

	}

	public List<Analysis> getAllAnalysis() {
		Vector<Analysis> toRet = new Vector<Analysis>();
		try {
			String sql = "Select analysisName, AnalysisID from "
					+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS
					+ " where notebookName = '" + notebook_name_
					+ "' and userName = '" + user_name_ + "'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				toRet.add(new Analysis(user_name_, notebook_name_, rs
						.getString(1), rs.getInt(2)));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public Analysis getAnalysis(String analysisName) {
		try {
			String sql = "Select AnalysisID from " + Constants.TABLE_PREFIX
					+ Constants.TABLE_ANALYSIS + " where analysisName = '"
					+ analysisName + "' and notebookName = '" + notebook_name_
					+ "' and userName = '" + user_name_ + "'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return new Analysis(user_name_, notebook_name_, analysisName,
						rs.getInt(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<Paper> getAllPapers() {
		Vector<Paper> toRet = new Vector<Paper>();
		try {
			String sql = "Select paperID, paperName, Description from "
					+ Constants.TABLE_PREFIX + Constants.TABLE_PAPER
					+ " where username ='" + user_name_
					+ "' and notebookName = '" + notebook_name_ + "'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				toRet.add(new Paper(rs.getInt(1), user_name_, notebook_name_,
						rs.getString(2), rs.getString(3)));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public Paper getPaper(String paperName) {
		try {
			String sql = "Select paperID, Description from "
					+ Constants.TABLE_PREFIX + Constants.TABLE_PAPER
					+ " where paperName = '" + paperName
					+ "' and notebookName = '" + notebook_name_
					+ "' and username = '" + user_name_ + "'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return new Paper(rs.getInt(1), user_name_, notebook_name_,
						paperName, rs.getString(2));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
