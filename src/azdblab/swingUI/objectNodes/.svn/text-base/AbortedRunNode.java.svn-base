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

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JTextPane;

import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Comment;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
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
public class AbortedRunNode extends RunStatusNode {

	public AbortedRunNode(String userName, String notebookName,
			String experimentName, String scenario, String machineName,
			String dbms, String startTime) {

		super(userName, notebookName, experimentName, scenario, machineName,
				dbms, startTime, 4);
		willHaveChildren = false;
		strNodeName = "Aborted Run of [" + experimentName + "," + dbms + ","
		+ startTime + "," + userName + "," + notebookName + "]";
		
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "Abort_New.png");
	}

	private JPanel createAbortedRunPanel() {

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

		// Install All the sections into tabs

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Aborted Run info", infoPane);
		npl_toRet.addComponentToTab("Run Status", createTextPaneFromString(getRunLogHTML()));
		npl_toRet.addComponentToTab("Comments", getCommentPane());

	//	JPanel runPanel = new JPanel();
	//	runPanel.add("Aborted Run info", infoPane);

		return npl_toRet;

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Aborted Run Node");

		return createAbortedRunPanel();
	}

	public JPanel getButtonPanel() {

		JPanel buttonPanel = new JPanel();
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
		return "This node contains information about a run that has been aborted";
	}

}
