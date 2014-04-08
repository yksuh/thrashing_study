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
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.awt.FlowLayout;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JList;
import javax.swing.JTextArea;

import javax.swing.JTextPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.ListSelectionModel;

import azdblab.Constants;
import azdblab.executable.Main;

import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddNotebookDlg;
import azdblab.swingUI.dialogs.PortingDlg;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The data module for each user object. Used in creating the views for user in
 * the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class UserNode extends ObjectNode {

	private String strUserName;

	private String strDateCreate;


	public UserNode(String userName) {
		strUserName = userName;
		strNodeName = strUserName;
	}

	public void setCreateDate(String create) {
		strDateCreate = create;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getCreateDate() {
		return strDateCreate;
	}

	public String getIconResource(boolean open) {
		if (open) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "user.png");
		} else {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "user.png");
		}
	}

	public String createDescription() {
		/*
		 * @mjseo new routine for more effective string concatenation
		 */
		StringBuffer sb = new StringBuffer();
		sb.append("<HTML><BODY><CENTER><h1>");
		sb.append("User " + strUserName + " is created on "
				+ User.getUser(strUserName).getStrDateCreate());
		sb.append("</h1></CENTER> <font color='blue'>");
		sb.append("</font></BODY></HTML>");

		/*
		 * @mjseo comment inefficient string concatenation
		 */
		// String info = "";
		// info += "<HTML><BODY><CENTER><h1>";
		// info += "User " + strUserName + " is created on " + strDateCreate;
		// info += "</h1></CENTER> <font color='blue'>";
		// info += "</font></BODY></HTML>";

		return sb.toString();
	}

	public String createUserAnalytic() {
		List<String> vecInfo = azdblab.labShelf.dataModel.Analytic.getValue(
				strUserName, null, null, null);

		String anldetail = "";
		anldetail += "<HTML><BODY><CENTER><h1>";
		anldetail += "Properties of User " + strUserName;
		anldetail += "</h1></CENTER> <font color='blue'>";

		if (vecInfo == null || vecInfo.size() == 0) {
			anldetail += "<p> No analytic defined </p>";
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

		return anldetail;

	}

	private JTextPane logPane;
	private JPanel l_panel;
	private JList lst_Logs;

	private void ImportNotebookActionPerformed(ActionEvent evt) {

		JOptionPane.showMessageDialog(null, "Not Available now.");

		PortingDlg pd = new PortingDlg(0, 2);
		pd.setModal(true);
		pd.setVisible(true);
	}

	private JPanel createUserPanel() {

		// Description Section
		String description = createDescription();

		JTextPane infoPane = createTextPaneFromString(description);

		String anlDetail = createUserAnalytic();

		JTextPane anlPane = createTextPaneFromString(anlDetail);

		// For the current Run's log file
		InitializeCurrentLogDisplay();

		// For all Run's log files
		InitializeAllLogsDisplay();

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("User Info", infoPane);
		npl_toRet.addComponentToTab("User Analytics", anlPane);
		return npl_toRet;
	}

	private JTextArea txt_ShowLog;

	private JPanel InitializeAllLogsDisplay() {
		JButton btn_getLogs = new JButton("Get Logs for User:" + strUserName);
		btn_getLogs.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					File[] listOfFiles = new File(
							Constants.AZDBLAB_LOG_DIR_NAME).listFiles();
					DefaultListModel lmodel = new DefaultListModel();
					for (int i = 0; i < listOfFiles.length; i++) {
						if (listOfFiles[i].isFile()) {
							String files = listOfFiles[i].getName();
							Process p = Runtime.getRuntime().exec(
									"grep " + strUserName + " "
											+ Constants.AZDBLAB_LOG_DIR_NAME
											+ File.separator + files);
							p.waitFor();
							InputStreamReader isr = new InputStreamReader(p
									.getInputStream());
							BufferedReader br = new BufferedReader(isr);
							if ((br.readLine()) != null) {
								lmodel.addElement(files);
							}
						}
					}
					lst_Logs.setModel(lmodel);
					lst_Logs.setSelectedIndex(-1);
				} catch (Exception x) {
					x.printStackTrace();
				}

			}
		});

		lst_Logs = new JList();
		lst_Logs.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_Logs.setVisibleRowCount(20);
		JButton btn_ShowLog = new JButton("Show");
		btn_ShowLog.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (lst_Logs.getSelectedIndex() == -1) {
					return;
				}
				String selectedLog = (String) lst_Logs.getSelectedValue();
				txt_ShowLog.setText(getLogText(Constants.AZDBLAB_LOG_DIR_NAME
						+ File.separator + selectedLog));
			}
		});

		JPanel jpl_List = new JPanel();
		jpl_List.setLayout(new BorderLayout());
		jpl_List.add(lst_Logs, BorderLayout.CENTER);
		jpl_List.add(btn_ShowLog, BorderLayout.SOUTH);

		txt_ShowLog = new JTextArea();
		txt_ShowLog.setLineWrap(true);
		txt_ShowLog.setEditable(false);

		JPanel jpl_Bottom = new JPanel();
		jpl_Bottom.setLayout(new GridLayout(1, 2));
		jpl_Bottom.add(jpl_List);
		jpl_Bottom.add(txt_ShowLog);

		JPanel jpl_Logs = new JPanel();
		jpl_Logs.setLayout(new BorderLayout());
		jpl_Logs.add(btn_getLogs, BorderLayout.NORTH);
		jpl_Logs.add(jpl_Bottom, BorderLayout.SOUTH);
		return jpl_Logs;
	}

	private void InitializeCurrentLogDisplay() {
		l_panel = new JPanel();
		logPane = createTextPaneFromString(getLogText());
		JButton logButton = new JButton("Refresh Log File");
		logButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				l_panel.remove(logPane);
				logPane = createTextPaneFromString(getLogText());
				l_panel.add(logPane, BorderLayout.CENTER);
				l_panel.revalidate();
				l_panel.repaint();
			}
		});
		l_panel.setLayout(new BorderLayout());
		l_panel.add(logButton, BorderLayout.PAGE_START);
		l_panel.add(logPane, BorderLayout.CENTER);
	}

	private String getLogText() {
		String logInfo = "";
		logInfo += "<HTML><BODY><CENTER><h1>";
		logInfo += "Contents of Log File";
		logInfo += "</h1></CENTER>";
		try {
			// BufferedReader in = new BufferedReader(new
			// FileReader(Main._logger
			// .getAZDBLabLoggerName()));
			BufferedReader in = new BufferedReader(new FileReader(Main._logger
					.getAZDBLabLoggerName()));
			String curLine;
			while ((curLine = in.readLine()) != null) {
				logInfo += "<p>" + curLine + "</p>";
			}
			in.close();
		} catch (FileNotFoundException e) {
			// Main._logger.reportError(Main._logger.getAZDBLabLoggerName()
			// + " not found");
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, "Cannot find '"
					+ Main._logger.getAZDBLabLoggerName()
					+ "'. Observer will now be terminated.");
		} catch (IOException e) {
			e.printStackTrace();
		}
		logInfo += "</BODY></HTML>";
		return logInfo;
	}

	private String getLogText(String path) {
		String logInfo = "";
		logInfo += "<HTML><BODY><CENTER><h1>";
		logInfo += "Contents of Log File";
		logInfo += "</h1></CENTER>";
		try {
			BufferedReader in = new BufferedReader(new FileReader(path));
			String curLine;
			while ((curLine = in.readLine()) != null) {
				logInfo += "<p>" + curLine + "</p>";
			}
			in.close();
		} catch (FileNotFoundException e) {
			// Main._logger.reportError(Main._logger.getAZDBLabLoggerName()
			// + " not found");
			e.printStackTrace();
			JOptionPane.showMessageDialog(null, "Cannot find '"
					+ Main._logger.getAZDBLabLoggerName()
					+ "'. Observer will now be terminated.");
		} catch (IOException e) {
			e.printStackTrace();
		}
		logInfo += "</BODY></HTML>";
		return logInfo;

	}

	private void NewNotebookActionPerformed(ActionEvent evt) {

		AddNotebookDlg anbdlg = new AddNotebookDlg();
		anbdlg.setModal(true);
		anbdlg.setVisible(true);

		if (anbdlg.getDefaultCloseOperation() == 1) {
			String notebookName = anbdlg.getNotebookName();

			if (notebookName == null) {
				return;
			}

			String strdescription = anbdlg.getNotebookDescription();

			String createDate = new SimpleDateFormat(Constants.NEWTIMEFORMAT)
					.format(new Date(System.currentTimeMillis()));

			User.getUser(strUserName).insertNotebook(notebookName,
					createDate, strdescription);

			NotebookNode notebookmod = new NotebookNode(strUserName,
					notebookName, strdescription);
			notebookmod.setCreateDate(createDate);

			AZDBLABMutableTreeNode newnode = new AZDBLABMutableTreeNode(
					notebookmod);

//			AspectDefinitionNode aspectNode = new AspectDefinitionNode(
//					strUserName, "", "", "", "", "");
//			AZDBLABMutableTreeNode aspectTreeNode = new AZDBLABMutableTreeNode(
//					aspectNode);
//			newnode.add(aspectTreeNode);

//			AnalyticDefinitionNode analyticNode = new AnalyticDefinitionNode(
//					strUserName, "", "", "", "", "");
//			AZDBLABMutableTreeNode analyticTreeNode = new AZDBLABMutableTreeNode(
//					analyticNode);
//			newnode.add(analyticTreeNode);

			AZDBLabObserver.addElementToTree(parent, newnode);
		}
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());

		// String currentUser = System.getProperty("user.name");

		JButton button = new JButton("New Notebook");
		JButton button1 = new JButton("Import Notebook");

		buttonPanel.add(button);
		buttonPanel.add(button1);

		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				NewNotebookActionPerformed(ev);
			}
		});

		button1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				ImportNotebookActionPerformed(ev);
			}
		});


		return buttonPanel;
	}


	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a User Node");
		return createUserPanel();
	}

	@Override
	protected void loadChildNodes() {
		List<Notebook> notebooks = User.getUser(strUserName).getNotebooks();
		for (int i = 0; i < notebooks.size(); i++) {
			NotebookNode nToAdd = new NotebookNode(strUserName, notebooks
					.get(i).getNotebookName(), notebooks.get(i)
					.getDescription());
			AZDBLABMutableTreeNode notebookTreeNode = new AZDBLABMutableTreeNode(
					nToAdd);
			parent.add(notebookTreeNode);
		}
		AspectDefinitionNode aspectNode = new AspectDefinitionNode(strUserName,
				"", "", "", "", "");
		AZDBLABMutableTreeNode aspectTreeNode = new AZDBLABMutableTreeNode(
				aspectNode);
		parent.add(aspectTreeNode);

		AnalyticDefinitionNode analyticNode = new AnalyticDefinitionNode(
				strUserName, "", "", "", "", "");
		AZDBLABMutableTreeNode analyticTreeNode = new AZDBLABMutableTreeNode(
				analyticNode);
		parent.add(analyticTreeNode);

		PredefinedQueryNode preDefQuery = new PredefinedQueryNode(strUserName);
		AZDBLABMutableTreeNode mtn_Querys = new AZDBLABMutableTreeNode(
				preDefQuery);
		parent.add(mtn_Querys);

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
		return "This node contains information pertaining to a user";
	}
}
