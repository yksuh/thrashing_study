/*
 * Copyright (c) 2012, Arizona Board of Regents
 * 
 * See LICENSE at /cs/projects/tau/azdblab/license
 * See README at /cs/projects/tau/azdblab/readme
 * AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
 * This is a Laboratory Information Management System
 * 
 * Authors:
 * Others (unknown)
 * Benjamin Dicken (benjamindicken.com, bddicken@gmail.com)
 * 
 */

package azdblab.labShelf.creator;

import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JFileChooser;
import javax.swing.ListSelectionModel;

import javax.swing.WindowConstants;
import javax.swing.border.TitledBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import azdblab.Constants;
import azdblab.LoginManager;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.User;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Vector;

/**
 * This code was edited or generated using CloudGarden's Jigloo SWT/Swing GUI
 * Builder, which is free for non-commercial use. If Jigloo is being used
 * commercially (ie, by a corporation, company or business for any purpose
 * whatever) then you should purchase a license for each developer using Jigloo.
 * Please visit www.cloudgarden.com for details. Use of Jigloo implies
 * acceptance of these licensing terms. A COMMERCIAL LICENSE HAS NOT BEEN
 * PURCHASED FOR THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED LEGALLY FOR
 * ANY CORPORATE OR COMMERCIAL PURPOSE.
 */
public class SpecifierFrm extends javax.swing.JFrame {
	/*
	 *
	 * 
	 */
	static final long serialVersionUID = System
			.identityHashCode("SpecifierFrm");

	private JPanel pan_Settings;
	private JLabel jLabel1;
	private JLabel jLabel2;
	private JLabel jLabel3;
	private JLabel jLabel4;
	private JLabel jLabel5;
	private JScrollPane comment_scrpan;
	private JRadioButton ratbtn_ExperimentSubject;
	private JRadioButton radbtn_LabShelf;
	private ButtonGroup btngrp_Type;
	private JButton btn_Quit;
	private JButton btn_Generate;
	private JTextArea comment_txtarea;
	private JTextField txt_ConnectString;
	private JTextField txt_Password;
	private JTextField txt_UserName;
	private JTextField txt_Title;
	private String strTitle;
	private String strUserNameEncrypted;
	private String strPasswordEncrypted;
	private String strConnectStringEncrypted;
	private String create_date_;
	private String creator_name_;
	private String comments_;

	private String type_;

	public SpecifierFrm() {
		super();
		initVAR();
		initNewGUI();
	}

	private void initVAR() {
		type_ = "labShelf";
	}

