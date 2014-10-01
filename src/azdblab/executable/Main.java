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

import java.io.BufferedReader;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader; //import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Vector;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

//import salvo.jesus.graph.visual.layout.LayeredTreeLayout;
import java.lang.reflect.Method;

import azdblab.Constants; //import azdblab.analysis.api.OptimizerAnalyzer;
import azdblab.labShelf.creator.SpecifierFrm;
//import azdblab.labShelf.dataModel.Executor;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.plugins.MasterPluginManager;
import azdblab.plugins.PluginData;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.plugins.experimentSubject.ExperimentSubjectPluginManager;
import azdblab.plugins.scenario.*;
import azdblab.swingUI.*;
import azdblab.swingUI.objectNodes.ExperimentNode;
import azdblab.utility.logger.AZDBLabLogger;
import azdblab.exception.analysis.ColumnAttributeException;
import azdblab.exception.analysis.DataDefinitionValidationException;
import azdblab.exception.analysis.InvalidExperimentException;
import azdblab.exception.analysis.InvalidExperimentRunException;
import azdblab.exception.analysis.NameResolutionException;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataGenerator.DataGenerator;
import azdblab.model.dataGenerator.DefaultDataGenerator;
import azdblab.model.experiment.LabShelfConnector;
import azdblab.model.experiment.Decryptor;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.XMLHelper;
import java.util.Date;
import java.io.File;
import java.net.InetAddress;
import java.net.UnknownHostException;

import java.text.SimpleDateFormat;

import javax.management.InstanceAlreadyExistsException;
import javax.management.MBeanRegistrationException;
import javax.management.MalformedObjectNameException;
import javax.management.NotCompliantMBeanException;

/**
 * This is the main class that is run from the command line. It handles parsing
 * the input parameters.
 * 
 */
public class Main {
	private static String LAB_USERNAME;
	private static String LAB_PASSWORD;
	private static String LAB_CONNECTSTRING;

	public static boolean Auto_Commit_ = false;
	public static MasterPluginManager masterManager;
	// public static Logger observerLogger;
	// public static Logger executorLogger;
	// public static Logger defaultLogger;
	/****
	 * Observer or executor logger for logging
	 */
	public static AZDBLabLogger _logger;

	/****
	 * Set either an observer or executor logger for its own logging.
	 * 
	 * @param loggerTypeName
	 *            observer or executor
	 */
	public static void setAZDBLabLogger(String loggerTypeName) {
		_logger = new AZDBLabLogger(loggerTypeName);
		String computername = "";
		try {
			computername = InetAddress.getLocalHost().getHostName();
		} catch (UnknownHostException e) {
			e.printStackTrace();
			System.err.println("The executable cannot get host name");
			System.err.println("Please retry again.");
			System.exit(-1);
		}
		SimpleDateFormat logsdf = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
		String strLoggingTime = logsdf.format(new Date(System
				.currentTimeMillis()));
		
		String logFileName = Constants.AZDBLAB_LOG_DIR_NAME + File.separator
				+ computername + "." + loggerTypeName + "." + strLoggingTime
				+ ".log";
		
		try {
			_logger.setAZDBLabAppender(computername,strLoggingTime,loggerTypeName,logFileName);
		} catch (IOException e) {
			// e.printStackTrace();
			System.err.println("Appender cannot be created due to permission.");
			System.err.println(loggerTypeName + " shuts down. ");
			System.err.println("Please retry again.");
			System.exit(-1);
		}
		_logger.setAZDBLabLoggerName(logFileName);
	}

