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

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.util.List;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;

public class SelectDbmsDlg extends javax.swing.JDialog {
	private Vector<String> DBMS;
	private String selectedExecutor;
	private JList lst_DBMS;
	private JList lst_Executors;
	public static final long serialVersionUID = System
			.identityHashCode("RunExperimentDlg");

	/**
	 * This Dialog allows users to select which DBMS they want an experiment to
	 * run on
	 * 
	 * @param frame
	 */
	public SelectDbmsDlg(JFrame frame) {
		super(frame);
		DBMS = new Vector<String>();
		initGUI();
	}

	public SelectDbmsDlg() {
		super();
		DBMS = new Vector<String>();
		initGUI();
	}

	/**
	 * Displays the JFrame
	 */
	private void initGUI() {
		getContentPane().setLayout(null);
		this.setTitle("Run Paramaters");
		this.setSize(650, 500);

		JLabel lbl_Description = new JLabel("Please select a Database");
		lbl_Description.setBounds(20, 20, 260, 30);
		getContentPane().add(lbl_Description);

		JLabel lbl_SelectExecutor = new JLabel("Please select an Executor");
		lbl_SelectExecutor.setBounds(330, 20, 260, 30);
		getContentPane().add(lbl_SelectExecutor);

		lst_DBMS = new JList(Constants.DBMSs);
		lst_DBMS.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_DBMS.setBounds(20, 70, 300, 340);
		lst_DBMS.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		lst_DBMS.setSelectedIndex(-1);
		getContentPane().add(lst_DBMS);
		lst_DBMS.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent arg0) {
				lst_Executors.removeAll();
				DefaultListModel lmodel = new DefaultListModel();
				lmodel.addElement("Any");
				String sql = "Select machineName from "
						+ Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR
						+ " where currentdbmsname = '"
						+ lst_DBMS.getSelectedValue().toString().toLowerCase()
						+ "'";
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				try {
					while (rs.next()) {
						lmodel.addElement(rs.getString(1));
					}
					rs.close();
				} catch (Exception x) {
					x.printStackTrace();
				}
				lst_Executors.setModel(lmodel);
				lst_Executors.setSelectedIndex(0);
			}
		});

		lst_Executors = new JList();
		lst_Executors.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

		JScrollPane scrp_Executor = new JScrollPane();
		scrp_Executor.setBounds(330, 70, 300, 340);
		scrp_Executor.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		scrp_Executor.setViewportView(lst_Executors);
		getContentPane().add(scrp_Executor);

		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.setBounds(20, 430, 300, 30);
		getContentPane().add(btn_Cancel);
		btn_Cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});

		JButton btn_Add = new JButton("Ok");
		btn_Add.setBounds(330, 430, 300, 30);
		getContentPane().add(btn_Add);
		btn_Add.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				DBMS = new Vector<String>();
				Object tmp[] = lst_DBMS.getSelectedValues();
				for (int i = 0; i < tmp.length; i++) {
					DBMS.add((String) tmp[i]);
				}
				selectedExecutor = lst_Executors.getSelectedValue().toString();
				dispose();
			}
		});

		JLabel border = new JLabel();
		getContentPane().add(border);
		border.setBounds(10, 10, 630, 455);
		border.setBorder(BorderFactory.createLineBorder(Color.BLACK));
	}

	/**
	 * @return the selected DBMS, or an empty vector if none selected
	 */
	public List<String> getDBMS() {
		return DBMS;
	}

	/**
	 * @return If this experiment is constrained on the Executors it can run on,
	 *         that value is returned here, otherwsie any is returned
	 */
	public String getSelectedExecutor() {
		return selectedExecutor;
	}
}
