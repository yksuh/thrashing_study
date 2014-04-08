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

import java.io.InputStream;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;

import javax.swing.JOptionPane;

import oracle.jdbc.OracleResultSet;
import oracle.sql.CLOB;
import plugins.OracleSubject;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;

public class Analysis {
	private String strUserName;
	private String strAnalysisName;
	private int analysisID;
	private String strNotebookName;

	public Analysis(String userName, String notebookName, String analysisName,
			int analysisID) {
		strUserName = userName;
		strAnalysisName = analysisName;
		this.analysisID = analysisID;
		strNotebookName = notebookName;
	}

	public static Analysis getAnalysis(int analysisID) {
		String sql = "Select userName, notebookName, analysisName from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS
				+ " where analysisID = " + analysisID;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return new Analysis(rs.getString(1), rs.getString(2), rs
						.getString(3), analysisID);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Inserts an analysis
	 * 
	 * @param analysisName
	 * @param userName
	 * @param notebookName
	 * @return 0 on success, -1 on failure
	 */
	public static int insertAnalysis(String analysisName, String userName,
			String notebookName) {
		Integer analysisID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_ANALYSIS);
		try {
			LabShelfManager.getShelf()
					.insertTupleToNotebook(
							Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS,
							new String[] { "UserName", "AnalysisName",
									"AnalysisID", "NotebookName", "isFrozen" },
							new String[] { userName, analysisName,
									String.valueOf(analysisID), notebookName,
									"FALSE" },
							new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_NUMBER,
									GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_VARCHAR });
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public void insertQueryIntoAnalysis(int InstqueryID) {
		try {
			int dataTypes[] = { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER };
			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_QUERY,
					new String[] { "AnalysisID", "InstantiatedQueryID" },
					new String[] { String.valueOf(analysisID),
							String.valueOf(InstqueryID) }, dataTypes);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void freezeAnalysis() throws Exception {
		String sql = "update " + Constants.TABLE_PREFIX
				+ Constants.TABLE_ANALYSIS
				+ " set isFrozen = 'TRUE' where analysisID = " + analysisID;
			LabShelfManager.getShelf().executeUpdateQuery(sql);
	}

	public List<InstantiatedQuery> getAnalysisQuerys() {
		Vector<Integer> vecInstIDs = new Vector<Integer>();
		Vector<InstantiatedQuery> vecAnalysisQuerys = new Vector<InstantiatedQuery>();
		try {
			String sql = "Select InstantiatedQueryID from "
					+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_QUERY
					+ " where analysisID = " + analysisID;
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				vecInstIDs.add(rs.getInt(1));
			}
			rs.close();
			for (int i = 0; i < vecInstIDs.size(); i++) {
				vecAnalysisQuerys.add(InstantiatedQuery
						.getInstantiatedQuery(vecInstIDs.get(i)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vecAnalysisQuerys;
	}

	public List<InstantiatedQuery> getQueriesForAnalysis() {
		List<InstantiatedQuery> myQuerys = getAnalysisQuerys();
		List<InstantiatedQuery> allQuerys = User.getUser(strUserName)
				.getInstantiatedQuerys();
		Vector<InstantiatedQuery> toRet = new Vector<InstantiatedQuery>();
		for (int i = 0; i < allQuerys.size(); i++) {
			boolean toAdd = true;
			for (int j = 0; j < myQuerys.size(); j++) {
				if (allQuerys.get(i).getInstantiatedQueryID() == myQuerys
						.get(j).getInstantiatedQueryID()) {
					toAdd = false;
				}
			}
			if (toAdd) {
				toRet.add(allQuerys.get(i));
			}
		}
		return toRet;
	}

	public boolean getModifiable() {
		String sql = "Select isFrozen from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_ANALYSIS + " where analysisID = "
				+ analysisID;
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		try {
			if (rs.next()) {
				boolean isModifiable = rs.getString(1).equalsIgnoreCase("false");
				rs.close();
				return isModifiable;
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public String getScript(String scriptName) {
		String scriptText = "";

		String sql = "SELECT ScriptText FROM AZDBLAB_ANALYSISSCRIPT WHERE AnalysisID="
				+ analysisID + " AND ScriptName='" + scriptName + "'";
		try {
			ResultSet rs = ((OracleSubject) LabShelfManager.getShelf())
					.executeQuerySQL(sql);

			rs.next();
			CLOB clob = ((OracleResultSet) rs).getCLOB(1);
			byte data[] = new byte[1024];
			InputStream in = clob.getAsciiStream();

			while (in.read(data, 0, 1024) > 0) {
				scriptText += new String(data);
			}
			in.close();
			rs.close();
		} catch (Exception x) {
			x.printStackTrace();
		}
		return scriptText;
	}

	public void insertScript(String scriptName, String scriptType,
			String scriptText) {
		if (scriptName.equals("")) {
			JOptionPane.showMessageDialog(null,
					"You must specify a script name");
			return;
		}
		int dataTypes[] = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {

			LabShelfManager.getShelf().putDocument(
					Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_SCRIPT,
					"ScriptText",
					new String[] { "AnalysisID", "ScriptName", "ScriptType" },
					new String[] { analysisID + "", scriptName, scriptType },
					dataTypes, scriptText);
			LabShelfManager.getShelf().commit();
			LabShelfManager.getShelf().commitlabshelf();

			JOptionPane.showMessageDialog(null, "Successfully inserted script");
		} catch (Exception e) {
			JOptionPane.showMessageDialog(null, "Failed to insert script");
			e.printStackTrace();
		}
	}

	public List<Script> getScripts() {
		Vector<Script> toRet = new Vector<Script>();

		try {
			String sql = "Select * from " + Constants.TABLE_PREFIX
					+ Constants.TABLE_ANALYSIS_SCRIPT + " where AnalysisID = "
					+ analysisID;
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				toRet.add(new Script(rs.getString(2), rs.getString(3),
						analysisID));
			}

			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public List<AnalysisRun> getAnalysisRuns() {
		Vector<AnalysisRun> toRet = new Vector<AnalysisRun>();
		String sql = "select DATERUN, ANALYSISRUNID from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RUN
				+ " where analysisID = " + analysisID;
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		try {
			while (rs.next()) {
				toRet.add(new AnalysisRun(new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(1)), rs.getInt(2)));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getAnalysisName() {
		return strAnalysisName;
	}

	public int getAnalysisID() {
		return analysisID;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public class Script {
		private String scriptName;
		private String scriptType;
		private int analysisID;

		public Script(String scriptName, String scriptType, int analysisID) {
			this.scriptName = scriptName;
			this.scriptType = scriptType;
			this.analysisID = analysisID;
		}

		@Override
		public String toString() {
			return scriptName;
		}

		public String getScriptName() {
			return scriptName;
		}

		public String getScriptType() {
			return scriptType;
		}

		public int getAnalysisID() {
			return analysisID;
		}
	}

	public class AnalysisRun {
		private String dateRun;
		private int AnalysisRunID;

		public AnalysisRun(String dateRun, int AnalysisRunID) {
			this.dateRun = dateRun;
			this.AnalysisRunID = AnalysisRunID;
		}

		@Override
		public String toString() {
			return dateRun;
		}

		public String getDateTimeRun() {
			return dateRun;
		}

		public int getAnalysisRunID() {
			return AnalysisRunID;
		}
	}

}
