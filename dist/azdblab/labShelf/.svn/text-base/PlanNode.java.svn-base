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

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.HashMap;

/**
 * <p>
 * The PlanNode abstract class is a DBMS Independent representation of a node in
 * the DBMS Query plan. The DBMS independent PlanNode is only required to
 * contain enough information to display the node in the result browser.
 * </p>
 * <p>
 * The DBMS specific implemenations of this should contains all information
 * necessary compare the PlanNodes to to each other. Each node is used by
 * AZDBLab to determine whether two query plans are equals. As a query plan or
 * query plan tree is made up of many PlanNodes, the equality of the tree will
 * be determined based on the equality of each node. The intent of AZDBLab is to
 * identify when query plan changes, thus, the PlanNode should have enough
 * detail to identify critical changes to the overall query plan.
 * </p>
 */
public abstract class PlanNode implements Serializable {
	public static final long serialVersionUID = 123456;
	protected String[] strColumnNames;
	protected String[] strColumnValues;
	protected PlanNode parentNode;
	protected int iNodeID;
	protected int iParentID;
	protected int iPosition;
	protected HashMap<String, Integer> mapOperators;
	protected HashMap<String, Double> mapOpCostEstimates;

	protected int numOfOperators;

	/**
	 * The constructor specifies the basic <code>PlanNode</code> information.
	 * This constructor is only used when timing the query, for query plans
	 * comparison and verification purpose only.
	 * 
	 * @param node_id
	 *            ID of the node
	 * @param parent_id
	 *            ID of the parent of current node
	 * @param node_order
	 *            the position of node in pre-order traversal
	 * @param name
	 *            the name of the node
	 * @param info
	 *            extra information
	 */
	public PlanNode(int nodeID, int parentID, int position, String name,
			String info) {
		iNodeID = nodeID;
		iParentID = parentID;
		iPosition = position;
		strColumnNames = new String[5];
		strColumnValues = new String[5];
		strColumnNames[0] = "ID";
		strColumnNames[1] = "PARENT_ID";
		strColumnNames[2] = "POSITION";
		strColumnNames[3] = "OBJECT_NAME"; // TO BE DEFINED BY TABLE/OPERATOR
											// NODE
		strColumnNames[4] = "INFO";
		strColumnValues[0] = String.valueOf(nodeID);
		strColumnValues[1] = String.valueOf(parentID);
		strColumnValues[2] = String.valueOf(position);
		strColumnValues[3] = name;
		strColumnValues[4] = info;
	}

	/**
	 * The constructor specifies the basic <code>PlanNode</code> information
	 * 
	 * @param node_id
	 *            ID of the node
	 * @param parent_id
	 *            ID of the parent of current node
	 * @param node_order
	 *            the position of node in pre-order traversal
	 * @param name
	 *            the name of the <code>PlanNode</code>. either a table name or
	 *            a operator name.
	 * @param columnNames
	 *            the properties of the <code>PlanNode</code>.
	 * @param columnValues
	 *            the values of the properties of the <code>PlanNode</code>.
	 */
	public PlanNode(String nodeID, String parentID, String position,
			String name, String[] columnNames, String[] columnValues) {
		iNodeID = Integer.parseInt(nodeID);
		if (parentID == null) {
			iParentID = -1;
			iPosition = -1;
		} else {
			iParentID = Integer.parseInt(parentID);
			iPosition = Integer.parseInt(position);
		}
		strColumnNames = columnNames;
		strColumnValues = columnValues;
	}

	public String[] getColumnNames() {
		return strColumnNames;
	}

	public String[] getColumnValues() {
		return strColumnValues;
	}

	// public void setNumOfOperators(int ops){
	// numOfOperators = ops;
	// }
	//  
	// public int getNumOfOperators(){
	// return numOfOperators;
	// }

	/**
	 * Determines the equality of two Plan tree rooted at PlanNodes; A PlanNodes
	 * equality must be determined differently on each DBMS implementation. The
	 * overall criteria being that a PlanNodes difference are significant if the
	 * difference result from a different query plan.
	 * 
	 * @param o
	 *            The other PlanNode that is being compared to this node.
	 * @return A value of true, if the two nodes are the same implementation and
	 *         represent the same information, else return false.
	 */
	public boolean equals(Object o) {
		return nodeEqual(this, (PlanNode) o);
	}

