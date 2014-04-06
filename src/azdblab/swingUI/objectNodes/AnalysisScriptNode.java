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
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Analysis;
import azdblab.labShelf.dataModel.Analysis.Script;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class AnalysisScriptNode extends ObjectNode {
	private int analysisID;
	private boolean analysisModifiable = true;
	private JComboBox cobox_ScriptType;

	private JTextArea txt_Script;
	private JList lst_Scripts;
	private JTextArea txt_ScriptView;
	private JTextField txt_ScriptName;

	public AnalysisScriptNode(String ID) {
		this(Integer.parseInt(ID));
	}

	public AnalysisScriptNode(int ID) {
		analysisID = ID;
		strNodeName = "Scripts";
		willHaveChildren = false;
		analysisModifiable = Analysis.getAnalysis(ID).getModifiable();
	}

	private JPanel initializeScriptsPanel() {
		NodePanel npl_ScriptsPanel = new NodePanel();
		if (analysisModifiable) {
			npl_ScriptsPanel.addComponentToTab("Add a Script",
					initializeOptions());
		}
		npl_ScriptsPanel.addComponentToTab("View Script", initializeView());
		return npl_ScriptsPanel;
	}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());
		JButton button = new JButton("Add AnalysisScript");
		buttonPanel.add(button);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				AddAnalysisScriptActionPerformed(ev);
			}
		});
		return buttonPanel;

	}

	private void AddAnalysisScriptActionPerformed(ActionEvent ev) {

	}

	/**
	 * Initializes the panel that allows users to add scripts to the analysis
	 * 
	 * @return
	 */
	private JPanel initializeOptions() {
		txt_ScriptName = new JTextField();
		txt_Script = new JTextArea("Script Text...");
		txt_Script.setLineWrap(true);

		DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
		dcbm.addElement("BASH");

		cobox_ScriptType = new JComboBox(dcbm);

		JButton btn_addScript = new JButton("Add Script to Analysis");
		btn_addScript.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (analysisModifiable) {
					Analysis.getAnalysis(analysisID).insertScript(
							txt_ScriptName.getText(),
							(String) cobox_ScriptType.getSelectedItem(),
							txt_Script.getText());

					lst_Scripts.setModel(generateListModel());
				} else {
					JOptionPane.showMessageDialog(null,
							"Error, cannot add to a frozen analysis");
				}
			}
		});

		JScrollPane scr_scriptInput = new JScrollPane();
		scr_scriptInput.setViewportView(txt_Script);

		JPanel jpl_OptionsButtons = new JPanel();
		jpl_OptionsButtons.setLayout(new GridLayout(2, 3));

		jpl_OptionsButtons.add(new JLabel("Script Name"));
		jpl_OptionsButtons.add(txt_ScriptName);
		jpl_OptionsButtons.add(btn_addScript);
		jpl_OptionsButtons.add(new JLabel("Script Type"));
		jpl_OptionsButtons.add(cobox_ScriptType);

		JPanel jpl_OptionsView = new JPanel();
		jpl_OptionsView.setLayout(new BorderLayout());
		jpl_OptionsView.add(jpl_OptionsButtons, BorderLayout.NORTH);
		jpl_OptionsView.add(scr_scriptInput, BorderLayout.CENTER);

		return jpl_OptionsView;
	}

	/**
	 * Initializes the panel that allows users to view scripts in the analysis
	 * 
	 * @return
	 */
	private JPanel initializeView() {
		txt_ScriptView = new JTextArea("Script Text...");
		txt_ScriptView.setEditable(false);
		txt_ScriptView.setLineWrap(true);

		JScrollPane scr_scriptView = new JScrollPane();
		scr_scriptView.setViewportView(txt_ScriptView);

		JButton btn_View = new JButton("View Script");
		btn_View.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				txt_ScriptView.setText("ScriptType = "
						+ ((Script) lst_Scripts.getSelectedValue())
								.getScriptType()
						+ "\n"
						+ Analysis.getAnalysis(
								((Script) lst_Scripts.getSelectedValue())
										.getAnalysisID()).getScript(
								((Script) lst_Scripts.getSelectedValue())
										.getScriptName()));
			}
		});

		lst_Scripts = new JList(generateListModel());
		lst_Scripts.setLayoutOrientation(JList.VERTICAL);
		lst_Scripts.setVisibleRowCount(15);
		lst_Scripts.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_Scripts.setSelectedIndex(0);

		JScrollPane scr_lstScriptView = new JScrollPane();
		scr_lstScriptView.setViewportView(lst_Scripts);

		JPanel jpl_ViewTop = new JPanel();
		jpl_ViewTop.setLayout(new BorderLayout());
		jpl_ViewTop.add(scr_lstScriptView, BorderLayout.CENTER);
		jpl_ViewTop.add(btn_View, BorderLayout.SOUTH);

		JPanel jpl_View = new JPanel();
		jpl_View.setLayout(new GridLayout(2, 1));
		jpl_View.add(jpl_ViewTop);
		jpl_View.add(scr_scriptView);
		return jpl_View;
	}

	@Override
	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at an Analysis Script Node");

		return initializeScriptsPanel();
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "report.png";
	}

	/**
	 * 
	 * @return a ListModel containing all the scripts in the analysis
	 */
	private DefaultListModel generateListModel() {
		DefaultListModel lmodel = new DefaultListModel();
		List<Script> scriptData = Analysis.getAnalysis(analysisID)
				.getScripts();

		for (int i = 0; i < scriptData.size(); i++) {
			lmodel.addElement(scriptData.get(i));
		}
		return lmodel;
	}

	@Override
	protected void loadChildNodes() {
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
		return "This node contains information about scripts stored in a notebook";
	}

}