	private void initNewGUI() {
		try {
			setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
			getContentPane().setLayout(null);
//			this.setTitle("LabShelf Creator");
			this.setTitle("AZDBLab Manager");

			JTabbedPane tabbedPane = new JTabbedPane();
			tabbedPane.setBounds(0, 0, 470, 525);

//			pan_Settings = new JPanel();
//			pan_Settings.setBounds(14, 14, 470, 525);
//			pan_Settings.setBorder(BorderFactory.createTitledBorder(null, null,
//					TitledBorder.LEADING, TitledBorder.TOP));
//			pan_Settings.setLayout(null);
//			{
//				{
//					btngrp_Type = new ButtonGroup();
//
//				}
//
//				pan_Settings = new JPanel();
//				getContentPane().add(pan_Settings);
//				pan_Settings.setBounds(14, 14, 427, 429);
//				pan_Settings.setBorder(BorderFactory.createTitledBorder(null,
//						"Setting Strings", TitledBorder.LEADING,
//						TitledBorder.TOP));
//				pan_Settings.setLayout(null);
//				{
//					jLabel1 = new JLabel();
//					pan_Settings.add(jLabel1);
//					jLabel1.setText("Name");
//					jLabel1.setBounds(14, 49, 126, 14);
//				}
//				{
//					jLabel2 = new JLabel();
//					pan_Settings.add(jLabel2);
//					jLabel2.setText("DBMS User Name");
//					jLabel2.setBounds(14, 98, 300, 28);
//				}
//				{
//					jLabel3 = new JLabel();
//					pan_Settings.add(jLabel3);
//					jLabel3.setText("DBMS Password");
//					jLabel3.setBounds(14, 149, 300, 28);
//				}
//				{
//					jLabel4 = new JLabel();
//					pan_Settings.add(jLabel4);
//					jLabel4.setText("JDBC Connect String");
//					jLabel4.setBounds(17, 203, 196, 28);
//				}
//				{
//					txt_Title = new JTextField();
//					pan_Settings.add(txt_Title);
//					txt_Title.setBounds(14, 70, 399, 26);
//				}
//				{
//					txt_UserName = new JTextField();
//					pan_Settings.add(txt_UserName);
//					txt_UserName.setBounds(14, 126, 399, 25);
//				}
//				{
//					txt_Password = new JTextField();
//					pan_Settings.add(txt_Password);
//					txt_Password.setBounds(15, 177, 399, 26);
//				}
//				{
//					txt_ConnectString = new JTextField();
//					pan_Settings.add(txt_ConnectString);
//					setTestingVars();
//					txt_ConnectString.setBounds(17, 231, 399, 28);
//				}
//				{ // private JCheckBox su_User_Check;
//
//					radbtn_LabShelf = new JRadioButton();
//					pan_Settings.add(radbtn_LabShelf);
//					radbtn_LabShelf.setText("LabShelf");
//					radbtn_LabShelf.setBounds(14, 21, 154, 21);
//					btngrp_Type.add(radbtn_LabShelf);
//					radbtn_LabShelf.setSelected(true);
//					radbtn_LabShelf.addActionListener(new ActionListener() {
//						public void actionPerformed(ActionEvent evt) {
//							radbtn_LabShelfActionPerformed(evt);
//						}
//					});
//				}
//				{
//					ratbtn_ExperimentSubject = new JRadioButton();
//					pan_Settings.add(ratbtn_ExperimentSubject);
//					ratbtn_ExperimentSubject.setText("Experiment Subject");
//					ratbtn_ExperimentSubject.setBounds(238, 21, 175, 21);
//					btngrp_Type.add(ratbtn_ExperimentSubject);
//					ratbtn_ExperimentSubject
//							.addActionListener(new ActionListener() {
//								public void actionPerformed(ActionEvent evt) {
//									ratbtn_ExperimentSubjectActionPerformed(evt);
//								}
//							});
//				}
//				{
//					jLabel5 = new JLabel();
//					pan_Settings.add(jLabel5);
//					jLabel5.setText("Comments");
//					jLabel5.setBounds(17, 265, 112, 28);
//				}
//				{
//					comment_scrpan = new JScrollPane();
//					pan_Settings.add(comment_scrpan);
//					comment_scrpan.setBounds(17, 293, 397, 121);
//					{
//						comment_txtarea = new JTextArea();
//						comment_scrpan.setViewportView(comment_txtarea);
//						comment_txtarea
//								.setPreferredSize(new java.awt.Dimension(332,
//										82));
//					}
//				}
//			}
//			{
//				btn_Generate = new JButton();
//				pan_Settings.add(btn_Generate);
//				btn_Generate.setText("Generate...");
//				btn_Generate.setBounds(73, 449, 133, 28);
//				btn_Generate.addActionListener(new ActionListener() {
//					public void actionPerformed(ActionEvent evt) {
//						btn_GenerateActionPerformed(evt);
//					}
//				});
//			}
//			{
//				btn_Quit = new JButton();
//				pan_Settings.add(btn_Quit);
//				btn_Quit.setText("Quit");
//				btn_Quit.setBounds(245, 449, 133, 28);
//				btn_Quit.addActionListener(new ActionListener() {
//					public void actionPerformed(ActionEvent evt) {
//						btn_QuitActionPerformed(evt);
//					}
//				});
//			}
//			tabbedPane.addTab("LabShelf/ExpSub Configuration", pan_Settings);

			// JPanel pan_Settings3 = new JPanel();
			// pan_Settings3.setBounds(14, 14, 470, 525);
			// pan_Settings3.setBorder(BorderFactory.createTitledBorder(null,
			// null, TitledBorder.LEADING, TitledBorder.TOP));
			// pan_Settings3.setLayout(null);
			// tabbedPane.addTab("Create User", pan_Settings3);
			//
			// JLabel lbl_NewTitle = new JLabel("Title");
			// lbl_NewTitle.setBounds(20, 20, 100, 30);
			// pan_Settings3.add(lbl_NewTitle);
			//
			// txt_NewTitle = new JTextField();
			// txt_NewTitle.setBounds(20, 60, 400, 30);
			// pan_Settings3.add(txt_NewTitle);
			//
			// JLabel lbl_userName = new JLabel("New Username");
			// lbl_userName.setBounds(20, 100, 100, 30);
			// pan_Settings3.add(lbl_userName);
			//
			// txt_NewUser = new JTextField();
			// txt_NewUser.setBounds(20, 140, 400, 30);
			// pan_Settings3.add(txt_NewUser);
			//
			// JLabel lbl_password = new JLabel("New Password");
			// lbl_password.setBounds(20, 180, 100, 30);
			// pan_Settings3.add(lbl_password);
			//
			// txt_NewPassword = new JTextField();
			// txt_NewPassword.setBounds(20, 220, 400, 30);
			// pan_Settings3.add(txt_NewPassword);
			//
			// JButton btn_NewGenerate = new JButton("Generate");
			// btn_NewGenerate.setBounds(20, 260, 100, 30);
			// btn_NewGenerate.addActionListener(new ActionListener() {
			// @Override
			// public void actionPerformed(ActionEvent e) {
			// newGenerate();
			// }
			// });
			// pan_Settings3.add(btn_NewGenerate);
			// setTestingVars();

			// JPanel pan_Settings2 = new JPanel();
			// pan_Settings2.setBounds(14, 14, 470, 525);
			// pan_Settings2.setBorder(BorderFactory.createTitledBorder(null,
			// null, TitledBorder.LEADING, TitledBorder.TOP));
			// pan_Settings2.setLayout(null);
			// tabbedPane.addTab("Installation", pan_Settings2);
			
			tabbedPane.addTab("View Tables", initializeViewTables());
			tabbedPane.addTab("User Dialog", initializeUserDialog());
			
			// The following line enables to use scrolling tabs.
			tabbedPane.setTabLayoutPolicy(JTabbedPane.SCROLL_TAB_LAYOUT);

			{
				new ButtonGroup();

			}
			// {
			// JRadioButton radbtn_create_internal_tables = new JRadioButton();
			// pan_Settings2.add(radbtn_create_internal_tables);
			// radbtn_create_internal_tables
			// .setText("Install Internal Tables");
			// radbtn_create_internal_tables.setBounds(14, 21, 200, 21);
			// btngrp_Type2.add(radbtn_create_internal_tables);
			// radbtn_create_internal_tables.setSelected(true);
			// radbtn_create_internal_tables
			// .addActionListener(new ActionListener() {
			// public void actionPerformed(ActionEvent evt) {
			// radbtn_create_internal_tablesActionPerformed(evt);
			// }
			// });
			// }
			// {
			// JRadioButton radbtn_drop_internal_tables = new JRadioButton();
			// pan_Settings2.add(radbtn_drop_internal_tables);
			// radbtn_drop_internal_tables
			// .setText("Uninstall Internal Tables");
			// radbtn_drop_internal_tables.setBounds(238, 21, 200, 21);
			// btngrp_Type2.add(radbtn_drop_internal_tables);
			// radbtn_drop_internal_tables
			// .addActionListener(new ActionListener() {
			// public void actionPerformed(ActionEvent evt) {
			// ratbtn_drop_internal_tablesActionPerformed(evt);
			// }
			// });
			// }
			// {
			// JButton btn_ok = new JButton();
			// pan_Settings2.add(btn_ok);
			// btn_ok.setText("OK");
			// btn_ok.setBounds(73, 100, 133, 28);
			// btn_ok.addActionListener(new ActionListener() {
			// public void actionPerformed(ActionEvent evt) {
			// try {
			// InstallTables inst = new
			// InstallTables(txt_ConnectString.getText());
			// if (action_type_.equals("create")) {
			// inst.install(txt_UserName.getText(), txt_Password.getText());
			// JOptionPane.showMessageDialog(null,"Install successfull");
			// }
			// // if (action_type_.equals("drop")) {
			// // inst.uninstall(txt_UserName.getText(),
			// txt_Password.getText());
			// // JOptionPane.showMessageDialog(null, "Uninstall successful");
			// // }
			// } catch (Exception e) {
			// e.printStackTrace();
			// JOptionPane
			// .showMessageDialog(
			// null,
			// action_type_
			// +
			// " unsuccessful, please verify that username/password/connect String are correct");
			// }
			// // btn_OKActionPerformed(evt);
			// }
			// });
			// }
			// {
			// JButton btn_cancel = new JButton();
			// pan_Settings2.add(btn_cancel);
			// btn_cancel.setText("Cancel");
			// btn_cancel.setBounds(245, 100, 133, 28);
			// btn_cancel.addActionListener(new ActionListener() {
			// public void actionPerformed(ActionEvent evt) {
			// System.exit(0);
			// }
			// });
			// }
			pack();
			getContentPane().add(tabbedPane);
			this.setSize(500, 570);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

//	private void setTestingVars() {
//		txt_ConnectString.setText(Constants.AZDBLAB_LABSHELF_SERVER);
//	}

	// private void newGenerate() {
	// InstallTables inst = new InstallTables(txt_ConnectString.getText());
	// // if (!inst.testConnect(txt_UserName.getText(), txt_Password.getText()))
	// {
	// // JOptionPane.showMessageDialog(null,
	// //
	// "Error acquiring connection\nPlease confirm that the settings on \"LabShelf/ExpSub Configuration\" are valid");
	// // }
	// if (inst.createUser(txt_NewUser.getText(), txt_NewPassword.getText())) {
	// // inst = new InstallTables(txt_ConnectString.getText());
	// // try {
	// //// inst.install(txt_NewUser.getText(), txt_NewPassword.getText());
	// //// createConnectXML();
	// // } catch (Exception e) {
	// // e.printStackTrace();
	// // JOptionPane
	// // .showMessageDialog(null,
	// // "Error in install\nSome LabShelf Tables may be missing");
	// // }
	// JOptionPane.showMessageDialog(null,
	// "LabShelf: " + txt_NewUser.getText() + " is successfully created.");
	// } else {
	// JOptionPane.showMessageDialog(null,
	// "Error Creating User\nPlease verify that you have the necessary privlages");
	// }
	// }

	// private void createConnectXML() {
	// JFileChooser fc = new JFileChooser();
	// fc.showSaveDialog(this);
	//
	// File saveFile = fc.getSelectedFile();
	// try {
	//
	// FileWriter frout = new FileWriter(saveFile);
	// BufferedWriter brout = new BufferedWriter(frout);
	//
	// try {
	//
	// Encryptor encryptor = new Encryptor("sigmod08");
	//
	// strTitle = txt_NewTitle.getText();
	// strUserNameEncrypted = encryptor.encrypt(txt_NewUser.getText());
	// strPasswordEncrypted = encryptor.encrypt(txt_NewPassword
	// .getText());
	// strConnectStringEncrypted = encryptor.encrypt(txt_ConnectString
	// .getText());
	// comments_ = comment_txtarea.getText();
	// creator_name_ = System.getProperty("user.name");
	// SimpleDateFormat date_formater = new SimpleDateFormat(
	// "MM_dd_yyyy_HH_mm_ss");
	// create_date_ = date_formater.format(new Date(System
	// .currentTimeMillis()));
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// brout.append("<LABSHELFCONNECTOR " + "TYPE=\"" + type_
	// + "\" " + "TITLE=\"" + strTitle + "\" " + "LAB_USERNAME=\""
	// + strUserNameEncrypted + "\" " + "LAB_PASSWORD=\""
	// + strPasswordEncrypted + "\" " + "LAB_CONNECTSTRING=\""
	// + strConnectStringEncrypted + "\" " + "CREATE_TIME=\""
	// + create_date_ + "\" " + "CREATOR_NAME=\"" + creator_name_
	// + "\" " + "COMMENTS=\"" + comments_ + "\" " + "/>");
	//
	// brout.close();
	// frout.close();
	// JOptionPane.showMessageDialog(null, "Successfully Created User");
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	// }

	private JList lst_Tables;
	private JTextArea txt_Description;

	private JPanel initializeViewTables() {
		JPanel jpl_view = new JPanel();
		jpl_view.setLayout(null);
		jpl_view.setBounds(0, 0, 470, 525);

		JLabel lbl_Description1 = new JLabel(
				"The following tables will be installed");
		lbl_Description1.setBounds(10, 10, 300, 20);
		jpl_view.add(lbl_Description1);

		lst_Tables = new JList(populateTablesList());
		lst_Tables.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_Tables.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		lst_Tables.setSelectedIndex(-1);
		lst_Tables.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent e) {
				txt_Description.setText(((InternalTable) lst_Tables
						.getSelectedValue()).getStringRepresentation());
			}
		});

