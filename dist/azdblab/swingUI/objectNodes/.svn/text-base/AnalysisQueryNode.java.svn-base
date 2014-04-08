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
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

import javax.swing.DefaultComboBoxModel;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Analysis;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class AnalysisQueryNode extends ObjectNode {
	private int analysisID;
	private boolean analysisModifiable = true;;

	private JList lst_queries;
	private JTextArea txt_QueryView;
	private JComboBox cobox_selectQuery;

	/**
	 * Analysis query Nodes provide information on the queries in the analysis
	 * 
	 * @param ID
	 *            the analysisID of the analysis
	 */
	public AnalysisQueryNode(String ID) {
		this(Integer.parseInt(ID));
	}

	public AnalysisQueryNode(int ID) {
		analysisID = ID;
		strNodeName = "Queries";
		willHaveChildren = false;
		analysisModifiable = Analysis.getAnalysis(ID).getModifiable();
			}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());
		JButton button = new JButton("Add AnalysisQuery");
		buttonPanel.add(button);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				AddAnalysisQueryActionPerformed(ev);
			}
		});
		return buttonPanel;

	}

	private void AddAnalysisQueryActionPerformed(ActionEvent ev) {

	}

	/**
	 * Initializes the panel that adds queries to the analysis
	 * 
	 * @return
	 */
	private JPanel initializeOptions() {
		JButton btn_addQuery = new JButton("Add Query to Analysis");
		btn_addQuery.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (analysisModifiable) {
					Analysis.getAnalysis(analysisID).insertQueryIntoAnalysis(
							((InstantiatedQuery) cobox_selectQuery
									.getSelectedItem())
									.getInstantiatedQueryID());
				} else {
					JOptionPane.showMessageDialog(null,
							"Cannot add Queries to frozen Analysis");
				}
				lst_queries.setModel(getQueryListModel());
				cobox_selectQuery.setModel(getQueryBoxModel());
			}
		});

		cobox_selectQuery = new JComboBox(getQueryBoxModel());
		JPanel jpl_Options = new JPanel();
		if (cobox_selectQuery.getModel().getSize() > 0) {
			jpl_Options.add(cobox_selectQuery);
			jpl_Options.add(btn_addQuery);
		} else {
			jpl_Options.add(new JLabel(
					"All predefined queries are already in this analysis"));
		}

		return jpl_Options;

	}

	/**
	 * Initializes the panel that allows users to view queries already in the
	 * analysis
	 * 
	 * @return
	 */
	private JPanel initializeView() {
		lst_queries = new JList(getQueryListModel());
		lst_queries.setLayoutOrientation(JList.VERTICAL);
		lst_queries.setVisibleRowCount(-1);
		lst_queries.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_queries.setSelectedIndex(-1);

		JButton btn_showQuery = new JButton("Show Selected Query");
		btn_showQuery.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (lst_queries.getSelectedIndex() == -1) {
					return;
				}
				txt_QueryView.setText(((InstantiatedQuery) lst_queries
						.getSelectedValue()).getInstantiatedSQL());
			}
		});
		txt_QueryView = new JTextArea("Query Text will appear here");
		txt_QueryView.setEditable(false);
		txt_QueryView.setLineWrap(true);

		JPanel jpl_viewTop = new JPanel();
		jpl_viewTop.setLayout(new BorderLayout());
		jpl_viewTop.add(new JLabel("Select a Query to View"),
				BorderLayout.NORTH);
		jpl_viewTop.add(lst_queries, BorderLayout.CENTER);
		jpl_viewTop.add(btn_showQuery, BorderLayout.SOUTH);

		JPanel jpl_View = new JPanel();
		jpl_View.setLayout(new GridLayout(2, 1));
		jpl_View.add(jpl_viewTop);
		jpl_View.add(txt_QueryView);
		return jpl_View;
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Analysis Query Node");

		NodePanel npl_AnalysisQuery = new NodePanel();
		if (analysisModifiable) {
			npl_AnalysisQuery.addComponentToTab("Add a Query",
					initializeOptions());
		}
		npl_AnalysisQuery.addComponentToTab("View Query", initializeView());
		return npl_AnalysisQuery;
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "AnalysisQuery.gif";
	}

	/**
	 * 
	 * @return comboBoxModel of all queries not already in the analysis
	 */
	public DefaultComboBoxModel getQueryBoxModel() {
		return new DefaultComboBoxModel((Vector<InstantiatedQuery>)Analysis.getAnalysis(analysisID)
				.getQueriesForAnalysis());

	}

	/**
	 * 
	 * @return listModel of all queries in the analysis
	 */
	private DefaultListModel getQueryListModel() {
		List<InstantiatedQuery> vecInstQuerys = Analysis.getAnalysis(
				analysisID).getAnalysisQuerys();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < vecInstQuerys.size(); i++) {
			lmodel.addElement(vecInstQuerys.get(i));

		}
		return lmodel;
	}

	@Override
	protected void loadChildNodes() {

	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information regarding the queries associated with an analysis";
	}

}