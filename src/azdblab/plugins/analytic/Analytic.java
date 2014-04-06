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
package azdblab.plugins.analytic;

import azdblab.Constants;
import azdblab.plugins.Plugin;
import azdblab.swingUI.objectNodes.CompletedRunNode;
import azdblab.swingUI.objectNodes.AspectDefinitionNode;
import azdblab.executable.Main;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.objectNodes.ExperimentNode;
import azdblab.swingUI.objectNodes.NotebookNode;

import java.io.FileNotFoundException;
import java.io.Reader;
import java.sql.Clob;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.List;
import java.util.Vector;
import javax.swing.JPanel;

public abstract class Analytic extends Plugin {

	protected String strUserName;

	protected String strNotebookName;

	protected String strAnalyticName;

	protected String strAnalyticDescription;

	protected String strAnalyticSQL;

	protected String strAnalyticTableName;
	// protected LabShelf myDBController;

	protected static final String strTableNamePrefix = "DEFINEDANALYTICOF_";

	static protected final String strAnalyticTempTablePrefix = "analytic_temp";
	/**
	 * The panel GUI used to specify the Aspect.
	 */
	protected JPanel panelAnalyticSpec;

	/**
	 * Table of Aspects for specific styles
	 */
	protected InternalTable TABLE_DEFINEDANALYTICOFSTYLE;

	public Analytic(String userName, String notebookName, String analyticName,
			String analyticDescription, String analyticSQL) {

		// myDBController = LabShelf.getShelf(MetaData.getLABUSERNAME(),
		// MetaData.getLABPASSWORD(), MetaData.getLABCONNECTSTRING());
		// myDBController.OpenLabShelf();

		// myDBController = dbController;
		strUserName = userName;
		strNotebookName = notebookName;
		strAnalyticName = analyticName;

		strAnalyticDescription = analyticDescription;
		strAnalyticSQL = analyticSQL;

		panelAnalyticSpec = null;

		createStyleTable();

	}

	protected void finalize() throws Throwable {
		// myDBController.close();
		super.finalize();
	}

	public void setAnalyticName(String analytic_name) {
		strAnalyticName = analytic_name;
	}

	static public void processAnalytic(String userName, String notebookName,
			String experimentName,
			// String scenario,
			String startTime,
			// int testNumber,
			String SQL, String analyticName, int count) {

		setupTempTable(userName, notebookName, experimentName, startTime, count);

		compute(userName, notebookName, experimentName, startTime, SQL,
				analyticName, count);

		deleteTempTable(count);

	}

