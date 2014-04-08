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

import java.awt.Color;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import azdblab.labShelf.InternalTable;
import azdblab.labShelf.TableDefinition;

public class ViewTableSchemaDlg extends javax.swing.JDialog {
	public static final long serialVersionUID = System
			.identityHashCode("ViewTableSchemaDlg");

	public ViewTableSchemaDlg(JFrame frame) {
		super(frame);
		initGUI();
	}

	private JList lst_Tables;
	private JTextArea txt_Description;

	private void initGUI() {
		getContentPane().setLayout(null);
		this.setTitle("View Table Schema");

		this.setBounds(0, 0, 470, 525);

		JLabel lbl_Description1 = new JLabel(
				"The following tables will be installed");
		lbl_Description1.setBounds(10, 10, 300, 20);
		this.add(lbl_Description1);

		lst_Tables = new JList(populateTablesList());
		lst_Tables.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_Tables.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		lst_Tables.setSelectedIndex(-1);
		lst_Tables.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent e) {
				txt_Description.setText(((InternalTable) lst_Tables
						.getSelectedValue()).getStringRepresentation());
				txt_Description.setCaretPosition(0);
			}
		});

		JScrollPane scrp_view = new JScrollPane();
		scrp_view.setViewportView(lst_Tables);
		scrp_view.setBounds(10, 30, 420, 200);
		this.add(scrp_view);

		JLabel lbl_Description2 = new JLabel("Table Schema");
		lbl_Description2.setBounds(10, 240, 420, 20);
		this.add(lbl_Description2);

		txt_Description = new JTextArea();
		txt_Description.setLineWrap(true);
		txt_Description.setEditable(false);
		// txt_Description.setBounds(10, 260, 420, 200);
		txt_Description.setBorder(BorderFactory.createLineBorder(Color.BLACK));

		JScrollPane scrp_descrip = new JScrollPane();
		scrp_descrip.setViewportView(txt_Description);
		scrp_descrip.setBounds(10, 260, 420, 200);
		this.add(scrp_descrip);
	}

	private DefaultListModel populateTablesList() {

		DefaultListModel lmodel = new DefaultListModel();
		InternalTable tmp[] = TableDefinition.INTERNAL_TABLES;
		for (int i = 0; i < tmp.length; i++) {
			lmodel.addElement(tmp[i]);
		}

		Vector<InternalTable> vec_tmp = TableDefinition.vecPluginTables;
		for (int i = 0; i < vec_tmp.size(); i++) {
			lmodel.addElement(vec_tmp.get(i));
		}
		return lmodel;
	}
}
