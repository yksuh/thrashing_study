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

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;

import javax.swing.JTextPane;
import javax.swing.JPanel;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.dataModel.Comment;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddCommentDlg;
import azdblab.swingUI.objectNodes.RenderAspectPanel;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

;

/**
 * The data module for Individual completed run object. Used in creating the
 * views for each individual completed run (with experiment start time) in the
 * GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class CompletedRunNode extends RunStatusNode {

	private boolean bIsOpen;

	private RenderAspectPanel renAspPan;

	public CompletedRunNode(String userName, String notebookName,
			String experimentName, String scenario, String machineName,
			String dbms, String startTime) {

		super(userName, notebookName, experimentName, scenario, machineName,
				dbms, startTime, 0);
		willHaveChildren = true;
////		strNodeName = strDBMS + ":" +User.getUser(strUserName).getNotebook(strNotebookName)
////				.getExperiment(strExperimentName).getRun(strStartTime)
////				.getRunID()+ ":" + strStartTime.substring(0, strStartTime.length()-4);
//		strNodeName = "Z:" +User.getUser(strUserName).getNotebook(strNotebookName)
//				.getExperiment(strExperimentName).getRun(strStartTime)
//				.getRunID()+ ":" + strStartTime.substring(0, strStartTime.length()-4);
		if(Constants.DEMO_SCREENSHOT){
			strNodeName = Constants.hiddenDBMSes.get(strDBMS.toLowerCase()) + ":" +User.getUser(strUserName).getNotebook(strNotebookName)
					.getExperiment(strExperimentName).getRun(strStartTime)
					.getRunID()+ ":" + strStartTime.substring(0, strStartTime.length()-4);	
		}else{
			strNodeName = strDBMS + ":" +User.getUser(strUserName).getNotebook(strNotebookName)
				.getExperiment(strExperimentName).getRun(strStartTime)
				.getRunID()+ ":" + strStartTime.substring(0, strStartTime.length()-4);	
		}
		
	}

	public String getStartTime() {
		return strStartTime;
	}

	public void setIsOpen(boolean isOpen) {
		bIsOpen = isOpen;
	}

	public boolean getIsOpen() {
		return bIsOpen;
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "completedrun.png");
	}
	
	private String getDBName(){
		if(strDBMS.equals("mysql"))
			return "MySQL";
		if(strDBMS.equals("teradata"))
			return "Teradata";
		if(strDBMS.equals("oracle"))
			return "Oracle";
		if(strDBMS.equals("sqlserver"))
			return "SQL Server";
		if(strDBMS.equals("postgresql"))
			return "PostgreSQL";
		if(strDBMS.equals("db2"))
			return "DB2";
		if(strDBMS.equals("javadb"))
			return "Java DB";
		
		return strDBMS;
		
	}
	
	public String getMachineName()
	{
		String name = "sodb";
		int index =0;
		for(int i=0; i< strMachineName.length(); i++){
			if(strMachineName.charAt(i)=='.'){
				index=i;
				break;
			}
		}
		if(strMachineName.charAt(index-2)=='1')
			name+='1';
		name= name+ strMachineName.charAt(index-1);
		
		return name;
				
	}

	private JPanel logPanel;
	private JTextPane logPane;

	private JPanel getModifiedDataPane() {
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "This experiment was started on " + strStartTime.substring(0, strStartTime.length()-4) + ".";
		info += "</h1></CENTER> <font color='blue'>";
		info += "<p>The RunID is "
				+ User.getUser(strUserName).getNotebook(strNotebookName)
						.getExperiment(strExperimentName).getRun(strStartTime)
						.getRunID() + " : " + getDBName() + " : " + getMachineName() + "</p>";
		//info += "<p> on database : " + strDBMS + " </p>";
		info += "</font>";

		info += "</BODY></HTML>";

		JTextPane infoPane = createTextPaneFromString(info);

		List<String> vecInfo = azdblab.labShelf.dataModel.Analytic.getValue(
				strUserName, strNotebookName, strExperimentName, strStartTime);

		String anldetail = "";
		anldetail += "<HTML><BODY><CENTER><h1>";
		anldetail += "Properties of Completed Run started on " + strStartTime.substring(0, strStartTime.length()-4) + ".";
		anldetail += "</h1></CENTER> <font color='blue'>";

		if (vecInfo == null || vecInfo.size() == 0) {
			anldetail += "<p> No analytic defined for this run </p>";
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

		renAspPan = new RenderAspectPanel(strUserName, strNotebookName,
				strExperimentName, strStartTime, parent);
		initializeLogPane();

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Completed Run time info", infoPane);
		npl_toRet.addComponentToTab("Analytic Detail of Completed Run", anlPane);
		npl_toRet.addComponentToTab("Table Information", getResultPane());
		npl_toRet.addComponentToTab("Aspect Indication", renAspPan);
		npl_toRet.addComponentToTab("Run Status",
				createTextPaneFromString(getRunLogHTML()));
		npl_toRet.addComponentToTab("Comments", getCommentPane());
		return npl_toRet;
	}

	private JTextPane getResultPane() {
		String sql = "Select SourceXML from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENT
				+ " where experimentID = "
				+ Experiment.getExperimentID(strUserName, strNotebookName,
						strExperimentName);
		try {
			String info = "<HTML><BODY><CENTER><h1>";
			info += "Table information";
			info += "</h1></CENTER>";

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			rs.next();
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setNamespaceAware(true);
			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);
			Element experimentDefinition = factory.newDocumentBuilder().parse(
					LabShelfManager.getShelf().getInputFromClob(rs.getClob(1)))
					.getDocumentElement();
			Element TableDef = (Element) experimentDefinition
					.getElementsByTagName("tableConfiguration").item(0);
			Element varTableSet = (Element) TableDef.getElementsByTagName(
					"variableTableSet").item(0);
			NodeList nlst = varTableSet.getElementsByTagName("table");
			for (int i = 0; i < nlst.getLength(); i++) {
				Element tab = (Element) nlst.item(i);
				info += "<p> Variable Table <br/>";
				info += "Name = " + tab.getAttribute("name") + " <br />";
				info += "Seed = " + tab.getAttribute("seed") + "</p>";
			}

			Element fixedTableSet = (Element) TableDef.getElementsByTagName(
					"fixedTableSet").item(0);
			nlst = fixedTableSet.getElementsByTagName("table");
			for (int i = 0; i < nlst.getLength(); i++) {
				Element tab = (Element) nlst.item(i);
				info += "<p> Fixed Table <br/>";
				info += "Name = " + tab.getAttribute("name") + "<br/>";
				info += "Seed = " + tab.getAttribute("seed") + "</p>";
			}
			info += "<p> If you want more information on the tables, please view the Data Definition Node </p>";
			info += "</BODY></HTML>";
			rs.close();
			return createTextPaneFromString(info);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return createTextPaneFromString("Failed to create Pane");
	}

	private void initializeLogPane() {
		logPanel = new JPanel();
		logPanel.setLayout(new BorderLayout());

		logPane = new JTextPane();

		JButton getLogButton = new JButton(
				"Get Logfile associated with this run");
		getLogButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				logPanel.remove(logPane);
				logPane = createTextPaneFromString(getLogString());
				logPanel.add(logPane);
				logPanel.revalidate();
				logPanel.repaint();
			}
		});

		logPanel.add(getLogButton, BorderLayout.NORTH);
		logPanel.add(logPane, BorderLayout.CENTER);
	}
	
	

	private String getLogString() {
		String logInfo = "";
		logInfo += "<HTML><BODY><CENTER><h1>";
		logInfo += "Contents of Log File for run on: " + strStartTime;
		logInfo += "</h1></CENTER>";

		String LOG_FILE_NAME = "";
		String path = Constants.AZDBLAB_LOG_DIR_NAME;
		String files;
		File folder = new File(path);
		File[] listOfFiles = folder.listFiles();
		try {
			for (int i = 0; i < listOfFiles.length; i++) {

				if (listOfFiles[i].isFile()) {
					files = listOfFiles[i].getName();
					Process p = Runtime.getRuntime().exec(
							"grep " + strStartTime + " " + path
									+ File.separator + files);
					InputStreamReader isr = new InputStreamReader(p
							.getInputStream());
					BufferedReader br = new BufferedReader(isr);
					if ((br.readLine()) != null) {
						LOG_FILE_NAME = files;
						break;
					}
				}
			}

		} catch (Exception e) {
			Main._logger
					.reportError("Error in ExperimentNode while accessing log Files");
		}
		logInfo += "<p> retrieving logFile " + LOG_FILE_NAME + "</p>";
		try {
			BufferedReader in = new BufferedReader(new FileReader(
					Constants.AZDBLAB_LOG_DIR_NAME + File.separator
							+ LOG_FILE_NAME));
			String curLine;
			while ((curLine = in.readLine()) != null) {
				logInfo += "<p>" + curLine + "</p>";
			}
			in.close();
		} catch (Exception e) {
			logInfo += "<p> The log for this Experiment could not be found </p>";
		}
		return logInfo;
	}

	private JPanel getCompletedRunButtons() {
		JPanel buttonPanel = new JPanel();

		JButton btn_AddComment = new JButton("Add Comment");
		btn_AddComment.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				AddCommentDlg dlg = new AddCommentDlg(getRunID());
				dlg.setModal(true);
				dlg.setVisible(true);

				refreshCommentList();
			}
		});
//
//		JButton btn_Compute = new JButton("Compute Query Statistics");
//		btn_Compute.addActionListener(new ActionListener() {
//			@Override
//			public void actionPerformed(ActionEvent e) {
//				Vector<Query> vecQueries = User.getUser(strUserName)
//						.getNotebook(strNotebookName).getExperiment(
//								strExperimentName).getRun(strStartTime)
//						.getExperimentRunQueries();
//				QueryAnalyzer qa = new QueryAnalyzer();
//				for (int i = 0; i < vecQueries.size(); i++) {
//					qa.analyzeQuery(vecQueries.get(i));
//					System.out.println("QueryNo :: " + vecQueries.get(i).iQueryNumber);
//					System.out.println(vecQueries.get(i).strQuerySQL);
//					System.out.println("iNumCnSel:" + qa.iNumCnSel);
//					System.out.println("iNumCnFrm:" + qa.iNumCnFrm);
//					System.out.println("iNumEqWhere:" + qa.iNumEqWhere);
//					System.out.println("iNumInEqWhere:" + qa.iNumInEqWhere);
//					System.out.println("iNumAndRel:" + qa.iNumAndRel);
//					System.out.println("iNumPredicate:" + qa.iNumPredicate);
//					System.out.println("iNumSelfJoin:" + qa.iNumSelfJoin);
//					System.out.println("iVarTabMultiInFrom:"
//							+ qa.iVarTabMultiInFrom);
//					System.out.println("iTwoSidedPKJoin:" + qa.iTwoSidedPKJoin);
//					System.out.println("iOneSidedPKJoin:" + qa.iOneSidedPKJoin);
//					System.out.println("iZeroSidedPKJoin:"
//							+ qa.iZeroSidedPKJoin);
//					System.out.println("------------------------------------");
//					qa.reset();
//				}
//
//			}
//		});
		buttonPanel.add(btn_AddComment);
		return buttonPanel;
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Completed Run Node");

		return getModifiedDataPane();
	}

	public JPanel getButtonPanel() {
		return getCompletedRunButtons();
	}

	@Override
	protected void loadChildNodes() {
		List<Query> vecQueries = User.getUser(strUserName).getNotebook(
				strNotebookName).getExperiment(strExperimentName).getRun(
				strStartTime).getExperimentRunQueries();

		for (int i = 0; i < vecQueries.size(); i++) {
			Query q = vecQueries.get(i);
			parent.add(new AZDBLABMutableTreeNode(new QueryNode(q.iQueryID,
					q.iQueryNumber, q.getStrQuerySQL())));
		}

		ExperimentNode expNode = (ExperimentNode) ((AZDBLABMutableTreeNode) parent
				.getParent().getParent()).getUserObject();

		DataDefNode dataDefNode = new DataDefNode(expNode.getMyExperimentRun()
				.getDataDefinition());
		AZDBLABMutableTreeNode dataDefTreeNode = new AZDBLABMutableTreeNode(
				dataDefNode);

		parent.add(dataDefTreeNode);

		QueryGenDefNode queryGenDefNode = new QueryGenDefNode(strUserName,
				strNotebookName, strExperimentName, "", expNode
						.getMyExperimentRun(), strStartTime, true);

		AZDBLABMutableTreeNode queryGenDefTreeNode = new AZDBLABMutableTreeNode(
				queryGenDefNode);

		parent.add(queryGenDefTreeNode);

	}

	@Override
	public List<Comment> getComments() {
		return User.getUser(strUserName).getNotebook(strNotebookName)
				.getExperiment(strExperimentName).getRun(strStartTime)
				.getAllComments();
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
		return "This node contains information regarding a completed run";
	}
	
}
