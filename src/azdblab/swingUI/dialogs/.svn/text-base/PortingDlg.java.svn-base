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
import javax.swing.ComboBoxModel;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JTextField;

import javax.swing.JFileChooser;
import javax.swing.filechooser.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Vector;

import azdblab.swingUI.objectNodes.*;

import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.Notebook;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;

import java.sql.SQLException;


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
public class PortingDlg extends javax.swing.JDialog {
	
	public static final long		serialVersionUID	= System.identityHashCode("PortingDlg");
	
	//private InternalDatabaseController	dbController;
	
	
	private JLabel 			jLabel1;
	private JButton 		btn_Browse;
	private JLabel 			jLabel2;
	private JLabel 			jLabel4;
	private JButton 		btn_Cancel;
	private JComboBox 		combox_Experiment;
	private JButton 		btn_Porting;
	//private JComboBox 		combox_Analytics;
	private JComboBox 		combox_Run;
	private JComboBox 		combox_Notebook;
	private JComboBox 		combox_User;
	private JLabel 			jLabel5;
	private JLabel 			jLabel3;
	private JTextField 		txt_filename;

	private static int		MODE;		// 0 : Import
										// 1 : Export
	
	private	static String	strTitle	= null;
	
	
	private int				OPTION;		// 1 USER
										// 2 NOTEBOOK
										// 3 EXPERIMENT
										// 4 RUN
	
	private String			strUserName;
	private String			strNotebookName;
	private String			strExperimentName;
	
	private String			strTestTime;
	private int				iTestNum;
	
	private String			strPortingFileName;	//= "/home/ruizhang/Desktop/AZDBLAB_EXPORT_SAMPLE.xml";
	
	
	public PortingDlg( int mode, int option) {//, InternalDatabaseController db_Controller) {
		super();
		
		MODE			= mode;
		
		OPTION			= option;
		
		//dbController	= db_Controller;
		
		initVar();
		initGUI();
		
	}
	
