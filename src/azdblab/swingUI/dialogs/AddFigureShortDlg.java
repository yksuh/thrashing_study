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
import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import azdblab.labShelf.dataModel.Figure;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Paper;
import azdblab.labShelf.dataModel.User;

public class AddFigureShortDlg {

	private JFrame figSave;
	private JTextField txt_FigName;
	private JComboBox cobox_FigPaper;
	private JTextArea txt_FigDescription;

	private String X_VAL;
	private String Y_VAL;
	private String C_VAL;
	private String numColors;
	private String lineType;
	private boolean x_log;
	private boolean y_log;
	private boolean bln_showLegend;
	private int instqueryID;

	/*
	 * This dialog is created from predefined query nodes, Much of the data
	 * required to create figures is gathered there, and sent here
	 */
	public AddFigureShortDlg(String x_value, String y_value,
			String color_value, String colorText, String linetype,
			boolean xLog, boolean yLog, boolean showLegend, int Instquery_ID) {
		X_VAL = x_value;
		Y_VAL = y_value;
		C_VAL = color_value;
		numColors = colorText;
		lineType = linetype;
		x_log = xLog;
		y_log = yLog;
		bln_showLegend = showLegend;
		instqueryID = Instquery_ID;

		showDialog();
	}

	/**
	 * This sets up the JFrame for adding a Figure to a Paper
	 * 
	 * @author Matt
	 */
	private void showDialog() {
		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				figSave.setVisible(false);
			}
		});

		JButton btn_Add = new JButton("Add");
		btn_Add.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				btn_AddActionPreformed();
			}
		});

		txt_FigName = new JTextField("");
		List<Notebook> vecNotebooks = User.getUser(
				InstantiatedQuery.getInstantiatedQuery(instqueryID)
						.getUserName()).getNotebooks();
		Vector<Paper> vecPapers = new Vector<Paper>();
		for (int i = 0; i < vecNotebooks.size(); i++) {
			vecPapers.addAll(vecNotebooks.get(i).getAllPapers());
		}

		DefaultComboBoxModel dcbm = new DefaultComboBoxModel(vecPapers);

		cobox_FigPaper = new JComboBox();
		cobox_FigPaper.setModel(dcbm);

		txt_FigDescription = new JTextArea("Description of the Figure...");
		txt_FigDescription.setLineWrap(true);
		txt_FigDescription.setBorder(BorderFactory
				.createLineBorder(Color.black));
		JPanel jpl_addFigure = new JPanel();
		jpl_addFigure.setLayout(new GridLayout(2, 2));
		jpl_addFigure.add(new JLabel("Figure Name:"));
		jpl_addFigure.add(txt_FigName);
		jpl_addFigure.add(new JLabel("Paper:"));
		jpl_addFigure.add(cobox_FigPaper);
		JPanel jpl_FigButtons = new JPanel();
		jpl_FigButtons.setLayout(new GridLayout(1, 2));
		jpl_FigButtons.add(btn_Add);
		jpl_FigButtons.add(btn_Cancel);

		JPanel jpl_Description = new JPanel();
		jpl_Description.setLayout(new BorderLayout());
		jpl_Description.setSize(700, 300);
		jpl_Description.add(txt_FigDescription, BorderLayout.CENTER);

		figSave = new JFrame("Add Figure to Paper");
		figSave.setSize(700, 420);
		figSave.setLocation(500, 500);
		figSave.setLayout(new BorderLayout());
		figSave.add(jpl_addFigure, BorderLayout.NORTH);
		figSave.add(jpl_Description, BorderLayout.CENTER);
		figSave.add(jpl_FigButtons, BorderLayout.SOUTH);
		figSave.setVisible(true);

	}

	/**
	 * This adds a Figure to a Paper
	 * 
	 * @author Matt
	 */
	private void btn_AddActionPreformed() {

		String FigureName = txt_FigName.getText();
		String showLegend;
		if (x_log) {
			X_VAL += "::Logarithmic";
		} else {
			X_VAL += "::Arithmatic";
		}
		if (y_log) {
			Y_VAL += "::Logarithmic";
		} else {
			Y_VAL += "::Arithmatic";
		}
		String Description = txt_FigDescription.getText();

		int C_NUM = 1;
		try {
			C_NUM = Integer.parseInt(numColors);
		} catch (Exception e) {
			C_NUM = 1;
		}

		if (bln_showLegend) {
			showLegend = "true";
		} else {
			showLegend = "false";
		}

		if (FigureName == "") {
			JOptionPane.showMessageDialog(null,
					"You must specify a figure name!");
			return;
		}
		Figure.addFigure(((Paper) cobox_FigPaper.getSelectedItem())
				.getPaperID(), instqueryID, Description, FigureName, X_VAL,
				Y_VAL, C_VAL, C_NUM, showLegend, lineType);

		figSave.dispose();
	}
}
