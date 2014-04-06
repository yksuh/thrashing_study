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
package plugins.unit_testing;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

class TeradataQryPlan {
	private String filename;

	public String getFilename() {
		return filename;
	}

	DocumentBuilderFactory dbf;
	DocumentBuilder db;
	Document doc;
	Node root;

	String QCFCaptureTimestamp = null;

	public String getQCFCaptureTimestamp() {
		// Lazy initialization
		if (QCFCaptureTimestamp == null) {
			QCFCaptureTimestamp = doc.getElementsByTagName("Query").item(0)
					.getAttributes().getNamedItem("QCFCaptureTimestamp")
					.getNodeValue();
		}
		return QCFCaptureTimestamp;
	}

	String DefaultDatabase = null;

	public String getDefaultDatabase() {
		if (DefaultDatabase == null) {
			DefaultDatabase = doc.getElementsByTagName("Request").item(0)
					.getAttributes().getNamedItem("DefaultDatabase")
					.getNodeValue();

		}
		return DefaultDatabase;
	}

	String QueryText = null;

	public String getQueryText() {
		if (QueryText == null) {
			QueryText = doc.getElementsByTagName("Request").item(0)
					.getAttributes().getNamedItem("QueryText").getNodeValue();
		}
		return QueryText;
	}

	public Node getRoot() {
		return root;
	}

	public String getRootNodeName() {
		return root.getNodeName();
	}

	enum RefType { Relation, Spool, Wrong };
	static class SourceAccess {
		
		
		String refName;
		RefType refType =RefType.Wrong ;
		
		public String toString() {
			return String.format("[SourceAccess]:refName:%s , Type:%s", 
					refName, refType.toString());
		}

	}

	static class TargetStore {
		String refName;
		RefType refType = RefType.Wrong;
		String SortKey;

		@Override
		public String toString() {
			return String.format("[TargetStore]:refName:%s, refType:%s SortKey:%s", 
					refName, refType, SortKey);
		}
	}

	static class PlanStep {
		String QCFParallelKind;
		String QCFStepKind;
		String QCFStepNum;
		String StepLev1Num;
		ArrayList<SourceAccess> SourceAccess;
		ArrayList<TargetStore> TargetStore;
		
		String PredicateKind = "";
		String JoinKind = "";
		String JoinType = "";
		
		HashMap<String, String> OptStepEst;

		public PlanStep() {
			SourceAccess = new ArrayList<TeradataQryPlan.SourceAccess>();
			TargetStore = new ArrayList<TeradataQryPlan.TargetStore>();
			OptStepEst = new HashMap<String, String>();
		}
		public boolean isSourceAccessExist() {
			return ( SourceAccess.size() > 0 ) ? true : false;
		}
		public boolean isTargetStoreExist() {
			return ( SourceAccess.size() > 0 ) ? true : false;
		}
		@Override
		public String toString() {
			return "Plan["+ StepLev1Num + "]\n" 
					+ "QCFParallelKind:" + QCFParallelKind + " " + "QCFStepKind:"
					+ QCFStepKind + " " + "QCFStepNum:" + QCFStepNum + " "
					+ "StepLev1Num:" + StepLev1Num+ "\n"
					+ "" + SourceAccess + "\n"
					+ "" + TargetStore + "\n"
					+ "" + PredicateKind + "\n"
					+ "" + JoinKind + "\n"
					+ "" + JoinType + "\n"
					+ "" + OptStepEst + "\n"
					;
		}
	}

