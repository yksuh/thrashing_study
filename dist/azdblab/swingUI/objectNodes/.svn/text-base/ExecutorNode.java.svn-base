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

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import azdblab.Constants;
import azdblab.labShelf.dataModel.Executor;
import azdblab.labShelf.dataModel.Run;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The data module for each user object. Used in creating the views for user in
 * the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class ExecutorNode extends ObjectNode {

	protected String strMachineName;

	protected String strDBMS;

	// private String strStartTime;

	protected String strStatus;

	protected String strCommand;

	// private Vector<NotebookModule> notebooks;

	protected int type;
	
	public ExecutorNode(String machineName, String DBMS, String status,
			String command) {

		strMachineName = machineName;

//		strNodeName = machineName + ":" + DBMS;
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = machineName + ":" + Constants.hiddenDBMSes.get(DBMS.toLowerCase());
		}else{
			strNodeName = machineName + ":" + DBMS;
		}

		
		strDBMS = DBMS;

		// strStartTime = startTime;

		strStatus = status;

		strCommand = command;

		willHaveChildren = false;
		/*
		 * dbController = new InternalDatabaseController( AZDBLAB.LAB_USERNAME,
		 * AZDBLAB.LAB_PASSWORD, AZDBLAB.LAB_CONNECTSTRING );
		 * dbController.open();
		 */	
		 type = Executor.TYPE_RUNNING;
		}

//	private int getCurrentRunID() {
//		Vector<Run> runs = Run.getSpecificRuns(Run.TYPE_RUNNING);
//		if(runs.size() > 0){
//			if (strDBMSName.equals(getDBMS())
//					&& getMachineName().equals(strMachineName)) {
//				return (runs.get(0)).getRunID();	
//			}
//		}else{
//			return -1;
//		}
//	}

	public String getMachineName() {
		return strMachineName;
	}

	public String getDBMS() {
		return strDBMS;
	}

	public String getStatus() {
		return strStatus;
	}

	public String getCommand() {
		return strCommand;
	}

	public void setStatus(String status) {
		strStatus = status;
	}

	public void setCommand(String command) {
		strCommand = command;
	}

	public String getIconResource(boolean open) {
		if (strStatus.equals("Terminated")) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "executor_terminated.png");
		}

		return (Constants.DIRECTORY_IMAGE_LFHNODES + "executor.png");
	}

	JTextPane logPane;
	JPanel l_panel;

	private JPanel createExecutorPanel() {

		List<String> vecHistory = Executor.getExecutor(strMachineName, strDBMS)
				.getExecutorHistory();

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "Machine " + strMachineName;
		info += "</h1></CENTER> <font color='blue'>";
		info += "<p>DBMS: " + strDBMS + "</p>";
		info += "<p>Status: " + strStatus + "</p>";
		info += "<p>Command: " + strCommand + "</p>";
//		int runID = getCurrentRunID();
//		if(runID != -1){
//			info += "<p>Current Run: " + runID + "</p>";
//		}else
//			info += "<p>Current Run: None</p>";
		info += "<CENTER><h1> HISTORY </h1></CENTER> <font color='blue'>";

		String tableHistory = "<TABLE BORDER=1> " + "<TR>"
				+ "    <TH>Transaction Time</TH>" + "    <TH>Status</TH>"
				+ "    <TH>Command</TH> " + "    <TH>Reason</TH> " + "</TR>";

		for (int i = 0; i < vecHistory.size(); i++) {
			String[] detail = vecHistory.get(i).split("##");
			tableHistory += "<TR>" + "<TD ALIGN=LEFT>" + detail[0]
					+ "</TD><TD ALIGN=LEFT>" + detail[1] + "<TD ALIGN=LEFT>"
					+ detail[2] + "</TD><TD ALIGN=LEFT>";
			if (detail[1].equals("Paused")) {
			}
			tableHistory += "</TD></TR>";
		}

		tableHistory += "</TABLE>";

		info += "<p>" + tableHistory + "</p>";
		info += "</font></BODY></HTML>";


		// Install All the sections into tabs
		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Executor Info", createTextPaneFromString(info));

		// return new JComponentWrapper(userPanel, strUserName,
		// JComponentWrapper.PANEL_TYPE_PANE);
		return npl_toRet;
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Executor Node");

		return createExecutorPanel();
	}

	public JPanel getButtonPanel() {
		
		JPanel jpl_Buttons = new JPanel();
		jpl_Buttons.setLayout(new FlowLayout());

		JButton btn_Pause = new JButton("Pause this executor");
		btn_Pause.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				btn_pauseActionPreformed();
				AZDBLabObserver.checkExecutors();
			}
		});
		jpl_Buttons.add(btn_Pause);
		
		JButton btn_Refresh = new JButton("Refresh executor");
		btn_Refresh.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				btn_RefreshActionPreformed();
				AZDBLabObserver.checkExecutors();
			}

		});

		jpl_Buttons.add(btn_Refresh);

		JButton btn_Terminate = new JButton("Terminate this executor");
		btn_Terminate.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				btn_terminateActionPreformed();
				AZDBLabObserver.checkExecutors();
			}
		});
		jpl_Buttons.add(btn_Terminate);
		return jpl_Buttons;
	}

	private void btn_RefreshActionPreformed() {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to refresh this executor?",
				"Refreshing Executor", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
			Executor.getExecutor(strMachineName, strDBMS).updateExecutor(
					strDBMS,
					new SimpleDateFormat(Constants.TIMEFORMAT).format(new Date(
							System.currentTimeMillis())), strStatus, "Running");

			setCommand("Running");
			setStatus("Run");
		}
	}
	
	private void btn_pauseActionPreformed() {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to pause this executor?",
				"Pausing Executor", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			Executor.getExecutor(strMachineName, strDBMS).updateExecutor(
					strDBMS,
					new SimpleDateFormat(Constants.TIMEFORMAT).format(new Date(
							System.currentTimeMillis())), strStatus,
					"Pause");

			setCommand("Pause");
			setStatus("Paused");
		}
	}

	private void btn_terminateActionPreformed() {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to terminate this executor?",
				"Terminating Executor", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			Executor.getExecutor(strMachineName, strDBMS).updateExecutor(
					strDBMS,
					new SimpleDateFormat(Constants.TIMEFORMAT).format(new Date(
							System.currentTimeMillis())), strStatus,
					"Terminate");

			setCommand("Terminate");
			setStatus("Terminated");
		}
	}

	@Override
	protected void loadChildNodes() {

	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Young-Kyoon Suh");
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information and options pertaining to an executor";
	}

	public int getType() {
		return type;
	}
}
