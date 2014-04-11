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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.objectNodes.*;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;

public class AddStudyLongDlg {
	private JFrame addElement;
	private JTextField txt_name;
	private PaperNode parent;
	private int paperId;

	public AddStudyLongDlg(int paperId, PaperNode pNode) throws Exception {
		parent = pNode;
		showDialog();
		this.paperId = paperId;
	}

	/*
	 * This dialog is created from paper nodes when attempting to add Figures,
	 * it must gather enough info to add a Figure from scratch
	 */

	/**
	 * This method adds a figure to the current paper
	 * 
	 * @throws Exception
	 *             any exception causes the add action to abort
	 */

	private void showDialog() throws Exception {
		// the bottom is the two buttons
		// the top is the drop down boxes
		// the middle is the description
		// there is no way to preview the figure before adding
		
		txt_name = new JTextField();

		JPanel jpl_Top = new JPanel();
		jpl_Top.setLayout(new BorderLayout());
		jpl_Top.add(txt_name);

		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addElement.setVisible(false);
			}
		});

		JButton btn_Add = new JButton("Add");
		btn_Add.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					Integer studyID = LabShelfManager.getShelf().getSequencialID(
							Constants.SEQUENCE_STUDY);
					
					StudyNode study = new StudyNode(studyID, txt_name.getText());
					
					AZDBLABMutableTreeNode mtn_study = new AZDBLABMutableTreeNode(study);
					int dataTypes[] = { GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER };
					LabShelfManager.getShelf().insertTupleToNotebook(
							TableDefinition.STUDY.TableName,
							new String[] { "StudyID", "PaperID", "Name", "Item", "ProtocolID"},
							new String[] { String.format("%d", studyID), 
									String.format("%d", paperId), 
									txt_name.getText(), 
									String.format("%d", 0),
									String.format("%d", 0)
							}, 
							dataTypes);
					AZDBLabObserver.addElementToTree(parent.getParent(), mtn_study);
					addElement.dispose();
				} catch (Exception x) {
					x.printStackTrace();
					JOptionPane.showMessageDialog(null, "Failed to add Study");
				}
			}
		});
		

		JPanel jpl_buttons = new JPanel();
		jpl_buttons.setLayout(new BoxLayout(jpl_buttons, BoxLayout.LINE_AXIS));
		jpl_buttons.add(btn_Add);
		jpl_buttons.add(btn_Cancel);

		addElement = new JFrame("Add a Study to Paper");
		addElement.setSize(400, 88);
		addElement.setLocation(500, 500);
		addElement.setLayout(new BorderLayout());
		addElement.add(jpl_Top, BorderLayout.NORTH);
		addElement.add(jpl_buttons, BorderLayout.SOUTH);
		addElement.setVisible(true);
	}
}