	HashMap<String, String> relations = new HashMap<String, String>();
	HashMap<String, HashMap<String,String>> spools = new HashMap<String, HashMap<String,String>>();
	
	
	public void getRelations() {
		NodeList Relation_Element = doc.getElementsByTagName("Relation");
		
		for(int i = 0 ; i < Relation_Element.getLength(); i++) {
			NamedNodeMap attrs = Relation_Element.item(i).getAttributes();
			String ID = attrs.getNamedItem("Id").getNodeValue();
			String tablename= attrs.getNamedItem("TableName").getNodeValue();
			relations.put(ID, tablename);
			//System.out.println(v);
		}
		NodeList Spool_Element = doc.getElementsByTagName("Spool");
		
		for(int i = 0 ; i < Spool_Element.getLength(); i++) {
			NamedNodeMap attrs = Spool_Element.item(i).getAttributes();
			String ID = attrs.getNamedItem("Id").getNodeValue();
			String Cardinality=attrs.getNamedItem("Cardinality").getNodeValue();
			String SpoolSize=attrs.getNamedItem("SpoolSize").getNodeValue();
			HashMap<String, String> info = new HashMap<String, String>();
			info.put("Cardinality", Cardinality);
			info.put("SpoolSize", SpoolSize);
			spools.put(ID, info);
		}
		System.out.println(relations);
		System.out.println(spools);
	
	
	}
	
	
	void printPlanNode() {
//		PlanNode root = new PlanNode("root");
//		PlanNode pn1 = new PlanNode("pn1");
//		PlanNode pn2 = new PlanNode("pn2");
//		PlanNode pn3 = new PlanNode("pn3");
//
//		PlanNode pn4 = new PlanNode("pn4");
//		PlanNode pn5 = new PlanNode("pn5");
//		PlanNode pn6 = new PlanNode("pn6");
//		
//		
//		System.err.println(nodeList);
//								
//		pn1.setParent("root");
//		pn2.setParent("root");
//		pn3.setParent("pn1");
//		
//		pn4.setParent("pn2");
//		pn5.setParent("pn2");
//		pn6.setParent("pn2");
//		
//		//root.traverseHere();
//		getPlanNode("root").traverseHere();
		
		
	}
	HashMap<String,PlanNode> nodeList = new HashMap<String, PlanNode>();
	PlanNode getPlanNode(String name) {
		return nodeList.get(name);
	}
	void debugNodeList(String memo) {
		System.err.println("[" + memo + "]" + nodeList);
	}
	class PlanNode {
		ArrayList<PlanNode> children = new ArrayList<PlanNode>();
		PlanNode parent = null;
		String name;
		public PlanNode(String name) {
			nodeList.put(name, this);
			this.name = name;
		}
		void addChild(String name, PlanNode node) {
			System.err.println("addChild");
			this.children.add(node);
			nodeList.put(name, node);
		}
		void setParent(String name) {
			System.err.println("setParent");
			PlanNode n = nodeList.get(name);
			this.parent = n;
			n.addChild(this.name, this);
		}
		void setParent(PlanNode node) {
			System.err.println("setParentbyNode");
			this.parent = node;
			node.addChild(this.name, this);
		}
		void info() {
			System.out.println();
			System.out.println("Name:" + this.name);
			System.out.println("Parent:" + ((parent==null) ? "NONE" : this.parent.name) );
			System.out.println("Children:" + this.children);
		}
		/*
		 * inorder(node)
			  if node = null then return
			  inorder(node.left)
			  print node.value
			  inorder(node.right)
		 */
		void traverseHere() {
			System.err.println("{In Traversing:"+ this.name +"}");
			for(int i = 0 ; i < this.children.size(); i++) {
				System.out.println("[TV]"+this.children.get(i).name);
				this.children.get(i).traverseHere();
			}
			
		}
		
	}
	
