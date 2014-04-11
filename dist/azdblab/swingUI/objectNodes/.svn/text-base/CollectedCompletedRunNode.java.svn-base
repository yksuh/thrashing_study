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

import javax.swing.JButton;
import azdblab.Constants;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.objectNodes.CompletedRunNode;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

import java.util.List;
import java.util.Vector;

import javax.swing.JPanel;

/**
 * The data module for CompletedRun object. Used in creating the view for
 * CompletedRun node in the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class CollectedCompletedRunNode extends ObjectNode {

	private String strUserName;

	private String strNotebookName;

	private String strExpName;

	public CollectedCompletedRunNode(String username, String notebookname,
			String expname) {

		strUserName = username;
		strNotebookName = notebookname;
		strExpName = expname;
		strNodeName = "Completed Runs";
			}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "collectedcompletedrun.png");
	}

	private JPanel createCompletedRunPanel() {

		Vector<CompletedRunNode> vecRuns = new Vector<CompletedRunNode>();
		try {
			List<Run> runs = User.getUser(strUserName).getNotebook(
					strNotebookName).getExperiment(strExpName)
					.getCompletedRuns();

			for (Run r : runs) {
				CompletedRunNode crn = new CompletedRunNode(r.getUserName(), r
						.getNotebookName(), r.getExperimentName(), r
						.getScenario(), r.getMachineName(), r.getDBMS(), r
						.getStartTime());
				vecRuns.add(crn);
			}
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "List of Completed Runs";
		info += "</h1></CENTER> <font color='blue'>";
		info += "</font>";

		for (int i = 0; i < vecRuns.size(); i++) {
			info += "<p>" + vecRuns.get(i) + "</p>";
		}

		info += "</BODY></HTML>";
		
		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("List of Completed Runs", createTextPaneFromString(info));
		return npl_toRet;
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Collected Completed Run Node");

		return createCompletedRunPanel();
	}

	private void btn_RefreshActionPreformed() {
		parent.removeAllChildren();

		try {
			List<Run> vecRuns = User.getUser(strUserName).getNotebook(
					strNotebookName).getExperiment(strExpName)
					.getCompletedRuns();

			Vector<CompletedRunNode> vecCompletedRuns = new Vector<CompletedRunNode>();

			for (Run r : vecRuns) {
				CompletedRunNode crn = new CompletedRunNode(r.getUserName(), r
						.getNotebookName(), r.getExperimentName(), r
						.getScenario(), r.getMachineName(), r.getDBMS(), r
						.getStartTime());
				vecCompletedRuns.add(crn);
			}
			if (vecCompletedRuns != null && vecCompletedRuns.size() > 0) {

				int numCompRuns = vecCompletedRuns.size();
				for (int j = 0; j < numCompRuns; j++) {

					CompletedRunNode cmpRunNode = vecCompletedRuns.get(j);

					cmpRunNode.setIsOpen(false);

					AZDBLABMutableTreeNode cmpRunTreeNode = new AZDBLABMutableTreeNode(
							cmpRunNode);

					parent.add(cmpRunTreeNode);

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		AZDBLabObserver.updateUI();
	}

	public JPanel getButtonPanel() {
		JButton btn_Refresh = new JButton("Refresh List of Completed Runs");
		btn_Refresh.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				btn_RefreshActionPreformed();
			}
		});
		JPanel jpl_ButtonPanel = new JPanel();
		jpl_ButtonPanel.setLayout(new FlowLayout());
		jpl_ButtonPanel.add(btn_Refresh);
		return jpl_ButtonPanel;
	}

	@Override
	protected void loadChildNodes() {
		try {
			List<Run> vecRuns = User.getUser(strUserName).getNotebook(
					strNotebookName).getExperiment(strExpName)
					.getCompletedRuns();

			Vector<CompletedRunNode> vecCompletedRuns = new Vector<CompletedRunNode>();

			for (Run r : vecRuns) {
				CompletedRunNode crn = new CompletedRunNode(r.getUserName(), r
						.getNotebookName(), r.getExperimentName(), r
						.getScenario(), r.getMachineName(), r.getDBMS(), r
						.getStartTime());
				vecCompletedRuns.add(crn);
			}
			if (vecCompletedRuns != null && vecCompletedRuns.size() > 0) {

				int numCompRuns = vecCompletedRuns.size();
				for (int j = 0; j < numCompRuns; j++) {

					CompletedRunNode cmpRunNode = vecCompletedRuns.get(j);

					cmpRunNode.setIsOpen(false);

					AZDBLABMutableTreeNode cmpRunTreeNode = new AZDBLABMutableTreeNode(
							cmpRunNode);

					parent.add(cmpRunTreeNode);

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
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
		return "This node is the parent to all of the completed runs for a particular experiment";
	}

}
