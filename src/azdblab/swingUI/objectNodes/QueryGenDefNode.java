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
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JPanel;
import azdblab.Constants;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.queryGenerator.PredefinedQueryGenerator;
import azdblab.model.queryGenerator.QueryGenerator;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddCommentDlg;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The module for each single Analytics Definition
 * 
 * @author ruizhang
 * 
 */
public class QueryGenDefNode extends ObjectNode {

	private String strUserName = null;

	private String strNotebookName = null;

	private String strExperimentName = null;

	private String strTestTime = null;

	// private String strStyleName = null;

	private boolean bhasResult;

	// private InternalDatabaseController myDBController;

	private ExperimentRun myTest = null;

	private String[] strQueries = null;

	public QueryGenDefNode(
			// InternalDatabaseController dbController,
			String user_name, String notebook_name, String experiment_name,
			String style_name, ExperimentRun test, String test_time,
			boolean has_result) {

		// myDBController = dbController;
		willHaveChildren = false;
		strUserName = user_name;
		strNotebookName = notebook_name;
		strExperimentName = experiment_name;
		// strStyleName = style_name;

		myTest = test;

		strTestTime = test_time;

		bhasResult = has_result;

		strNodeName = "Query Generation Definition";
	}

	public String getUserName(){
		return strUserName;
	}
	
	public String getNotebookName(){
		return strNotebookName;
	}
	
	public String getExperimentName(){
		return strExperimentName;
	}
	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "querydef_new.png");
	}

	private JPanel createQueryGeneratorDefinitionPanel() {

		QueryGenerator tmpQG = myTest.getMyQueryGenerator();
		if (strTestTime != null) {
			tmpQG.setTestTime(strTestTime);
		}

		String detail = "";
		detail += "<HTML><BODY><CENTER><center><h1>";
		detail += "Query Generator of " + strUserName + " in notebook "
				+ strNotebookName + " for experiment " + strExperimentName;
		detail += "</h1></CENTER>";
		detail += "<p>" + tmpQG.getDescription(bhasResult) + "</p>";
		detail += "</center></BODY></HTML>";

		JTextPane detailPane = createTextPaneFromString(detail);

		NodePanel npl_toRet = new NodePanel();
		// qryGenDefPanel.addComponentToTab("Query Generator Specification",
		// initPan);
		npl_toRet.addComponentToTab("Query Generator Info", detailPane);
		if (tmpQG instanceof PredefinedQueryGenerator) {
			npl_toRet.addComponentToTab("Queries",
					getQueryTab((PredefinedQueryGenerator) tmpQG));
		}
		// return new JComponentWrapper(aspectDefPanel, strTitle,
		// JComponentWrapper.PANEL_TYPE_PANE);
		return npl_toRet;
	}

	private JTextPane getQueryTab(PredefinedQueryGenerator gen) {
		if (gen.myQueries == null) {
			return null;
		}
		String html = "<html><body><center>";

		html += "<table border=\"1\">";
		html += "<tr><th>Query#</th><th>SQL</th></tr>";
		for (int i = 0; i < gen.myQueries.length; i++) {
			html += "<tr><td>" + i + "</td><td>" + gen.myQueries[i]
					+ "</td></tr>";
		}
		html += "</table>";
		html += "</center></body></html>";
		
		strQueries  = gen.myQueries;
		return createTextPaneFromString(html);
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Query Generation Definition Node");

		return createQueryGeneratorDefinitionPanel();

	}
	
	public JPanel getButtonPanel() {
		return null;
//		return getEvalPKQueryParamButtons();
	}

	public String[] getQueries(){
		return strQueries; 
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
		return "This is the module for analytic generation";
	}
}
