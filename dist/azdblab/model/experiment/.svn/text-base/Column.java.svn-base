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
package azdblab.model.experiment;

/**Store information about a database table's column.  This information
 * is found in the internal data dictionaries and used to set the column stats
 * for a table's columns.
 * @author Kevan Holdaway
 *
 */
public class Column {
	/**
	 * The name of the column
	 * @param name
	 */
	public Column(String name) {
		myName = name;
	}
	/**
	 * The average column length
	 */
	public long myAverageColumnLen;
	/**
	 * The number of distinct tuples in the column
	 */
	public long myDistinctCount;

	/**
	 * The name of the column.
	 */
	public String myName;
}
