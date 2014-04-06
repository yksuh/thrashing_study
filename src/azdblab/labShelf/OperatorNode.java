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

import java.util.Vector;

public class OperatorNode extends PlanNode {

	private String				strOperatorName;
	
	private Vector<PlanNode>	vecChildNodes;
	
	/**
	 * The constructor specifies the basic <code>OperatorNode</code> information.
	 * This constructor is only used when timing the query, for query plans comparison and verification purpose only.
	 * @param node_id ID of the node
	 * @param parent_id ID of the parent of current node
	 * @param node_order the position of node in pre-order traversal
	 * @param name the operator name of the node
	 * @param info extra information
	 */
	public OperatorNode(int node_id,
			int parent_id,
			int node_order,
			String name, 
			String info) {
		
		super(node_id, parent_id, node_order, name, info);
		
		setOperator(name);
		
		vecChildNodes	= new Vector<PlanNode>();
		
	}
	
	/**
	 * The constructor specifies the basic <code>OperatorNode</code> information
	 * @param node_id ID of the node
	 * @param parent_id ID of the parent of current node
	 * @param node_order the position of node in pre-order traversal
	 * @param name the name of the <code>OperatorNode</code>. either a table name or a operator name.
	 * @param columnNames the properties of the <code>OperatorNode</code>.
	 * @param columnValues the values of the properties of the <code>OperatorNode</code>.
	 */
	public OperatorNode(String node_id,
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
		
		setOperator(name);
		
		vecChildNodes	= new Vector<PlanNode>();
		
	}
	
	/**
	 * Provides the name of the operator that will be displayed on the graph when the node is drawn by the 
	 * result browser.
	 * @return The operator name.
	 */
	public String getOperatorName() {
		return strOperatorName;
	}
	
	/**
	 * Sets the operator of the node.
	 * @param operator The name of the operator.
	 */
	public void setOperator(String operator) {
		strOperatorName	= operator;
		setPropertyValue("OPERATION", operator);
	}
	
	/**
	 * Sets the child node for current <code>OperatorNode</code>.
	 * @param pos To which position should the child node be added.
	 * @param childnode The child node to be added.
	 */
	public void setChild(int pos, PlanNode childnode) {
		vecChildNodes.add(pos, childnode);
		childnode.parentNode	= this;
	}
	
	/**
	 * Retrieves the child node at specified position.
	 * @param pos The position of the child <code>OperatorNode</code> to be retrieved under current node.
	 * @return The child node at position specified by pos.
	 */
	public PlanNode getChild(int pos) {
		return (PlanNode)vecChildNodes.get(pos);
	}
	
	
	public int getChildNumber() {
		if (vecChildNodes != null)
			return vecChildNodes.size();
		else 
			return -1;
	}	
	
}
