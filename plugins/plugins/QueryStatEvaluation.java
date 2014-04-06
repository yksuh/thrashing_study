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
* Young-Kyoon Suh 
* Rui Zhang (http://www.cs.arizona.edu/people/ruizhang/)
*/
package plugins;

import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;
import java.util.regex.Pattern;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.plugins.evaluation.Evaluation;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.dialogs.ProgressDlg;
import azdblab.swingUI.dialogs.ResultPaneDlg;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.objectNodes.CompletedRunNode;
import azdblab.swingUI.objectNodes.ScenarioNode;
import azdblab.swingUI.objectNodes.QueryNode;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;

/**
 * The purpose of queryStatEvaluation is to extend the functionality of
 * AZDBLAB_QUERYEXECUTION by parsing the procdiff.
 * <p>
 * 
 * This aspect is responsible for creating and populating the following tables.
 * AZDBLAB_QUERYEXECUTIONASPECT which contains tick and derived runtime
 * information.
 * <p>
 * 
 * Additionally it creates AZDBLAB_QUERYEXECUTIONPROCS which details every
 * process that is run during an execution, in addition to storing data such as
 * their u/stime
 * 
 * @author mwj
 * 
 */
public class QueryStatEvaluation extends Evaluation {
	public static String MYNAME = "QueryStatEvaluation";
	//@Override
	
	public QueryStatEvaluation(ObjectNode sent) {
		super(sent);
	}


	/**
	 * Returns either the scenario or the run level buttons
	 */
	@Override
	public Vector<JButton> getButtons() {

		if (myObjectNode instanceof CompletedRunNode) {
			return getCompletedRunLevelButtons();
		} else if (myObjectNode instanceof ScenarioNode) {
			return getScenarioLevelButtons();
		}
		return null;
	}

	/**
	 * Returns the scenario level button
	 * 
	 * @return
	 */
	private Vector<JButton> getScenarioLevelButtons() {

		JButton btn_CalculateEvaluations = new JButton(
				"Calculate Children's Evaluations");
		btn_CalculateEvaluations.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					calculateAspects();
				} catch (Exception x) {
					JOptionPane
							.showMessageDialog(null,
									"An exception occured, failed to compute all queryStatEvaluations");
					x.printStackTrace();
				}
			}
		});

		Vector<JButton> toRet = new Vector<JButton>();
		toRet.add(btn_CalculateEvaluations);
		return toRet;
	}

	/**
	 * This is the scenario level method that calculates all child aspects
	 * 
	 * @throws Exception
	 */
	private void calculateAspects() throws Exception {

		List<Experiment> experiments = User
				.getUser(((ScenarioNode) myObjectNode).getUserName())
				.getNotebook(((ScenarioNode) myObjectNode).getNotebookName())
				.getAllExperiments();
		ProgressDlg progDlg = new ProgressDlg();
		for (int i = 0; i < experiments.size(); i++) {
			if (experiments.get(i).getScenario()
					.equals(((ScenarioNode) myObjectNode).getScenario())) {
				List<Run> vecCompRuns = experiments.get(i).getCompletedRuns();
				progDlg.setTitle("Query Evaluation Progress: "
						+ experiments.get(i).getExperimentName());
				for (int j = 0; j < vecCompRuns.size(); j++) {
					computeQueryExecutionStats(vecCompRuns.get(j));
					progDlg.updateProgress("Computing Stats for "
							+ vecCompRuns.get(j).getExperimentName() + " : "
							+ vecCompRuns.get(j).getStartTime(), j
							/ vecCompRuns.size());
				}
			}
		}
		progDlg.dispose();
	}

	/**
	 * returns the run level button
	 * 
	 * @return
	 */
	private Vector<JButton> getCompletedRunLevelButtons() {
		JButton btn_ComputeQueryExecutionData = new JButton(
				"Compute Query Stat Evaluation");

		btn_ComputeQueryExecutionData.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				computeQueryExecutionStats(User
						.getUser(
								((CompletedRunNode) myObjectNode).getUserName())
						.getNotebook(
								((CompletedRunNode) myObjectNode)
										.getNotebookName())
						.getExperiment(
								((CompletedRunNode) myObjectNode)
										.getExperimentName())
						.getRun(((CompletedRunNode) myObjectNode)
								.getStartTime()));

			}
		});

		Vector<JButton> toRet = new Vector<JButton>();
		toRet.add(btn_ComputeQueryExecutionData);
		return toRet;
	}

	@Override
	public String getName() {
		return MYNAME;
	}

	public static final boolean refreshTable = false;

	@Override
	public Vector<InternalTable> getTables() {
		if (refreshTable) {
			LabShelfManager.getShelf()
					.dropTable(QUERYSTATEVALUATION.TableName);
			LabShelfManager.getShelf().dropTable(RUNHASASPECT.TableName);
			LabShelfManager.getShelf().dropTable(QUERYEXECUTIONPROCS.TableName);
		}

		Vector<InternalTable> toRet = new Vector<InternalTable>();
		toRet.add(QUERYSTATEVALUATION);
		toRet.add(RUNHASASPECT);
		toRet.add(QUERYEXECUTIONPROCS);
		// toRet.add(COMMENT);
		return toRet;
	}

	@Override
	public JPanel getTabs() {
		if (myObjectNode instanceof QueryNode) {
			if (((AZDBLABMutableTreeNode) myObjectNode.getParent().getParent())
					.getUserObject() instanceof CompletedRunNode) {
				return getQueryViewTab();
			}
		}
		return null;
	}

	public static InternalTable RUNHASASPECT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_RUNHASASPECT,
			new String[] { "AspectName", "RunID" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 100, 10 },
			new int[] { 0, 0 }, null, new String[] { "AspectName", "RunID" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);

	// public static final InternalTable COMMENT = new
	// InternalTable(Constants.TABLE_PREFIX + Constants.TABLE_COMMENT, new
	// String[] { "RunID", "Comments", "DateAdded" }, new int[] {
	// GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_CLOB,
	// GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 10, -1, 100 }, new int[] {
	// 0, 0, 0 }, null, new String[] { "RunID", "DateAdded" }, new ForeignKey[]
	// { new ForeignKey(new String[] { "RunID" }, Constants.TABLE_PREFIX +
	// Constants.TABLE_EXPERIMENTRUN, new String[] { "RunID" },
	// " ON DELETE CASCADE") }, null);

    public static InternalTable QUERYEXECUTIONPROCS = new InternalTable(
            Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTIONPROCS,
            new String[] { "QueryExecutionID", "ProcessID", "VM", "ProcessName",
                    "UTicks", "STicks", "CTime", "min_flt", "maj_flt", 
                    "blkio_count", "blockio_delay", "btime", "cpu_count", "cpu_delay",
                    "cpu_run_real_total", "cpu_run_virtual_total", "cpu_scaled_run_real_total", "etime", "freepgs_count", 
                    "freepgs_delay", "nivcsw", "nvcsw", "read_bytes", "read_char", 
                    "read_syscalls", "sTickScaled", "swapin_count", "swapin_delay", "uTickScaled", 
                    "write_bytes", "write_char", "write_syscalls" },
            new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_VARCHAR,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER,
                    GeneralDBMS.I_DATA_TYPE_NUMBER},
            new int[] { 10, 5, 1, 32,
                    16, 16, 16, 16, 16,
                    16, 16, 16, 16, 16,
                    16, 16, 16, 16, 16,
                    16, 16, 16, 16, 16,
                    16, 16, 16, 16, 16,
                    16, 16, 16},
            new int[] { 0, 0, 0, 0, 
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0},
            null,
            new String[] { "QueryExecutionID", "ProcessID", "VM" },
            new ForeignKey[] { new ForeignKey(
                    new String[] { "QueryExecutionID" }, Constants.TABLE_PREFIX
                            + Constants.TABLE_QUERYEXECUTION,
                    new String[] { "QueryExecutionID" }, " ON DELETE CASCADE") },
            null);

	public static InternalTable QUERYSTATEVALUATION = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYSTATEVALUATION,
			new String[] { "QueryExecutionID", "TotalOtherTime",
					"NumPhantomsPresent", "TotalFaults", "StoppedProcesses",
					"TotalDBMSTime", "NumStartedProcesses",
					"NumExecutedProcesses", "userModeTicks",
					"lowPriorityUserModeTicks", "systemModeTicks",
					"idleTaskTicks", "ioWait", "irq", "softirq",
					"stealStolenTicks", "NumBadProcs", "dbmsIOWait", "otherIOWait" },
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
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER},
			new int[] { 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
					10, 10, 10, 10, 10 },
			new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
			null,
			new String[] { "QueryExecutionID" },
			new ForeignKey[] { new ForeignKey(
					new String[] { "QueryExecutionID" }, Constants.TABLE_PREFIX
							+ Constants.TABLE_QUERYEXECUTION,
					new String[] { "QueryExecutionID" }, " ON DELETE CASCADE") },
			null);

	@Override
	public Evaluation getInstance(ObjectNode sent) {
		return new QueryStatEvaluation(sent);
	}

	@Override
	public Vector<String> getSupportedClasses() {
		Vector<String> toRet = new Vector<String>();
		toRet.add("CompletedRunNode");
		toRet.add("ScenarioNode");
		toRet.add("QueryNode");
		return toRet;
	}

	public static final String[] DBMSProcessNames = { "oracle", "db2", "mysql",
			"postgres", "sqlserver", "sqlservr", "pgsql", "postmaster" };

	private boolean isDBMS(String sent) {
		for (int i = 0; i < DBMSProcessNames.length; i++) {
			if (sent.contains(DBMSProcessNames[i])) {
				return true;
			}
		}
		return false;
	}

	public void computeQueryExecutionStats(Run toCompute) {
		if (toCompute.isInAspect(MYNAME)) {
			System.out.println("Completed Records for RunID:"
					+ toCompute.getRunID() + " Already Exist");
			return;
		}
		AZDBLabObserver.timerOn = false;
		int numSeen = 0, numFailed = 0;
		String sql = "Select  qe.procdiff, qe.queryexecutionid from azdblab_queryexecution qe, azdblab_query q where q.runid = "
				+ toCompute.getRunID() + " and q.queryid = qe.queryid";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				try {
					numSeen++;
					int userModeTicks = 0, lowPriorityUserModeTicks = 0, systemModeTicks = 0, idleTaskTicks = 0, ioWaitTicks = 0, irq = 0, softirq = 0, stealStolenTicks = 0;
					int numPhantoms = 0;
					int numStoppedProcesses = 0;
					int numExecutedProcesses = 0, NumStartedProcesses = 0;
					String toTest = LabShelfManager.getShelf().getStringFromClob(rs, 1).replace("\n", " ").toLowerCase();


					String nonVMProcs = toTest.split("VM:")[0];
					String vmProcs = "";
					if (toTest.split("VM:").length > 1) {
						vmProcs = toTest.split("VM:")[1];
					}
					/***
					 * Parse existing processes to find out other time Do not
					 * include DBMSes
					 */

					Vector<ProcessInfo> vec_myProcesses = new Vector<ProcessInfo>();
					
					// non-VM
					numExecutedProcesses = parseAllProcesses(
							numExecutedProcesses, 
							Pattern.compile("\\)").split(nonVMProcs), vec_myProcesses, false);
					numExecutedProcesses += parseAllProcesses(
							numExecutedProcesses, Pattern.compile("\\)").split(vmProcs), vec_myProcesses, true);
					saveAllProcesses(vec_myProcesses, rs.getInt(2));
					
					int numFaults = 0;
					int finalOtherTime = 0;
					int finaldbmsTime = 0;
					long dbmsIOWait = 0;
					long otherIOWait = 0;
					for (int i = 0; i < vec_myProcesses.size(); i++) {
						if (isDBMS(vec_myProcesses.get(i).processName)) {
							finaldbmsTime += vec_myProcesses.get(i).uTick
									+ vec_myProcesses.get(i).sTick;
							if (dbmsIOWait < vec_myProcesses.get(i).blockio_delay)
								dbmsIOWait = vec_myProcesses.get(i).blockio_delay;
						} else {
							finalOtherTime += vec_myProcesses.get(i).uTick
									+ vec_myProcesses.get(i).sTick;
							numFaults += vec_myProcesses.get(i).min_flt
									+ vec_myProcesses.get(i).maj_flt;
							if (otherIOWait < vec_myProcesses.get(i).blockio_delay)
								otherIOWait = vec_myProcesses.get(i).blockio_delay;
						}
					}

					int numBadProcs = 0;
					for (int i = 0; i < vec_myProcesses.size(); i++) {
						if (isBadProc(vec_myProcesses.get(i).processName)) {
							numBadProcs++;
						}
					}

					try {
						String[] result = toTest.split("\\)");
						String body = result[result.length - 1];
						String[] tickInformation = body.split("phantom processes:")[0].split("increased ticks:");

						if (tickInformation.length > 1) {
							String tickInfo = tickInformation[1];
							tickInfo = tickInfo.replace("increased ticks:", "");
							tickInfo = tickInfo.replace("[", "");
							tickInfo = tickInfo.replace("]", "");
							String[] ticks = tickInfo.split(",");
							for (int i = 0; i < ticks.length; i++) {
								String tmpString = ticks[i];
								tmpString = tmpString.replace(",", "");
								int tmpTick = Integer
										.parseInt(tmpString.split(":")[1].trim());

								if (tmpString.contains("lowpriorityusermodeticks")) {
									lowPriorityUserModeTicks += tmpTick;
								} else if (tmpString.contains("usermodeticks")) {
									userModeTicks += tmpTick;
								} else if (tmpString.contains("systemmodeticks")) {
									systemModeTicks += tmpTick;
								} else if (tmpString.contains("idletaskticks")) {
									idleTaskTicks += tmpTick;
								} else if (tmpString.contains("iowaitticks")) {
									ioWaitTicks += tmpTick;
								} else if (tmpString.contains("stealstolenticks")) {
									stealStolenTicks += tmpTick;
								} else if (tmpString.contains("softirqticks")) {
									softirq += tmpTick;
								}
							}
						}
						finaldbmsTime = finaldbmsTime
								+ (ioWaitTicks + softirq) * 10;
						LabShelfManager
								.getShelf()
								.insertTuple(
										Constants.TABLE_PREFIX
												+ Constants.TABLE_QUERYSTATEVALUATION,
										QUERYSTATEVALUATION.columns,
										new String[] {
												rs.getString(2),
												String.valueOf(finalOtherTime),
												String.valueOf(numPhantoms),
												String.valueOf(numFaults),
												String.valueOf(numStoppedProcesses),
												String.valueOf(finaldbmsTime),
												String.valueOf(NumStartedProcesses),
												String.valueOf(numExecutedProcesses),
												String.valueOf(userModeTicks),
												String.valueOf(lowPriorityUserModeTicks),
												String.valueOf(systemModeTicks),
												String.valueOf(idleTaskTicks),
												String.valueOf(ioWaitTicks),
												String.valueOf(irq),
												String.valueOf(softirq),
												String.valueOf(stealStolenTicks),
												String.valueOf(numBadProcs),
												String.valueOf(dbmsIOWait),
												String.valueOf(otherIOWait)},
										QUERYSTATEVALUATION.columnDataTypes);
					} catch (Exception x) {
						// if this was thrown it means the record already
						// exists,
						// thus an update is required
						x.printStackTrace();
						String updateSQL = "Update " + Constants.TABLE_PREFIX
								+ Constants.TABLE_QUERYSTATEVALUATION
								+ " set totalOtherTime = " + finalOtherTime
								+ " , NumPhantomsPresent = " + numPhantoms
								+ " , TotalFaults = " + numFaults
								+ " , StoppedProcesses = "
								+ numStoppedProcesses + " , totalDBMSTime = "
								+ finaldbmsTime + " , NumStartedProcesses = "
								+ NumStartedProcesses
								+ " , NumExecutedProcesses = "
								+ (numExecutedProcesses - 1)
								+ ", userModeTicks = " + userModeTicks
								+ ", lowPriorityUserModeTicks = "
								+ lowPriorityUserModeTicks
								+ ", systemModeTicks = " + systemModeTicks
								+ ", idleTaskTicks = " + idleTaskTicks
								+ ", ioWait = " + ioWaitTicks
								+ ", irq = " + irq
								+ ", softirq = " + softirq
								+ ", stealStolenTicks = " + stealStolenTicks
								+ ", numBadProcs = " + numBadProcs
								+ " where queryexecutionid = "
								+ rs.getString(2);
						LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
					}
				} catch (Exception y) {
					y.printStackTrace();
					numFailed++;
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("Attempted to process " + numSeen
				+ " queryExecutions");
		System.out
				.println("Failed to update " + numFailed + " queryExecutions");
		if (numFailed == 0) {
			try {
				LabShelfManager.getShelf().insertTuple(
						QueryStatEvaluation.RUNHASASPECT.TableName,
						QueryStatEvaluation.RUNHASASPECT.columns,
						new String[] { MYNAME, String.valueOf(toCompute.getRunID()) },
						QueryStatEvaluation.RUNHASASPECT.columnDataTypes);
			} catch (Exception e) {
				e.printStackTrace();
			}
//			toCompute.addToAspect(MYNAME);
		}
		LabShelfManager.getShelf().commit();
		LabShelfManager.getShelf().commitlabshelf();
		AZDBLabObserver.timerOn = true;
	}


	private int parseAllProcesses(int numExecutedProcesses, String[] result,
			Vector<ProcessInfo> vec_myProcesses, boolean VM) {
		for (int i = 0; i < result.length-1; i++) {
			numExecutedProcesses++;
			ProcessInfo proc = parseProcess(result[i]);
			
			if (proc != null) {
				proc.vm = VM;
				vec_myProcesses.add(proc);
			}
		}
		return numExecutedProcesses;
	}


	private ProcessInfo parseProcess(String procNode) {
		
		String[] id_body = procNode.split("\\(");
		int procID = Integer.parseInt(id_body[0].trim());
		String processBody = id_body[1];
		String[] processInfo = processBody.split(",");
		String processName = processInfo[0];
		ProcessInfo myProcess = new ProcessInfo(procID,
				processName);
		try {
		for (int j = 1; (j < processInfo.length); j++) {
			String procStat = processInfo[j]; 
			if (procStat.contains("btime")) { 
				myProcess.btime = Integer.parseInt(procStat.split(":")[1].trim());
			} else if (procStat.contains("etime")) {
				myProcess.etime = Integer.parseInt(procStat.split(":")[1]);
			} else if (procStat.contains("utime ")) { 
				myProcess.uTick = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("stime ")) {
				myProcess.sTick = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("min_flt")) {
				myProcess.min_flt = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("maj_flt")) {
				myProcess.maj_flt = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("r_chr")) {
				myProcess.read_char = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("w_chr")) {
				myProcess.write_char = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("r_calls")) {
				myProcess.read_syscalls = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("r_bytes")) {
				myProcess.read_bytes = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("w_bytes")) {
				myProcess.write_bytes = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("nvcsw")) {
				myProcess.nvcsw = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("nivcsw")) {
				myProcess.nivcsw = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("utimes")) {
				myProcess.uTickScaled = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("stimes")) {
				myProcess.sTickScaled = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("cpures")) {
				myProcess.cpu_scaled_run_real_total = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("freepgs")) {
				myProcess.freepgs_count = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("freepgd")) {
				myProcess.freepgs_delay = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("cpucnt")) {
				myProcess.cpu_count = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("cpudel")) {
				myProcess.cpu_delay = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("blkcnt")) {
				myProcess.blockio_count = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("blkdel")) {
				myProcess.blockio_delay = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("swpcnt")) {
				myProcess.swapin_count = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("swpdel")) {
				myProcess.swapin_delay = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("cpu_ret")) {
				myProcess.cpu_run_real_total = Integer.parseInt(procStat.split("=")[1].trim());
			} else if (procStat.contains("cpu_rvt")) {
				myProcess.cpu_run_virtual_total = Integer.parseInt(procStat.split("=")[1].trim());
			}
		}
		if  (processInfo.length > 4)
			return (myProcess);
		} catch (Exception e) {
			System.out.println("Not to worry, everything is fine!");
		}
		return null;
	}

	private boolean isBadProc(String procName) {
		for (int i = 0; i < badProcs.length; i++) {
			if (procName.equalsIgnoreCase(badProcs[i])) {
				return true;
			}
		}
		return false;
	}

	private void saveAllProcesses(Vector<ProcessInfo> toSave,
			int queryExecutionID) {
		for (int i = 0; i < toSave.size(); i++) {
			try {
				ProcessInfo curProc = toSave.get(i);
				LabShelfManager.getShelf().insertTuple( 
					Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYEXECUTIONPROCS,
					QUERYEXECUTIONPROCS.columns,
					new String[] {
						String.valueOf(queryExecutionID),
						String.valueOf(curProc.processID),
						curProc.vm?"1":"0",
						String.valueOf(curProc.processName.trim()),
						String.valueOf(curProc.uTick),
						String.valueOf(curProc.sTick),
						String.valueOf(curProc.uTick+curProc.sTick),
						String.valueOf(curProc.min_flt),
						String.valueOf(curProc.maj_flt),
                    	String.valueOf(curProc.blockio_count),
                    	String.valueOf(curProc.blockio_delay),
                    	String.valueOf(curProc.btime),
                        String.valueOf(curProc.cpu_count),
                        String.valueOf(curProc.cpu_delay),
                        String.valueOf(curProc.cpu_run_real_total),
    	                String.valueOf(curProc.cpu_run_virtual_total),
            	        String.valueOf(curProc.cpu_scaled_run_real_total),
                    	String.valueOf(curProc.etime),
                        String.valueOf(curProc.freepgs_count),
                        String.valueOf(curProc.freepgs_delay),
                        String.valueOf(curProc.nivcsw),
    	                String.valueOf(curProc.nvcsw),
            	        String.valueOf(curProc.read_bytes),
                    	String.valueOf(curProc.read_char),
                        String.valueOf(curProc.read_syscalls),
                        String.valueOf(curProc.sTickScaled),
                        String.valueOf(curProc.swapin_count),
    	                String.valueOf(curProc.swapin_delay),
            	        String.valueOf(curProc.uTickScaled),
                    	String.valueOf(curProc.write_bytes),
                        String.valueOf(curProc.write_char),
                        String.valueOf(curProc.write_syscalls) },
					QUERYEXECUTIONPROCS.columnDataTypes);

			} catch (Exception e) {
				e.printStackTrace();
				String updateSQL = "Update " + Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYEXECUTIONPROCS
						+ " set ProcessName = '" + toSave.get(i).processName.trim()+"',"
				        + " UTicks = " + toSave.get(i).uTick + ","
						+ " STicks = " + toSave.get(i).sTick + " , " 
						+ " min_flt = " + toSave.get(i).min_flt+ ", " 
						+ " maj_flt = " + toSave.get(i).maj_flt+ ", "
						+ " blkio_count = " + toSave.get(i).blockio_count+ ", "
						+ " blockio_delay = " + toSave.get(i).blockio_delay+ ", "
						+ " btime = " + toSave.get(i).btime+ ", "
						+ " cpu_count = " + toSave.get(i).cpu_count+ ", "
						+ " cpu_delay = " + toSave.get(i).cpu_delay+ ", "
						+ " cpu_run_real_total = " + toSave.get(i).cpu_run_real_total+ ", "
						+ " cpu_run_virtual_total = " + toSave.get(i).cpu_run_virtual_total+ ", "
						+ " cpu_scaled_run_real_total = " + toSave.get(i).cpu_scaled_run_real_total+ ", "
						+ " etime = " + toSave.get(i).etime+ ", "
						+ " freepgs_count = " + toSave.get(i).freepgs_count+ ", "
						+ " freepgs_delay = " + toSave.get(i).freepgs_delay+ ", "
						+ " nivcsw = " + toSave.get(i).nivcsw+ ", "
						+ " nvcsw = " + toSave.get(i).nvcsw+ ", "
						+ " ProcessID = " + toSave.get(i).processID+ ", "
						+ " read_bytes = " + toSave.get(i).read_bytes+ ", "
						+ " read_char = " + toSave.get(i).read_char+ ", "
						+ " read_syscalls = " + toSave.get(i).read_syscalls+ ", "
						+ " sTickScaled = " + toSave.get(i).sTickScaled+ ", "
						+ " swapin_count = " + toSave.get(i).swapin_count+ ", "
						+ " swapin_delay = " + toSave.get(i).swapin_delay+ ", "
						+ " uTickScaled = " + toSave.get(i).uTickScaled+ ", "
						+ " write_bytes = " + toSave.get(i).write_bytes+ ", "
						+ " write_char = " + toSave.get(i).write_char+ ", "
						+ " write_syscalls = " + toSave.get(i).write_syscalls
						+ " where QueryExecutionID = " + queryExecutionID
						+ " and processID = " + toSave.get(i).processID;
				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
			}
		}
		LabShelfManager.getShelf().commit();
	}

	public static boolean executionExists(int queryExecutionID) {
		String sql = "Select * from azdblab_queryexecutionaspect where queryexecutionid = "
				+ queryExecutionID;
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(sql);
			if (rs.next()) {
				rs.close();
				return true;
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}


	private class ProcessInfo {
		public int etime;
		int processID;
		boolean vm;
		String processName;
		long cTime, eTime, uTick, sTick, min_flt, maj_flt, 
			btime, read_char, write_char,
			read_syscalls, write_syscalls,
			read_bytes, write_bytes, 
			nvcsw, nivcsw, uTickScaled,
			sTickScaled, cpu_scaled_run_real_total,
			freepgs_count, freepgs_delay, cpu_count,
			cpu_delay, blockio_count, blockio_delay,
			swapin_count, swapin_delay, cpu_run_real_total,
			cpu_run_virtual_total;

		public ProcessInfo(int pID, String procName) {
			processID = pID;
			processName = procName;
			cTime = 0;
			uTick = 0;
			sTick = 0;
			min_flt = 0;
			maj_flt = 0;
		}
	}

	/*
	 * 
	 * 
	 * Begin View aspect section
	 */

	private JTextArea txt_Formula;
	private JTextArea txt_Failure;
	private JTextField txt_MinExecutions;
	private JTextArea txt_BadProcs;
	private int planNum = 0;

	private HashMap<Long, Integer> seenPlans;

	private JPanel getQueryViewTab() {
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
				generateDialog(txt_Formula.getText(), txt_Failure.getText(),
						Integer.parseInt(txt_MinExecutions.getText().trim()),
						txt_BadProcs.getText().split(","),
						(QueryNode) myObjectNode);
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

	private String getDefaultBadProcs() {
		return "yum-updatesd,yum-updatesd-he";
	}

	private void generateDialog(String computeTime, String computeFailure,
			int minExecutions, String[] badProcs, QueryNode sent) {
		seenPlans = new HashMap<Long, Integer>();
		String html = "<HTML><BODY>";
		html += "<h1> Basic View</h1>";
		html += "<table border=\"1\"";
		html += "<tr>";
		html += "<th>Cardinality</th>";
		html += "<th>Plan#</th>";
		html += "<th>Min Execution</th>";
		html += "<th>Max Execution</th>";
		html += "<th>Avg Execution</th>";
		html += "<th>Standard Deviation</th>";
		html += "<th>Execution 1</th>";
		html += "<th>Execution 2</th>";
		html += "<th>Execution 3</th>";
		html += "<th>Execution 4</th>";
		html += "<th>Execution 5</th>";
		html += "<th>Execution 6</th>";
		html += "<th>Execution 7</th>";
		html += "<th>Execution 8</th>";
		html += "<th>Execution 9</th>";
		html += "<th>Execution 10</th>";
		html += "</tr>";

		DecimalFormat df = new DecimalFormat("#.##");
		try {
			String sql = "select distinct cardinality from azdblab_queryexecution where queryid = "
					+ sent.getQueryID() + " order by cardinality desc";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			Vector<String> vecCard = new Vector<String>();
			while (rs.next()) {
				vecCard.add(rs.getString(1));
			}
			rs.close();
			for (int i = 0; i < vecCard.size(); i++) {
				sql = "select ("
						+ computeTime
						+ ") as ComputedTime , qp.planID, qe.queryexecutionid from azdblab_queryexecution qe, AZDBLAB_QUERYEXECUTIONHASPLAN qp, "
						+ Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYSTATEVALUATION
						+ " qea where qe.queryid = "
						+ sent.getQueryID()
						+ " and qe.cardinality = "
						+ vecCard.get(i)
						+ " and qe.queryexecutionid = qp.queryexecutionid and qe.queryexecutionid = qea.queryexecutionid order by iternum";
				// System.out.println(sql);
				rs = LabShelfManager.getShelf().executeQuerySQL(sql);

				ArrayList<Execution> tmp = new ArrayList<Execution>();

				long PlanID = 0;
				while (rs.next()) {
					tmp.add(new Execution(rs.getInt(1), rs.getInt(3)));
					PlanID = rs.getLong(2);
				}
				rs.close();

				sql = "Select qe.queryexecutionid from "
						+ Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYEXECUTION
						+ " qe, "
						+ Constants.TABLE_PREFIX
						+ Constants.TABLE_QUERYSTATEVALUATION
						+ " qea where qe.queryid = "
						+ sent.getQueryID()
						+ " and qe.cardinality = "
						+ vecCard.get(i)
						+ " and qe.queryexecutionid = qea.queryexecutionid and ("
						+ computeFailure + ")";
				rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				while (rs.next()) {
					int tmpID = rs.getInt(1);
					for (int j = 0; j < tmp.size(); j++) {
						if (tmp.get(j).queryExecutionID == tmpID) {
							tmp.get(j).isValid = false;
						}
					}
				}
				rs.close();
				// determine whether or not the executions contain a bad proc
				for (int k = 0; k < tmp.size(); k++) {
					if (tmp.get(k).isValid) {
						sql = "Select count(*) from " + Constants.TABLE_PREFIX
								+ Constants.TABLE_QUERYEXECUTIONPROCS
								+ " where queryexecutionid = "
								+ tmp.get(k).queryExecutionID
								+ " and ProcessName IN (";
						for (int l = 0; l < badProcs.length; l++) {
							sql += "'" + badProcs[l].trim() + "'";
							if (l < badProcs.length - 1) {
								sql += ",";
							}
						}
						sql += ")";
					}
					rs = LabShelfManager.getShelf().executeQuerySQL(sql);
					rs.next();
					if (rs.getInt(1) > 0) {
						tmp.get(k).isValid = false;
					}
				}

				boolean isValid = false;
				int numValid = getNumValid(tmp);
				if (numValid >= minExecutions) {
					isValid = true;
				}
				html += "<tr>";
				if (!isValid) {
					html += "<td style=\"background-color:#ff0000\">"
							+ vecCard.get(i) + "</td>";
				} else {
					html += "<td>" + vecCard.get(i) + "</td>";
				}

				html += "<td>" + getPlanNumber(PlanID) + "</td>";

				int min = 9999999;
				int max = 0;
				int sum = 0;
				for (int j = 0; j < tmp.size(); j++) {
					if (!tmp.get(j).isValid) {
						continue;
					}
					sum += tmp.get(j).runtime;
					if (tmp.get(j).runtime > max) {
						max = tmp.get(j).runtime;
					}
					if (tmp.get(j).runtime < min) {
						min = tmp.get(j).runtime;
					}
				}
				if (tmp.size() != 0) {
					try {
						int avg = sum / numValid;
						html += "<td>" + min + "</td>";
						html += "<td>" + max + "</td>";
						html += "<td>" + avg + "</td>";

						sum = 0;
						for (int j = 0; j < tmp.size(); j++) {
							if (!tmp.get(j).isValid) {
								continue;
							}
							sum += Math.pow(avg - tmp.get(j).runtime, 2);
						}
						double stdDev = Math.sqrt(sum / tmp.size());

						html += "<td>" + df.format(stdDev) + "</td>";
					} catch (Exception e) {
						html += "<td>---</td>";
						html += "<td>---</td>";
						html += "<td>---</td>";
						html += "<td>---</td>";
					}
				}

				for (int j = 0; j < 10; j++) {
					if (j < tmp.size()) {
						if (tmp.get(j).isValid) {
							if (tmp.get(j).runtime == min) {
								html += "<td style=\"background-color:#aaffaa\">";
							} else if (tmp.get(j).runtime == max) {
								html += "<td style=\"background-color:#ffcccc\">";
							} else {
								html += "<td>";
							}
							html += tmp.get(j).runtime + "</td>";
						} else {
							html += "<td> <b>" + tmp.get(j).runtime
									+ " </b></td>";
						}

					} else {
						html += "<td>None</td>";
					}
				}

				html += "</tr>";
				rs.close();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
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

		html += "<h2> Output Information </h2>";
		html += "<table border=\"1\">";
		html += "<tr>";
		html += "<th>Value</th>";
		html += "<th>Meaning</th>";
		html += "</tr>";

		html += "<tr>";
		html += "<td style=\"background-color:#ffcccc\">Light Red Cells</td>";
		html += "<td>This is the execution with the highest runtime</td>";
		html += "</tr>";

		html += "<tr>";
		html += "<td style=\"background-color:#aaffaa\">Light Green Cells</td>";
		html += "<td>This is the execution with the lowest runtime</td>";
		html += "</tr>";

		html += "<tr>";
		html += "<td style=\"background-color:#ff0000\">Dark Red Cells</td>";
		html += "<td>This cardinality has fewer than 6 valid executions</td>";
		html += "</tr>";

		html += "<tr>";
		html += "<td><b>Bolded Text</b></td>";
		html += "<td>This execution is invalid, and does not influence the calculations</td>";
		html += "</tr>";

		html += "</BODY></HTML>";
		ResultPaneDlg resDlg = new ResultPaneDlg(html);
		Run myRun = User.getUser(sent.getUserName())
				.getNotebook(sent.getNotebookName())
				.getExperiment(sent.getExperimentName())
				.getRun(sent.getStartTime());
		resDlg.setTitle("ResultView: " + myRun.getScenario() + "-"
				+ myRun.getExperimentName() + "-" + myRun.getDBMS() + "-"
				+ myRun.getStartTime() + "- Query: " + sent.getQueryNumber());
		resDlg.setVisible(true);
	}

	private int getNumValid(ArrayList<Execution> sent) {
		int toRet = 0;
		for (int i = 0; i < sent.size(); i++) {
			if (sent.get(i).isValid) {
				toRet++;
			}
		}
		return toRet;
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

	private int getPlanNumber(long planID) {
		if (seenPlans.containsKey(planID)) {
			return seenPlans.get(planID);
		} else {
			seenPlans.put(planID, planNum);
			planNum++;
			return seenPlans.get(planID);
		}
	}

	class Execution {
		int runtime;
		boolean isValid;
		int queryExecutionID;

		public Execution(int runtime, int executionID) {
			this.runtime = runtime;
			queryExecutionID = executionID;
			isValid = true;
		}
	}
	
	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
	
	public static String strVersion = "1.01";
	public static String getVersion() {
		return strVersion;
	}

	private static final String[] badProcs = { "ata/0", "md0_raid1",
			"md1_raid1", "kjournald", "automount", "mdadm", "scsi_eh_0",
			"scsi_eh_2", "hald-addon-stor", "pcscd", "events/0",
			"yum-updatesd-he", "yum-updatesd", "kblockd/0", "pdflush",
			"makewhatis", "dbus-daemon", "gawk", "awk", "auditd", "smartd",
			"iscsid", "run-parts", "umount", "umount.nfs", "gdm-rh-security",
			"savservice", "iastordatamgrsvc", "swi_service", "almon",
			"iastoricon", "proquota", "alupdate", "alsvc" };
}
