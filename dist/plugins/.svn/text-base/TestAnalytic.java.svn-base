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

import javax.swing.ComboBoxModel;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.plugins.analytic.Analytic;
import azdblab.swingUI.objectNodes.AspectDefinitionNode;

import java.sql.SQLException;
import java.util.List;
import java.util.Date;


public class TestAnalytic extends Analytic {
	
	class AnalyticSpecPanel extends javax.swing.JPanel {

		public static final long serialVersionUID	= 12345567; //System.identityHashCode("TestAnalytic");
		
		private JLabel 			jLabel1;
		private JLabel 			jLabel2;
		private JLabel 			jLabel3;
		private JLabel 			jLabel4;
		private JLabel 			jLabel5;
		private JLabel 			jLabel6;
		
		private JTextArea 		txtara_Description;
		private JScrollPane 	scrpan_Description;
		private JButton 		btn_Next;
		private JButton			btn_Run;
		private JTextField 		txt_AnalyticName;
		private JTextField 		txt_NotebookName;
		private JTextField 		txt_UserName;
		
		//private JTextField 		txt_AspectValue;
		
		
		
		private JComboBox 		cmbbox_Operation;
		private JComboBox 		cmbbox_AspectName;
		//private JComboBox 		cmbbox_AspectValue;
		
		//private JTextField		txt_AspectValue;

		
		private String			strPanelUserName;
		
		private String			strPanelNotebookName;
		
		private String			strPanelAnalyticName;
		
		private String			strPanelDescription;
		
		//private String			strPanelAspectValue;
		
		private String			strPanelOperation;
		
		private String			strPanelAspectName;
		
