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

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Paper;
import azdblab.labShelf.dataModel.Table;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class TableNode extends ObjectNode {
	private NodePanel jpl_View;
	private JList lst_tableList;
	private JPanel jpl_viewTable;
	private JPanel jpl_viewData;
	private JPanel jpl_description;
	private JPanel jpl_latexView;
	private int paperID;

	public TableNode(int ID) {
		strNodeName = "Tables";
		willHaveChildren = false;
		paperID = ID;
		
	}

	private JPanel createTablePanel() {
		NodePanel tablePanel = new NodePanel();
		tablePanel.addComponentToTab("Select Table", initializeSelector());
		tablePanel.addComponentToTab("View Table", initializeView());
		return tablePanel;
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());
		JButton button = new JButton("Add Table");
		buttonPanel.add(button);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				AddTableActionPerformed(ev);
			}
		});
		return buttonPanel;

	}

	private void AddTableActionPerformed(ActionEvent ev) {

	}

	private JPanel initializeSelector() {
		DefaultListModel data = new DefaultListModel();
		List<Table> vecTables = Paper.getPaper(paperID).getAllTables();
		for (int i = 0; i < vecTables.size(); i++) {
			data.addElement(vecTables.get(i));
		}

		lst_tableList = new JList(data);

		JButton btn_display = new JButton("Display Table");
		btn_display.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent q) {
				try {
					btn_displayActionPreformed();
				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, "Failed to draw Table");
					e.printStackTrace();
				}
			}
		});

		JPanel selectPanel = new JPanel();
		selectPanel.setLayout(new BorderLayout());
		selectPanel.add(lst_tableList, BorderLayout.CENTER);
		selectPanel.add(btn_display, BorderLayout.SOUTH);
		return selectPanel;
	}

	private JPanel initializeView() {
		jpl_viewTable = new JPanel();
		jpl_viewData = new JPanel();
		jpl_description = new JPanel();
		jpl_latexView = new JPanel();
		jpl_View = new NodePanel();
		jpl_View.addComponentToTab("JTableView", jpl_viewTable);
		jpl_View.addComponentToTab("LATEXView", jpl_latexView);
		jpl_View.addComponentToTab("Table Description", jpl_description);
		jpl_View.addComponentToTab("Misc. data", jpl_viewData);
		return jpl_View;
	}

	private void btn_displayActionPreformed() throws Exception {
		jpl_viewData.removeAll();
		jpl_viewData.setLayout(new GridLayout(20, 1));
		jpl_viewData.add(new JLabel("Table Name: "
				+ ((Table) lst_tableList.getSelectedValue()).getTableName()));
		jpl_viewData.add(new JLabel("Creation Date: "
				+ ((Table) lst_tableList.getSelectedValue()).getCreationTime()));

		JTable resultTable = ((Table) lst_tableList.getSelectedValue())
				.getJTable();
		JScrollPane scrpan_Result = new JScrollPane();
		scrpan_Result.setViewportView(resultTable);
		jpl_viewTable.removeAll();
		jpl_viewTable.setLayout(new BorderLayout());
		jpl_viewTable.add(scrpan_Result, BorderLayout.CENTER);
		jpl_viewTable.repaint();

		JTextArea txt_LATEX = new JTextArea(((Table) lst_tableList
				.getSelectedValue()).getLATEX());
		txt_LATEX.setEditable(false);
		txt_LATEX.setLineWrap(true);

		JScrollPane scrpan_LATEX = new JScrollPane();
		scrpan_LATEX.setViewportView(txt_LATEX);

		jpl_latexView.removeAll();
		jpl_latexView.setLayout(new BorderLayout());
		jpl_latexView.add(scrpan_LATEX, BorderLayout.CENTER);
		jpl_latexView.repaint();

		JTextArea txt_description = new JTextArea(((Table) lst_tableList
				.getSelectedValue()).getDescription());
		txt_description.setEditable(false);
		txt_description.setLineWrap(true);

		jpl_description.removeAll();
		jpl_description.setLayout(new BorderLayout());
		jpl_description.add(txt_description, BorderLayout.CENTER);

	}

	public JPanel getDataPanel() {

		AZDBLabObserver.putInfo("You are looking at a Table Node");
		return createTablePanel();
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "table.png");
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
		return "This node contains information pertaining to the tables utilized by a particular paper";
	}

}
