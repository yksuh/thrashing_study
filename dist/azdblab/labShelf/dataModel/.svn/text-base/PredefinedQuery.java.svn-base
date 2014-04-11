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
import java.util.List;
import java.util.Vector;

import javax.swing.JOptionPane;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;

public class PredefinedQuery {
	private String strQueryName;
	private String strQuerySQL;
	private String strQueryDescription;
	private int queryID;
	private String strUserName;

	public PredefinedQuery(String userName, String queryName, String querySQL,
			String queryDescription, int queryID) {
		strQueryName = queryName;
		strQuerySQL = querySQL;
		strQueryDescription = queryDescription;
		this.queryID = queryID;
		strUserName = userName;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getQuerySQL() {
		return strQuerySQL;
	}

	public String getDescription() {
		return strQueryDescription;
	}

	public String getQueryName() {
		return strQueryName;
	}

	public int getQueryID() {
		return queryID;
	}

	public List<InstantiatedQuery> getInstantiatedInstances() {
		// InstantiatedQueryID", "UserName",
		// "NotebookName", "ExperimentName
		String sql = "Select InstantiatedQueryID, UserName, NotebookName, ExperimentName from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_INSTANTIATED_QUERY
				+ " where queryid = " + queryID;
		Vector<InstantiatedQuery> vecToRet = new Vector<InstantiatedQuery>();
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			while (rs.next()) {
				vecToRet.add(new InstantiatedQuery(queryID, rs.getInt(1), rs
						.getString(2), rs.getString(3), rs.getString(4),
						strQueryName));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vecToRet;

	}

	public static PredefinedQuery getPredefinedQuery(int qID) {
		String sql = "Select UserName, Query, Description, QueryName from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY
				+ " where queryID = " + qID;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return new PredefinedQuery(rs.getString(1), rs.getString(4), rs
						.getString(2), rs.getString(3), qID);
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public static void deleteQuery(int queryID) {
		LabShelfManager.getShelf().deleteRows(
				Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY,
				new String[] { "QueryID" },
				new String[] { String.valueOf(queryID) },
				new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER });
		// the cascade delete should take care of the rest of them (papers,
		// analysis, instQuery)
		LabShelfManager.getShelf().commit();
		LabShelfManager.getShelf().commitlabshelf();
	}

	/**
	 * This method determines whether or not it is ok to modify a given
	 * predefined query
	 * 
	 * It is ok to modify a predefined query if it is not associated with any
	 * Tables, Figures, or Analysis
	 * 
	 * @return
	 */
	public boolean checkModify() {
		String sql = "Select * from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_PREDEFINED_QUERY
				+ " pd, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_INSTANTIATED_QUERY
				+ " inst where pd.QueryID = "
				+ queryID
				+ " and pd.QueryID = inst.QueryID and (inst.InstantiatedQueryID in (select tb.InstantiatedQueryID from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_TABLE
				+ " tb) or inst.InstantiatedQueryID in (select fig.InstantiatedQueryID from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_FIGURE
				+ " fig) or inst.InstantiatedQueryID in (select aq.InstantiatedQueryID from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_QUERY
				+ " aq))";

		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		try {
			if (rs.next()) {
				return false;
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public static void addQuery(String description, String QuerySQL,
			String userName, String QueryName) {
		int queryID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_PREDEFINED_QUERY);
		try {
			if (description == null) {
				description = " ";
			}
			if (QuerySQL == null) {
				return;
			}
			LabShelfManager.getShelf().putDocument(
					Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY,
					"Query",
					new String[] { "QueryID", "Username", "Description",
							"QueryName" },
					new String[] { queryID + "", userName, description + " ",
							QueryName },
					new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR },
					QuerySQL.replace("\n", "  "));
			LabShelfManager.getShelf().commit();
			LabShelfManager.getShelf().commitlabshelf();
			JOptionPane.showMessageDialog(null, "Successfully added Query");
		} catch (Exception e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, "Failed to add Query");
		}
	}

	@Override
	public String toString() {
		return strQueryName;
	}
}
