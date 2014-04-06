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

public class TableNode extends PlanNode {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String		strTableName;
	
	/**
	  * The constructor specifies the basic <code>TableNode</code> information.
	 * This constructor is only used when timing the query, for query plans comparison and verification purpose only.
	 * @param node_id ID of the node
	 * @param parent_id ID of the parent of current node
	 * @param node_order the position of node in pre-order traversal
	 * @param name the table name of the node
	 * @param info extra information
	 */
	public TableNode(int node_id,
			int parent_id,
			int node_order,
			String name, 
			String info) {
		
		super(node_id, parent_id, node_order, name, info);
		
		setTableName(name);
	}
	
	/**
	 * The constructor specifies the basic <code>TableNode</code> information
	 * @param node_id ID of the node
	 * @param parent_id ID of the parent of current node
	 * @param node_order the position of node in pre-order traversal
	 * @param name the name of the <code>TableNode</code>. either a table name or a operator name.
	 * @param columnNames the properties of the <code>TableNode</code>.
	 * @param columnValues the values of the properties of the <code>TableNode</code>.
	 */
	public TableNode(String node_id,
			String parent_id,
			String node_order,
			String name,
			String[] columnNames,
			String[] columnValues) {
		
		super(node_id,
				parent_id,
				node_order,
				name,
				columnNames,
				columnValues);
		setTableName(name);
	}
	
	/**
	 * Sets the name of the table if current node represents a table.
	 * @param tableName The name of the table.
	 */
	public void setTableName(String tableName) {
		strTableName	= tableName;
		setPropertyValue("OBJECT_NAME", tableName);
	}
	
	/**
	 * Retrieves the name of the table, if current node represents a table.
	 * @return The name of the table represented by current <code>TableNode.</code>
	 */
	public String getTableName() {
		return strTableName;
	}

}