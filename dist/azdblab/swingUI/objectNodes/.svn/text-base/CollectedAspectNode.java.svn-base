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




public class CollectedAspectNode extends ObjectNode {
	
	public CollectedAspectNode() {
		willHaveChildren = false;
		strNodeName		= "Aspect Definitions (collected)";
	}
	
	public String getIconResource(boolean open) {
		return null;
	}
	
	
	private JPanel createCollectedAspectNodePanel() {
		
		String		aspinfo		= "";
		aspinfo					+= "<HTML><BODY><CENTER><h1>";
		aspinfo					+= "All the Aspects are here!";
		aspinfo					+= "</h1></CENTER> <font color='blue'>";
		aspinfo					+= "</font></BODY></HTML>";

	
		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("All Aspects", createTextPaneFromString(aspinfo));
		
		return npl_toRet;
	}
	
	@Override
	public JPanel getDataPanel() {
		return createCollectedAspectNodePanel();
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
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information about all of the installed aspects";
	}
}
