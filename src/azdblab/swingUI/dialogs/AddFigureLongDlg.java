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
import java.sql.ResultSet;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Figure;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.labShelf.dataModel.LabShelfManager;

public class AddFigureLongDlg {
	private int paperID;
	private JFrame addElement;
	private JComboBox cobox_Query;
	private JTextField txt_name;
	private JTextField txt_numColors;
	private JTextArea txt_description;
	private JComboBox cobox_Xaxis;
	private JComboBox cobox_Yaxis;
	private JComboBox cobox_Color;
	private JComboBox cobox_LineType;
	private JCheckBox chk_XLog;
	private JCheckBox chk_YLog;
	private JCheckBox GNU_ShowLegend;

	public AddFigureLongDlg(int pID) throws Exception {
		paperID = pID;
		showDialog();
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
		DefaultComboBoxModel dcbm = new DefaultComboBoxModel();
		String sql = "select inst.InstantiatedQueryID from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_PREDEFINED_QUERY + " pd, "
				+ Constants.TABLE_PREFIX + Constants.TABLE_INSTANTIATED_QUERY
				+ " inst where inst.QueryID = pd.QueryID";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		Vector<Integer> vecQueryIDs = new Vector<Integer>();
		while (rs.next()) {
			vecQueryIDs.add(rs.getInt(1));
		}
		rs.close();

		for (int i = 0; i < vecQueryIDs.size(); i++) {
			dcbm.addElement(InstantiatedQuery.getInstantiatedQuery(vecQueryIDs
					.get(i)));
		}
		cobox_Query = new JComboBox(dcbm);
		cobox_Query.setSelectedIndex(-1);
		txt_name = new JTextField();
		cobox_Query.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					InstantiatedQuery selectedQuery = (InstantiatedQuery) cobox_Query
							.getSelectedItem();
					cobox_Xaxis.setModel(new DefaultComboBoxModel(
							(Vector<String>) selectedQuery.getColumnNames()));
					cobox_Yaxis.setModel(new DefaultComboBoxModel(
							(Vector<String>) selectedQuery.getColumnNames()));
					cobox_Color.setModel(new DefaultComboBoxModel(
							(Vector<String>) selectedQuery.getColumnNames()));
				} catch (Exception x) {
					x.printStackTrace();
				}
			}
		});
		cobox_Xaxis = new JComboBox();
		cobox_Yaxis = new JComboBox();
		cobox_Color = new JComboBox();

		DefaultComboBoxModel dcbm4 = new DefaultComboBoxModel();
		dcbm4.addElement("Lines");
		dcbm4.addElement("Bars");
		dcbm4.addElement("Points");
		cobox_LineType = new JComboBox(dcbm4);

		txt_numColors = new JTextField("# of Colors");
		chk_XLog = new JCheckBox("Logarithmic scale");
		chk_YLog = new JCheckBox("Logarithmic scale");
		GNU_ShowLegend = new JCheckBox("Show Legend");

		JPanel jpl_Top = new JPanel();
		jpl_Top.setLayout(new GridLayout(8, 2));
		jpl_Top.add(new JLabel("Figure Name"));
		jpl_Top.add(txt_name);
		jpl_Top.add(new JLabel("Query Name"));
		jpl_Top.add(cobox_Query);
		jpl_Top.add(new JLabel("X axis"));
		jpl_Top.add(GNU_ShowLegend);
		jpl_Top.add(cobox_Xaxis);
		jpl_Top.add(chk_XLog);
		jpl_Top.add(new JLabel("Y axis"));
		jpl_Top.add(cobox_LineType);
		jpl_Top.add(cobox_Yaxis);
		jpl_Top.add(chk_YLog);
		jpl_Top.add(new JLabel("Color"));
		jpl_Top.add(new JLabel("Number of Colors"));
		jpl_Top.add(cobox_Color);
		jpl_Top.add(txt_numColors);

		txt_description = new JTextArea("Description...");
		txt_description.setLineWrap(true);
		txt_description.setBorder(BorderFactory.createLineBorder(Color.black));

		JPanel jpl_Description = new JPanel();
		jpl_Description.setLayout(new BorderLayout());
		jpl_Description.setSize(700, 300);
		jpl_Description.add(txt_description, BorderLayout.CENTER);

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
					addFigureToTable();
					JOptionPane.showMessageDialog(null,
							"Successfully added Figure");
					addElement.setVisible(false);
				} catch (Exception x) {
					JOptionPane.showMessageDialog(null, "Failed to add Figure");
				}
			}
		});

		JPanel jpl_FigButtons = new JPanel();
		jpl_FigButtons.setLayout(new GridLayout(1, 2));
		jpl_FigButtons.add(btn_Cancel);
		jpl_FigButtons.add(btn_Add);

		addElement = new JFrame("Add a Figure to Paper");
		addElement.setSize(700, 500);
		addElement.setLocation(500, 500);
		addElement.setLayout(new BorderLayout());
		addElement.add(jpl_Top, BorderLayout.NORTH);
		addElement.add(jpl_Description, BorderLayout.CENTER);
		addElement.add(jpl_FigButtons, BorderLayout.SOUTH);
		addElement.setVisible(true);
	}

	/**
	 * Adds the Figure specified in the form to the Paper
	 * 
	 * @throws Exception
	 *             If any field is not filled throw an error
	 */
	private void addFigureToTable() throws Exception {
		String FigureName = txt_name.getText();
		String X_VAL = (String) cobox_Xaxis.getSelectedItem();
		if (chk_XLog.isSelected()) {
			X_VAL += "::Logarithmic";
		} else {
			X_VAL += "::Arithmatic";
		}
		String Y_VAL = (String) cobox_Yaxis.getSelectedItem();
		if (chk_YLog.isSelected()) {
			Y_VAL += "::Logarithmic";
		} else {
			Y_VAL += "::Arithmatic";
		}
		int c_num;
		try {
			c_num = Integer.parseInt(txt_numColors.getText());
		} catch (Exception e) {
			c_num = 1;
		}

		if (FigureName == "") {
			JOptionPane.showMessageDialog(null,
					"You must specify a figure name!");
			return;
		}

		String showLegend;
		if (GNU_ShowLegend.isSelected()) {
			showLegend = "true";
		} else {
			showLegend = "false";
		}

		Figure.addFigure(paperID, ((InstantiatedQuery) cobox_Query
				.getSelectedItem()).getInstantiatedQueryID(), txt_description
				.getText(), FigureName, X_VAL, Y_VAL, cobox_Color
				.getSelectedItem().toString(), c_num, showLegend,
				(String) cobox_LineType.getSelectedItem());

	}
}
