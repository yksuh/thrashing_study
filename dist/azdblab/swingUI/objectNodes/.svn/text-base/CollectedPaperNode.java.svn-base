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
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JTextPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Paper;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class CollectedPaperNode extends ObjectNode {

	private String strUserName;
	private String strNotebookName;
	private JTextField txt_PaperName;
	private JTextArea txt_Description;

	public CollectedPaperNode(String username, String notebookName) {
		strNodeName = "Papers";
		strUserName = username;
		strNotebookName = notebookName;
		if (User.getUser(strUserName).getNotebook(strNotebookName)
				.getAllPapers().size() == 0) {
			willHaveChildren = false;
		}
			}

	private JPanel createCollectedPaperNodePanel() {

		String paperInfo = "";
		paperInfo += "<HTML><BODY><CENTER><h1>";
		paperInfo += "All the Papers are here!";
		paperInfo += "</h1></CENTER> <font color='blue'>";
		paperInfo += "</font></BODY></HTML>";

		JTextPane paperPanel = createTextPaneFromString(paperInfo);

		JButton btn_create = new JButton("Create a new Paper");
		btn_create.addActionListener(new ActionListener() {

			public void actionPerformed(ActionEvent e) {
				btn_create_actionPreformed();
			}
		});

		JPanel colPaperPanel = new JPanel();
		colPaperPanel.setLayout(new BorderLayout());
		colPaperPanel.add(paperPanel, BorderLayout.CENTER);

		txt_PaperName = new JTextField("Paper Name");
		txt_Description = new JTextArea("Description");

		JPanel jpl_CreatePaper = new JPanel();
		jpl_CreatePaper.setLayout(new BorderLayout());
		jpl_CreatePaper.add(txt_PaperName, BorderLayout.NORTH);
		jpl_CreatePaper.add(txt_Description, BorderLayout.CENTER);
		jpl_CreatePaper.add(btn_create, BorderLayout.SOUTH);

		NodePanel Paper_Panel = new NodePanel();
		Paper_Panel.addComponentToTab("All Papers", colPaperPanel);
		Paper_Panel.addComponentToTab("Create a new Paper", jpl_CreatePaper);

		return Paper_Panel;
	}

	private void btn_create_actionPreformed() {
		if (txt_PaperName.getText() == "") {
			JOptionPane.showMessageDialog(null,
					"Error, papers must have a name");
			return;
		}
		Integer paperID = LabShelfManager.getShelf().getSequencialID(
				Constants.SEQUENCE_PAPER);

		int dataTypes[] = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		try {
			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_PAPER,
					new String[] { "PaperID", "Username", "PaperName",
							"Description", "NotebookName" },
					new String[] { String.valueOf(paperID), strUserName,
							txt_PaperName.getText(), txt_Description.getText(),
							strNotebookName }, dataTypes);

			PaperNode papNode = new PaperNode(txt_PaperName.getText(), paperID);
			AZDBLABMutableTreeNode mtn_paperNode = new AZDBLABMutableTreeNode(
					papNode);

			AZDBLabObserver.addElementToTree(parent, mtn_paperNode);
		} catch (SQLException e) {
			JOptionPane.showMessageDialog(null, "Error, failed to add paper");
			e.printStackTrace();
		}

	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Collected Paper Node");

		return createCollectedPaperNodePanel();
	}

	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "Collectedpaper.png";
	}

	@Override
	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {

		List<Paper> vecPapers = User.getUser(strUserName).getNotebook(
				strNotebookName).getAllPapers();

		for (int l = 0; l < vecPapers.size(); l++) {
			PaperNode papNode = new PaperNode(vecPapers.get(l).getPaperName(),
					vecPapers.get(l).getPaperID());
			AZDBLABMutableTreeNode mtn_paperNode = new AZDBLABMutableTreeNode(
					papNode);
			parent.add(mtn_paperNode);
		}
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node is the parent to all of the papers contained by a notebook";
	}

}