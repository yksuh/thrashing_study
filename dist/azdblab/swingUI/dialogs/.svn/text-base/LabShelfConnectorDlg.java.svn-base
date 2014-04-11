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
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;

import javax.swing.AbstractButton;
import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.ListModel;
import javax.swing.border.TitledBorder;

import azdblab.Constants;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;
import java.util.Map;
import java.util.TreeMap;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.sun.corba.se.impl.orbutil.closure.Constant;

import azdblab.labShelf.DBMSConnectParam;
import azdblab.labShelf.creator.Encryptor;
import azdblab.labShelf.creator.ShelfCreator;
import azdblab.labShelf.creator.SpecifierFrm;
import azdblab.model.experiment.Decryptor;
import azdblab.model.experiment.XMLHelper;

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
public class LabShelfConnectorDlg extends javax.swing.JDialog {

	public static final long serialVersionUID = System
			.identityHashCode("LabShelfConnectorDlg");

	private JTabbedPane tabpan_Options;
	private JList lst_ShelfList;
	private JTextField txt_ConnectString;
	private JTextField txt_Password;
	private JTextArea comment_txtarea;
	private JScrollPane comment_scrpan;
	private JTextField creator_name_txt;
	private JTextField create_date_txt;
	private JTextField txt_UserName;
	private JLabel jLabel3;
	private JLabel jLabel4;
	private JLabel jLabel5;
	private JLabel jLabel6;
	private JLabel jLabel2;
	private JLabel jLabel1;
	private JButton btn_ExistingCancel;
	private JButton btn_ExistingLogin;
	private JScrollPane scrpan_ShelfList;
	private JPanel pan_Specify;
	private JPanel pan_Existing;
	private JPanel pan_Create;

	private String strUserName;
	private String strPassword;
	private String strConnectString;
	private String create_date_;
	private String creator_name_;
	private String comments_;
	private String strNotebookName;

	// private LabShelf dbController;

	private Vector<DBMSConnectParam> vecDBMSConParam;

	private JButton btn_SpecifyCancel;

	private JButton btn_SpecifyLogin;

	private JPanel pan_Settings;

	private ButtonGroup btngrp_Type;

	private JLabel jLabel7;

	private JRadioButton radbtn_LabShelf;

	private JRadioButton ratbtn_ExperimentSubject;

	private JLabel jLabel11;

	private JButton btn_Generate;

	private JButton btn_Quit;

	private JLabel jLabel10;

	private JLabel jLabel8;

	private JLabel jLabel9;

	private JTextField txt_Title;

	private String type_;

	private JTextField txt_LabShelfExpTitle;

	private JTextField txt_LabShelfExpUserName;

	private JTextField txt_LabShelfExpPassword;

	private JTextField txt_LabShelfExpConnectString;
	public LabShelfConnectorDlg(JFrame frame) {
		super(frame);
		initVAR();
		initGUI();
		loadLabShelfConnections();
	}

	private void initVAR() {

		strUserName = "";

		strPassword = "";

		strConnectString = "";

		// dbController = null;

		vecDBMSConParam = new Vector<DBMSConnectParam>();
		type_ = "labShelf";
	}

