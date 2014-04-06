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

import azdblab.model.dataDefinition.ForeignKey;

/**
 * This information store information about a data base table.
 * @author Kevan Holdaway
 *
 */
public class Table {
	/**
	 * Creates a table object
	 * @param name The name of the table
	 * @param prefix
	 * @param aCard The actual cardinality of the table.
	 * @param minCard The minimum cardinality for the search
	 * @param maxCard The maximum cardinality for the search.
	 * @param cols The columns for this table.
	 */
	public Table(String name, String prefix, long aCard, long minCard, long maxCard, long seed, Column[] cols) {
		table_name_with_prefix = prefix+name;
		table_name = name;
		actual_card = aCard;
		hy_min_card = minCard;
		hy_max_card = maxCard;
		table_seed	= seed;
		columns = cols;
		table_prefix = prefix;
	}
	
	public Table(Table newTable) {
		table_name_with_prefix 	= newTable.table_name_with_prefix;
		table_name 				= newTable.table_name;
		actual_card 			= newTable.actual_card;
		hy_min_card 			= newTable.hy_min_card;
		hy_max_card 			= newTable.hy_max_card;
		table_seed				= newTable.table_seed;
		columns 				= newTable.columns;
	}

	
	/**
	 * Creates a table object
	 * @param name The name of the table
	 * @param name_prefix The name of the table with the unique prefix that AZDBLab assigned to it.  The real name of
	 * the table in the database.
	 * @param aCard The actual cardinality of the table.
	 * @param minCard The minimum cardinality for the search
	 * @param maxCard The maximum cardinality for the search.
	 * @param cols The columns for this table.
	 */
	public Table(String name, 
				 String name_prefix, 
				 String[] columns,
				 int[] columnDTypes,
				 int[] columnDTypeLengths,
				 String[] primary,
				 ForeignKey[] foreign,
				 String[] sOns,
				 String[] hIdxes,
				 String[] btIdxes,
				 String[] uqs
				) {
		table_name = name;
		table_name_with_prefix = name_prefix+name;
		columnNames = columns;
		columnDataTypes = columnDTypes;
		columnDataTypeLengths = columnDTypeLengths;
		primaryKeys = primary;
		foreignKeys = foreign;
		sortedOns = sOns;
		hashIndexColumns = hIdxes;
		btreeIndexColumns = btIdxes;
		uniqueColumns = uqs;
		table_prefix = name_prefix;
	}
	
	private String[] columnNames;			// a list of columns
	private int[] columnDataTypes;			// a list of column data types
	private int[] columnDataTypeLengths;	// a list of column data lengths
	private String[] primaryKeys;			// a list of primary keys
	private ForeignKey[] foreignKeys;		// a list of foreign keys
	private String[] sortedOns;				// a list of columns on which the table should be sorted
	private String[] hashIndexColumns;		// a list of columns having hash indexes
	private String[] btreeIndexColumns;		// a list of columns having btree indexes
	private String[] uniqueColumns;			// a list of columns having unique constraints
	
	/**
	 * @return the columnNames
	 */
	public String[] getColumnNames() {
		return columnNames;
	}

	/**
	 * @return the columnDataTypes
	 */
	public int[] getColumnDataTypes() {
		return columnDataTypes;
	}

	/**
	 * @return the columnDataTypeLengths
	 */
	public int[] getColumnDataTypeLengths() {
		return columnDataTypeLengths;
	}

	/**
	 * @return the primaryKeys
	 */
	public String[] getPrimaryKeys() {
		return primaryKeys;
	}

	/**
	 * @return the foreignKeys
	 */
	public ForeignKey[] getForeignKeys() {
		return foreignKeys;
	}

	/**
	 * @return the sortedOns
	 */
	public String[] getSortedOns() {
		return sortedOns;
	}

	/**
	 * @return the hashIndexes
	 */
	public String[] getHashIndexColumns() {
		return hashIndexColumns;
	}

	/**
	 * @return the btreeIndexes
	 */
	public String[] getBtreeIndexColumns() {
		return btreeIndexColumns;
	}

	/**
	 * @return the uniques
	 */
	public String[] getUniqueColumns() {
		return uniqueColumns;
	}

	/**
	 * @return the table_name
	 */
	public String getTable_name() {
		return table_name;
	}

	/**
	 * @return the table_name_with_prefix
	 */
	public String getTable_name_with_prefix() {
		return table_name_with_prefix;
	}
	
	public Column[] getColumns(){
		return columns;
	}
	
	/**
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object o) {
		if (!(o instanceof Table))
			return false;
		Table other = (Table) o;

		return other.table_name.equals(table_name)
			&& other.hy_max_card == hy_max_card
			&& other.hy_min_card == hy_min_card;
	}
	
	/**
	 * Sets the seed of the table.
	 * @param seed the seed of the table.
	 */
	public void setTableSeed(long seed) {
		table_seed	= seed;
	}
	
	/**
	 * Retrieves the seed of the table.
	 * @return the seed of the table.
	 */
	public long getTableSeed() {
		return table_seed;
	}
	
	/**
	 * The seed for generating random records for this table.
	 */
	private long table_seed;
	
	/**
	 * The actual cardinality of the table.
	 */
	public long actual_card;
	/**
	 *The columns of teh table.
	 */
	//		public long avg_row_len;
	//		public long num_blks;
	public Column[] columns;
	/**
	 *The maximum cardinality for the search space.
	 */
	public long hy_max_card;
	/**
	 * The minimum cardinality for the search space.
	 */
	public long hy_min_card;
	/**
	 * The name of the table.
	 */
	public String table_name;

	/**
	 * The name of the table with the unique prefix assigned by AZDBLab.  This is the real name
	 * of the table in the database.
	 */
	public String table_name_with_prefix;
	
	/**
	 * Prefix
	 */
	public String table_prefix;
}
