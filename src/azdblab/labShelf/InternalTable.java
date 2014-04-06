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

import azdblab.Constants;
import azdblab.model.dataDefinition.ForeignKey;

/**
 * This internal class is a data structure used to store information about the internal tables.  It is a simple
 * wrapper for an internal table.  The information is extracted to create the real internal tables 
 * inside the DBMS.  All the information contained in this class can be used to create a real instance of 
 * this table in the DBMS.
 * 
 */
public class InternalTable {


	/**
	 * Creates an InternalTable Object.  The information here is used to create a DBMS table.
	 * @param TableName The name of the table to be created.
	 * @param columns The names of the columns.
	 * @param columnDataTypes The data types of the columns.  Uses the MetaData found in AZDBLAB.java.
	 * @param columnDataTypeLengths The lengths of the data types for each column above.
	 * @param primaryKey The names of the columns in the primary key.
	 * @param foreignKey An array of Foreign keys for this table.
	 */
	public InternalTable(	String 			TableName,
							String[] 		columns,
							int[] 			columnDataTypes,
							int[] 			columnDataTypeLengths,
							int[]			columnNullable,
							String[]		uniqueConstraintColumns,
							String[] 		primaryKey,
							ForeignKey[] 	foreignKey,
							String			sequence) {
		
		this.TableName 					= TableName;
		this.columns 					= columns;
		this.columnDataTypes 			= columnDataTypes;
		this.columnDataTypeLengths 		= columnDataTypeLengths;
		this.columnNullable 			= columnNullable;
		this.uniqueConstraintColumns	= uniqueConstraintColumns;
		this.primaryKey 				= primaryKey;
		this.foreignKey 				= foreignKey;
		this.strSequenceName			= sequence;
	}
	
	/**
	 * The data type lengths for the columns of the tables.
	 */
	public int[] columnDataTypeLengths;
	
	/**
	 * The data types of each column.
	 * @see Constants
	 */
	public int[] columnDataTypes;
	
	public int[] columnNullable;
	
	/**
	 * The names of each column
	 */
	public String[] columns;
	
	
	public String[] uniqueConstraintColumns;
	/**
	 * The foreign keys for the table
	 * @see ForeignKey
	 */
	public ForeignKey[] foreignKey;
	
	/**
	 * The name of the columns in the primary key.
	 */
	public String[] primaryKey;
	
	/**
	 * The name of the table.
	 */
	public String TableName;
	
	
	public String strSequenceName;
	
	public String toString() {
		return TableName;
	}

	public String getStringRepresentation() {
		String toRet = "";
		for (int i = 0; i < columns.length; i++) {
			toRet += columns[i] + "\t";
			int val = columnDataTypes[i];
			if (val == GeneralDBMS.I_DATA_TYPE_NUMBER) {
				toRet += "Number";
			} else if (val == GeneralDBMS.I_DATA_TYPE_VARCHAR) {
				toRet += "VarChar";
			} else if (val == GeneralDBMS.I_DATA_TYPE_CLOB) {
				toRet += "Clob";
			} else if (val == GeneralDBMS.I_DATA_TYPE_DATE) {
				toRet += "Date";
			} else if (val == GeneralDBMS.I_DATA_TYPE_TIMESTAMP) {
				toRet += "Timestamp";
			}
			toRet += "\n";
		}
		if (primaryKey != null) {
			toRet += "Primary Key(s): ";
			for (int i = 0; i < primaryKey.length; i++) {
				toRet += primaryKey[i];
				if (i != primaryKey.length - 1) {
					toRet += ", ";
				}
			}
			toRet += "\n";
		}
		if (uniqueConstraintColumns != null) {
			toRet += "Unique Constraint(s): ";
			for (int i = 0; i < uniqueConstraintColumns.length; i++) {
				toRet += uniqueConstraintColumns[i];
				if (i != uniqueConstraintColumns.length - 1) {
					toRet += ", ";
				}
			}
			toRet += "\n";
		}
		if(foreignKey != null){
			toRet += "Foreign Key(s):\n";
			for(int i = 0; i < foreignKey.length; i++){
				String tmp[] = foreignKey[i].columns;
				for(int j = 0; j < tmp.length; j++){
					toRet += tmp[j];
					if (j != tmp.length - 1) {
						toRet += ", ";
					}
				}
				toRet += "  From:" + foreignKey[i].tableReferenced + "\n";
			}
		}
		return toRet;
	}
	
}