	public void getPlans() {
		PlanNode root = new PlanNode("root");
		
		NodeList planlist = doc.getElementsByTagName("PlanStep");
		ArrayList<PlanStep> steps = new ArrayList<TeradataQryPlan.PlanStep>();

		for (int i = 0; i < planlist.getLength(); i++) {
			// planlist.item(i) --> planstep i
			PlanStep step = new PlanStep();
			step.QCFParallelKind = planlist.item(i).getAttributes()
					.getNamedItem("QCFParallelKind").getNodeValue();
			step.QCFStepKind = planlist.item(i).getAttributes()
					.getNamedItem("QCFStepKind").getNodeValue();
			step.QCFStepNum = planlist.item(i).getAttributes()
					.getNamedItem("QCFStepNum").getNodeValue();
			step.StepLev1Num = planlist.item(i).getAttributes()
					.getNamedItem("StepLev1Num").getNodeValue();

			for (int j = 0; j < planlist.item(i).getChildNodes().getLength(); j++) {
				
				
				
				Node tempnode = planlist.item(i).getChildNodes().item(j);
				String nodeName = tempnode.getNodeName();
				// Check Node Type
				// -->SourceAccess
				if (nodeName.equals("SourceAccess")) {
					SourceAccess sa = new SourceAccess();

					NodeList cNodes = tempnode.getChildNodes();
					for (int k = 0, numchild = cNodes.getLength(); k < numchild; k++) {
						Node Child = cNodes.item(k);
						String ChildName = Child.getNodeName();
						if (ChildName.equals("RelationRef")) {
							//System.err.printf("[DEBUG(RelationRef):]");
							NamedNodeMap attr = Child.getAttributes();
							String attrval = attr.getNamedItem("Ref")
									.getNodeValue();
							sa.refName = attrval;
							sa.refType = RefType.Relation;

						} else if (ChildName.equals("SpoolRef")) {
							//System.err.printf("[DEBUG(SpoolRef):]");
							NamedNodeMap attr = Child.getAttributes();
							String attrval = attr.getNamedItem("Ref")
									.getNodeValue();
							sa.refName = attrval;
							sa.refType = RefType.Spool;
						}

					}
					step.SourceAccess.add(sa);
					//System.err.println(sa);
				}
				// -->TargetStore
				else if (nodeName.equals("TargetStore")) {
					TargetStore ts = new TargetStore();

					NodeList cNodes = tempnode.getChildNodes();
					for (int k = 0, numchild = cNodes.getLength(); k < numchild; k++) {
						Node Child = cNodes.item(k);
						String ChildName = Child.getNodeName();
						if (ChildName.equals("SpoolRef")) {
							//System.err.printf("[DEBUG(SpoolRef):]");
							NamedNodeMap attr = Child.getAttributes();
							String attrval = attr.getNamedItem("Ref")
									.getNodeValue();
							ts.refName = attrval;
							ts.refType = RefType.Spool;
						}

					}
					step.TargetStore.add(ts);
					
					//System.err.println();

				}
				// -->OptStepEst
				else if (nodeName.equals("OptStepEst")) {
					// getting attr
					for (int k = 0, numAttr = tempnode.getAttributes()
							.getLength(); k < numAttr; k++) {
						String key = tempnode.getAttributes().item(k)
								.getNodeName();
						String value = tempnode.getAttributes().item(k)
								.getNodeValue();
						step.OptStepEst.put(key, value);
					}
					//System.err.printf("[DEBUG(OptStepEst):]");
					System.out.println(step.OptStepEst);
				}
				// -->AmpStepUsage
				else if (nodeName.equals("AmpStepUsage")) {

				}
				else if (nodeName.equals("Predicate")) {
					
					NamedNodeMap attrs = tempnode.getAttributes();
					String PredicateKind = attrs.getNamedItem("PredicateKind").getNodeValue();
					if( PredicateKind.equals("Join"))
						step.PredicateKind = PredicateKind;
					else {
						step.PredicateKind = "NoJoin";
						step.JoinKind = "";
						step.JoinType = "";
					}
					
				}
				else if (nodeName.equals("StepDetails")) {
					NodeList cNodes = tempnode.getChildNodes();
					for(int k = 0; k < cNodes.getLength(); k++) {
						if(cNodes.item(k).getNodeName().equals("JIN")) {
							Node JIN_Node = cNodes.item(k);
							NamedNodeMap attrs = JIN_Node.getAttributes();
							step.JoinKind = attrs.getNamedItem("JoinKind").getNodeValue();
							step.JoinType = attrs.getNamedItem("JoinType").getNodeValue();
							
						}
					}
				}
				else if (tempnode.getNodeType() == Node.ELEMENT_NODE) {
					System.out.println("-->" + tempnode.getNodeName());
				}
			}

			//System.out.println(step);
			steps.add(step);
		}
		
		PlanNode target = null;
		String targetRefName = null;
		
		for(PlanStep p: steps) {
			System.err.println(p);
			
			
			if( p.isTargetStoreExist() ) {
				targetRefName = p.TargetStore.get(0).refName;
				target = new PlanNode(targetRefName);
				
				if(getPlanNode(targetRefName) == null) {
					// conn to root
					target.setParent("root");
					debugNodeList("added to root");
				}
				else {
					target.setParent(targetRefName);
					debugNodeList("added to target");
				}		
			}
			if (target != null) {
				for(int i = 0, size = p.SourceAccess.size()
						; i < size  ; i++) {
					String refName = p.SourceAccess.get(i).refName;
					PlanNode source = new PlanNode(refName);
					source.setParent("root");
				}
			}
			System.err.println("target Traverse Here");
				
			
		}

		root.traverseHere();
		

	}