	private void initGUI() {
		try {
			{
				getContentPane().setLayout(null);
				this.setTitle("LabShelf (ExpSubject) Manager");
			}
			{
				tabpan_Options = new JTabbedPane();
				getContentPane().add(tabpan_Options);
//				tabpan_Options.setBounds(14, 14, 504, 360);
				tabpan_Options.setBounds(14, 14, 550, 450);
				{
					pan_Existing = new JPanel();
					tabpan_Options.addTab("Connection to an Existing LabShelf", null,
							pan_Existing, null);
//					pan_Existing.setPreferredSize(new java.awt.Dimension(500,338));
					pan_Existing.setPreferredSize(new java.awt.Dimension(500,450));
					pan_Existing.setLayout(null);
					{
						scrpan_ShelfList = new JScrollPane();
						pan_Existing.add(scrpan_ShelfList);
						scrpan_ShelfList.setBounds(28, 14, 448, 62);
						{
							ListModel lst_ShelfListModel = new DefaultComboBoxModel(
									new String[] {});
							lst_ShelfList = new JList();
							scrpan_ShelfList.setViewportView(lst_ShelfList);
							lst_ShelfList.setModel(lst_ShelfListModel);
							lst_ShelfList.setValueIsAdjusting(true);
							lst_ShelfList.setListData(vecDBMSConParam);
							lst_ShelfList.setSelectedIndex(0);
							lst_ShelfList.addMouseListener(new MouseAdapter() {
								public void mouseClicked(MouseEvent evt) {
									lst_ShelfListMouseClicked(evt);
								}
							});
						}
					}
					{
						jLabel4 = new JLabel();
						pan_Existing.add(jLabel4);
						jLabel4.setText("Date Created");
						jLabel4.setBounds(28, 88, 102, 15);
					}
					{
						jLabel5 = new JLabel();
						pan_Existing.add(jLabel5);
						jLabel5.setText("Creator");
						jLabel5.setBounds(28, 125, 102, 15);
					}
					{
						jLabel6 = new JLabel();
						pan_Existing.add(jLabel6);
						jLabel6.setText("Comments");
						jLabel6.setBounds(28, 158, 102, 15);
					}
					{
						create_date_txt = new JTextField();
						pan_Existing.add(create_date_txt);
						create_date_txt.setBounds(130, 85, 346, 22);
						create_date_txt.setEditable(false);
					}
					{
						creator_name_txt = new JTextField();
						pan_Existing.add(creator_name_txt);
						creator_name_txt.setEditable(false);
						creator_name_txt.setBounds(130, 122, 346, 22);
					}
					{
						comment_scrpan = new JScrollPane();
						pan_Existing.add(comment_scrpan);
						comment_scrpan.setBounds(28, 179, 448, 104);
						{
							comment_txtarea = new JTextArea();
							comment_scrpan.setViewportView(comment_txtarea);
							comment_txtarea.setEditable(false);
						}
						
						JLabel lbl_Version = new JLabel("Azdblab Version:" + Constants.AZDBLAB_VERSION);
						lbl_Version.setBounds(28,285,448,40);
						pan_Existing.add(lbl_Version);
					}
					{
						btn_ExistingLogin = new JButton();
						pan_Existing.add(btn_ExistingLogin);
						btn_ExistingLogin.setText("Login");
//						btn_ExistingLogin.setBounds(105, 380, 119, 28);
						btn_ExistingLogin.setBounds(105, 340, 119,28);
						btn_ExistingLogin.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent evt) {
								btn_LoginActionPerformed(evt);
							}
						});
					}
					{
						btn_ExistingCancel = new JButton();
						pan_Existing.add(btn_ExistingCancel);
						btn_ExistingCancel.setText("Cancel");
//						btn_ExistingCancel.setBounds(308, 380, 112, 28);
						btn_ExistingCancel.setBounds(270, 340,112,28);
						btn_ExistingCancel.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent evt) {
								btn_CancelActionPerformed(evt);
							}
						});
					}
				}
