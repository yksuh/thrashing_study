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
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;

import javax.swing.JTable;

import azdblab.Constants;
import azdblab.swingUI.AZDBLabObserver;

public class Table {
	private int paperID;
	private int myInstantiatedQueryID;
	private String Description;
	private String TableName;
	private String CreationTime;

	public Table(int paperID, int InstQueryID, String TableName,
			String Description, String CreationTime) {

		this.paperID = paperID;
		this.myInstantiatedQueryID = InstQueryID;
		this.TableName = TableName;
		this.Description = Description;
		this.CreationTime = CreationTime;
	}

	public static Table getTable(int paperID, String tableName) {
		String sql = "Select InstantiatedQueryID, Description, CreationTime from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_PAPER
				+ " where paperID = "
				+ paperID
				+ " and tableName = '"
				+ tableName + "'";

		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return new Table(paperID, rs.getInt(1), tableName, rs
						.getString(2), new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(3)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String getLATEX() {
		return getLATEX(InstantiatedQuery.getInstantiatedQuery(
				myInstantiatedQueryID).getInstantiatedSQL());
	}

	/**
	 * 
	 * @return a LATEX representation of the data fetched in getView();
	 */
	public static String getLATEX(String query) {
		String toSave = "";
		toSave += "\\documentclass[12pt]{article}\n";
		toSave += "\\begin{document}\n";
		toSave += "\\begin{tabular}{";

		try {
			ResultSet rs = LabShelfManager.getShelf()
					.executeQuerySQLOnce(query);
			ResultSetMetaData rsmd = rs.getMetaData();
			rsmd.getColumnCount();
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				if (i == 0) {

					toSave += "|  l ";
				} else if (i == rsmd.getColumnCount() - 1) {
					toSave += "|  r ";
				} else {
					toSave += "| c ";
				}
			}
			toSave += "| }\n";
			toSave += "\\hline\n";
			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				toSave += " " + rsmd.getColumnName(i + 1) + " ";
				if (i != rsmd.getColumnCount() - 1) {
					toSave += "&";
				} else {
					toSave += "\\\\\n";
				}
			}
			toSave += "\\hline\n";
			toSave += "\\hline\n";
			int numLines = 0;
			while (rs.next()) {
				for (int j = 0; j < rsmd.getColumnCount(); j++) {
					toSave += " " + rs.getString(j + 1) + " ";
					if (j != rsmd.getColumnCount() - 1) {
						toSave += "&";
					} else {
						toSave += "\\\\ \\hline\n";
					}
					if (numLines == 30) {
						// TODO maybe 30 isn't the right number, generate one
						// and see
						numLines = 0;
						toSave += "\\newpage \n";
					}
					numLines++;
				}
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		toSave += "\\end{tabular}\n";
		toSave += "\\end{document}\n";
		return toSave.replace("_", "\\_");
	}

	public JTable getJTable() {
		return getJTable(InstantiatedQuery.getInstantiatedQuery(
				myInstantiatedQueryID).getInstantiatedSQL());
	}

	public static JTable getJTable(String sql) {
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(
					sql.replace("\n", " "));
			ResultSetMetaData rsmd = rs.getMetaData();
			String[] ColumnNames = new String[rsmd.getColumnCount()];
			for (int i = 0; i < ColumnNames.length; i++) {
				ColumnNames[i] = rsmd.getColumnName(i + 1);
			}
			int size = 0;
			while (rs.next()) {
				size++;
			}
			rs.close();

			rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);

			String[][] rowData = new String[size][ColumnNames.length];

			int curRow = 0;
			while (rs.next()) {
				for (int i = 0; i < ColumnNames.length; i++) {
					rowData[curRow][i] = rs.getString(i + 1);
				}
				curRow++;
			}
			rs.close();			return new JTable(rowData, ColumnNames);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String toString() {
		return TableName;
	}

	public int getPaperID() {
		return paperID;
	}

	public int getMyInstantiatedQueryID() {
		return myInstantiatedQueryID;
	}

	public String getDescription() {
		return Description;
	}

	public String getTableName() {
		return TableName;
	}

	public String getCreationTime() {
		return CreationTime;
	}
}
