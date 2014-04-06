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

import javax.swing.JLabel;
import javax.swing.JProgressBar;

public class ProgressDlg extends javax.swing.JDialog {
	private static final long serialVersionUID = System
			.identityHashCode("ProgressDlg");

	public ProgressDlg() {
		super();
		initGUI();
		setVisible(true);
	}

	public void changeTitle(String newTitle) {
		this.setTitle(newTitle);
	}

	private JProgressBar prgbar_Progress;
	private JLabel lbl_Header;

	private void initGUI() {
		try {
			getContentPane().setLayout(new BorderLayout());

			prgbar_Progress = new JProgressBar();
			prgbar_Progress.setMaximum(100);
			prgbar_Progress.setStringPainted(true);
			prgbar_Progress.setValue(0);
			this.add(prgbar_Progress, BorderLayout.CENTER);

			lbl_Header = new JLabel();
			lbl_Header.setText("Starting...");
			this.add(lbl_Header, BorderLayout.NORTH);

			this.setSize(600, 200);
			this.setLocation(300, 300);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateProgress(String message, int progress) {
		lbl_Header.setText(message);
		prgbar_Progress.setValue((int) progress);
		this.validate();
		this.repaint();
	}

}
