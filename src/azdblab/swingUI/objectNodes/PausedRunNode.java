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
 * The data module for CompletedRun object. Used in creating the view for
 * CompletedRun node in the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class PausedRunNode extends RunStatusNode {
	private boolean bIsPaused;
	public boolean bIsResumed;
	public PausedRunNode(String username, String notebookname,
			String experimentName, String scenario, String machineName,
			String dbms, String startTime) {

		super(username, notebookname, experimentName, scenario, machineName,
				dbms, startTime, 3);
		willHaveChildren = false;
		bIsPaused = false;
		bIsResumed = false;
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = "Paused Run of [" + experimentName + "," + Constants.hiddenDBMSes.get(dbms.toLowerCase()) + ":"+ getShortMachineName() +"," 
					+ startTime + "," + username + "," + notebookname + "]";
		}else{
			strNodeName = "Paused Run ("+getRunID()+") of [" + experimentName + "," + dbms + ":"+ getShortMachineName() +"," 
					+ startTime + "," + username + "," + notebookname + "]";
		}
		
		
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

	private JPanel createPausedRunPanel() {
		String lastTime = "";
		String reason = "";
		System.out.println(this.strUserName + " : " + this.strNotebookName + " : " + this.strExperimentName);
		Experiment experiment = User.getUser(this.strUserName).getNotebook(this.strNotebookName).getExperiment(this.strExperimentName);
		System.out.println(this.strUserName + " : " + this.strNotebookName + " : " + this.strExperimentName);

		int runID = experiment.getRun(this.strStartTime).getRunID();
		try {
			String query = "SELECT currentstage, transactiontime "
					+ "FROM AZDBLAB_RUNLOG " + "WHERE RunID = " + runID
					+ " ORDER BY transactiontime DESC";

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(query);
			while (rs.next()) {
				reason = rs.getString(1);
				lastTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(2));

				if (reason.contains("Pause") || reason.contains("pause"))
					break;
			}
		} catch (Exception ex) {
			lastTime = "**Error retrieving transaction time**";
			reason = "**Error retrieving reason**";
			ex.printStackTrace();
		}
		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "<p> Experiment : " + strExperimentName + "</p>";
		info += "<p> from notebook : " + strNotebookName + "</p>";
		info += "<p> of user : " + strUserName + "</p>";
		info += "<p> id: " + runID + "</p>";
		info += "<p> on dbms: " + strDBMS + "</p>";
		info += "<p> is currently paused</p>";
		info += "<p> Execution started at " + strStartTime + "</p>";
		info += "<p> Last paused at " + lastTime + "</p>";
		info += "<p> Reason: " + reason + "</p>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "</font>";
		info += "</BODY></HTML>";

		JTextPane infoPane = createTextPaneFromString(info);

		// Install All the sections into tabs
		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Paused Run info", infoPane);
		npl_toRet.addComponentToTab("Run Status", createTextPaneFromString(getRunLogHTML()));
		npl_toRet.addComponentToTab("Comments", getCommentPane());

		// JPanel runPanel = new JPanel();
		// runPanel.add("Paused Run info", infoPane);

		return npl_toRet;
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());

		JButton button = new JButton("Resume Experiment Run");
		JButton btn_Abort = new JButton("Abort Experiment Run");

		buttonPanel.add(button);
		buttonPanel.add(btn_Abort);

		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				ResumePausedRunActionPerformed(ev);
				AZDBLabObserver.checkRuns();
			}
		});

		btn_Abort.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				mnuitm_AbortPausedRunActionPerformed();
				AZDBLabObserver.checkRuns();
			}
		});

		JButton btn_AddComment = new JButton("Add Comment");
		btn_AddComment.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				AddCommentDlg dlg = new AddCommentDlg(getRunID());
				dlg.setModal(true);
				dlg.setVisible(true);

				refreshCommentList();
			}
		});
		buttonPanel.add(btn_AddComment);
		return buttonPanel;
	}

	private void mnuitm_AbortPausedRunActionPerformed() {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to abort this paused run?", "Aborting Run",
				JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(new Date(System.currentTimeMillis()));
			Run temp_run = User.getUser(strUserName).getNotebook(
					strNotebookName).getExperiment(strExperimentName).getRun(
					strStartTime);
			RunStatus runStat = temp_run.getRunProgress();

			temp_run.insertRunLog(transactionTime, "Aborted",
					runStat.percentage_);
			temp_run.updateRunProgress(transactionTime, "Aborted",
					runStat.percentage_);
			
//			User.getUser(strUserName).getNotebook(strNotebookName)
//					.getExperiment(strExperimentName).getRun(strStartTime)
//					.setExecutorCommand(transactionTime, "Abort");
		}
	}

	private void ResumePausedRunActionPerformed(ActionEvent evt) {
		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to resume this paused run?", "Resume Paused Run",
				JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			String userName = getUserName();
			String notebookName = getNotebookName();
			String experimentName = getExperimentName();

			String startTime = getStartTime();
			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(System.currentTimeMillis());
//			String command = "Resume";

			Run tempRun = User.getUser(userName).getNotebook(notebookName).getExperiment(
					experimentName).getRun(startTime);
			RunStatus rs = tempRun.getRunProgress();
			
//			tempRun.setExecutorCommand(transactionTime, command);
			
//			User.getUser(userName).getNotebook(notebookName).getExperiment(
//					experimentName).getRun(startTime).setExecutorCommand(
//					transactionTime, command);
			// Update currentstage of experimentrun to "Running".
			// update run status to paused
//			tempRun.insertRunLog(transactionTime, "Resumed", rs.percentage_);
//			tempRun.updateRunProgress(transactionTime, "Resumed", rs.percentage_);
			tempRun.insertRunLog(transactionTime, "Running", rs.percentage_);
			tempRun.updateRunProgress(transactionTime, "Running", rs.percentage_);
			bIsResumed = true;
		}

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Paused Run Node");

		return createPausedRunPanel();
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	public List<Comment> getComments() {
		return User.getUser(strUserName).getNotebook(strNotebookName)
				.getExperiment(strExperimentName).getRun(strStartTime)
				.getAllComments();
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
		return "This node contains information pertaining to a paused run";
	}
}
