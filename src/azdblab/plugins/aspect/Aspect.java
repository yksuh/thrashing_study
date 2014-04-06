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
package azdblab.plugins.aspect;

//import azdblab.MetaData;

import azdblab.executable.Main;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.model.dataDefinition.*;
import azdblab.model.experiment.ExperimentRun;
import azdblab.plugins.Plugin;
import azdblab.swingUI.objectNodes.ExperimentNode;
import azdblab.swingUI.objectNodes.NotebookNode;

import java.sql.SQLException;
import java.sql.ResultSet;

import java.util.List;
import java.util.Vector;

import azdblab.swingUI.objectNodes.CompletedRunNode;

import javax.swing.JPanel;

public abstract class Aspect extends Plugin{

	protected String strUserName;

	protected String strNotebookName;

	protected String strAspectName;

	// protected String strAspectValue;

	protected String strAspectSQL;

	protected String strAspectDescription;

	protected String strAspectTableName;

	// protected LabShelf myDBController;

	static private final String strAspectTempTablePrefix = "aspect_temp";

	/**
	 * The panel GUI used to specify the Aspect.
	 */
	protected JPanel panelAspectSpec;

	/**
	 * Table of Aspects for specific styles
	 */
	protected InternalTable TABLE_DEFINEDASPECTOFSTYLE;

	public Aspect(String user_name, String notebook_name, String aspect_name,
			String aspectDescription, String aspectSQL) {

		// myDBController = LabShelf.getShelf(MetaData.getLABUSERNAME(),
		// MetaData.getLABPASSWORD(), MetaData.getLABCONNECTSTRING());

		// myDBController = dbController;

		strUserName = user_name;
		strNotebookName = notebook_name;
		strAspectName = aspect_name;
		strAspectDescription = aspectDescription;
		strAspectSQL = aspectSQL;
		panelAspectSpec = null;

		createStyleTable();

	}

	protected void finalize() throws Throwable {
		// myDBController.close();
		super.finalize();
	}

	static public void processAspect(String userName, String notebookName,
			String experimentName,
			// String scenario,
			String startTime, String SQL, String aspectName, long optCard,
			long minCard, long maxCard, int count) {

		setupTempTable(userName, notebookName, experimentName, startTime,
				minCard, maxCard, count);

		compute(userName, notebookName, experimentName, startTime, SQL,
				aspectName, optCard, minCard, maxCard, count);

		deleteTempTable(count);

	}

