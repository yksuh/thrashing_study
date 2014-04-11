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

import java.util.Vector;

import javax.swing.JPanel;

import azdblab.swingUI.treeNodesManager.NodePanel;

//import azdblab.swingUI.treeNodesManager.NodePanel;

public class CollectedPendingRunNode extends ObjectNode {

	public CollectedPendingRunNode() {
		strNodeName = "Pending Runs";
	}

	public String getIconResource(boolean open) {
		return null;
	}

	private JPanel createCollectedPendingRunNodePanel() {

		String pendinfo = "";
		pendinfo += "<HTML><BODY><CENTER><h1>";
		pendinfo += "All Pending Runs here";
		pendinfo += "</h1></CENTER> <font color='blue'>";
		pendinfo += "</font></BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("All Pending Runs",createTextPaneFromString(pendinfo));

		return npl_toRet;
	}

	@Override
	public JPanel getDataPanel() {
		return createCollectedPendingRunNodePanel();
	}

	public JPanel getButtonPanel() {
		return null;
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
		return "This node is the parent to all of the pending runs on this labshelf";
	}
}
