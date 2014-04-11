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
package plugins;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TimerTask;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import plugins.TeradataPlan.NodeType;
import plugins.TeradataPlan.TRPlanNode;

import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TableNode;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;
import azdblab.plugins.experimentSubject.ExperimentSubject;

/**
 * ExperimentSubject for Teradata DBMS The following is Connection Information
 * for SODB12 user: dbc pass: dbc connection string:
 * jdbc:teradata://172.16.236.128/TMODE=ANSI,CHARSET=UTF8
 * 
 * @author mjseo
 * @category exsubj
 */
class TeradataPlan {

	HashMap<String, TRPlanNode> nodeList = new HashMap<String, TRPlanNode>();
	TRPlanNode root = new TRPlanNode("root");

	public TeradataPlan() {
		super();
		root.type = NodeType.Operator;
		root.id = 1;
		root.parentId = 0;

	}

	class PlanNodeNotFoundException extends Exception {
		private static final long serialVersionUID = 1L;

		public PlanNodeNotFoundException() {
			super();
		}
	}

	TRPlanNode getPlanNode(String name) {
		if (nodeList.containsKey(name)) {
			// System.err.println("case1:"+name);
			return nodeList.get(name);
		} else {
			// System.err.println("case2:"+name);
			return null;
		}
	}

	public TRPlanNode createNode(String name) {
		TRPlanNode r = null;
		r = getPlanNode(name);

		return r == null ? new TRPlanNode(name) : r;

	}

	void debugNodeList(String memo) {
		// System.err.println("[" + memo + "]" + nodeList);
	}

	public void linkAllParent() {
		Set<String> set = nodeList.keySet();
		Iterator<String> keys = set.iterator();

		while (keys.hasNext()) {
			String key = (keys.next());
			TRPlanNode cn = nodeList.get(key);
			if (!cn.hasParent() && !cn.name.equals("root")) {
				cn.setParent("root");
				// System.out.println(cn.name + " node is child of root");
			}
		}

	}

	enum NodeType {
		Operator, Table
	};

	int nodeIdCount = 1;

	class TRPlanNode {
		String name;
		String table_name;
		String detail = "";

		int id = -1;
		int parentId = 0;

		// NodeType type = NodeType.Table;
		NodeType type = NodeType.Operator;

		ArrayList<TRPlanNode> children = new ArrayList<TRPlanNode>();
		TRPlanNode parent = null;

		public TRPlanNode(String name) {
			nodeList.put(name, this);
			this.name = name;
			this.id = ++nodeIdCount;
			this.info = new HashMap<String, Double>();
			// System.err
			// .println("NODE " + name + " and ID:" + id + "is created.");
		}

		public boolean hasParent() {
			return parent == null ? false : true;
		}

		public String getName() {
			return name;
		}

		public String getDetail() {
			return detail;
		}

		public void setDetail(String detail) {
			this.detail = detail;
		}

		private void addChild(String name, TRPlanNode node) {
			HashSet<TRPlanNode> nodes = new HashSet<TeradataPlan.TRPlanNode>(
					children);
			if (!nodes.contains(node)) {
				this.children.add(node);
				nodeList.put(name, node);
			}

		}

		boolean hasParent(String name) {
			return (this.parent != null ? true : false);
		}

		void setParent(String name) {
			if (hasParent(name)) {
				return; // do nothing
			}
			//System.out.println("[" + this.name + "]trying to do setParent \""
			//		+ name + "\"");
			TRPlanNode n = nodeList.get(name);
			this.parent = n;
			this.parentId = n.id;
			n.addChild(this.name, this);
		}

		void info() {
			//System.out.println();
			//System.out.println("Name:" + this.name);
			//System.out.println("Parent:"
			//		+ ((parent == null) ? "NONE" : this.parent.name));
			//System.out.println("Children:" + this.children);
		}

		@Override
		public String toString() {
			return String.format("[Name:%s,id=%d, parentId=%d, Detail:%s]",
					this.name, id, parentId, this.detail);
		}

		String traverseHere() {
			String str = "";
			for (int i = 0; i < this.children.size(); i++) {
				str += this.children.get(i) + " "
						+ this.children.get(i).traverseHere();
			}
			return str;
		}

		void printTraverse() {
		}

		TRPlanNode leftNode() {
			if (children.size() > 0)
				return children.get(0);
			else
				return null;
		}

		TRPlanNode rightNode() {
			if (children.size() > 1)
				return children.get(1);
			else
				return null;
		}

		Map<String, Double> info;

		Map<String, Double> getInfo() {
			// System.err.println("getInfo() called."+ (info == null ? "NULL" :
			// info.toString()) );
			return info;
		}

		void setInfo(Map<String, Double> info) {
			this.info = info;
		}

	}

	ArrayList<TRPlanNode> orderedPlanNodeName;

	ArrayList<TRPlanNode> inOrder() {
		orderedPlanNodeName = new ArrayList<TRPlanNode>();
		traverseInOrder(root);
		return orderedPlanNodeName;
	}

	TRPlanNode[] inOrderToArray() {
		orderedPlanNodeName = new ArrayList<TRPlanNode>();
		traversePreOrder(root);
		// eturn (TRPlanNode[]) (orderedPlanNodeName.toArray(a)
		return (TRPlanNode[]) orderedPlanNodeName
				.toArray(new TRPlanNode[orderedPlanNodeName.size()]);
	}

	TRPlanNode[] ToArray() {
		orderedPlanNodeName = new ArrayList<TRPlanNode>();
		// traversePreOrder(root);
		// eturn (TRPlanNode[]) (orderedPlanNodeName.toArray(a)
		return (TRPlanNode[]) orderedPlanNodeName
				.toArray(new TRPlanNode[orderedPlanNodeName.size()]);
	}

	void traverseInOrder(TRPlanNode p) {
		if (p == null)
			return;
		traverseInOrder(p.leftNode());
		// System.out.println(p.name);
		orderedPlanNodeName.add(p);
		traverseInOrder(p.rightNode());
	}

	ArrayList<TRPlanNode> preOrder() {
		orderedPlanNodeName = new ArrayList<TRPlanNode>();
		traversePreOrder(root);
		return orderedPlanNodeName;
	}

	TRPlanNode[] preOrderToArray() {
		orderedPlanNodeName = new ArrayList<TRPlanNode>();
		traversePreOrder(root);
		// eturn (TRPlanNode[]) (orderedPlanNodeName.toArray(a)
		return (TRPlanNode[]) orderedPlanNodeName
				.toArray(new TRPlanNode[orderedPlanNodeName.size()]);
	}

	void traversePreOrder(TRPlanNode p) {
		if (p == null)
			return;
		orderedPlanNodeName.add(p);
		traverseInOrder(p.leftNode());
		traverseInOrder(p.rightNode());
	}

}

class TeradataXML {

	private String filename;

	public String getFilename() {
		return filename;
	}

	enum sourceType {
		File, String
	};

	public void readFromStream(InputStream is)
			throws ParserConfigurationException, SAXException, IOException {
		dbf = DocumentBuilderFactory.newInstance();
		db = dbf.newDocumentBuilder();
		doc = db.parse(is);

		doc.getDocumentElement().normalize();
		root = doc.getDocumentElement();
		readConfiguration();
		getPlans();
	}

	public TeradataXML(File f) throws ParserConfigurationException,
			SAXException, IOException {
		InputStream is = new FileInputStream(f);
		readFromStream(is);
	}