		private	boolean			isNew;
		
		
		public AnalyticSpecPanel(String user_name, String notebook_name, String analytic_name) {
			super();
			
			strPanelUserName		= user_name;
			strPanelNotebookName	= notebook_name;
			strPanelAnalyticName	= analytic_name;
			
			isNew					= true;
			
			initGUI();
		}
		
		
		public AnalyticSpecPanel(	String user_name, 
									String notebook_name, 
									String analytic_name, 
									String operation,
									String aspect_name, 
									String description ) {
			super();
			
			strPanelUserName		= user_name;
			strPanelNotebookName	= notebook_name;
			strPanelAnalyticName	= analytic_name;
			
			strPanelOperation		= operation;
			strPanelAspectName		= aspect_name;
			strPanelDescription		= description;

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
					jLabel1.setBounds(35, 49, 63, 21);
				}
				{
					jLabel2 = new JLabel();
					this.add(jLabel2);
					jLabel2.setText("Notebook");
					jLabel2.setBounds(35, 77, 63, 28);
				}
				{
					jLabel3 = new JLabel();
					this.add(jLabel3);
					jLabel3.setText("Analytic");
					jLabel3.setBounds(35, 119, 63, 21);
				}
				{
					jLabel4 = new JLabel();
					this.add(jLabel4);
					jLabel4.setText("Test Analytic");
					jLabel4.setBounds(196, 7, 147, 28);
					jLabel4.setFont(new java.awt.Font("Dialog",1,14));
				}
				{
					txt_UserName = new JTextField();
					txt_UserName.setText(strPanelUserName);
					this.add(txt_UserName);
					txt_UserName.setBounds(126, 49, 378, 21);
					txt_UserName.setEditable(false);
				}
				{
					txt_NotebookName = new JTextField();
					txt_NotebookName.setText(strPanelNotebookName);
					this.add(txt_NotebookName);
					txt_NotebookName.setBounds(126, 84, 378, 21);
					txt_NotebookName.setEditable(false);
				}
				{
					txt_AnalyticName = new JTextField();
					txt_AnalyticName.setText(strPanelAnalyticName);
					this.add(txt_AnalyticName);
					txt_AnalyticName.setBounds(126, 119, 378, 21);
					txt_AnalyticName.setEditable(false);
				}
				{
					btn_Next = new JButton();
					this.add(btn_Next);
					if (isNew) {
						btn_Next.setText("Next");
					} else {
						btn_Next.setText("Back");
					}
					btn_Next.setBounds(200, 460, 120, 30);
					btn_Next.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_NextActionPerformed(evt);
						}
					});
				}
				{
					btn_Run = new JButton();
					this.add(btn_Run);
					btn_Run.setText("Run");
					btn_Run.setBounds(200, 500, 120, 30);
					if (isNew) {
						btn_Run.setEnabled(false);
					}
					btn_Run.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_RunActionPerformed(evt);
						}
					});
				}
				{
					jLabel6 = new JLabel();
					this.add(jLabel6);
					jLabel6.setText("Analytic Description");
					jLabel6.setBounds(35, 329, 161, 21);
				}
				{
					scrpan_Description = new JScrollPane();
					this.add(scrpan_Description);
					scrpan_Description.setBounds(35, 357, 469, 84);
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
				{
					ComboBoxModel cmbbox_AnalyticsModel = new DefaultComboBoxModel(initOperation());
					cmbbox_Operation = new JComboBox();
					add(cmbbox_Operation);
					cmbbox_Operation.setModel(cmbbox_AnalyticsModel);
					cmbbox_Operation.setBounds(30, 203, 180, 28);
				}
				{
					ComboBoxModel cmbbox_AspectNameModel = new DefaultComboBoxModel(initAspectName());
					cmbbox_AspectName = new JComboBox();
					add(cmbbox_AspectName);
					cmbbox_AspectName.setModel(cmbbox_AspectNameModel);
					cmbbox_AspectName.setBounds(250, 203, 250, 28);
					cmbbox_AspectName.setAutoscrolls(true);
					cmbbox_AspectName.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							cmbbox_AspectNameActionPerformed(evt);
						}
					});
				}
				{
					jLabel5 = new JLabel();
					this.add(jLabel5);
					jLabel5.setText("Please Specify Aspect Value");
					jLabel5.setBounds(35, 280, 180, 28);
				}
				//{
				//	ComboBoxModel cmbbox_AspectValueModel = new DefaultComboBoxModel(initAspectValue());
				//	cmbbox_AspectValue = new JComboBox();
				//	add(cmbbox_AspectValue);
				//	cmbbox_AspectValue.setModel(cmbbox_AspectValueModel);
				//	cmbbox_AspectValue.setBounds(224, 280, 280, 28);
				//}
				//{
				//	txt_AspectValue = new JTextField();
				//	this.add(txt_AspectValue);
				//	if (!isNew) {
				//		txt_AspectValue.setText(strPanelAspectValue);
				//	}
				//	txt_AspectValue.setBounds(224, 280, 280, 28);
				//	txt_AspectValue.setEditable(false);
				//}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		private void btn_NextActionPerformed(ActionEvent evt) {
			//Main.defaultLogger.logging_normal("btn_Next.actionPerformed, event=" + evt);
			//TODO add your code for btn_Next.actionPerformed
			
			
			if (isNew) {
				
				strOperation			= cmbbox_Operation.getSelectedItem().toString();
				strAspectName			= cmbbox_AspectName.getSelectedItem().toString();
				//strAspectValue			= txt_AspectValue.getText();
				strAnalyticDescription	= txtara_Description.getText();
				
				strAnalyticSQL			= buildAnalyticQuery( 	strUserName,
																strNotebookName,
																strAnalyticName,
																strOperation,
																strAspectName );
				
				finalizeAnalytic();
				
				btn_Run.setEnabled(true);
				
			} else {
				panelStyleSelect.setVisible(true);
				setVisible(false);
			}
		}
		
		
		private void btn_RunActionPerformed(ActionEvent evt) {
			//Main.defaultLogger.logging_normal("btn_Run.actionPerformed, event=" + evt);
			//TODO add your code for btn_Next.actionPerformed
			computeAnalytic(strUserName, strNotebookName, strAnalyticSQL, strAnalyticName);
		}
		
		private void cmbbox_AspectNameActionPerformed(ActionEvent evt) {
			//Main.defaultLogger.logging_normal("cmbbox_AspectName.actionPerformed, event=" + evt);
			//TODO add your code for cmbbox_AspectName.actionPerformed
			strAspectName				= cmbbox_AspectName.getSelectedItem().toString();
			
			//String		aspectval		= myDBController.getAspectType(strUserName, aspectname);
			
			//txt_AspectValue.setText(aspectval);
		}
		
		
		
		private String[] initOperation() {
			if (isNew) {
				return new String[] {"COUNT"};
			} else {
				return new String[] {strOperation};
			}
		}
		
		private String[] initAspectName() {
			if (!isNew) {
				return new String[] {strAspectName};
			}
			
			List<AspectDefinitionNode>	aspects			= getAllAspects();
			
			String[]						aspectNames		= new String[aspects.size() + 1];
			
			for (int i = 0; i < aspects.size(); i++) {
				AspectDefinitionNode	aspectNode	= aspects.get(i);
				aspectNames[i + 1]					= aspectNode.getAspectName();
			}
			
			aspectNames[0]									= "Select Aspect";
			
			return aspectNames;
			
		}
	
		
		public String getDescription() {
			return strPanelDescription;
		}
		
		public String getOperation() {
			return strPanelOperation;
		}
		
		public String getAspectName() {
			return strPanelAspectName;
		}
		
		//public String getAspectValue() {
		//	return strPanelAspectValue;
		//}

	}
		

	private	static final String			strStyleName				= "TESTStyle";
	
	private static final String			strStyleTableName			= strStyleName.toUpperCase();
	
	
	private String						strOperation;
	
	private String						strAspectName;
	
	//private String						strAspectValue;
	
	private JPanel 						panelStyleSelect;
	
	public TestAnalytic( 
						String userName, 
						String notebookName, 
						String analyticName, 
						String analyticDescription, 
						String analyticSQL ) {
		super(userName, notebookName, analyticName, analyticDescription, analyticSQL);
	}
	
	
	public static String getAnalyticStyleName() {
		return strStyleName;
	}
	
	
	@Override
	protected void createStyleTable() {

		TABLE_DEFINEDANALYTICOFSTYLE =
			new InternalTable(
					Constants.TABLE_PREFIX + strStyleTableName,
					new String[] { "UserName", "NotebookName", "AnalyticName", "Operation", "AspectName" },
					new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR, 
								GeneralDBMS.I_DATA_TYPE_VARCHAR,
								GeneralDBMS.I_DATA_TYPE_VARCHAR, 
								GeneralDBMS.I_DATA_TYPE_VARCHAR,
								GeneralDBMS.I_DATA_TYPE_VARCHAR
								},
					new int[] { 50, 50, 100, 50, 100 },
					new int[] { 0, 0, 0, 0, 0 },
					null,
					new String[] { "UserName", "AnalyticName" },
					new ForeignKey[] {
							new ForeignKey(
									new String[] { "UserName", "AnalyticName" },
									Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDANALYTIC,
									new String[] { "UserName", "AnalyticName" }, 
									"ON DELETE CASCADE"),
						},
					null
				);
		
		if (!LabShelfManager.getShelf().tableExists(TABLE_DEFINEDANALYTICOFSTYLE.TableName)) {
			//Main.defaultLogger.logging_normal("Install Defined Analytic Table for Style :" + strStyleTableName);
			LabShelfManager.getShelf().installSpecificTable(TABLE_DEFINEDANALYTICOFSTYLE);
		} else {
			//Main.defaultLogger.logging_normal("Defined Aspect Table for Style :" + strStyleTableName + " already exists. Ignore installation.");
		}
	}
	
	@Override
	protected void getAnalyticDetails() {
		
		String 					selectColumnNames	= 	TABLE_DEFINEDANALYTICOFSTYLE.columns[3] + ", " + 
														TABLE_DEFINEDANALYTICOFSTYLE.columns[4];
		
		String					whereStatement		= 	TABLE_DEFINEDANALYTICOFSTYLE.columns[0] + " = '" + strUserName + "'" + 
														" AND " +
														TABLE_DEFINEDANALYTICOFSTYLE.columns[2] + " = '" + strAnalyticName + "'";

		if ((strNotebookName != null) && (!strNotebookName.equals(""))) {
			whereStatement	+= " AND " +
			TABLE_DEFINEDANALYTICOFSTYLE.columns[1] + " = '" + strNotebookName + "'";
		}
		
		
		String					query				= "SELECT " + selectColumnNames + " FROM " + TABLE_DEFINEDANALYTICOFSTYLE.TableName + " WHERE " + whereStatement;
		
		try{

			ResultSet			rs					= LabShelfManager.getShelf().executeQuerySQL(query);
			
			while (rs.next()) {
				strOperation	= rs.getString(1);
				strAspectName	= rs.getString(2);
			}
			
		} catch (SQLException sqlex){
			sqlex.printStackTrace();
		}
	}

	@Override
	public JPanel getNewSpecificationPanel(JPanel panel_styleselect) {
		
		panelStyleSelect	= panel_styleselect;
		
		if (panelAnalyticSpec == null) {
			
			panelAnalyticSpec	= new AnalyticSpecPanel(strUserName, strNotebookName, strAnalyticName);
			
		}
		return panelAnalyticSpec;
	}
	

	@Override
	public JPanel getExistingSpecificationPanel(JPanel panel_styleselect) {
		
		panelStyleSelect	= panel_styleselect;
		
		if (panelAnalyticSpec == null) {
			
			getAnalyticDetails();
			
			panelAnalyticSpec	= new AnalyticSpecPanel(strUserName, strNotebookName, strAnalyticName, strOperation, strAspectName, strAnalyticDescription);			
		}
		
		return panelAnalyticSpec;
		
	}

	
	private String buildAnalyticQuery(	String user_name,
										String notebook_name,
										String analytic_name,
										String operation,
										String aspect_name
										 ) {
		
		String		tempTabName		= strAnalyticTempTablePrefix;

		String		querySQL		= "";
		
		String[]	aspNames		= aspect_name.split(" with ");
		
		
//		if (operation.equals("EXISTENCE")) {
//			querySQL	=	"SELECT UserName, NotebookName, ExperimentName, CreateTime, TestNumber, " + 
//							"FROM " + tempTabName + " " +
//							"WHERE AspectName = '" + aspNames[aspNames.length - 1] + 
//							"ORDER BY UserName, NotebookName, ExpName";
//		} else if(operation.equals("COUNT")) {

		if(operation.equals("COUNT")) {
		
			querySQL	=	"SELECT RunID, SUM(AspectValue) AS ANALYTICVALUE " + 
							"FROM " + tempTabName + " " + 
							"WHERE AspectName = '" + aspNames[aspNames.length - 1] + "' " + 
							"GROUP BY RunID";
			
			//if (notebook_name != null && !notebook_name.equals("")) {
			//	querySQL	+= ", NotebookName";
			//}
			
		} else if (operation.equals("SHOW PLANID")) {
			
			querySQL	= 	"SELECT ex.ExperimentName, t.RunID, t.QueryID " +
							"FROM " + tempTabName + " t, AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " +
							"WHERE AspectName = '" + aspNames[aspNames.length - 1] + "' AND t.RunID = er.RunID AND er.ExperimentID = ex.ExperimentID";
			
		
		} else {
			Main._logger.outputLog("OPERATION TYPE " + operation + " is NOT available");
		}

		return querySQL;
		
	}
	
	
	@Override
	protected boolean storeDefinedAnalytic() {
		Date	date	= new Date(System.currentTimeMillis());
		insertAnalytic(	strUserName, 
												strNotebookName, 
												strAnalyticName, 
												getAnalyticStyleName(),
												date.toString(),
												strAnalyticDescription,
												strAnalyticSQL
											);
		return true;
	}

	@Override
	public boolean storeSpecification() {

		String[]	columnValues	= new String[TABLE_DEFINEDANALYTICOFSTYLE.columns.length];
		
		columnValues[0]				= strUserName;
		columnValues[1]				= strNotebookName;
		columnValues[2]				= strAnalyticName;
		columnValues[3]				= strOperation;
		columnValues[4]				= strAspectName;
		
		String[]	columnNames		= new String[TABLE_DEFINEDANALYTICOFSTYLE.columns.length];
		int[]		columnDataTypes	= new int[TABLE_DEFINEDANALYTICOFSTYLE.columns.length];
		
		for (int i = 0; i < TABLE_DEFINEDANALYTICOFSTYLE.columns.length; i++) {
			columnNames[i]		= TABLE_DEFINEDANALYTICOFSTYLE.columns[i];
			columnDataTypes[i]	= TABLE_DEFINEDANALYTICOFSTYLE.columnDataTypes[i];
		}
		try {
			LabShelfManager.getShelf().insertTuple(	TABLE_DEFINEDANALYTICOFSTYLE.TableName,
									columnNames,
									columnValues,
									columnDataTypes);
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return false;
		}

		return true;

	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param analyticName
	 * @param analyticStyle
	 * @param createDate
	 * @param analyticDescription
	 * @param analyticSQL
	 * @return
	 */
	public void insertAnalytic( 	String userName, 
									String notebookName, 
									String analyticName,
									String analyticStyle,
									String createDate,
									String analyticDescription,
									String analyticSQL ) {


		int		analyticID	= LabShelfManager.getShelf().getSequencialID("SEQ_ANALYTICID");


		String clobColumnName = "AnalyticSQL";

		String[] columnNames 	=
			new String[] { 	"AnalyticID",
							"UserName", 
							"NotebookName", 
							"AnalyticName", 
							"Style",
							"CreateDate",
							"Description" };

		String[] columnValues 	= 
			new String[] { 	String.valueOf(analyticID),
							userName, 
							notebookName, 
							analyticName, 
							analyticStyle,
							createDate,
							analyticDescription };

		int[] 	dataTypes 		=
			new int[] {		GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR,
							GeneralDBMS.I_DATA_TYPE_VARCHAR };

		LabShelfManager.getShelf().putDocument(Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDANALYTIC, clobColumnName, columnNames, columnValues, dataTypes, analyticSQL);
		LabShelfManager.getShelf().commitlabshelf();

	}
	

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param analyticName
	 */
	public void deleteAnalytic(String userName, String notebookName, String analyticName) {
		
		boolean		hasNotebook		= false;
		
		if ((notebookName != null) && (!notebookName.equals(""))) {
			hasNotebook				= true;
		}
		
		String[] 	columnNames 	= null;
		String[] 	columnValues 	= null;
		int[] 		columnDataTypes = null;
		
		if (hasNotebook) {
			columnNames				= new String[] { "UserName", "NotebookName", "AnalyticName" };
			columnValues 			= new String[] { userName, notebookName, analyticName };
			columnDataTypes			= new int[] { 
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
					};
			
		} else {
			columnNames				= new String[] { "UserName", "AnalyticName" };
			columnValues 			= new String[] { userName, analyticName };
			columnDataTypes			= new int[] { 
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
					};
		}
				
		
		
		//This delete cascades
		LabShelfManager.getShelf().deleteRows(Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDANALYTIC, columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();
		
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
	
}