	/**
	 * The main method that is called from the command line. This is the only
	 * point of entry for AZDBLab.
	 * 
	 * @param args
	 *            The command line arguments that are passed into AZDBLab
	 * @throws InterruptedException 
	 * @throws NullPointerException 
	 * @throws NotCompliantMBeanException 
	 * @throws MBeanRegistrationException 
	 * @throws InstanceAlreadyExistsException 
	 * @throws MalformedObjectNameException 
	 */
	public static void main(String[] args) throws MalformedObjectNameException, InstanceAlreadyExistsException, MBeanRegistrationException, NotCompliantMBeanException, NullPointerException, InterruptedException {
		if (args.length < 1) {
			usage();
		}
		

		String current_version = null;
		int numOptionalArgs = args.length;
		bUninstall = false;
		// determine which arguments were passed in
		for (int i = 0; i < numOptionalArgs; i++) {
			if (args[i].equals(VERBOSE)) {
				verbose = true;
			} else if (args[i].equals(OBSERVER)) {
				bObserver = true;
				bExecutor = false;
			} else if (args[i].equals(EXECUTOR)) {
				bExecutor = true;
				bObserver = false;
			} else if (args[i].equals(UNINSTALL)) {
				bUninstall = true;
				bExecutor = false;
				bObserver = false;
			} else if (args[i].equals(HOSTNAME)) {
				String[] spl = args[i+1].split(":");
				azdblab.executable.Executor.VMProcMonHostname = spl[0];
				azdblab.executable.Executor.VMProcMonPortNum = Integer.parseInt(spl[1]);
			} else if (args[i].equals((CREATOR))) {
				bCreator = true;
				SpecifierFrm sfrm = new SpecifierFrm();
				sfrm.setVisible(true);
			} else {
				// usage();
			}
		}

		System
				.setProperty("javax.xml.parsers.DocumentBuilderFactory",
						"com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl");
		try {
			Constants.LoadSchemas();
		} catch (Exception ex) {
			ex.printStackTrace();
			System.exit(3);
		}
		// Check if the result_temp directory exists. If NOT, create one,
		// otherwise continue.
		File tempDir = new File(Constants.DIRECTORY_TEMP);
		if (!tempDir.exists()) {
			tempDir.mkdir();
		}
		// String logFileName, appenderName;
		// if the arguments specify that the result browser is to be run

		masterManager = new MasterPluginManager();
		populateDBMSListing();
		if (bObserver) {
			Main.setAZDBLabLogger(Constants.AZDBLAB_OBSERVER);
			_logger.outputLog("Run Observer");
			ObserverGUI gui = new ObserverGUI();
			gui.show();
			return;
		} else if (bExecutor) {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
			_logger.outputLog("Run Executor");
			// give executor log name
			String specifier = args[2];
			String dbms_name = args[3];
			if (args.length < 4) {
				System.out
						.println("Specify experiment subject plugin and the DBMS name please.");
				return;
			}
			for (int i = 4; i < args.length; ++i) {
				if (args[i].equals("-autocommit")) {
					Auto_Commit_ = true;
				} else if (args[i].equals("-timeout")) {
					int time_out = Integer.parseInt(args[++i]);
					System.out.println("Timeout argument found: " + time_out
							+ " seconds.");
					Constants.SetExpTimeOut(time_out);
				}
			}		
			
			String exp_user_name = null;
			String exp_password = null;
			String connectStr = null;
			// connect to labshelf
			LabShelfConnector dbms_connector = new LabShelfConnector();
			dbms_connector.initialize();
			current_version = dbms_connector.getCurrentVersion();
			Constants.setCurrentVersion(current_version);
			try {

				// connect to experiment subject
				Decryptor decryptor = new Decryptor(Constants.DESKEYPHRASE);
				// System.out.println("plugin dir: " +
				// MetaData.DIRECTORY_PLUGINS + specifier);
				Document doc = XMLHelper.readDocument(new File(
						Constants.DIRECTORY_PLUGINS + specifier));
				Element root = doc.getDocumentElement();
				LabShelfManager.getShelf(Main.getLABUSERNAME(), Main
						.getLABPASSWORD(), Main.getLABCONNECTSTRING(), InetAddress.getLocalHost().getHostName());

				exp_user_name = decryptor.decrypt(root
						.getAttribute("LAB_USERNAME"));
				exp_password = decryptor.decrypt(root
						.getAttribute("LAB_PASSWORD"));
				connectStr = decryptor.decrypt(root
						.getAttribute("LAB_CONNECTSTRING"));

				 //Main.setLABUSERNAME(exp_user_name);
				 //Main.setLABPASSWORD(exp_password);
				 //Main.setLABCONNECTSTRING(machine_name);
				// LabShelf.getExpSubShelf(exp_user_name, exp_password,
				// machine_name);
			} catch (Exception ex) {
				ex.printStackTrace();
			}

			if (exp_user_name == null || exp_password == null
					|| connectStr == null) {
				System.out
						.println("Please specify correctly the experiment subject plugin file and try again.");
				// categoryExecutor.error("Please specify correctly the experiment subject plugin file and try again.");
				System.exit(-1);
			}

			if (current_version == null || current_version.equals("")) {
				System.exit(1);
			}
			// select the proper version of xml schemas
			// the version is of the format mm_dd_yy_hh_MM_ss
			if (!Constants.ChooseProperSchema(current_version)) {
				System.err.println("Schema not completely loaded.");
				System.exit(2);
			}
					
			String machineName = "";
			try {
//				System.out.println("dbms:" + dbms_name);
				if(dbms_name.contains("sqlserver")){
					machineName = "sodb6.cs.arizona.edu";
				}else{
					machineName = InetAddress.getLocalHost().getHostName();
				}
			} catch (UnknownHostException e) {
				e.printStackTrace();
			}
			
//			CheckSingleCore();
			
//			if(!machineName.contains("sodb6") && !machineName.contains("sodb4")){
//				CheckExecutorAndDBMSRunning(dbms_name);
//			}
//			CheckExecutorAndDBMSRunning(dbms_name);

			
//			System.out.println("machineName:" + machineName);
			// JDBCTest(machine_name, exp_user_name, exp_password);
//			Executor(String expUserName, String expPassword, String machineName,String connectString, String dbmsName) {
			Executor executor = new Executor(exp_user_name, exp_password, machineName, connectStr, dbms_name);
//			 System.out.println("userName: " + exp_user_name);
//			 System.out.println("passwd: " + exp_password);
//			 System.out.println("machine_name: " + machineName);
//			 System.out.println("connectStr: " + connectStr);

			// from this point, every printout needs to go to the executor log.
			executor.execute();
		} else if (bUninstall) {
			System.out.println("Uninstall LabShelf!");
			LabShelfConnector dbconnector = new LabShelfConnector();
			dbconnector.initialize();

			System.out
					.print("Are you sure to uninstall the labshelf? All the results will be cleared. Y/N : [N]");
			BufferedReader stdin = new BufferedReader(new InputStreamReader(
					System.in));

			try {
				String option = stdin.readLine();
				if (option.equals("Y")) {
					// LabShelf.getShelf().uninstallInternalTables();
					// logCategory.info("Labnotebook is being uninstalled.");
				} else {
					System.out
							.println("Uninstall Terminated. LabShelf was not uninstalled.");
					System.exit(0);
				}
			} catch (IOException ioex) {
			}

		}
		if (!bCreator) {
			_logger.outputLog("Beginning Log");
		}
	}

