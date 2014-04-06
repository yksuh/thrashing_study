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
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Stack;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.ListSelectionModel;
import javax.swing.ScrollPaneConstants;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import com.panayotis.gnuplot.JavaPlot;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Figure;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.PredefinedQuery;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.AddInstantiatedQueryDlg;
import azdblab.swingUI.dialogs.ModifyPredefinedQueryDlg;
import azdblab.swingUI.dialogs.AddTableShortDlg;
import azdblab.swingUI.dialogs.ShowFigureDlg;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class PredefinedQueryNode extends ObjectNode {

	// uninstantiatedQuery GUI vars
	private JTextArea txt_UninstQuery;
	private JTextArea txt_UninstDescription;
	private JList lst_UninstQuerys;
	private JPanel jpl_Figure;
	private JTextPane txt_InstHTMLTable;
	private JPanel jpl_LATEXView;
	private JList lst_InstTimes;
	private JList lst_InstQuerys;
	private JTextField txt_UserParam;
	private JTextField txt_NotebookParam;
	private JTextField txt_ExperimentParam;
	private JTextArea txt_InstQuery;
	private JTextArea txt_InstDescription;
	private JTextArea txt_LATEX;
	private JTextArea txt_DefinedTabView;
	// for the figures
	private JCheckBox GNUX_Log;
	private JCheckBox GNUY_Log;
	private JCheckBox GNU_ShowLegend;
	private JCheckBox chk_PrimaryKey;

	private JComboBox cobox_GNUXaxis;
	private JComboBox cobox_GNUYaxis;
	private JComboBox cobox_GNUColor;
	private JComboBox cobox_LineType;
	private JTextField txt_numColors;
	private JTextPane txt_HtmlView;
	private String userName;

	private static PreviousFigureParams prevFig;

	public static Stack<String> previousQueries;

	public PredefinedQueryNode(String user) {
		willHaveChildren = false;
		userName = user;
		strNodeName = "Defined Queries";
		if (previousQueries == null) {
			previousQueries = new Stack<String>();
		}
	}

	private JPanel initializePredefinedQueryNode() {
		NodePanel npl_predefQuery = new NodePanel();
		npl_predefQuery.addComponentToTab("Query Tester",
				initializeQueryTester());
		npl_predefQuery.addComponentToTab("Uninstantiated Queries",
				initializeUninstantiatedTab());
		npl_predefQuery.addComponentToTab("Instantiated Queries",
				initializeInstantiatedTab());
		npl_predefQuery.addComponentToTab("Table Creator",
				initializeTableCreator());
		return npl_predefQuery;
	}

	/*********************************************************************
	 * Uninstnaitated Section
	 */
	private JPanel initializeUninstantiatedTab() {

		List<PredefinedQuery> queryList = User.getUser(userName)
				.getPredefinedQuerys();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < queryList.size(); i++) {
			lmodel.addElement(queryList.get(i));
		}

		lst_UninstQuerys = new JList(lmodel);
		lst_UninstQuerys.setVisibleRowCount(10);
		lst_UninstQuerys.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_UninstQuerys.setPreferredSize(new Dimension(500, 500));

		txt_UninstQuery = new JTextArea("Query Text....");
		txt_UninstQuery.setEditable(false);
		txt_UninstQuery.setLineWrap(true);
		txt_UninstQuery.setBorder(BorderFactory.createLineBorder(Color.black));

		txt_UninstDescription = new JTextArea("Query Description...");
		txt_UninstDescription.setEditable(false);
		txt_UninstDescription.setLineWrap(true);
		txt_UninstDescription.setBorder(BorderFactory
				.createLineBorder(Color.black));

		lst_UninstQuerys.addListSelectionListener(new ListSelectionListener() {

			@Override
			public void valueChanged(ListSelectionEvent e) {
				if (lst_UninstQuerys.getSelectedValue() != null) {
					PredefinedQuery p = (PredefinedQuery) lst_UninstQuerys
							.getSelectedValue();
					txt_UninstQuery
							.setText(p.getQuerySQL().replace(":@:", "'"));
					txt_UninstDescription.setText(p.getDescription());
				}
			}

		});
		JButton btn_UninstView = new JButton("Modify Query");
		btn_UninstView.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (!(lst_UninstQuerys.getSelectedValue() == null)) {
					modifyUninstQuery();
				}
			}
		});

		JButton btn_AddUninstantiated = new JButton("Add New Query");
		btn_AddUninstantiated.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addUninstQuery();
			}
		});

		JPanel jpl_UninstBottom = new JPanel();
		jpl_UninstBottom.setLayout(new GridLayout(1, 2));
		((GridLayout) jpl_UninstBottom.getLayout()).setVgap(5);
		((GridLayout) jpl_UninstBottom.getLayout()).setHgap(5);
		jpl_UninstBottom.add(txt_UninstQuery);
		jpl_UninstBottom.add(txt_UninstDescription);

		JPanel jpl_Buttons = new JPanel();
		jpl_Buttons.setLayout(new GridLayout(1, 3));
		((GridLayout) jpl_Buttons.getLayout()).setHgap(10);
		// setting a layoutmanager may be necessary
		jpl_Buttons.add(btn_UninstView);
		jpl_Buttons.add(btn_AddUninstantiated);

		JScrollPane scrp_Querys = new JScrollPane();
		scrp_Querys.setViewportView(lst_UninstQuerys);
		lst_UninstQuerys.setBorder(BorderFactory.createLineBorder(Color.black));

		JPanel jpl_UninstTop = new JPanel();
		jpl_UninstTop.setLayout(new BorderLayout());
		jpl_UninstTop.add(scrp_Querys, BorderLayout.CENTER);
		jpl_UninstTop.add(jpl_Buttons, BorderLayout.SOUTH);

		NodePanel npl_UninstBottom = new NodePanel();
		npl_UninstBottom.addComponentToTab("Info", jpl_UninstBottom);

		JPanel jpl_UninstantiatedView = new JPanel();
		jpl_UninstantiatedView.setLayout(new GridLayout(2, 1));
		((GridLayout) jpl_UninstantiatedView.getLayout()).setVgap(10);
		jpl_UninstantiatedView.add(jpl_UninstTop);
		jpl_UninstantiatedView.add(npl_UninstBottom);

		return jpl_UninstantiatedView;
	}

	private void addUninstQuery() {
		new ModifyPredefinedQueryDlg(userName, this);
	}

	private void modifyUninstQuery() {
		PredefinedQuery pd = (PredefinedQuery) lst_UninstQuerys
				.getSelectedValue();
		if (!pd.checkModify()) {
			JOptionPane
					.showMessageDialog(
							null,
							"Error, this query is associated with a Table, Figure, or Analysis.\nThus it cannot be modified");
			return;
		}
		ModifyPredefinedQueryDlg dlg_Modify = new ModifyPredefinedQueryDlg(pd
				.getUserName(), pd.getQueryID(), this);
		dlg_Modify.setVisible(true);
		dlg_Modify.dispose();
	}

	public void refreshUninstList() {
		List<PredefinedQuery> queryList = User.getUser(userName)
				.getPredefinedQuerys();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < queryList.size(); i++) {
			lmodel.addElement(queryList.get(i));
		}
		lst_UninstQuerys.setModel(lmodel);
	}

	/**********************************************************************
	 * Instantiated Section
	 */
	private JPanel initializeInstantiatedTab() {

		JButton btn_RunInst = new JButton("Run");
		btn_RunInst.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					runQuery();
				} catch (Exception x) {
					x.printStackTrace();
				}
			}
		});

		JButton btn_Instantiate = new JButton("Instantate a new Query");
		btn_Instantiate.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addInstQuery();
			}
		});

		JButton btn_ExportRun = new JButton("Export Run");
		btn_ExportRun.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					JFileChooser chooser = new JFileChooser();
					chooser.setCurrentDirectory(new java.io.File("/home"));
					chooser.setDialogTitle("Select a save Destination");
					chooser.setAcceptAllFileFilterUsed(false);
					String filename = "";
					if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
						filename += chooser.getSelectedFile();
					} else {
						return;
					}
					int numExported = ((InstantiatedQuery) lst_InstQuerys
							.getSelectedValue()).exportToFile(filename);
					JOptionPane
							.showMessageDialog(null, "Successfully Exported "
									+ numExported + " records");
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to export Run\n" + x.getMessage());
				}
			}

		});

		List<InstantiatedQuery> queryData = User.getUser(userName)
				.getInstantiatedQuerys();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < queryData.size(); i++) {
			lmodel.addElement(queryData.get(i));
		}

		lst_InstQuerys = new JList(lmodel);
		lst_InstQuerys.setVisibleRowCount(10);
		lst_InstQuerys.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_InstQuerys.setPreferredSize(new Dimension(500, 500));
		JScrollPane scrp_Querys = new JScrollPane();
		scrp_Querys.setViewportView(lst_InstQuerys);
		lst_InstQuerys.setBorder(BorderFactory.createLineBorder(Color.black));

		txt_DefinedTabView = new JTextArea();
		txt_DefinedTabView.setEditable(false);
		JScrollPane scrpTabView = new JScrollPane();
		scrpTabView.setViewportView(txt_DefinedTabView);
		scrpTabView
				.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

		JPanel jpl_Buttons = new JPanel();
		jpl_Buttons.setLayout(new GridLayout(1, 3));
		((GridLayout) jpl_Buttons.getLayout()).setHgap(10);
		jpl_Buttons.add(btn_RunInst);
		jpl_Buttons.add(btn_ExportRun);
		jpl_Buttons.add(btn_Instantiate);

		JPanel jpl_InstTop = new JPanel();
		jpl_InstTop.setLayout(new BorderLayout());
		jpl_InstTop.add(scrp_Querys, BorderLayout.CENTER);
		jpl_InstTop.add(jpl_Buttons, BorderLayout.SOUTH);
		jpl_Figure = new JPanel();

		NodePanel npl_InstBottom = new NodePanel();
		npl_InstBottom.addComponentToTab("Info", initializeInstInfo());
		npl_InstBottom.addComponentToTab("Figure", jpl_Figure);
		npl_InstBottom.addComponentToTab("Table", initializeTable());
		npl_InstBottom.addComponentToTabLight("Tab Delineated View",
				scrpTabView);

		JPanel jpl_InstantiatedView = new JPanel();
		jpl_InstantiatedView.setLayout(new GridLayout(2, 1));
		jpl_InstantiatedView.add(jpl_InstTop, BorderLayout.NORTH);
		jpl_InstantiatedView.add(npl_InstBottom, BorderLayout.SOUTH);
		return jpl_InstantiatedView;
	}

	private void addInstQuery() {
		new AddInstantiatedQueryDlg(userName, this);
	}

	public void refreshInstList() {

		List<InstantiatedQuery> queryData = User.getUser(userName)
				.getInstantiatedQuerys();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < queryData.size(); i++) {
			lmodel.addElement(queryData.get(i));
		}
		lst_InstQuerys.setModel(lmodel);
	}

	private JPanel initializeInstInfo() {

		txt_InstQuery = new JTextArea();
		txt_InstQuery.setEditable(false);
		txt_InstQuery.setLineWrap(true);
		txt_InstQuery.setBorder(BorderFactory.createLineBorder(Color.black));

		JScrollPane scrpInstQuery = new JScrollPane();
		scrpInstQuery.setViewportView(txt_InstQuery);

		txt_InstDescription = new JTextArea();
		txt_InstDescription.setEditable(false);
		txt_InstDescription.setLineWrap(true);
		txt_InstDescription.setBorder(BorderFactory
				.createLineBorder(Color.black));

		lst_InstTimes = new JList();
		lst_InstTimes.setPreferredSize(new Dimension(100, 100));
		lst_InstTimes.setBorder(BorderFactory.createLineBorder(Color.black));
		txt_UserParam = new JTextField();
		txt_UserParam.setEditable(false);

		txt_NotebookParam = new JTextField();
		txt_NotebookParam.setEditable(false);

		txt_ExperimentParam = new JTextField();
		txt_ExperimentParam.setEditable(false);

		JPanel jpl_Param2 = new JPanel();
		jpl_Param2.setLayout(new GridLayout(3, 2));
		jpl_Param2.add(new JLabel("User"));
		jpl_Param2.add(txt_UserParam);
		jpl_Param2.add(new JLabel("Notebook"));
		jpl_Param2.add(txt_NotebookParam);
		jpl_Param2.add(new JLabel("Experiment"));
		jpl_Param2.add(txt_ExperimentParam);

		JPanel jpl_Times = new JPanel();
		jpl_Times.setLayout(new BorderLayout());
		jpl_Times.add(lst_InstTimes, BorderLayout.CENTER);
		jpl_Times.add(new JLabel("Times"), BorderLayout.NORTH);

		JPanel jpl_Params = new JPanel();
		jpl_Params.setLayout(new BorderLayout());
		jpl_Params.add(jpl_Param2, BorderLayout.CENTER);
		jpl_Params.add(jpl_Times, BorderLayout.SOUTH);

		JPanel jpl_Query = new JPanel();
		jpl_Query.setLayout(new BorderLayout());
		((BorderLayout) jpl_Query.getLayout()).setVgap(5);
		jpl_Query.add(new JLabel("Query"), BorderLayout.NORTH);
		jpl_Query.add(scrpInstQuery, BorderLayout.CENTER);

		JPanel jpl_Description = new JPanel();
		jpl_Description.setLayout(new BorderLayout());
		((BorderLayout) jpl_Description.getLayout()).setVgap(5);
		jpl_Description.add(new JLabel("Description"), BorderLayout.NORTH);
		jpl_Description.add(txt_InstDescription, BorderLayout.CENTER);

		JPanel jpl_Info = new JPanel();
		jpl_Info.setLayout(new GridLayout(1, 3));
		((GridLayout) jpl_Info.getLayout()).setHgap(10);
		jpl_Info.add(jpl_Query);
		jpl_Info.add(jpl_Description);
		jpl_Info.add(jpl_Params);
		return jpl_Info;
	}

	private JPanel initializeFigure() {

		txt_numColors = new JTextField("#Colors(Default: 1)");

		InstantiatedQuery selectedInstQuery = (InstantiatedQuery) lst_InstQuerys
				.getSelectedValue();

		cobox_GNUXaxis = new JComboBox(new DefaultComboBoxModel(
				(Vector<String>) selectedInstQuery.getColumnNames()));
		cobox_GNUYaxis = new JComboBox(new DefaultComboBoxModel(
				(Vector<String>) selectedInstQuery.getColumnNames()));
		cobox_GNUColor = new JComboBox(new DefaultComboBoxModel(
				(Vector<String>) selectedInstQuery.getColumnNames()));

		DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
		dcbm.addElement("Points");
		dcbm.addElement("Lines");
		dcbm.addElement("Bars");

		cobox_LineType = new JComboBox(dcbm);

		JButton btn_GNUGo = new JButton("Go!");
		btn_GNUGo.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					int numColors = 1;
					try {
						numColors = Integer.parseInt(txt_numColors.getText());
					} catch (Exception x) {
						numColors = 1; // if its a string or error, default to 1
						// color
					}

					prevFig = new PreviousFigureParams(
							((InstantiatedQuery) lst_InstQuerys
									.getSelectedValue())
									.getInstantiatedQueryID(), cobox_GNUXaxis
									.getSelectedIndex(), cobox_GNUYaxis
									.getSelectedIndex(), cobox_GNUColor
									.getSelectedIndex(), GNUX_Log.isSelected(),
							GNUY_Log.isSelected(), numColors, GNU_ShowLegend
									.isSelected(), cobox_LineType
									.getSelectedIndex());
					goButton_ActionPreformed();
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to draw Plot");
					x.printStackTrace();
				}
			}
		});

		GNUX_Log = new JCheckBox("X-axis log scale");
		GNUY_Log = new JCheckBox("Y-axis log scale");
		GNU_ShowLegend = new JCheckBox("Show Legend");

		chk_PrimaryKey = new JCheckBox("Primary Key Mode");
		chk_PrimaryKey.setSelected(true);
		chk_PrimaryKey.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				txt_numColors.setVisible(!chk_PrimaryKey.isSelected());
			}
		});
		if (prevFig != null) {
			if (((InstantiatedQuery) lst_InstQuerys.getSelectedValue())
					.getInstantiatedQueryID() == prevFig.instantiatedQueryID) {
				cobox_GNUXaxis.setSelectedIndex(prevFig.x_selectedIndex);
				cobox_GNUYaxis.setSelectedIndex(prevFig.y_selectedIndex);
				cobox_GNUColor.setSelectedIndex(prevFig.c_selectedIndex);
				GNUX_Log.setSelected(prevFig.x_isLogScale);

				GNUY_Log.setSelected(prevFig.y_isLogScale);
				txt_numColors.setText(String.valueOf(prevFig.numColors));
				GNU_ShowLegend.setSelected(prevFig.showLegend);
				cobox_LineType.setSelectedIndex(prevFig.selectedLine);
				// TODO
			}
		}

		if (chk_PrimaryKey.isSelected()) {
			txt_numColors.setVisible(false);
		}

		JPanel jpl_GNUTop = new JPanel();
		jpl_GNUTop.setLayout(new GridLayout(5, 4));
		((GridLayout) jpl_GNUTop.getLayout()).setVgap(5);
		((GridLayout) jpl_GNUTop.getLayout()).setHgap(5);
		jpl_GNUTop.add(new JLabel("x-axis value"));
		jpl_GNUTop.add(new JLabel("y-axis value"));
		jpl_GNUTop.add(new JLabel("color value"));
		jpl_GNUTop.add(new JLabel());
		jpl_GNUTop.add(cobox_GNUXaxis);
		jpl_GNUTop.add(cobox_GNUYaxis);
		jpl_GNUTop.add(cobox_GNUColor);
		jpl_GNUTop.add(btn_GNUGo);
		jpl_GNUTop.add(GNUX_Log);
		jpl_GNUTop.add(GNUY_Log);
		jpl_GNUTop.add(GNU_ShowLegend);

		jpl_GNUTop.add(new JLabel());

		jpl_GNUTop.add(new JLabel("Point Type:"));
		jpl_GNUTop.add(cobox_LineType);
		jpl_GNUTop.add(new JLabel());
		jpl_GNUTop.add(new JLabel());
		jpl_GNUTop.add(chk_PrimaryKey);
		jpl_GNUTop.add(txt_numColors);
		jpl_Figure.removeAll();
		jpl_Figure.setLayout(new BorderLayout());
		jpl_Figure.add(jpl_GNUTop, BorderLayout.NORTH);
		jpl_Figure.repaint();
		return jpl_Figure;
	}

	private JPanel initializeTable() {
		txt_InstHTMLTable = new JTextPane();
		txt_InstHTMLTable = new JTextPane();
		txt_InstHTMLTable.setContentType("text/html");

		JScrollPane scrp_HTML = new JScrollPane();
		scrp_HTML.setViewportView(txt_InstHTMLTable);
		scrp_HTML
				.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

		jpl_LATEXView = new JPanel();
		NodePanel npl_Table = new NodePanel();
		npl_Table.addComponentToTabLight("HTML View", scrp_HTML);
		npl_Table.addComponentToTab("LATEX View", jpl_LATEXView);

		return npl_Table;
	}

	private void runQuery() throws Exception {
		if (lst_InstQuerys.getSelectedIndex() == -1) {
			return;
		}

		System.out.println("Begining Instantiated Query Run");
		PredefinedQuery p = PredefinedQuery
				.getPredefinedQuery(((InstantiatedQuery) lst_InstQuerys
						.getSelectedValue()).getQueryID());

		txt_InstDescription.setText(p.getDescription());

		InstantiatedQuery selectedInstQuery = (InstantiatedQuery) lst_InstQuerys
				.getSelectedValue();
		String instQuery = InstantiatedQuery.getInstantiatedQuery(
				selectedInstQuery.getInstantiatedQueryID())
				.getInstantiatedSQL();
		txt_InstQuery.setText(instQuery);
		txt_UserParam.setText(selectedInstQuery.getUserNameParameter());
		txt_NotebookParam.setText(selectedInstQuery.getNotebookNameParameter());
		txt_ExperimentParam.setText(selectedInstQuery
				.getExperimentNameParameter());
		List<String> toAdd = selectedInstQuery.getInstQueryRunTimes();
		DefaultListModel lmodel = new DefaultListModel();
		for (int i = 0; i < toAdd.size(); i++) {
			lmodel.addElement(toAdd.get(i));
		}
		if (toAdd.size() == 0) {
			lmodel.addElement("None");
		}
		lst_InstTimes.setModel(lmodel);
		lst_InstTimes.repaint();

		txt_LATEX = new JTextArea();
		txt_LATEX.setEditable(false);
		txt_LATEX.setLineWrap(true);
		txt_LATEX.setBorder(BorderFactory.createLineBorder(Color.black));
		// txt_LATEX.setText(Table.getLATEX(instQuery));

		JScrollPane scrp_LATEX = new JScrollPane();
		scrp_LATEX.setViewportView(txt_LATEX);

		JButton btn_AddTableToPaper = new JButton("Add Table to Paper");
		btn_AddTableToPaper.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				new AddTableShortDlg(userName,
						((InstantiatedQuery) lst_InstQuerys.getSelectedValue())
								.getInstantiatedQueryID());
			}
		});

		JButton btn_SaveTableLATEX = new JButton("Save as LATEX");
		btn_SaveTableLATEX.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					saveTableLatex();
					JOptionPane.showMessageDialog(null,
							"Successfully exported table");
				} catch (Exception x) {
					JOptionPane
							.showMessageDialog(null, "Failed to write Table");
				}
			}
		});

		txt_InstHTMLTable.setText(InstantiatedQuery.getHTMLOutput(instQuery));
		txt_InstHTMLTable.setCaretPosition(0);
		jpl_LATEXView.setLayout(new BorderLayout());
		jpl_LATEXView.add(btn_SaveTableLATEX, BorderLayout.NORTH);
		jpl_LATEXView.add(scrp_LATEX, BorderLayout.CENTER);

		txt_DefinedTabView.setText(InstantiatedQuery
				.getTabDeliniatedOutput(instQuery));
		initializeFigure();
	}

	private void goButton_ActionPreformed() throws Exception {
		if (cobox_GNUXaxis.getSelectedIndex() == -1
				|| cobox_GNUYaxis.getSelectedIndex() == -1) {
			JOptionPane.showMessageDialog(null,
					"You must select a x and y axis value!");
			return;
		}
		int numColors = 1;
		try {
			numColors = Integer.parseInt(txt_numColors.getText());
		} catch (Exception e) {
			numColors = 1; // if its a string or error, default to 1 color
		}

		JavaPlot jp = Figure.getJavaPlot(((InstantiatedQuery) lst_InstQuerys
				.getSelectedValue()).getInstantiatedSQL(), cobox_GNUXaxis
				.getSelectedIndex(), cobox_GNUYaxis.getSelectedIndex(),
				cobox_GNUColor.getSelectedIndex(), GNUX_Log.isSelected(),
				GNUY_Log.isSelected(), numColors, GNU_ShowLegend.isSelected(),
				(String) cobox_LineType.getSelectedItem(), chk_PrimaryKey
						.isSelected());
		new ShowFigureDlg(jp);

		jpl_Figure.repaint();
	}

	/**
	 * Saves the table to a latex file
	 * 
	 * @author Matt
	 * @throws IOException
	 */
	private void saveTableLatex() throws Exception {

		JFileChooser chooser = new JFileChooser();
		chooser.setCurrentDirectory(new java.io.File("/home"));
		chooser.setDialogTitle("Select a save Destination");
		chooser.setAcceptAllFileFilterUsed(false);
		String directory = "";
		if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
			directory += chooser.getSelectedFile();
		} else {
			throw new Exception();
		}

		PrintWriter out = new PrintWriter(new FileWriter(directory));
		out.print(txt_LATEX.getText());
		out.close();

	}

	/******************************************************
	 * Query Tester Section
	 */
	// The purpose of the queryTester is to run arbitrary SQL on the database,
	// and get results, just to see if the query works as intended
	private JTextArea txt_TesterQuery;
	private JTextArea txt_TabView;
	private NodePanel npl_QueryTesterOutput;

	private JPanel initializeQueryTester() {
		txt_TesterQuery = new JTextArea("Query Text...");
		txt_TesterQuery.setLineWrap(true);
		txt_TesterQuery.setBorder(BorderFactory.createLineBorder(Color.black));
		JButton btn_TestRun = new JButton("Run");
		btn_TestRun.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					previousQueries.push(txt_TesterQuery.getText());
					txt_TabView.setText(InstantiatedQuery
							.getTabDeliniatedOutput(txt_TesterQuery.getText()));
					txt_TabView.setCaretPosition(0);
					txt_HtmlView.setText(InstantiatedQuery
							.getHTMLOutput(txt_TesterQuery.getText()));
					txt_HtmlView.setCaretPosition(0);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to run query\n"
							+ x.getMessage());
				}
			}
		});

		JButton btn_SaveResult = new JButton("Export Run");
		btn_SaveResult.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					JFileChooser chooser = new JFileChooser();
					chooser.setCurrentDirectory(new java.io.File("/home"));
					chooser.setDialogTitle("Select a save Destination");
					chooser.setAcceptAllFileFilterUsed(false);
					String filename = "";
					if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
						filename += chooser.getSelectedFile();
					} else {
						return;
					}
					int numExported = InstantiatedQuery.exportToFile(
							txt_TesterQuery.getText(), filename);
					JOptionPane
							.showMessageDialog(null, "Successfully Exported "
									+ numExported + " records");
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to export Run\n" + x.getMessage());
				}

			}

		});

		txt_TabView = new JTextArea();
		txt_TabView.setEditable(false);

		txt_HtmlView = new JTextPane();
		txt_HtmlView.setContentType("text/html");

		JScrollPane scrpTabView = new JScrollPane();
		scrpTabView.setViewportView(txt_TabView);
		scrpTabView
				.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

		JScrollPane scrpHtmlView = new JScrollPane();
		scrpHtmlView.setViewportView(txt_HtmlView);
		scrpHtmlView
				.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

		npl_QueryTesterOutput = new NodePanel();
		// npl_QueryTesterOutput.addComponentToTab("Html View", scrpHtmlView);
		npl_QueryTesterOutput.addComponentToTabLight("Html View", scrpHtmlView);
		npl_QueryTesterOutput.addComponentToTabLight("Tab Delineated View",
				scrpTabView);

		JPanel jpl_Buttons = new JPanel(new GridLayout(1, 2));
		jpl_Buttons.add(btn_TestRun);
		jpl_Buttons.add(btn_SaveResult);
		((GridLayout) jpl_Buttons.getLayout()).setHgap(5);

		JPanel jpl_QueryTesterInput = new JPanel();
		jpl_QueryTesterInput.setLayout(new BorderLayout());
		jpl_QueryTesterInput.add(new JLabel("Please input your query below"),
				BorderLayout.NORTH);
		JScrollPane scrpQuery = new JScrollPane();
		scrpQuery.setViewportView(txt_TesterQuery);
		jpl_QueryTesterInput.add(scrpQuery, BorderLayout.CENTER);
		jpl_QueryTesterInput.add(jpl_Buttons, BorderLayout.SOUTH);

		JPanel jplQueryTester = new JPanel();
		jplQueryTester.setLayout(new GridLayout(2, 1));
		JScrollPane scrpTop = new JScrollPane();
		scrpTop.setViewportView(jpl_QueryTesterInput);
		jplQueryTester.add(jpl_QueryTesterInput);
		jplQueryTester.add(npl_QueryTesterOutput);
		return jplQueryTester;

	}

	private JTextArea txt_UpdateQuery;

	private JPanel initializeTableCreator() {

		JButton btn_Execute = new JButton("Execute Update SQL");
		btn_Execute.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				String sql = txt_UpdateQuery.getText().toLowerCase().trim();
				String[] words = sql.split(" ");
				if (words[0].contains("drop") || words[0].contains("delete")) {
					//TODO modify this to allow deletes for a specific user
				//	if (!System.getProperty("user.name").equals("mwj")) {
						JOptionPane.showMessageDialog(null,
								"Drop and Delete statements are not allowed");
						return;
				//	}
				}
				LabShelfManager.getShelf().executeUpdateSQL(
						txt_UpdateQuery.getText());
			}
		});

		txt_UpdateQuery = new JTextArea();
		txt_UpdateQuery.setLineWrap(true);

		JScrollPane scrpQuery = new JScrollPane();
		scrpQuery.setViewportView(txt_UpdateQuery);

		JPanel jpl_Top = new JPanel(new BorderLayout());
		jpl_Top.add(scrpQuery, BorderLayout.CENTER);
		jpl_Top.add(btn_Execute, BorderLayout.SOUTH);

		JPanel jpl_ToRet = new JPanel(new GridLayout(2, 1));
		jpl_ToRet.add(jpl_Top);
		jpl_ToRet
				.add(new JLabel(
						"This utility is soley for executing update SQL, do not attempt to use it for anything else"));
		return jpl_ToRet;
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Predefined Query Node");

		return initializePredefinedQueryNode();
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "selectedQuery.png";
	}

	@Override
	public JPanel getButtonPanel() {
		JButton btn_Previous = new JButton("Previous Query");
		btn_Previous.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (!PredefinedQueryNode.previousQueries.isEmpty()) {
					txt_TesterQuery.setText(PredefinedQueryNode.previousQueries
							.pop());
					txt_TesterQuery.repaint();
				} else {
					System.out.println("No Queries remaining");
				}
			}
		});
		JPanel jpl_Buttons = new JPanel();
		jpl_Buttons.add(btn_Previous);
		return jpl_Buttons;
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
		return "This node allows the user to execute queries on the labshelf";
	}

	private class PreviousFigureParams {
		int x_selectedIndex;
		int y_selectedIndex;
		int c_selectedIndex;
		boolean x_isLogScale;
		boolean y_isLogScale;
		int numColors;
		boolean showLegend;
		int selectedLine;
		int instantiatedQueryID;

		public PreviousFigureParams(int instantiatedQueryID,
				int x_selectedIndex, int y_selectedIndex, int c_selectedIndex,
				boolean x_isLogScale, boolean y_isLogScale, int numColors,
				boolean showLegend, int lineType) {
			this.instantiatedQueryID = instantiatedQueryID;
			this.x_selectedIndex = x_selectedIndex;
			this.y_selectedIndex = y_selectedIndex;
			this.c_selectedIndex = c_selectedIndex;
			this.x_isLogScale = x_isLogScale;
			this.y_isLogScale = y_isLogScale;
			this.numColors = numColors;
			this.showLegend = showLegend;
			this.selectedLine = lineType;

		}

	}
}
