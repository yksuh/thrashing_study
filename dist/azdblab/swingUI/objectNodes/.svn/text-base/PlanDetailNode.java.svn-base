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
package azdblab.swingUI.objectNodes;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.swing.JOptionPane;
import javax.swing.JPanel;

import azdblab.Constants;
import salvo.jesus.graph.DirectedEdgeImpl;
import salvo.jesus.graph.Edge;
import salvo.jesus.graph.Tree;
import salvo.jesus.graph.TreeImpl;
import salvo.jesus.graph.VertexImpl;
import salvo.jesus.graph.visual.GraphScrollPane;
import salvo.jesus.graph.visual.VisualEdge;
import salvo.jesus.graph.visual.VisualGraph;
import salvo.jesus.graph.visual.VisualVertex;
import salvo.jesus.graph.visual.layout.LayeredTreeLayout;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableNode;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;
import java.sql.SQLException;

/**
 * The data module for each user object. Used in creating the views for user in
 * the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class PlanDetailNode extends ObjectNode {

	/**
	 * Associates a query PlanNode with a Vertex in the graph.
	 * 
	 * @author Kevan Holdaway
	 */
	private class VertexWrapper {
		// ~ Constructors
		// ·······················································

		/**
		 * Associates a query PlanNode with a Vertex in the graph.
		 * 
		 * @param v
		 *            The vertex that corresponds to this PlanNode.
		 * @param n
		 *            The PlanNode that corresponds to this vertex.
		 */
		public VertexWrapper(VertexImpl v, PlanNode n) {
			_v = v;
			_n = n;
		}

		// ~ Instance fields
		// ····················································

		/** The PlanNode that corresponds to this vertex. */
		public PlanNode _n;

		/** The Vertext that corresponds to this PlanNode. */
		public VertexImpl _v;
	}

	/**
	 * This class allows a user to click on a step in the plan query graph and
	 * to view the other information about the query plan step. This information
	 * is DBMS specific.
	 * 
	 * @author Kevan Holdaway
	 */
	private class OtherInformationMouseAdapter extends MouseAdapter {
		// ~ Constructors
		// ·······················································

		/**
		 * Creates an Adapter for the event mouse clicked.
		 * 
		 * @param info
		 *            The other information that will be displayed in a small
		 *            popup dialog window when the mouse is clicked on a node.
		 */
		public OtherInformationMouseAdapter(String info, String title) {
			_info = info;
			_title = title;
		}

		// ~ Methods
		// ····························································

		/**
		 * @see java.awt.event.MouseListener#mouseClicked(java.awt.event.MouseEvent)
		 */
		public void mouseClicked(MouseEvent e) {
			JOptionPane.showMessageDialog(null, _info, _title,
					JOptionPane.INFORMATION_MESSAGE);
		}

		// ~ Instance fields
		// ····················································

		/**
		 * The other information that will be displayed in a small popup dialog
		 * window when the mouse is clicked on a node.
		 */
		private String _info;
		private String _title;
	}

	private String strUserName;
	private String strNotebookName;
	private String strExpName;
	// private String strScenario;
	private String strStartTime;
	private int iQueryNum;
	private int queryExecutionNum;
	private int iPlanNum;
	private String myPlanID;

	/**
	 * Creates an experiment result.
	 * 
	 * @param result
	 *            The result of the test.
	 * @param number_queries
	 *            The number of queries that the test contains.
	 */
	public PlanDetailNode(
			// InternalDatabaseController dbController,
			String user_name, String notebook_name, String exp_name,
			// String scenario,
			String startTime, int query_num, int chpnt_num, int plan_num,
			String plan_ID) {

		// AZDBLab.OPTIMAL_CHANGE_POINT_NUMBER,

		// myDBController = dbController;
		strUserName = user_name;
		strNotebookName = notebook_name;
		strExpName = exp_name;
		// strScenario = scenario;
		strStartTime = startTime;
		iQueryNum = query_num;
		queryExecutionNum = chpnt_num;
		iPlanNum = plan_num;
		willHaveChildren = false;
		strNodeName = "Plan # " + iPlanNum + "";
		myPlanID = plan_ID;
		// if (plan_num == 0) {
		// strNodeName += " (Optimal)";
		// }

		// Allocating space to store all of the query results.
		// myQueryResults = new QueryResult[number_queries];
	}

	// ~ Instance fields
	// ····················································

	/** The result XML of the test. */
	// public JComponentWrapper myTestResult;

	/** The query results stored in QueryResult objects. */
	// public QueryResult[] myQueryResults;

	public String getIconResource(boolean open) {
		return (Constants.DIRECTORY_IMAGE_LFHNODES + "plan.png");
	}

	/**
	 * 
	 * @return the plan ID of the relevent queryPlan
	 */
	public String getPlanID() {
		return myPlanID;
	}

	private JPanel createPlanDetailPanel() {

		try {
			// Info Section
			String info = "";
			info += "<HTML><BODY><CENTER><h1>";
			info += "";
			info += "</h1></CENTER> <font color='blue'>";
			info += "</font></BODY></HTML>";

			PlanNode rootNode = User.getUser(strUserName).getNotebook(
					strNotebookName).getExperiment(strExpName).getRun(
					strStartTime).getQuery(iQueryNum)
					.getPlan(queryExecutionNum);

			int queryid = User.getUser(strUserName)
					.getNotebook(strNotebookName).getExperiment(strExpName)
					.getRun(strStartTime).getQuery(iQueryNum).getQueryID();
			if (rootNode == null) {
				System.err.println("the root node is null");
				return null;
			}
			User.getUser(strUserName).getNotebook(strNotebookName)
					.getExperiment(strExpName).getRun(strStartTime).getQuery(
							iQueryNum).restoreCostEstimateForPlanOperator(
							queryid, queryExecutionNum, rootNode);

			NodePanel npl_planDetailPanel = new NodePanel();
			npl_planDetailPanel.addComponentToTabLight("Plan Tree View",
					new GraphScrollPane(createPlanTree(rootNode)));
			npl_planDetailPanel.addComponentToTabLight(
					"Extended Plan Tree View", new GraphScrollPane(
							createExtendedPlanTree(rootNode)));
			npl_planDetailPanel.addComponentToTabLight(
					"Really Extended Plan Tree View", new GraphScrollPane(
							createReallyExtendedPlanTree(rootNode)));
			return npl_planDetailPanel;
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			// return new JComponentWrapper(new JPanel(), "NOT AVAILABLE",
			// JComponentWrapper.PANEL_TYPE_PANE);
			return new JPanel();
		} catch (Exception ex) {
			ex.printStackTrace();
			// return new JComponentWrapper(new JPanel(), "NOT AVAILABLE",
			// JComponentWrapper.PANEL_TYPE_PANE);
			return new JPanel();
		}
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Plan Detail Node");

		return createPlanDetailPanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	private void buildTree(PlanNode node, Tree tree,
			HashMap<Object, VertexWrapper> verticies) throws Exception {

		// Vector sorted = new Vector();
		// inserting the root into the sorted list first.

		VertexImpl v = new VertexImpl(String.valueOf(node.getNodeID())); // not
		// putting this for other nodes to use as parent
		VertexWrapper w = new VertexWrapper(v, node);
		verticies.put(String.valueOf(node.getNodeID()), w);

		// getting this nodes parent

		int PID = -1;

		Object pnt_id = String.valueOf(node.getParentID());

		if (pnt_id != null) {
			PID = Integer.parseInt(pnt_id.toString());
		}

		Object o = verticies.get(String.valueOf(PID));

		/*
		 * VertexImpl v = new VertexImpl(String.valueOf(node.getNodeID())); //
		 * not // putting this for other nodes to use as parent VertexWrapper w
		 * = new VertexWrapper(v, node);
		 * verticies.put(String.valueOf(node.getNodeID()), w);
		 * 
		 * // getting this nodes parent Object o =
		 * verticies.get(String.valueOf(node.getParentID()));
		 */

		// root node won't have a parent, so o will be null
		if (o != null) {
			w = (VertexWrapper) o;

			VertexImpl parent = w._v;

			// creating an edge from parent to child
			Edge e = new DirectedEdgeImpl(parent, v);

			// allows use to remove edge label later
			e.setFollowVertexLabel(false);

			// adding edge to tree
			tree.addEdge(e);
		}

		if (node instanceof TableNode) {

			if (o == null) { // this plan only contains a single table
				tree.add(v);
			}
			return;

		} else if (node instanceof OperatorNode) {
			int chnum = ((OperatorNode) node).getChildNumber();
			for (int j = 0; j < chnum; j++) {
				PlanNode tmpnode = ((OperatorNode) node).getChild(j);
				buildTree(tmpnode, tree, verticies);
			}

		}
	}

	private VisualGraph createPlanTree(PlanNode p) throws Exception {

		HashMap<Object, VertexWrapper> verticies = new HashMap<Object, VertexWrapper>();
		Tree g = new TreeImpl();

		buildTree(p, g, verticies);

		VisualGraph vg = new VisualGraph(g);
		List<VisualEdge> edges = vg.getVisualEdges();

		// Setting all the edge labels to the empty string.
		for (int i = 0; i < edges.size(); i++) {
			VisualEdge e = (VisualEdge) edges.get(i);
			e.setLabel("");
		}

		// Setting the vertex labels to match the plan node operation name.
		List<VisualVertex> visualVerticies = vg.getVisualVertices();

		for (int i = 0; i < visualVerticies.size(); i++) {
			VisualVertex vv = (VisualVertex) visualVerticies.get(i);
			String node_id = vv.getLabel();
			VertexWrapper vWrapper = (VertexWrapper) verticies.get(node_id);
			PlanNode currNode = vWrapper._n;

			if (currNode instanceof OperatorNode) {
				vv.getVertex().setLabel(
						((OperatorNode) currNode).getOperatorName()); // .getOperationName());
			} else if (currNode instanceof TableNode) {
				vv.getVertex().setLabel(((TableNode) currNode).getTableName()); // .getOperationName());
			}

			vv.addMouseListener(new OtherInformationMouseAdapter(String
					.valueOf(currNode.getProperties()),
					"Additional Node Information"));
			vv.rescale();
		}

		// Laying out the tree
		LayeredTreeLayout layout1 = new LayeredTreeLayout(vg);
		vg.setGraphLayoutManager(layout1);
		vg.layout();

		return vg;
	}

	private VisualGraph createExtendedPlanTree(PlanNode p) throws Exception {

		HashMap<Object, VertexWrapper> verticies = new HashMap<Object, VertexWrapper>();
		Tree g = new TreeImpl();

		buildTree(p, g, verticies);

		VisualGraph vg = new VisualGraph(g);
		List<VisualEdge> edges = vg.getVisualEdges();
		// Setting all the edge labels to the empty string.
		for (int i = 0; i < edges.size(); i++) {
			VisualEdge e = (VisualEdge) edges.get(i);
			e.setLabel("");
		}

		// Setting the vertex labels to match the plan node operation name.
		List<VisualVertex> visualVerticies = vg.getVisualVertices();

		for (int i = 0; i < visualVerticies.size(); i++) {
			VisualVertex vv = (VisualVertex) visualVerticies.get(i);
			String node_id = vv.getLabel();
			VertexWrapper vWrapper = (VertexWrapper) verticies.get(node_id);
			PlanNode currNode = vWrapper._n;

			String strLabel = "";
			String strTitle = "";
			String strInfo = "";
			if (currNode instanceof OperatorNode) {
				strLabel = "<<" + ((OperatorNode) currNode).getOperatorName()
						+ ">>\n";
				strTitle = "Complete Cost Estimates";
				strInfo += "<<" + ((OperatorNode) currNode).getOperatorName()
						+ ">>\n";
				HashMap<String, Double> resMap = ((OperatorNode) currNode)
						.getOpCostEstimates();
				// Get hashmap in Set interface to get key and value
				Set s = resMap.entrySet();
				// Move next key and value of HashMap by iterator
				Iterator it = s.iterator();
				while (it.hasNext()) {
					// key=value separator this by Map.Entry to get key and
					// value
					Map.Entry m = (Map.Entry) it.next();
					// getKey is used to get key of HashMap
					String key = (String) m.getKey();
					// getValue is used to get value of key in HashMap
					Double value = (Double) m.getValue();

					// if key contains
					// ("stream_cost, rows, cardinality, num_of_rows, estimate_rows)"
					strInfo += key + ": " + value;
					strInfo += "\n";

					// Main.defaultLogger.logging_info("(" + key + ", " + value
					// + ")");

					String temp = key.toLowerCase();
					if (temp.contains("stream_cost") // DB2
							|| temp.contains("result_card") // DB2
							|| temp.contains("rows") // MySQL
							|| temp.contains("cardinality") // Oracle OR DB2
							|| temp.contains("num_of_rows") // Postgres SQL
							|| temp.contains("estimate_rows")) {// SQLSERVER
						strLabel += "Cardinality Estimate: " + value;
						strLabel += "\n";
						// Main.defaultLogger.logging_info("Label: " +
						// strLabel);
					}
				}
				vv.getVertex().setLabel(strLabel);
				vv.addMouseListener(new OtherInformationMouseAdapter(strInfo,
						strTitle));
			} else if (currNode instanceof TableNode) {
				strLabel = ((TableNode) currNode).getTableName();
				vv.getVertex().setLabel(strLabel);
				strInfo = String.valueOf(currNode.getProperties());
				strTitle = "Table Node Information";
				vv.addMouseListener(new OtherInformationMouseAdapter(strInfo,
						strTitle));
			}

			vv.rescale();
		}

		// Laying out the tree
		LayeredTreeLayout layout1 = new LayeredTreeLayout(vg);
		vg.setGraphLayoutManager(layout1);
		vg.layout();

		return vg;
	}

	private VisualGraph createReallyExtendedPlanTree(PlanNode p)
			throws Exception {

		HashMap<Object, VertexWrapper> verticies = new HashMap<Object, VertexWrapper>();
		Tree g = new TreeImpl();

		buildTree(p, g, verticies);

		VisualGraph vg = new VisualGraph(g);
		List<VisualEdge> edges = vg.getVisualEdges();
		// Setting all the edge labels to the empty string.
		for (int i = 0; i < edges.size(); i++) {
			VisualEdge e = (VisualEdge) edges.get(i);
			e.setLabel("");
		}

		// Setting the vertex labels to match the plan node operation name.
		List<VisualVertex> visualVerticies = vg.getVisualVertices();

		for (int i = 0; i < visualVerticies.size(); i++) {
			VisualVertex vv = (VisualVertex) visualVerticies.get(i);
			String node_id = vv.getLabel();
			VertexWrapper vWrapper = (VertexWrapper) verticies.get(node_id);
			PlanNode currNode = vWrapper._n;

			String strLabel = "";
			String strTitle = "";
			String strInfo = "";
			if (currNode instanceof OperatorNode) {
				strLabel = "<<" + ((OperatorNode) currNode).getOperatorName()
						+ ">>\n";
				strTitle = "Complete Cost Estimates";
				HashMap<String, Double> resMap = ((OperatorNode) currNode)
						.getOpCostEstimates();
				// Get hashmap in Set interface to get key and value
				Set s = resMap.entrySet();
				// Move next key and value of HashMap by iterator
				Iterator it = s.iterator();
				while (it.hasNext()) {
					// key=value separator this by Map.Entry to get key and
					// value
					Map.Entry m = (Map.Entry) it.next();
					// getKey is used to get key of HashMap
					String key = (String) m.getKey();
					if(Constants.DEMO_SCREENSHOT){
						if(key.contains("DB2_")){
							key = key.replace("DB2_", "X_");
						}
//						else if(key.contains("ORA_")){
//							key = key.replace("ORA_", "X_");
//						}
					}
					// getValue is used to get value of key in HashMap
					Double value = (Double) m.getValue();
					strLabel += key + ": " + value;
					strLabel += "\n";
				}
				vv.getVertex().setLabel(strLabel);
				// vv.addMouseListener(new OtherInformationMouseAdapter(strInfo,
				// strTitle));
			} else if (currNode instanceof TableNode) {
				strLabel = ((TableNode) currNode).getTableName();
				vv.getVertex().setLabel(strLabel);
				strInfo = String.valueOf(currNode.getProperties());
				strTitle = "Table Node Information";
				vv.addMouseListener(new OtherInformationMouseAdapter(strInfo,
						strTitle));
			}
			vv.rescale();
		}

		// Laying out the tree
		LayeredTreeLayout layout1 = new LayeredTreeLayout(vg);
		vg.setGraphLayoutManager(layout1);
		vg.layout();

		return vg;
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains detailed information regarding a query plan";
	}

}
