package azdblab.swingUI.objectNodes;

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
* Young-Kyoon Suh 
* Rui Zhang (http://www.cs.arizona.edu/people/ruizhang/)
*/

import java.sql.ResultSet;

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
import azdblab.labShelf.dataModel.Comment;
import azdblab.labShelf.dataModel.Executor;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.labShelf.dataModel.Run.RunStatus;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddCommentDlg;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The data module for paused executors in the GUI
 * 
 * @author Young-Kyoon Suh
 * 
 */
public class PausedExecutorNode extends ExecutorNode {
	private boolean bIsPaused;
	public boolean bIsResumed;
	public PausedExecutorNode(String machineName, String DBMS, String status,
			String command) {

		super(machineName, DBMS, status, command);
		
//		strNodeName = "Paused Executor of [" + DBMS + " on "+ machineName + "]";
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = machineName + ":" + Constants.hiddenDBMSes.get(DBMS.toLowerCase());
		}else{
			strNodeName = machineName + ":" + DBMS;
		}
		type = Executor.TYPE_PAUSED;
	}

	public void setPaused(boolean isPaused) {
		bIsPaused = isPaused;
	}

	public boolean getIsPaused() {
		return bIsPaused;
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "pause.png");
	}

	private JPanel createPausedExecutorPanel() {
		List<String> vecHistory = Executor.getExecutor(getMachineName(), getDBMS())
				.getExecutorHistory();

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "Machine " + getMachineName();
		info += "</h1></CENTER> <font color='blue'>";
		info += "<p>DBMS: " + getDBMS() + "</p>";
		info += "<p>Status: " + getStatus() + "</p>";
		info += "<p>Command: " + getCommand() + "</p>";
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
		npl_toRet.addComponentToTab("Paused Executor Info", createTextPaneFromString(info));

		// return new JComponentWrapper(userPanel, strUserName,
		// JComponentWrapper.PANEL_TYPE_PANE);
		return npl_toRet;
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());

		JButton button = new JButton("Resume Executor");
		JButton btn_Abort = new JButton("Terminate Executor");

		buttonPanel.add(button);
		buttonPanel.add(btn_Abort);

		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				ResumePausedExecutorActionPerformed(ev);
//				AZDBLabObserver.checkRuns();
			}
		});

		btn_Abort.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				mnuitm_TerminatePausedExecutorActionPerformed();
				AZDBLabObserver.checkExecutors();
			}
		});

//		JButton btn_AddComment = new JButton("Add Comment");
//		btn_AddComment.addActionListener(new ActionListener() {
//			@Override
//			public void actionPerformed(ActionEvent e) {
////				AddCommentDlg dlg = new AddCommentDlg(getRunID());
////				dlg.setModal(true);
////				dlg.setVisible(true);
////
////				refreshCommentList();
//			}
//		});
//		buttonPanel.add(btn_AddComment);
		return buttonPanel;
	}

	private void mnuitm_TerminatePausedExecutorActionPerformed() {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to terminate this paused executor?", "Terminating Executor",
				JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			Executor.getExecutor(strMachineName, strDBMS).updateExecutor(
					strDBMS,
					new SimpleDateFormat(Constants.TIMEFORMAT).format(new Date(
							System.currentTimeMillis())), strStatus,
					"Terminate");
		}
	}

	private void ResumePausedExecutorActionPerformed(ActionEvent evt) {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to resume this paused executor?", "Resume Paused Executor",
				JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(System.currentTimeMillis());
			String command = "Resume";

			azdblab.labShelf.dataModel.Executor.getExecutor(getMachineName(), getDBMS()).updateExecutor(getDBMS(), transactionTime, null, command);
		}

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Paused Executor Node");

		return createPausedExecutorPanel();
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Young-Kyoon Suh");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information pertaining to a paused executor";
	}
}

