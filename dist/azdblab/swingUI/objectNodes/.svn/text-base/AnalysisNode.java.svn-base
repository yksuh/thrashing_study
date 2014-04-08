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
package azdblab.swingUI.objectNodes;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.swing.BoxLayout;
import javax.swing.DefaultComboBoxModel;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.dataModel.Analysis;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.PredefinedQuery;
import azdblab.labShelf.dataModel.Analysis.AnalysisRun;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class AnalysisNode extends ObjectNode {

	private JButton btn_freeze;

	private Analysis myAnalysis;
	private boolean isModifiable = false;
	private JList lst_Times;
	private JComboBox cobox_ViewResults;
	private JTextArea txt_Result;

	public AnalysisNode(int ID) {
		myAnalysis = Analysis.getAnalysis(ID);
		strNodeName =myAnalysis.getAnalysisName();
		isModifiable = myAnalysis.getModifiable();
	}

	private JPanel initializeDataPanel() {
		NodePanel npl_Analysis = new NodePanel();
		npl_Analysis.addComponentToTab("Analysis Info", initializeInfo());
		npl_Analysis.addComponentToTab("Analysis Options", initializeOptions());
		npl_Analysis.addComponentToTab("View Run", initializeRunView());
		npl_Analysis.addComponentToTab("Run Information", initializeRunInfo());

		return npl_Analysis;
	}

	private JPanel initializeInfo() {
		JPanel jpl_Info = new JPanel();
		jpl_Info.setLayout(new BoxLayout(jpl_Info, BoxLayout.Y_AXIS));
		jpl_Info.add(new JLabel("Analysis Name: " + myAnalysis.getAnalysisName()));
		jpl_Info.add(new JLabel("Frozen: " + !isModifiable));
		return jpl_Info;

	}

	private JPanel initializeOptions() {
		JButton btn_runAnalysis = new JButton("Run Analysis");
		btn_runAnalysis.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser chooser = new JFileChooser();
				chooser.setCurrentDirectory(new java.io.File("/home"));
				chooser
						.setDialogTitle("Where would you like to preform the analysis");
				chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				chooser.setAcceptAllFileFilterUsed(false);
				String directory = "";
				try {
					if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
						directory += chooser.getSelectedFile();
						directory += "/" + myAnalysis.getAnalysisName().replace(" ", "_")
								+ "_QueryResults/";
						Runtime.getRuntime().exec("mkdir " + directory);
					} else {
						return;
					}
					// to guarnetee the directory is created, sleep for 100
					Thread.sleep(1000);

					// Create an analysisRun entry
					int ID = createAnalysisRun();

					runQueries(directory);
					runScripts(directory, ID);
					try {
						freezeAnalysis();
						isModifiable = false;
					} catch (Exception q) {
						// do nothing
					}

					lst_Times.setModel(getRunTimes());
					LabShelfManager.getShelf().commit();
					LabShelfManager.getShelf().commitlabshelf();
					JOptionPane.showMessageDialog(null,
							"Analysis Run successful\nResults Directory: "
									+ directory);
				} catch (Exception x) {
					x.printStackTrace();
					if (!x.getMessage().equals("Aborted at User request")) {
						JOptionPane.showMessageDialog(null,
								"Failed to run Analysis");
					}
				}
			}
		});

		btn_freeze = new JButton("Freeze Analysis");
		btn_freeze.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					freezeAnalysis();
					JOptionPane.showMessageDialog(null, "Analysis Frozen");
					btn_freeze.setVisible(false);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to Freeze Analysis");
					x.printStackTrace();
				}
			}
		});
		JButton btn_clone = new JButton("Clone Analysis");
		btn_clone.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					cloneAnalysis();
					JOptionPane.showMessageDialog(null, "Analysis Cloned");
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to clone Analysis");
					x.printStackTrace();
				}
			}
		});

		JPanel jpl_Options = new JPanel();
		jpl_Options.add(btn_runAnalysis);
		if (isModifiable) {
			jpl_Options.add(btn_freeze);
		}
		jpl_Options.add(btn_clone);
		return jpl_Options;
	}

	private JPanel initializeRunInfo() {

		DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
		dcbm.addElement("Select a Run Date to view");
		cobox_ViewResults = new JComboBox(dcbm);
		JButton btn_ViewResults = new JButton("View");
		btn_ViewResults.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					displayResult((AnalysisResult) cobox_ViewResults
							.getSelectedItem());
				} catch (Exception x) {
					x.printStackTrace();
					txt_Result.setText("Error retrieving result");
				}
			}
		});
		txt_Result = new JTextArea("The result of the script will appear here");
		txt_Result.setEditable(false);
		txt_Result.setLineWrap(true);
		JPanel jpl_runInfoTop = new JPanel();
		jpl_runInfoTop.setLayout(new GridLayout(1, 3));
		jpl_runInfoTop.add(new JLabel("Script to View"));
		jpl_runInfoTop.add(cobox_ViewResults);
		jpl_runInfoTop.add(btn_ViewResults);

		JPanel jpl_RunInfo = new JPanel();
		jpl_RunInfo.setLayout(new BorderLayout());
		jpl_RunInfo.add(jpl_runInfoTop, BorderLayout.NORTH);
		jpl_RunInfo.add(txt_Result, BorderLayout.CENTER);

		return jpl_RunInfo;

	}

	private JPanel initializeRunView() {
		lst_Times = new JList(getRunTimes());

		JButton btn_View = new JButton("View this Analysis");
		btn_View.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					cobox_ViewResults
							.setModel(getResultModel(((AnalysisRun) lst_Times
									.getSelectedValue()).getAnalysisRunID()));
				} catch (Exception x) {
					x.printStackTrace();
				}
			}
		});
		JButton btn_Export = new JButton("Export run as Zip File");
		btn_Export.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					JFileChooser chooser = new JFileChooser();
					chooser.setCurrentDirectory(new java.io.File("/home"));
					chooser
							.setDialogTitle("Where would you like to preform the analysis");
					chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
					chooser.setAcceptAllFileFilterUsed(false);
					String directory = "";
					String baseDir = "";
					if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
						directory += chooser.getSelectedFile();
						baseDir = directory;
						directory += "/"
								+ ((AnalysisRun) lst_Times.getSelectedValue())
										.getDateTimeRun().replace(" ", "_") + "/";
						Runtime.getRuntime().exec("mkdir " + directory);
					} else {
						return;
					}
					Thread.sleep(1000); // to guarentee that the directory is
					// created before exporting starts

					exportRun(((AnalysisRun) lst_Times.getSelectedValue())
							.getAnalysisRunID(), directory, baseDir);
					JOptionPane.showMessageDialog(null,
							"Successfully exported Run to " + directory);
				} catch (Exception x) {
					x.printStackTrace();
					JOptionPane.showMessageDialog(null,
							"Failed to export Analysis");
				}
			}
		});

		JPanel jpl_Buttons = new JPanel();
		jpl_Buttons.setLayout(new GridLayout(1, 2));
		jpl_Buttons.add(btn_View);
		jpl_Buttons.add(btn_Export);
		JPanel jpl_runView = new JPanel();
		jpl_runView.setLayout(new BorderLayout());
		jpl_runView.add(lst_Times, BorderLayout.CENTER);
		jpl_runView.add(jpl_Buttons, BorderLayout.SOUTH);
		return jpl_runView;
	}

	private void freezeAnalysis() throws Exception {
		myAnalysis.freezeAnalysis();
	}

	/**
	 * 
	 * @param directory
	 *            the directory where the query Results will be places
	 * @throws Exception
	 *             any exception causes the Analysis to abort
	 */
	private void runQueries(String directory) throws Exception {
		List<InstantiatedQuery> queryData =myAnalysis.getAnalysisQuerys();
		for (int i = 0; i < queryData.size(); i++) {
			String sql = queryData.get(i).getInstantiatedSQL();
			createFile(getResultViewer(LabShelfManager.getShelf()
					.executeQuerySQL(sql)), directory
					+ PredefinedQuery.getPredefinedQuery(
							queryData.get(i).getQueryID()).getQueryName());
		}
	}

	private void runScripts(String directory, int analysisRunID)
			throws Exception {
		String sql = "Select ScriptName, ScriptType, ScriptText from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_SCRIPT
				+ " where analysisID = " + myAnalysis.getAnalysisID();
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		Vector<String[]> scriptData = new Vector<String[]>();
		Vector<Clob> scriptText = new Vector<Clob>();
		while (rs.next()) {
			scriptData.add(new String[] { rs.getString(1), rs.getString(2) });
			scriptText.add(rs.getClob(3));
		}
		rs.close();
		for (int i = 0; i < scriptData.size(); i++) {
			String filename = directory + scriptData.get(i)[0];
			File tempFile = new File(filename);
			tempFile.deleteOnExit();
			PrintWriter out = new PrintWriter(new FileWriter(tempFile));
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					scriptText.get(i).getAsciiStream()));
			String scriptTemp;
			while ((scriptTemp = reader.readLine()) != null) {
				out.println(scriptTemp);
			}
			out.close();
			// run the file in the query directory

			Runtime.getRuntime().exec("chmod +x " + filename, null,
					new File(directory));
			if (scriptData.get(i)[1].equals("BASH")) {
				Runtime.getRuntime().exec("/bin/bash", null, new File("/bin"));
			}

			Process p = Runtime.getRuntime().exec(scriptData.get(i)[0], null,
					new File(directory));
			BufferedReader stdout = new BufferedReader(new InputStreamReader(p
					.getInputStream()));
			BufferedReader stderr = new BufferedReader(new InputStreamReader(p
					.getErrorStream()));
			p.waitFor();

			String temp;
			String err = "";
			while ((temp = stderr.readLine()) != null) {
				err += temp + "\n";
			}
			stderr.close();
			if (!err.equals("")) {
				int selection = JOptionPane.showConfirmDialog(null, "Error in "
						+ scriptData.get(i)[0]
						+ "\nWould you like to continue?\nDetails...\n" + err,
						"Error detected", JOptionPane.YES_NO_OPTION);
				if (selection == JOptionPane.NO_OPTION) {
					purgeRun(analysisRunID);
					throw new Exception("Aborted at User request");
				}
			}
			String record = "";
			while ((temp = stdout.readLine()) != null) {
				record += temp + "\n";
			}
			stdout.close();
			tempFile.delete();
			// if errors p.waitFor may be necessary
			// add a record for this analysis run
			addRunRecord(scriptData.get(i)[0], analysisRunID, record);
		}
	}

	private void purgeRun(int analysisRunID) {
		// TODO
		// There appers to be an error in the executeDeleteSQL code... the
		// labnotebook hangs
		/*
		 * String deleteResults = "Delete from " + Constants.TABLE_PREFIX +
		 * Constants.TABLE_ANALYSIS_RESULT + " where AnalysisRunID = " +
		 * analysisRunID; String deleteRun = "Delete from " +
		 * Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RUN +
		 * " where AnalysisRunID = " + analysisRunID;
		 */
		try {
			// Main._logger.outputLog(deleteResults);
			// LabNotebookLibrary.getLibrary().executeDeleteSQL(deleteResults);
			// Main._logger.outputLog(deleteRun);
			// LabNotebookLibrary.getLibrary().executeDeleteSQL(deleteRun);
			// JOptionPane.showMessageDialog(null,
			// "Aborted Analysis run, All results Purged");
		} catch (Exception e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(null,
					"Failed to purge analysisRun/AnalysisResult");
		}

	}

	// this method might be better in utility.Graphics.Generator
	private Vector<String> getResultViewer(ResultSet rs) throws Exception {
		Vector<String> vecResult = new Vector<String>();
		ResultSetMetaData rsmd = rs.getMetaData();
		int columns = rsmd.getColumnCount();
		String strcol = "";
		for (int i = 0; i < columns; i++) {
			strcol += rsmd.getColumnName(i + 1);
			if (i < columns - 1) {
				strcol += "\t";
			}
		}
		vecResult.add(strcol);
		while (rs.next()) {
			String strresult = "";
			for (int i = 0; i < columns; i++) {
				Object current_value = rs.getObject(i + 1);
				if (current_value == null) {
					current_value = "0";
				}
				strresult += current_value.toString();
				if (i < columns - 1) {
					strresult += "\t";
				}
			}
			vecResult.add(strresult);
		}
		rs.close();
		return vecResult;
	}

	private void createFile(Vector<String> vecResult, String filename)
			throws IOException {

		FileWriter outFile = new FileWriter(filename);
		PrintWriter out = new PrintWriter(outFile);
		for (int i = 0; i < vecResult.size(); i++) {
			out.println(vecResult.get(i));
		}
		out.close();
	}

	private void cloneAnalysis() throws Exception {
		// Step 1 get name of new analysis
		// step 2 create new analysis
		// step 3 associate all analysis_queries and analysis_scripts with the
		// new analysis

		// get name

		String newAnlName = JOptionPane
				.showInputDialog("Input cloned analysis name");
		if (newAnlName == null) {
			return;
		}
		if (newAnlName.equals("")) {
			throw new Exception();
		}
		String sql = "Select Username, NotebookName from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS
				+ " where analysisID = " + myAnalysis.getAnalysisID();
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		rs.next();
		String userName = rs.getString(1);
		String notebookName = rs.getString(2);
		rs.close();
		Integer newAnalysisID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_ANALYSIS);
		int dataTypes[] = { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_VARCHAR };
		// create analysis
		LabShelfManager.getShelf().insertTupleToNotebook(
				Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS,
				new String[] { "UserName", "AnalysisName", "AnalysisID",
						"NotebookName" },
				new String[] { userName, newAnlName,
						String.valueOf(newAnalysisID), notebookName },
				dataTypes);

		// get all associated Querys
		Vector<String> queryIDs = new Vector<String>();
		sql = "Select InstantiatedQueryID from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_ANALYSIS_QUERY + " where AnalysisID = "
				+ myAnalysis.getAnalysisID();
		rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			queryIDs.add(rs.getString(1));
		}
		// add All associated Queries to clone
		dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER };
		for (int i = 0; i < queryIDs.size(); i++) {
			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_QUERY,
					new String[] { "AnalysisID", "InstantiatedQueryID" },
					new String[] { String.valueOf(newAnalysisID),
							queryIDs.get(i) }, dataTypes);
		}

		// get all Scripts
		sql = "Select scriptName, scriptType, scriptText from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_SCRIPT
				+ " where AnalysisID = " + myAnalysis.getAnalysisID();
		rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		Vector<String[]> scriptData = new Vector<String[]>();
		Vector<Clob> scriptText = new Vector<Clob>();
		while (rs.next()) {
			scriptData.add(new String[] { rs.getString(1), rs.getString(2) });
			scriptText.add(rs.getClob(3));
		}

		// add all Scripts
		for (int i = 0; i < scriptData.size(); i++) {
			String txt_script = "";
			byte data[] = new byte[1024];
			InputStream in = scriptText.get(i).getAsciiStream();

			while (in.read(data, 0, 1024) > 0) {
				txt_script += new String(data);
			}
			in.close();
			LabShelfManager.getShelf().putDocument(
					Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_SCRIPT,
					"ScriptText",
					new String[] { "AnalysisID", "ScriptName", "ScriptType" },
					new String[] { String.valueOf(newAnalysisID),
							scriptData.get(i)[0], scriptData.get(i)[1] },
					new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR }, txt_script);
		}
		LabShelfManager.getShelf().commit();
		LabShelfManager.getShelf().commitlabshelf();
		rs.close();

		AnalysisNode anlNode = new AnalysisNode(newAnalysisID);
		AZDBLABMutableTreeNode mtn_anlNode = new AZDBLABMutableTreeNode(anlNode);

		AnalysisQueryNode anlQueryNode = new AnalysisQueryNode(newAnalysisID);
		AZDBLABMutableTreeNode mtn_anlQueryNode = new AZDBLABMutableTreeNode(
				anlQueryNode);

		AnalysisScriptNode anlRunNode = new AnalysisScriptNode(newAnalysisID);
		AZDBLABMutableTreeNode mtn_anlRunNode = new AZDBLABMutableTreeNode(
				anlRunNode);

		mtn_anlNode.add(mtn_anlQueryNode);
		mtn_anlNode.add(mtn_anlRunNode);

		if (!(((AZDBLABMutableTreeNode) parent.getParent()).getUserObject() instanceof CollectedAnalysisNode)) {
			throw new Exception(
					"AnalysisNode's parent is not a collectedAnalysisNode");
		}
		AZDBLabObserver.addElementToTree((AZDBLABMutableTreeNode) parent
				.getParent(), mtn_anlNode);
	}

	private int createAnalysisRun() throws Exception {
		int analysisRunID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_ANALYSISRUN);
		SimpleDateFormat creationDateFormater = new SimpleDateFormat(
				Constants.NEWTIMEFORMAT);
		String currentTime = creationDateFormater.format(new Date(System
				.currentTimeMillis()));

		LabShelfManager
				.getShelf()
				.insertTupleToNotebook(
						Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RUN,
						new String[] { "AnalysisID", "AnalysisRunID", "DateTimeRun" },
						new String[] { String.valueOf(myAnalysis.getAnalysisID()), analysisRunID + "",
								currentTime },
						new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
								GeneralDBMS.I_DATA_TYPE_NUMBER,
								GeneralDBMS.I_DATA_TYPE_DATE });

		return analysisRunID;
	}

	private void addRunRecord(String scriptName, int runID, String output)
			throws Exception {
		LabShelfManager.getShelf().putDocument(
				Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RESULT,
				"OUTPUT",
				new String[] { "AnalysisRunID", "scriptName", "AnalysisID" },
				new String[] { runID + "", scriptName, String.valueOf(myAnalysis.getAnalysisID()) },
				new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
						GeneralDBMS.I_DATA_TYPE_VARCHAR,
						GeneralDBMS.I_DATA_TYPE_NUMBER }, output);
	}

	private DefaultListModel getRunTimes() {
		List<AnalysisRun> runData =myAnalysis.getAnalysisRuns();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < runData.size(); i++) {
			lmodel.addElement(runData.get(i));
		}
		return lmodel;
	}

	private DefaultComboBoxModel getResultModel(int runID) throws Exception {
		DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
		String sql = "Select SCRIPTNAME, OUTPUT from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_ANALYSIS_RESULT + " where ANALYSISRUNID = "
				+ runID;
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			dcbm.addElement(new AnalysisResult(rs.getString(1), rs.getClob(2)));
		}
		rs.close();
		return dcbm;
	}

	private void displayResult(AnalysisResult sent) throws Exception {
		BufferedReader reader = new BufferedReader(new InputStreamReader(
				sent.result.getAsciiStream()));
		String temp;
		String toRet = "";
		while ((temp = reader.readLine()) != null) {
			toRet += temp + "\n";
		}
		txt_Result.setText(toRet);
	}

	private void exportRun(int analysisRunID, String directory, String baseDir)
			throws Exception {
		// get all the results
		String sql = "select scriptname, output from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_ANALYSIS_RESULT + " where analysisRunID = "
				+ analysisRunID;
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			// save all scripts
			InputStream in = rs.getClob(2).getAsciiStream();
			byte data[] = new byte[1024];
			PrintWriter out = new PrintWriter(new FileWriter(directory
					+ rs.getString(1).replace(" ", "_") + ".txt"));

			while (in.read(data, 0, 1024) > 0) {
				out.print(new String(data).trim());
			}
			in.close();
			out.close();
		}
		rs.close();
		// create the zip file
		System.out.println("zip -r " + directory + "/Results.zip " + directory);
		String zipCmd = "zip -r "
				+ directory
				+ "/test.zip "
				+ ((AnalysisRun) lst_Times.getSelectedValue()).getDateTimeRun()
						.replace(" ", "_");
		Runtime.getRuntime().exec(zipCmd, null, new File(baseDir));
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Analysis Node");

		return initializeDataPanel();
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "Analysis.png";
	}

	@Override
	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {
		AnalysisQueryNode anlQueryNode = new AnalysisQueryNode(myAnalysis.getAnalysisID());
		AZDBLABMutableTreeNode mtn_anlQueryNode = new AZDBLABMutableTreeNode(
				anlQueryNode);

		AnalysisScriptNode anlScriptNode = new AnalysisScriptNode(myAnalysis.getAnalysisID());
		AZDBLABMutableTreeNode mtn_anlRunNode = new AZDBLABMutableTreeNode(
				anlScriptNode);

		parent.add(mtn_anlQueryNode);
		parent.add(mtn_anlRunNode);
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains general information about an analysis stored in a labshelf";
	}

}

class AnalysisResult {
	String scriptName;
	Clob result;

	public AnalysisResult(String name, Clob c) {
		scriptName = name;
		result = c;
	}

	@Override
	public String toString() {
		return scriptName;
	}
}
