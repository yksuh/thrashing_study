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

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import azdblab.Constants;

import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JPanel;
import javax.swing.tree.TreeNode;

import azdblab.exception.analysis.InvalidExperimentRunException;
import azdblab.labShelf.dataModel.User;
import azdblab.model.experiment.ExperimentRun;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.SelectDbmsDlg;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The experiment module provides access to the content of the experiment XML.
 * It provides a simple API to extract the information from the XML.
 * 
 * @author
 * 
 */
public class ExperimentNode extends ObjectNode {

	private String strUserName;

	private String strNotebookName;

	/**
	 * The name of the experiment.
	 */
	private String strExperimentName;

	private String strScenario;
	// private Vector<String> strExpDBMSNames;

	private boolean _processed = false;

	/**
	 * The description for this experiment.
	 */
	private String strExpDescription;

	/**
	 * The DOM document for the experiment.
	 */
	private Element elementExpDescription;

	private int iOptimalCardinality;

	private Document expDoc;
	/**
	 * The tests for this experiment.
	 */
	private ExperimentRun myExperimentRun;

	/**
	 * Creates an experiment module.
	 * 
	 * @param exp_source
	 *            The XML source of the experiment module.
	 * @throws InvalidExperimentRunException
	 *             If there is a test that has a problem.
	 * @throws DBMSNotSupportedException
	 *             If the DBMS for a test in the experiment has an invalid DBMS
	 * @throws DBMSInvalidConnectionParameterException
	 *             When the experiment cannot connect to the DBMS.
	 */
	public ExperimentNode(Document experiment, String user_name,
			String notebook_name) {
		strUserName = user_name;
		strNotebookName = notebook_name;

		expDoc = experiment;
		processSourceXML(experiment);

		strNodeName = strExperimentName;

	}

	/**
	 * Returns the description for this experiment.
	 * 
	 * @return The description for this experiment.
	 */
	public String getDescription() {
		return strExpDescription;
	}

	/**
	 * Returns the name of the experiment.
	 * 
	 * @return The name of the experiment.
	 */
	public String getExperimentName() {
		return strExperimentName;
	}

	public String getScenario() {
		return strScenario;
	}

