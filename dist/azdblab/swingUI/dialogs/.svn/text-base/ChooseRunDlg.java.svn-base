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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.ListModel;

import java.util.List;
import java.util.Vector;

/**
* This code was edited or generated using CloudGarden's Jigloo
* SWT/Swing GUI Builder, which is free for non-commercial
* use. If Jigloo is being used commercially (ie, by a corporation,
* company or business for any purpose whatever) then you
* should purchase a license for each developer using Jigloo.
* Please visit www.cloudgarden.com for details.
* Use of Jigloo implies acceptance of these licensing terms.
* A COMMERCIAL LICENSE HAS NOT BEEN PURCHASED FOR
* THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED
* LEGALLY FOR ANY CORPORATE OR COMMERCIAL PURPOSE.
*/
public class ChooseRunDlg extends javax.swing.JDialog {
	
	public static final long	serialVersionUID	= System.identityHashCode("ChooseRunDlg");
	
	private JButton 			btn_compute;
	private JLabel 				jLabel1;
	private JButton 			btn_cancel;
	private JScrollPane scrpan_Candidates;
	private JButton btn_remove;
	private JButton btn_add;
	private JList list_Selection;
	private JList list_Candidate;
	private JScrollPane scrpan_Selection;

	public ChooseRunDlg(JFrame frame) {
		super(frame);
		initGUI();
		initVar();
	}
	
	private void initGUI() {
		try {
			{
				getContentPane().setLayout(null);
				this.setTitle("Select Runs");
				{
					btn_compute = new JButton();
					getContentPane().add(btn_compute);
					btn_compute.setText("Compute");
					btn_compute.setBounds(142, 354, 105, 28);
					btn_compute.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_computeActionPerformed(evt);
						}
					});
				}
				{
					btn_cancel = new JButton();
					getContentPane().add(btn_cancel);
					btn_cancel.setText("Cancel");
					btn_cancel.setBounds(299, 354, 105, 28);
					btn_cancel.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_cancelActionPerformed(evt);
						}
					});
				}
				{
					jLabel1 = new JLabel();
					getContentPane().add(jLabel1);
					jLabel1.setBounds(11, 16, 535, 326);
					jLabel1.setBorder(BorderFactory.createTitledBorder("Choose Runs"));
				}
				{
					scrpan_Candidates = new JScrollPane();
					getContentPane().add(scrpan_Candidates);
					scrpan_Candidates.setBounds(28, 39, 222, 290);
					{
						ListModel list_CandidateModel = 
							new DefaultComboBoxModel(
									new String[] {});
						list_Candidate = new JList();
						scrpan_Candidates.setViewportView(list_Candidate);
						list_Candidate.setModel(list_CandidateModel);
					}
				}
				{
					scrpan_Selection = new JScrollPane();
					getContentPane().add(scrpan_Selection);
					scrpan_Selection.setBounds(311, 39, 218, 290);
					{
						ListModel list_SelectionModel = 
							new DefaultComboBoxModel(
									new String[] {});
						list_Selection = new JList();
						scrpan_Selection.setViewportView(list_Selection);
						list_Selection.setModel(list_SelectionModel);
					}
				}
				{
					btn_add = new JButton();
					getContentPane().add(btn_add);
					btn_add.setText(">>");
					btn_add.setBounds(262, 101, 34, 22);
					btn_add.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_addActionPerformed(evt);
						}
					});
				}
				{
					btn_remove = new JButton();
					getContentPane().add(btn_remove);
					btn_remove.setText("<<");
					btn_remove.setBounds(262, 201, 34, 22);
					btn_remove.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_removeActionPerformed(evt);
						}
					});
				}
			}
			//this.setIconImage(new ImageIcon(AZDBLAB.DIRECTORY_IMAGE + "/" + "azdblab.png").getImage());
			this.setSize(582, 423);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void initVar() {
		vec_selected_runs = new Vector<String>();
	}
	
	private void btn_computeActionPerformed(ActionEvent evt) {
		ListModel lm = list_Selection.getModel();
		int length = lm.getSize();
		for (int i = 0; i < length; i++) {
			vec_selected_runs.add(lm.getElementAt(i).toString());
		}
		dispose();
	}
	
	private void btn_cancelActionPerformed(ActionEvent evt) {
		dispose();
	}

	public void setCandidateRuns(Vector<String> candidate_runs) {
      for (int i = 0; i < candidate_runs.size(); i++) {
        ListModel lm = list_Candidate.getModel();
        ((DefaultComboBoxModel)lm).addElement(candidate_runs.get(i));
      }
	}
	
	public List<String> getSelectedRuns() {
      return vec_selected_runs;
	}
	
	private void btn_addActionPerformed(ActionEvent evt) {
		Object[] selected_values = list_Candidate.getSelectedValues();
		if (selected_values.length > 0) {
			ListModel lm = list_Selection.getModel();
			for (int i = 0; i < selected_values.length; i++) {
              ((DefaultComboBoxModel)lm).addElement(selected_values[i]);
			}
		} else {
			return;
		}
	}
	
	private void btn_removeActionPerformed(ActionEvent evt) {
		int[] select_indices = list_Selection.getSelectedIndices();
		for (int i = 0; i < select_indices.length; i++) {
		  list_Selection.remove(select_indices[i]);
		}
	}
	
	private Vector<String> vec_selected_runs;

}
