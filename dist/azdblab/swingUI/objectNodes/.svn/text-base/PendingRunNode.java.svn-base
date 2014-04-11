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
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JOptionPane;

import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddCommentDlg;
import azdblab.swingUI.treeNodesManager.NodePanel;
import azdblab.labShelf.dataModel.Comment;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;

/**
 * The data module for CompletedRun object. Used in creating the view for
 * CompletedRun node in the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class PendingRunNode extends RunStatusNode {

	public PendingRunNode(String userName, String notebookName,
			String experimentName, String scenario, String dbms,
			String startTime) {

		super(userName, notebookName, experimentName, scenario, "", dbms,
				startTime, 2);
		willHaveChildren = false;
		
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = "Pending Run of [" + experimentName + "," + Constants.hiddenDBMSes.get(dbms.toLowerCase()) + ", " + startTime + "]";
		}else{
			strNodeName = "Pending Run ("+getRunID()+") of [" + experimentName + "," + dbms + ", " + startTime + "]";	
		}
			}

	public PendingRunNode(String userName, String notebookName,
			String experimentName, String machineName, String scenario,
			String dbms, String startTime) {
		super(userName, notebookName, experimentName, scenario, machineName,
				dbms, startTime, 2);
		willHaveChildren = false;
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = "Pending Run of [" + experimentName + "," + Constants.hiddenDBMSes.get(dbms.toLowerCase()) + ":"+ getShortMachineName() + ", " + startTime + "]";
		}else{
			strNodeName = "Pending Run ("+getRunID()+") of [" + experimentName + "," + dbms + ":"+ getShortMachineName() + ", " + startTime + "]";
		}
		
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "pendingrun.png");
	}

	private JPanel createPendingRunPanel() {

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "<p> Experiment : " + strExperimentName + "</p>";
		info += "<p> from notebook : " + strNotebookName + "</p>";
		info += "<p> of user : " + strUserName + "</p>";
		info += "<p> is currently Pending, requested at " + strStartTime
				+ "</p>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "</font>";

		info += "</BODY></HTML>";

		JTextPane infoPane = createTextPaneFromString(info);
		NodePanel nodePanel = new NodePanel();

		nodePanel.addComponentToTab("Pending Run Info", infoPane);
		nodePanel.addComponentToTab("Run Status",
				createTextPaneFromString(getRunLogHTML()));
		nodePanel.addComponentToTab("Comments", getCommentPane());
		return nodePanel;
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());

		JButton button = new JButton("Delete Pending Run");

		buttonPanel.add(button);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				DeletePendingRunActionPerformed(ev);
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
		// TODO
	}

	private void DeletePendingRunActionPerformed(ActionEvent evt) {

		if (JOptionPane.showConfirmDialog(null,
				"Are you sure to delete this pending run?",
				"Delete Pending Run", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {

			String userName = getUserName();
			String notebookName = getNotebookName();
			String experimentName = getExperimentName();
			String startTime = getStartTime();
			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(System.currentTimeMillis());
			Run temp_run = User.getUser(userName).getNotebook(notebookName)
					.getExperiment(experimentName).getRun(startTime);
			temp_run.insertRunLog(transactionTime, "Aborted", 0.0);
			temp_run.updateRunProgress(transactionTime, "Aborted", 0.0);
			try {
				AZDBLabObserver.removeElement(parent);
			} catch (Exception e) {
				System.out
						.println("Please be patient, the pending run will be removed from the queue shortly");
			}
		}

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Pending Run Node");

		return createPendingRunPanel();
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
		return "This node contains information pertaining to a pending run";
	}

}
