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

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Vector;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import java.sql.ResultSet;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.plugins.evaluation.Evaluation;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.ResultPaneDlg;
import azdblab.swingUI.objectNodes.CompletedRunNode;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.objectNodes.ScenarioNode;

import azdblab.model.dataDefinition.ForeignKey;

public class SanityCheckEvaluation extends Evaluation {

	private String strUserName;
	private String strNotebookName;
	private String strScenarioName;

	/**
	 * The argument should be the object node of the containing class (Ie
	 * NotebookNode or CompletedRunNode)
	 * 
	 * @param sent
	 */
	public SanityCheckEvaluation(ObjectNode sent) {
		super(sent);
	}

	@Override
	public Vector<JButton> getButtons() {
		return null;
	}

	/**
	 * This method is the main method for generating sanity checks
	 * 
	 * First is ensures that sanity checks have been computed for all runs in
	 * vecCompRuns, after that it generates the resultHTML pane
	 * 
	 * @param vecCompRuns
	 * @throws Exception
	 */
	private void generateOverallSanityCheck(Vector<Run> vecCompRuns,
			String runtimeFormula, String failurePred, int minimumIteration,
			String[] badProcs) throws Exception {
		// null instantiate it
		QueryStatEvaluation bsAspect = new QueryStatEvaluation(null);

		// Step2 Ensure that all runs have aspects computed

		for (int i = 0; i < vecCompRuns.size(); i++) {
			if (getNumberAspects(vecCompRuns.get(i)) == 0) {
				bsAspect.computeQueryExecutionStats(vecCompRuns.get(i));
			}
			checkRun(vecCompRuns.get(i), runtimeFormula, failurePred,
					minimumIteration, badProcs);
			System.out.println("Processed Information for: "
					+ vecCompRuns.get(i).getDBMS() + ":"
					+ vecCompRuns.get(i).getExperimentName() + ":"
					+ vecCompRuns.get(i).getStartTime());
		}
		DecimalFormat df = new DecimalFormat("####0.00");

		// Step3 calculate the info

		String html = "<HTML><BODY>";
		html += "<table border=\"1\"";

		html += "<tr> <th colspan=\"2\" style=\"font-size:110%\">Sanity Check Results </th> </tr>";
		html += "<tr>";
		html += "<th>Number of Missing Queries</th>";
		long numMissingQueries = getColumnSum(vecCompRuns, "NumMissingQueries");
		if (numMissingQueries == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numMissingQueries + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numMissingQueries + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Percentage Stopped</th>";
		long totalStoppedAspects = getColumnSum(vecCompRuns,
				"NumStoppedProcesses");
		long numberAspects = getNumAspectsFor(vecCompRuns);
		double percentStopped = ((double) totalStoppedAspects / (double) numberAspects) * 100;
		if (percentStopped <= 1) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ totalStoppedAspects + "/" + numberAspects + " = "
					+ df.format(percentStopped) + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ totalStoppedAspects + "/" + numberAspects + " = "
					+ df.format(percentStopped) + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Percentage Phantom</th>";

		long totalPhantomAspects = getColumnSum(vecCompRuns,
				"NumPhantomProcesses");
		double percentPhantom = ((double) totalPhantomAspects / (double) numberAspects) * 100;
		if (percentPhantom <= 1) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ totalPhantomAspects + "/" + numberAspects + " = "
					+ df.format(percentPhantom) + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ totalPhantomAspects + "/" + numberAspects + " = "
					+ df.format(percentPhantom) + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Percentage of Excessive Variation</th>";
		long numStdDevViolations = getColumnSum(vecCompRuns,
				"NumExcessiveVariation");
		long numberCardinalities = getNumberCardinalities(vecCompRuns);
		double percentExcessiveVariation = ((double) numStdDevViolations / (double) numberCardinalities) * 100;

		if (percentExcessiveVariation <= 3) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numStdDevViolations + "/" + numberCardinalities + " = "
					+ df.format(percentExcessiveVariation) + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numStdDevViolations + "/" + numberCardinalities + " = "
					+ df.format(percentExcessiveVariation) + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Number of Monotonicity Violations</th>";
		long numMonotonicityViolations = getColumnSum(vecCompRuns,
				"NumMonotonicityViolations");
		if (numMonotonicityViolations == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numMonotonicityViolations + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numMonotonicityViolations + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th> Number of Timing Violations</th>";
		long numTimingViolations = getColumnSum(vecCompRuns,
				"NumTimingViolations");
		if (numTimingViolations == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numTimingViolations + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numTimingViolations + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Number of Unique Plan Violations</th>";
		long numDistinctPlanViolations = getColumnSum(vecCompRuns,
				"NumUniquePlanViolations");
		if (numDistinctPlanViolations == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numDistinctPlanViolations + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numDistinctPlanViolations + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Number of Aspect Failures</th>";
		long numberExecutions = getNumberExecutionsFor(vecCompRuns);
		long numAspectFailures = (numberExecutions - numberAspects);
		if (numAspectFailures == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numAspectFailures + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numAspectFailures + " </td>";
		}
		html += "</tr>";
		html += "<tr>";
		html += "<th>Number of Minimum Iteration Violations</th>";
		long numIterationViolations = getColumnSum(vecCompRuns,
				"NumMinimumIterationViolations");
		if (numIterationViolations == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numIterationViolations + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numIterationViolations + " </td>";
		}
		html += "</tr>";
		html += "<th>Number of DBMS Time Violations</th>";
		long numDBMSTimeViolations = getColumnSum(vecCompRuns,
				"numDBMSTimeViolations");
		if (numDBMSTimeViolations == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numDBMSTimeViolations + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numDBMSTimeViolations + " </td>";
		}

		html += "</tr>";

		html += "<th>Number of Tick Violations</th>";
		long numTickViolations = getColumnSum(vecCompRuns, "numTickViolations");
		if (numTickViolations == 0) {
			html += "<td style=\"background-color:#aaffaa\" > "
					+ numTickViolations + " </td>";
		} else {
			html += "<td style=\"background-color:#ffcccc\"> "
					+ numTickViolations + " </td>";
		}
		html += "</tr>";
		html += "</table>";
		long numberQueries = getNumQueriesFor(vecCompRuns);
		html += "<br/>";
		html += "<table border=\"1\">";
		html += "<tr> <th colspan=\"2\" style=\"font-size:110%\"> Summary Statistics </th> </tr>";
		html += "<tr> <th>Number of Queries Run</th> <td>" + numberQueries
				+ " </td> </tr>";
		html += "<tr> <th>Number of Query Executions</th> <td> "
				+ numberExecutions + " </td> </tr>";
		html += "<tr> <th>Number of Execution Points</th> <td>"
				+ numberCardinalities + " </td> </tr>";
		html += "</table>";
		html += "<br/>";

		html += "<table border=\"1\">";
		html += "<tr> <th colspan=\"3\" style=\"font-size:110%\">Table Explanation </th> </tr>";
		html += "<tr> <th>Number of Missing Queries</th> <td> The number of queries associated with this completed run </td> <td> Red if greater than zero</td> </tr>";
		html += "<tr> <th>Percentage of Stopped Processes</th> <td> The percentage of queryExecutions where a stopped process was detected </td><td> Red if greater than 1%</td> </tr>";
		html += "<tr> <th>Percentage of Phantom Processes</th> <td> The percentage of queryExecutions where a phantom process was detected </td><td> Red if greater than 1%</td> </tr>";
		html += "<tr> <th>Percentage of Excessive Variation</th> <td> The number of cardinalities where the standard deviation of the executions is > 20% of the average runtime </td> <td> Red if greater than 3%</td></tr>";
		html += "<tr> <th>Number of Monotonicity Violations</th> <td> The number of Execution Points which exhibit monotonicity violations </td><td> Red if greater than zero</td> </tr>";
		html += "<tr> <th>Number of Timing Violations</th> <td> The number of queryExecutions where runtime - totalOtherTime &lt;= 0 </td><td> Red if greater than zero</td> </tr>";
		html += "<tr> <th>Number of Unique Plan Violations</th> <td> The number of queries where the number of distinct plans at a cardinality is zero </td><td> Red if greater than zero</td> </tr>";
		html += "<tr> <th>Number of Aspect Failures</th> <td> The number of executions which have no associated aspect </td><td> Red if greater than zero</td> </tr>";
		html += "<tr> <th>Number of Minimum Iteration Violations</th> <td> The number of cardinalities where the number of valid (no stopped or phantom processes) is &lt;= 5 </td><td>Red if greater than zero</td> </tr>";
		html += "<tr> <th>Number of DBMS Time Violations</th> <td> The number of query executions  where runtime - totalOtherTime is &gt; 0 but less than dbmsTime </td><td> Red if greater than zero</td> </tr>";
		html += "<tr> <th> Number Tick Violations </th> <td> The number of instances where |totalTicks*10 - runtime| &gt; 10 </td><td> Red if greater than zero</td> </tr>";
		html += "<tr> <th> Number of ExecutionPoints </th> <td colspan=\"2\"> The number of unique QueryID/Cardinality pairs for this Run </td> </tr>";

		html += "</table>";

		html += "<h2> Input Parameters </h2>";
		html += "<table border=\"1\">";
		html += "<tr>";
		html += "<th>Parameter</th>";
		html += "<th>Value</th>";
		html += "</tr>";

		html += "<tr>";
		html += "<td>Runtime Formula</td>";
		html += "<td>" + txt_Formula.getText() + "</td>";
		html += "</tr>";

		html += "<tr>";
		html += "<td>Failure Predicate</td>";
		html += "<td>" + txt_Failure.getText().replace("<", "&lt;") + "</td>";
		html += "</tr>";

		html += "<tr>";
		html += "<td>Minimum Number of Executions</td>";
		html += "<td>" + txt_MinExecutions.getText() + "</td>";
		html += "</tr>";
		html += "</table>";

		html += "</BODY></HTML>";

		String tmp = "Overall Sanity View: " + strScenarioName + " on user:"
				+ strUserName + " on notebook:" + strNotebookName;
		if (vecCompRuns.size() == 1) {
			tmp += "on experiment: " + vecCompRuns.get(0).getExperimentName()
					+ " at:" + vecCompRuns.get(0).getStartTime();
		}

		ResultPaneDlg resDlg = new ResultPaneDlg(html);
		resDlg.setTitle("Overall Sanity View: " + strScenarioName + " on user:"
				+ strUserName + " on notebook:" + strNotebookName);
		resDlg.setVisible(true);
	}

	private void checkRun(Run toCheck, String runtimeFormula,
			String failurePredicate, int minimumIterations, String[] badProcs) {
		if (checkHasAspect(toCheck)) {
			System.out.println("Sanity Information for " + toCheck.getRunID()
					+ " already exists");
			return;
		}
		try {
			System.out.println("Checking:" + toCheck.getRunID());
			int numMissingQueries = querySanityCheck(toCheck);
			System.out.println("Missing query check -- done: " + numMissingQueries);
			int numStoppedProcesses = getStoppedAspects(toCheck);
			System.out.println("Stopped Check -- done: " + numStoppedProcesses);
			int numPhantomProcesses = getPhantomAspects(toCheck);
			System.out.println("Phantom check -- done: " + numPhantomProcesses);
			int numExcessiveVariation = getStandardDeviationViolations(toCheck,
					runtimeFormula);
			System.out.println("Excessive Variation Violations -- done:" + numExcessiveVariation);
			int numMonotonicityViolations = getNumberMonotonicityViolations(
					toCheck, runtimeFormula);
			System.out.println("Monotonicity Violations -- done:" + numMonotonicityViolations);
			int numTimingViolations = getTimingViolations(toCheck,
					runtimeFormula);
			System.out.println("Timing Violations -- done:" + numTimingViolations);
			int numUniquePlanViolations = getDistinctPlanViolations(toCheck);
			System.out.println("Unique Plan Violations -- done:" + numUniquePlanViolations);
			int numIterationViolations = getCardinaltiyViolations(toCheck,
					failurePredicate, minimumIterations, badProcs);
			System.out.println("Minimum Iteration Violations-- done:" + numIterationViolations);
			int numDBMSTimeViolations = getDBMSTimeViolations(toCheck);
			System.out.println("DBMS Time Violations-- done:" + numDBMSTimeViolations);
			int numTickViolations = getTickViolations(toCheck, runtimeFormula);
			System.out.println("Tick Violations -- done:" + numTickViolations);
			System.out.println("Done Checking:" + toCheck.getRunID());

			LabShelfManager.getShelf().insertTupleToNotebook(
					Constants.TABLE_PREFIX + Constants.TABLE_SANITYCHECKASPECT,
					new String[] { "RunID", "NumMissingQueries",
							"NumStoppedProcesses", "NumPhantomProcesses",
							"NumExcessiveVariation",
							"NumMonotonicityViolations", "NumTimingViolations",
							"NumUniquePlanViolations", "numDBMSTimeViolations",
							"NumMinimumIterationViolations",
							"numTickViolations" },
					new String[] { String.valueOf(toCheck.getRunID()),
							String.valueOf(numMissingQueries),
							String.valueOf(numStoppedProcesses),
							String.valueOf(numPhantomProcesses),
							String.valueOf(numExcessiveVariation),
							String.valueOf(numMonotonicityViolations),
							String.valueOf(numTimingViolations),
							String.valueOf(numUniquePlanViolations),
							String.valueOf(numDBMSTimeViolations),
							String.valueOf(numIterationViolations),
							String.valueOf(numTickViolations) },
					new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER,
							GeneralDBMS.I_DATA_TYPE_NUMBER });

		} catch (Exception e) {
			// There was an error, don't save the record
			e.printStackTrace();
		}
	}
	
	private boolean checkHasAspect(Run toCheck) {
		String sql = "Delete from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_SANITYCHECKASPECT + " where runid = "
				+ toCheck.getRunID();
		try {
			LabShelfManager.getShelf().executeDeleteSQL(sql);

			LabShelfManager.getShelf().commit();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public String getName() {
		return "Sanity Check Aspect";
	}

	@Override
	public JPanel getTabs() {
		return getSettingsPanel();
	}

	private JTextArea txt_Formula;
	private JTextArea txt_Failure;
	private JTextField txt_MinExecutions;
	private JTextArea txt_BadProcs;

	private JPanel getSettingsPanel() {
		JPanel jpl_toRet = new JPanel();
		jpl_toRet.setPreferredSize(new Dimension(800, 500));
		jpl_toRet.setLayout(null);

		JLabel lbl_Formula = new JLabel(
				"Please input a formula for TotalDBMSTime");
		lbl_Formula.setBounds(10, 10, 700, 20);
		// setBounds(x,y,width, height);
		txt_Formula = new JTextArea(getDefaultFormulaText());
		txt_Formula.setBounds(10, 40, 700, 100);
		txt_Formula.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		txt_Formula.setLineWrap(true);
		// 150
		JLabel lbl_Failure = new JLabel(
				"Please input a predicate indicating when to throw out an execution");
		lbl_Failure.setBounds(10, 150, 700, 20);
		// 180;
		txt_Failure = new JTextArea(getDefaultFailureText());
		txt_Failure.setBounds(10, 180, 700, 100);
		txt_Failure.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		txt_Failure.setLineWrap(true);
		// 190
		JLabel lbl_MinExecutions = new JLabel(
				"Please Input the Minimum number of executions a pass needs to be valid");
		lbl_MinExecutions.setBounds(10, 290, 700, 20);

		txt_MinExecutions = new JTextField(getDefaultMinExecution());
		txt_MinExecutions.setBounds(10, 310, 100, 40);

		JLabel lbl_BadProcs = new JLabel(
				"Please input bad processes in a comma delineated list");
		lbl_BadProcs.setBounds(10, 360, 700, 40);

		txt_BadProcs = new JTextArea(getDefaultBadProcs());
		txt_BadProcs.setLineWrap(true);
		txt_BadProcs.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		txt_BadProcs.setBounds(10, 400, 700, 200);

		JButton btn_Generate = new JButton("Generate");
		btn_Generate.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					if (myObjectNode instanceof ScenarioNode) {
						strUserName = ((ScenarioNode) myObjectNode)
								.getUserName();
						strNotebookName = ((ScenarioNode) myObjectNode)
								.getNotebookName();
						strScenarioName = ((ScenarioNode) myObjectNode)
								.getScenario();
						List<Experiment> experiments = User
								.getUser(strUserName).getNotebook(
										strNotebookName).getAllExperiments();
						Vector<Run> vecCompRuns = new Vector<Run>();
						for (int i = 0; i < experiments.size(); i++) {
							if (experiments.get(i).getScenario().equals(
									strScenarioName)) {
								vecCompRuns.addAll(experiments.get(i)
										.getCompletedRuns());
							}
						}
						generateOverallSanityCheck(vecCompRuns, txt_Formula
								.getText(), txt_Failure.getText(), Integer
								.parseInt(txt_MinExecutions.getText().trim()),
								txt_BadProcs.getText().split(","));
					} else if (myObjectNode instanceof CompletedRunNode) {
						strUserName = ((CompletedRunNode) myObjectNode)
								.getUserName();
						strNotebookName = ((CompletedRunNode) myObjectNode)
								.getNotebookName();
						strScenarioName = ((CompletedRunNode) myObjectNode)
								.getScenario();
						Vector<Run> toRun = new Vector<Run>();
						toRun.add(User.getUser(strUserName).getNotebook(
								strNotebookName).getExperiment(
								((CompletedRunNode) myObjectNode)
										.getExperimentName()).getRun(
								((CompletedRunNode) myObjectNode)
										.getStartTime()));

						generateOverallSanityCheck(toRun,
								txt_Formula.getText(), txt_Failure.getText(),
								Integer.parseInt(txt_MinExecutions.getText()
										.trim()), txt_BadProcs.getText().split(
										","));
					}
				} catch (Exception x) {
					x.printStackTrace();
					JOptionPane.showMessageDialog(null,
							"Failed to Generate Sanity Check");
				}
				//
				// generateDialog(txt_Formula.getText(), txt_Failure.getText(),
				// Integer.parseInt(txt_MinExecutions.getText().trim()),
				// txt_BadProcs.getText().split(","),
				// (QueryNode) myObjectNode);
			}
		});
		btn_Generate.setBounds(10, 610, 150, 40);

		jpl_toRet.add(lbl_Formula);
		jpl_toRet.add(txt_Formula);
		jpl_toRet.add(lbl_Failure);
		jpl_toRet.add(txt_Failure);
		jpl_toRet.add(lbl_MinExecutions);
		jpl_toRet.add(txt_MinExecutions);
		jpl_toRet.add(lbl_BadProcs);
		jpl_toRet.add(txt_BadProcs);
		jpl_toRet.add(btn_Generate);
		return jpl_toRet;
	}

	private InternalTable SANITYCHECKASPECT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_SANITYCHECKASPECT,
			new String[] { "RunID", "NumMissingQueries", "NumStoppedProcesses",
					"NumPhantomProcesses", "NumExcessiveVariation",
					"NumMonotonicityViolations", "NumTimingViolations",
					"NumUniquePlanViolations", "numDBMSTimeViolations",
					"NumMinimumIterationViolations", "numTickViolations" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 10, 10,
					10, 10, 10, 10, 10, 10, 10, 10 }, new int[] { 0, 0, 0, 0,
					0, 0, 0, 0, 0, 0, 0 }, null, new String[] { "RunID" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);

	public static final boolean refreshTable = false;

	@Override
	public Vector<InternalTable> getTables() {
		if (refreshTable) {
			LabShelfManager.getShelf().dropTable(SANITYCHECKASPECT.TableName);
		}
		Vector<InternalTable> toRet = new Vector<InternalTable>();
		toRet.add(SANITYCHECKASPECT);
		return toRet;
	}

	@Override
	public Evaluation getInstance(ObjectNode sent) {
		return new SanityCheckEvaluation(sent);
	}

	@Override
	public Vector<String> getSupportedClasses() {
		Vector<String> toRet = new Vector<String>();
		// toRet.add("ScenarioNode");
		toRet.add("CompletedRunNode");
		return toRet;
	}

	private long getColumnSum(Vector<Run> vecToCompute, String attribute) {
		String sql = "select sum(" + attribute + ") from "
				+ Constants.TABLE_PREFIX + Constants.TABLE_SANITYCHECKASPECT
				+ " where ";
		for (int i = 0; i < vecToCompute.size(); i++) {
			sql += "runID = " + vecToCompute.get(i).getRunID();
			if (i != vecToCompute.size() - 1) {
				sql += " or ";
			}
		}
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	private long getNumAspectsFor(Vector<Run> vecToCompute) {
		String sql = "Select count(*) from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN
				+ " er, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERY
				+ " q, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYEXECUTION
				+ " qe, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYSTATEVALUATION
				+ " qea where er.runID = q.runID and q.queryID = qe.queryID and qe.queryExecutionID = qea.queryExecutionID and er.runID IN (";
		for (int i = 0; i < vecToCompute.size(); i++) {
			sql += vecToCompute.get(i).getRunID();
			if (i != vecToCompute.size() - 1) {
				sql += " , ";
			}
		}
		sql += ")";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	private long getNumberExecutionsFor(Vector<Run> vecToCompute) {
		String sql = "Select count(*) from "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN
				+ " er, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERY
				+ " q, "
				+ Constants.TABLE_PREFIX
				+ Constants.TABLE_QUERYEXECUTION
				+ " qe "
				+ " where er.runID = q.runID and q.queryID = qe.queryID and er.runID IN (";
		for (int i = 0; i < vecToCompute.size(); i++) {
			sql += vecToCompute.get(i).getRunID();
			if (i != vecToCompute.size() - 1) {
				sql += " , ";
			}
		}
		sql += ")";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	private long getNumQueriesFor(Vector<Run> vecToCompute) {
		String sql = "Select count(*) from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_EXPERIMENTRUN + " er, "
				+ Constants.TABLE_PREFIX + Constants.TABLE_QUERY + " q "

				+ " where er.runID = q.runID and er.runID IN (";
		for (int i = 0; i < vecToCompute.size(); i++) {
			sql += vecToCompute.get(i).getRunID();
			if (i != vecToCompute.size() - 1) {
				sql += " , ";
			}
		}
		sql += ")";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	private long getNumberCardinalities(Vector<Run> vecToCompute) {
		String sql = "Select count(*) from (select distinct qe.queryid, qe.cardinality "
				+ "from azdblab_queryexecution qe, azdblab_query q, azdblab_experimentrun "
				+ "er where er.runid = q.runid and q.queryid = qe.queryid and er.runid IN (";

		for (int i = 0; i < vecToCompute.size(); i++) {
			sql += vecToCompute.get(i).getRunID();
			if (i != vecToCompute.size() - 1) {
				sql += " , ";
			}
		}
		sql += "))";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				return rs.getLong(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	private String getDefaultBadProcs() {
		return "yum-updatesd,yum-updatesd-he";
	}

	private String getDefaultFormulaText() {
		return "totalDBMSTime";
	}

	private String getDefaultFailureText() {
		return "NumPhantomsPresent > 0 or StoppedProcesses > 0 or Runtime = 9999999 or runtime < 20";
	}

	private String getDefaultMinExecution() {
		return "6";
	}

	/**
	 * Returns the number of missing queries
	 * 
	 * @return
	 */
	public int querySanityCheck(Run myRun) {
		return Math.abs(User.getUser(myRun.getUserName()).getNotebook(
				myRun.getNotebookName()).getExperiment(
				myRun.getExperimentName()).getNumberQueries()
				- getNumberQueries(myRun));
	}

	public int getDistinctPlanViolations(Run myRun) throws Exception {
		AZDBLabObserver.timerOn = false;
		int numViolations = 0;
		List<Query> vecQueries = myRun.getExperimentRunQueries();
		for (int i = 0; i < vecQueries.size(); i++) {
			String sql = "Select distinct Cardinality from azdblab_queryexecution where queryid = "
					+ vecQueries.get(i).getQueryID();
			Vector<String> vecCards = new Vector<String>();
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				vecCards.add(rs.getString(1));
			}
			rs.close();
			for (int j = 0; j < vecCards.size(); j++) {
				sql = "select count(distinct qep.planid) from azdblab_queryexecutionhasplan qep, azdblab_queryexecution qe where qe.queryid = "
						+ vecQueries.get(i).getQueryID()
						+ " and qe.cardinality = "
						+ vecCards.get(j)
						+ " and qe.queryexecutionid = qep.queryExecutionid";
				rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				if (rs.next()) {
					if (rs.getInt(1) != 1) {
						numViolations++;
					}
				}
				rs.close();
			}

		}
		AZDBLabObserver.timerOn = true;
		return numViolations;
	}

	/**
	 * Gets the number of aspects associated with this run with phantom
	 * processes
	 * 
	 * @return
	 */
	public int getPhantomAspects(Run myRun) throws Exception {
		String sql = "Select  count(*) from azdblab_querystatevaluation qea, azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ myRun.getRunID()
				+ " and q.queryid = qe.queryid and qe.queryexecutionid = qea.queryexecutionid and qea.NumPhantomsPresent > 0";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);

		}
		rs.close();

		return 0;
	}

	/**
	 * Returns the number of executions where runtime - totalOtherTime < 0;
	 * 
	 * @return
	 */
	public int getTimingViolations(Run myRun, String runtimeFormula)
			throws Exception {
		String sql = "Select  count(*) from azdblab_querystatevaluation qea, azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ myRun.getRunID()
				+ " and q.queryid = qe.queryid and qe.queryexecutionid = qea.queryexecutionid and qea.totalOtherTime >= ("
				+ runtimeFormula + ")";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);

		}
		rs.close();

		return 0;
	}

	public int getTickViolations(Run myRun, String runtimeFormula)
			throws Exception {
		String sql = "Select count(*) from azdblab_querystatevaluation qea, AZDBLAB_QUERYEXECUTION qe, AZDBLAB_QUERY q where qe.queryid = q.queryid and q.runid = "
				+ myRun.getRunID()
				+ " and qe.queryexecutionid = qea.queryexecutionid and ((qea.userModeTicks + qea.lowPriorityUserModeTicks + qea.systemModeTicks + qea.idleTaskTicks + qea.ioWaitTicks + qea.irq + qea.softirq + qea.stealStolenTicks) *10 - ("
				+ runtimeFormula + ") >10)";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);
		}

		return -1;
	}

