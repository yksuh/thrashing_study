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
package azdblab.model.dataGenerator;

import java.io.IOException;

import azdblab.exception.analysis.ColumnAttributeException;
import azdblab.exception.analysis.DataDefinitionValidationException;
import azdblab.exception.analysis.NameResolutionException;
import azdblab.executable.Main;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.plugins.experimentSubject.ExperimentSubject;

/**
 * This data generator is used to create tables and fill them with values for the tables in experiments.
 * @author Kevan Holdaway
 *
 */
public class DefaultDataGenerator extends DataGenerator {
	/**
	 * The data generator used the InternalDatabaseControllerAPI to record events in AZDBLab's internal tables.  It
	 * uses the data definition to know what and how to create tables.
	 * @param dbController Used to access AZDBLab's internal tables.
	 * @param dataDef Used to understand how to create and populate the tables.
	 */
	public DefaultDataGenerator(ExperimentSubject expSubject, DataDefinition dataDef) {
		
		//myDBController	= dbcontroller;
		
		myExpSubject	= expSubject;
		
		myDataDef		= dataDef;
		
		myTables		= myDataDef.getTables();
		myPrefix		= myDataDef.getDataDefName() + "_";
	}

//	public String[] getTables(){
//		String[] tables = new String[myTables.length];
//		for (int i = 0; i < myTables.length; i++) {
//			tables[i] = myPrefix + myTables[myTables.length - i - 1];
//		}
//		return tables;
//	}
	/**
	 * Given a table, create a column value generator for each column.
	 * @param table The name of the table that need column value generators.
	 * @return An array of ColumnValueGenerators that can be used to populate the data base tables according
	 * to the data definition.
	 * @throws ColumnAttributeException If a ColumnValueGenerator of this type cannot be created as defined by
	 * the data definition.
	 *//*
	private ColumnValueGenerator[] createColumnValueGenerators(String table) throws ColumnAttributeException {
		String columns[] = myDataDef.getTableColumns(table);
		ColumnValueGenerator columnGens[] = new ColumnValueGenerator[columns.length];
		//create a ColumnValueGenerator for each column
		for (int j = 0; j < columns.length; j++) {
			int data_type = myDataDef.getColumnDataType(table, columns[j]);
			int data_gen_type = myDataDef.getColumnDataGenType(table, columns[j]);
			long min_val = myDataDef.getColumnMinValue(table, columns[j]);
			long max_val = myDataDef.getColumnMaxValue(table, columns[j]);
			int data_length = myDataDef.getColumnDataLength(table, columns[j]);
			try {
				columnGens[j] = new ColumnValueGenerator(data_type, data_length, data_gen_type, min_val, max_val);
			} catch (ColumnAttributeException e) {
				throw new ColumnAttributeException(
					"Data Definition Error for '"
						+ myDataDef.getDataDefName()
						+ "' (Table='"
						+ table
						+ "', Column='"
						+ columns[j]
						+ "'): "
						+ e.getMessage());
			}
		}
		return columnGens;
	}
	*/

	/**
	 * Creates all the tables in the data definition. (Create the Experimental Tables)
	 */
	public void createTables() 
				throws IOException, DataDefinitionValidationException, NameResolutionException, ColumnAttributeException {

		// Uninstall the old experiment tables belonging to the same experiment (If exist)
		for (int i = 0; i < myTables.length; i++) {
			boolean flag = myExpSubject.tableExists(myPrefix + myTables[myTables.length - i - 1]);
			if (flag) {
				Main._logger.outputLog(myPrefix + myTables[myTables.length - i - 1] + " exists!!!");
				myExpSubject.dropTable(myPrefix + myTables[myTables.length - i - 1]);
			}
		}
		
		myExpSubject.installExperimentTables(myDataDef, myPrefix);
		
		//myDBController.insertDataDefinition(myDataDef.getName(), myDataDef.getXMLFile());
		
	}

