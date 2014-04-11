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
package plugins;

import java.awt.event.ActionEvent;

import java.awt.event.ActionListener;
import java.sql.ResultSet;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;


import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.plugins.aspect.Aspect;

import java.sql.SQLException;


public class SQLStyleAspect extends Aspect {
	
	class AspectSpecPanel extends javax.swing.JPanel {

		public static final long serialVersionUID	= 3;
		
		private JLabel 			jLabel1;
		private JLabel 			jLabel2;
		private JLabel 			jLabel3;
		private JLabel 			jLabel4;
		private JLabel 			jLabel5;
		private JLabel 			jLabel6;
		private JLabel 			jLabel7;
		private JTextArea 		txtara_Description;
		private JTextArea 		txtara_SQL;
		private JScrollPane 	scrpan_Description;
		private JButton 		btn_Next;
		private JScrollPane 	scrpan_SQL;
		private JTextField 		txt_AspectName;
		private JTextField		txt_AspectValue;
		private JTextField 		txt_NotebookName;
		private JTextField 		txt_UserName;
		
		private String			strPanelUserName;
		
		private String			strPanelNotebookName;
		
		private String			strPanelAspectName;
		
		private String			strPanelAspectValue;
		
		private String			strPanelDescription;
		
		private String			strPanelSQL;
		