		JScrollPane scrp_view = new JScrollPane();
		scrp_view.setViewportView(lst_Tables);
		scrp_view.setBounds(10, 30, 420, 200);
		jpl_view.add(scrp_view);

		JLabel lbl_Description2 = new JLabel("Table Schema");
		lbl_Description2.setBounds(10, 240, 420, 20);
		jpl_view.add(lbl_Description2);

		txt_Description = new JTextArea();
		txt_Description.setLineWrap(true);
		txt_Description.setEditable(false);
		txt_Description.setBounds(10, 260, 420, 200);
		txt_Description.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		jpl_view.add(txt_Description);

		return jpl_view;
	}

	private JPanel pan_UserCreate;
	private JList userList;
	private JScrollPane scrp_view;
	private JTextField txt_Password2;
	private JCheckBox su_User_Check;
	private JButton btn_Quit2;
	private JButton btn_Generate2;
	private JLabel jLabel6;
	private JLabel jLabel7;
	private JLabel jLabel8;
	private JLabel jLabel9;

	private JPanel initializeUserDialog() 
	{
		setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
		getContentPane().setLayout(null);
//		this.setTitle("User Creator");

		JTabbedPane tabbedPane = new JTabbedPane();
		tabbedPane.setBounds(0, 0, 470, 525);

		pan_UserCreate = new JPanel();
		pan_UserCreate.setBounds(14, 14, 470, 525);
		pan_UserCreate.setBorder(BorderFactory.createTitledBorder(null, null,
				TitledBorder.LEADING, TitledBorder.TOP));
		pan_UserCreate.setLayout(null);
		{
			pan_UserCreate = new JPanel();
			getContentPane().add(pan_UserCreate);
			pan_UserCreate.setBounds(14, 14, 427, 429);
			pan_UserCreate.setBorder(BorderFactory.createTitledBorder(null,
					"Create user", TitledBorder.LEADING, TitledBorder.TOP));
			pan_UserCreate.setLayout(null);
			{
				jLabel6 = new JLabel();
				jLabel6.setText("");
				jLabel6.setForeground(Color.red);
				pan_UserCreate.add(jLabel6);
				jLabel6.setBounds(14, 270, 300, 28);
			}
			{
				jLabel7 = new JLabel();
				pan_UserCreate.add(jLabel7);
				jLabel7.setText("Select User to create login for:");
				jLabel7.setBounds(14, 59, 250, 22);
			}
			{
				Vector<String> u = LoginManager.getUsers("");
				if (u.size() == 0)
					jLabel6.setText("all users already have logins!");
				userList = new JList(u);
				scrp_view = new JScrollPane(userList);
				pan_UserCreate.add(scrp_view);
				scrp_view.setBounds(14, 85, 200, 100);
			}
			{
				jLabel8 = new JLabel();
				pan_UserCreate.add(jLabel8);
				jLabel8.setText("Choose a password");
				jLabel8.setBounds(14, 190, 300, 28);
			}
			{
				txt_Password2 = new JTextField();
				pan_UserCreate.add(txt_Password2);
				txt_Password2.setBounds(15, 225, 399, 26);
			}
			{
				jLabel9 = new JLabel();
				pan_UserCreate.add(jLabel9);
				jLabel9.setText("<html> <p> If a user already has an account in a different Lab Shelf, their previous password will be kept.</p> </html>");
				jLabel9.setBounds(14, 290, 400, 80);
			}
			{
				su_User_Check = new JCheckBox();
				pan_UserCreate.add(su_User_Check);
				su_User_Check.setText("Super User?");
				su_User_Check.setBounds(14, 29, 154, 24);
				su_User_Check.setSelected(false);
				su_User_Check.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent evt) {
						boolean isSel = (su_User_Check.isSelected());
						su_User_Check.setSelected(isSel);
					}
				});
			}
		}
		{
			btn_Generate2 = new JButton();
			pan_UserCreate.add(btn_Generate2);
			btn_Generate2.setText("Submit");
			btn_Generate2.setBounds(73, 449, 133, 28);
			btn_Generate2.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					createUserLogin((String) userList.getSelectedValue());
				}
			});
		}
		{
			btn_Quit2 = new JButton();
			pan_UserCreate.add(btn_Quit2);
			btn_Quit2.setText("Quit");
			btn_Quit2.setBounds(245, 449, 133, 28);
			btn_Quit2.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent evt) {
					btn_QuitActionPerformed(evt);
				}
			});
		}

		return pan_UserCreate;
	}

	private DefaultListModel populateTablesList() {
		DefaultListModel lmodel = new DefaultListModel();
		InternalTable tmp[] = TableDefinition.INTERNAL_TABLES;
		for (int i = 0; i < tmp.length; i++) {
			lmodel.addElement(tmp[i]);
		}
		return lmodel;
	}

	private void btn_GenerateActionPerformed(ActionEvent evt) {

		JFileChooser fc = new JFileChooser();
		fc.showSaveDialog(this);

		File saveFile = fc.getSelectedFile();
		try {

			FileWriter frout = new FileWriter(saveFile);
			BufferedWriter brout = new BufferedWriter(frout);

			try {

				Encryptor encryptor = new Encryptor("sigmod08");

				strTitle = txt_Title.getText();
				strUserNameEncrypted = encryptor
						.encrypt(txt_UserName.getText());
				strPasswordEncrypted = encryptor
						.encrypt(txt_Password.getText());
				strConnectStringEncrypted = encryptor.encrypt(txt_ConnectString
						.getText());
				comments_ = comment_txtarea.getText();
				creator_name_ = System.getProperty("user.name");
				SimpleDateFormat date_formater = new SimpleDateFormat(
						"MM_dd_yyyy_HH_mm_ss");
				create_date_ = date_formater.format(new Date(System
						.currentTimeMillis()));
			} catch (Exception e) {
				e.printStackTrace();
			}

			brout.append("<LABSHELFCONNECTOR " + "TYPE=\"" + type_ + "\" "
					+ "TITLE=\"" + strTitle + "\" " + "LAB_USERNAME=\""
					+ strUserNameEncrypted + "\" " + "LAB_PASSWORD=\""
					+ strPasswordEncrypted + "\" " + "LAB_CONNECTSTRING=\""
					+ strConnectStringEncrypted + "\" " + "CREATE_TIME=\""
					+ create_date_ + "\" " + "CREATOR_NAME=\"" + creator_name_
					+ "\" " + "COMMENTS=\"" + comments_ + "\" " + "/>");

			brout.close();
			frout.close();

			ShelfCreator inst = new ShelfCreator(txt_ConnectString.getText());
			boolean INSTALL = true; // don't change this flag if you're not
			// superman
			// TODO
			boolean reinstall = true;
			if (reinstall) {
				inst.uninstall(txt_UserName.getText(), txt_Password.getText());
				inst.install(txt_UserName.getText(), txt_Password.getText());
				return;
			}

			if (INSTALL) {
				if (type_.equalsIgnoreCase("labshelf")) {
//					// create a lab shelf
//					if (inst.createLabShelf(txt_UserName.getText(),
//							txt_Password.getText())) {
//						System.out.println("LabShelf/ExperimentSubject: "
//								+ txt_UserName.getText() + " gets created.");
//					} else {
//						System.out.println("Failed to create labShelf user "
//								+ txt_UserName.getText());
//					}
					// install tables
					inst.install(txt_UserName.getText(), txt_Password.getText());
				}
			} else {
				if (type_.equalsIgnoreCase("labshelf")) {
					// uninstall tables
					inst.uninstall(txt_UserName.getText(),
							txt_Password.getText());
//					// drop user
//					if (inst.dropLabShelf(txt_UserName.getText(),
//							txt_Password.getText())) {
//						System.out.println("LabShelf/ExperimentSubject: "
//								+ txt_UserName.getText() + " gets deleted.");
//					} else {
//						System.out.println("Failed to delete labShelf user "
//								+ txt_UserName.getText());
//					}
				}
			}
			JOptionPane.showMessageDialog(null,
					"Connector XML Creation Success");
		} catch (IOException ioex) {
			ioex.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
			// JOptionPane.showMessageDialog(null, "Creation Failed");
		}
	}

	private void btn_QuitActionPerformed(ActionEvent evt) {
		dispose();
	}

