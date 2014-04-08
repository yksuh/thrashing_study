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

public class CollectedPausedRunNode extends ObjectNode {

	public CollectedPausedRunNode() {
		strNodeName = "Paused Runs";
	}

	public String getIconResource(boolean open) {
		return null;
	}

	private JPanel createCollectedPausedRunNodePanel() {

		String psdinfo = "";
		psdinfo += "<HTML><BODY><CENTER><h1>";
		psdinfo += "All Paused Runs here";
		psdinfo += "</h1></CENTER> <font color='blue'>";
		psdinfo += "</font></BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("All Paused Runs", createTextPaneFromString(psdinfo));

		return npl_toRet;
	}

	@Override
	public JPanel getDataPanel() {
		return createCollectedPausedRunNodePanel();
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
		return "This node is the parent to all of the paused runs on this labshelf";
	}

}
