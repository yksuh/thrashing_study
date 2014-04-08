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
import azdblab.Constants;
import azdblab.plugins.aspect.*;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The module for each single Analytics Definition
 * @author ruizhang
 *
 */
public class AspectDefinitionNode extends ObjectNode {
	
	private	String		strUserName				= null;
	
	private String		strNotebookName			= null;
	
	private String		strAspectName			= null;
	
	private String		strStyleName			= null;
	
	private String		strAspectDescription	= null;
	
	private String		strAspectSQL			= null;	
	
	
	
	public AspectDefinitionNode(	String userName, 
									String notebookName, 
									String aspectName,
									String styleName,
									String aspectDescription,
									String aspectSQL) {
		
		//dbController			= new InternalDatabaseController(	AZDBLAB.LAB_USERNAME,
		//															AZDBLAB.LAB_PASSWORD, 
		//															AZDBLAB.LAB_CONNECTSTRING );
		
		//dbController.open();
		
		willHaveChildren = false;
		strUserName				= userName;
		
		strNotebookName			= notebookName;
		strAspectName			= aspectName;
		strStyleName			= styleName;
		strAspectDescription	= aspectDescription;
		strAspectSQL			= aspectSQL;
		
		
		strNodeName				= "Aspect Specification for " + userName;
		
		if ((notebookName != null) && (!notebookName.equals(""))) {
			strNodeName		+= " with " + notebookName;
		}
		
		if ((aspectName != null) && (!aspectName.equals(""))) {
			strNodeName		+= " with " + aspectName;
		}
		
	}
	
	
	public String getAspectName() {
		return strAspectName;
	}
	
	
	public String getAspectSQL() {
		return strAspectSQL;
	}
	
	
	public String getAspectDescription() {
		return strAspectDescription;
	}
	
	
	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "Specification_New.png");
	}
	
	
	private JPanel createAspectDefinitionPanel() {	

		AspectPluginManager		aspectMan			= new AspectPluginManager();
		
		JPanel					initPan				= null;
		
		if (strAspectName == null || strAspectName.equals("")) {
			initPan	= aspectMan.createAspect(strUserName, strNotebookName);
		} else {
			initPan	= aspectMan.createAspect(strUserName, strNotebookName, strAspectName, strStyleName, strAspectDescription, strAspectSQL);
		}
		
		String detail	= "";
		detail			+= "<HTML><BODY><CENTER><h1>";
		detail			+= "Aspect " + strAspectName + " is created by " + strUserName + " in notebook " + strNotebookName;
		detail			+= "</h1></CENTER> <font color='blue'>";
		detail			+= "</font>";
		detail			+= "<p>Details:</p>";
		detail			+= "<p>Style: " + strStyleName + "</p>";
		//detail			+= "<p>Description: " + strDescription + "</p>";
		detail			+= "</BODY></HTML>";
		
		//JTextPane detailPane = createTextPaneFromString(detail);

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Aspect Specification", initPan);
		
		return npl_toRet;
		
	}
	
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Aspect Definition Node");

		return createAspectDefinitionPanel();
		
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
		return "This node allows the user to define an aspect for a particular labshelf";
	}

}