//	private void ratbtn_ExperimentSubjectActionPerformed(ActionEvent evt) {
//		type_ = "experimentsubject";
//	}
//
//	private void radbtn_LabShelfActionPerformed(ActionEvent evt) {
//		type_ = "labshelf";
//	}

	protected void radbtn_create_internal_tablesActionPerformed(ActionEvent evt) {
	}

	protected void ratbtn_drop_internal_tablesActionPerformed(ActionEvent evt) {
	}

	// refactor later


	/**
	 * Create a user login XML file (or modify an existing one) with the
	 * information that the user filled out inside of the Create User dialog.
	 * 
	 * @author Benjamin Dicken
	 * @return a boolean. If creation was successful return true, else false
	 */
	private boolean createUserLogin(String userFileName) 
	{
		String tmpUser = (String) userList.getSelectedValue();
		String tmpPass = txt_Password2.getText();
		String tmpSU = (su_User_Check.isSelected() == true) ? "y" : "n";
		
		// Check if all the fields of the form are filled out
		boolean fieldsNotFilledOut = false;
		if (txt_Password2.getText().equals("")
				|| userList.getSelectedValue() == null) {
			fieldsNotFilledOut = true;
		}
		if (fieldsNotFilledOut) {
			JOptionPane.showMessageDialog(null, "Please fill out all fields.", "Empty Fields", JOptionPane.ERROR_MESSAGE);
			return false;
		}
		
		boolean tmpRes = LoginManager.createUserLogin(userFileName, tmpUser, tmpPass, tmpSU);
		
		if(tmpRes == true) {
			JOptionPane.showMessageDialog(null,
					"User \"" + (String) userList.getSelectedValue()
					+ "\" was added successfully!", "User Created",
					JOptionPane.PLAIN_MESSAGE);
		} else {
			JOptionPane.showMessageDialog(null,
					"An error occured while adding user \"" + (String) userList.getSelectedValue()
					+ "\".", "Error",
					JOptionPane.PLAIN_MESSAGE);
		}
		this.updateCreateUI();
		
		return tmpRes;
	}
	

	/**
	 * Updates all of the dynamic portions of the user creation dialog box.
	 * 
	 * @author Benjamin Dicken
	 * @return void
	 */
	private void updateCreateUI() {

		// Refresh the users list
		scrp_view.remove(userList);
		pan_UserCreate.remove(scrp_view);
		Vector<String> u = LoginManager.getUsers("");
		userList = new JList(u);
		txt_Password.setText("");
		scrp_view = new JScrollPane(userList);
		pan_UserCreate.add(scrp_view);
		scrp_view.setBounds(14, 85, 200, 100);
		scrp_view.setBounds(14, 85, 200, 100);

		u = LoginManager.getUsers("");
		if (u.size() == 0) {
			jLabel4.setText("all users already have logins!");
		}

		pan_UserCreate.validate();
	}

}