//				{
//					pan_Specify = new JPanel();
//					tabpan_Options.addTab("Specify a LabShelf", null,
//							pan_Specify, null);
//					pan_Specify.setLayout(null);
//					{
//						jLabel1 = new JLabel();
//						pan_Specify.add(jLabel1);
//						jLabel1.setText("DBMS User Name");
//						jLabel1.setBounds(21, 21, 385, 28);
//					}
//					{
//						jLabel2 = new JLabel();
//						pan_Specify.add(jLabel2);
//						jLabel2.setText("DBMS Password");
//						jLabel2.setBounds(21, 105, 399, 28);
//					}
//					{
//						jLabel3 = new JLabel();
//						pan_Specify.add(jLabel3);
//						jLabel3.setText("JDBC Connect String");
//						jLabel3.setBounds(21, 189, 364, 28);
//					}
//					{
//						txt_UserName = new JTextField();
//						pan_Specify.add(txt_UserName);
//						txt_UserName.setBounds(21, 56, 462, 28);
//					}
//					{
//						txt_Password = new JTextField();
//						pan_Specify.add(txt_Password);
//						txt_Password.setBounds(21, 140, 462, 28);
//					}
//					{
//						txt_ConnectString = new JTextField();
//						pan_Specify.add(txt_ConnectString);
//						txt_ConnectString.setBounds(21, 224, 462, 28);
//					}
//					{
//						btn_SpecifyLogin = new JButton();
//						pan_Specify.add(btn_SpecifyLogin);
//						btn_SpecifyLogin.setText("Login");
////						btn_SpecifyLogin.setBounds(105, 380, 119, 28);
//						btn_SpecifyLogin.setBounds(105, 340, 119,28);
//						btn_SpecifyLogin.addActionListener(new ActionListener() {
//							public void actionPerformed(ActionEvent evt) {
//								btn_LoginActionPerformed(evt);
//							}
//						});
//					}
//					{
//						btn_SpecifyCancel = new JButton();
//						pan_Specify.add(btn_SpecifyCancel);
//						btn_SpecifyCancel.setText("Cancel");
////						btn_SpecifyCancel.setBounds(308, 380, 112, 28);
//						btn_SpecifyCancel.setBounds(270, 340,112,28);
//						btn_SpecifyCancel.addActionListener(new ActionListener() {
//							public void actionPerformed(ActionEvent evt) {
//								btn_CancelActionPerformed(evt);
//							}
//						});
//					}
//				}
				
				{
					pan_Settings = new JPanel();
//					pan_Settings.setBounds(14, 14, 470, 525);
//					pan_Settings.setBorder(BorderFactory.createTitledBorder(null, null,
//							TitledBorder.LEADING, TitledBorder.TOP));
					pan_Settings.setLayout(null);
					
					{
						btngrp_Type = new ButtonGroup();

					}
					
					pan_Settings.setBounds(14, 14, 380, 429);
					pan_Settings.setBorder(BorderFactory.createTitledBorder(null,
							"Setting Strings", TitledBorder.LEADING,
							TitledBorder.TOP));

//					pan_Settings = new JPanel();
////					getContentPane().add(pan_Settings);
//					pan_Settings.setBounds(14, 14, 427, 429);
//					pan_Settings.setBorder(BorderFactory.createTitledBorder(null,
//							"Setting Strings", TitledBorder.LEADING,
//							TitledBorder.TOP));
//					pan_Settings.setLayout(null);
					
					{ // private JCheckBox su_User_Check;

						radbtn_LabShelf = new JRadioButton();
						pan_Settings.add(radbtn_LabShelf);
						radbtn_LabShelf.setText("LabShelf");
						radbtn_LabShelf.setBounds(14, 25, 154, 21);
						btngrp_Type.add(radbtn_LabShelf);
						radbtn_LabShelf.setSelected(true);
						radbtn_LabShelf.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent evt) {
								radbtn_LabShelfActionPerformed(evt);
							}
						});
					}
					{
						ratbtn_ExperimentSubject = new JRadioButton();
						pan_Settings.add(ratbtn_ExperimentSubject);
						ratbtn_ExperimentSubject.setText("Experiment Subject");
						ratbtn_ExperimentSubject.setBounds(238, 25, 175, 21);
						btngrp_Type.add(ratbtn_ExperimentSubject);
						ratbtn_ExperimentSubject
								.addActionListener(new ActionListener() {
									public void actionPerformed(ActionEvent evt) {
										ratbtn_ExperimentSubjectActionPerformed(evt);
									}
								});
					}
					
					{
						jLabel7 = new JLabel();
						pan_Settings.add(jLabel7);
						jLabel7.setText("Name");
						jLabel7.setBounds(21, 45, 385, 28);
					}
					{
						jLabel8 = new JLabel();
						pan_Settings.add(jLabel8);
						jLabel8.setText("DBMS User Name");
						jLabel8.setBounds(21, 105, 399, 28);
					}
					{
						jLabel9 = new JLabel();
						pan_Settings.add(jLabel9);
						jLabel9.setText("DBMS Password");
						jLabel9.setBounds(21, 155, 364, 28);
					}
					{
						jLabel10 = new JLabel();
						pan_Settings.add(jLabel10);
						jLabel10.setText("JDBC Connect String");
						jLabel10.setBounds(17, 203, 196, 28);
					}
					{
						txt_LabShelfExpTitle = new JTextField();
						pan_Settings.add(txt_LabShelfExpTitle);
						txt_LabShelfExpTitle.setBounds(14, 70, 399, 28);
					}
					{
						txt_LabShelfExpUserName = new JTextField();
						pan_Settings.add(txt_LabShelfExpUserName);
						txt_LabShelfExpUserName.setBounds(14, 126, 399, 28);
					}
					{
						txt_LabShelfExpPassword = new JTextField();
						pan_Settings.add(txt_LabShelfExpPassword);
						txt_LabShelfExpPassword.setBounds(15, 177, 399, 28);
					}
					{
						txt_LabShelfExpConnectString = new JTextField();
						pan_Settings.add(txt_LabShelfExpConnectString);
						txt_LabShelfExpConnectString.setText(Constants.AZDBLAB_LABSHELF_SERVER);
						txt_LabShelfExpConnectString.setBounds(17, 231, 399, 28);
					}
					{
						jLabel11 = new JLabel();
						pan_Settings.add(jLabel11);
						jLabel11.setText("Comments");
						jLabel11.setBounds(17, 265, 112, 28);
					}
					{
						comment_scrpan = new JScrollPane();
						pan_Settings.add(comment_scrpan);
						comment_scrpan.setBounds(17, 293, 397, 70);
						{
							comment_txtarea = new JTextArea();
							comment_scrpan.setViewportView(comment_txtarea);
							comment_txtarea
									.setPreferredSize(new java.awt.Dimension(332,51));
						}
					}
					{
						btn_Generate = new JButton();
						pan_Settings.add(btn_Generate);
						btn_Generate.setText("Generate...");
						btn_Generate.setBounds(105,370,119,28);
						btn_Generate.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent evt) {
								btn_GenerateActionPerformed(evt);
							}
						});
					}
					{
						btn_Quit = new JButton();
						pan_Settings.add(btn_Quit);
						btn_Quit.setText("Quit");
						btn_Quit.setBounds(270, 370,112,28);
						btn_Quit.addActionListener(new ActionListener() {
							public void actionPerformed(ActionEvent evt) {
								btn_QuitActionPerformed(evt);
							}
						});
					}