	/**
	 * Returns the name of the experiment.
	 * 
	 * @return The name of the experiment.
	 */
	public String getUserName() {
		return strUserName;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public int getOptimalCardinality() {
		return iOptimalCardinality;
	}

	/**
	 * Returns all the tests for this experiment.
	 * 
	 * @return All the tests for this experiment.
	 */
	public ExperimentRun getMyExperimentRun() {
		return myExperimentRun;
	}

	public void processXML() {
		try {
			myExperimentRun = new ExperimentRun(User.getUser(strUserName)
					.getNotebook(strNotebookName).getExperiment(
							strExperimentName), expDoc.getDocumentElement());
			_processed = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void processSourceXML(Document experiment) {

		elementExpDescription = experiment.getDocumentElement();

		strExpDescription = (elementExpDescription.getChildNodes().item(0))
				.getTextContent();

		strExperimentName = experiment.getDocumentElement()
				.getAttribute("name");
		strScenario = experiment.getDocumentElement().getAttribute("scenario");

	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "experiment_new.png");
	}

	private void RunExperimentActionPerformed(ActionEvent evt) {
		SelectDbmsDlg runExp_Dlg = new SelectDbmsDlg();
		runExp_Dlg.setModal(true);
		runExp_Dlg.setVisible(true);
		List<String> strExpDBMSNames = runExp_Dlg.getDBMS();

		for (int i = 0; i < strExpDBMSNames.size(); i++) { // kind of pointless,
															// this will always
															// be of size 1
			try {
				String machineName = runExp_Dlg.getSelectedExecutor();
				String dbmsName = strExpDBMSNames.get(i).toLowerCase();
				String startTime = new SimpleDateFormat(Constants.TIMEFORMAT)
						.format(new Date(System.currentTimeMillis()));
			
				
				if (machineName.equalsIgnoreCase("any")) {
					User.getUser(strUserName).getNotebook(strNotebookName)
							.getExperiment(strExperimentName)
							.insertExperimentRun(dbmsName, startTime,
									"Pending", 0.0);
				} else {
					User.getUser(strUserName).getNotebook(strNotebookName)
							.getExperiment(strExperimentName)
							.insertExperimentRun(dbmsName, startTime,
									"Pending", 0.0, machineName);
				}

				PendingRunNode newPendingRunNode = new PendingRunNode(
						strUserName, strNotebookName, strExperimentName,
						strScenario, dbmsName, startTime);
				AZDBLABMutableTreeNode newPendingRunTreeNode = new AZDBLABMutableTreeNode(
						newPendingRunNode);
				TreeNode root = parent.getRoot();
				for (int k = 0; k < root.getChildCount(); k++) {
					AZDBLABMutableTreeNode temp = (AZDBLABMutableTreeNode) root
							.getChildAt(k);
					if (temp.getUserObject() instanceof CollectedPendingRunNode) {
						AZDBLabObserver.addElementToTree(temp,
								newPendingRunTreeNode);
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				return;
			}

		}

	}

	private JPanel createExperimentPanel() {
		if (!_processed) {
			processXML();
		}
		JTextPane detailPane = null;
		
		if(strExperimentName.contains("tps")){
			detailPane = createTextPaneFromXML(elementExpDescription, 
					Constants.XACT_SOURCE_TRANSFORM_STYLE);
		}else{
			detailPane = createTextPaneFromXML(elementExpDescription, 
					Constants.SOURCE_TRANSFORM_STYLE);
		}

		List<String> vecInfo = azdblab.labShelf.dataModel.Analytic.getValue(
				strUserName, strNotebookName, strExperimentName, null);

		String anldetail = "";
		anldetail += "<HTML><BODY><CENTER><h1>";
		anldetail += "Properties of Experiment " + strExperimentName;
		anldetail += "</h1></CENTER> <font color='blue'>";

		if (vecInfo == null || vecInfo.size() == 0) {
			anldetail += "<p> No analytic defined for this experiment </p>";
		} else {

			String tableDetail = "<TABLE BORDER=1> " + "<TR>"
					+ "    <TH>Name of Analytic</TH>"
					+ "    <TH>Value of Analytic</TH>"
					+ "    <TH>Analytic Details</TH> " + "</TR>";

			for (int i = 0; i < vecInfo.size(); i++) {
				String[] detail = vecInfo.get(i).split("##");
				tableDetail += "<TR>" + "<TD ALIGN=LEFT>" + detail[0]
						+ "</TD><TD ALIGN=LEFT>" + detail[1]
						+ "<TD ALIGN=LEFT>" + detail[2] + "</TD>" + "</TR>";
			}

			tableDetail += "</TABLE>";

			anldetail += "<p>" + tableDetail + "</p>";
		}

		anldetail += "</font>";
		anldetail += "</BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Experiment", detailPane);
		npl_toRet.addComponentToTab("Experiment Analytics",
				createTextPaneFromString(anldetail));

		if (myExperimentRun != null) {
			if (myExperimentRun.getRoot() != null) {
				JTextPane infoPane = null;
				if(strExperimentName.contains("tps")){
					infoPane = createTextPaneFromXML(myExperimentRun.getRoot(), Constants.XACT_SOURCE_TRANSFORM_STYLE);
				}else{
					infoPane = createTextPaneFromXML(myExperimentRun.getRoot(), Constants.SOURCE_TRANSFORM_STYLE);
				}
				npl_toRet.addComponentToTab("Experiment Run", infoPane);
			}
		}

		return npl_toRet;
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	private JPanel createButtonPanel() {

		JButton btn_RunExperiment = new JButton("Run Experiment");
		btn_RunExperiment.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				RunExperimentActionPerformed(evt);
			}
		});

		JPanel jpl_toRet = new JPanel(new FlowLayout());
		jpl_toRet.add(btn_RunExperiment);
		return jpl_toRet;
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Experiment Node");

		return createExperimentPanel();
	}

	@Override
	protected void loadChildNodes() {
		if (!_processed) {
			processXML();
		}
		DataDefNode dataDefNode = new DataDefNode(myExperimentRun
				.getDataDefinition());
		AZDBLABMutableTreeNode dataDefTreeNode = new AZDBLABMutableTreeNode(
				dataDefNode);
		parent.add(dataDefTreeNode);

		parent.add(new AZDBLABMutableTreeNode(new QueryGenDefNode(strUserName,
				strNotebookName, strExperimentName, "", getMyExperimentRun(),
				null, false)));

		try {
			if (User.getUser(strUserName).getNotebook(strNotebookName)
					.getExperiment(strExperimentName).getCompletedRuns().size() != 0) {
				CollectedCompletedRunNode compRunNode = new CollectedCompletedRunNode(
						strUserName, strNotebookName, strExperimentName);
				AZDBLABMutableTreeNode compRunTreeNode = new AZDBLABMutableTreeNode(
						compRunNode);

				parent.add(compRunTreeNode);
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