	static public void computeAnalytic(String userName, String notebookName,
			String SQL, String analyticName) {

		try {

			// USER level, where no notebook is specified.
			if (notebookName == null || notebookName.equals("")) {

				int count = 0;
				Vector<NotebookNode> vecNotebooks = new Vector<NotebookNode>();
				List<Notebook> notebooks = User
						.getUser(userName).getNotebooks();
				for (Notebook n : notebooks) {
					NotebookNode lnn = new NotebookNode(n.getUserName(), n
							.getNotebookName(), n.getDescription());
					vecNotebooks.add(lnn);
				}
				for (int i = 0; i < vecNotebooks.size(); i++) {

					NotebookNode tmpNotebookNode = vecNotebooks.get(i);
					String tmpNotebookName = tmpNotebookNode.getNotebookName();
					Notebook current_notebook = User
							.getUser(userName).getNotebook(tmpNotebookName);

					Vector<ExperimentNode> vecExpMod = new Vector<ExperimentNode>();
					List<Experiment> experiments = User
							.getUser(userName).getNotebook(tmpNotebookName)
							.getAllExperiments();
					for (Experiment e : experiments) {
						vecExpMod.add(new ExperimentNode(e
								.getExperimentSource(), e.getUserName(), e
								.getNotebookName()));
					}

					for (int j = 0; j < vecExpMod.size(); j++) {

						ExperimentNode tmpexpmod = vecExpMod.get(j);
						String expname = tmpexpmod.getExperimentName();
						// String scenario = tmpexpmod.getScenario();
						// ExperimentRun tests = tmpexpmod.getMyTests();
						Experiment current_experiment = current_notebook
								.getExperiment(expname);

						List<Run> runs = current_experiment
								.getCompletedRuns();
						Vector<CompletedRunNode> vecRuns = new Vector<CompletedRunNode>();

						for (Run r : runs) {
							CompletedRunNode crn = new CompletedRunNode(r
									.getUserName(), r.getNotebookName(), r
									.getExperimentName(), r.getScenario(), r
									.getMachineName(), r.getDBMS(), r
									.getStartTime());
							vecRuns.add(crn);
						}
						for (int l = 0; l < vecRuns.size(); l++) {

							CompletedRunNode expRun = vecRuns.get(l);

							processAnalytic(userName, tmpNotebookName, expname,
									expRun.getStartTime(), SQL, analyticName,
									count);

							count++;

						}

					}

				}

				// NOTEBOOK level, both user name and notebook name are
				// available.
			} else {

				int count = 0;

				Vector<ExperimentNode> vecExpMod = new Vector<ExperimentNode>();
				List<Experiment> experiments = User
						.getUser(userName).getNotebook(notebookName)
						.getAllExperiments();
				for (Experiment e : experiments) {
					vecExpMod.add(new ExperimentNode(e.getExperimentSource(), e
							.getUserName(), e.getNotebookName()));
				}
				Notebook current_notebook =User.getUser(
						userName).getNotebook(notebookName);
				for (int j = 0; j < vecExpMod.size(); j++) {

					ExperimentNode tmpexpmod = vecExpMod.get(j);
					String expname = tmpexpmod.getExperimentName();
					// String scenario = tmpexpmod.getScenario();
					Experiment current_experiment = current_notebook
							.getExperiment(expname);
					// ExperimentRun[] tests = tmpexpmod.getMyTests();

					// for ( int k = 0; k < tests.length; k++ ) {

					// int testnum = tests[k].getTestNumber();
					List<Run> runs = current_experiment.getCompletedRuns();
					Vector<CompletedRunNode> vecRuns = new Vector<CompletedRunNode>();

					for (Run r : runs) {
						CompletedRunNode crn = new CompletedRunNode(r
								.getUserName(), r.getNotebookName(), r
								.getExperimentName(), r.getScenario(), r
								.getMachineName(), r.getDBMS(), r
								.getStartTime());
						vecRuns.add(crn);
					}

					for (int l = 0; l < vecRuns.size(); l++) {

						CompletedRunNode expRun = vecRuns.get(l);

						processAnalytic(userName, notebookName, expname, expRun
								.getStartTime(), SQL, analyticName, count);

						count++;

					}

				}

			}

			Main._logger.outputLog("Analytic Computing finished.");

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	static private void setupTempTable(String userName, String notebookName,
			String experimentName,
			// String scenario,
			String startTime, int count) {

		try {

			String tabName = strAnalyticTempTablePrefix;

			// Main._logger.outputLog("-- Preparing for temporary analytic table :"
			// + tabName);

			if (LabShelfManager.getShelf().tableExists(tabName)) {
				String strDel = "DROP TABLE " + tabName;
				LabShelfManager.getShelf().executeUpdateQuery(strDel);
			}

			/*
			 * String tempSQL = "CREATE TABLE " + tabName + " AS " +
			 * "SELECT DISTINCT ex.UserName, " + "ex.NotebookName, " +
			 * "ex.ExperimentName, " + "er.CreateTime, " + "tt.TestNumber, " +
			 * "qr.QueryNumber, " + "da.AspectName " + "FROM " +
			 * AZDBLAB.TABLE_PREFIX + AZDBLAB.TABLE_EXPERIMENT + " " + "ex, " +
			 * AZDBLAB.TABLE_PREFIX + AZDBLAB.TABLE_EXPERIMENTRUN + " " + "er, "
			 * + AZDBLAB.TABLE_PREFIX + AZDBLAB.TABLE_TEST + " " + "tt, " +
			 * AZDBLAB.TABLE_PREFIX + AZDBLAB.TABLE_QUERY + " " + "qr, " +
			 * AZDBLAB.TABLE_PREFIX + AZDBLAB.TABLE_DEFINEDASPECT + " " + "da, "
			 * + AZDBLAB.TABLE_PREFIX + AZDBLAB.TABLE_SATISFIESASPECT + " " +
			 * "st " + "WHERE ex.ExperimentID = er.ExperimentID " +
			 * "AND er.RunID = tt.RunID " + "AND tt.TestID = qr.TestID " +
			 * "AND qr.QueryID = st.QueryID " + "AND st.AspectID = da.AspectID "
			 * + "AND ex.UserName = '" + user_name + "'";
			 */

			int runID = User.getUser(userName)
					.getNotebook(notebookName).getExperiment(experimentName)
					.getRun(startTime).getRunID();

			String tempSQL = "CREATE TABLE " + tabName + " AS "
					+ "SELECT DISTINCT qr.RunID, " + "qr.QueryID, "
					+ "da.AspectName, " + "st.AspectValue " +

					"FROM " + Constants.TABLE_PREFIX + Constants.TABLE_QUERY
					+ " " + "qr, " + Constants.TABLE_PREFIX
					+ Constants.TABLE_DEFINEDASPECT + " " + "da, "
					+ Constants.TABLE_PREFIX + Constants.TABLE_SATISFIESASPECT
					+ " " + "st " +

					"WHERE qr.RunID = " + runID
					+ "AND qr.QueryID = st.QueryID "
					+ "AND st.AspectID = da.AspectID";

			LabShelfManager.getShelf().executeUpdateQuery(tempSQL);

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

	}

	static private void deleteTempTable(// String userName,
			// String notebookName,
			// String experimentName,
			// String testNumber,
			// String experimentTime,
			int count) {

		try {

			String tabName = strAnalyticTempTablePrefix;

			String strDel = "DROP TABLE " + tabName;
			LabShelfManager.getShelf().executeUpdateQuery(strDel);

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	static private void compute(String userName, String notebookName,
			String experimentName, String startTime, String SQL,
			String analyticName, int count) {

		try {

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(SQL);

			ResultSetMetaData rsmd;

			rsmd = rs.getMetaData();

			int numCol = rsmd.getColumnCount();

			String[] columns = new String[numCol];

			for (int i = 0; i < numCol; i++) {
				columns[i] = rsmd.getColumnName(i + 1);
				Main._logger.outputLog(columns[i] + "\t");
			}

			Main._logger.outputLog("");

			Vector<String> vecResult = new Vector<String>();

			while (rs.next()) {

				String currentResult = "";
				for (int i = 0; i < numCol; i++) {
					currentResult += rs.getString(i + 1) + "\t";
				}
				vecResult.add(currentResult);
				Main._logger.outputLog(currentResult);

			}

			rs.close();

			for (int i = 0; i < vecResult.size(); i++) {
				String[] content = vecResult.get(i).split("\t");
				User.getUser(userName).getNotebook(
						notebookName).insertAnalyticValueOf(
						Integer.parseInt(content[0]), analyticName, content[1]);
			}

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

	}

	/**
	 * Finalize the definition of aspect. stores the description
	 * 
	 * @param description
	 */
	protected void finalizeAnalytic() {

		boolean finishDef = storeDefinedAnalytic();

		boolean finishSpec = storeSpecification();

		if (!finishDef || !finishSpec) {
			// deleteAnalytic();
		}

	}

	protected abstract boolean storeDefinedAnalytic();

	public abstract boolean storeSpecification();

	public static String getAnalyticStyleName() {
		return "ANALYTIC";
	};

	protected abstract void getAnalyticDetails();

	protected abstract void createStyleTable();

	public abstract JPanel getNewSpecificationPanel(JPanel panel_styleselect);

	public abstract JPanel getExistingSpecificationPanel(
			JPanel panel_styleselect);

	public void deleteAnalytic() {
		User.getUser(strUserName).getNotebook(
				strNotebookName).deleteAnalytic(strAnalyticName);
	}

	public abstract void insertAnalytic(String strUserName,
			String strNotebookName, String strAnalyticName,
			String strAnalyticStyleName, String Date,
			String strAnalyticDescription, String strAnalyticSQL);

	public abstract void deleteAnalytic(String userName, String notebookName,
			String analyticName);

	/**
	 * 
	 * @return
	 */
	public List<AspectDefinitionNode> getAllAspects() {

		Vector<AspectDefinitionNode> result = new Vector<AspectDefinitionNode>();

		String columnName = "UserName, " + "NotebookName, " + "AspectName, "
				+ "Style, " + "Description, " + "AspectSQL";

		String[] columnNames = new String[] {};
		String[] columnValues = new String[] {};
		int[] dataTypes = new int[] {};

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
					Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT,
					new String[] { columnName }, columnNames, columnValues,
					dataTypes);

			while (rs.next()) {

				String userName = rs.getString(1);
				String notebookName = rs.getString(2);
				String aspectName = rs.getString(3);
				String aspectStyle = rs.getString(4);
				String aspectDescription = rs.getString(5);
				Clob clob = rs.getClob(6);

				if (clob == null) {

				}

				char[] data = new char[1024];

				Reader reader = clob.getCharacterStream();

				StringBuffer strbuf = new StringBuffer();

				for (int len; (len = reader.read(data, 0, 1024)) > 0; strbuf
						.append(data, 0, len))
					;

				String aspectSQL = new String(strbuf);

				AspectDefinitionNode aspnode = new AspectDefinitionNode(
						userName, notebookName, aspectName, aspectStyle,
						aspectDescription, aspectSQL);
				result.add(aspnode);
			}

			rs.close();

			return result;

		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

}