//					tabpan_Options.addTab("LabShelf/ExpSub Configuration", pan_Settings);
					tabpan_Options.addTab("LabShelf/ExpSubject Configuration", pan_Settings);
				} 
			}

			// this.setIconImage(new
			// ImageIcon(getClass().getClassLoader().getResource(AZDBLAB.DIRECTORY_IMAGE
			// + "/" + "azdblab.png")).getImage());
//			this.setSize(535, 460);
			this.setSize(590, 550);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void btn_GenerateActionPerformed(ActionEvent evt) {

		JFileChooser fc = new JFileChooser();
		fc.showSaveDialog(this);

		File saveFile = fc.getSelectedFile();
		try {

			FileWriter frout = new FileWriter(saveFile);
			BufferedWriter brout = new BufferedWriter(frout);

			String strTitle = "";
			String strUserNameEncrypted= "";
			String strPasswordEncrypted= "";
			String strConnectStringEncrypted= "";
			try {

				Encryptor encryptor = new Encryptor("sigmod08");

				strTitle = txt_LabShelfExpTitle.getText();
				strUserNameEncrypted = encryptor
						.encrypt(txt_LabShelfExpUserName.getText());
				strPasswordEncrypted = encryptor
						.encrypt(txt_LabShelfExpPassword.getText());
				strConnectStringEncrypted = encryptor.encrypt(txt_LabShelfExpConnectString
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

			ShelfCreator inst = new ShelfCreator(Constants.AZDBLAB_LABSHELF_SERVER);
			boolean INSTALL = true; // don't change this flag if you're not
//			// superman
//			// TODO
//			boolean reinstall = false;
//			if (reinstall) {
//				inst.uninstall(txt_UserName.getText(), txt_Password.getText());
//				inst.install(txt_UserName.getText(), txt_Password.getText());
//				return;
//			}

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
					inst.install(txt_LabShelfExpUserName.getText(), txt_LabShelfExpPassword.getText());
				}
			} 
			else {
				if (type_.equalsIgnoreCase("labshelf")) {
					// uninstall tables
					inst.uninstall(txt_LabShelfExpUserName.getText(),
							txt_LabShelfExpPassword.getText());
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
//			e.printStackTrace();
			JOptionPane.showMessageDialog(null, "LabShelf table installation failed due to '" + e.getMessage() + "'. Please ask DBA to create user '" + txt_LabShelfExpUserName.getText() +"'.");
		}
	}
	
	private void btn_QuitActionPerformed(ActionEvent evt) {
		this.dispose();
	}
	
	private void btn_LoginActionPerformed(ActionEvent evt) {
		// Main.defaultLogger.logging_info("btn_Login.actionPerformed, event=" +
		// evt);
		// TODO add your code for btn_Login.actionPerformed

		if (strUserName.equals("") || strPassword.equals("")
				|| strConnectString.equals("")) {
			JOptionPane.showMessageDialog(this,
					"Please Use a Valid Connection.");
			return;
		}

//		if ((!txt_UserName.getText().equals(""))
//				&& (!txt_Password.getText().equals(""))
//				&& (!txt_ConnectString.getText().equals(""))) {
//			strUserName = txt_UserName.getText();
//			strPassword = txt_Password.getText();
//			strConnectString = txt_ConnectString.getText();
//		}
		Constants.setNOTEBOOKNAME(strNotebookName);
		Constants.setLABUSERNAME(strUserName);
		Constants.setLABPASSWORD(strPassword);
		Constants.setLABCONNECTSTRING(strConnectString);

		String current_version = null;
		current_version = create_date_txt.getText();

		if (current_version.equals("")) {
			System.exit(1);
		}

		Constants.setCurrentVersion(current_version);
		if (!Constants.ChooseProperSchema(current_version)) {
			System.err.println("Schema not completely loaded.");
			System.exit(2);
		}
		dispose();

	}

	private void ratbtn_ExperimentSubjectActionPerformed(ActionEvent evt) {
		type_ = "experimentsubject";
		txt_LabShelfExpTitle.setText("");
		txt_LabShelfExpUserName.setText("");
		txt_LabShelfExpPassword.setText("");
		txt_LabShelfExpConnectString.setText("");
	}

	private void radbtn_LabShelfActionPerformed(ActionEvent evt) {
		type_ = "labshelf";
		txt_LabShelfExpTitle.setText("");
		txt_LabShelfExpUserName.setText("");
		txt_LabShelfExpPassword.setText("");
		txt_LabShelfExpConnectString.setText(Constants.AZDBLAB_LABSHELF_SERVER);
	}
	
	private void btn_CancelActionPerformed(ActionEvent evt) {
		// Main.defaultLogger.logging_info("btn_Cancel.actionPerformed, event="
		// + evt);
		// TODO add your code for btn_Cancel.actionPerformed
		// dispose();
		System.exit(0);
	}

	private void lst_ShelfListMouseClicked(MouseEvent evt) {
		// Main.defaultLogger.logging_info("lst_ShelfList.mouseClicked, event="
		// + evt);
		// TODO add your code for lst_ShelfList.mouseClicked

		int select = lst_ShelfList.getSelectedIndex();

		if (select >= 0) {
			ListModel lst_ShelfListModel = lst_ShelfList.getModel();
			DBMSConnectParam newDBMSConParam = (DBMSConnectParam) lst_ShelfListModel
					.getElementAt(select);
			strNotebookName = newDBMSConParam.strNotebookName;
			strUserName = newDBMSConParam.strJDBCUserName;
			strPassword = newDBMSConParam.strJDBCPassword;
			strConnectString = newDBMSConParam.strJDBCConnectString;
			create_date_ = newDBMSConParam.create_date_;
			creator_name_ = newDBMSConParam.creator_name_;
			comments_ = newDBMSConParam.comments_;

			create_date_txt.setText(create_date_);
			creator_name_txt.setText(creator_name_);
			comment_txtarea.setText(comments_);
			// Main.defaultLogger.logging_info(strConnectString);
		}
	}

	private void loadLabShelfConnections() {
		File pluginDir = new File(Constants.DIRECTORY_PLUGINS);
		if (!pluginDir.exists()) {
			return;
		}
		File[] dbmsConParams = (pluginDir).listFiles();
		try {
			Map<String, DBMSConnectParam> mapTmpDBCon = new TreeMap<String, DBMSConnectParam>();
			Decryptor decryptor = new Decryptor(Constants.DESKEYPHRASE);
			for (int i = 0; i < dbmsConParams.length; i++) {
				if (dbmsConParams[i].getName().contains(".xml")) {
					Document doc = XMLHelper.readDocument(dbmsConParams[i]);
					Element root = doc.getDocumentElement();
					if (root.getAttribute("TYPE").equals("labShelf")) {
						DBMSConnectParam newDBMSConParam = new DBMSConnectParam(
								root.getAttribute("TITLE"), decryptor
										.decrypt(root
												.getAttribute("LAB_USERNAME")),
								decryptor.decrypt(root
										.getAttribute("LAB_PASSWORD")),
								decryptor.decrypt(root
										.getAttribute("LAB_CONNECTSTRING")),
								root.getAttribute("CREATE_TIME"), root
										.getAttribute("CREATOR_NAME"), root
										.getAttribute("COMMENTS"));

						// vecDBMSConParam.add(newDBMSConParam);
						mapTmpDBCon.put(newDBMSConParam.strNotebookName,
								newDBMSConParam);
					}
				}

			}

			vecDBMSConParam.addAll(mapTmpDBCon.values());

			// Default
			if (vecDBMSConParam.size() > 0) {

				DBMSConnectParam tmpDBConParam = vecDBMSConParam.get(0);
				strNotebookName = tmpDBConParam.strNotebookName;
				strUserName = tmpDBConParam.strJDBCUserName;
				strPassword = tmpDBConParam.strJDBCPassword;
				strConnectString = tmpDBConParam.strJDBCConnectString;
				create_date_ = tmpDBConParam.create_date_;
				creator_name_ = tmpDBConParam.creator_name_;
				comments_ = tmpDBConParam.comments_;

				create_date_txt.setText(create_date_);
				creator_name_txt.setText(creator_name_);
				comment_txtarea.setText(comments_);
				lst_ShelfList.setListData(vecDBMSConParam);
				lst_ShelfList.setSelectedIndex(0);
				tabpan_Options.setSelectedIndex(0);
			} else {
				tabpan_Options.setSelectedIndex(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	// public LabShelf getDataBaseController() {
	// return dbController;
	// }
}
