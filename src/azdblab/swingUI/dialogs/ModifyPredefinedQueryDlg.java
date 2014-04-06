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
package azdblab.swingUI.dialogs;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import azdblab.labShelf.dataModel.PredefinedQuery;
import azdblab.swingUI.objectNodes.PredefinedQueryNode;

public class ModifyPredefinedQueryDlg extends javax.swing.JDialog {
	/**
	 * 
	 */
	private static final long serialVersionUID = System
			.identityHashCode("AddPredefinedQueryDlg");
	private String strUsername;
	private JFrame querySave;
	private JTextField txt_QueryName;
	private JTextArea txt_QueryText;
	private JTextArea txt_QueryDescription;
	private int QueryID; // this will be null if deleteMode isn't true;
	private PredefinedQueryNode caller;

	private boolean _deleteMode;

	/**
	 * The purpose of this dlg is to add a predefined query to the lab notebook,
	 * it does NOT extend javax.swing.JDialog, rather it runs independently of
	 * the main view
	 * 
	 * @param username
	 */
	public ModifyPredefinedQueryDlg(String username, PredefinedQueryNode call) {
		_deleteMode = false;
		caller = call;
		strUsername = username;
		init();
	}

	public ModifyPredefinedQueryDlg(String username, int QueryID,
			PredefinedQueryNode call) {
		_deleteMode = true;
		caller = call;
		strUsername = username;
		init();
		PredefinedQuery pd = PredefinedQuery.getPredefinedQuery(QueryID);
		txt_QueryDescription.setText(pd.getDescription());
		txt_QueryText.setText(pd.getQuerySQL());
		txt_QueryName.setText(pd.getQueryName());
		this.QueryID = pd.getQueryID();

	}

	/**
	 * Displays the new JFrame
	 */
	private void init() {

		txt_QueryDescription = new JTextArea();
		txt_QueryDescription.setLineWrap(true);
		txt_QueryDescription.setBorder(BorderFactory
				.createLineBorder(Color.black));

		JPanel jpl_QueryDescription = new JPanel();
		jpl_QueryDescription.setLayout(new BorderLayout());
		jpl_QueryDescription.add(new JLabel("Description"), BorderLayout.NORTH);
		jpl_QueryDescription.add(txt_QueryDescription, BorderLayout.CENTER);

		txt_QueryText = new JTextArea();
		txt_QueryText.setLineWrap(true);
		txt_QueryText.setBorder(BorderFactory.createLineBorder(Color.black));

		JPanel jpl_QueryText = new JPanel();
		jpl_QueryText.setLayout(new BorderLayout());
		jpl_QueryText.add(new JLabel("Query"), BorderLayout.NORTH);
		jpl_QueryText.add(txt_QueryText, BorderLayout.CENTER);

		JPanel jpl_QueryData = new JPanel();
		jpl_QueryData.setLayout(new GridLayout(1, 2));
		((GridLayout) jpl_QueryData.getLayout()).setHgap(10);
		jpl_QueryData.add(jpl_QueryText);
		jpl_QueryData.add(jpl_QueryDescription);

		txt_QueryName = new JTextField();

		JPanel jpl_queryName = new JPanel();
		jpl_queryName.setLayout(new GridLayout(1, 2));
		jpl_queryName.add(new JLabel("Query Name"));
		jpl_queryName.add(txt_QueryName);

		JPanel jpl_QueryButtons = new JPanel();
		if (!_deleteMode) {

			JButton btn_Cancel = new JButton("Cancel");
			btn_Cancel.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					querySave.setVisible(false);
				}
			});

			JButton btn_Add = new JButton("Add");
			btn_Add.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					addQuery();
				}
			});

			jpl_QueryButtons.setLayout(new GridLayout(1, 2));
			jpl_QueryButtons.add(btn_Cancel);
			jpl_QueryButtons.add(btn_Add);
		} else {
			JButton btn_Cancel = new JButton("Cancel");
			btn_Cancel.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					querySave.setVisible(false);
					querySave.dispose();
				}
			});

			JButton btn_Delete = new JButton("Delete");
			btn_Delete.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					PredefinedQuery.deleteQuery(QueryID);
					caller.refreshUninstList();
					caller.refreshInstList();
					querySave.setVisible(false);
					querySave.dispose();
				}
			});

			JButton btn_Modify = new JButton("Update Query");
			btn_Modify.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					PredefinedQuery.deleteQuery(QueryID);
					PredefinedQuery.addQuery(txt_QueryDescription.getText(),
							txt_QueryText.getText(), strUsername, txt_QueryName
									.getText());
					caller.refreshUninstList();
					querySave.setVisible(false);
					querySave.dispose();
				}
			});

			jpl_QueryButtons.setLayout(new GridLayout(1, 3));
			jpl_QueryButtons.add(btn_Cancel);
			jpl_QueryButtons.add(btn_Modify);
			jpl_QueryButtons.add(btn_Delete);
		}
		((GridLayout) jpl_QueryButtons.getLayout()).setHgap(5);
		querySave = new JFrame("Add Predefined Query");
		querySave.setSize(700, 420);
		querySave.setLocation(500, 500);
		querySave.setLayout(new BorderLayout());
		querySave.add(jpl_queryName, BorderLayout.NORTH);
		querySave.add(jpl_QueryData, BorderLayout.CENTER);
		querySave.add(jpl_QueryButtons, BorderLayout.SOUTH);
		querySave.setVisible(true);
	}

	/**
	 * Adds the query to the notebook, replaces all "'" with ":@:" to get around
	 * the fact that ' is a special character
	 */
	private void addQuery() {
		PredefinedQuery.addQuery(txt_QueryDescription.getText(), txt_QueryText
				.getText(), strUsername, txt_QueryName.getText());
		caller.refreshUninstList();
		querySave.setVisible(false);
		this.dispose();
	}
}