	/*****
	 * Check if the currect number of cores matches the one in the experiment spect. 
	 * 
	 */
	private static boolean CheckNumCores(int cores) {
		boolean desiredNumCores = true;
		try {
			/****
			 * Check if more than one core is enabled.
			 */
			_logger.outputLog("Checking if the enabled number of cores matches " + cores);
			String command = "cat /proc/cpuinfo | grep \"processor\" | wc -l";
//			System.out.println(command);
			String[] commandAndArgs = new String[]{ "/bin/sh", "-c", command};
			Process p1 = Runtime.getRuntime().exec(commandAndArgs);
			BufferedReader buf_reader = new BufferedReader(new InputStreamReader(p1.getInputStream()));
			String line = "";
			while ((line = buf_reader.readLine()) != null) {
				Integer numCores = Integer.parseInt(line.trim());
				_logger.outputLog("# of cores enabled: " + numCores.intValue());
				if(numCores.intValue() != cores){
					desiredNumCores = false;
					break;
				}
			}
			buf_reader.close();
			p1.waitFor();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return desiredNumCores;
	}

	/*****
	 * Mantis#1477
	 * Never run two executors on the same machine 
	 * @param dbms_name chosen dbms
	 */
	private static void CheckExecutorAndDBMSRunning(String dbms_name) {
		/******
		 * 1) Check if any other executors are running.
		 * 2) Check if any other DBMS is running. 
		 * 3) Run a chosen DBMS unless running. 
		 * => We stop executor.
		 */
//		String[] DBMSs = { "DB2", "MySQL", "Oracle", "Pgsql", "Pgsql2", "SqlServer" };
		for(int i=0;i<Constants.DBMSs.length;i++){
			String dbmsToBeChecked = (Constants.DBMSs[i]).toLowerCase();
//System.out.println("DBMS to be checked: " + dbmsToBeChecked);				
			if(dbmsToBeChecked.contains(dbms_name)){
				continue;
			}else{
				try {
					/****
					 * Check if any other executors are running // passed
					 */
_logger.outputLog("Checking running executors for '" + dbmsToBeChecked +"' ...");
					String command = "ps aux | grep \"runexecutor_" + dbmsToBeChecked+ "\"";
//System.out.println(command);
					String[] commandAndArgs = new String[]{ "/bin/sh", "-c", command};
					Process p1 = Runtime.getRuntime().exec(commandAndArgs);
					InputStream instd = p1.getInputStream();
					BufferedReader buf_reader = new BufferedReader(
							new InputStreamReader(instd));
					String line = "";
					while ((line = buf_reader.readLine()) != null) {
						if(!line.contains("grep")){
							System.err.println("Another executor for " + dbmsToBeChecked + " is running. ");
							System.err.println("=>"+line);
							System.err.println("Terminated.");
							buf_reader.close();
							p1.waitFor();
							System.exit(-1);
						}
					}
					buf_reader.close();
					p1.waitFor();
//					InputStream errstd = p1.getErrorStream();
//				      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
//				      while ((line=buf_err_reader.readLine()) != null) {
//				    	  System.out.println(line);
//				      }
//				      buf_err_reader.close();
//				      p1.waitFor();
_logger.outputLog("Checking running other DBMSes except '" + dbmsToBeChecked +"' ...");					
					/****
					 * Check if any other DBMS is running.  // passed
					 */
					if(dbmsToBeChecked.contains("pgsql")){
						dbmsToBeChecked = "postgres";	
					}
					command = "ps aux | grep \"" + dbmsToBeChecked + "\"";
//System.out.println(command);
					commandAndArgs = new String[]{ "/bin/sh", "-c", command};
					p1 = Runtime.getRuntime().exec(commandAndArgs);
					instd = p1.getInputStream();
					buf_reader = new BufferedReader(new InputStreamReader(instd));
					line = "";
					while ((line = buf_reader.readLine()) != null) {
						if(line.startsWith(dbmsToBeChecked) 
						&& !line.startsWith("db2das") // will be removed
						){
							Process p2 = null;
							String exec_command = "";
							if(dbmsToBeChecked.contains("postgres")){
								exec_command = "postgresql-9.2";	
							}
							else if(dbmsToBeChecked.contains("mysql")){
								exec_command = "mysql";		
							}
							else if(dbmsToBeChecked.contains("db2")){
								exec_command = "db2";		
							}
							else if(dbmsToBeChecked.contains("oracle")){
								exec_command = "dbora";
							}
							if(dbms_name.contains("javadb")){
								exec_command = "derby";	
							}
							_logger.reportError("Another DBMS (" + dbmsToBeChecked + ") process(es) is running...");
							_logger.reportError("\t => "+line);
							_logger.reportError("Now we stop it...");
							p2 = Runtime.getRuntime().exec("sudo /etc/init.d/" + exec_command + " stop");
							InputStream instd2 = p2.getInputStream();
							BufferedReader buf_reader2 = new BufferedReader(new InputStreamReader(instd2));
							while (buf_reader2.readLine() != null) {
							}
							buf_reader2.close();
							p2.waitFor();
							buf_reader.close();
							p1.waitFor();
							System.err.println("Terminated.");
							System.exit(-1);
						}
					}
					buf_reader.close();
					p1.waitFor();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		}
		
		/****
		 * 3) Run a chosen DBMS unless running. // passed
		 */
		try {
			if(dbms_name.contains("pgsql")){
				dbms_name = "postgres";	
			}
			if(dbms_name.contains("javadb")){
				dbms_name = "derby";	
			}
_logger.outputLog("Checking if '" + dbms_name +"' is running ... ");	
			boolean running = false;
			String command = "ps aux | grep \"" + dbms_name + "\"";
//System.out.println(command);
			String[] commandAndArgs = new String[]{ "/bin/sh", "-c", command};
			Process p1 = Runtime.getRuntime().exec(commandAndArgs);
			InputStream instd = p1.getInputStream();
			BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
			String line = "";
			while ((line = buf_reader.readLine()) != null) {
				if(line.startsWith(dbms_name) 
				&& !line.startsWith("db2das") // will be removed
				){
					running = true;
				}else if (dbms_name.equals("derby") && line.contains("derbyrun.jar")){
					running = true;
				}
			}
			buf_reader.close();
			p1.waitFor();
			if(!running){
_logger.outputLog("\t => '" + dbms_name +"' is not running ... ");	
_logger.outputLog("\t => Start '" + dbms_name +"' ");
				command = "./start_dbms.sh " + dbms_name + " daemon_turnoff";
_logger.outputLog(command);
				commandAndArgs = new String[]{ "/bin/sh", "-c", command};
				p1 = Runtime.getRuntime().exec(commandAndArgs);
				instd = p1.getInputStream();
				buf_reader = new BufferedReader(new InputStreamReader(instd));
				while ((line = buf_reader.readLine()) != null) {
_logger.outputLog(line);
				}
				buf_reader.close();
				p1.waitFor();
				_logger.outputLog("Waiting for 5 seconds for the startup ...");
				// wait for 5 seconds before DBMS starts
				Thread.sleep(5000);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
	}

	/**
	 * This will run a single experiment.
	 * 
	 * @param myExperimentFileName
	 *            The name of the experiment to be run.
	 * @throws InvalidExperimentException
	 *             This is thrown for any error that causes the experiment to
	 *             cease execution.
	 */
	@SuppressWarnings("unused")
	public static void runExperiment(String lab_user_name,
			String lab_notebook_name, String lab_experiment_name,
			String exp_user_name, String exp_password, String machine_name, String connectString,
			String dbms, String start_time) throws InvalidExperimentException {

		// _expHasErrors = false;
		ExperimentNode myExperiment = null;
		String experimentName = null;
		String userName = null;
		String notebookName = null;
		String scenarioName = null;
//		int numCores = 0;
//		int numTerminals = 0;
//		int numIncr = 0;
//		int duration = 0;
		
		/***
		 * DBMS Buffer Cache Size
		 */
		double dbmsBuffCacheSizeMin = 0;
		double dbmsBuffCacheSizeMax = 0;
		double dbmsBuffCacheSizeIncr = 0;
		/***
		 * Number of Cores
		 */
		int numCores = 0;
		/***
		 * BatchRunTime
		 */
		int sessionDuration = 0;
		/***
		 * Transaction Size
		 */
		double minNumRowsFromSELECT = 0;
		double maxNumRowsFromSELECT = 0;
		int incrNumRowsFromSELECT = 0;
		/***
		 * Exclusive Locks
		 */
		double minNumRowsFromUPDATE = 0;
		double maxNumRowsFromUPDATE = 0;
		double incrNumRowsFromUPDATE = 0;
		/***
		 * Terminal configuration
		 */
		int minMPL = 0;
		int maxMPL = 0;
		int incrMPL = 0;
		/***
		 * Effective DB size
		 */
		double minActiveRowPool = 0;
		double maxActiveRowPool = 0;
		double incrActiveRowPool = 0;
		
		// LabShelf.getShelf().printTableSchema();
		Experiment experiment = User.getUser(lab_user_name).getNotebook(
				lab_notebook_name).getExperiment(lab_experiment_name);

		try {
			if(lab_experiment_name.contains("tps") || lab_experiment_name.contains("xt")){
				myExperiment = new ExperimentNode(experiment.getXactExperimentSource(),
						experiment.getUserName(), experiment.getNotebookName());
			}else{
				myExperiment = new ExperimentNode(experiment.getExperimentSource(),
						experiment.getUserName(), experiment.getNotebookName());				
			}
			myExperiment.processXML();
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}

		experimentName = experiment.getExperimentName();
		userName = experiment.getUserName();
		notebookName = experiment.getNotebookName();
		scenarioName = experiment.getScenario();
//		numCores = experiment.getNumCores();
//		numTerminals = experiment.getNumTerminals();
//		numIncr = experiment.getNumIncr();
//		double effDBSz = experiment.getEffectiveDBSize();
//		duration = experiment.getDuration();

		dbmsBuffCacheSizeMin = experiment.getDBMSBufferCacheMin();
		dbmsBuffCacheSizeMax = experiment.getDBMSBufferCacheMax();
		dbmsBuffCacheSizeIncr = experiment.getDBMSBufferCacheIncr();
		numCores = experiment.getNumCores();
		sessionDuration = experiment.getBatchRunTime();
		minNumRowsFromSELECT = experiment.getTransactionSizeMin();
		maxNumRowsFromSELECT = experiment.getTransactionSizeMax();
		incrNumRowsFromSELECT = experiment.getTransactionSizeIncr();
		minNumRowsFromUPDATE = experiment.getExclusiveLockPctMin();
		maxNumRowsFromUPDATE = experiment.getExclusiveLockPctMax();
		incrNumRowsFromUPDATE  = experiment.getExclusiveLockPctIncr();
		minMPL = experiment.getMPLMin();
		maxMPL = experiment.getMPLMax();
		incrMPL  = experiment.getMPLIncr();
		minActiveRowPool = experiment.getEffectiveDBMin();
		maxActiveRowPool = experiment.getEffectiveDBMax();
		incrActiveRowPool  = experiment.getEffectiveDBIncr();	
		/*
		 * Logging information containing user name, notebook name, experiment
		 * name, scenario, logging time
		 */
		SimpleDateFormat sdf2 = new SimpleDateFormat(Constants.TIMEFORMAT);
		String transactionTime2 = sdf2.format(new Date(System
				.currentTimeMillis()));
		_logger
				.outputLog("=====================================================");
		_logger.outputLog("UserName: " + userName);
		_logger.outputLog("notebookName: " + notebookName);
		_logger.outputLog("experimentName: " + experimentName);
		_logger.outputLog("DBMS: " + dbms.toUpperCase());
		_logger.outputLog("Scenario: " + scenarioName);
		_logger.outputLog("machineName: " + machine_name);
//		_logger.outputLog("numCores = " + numCores);
//		_logger.outputLog("duration = " + duration);
//		_logger.outputLog("numTerminals = " + numTerminals);
//		_logger.outputLog("numIncrs = " + numIncr);
//		_logger.outputLog("effective db size = " + String.format("%.2f", effDBSz));
		
		String str = String.format("DBMSBufferCacheSize: %.2f%%, %d%%, %.2f%%", dbmsBuffCacheSizeMin*100, (int)(dbmsBuffCacheSizeIncr*100), dbmsBuffCacheSizeMax*100);
		_logger.outputLog(str);
		str = String.format("Number of Cores: %d", numCores);
		_logger.outputLog(str);
		str = String.format("Batch Run Time: %d", sessionDuration);
		_logger.outputLog(str);
		str = String.format("Transaction Size: %.2f%%, x%d, %.2f%%", minNumRowsFromSELECT*100, incrNumRowsFromSELECT, maxNumRowsFromSELECT*100);
		_logger.outputLog(str);
		str = String.format("Exclusive Lock Pct: %d%%, %d%%, %d%%", (int)(minNumRowsFromUPDATE*100), (int)(incrNumRowsFromUPDATE*100), (int)(maxNumRowsFromUPDATE*100));
		_logger.outputLog(str);
		str = String.format("Multiprogramming Level: %d, %d, %d", minMPL, incrMPL, maxMPL);
		_logger.outputLog(str);
		str = String.format("Effective DB: %d%%, %d%%, %d%%", (int)(minActiveRowPool*100), (int)(incrActiveRowPool*100), (int)(maxActiveRowPool*100));
		_logger.outputLog(str);
		minMPL = experiment.getMPLMin();
		maxMPL = experiment.getMPLMax();
		incrMPL  = experiment.getMPLIncr();
		minActiveRowPool = experiment.getEffectiveDBMin();
		maxActiveRowPool = experiment.getEffectiveDBMax();
		incrActiveRowPool  = experiment.getEffectiveDBIncr();
		_logger.outputLog("connectString: " + connectString);
		_logger.outputLog("logging time: [" + transactionTime2 + "]");
		_logger
				.outputLog("=====================================================");
		ExperimentSubjectPluginManager expSubPluginMan = new ExperimentSubjectPluginManager();

		ExperimentSubject experiment_subject = expSubPluginMan
				.getExperimentSubject(exp_user_name, exp_password,
						machine_name, connectString, dbms);
//		HashMap<Long, ProcessInfo> procMap = new HashMap<Long, ProcessInfo>();
//		if ((dbms.toLowerCase()).contains("sqlserver")) {
//			procMap = WindowsProcessAnalyzer
//					.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
//		} else {
//			try {
//				procMap = LinuxProcessAnalyzer
//						.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
//			} catch (SanityCheckException e) {
//				e.printStackTrace();
//			}
//		}
//		// read existing running process
//		ProcessAnalyzer.buildFrequentlyRunningCurrentProcesses(dbms
//				.toLowerCase(), procMap);

		experiment_subject.open(Auto_Commit_);
		
		if (Main.verbose) {
			System.out.println("$$$$$$$$ BEGIN Running Experiment ("
					+ lab_experiment_name + ") " + "By User " + lab_user_name
					+ " within notebook " + lab_notebook_name + " $$$$$$$");

		}

		/******************* testing right now *******************/
		// expSubject.setOptimizerFeature("", "30");
		/******************* testing right now *******************/

		// error check the experiment. This would report any validation errors,
		// name resolution problems
		// or other user input errors.
		// errorCheck(myExperiment, myDBController);
		// if (errorCheckOnly || _expHasErrors) {
		// return;
		// }

		SimpleDateFormat sdf = new SimpleDateFormat(Constants.TIMEFORMAT);
		String transactionTime = sdf
				.format(new Date(System.currentTimeMillis()));

		Run exp_run = experiment.getRun(start_time);
		exp_run.insertRunLog(transactionTime, "Initializing Experiment", 5.0);
		exp_run.updateRunProgress(transactionTime, "Initializing Experiment",
				5.0);
		if (Main.verbose) {
			System.out.println();
			System.out.println("####### Beginning Running Tests #######");
		}

		// determine if aspect and analytic calculation is needed.
		boolean is_finished = true;
		// running experimentRun
		ExperimentRun experimentRun = experiment.getMyExperimentRun();
		experimentRun
				.prepareExperimentRun(experiment_subject, dbms, start_time);
		if (Main.verbose) {
			System.out.println();
			System.out.println("Begin ExperimentRun: "
					+ experimentRun.getExperimentName());
		}

		// inserting experimentRun
		try {
			if (!experiment.experimentRunExists(start_time)) {
				System.out.println(">>> after checking experiment run "
						+ experimentRun.getExperimentName());
				experiment.insertExperimentRun(dbms, start_time, "init", 0.0);
			}
		} catch (SQLException e) {
			System.err.println("Error on ExperimentRun: "
					+ experimentRun.getExperimentName() + ":  "
					+ e.getMessage());
			e.printStackTrace();
		}
		System.out.println(">>> after insert experiment run "
				+ experimentRun.getExperimentName());
		// Obtain the data definition for this test.
		DataDefinition dataDefinition = experimentRun.getDataDefinition();
		// call Data Generator
		DataGenerator dataGenerator = new DefaultDataGenerator(
				experiment_subject, dataDefinition);
		System.out.println(">>> before dropping tables ... ");
		try {
			System.out
					.println("## <ExperimentStart> Purge Already installed tables ##################");
			// find all tables in the experimentSubject
			experimentRun.getExperimentSubject().dropAllInstalledTables();
			System.out
					.println("######################################################################");

			// drop them all until there is no table left
			// have a scenario create a new table
			// set up new experiment tables.
			dataGenerator.createTables();
			// create subject tables for each subject's execution plan
			// information
			experimentRun.getExperimentSubject().initializeSubjectTables();
			experimentRun.getExperimentSubject().disableAutoStatUpdate();
			// experimentRun.getExperimentSubject().setDataDefinition(dataDefinition);
			// experimentRun.getExperimentSubject().setPrefix(dataGenerator.getPrefix());
			// experimentRun.getExperimentSubject().enableAutoStatUpdate();
		} catch (ColumnAttributeException e) {
			System.err.println("Error on Experiment: "
					+ experimentRun.getExperimentName() + ":  "
					+ e.getMessage());
			e.printStackTrace();
			experiment.deleteExperimentRun(start_time);
		} catch (FileNotFoundException e) {
			System.err.println("Error on Experiment: "
					+ experimentRun.getExperimentName() + ":  "
					+ e.getMessage());
			e.printStackTrace();
			experiment.deleteExperimentRun(start_time);
		} catch (IOException e) {
			System.err.println("Error on Experiment: "
					+ experimentRun.getExperimentName() + ":  "
					+ e.getMessage());
			e.printStackTrace();
			experiment.deleteExperimentRun(start_time);
		} catch (DataDefinitionValidationException e) {
			System.err.println("Error on Experiment: "
					+ experimentRun.getExperimentName() + ":  "
					+ e.getMessage());
			e.printStackTrace();
			experiment.deleteExperimentRun(start_time);
		} catch (NameResolutionException e) {
			System.err.println("Error on Experiment: "
					+ experimentRun.getExperimentName() + ":  "
					+ e.getMessage());
			e.printStackTrace();
			experiment.deleteExperimentRun(start_time);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		// call Query Generator, validate xml
		/*QueryGenerator queryGenerator = experimentRun.getMyQueryGenerator();
		TransactionGenerator xactGenerator = experimentRun.getMyTransactionGenerator();
		
		// if(!queryGenerator.checkSuccess()){
		// System.err.println("Error on Experiment: " +
		// experimentRun.getExperimentName());
		// System.err.println("Query Generator not successful.");
		// System.err.println("Please check your experiment. You might forget to put '=' in binaryOperators element. ");
		// experiment.deleteExperimentRun(start_time);
		// return;
		// }

		// queryGenerator.setTestTime(startTime);
		xactGenerator.setTestTime(start_time);

		if (xactGenerator == null) {
			System.err.println("Transaction Generator not specified.");
			return;
		}
		int num_xacts = xactGenerator.generateTransactions(start_time);*/
		// Run.num_queries = num_queries;

		try {
			Scenario scen = experimentRun.getScenarioInstance();
//			if(!CheckNumCores(numCores)){
//				_logger.outputLog("Please check '/boot/grub/grub.conf' or any other grub file, to see if 'maxcpus="+numCores+"' is given in the kernel entry.");
//				System.exit(-1);
//			}
//			scen.setCores(numCores);
//			scen.setDuration(duration);
//			scen.setTerminals(numTerminals);
//			scen.setIncrements(numIncr);
//			scen.setEffectiveDBSz(effDBSz);
			scen.setConfigParamters(dbmsBuffCacheSizeMin, dbmsBuffCacheSizeMax, dbmsBuffCacheSizeIncr, 
					numCores, 
					sessionDuration, 
					minNumRowsFromSELECT, maxNumRowsFromSELECT, incrNumRowsFromSELECT,
					minNumRowsFromUPDATE,  maxNumRowsFromUPDATE, incrNumRowsFromUPDATE,
					minMPL, maxMPL, incrMPL,
					minActiveRowPool, maxActiveRowPool, incrActiveRowPool);
			scen.executeExperiment();
			
		} catch (InvalidExperimentRunException e) {
			System.err
					.println("Error on Experiment: "
							+ experimentRun.getExperimentName() + ": "
							+ e.getMessage());
			e.printStackTrace();
			experiment.deleteExperimentRun(start_time);
		} catch (Exception ex) {
			isNotDone = true;
			return;
		}

		if (Main.verbose) {
			System.out.println("End ExperimentRun: "
					+ experimentRun.getExperimentName());
		}

	/*	
		transactionTime = sdf.format(new Date(System.currentTimeMillis()));
		// exp_run.updateRunProgress(transactionTime, "Analyze Queries", 95.0);
		// exp_run.insertRunLog(transactionTime, "Analyze Queries", 95.0);
		exp_run.updateRunProgress(transactionTime, "In Progress", 95.0);
		exp_run.insertRunLog(transactionTime, "In Progress", 95.0);

		// this is a hardcoded method to analyze all the queries in the labshelf
		// it is only called when a paper deadline is approaching... sigh
		// exp_run.analyzeAllQueries();
		// TODO: to add the query analyzer here.
//		exp_run.analyzeAllQueries(lab_user_name, lab_notebook_name,
//				lab_experiment_name, start_time);

		System.out.print("Calculate Aspect for experiment " + experimentName
				+ " ...");
		// Process Aspect
		Vector<AspectDefinitionNode> defined_aspects = new Vector<AspectDefinitionNode>();
		Vector<azdblab.labShelf.dataModel.Aspect> aspects = azdblab.labShelf.dataModel.Aspect
				.getAllAspects();
		for (azdblab.labShelf.dataModel.Aspect a : aspects) {
			AspectDefinitionNode aspect_def_node = new AspectDefinitionNode(a
					.getUserName(), a.getNotebookName(), a.getAspectName(), a
					.getAspectStyle(), a.getAspectDescription(), a
					.getAspecticSQL());
			defined_aspects.add(aspect_def_node);
		}
		if (defined_aspects.size() > 0) {
			transactionTime = sdf.format(new Date(System.currentTimeMillis()));
			exp_run.updateRunProgress(transactionTime, "Calculating Aspects",
					96.0);
			exp_run.insertRunLog(transactionTime, "Calculating Aspects", 96.0);
		}
		for (int i = 0; i < defined_aspects.size(); i++) {
			AspectDefinitionNode tmpAspNode = defined_aspects.get(i);
			String aspName = tmpAspNode.getAspectName();
			String aspSQL = tmpAspNode.getAspectSQL();
			try {
				// ExperimentRun tmpExperimentRun =
				// tmpExperiment.getExperimentName();
				userName = experiment.getUserName();
				notebookName = experiment.getNotebookName();
				// scenarioName = experiment.getMyExperimentRun();
				DataDefinition tmpdatadef = experimentRun.getDataDefinition();
				// long optCard =
				// tmpdatadef.getTableCardinality(tmpExperimentRun.getVariableTables()[0].table_name);
				long optCard = experimentRun.getVarTableMinCardinality();
				long minCard = experimentRun.getVarTableMinCardinality();
				long maxCard = experimentRun.getVarTableMaxCardinality();
				Aspect.processAspect(userName, notebookName, experimentName,
						start_time, aspSQL, aspName, optCard, minCard, maxCard,
						i);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		System.out.println("Finished.");

		System.out.print("Calculate Analytics for experiment " + experimentName
				+ " ...");
		// Process Analytic
		Vector<AnalyticDefinitionNode> defined_analytics = new Vector<AnalyticDefinitionNode>();
		List<azdblab.labShelf.dataModel.Analytic> analytics = LabShelfManager
				.getShelf().getAllAnalytics();
		for (azdblab.labShelf.dataModel.Analytic a : analytics) {
			AnalyticDefinitionNode analytic_def_node = new AnalyticDefinitionNode(
					a.getUserName(), a.getNotebookName(), a.getAnalyticName(),
					a.getAnalyticStyle(), a.getAnalyticDescription(), a
							.getAnalyticSQL());
			defined_analytics.add(analytic_def_node);
		}
		if (defined_analytics.size() > 0) {
			transactionTime = sdf.format(new Date(System.currentTimeMillis()));
			exp_run.updateRunProgress(transactionTime, "Calculating Analytics",
					98.0);
			exp_run
					.insertRunLog(transactionTime, "Calculating Analytics",
							98.0);
		}
		for (int i = 0; i < defined_analytics.size(); i++) {
			AnalyticDefinitionNode tmpAnlNode = defined_analytics.get(i);
			String anlName = tmpAnlNode.getAnalyticName();
			String anlSQL = tmpAnlNode.getAnalyticSQL();
			Analytic.processAnalytic(userName, notebookName, experimentName,
					start_time, anlSQL, anlName, i);
		}
		*/
		System.out.println("Finished.");

		transactionTime = sdf.format(new Date(System.currentTimeMillis()));

		// ///////////////////////////////////////////////////////////////////////
		// Note: if network problem happens at this point, it cannot go further
		// ...
		// retry: SELECT CurrentStatus, Command FROM AZDBLAB_EXECUTOR WHERE
		// MachineName='jdbc:db2://sodb2.cs.arizona.edu:50000/research' AND
		// DBMS='db2'
		exp_run.updateRunProgress(transactionTime, "Completed", 100.0);
		exp_run.insertRunLog(transactionTime, "Completed", 100.0);
		// ////////////////////////////////////////////////////////////////////
		System.out.println("Finished.");

		// close experiment_subject - added by yksuh on 2010.11.09
		experiment_subject.close();

		LabShelfManager.getShelf().commit();

		if (Main.verbose) {
			System.out.println();
			System.out.println("####### Ending Running Tests #######");
			System.out.println("$$$$$$$ Ending Experiment " + experimentName
					+ " $$$$$$$$");
		}
	}

	/**
	 * Runs each experiment
	 * 
	 * @param experiments
	 *            A list of the experiments that need to be run by AZDBLab.
	 * 
	 *            public static void runManyExperiments(String[] experiments) {
	 *            for (int i = 0; i < experiments.length; i++) { try {
	 *            runExperiment(null, null, experiments[i]); } catch
	 *            (InvalidExperimentException e) { e.printStackTrace(); } }
	 * 
	 *            }
	 */

	/**
	 * Provides usage information to the user.
	 */
	private static void usage() {
		System.err
				.println("Error improper invocation, please use one of the following calling options");
		System.err
				.println("-observer [-verbose], if you wish to run the observer");
		System.err
				.println("-executor experimentSubject.xml 'DBMS' , to run the executor");
		// System.err.println("Truth!");
		System.exit(0); // okay exit reason

	}

	public static void populateDBMSListing() {

		Vector<PluginData> myPlugins = Main.masterManager
				.getPluginsWithSuperclass(ExperimentSubject.class);
		Vector<String> dbmsListing = new Vector<String>();
		for (int i = 0; i < myPlugins.size(); i++) {
			/*try {
				Method aMethod = myPlugins.get(i).pluginClass.getMethod(
						"getDBMSName", (Class<?>[])null);
				String dbms_Name = (String) aMethod.invoke(myPlugins.get(i).pluginClass, new Object[0]);
				dbmsListing.add(dbms_Name);
				System.out.println("DBMSNAME = " + dbms_Name);
			} catch (NoSuchMethodException nsmexp) {
				nsmexp.printStackTrace();
			}catch (Exception e) {
				e.printStackTrace();
			}*/
			try {
				Class partypes[] = new Class[4];
				partypes[0] = String.class;
				partypes[1] = String.class;
				partypes[2] = String.class;
				partypes[3] = String.class;
				Method aMethod = myPlugins.get(i).pluginClass.getMethod(
						"getDBMSName", (Class<?>[])null);
				String dbms_Name = (String) aMethod.invoke(myPlugins.get(i).pluginClass.getConstructor(partypes).newInstance(new Object[4]), new Object[0]);
				dbmsListing.add(dbms_Name);
//				System.out.println("DBMSNAME = " + dbms_Name);
			} catch (java.lang.NoSuchMethodException ex) {
				ex.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		Constants.setDBMS(dbmsListing);
	}
	/**
	 * Indicates whether the experiment has errors.
	 */
	// private static boolean _expHasErrors = false;
	/**
	 * Flag that indicates AZDBLab should only error check data.
	 */
	// private static final String ERROR_CHECK_ONLY = "-errorCheckOnly";
	/**
	 * Indicates whether AZDBLab should error check only
	 */
	public static boolean errorCheckOnly = false;
	/**
	 * Indicates whether AZDBLab should unistall the system.
	 */
	public static boolean bUninstall = false;
	/**
	 * Flag that tells AZDBLab to uninstall an experiment.
	 */
	// private static final String UNINSTALL_EXPERIMENT =
	// "-uninstallExperiment";
	// private static final String UNINSTALL_EXPERIMENT = "-d";
	/**
	 * Flag that tells AZDBLab to uninstall the system.
	 */
	// private static final String UNINSTALL_SYSTEM = "-uninstallAZDBLab";
	/**
	 * Indicates whether should uninstall the current experiments.
	 */
	public static boolean uninstallExperiment = false;

	/**
	 * Indicates whether AZDBLab should print messages to stdout
	 */
	public static boolean verbose = false;
	/**
	 * Flag that tells AZDBLab to print progress messages to stdout
	 */
	private static final String VERBOSE = "-verbose";
	/**
	 * Flag that tells AZDBLab that the result browser should be invoked.
	 */
	/**
	 * Indicates whether the result browser should be invoked.
	 */
	public static boolean viewResult = false;

	public static final String EXECUTOR = "-executor";
	public static final String HOSTNAME = "-host";

	public static boolean bExecutor = false;

	public static final String OBSERVER = "-observer";

	public static boolean bObserver = false;

	public static final String UNINSTALL = "-uninstall";

	public static final String CREATOR = "-creator";

	public static boolean bCreator = false;

	public static void setLABUSERNAME(String UserName) {
		Main.LAB_USERNAME = UserName;
	}

	public static void setLABPASSWORD(String Password) {
		Main.LAB_PASSWORD = Password;
	}

	public static void setLABCONNECTSTRING(String ConnectString) {
		Main.LAB_CONNECTSTRING = ConnectString;
	}

	public static String getLABUSERNAME() {
		return Main.LAB_USERNAME;
	}

	public static String getLABPASSWORD() {
		return Main.LAB_PASSWORD;
	}
	public static String getLABCONNECTSTRING() {
		return Main.LAB_CONNECTSTRING;
	}

	public static boolean isNotDone = false;;
}
