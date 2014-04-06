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
import javax.swing.JButton;

import javax.swing.JLabel;
import javax.swing.JTextField;

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
public class AddNotebookDlg extends javax.swing.JDialog {
	
	public static final long	serialVersionUID	= System.identityHashCode("AddNotebookDlg");
	
	private JButton 			btn_add;
	private JTextField 			txt_notebookname;
	private JLabel 				jLabel1;
	private JButton 			btn_cancel;
	
	
	private	String				strNotebookName;
	
	private String				strDescription;
		
	public AddNotebookDlg() {
		super();
		initGUI();
		initVar();
	}
	
	private void initGUI() {
		try {
			{
				getContentPane().setLayout(null);
				this.setTitle("Add a new Notebook");
				{
					btn_add = new JButton();
					getContentPane().add(btn_add);
					btn_add.setText("Add");
					btn_add.setBounds(84, 189, 105, 28);
					btn_add.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_addActionPerformed(evt);
						}
					});
				}
				{
					btn_cancel = new JButton();
					getContentPane().add(btn_cancel);
					btn_cancel.setText("Cancel");
					btn_cancel.setBounds(266, 189, 105, 28);
					btn_cancel.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_cancelActionPerformed(evt);
						}
					});
				}
				{
					jLabel1 = new JLabel();
					getContentPane().add(jLabel1);
					jLabel1.setBounds(14, 14, 420, 238);
					jLabel1.setBorder(BorderFactory.createTitledBorder("Specify Notebook Name"));
				}
				{
					txt_notebookname = new JTextField();
					getContentPane().add(txt_notebookname);
					txt_notebookname.setBounds(35, 63, 378, 28);
				}
			}
			//this.setIconImage(new ImageIcon(AZDBLAB.DIRECTORY_IMAGE + "/" + "azdblab.png").getImage());
			this.setSize(465, 316);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void initVar() {
		strNotebookName	= null;
		strDescription	= "Description of Notebook";
	}
	
	private void btn_addActionPerformed(ActionEvent evt) {
		strNotebookName	= txt_notebookname.getText();
		dispose();
	}
	
	private void btn_cancelActionPerformed(ActionEvent evt) {
		strNotebookName		= null;
		dispose();
	}

	public String getNotebookName() {
		return strNotebookName;
	}
	
	public String getNotebookDescription() {
		return strDescription;
	}
	
}
