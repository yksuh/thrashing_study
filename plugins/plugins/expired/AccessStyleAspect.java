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
package plugins.expired;

import java.awt.event.ActionEvent;

import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;


import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.plugins.aspect.Aspect;

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
public class AccessStyleAspect extends Aspect {
	
	class AspectSpecPanel extends javax.swing.JPanel {

		public static final long serialVersionUID	= 4;
		
		private JLabel 			jLabel1;
		private JLabel 			jLabel2;
		private JLabel 			jLabel3;
		private JLabel 			jLabel4;
		private JLabel 			jLabel5;
		private JTable 			tab_AccessView;
		private JScrollPane 	scrpan_TabView;
		private JLabel 			jLabel6;
		private JTextArea 		txtara_Description;
		private JScrollPane 	scrpan_Description;
		private JButton 		btn_Next;
		private JTextField 		txt_AspectName;
		private JTextField 		txt_NotebookName;
		private JTextField 		txt_UserName;
		
		private String			strPanelUserName;
		
		private String			strPanelNotebookName;
		
		private String			strPanelAspectName;
		
		//private String			strPanelAspectValue;
		
		private String			strPanelDescription;
		
		private String			strPanelSQL;
		
		private	boolean			isNew;
		
		
		public AspectSpecPanel(String user_name, String notebook_name, String aspect_name) {
			super();
			
			strPanelUserName		= user_name;
			strPanelNotebookName	= notebook_name;
			strPanelAspectName		= aspect_name;
			//strPanelAspectValue		= aspect_value;
			
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
				this.setPreferredSize(new java.awt.Dimension(595, 560));
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
					jLabel3.setText("Aspect");
					jLabel3.setBounds(35, 119, 63, 21);
				}
				{
					jLabel4 = new JLabel();
					this.add(jLabel4);
					jLabel4.setText("SQL Style Aspect");
					jLabel4.setBounds(196, 7, 147, 28);
					jLabel4.setFont(new java.awt.Font("Dialog",1,14));
				}
				{
					txt_UserName = new JTextField();
					txt_UserName.setText(strPanelUserName);
					this.add(txt_UserName);
					txt_UserName.setBounds(126, 49, 434, 21);
					txt_UserName.setEditable(false);
				}
				{
					txt_NotebookName = new JTextField();
					txt_NotebookName.setText(strPanelNotebookName);
					this.add(txt_NotebookName);
					txt_NotebookName.setBounds(126, 84, 434, 21);
					txt_NotebookName.setEditable(false);
				}
				{
					txt_AspectName = new JTextField();
					txt_AspectName.setText(strPanelAspectName);
					this.add(txt_AspectName);
					txt_AspectName.setBounds(126, 119, 434, 21);
					txt_AspectName.setEditable(false);
				}
				{
					jLabel5 = new JLabel();
					this.add(jLabel5);
					jLabel5.setText("Aspect specification");
					jLabel5.setBounds(35, 154, 161, 28);
				}
				{
					btn_Next = new JButton();
					this.add(btn_Next);
					btn_Next.setText("Next");
					btn_Next.setBounds(231, 518, 119, 28);
					btn_Next.addActionListener(new ActionListener() {
						public void actionPerformed(ActionEvent evt) {
							btn_NextActionPerformed(evt);
						}
					});
				}
				{
					jLabel6 = new JLabel();
					this.add(jLabel6);
					jLabel6.setText("Aspect Description");
					jLabel6.setBounds(35, 378, 112, 21);
				}
				{
					scrpan_Description = new JScrollPane();
					this.add(scrpan_Description);
					scrpan_Description.setBounds(35, 406, 525, 98);
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
					scrpan_TabView = new JScrollPane();
					this.add(scrpan_TabView);
					scrpan_TabView.setBounds(126, 182, 434, 189);
					{
						TableModel tab_AccessViewModel = new DefaultTableModel(
							//new String[][] { { }, { } },
								null,
							new String[] { "A", "B" });
						tab_AccessView = new JTable();
						scrpan_TabView.setViewportView(tab_AccessView);
						tab_AccessView.setModel(tab_AccessViewModel);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		private void btn_NextActionPerformed(ActionEvent evt) {
			Main._logger.outputLog("btn_Next.actionPerformed, event=" + evt);
			//TODO add your code for btn_Next.actionPerformed
			//strDescription		= txtara_Description.getText();
			//strSQL				= txtara_SQL.getText();
			
			//finalizeAspect();
			
			JOptionPane.showMessageDialog(this, "Access Style Aspect Not Available Currently.");
		}
		
		
		public String getDescription() {
			return strPanelDescription;
		}
		
		
		public String getSQL() {
			return strPanelSQL;
		}

	}
	
	private	static final String			strStyleName		= "AccessStyle";
	
	public AccessStyleAspect(String user_name, String notebook_name, String aspect_name, String aspectDescription, String aspectSQL) {
		super(user_name, notebook_name, aspect_name, aspectDescription, aspectSQL);
	}
	
	
	public static String getAspectStyleName() {
		//Main.defaultLogger.logging_normal("STYLE NAME : ---- ABSTRACT CLASS -- " + strStyleName);
		return strStyleName;
	}
	
	
	@Override
	protected void createStyleTable() {
		/*
		TABLE_DEFINEDASPECTOFSTYLE =
			myDBController.new InternalTable(
					AZDBLAB.TABLE_PREFIX + strStyleTableName,
					new String[] { "AspectID", "OtherStuff" },
					new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER, 
								GeneralDBMS.I_DATA_TYPE_CLOB
								},
					new int[] { 10, -1},
					new int[] { 0, 0 },
					new String[] { "AspectID" },
					new ForeignKey[] {
							new ForeignKey(
									new String[] { "AspectID" },
									myDBController.DEFINEDASPECT.TableName,
									new String[] { "AspectID" },
									" ON DELETE CASCADE"),
						}
				);
		
		if (!myDBController.tableExists(TABLE_DEFINEDASPECTOFSTYLE.TableName)) {
			Main.defaultLogger.logging_normal("Install Defined Aspect Table for Style :" + strStyleTableName);
			myDBController.installSpecificTable(TABLE_DEFINEDASPECTOFSTYLE);
		} else {
			Main.defaultLogger.logging_normal("Defined Aspect Table for Style :" + strStyleTableName + " already exists. Ignore installation.");
		}
		*/
	}
	
	@Override
	protected void getAspectDetails() {
		/*
		String 					selectColumnNames	= TABLE_DEFINEDASPECTOFSTYLE.columns[3] + ", " + TABLE_DEFINEDASPECTOFSTYLE.columns[4];	
		
		String					whereStatement		= 	TABLE_DEFINEDASPECTOFSTYLE.columns[0] + " = '" + strUserName + "'" + 
														" AND " +
														TABLE_DEFINEDASPECTOFSTYLE.columns[2] + " = '" + strAspectName + "'";

		if ((strNotebookName != null) && (!strNotebookName.equals(""))) {
			whereStatement	+= " AND " +
			TABLE_DEFINEDASPECTOFSTYLE.columns[1] + " = '" + strNotebookName + "'";
		}
		
		
		String					query				= "SELECT " + selectColumnNames + " FROM " + TABLE_DEFINEDASPECTOFSTYLE.TableName + " WHERE " + whereStatement;
		
		try{

			ResultSet			rs					= myDBController.executeSelectQuery(query);
			
			while (rs.next()) {
				//strSQL			= rs.getString(1);
//				strDescription 	= rs.getString(1);
			}
			
		} catch (SQLException sqlex){
			sqlex.printStackTrace();
		}
		*/
	}

	@Override
	public JPanel getNewSpecificationPanel(JPanel panel_styleselect) {
		// TODO Auto-generated method stub
		
		if (panelAspectSpec == null) {
			
			panelAspectSpec	= new AspectSpecPanel(strUserName, strNotebookName, strAspectName);
			
		}
		return panelAspectSpec;
	}
	

	@Override
	public JPanel getExistingSpecificationPanel(JPanel panel_styleselect) {
		
		
		if (panelAspectSpec == null) {
			
			getAspectDetails();
			
			panelAspectSpec	= new AspectSpecPanel(strUserName, strNotebookName, strAspectName, strAspectDescription, strAspectSQL);
			
		}
		
		return panelAspectSpec;
		
	}


	@Override
	protected boolean storeDefinedAspect() {
		//myDBController.insertAspect(strUserName, strNotebookName, strAspectName, getAspectStyleName());
		return false;
	}
	
	
	@Override
	public boolean storeSpecification() {
		return false;
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
	public String getSupportedShelfs() {
		return "7.X";
	}

}