	/**
	 * Determines the equality of two plans by traversing each one recursively.
	 * 
	 * @param n
	 *            one plan node
	 * @param o
	 *            another plan node
	 * @return true if two plans rooted as n and o respectively, are equal,
	 *         otherwise, false.
	 */
	private boolean nodeEqual(PlanNode n, PlanNode o) {

		if (o instanceof TableNode) {
			if (!(n instanceof TableNode)) {
				return false;
			}
			TableNode q = (TableNode) n;
			TableNode p = (TableNode) o;
			return (q.iNodeID == p.iNodeID)
					&& (q.iParentID == p.iParentID)
					&& (q.getPropertyValue("OBJECT_NAME").equals(p
							.getPropertyValue("OBJECT_NAME")))
					&& (q.iPosition == p.iPosition);
		} else if (o instanceof OperatorNode) {
			if (!(n instanceof OperatorNode)) {
				return false;
			}
			OperatorNode q = (OperatorNode) n;
			OperatorNode p = (OperatorNode) o;
			if ((q.iNodeID == p.iNodeID)
					&& (q.iParentID == p.iParentID)
					&& (q.getPropertyValue("OPERATION").equals(p
							.getPropertyValue("OPERATION")))
					&& (q.iPosition == p.iPosition)) {
				int ch0cnt = p.getChildNumber();
				int ch1cnt = q.getChildNumber();
				if (ch0cnt != ch1cnt) {
					return false;
				}
				boolean eq = true;
				for (int i = 0; i < ch0cnt; i++) {
					eq = nodeEqual(q.getChild(i), p.getChild(i));
					if (!eq) {
						return false;
					}
				}
				return eq;
			}
		}
		return false;
	}

	/**
	 * Provides the parent node of current node. Also can be used by AZDBLab to
	 * visualize the graph.
	 * 
	 * @return The parent node of current node.
	 */
	public PlanNode getParent() {
		return parentNode;
	}

	public int getNodeID() {
		return iNodeID;
	}

	public int getParentID() {
		return iParentID;
	}

	/**
	 * Retrieves the position number of this node among the child nodes of its
	 * parent node.
	 * 
	 * @return The position number of current node.
	 */
	public int getPosition() {
		return iPosition;
	}

	public void setPosition(int position) {
		iPosition = position;
	}

	public void setNodeID(int nodeID) {
		iNodeID = nodeID;
	}

	public void setParentID(int parentID) {
		iParentID = parentID;
	}

	public int hashCode() {
		String nodeString = "";
		if (this instanceof OperatorNode) {
			nodeString = (String) this.getPropertyValue("OPERATION");
		} else if (this instanceof TableNode) {
			nodeString = (String) (this.getPropertyValue("OBJECT_NAME"));
		}
		int nodehash = nodeString.hashCode();
		return nodehash;
	}

	/**
	 * Creates a hash code for the node according to the hashCode spec for
	 * Objects.
	 * 
	 * @return Should provide a unique hash code for each object.
	 */
	public long myHashCode() {
		long hashCode = hashComputing(this);
		return hashCode;
	}

	private long hashComputing(PlanNode node) {
		if (node instanceof OperatorNode) {
			OperatorNode o = (OperatorNode) node;
			int numChild = o.getChildNumber();
			long subCode = 1;
			for (int i = 0; i < numChild; i++) {
				PlanNode nodeChild = o.getChild(i);
				subCode *= (hashComputing(nodeChild) + (int) Math.pow(2,
						(i + 1)));
			}
			return node.hashCode() * subCode;
		} else if (node instanceof TableNode) {
			return node.hashCode();
		}
		return -1;
	}

	/**
	 * Provides a string representation of the information that is contained in
	 * this node.
	 * 
	 * @return A string representing the information in this node. This should
	 *         be in a human readable format.
	 */
	public String toString() {
		return visitNode(this);
	}

