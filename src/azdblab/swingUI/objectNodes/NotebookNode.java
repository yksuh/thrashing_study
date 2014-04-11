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
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;
import java.awt.event.ActionEvent;
import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import azdblab.Constants; //import azdblab.swingUI.treeNodesManager.NodePanel;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.XMLHelper;
import azdblab.model.queryAnalyzer.QueryAnalyzer;
import azdblab.observer.api.ResultOpenInterface;
import azdblab.observer.controller.listeners.OpenActionListener;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.CreateExperimentDlg;
import azdblab.swingUI.dialogs.PortingDlg;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class NotebookNode extends ObjectNode implements ResultOpenInterface {

	private String strUserName;

	private String strNotebookName;

	private String strDateCreate;

	private String strDescription;

	public NotebookNode(String username, String notebookname, String description) {
		strUserName = username;
		strNotebookName = notebookname;
		strDescription = description;
		strNodeName = strNotebookName;
		if(Constants.DEMO_SCREENSHOT){
			if(strNodeName.contains("Test")){
				strNodeName = "SIGMOD2014";
			}
		}
	}

	public void setCreateDate(String createdate) {
		strDateCreate = createdate;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public String getCreateDate() {
		return strDateCreate;
	}

	public String getDescription() {
		return strDescription;
	}

	public String getIconResource(boolean open) {
		if (open) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "Test_New.png");
		} else {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "folder_closed.png");
		}
	}

	private JPanel createNotebookPanel() {
		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "Notebook "
				+ strNotebookName
				+ " is created on "
				+ User.getUser(strUserName).getNotebook(strNotebookName)
						.getCreateDate();
		info += "</h1></CENTER> <font color='blue'>";
		info += "</font></BODY></HTML>";

		JTextPane infoPane = createTextPaneFromString(info);

		// Story Section
		String description = "";
		description += "<HTML><BODY><h1>";
		description += strDescription;
		description += "</h1> <font color='blue'>";
		description += "</font></BODY></HTML>";

		List<String> vecInfo = azdblab.labShelf.dataModel.Analytic.getValue(
				strUserName, strNotebookName, null, null);

		String anldetail = "";
		anldetail += "<HTML><BODY><CENTER><h1>";
		anldetail += "Properties of Notebook " + strNotebookName;
		anldetail += "</h1></CENTER> <font color='blue'>";

		if (vecInfo == null || vecInfo.size() == 0) {
			anldetail += "<p> No analytic defined for this query </p>";
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

		JTextPane anlPane = createTextPaneFromString(anldetail);

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("User Info", infoPane);
		npl_toRet.addComponentToTab("User Analytics", anlPane);
		return npl_toRet;

	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Notebook Node");

		return createNotebookPanel();
	}

	private JPanel createButtonPanel() {

		JButton btn_CreateExperiment = new JButton("Create Experiment");
		btn_CreateExperiment.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				createExperimentActionPreformed();
			}
		});

		JPanel jpl_btnPanel = new JPanel();
		jpl_btnPanel.setLayout(new FlowLayout());
		JButton btn_LoadExperiment = new JButton("Load Experiment");
		JButton btn_ImportExperiment = new JButton("Import Experiment");
		JButton btn_ExportExperiment = new JButton("Export Experiment");

		JButton btn_ComputeQueryStats = new JButton(
				"Add Query Statistics for all Experiments");
		btn_ComputeQueryStats.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					// DeletePK();
					// System.out.println("Done Deleting");
					ComputePK();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

		});
		jpl_btnPanel.add(btn_LoadExperiment);
		jpl_btnPanel.add(btn_ImportExperiment);
		jpl_btnPanel.add(btn_ExportExperiment);
		jpl_btnPanel.add(btn_CreateExperiment);
		jpl_btnPanel.add(btn_ComputeQueryStats);

		btn_LoadExperiment
				.addActionListener(new OpenActionListener(null, this));

		btn_ImportExperiment.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				ImportExperimentActionPerformed(evt);
			}
		});
		btn_ExportExperiment.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent evt) {
				ExportNotebookActionPerformed(evt);
			}
		});
		return jpl_btnPanel;
	}

	private void ComputePK() throws Exception {

		Vector<Run> vecRuns = Run.getAllRuns();

		for (int j = 0; j < vecRuns.size(); j++) {
			QueryAnalyzer qa = new QueryAnalyzer();
			List<Query> vecQueries = vecRuns.get(j).getExperimentRunQueries();
			for (int k = 0; k < vecQueries.size(); k++) {
				qa.analyzeQuery(vecQueries.get(k));
//				String sqlParam = "INSERT INTO " + Constants.TABLE_PREFIX
//						+ Constants.TABLE_QUERYHASPARAMETER + " VALUES ("
//						+ vecQueries.get(k).iQueryID
//						+ ", 'NUMZEROSIDEDPKJOINS'," + qa.iZeroSidedPKJoin
//						+ ")";
//				LabShelfManager.getShelf().executeUpdateQuery(sqlParam);
//
//				sqlParam = "INSERT INTO " + Constants.TABLE_PREFIX
//						+ Constants.TABLE_QUERYHASPARAMETER + " VALUES ("
//						+ vecQueries.get(k).iQueryID
//						+ ", 'NUMONESIDEDPKJOINS'," + qa.iOneSidedPKJoin + ")";
//				LabShelfManager.getShelf().executeUpdateQuery(sqlParam);
//
//				sqlParam = "INSERT INTO " + Constants.TABLE_PREFIX
//						+ Constants.TABLE_QUERYHASPARAMETER + " VALUES ("
//						+ vecQueries.get(k).iQueryID
//						+ ", 'NUMTWOSIDEDPKJOINS'," + qa.iTwoSidedPKJoin + ")";
//				LabShelfManager.getShelf().executeUpdateQuery(sqlParam);
//
//				LabShelfManager.getShelf().commitlabshelf();
				qa.reset();
			}
			
//			/***
//			 * If run concerns a pk
//			 */
//			String expName = ((vecRuns.get(j)).getExperimentName()).toLowerCase();
//			if (expName.contains("pk")) {
//				List<Query> vecPKQueries = vecRuns.get(j).getExperimentRunQueries();
//				for (int k = 0; k < vecPKQueries.size(); k++) {
//					HashMap<String, Integer> resultMap = qa
//							.calculateQueryParameters(vecPKQueries.get(k));
//					Map testResMap = new TreeMap(resultMap);
//					Iterator iter = testResMap.entrySet().iterator();
//					while (iter.hasNext()) {
//						Map.Entry testEntry = (Map.Entry) iter.next();
//						String testName = (String) testEntry.getKey();
//						int testValue = ((Integer) testEntry.getValue())
//								.intValue();
//						String insertSQL = "INSERT INTO "
//								+ Constants.TABLE_PREFIX
//								+ Constants.TABLE_QUERYHASPARAMETER
////								+ "temp_pk_param2 "
//								+ " VALUES (" + vecQueries.get(k).iQueryID
//								+ ",'" + testName + "'," + testValue + ")";
//						System.out.println(insertSQL);
//						LabShelfManager.getShelf()
//								.executeUpdateQuery(insertSQL);
//						LabShelfManager.getShelf().commitlabshelf();
//					}
//				}
//			}
		}
	}

	public void loadExperiment(String strExpFileName) {

		String userName = strUserName;
		String notebookName = strNotebookName;

		// Check to see if the experiment is already open.

		File expFile = new File(strExpFileName);

		try {
			String schemaName = "";
			if(strExpFileName.contains("tps") || strExpFileName.contains("xt")){
				schemaName = Constants.CHOSEN_XACTEXPERIMENT_SCHEMA;
			}else{
				schemaName = Constants.CHOSEN_EXPERIMENT_SCHEMA;
			}
			
			// Make sure that the XML is valid
			if (XMLHelper.isValid(new FileInputStream(new File(
					(schemaName))),
					new FileInputStream(expFile))) {

				Document expSource = XMLHelper.validate(new FileInputStream(
						new File(schemaName)),
						new FileInputStream(expFile));

				String experimentName = expSource.getDocumentElement()
						.getAttribute("name");

				String scenario = expSource.getDocumentElement().getAttribute(
						"scenario");
				// updates the experiment definition if possible. It may not be
				// possible if an experiment already
				// exists but has all different tests.
				String startTime = new SimpleDateFormat(Constants.NEWTIMEFORMAT)
						.format(new Date(System.currentTimeMillis()));

				Notebook selected_notebook = User.getUser(userName)
						.getNotebook(notebookName);
				selected_notebook.insertExperiment(scenario, experimentName,
						strExpFileName, startTime, new FileInputStream(
								new File(strExpFileName)));

				Experiment new_experiment = selected_notebook
						.getExperiment(experimentName);

				String absolutePath = expFile.getParent();

				// Insert the DataDefinition Spec and QueryGenerator Spec

				Element experimentRoot = expSource.getDocumentElement();

				NodeList dataDefinitionList = experimentRoot
						.getElementsByTagName("dataDefinition");
				if (dataDefinitionList.getLength() == 0) {
					dataDefinitionList = experimentRoot
							.getElementsByTagName("dataDefinitionReference");
					String href = ((Element) dataDefinitionList.item(0))
							.getAttribute("href");

					Document dataDefDoc = XMLHelper.readDocument(new File(
							absolutePath + "/" + href));
					String dataDefName = dataDefDoc.getDocumentElement()
							.getAttribute("name");

					int testSpecID = LabShelfManager.getShelf()
							.insertExperimentSpec(dataDefName,
									new File(absolutePath + "/" + href), "D");

					new_experiment.insertRefersExperimentSpec("D", testSpecID);

				}

				if(!strExpFileName.contains("tps") || !strExpFileName.contains("xt")){
					NodeList queryDefinitionList = experimentRoot
							.getElementsByTagName("queryDefinition");
					if (queryDefinitionList.getLength() == 0) {
						queryDefinitionList = experimentRoot
								.getElementsByTagName("queryDefinitionReference");
						String href = ((Element) queryDefinitionList.item(0))
								.getAttribute("href");

						Document queryDefDoc = XMLHelper.readDocument(new File(
								absolutePath + "/" + href));
						String queryDefName = queryDefDoc.getDocumentElement()
								.getAttribute("name");
						int testSpecID = LabShelfManager.getShelf()
								.insertExperimentSpec(queryDefName,
										new File(absolutePath + "/" + href), "Q");

						new_experiment.insertRefersExperimentSpec("Q", testSpecID);

					}
					loadExperimentNode(parent, userName, notebookName, new File(
							strExpFileName), false);
				}
				else{
					loadExperimentNode(parent, userName, notebookName, new File(
							strExpFileName), true);	
				}
				
				AZDBLabObserver.updateUI();

			} else {

				JOptionPane
						.showMessageDialog(
								null,
								"Failed to open file '"
										+ strExpFileName
										+ "' because the file was not a valid experiment xml format");

				System.err
						.println("Failed to open file '"
								+ strExpFileName
								+ "' because the file was not a valid experiment xml format");
			}
		} catch (Exception e) {
			System.err.println("Failed to open file '" + strExpFileName
					+ "' because ");
			e.printStackTrace();
		}
	}

	private void loadExperimentNode(AZDBLABMutableTreeNode notebookNode,
			String userName, String notebookName, File expFile, boolean tpsflag) {

		try {

			HashMap<String, AZDBLABMutableTreeNode> mapScenarioTreeNodes = new HashMap<String, AZDBLABMutableTreeNode>();

			Vector<ExperimentNode> vecExpNodes = new Vector<ExperimentNode>();

			String schemaName = "";
			if(tpsflag){
				schemaName = Constants.CHOSEN_XACTEXPERIMENT_SCHEMA;
			}else{
				schemaName = Constants.CHOSEN_EXPERIMENT_SCHEMA;
			}
			if (expFile != null) {

				Document expsource = XMLHelper.validate(
						new FileInputStream(
								new File(schemaName)),
								new FileInputStream(expFile));
				
				ExperimentNode newExpNode = new ExperimentNode(expsource,
						userName, notebookName);
				vecExpNodes.add(newExpNode);

			} else {

				vecExpNodes = new Vector<ExperimentNode>();

				List<Experiment> experiments = User.getUser(userName)
						.getNotebook(notebookName).getAllExperiments();

				for (Experiment e : experiments) {
					vecExpNodes.add(new ExperimentNode(e.getExperimentSource(),
							e.getUserName(), e.getNotebookName()));
				}
			}

			for (int i = 0; i < vecExpNodes.size(); i++) {

				ExperimentNode expNode = vecExpNodes.get(i);
				AZDBLABMutableTreeNode expTreeNode = new AZDBLABMutableTreeNode(
						expNode);

				String experimentName = expNode.getExperimentName();
				String scenario = expNode.getScenario();

				if (expFile != null) {

					int numChildren = notebookNode.getChildCount();

					boolean bFound = false;

					for (int j = 0; j < numChildren; j++) {

						AZDBLABMutableTreeNode childNode = (AZDBLABMutableTreeNode) notebookNode
								.getChildAt(j);

						if (childNode.getUserObject() instanceof ScenarioNode) {

							ScenarioNode newScenNode = (ScenarioNode) childNode
									.getUserObject();

							if (scenario.equals(newScenNode.getScenario())) {
								childNode.add(expTreeNode);
								bFound = true;
								break;
							}

						}

					}

					if (!bFound) {

						ScenarioNode newScenNode = new ScenarioNode(userName,
								notebookName, scenario, "Nothing Description");

						AZDBLABMutableTreeNode scenTreeNode = new AZDBLABMutableTreeNode(
								newScenNode);

						scenTreeNode.add(expTreeNode);

						notebookNode.add(scenTreeNode);

					}

				} else {

					if (mapScenarioTreeNodes.containsKey(scenario)) {

						AZDBLABMutableTreeNode scenTreeNode = mapScenarioTreeNodes
								.get(scenario);

						scenTreeNode.add(expTreeNode);

					} else {

						ScenarioNode newScenNode = new ScenarioNode(userName,
								notebookName, scenario, "Nothing Description");

						AZDBLABMutableTreeNode scenTreeNode = new AZDBLABMutableTreeNode(
								newScenNode);

						scenTreeNode.add(expTreeNode);

						notebookNode.add(scenTreeNode);

						mapScenarioTreeNodes.put(scenario, scenTreeNode);

					}

				}

				ExperimentRun er = expNode.getMyExperimentRun();
				if (er != null) {

					DataDefNode dataDefNode = new DataDefNode(er
							.getDataDefinition());
					AZDBLABMutableTreeNode dataDefTreeNode = new AZDBLABMutableTreeNode(
							dataDefNode);

					expTreeNode.add(dataDefTreeNode);

					QueryGenDefNode queryGenDefNode = new QueryGenDefNode(
							userName, notebookName, experimentName, "", er,
							null, false);

					AZDBLABMutableTreeNode queryGenDefTreeNode = new AZDBLABMutableTreeNode(
							queryGenDefNode);

					expTreeNode.add(queryGenDefTreeNode);
				}

				// INSERT THE COMPLETED RUN RESULT
				List<Run> vecRuns = User.getUser(userName).getNotebook(
						notebookName).getExperiment(experimentName)
						.getCompletedRuns();
				Vector<CompletedRunNode> vecCompletedRuns = new Vector<CompletedRunNode>();
				for (Run r : vecRuns) {
					CompletedRunNode crn = new CompletedRunNode(
							r.getUserName(), r.getNotebookName(), r
									.getExperimentName(), r.getScenario(), r
									.getMachineName(), r.getDBMS(), r
									.getStartTime());
					vecCompletedRuns.add(crn);
				}
				if (vecCompletedRuns != null && vecCompletedRuns.size() > 0) {

					int numCompRuns = vecCompletedRuns.size();

					CollectedCompletedRunNode compRunNode = new CollectedCompletedRunNode(
							userName, notebookName, experimentName);
					AZDBLABMutableTreeNode compRunTreeNode = new AZDBLABMutableTreeNode(
							compRunNode);

					for (int j = 0; j < numCompRuns; j++) {

						CompletedRunNode cmpRunNode = vecCompletedRuns.get(j);

						cmpRunNode.setIsOpen(false);

						AZDBLABMutableTreeNode cmpRunTreeNode = new AZDBLABMutableTreeNode(
								cmpRunNode);

						compRunTreeNode.add(cmpRunTreeNode);

					}

					expTreeNode.add(compRunTreeNode);

				}

				// mapOpenedExperiments.put(experimentName + ".xml",
				// experimentName + ".xml");

			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	private void ImportExperimentActionPerformed(ActionEvent evt) {

		JOptionPane.showMessageDialog(null, "Not Available now.");

		PortingDlg pd = new PortingDlg(0, 3);
		pd.setModal(true);
		pd.setVisible(true);

	}

	private void exportNotebook() {
		JOptionPane.showMessageDialog(null, "TEST OF EXPORTING NOTEBOOK");

		PortingDlg pd = new PortingDlg(1, 2);
		pd.setModal(true);
		pd.setVisible(true);

		if (pd.getOption() == 2) {

		}
	}

	private void ExportNotebookActionPerformed(ActionEvent evt) {
		exportNotebook();
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	@Override
	protected void loadChildNodes() {

		List<Experiment> experiments = User.getUser(strUserName).getNotebook(
				strNotebookName).getAllExperiments();
		ArrayList<String> scen = new ArrayList<String>();

		for (int i = 0; i < experiments.size(); i++) {
			Experiment exp = experiments.get(i);
			if (!scen.contains(exp.getScenario())) {
				ScenarioNode newScenNode = new ScenarioNode(strUserName,
						strNotebookName, exp.getScenario(),
						"Nothing Description");
				AZDBLABMutableTreeNode scenTreeNode = new AZDBLABMutableTreeNode(
						newScenNode);
				parent.add(scenTreeNode);
				scen.add(exp.getScenario());
			}
		}

		AspectDefinitionNode aspectNode = new AspectDefinitionNode(strUserName,
				strNotebookName, "", "", "", "");
		AZDBLABMutableTreeNode aspectTreeNode = new AZDBLABMutableTreeNode(
				aspectNode);
		parent.add(aspectTreeNode);

		AnalyticDefinitionNode analyticNode = new AnalyticDefinitionNode(
				strUserName, strNotebookName, "", "", "", "");
		AZDBLABMutableTreeNode analyticTreeNode = new AZDBLABMutableTreeNode(
				analyticNode);
		parent.add(analyticTreeNode);

		CollectedPaperNode paperNode = new CollectedPaperNode(strUserName,
				strNotebookName);
		AZDBLABMutableTreeNode treeNodePaperCollected = new AZDBLABMutableTreeNode(
				paperNode);

		parent.add(treeNodePaperCollected);

		CollectedAnalysisNode analyNode = new CollectedAnalysisNode(
				strUserName, strNotebookName);
		AZDBLABMutableTreeNode treeNodeAnalysisCollected = new AZDBLABMutableTreeNode(
				analyNode);
		parent.add(treeNodeAnalysisCollected);
	}

	private void createExperimentActionPreformed() {
		CreateExperimentDlg dlg_Create = new CreateExperimentDlg(strUserName,
				strNotebookName);
		dlg_Create.setVisible(true);
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
