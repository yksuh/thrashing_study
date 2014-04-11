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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;

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
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Paper;
import azdblab.labShelf.dataModel.User;

public class AddTableShortDlg {

	private JFrame tableSave;
	private JTextField txt_TableName;
	private JComboBox cobox_TablePaper;
	private JTextArea txt_TableDescription;
	private String strUserName;
	private int instQueryID;

	/**
	 * The Short version of the add table dialog asks the user to input a name,
	 * a description, and a paper
	 * 
	 * @param userName
	 * @param qID
	 */
	public AddTableShortDlg(String userName, int qID) {
		strUserName = userName;
		instQueryID = qID;
		showFrame();
	}

	/**
	 * This sets up the JFrame for adding a Table to a paper
	 * 
	 * @author Matt
	 */
	private void showFrame() {
		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				tableSave.setVisible(false);
			}
		});

		JButton btn_AddTable = new JButton("Add");
		btn_AddTable.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent x) {
				try {
					btn_AddTableActionPreformed();
				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, "Failed to add Table");
				}
			}
		});
		txt_TableName = new JTextField("");
		User myUser = User.getUser(strUserName);
		List<Notebook> vecNotebooks = myUser.getNotebooks();
		Vector<Paper> vecPapers = new Vector<Paper>();

		for (int i = 0; i < vecNotebooks.size(); i++) {
			vecPapers.addAll(vecNotebooks.get(i).getAllPapers());
		}

	//	Vector<String[]> papers = DataModel.getPapersUser(strUserName);

		DefaultComboBoxModel dcbm = new DefaultComboBoxModel(vecPapers);
		// for (int i = 0; i < papers.size(); i++) {
		// dcbm.addElement(new Paper_Data(papers.get(i)[0], papers.get(i)[1]));
		// }

		cobox_TablePaper = new JComboBox(dcbm);

		txt_TableDescription = new JTextArea("Description of Table");
		txt_TableDescription.setLineWrap(true);
		txt_TableDescription.setBorder(BorderFactory
				.createLineBorder(Color.black));

		JPanel jpl_TableDescription = new JPanel();
		jpl_TableDescription.setLayout(new BorderLayout());
		jpl_TableDescription.add(txt_TableDescription);
		jpl_TableDescription.setSize(700, 300);

		JPanel jpl_addTable = new JPanel();
		jpl_addTable.setLayout(new GridLayout(2, 2));
		jpl_addTable.add(new JLabel("Table Name:"));
		jpl_addTable.add(txt_TableName);
		jpl_addTable.add(new JLabel("Paper:"));
		jpl_addTable.add(cobox_TablePaper);

		JPanel jpl_TableButtons = new JPanel();
		jpl_TableButtons.setLayout(new GridLayout(1, 2));
		jpl_TableButtons.add(btn_AddTable);
		jpl_TableButtons.add(btn_Cancel);

		tableSave = new JFrame("Add this Table to a Paper");
		tableSave.setSize(700, 420);
		tableSave.setLocation(500, 500);
		tableSave.setLayout(new BorderLayout());
		tableSave.add(jpl_addTable, BorderLayout.NORTH);
		tableSave.add(jpl_TableDescription, BorderLayout.CENTER);
		tableSave.add(jpl_TableButtons, BorderLayout.SOUTH);
		tableSave.setVisible(true);
	}

	/**
	 * This method adds a Table to a paper
	 * 
	 * @throws Exception
	 *             SQLException, should be handled by caller
	 * @author Matt
	 */
	private void btn_AddTableActionPreformed() throws Exception {
		int paperID = ((Paper) cobox_TablePaper.getSelectedItem()).getPaperID();
		String TableName = txt_TableName.getText();
		SimpleDateFormat creationDateFormater = new SimpleDateFormat(
				Constants.NEWTIMEFORMAT);
		String currentTime = creationDateFormater.format(new Date(System
				.currentTimeMillis()));
		String description = txt_TableDescription.getText();

		int dataTypes[] = { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_DATE };

		LabShelfManager.getShelf().insertTupleToNotebook(
				Constants.TABLE_PREFIX + Constants.TABLE_TABLE,
				new String[] { "PaperID", "InstantiatedQueryID", "Description",
						"TableName", "CreationTime" },
				new String[] { String.valueOf(paperID), instQueryID + "",
						description + " ", TableName, currentTime }, dataTypes);
		JOptionPane.showMessageDialog(null, "Successfully added Table!");
		tableSave.setVisible(false);

	}
}