	/**
	 * Returns the number of aspects associated with this run
	 * 
	 * @return
	 */
	public int getNumberAspects(Run myRun) throws Exception {
		String sql = "Select  count(*) from azdblab_querystatevaluation qea, azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ myRun.getRunID()
				+ " and q.queryid = qe.queryid and qe.queryexecutionid = qea.queryexecutionid";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);

		}
		rs.close();

		return 0;
	}

	/**
	 * returns the number of aspects associated with this run that contain
	 * stopped processes
	 * 
	 * @return
	 */
	public int getStoppedAspects(Run myRun) throws Exception {
		String sql = "Select  count(*) from azdblab_querystatevaluation qea, azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ myRun.getRunID()
				+ " and q.queryid = qe.queryid and qe.queryexecutionid = qea.queryexecutionid and qea.StoppedProcesses > 0";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);

		}
		rs.close();

		return 0;
	}

	/**
	 * Gets the number of queryExecutions associated with this run
	 * 
	 * @return
	 */
	public int getNumberExecutions(Run myRun) throws Exception {
		String sql = "Select  count(*) from azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ myRun.getRunID() + " and q.queryid = qe.queryid";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);

		}
		rs.close();

		return 0;
	}

	/**
	 * Returns the number of cardinalitys accross all queries associated with
	 * this run
	 * 
	 * @return
	 */
	public int getTotalCardinalitys(Run myRun) throws Exception {
		String sql = "Select  distinct qe.queryid, qe.cardinality from azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ myRun.getRunID() + " and q.queryid = qe.queryid";
		int numLevels = 0;
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			numLevels++;
		}
		rs.close();

		return numLevels;
	}

	public int getCardinaltiyViolations(Run myRun, String failurePredicate,
			int iterationsNeeded, String[] badProcs) throws Exception {
		AZDBLabObserver.timerOn = false;
		int numViolations = 0;
		List<Query> vecQueries = myRun.getExperimentRunQueries();
		for (int i = 0; i < vecQueries.size(); i++) {
			Query q = vecQueries.get(i);
			Vector<String> vecCard = new Vector<String>();
			String sql = "Select  distinct cardinality from azdblab_queryexecution where queryid = "
					+ q.iQueryID + " order by cardinality";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				vecCard.add(rs.getString(1));
			}
			rs.close();

			for (int j = 0; j < vecCard.size(); j++) {
				String sql2 = "Select count(*) from azdblab_querystatevaluation qea, azdblab_queryexecution qe where qe.queryid = "
						+ q.iQueryID
						+ " and qe.cardinality = "
						+ vecCard.get(j)
						+ " and not ("
						+ failurePredicate
						+ ") and not exists (select * from azdblab_queryexecutionprocs qp where qp.queryexecutionid = qe.queryexecutionid and qp.processname in (";

				for (int z = 0; z < badProcs.length; z++) {
					sql2 += "'" + badProcs[z].trim() + "'";
					if (z < badProcs.length - 1) {
						sql2 += ",";
					}
				}
				sql2 += "))";

				rs = LabShelfManager.getShelf().executeQuerySQL(sql2);
				rs.next();
				if (rs.getInt(1) < iterationsNeeded) {
					numViolations++;
				}
				rs.close();
			}

		}

		AZDBLabObserver.timerOn = true;
		return numViolations;
	}

	public int getStandardDeviationViolations(Run myRun, String runTimeFormula)
			throws Exception {
		AZDBLabObserver.timerOn = false;
		int numViolations = 0;
		List<Query> vecQueries = myRun.getExperimentRunQueries();
		for (int i = 0; i < vecQueries.size(); i++) {
			Query q = vecQueries.get(i);
			Vector<String> vecCard = new Vector<String>();
			String sql = "Select  distinct cardinality from azdblab_queryexecution where queryid = "
					+ q.getQueryID();
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				vecCard.add(rs.getString(1));
			}
			rs.close();

			for (int j = 0; j < vecCard.size(); j++) {
				String sql2 = "Select AVG("
						+ runTimeFormula
						+ "), STDDEV("
						+ runTimeFormula
						+ ") from azdblab_queryexecution qe, azdblab_querystatevaluation qea  where qe.queryid = "
						+ q.getQueryID() + " and qe.cardinality = "
						+ vecCard.get(j)
						+ " and qe.queryexecutionid = qea.queryexecutionid";
				rs = LabShelfManager.getShelf().executeQuerySQL(sql2);
				if (rs.next()) {
					if ((rs.getDouble(2) / rs.getDouble(1)) >= .2) {
						numViolations++;
					}
				}
				rs.close();
			}
		}

		AZDBLabObserver.timerOn = true;
		return numViolations;
	}

	public int getDBMSTimeViolations(Run myRun) throws Exception {
		String sql = "Select count(*) from azdblab_queryexecution qe, azdblab_querystatevaluation qea, azdblab_query q where q.runid = "
				+ myRun.getRunID()
				+ " and q.queryid = qe.queryid and qe.queryexecutionid = qea.queryexecutionid  and (qe.runtime - qea.totalOtherTime) < qea.totaldbmstime and (qe.runtime - qea.totalothertime) > 0";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		if (rs.next()) {
			return rs.getInt(1);
		}
		rs.close();

		return 0;
	}

	public int getNumberMonotonicityViolations(Run myRun, String runtimeFormula)
			throws Exception {
		AZDBLabObserver.timerOn = false;
		int numViolations = 0;
		List<Query> vecQueries = myRun.getExperimentRunQueries();
		for (int i = 0; i < vecQueries.size(); i++) {
			String sql = "Select Distinct cardinality from azdblab_queryexecution where queryid = "
					+ vecQueries.get(i).getQueryID();

			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			Vector<Integer> vecCard = new Vector<Integer>();
			while (rs.next()) {
				vecCard.add(rs.getInt(1));
			}
			rs.close();
			Vector<CardinalityLevel> vecLevels = new Vector<CardinalityLevel>();
			for (int j = 0; j < vecCard.size(); j++) {
				String sql2 = "Select stdDev("
						+ runtimeFormula
						+ "), avg("
						+ runtimeFormula
						+ "), qep.planid from azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep, azdblab_querystatevaluation qea where qe.cardinality = "
						+ vecCard.get(j)
						+ " and qe.queryid = "
						+ vecQueries.get(i).getQueryID()
						+ " and qe.queryexecutionid = qep.queryexecutionid and qe.queryexecutionid = qea.queryexecutionid group by qep.planid";
				rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql2);
				if (rs.next()) {
					vecLevels.add(new CardinalityLevel(vecCard.get(j), rs
							.getDouble(1), rs.getDouble(2), rs.getLong(3)));
				}
			}
			for (int q = 0; q < vecLevels.size(); q++) {
				for (int x = 0; x < vecLevels.size(); x++) {
					CardinalityLevel cardHigh = vecLevels.get(q);
					CardinalityLevel cardLow = vecLevels.get(x);
					if (cardHigh.planID == cardLow.planID
							&& cardHigh.cardinality > cardLow.cardinality) {
						if ((cardHigh.stdDev + cardHigh.avg) < (cardLow.avg - cardLow.stdDev)) {
							numViolations++;
						}
					}
				}
			}

		}

		AZDBLabObserver.timerOn = true;
		return numViolations;

	}

	/**
	 * returns the number of queries associated with this run
	 */
	public int getNumberQueries(Run myRun) {
		return myRun.getExperimentRunQueries().size();
	}

	private class CardinalityLevel {
		int cardinality;
		double stdDev;
		double avg;
		long planID;

		public CardinalityLevel(int cardinality, double stdDev, double avg,
				long planID) {
			this.cardinality = cardinality;
			this.stdDev = stdDev;
			this.avg = avg;
			this.planID = planID;
		}

	}
	
	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}

}
