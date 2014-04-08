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

import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;




public class CollectedAbortedRunNode extends ObjectNode {
	
	public CollectedAbortedRunNode() {
		strNodeName		= "Aborted Runs";
	}

	
	public String getIconResource(boolean open) {
		return null;
	}
	
	
	private JPanel createCollectedAbortedRunNodePanel() {
		
		String		psdinfo		= "";
		psdinfo					+= "<HTML><BODY><CENTER><h1>";
		psdinfo					+= "All Aborted Runs here";
		psdinfo					+= "</h1></CENTER> <font color='blue'>";
		psdinfo					+= "</font></BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("All Aborted Runs", createTextPaneFromString(psdinfo));
	
		return npl_toRet;
	}
	
	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Collected Aborted Run Node");

		return createCollectedAbortedRunNodePanel();
	}
	public JPanel getButtonPanel()
	{
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
		return "This node is the parent of all of the aborted runs on this labshelf";
	}

}
