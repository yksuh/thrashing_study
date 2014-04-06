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
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;

import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.PredefinedQuery;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.objectNodes.PredefinedQueryNode;

public class AddInstantiatedQueryDlg extends javax.swing.JDialog {
	private static final long serialVersionUID = System
			.identityHashCode("AddInstantiatedQueryDlg");;
	private String username;
	private JFrame querySave;

	private JTextArea txt_QueryText;

	private JList lst_Times;
	private JComboBox cobox_Experiments;
	private JComboBox cobox_Notebooks;
	private JComboBox cobox_Users;
	private JComboBox cobox_PredefQuerys;
	private PredefinedQueryNode caller;

	/**
	 * This GUI allows a user to instantiate a predefined query, it does not
	 * extend javax.swing.JDialog, allowing it to run independently of the main
	 * frame.
	 * 
	 * @param user
	 */
	public AddInstantiatedQueryDlg(String user, PredefinedQueryNode call) {
		caller = call;
		username = user;
		init();
	}

	/**
	 * Displays the GUI
	 */
	private void init() {

		lst_Times = new JList();
		lst_Times
				.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
		lst_Times.setBorder(BorderFactory.createLineBorder(Color.black));

		cobox_Experiments = new JComboBox();
		cobox_Experiments.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					List<Run> expRuns = User.getUser(
							(String) cobox_Users.getSelectedItem())
							.getNotebook(
									(String) cobox_Notebooks.getSelectedItem())
							.getExperiment(
									(String) cobox_Experiments
											.getSelectedItem())
							.getCompletedRuns();
					DefaultListModel lmodel = new DefaultListModel();
					for (int i = 0; i < expRuns.size(); i++) {
						lmodel.addElement(expRuns.get(i).getStartTime());
					}
					lst_Times.setModel(lmodel);
				} catch (Exception x) {
					x.printStackTrace();
				}
			}
		});

		cobox_Notebooks = new JComboBox();
		cobox_Notebooks.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				List<Experiment> vecExperiments = User.getUser(
						(String) cobox_Users.getSelectedItem()).getNotebook(
						(String) cobox_Notebooks.getSelectedItem())
						.getAllExperiments();

				DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
				for (int i = 0; i < vecExperiments.size(); i++) {
					dcbm.addElement(vecExperiments.get(i).getExperimentName());
				}
				cobox_Experiments.setModel(dcbm);
				cobox_Experiments.setSelectedIndex(-1);
			}
		});

		Vector<User> users = User.getAllUsers();
		DefaultComboBoxModel dcbmUser = new DefaultComboBoxModel();
		for (int i = 0; i < users.size(); i++) {
			dcbmUser.addElement(users.get(i).getUserName());
		}
		cobox_Users = new JComboBox(dcbmUser);
		cobox_Users.setSelectedIndex(-1);
		cobox_Users.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				List<Notebook> notebooks = User.getUser(
						(String) cobox_Users.getSelectedItem()).getNotebooks();
				DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
				for (int i = 0; i < notebooks.size(); i++) {
					dcbm.addElement(notebooks.get(i).getNotebookName());
				}
				cobox_Notebooks.setModel(dcbm);
				cobox_Notebooks.setSelectedIndex(-1);
			}
		});

		JPanel jpl_Times = new JPanel();
		jpl_Times.setLayout(new BorderLayout());
		jpl_Times.add(new JLabel("Times"), BorderLayout.NORTH);
		jpl_Times.add(lst_Times, BorderLayout.CENTER);

		JPanel jpl_BasicParams = new JPanel();
		jpl_BasicParams.setLayout(new GridLayout(3, 2));
		((GridLayout) jpl_BasicParams.getLayout()).setVgap(5);
		((GridLayout) jpl_BasicParams.getLayout()).setHgap(5);
		jpl_BasicParams.add(new JLabel("User"));
		jpl_BasicParams.add(cobox_Users);
		jpl_BasicParams.add(new JLabel("Notebook"));
		jpl_BasicParams.add(cobox_Notebooks);
		jpl_BasicParams.add(new JLabel("Experiments"));
		jpl_BasicParams.add(cobox_Experiments);

		JPanel jpl_QueryParams = new JPanel();
		jpl_QueryParams.setLayout(new GridLayout(2, 1));
		jpl_QueryParams.add(jpl_BasicParams);
		jpl_QueryParams.add(jpl_Times);

		List<PredefinedQuery> vecQuerys = User.getUser(username)
				.getPredefinedQuerys();
		DefaultComboBoxModel dcbmQuery = new DefaultComboBoxModel();
		for (int i = 0; i < vecQuerys.size(); i++) {
			dcbmQuery.addElement(vecQuerys.get(i));
		}
		cobox_PredefQuerys = new JComboBox(dcbmQuery);
		cobox_PredefQuerys.setSelectedIndex(-1);
		cobox_PredefQuerys.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				txt_QueryText.setText(((PredefinedQuery) cobox_PredefQuerys
						.getSelectedItem()).getQuerySQL().replace(":@:", "'"));
			}
		});
		txt_QueryText = new JTextArea();
		txt_QueryText.setEditable(false);
		txt_QueryText.setLineWrap(true);
		txt_QueryText.setPreferredSize(new Dimension(700, 150));
		txt_QueryText.setBorder(BorderFactory.createLineBorder(Color.black));

		JPanel jpl_QuerySelect = new JPanel();
		jpl_QuerySelect.setLayout(new BorderLayout());
		jpl_QuerySelect.add(cobox_PredefQuerys, BorderLayout.NORTH);
		jpl_QuerySelect.add(txt_QueryText, BorderLayout.CENTER);

		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				querySave.setVisible(false);
			}
		});
		JButton btn_Add = new JButton("Add");
		btn_Add.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					saveInstantiatedQuery();
					JOptionPane.showMessageDialog(null,
							"Successfully instantiated Query");
					querySave.setVisible(false);
					querySave.dispose();
					caller.refreshInstList();
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to instantiate Query");
					x.printStackTrace();
				}
			}
		});

		JPanel jpl_QueryButtons = new JPanel();
		jpl_QueryButtons.setLayout(new GridLayout(1, 2));
		jpl_QueryButtons.add(btn_Cancel);
		jpl_QueryButtons.add(btn_Add);

		querySave = new JFrame("Instantiate Query");
		querySave.setSize(700, 620);
		querySave.setLocation(500, 500);
		querySave.setLayout(new BorderLayout());
		querySave.add(jpl_QuerySelect, BorderLayout.NORTH);
		querySave.add(jpl_QueryParams, BorderLayout.CENTER);
		querySave.add(jpl_QueryButtons, BorderLayout.SOUTH);
		querySave.setVisible(true);
	}

	/**
	 * Save the query, any unselected fields are instantiated to "NULL"
	 * 
	 * @throws Exception
	 */
	private void saveInstantiatedQuery() throws Exception {
		if (cobox_PredefQuerys.getSelectedIndex() == -1) {
			throw new Exception();
		}
		String user_param = (String) cobox_Users.getSelectedItem();
		String notebook_param = (String) cobox_Notebooks.getSelectedItem();
		String experiment_param = (String) cobox_Experiments.getSelectedItem();
		if (user_param == null) {
			user_param = "NULL";
		}
		if (notebook_param == null) {
			notebook_param = "NULL";
		}
		if (experiment_param == null) {
			experiment_param = "NULL";
		}

		Object objs[] = lst_Times.getSelectedValues();
		Vector<String> time_param = new Vector<String>();
		for (int i = 0; i < objs.length; i++) {
			time_param.add(objs[i].toString());
		}
		InstantiatedQuery.addInstantiatedQuery(
				((PredefinedQuery) cobox_PredefQuerys.getSelectedItem())
						.getQueryID(), user_param, notebook_param,
				experiment_param, time_param);
	}
}
