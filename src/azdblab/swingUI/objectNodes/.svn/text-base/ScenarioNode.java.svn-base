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

import java.util.List;
import java.util.Vector;

import javax.swing.JTextPane;
import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.User;
import azdblab.plugins.scenario.Scenario;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class ScenarioNode extends ObjectNode {

	private String strUserName;

	private String strNotebookName;

	private String strScenario;

	private String strDescription;

	public ScenarioNode(String username, String notebookname, String scenario,
			String description) {
		strUserName = username;
		strNotebookName = notebookname;
		strScenario = scenario;
		strDescription = description;

		strNodeName = strScenario;

	}

	public String getUserName() {
		return strUserName;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public String getScenario() {
		return strScenario;
	}

	public String getDescription() {
		return strDescription;
	}

	public String getIconResource(boolean open) {
		if (open) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "scenario.png");
		} else {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "scenario.png");
		}
	}

	private JPanel createScenarioPanel() {

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "Scenario " + strScenario;
		info += "</h1></CENTER> <font color='blue'>";
		info += "</font></BODY></HTML>";

		JTextPane infoPane = createTextPaneFromString(info);

		// Story Section
		/*String description = "";
		description += "<HTML><BODY><h1>";
		description += strDescription;
		description += "</h1> <font color='blue'>";
		description += "</font></BODY></HTML>";*/

		// JTextPane descriptionPane = createTextPaneFromString(description);

		// Install All the sections into tabs
		NodePanel scenarioPanel = new NodePanel();
		scenarioPanel.addComponentToTab("Scenario Info", infoPane);
		scenarioPanel.addComponentToTab("Scenario Description",
				createTextPaneFromString(getScenarioDescription()));
		// notebookPanel.addComponentToTab("Description", descriptionPane);
		// return new JComponentWrapper(notebookPane, strNotebookName,
		// JComponentWrapper.PANEL_TYPE_PANE);

		return scenarioPanel;

	}

	public String getScenarioDescription() {
		String html = "<html><body>";
		html += "<center>";
		html += "<h1> Description of scenario " + strScenario + "</h1>";
		html += Scenario.getDescription(strScenario).replace("\n", "<p>");
		html += "</center>";
		html += "</body></html>";
		return html;
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Scenario Node");

		return createScenarioPanel();
	}

	public JPanel getButtonPanel() {

		return null;
	}

	public boolean equals(Object node) {
		return strScenario.equals(((ScenarioNode) node).strScenario);
	}

	@Override
	protected void loadChildNodes() {
		try {
			List<Experiment> experiments = User.getUser(strUserName)
					.getNotebook(strNotebookName).getAllExperiments();

			for (int i = 0; i < experiments.size(); i++) {
				Experiment exp = experiments.get(i);
				if (exp.getScenario().equals(strScenario)) {
					ExperimentNode newExpNode = new ExperimentNode(exp
							.getExperimentSource(), exp.getUserName(), exp
							.getNotebookName());
					AZDBLABMutableTreeNode newChild = new AZDBLABMutableTreeNode(
							newExpNode);
					parent.add(newChild);
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

}