	/**
	 * 
	 * @param key
	 * @param level Level at which the data is retrieved.
	 * @return
	 */
	private Vector<String> loadData(String[] key, int level) {
		
		Vector<String>	vecResult	= new Vector<String>();
		
		try {
			switch (level) {
			
			case 0:
				Vector<User> userData =User.getAllUsers();
				Vector<UserNode> users = new Vector<UserNode>();
				for (User u : userData) {
					UserNode un = new UserNode(u.getStrUserName());
					un.setCreateDate(u.getStrDateCreate());
					users.add(un);
				}
				for (int i = 0; i < users.size(); i++) {
					vecResult.add((users.get(i)).getUserName());
				}
				//Main.defaultLogger.logging_info("Get Users");
				break;
				
			case 1:
				Vector<NotebookNode> vecnotebook = new Vector<NotebookNode>();
				List<Notebook> notebooks = User.getUser(key[0]).getNotebooks();
				for (Notebook n : notebooks) {
					vecnotebook.add(new NotebookNode(n.getUserName(), n.getNotebookName(), n.getDescription()));
				}
				for (int i = 0; i < notebooks.size(); i++) {
					vecResult.add((notebooks.get(i)).getNotebookName());
				}
				//Main.defaultLogger.logging_info("Get Notebooks");
				break;
								
			case 2:
				Vector<ExperimentNode> experiments = new Vector<ExperimentNode>();
				List<Experiment> ex = User.getUser(key[0]).getNotebook(key[1]).getAllExperiments();
				for (Experiment e : ex) {
					experiments.add(new ExperimentNode(e.getExperimentSource(), e.getUserName(), e.getNotebookName()));
				}
				for (int i = 0; i < experiments.size(); i++) {
					vecResult.add((experiments.get(i)).getExperimentName());
				}
				//Main.defaultLogger.logging_info("Get Experiments");
				break;
				
			case 3:
				List<Run> vecRunNode =User.getUser(key[0]).getNotebook(key[1]).getExperiment(key[2]).getCompletedRuns();
				
				for (int i = 0; i < vecRunNode.size(); i++) {
					vecResult.add((vecRunNode.get(i)).getStartTime());
				}
				//Main.defaultLogger.logging_info("Get Runs");
				break;
				
			default:
				break;
			
			}
			
			return vecResult;
			
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return null;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	
	
	private void initVar() {		
		if (MODE == 0) {
			strTitle	= "Import";
		} else if (MODE == 1) {
			strTitle	= "Export";
		}
	}
	
	
	private void initGUI() {
		try {
			{
				getContentPane().setLayout(null);
				this.setTitle(strTitle);
				{
					jLabel1 = new JLabel();
					getContentPane().add(jLabel1);
					jLabel1.setText("File Name");
					jLabel1.setBounds(84, 70, 63, 28);
				}
				{
					txt_filename = new JTextField();
					getContentPane().add(txt_filename);
					txt_filename.setBounds(161, 70, 308, 28);
				}
				{
					btn_Browse = new JButton();
					getContentPane().add(btn_Browse);
					btn_Browse.setText("Browse...");
					btn_Browse.setBounds(490, 70, 98, 28);
					btn_Browse.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_BrowseActionPerformed(evt);
						}
					});
				}
				{
					jLabel2 = new JLabel();
					getContentPane().add(jLabel2);
					jLabel2.setText("Users");
					jLabel2.setBounds(35, 154, 49, 28);
				}
				{
					jLabel3 = new JLabel();
					getContentPane().add(jLabel3);
					jLabel3.setText("Notebooks");
					jLabel3.setBounds(168, 154, 91, 28);
				}
				{
					jLabel4 = new JLabel();
					getContentPane().add(jLabel4);
					jLabel4.setText("Experiments");
					jLabel4.setBounds(322, 154, 91, 28);
				}
				{
					jLabel5 = new JLabel();
					getContentPane().add(jLabel5);
					jLabel5.setText("Analytics");
					jLabel5.setBounds(469, 154, 91, 28);
				}
				{					
					Vector<String>	vecUsers	= loadData(new String[]{""}, 0);
					String[]		items		= new String[vecUsers.size() + 1];
					for (int i = 1; i <= vecUsers.size(); i++) {
						items[i]	= (String)vecUsers.get(i - 1);
					}
					items[0]	= "Select User";
					
					ComboBoxModel combox_UserModel = new DefaultComboBoxModel(items);
						
					combox_User = new JComboBox();
					getContentPane().add(combox_User);
					combox_User.setModel(combox_UserModel);
					combox_User.setBounds(40, 189, 120, 28);
					combox_User.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							combox_UserActionPerformed(evt);
						}
					});					
				}
				{
					ComboBoxModel combox_NotebookModel = new DefaultComboBoxModel(
						new String[] { "Select Notebook" });
					combox_Notebook = new JComboBox();
					getContentPane().add(combox_Notebook);
					combox_Notebook.setModel(combox_NotebookModel);
					combox_Notebook.setBounds(180, 189, 120, 28);
					//combox_User.addItemListener(new ItemListener() {
					//	public void itemStateChanged(ItemEvent evt) {
					//		combox_NotebookItemStateChanged(evt);
					//	}
					//});
					combox_Notebook.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							combox_NotebookActionPerformed(evt);
						}
					});
				}
				{
					ComboBoxModel combox_ExperimentModel = new DefaultComboBoxModel(
						new String[] { "Select Experiment" });
					combox_Experiment = new JComboBox();
					getContentPane().add(combox_Experiment);
					combox_Experiment.setModel(combox_ExperimentModel);
					combox_Experiment.setBounds(320, 189, 120, 28);
					combox_Experiment.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							combox_ExperimentActionPerformed(evt);
						}
					});
				}
				{
					ComboBoxModel combox_RunModel = new DefaultComboBoxModel(
						new String[] { "Select Run" });
					combox_Run = new JComboBox();
					getContentPane().add(combox_Run);
					combox_Run.setModel(combox_RunModel);
					combox_Run.setBounds(460, 189, 120, 28);
					//combox_Run.addActionListener(new ActionListener() {
					//	public void actionPerformed(ActionEvent evt) {
					//		combox_RunActionPerformed(evt);
					//	}
					//});
					
				}
				{
				//	ComboBoxModel combox_AnalyticsModel = new DefaultComboBoxModel(
				//		new String[] { "Select Analytics" });
				//	combox_Analytics = new JComboBox();
				//	getContentPane().add(combox_Analytics);
				//	combox_Analytics.setModel(combox_AnalyticsModel);
				//	combox_Analytics.setBounds(469, 189, 105, 28);
				}
				{
					btn_Porting = new JButton();
					getContentPane().add(btn_Porting);
					//btn_Porting.setText("Porting");
					btn_Porting.setText(strTitle);
					btn_Porting.setBounds(427, 294, 98, 28);
					btn_Porting.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_PortingActionPerformed(evt);
						}
					});
				}
				{
					btn_Cancel = new JButton();
					getContentPane().add(btn_Cancel);
					btn_Cancel.setText("Cancel");
					btn_Cancel.setBounds(553, 294, 98, 28);
					btn_Cancel.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_CancelActionPerformed(evt);
						}
					});
				}
			}
			this.setSize(730, 411);
			this.setTitle(strTitle);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void btn_CancelActionPerformed(ActionEvent evt) {
		//Main.defaultLogger.logging_info("btn_Cancel.actionPerformed, event=" + evt);
		//TODO add your code for btn_Cancel.actionPerformed
		dispose();
	}
	
	private void btn_PortingActionPerformed(ActionEvent evt) {
		//Main.defaultLogger.logging_info("btn_Porting.actionPerformed, event=" + evt);
		//TODO add your code for btn_Porting.actionPerformed
		
		strUserName			= combox_User.getSelectedItem().toString();
		strNotebookName		= combox_Notebook.getSelectedItem().toString();
		strExperimentName	= combox_Experiment.getSelectedItem().toString();
		strTestTime			= combox_Run.getSelectedItem().toString();
		
		//dbController.ExportUsers(strUserName);
		
		dispose();
		
	}

	
	private void btn_BrowseActionPerformed(ActionEvent evt) {
		//Main.defaultLogger.logging_info("btn_Porting.actionPerformed, event=" + evt);
		//TODO add your code for btn_Porting.actionPerformed
		
		JFileChooser fc = new JFileChooser();
		
		FileFilter ff = new FileNameExtensionFilter(".xml", "xml");
		fc.addChoosableFileFilter(ff);
		
		if (MODE == 0) {
			fc.showOpenDialog(this);
		} else if (MODE == 1) {
			fc.showSaveDialog(this);
		}
		
		File	file		= fc.getSelectedFile();
		
		strPortingFileName	= file.getAbsolutePath();
		
	}
	
	
	
	public String getUserName() {
		return strUserName;
	}
	
	public String getNotebookName() {
		return strNotebookName;
	}
	
	public String getExperimentName() {
		return strExperimentName;
	}
	
	public String getPortingFileName() {
		return strPortingFileName;
	}
	
	public String getTestTime() {
		return strTestTime;
	}
	
	public int getTestNum() {
		return iTestNum;
	}
	
	public int getOption() {
		return OPTION;
	}
	
	public void loadItems() {
		// load the dbms controller
	}
	
	private void combox_UserActionPerformed(ActionEvent evt) {
		//Main.defaultLogger.logging_info("combox_User.itemStateChanged, event=" + evt);
		//TODO add your code for combox_User.itemStateChanged
		
		if (combox_User.getSelectedIndex() == 0) {
			return;
		}
		
		String			user			= combox_User.getSelectedItem().toString();
		
		Vector<String>	vecNotebooks	= loadData(new String[]{user}, 1);
		String[]		items			= new String[vecNotebooks.size() + 1];
		for (int i = 1; i <= vecNotebooks.size(); i++) {
			items[i]	= (String)vecNotebooks.get(i - 1);
		}
		
		items[0]	= "Select Notebook";
		
		ComboBoxModel combox_NotebookModel = new DefaultComboBoxModel(items);
		
		combox_Notebook.setModel(combox_NotebookModel);
		
		combox_Notebook.setSelectedIndex(0);
	}
	
	
	private void combox_NotebookActionPerformed(ActionEvent evt) {
		
		//if (combox_Notebook.getSelectedIndex() == 0) {
		//	return;
		//}
		
		String			user			= combox_User.getSelectedItem().toString();
		String			notebook		= combox_Notebook.getSelectedItem().toString();
		
		Vector<String>	vecExperiments	= loadData(new String[]{user, notebook}, 2);
		String[]		items			= new String[vecExperiments.size() + 1];
		for (int i = 1; i <= vecExperiments.size(); i++) {
			items[i]	= (String)vecExperiments.get(i - 1);
		}
		
		items[0]	= "Select Experiment";
		
		ComboBoxModel combox_ExperimentModel = new DefaultComboBoxModel(items);
		
		combox_Experiment.setModel(combox_ExperimentModel);
		
		combox_Experiment.setSelectedIndex(0);
	}
	
	
	private void combox_ExperimentActionPerformed(ActionEvent evt) {
		
		if (combox_Experiment.getSelectedIndex() == 0) {
			return;
		}
		
		String			user			= combox_User.getSelectedItem().toString();
		String			notebook		= combox_Notebook.getSelectedItem().toString();
		String			experiment		= combox_Experiment.getSelectedItem().toString();
		
		Vector<String>	vecRuns			= loadData(new String[]{user, notebook, experiment}, 3);
		String[]		items			= new String[vecRuns.size() + 1];
		for (int i = 1; i <= vecRuns.size(); i++) {
			items[i]	= (String)vecRuns.get(i - 1);
		}
		
		items[0]	= "Select Run";
		
		ComboBoxModel combox_RunModel = new DefaultComboBoxModel(items);
		
		combox_Run.setModel(combox_RunModel);
		
		combox_Run.setSelectedIndex(0);
	}
	
}
