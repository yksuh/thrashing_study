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
import java.io.FileWriter;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.swingUI.AZDBLabObserver;

public class InstantiatedQuery {
	private int queryID;
	private int InstantiatedQueryID;
	private String paramUserName;
	private String paramNotebookName;
	private String paramExperimentName;
	private String queryName;

	public InstantiatedQuery(int queryID, int InstantatedQueryID,
			String paramUserName, String paramNotebookName,
			String paramExperimentName, String QueryName) {
		this.queryID = queryID;
		this.InstantiatedQueryID = InstantatedQueryID;
		this.paramUserName = paramUserName;
		this.paramNotebookName = paramNotebookName;
		this.paramExperimentName = paramExperimentName;
		this.queryName = QueryName;
	}

	public String getHTMLOutput() throws Exception {
		return getHTMLOutput(getInstantiatedSQL());
	}

	public static String getHTMLOutput(String query) throws Exception {
		String html = "<HTML><BODY>";
		html += "<table border=\"1\"";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(query);
		ResultSetMetaData rsmd = rs.getMetaData();
		html += "<tr>";
		for (int i = 0; i < rsmd.getColumnCount(); i++) {
			html += "<th> " + rsmd.getColumnName((i + 1)) + "</th>";
		}
		html += "</tr>";
		int numRows = 0;
		while (rs.next()) {
			html += "<tr>";
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				String temp = rs.getString(i + 1);
				try {
					if (temp.length() > 100) {
						temp = "Too Long";
					}
				} catch (Exception e) {
					temp = "Does not exist";
				}
				html += "<td>" + temp + "</td>";
			}
			html += "</tr>";
			if (numRows > 200) {
				html += "<tr> <th> resultSet is too long </th> </tr>";
				break;
			}
			numRows++;
		}
		rs.close();
		html += "</table>";
		return html;
	}

	public int exportToFile(String filename) throws Exception {
		return exportToFile(getInstantiatedSQL(), filename);
	}

	/**
	 * Returns the number of exported records
	 * @param query
	 * @param filename
	 * @return
	 * @throws Exception
	 */
	public static int exportToFile(String query, String filename)
			throws Exception {
		BufferedWriter out = new BufferedWriter(new FileWriter(filename));
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(query);
		ResultSetMetaData rsmd = rs.getMetaData();
		for (int i = 0; i < rsmd.getColumnCount(); i++) {
			out.write(rsmd.getColumnName(i + 1));
			if (i < rsmd.getColumnCount() - 1) {
				out.write("\t");
			}
		}
		out.write("\n");
		int numExported = 0;
		while (rs.next()) {
			numExported++;
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				String current_value = rs.getString(i + 1);
				if (current_value == null) {
					current_value = " ";
				}
				out.write(current_value.toString());
				if (i < rsmd.getColumnCount() - 1) {
					out.write("\t");
				}
			}
			out.write("\n");
		}
		rs.close();
		out.close();

		return numExported;
	}

	public String getTabDeliniatedOutput() throws Exception {
		return getTabDeliniatedOutput(getInstantiatedSQL());
	}

	public static String getTabDeliniatedOutput(String query) throws Exception {
		String toRet = "";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(query);
		ResultSetMetaData rsmd = rs.getMetaData();
		for (int i = 0; i < rsmd.getColumnCount(); i++) {
			toRet += rsmd.getColumnName(i + 1);
			if (i < rsmd.getColumnCount() - 1) {
				toRet += "\t";
			}
		}

		toRet += "\n";
		int numRows = 0;
		while (rs.next()) {
			String strresult = "";
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				String current_value = rs.getString(i + 1);
				if (current_value == null) {
					current_value = " ";
				}
				strresult += current_value.toString();
				if (i < rsmd.getColumnCount() - 1) {
					strresult += "\t";
				}
			}
			toRet += strresult + "\n";
			if (numRows > 200) {
				toRet += "ResultSet is to Long\n";
				break;
			}
			numRows++;
		}
		rs.close();
		return toRet;
	}

	public List<String> getInstQueryRunTimes() {
		Vector<String> toRet = new Vector<String>();
		try {
			String sql = "Select DateParam from " + Constants.TABLE_PREFIX
					+ Constants.TABLE_INSTANTIATED_QUERYDATE
					+ " where InstantiatedQueryID = " + InstantiatedQueryID;
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			while (rs.next()) {
//				toRet.addElement(rs.getString(1));
				toRet.addElement(new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(1)));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public String getInstantiatedSQL() {
		return instantiateQuery(PredefinedQuery.getPredefinedQuery(queryID)
				.getQuerySQL(), paramUserName, paramExperimentName,
				getInstQueryRunTimes());
	}

	private String instantiateQuery(String uninstQuery, String user,
			String experiment, List<String> times) {
		String predefined_user_name = user;
		String predefined_experiment_name = experiment;
		List<String> predefined_start_time_list = times;
		String modified_query = uninstQuery;
		if (modified_query.contains("_EXPCLAUSE")) {
			modified_query = modified_query.replace("_EXPCLAUSE", " "
					+ BuildExpClause(predefined_user_name,
							predefined_experiment_name,
							predefined_start_time_list) + " ");
		}

		return modified_query;
	}

	private String BuildExpClause(String user_name, String experiment_name,
			List<String> start_time_list) {
		StringBuffer time_component_buf = new StringBuffer();
		for (int i = 0; i < start_time_list.size(); ++i) {
			time_component_buf.append("er.starttime = '"
					+ start_time_list.get(i) + "' ");
			if (i < start_time_list.size() - 1) {
				time_component_buf.append(" OR ");
			}
		}
		return " ex.username = '" + user_name + "' AND ex.experimentname = '"
				+ experiment_name + "' AND (" + time_component_buf.toString()
				+ ") ";
	}

	public static InstantiatedQuery getInstantiatedQuery(int InstQueryID) {
		String sql = "Select pd.queryID, inst.UserName, inst.NotebookName, inst.ExperimentName, pd.QueryName from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_PREDEFINED_QUERY
				+ " pd, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_INSTANTIATED_QUERY
				+ " inst where inst.InstantiatedQueryID = "
				+ InstQueryID
				+ " and inst.queryID = pd.queryID";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return new InstantiatedQuery(rs.getInt(1), InstQueryID, rs
						.getString(2), rs.getString(3), rs.getString(4), rs
						.getString(5));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 
	 * @return a combo box model representation of the columns
	 */
	public List<String> getColumnNames() {
		Vector<String> toRet = new Vector<String>();

		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(
					getInstantiatedSQL());
			ResultSetMetaData rsmd = rs.getMetaData();
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				toRet.add(rsmd.getColumnName(i + 1));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public int getQueryID() {
		return queryID;
	}

	public int getInstantiatedQueryID() {
		return InstantiatedQueryID;
	}

	public String getUserNameParameter() {
		return paramUserName;
	}

	public String getNotebookNameParameter() {
		return paramNotebookName;
	}

	public String getExperimentNameParameter() {
		return paramExperimentName;
	}

	public String getPredefinedQueryName() {
		return queryName;
	}

	public static void addInstantiatedQuery(int PredefinedQueryID,
			String userParam, String notebookParam, String experimentParam,
			Vector<String> times) throws Exception {
		int instID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_INSTIATED_QUERY);
		LabShelfManager.getShelf().insertTupleToNotebook(
				Constants.TABLE_PREFIX + Constants.TABLE_INSTANTIATED_QUERY,
				new String[] { "QueryID", "InstantiatedQueryID", "UserName",
						"NotebookName", "ExperimentName" },
				new String[] { String.valueOf(PredefinedQueryID),
						String.valueOf(instID), userParam, notebookParam,
						experimentParam },
				new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
						GeneralDBMS.I_DATA_TYPE_NUMBER,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_VARCHAR });

		for (int i = 0; i < times.size(); i++) {
			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX
							+ Constants.TABLE_INSTANTIATED_QUERYDATE,
					new String[] { "InstantiatedQueryID", "DateParam" },
					new String[] { instID + "", times.get(i) },
					new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_DATE });

		}
	}
	
	public String getUserName(){
		return PredefinedQuery.getPredefinedQuery(queryID).getUserName();
	}

	@Override
	public String toString() {
		String toRet = queryName + "    ";
		if (!paramUserName.equals("NULL")) {
			toRet += "USER=" + paramUserName;
		} else {
			toRet += "no Parameters";
		}
		if (!paramNotebookName.equals("NULL")) {
			toRet += ", " + "NOTEBOOK=" + paramNotebookName;
		}
		if (!paramExperimentName.equals("NULL")) {
			toRet += ", " + "EXPERIMENT= " + paramExperimentName;
		}
		return toRet;
	}

}
