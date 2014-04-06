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

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;

import javax.swing.JFileChooser;

import com.panayotis.gnuplot.JavaPlot;
import com.panayotis.gnuplot.terminal.PostscriptTerminal;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;

public class Paper {

	private int paperID;
	private String strUserName;
	private String strPaperName;
	private String strDescription;
	private String strNotebookName;

	public Paper(int paperID, String userName, String notebookName,
			String paperName, String description) {
		this.paperID = paperID;
		strUserName = userName;
		strNotebookName = notebookName;
		strPaperName = paperName;
		strDescription = description;
	}

	public static Paper getPaper(int pID) {
		String sql = "Select userName, notebookName, paperName, description from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_PAPER
				+ " where paperID = " + pID;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return new Paper(pID, rs.getString(1), rs.getString(2), rs
						.getString(3), rs.getString(4));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}

	public int getPaperID() {
		return paperID;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getPaperName() {
		return strPaperName;
	}

	public String getDescription() {
		return strDescription;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public List<Table> getAllTables() {
		String sql = "Select InstantiatedQueryID,TableName, Description, CreationTime from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_TABLE
				+ " where paperID = " + paperID;
		Vector<Table> toRet = new Vector<Table>();
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				toRet.add(new Table(paperID, rs.getInt(1), rs.getString(2), rs
						.getString(3), new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(4))));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public Table getTable(String tableName) {
		String sql = "Select InstantiatedQueryID, Description, CreationTime from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_TABLE
				+ " where paperID = "
				+ paperID
				+ " and tableName = '"
				+ tableName + "'";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			return new Table(paperID, rs.getInt(1), tableName, rs.getString(2),
					new SimpleDateFormat(Constants.NEWDATEFORMAT).format(rs.getDate(3)));
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public List<Figure> getAllFigures() {
		String sql = "Select InstantiatedQueryID, X_VAL, Y_VAL, Description, CreationTime, C_VAL, C_NUM, ShowLegend, LineType, figureName  from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_FIGURE
				+ " where paperID = " + paperID;
		Vector<Figure> toRet = new Vector<Figure>();
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				toRet.add(new Figure(paperID, rs.getInt(1), rs.getString(10),
						rs.getString(2), rs.getString(3), rs.getString(4), 
						new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(5)), rs.getString(6), rs.getInt(7),
						rs.getString(8), rs.getString(9)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return toRet;
	}

	public Figure getFigure(String figureName) {
		String sql = "Select InstantiatedQueryID, X_VAL, Y_VAL, Description, CreationTime, C_VAL, C_NUM, ShowLegend, LineType from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_FIGURE
				+ " where paperID = "
				+ paperID
				+ " and figureName = '"
				+ figureName + "'";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return new Figure(paperID, rs.getInt(1), figureName, rs
						.getString(2), rs.getString(3), rs.getString(4), 
						new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(5)), rs.getString(6), rs.getInt(7), rs
						.getString(8), rs.getString(9));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * returns the paperID;
	 * 
	 * @return
	 */
	public static int addPaper(String userName, String paperName,
			String description, String notebookName) {

		Integer paperID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_PAPER);

		int dataTypes[] = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {
			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_PAPER,
					new String[] { "PaperID", "Username", "PaperName",
							"Description", "NotebookName" },
					new String[] { String.valueOf(paperID), userName,
							paperName, description, notebookName }, dataTypes);
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return paperID;

	}
	
	

	public void exportPaper() throws Exception {
		JFileChooser chooser = new JFileChooser();
		chooser.setCurrentDirectory(new java.io.File("/home"));
		chooser.setDialogTitle("Where would you like the paper saved");
		chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		chooser.setAcceptAllFileFilterUsed(false);
		String directory = "";
		if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
			directory += chooser.getSelectedFile();
		} else {
			throw new Exception();
		}
		String saveFolder = strPaperName.replace(" ", "_");

		try {
			Runtime.getRuntime().exec("mkdir " + directory + "/" + saveFolder);
			Runtime.getRuntime().exec(
					"mkdir " + directory + "/" + saveFolder + "/Figures");
			Runtime.getRuntime().exec(
					"mkdir " + directory + "/" + saveFolder + "/Tables");
		} catch (IOException e) {
			e.printStackTrace();
		}
		String tableDir = directory + "/" + saveFolder + "/Tables";
		String figureDir = directory + "/" + saveFolder + "/Figures";

		// begin saving the tables

		List<Table> vecTables = getAllTables();

		for (int i = 0; i < vecTables.size(); i++) {
			FileWriter outFile = new FileWriter(tableDir + "/"
					+ vecTables.get(i).getTableName() + ".tex");
			PrintWriter out = new PrintWriter(outFile);
			out.print(vecTables.get(i).getLATEX());
			out.close();
		}
		// done saving tables

		List<Figure> vecFig = getAllFigures();
		for (int i = 0; i < vecFig.size(); i++) {
			JavaPlot tmp = vecFig.get(i).getJavaPlot();
			tmp.setTerminal(new PostscriptTerminal(figureDir + "/"
					+ vecFig.get(i).getFigureName().replace(" ", "_") + ".ps"));
			tmp.plot();
		}
	}
}
