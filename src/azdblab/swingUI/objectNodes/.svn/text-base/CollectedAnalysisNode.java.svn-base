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
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Analysis;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class CollectedAnalysisNode extends ObjectNode {
	private String strUserName;
	private String strNotebookName;

	public CollectedAnalysisNode(String user, String notebook) {
		strNodeName = "Analysis";
		strUserName = user;
		strNotebookName = notebook;
		
		if(User.getUser(strUserName).getNotebook(
				strNotebookName).getAllAnalysis().size() == 0){
			willHaveChildren = false;
		}
		
	}

	private JPanel createDataPanel() {
		NodePanel npl_Analysis = new NodePanel();
		npl_Analysis.addComponentToTab("Create a new Analysis",
				initializeCreateTab());
		return npl_Analysis;
	}

	private JPanel initializeCreateTab() {
		JButton btn_Create = new JButton("Create a new Analysis");
		btn_Create.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String analyName = JOptionPane.showInputDialog(null,
						"Please input an analysis name");
				if (analyName.equals("")) {
					JOptionPane.showMessageDialog(null,
							"No name inputed, aborting analysis creation");
					return;
				}

				if (Analysis.insertAnalysis(analyName, strUserName,
						strNotebookName) == 0) {
					JOptionPane.showMessageDialog(null,
							"Successfully Created Analysis");
					AnalysisNode anlNode = new AnalysisNode(User
							.getUser(strUserName).getNotebook(strNotebookName)
							.getAnalysis(analyName).getAnalysisID());
					AZDBLABMutableTreeNode mtn_anlNode = new AZDBLABMutableTreeNode(
							anlNode);

					AZDBLabObserver.addElementToTree(parent, mtn_anlNode);
					return;
				}
				JOptionPane.showMessageDialog(null,
				"Failed to Create Analysis");
			}
		});

		JPanel jpl_Create = new JPanel();
		jpl_Create.add(btn_Create);
		return jpl_Create;
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Collected Analysis Node");

		return createDataPanel();
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "Collectedanalysis.png";
	}

	@Override
	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {
		List<Analysis> vecAnalysis = User.getUser(strUserName).getNotebook(
				strNotebookName).getAllAnalysis();
		for (int i = 0; i < vecAnalysis.size(); i++) {
			AnalysisNode anlNode = new AnalysisNode(vecAnalysis.get(i).getAnalysisID());
			AZDBLABMutableTreeNode mtn_anlNode = new AZDBLABMutableTreeNode(
					anlNode);
			parent.add(mtn_anlNode);
		}
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node is the parent of all analysis stored in a notebook";
	}

}