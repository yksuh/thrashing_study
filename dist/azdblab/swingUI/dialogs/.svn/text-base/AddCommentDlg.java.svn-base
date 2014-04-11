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
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import azdblab.labShelf.dataModel.Comment;

public class AddCommentDlg extends javax.swing.JDialog {
	private static final long serialVersionUID = System
			.identityHashCode("AddCommentDlg");

	private int runID;

	public AddCommentDlg(int runID) {
		super();
		this.runID = runID;
		initGUI();
	}

	private JTextArea txt_Comment;

	private void initGUI() {
		getContentPane().setLayout(new BorderLayout());
		this.setTitle("Add a Comment");

		txt_Comment = new JTextArea();
		txt_Comment.setLineWrap(true);
		txt_Comment.setEditable(true);
		JScrollPane scrp_Comment = new JScrollPane();
		scrp_Comment.setViewportView(txt_Comment);

		JButton btn_Add = new JButton("Add Comment");
		btn_Add.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (txt_Comment.getText().length() == 0) {
					JOptionPane.showMessageDialog(null,
							"Error, Please Input A Comment");
					return;
				}
				Comment.addComment(runID, txt_Comment.getText());
				dispose();
			}
		});

		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});

		JPanel jpl_Buttons = new JPanel(new GridLayout(1, 2));
		((GridLayout) jpl_Buttons.getLayout()).setHgap(5);
		jpl_Buttons.add(btn_Add);
		jpl_Buttons.add(btn_Cancel);

		this.add(new JLabel("Comment:"), BorderLayout.NORTH);
		this.add(scrp_Comment, BorderLayout.CENTER);
		this.add(jpl_Buttons, BorderLayout.SOUTH);
		((BorderLayout) this.getLayout()).setVgap(5);
		this.setSize(500, 400);
	}
}