		private	boolean			isNew;
		
		
		public AspectSpecPanel(String user_name, String notebook_name, String aspect_name) {
			super();
			
			strPanelUserName		= user_name;
			strPanelNotebookName	= notebook_name;
			strPanelAspectName		= aspect_name;

			isNew					= true;
			
			initGUI();
		}
		
		
		public AspectSpecPanel(String user_name, String notebook_name, String aspect_name, String description, String sql) {
			super();
			
			strPanelUserName		= user_name;
			strPanelNotebookName	= notebook_name;
			strPanelAspectName		= aspect_name;
			strPanelDescription		= description;
			strPanelSQL				= sql;
			
			isNew					= false;
			
			initGUI();
		}
		
		
		private void initGUI() {
			try {
				this.setPreferredSize(new java.awt.Dimension(800, 600));
				this.setLayout(null);
				{
					jLabel1 = new JLabel();
					this.add(jLabel1);
					jLabel1.setText("User");
					jLabel1.setBounds(35, 50, 63, 21);
				}
				{
					jLabel2 = new JLabel();
					this.add(jLabel2);
					jLabel2.setText("Notebook");
					jLabel2.setBounds(35, 80, 63, 28);
				}
				{
					jLabel3 = new JLabel();
					this.add(jLabel3);
					jLabel3.setText("Aspect Name");
					jLabel3.setBounds(35, 120, 63, 21);
				}
				{
					jLabel6 = new JLabel();
					this.add(jLabel6);
					jLabel6.setText("Aspect Value");
					jLabel6.setBounds(35, 160, 63, 21);
				}
				{
					jLabel4 = new JLabel();
					this.add(jLabel4);
					jLabel4.setText("SQL Style Aspect");
					jLabel4.setBounds(200, 7, 150, 28);
					jLabel4.setFont(new java.awt.Font("Dialog",1,14));
				}
				{
					txt_UserName = new JTextField();
					txt_UserName.setText(strPanelUserName);
					this.add(txt_UserName);
					txt_UserName.setBounds(126, 50, 380, 21);
					txt_UserName.setEditable(false);
				}
				{
					txt_NotebookName = new JTextField();
					txt_NotebookName.setText(strPanelNotebookName);
					this.add(txt_NotebookName);
					txt_NotebookName.setBounds(126, 80, 378, 21);
					txt_NotebookName.setEditable(false);
				}
				{
					txt_AspectName = new JTextField();
					txt_AspectName.setText(strPanelAspectName);
					this.add(txt_AspectName);
					txt_AspectName.setBounds(126, 120, 380, 21);
					txt_AspectName.setEditable(false);
				}
				{
					txt_AspectValue = new JTextField();
					txt_AspectValue.setText(strPanelAspectValue);
					this.add(txt_AspectValue);
					txt_AspectValue.setBounds(126, 160, 380, 21);
					txt_AspectValue.setEditable(false);
				}
				{
					scrpan_SQL = new JScrollPane();
					this.add(scrpan_SQL);
					scrpan_SQL.setBounds(35, 230, 469, 150);
					{
						txtara_SQL = new JTextArea();
						txtara_SQL.setLineWrap(true);
						txtara_SQL.setWrapStyleWord(true);
						if (!isNew) {
							txtara_SQL.setText(strPanelSQL);
							txtara_SQL.setEditable(false);
						}
						scrpan_SQL.setViewportView(txtara_SQL);
						
					}
				}
				{
					jLabel5 = new JLabel();
					this.add(jLabel5);
					jLabel5.setText("Aspect SQL specification");
					jLabel5.setBounds(35, 200, 161, 28);
				}
				{
					btn_Next = new JButton();
					this.add(btn_Next);
					if (isNew) {
						btn_Next.setText("Next");
					} else {
						btn_Next.setText("Back");
					}
					btn_Next.setBounds(210, 550, 119, 28);
					btn_Next.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_NextActionPerformed(evt);
						}
					});
				}
				{
					jLabel7 = new JLabel();
					this.add(jLabel7);
					jLabel7.setText("Aspect Description");
					jLabel7.setBounds(35, 400, 150, 21);
				}
				{
					scrpan_Description = new JScrollPane();
					this.add(scrpan_Description);
					scrpan_Description.setBounds(35, 430, 469, 100);
					{
						txtara_Description = new JTextArea();
						txtara_Description.setLineWrap(true);
						txtara_Description.setWrapStyleWord(true);
						if (!isNew) {
							txtara_Description.setText(strPanelDescription);
							txtara_Description.setEditable(false);
						}
						scrpan_Description.setViewportView(txtara_Description);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		private void btn_NextActionPerformed(ActionEvent evt) {
			//Main._logger.outputLog("btn_Next.actionPerformed, event=" + evt);
			//TODO add your code for btn_Next.actionPerformed
			if (isNew) {
				//strAspectValue		= txt_AspectValue.getText();
				strAspectSQL				= txtara_SQL.getText();
				strAspectDescription		= txtara_Description.getText();
				
				finalizeAspect();
				
			} else {
				panelStyleSelect.setVisible(true);
				setVisible(false);
			}
		}
		
		
		public String getAspectValue() {
			return strPanelAspectValue;
		}
		
		public String getDescription() {
			return strPanelDescription;
		}
		
		
		public String getSQL() {
			return strPanelSQL;
		}

	}
		

	private	static final String			strStyleName		= "SQLStyle";
	
	private static final String			strStyleTableName	= strStyleName.toUpperCase();
	
	private JPanel 						panelStyleSelect;
	
	private String						strAspectExtraInfo;
	
	
	public SQLStyleAspect(	
							String user_name, 
							String notebook_name, 
							String aspect_name, 
							String aspectDescription,
							String aspectSQL ) {
		
		super(user_name, notebook_name, aspect_name, aspectDescription, aspectSQL);
		
		strAspectExtraInfo	= strStyleName +  " defined aspect";
		
	}
	
	
	public static String getAspectStyleName() {
		//Main._logger.outputLog("STYLE NAME : ---- ABSTRACT CLASS -- " + strStyleName);
		return strStyleName;
	}
	
	
	@Override
	protected void createStyleTable() {
		
		TABLE_DEFINEDASPECTOFSTYLE =
			new InternalTable(
					Constants.TABLE_PREFIX + strStyleTableName,
					new String[] { "UserName", "NotebookName", "AspectName", "ExtraInfo" },
					new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR, 
								GeneralDBMS.I_DATA_TYPE_VARCHAR, 
								GeneralDBMS.I_DATA_TYPE_VARCHAR,
								GeneralDBMS.I_DATA_TYPE_VARCHAR
								},
					new int[] { 50, 50, 100, 1000},
					new int[] { 0, 0, 0, 0},
					null,
					new String[] { "UserName", "AspectName" },
					new ForeignKey[] {
							new ForeignKey(
									new String[] { "UserName", "AspectName" },
									Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT,
									new String[] { "UserName", "AspectName" },
									" ON DELETE CASCADE"),
						},
					null
				);
		
		if (!LabShelfManager.getShelf().tableExists(TABLE_DEFINEDASPECTOFSTYLE.TableName)) {
			//Main._logger.outputLog("Install Defined Aspect Table for Style :" + strStyleTableName);
			LabShelfManager.getShelf().installSpecificTable(TABLE_DEFINEDASPECTOFSTYLE);
		} else {
			//Main._logger.outputLog("Defined Aspect Table for Style :" + strStyleTableName + " already exists. Ignore installation.");
		}
		
	}
	
	@Override
	protected void getAspectDetails() {
		
		String 					selectColumnNames	= TABLE_DEFINEDASPECTOFSTYLE.columns[3];	
		
		String					whereStatement		= 	TABLE_DEFINEDASPECTOFSTYLE.columns[0] + " = '" + strUserName + "'" + 
														" AND " +
														TABLE_DEFINEDASPECTOFSTYLE.columns[2] + " = '" + strAspectName + "'";

		if ((strNotebookName != null) && (!strNotebookName.equals(""))) {
			whereStatement	+= " AND " +
			TABLE_DEFINEDASPECTOFSTYLE.columns[1] + " = '" + strNotebookName + "'";
		}
		
		
		String					query				= "SELECT " + selectColumnNames + " FROM " + TABLE_DEFINEDASPECTOFSTYLE.TableName + " WHERE " + whereStatement;
		
		try{

			ResultSet			rs					= LabShelfManager.getShelf().executeQuerySQL(query);
			
			while (rs.next()) {

				strAspectExtraInfo	 	= rs.getString(1);
				
			}
			
		} catch (SQLException sqlex){
			sqlex.printStackTrace();
		}
		
	}
	

