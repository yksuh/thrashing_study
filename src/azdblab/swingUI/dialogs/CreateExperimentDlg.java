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
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Element;

import org.w3c.dom.Document;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.experiment.ExperimentErrorHandler;

public class CreateExperimentDlg extends javax.swing.JDialog {
	public static final long serialVersionUID = System
			.identityHashCode("CreateExperimentDlg");

	private String strUserName;
	private String strNotebookName;

	private JTextField txt_name;
	private JTextField txt_scenario;
	private JTextField txt_Cardinality;
	private JTextField txt_Granularity;
	private JCheckBox chk_Primary;
	private JLabel lbl_SelectedQuery;

	private String QueryFileName = "";
	private int numQueries;

	public CreateExperimentDlg(String userName, String notebookName) {
		super();
		try {
			strUserName = userName;
			strNotebookName = notebookName;
			initGUI();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void initGUI() throws Exception {

		JLabel lbl_name = new JLabel("Experiment Name:");
		lbl_name.setBounds(15, 20, 300, 30);
		this.add(lbl_name);

		txt_name = new JTextField();
		txt_name.setBounds(315, 20, 300, 30);
		this.add(txt_name);

		JLabel lbl_scenario = new JLabel("Scenario Name:");
		lbl_scenario.setBounds(15, 60, 300, 30);
		this.add(lbl_scenario);

		txt_scenario = new JTextField();
		txt_scenario.setBounds(315, 60, 300, 30);
		this.add(txt_scenario);

		JLabel lbl_Cardinality = new JLabel("Input Median Cardinality:");
		lbl_Cardinality.setBounds(15, 100, 300, 30);
		this.add(lbl_Cardinality);

		txt_Cardinality = new JTextField();
		txt_Cardinality.setBounds(315, 100, 300, 30);
		this.add(txt_Cardinality);

		JLabel lbl_Granularity = new JLabel("Input Search Granularity");
		lbl_Granularity.setBounds(15, 140, 300, 30);
		this.add(lbl_Granularity);

		txt_Granularity = new JTextField();
		txt_Granularity.setBounds(315, 140, 300, 30);
		this.add(txt_Granularity);

		chk_Primary = new JCheckBox("This Experiment Uses Primary Keys");
		chk_Primary.setBounds(15, 180, 300, 30);
		this.add(chk_Primary);

		JLabel lbl_Query = new JLabel("Query Definition");
		lbl_Query.setBounds(15, 220, 300, 30);
		this.add(lbl_Query);

		lbl_SelectedQuery = new JLabel("No Selection");
		lbl_SelectedQuery.setBounds(315, 220, 300, 30);
		this.add(lbl_SelectedQuery);

		JButton btn_Query = new JButton("Choose File");
		btn_Query.setBounds(15, 260, 100, 30);
		btn_Query.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				JFileChooser chooser = new JFileChooser();
				chooser.setCurrentDirectory(new java.io.File("/home"));
				chooser
						.setDialogTitle("Please select a Query Specification File");
				String filename = "";
				if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
					filename += chooser.getSelectedFile();
				} else {
					return;
				}
				if (isValid(filename)) {
					QueryFileName = filename;
					lbl_SelectedQuery.setText(QueryFileName);
				} else {
					JOptionPane.showMessageDialog(null,
							"Error, this query File is invalid");
				}

			}
		});
		this.add(btn_Query);

		JButton btn_Go = new JButton("Add Experiment");
		btn_Go.setBounds(15, 300, 200, 50);
		btn_Go.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (QueryFileName.equals("")) {
					JOptionPane.showMessageDialog(null,
							"Please select a QueryFile");
					return;
				}
				String experiment_name = txt_name.getText().trim();
				String scenario_name = txt_scenario.getText().trim();
				if (experiment_name.equals("") || scenario_name.equals("")) {
					JOptionPane.showMessageDialog(null,
							"Error, one or more fields is not filled out");
					return;
				}

				int cardinality = 0, granularity = 0;
				try {
					cardinality = Integer.parseInt(txt_Cardinality.getText()
							.trim());
					granularity = Integer.parseInt(txt_Granularity.getText()
							.trim());
				} catch (Exception q) {
					q.printStackTrace();
					JOptionPane
							.showMessageDialog(null,
									"Error, Please input bot a cardinality and a granularity");
				}
				boolean primary_keys = chk_Primary.isSelected();

				String newExperiment = experimentTemplete;
				newExperiment.replace("$$EXPNAME$$", experiment_name);
				newExperiment.replace("$$SCENARIO$$", scenario_name);
				newExperiment.replace("$$GRANULARITY$$", String
						.valueOf(granularity));
				newExperiment.replace("$$MAXCARD$$", String
						.valueOf(cardinality * 2));
				newExperiment.replace("$$FILENAME$$", QueryFileName);
				newExperiment.replace("$$NUMQUERIES$$", String
						.valueOf(numQueries));

				String newDataDef = dataDefTemplete;
				newDataDef.replace("$$CARDINALITY$$", String
						.valueOf(cardinality));
				newDataDef.replace("$$PRIMARYKEY$$", String.valueOf(
						primary_keys).toLowerCase());

				/*
				 * 
				 * ExperimentID Number UserName VarChar NotebookName VarChar
				 * ExperimentName VarChar Scenario VarChar SourceFileName
				 * VarChar CreateDate VarChar SourceXML Clob
				 */
				try {
					int experimentID = LabShelfManager.getShelf()
							.getSequencialID(Constants.SEQUENCE_EXPERIMENT);
					LabShelfManager
							.getShelf()
							.putDocument(
									Constants.TABLE_PREFIX
											+ Constants.TABLE_EXPERIMENT,
									"SourceXML",
									new String[] { "ExperimentID", "UserName",
											"NotebookName", "ExperimentName",
											"Scenario", "SourceFileName",
											"CreateDate" },
									new String[] {
											String.valueOf(experimentID),
											strUserName,
											strNotebookName,
											txt_name.getText().trim(),
											txt_scenario.getText().trim(),
											"AutomaticallyGenerated",
											new SimpleDateFormat(
													Constants.TIMEFORMAT)
													.format(new Date(
															System
																	.currentTimeMillis())) },
									new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_DATE },
									newExperiment);

					int newDataDefID = LabShelfManager.getShelf()
							.getSequencialID(Constants.SEQUENCE_EXPERIMENTSPEC);
					/**
					 * 
					 * ExperimentSpecID Number Name VarChar Kind VarChar
					 * FileName VarChar SourceXML Clob
					 */

					LabShelfManager
							.getShelf()
							.putDocument(
									Constants.TABLE_PREFIX
											+ Constants.TABLE_EXPERIMENTSPEC,
									"SourceXML",
									new String[] { "ExperimentSpecID", "Name",
											"Kind", "FileName" },
									new String[] {
											String.valueOf(newDataDefID),
											"GeneratedDataDef_"
													+ new SimpleDateFormat(
															Constants.TIMEFORMAT)
															.format(new Date(
																	System
																			.currentTimeMillis())),
											"D", "Generated" },
									new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_VARCHAR,
											GeneralDBMS.I_DATA_TYPE_VARCHAR },
									newDataDef);

					int newQueryDefID = LabShelfManager.getShelf()
							.getSequencialID(Constants.SEQUENCE_EXPERIMENTSPEC);
					LabShelfManager.getShelf().putDocument(
							Constants.TABLE_PREFIX
									+ Constants.TABLE_EXPERIMENTSPEC,
							"SourceXML",
							new String[] { "ExperimentSpecID", "Name", "Kind",
									"FileName" },
							new String[] { String.valueOf(newQueryDefID),
									QueryFileName, "Q", QueryFileName },
							new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
									GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_VARCHAR },
							new FileInputStream(new File(QueryFileName)));

					/*
					 * ExperimentID Number Kind VarChar ExperimentSpecID Number
					 */
					LabShelfManager.getShelf().insertTupleToNotebook(
							Constants.TABLE_PREFIX
									+ Constants.TABLE_REFERSEXPERIMENTSPEC,
							new String[] { "ExperimentID", "Kind",
									"ExperimentSpecID" },
							new String[] { String.valueOf(experimentID), "D",
									String.valueOf(newDataDefID) },
							new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
									GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_NUMBER });

					LabShelfManager.getShelf().insertTupleToNotebook(
							Constants.TABLE_PREFIX
									+ Constants.TABLE_REFERSEXPERIMENTSPEC,
							new String[] { "ExperimentID", "Kind",
									"ExperimentSpecID" },
							new String[] { String.valueOf(experimentID), "Q",
									String.valueOf(newQueryDefID) },
							new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
									GeneralDBMS.I_DATA_TYPE_VARCHAR,
									GeneralDBMS.I_DATA_TYPE_NUMBER });
				} catch (Exception d) {
					d.printStackTrace();
					JOptionPane.showMessageDialog(null,
							"Failed to create Experiment");
				}
				// TODO now save everything
				// Generate this from a templete .xml file, possibly one
				// staticly defined here
				// TODO Auto-generated method stub
			}
		});
		this.add(btn_Go);

		JButton btn_Cancel = new JButton("Cancel");
		btn_Cancel.setBounds(315, 300, 100, 50);
		btn_Cancel.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				dispose();
			}
		});
		this.add(btn_Cancel);

		getContentPane().setLayout(null);
		this.setSize(700, 400);
		this.setLocation(100, 100);
		this.setTitle("Create an Experiment");

	}

	private boolean isValid(String filename) {
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			factory.setValidating(true);
			factory.setNamespaceAware(true);
			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);
			factory.setAttribute(Constants.JAXP_SCHEMA_LANGUAGE,
					Constants.W3C_XML_SCHEMA);
			factory.setAttribute(Constants.JAXP_SCHEMA_SOURCE,
					new FileInputStream(new File(
							Constants.CHOSEN_PREDEFINED_SCHEMA)));

			DocumentBuilder builder = factory.newDocumentBuilder();
			builder.setErrorHandler(new ExperimentErrorHandler());
			Document d = builder.parse(new FileInputStream(new File(filename)));

			Element myElem = d.getDocumentElement();
			numQueries = myElem.getElementsByTagName("query").getLength();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	private static final String experimentTemplete = "<experiment name=\"$$EXPNAME$$\" scenario=\"$$SCENARIO$$\">"
			+ "\n"
			+ "<description>"
			+ "\n"
			+ "The baseline test of onepass scenario, with 20 predefined queries."
			+ "\n"
			+ "Four experiment tables, each with 1M rows. One variable table is used."
			+ "\n"
			+ "</description>"
			+ "\n"
			+ "<dataDefinitionReference href=\"$$DATADEF$$\"/>"
			+ "\n"
			+ "<tableConfiguration>"
			+ "\n"
			+ "<variableTableSet searchMethod=\"linear\" searchGranularity=\"$$GRANULARITY$$\">"
			+ "\n"
			+ "<table name=\"HT1\" seed=\"1999\">"
			+ "\n"
			+ "<cardinality hypotheticalMinimum=\"$$GRANULARITY$$\" hypotheticalMaximum=\"$$MAXCARD$$\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "</variableTableSet>"
			+ "\n"
			+ "<fixedTableSet>"
			+ "\n"
			+ "<table name=\"HT2\" seed=\"2999\">"
			+ "\n"
			+ "<cardinality hypothetical=\"actual\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "<table name=\"HT3\" seed=\"3999\">"
			+ "\n"
			+ "<cardinality hypothetical=\"actual\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "<table name=\"HT4\" seed=\"4999\">"
			+ "\n"
			+ " <cardinality hypothetical=\"actual\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "</fixedTableSet>"
			+ "\n"
			+ "</tableConfiguration>"
			+ "\n"
			+ "<queryDefinitionReference numberQueries=\"$$NUMQUERIES$$\" type=\"predefinedQueries\" href=\"$$FILENAME$$\"/>"
			+ "\n" + "</experiment>" + "\n";

	private static final String dataDefTemplete = "<dataDefinition name=\"ft\">"
			+ "\n"
			+ "<documentation>"
			+ "\n"
			+ "A database that has tables with cardinalities that are a power of 10.  From 1 to "
			+ "\n"
			+ "$$CARDINALITY$$.  There are only numeric column data in these tables."
			+ "\n"
			+ "</documentation>"
			+ "\n"
			+ "<table name=\"HT1\" cardinality=\"$$CARDINALITY$$\">"
			+ "\n"
			+ "<column name=\"id1\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"sequential\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"$$PRIMARYKEY$$\"/>"
			+ "\n"
			+ "<column name=\"id2\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id3\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id4\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "<table name=\"HT2\" cardinality=\"$$CARDINALITY$$\">"
			+ "\n"
			+ "<column name=\"id1\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"sequential\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"$$PRIMARYKEY$$\"/>"
			+ "\n"
			+ "<column name=\"id2\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id3\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id4\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "<table name=\"HT3\" cardinality=\"$$CARDINALITY$$\">"
			+ "\n"
			+ "<column name=\"id1\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"sequential\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"$$PRIMARYKEY$$\"/>"
			+ "\n"
			+ "<column name=\"id2\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id3\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id4\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "</table>"
			+ "\n"
			+ "<table name=\"HT4\" cardinality=\"$$CARDINALITY$$\">"
			+ "\n"
			+ "<column name=\"id1\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"sequential\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"$$PRIMARYKEY$$\"/>"
			+ "\n"
			+ "<column name=\"id2\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id3\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n"
			+ "<column name=\"id4\" dataType=\"number\" dataLength=\"20\" dataGenerationType=\"random\" distributionMinimum=\"0\" distributionMaximum=\"$$CARDINALITY$$\" inPrimaryKey=\"false\"/>"
			+ "\n" + "</table>" + "\n" + "</dataDefinition>" + "\n";

}
