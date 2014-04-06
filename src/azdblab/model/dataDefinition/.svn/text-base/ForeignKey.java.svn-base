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
package azdblab.model.dataDefinition;

/**
 * Stores information about a foreign key in the DBMS.  These objects are used when creating tables.  They allow
 * the user to specify referential integrity constraints.
 * @author Kevan Holdaway
 *
 */
public class ForeignKey {
	/**
	 * Creates a Foreign Key object
	 * @param columns The columns of the table that have referential integrity for this foreign key.
	 * @param tableReferenced The foreign table that is referenced.
	 * @param columnsReferenced The foreign table's columns that are referenced.
	 */
	public ForeignKey(String[] columns, String tableReferenced, String[] columnsReferenced, String cascadeOption) {
		this.columns 			= columns;
		this.columnsReferenced 	= columnsReferenced;
		this.tableReferenced 	= tableReferenced;
		this.strCascadeOption	= cascadeOption;
	}

	/**
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object o) {
		if (!(o instanceof ForeignKey))
			return false;
		ForeignKey other = (ForeignKey) o;

		if (!other.tableReferenced.equals(tableReferenced))
			return false;
		if (other.columns.length != this.columns.length)
			return false;
		if (other.columnsReferenced.length != this.columnsReferenced.length)
			return false;
		for (int i = 0; i < columns.length; i++)
			if (!columns[i].equals(other.columns[i]))
				return false;

		for (int i = 0; i < columnsReferenced.length; i++)
			if (!columnsReferenced[i].equals(other.columnsReferenced[i]))
				return false;
		
		if (!strCascadeOption.equals(other.strCascadeOption)) {
			return false;
		}
		
		return true;
	}
	/**
	 * The columns in this foreign key
	 */
	public String[]		columns;

	/**
	 * The columns that are referenced in the foreign table.
	 */
	public String[]		columnsReferenced;
	/**
	 * The table that is referenced.
	 */
	public String		tableReferenced;
	
	public String		strCascadeOption;

}
