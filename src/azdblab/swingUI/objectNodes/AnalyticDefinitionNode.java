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
import azdblab.plugins.analytic.AnalyticPluginManager;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The module for each single Analytics Definition
 * 
 * @author ruizhang
 * 
 */
public class AnalyticDefinitionNode extends ObjectNode {

	private String strUserName = null;

	private String strNotebookName = null;

	private String strAnalyticName = null;

	private String strStyleName = null;

	private String strAnalyticDescription = null;

	private String strAnalyticSQL = null;

	// private LabShelf dbController = LabShelf.getShelf();

	// public AnalyticDefinitionNode(InternalDatabaseController dbController,
	// String user_name, String notebook_name, String analytic_name, String
	// operator, String aspect, String whereclause, String resultavail, String
	// description, String style_name) {
	public AnalyticDefinitionNode(String userName, String notebookName,
			String analyticName, String styleName, String analyticDescription,
			String analyticSQL) {

		// dbController = new InternalDatabaseController( AZDBLAB.LAB_USERNAME,
		// AZDBLAB.LAB_PASSWORD,
		// AZDBLAB.LAB_CONNECTSTRING );

		// dbController.open();

		willHaveChildren = false;
		strUserName = userName;
		strNotebookName = notebookName;
		strAnalyticName = analyticName;
		strStyleName = styleName;
		strAnalyticDescription = analyticDescription;
		strAnalyticSQL = analyticSQL;

		strNodeName = "Analytic Specification for " + userName;

		if ((notebookName != null) && (!notebookName.equals(""))) {
			strNodeName += " with " + notebookName;
		}

		if ((analyticName != null) && (!analyticName.equals(""))) {
			strNodeName += " with " + analyticName;
		}
		

	}

	public String getAnalyticName() {
		return strAnalyticName;
	}

	public String getAnalyticSQL() {
		return strAnalyticSQL;
	}

	public String getAnalyticDescription() {
		return strAnalyticDescription;
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "analytic_new1.png");
	}

	private JPanel createAnalyticDefinitionPanel() {


		AnalyticPluginManager analyticMan = new AnalyticPluginManager();

		JPanel initPan = null;

		if (strAnalyticName == null || strAnalyticName.isEmpty()) {
			initPan = analyticMan.createAnalytic(strUserName, strNotebookName);
		} else {
			initPan = analyticMan.createAnalytic(strUserName, strNotebookName,
					strAnalyticName, strStyleName, strAnalyticDescription,
					strAnalyticSQL);
		}
/*
		String detail = "";
		detail += "<HTML><BODY><CENTER><h1>";
		detail += "Aspect " + strAnalyticName + " is created by " + strUserName
				+ " in notebook " + strNotebookName;
		detail += "</h1></CENTER> <font color='blue'>";
		detail += "</font>";
		detail += "<p>Details:</p>";
		detail += "<p>Style: " + strStyleName + "</p>";
		// detail += "<p>Description: " + strDescription + "</p>";
		detail += "</BODY></HTML>";*/


		// return new JComponentWrapper(aspectDefPanel, strTitle,
		// JComponentWrapper.PANEL_TYPE_PANE);
		
		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Analytic Specification", initPan);
		return npl_toRet;

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Analytic Definition Node");

		return createAnalyticDefinitionPanel();

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
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node allows the user to define an analytic for a labshelf";
	}

}
