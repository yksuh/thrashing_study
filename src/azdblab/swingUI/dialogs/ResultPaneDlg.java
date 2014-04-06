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
import java.awt.Insets;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;

public class ResultPaneDlg extends javax.swing.JDialog {
	public static final long serialVersionUID = System
			.identityHashCode("ResultPaneDlg");


	public ResultPaneDlg(String html) {
		super();
		initGUI(html);
	}

	public void changeTitle(String newTitle) {
		this.setTitle(newTitle);
	}

	private void initGUI(String html) {
		try {

			getContentPane().setLayout(new BorderLayout());
			JTextPane resPane = new JTextPane();
			resPane.setEditable(false);
			resPane.setContentType("text/html");
			resPane.setText(html);
			resPane.setMargin(new Insets(15, 15, 15, 15));
			resPane.setCaretPosition(0);

			JButton btn_Close = new JButton("Close Pane");
			btn_Close.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					closeActionPreformed();
				}
			});

			JPanel jpl_Buttons = new JPanel(new GridLayout(1, 2));
			((GridLayout) jpl_Buttons.getLayout()).setHgap(5);
			jpl_Buttons.add(btn_Close);

			JScrollPane scrpResults = new JScrollPane();
			scrpResults.setViewportView(resPane);
			this.add(scrpResults, BorderLayout.CENTER);
			this.add(jpl_Buttons, BorderLayout.SOUTH);
			this.setSize((int) Toolkit.getDefaultToolkit().getScreenSize()
					.getWidth(), 800);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void closeActionPreformed() {
		this.dispose();
	}
}
