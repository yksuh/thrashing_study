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
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.dataModel.LabShelfManager;

public class AddTableLongDlg {
	/*
	 * This dialog is created from paperNodes, it is the long version as it must
	 * contain all information needed to create a table, only the paperID is
	 * sent to it
	 */

	private JFrame addElement;
	private JComboBox cobox_Query;
	private JTextField txt_name;
	private JTextArea txt_description;
	private int paperID;

	public AddTableLongDlg(int pID) throws Exception {
		paperID = pID;
		showDialog();
	}

	/**
	 * Creates the JFrame
	 * 
	 * @throws Exception
	 */
	private void showDialog() throws Exception {
		DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
		String sql = "Select pd.queryName, inst.InstantiatedQueryID, inst.UserName, inst.NotebookName, inst.ExperimentName from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_PREDEFINED_QUERY
				+ " pd, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_INSTANTIATED_QUERY
				+ " inst where inst.QueryID = pd.QueryID";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			dcbm.addElement(new TableDlgQueryData(rs.getString(2), rs
					.getString(1), rs.getString(3), rs.getString(4), rs
					.getString(5)));
		}
		rs.close();
		cobox_Query = new JComboBox(dcbm);
		txt_name = new JTextField();
		txt_description = new JTextArea("Description...");
		txt_description.setLineWrap(true);
		txt_description.setBorder(BorderFactory.createLineBorder(Color.black));
		JButton btn_Add = new JButton("Add");
		btn_Add.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					addTable_actionPreformed();
					JOptionPane.showMessageDialog(null,
							"Successfully added Table");
					addElement.setVisible(false);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to add Table");
					x.printStackTrace();
				}
			}
		});

		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addElement.setVisible(false);
			}
		});

		JPanel jpl_addFigure = new JPanel();
		jpl_addFigure.setLayout(new GridLayout(2, 2));
		jpl_addFigure.add(new JLabel("Query:"));
		jpl_addFigure.add(cobox_Query);
		jpl_addFigure.add(new JLabel("Name:"));
		jpl_addFigure.add(txt_name);

		JPanel jpl_FigButtons = new JPanel();
		jpl_FigButtons.setLayout(new GridLayout(1, 2));
		jpl_FigButtons.add(btn_Cancel);
		jpl_FigButtons.add(btn_Add);

		JPanel jpl_Description = new JPanel();
		jpl_Description.setLayout(new BorderLayout());
		jpl_Description.setSize(700, 300);
		jpl_Description.add(txt_description, BorderLayout.CENTER);

		addElement = new JFrame("Add Table to Paper");
		addElement.setSize(700, 420);
		addElement.setLocation(500, 500);
		addElement.setLayout(new BorderLayout());
		addElement.add(jpl_addFigure, BorderLayout.NORTH);
		addElement.add(jpl_Description, BorderLayout.CENTER);
		addElement.add(jpl_FigButtons, BorderLayout.SOUTH);
		addElement.setVisible(true);
	}

	/**
	 * Adds the table to the labshelf
	 * 
	 * @throws Exception
	 */
	private void addTable_actionPreformed() throws Exception {
		String pID = paperID + "";
		String TableName = txt_name.getText();
		SimpleDateFormat creationDateFormater = new SimpleDateFormat(
				Constants.NEWTIMEFORMAT);
		String currentTime = creationDateFormater.format(new Date(System
				.currentTimeMillis()));
		int InstantiatedQueryID = ((TableDlgQueryData) cobox_Query
				.getSelectedItem()).InstantiatedQueryID;
		String description = txt_description.getText();

		int dataTypes[] = { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_DATE };

		LabShelfManager.getShelf().insertTupleToNotebook(
				Constants.TABLE_PREFIX + Constants.TABLE_TABLE,
				new String[] { "PaperID", "InstantiatedQueryID", "Description",
						"TableName", "CreationTime" },
				new String[] { pID, InstantiatedQueryID + "",
						description + " ", TableName, currentTime }, dataTypes);
		addElement.setVisible(false);
	}
}

class TableDlgQueryData {
	int InstantiatedQueryID;
	String queryName;
	String userParam;
	String experimentParam;
	String notebookParam;

	public TableDlgQueryData(String ID, String name, String user,
			String notebook, String experiment) {
		InstantiatedQueryID = Integer.parseInt(ID);
		queryName = name;
		userParam = user;
		experimentParam = experiment;
		notebookParam = notebook;
	}

	@Override
	public String toString() {
		return queryName + " param:" + userParam + "_" + notebookParam + "_"
				+ experimentParam;
	}
}