	/**
	 * @see azdblab.model.dataGenerator.DataGenerator#depopulate()
	 */
	public void deleteTables() {
		
		for (int i = 0; i < myTables.length; i++) {
			if (myExpSubject.tableExists(myPrefix + myTables[myTables.length - i - 1])) {
				myExpSubject.dropTable(myPrefix + myTables[myTables.length - i - 1]);
			}
			
			if (myExpSubject.tableExists("clone_max_" + myPrefix + myTables[myTables.length - i - 1])) {
				myExpSubject.dropTable("clone_max_" + myPrefix + myTables[myTables.length - i - 1]);
			}
		}
		
		myExpSubject.deleteHelperTables();
		
		//myDBController.deleteDataDefinition(myDataDef.getName());

	}
	
	/**
	 * @see azdblab.model.dataGenerator.DataGenerator#errorCheck()
	 */
	public void errorCheck() throws ColumnAttributeException {
		for (int i = 0; i < myTables.length; i++) {
			//ColumnValueGenerator columnGens[] = createColumnValueGenerators(myTables[i]);
		}

	}

	
	/**
	 * @throws ColumnAttributeException
	 *
	private void populateTables() throws ColumnAttributeException {

		//for each table in this test insert rows into it
		for (int i = 0; i < myTables.length; i++) {
			String columns[] = myDataDef.getTableColumns(myTables[i]);
			int[] columnDataTypes = new int[columns.length];
			//get the next value of each column
			for (int j = 0; j < columns.length; j++)
				columnDataTypes[j] = myDataDef.getColumnDataType(myTables[i], columns[j]);

			long cardinality = myDataDef.getTableCardinality(myTables[i]);
			ColumnValueGenerator columnGens[] = createColumnValueGenerators(myTables[i]);
			//inserting the specified number of tuples into table
			if (Main.verbose)
				Main._logger.outputLog("Begin Inserting into  " + myPrefix + myTables[i]);

			for (long k = 0; k < cardinality; k++) {
				if (Main.verbose)
					if (k % 10000 == 0)
						Main._logger.outputLog("Inserted " + k + " rows into " + myPrefix + myTables[i]);

				String[] columnValues = new String[columns.length];
				for (int j = 0; j < columns.length; j++) {
					columnValues[j] = columnGens[j].getRandomValue();
				}
				try {
					myExpSubject.insertTuple(myPrefix + myTables[i], columns, columnValues, columnDataTypes);
				} catch (SQLException e) {
					//RANORMAL may want to retry later
				}
			}
			if (Main.verbose)
				Main._logger.outputLog("Finished Inserting into  " + myPrefix + myTables[i]);

		}
	}
	 */
	
	/**
	 * Checks to see that the data definition tables are all installed.
	 * @return true - if all tables of the data definition are installed.
	 * @throws FileNotFoundException If the data definition file cannot be opened.
	 * @throws IOException If there is a problem writing to a file.
	 * @throws DataDefinitionValidationException If there is a validation error on the data 
	 * definition file.
	 * @throws NameResolutionException If there is a name resolution problem.
	 *
	private boolean tablesInstalled()
		throws FileNotFoundException, IOException, DataDefinitionValidationException, NameResolutionException {
		//dataDefinitionInstalled returns true the two XML files represent the same data
		if (!myDBController.dataDefinitionExists(myDataDef.getName()))
			return false;
		for (int i = 0; i < myTables.length; i++) {
			if (!myExpSubject.tableExists(myPrefix + myTables[i]))
			//if (!myExpSubject.tableExists(myPrefix + myTables[i]))
				return false;
		}

		//dataDefinitionInstalled returns true the two XML files represent the same data
		if (!myDataDef.equals(myDBController.getDataDefinitionModule(myDataDef.getName())))
			return false;
		return true;
	}
	*/
	
	/**
	 * The data definition
	 */
	private DataDefinition 				myDataDef;

	/**
	 * The prefix that is used to avoid table name collisions among different tests.
	 */
	private String 						myPrefix;
	/**
	 * The names of the tables for this data definition.
	 */
	private String[] 					myTables;
	
	/**
	 * Used to insert rows into the experiment database tables.
	 */
	private ExperimentSubject			myExpSubject;
		
	//private LabShelf	myDBController;
	
}
