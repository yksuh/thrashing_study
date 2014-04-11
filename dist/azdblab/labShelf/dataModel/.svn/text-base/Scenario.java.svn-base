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
package azdblab.labShelf.dataModel;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.TableDefinition;

public class Scenario extends TableDefinition {

	String userName;
	String notebookName;
	String scenarioName;
	
	public Scenario(String userName, String notebookName, String scenarioName) {
		this.userName = userName;
		this.notebookName = notebookName;
		this.scenarioName = scenarioName;
	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @return
	 */
	public boolean experimentExists(String experimentName) {
		boolean result;
		String[] selectColumns = new String[] { "UserName", "NotebookName",
				"ExperimentName", "Scenario" };
		String[] columnNames = new String[] { "UserName", "NotebookName",
				"ExperimentName", "Scenario" };
		String[] columnValues = new String[] { userName, notebookName,
				experimentName, scenarioName };
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR };

		// Queries for the desired test and checks to see that one tuple is
		// returned.
		ResultSet rs = LabShelfManager.getShelf().executeSimpleQuery(
				EXPERIMENT.TableName, selectColumns, columnNames, columnValues,
				dataTypes);

		try {
			result = rs.next();

			rs.close();

		} catch (SQLException e) {
			result = false;
		}
		return result;
	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 */
	public void deleteExperiment(String experimentName) {
		String[] columnNames = new String[] { "UserName", "NotebookName", "ExperimentName", "Scenario" };
		String[] columnValues = new String[] { userName, notebookName, experimentName, scenarioName };
		int[] columnDataTypes = new int[] { 
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_VARCHAR
				};

		LabShelfManager.getShelf().deleteRows(EXPERIMENT.TableName, columnNames, columnValues, columnDataTypes);
		LabShelfManager.getShelf().commitlabshelf();
		
	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param sourceFileName
	 * @param createDate
	 * @param xml_source
	 */
	public void insertExperiment(String experimentName, String sourceFileName, String createDate, FileInputStream xml_source) {
			
			int		experimentID	= LabShelfManager.getShelf().getSequencialID("SEQ_EXPERIMENTID");
			
			String clobColumnName = "SourceXML";
			String[] columns = new String[] { "ExperimentID", "UserName", "NotebookName", "ExperimentName", "Scenario", "SourceFileName", "CreateDate" };
			String[] columnValues = new String[] { String.valueOf(experimentID), userName, notebookName, experimentName, scenarioName, sourceFileName, createDate };
			int[] dataTypes = new int[] { 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE
					};
			
			//Upload the experiment into the DBMS.
			LabShelfManager.getShelf().putDocument(EXPERIMENT.TableName, clobColumnName, columns, columnValues, dataTypes, xml_source);
			LabShelfManager.getShelf().commitlabshelf();
			
	}
}