	public TeradataQryPlan(String filename)
			throws ParserConfigurationException, SAXException, IOException {
		dbf = DocumentBuilderFactory.newInstance();
		db = dbf.newDocumentBuilder();
		// Parsing
		doc = db.parse(filename);
		// Nomalize
		doc.getDocumentElement().normalize();
		root = doc.getDocumentElement();
		this.filename = filename;
	}

	public void test() {
		System.out.println("file:" + getFilename());
		System.out.println("root n name:" + getRootNodeName());
		System.out.println("TS:" + getQCFCaptureTimestamp());
		System.out.println("DefaultDB:" + getDefaultDatabase());
		System.out.println("QueryText:" + getQueryText());
		getPlans();
		config();
		System.out.println(configuration.toString());
		getRelations();
	}

	HashMap<String, String> configuration = new HashMap<String, String>();

	public void config() {
		Node config = doc.getElementsByTagName("Configuration").item(0);
		for (int i = 0; i < config.getAttributes().getLength(); i++) {
			String attrName = config.getAttributes().item(i).getNodeName();
			String attrValue = config.getAttributes().item(i).getNodeValue();

			configuration.put(attrName, attrValue);
			// System.out.println(config.getAttributes().item(i).getNodeName());
		}
	}

}

public class TeradataResultXML2 {
	public static final String FILENAME = "./plugins/plugins/unit_testing/result.xml";

	public static void main(String[] args) {
		try {
			System.out.println("Begin Experiment");
			TeradataQryPlan tqp1 = new TeradataQryPlan(
					"/home/mjseo/QryPlanXML_1.xml");
			tqp1.test();
			System.err.printf("=================================\n");
			TeradataQryPlan tqp3 = new TeradataQryPlan(
					"/home/mjseo/result2.xml");
			tqp3.test();
			
			
			//System.err.printf("=================================\n");
			//TeradataQryPlan tqp2 = new TeradataQryPlan(FILENAME);
			//tqp2.test();
			// do result2
			
			
			// For Tree
			//TeradataQryPlan tqp1 = new TeradataQryPlan(
			//"/home/mjseo/QryPlanXML_1.xml");
			
			tqp1.printPlanNode();
			
			

		} catch (ParserConfigurationException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (SAXException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			/*
			 * File file = new File(FILENAME);
			 * 
			 * DocumentBuilderFactory dbf =
			 * DocumentBuilderFactory.newInstance(); DocumentBuilder db =
			 * dbf.newDocumentBuilder(); // Parsing Document doc =
			 * db.parse(file); // Nomalize doc.getDocumentElement().normalize();
			 * // printout root element System.out.println("Root element " +
			 * doc.getDocumentElement().getNodeName());
			 */

			// Find Plans Node List
			/*
			 * NodeList nodeLst = doc.getElementsByTagName("Plan");
			 * System.out.println(nodeLst.getLength());
			 * 
			 * Node planNode = nodeLst.item(0); NamedNodeMap n =
			 * planNode.getAttributes(); Node n1 = n.getNamedItem("NumSteps");
			 * String value = n1.getNodeValue(); System.out.println(value);
			 */

			/*
			 * System.out.println("Information of all Plans");
			 * 
			 * for (int s = 0; s < nodeLst.getLength(); s++) {
			 * 
			 * Node fstNode = nodeLst.item(s);
			 * 
			 * if (fstNode.getNodeType() == Node.ELEMENT_NODE) {
			 * 
			 * Element fstElmnt = (Element) fstNode; NodeList fstNmElmntLst =
			 * fstElmnt .getElementsByTagName("firstname"); Element fstNmElmnt =
			 * (Element) fstNmElmntLst.item(0); NodeList fstNm =
			 * fstNmElmnt.getChildNodes(); System.out.println("First Name : " +
			 * ((Node) fstNm.item(0)).getNodeValue()); NodeList lstNmElmntLst =
			 * fstElmnt .getElementsByTagName("lastname"); Element lstNmElmnt =
			 * (Element) lstNmElmntLst.item(0); NodeList lstNm =
			 * lstNmElmnt.getChildNodes(); System.out.println("Last Name : " +
			 * ((Node) lstNm.item(0)).getNodeValue()); }
			 * 
			 * }
			 */
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
