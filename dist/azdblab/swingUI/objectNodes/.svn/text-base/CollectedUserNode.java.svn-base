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
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.dialogs.AddUserDlg;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class CollectedUserNode extends ObjectNode {

	public CollectedUserNode() {
		strNodeName = "Users";
		if (User.getAllUsers().size() == 0) {
			willHaveChildren = false;
		}
	}

	public String getIconResource(boolean open) {
		return null;
	}

	private JPanel createCollectedUserNodePanel() {

		String usrinfo = "";
		usrinfo += "<HTML><BODY><CENTER><h1>";
		usrinfo += "All the Users are here!";
		usrinfo += "</h1></CENTER> <font color='blue'>";
		usrinfo += "</font></BODY></HTML>";

		// JTextPane usrPanel = createTextPaneFromString(usrinfo);

		NodePanel npl_tmp = new NodePanel();
		npl_tmp.addComponentToTab("All Users",
				createTextPaneFromString(usrinfo));
		// JPanel userPanel = new JPanel();
		// userPanel.add("All Users", createTextPaneFromString(usrinfo));

		return npl_tmp;
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());
		JButton button = new JButton("Add User");
		buttonPanel.add(button);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				AddUserActionPerformed(ev);
			}
		});
		return buttonPanel;

	}

	
	private void AddUserActionPerformed(ActionEvent ev) {

		AddUserDlg audlg = new AddUserDlg();
		audlg.setModal(true);
		audlg.setVisible(true);

		if (audlg.getDefaultCloseOperation() == 2) {
			String strusername = audlg.getUserName();

			if (strusername == null) {
				return;
			}
			String createDate = new SimpleDateFormat(Constants.NEWTIMEFORMAT)
					.format(new Date(System.currentTimeMillis()));
			LabShelfManager.getShelf().insertUser(strusername, createDate);
			UserNode usermod = new UserNode(strusername);
			usermod.setCreateDate(createDate);

			AZDBLABMutableTreeNode newnode = new AZDBLABMutableTreeNode(usermod);

			AspectDefinitionNode aspectNode = new AspectDefinitionNode(
					strusername, "", "", "", "", "");
			AZDBLABMutableTreeNode aspectTreeNode = new AZDBLABMutableTreeNode(
					aspectNode);
			newnode.add(aspectTreeNode);

			AnalyticDefinitionNode analyticNode = new AnalyticDefinitionNode(
					strusername, "", "", "", "", "");
			AZDBLABMutableTreeNode analyticTreeNode = new AZDBLABMutableTreeNode(
					analyticNode);
			newnode.add(analyticTreeNode);

			AZDBLabObserver.addElementToTree(parent, newnode);
		
		}
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Collected User Node");

		return createCollectedUserNodePanel();
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	@Override
	protected void loadChildNodes() {
		Vector<User> vecuser = User.getAllUsers();
		for (int i = 0; i < vecuser.size(); i++) {
			UserNode userNode = new UserNode(vecuser.get(i).getStrUserName());
			AZDBLABMutableTreeNode userTreeNode = new AZDBLABMutableTreeNode(
					userNode);
			parent.add(userTreeNode);
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

	@Override
	protected String getDescription() {
		return "This node is the parent to all of the users in the labshelf";
	}
}