	static public void computeAspect(String userName, String notebookName,
			String SQL, String aspectName) {

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
					Vector<ExperimentNode> vecExpMod = new Vector<ExperimentNode>();
					Notebook current_notebook = User
							.getUser(userName).getNotebook(tmpNotebookName);

					List<Experiment> experiments = current_notebook
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
						ExperimentRun experimentRun = tmpexpmod
								.getMyExperimentRun();

						Experiment current_experiment = current_notebook
								.getExperiment(expname);
						// for ( int k = 0; k < tests.length; k++ ) {

						// int testnum = tests[k].getTestNumber();

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
						tmpexpmod.processXML();
						DataDefinition tmpdatadef = experimentRun
								.getDataDefinition();
						long optCard = tmpdatadef
								.getTableCardinality(experimentRun
										.getVariableTables()[0].table_name);
						long minCard = experimentRun
								.getVarTableMinCardinality();
						long maxCard = experimentRun
								.getVarTableMaxCardinality();

						for (int l = 0; l < vecRuns.size(); l++) {

							CompletedRunNode expRun = vecRuns.get(l);

							processAspect(userName, tmpNotebookName, expname,
									expRun.getStartTime(), SQL, aspectName,
									optCard, minCard, maxCard, count);

							count++;

						}

					}

				}

				// NOTEBOOK level, both user name and notebook name are
				// available.
			} else {

				int count = 0;
				Notebook current_notebook = User.getUser(
						userName).getNotebook(notebookName);
				Vector<ExperimentNode> vecExpMod = new Vector<ExperimentNode>();
				List<Experiment> experiments = current_notebook
						.getAllExperiments();
				for (Experiment e : experiments) {
					vecExpMod.add(new ExperimentNode(e.getExperimentSource(), e
							.getUserName(), e.getNotebookName()));
				}

				for (int j = 0; j < vecExpMod.size(); j++) {

					ExperimentNode tmpexpmod = vecExpMod.get(j);
					String expname = tmpexpmod.getExperimentName();
					// String scenario = tmpexpmod.getScenario();
					tmpexpmod.processXML();
					ExperimentRun experimentRun = tmpexpmod
							.getMyExperimentRun();
					Experiment current_experiment = current_notebook
							.getExperiment(expname);
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
					DataDefinition tmpdatadef = experimentRun
							.getDataDefinition();
					long optCard = tmpdatadef.getTableCardinality(experimentRun
							.getVariableTables()[0].table_name);
					long minCard = experimentRun.getVarTableMinCardinality();
					long maxCard = experimentRun.getVarTableMaxCardinality();

					for (int l = 0; l < vecRuns.size(); l++) {

						CompletedRunNode expRun = vecRuns.get(l);

						processAspect(userName, notebookName, expname, expRun
								.getStartTime(), SQL, aspectName, optCard,
								minCard, maxCard, count);

						count++;

					}

				}

			}

			Main._logger.outputLog("Aspect Computing finished.");

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	public void setAspectName(String aspect_name) {
		strAspectName = aspect_name;
	}

	static private void setupTempTable( // LabShelf dbcontroller,
			String userName, String notebookName, String experimentName,
			// String scenario,
			String startTime, long granularity, long maxCard, int count) {

		try {

			String tabName = strAspectTempTablePrefix + "_" + count + "";

			// Main._logger.outputLog("-- Preparing for temporary aspect table :"
			// + tabName);

			if (LabShelfManager.getShelf().tableExists(tabName)) {
				String strDel = "DROP TABLE " + tabName;
				LabShelfManager.getShelf().executeUpdateQuery(strDel);
			}

			int runID =User.getUser(userName)
					.getNotebook(notebookName).getExperiment(experimentName)
					.getRun(startTime).getRunID();

			String tempSQL = "CREATE TABLE " + tabName + " AS "
					+ "SELECT distinct " + "qr.QUERYID, " + "ct.CARDINALITY, "
					+ "ct.queryExecutionNumber, " + "pn.PLANID,"
					+ "avg(ct.RUNTIME) as RunTime, avg(qea.totalDbmsTime) as totalDBMSTime " +

					" FROM AZDBLAB_QUERY qr, " + "AZDBLAB_QUERYEXECUTION ct, "
					+ "AZDBLAB_QUERYEXECUTIONHASPLAN pn, AZDBLAB_QUERYEXECUTIONASPECT qea " +

					" WHERE qr.RUNID = " + runID
					+ " AND qr.QUERYID = ct.QUERYID "
					+ " AND ct.QueryExecutionID = pn.QueryExecutionID AND qea.queryexecutionid = ct.queryexecutionid " +
					// Make this into an option in the GUI 
					//TODO
					" and qea.stoppedprocesses = 0 and qea.numphantomspresent = 0 " +
					" group by qr.queryid, ct.cardinality, ct.queryexecutionnumber, pn.planid";

			LabShelfManager.getShelf().executeUpdateQuery(tempSQL);

			String sampleTabName = strAspectTempTablePrefix + "_sample_"
					+ count + "";

			if (LabShelfManager.getShelf().tableExists(sampleTabName)) {
				String strDel = "DROP TABLE " + sampleTabName;
				LabShelfManager.getShelf().executeUpdateQuery(strDel);
			}

			String tempSampleSQL = "CREATE TABLE " + sampleTabName
					+ " (CARDINALITY NUMBER)";
			LabShelfManager.getShelf().executeUpdateQuery(tempSampleSQL);

			for (long card = granularity; card <= maxCard; card += granularity) {
				String insertValue = "INSERT INTO " + sampleTabName
						+ " VALUES(" + card + ")";
				LabShelfManager.getShelf().executeUpdateQuery(insertValue);
			}

			Main._logger.outputLog("temp table setup");

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

	}

	static private void deleteTempTable( // LabShelf dbcontroller,
			// String userName,
			// String notebookName,
			// String experimentName,
			// String testNumber,
			// String experimentTime,
			int count) {

		try {
			String tabName = strAspectTempTablePrefix + "_" + count + "";
			String strDel = "DROP TABLE " + tabName;
			LabShelfManager.getShelf().executeUpdateQuery(strDel);

			String sampleTabName = strAspectTempTablePrefix + "_sample_"
					+ count + "";
			strDel = "DROP TABLE " + sampleTabName;
			LabShelfManager.getShelf().executeUpdateQuery(strDel);

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	static private void compute(
			// InternalDatabaseController dbcontroller,
			String userName, String notebookName, String experimentName,
			String startTime, String SQL, String aspectName, long optCard,
			long minCard, long maxCard, int count) {

		Main._logger.outputLog("Optimal Card: " + optCard);
		Main._logger.outputLog("Computing Aspect For [" + experimentName
				+ "] at [" + startTime + "]");

		try {
			String tabName = strAspectTempTablePrefix + "_" + count + "";
			String sampleTable = strAspectTempTablePrefix + "_sample_" + count
					+ "";

			// String sql = "SELECT distinct c1.QUERYNUMBER, c1.QUERYSQL " +
			// "FROM " + tabName + " c1, " + tabName + " c2, " + tabName +
			// " c3 " +
			// "WHERE c1.CARDINALITY > c2.CARDINALITY " +
			// "AND c2.CARDINALITY > c3.CARDINALITY " +
			// "AND c3.CARDINALITY > 100000 " +
			// "AND c1.PLANNUMBER = c3.PLANNUMBER " +
			// "AND NOT (c1.PLANNUMBER = c2.PLANNUMBER) " +
			// "AND c1.QUERYNUMBER = c2.QUERYNUMBER " +
			// "AND c1.QUERYNUMBER = c3.QUERYNUMBER " +
			// "ORDER BY c1.QUERYNUMBER";

			String sql = SQL.replaceAll("_QueryInfo", tabName);
			sql = sql.replaceAll("_CardinalitySample", sampleTable);
			sql = sql.replaceAll("_OPTCARD", String.valueOf(optCard));
			sql = sql.replaceAll("_MINCARD", String.valueOf(minCard));
			sql = sql.replaceAll("_MAXCARD", String.valueOf(maxCard));

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);

			if (rs == null) {
				Main._logger.outputLog("No such result!");
			}

			Vector<Integer> vecQueryID = new Vector<Integer>();

			Vector<Long> vecAspValue = new Vector<Long>();

			// Vector<Long> vecAspValue2 = new Vector<Long>();

			while (rs.next()) {
				vecQueryID.add(rs.getInt(1));
				vecAspValue.add(rs.getLong(2));
				// vecAspValue2.add(rs.getLong(3));
			}

			rs.close();

			for (int i = 0; i < vecQueryID.size(); i++) {

				int queryID = vecQueryID.get(i);

				long aspValue = vecAspValue.get(i);

				User.getUser(userName)
						.insertSatisfiedAspect(queryID, aspectName, aspValue);

				Main._logger.outputLog(queryID + "\t" + vecAspValue.get(i));

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
	public void finalizeAspect() {

		storeDefinedAspect();

		storeSpecification();

		computeAspect(strUserName, strNotebookName, strAspectSQL, strAspectName);

	}

	protected abstract boolean storeDefinedAspect();

	public abstract boolean storeSpecification();

	public static String getAspectStyleName() {
		return "ASPECT";
	};

	// private String getDescription() {
	// return "TEMPORARY DESCRIPTION";
	// }
	// public abstract String getSQLQuery();
	protected abstract void getAspectDetails();

	protected abstract void createStyleTable();

	public abstract JPanel getNewSpecificationPanel(JPanel panelStyleSelect);

	public abstract JPanel getExistingSpecificationPanel(JPanel panelStyleSelect);

	public abstract void insertAspect(String userName, String notebookName,
			String aspectName, String aspectStyle, String aspectDescription,
			String aspectSQL);

	public abstract void deleteAspect(String userName, String notebookName,
			String aspectName);

}
