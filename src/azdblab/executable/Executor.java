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
package azdblab.executable;

import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.Timer;
import java.util.Vector;

import azdblab.Constants;
import azdblab.swingUI.objectNodes.PendingRunNode;
import azdblab.swingUI.objectNodes.PausedRunNode;
import azdblab.swingUI.objectNodes.RunningRunNode;
import azdblab.swingUI.objectNodes.RunStatusNode;
import azdblab.utility.watcher.AZDBNotification;
import azdblab.utility.watcher.RegisterMBean;
import azdblab.utility.watcher.StreamHandler;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.model.experiment.RunExperiment;

import java.util.TimerTask;

import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;

public class Executor extends NotificationBroadcasterSupport implements
		ExecutorMBean/* extends javax.swing.JFrame */{

	public static final long serialVersionUID = System
			.identityHashCode("Executor");
	
	public static int VMProcMonPortNum = 7000;
	public static String VMProcMonHostname = "";

	public class ExecutorStatus {

		public String strCurrentStatus;
		public String strCommand;

	}

	private class TaskScanner extends TimerTask {

		public void run() {
			while(true)
				performTasks();
		}

	}

	private TaskScanner taskScanner;

	private Timer timer;

	private String strUserName;
	private String strNotebookName;
	private String strExperimentName;
	private String strVersionName = Constants.AZDBLAB_VERSION;
	// private String strScenario;
	private String strStartTime;
	private boolean heartbeats;

	private String strExpUserName;
	private String strExpPassword;

	private String dbms;

	private Vector<RunStatusNode> vecPendingRuns;

	private Vector<RunStatusNode> vecRunningRuns;

	private Vector<RunStatusNode> vecPausedRuns;
	private RunExperiment re;

	public String strMachineName;
	private String strConnectString;
	private String current_status;
	private String command;
	private long sequenceNumber = 0;
	private Thread heartbeat_thread;

	azdblab.labShelf.dataModel.Executor executor_;

	LabShelfManager labshelf_lib_ = null;

	private int selected_pending_run_ = -1;
	private int selected_running_run_ = -1;
	private int selected_paused_run_ = -1;

	public Executor(String expUserName, String expPassword, String machineName,
			String connectString, String dbmsName) {

		labshelf_lib_ = LabShelfManager.getShelf(Main.getLABUSERNAME(),
				Main.getLABPASSWORD(), Main.getLABCONNECTSTRING(), machineName);
//		Thread thread = new Thread() {
//			public void run() {
//				startLabShelfMonitor();
//			}
//		};
//		thread.start();

		try {
			String tmpVersion = strVersionName.replace(".", "TOKEN").split(
					"TOKEN")[0];
			String sql = "select * from azdblab_version where versionname Like '"
					+ tmpVersion + ".%'";
			ResultSet rs = LabShelfManager.getShelf(Main.getLABUSERNAME(),
					Main.getLABPASSWORD(), Main.getLABCONNECTSTRING(), machineName)
					.executeQuerySQL(sql);
			if (!rs.next()) {
				Main._logger.reportError("Executor version does not exist in AZDBLAB: ");
				Main._logger.reportError("Executor version: "
						+ this.strVersionName);
				System.exit(-1);
			}

			String azdblab_ver = rs.getString(1);
			StringTokenizer st = null;
			st = new StringTokenizer(azdblab_ver, ".");
			int schema_major_mum = Integer.parseInt(st.nextToken());
			st = new StringTokenizer(strVersionName, ".");
			int executor_major_num = Integer.parseInt(st.nextToken());
			if (schema_major_mum != executor_major_num) {
				Main._logger.reportError("Executor major version number does not match that of AZDBLAB: ");
				Main._logger.reportError("Executor version: "
						+ this.strVersionName);
				Main._logger.reportError("Schema version: " + azdblab_ver);
			}
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		dbms = dbmsName;
		taskScanner = new TaskScanner();
		timer = new Timer();
		strExpUserName = expUserName;
		strExpPassword = expPassword;
		strMachineName = machineName;
		strConnectString = connectString;
		re = null;
		current_status = "Running";
		command = "Run";
		vecPendingRuns = new Vector<RunStatusNode>();
		vecRunningRuns = new Vector<RunStatusNode>();
		vecPausedRuns = new Vector<RunStatusNode>();
		executor_ = azdblab.labShelf.dataModel.Executor
				.getExecutor(machineName, dbms);
		// If previously Paused, then preserve this state.
		String currentTime = new SimpleDateFormat(Constants.TIMEFORMAT)
				.format(new Date(System.currentTimeMillis()));
		if (executor_ == null) {
			labshelf_lib_.insertExecutor(machineName, dbms, currentTime,
					current_status, command);
			executor_ = azdblab.labShelf.dataModel.Executor
					.getExecutor(machineName, dbms);
		}

		if (executor_ != null
				&& executor_.getState().strCurrentStatus.equals("Paused")) {
			current_status = "Paused";
		}

		if (executor_ != null
				&& executor_.getState().strCommand.equals("Resume")) {
			command = "Resume";
		}
		
		// LabShelf.getShelf().insertExecutor(strMachineName,
		// strDBMSName, currentTime, strCurrentStatus, strCommand);
		executor_.insertExecutorLog(strMachineName, currentTime,
				current_status, command);
		// Notification n = new AZDBNotification(this, sequenceNumber++,
		// System.currentTimeMillis(),
		// strMachineName + " " +current_status +" " +command,
		// AZDBNotification.PRINTNOTIFICATION);
		// sendNotification(n);
		loadRunningRuns();

	}

	public void loadRunningRuns() {
		vecRunningRuns.clear();
		Vector<Run> runs = Run.getSpecificRuns(Run.TYPE_RUNNING);
		if(runs != null){
			for (Run r : runs) {
				RunStatusNode rsn = new RunningRunNode(r.getUserName(),
						r.getNotebookName(), r.getExperimentName(),
						r.getScenario(), r.getMachineName(), r.getDBMS(),
						r.getStartTime());
				vecRunningRuns.add(rsn);
			}
		}
	}

	public void loadPendingRuns() {
		vecPendingRuns.clear();
		Vector<Run> runs = Run.getSpecificRuns(Run.TYPE_PENDING);
		for (Run r : runs) {
			RunStatusNode rsn;
			// TODO modified here
			if (r.getMachineName() != null) {
				rsn = new PendingRunNode(r.getUserName(), r.getNotebookName(),
						r.getExperimentName(), r.getMachineName(),
						r.getScenario(), r.getDBMS(), r.getStartTime());
			} else {
				rsn = new PendingRunNode(r.getUserName(), r.getNotebookName(),
						r.getExperimentName(), r.getScenario(), r.getDBMS(),
						r.getStartTime());
			}

			vecPendingRuns.add(rsn);
		}
	}

	public void loadPausedRuns() {
		vecPausedRuns.clear();
		Vector<Run> runs = Run.getSpecificRuns(Run.TYPE_PAUSED);
		for (Run r : runs) {
			RunStatusNode rsn = new PausedRunNode(r.getUserName(),
					r.getNotebookName(), r.getExperimentName(),
					r.getScenario(), r.getMachineName(), r.getDBMS(),
					r.getStartTime());
			if(r.getiType() == Run.TYPE_RESUMED){
				rsn.setType(Run.TYPE_RESUMED);
			}
			vecPausedRuns.add(rsn);
		}
	}

	public PendingRunNode getRunnablePendingRun() {

		loadPendingRuns();

		if (vecPendingRuns == null || vecPendingRuns.size() == 0) {

			// JOptionPane.showMessageDialog(this,
			// "No pending experiment to run, come back later please.");
			if (!RunExperiment.getIsRunning()) {
				// Main._logger.outputLog("No pending experiment to run, come back later please.");
			}
			return null;

		}

		//System.out.println("pending run on " + dbms + " / " + strMachineName + ":" + vecPendingRuns.size());
		// Set<String> setDBMSNames = new TreeSet<String>();

		for (int i = 0; i < vecRunningRuns.size(); i++) {

			RunningRunNode rrnode = (RunningRunNode) vecRunningRuns.get(i);

			if (dbms.equals(rrnode.getDBMS())
					&& (strMachineName.equals(rrnode.getMachineName()))) {
				// JOptionPane.showMessageDialog(this,
				// "Other usering is running experiment with the same DBMS, executor is not available, please wait for a while.");
				
//				System.out.println(rrnode.getDBMS() + " / " + rrnode.getMachineName() + " / " + rrnode.getRunID());
				
				Main._logger
						.outputLog("The Executor is currently running another experiment with the same DBMS, "
								+ "executor is not available, please wait for a while.");
				System.exit(-1);
			}

		}

		// System.out.println("Searching based on machineName");
		// System.out.println("My machineName :" + strMachineName);

		// TODO modified here
		// 1) Search based on machineName first
		for (int i = 0; i < vecPendingRuns.size(); i++) {

			PendingRunNode pdnode = (PendingRunNode) vecPendingRuns.get(i);
			// System.out.println("Locaed experiment with machineName:"
			// + pdnode.getMachineName());
			if (dbms.equals(pdnode.getDBMS())
					&& pdnode.getMachineName().equals(strMachineName)) {
				selected_pending_run_ = i;
				return pdnode;
			}
		}
		// search non constrained pending runs for a runnable one
		for (int i = 0; i < vecPendingRuns.size(); i++) {

			PendingRunNode pdnode = (PendingRunNode) vecPendingRuns.get(i);

			if (dbms.equals(pdnode.getDBMS())
					&& pdnode.getMachineName().equals("")) {
				selected_pending_run_ = i;
				return pdnode;
			}
		}

		return null;

	}

	/****
	 * Young added this.
	 * When an executor gets started or resumed, it looks for the run that started earliest, or a pending run that gets put earliest. 
	 * @return
	 */
	public RunStatusNode getRunnableRun() {

		loadRunningRuns();
		
		if (vecRunningRuns != null && vecRunningRuns.size() > 0) {
			for (int i = 0; i < vecRunningRuns.size(); i++) {
				RunningRunNode rrnode = (RunningRunNode) vecRunningRuns.get(i);
				if (dbms.equals(rrnode.getDBMS())
				&& (strMachineName.equals(rrnode.getMachineName()))) {
						if (!RunExperiment.getIsRunning()) {
							selected_running_run_ = i;
							return rrnode;
						}else{
//							if(rrnode.getRunID() == ){
//								Main._logger.outputLog("The Executor is currently running another experiment with the same DBMS, "
//										+ "executor is not available, please wait for a while.");
//									System.exit(-1);
//							}
							return null;
						}
				}
			}
		}

		// we look for any pending run, since there's no running run.
		
		loadPendingRuns();

		if (vecPendingRuns == null || vecPendingRuns.size() == 0) {

			// JOptionPane.showMessageDialog(this,
			// "No pending experiment to run, come back later please.");
			if (!RunExperiment.getIsRunning()) {
				// Main._logger.outputLog("No pending experiment to run, come back later please.");
			}
			return null;

		}
		
		// TODO modified here
		// 1) Search based on machineName first
		for (int i = 0; i < vecPendingRuns.size(); i++) {

			PendingRunNode pdnode = (PendingRunNode) vecPendingRuns.get(i);
			// System.out.println("Locaed experiment with machineName:"
			// + pdnode.getMachineName());
			if (dbms.equals(pdnode.getDBMS())
					&& pdnode.getMachineName().equals(strMachineName)) {
				selected_pending_run_ = i;
				return pdnode;
			}
		}
		// search non constrained pending runs for a runnable one
		for (int i = 0; i < vecPendingRuns.size(); i++) {

			PendingRunNode pdnode = (PendingRunNode) vecPendingRuns.get(i);

			if (dbms.equals(pdnode.getDBMS())
					&& pdnode.getMachineName().equals("")) {
				selected_pending_run_ = i;
				return pdnode;
			}
		}

		return null;

	}
	
	
	public PausedRunNode getPausedRun() {

		loadPausedRuns();

		if (vecPausedRuns == null || vecPausedRuns.size() == 0) {

			return null;

		}

		for (int i = 0; i < vecPausedRuns.size(); i++) {

			PausedRunNode psdnode = (PausedRunNode) vecPausedRuns.get(i);

			/***
			 * Young: we want to later unpause a paused run that's selected for resume.
			 * So, we internally have TYPE_RESUMED for the chosen paused run.
			 */
			if (dbms.equals(psdnode.getDBMS())
							&& strMachineName.equals(psdnode.getMachineName()) 
							&& psdnode.getType() == Run.TYPE_RESUMED) { 
				selected_paused_run_ = i;
				return psdnode;
			}

		}

		return null;

	}
	
	public void performTasks() {
//		startHeartbeats();
		azdblab.labShelf.dataModel.Executor.ExecutorState exestate = executor_
				.getExecutorState(strMachineName, dbms);
		if (exestate == null) {
			return;
		}
		current_status = exestate.strCurrentStatus;
		command = exestate.strCommand;
		// idle and set to be terminated, just exit.
		if ((command.equals("Terminate")) && (!RunExperiment.getIsRunning())) {

			current_status = "Terminated";
			command = "No Command";

			String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT)
					.format(new Date(System.currentTimeMillis()));
			executor_.insertExecutorLog(strMachineName, transactionTime,
					current_status, command);
			executor_.updateExecutor(dbms, transactionTime, current_status,
					command);

			Main._logger
					.outputLog("WW-- Executor terminated by user manually.");
			System.exit(0);

		}

		if ((command.equals("Abort"))) {
			if (current_status.equals("Paused")) {
				current_status = "Running";
				String transactionTime = new SimpleDateFormat(
						Constants.TIMEFORMAT).format(new Date(System
						.currentTimeMillis()));
				executor_.insertExecutorLog(strMachineName, transactionTime,
						current_status, command);
				executor_.updateExecutor(dbms, transactionTime, current_status,
						command);
			}
		}

		// while running, if found command is "Pause", pause.
		if ((command.equals("Pause"))) {
//System.out.println("command: " + command + ", current_status: " + current_status);
			if (!current_status.equals("Paused")) {
				current_status = "Paused";
				String transactionTime = new SimpleDateFormat(
						Constants.TIMEFORMAT).format(new Date(System
						.currentTimeMillis()));
				executor_.insertExecutorLog(strMachineName, transactionTime,
						current_status, command);
				executor_.updateExecutor(dbms, transactionTime, current_status,
						command);
//				Notification n = new AZDBNotification(this, sequenceNumber++,
//						System.currentTimeMillis(), AZDBNotification.PRINTNOTIFICATION+
//						"&"+ getProcessID()+"Pausing executor on"
//								+ strMachineName);
			}

			return;
		}

		// if command is either "Resume" or "Run"
		RunStatusNode runNode = getRunnableRun();
		
		if(runNode != null){
			
			// if not running now, initiate an execution
			if (!RunExperiment.getIsRunning()) {
				Main._logger.outputLog("Begining Experiment with startTime : " + runNode.getStartTime());
				strUserName = runNode.getUserName();
				Main._logger.outputLog("Experiment User : " + strUserName);
				strNotebookName = runNode.getNotebookName();
				strExperimentName = runNode.getExperimentName();
				// strScenario = psdRunNode.getScenario();
				dbms = runNode.getDBMS(); // not necessary but well.
				strStartTime = runNode.getStartTime();

				command = "Run";
				current_status = "Running";

				// if runnode comes from pending run
				if(runNode instanceof PendingRunNode){
					vecPendingRuns.remove(selected_pending_run_);
					selected_pending_run_ = -1;
				}
				// else it comes from any running run
				else{
					vecRunningRuns.remove(selected_running_run_);
					selected_running_run_ = -1;
				}

				String transactionTime = new SimpleDateFormat(
						Constants.TIMEFORMAT).format(new Date(System
						.currentTimeMillis()));
				executor_.updateExperimentRunMachineName(strUserName,
						strNotebookName, strExperimentName, strStartTime);
				executor_.insertExecutorLog(strMachineName,
						transactionTime, current_status, command);
				executor_.updateExecutor(dbms, transactionTime,
						current_status, command);

				re = new RunExperiment(strUserName, strNotebookName,
						strExperimentName, strExpUserName,
						strExpPassword, strMachineName, strConnectString, dbms,
						strStartTime);
				re.start();
				return;

			} 
			else {
				if(runNode instanceof RunningRunNode){
					Main._logger.outputLog("Another experiment is running...");	
				}
			}
		} else{
//			Main._logger.outputLog("There's no available run, so waiting...");		
			return;
		}
		return;
	}

	public void execute() {
		/*
		 * try { SuspendSystemTasks(); } catch (InterruptedException e) { //
		 * TODO Auto-generated catch block e.printStackTrace(); }
		 */
//		try {
//			Thread.sleep(500000);
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		Notification n = new AZDBNotification(this, sequenceNumber++, System.currentTimeMillis(),
//				 "4&"+getProcessID()+"&"+this.strMachineName + " " + this.dbms+"&"+"azdb");
//		sendNotification(n);
		timer.scheduleAtFixedRate(taskScanner, 2000, 5000);
		
	}

//	public void sendHeartbeat() {
//		Notification n = new Notification(getProcessID(), strMachineName + " "
//						+ current_status + " " + command,
//				AZDBNotification.DONOTHING);
//		sendNotification(n);
//	}
//
//	public void sendNotification(String source, String message, int type) {
//		Notification n = new AZDBNotification(source, sequenceNumber,
//				System.currentTimeMillis(), type+"&"+getProcessID()+"&"+message);
//		sendNotification(n);
//		stopHeartbeats();
//	}
//	public void startLabShelfMonitor(){
//		System.out.println("Entered labshelf server montior");
//		LabShelfServerMonitor.connectToLabshelf();
////			connectToExpSubject();
//		try{
//			LabShelfServerMonitor.monitor();
//		}catch(Exception ex){
//			System.err.println("Watcher should be invoked from Executor");
//			Notification n = new AZDBNotification("LabShelfServerMonitorEx", 0, System.currentTimeMillis(),
//					
//					2+"&"+getProcessID()+"&The executor on "+ strMachineName +"can no longer connect with " +
//							"labshelf.");
//			
//			sendNotification(n);
//			//System.err.println(ex.getMessage());
//		}
////			closeExpSubject();
//		LabShelfServerMonitor.closeLabshelf();
//	}
//	
//	public void startHeartbeats(){
//		heartbeats=true;
//		System.out.println("starting heartbeats");
//		heartbeat_thread = new Thread() {
//			public void run() {
//				while (heartbeats) {
//					sendHeartbeat();
//					try {
//						//each hour send a heartbeat
//						Thread.sleep(3600000);
//					} catch (InterruptedException e) {
//						e.printStackTrace();
//					}
//				}
//			}
//		};
//		heartbeat_thread.start();
//	}
//	
//	public void stopHeartbeats(){
//		System.out.println("stopping heartbeats");
//		heartbeats=false;
//	}
	
	static String getProcessID(){
		final String proc = ManagementFactory.getRuntimeMXBean().getName();
		int index = proc.indexOf('@');
		if(index<1)
			return "";
		return Long.toString(Long.parseLong(proc.substring(0, index)));
	}
}
