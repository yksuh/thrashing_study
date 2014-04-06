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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import azdblab.Constants;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Paper;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;
import azdblab.swingUI.dialogs.*;

public class PaperNode extends ObjectNode {
	private int paperID;
	Paper modelPaper;

	public PaperNode(String paperName, int ID) {
		strNodeName = paperName;
		paperID = ID;
	}

	private JPanel createPaperPanel() {
		NodePanel paperPanel = new NodePanel();
		paperPanel.addComponentToTab("Description", initializeDescription());
		paperPanel.addComponentToTab("Paper Options", initializeOptions());
		return paperPanel;
	}

	private JPanel initializeOptions() {
		JButton btn_addFigure = new JButton("Add a Figure to this Paper");
		btn_addFigure.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					new AddFigureLongDlg(paperID);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to add Figure");
				}
			}
		});
		JButton btn_addTable = new JButton("Add a Table to this Paper");
		btn_addTable.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					new AddTableLongDlg(paperID);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to add Table");
				}
			}
		});
		
		JButton btn_addStudy = new JButton("Add a Study to this Paper");
		btn_addStudy.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					new AddStudyLongDlg(paperID, PaperNode.this);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to add Study");
				}
			}
		});
		
		JButton btn_export = new JButton("Export this Paper");
		btn_export.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					Paper.getPaper(paperID).exportPaper();
					JOptionPane.showMessageDialog(null,
							"Exported paper Successfully");
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null,
							"Failed to export paper");
					x.printStackTrace();
				}
			}
		});

		JPanel jpl_Options = new JPanel();
		jpl_Options.add(btn_addFigure);
		jpl_Options.add(btn_addTable);
		jpl_Options.add(btn_addStudy);
		jpl_Options.add(btn_export);
		return jpl_Options;
	}

	private JPanel initializeDescription() {
		JTextArea txt_Description = new JTextArea(modelPaper.getDescription());
		txt_Description.setEditable(false);

		JPanel jpl_Description = new JPanel();
		jpl_Description.setLayout(new BorderLayout());
		jpl_Description.add(new JLabel("Description of Paper: " + strNodeName),
				BorderLayout.NORTH);
		jpl_Description.add(txt_Description, BorderLayout.CENTER);

		return jpl_Description;
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Paper Node");

		if (modelPaper == null) {
			modelPaper = Paper.getPaper(paperID);
		}
		return createPaperPanel();
	}

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "paper.png");
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {

		FigureNode figNode = new FigureNode(paperID);
		AZDBLABMutableTreeNode figureNode = new AZDBLABMutableTreeNode(figNode);
		TableNode tabNode = new TableNode(paperID);
		AZDBLABMutableTreeNode tableNode = new AZDBLABMutableTreeNode(tabNode);
		parent.add(figureNode);
		parent.add(tableNode);
		
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL("SELECT * FROM " 
		+ TableDefinition.STUDY.TableName + " WHERE PaperID = " + paperID);
		try {
			while (rs.next()) {
				StudyNode s = new StudyNode(rs.getInt(1), rs.getString(3), rs.getInt(4), rs.getInt(5), rs.getString(6));
				AZDBLABMutableTreeNode studyNode = new AZDBLABMutableTreeNode(s);
				parent.add(studyNode);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}
	
	@Override
	protected String getDescription() {
		return "This node  contains information regarding a paper";
	}
}