	public TeradataXML(String xml) throws ParserConfigurationException,
			SAXException, IOException {
		xml = xml.replaceAll("UTF\\-16", "UTF-8");
		// System.err.println(xml);
		ByteArrayInputStream bais = null;
		try {
			bais = new ByteArrayInputStream(xml.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		readFromStream(bais);
	}

	DocumentBuilderFactory dbf;
	DocumentBuilder db;
	Document doc;
	Node root;

	String QCFCaptureTimestamp = null;

	enum RefType {
		Relation, Spool, Wrong
	};

	HashMap<String, String> relations = new HashMap<String, String>();
	HashMap<String, String> spools = new HashMap<String, String>();

	public void getRelAndSpool() {
		NodeList Relation_Element = doc.getElementsByTagName("Relation");

		for (int i = 0; i < Relation_Element.getLength(); i++) {
			NamedNodeMap attrs = Relation_Element.item(i).getAttributes();
			String ID = attrs.getNamedItem("Id").getNodeValue();
			String tablename = attrs.getNamedItem("TableName").getNodeValue();
			relations.put(ID, tablename);
		}
		NodeList Spool_Element = doc.getElementsByTagName("Spool");

		for (int i = 0; i < Spool_Element.getLength(); i++) {
			NamedNodeMap attrs = Spool_Element.item(i).getAttributes();
			String ID = attrs.getNamedItem("Id").getNodeValue();
			String Cardinality = attrs.getNamedItem("Cardinality")
					.getNodeValue();
			String SpoolSize = attrs.getNamedItem("SpoolSize").getNodeValue();
			spools.put(ID, String.format("Cardinality:%s, SpoolSize:%s",
					Cardinality, SpoolSize));
		}
		// System.out.println(relations);
		// System.out.println(spools);

	}

	TeradataPlan tdPlan;

	public TRPlanNode getRoot() {
		return tdPlan.root;
	}

	public Map<String, String> getMap(NamedNodeMap nnm) {
		Map<String, String> m = new HashMap<String, String>();
		for (int i = 0, length = nnm.getLength(); i < length; i++) {
			m.put(nnm.item(i).getNodeName(), nnm.item(i).getNodeValue());
		}
		return m;
	}

	public void getPlans() {
		tdPlan = new TeradataPlan();
		// getting SQL Statement
		// Node request = doc.getElementsByTagName("Request").item(0);
		// getting ObjectDefs
		NodeList relationList = doc.getElementsByTagName("Relation");
		NodeList spoolList = doc.getElementsByTagName("Spool");
		
		HashMap<String, String> idToTableMap = new HashMap<String, String>();
		for (int i = 0; i < relationList.getLength(); i++) {
			Node aRel = relationList.item(i);
			NamedNodeMap attrs = aRel.getAttributes();
			// Id TableName Cardinality
			String Id = attrs.getNamedItem("Id").getNodeValue();
			String TableName = attrs.getNamedItem("TableName").getNodeValue();
			String Cardinality = attrs.getNamedItem("Cardinality")
					.getNodeValue();
			// System.err.printf("[%s,%s,%s]",Id,TableName,Cardinality);//RM
			TRPlanNode src = tdPlan.createNode(Id);
			src.table_name = TableName;
			idToTableMap.put(Id, TableName);
			src.info.put("Rows", Double.parseDouble(Cardinality));
			// T2
		}
		for (int i = 0; i < spoolList.getLength(); i++) {
			// Cardinality SpoolSize
			Node aSpool = spoolList.item(i);
			NamedNodeMap attrs = aSpool.getAttributes();

			String Id = attrs.getNamedItem("Id").getNodeValue();
			String SpoolSize = attrs.getNamedItem("SpoolSize").getNodeValue();
			String Cardinality = attrs.getNamedItem("Cardinality")
					.getNodeValue();
			// System.err.printf("[%s,%s,%s]",Id,SpoolSize,Cardinality);//RM
			TRPlanNode src = tdPlan.createNode(Id);
			src.info.put("Rows", Double.parseDouble(Cardinality));
			src.info.put("SpoolSize", Double.parseDouble(SpoolSize));
		}

		int seq = 0;

		NodeList planlist = doc.getElementsByTagName("PlanStep");
		String JoinKind = "";
		String JoinType = "";
		Map<String, Double> joinInfo = null;
		for (int i = 0; i < planlist.getLength(); i++) {
			ArrayList<String> srcAcc = new ArrayList<String>();
			String tgtAcc = "";
			String StepDetail = "";
			String operation = "";

			for (int j = 0; j < planlist.item(i).getChildNodes().getLength(); j++) {
				Node tempnode = planlist.item(i).getChildNodes().item(j);
				String nodeName = tempnode.getNodeName();
				if (nodeName.equals("SourceAccess")) {
					NodeList cNodes = tempnode.getChildNodes();
					for (int k = 0, numchild = cNodes.getLength(); k < numchild; k++) {
						Node Child = cNodes.item(k);
						String ChildName = Child.getNodeName();
						if (ChildName.equals("RelationRef")) {
							// System.err.printf("[DEBUG(RelationRef):]");
							NamedNodeMap attr = Child.getAttributes();
							// String attrval = "TABLE(" +
							// attr.getNamedItem("AliasName")
							// .getNodeValue();
							// attrval += ":";
							// attrval +=
							// attr.getNamedItem("Ref").getNodeValue();
							// attrval += ")";

							// T1
							String attrval = attr.getNamedItem("Ref")
									.getNodeValue();
							srcAcc.add(attrval);
						} else if (ChildName.equals("SpoolRef")) {
							NamedNodeMap attr = Child.getAttributes();
							String attrval = attr.getNamedItem("Ref")
									.getNodeValue();
							srcAcc.add(attrval);
						}
					}
				} else if (nodeName.equals("TargetStore")) {
					NodeList cNodes = tempnode.getChildNodes();
					for (int k = 0, numchild = cNodes.getLength(); k < numchild; k++) {
						Node Child = cNodes.item(k);
						String ChildName = Child.getNodeName();

						if (ChildName.equals("SpoolRef")) {
							NamedNodeMap attr = Child.getAttributes();
							String attrval = attr.getNamedItem("Ref")
									.getNodeValue();
							tgtAcc = attrval;
						}

					}
				} else if (nodeName.equals("Predicate")) {

					NamedNodeMap attrs = tempnode.getAttributes();
					String PredicateKind = attrs.getNamedItem("PredicateKind")
							.getNodeValue();
					if (PredicateKind.equals("Join")) {
						// step.PredicateKind = PredicateKind;
					} else {
						// step.PredicateKind = "NoJoin";
						// step.JoinKind = "";
						// step.JoinType = "";
					}

				} else if (nodeName.equals("StepDetails")) {
					NodeList cNodes = tempnode.getChildNodes();
					for (int k = 0; k < cNodes.getLength(); k++) {
						if (cNodes.item(k).getNodeName().equals("JIN")) {
							operation = "JOIN" + seq++;
							Node JIN_Node = cNodes.item(k);

							NamedNodeMap attrs = JIN_Node.getAttributes();
							joinInfo = new HashMap<String, Double>();

							StepDetail += String.format(
									"JoinKind:%s,JoinType:%s", attrs
											.getNamedItem("JoinKind")
											.getNodeValue(), attrs
											.getNamedItem("JoinType")
											.getNodeValue());
							JoinKind = attrs.getNamedItem("JoinKind")
									.getNodeValue();
							JoinType = attrs.getNamedItem("JoinType")
									.getNodeValue();
						}
					}
				} else if (nodeName.equals("OptStepEst")) {
					NamedNodeMap attrs = tempnode.getAttributes();
					joinInfo = new HashMap<String, Double>();
					for (int l = 0, length = attrs.getLength(); l < length; l++) {
						String key = attrs.item(l).getNodeName();
						String value = attrs.item(l).getNodeValue();
						joinInfo.put(key, Double.parseDouble(value));
						// LAST:
						// Modifying OptSetCost

					}
					if (joinInfo.size() == 0) {
						joinInfo.put("Value", 0.0); // TODO: lastposition
					}
					double rows = joinInfo.get("EstRowCount");
					joinInfo.put("ROWS", rows);
					/*
					 * StepDetail += String.format( "JoinKind:%s,JoinType:%s",
					 * attrs .getNamedItem("JoinKind") .getNodeValue(), attrs
					 * .getNamedItem("JoinType") .getNodeValue()); JoinKind =
					 * attrs.getNamedItem("JoinKind").getNodeValue(); JoinType =
					 * attrs.getNamedItem("JoinType").getNodeValue();
					 */
				} else if (tempnode.getNodeType() == Node.ELEMENT_NODE) {
					// Other Node: System.out.println("[ETC]-->" +
					// tempnode.getNodeName());
				}

				// System.out.println(srcAcc);
				// System.out.println(tgtAcc);
			}
			if (!tgtAcc.equals("")) {
				TRPlanNode tgt = tdPlan.createNode(tgtAcc);
				
				if (operation.startsWith("JOIN")) {
					TRPlanNode op = tdPlan.createNode(operation);
					op.type = NodeType.Operator;
					op.setParent(tgtAcc);
				}

				for (int l = 0; l < srcAcc.size(); l++) {
					TRPlanNode src = tdPlan.createNode(srcAcc.get(l));

					if (operation.startsWith("JOIN")) {
						if(srcAcc.get(l).startsWith("REL")){
							src.table_name = (String)idToTableMap.get((srcAcc.get(l)));
							src.type = NodeType.Table;
						}
						src.setParent(operation);
						tdPlan.getPlanNode(operation).setDetail(StepDetail);
						tdPlan.getPlanNode(operation).setInfo(joinInfo);

					} else if (srcAcc.get(l).startsWith("REL")) {
						src.type = NodeType.Table;
						src.setParent(tgtAcc);
					} else {
						src.setParent(tgtAcc);
					}

				}
			}
			// tdPlan.debugNodeList("Debug Here");
		}
		tdPlan.linkAllParent();

		// System.out.println(tdPlan.inOrder());
		// System.out.println(tdPlan.preOrder());
		// tdPlan.getPlanNode("JOIN1").children
		// System.err.println(tdPlan.getPlanNode("JOIN1").children);
		//tdPlan.debugNodeList("Debug Here");
	}

	HashMap<String, String> configuration = new HashMap<String, String>();

	private void readConfiguration() {

		Node config = doc.getElementsByTagName("Configuration").item(0);

		for (int i = 0; i < config.getAttributes().getLength(); i++) {
			String attrName = config.getAttributes().item(i).getNodeName();
			String attrValue = config.getAttributes().item(i).getNodeValue();

			configuration.put(attrName, attrValue);
		}
	}

	public String getTableNameById(String id) {
		return relations.get(id);
	}

	public String getSpoolInfo(String spoolId) {
		return spools.get(spoolId);
	}

	public void test() {
		getPlans();
	}

	public Vector<PlanNode> toPlanNodes() {
		// TRPlanNode[] nodes = tdPlan.preOrderToArray();
		TRPlanNode[] nodes = tdPlan.preOrderToArray();
		// TRPlanNode[] nodes = tdPlan.ToArray();
		Vector<PlanNode> v_tree = new Vector<PlanNode>();
		for (int i = 0; i < nodes.length; i++) {
			PlanNode newnode = null;
			if (nodes[i].type == TeradataPlan.NodeType.Operator) {
				// type Operator

				/*
				 * The constructor specifies the basic OperatorNode information
				 * 
				 * Parameters: node_id ID of the node parent_id ID of the parent
				 * of current node node_order the position of node in pre-order
				 * traversal name the name of the OperatorNode. either a table
				 * name or a operator name. columnNames the properties of the
				 * OperatorNode. columnValues the values of the properties of
				 * the OperatorNode.
				 */

				newnode = new OperatorNode(nodes[i].id + "", nodes[i].parentId
						+ "", i + "", nodes[i].name + "",
						new String[] { "OPERATION" },
						new String[] { "JOIN" + i });

				HashMap<String, Double> value = (HashMap<String, Double>) (nodes[i].getInfo());
				if (value == null) {
					// System.err.println("ecase1");
					value = new HashMap<String, Double>();
					value.put("ROWS", 0.0);
				}

				newnode.setOpCostEstimates(value);
			} else {
				// type Table
				newnode = new TableNode(nodes[i].id + "", nodes[i].parentId
						+ "", i + "",
//						nodes[i].name + ":" + nodes[i].table_name,
						(nodes[i].table_name).toUpperCase(),
						new String[] { "OBJECT_NAME" },
						new String[] { "TABLENAME" + i });
				HashMap<String, Double> value = (HashMap<String, Double>) (nodes[i].getInfo());
				if (value == null) {
					// System.err.println("ecase2");
					value = new HashMap<String, Double>();
					value.put("ROWS", 0.0);
				}
			}
			if (newnode != null)
				v_tree.add(newnode);
		}

		return v_tree;

	}
}

public class TeradataSubject extends ExperimentSubject {
	private static final String USER_NAME = "azdblab_user";

	public void populateXactTable(Table table, RepeatableRandom repRand) {
		String tableName = table.table_name_with_prefix;
		int columnnum = table.columns.length;
		long actual_cardinality = table.actual_card;
		long maximum_cardinality = table.hy_max_card;
		try {
			Main._logger.outputLog("New Imp. of pop()");
			Main._logger.outputLog("Clearing Table: " + tableName);
			String clearSQL = "DELETE FROM " + tableName;
			_statement.executeUpdate(clearSQL);
			commit();
			String strupdate = "";
			Main._logger.outputLog("Populating Table to maximum cardinality: "
					+ tableName);

			PreparedStatement psInsertRows = null;
			String strinsertOption = "";

			for (int i = 0; i < columnnum; i++) {
				if (i == columnnum - 1) {
					strinsertOption += "?";
				} else {
					strinsertOption += "?,";
				}
			}
			String insert_sql = "INSERT INTO " + tableName + " values ("
					+ strinsertOption + ");";
			psInsertRows = _connection.prepareStatement(insert_sql);
			for (long i = 0; i < actual_cardinality; i++) {
				if ((i + 1) % teradata_batch_size == 0) {
					int[] noRows = psInsertRows.executeBatch();
					Main._logger.outputLog((i + 1)
							+ " statements prepared and commit.");
					commit();
					// psInsertRows = _connection.prepareStatement(insert_sql);
				}
				String strdata = "";
				// Assume all data fields are of integer data type
				psInsertRows.setLong(1, i);
//				for (int j = 2; j <= columnnum; j++) {
//					psInsertRows.setLong(j, repRand.getNextRandomInt());
//
//				}
				Column[] column = table.getColumns();
				// Assume all data fields are of integer data type
				for ( int j = 1; j < columnnum; j++ ) {
					if(column[j].myName.contains("val")){
						String strVal = "'Dallas, long scarred by the guilt and shame of being the place Pres. JFK was assassinated.'";
						psInsertRows.setString(j+1, strVal);
					}else{
						psInsertRows.setLong(j+1, repRand.getNextRandomInt());
					}
				}
				psInsertRows.addBatch();
			}
			int[] noRows = psInsertRows.executeBatch();
			Main._logger.outputLog("Rest statements prepared and commit.");
			commit();

			// for (int i = 0 ; i < columnnum; i++) {
			// if (i == columnnum -1) {
			// strinsertOption += "?";
			// } else {
			// strinsertOption += "?,";
			// }
			// }
			// // String strinsert =
			// "INSERT INTO "+tableName+" values (?, "+strinsertOption+");";
			// String strinsert =
			// "INSERT INTO "+tableName+" values ("+strinsertOption+");";
			// psInsertRows = _connection.prepareStatement(strinsert);
			// for ( long i = 0; i < maximum_cardinality; i++ ){
			// if ((i + 1) % teradata_batch_size == 0){
			// int[] noRows = psInsertRows.executeBatch();
			// System.out.println(strinsert);
			// System.out.println((i+1)+ " statements prepared and commit.");
			// commit();
			// //psInsertRows = _connection.prepareStatement(strinsert);
			// }
			// String strdata = "";
			// // Assume all data fields are of integer data type
			// psInsertRows.setLong(1, i);
			// // for ( int j = 2; j <= columnnum; j++ ) {
			// // psInsertRows.setLong(j, repRand.getNextRandomInt());
			// // }
			// Column[] column = table.getColumns();
			// // Assume all data fields are of integer data type
			// for ( int j = 1; j < columnnum; j++ ) {
			// if(column[j].myName.contains("val")){
			// String strVal =
			// "'Dallas, long scarred by the guilt and shame of being the place Pre. JFK was assassinated.'";
			// psInsertRows.setString(j+1, strVal);
			// }else{
			// psInsertRows.setLong(j+1, repRand.getNextRandomInt());
			// }
			// }
			//
			//
			// }
			// psInsertRows.addBatch();
			// int[] noRows = psInsertRows.executeBatch();
			// System.out.println("Rest statements prepared and commit.");
			// commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}
	
	@Override  
	public void populateVariableTable(
		      String tableName, 
		      int columnnum, 
		      long maximum_cardinality, 
		      RepeatableRandom repRand){
			  try{
				  Main._logger.outputLog("New Imp. of pop()");
				  Main._logger.outputLog("Clearing Table: " + tableName);
				  String  clearSQL  = "DELETE FROM " + tableName;
				  _statement.executeUpdate(clearSQL);
				  commit();
				  String  strupdate  = "";
				  Main._logger.outputLog("Populating Table to maximum cardinality: " + tableName);
			      
			      PreparedStatement psInsertRows = null;
			      String strinsertOption = "";
				  
			      for (int i = 0 ; i < columnnum; i++) {
			    	if (i == columnnum -1) {
			    	  strinsertOption  += "?";
		            } else {
		            	strinsertOption  += "?,";
		            }
			      }
			  	  String strinsert = "INSERT INTO "+tableName+" values (?, "+strinsertOption+");";
			  	  psInsertRows = _connection.prepareStatement(strinsert);
			  	  for ( long i = 0; i < maximum_cardinality; i++ ){
			          if ((i + 1) % teradata_batch_size == 0){
							int[] noRows = psInsertRows.executeBatch();
							System.out.println((i+1)+ " statements prepared and commit.");
							commit();
							//psInsertRows = _connection.prepareStatement(strinsert);
			          }
			          String  strdata  = "";
			          // Assume all data fields are of integer data type
			          psInsertRows.setLong(1, i);
		          	  for ( int j = 2; j <= columnnum; j++ ) {
		  				psInsertRows.setLong(j, repRand.getNextRandomInt());
		          	  }
			        }
			  		psInsertRows.addBatch();
					int[] noRows = psInsertRows.executeBatch();
					System.out.println("Rest statements prepared and commit.");
					commit();
			  }catch (SQLException sqlex){
			      sqlex.printStackTrace();
			  }
		  }

		    
		  /**
		   * This method populates table with random records with amount equals to cardinality.
		   * @param tableName This table will be populated.
		   * @param actual_cardinality The new number of records to be filled in.
		   * @param repRand The <code>RepeatableRandom</code> instance used to generate random values for table
		   * @param isVariableTable Whether or not is the table to be populated a variable table. 
		   *   It only matters when clone table mechanism has to be implemented. This implementation assumes the cloning mechanism is activated. 
		   *   (OracleSubject has to override this to ignore this flag) 
		   */
		  public void populateTable(
		      String tableName, int columnnum, long actual_cardinality,
		      long maximum_cardinality, RepeatableRandom repRand,
		      boolean isVariableTable) throws Exception{
		    try {
		      if (!isVariableTable) {
		    	  Main._logger.outputLog("New Imp. of pop()");
				  Main._logger.outputLog("Clearing Table: " + tableName);
				  String  clearSQL  = "DELETE FROM " + tableName;
				  _statement.executeUpdate(clearSQL);
				  commit();
				  Main._logger.outputLog("Populating Table to actual cardinality: " + tableName);
			      
			      PreparedStatement psInsertRows = null;
			      String strinsertOption = "";
				  
			      for (int i = 0 ; i < columnnum; i++) {
			    	if (i == columnnum -1) {
			    	  strinsertOption  += "?";
		            } else {
		            	strinsertOption  += "?,";
		            }
			      }
			      String insert_sql = "INSERT INTO "+tableName+" values ("+strinsertOption+");";
			  	  psInsertRows = _connection.prepareStatement(insert_sql);
			      for ( long i = 0; i < actual_cardinality; i++ ){
			          if ((i + 1) % teradata_batch_size == 0){
							int[] noRows = psInsertRows.executeBatch();
							Main._logger.outputLog((i+1)+ " statements prepared and commit.");
							commit();
							//psInsertRows = _connection.prepareStatement(insert_sql);
			          }
			          String  strdata  = "";
			          // Assume all data fields are of integer data type
			          psInsertRows.setLong(1, i);
			          for ( int j = 2; j <= columnnum; j++ ) {
			  			psInsertRows.setLong(j, repRand.getNextRandomInt());
						
			          }
			          psInsertRows.addBatch();
				  }
			      int[] noRows = psInsertRows.executeBatch();
			      Main._logger.outputLog("Rest statements prepared and commit.");
			      commit();
		      } else {
		        String  cloneMaxTableName  = "clone_max_" + tableName;
		        Main._logger.outputLog("Clearing Table: " + tableName);
		        String  clearSQL  = "DELETE FROM " + tableName;
		        _statement.executeUpdate(clearSQL);
		        copyTable(cloneMaxTableName, tableName);
			      PreparedStatement psInsertRows = null;
			      String strinsertOption = "";
				  
			      for (int i = 0 ; i < columnnum; i++) {
			    	if (i == columnnum -1) {
			    	  strinsertOption  += "?";
		            } else {
		            	strinsertOption  += "?,";
		            }
			      }
			  	  String strinsert = "INSERT INTO "+cloneMaxTableName+" values ("+strinsertOption+");";
			  	psInsertRows = _connection.prepareStatement(strinsert);
		        String  strupdate  = "";
		        for (long i = 0; i < maximum_cardinality; i++){
		          if ((i + 1) % teradata_batch_size == 0){
		            //Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
		            int[] noRows = psInsertRows.executeBatch();
					System.out.println((i+1)+ " statements prepared and commit.");
					commit();
					//psInsertRows = _connection.prepareStatement(strinsert);
		          }
		          String  strdata  = "";
		          // Assume all data fields are of integer data type
		          psInsertRows.setLong(1, i);
		          for ( int j = 2; j <= columnnum; j++ ) {
		  			psInsertRows.setLong(j, repRand.getNextRandomInt());
		          }
		          psInsertRows.addBatch();

		        }
				int[] noRows = psInsertRows.executeBatch();
				System.out.println("Rest statements prepared and commit.");
				commit();		        
//		        Below is the old code that's not consistent with stepC.
//		        copyTable(tableName, cloneMaxTableName, actual_cardinality);
//		        commit();
		      }
		    } catch (SQLException sqlex){
		      sqlex.printStackTrace();
		    }
		  }
	
	/**
	 * Teradata DBMS require the command "DATABASE" to use database before using
	 * DBMS
	 * 
	 */
	@Override
	public void open(boolean auto_commit) {
		super.open(auto_commit);
		//super.open(true); // force auto_commit
		String setDB = "DATABASE " + USER_NAME + ";";
		try {
			_statement.executeUpdate(setDB);
			_connection.commit();
			Main._logger.outputLog("DATABASE azdblab_user; activated.");
			Main._logger.outputLog("OPEN Teradata DB successfully");
		} catch (SQLException e) {
			e.printStackTrace();
			// Main._logger.outputLog("Open DB for Teradata Failed");
			Main._logger.outputLog("DB open for teradata failed!");
		}

	}

	protected class TimeoutQueryExecutionTeradata extends TimerTask {
		public TimeoutQueryExecutionTeradata() {
		}

		public void run() {
			try {
				Statement tmp_stmt = _connection.createStatement();
				tmp_stmt.cancel();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
	}

	private static final String COST_MODEL_PREFIX = "TD_";
	TimeoutQueryExecutionTeradata teradata_timeOuter;

	/**
	 * 
	 * @param user_name
	 * @param password
	 * @param connect_string
	 */
	public TeradataSubject(String user_name, String password,
			String connect_string, String machineName) {
		super(user_name, password, connect_string, machineName);

	}
	
	@Override
	public void commit() {
		// TODO Auto-generated method stub
		super.commit();
		//System.out.println("Commit occured, but not executed in TeradataSubject");
	}

	/**
	 * 
	 * @param connect_string
	 */

	public void SetStatement(Statement stmt) {
		_statement = stmt;
	}

//	public String getExperimentSubjectName() {
//		return "TeradataSubject";
//	}

	public String getDBMSName() {
		return DBMS_NAME;
	}
	
//	public static String getName(){
//	  return DBMS_NAME;
//	}
	
	public void deleteHelperTables() {
	}

	/**
	 * static inner private class Main Temporary logger for developing
	 * TeradataSubject and JavaDBSubject This private inner class should be
	 * removed when implementation is done.
	 * 
	 * @author mjseo
	 * 
	 */
	// private static class Main {
	// public static boolean verbose = true;
	// public static class _logger {
	// public static void outputLog(String s) {
	// System.err.println("[oLog] "+s);
	// }
	// public static void reportError(String s) {
	// System.err.println("[iErr]"+s);
	// }
	//			
	// }
	// }

	/**
	 * Clone table in Teradata CREATE TABLE dest_table_name AS source_table_name
	 * WITH DATA;
	 * 
	 * @author mjseo
	 */
	@Override
	public void copyTable(String newTable, String oriTable) throws Exception {
		// TODO Auto-generated method stub
		try {

			if (tableExists(newTable)) {
				dropTable(newTable);

			}
			String cloneSQL = String.format("CREATE TABLE %s AS %s WITH DATA;",
					newTable, oriTable);
			Main._logger.outputLog(cloneSQL);
			// System.err.println(cloneSQL);

			_statement.executeUpdate(cloneSQL);
			//commit();
			_connection.commit();

			// Main._logger.outputLog
			Main._logger.outputLog("Clone table finished!");

		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
	      sqlex.printStackTrace();
	      throw new Exception(sqlex.getMessage());
		}
	}

	/**
	 * The second way to make clone table This can inseTablert partial data into
	 * new table
	 * 
	 * @author mjseo CREATE TABLE Dest_Table AS Src_Table WITH NO DATA; INSERT
	 *         Dest_Table SELECT * FROM Src_Table;
	 */
	@Override
	public void copyTable(String newTable, String oriTable, long cardinality) throws Exception {
		// TODO Auto-generated method stub
		try {

			if (tableExists(newTable)) {
//				_statement.executeUpdate("DROP STATS on " + newTable);
				_statement.executeUpdate("DROP TABLE " + newTable);
				commit();
			}
			String cloneSQL = String.format(
					"CREATE TABLE %s AS %s WITH NO DATA; ", newTable, oriTable);
//			Main._logger.outputLog(cloneSQL);
			_statement.executeUpdate(cloneSQL);
			//commit();
			_connection.commit();
			cloneSQL = String.format(
					"INSERT %s SELECT * FROM %s WHERE id1 < %s", newTable,
					oriTable, cardinality + "");
//			Main._logger.outputLog(cloneSQL);
			_statement.executeUpdate(cloneSQL);
			//commit();
			_connection.commit();
//Main._logger.outputLog("Clone table finished!");

		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
		      sqlex.printStackTrace();
		      throw new Exception(sqlex.getMessage());
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * azdblab.plugins.experimentalSubject.ExperimentSubject#dropAllInstalledTables
	 * ()
	 */

	@Override
	public void dropAllInstalledTables() {
		/*
		 * In Teradata SELECT * from dbc.tables where databasename = 'dbname';
		 * dbname is the name of database
		 * 
		 * @author mjseo
		 */
		String[] tablesShouldNotBeDeleted = { "FastLogRestartV", "FastLogV",
				"QCD", "FastLogIns", "FastLogUpd", "FastLog", "HelpSyntax" };
		// Array to HashSet for the sake of improving search tables that should
		// not be deleted
		HashSet<String> columns = new HashSet<String>(Arrays
				.asList(tablesShouldNotBeDeleted));
		// Get all tables;
		String sql = "SELECT TableName from dbc.tables where DatabaseName='"
				+ USER_NAME + "';";

		try {
			Main._logger.outputLog("Find all tables by : " + sql);
			Vector<String> vecTables = new Vector<String>();
			ResultSet rs = _statement.executeQuery(sql);
			
			while (rs.next()) {
				String s = rs.getString(1).trim();

				if (columns.contains(s)) {
					// TODO:DEL Main._logger.outputLog("contain:" + s);
				} else {
					// TODO:DEL Main._logger.outputLog(s);
					vecTables.add(s);
				}
			}
			Main._logger.outputLog(vecTables.toString());
			rs.close();

			for (String tblName : vecTables) {
				Main._logger
						.outputLog("installed tables which will be deleted : "
								+ tblName);
				dropTable(tblName);

			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

//	@Override
//	public void dropTable(String tableName) {
//		// TODO Auto-generated method stub
//		//super.dropTable(tableName);
//	    if (Main.verbose) {
//	    	Main._logger.outputLog("Dropping Table: " + tableName);
//	    }
//	    try {
//	      //drop the table from the DBMS.
//	      _statement.executeUpdate("DROP TABLE " + tableName +";");
//	      // yksuh added commit as below
//	      //commit();
//	      _connection.commit(); 
//	    } catch (SQLException e) {
//	      e.printStackTrace();
//	    }
////	    Main._logger.outputLog(tableName + " Dropped.");
//	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * azdblab.plugins.experimentalSubject.ExperimentSubject#printTableStat(
	 * java.lang.String) TODO
	 */
	public void printTableStat(String tableName) {
		String countSQL = "SELECT count(*) " + "FROM " + tableName;
		// TODO: data length, max_data_length, avg row length

		try {
			Main._logger.outputLog("count: " + countSQL);
			ResultSet rs = _statement.executeQuery(countSQL);
			if (rs.next()) {
				Main._logger.outputLog("actual rows: " + rs.getInt(1));
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main._logger.reportError("exception-No statistics for table: "
					+ tableName);
			System.exit(1); // programmer/dbms error
		}

	}

	/**
	 * Given AZDBLAB's integer represenation of a data type, this produces a
	 * representation of the data type.
	 * 
	 * @param dataType
	 *            The data type
	 * @param length
	 *            The number of digits for this value.
	 * @return A string representation of this data type/length. This value can
	 *         be used in a create table statement.
	 */
	protected String getDataTypeAsString(int dataType, int length) {
		switch (dataType) {
		case GeneralDBMS.I_DATA_TYPE_NUMBER: {
			return NUMBER + "(" + length + ")";
		}
		case GeneralDBMS.I_DATA_TYPE_VARCHAR: {
			return VARCHAR + "(" + length + ")";
		}
		case GeneralDBMS.I_DATA_TYPE_CLOB: {
			return BLOB;
		}
		default: {
			Main._logger.reportError("Unknown data type");
			System.exit(1);
			// problem with xml schema. should have been caught
			return null;
		}
		}
	}

	/**
	 * Returns a query plan for this SQL query.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#getQueryPlan(java.lang.String)
	 */
	public PlanNode getQueryPlan(String sql) throws Exception {
		// TODO @mjseo should know how to get information in DB
		// ResultSet rs =
		// _statement.executeQuery("explain in xml SELECT * from test;");

		String explain_plan = "EXPLAIN in xml " + sql;
		ResultSet rs;
		String xml = null;
		PlanNode result = null;

		try {
			rs = _statement.executeQuery(explain_plan);
			if (rs != null) {
				rs.next();
				xml = rs.getString(1);
				// result in xml
				//Main._logger.outputLog(xml);

			}

			TeradataXML txml = new TeradataXML(xml);
			// TRPlanNode[] preOrderedNodeNames = txml.tdPlan.preOrderToArray();
			Vector<PlanNode> v_tree = txml.toPlanNodes();
			PlanNode root = null;
			result = buildTree(root, v_tree);

		} catch (SQLException e1) {
			e1.printStackTrace();
			// throw new Exception(empty_plan + "\n" + explain_plan, e1);
		}
		return result;
		// PlanNode result = null;
		// result = createPlanTree(vecDetail);

	}

	/**
	 * Builds a plan tree by ordering the node correctly. Nodes are ordered by
	 * node id such that a pre-order traversal of the tree will yield the nodes
	 * in ascending order.
	 * 
	 * @param v_tree
	 */
	protected PlanNode buildTree(PlanNode root, Vector<PlanNode> v_tree) {

		// inserting the root into the sorted list first.
		/*
		 * teradata will put data like following. { root=[Name:root,id=1,
		 * parentId=0, Detail:], SPOOL9=[Name:SPOOL9,id=11, parentId=12,
		 * Detail:], SPOOL8=[Name:SPOOL8,id=7, parentId=10, Detail:JoinKind:Hash
		 * Join,JoinType:Inner], SPOOL7=[Name:SPOOL7,id=6, parentId=10,
		 * Detail:], JOIN2=[Name:JOIN2,id=10, parentId=9, Detail:],
		 * SPOOL6=[Name:SPOOL6,id=4, parentId=8, Detail:JoinKind:Dynamic Hash
		 * Join,JoinType:Inner], JOIN1=[Name:JOIN1,id=8, parentId=7, Detail:],
		 * SPOOL5=[Name:SPOOL5,id=3, parentId=8, Detail:],
		 * JOIN0=[Name:JOIN0,id=5, parentId=4, Detail:],
		 * SPOOL4=[Name:SPOOL4,id=1, parentId=5, Detail:],
		 * SPOOL3=[Name:SPOOL3,id=9, parentId=11, Detail:JoinKind:Hash
		 * Join,JoinType:Inner], SPOOL1=[Name:SPOOL1,id=12, parentId=1,
		 * Detail:], REL1=[Name:REL1,id=2, parentId=6, Detail:] }
		 * 
		 * [Debug Here]{ root=[Name:root,id=1, parentId=0, Detail:],
		 * SPOOL9=[Name:SPOOL9,id=8, parentId=11, Detail:JoinKind:Merge
		 * Join,JoinType:Inner], SPOOL7=[Name:SPOOL7,id=6, parentId=9,
		 * Detail:JoinKind:Merge Join,JoinType:Inner], JOIN2=[Name:JOIN2,id=11,
		 * parentId=10, Detail:], SPOOL6=[Name:SPOOL6,id=5, parentId=9,
		 * Detail:], JOIN1=[Name:JOIN1,id=9, parentId=8, Detail:],
		 * SPOOL5=[Name:SPOOL5,id=4, parentId=7, Detail:],
		 * JOIN0=[Name:JOIN0,id=7, parentId=6, Detail:],
		 * SPOOL4=[Name:SPOOL4,id=2, parentId=11, Detail:],
		 * SPOOL3=[Name:SPOOL3,id=10, parentId=12, Detail:JoinKind:Merge
		 * Join,JoinType:Inner], SPOOL1=[Name:SPOOL1,id=13, parentId=1,
		 * Detail:], SPOOL10=[Name:SPOOL10,id=12, parentId=13, Detail:],
		 * REL1=[Name:REL1,id=3, parentId=5, Detail:] }
		 */

		int num_nodes = v_tree.size(); // 13

		if (num_nodes == 0 || root instanceof TableNode) {
			return root;
		}

		if (root == null) {

			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = v_tree.get(i);
				if (current.getParent() == null) {
					root = v_tree.remove(i);
					break;
				}
			}
			buildTree(root, v_tree);

		} else {

			int id = Integer.parseInt(String.valueOf(root.getNodeID()));
			int chcount = 0;

			// root connection
			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = v_tree.get(i);
				int pid = Integer.parseInt(String
						.valueOf(current.getParentID()));
				if (pid == id) {
					current = v_tree.remove(i);
					num_nodes--;
					i--;
					((OperatorNode) root).setChild(chcount++, current);
				}
			}

			int chnum = ((OperatorNode) root).getChildNumber();
			for (int j = 0; j < chnum; j++) {
				PlanNode tmpnode = ((OperatorNode) root).getChild(j);
				buildTree(tmpnode, v_tree);
			}

		}

		return root; // TODO: return root;

	}

	/**
	 * Gets the table statistics from the DBMS.
	 * 
	 * @param tableName
	 *            The name of the table
	 * @return A TableStatistic Object that contains important information about
	 *         the table statistics.
	 * 
	 *         private TableStatistic getTableStatistics(String tableName) {
	 *         TableStatistic result = new TableStatistic(); ResultSet ts;
	 *         String stats = ""; //try { //Have oracle gather correct
	 *         statistics. //myJDBCWrapper.executeUpdate("ANALYZE TABLE " +
	 *         tableName + " COMPUTE STATISTICS"); //
	 *         myJDBCWrapper.executeUpdate("ANALYZE TABLE " + tableName +
	 *         " COMPUTE STATISTICS"); //} catch (SQLException e1) { //
	 *         Main.defaultLogger
	 *         .logging_error("No statistics computed for table: " + tableName);
	 *         // e1.printStackTrace(); // System.exit(1); //programmer/dbms
	 *         error //} //USER_TABLES is an oracle view which can be queried to
	 *         gather statistics. //stats = //
	 *         "SELECT Blocks, Avg_Row_Len, Num_Rows FROM USER_TABLES WHERE Table_Name = '"
	 *         // + tableName.toUpperCase() // + "'";
	 * 
	 *         stats ="SELECT AVG_ROW_LENGTH, TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '"
	 *         + tableName.toUpperCase() + "'";
	 * 
	 *         try { //retrieving the statistics from the DBMS. ts =
	 *         _statement.executeQuery(stats);
	 * 
	 *         if (ts.next()) { result.numblocks = 0;//ts.getLong(1);
	 *         result.average_row_length = ts.getLong(1); result.num_rows =
	 *         ts.getLong(2); result.tableName = tableName; } else {
	 *         Main.defaultLogger.logging_error("No statistics for table: " +
	 *         tableName); System.exit(1); //programmer/dbms error }
	 *         //ts.getStatement().close(); } catch (SQLException e) {
	 *         e.printStackTrace();
	 *         Main.defaultLogger.logging_error("No statistics for table: " +
	 *         tableName); System.exit(1); //programmer/dbms error }
	 * 
	 *         return result; }
	 */

	public void installExperimentTables(DataDefinition myDataDef,
			String myPrefix) {

		if (Main.verbose)
			Main._logger.outputLog("Installing Tables");

		String[] myTables = myDataDef.getTables();

		if (!isInstalled(myPrefix, myTables)) {
			// initializeSubjectTables(); // do nothing
			for (int i = 0; i < myTables.length; i++) {

				String[] primary = null;
				ForeignKey[] foreign = null;

				// appending the column information to the CREATE TABLE
				// statement.
				String[] columns = myDataDef.getTableColumns(myTables[i]);
				int[] columnDataTypes = new int[columns.length];
				int[] columnDataTypeLengths = new int[columns.length];
				for (int j = 0; j < columns.length; j++) {
					columnDataTypes[j] = myDataDef.getColumnDataType(
							myTables[i], columns[j]);
					columnDataTypeLengths[j] = myDataDef.getColumnDataLength(
							myTables[i], columns[j]);
				}

				// returning the pimary key and foreign key info
				primary = myDataDef.getTablePrimaryKey(myTables[i]);
				foreign = myDataDef.getTableForeignKeys(myTables[i]);

				createTable(myPrefix + myTables[i], columns, columnDataTypes,
						columnDataTypeLengths, primary, foreign);

				 commit();

			}

		}

		 commit();
	}

	/**
	 * Tests to see if the correct tables are installed.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#isInstalled()
	 */
	private boolean isInstalled(String strPrefix, String[] tables) {
		/*
		 * boolean cache = (tableExists(CACHE1_TABLE) &&
		 * tableExists(CACHE2_TABLE)); //boolean plan =
		 * tableExists(QUERY_PLAN_TABLE);
		 * 
		 * for ( int i = 0; i < tables.length; i++ ) { if
		 * (!tableExists(strPrefix + tables[i])) return false; }
		 * 
		 * return cache;
		 */
		return false;
	}

//	/**
//	 * Checks to see if a table exists.
//	 * 
//	 * @see azdblab.labShelf.GeneralDBMS#tableExists(java.lang.String)
//	 */
//	public boolean tableExists(String table) {
//		try {
//			// attempts to create the table. If it fails, the table exists and
//			// an exception will be thrown.
//			_connection.commit();
//			_statement.executeUpdate("CREATE TABLE " + table
//					+ " (Name varchar(1))");
//			_connection.commit();
//			// if the table was created, drop it again.
//			_statement.executeUpdate("DROP TABLE " + table);
//			_connection.commit();
//			return false;
//		} catch (SQLException e) {
//			//e.printStackTrace();
////			Main._logger.outputLog(table + "... exists !! ");
//			try {
//				_connection.commit();
//			} catch (SQLException e1) {
//				// TODO Auto-generated catch block
//				//e1.printStackTrace();
//			}
//			return true;
//		}
//	}

	@Override
	public void flushDBMSCache() {
		/**
		 * http://www.teradataforum.com/teradata/20080126_110753.htm
		 * 
		 * Subj: Re: Flush the cache From: Wu, Judy
		 * 
		 * On the server side, issue the following command on the shell command
		 * prompt. It will flush all kinds of cache. MP-RAS: psh
		 * /tpasw/bin/fsuflusher Windows: psh
		 * d:\progra~1\ncr\tdat\ltdbms\bin\fsuflusher psh "d:\program
		 * files\ncr\tdat\ltdbms\bin\fsuflusher" Linux: psh
		 * /usr/tdbms/bin/fsuflusher
		 * 
		 * Teradata DBS performance. Judy Wu
		 */

		// ssh mjseo@sodb12 '~/tdFlushCrunRemoteFlushCache.exitValue()ache.sh'
		// it connect to teradata virtual machine to run flush cache remotely
		// before this, we should prepare ssh authentication to avoid input
		// password when we
		// trying to do this remotely.
		// http://www.dotkam.com/2009/03/10/run-commands-remotely-via-ssh-with-no-password/

        try {
            Process p = Runtime.getRuntime().exec("/usr/tdbms/bin/fsuflusher");
//            BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
//            String line = null;
//            String result = "";
//            while ((line = in.readLine()) != null) {
//            	result += line;
//            }
//            Main._logger.outputDebug("Result:[" +result + "]");
            p.waitFor();
        }catch(Exception e) {
            e.printStackTrace(); 
        }

	}

	public void flushOSCache() {
		flushLinuxCache();
	}

	/**
	 * @see azdblab.plugins.experimentSubject#flushWindowsMemory()
	 */
	public void flushMemory() {
		// flushLinuxMemory();
	}

	// /**
	// * @see azdblab.labShelf.GeneralDBMS#timeQuery(java.lang.String,
	// * azdblab.dbms.api.PlanTree)
	// */
	// public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan,
	// long cardinality, int time_out) throws SQLException, Exception {
	// PlanNode curr_plan = getQueryPlan(sqlQuery);
	// // verifies that the current query plan is the plan that AZDBLAB thought
	// // it was timing.
	// if (!curr_plan.equals(plan)) {
	// throw new Exception(
	// "timeQuery: detected plan error.  Tried to time different plan from change point plan");
	// }
	//
	// String timedQuerySQL = sqlQuery;
	//
	// // We output the cardinality of the result to force oracle to time the
	// // entire query.
	// // insertPrefix = "SELECT COUNT(*) FROM (";
	//
	// // timedQuerySQL = insertPrefix + sqlQuery + ")";
	// // Main.defaultLogger.logging_normal(timedQuerySQL);
	//
	// // cacheClearSQL = insertPrefix + cacheClearSQL + ")";
	// // Main.defaultLogger.logging_normal(cacheClearSQL);
	//
	// long start_time;
	// long finish_time;
	// long exec_time = 0;
	// String proc_diff = "";
	// // long minimum_execution_time = Long.MAX_VALUE;
	// // long maximum_execution_time = -1;
	// // int count = 10;
	//
	// // long total_exetime = 0;
	//
	// // The query is timed count times. The minimum time is the time that is
	// // returned.
	// /*
	// * for (int i = 0; i < count; i++) { try { PreparedStatement ps =
	// * _connection .prepareStatement(timedQuerySQL);
	// *
	// * PreparedStatement cs = _connection .prepareStatement(cacheClearSQL);
	// * // clear the cache. ResultSet rs; cs.execute(); rs =
	// * cs.getResultSet(); if (rs.next()) { rs.getString(1);
	// * Main._logger.outputLog(cacheClearSQL);
	// Main.defaultLogger.logging_normal(". Row Count: " +
	// * rs.getString(1)); Main.defaultLogger.logging_normal(); } rs.close();
	// *
	// * // execute garbage collection System.gc(); Runtime.getRuntime().gc();
	// *
	// * start_time = System.currentTimeMillis(); ps.execute(); rs =
	// * ps.getResultSet(); if (rs.next()) { rs.getString(1);
	// * Main._logger.outputLog(timedQuerySQL);
	// Main.defaultLogger.logging_normal(". Row Count: " +
	// * rs.getString(1)); Main.defaultLogger.logging_normal(); } rs.close();
	// finish_time =
	// * System.currentTimeMillis(); exec_time = finish_time - start_time;
	// *
	// * total_exetime += exec_time;
	// *
	// * if (exec_time < minimum_execution_time) minimum_execution_time =
	// * exec_time;
	// *
	// * if (exec_time > maximum_execution_time) maximum_execution_time =
	// * exec_time;
	// *
	// *
	// * ps.close(); cs.close();
	// *
	// * } catch (SQLException e) { e.printStackTrace(); throw new
	// * SQLException(cacheClearSQL + "\n" + sqlQuery + "\n" +
	// * e.getMessage()); } }
	// */
	//
	// timeOuter = new TimeoutQueryExecution();
	//
	// Timer timer = new Timer();
	//
	// try {
	//
	// flushCache();
	//
	// // Main.defaultLogger.logging_normal("Finish Flushing Oracle Cache");
	//
	// // flushMemory();
	//
	// teradata_timeOuter = new TimeoutQueryExecutionTeradata();
	//
	// Main._logger.outputLog("Finish Clearing Memory");
	//
	// // query_executor_statement =
	// // _connection.prepareStatement(timedQuerySQL);
	// query_executor_statement = _connection.createStatement();
	// Main._logger.outputLog("Statement has been prepared");
	// Main._logger.outputLog("teradata subject timeout = " + time_out);
	// timer.scheduleAtFixedRate(teradata_timeOuter, time_out, time_out);
	// commit();
	//
	// ProcessTeller process_teller = new ProcessTeller();
	// Main._logger.outputLog("Start Timing query");
	// start_time = System.currentTimeMillis();
	//			
	//			
	// Map<Integer, LinuxProcess> proc_map1 = process_teller.GetProcesses();
	// long num_processes1 = process_teller.GetNumProcesses();
	//		    
	// query_executor_statement.execute(timedQuerySQL);
	//			
	// Map<Integer, LinuxProcess> proc_map2 = process_teller.GetProcesses();
	// long num_processes2 = process_teller.GetNumProcesses();
	//		    
	// finish_time = System.currentTimeMillis();
	// proc_diff = ProcessTeller.ProcessMapDiff(
	// num_processes1, num_processes2, proc_map1, proc_map2);
	// exec_time = finish_time - start_time;
	//
	// // timer.cancel();
	// // mysql_timeOuter.cancel();
	// Main._logger.outputLog("Finishing Timing query");
	// query_executor_statement.close();
	// Main._logger.outputLog("Statement closed");
	// } catch (SQLException e) {
	// e.printStackTrace();
	// // throw new SQLException(cacheClearSQL + "\n" + sqlQuery + "\n"
	// // + e.getMessage());
	// Main._logger.outputLog("Failed to time the query within timeOut");
	// exec_time = Constants.MAX_EXECUTIONTIME;
	// }
	//
	// if (Main.verbose) {
	// Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
	// }
	// timer.cancel();
	// teradata_timeOuter.cancel();
	//
	// // return new QueryStat(minimum_execution_time);
	// return new QueryExecutionStat(exec_time, proc_diff);
	//
	// }

	public String getDBVersion() {
		/*
		 * @mjseo get DBMS Version Query: select INFODATA from dbc.dbcinfo where
		 * INFOKEY='VERSION'; Result may looks like: InfoData ---------
		 * 13.10.00.05
		 */
		try {
			ResultSet rs = _statement
					.executeQuery("select INFODATA from dbc.dbcinfo where INFOKEY='VERSION'");
			if (rs != null) {
				rs.next();
			}
			return rs.getString(1);
		} catch (SQLException e) {
			return null;
		}
	}

	public String[] getPlanProperties() {
		return PLAN_PROPERTIES;
	}

	public String[] getPlanOperators() {
		return PLAN_OPERATORS;
	}

	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}

	public void setOptimizerFeature(String featureName, String featureValue) {

	}

	public void flushCache() {
		// Main.defaultLogger.logging_normal("Warning: Flushing mysql cache is not valid now");
	}

	private static final String BLOB = "BLOB";

	/**
	 * An array of column names for the table PLAN_TABLE in Oracle. public
	 * static final String[] PLAN_TABLE_COLUMNS = new String[] { "STATEMENT_ID",
	 * "TIMESTAMP", "REMARKS", "OPERATION", "OPTIONS", "OBJECT_NODE",
	 * "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_INSTANCE", "OBJECT_TYPE",
	 * "OPTIMIZER", "SEARCH_COLUMNS", "ID", "PARENT_ID", "POSITION", "COST",
	 * "CARDINALITY", "BYTES", "OTHER_TAG", "PARTITION_START", "PARTITION_STOP",
	 * "PARTITION_ID", "OTHER", "DISTRIBUTION" };
	 */

	/**
	 * An array of operators specified in Oracle DBMS
	 */
	public static final String[] PLAN_OPERATORS = new String[] { "MYSQL HASH JOIN" };

	/**
	 * An array of column names for the Description of Plans in MySQL.
	 */
	public static final String[] PLAN_DETAIL_FIELDS = new String[] {
			"STATEMENTID", "ID", "PARENT_ID",
			"POSITION",
			// THE ABOVE 3 ATTRIBUTES ARE NOT INCLUDED IN THE RESULT OF MYSQL.
			// BUT ADDED HERE FOR CREATING PROPER PLAN_TREE.
			"SELECT_TYPE", "OBJECT_NAME", "OPERATION", "POSSIBLE_KEYS",
			"KEY_NAME", "KEY_LEN", "REF", "ROWS", "EXTRA", "OBJECT_TYPE" };

	public static final String[] PLAN_PROPERTIES = new String[] {
			"STATEMENTID", "SELECT_TYPE", "POSSIBLE_KEYS", "KEY_NAME",
			"KEY_LEN", "REF", "ROWS", "EXTRA" };

	/**
	 * The name of the table that stores which tables have been created by
	 * AZDBLab.
	 */
	// private static final String EXPERIMENT_RECORD_TABLE =
	// AZDBLab.TABLE_PREFIX + "TABLE_RECORD";

	/**
	 * The name of the data type to store integer numbers in Oracle.
	 */
	// private static final String NUMBER = "NUMBER";
	private static final String NUMBER = "DECIMAL";

	/**
	 * The name of the character data type for ORACLE.
	 */
	// private static final String VARCHAR = "VARCHAR2";
	private static final String VARCHAR = "VARCHAR";

	private static final String DBMS_DRIVER_CLASS_NAME = "com.teradata.jdbc.TeraDriver";

	public static final String DBMS_NAME = "Teradata";

	@Override
	public void deleteRows(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// TODO Auto-generated method stub

	}

	@Override
	public ResultSet executeQuerySQL(String sql){
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ResultSet executeSimpleOrderedQuery(String tableName,
			String[] selectColumns, int indexOfOrderedColumn,
			int orderedDataType, String[] columnNames, String[] columnValues,
			int[] columnDataTypes) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ResultSet executeSimpleQuery(String tableName,
			String[] selectColumns, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void executeUpdateSQL(String sql){
	}

	@Override
	public void executeDeleteSQL(String sql) throws SQLException {
		// TODO Auto-generated method stub
		_statement.executeUpdate(sql);
		commit();
	}

	// public static final String[] PLAN_TABLE_COLUMNS = new String[] {
	// "ID",
	// "PARID",
	// "NODE_ORDER",
	// "OBJECT_NAME",
	// "OPERATION",
	// "OBJECT_TYPE",
	// "TOTAL_COST",
	// "IO_COST",
	// "CPU_COST",
	// "FIRST_ROW_COST",
	// "RE_TOTAL_COST",
	// "RE_IO_COST",
	// "RE_CPU_COST",
	// "COMM_COST",
	// "FIRST_COMM_COST",
	// "BUFFER_COST",
	// "REMOTE_TOTAL_COST",
	// "REMOTE_COMM_COST",
	// "STREAM_COST"};
	//	
	// private final String CREATE_PLAN_TABLE = "CREATE TABLE "
	// + QUERY_PLAN_TABLE + " ("
	// + PLAN_TABLE_COLUMNS[0] + " INTEGER 	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[1] + " INTEGER 	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[2] + " INTEGER 	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[3] + " VARCHAR(128)   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[4] + " VARCHAR(128)   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[5] + " VARCHAR(128)   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[6] + " INTEGER 	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[7] + " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[8] + " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[9] + " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[10]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[11]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[12]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[13]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[14]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[15]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[16]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[17]+ " DOUBLE 	   	   NOT NULL,"
	// + PLAN_TABLE_COLUMNS[18]+ " INTEGER	   	   NOT NULL"
	// + ")";
	//	
	@Override
	public void initializeSubjectTables() {
		Main._logger.outputLog("Install subject (plan) tables ...");
		// // delete all rows in EXPLAIN_INSTANCE table
		// String explain_inst_tbl = "EXPLAIN_INSTANCE";
		// String empty_table = "DELETE FROM " + strUserName + "." +
		// explain_inst_tbl;
		// try { //remove old query plan
		// _statement.executeUpdate(empty_table);
		// }catch (SQLException e1) {
		// //e1.printStackTrace(); //TODO:
		// }
		// if(tableExists(QUERY_PLAN_TABLE)){
		// dropTable(QUERY_PLAN_TABLE);
		// }
		// try {
		// // create a new plan table
		// Main._logger.outputLog(CREATE_PLAN_TABLE);
		// _statement.executeUpdate(CREATE_PLAN_TABLE);
		// }catch (SQLException e1) {
		// e1.printStackTrace();
		// }
		Main._logger.outputLog("... done!! ");
	}

	@Override
	public void disableAutoStatUpdate() {
		// // TODO Auto-generated method stub
		// boolean fail = false;
		// //Main.defaultLogger.logging_normal(">>> Disabling auto Stat update ... ");
		// // TODO Auto-generated method stub
		// String strStatUpdateSQL = "SET GLOBAL innodb_stats_on_metadata=OFF";
		// try {
		// //attempts to create the table. If it fails, the table exists and an
		// exception will be thrown.
		// _statement.executeUpdate(strStatUpdateSQL);
		// //if the table was created, drop it again.
		// } catch (SQLException e) {
		// Main.defaultLogger.logging_error("Turning off the update demon error: '"
		// +
		// strStatUpdateSQL + "'" );
		// e.printStackTrace();
		// fail = true;
		// }
		// if(!fail) Main.defaultLogger.logging_normal("<<<< Success! ");
	}

	@Override
	public void enableAutoStatUpdate() {
		// // TODO Auto-generated method stub
		// boolean fail = false;
		// //Main.defaultLogger.logging_normal(">>> Enabling auto Stat update ... ");
		// // TODO Auto-generated method stub
		// String strStatUpdateSQL = "SET GLOBAL innodb_stats_on_metadata=ON";
		// try {
		// //attempts to create the table. If it fails, the table exists and an
		// exception will be thrown.
		// _statement.executeUpdate(strStatUpdateSQL);
		// //if the table was created, drop it again.
		// } catch (SQLException e) {
		// Main.defaultLogger.logging_error("Turning on the update demon error: '"
		// +
		// strStatUpdateSQL + "'" );
		// e.printStackTrace();
		// fail = true;
		// }
		// if(!fail) Main.defaultLogger.logging_normal("<<<< Success! ");
	}

	@Override
	public int getTableCardinality(String tableName) {
		int res = 0;
		String countSQL = "SELECT count(*) " + "FROM " + tableName;
		try {
			ResultSet cs = _statement.executeQuery(countSQL);
			if (cs.next()) {
				res = cs.getInt(1);
			}
			cs.close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main._logger.reportError("exception-No statistics for table: "
					+ tableName);
			System.exit(1); // programmer/dbms error
		}
		return res;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
	private static final int teradata_batch_size = 10000;  
	protected String getDBMS() {
		return DBMS_NAME;
	}


	public void SetConnection(Connection conn) {
		_connection = conn;
	}

//	@Override
//	public void updateTableStatistics(Table table) throws Exception {
//		String templateSQL = "collect stats on " + table.table_name_with_prefix;
//
//		for (int i = 0; i < table.columns.length; i++) {
//			String updateSQL = templateSQL + " column ("
//					+ table.columns[i].myName + ")";
//Main._logger.writeIntoLog(updateSQL);
//			try {
//				_statement.executeUpdate(updateSQL);
//				commit();
//			} catch (SQLException e) {
//				Main._logger.reportError(e.getMessage());
//				Main._logger.reportError("exception-No statistics for table: "
//						+ table.table_name_with_prefix);
////				System.exit(1); // programmer/dbms error
//				throw new Exception("Statistics update error");
//			}
////			Main._logger.outputLog("stat collection on "
////					+ table.columns[i].myName + " is done.");
//		}
//	}
	/*****
	 * Young modified the function to change the stat method
	 */
	@Override
	public void updateTableStatistics(Table table) throws Exception {
		String templateSQL = "COLLECT STATS USING SYSTEM SAMPLE COLUMN ";
		for (int i = 0; i < table.columns.length; i++) {
			String updateSQL = templateSQL + table.columns[i].myName + " on " + table.table_name_with_prefix; 
Main._logger.writeIntoLog(updateSQL);
			try {
				_statement.executeUpdate(updateSQL);
				commit();
			} catch (SQLException e) {
				Main._logger.reportError(e.getMessage());
				Main._logger.reportError("exception-No statistics for table: "
						+ table.table_name_with_prefix);
//				System.exit(1); // programmer/dbms error
				throw new Exception("Statistics update error");
			}
//			Main._logger.outputLog("stat collection on "
//					+ table.columns[i].myName + " is done.");
		}
	}
}
