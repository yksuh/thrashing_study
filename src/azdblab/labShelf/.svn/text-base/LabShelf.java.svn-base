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
package azdblab.labShelf;

import java.io.FileInputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

import azdblab.exception.dbms.DBMSInvalidConnectionParameterException;


public interface LabShelf {
	
		/**
		 * Puts a document into the DBMS.  Anytype of File can be uploaded to the DBMS.  There should
		 * be no limit on the size of the document.
		 * @param tableName The name of the table that will contain the document.
		 * @param documentColumnName The name of the column that holds the document.
		 * @param columnNames The name of column used to determine if the document already exists.
		 * @param columnValues The values of the column used to determine if the document already exists.
		 * @param columnDataTypes The data types of the above columns.
		 * @param document A FileInputStream to the document.  This is used to read the file and upload it 
		 * into the DBMS.
		 */
		public int putDocument(
			String tableName,
			String documentColumnName,
			String[] columnNames,
			String[] columnValues,
			int[] columnDataTypes,
			FileInputStream document);
		
		
		public int putDocument(
				String tableName,
				String documentColumnName,
				String[] columnNames,
				String[] columnValues,
				int[] columnDataTypes,
				String content);
	
	
		/**
		 * Used to replace an existing document.  The old document is deleted and the document is uploaded again.  
		 * The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
		 * The columnDataTypes[i] is used to add other syntax need for a specific data type.
		 * @param tableName The name of the table that contains the document.
		 * @param documentColumnName The column that contains the document.
		 * @param columnNames The names of the columns used to identify the correct document.
		 * @param columnValues The values of the columns used to identify the correct document.
		 * @param columnDataTypes The data types of the columns.
		 * @param document The document that is to replace the existing document.
		 */
		public void updateDocument(
				String tableName,
				String documentColumnName,
				String[] columnNames,
				String[] columnValues,
				int[] columnDataTypes,
				FileInputStream document);
		
	
		/**
		 * Retrieves a document from the DBMS. The content of the document is understood only by the user.  
		 * The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
		 * The columnDataTypes[i] is used to add other syntax need for a specific data type.
		 * @param tableName The name of the table that contains the document
		 * @param documentColumnName The name of the column that contains the document.
		 * @param columnNames The name of the columns that will be used in the WHERE clause to identify the document that the 
		 * user wishes to retrieve.
		 * @param columnValues The values of the columns that will be used in the WHERE clause to identify the document that the 
		 * user wishes to retrieve.
		 * @param columnDataTypes The data types for each of these columns.
		 * @return An input stream to the document.  This input stream can be used to read the contents of the 
		 * document.
		 */
		public FileInputStream getDocument(
			String tableName,
			String documentColumnName,
			String[] columnNames,
			String[] columnValues,
			int[] columnDataTypes);
		 
		 /**
		  * Removes tuples from table tableName.  The columnName, columnValues, and columnDataTypes are used to 
		  * restrict which tuples are deleted.  They are used to build the WHERE clause of the delete SQL statement.  The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
		  * The columnDataTypes[i] is used to add other syntax need for a specific data type.  The parameter
		  * arrays passed in should be the same length.  If they have different lengths AZDBLab will print a message
		  * and exit.
		  * 
		  * @param tableName The name of the table whose rows will be deleted.
		  * @param columnNames The name of the columns that are used to determine which rows will be deleted.
		  * @param columnValues The values of the columns that are used to determine which rows will be deleted.
		  * @param columnDataTypes The data types of the above columns.
		  */
		public void deleteRows(String tableName, String[] columnNames, String[] columnValues, int[] columnDataTypes);
		
		
		/**
		 * Using the parameters this method builds an SQL query.  Each column in this array will be inside of the select clause.  The from clause simply contains
		 * the tableName.  The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
		 * The columnDataTypes[i] is used to add other syntax need for a specific data type.
		 * @param tableName
		 * @param selectColumns
		 * @param columnNames
		 * @param columnValues
		 * @param columnDataTypes
		 * @return The JDBC Result that corresponds to this query.
		 */
		public ResultSet executeSimpleQuery(
			String tableName,
			String[] selectColumns,
			String[] columnNames,
			String[] columnValues,
			int[] columnDataTypes);
		
		
		/**
		 * The can be used to execute a simple select-project query.  The select clause is build using the selectColumns
		 * parameter.  Each column in this array will be inside of the select clause.  The from clause simply contains
		 * the tableName.  The where clause is built as follows.  For each index i, columnNames[i]=columnValues[i]. 
		 * The columnDataTypes[i] is used to add other syntax need for a specific data type.
		 * @param tableName The name of the table that will appear in the from clause.
		 * @param selectColumns The name of the columns that will be in the select clause.
		 * @param indexOfOrderedColumn The index column you wish to have the results ordered by.  For example, if you wish 
		 * to have the result ordered by column 1 in the select clause, then you would use the number 1 here.
		 * @param orderedDataType The data type of the column that is used to determine the order of the output result.
		 * @param columnNames The names of the columns used in the where clause.
		 * @param columnValues The values of the columns used in the where clause.
		 * @param columnDataTypes The data types of the columns.
		 * @return A result set which is the result of executing the query.
		 */		
		public ResultSet executeSimpleOrderedQuery(
			String tableName,
			String[] selectColumns,
			int indexOfOrderedColumn,
			int orderedDataType,
			String[] columnNames,
			String[] columnValues,
			int[] columnDataTypes);
		
		
		public void insertTupleToNotebook(
			String tableName, 
			String[] columnNames, 
			String[] columnValues, 
			int[] columnDataTypes)
		throws SQLException; 
		
		
		
		public void closelabshelf();

		
		/**
		 * Commits all update operations made to the dbms.  This must be called for inserts statements to be seen.
		 */
		public void commitlabshelf();
		
		
		/**
		 * Opens the connection to the DBMS.
		 * @throws DBMSInvalidConnectionParameterException
		 */
		public void openlabshelf() throws DBMSInvalidConnectionParameterException;
		
		
		public ResultSet executeQuerySQL(String sql);
		
		public void executeUpdateSQL(String sql);
				
		public void exportResultData(String expFacilityPath, String resultFile);
		
		public void importResultData(String impFacilityPath, String inputFile);
		
}