	@Override
	public JPanel getNewSpecificationPanel(JPanel panel_styleselect) {
		// TODO Auto-generated method stub
		panelStyleSelect	= panel_styleselect;
		
		if (panelAspectSpec == null) {
			
			panelAspectSpec	= new AspectSpecPanel(strUserName, strNotebookName, strAspectName);
			
		}
		return panelAspectSpec;
	}
	

	@Override
	public JPanel getExistingSpecificationPanel(JPanel panel_styleselect) {
		
		panelStyleSelect	= panel_styleselect;
		
		if (panelAspectSpec == null) {
			
			getAspectDetails();
			
			panelAspectSpec	= new AspectSpecPanel(strUserName, strNotebookName, strAspectName, strAspectDescription, strAspectSQL);
			
		}
		
		return panelAspectSpec;
		
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param aspectName
	 * @param aspectStyle
	 * @param aspectDescription
	 * @param aspectSQL
	 * @return
	 */
	public void insertAspect( 	String userName, 
									String notebookName, 
									String aspectName,
									String aspectStyle,
									String aspectDescription,
									String aspectSQL ) {
		
		
		int		aspectID	= LabShelfManager.getShelf().getSequencialID("SEQ_ASPECTID");

		
		String clobColumnName = "AspectSQL";
		
		String[] columnNames 	= 
			new String[] { 	"AspectID",
							"UserName", 
							"NotebookName", 
							"AspectName", 
							"Style",
							"Description" };
		
		String[] columnValues 	= 
			new String[] { 	String.valueOf(aspectID),
							userName, 
							notebookName, 
							aspectName, 
							aspectStyle,
							aspectDescription };

		int[] 	dataTypes 		=
			new int[] {		GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR };
		
		LabShelfManager.getShelf().putDocument(Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT, clobColumnName, columnNames, columnValues, dataTypes, aspectSQL);
		LabShelfManager.getShelf().commitlabshelf();
		
	}
	
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param aspectName
	 */
	public void deleteAspect(String userName, String notebookName, String aspectName) {
		
		boolean		hasNotebook		= false;
		
		if ((notebookName != null) && (!notebookName.equals(""))) {
			hasNotebook				= true;
		}
		
		String[] 	columnNames 	= null;
		String[] 	columnValues 	= null;
		int[] 		columnDataTypes = null;
		
		if (hasNotebook) {
			columnNames				= new String[] { "UserName", "NotebookName", "AspectName" };
			columnValues 			= new String[] { userName, notebookName, aspectName };
			columnDataTypes			= new int[] { 
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
					};
			
		} else {
			columnNames				= new String[] { "UserName", "AspectName" };
			columnValues 			= new String[] { userName, aspectName };
			columnDataTypes			= new int[] { 
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
					};
		}
				
		
		
		//This delete cascades
		LabShelfManager.getShelf().deleteRows(Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT, columnNames, columnValues, columnDataTypes);
		//myLabShelf.deleteRows(ASPECTVALUE.TableName, columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();
		
	}
	
	@Override
	protected boolean storeDefinedAspect() {
		insertAspect(strUserName, strNotebookName, strAspectName, getAspectStyleName(), strAspectDescription, strAspectSQL);
		return true;
	}
	

	@Override
	public boolean storeSpecification() {

		String[]	columnValues	= new String[TABLE_DEFINEDASPECTOFSTYLE.columns.length];
		
		columnValues[0]				= strUserName;
		columnValues[1]				= strNotebookName;
		columnValues[2]				= strAspectName;
		columnValues[3]				= strAspectExtraInfo;
		
		String[]	columnNames		= new String[TABLE_DEFINEDASPECTOFSTYLE.columns.length];
		int[]		columnDataTypes	= new int[TABLE_DEFINEDASPECTOFSTYLE.columns.length];
		
		for (int i = 0; i < TABLE_DEFINEDASPECTOFSTYLE.columns.length; i++) {
			columnNames[i]		= TABLE_DEFINEDASPECTOFSTYLE.columns[i];
			columnDataTypes[i]	= TABLE_DEFINEDASPECTOFSTYLE.columnDataTypes[i];
		}
		try {
			LabShelfManager.getShelf().insertTuple(	TABLE_DEFINEDASPECTOFSTYLE.TableName,
										columnNames,
										columnValues,
										columnDataTypes );
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return false;
		}
		return true;

	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}

}
