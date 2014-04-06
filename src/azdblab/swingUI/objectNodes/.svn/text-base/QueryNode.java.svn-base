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

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Vector;

import javax.swing.DefaultListModel;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class QueryNode extends ObjectNode {

	private int queryID;
	private int queryNumber;
	private String querySQL;

	private String strUserName;
	private String strNotebookName;
	private String strExperimentName;
	private String strStartTime;
	// private JTextPane resPane;

	private HashMap<Long, Integer> seenPlans;
	private int planNum = 0;

	public QueryNode(int queryID, int QueryNumber, String QuerySQL) {
		this.queryID = queryID;
		this.queryNumber = QueryNumber;
		this.querySQL = QuerySQL;
		strNodeName = "Query #" + queryNumber;
		seenPlans = new HashMap<Long, Integer>();
	}

	private void populateStaticStrings() {
		try {
			String sql = "select e.userName, e.notebookName, e.experimentname, er.startTime from "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_EXPERIMENT
					+ " e, "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_EXPERIMENTRUN
					+ " er, "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_QUERY
					+ " q where q.queryID = "
					+ queryID
					+ " and q.runID = er.runID and er.experimentID = e.experimentID";

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			rs.next();
			strUserName = rs.getString(1);
			strNotebookName = rs.getString(2);
			strExperimentName = rs.getString(3);
			strStartTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(4));
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	public JPanel getDataPanel() {
		String info = "<HTML> <BODY>";
		info += "<p> QueryID = " + queryID + " </p>";
		info += "<p> queryNumber = " + queryNumber + " </p>";
		info += "<p> QuerySQL = " + querySQL + " </p>";
		info += "</BODY> </HTML>";

		NodePanel npl_toAdd = new NodePanel();
		npl_toAdd.addComponentToTab("Query Info",
				createTextPaneFromString(info));
		npl_toAdd.addComponentToTab("Query Summary", createSummaryTab());
		npl_toAdd.addComponentToTabLight("Detailed View", createExecutionPanel());

		return npl_toAdd;
	}

	private JTextPane createSummaryTab() {
		String summary = "<HTML> <BODY>";
		summary += "<center><h1> Summary of Query Executions </h1></center>";

		try {

			String sql = "select distinct cardinality from azdblab_queryexecution where queryid = "
					+ queryID + " order by cardinality desc";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			Vector<String> vecCard = new Vector<String>();
			while (rs.next()) {
				vecCard.add(rs.getString(1));
			}
			rs.close();

			long lastPlan = 0;
			String lastCard = "";
			double lastAvg = 0;
			double lastMin = 0;
			double lastMax = 0;

			for (int i = 0; i < vecCard.size(); i++) {
				sql = "select avg(qep.planid), avg(qe.runtime), max(qe.runtime), min(qe.runtime) from "
						+ Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYEXECUTION
						+ " qe, "
						+ Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYEXECUTIONHASPLAN
						+ " qep where qe.queryexecutionid = qep.queryexecutionid and qe.queryid = "
						+ queryID + "  and cardinality = " + vecCard.get(i);
				rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				rs.next();
				if (lastPlan != rs.getLong(1)) {
					if (lastPlan != 0) {
						summary += "<table border=\"1\">";
						summary += "<tr> <th> Cardinality </th> <th> Average </th> <th> Maximum </th> <th> Minimum </th> </tr>";
						summary += "<tr><td>" + lastCard + "</td><td>"
								+ lastAvg + "</td><td>" + lastMax + "</td><td>"
								+ lastMin + "</td></tr>";

						summary += "</table>";

						summary += "<p>--------------------------------</p>";
					}

					summary += "<table border=\"1\">";
					summary += "<tr> <th> Cardinality </th> <th> Average </th> <th> Maximum </th> <th> Minimum </th> </tr>";
					summary += "<tr><td>" + vecCard.get(i) + "</td><td>"
							+ rs.getDouble(2) + "</td><td>" + rs.getDouble(3)
							+ "</td><td>" + rs.getDouble(4) + "</td></tr>";

					summary += "</table>";
					summary += "<h2> Plan Number:"
							+ getPlanNumber(rs.getLong(1)) + "</h2>";
				}
				lastPlan = rs.getLong(1);
				lastCard = vecCard.get(i);
				lastAvg = rs.getDouble(2);
				lastMax = rs.getDouble(3);
				lastMin = rs.getDouble(4);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		summary += "</BODY> </HTML>";
		return createTextPaneFromString(summary);
	}

	private int getPlanNumber(long planID) {
		if (seenPlans.containsKey(planID)) {
			return seenPlans.get(planID);
		} else {
			seenPlans.put(planID, planNum);
			planNum++;
			return seenPlans.get(planID);
		}
	}

	private JTextPane resultPane;
	private JList lst_Executions;
	private JList lst_Cardinalitys;

	private JPanel createExecutionPanel() {

		lst_Cardinalitys = new JList(getCardinalitys(queryID));
		lst_Cardinalitys.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_Cardinalitys.setSelectedIndex(-1);
		lst_Cardinalitys.setVisibleRowCount(10);
		lst_Cardinalitys.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent e) {
				lst_Executions.setModel(getExecutionsAt(
						Integer.parseInt((String) lst_Cardinalitys
								.getSelectedValue()), queryID));
				lst_Executions.setSelectedIndex(-1);
			}
		});

		lst_Executions = new JList();
		lst_Executions.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		lst_Executions.setSelectedIndex(-1);
		lst_Executions.setVisibleRowCount(10);
		lst_Executions.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent e) {
				if (lst_Executions.getSelectedIndex() == -1) {
					return;
				}
				populateTextPane(((ExecutionData) lst_Executions
						.getSelectedValue()).executionID);
			}
		});

		JScrollPane scrpCard = new JScrollPane();
		scrpCard.setViewportView(lst_Cardinalitys);

		JScrollPane scrpExecutions = new JScrollPane();
		scrpExecutions.setViewportView(lst_Executions);

		JPanel jpl_Lists = new JPanel(new GridLayout(1, 2));
		((GridLayout) jpl_Lists.getLayout()).setHgap(5);
		jpl_Lists.add(scrpCard);
		jpl_Lists.add(scrpExecutions);

		JPanel jpl_Labels = new JPanel(new GridLayout(1, 2));
		jpl_Labels.add(new JLabel("Cardinality"));
		jpl_Labels.add(new JLabel("QueryExecution"));

		resultPane = new JTextPane();
		resultPane.setContentType("text/html");
		resultPane.setEditable(false);

		JScrollPane scrp_Res = new JScrollPane();
		scrp_Res.setViewportView(resultPane);

		JPanel jpl_display = new JPanel(new BorderLayout());
		jpl_display.add(scrp_Res, BorderLayout.CENTER);

		JPanel jpl_selector = new JPanel();
		jpl_selector.setLayout(new BorderLayout());
		jpl_selector.add(jpl_Labels, BorderLayout.NORTH);
		jpl_selector.add(jpl_Lists, BorderLayout.CENTER);

		JPanel jpl_toRet = new JPanel();
		jpl_toRet.setLayout(new GridLayout(2, 1));
		((GridLayout) jpl_toRet.getLayout()).setVgap(5);
		jpl_toRet.add(jpl_selector);
		jpl_toRet.add(jpl_display);
		return jpl_toRet;
	}

	private DefaultListModel getExecutionsAt(int Cardinality, int qID) {
		String sql = "select QueryExecutionID, IterNum from azdblab_queryexecution where queryID = "
				+ qID
				+ " and cardinality = "
				+ Cardinality
				+ " order by IterNum";
		DefaultListModel lmodel = new DefaultListModel();
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				lmodel
						.addElement(new ExecutionData(rs.getInt(1), rs
								.getInt(2)));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lmodel;
	}

	private DefaultListModel getCardinalitys(int qID) {

		String sql = "select distinct cardinality from azdblab_queryexecution where queryID = "
				+ qID + " order by cardinality desc";
		DefaultListModel lmodel = new DefaultListModel();
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				lmodel.addElement(rs.getString(1));
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return lmodel;
	}

	@Override
	public String getIconResource(boolean open) {
		return Constants.DIRECTORY_IMAGE_LFHNODES + "query.png";
	}

	@Override
	protected void loadChildNodes() { // ScenarioBasedOnCardinality
		populateStaticStrings();

		String sql = "select distinct qp.planID, qe.QUERYEXECUTIONNUMBER from AZDBLAB_QUERYEXECUTIONHASPLAN qp, AZDBLAB_QUERYEXECUTION qe where qe.queryid = "
				+ queryID
				+ " and qe.queryexecutionid = qp.queryexecutionid order by qe.QUERYEXECUTIONNUMBER asc ";

		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			// HashMap<Long, Integer> planNumMap = new HashMap<Long, Integer>();
			int nextPlanNum = 0;
			while (rs.next()) {
				Long planCode = new Long(rs.getLong(1));
				// Integer iPlanNum = planNumMap.get(planCode);
				Integer iPlanNum = seenPlans.get(planCode);
				if (iPlanNum == null) {
					iPlanNum = new Integer(nextPlanNum++);
					// new plan
					// planNumMap.put(planCode, iPlanNum);
					seenPlans.put(planCode, iPlanNum);
				}
				PlanDetailNode changePointNode = new PlanDetailNode(
						strUserName, strNotebookName, strExperimentName,
						strStartTime, queryNumber, rs.getInt(2), iPlanNum
								.intValue(), rs.getString(1));

				AZDBLABMutableTreeNode PlanTreeNode = new AZDBLABMutableTreeNode(
						changePointNode);
				parent.add(PlanTreeNode);
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void populateTextPane(int queryExecutionID) {
		String sql = "Select qe.RUNTIME, qe.procdiff, qe.PHASE, qp.planID from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTION
				+ " qe, " + Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYEXECUTIONHASPLAN
				+ " qp where qe.queryexecutionID = " + queryExecutionID
				+ " and qe.queryExecutionID = qp.queryExecutionID";
		String html = "<HTML><BODY>";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			rs.next();
			html += "<h1> Basic Information </h1>";
			html += "<table border=\"1\"> <tr> <th> Execution Time </th> <th> Phase </th> <th> PlanID </th> </tr>";
			html += "<tr> <td>" + rs.getString(1) + "</td> <td>"
					+ rs.getString(3) + "</td> <td>" + rs.getString(4)
					+ "</td> </tr> </table>";
			// html += "<h2> Aspect Summary </h2>";

			String procdiff = LabShelfManager.getShelf().getStringFromClob(rs, 2);
			//System.out.print(procdiff);
			// System.out.println(procdiff.split("\n"))
			String modifiedprocdiff = procdiff.replace("\n", "<br/>");
			modifiedprocdiff = modifiedprocdiff.replace("]", "]<br/>");
			rs.close();
			/*
			 * if (QueryExecutionAspect.executionExists(queryExecutionID)) {
			 * QueryExecutionAspectData aspData = QueryExecutionAspect
			 * .getAspectData(queryExecutionID);
			 * 
			 * html += "<table border=\"1\">"; html +=
			 * "<tr><th>Total Other Time</th> <td>" + aspData.TotalOtherTime +
			 * "</td> </tr>"; html += "<tr><th>Total DBMS Time</th> <td>" +
			 * aspData.TotalDBMSTime + "</td> </tr>"; html +=
			 * "<tr><th>Number of Started Processes</th> <td>" +
			 * aspData.NumStartedProcesses + "</td> </tr>"; html +=
			 * "<tr><th>Number of Stopped Processes</th> <td>" +
			 * aspData.StoppedProcesses + "</td> </tr>"; html +=
			 * "<tr><th>Number of Phantoms</th> <td>" +
			 * aspData.NumPhantomsPresent + "</td> </tr>"; html +=
			 * "<tr><th>TotalFaults</th> <td>" + aspData.TotalFaults +
			 * "</td> </tr>"; html += "<tr><th>User Mode Ticks</th> <td>" +
			 * aspData.userModeTicks + "</td> </tr>"; html +=
			 * "<tr><th>Low Priority User Mode Ticks</th> <td>" +
			 * aspData.lowPriorityUserModeTicks + "</td> </tr>"; html +=
			 * "<tr><th>System Mode Ticks</th> <td>" + aspData.systemModeTicks +
			 * "</td> </tr>"; html += "<tr><th>Idle Task Ticks</th> <td>" +
			 * aspData.idleTaskTicks + "</td> </tr>"; html +=
			 * "<tr><th>IO Wait Ticks</th> <td>" + aspData.ioWaitTicks +
			 * "</td> </tr>"; html += "<tr><th>irq Ticks</th> <td>" +
			 * aspData.irq + "</td> </tr>"; html +=
			 * "<tr><th>Soft irq Ticks</th> <td>" + aspData.softirq +
			 * "</td> </tr>"; html += "<tr><th>Steal Stolen Ticks</th> <td>" +
			 * aspData.stealStolenTicks + "</td> </tr>"; html += "</table>";
			 * 
			 * } else { html +=
			 * "No aspect Data exists, please compute queryExecutionAspects for this run<br/>"
			 * ; }
			 */
			html += "<h2> procdiff </h2>";
			html += modifiedprocdiff;
		} catch (Exception e) {
			e.printStackTrace();
			html += "Failed to fetch Information";

		}
		html += "</BODY> </HTML>";
		resultPane.setText(html);
		resultPane.setCaretPosition(0);
	}

	public int getQueryID() {
		return queryID;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public String getExperimentName() {
		return strExperimentName;
	}

	public String getStartTime() {
		return strStartTime;
	}

	public int getQueryNumber() {
		return queryNumber;
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Young-Kyoon Suh");
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information pertaining to the results of a particular query";
	}

}

class ExecutionData {
	int executionID;
	int iterationNumber;

	public ExecutionData(int executionID, int iterationNumber) {
		this.executionID = executionID;
		this.iterationNumber = iterationNumber;
	}

	@Override
	public String toString() {
		return String.valueOf(iterationNumber);
	}
}