	// /**
	// * Finds a matching <code>PlanNode</code> with a given id by traversing
	// the plan from root.
	// * @param node : a given plan node
	// * @param id : a given id
	// * @return <code>PlanNode</code> with the passed id
	// */
	// public PlanNode findPlanNode(PlanNode node, int id) {
	// PlanNode res = null;
	// if (node instanceof TableNode) {
	// res = null;
	// } else {
	// if(node.getNodeID() == id) {
	// res = node;
	// return res;
	// }
	// else{
	// int numchild = ((OperatorNode)node).getChildNumber();
	// for (int i = 0; i < numchild; i++) {
	// PlanNode descNode = findPlanNode(((OperatorNode)node).getChild(i), id);
	// if(descNode != null) {
	// res = descNode;
	// break;
	// }
	// }
	// }
	// }
	// return res;
	// }

	/**
	 * Traverses the plan from root <code>PlanNode</code>.
	 * 
	 * @param node
	 *            the root node
	 * @return the sequence of traversed <code>PlanNode</code> according to
	 *         pre-order.
	 */
	private String visitNode(PlanNode node) {
		if (node instanceof TableNode) {
			return ((TableNode) node).getTableName();
		} else {
			int numchild = ((OperatorNode) node).getChildNumber();
			String strnodes = "";
			for (int i = 0; i < numchild; i++) {
				strnodes += visitNode(((OperatorNode) node).getChild(i)) + "  ";
			}
			String operatorName = ((OperatorNode) node).getOperatorName();
			return (strnodes + "  " + operatorName);
		}
	}

	private void constructPlanOperators(PlanNode node) {
		if (node instanceof TableNode) {
			return;
		} else {
			int numchild = ((OperatorNode) node).getChildNumber();
			for (int i = 0; i < numchild; i++) {
				constructPlanOperators(((OperatorNode) node).getChild(i));
			}
			String operatorName = ((OperatorNode) node).getOperatorName();
			Integer occr = mapOperators.get(operatorName);
			if (occr == null) {
				mapOperators.put(operatorName, 1);
			} else {
				int newOccr = occr.intValue() + 1;
				mapOperators.remove(operatorName);
				mapOperators.put(operatorName, newOccr);
			}
		}
	}

	/**
	 * Retrieves the value of a specific property of the node.
	 * 
	 * @param property
	 *            The property whose value to be retrieved.
	 * @return The value of the property.
	 */
	public Object getPropertyValue(String property) {
		for (int i = 0; i < strColumnNames.length; i++) {
			if (property.equals(strColumnNames[i])) {
				return strColumnValues[i];
			}
		}
		return null;
	}

	/**
	 * Sets the value of a specific property.
	 * 
	 * @param property
	 *            The property whose value to be set.
	 * @param value
	 *            The value to be set to the property.
	 */
	public void setPropertyValue(String property, Object value) {
		for (int i = 0; i < strColumnNames.length; i++) {
			if (property.equals(strColumnNames[i])) {
				strColumnValues[i] = String.valueOf(value);
				return;
			}
		}
	}

	/**
	 * Retrieves the names of properties of a node.
	 * 
	 * @return The names of properties of a node.
	 */
	public String[] getProperties() {
		return strColumnNames;
	}

	public static void savePlanNode(Object obj, FileOutputStream outfile)
			throws IOException {
		ObjectOutputStream objstream = new ObjectOutputStream(outfile);
		objstream.writeObject(obj);
		objstream.close();
	}

	/**
	 * @param filename
	 *            String - The filename for the file to be loaded
	 */
	public static Object loadPlanNode(InputStream inputStream) throws Exception {
		ObjectInputStream objstream = new ObjectInputStream(inputStream);
		Object obj = objstream.readObject();
		objstream.close();
		return obj;
	}

	public HashMap<String, Integer> getPlanOperators() {
		mapOperators = new HashMap<String, Integer>();
		constructPlanOperators(this);
		return mapOperators;
	}

	public void setOpCostEstimates(HashMap<String, Double> mapRunStat) {
		// TODO Auto-generated method stub
		mapOpCostEstimates = mapRunStat;
	}

	public HashMap<String, Double> getOpCostEstimates() {
		return mapOpCostEstimates;
	}
}
