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
package azdblab.plugins.experimentSubject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.net.Socket;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;
import azdblab.Constants;
import azdblab.exception.procmonitor.ProcMonitorException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TransactionStat;
import azdblab.labShelf.dataModel.StateData;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;
import azdblab.utility.procdiff.LinuxProcessAnalyzer;
import azdblab.utility.procdiff.ProcessInfo;
import azdblab.utility.procdiff.StatInfo;
import azdblab.utility.watcher.StreamHandler;

/**
 * <p>The ExperimentSubject class implements the GeneralDBMS interface. It basically handles the experiment methods.</p>
 * <p>The regular expression of trace of the method calls should be: </p>
 * <p>(SA) (SV GP)* (SV TQ)* </p>
 * <p>In which SA represents setActualTableCardinality()	</p>
 * <p>		SV represents setVirtualTableCardinality()	</p>
 * <p>		GP represents getQueryPlan()				</p>
 * <p>		TQ represents timeQuery()					</p>
 * <p>
 * All tables should first be populated with SA and then the optimal query plan is generated for the actual cardinalities. 
 * After that, variable table will be set with different cardinalities as to generate different plans for the fake cardinalities.
 * At last, All the query plans gathered from last step will be timed to report their running time. And at least one plan, the optimal one, should be tested.
 * The SV call before TQ makes sure that the table has the same cardinality and the same set of records at this step as in the 2nd step in which those plans were generated.
 * </p>
 * 
 */
public abstract class ExperimentSubject extends GeneralDBMS{
	protected class TimeoutProcMonitor extends TimerTask{
		protected Process procMon = null;
	    public TimeoutProcMonitor(Process proc) {
	    	Main._logger.outputLog("Setting timeout for proc monitor!");
	    	procMon = proc;
	    }
	    
	    public void run() {
	      try {
	    	  Main._logger.outputLog("Kill proc monitor!");
	    	  if(procMon != null)
	    		  killProcMonitor(procMon);
	    	  cancel();
	      } catch (Exception ex) {
//	    	  ex.printStackTrace();
	      }
	    }
	  }
	
  protected class TimeoutQueryExecution extends TimerTask{
    public TimeoutQueryExecution() {}
    

    public void run() {
      try {
    	  if(query_executor_statement != null) {
    		  query_executor_statement.cancel();
    		  cancel();
    	  }
      } catch (Exception ex) {
//    	  ex.printStackTrace();
      }
    }
  }
  
  protected class TimeoutPreparedQueryExecution extends TimerTask{
	    private PreparedStatement pstmt; 
	    public TimeoutPreparedQueryExecution(PreparedStatement statePstmt) { 
	    	pstmt = statePstmt;
	    }

	    public void run() {
	      try {
	    	  if(pstmt != null) pstmt.cancel();
	      } catch (Exception ex) {
	        ex.printStackTrace();
	      }
	    }
	  }
  
  private String connectString = "";
  private String strMachineName = "";
  protected boolean bProcMonitorError = false;
  
  /**
   * The constructor specifies the connecting strings to the DBMS.
   * @param user_name The user name for the database account that stores the tables of AZDBLab.
   * @param password The password to authenticate with the DBMS.
   * @param connect_string The connect string specifies the drivers, port, ip, and other critical information
   * to connect using JDBC.  See oracle documentation for specific information on what information should 
   * be included here.
   */
  public ExperimentSubject(String user_name, String password, String connect_string, String machineName) {
    super(user_name, password, connect_string);  
    connectString = connect_string;
    strMachineName = machineName;
  }
    
  /**
   * This method is used to retrieve the query plan of the SQL query with the current 
   * DBMS statistics. Which are stored by <code>setVirtualTableCardinality()<code>.
   * @param sqlQuery The query that is passed to the DBMS.
   * @return A query plan for the query <code>sqlQuery</code>.
   * @throws Exception If the DBMS cannot return the query plan. The cause of this exception is DBMS
   * specific.
   */
  public abstract PlanNode getQueryPlan(String sqlQuery) throws Exception;
  /**
   * Get the passed state prepared 
   */
  public StateData getPreparedState(StateData state) throws Exception {
	  	if(state.pstmt == null){
			state.pstmt = _connection.prepareStatement(state.query);
			_connection.commit();
	  	}
		state.plan = getQueryPlan(state.query);
		return state;
  }
    
  /**
   * Time the specified sql statement.  The query plan is passed in as a parameter so that we can verify that the plan passed in
   * is the same as the query plan that the DBMS will use.
   * @param sqlQuery The SQL query that will be timed.
   * @param plan The query plan that corresponds to the SQL query being timed (with the current cardinality).
   * @param cardinality the table cardinality corresponding to current plan 
   * @return The <code>QueryStat</code> object containing information about
   *       time and so forth of executing the query.
   * @throws SQLException If timing the query fails because the table space is exhausted.
   * @throws Exception For failure other than above.
   */
  public QueryExecutionStat timeQuery(
      String sqlQuery, PlanNode plan, long cardinality,
      int time_out) throws SQLException, Exception {
		PlanNode curr_plan = getQueryPlan(sqlQuery);
		// verifies that the current query plan is the plan that AZDBLAB thought it was timing.
		if (!curr_plan.equals(plan)) {
			Main._logger.outputLog("query: " + sqlQuery);
			Main._logger.outputLog("cardinality: " + cardinality);
			Main._logger.outputLog("hash code for a given plan: " + plan.myHashCode());
			Main._logger.outputLog("a given plan: "	+ plan.toString());
			Main._logger.outputLog("hash code for a current plan: "	+ curr_plan.myHashCode());
			Main._logger.outputLog("a current plan: "	+ curr_plan.toString());
			throw new Exception("timeQuery: detected plan error.  Tried to time different plan from change point plan");
		}
		String timedQuerySQL = sqlQuery;
		long start_time;
		long finish_time;
		long exec_time = 0;
		String proc_diff = "";
//		TimeoutQueryExecution timeOuter = new TimeoutQueryExecution();
//		
//		Timer timer = new Timer();
		
		// process monitor
		Process procMon = null;
		// overall stat
		StatInfo beforeStat = null, afterStat = null;
		try {
			flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
			flushOSCache();
			Main._logger.outputLog("Finish Flushing OS Cache");
			flushDBMSCache();
			Main._logger.outputLog("Finish Flushing DBMS Cache");
			// create a statement to execute the query
			query_executor_statement = _connection.createStatement();
			// set up timer
			query_executor_statement.setQueryTimeout(time_out);
			
			// start process monitor
			int portNum = ((new Random()).nextInt(10000))+7000;
			procMon = runProcMonitor(portNum);
			
			// If proc diff can't be generated within tim
			TimeoutProcMonitor procMonTimeOuter = new TimeoutProcMonitor(procMon);
			Timer procMonTimer = new Timer();
			procMonTimer.scheduleAtFixedRate(procMonTimeOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
			
			boolean runningOnVM = !azdblab.executable.Executor.VMProcMonHostname.isEmpty();
			// set up time out thread
//			timer.scheduleAtFixedRate(timeOuter, time_out, time_out);
			// get processes
//			HashMap<Long, ProcessInfo> beforeMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.PRE_QE);
//			// get cpu stat
//			StatInfo beforeStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// get max pid
//			beforeStat.set_max_pid(LinuxProcessAnalyzer.getMaxPID());
			beforeStat = LinuxProcessAnalyzer.getStatInfo();
			// start time
			
			
			Socket localProcMonSock = new Socket("localhost", portNum);
			Socket hostProcMonSock = null;
			
			if (runningOnVM)
				hostProcMonSock = new Socket(azdblab.executable.Executor.VMProcMonHostname, 
						azdblab.executable.Executor.VMProcMonPortNum);
			
			byte[] b = new byte[3];
			localProcMonSock.getInputStream().read(b);
			
			if (runningOnVM)
				hostProcMonSock.getInputStream().read(b);
			
			start_time = System.currentTimeMillis();
			
			// execute the query
			query_executor_statement.executeQuery(timedQuerySQL);
			// finish time
			finish_time = System.currentTimeMillis();
//			// get max pid
//			long max_pid = LinuxProcessAnalyzer.getMaxPID();
//			// get cpu stat
//			StatInfo afterStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// set max pid
//			afterStat.set_max_pid(max_pid);
			proc_diff = getProcDiff(localProcMonSock);
			if (runningOnVM)
				proc_diff += "VM:\n"+getProcDiff(hostProcMonSock);
			
			afterStat = LinuxProcessAnalyzer.getStatInfo();
			// get processes
			//HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
			// do map diff
			proc_diff += LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
													   beforeStat,
												  	   afterStat//,
												  	   //beforeMap, 
												  	   //afterMap
												  	   );
			// get the time
			exec_time = finish_time - start_time;
			
			// kiil process monitor
			if(procMon != null)
				killProcMonitor(procMon);
			
			// cancel scheduled timer
//			timer.cancel();
			// cancel timeout thread
//			timeOuter.cancel();
			
			// cancel scheduled timer
			procMonTimer.cancel();
			// cancel timeout thread
			procMonTimeOuter.cancel();
			
			// close the created statement
			query_executor_statement.close();
		} 
		catch(ProcMonitorException pmex){
			if(procMon != null)
				killProcMonitor(procMon);
			if (!bProcMonitorError) {
				bProcMonitorError = true;
				QueryExecutionStat result = timeQuery(sqlQuery, plan, cardinality, time_out);
				bProcMonitorError = false;
				return result;
			}
			else{
				throw pmex;
			}
				
		}
		catch (Exception e) {
			Main._logger.reportError(e.toString());
			exec_time = Constants.MAX_EXECUTIONTIME;
			Main._logger.outputLog("Execution too long: Execution time set to " + exec_time);
			
			if(procMon != null)
				killProcMonitor(procMon);
//			int task = timer.purge();
//			System.out.println("cancelled task: " + task);
//			if(query_executor_statement != null) {
//				System.out.println("statement is closed.");
//				query_executor_statement.close();
//			}
//			if(timeOuter != null) {
//				System.out.println("timeouter is canceled.");
//				timeOuter.cancel();
//			}
//			if(timer != null) {
//				System.out.println("timer is canceled.");
//				timer.cancel();
//			}
			reset();
		}
		if (Main.verbose) {
			Main._logger.outputLog("Query Plan Execution Time: "
					+ exec_time);
		}
		return new QueryExecutionStat(exec_time, proc_diff);
  	}

protected String getProcDiff(Socket procMonSock) throws ProcMonitorException {
		String proc_diff = "";
		try{
			new DataOutputStream(procMonSock.getOutputStream()).writeBytes("STOP");
			InputStreamReader isr = new InputStreamReader(procMonSock.getInputStream());
			BufferedReader br = new BufferedReader(isr);
			String line=null;
			while ( ((line = br.readLine()) != null) && (!line.startsWith("END"))) {
				proc_diff += line + "\n";
			}
			procMonSock.close();
		}catch(Exception ex){
			throw new ProcMonitorException(ex.getMessage());
		}
		return proc_diff;
	}
   
  
  /**
   * Time the specified sql using PreparedStatement.  
   * The query plan is passed in as a parameter so that we can verify that the plan passed in
   * is the same as the query plan that the DBMS will use.
   * @param sqlQuery The SQL query that will be timed.
   * @param plan The query plan that corresponds to the SQL query being timed (with the current cardinality).
   * @param cardinality the table cardinality corresponding to current plan 
   * @return The <code>QueryStat</code> object containing information about
   *       time and so forth of executing the query.
   * @throws SQLException If timing the query fails because the table space is exhausted.
   * @throws Exception For failure other than above.
   */
  public QueryExecutionStat timePreparedQuery(
      String sqlQuery, PreparedStatement pstmt, PlanNode plan, long cardinality,
      int time_out) throws SQLException, Exception {
		PlanNode curr_plan = getQueryPlan(sqlQuery);
		// verifies that the current query plan is the plan that AZDBLAB thought
		// it // was timing.
		if (!curr_plan.equals(plan)) {
			Main._logger.outputLog("query: " + sqlQuery);
			Main._logger.outputLog("cardinality: " + cardinality);
			Main._logger.outputLog("hash code for a given plan: " + plan.myHashCode());
			Main._logger.outputLog("a given plan: "	+ plan.toString());
			Main._logger.outputLog("hash code for a current plan: "	+ curr_plan.myHashCode());
			Main._logger.outputLog("a current plan: "	+ curr_plan.toString());
			throw new Exception("timeQuery: detected plan error.  Tried to time different plan from change point plan");
		}
		long start_time;
		long finish_time;
		long exec_time = 0;
		String proc_diff = "";

//		timePreparedOuter = new TimeoutPreparedQueryExecution(pstmt);
//		
//		Timer timer = new Timer();
		
		// process monitor
		Process procMon = null;
		// overall stat
		StatInfo beforeStat = null, afterStat = null;
		TimeoutProcMonitor procMonTimeOuter = null;
		Timer procMonTimer = null;
		try {
			flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
			flushOSCache();
			Main._logger.outputLog("Finish Flushing OS Cache");
			flushDBMSCache();
			Main._logger.outputLog("Finish Flushing DBMS Cache");
			// set up timer
			pstmt.setQueryTimeout(time_out);
			
			int portNum = ((new Random()).nextInt(10000))+7000;
			// start process monitor
			procMon = runProcMonitor(portNum);
			
			// proc monitor timeouter
			procMonTimeOuter = new TimeoutProcMonitor(procMon);
			procMonTimer = new Timer();
			// run proc monitor timeout thread
			procMonTimer.scheduleAtFixedRate(procMonTimeOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
			
			boolean runningOnVM = !azdblab.executable.Executor.VMProcMonHostname.isEmpty();

//			// set up time out thread
//			timer.scheduleAtFixedRate(timePreparedOuter, time_out, time_out);
			// get processes
			beforeStat = LinuxProcessAnalyzer.getStatInfo();
			// start time
									
			Socket localProcMonSock = new Socket("localhost", portNum);
			Socket hostProcMonSock = null;
			
			if (runningOnVM)
				hostProcMonSock = new Socket(azdblab.executable.Executor.VMProcMonHostname, 
						azdblab.executable.Executor.VMProcMonPortNum);
			
			byte[] b = new byte[3];
			localProcMonSock.getInputStream().read(b);
			
			if (runningOnVM)
				hostProcMonSock.getInputStream().read(b);
			
			start_time = System.currentTimeMillis();
			// execute the prepared query
			pstmt.executeQuery();
			// finish time
			finish_time = System.currentTimeMillis();
//			// get max pid
//			long max_pid = LinuxProcessAnalyzer.getMaxPID();
//			// get cpu stat
//			StatInfo afterStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// set max pid
//			afterStat.set_max_pid(max_pid);
			proc_diff = getProcDiff(localProcMonSock);
			if (runningOnVM)
				proc_diff += "VM:\n"+getProcDiff(hostProcMonSock);
			afterStat = LinuxProcessAnalyzer.getStatInfo();
			// get processes
			//HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
			// do map diff
			proc_diff += LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
													   beforeStat,
												  	   afterStat//,
												  	   //beforeMap, 
												  	   //afterMap
												  	   );
			// get the time
			exec_time = finish_time - start_time;

			// cancel proc monitor timeout thread
			procMonTimeOuter.cancel();
			// cancel scheduled proc monitor timer
			procMonTimer.cancel();
			
			// kill process monitor
			if(procMon != null)
				killProcMonitor(procMon);
			
//			// cancel scheduled timer
//			timer.cancel();
//			// cancel timeout thread
//			timePreparedOuter.cancel();
		} 
		catch(ProcMonitorException pmex){
			if(procMon != null)
				killProcMonitor(procMon);
			if (!bProcMonitorError) {
				bProcMonitorError = true;
				QueryExecutionStat result = timePreparedQuery(sqlQuery, pstmt, plan, cardinality, time_out);
				bProcMonitorError = false;
				return result;
			}
			else{
				throw pmex;
			}
		}
		catch (Exception e) {
			Main._logger.reportError(e.toString());
			exec_time = Constants.MAX_EXECUTIONTIME;
			Main._logger.outputLog("Execution too long: Execution time set to " + exec_time);
			
			if(procMon != null)
				killProcMonitor(procMon);
			
			reset();
		}
		if (Main.verbose) {
			Main._logger.outputLog("Query Plan Execution Time: "
					+ exec_time);
		}
		return new QueryExecutionStat(exec_time, proc_diff);
  }
  
  /****
   * Run proc monitor
   * @return proc monitor process
 * @throws ProcMonitorException 
   */
  protected Process runProcMonitor(int portNum) throws ProcMonitorException {
	  try {
	      Runtime rt = Runtime.getRuntime();
	      final Process p0 = rt.exec("./"+Constants.PROC_MONITOR_NAME + " " + portNum);
//	      InputStream instd = p0.getInputStream();
//	      BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
//	      String tmp_data = null;
//	      while ((tmp_data = buf_reader.readLine()) != null) {  
//	      }
//	      buf_reader.close();
//	      p0.waitFor();
	      Thread.sleep(3000);
//	      Thread thread1 = new Thread() {
//				//proc1 = runs executor, proc2 =watcher
//				public void run() {
//				  InputStream errstd = p0.getErrorStream();
//    		      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
//    		      String line = "";
//    		      try {
//					while ((line=buf_err_reader.readLine()) != null) {  
//						  System.err.println(line);
//					  }
//					 buf_err_reader.close();
//					} catch (IOException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					}
//				}
//			};
//			thread1.start();
			return p0;
	    } catch (Exception ex) {
	      ex.printStackTrace();
	      throw new ProcMonitorException(ex.getMessage());
	    }  	
  }

  /****
   * Kill proc monitor
   * @return proc monitor process
 * @throws SecurityException 
 * @throws NoSuchFieldException 
 * @throws IllegalAccessException 
 * @throws IllegalArgumentException 
 * @throws IOException 
 * @throws InterruptedException 
   */
  protected void killProcMonitor(Process procMonitor) throws Exception {
		  Integer procMonPID = new Integer(0);
		  if (procMonitor.getClass().getName().equals("java.lang.UNIXProcess"))
		  {
				Class cl = procMonitor.getClass();
				Field field = cl.getDeclaredField("pid");
				field.setAccessible(true);
				Object pidObject = field.get(procMonitor);
				procMonPID = (Integer) pidObject;
		  } else {
			  throw new IllegalArgumentException("Needs to be a UNIXProcess");
		  }
		  
		  Process p1 =  Runtime.getRuntime().exec("sudo kill -9 " + procMonPID.intValue());
		  InputStream errstd = p1.getErrorStream();
	      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
	      String line = "";
	      while ((line=buf_err_reader.readLine()) != null) {  
	    	  Main._logger.reportError(line);
	      }
	      buf_err_reader.close();
//	      p1.waitFor();
	      
	      Thread.sleep(3000);
//	      Runtime.getRuntime().exec("sudo kill -9 ");
//	      InputStream instd = p0.getInputStream();
//	      BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
//	      String tmp_data = null;
//	      while ((tmp_data = buf_reader.readLine()) != null) {  
//	      }
//	      buf_reader.close();
//	      p0.waitFor();
  }
/***
   *  This method populates a variable table(s) with random records with the amount 
   *  equal to corresponding cardinality.
   *  
   * @param tableName 			: the table name
   * @param columnnum 			: # of columns
   * @param maximum_cardinality : maximum cardinality
   * @param repRand				: repeatable random object
   */
  public void populateVariableTable(
      String tableName, 
      int columnnum, 
      long maximum_cardinality, 
      RepeatableRandom repRand){
	  try{
		  Main._logger.outputLog("Clearing Table: " + tableName);
		  String  clearSQL  = "DELETE FROM " + tableName;
		  _statement.executeUpdate(clearSQL);
		  commit();
		  String  strupdate  = "";
	      Main._logger.outputLog("Populating Table to maximum cardinality: " + tableName);
	      for ( long i = 0; i < maximum_cardinality; i++ ){
	          if ((i + 1) % 10000 == 0){
	            Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
	            commit();
	          }
	          String  strdata  = "";
	          // Assume all data fields are of integer data type
	          for ( int j = 0; j < columnnum - 1; j++ ) {
	            if (j == columnnum - 2) {
	              strdata  += repRand.getNextRandomInt();
	            } else {
	              strdata  += repRand.getNextRandomInt() + ",";
	            }
	          }
	          strupdate = "INSERT INTO " + tableName + " VALUES(" + i + "," +
	                      strdata + ")";
	          _statement.executeUpdate(strupdate);
	        }
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
        Main._logger.outputLog("Clearing Table: " + tableName);
        String  clearSQL  = "DELETE FROM " + tableName;
        _statement.executeUpdate(clearSQL);
        commit();
        String  strupdate  = "";
        Main._logger.outputLog("Populating Table to actual cardinality: " + tableName);
        for ( long i = 0; i < actual_cardinality; i++ ){
          if ((i + 1) % 10000 == 0){
            Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//            commit();
          }
          String  strdata  = "";
          // Assume all data fields are of integer data type
          for ( int j = 0; j < columnnum - 1; j++ ) {
            if (j == columnnum - 2) {
              strdata  += repRand.getNextRandomInt();
            } else {
              strdata  += repRand.getNextRandomInt() + ",";
            }
          }
          strupdate = "INSERT INTO " + tableName + " VALUES(" + i + "," +
                      strdata + ")";
          _statement.addBatch(strupdate);
        }
      } else {
        String  cloneMaxTableName  = "clone_max_" + tableName;
        Main._logger.outputLog("Clearing Table: " + tableName);
        String  clearSQL  = "DELETE FROM " + tableName;
        _statement.executeUpdate(clearSQL);
        copyTable(cloneMaxTableName, tableName);
        String  strupdate  = "";
        for (long i = 0; i < maximum_cardinality; i++){
          if ((i + 1) % 10000 == 0){
            Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//            commit();
          }
          String  strdata  = "";
          // Assume all data fields are of integer data type
          for ( int j = 0; j < columnnum - 1; j++ ) {
            if (j == columnnum - 2) {
              strdata  += repRand.getNextRandomInt();
            } else {
              strdata  += repRand.getNextRandomInt() + ",";
            }
          }
          strupdate = "INSERT INTO " + cloneMaxTableName + " VALUES(" +
                      i + "," + strdata + ")";
          _statement.addBatch(strupdate);
        }
      }
      _statement.executeBatch();
      commit();
    } catch (SQLException sqlex){
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
  public void populateXactTable(
      Table table, RepeatableRandom repRand) throws Exception{
    try {
    	String tableName = table.table_name_with_prefix;
    	int columnnum = table.columns.length;
    	long actual_cardinality = table.actual_card;
        long maximum_cardinality = table.hy_max_card;
        
        Main._logger.outputLog("Clearing Table: " + tableName);
        String  clearSQL  = "DELETE FROM " + tableName;
        _statement.executeUpdate(clearSQL);
        commit();
        String  strupdate  = "";
        Main._logger.outputLog("Populating Table to actual cardinality: " + tableName);
        for ( long i = 0; i < actual_cardinality; i++ ){
          if ((i + 1) % 10000 == 0){
            Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//            commit();
          }
          String  strdata  = "";
          Column[] column = table.getColumns();
          // Assume all data fields are of integer data type
          for ( int j = 1; j < columnnum; j++ ) {
        	  if(column[j].myName.contains("val")){
        		  strdata += "'Dallas, long scarred by the guilt and shame of being the place Pres. JFK was assassinated.'";
        	  }else{
        		  strdata += repRand.getNextRandomInt();
        	  }
        	  if(j < columnnum -1){
        		  strdata += ",";  
        	  }
          }
          strupdate = "INSERT INTO " + tableName + " VALUES(" + i + "," +
                      strdata + ")";
          _statement.addBatch(strupdate);
        }
      _statement.executeBatch();
      commit();
    } catch (SQLException sqlex){
      sqlex.printStackTrace();
    }
  }
    
  public abstract void copyTable(String newTable, String oriTable)  throws Exception;
    
  public abstract void copyTable(String newTable, String oriTable,
                                  long cardinality) throws Exception;
    
//  public abstract void updateTableStatistics(
//      String tableName, long cardinality);
//  public abstract void updateTableStatistics(String tableName);
  public abstract void updateTableStatistics(Table table) throws Exception;
    
  /**
   * This method sets the table cardinality in the internal data dictionaries.
   * For different DBMSes, actual implementation varies.
   * @param tableName This table will have its cardinality statistics modified.
   * @param requested_cardinality The new cardinality for table tableName.
   * @param repRand The <code>RepeatableRandom</code> instance used to generate random values for table
   */
  public void updateTableCardinality(
      String tableName, long requested_cardinality, long maximum_cardinality) throws Exception{
    if (requested_cardinality == maximum_cardinality) {
      copyTable(tableName, "clone_max_" + tableName); // ft_HT1 is supposed to be deleted, not "clone_max" table)
      commit();
      return;
    }
    String sqldelete = "DELETE FROM " + tableName + " WHERE id1 >= " + requested_cardinality; 
    try {
      _statement.executeUpdate(sqldelete);
      commit();
    } catch (SQLException sqlex){
    }
  }
  
//  public void updateTableCardinalityByCopy(String tableName, long requested_cardinality) {
//	  copyTable(tableName, "clone_max_" + tableName, requested_cardinality); 
//	  return;
//  }
 
  public abstract void printTableStat(String tableName);
  
  public int getTableCardinality(String tableName) throws Exception{
	  int res = 0;
	  String countSQL = "SELECT count(*) " + "FROM " + tableName;
	  try {
//		  Main.defaultLogger.logging_normal("count sql: " + countSQL);
		  commit();
		  ResultSet cs = _statement.executeQuery(countSQL);
		  if(cs.next()){
		  		res = cs.getInt(1);
		  }
		  cs.close();
	  } catch (SQLException e) {
		  e.printStackTrace();
		  String errMsg = "exception-No statistics for table: " + tableName;
		  Main._logger.reportError(errMsg);
		  throw new Exception(errMsg);
	  }
	  return res;
  }
  
  /**
   * Retrieves the names of the properties for this specific DBMS; these properties can appear in PlanNodes.
   * @return The names of properties for this specific DBMS.
   */
  public abstract String[] getPlanProperties();

  /**
   * Retrieves the names of the possible operators for this specific DBMS; these operators can appear in OperatorNodes
   * @return The names of the possible operators for this specific DBMS
   */
  public abstract String[] getPlanOperators();
    
  /**
   * Installs the tables necessary for an experiment
   */    
  public abstract void installExperimentTables(DataDefinition myDataDef, String myPrefix);
    
  /**
   * Delete the Helper tables for experiment. Such as the cache tables, and the plan table, if exists.
   */    
  public abstract void deleteHelperTables();
        
  /**
   * Drops all existing tables
   */    
  public abstract void dropAllInstalledTables();
  
   /**
   * The Name of this DBMS
   */
  public abstract String getDBMSName();
  /**
   * The Driver Class Name of this DBMS
   */
  public abstract String getDBMSDriverClassName();
  /**
   * The Version of this DBMS
   */
  public abstract String getDBVersion();
//  /**
//   * Experiment Subject Name
//   */
//  public abstract String getExperimentSubjectName();
  
//  /**
//   * The Name of this DBMS
//   */
//  public abstract String getName();
  
  /**
   * The DBMS machine name
   */
  public String getMachineName(){
	  return strMachineName;
  }
  
  public abstract void setOptimizerFeature(String featureName, String featureValue);
    
  /**
   * This method is used to flush DBMS cache.
   * This is specific to DBMS.
   * @param null
   * @return none 
   */
  public abstract void flushDBMSCache();
 
  
  /**
   * This method is used to flush buffer cache in OS
   * SqlServer subject will invoke flushWindowsCache() in flushOSCache().
   * Other subjects will invoke flushLinuxCachey() in flushOSCache().
   * @param null
   * @return none 
   * specific.
   */
  public void flushOSCache() { flushLinuxCache(); }
  
  /**
   * Flush buffer cache in linux system
   */
  protected void flushLinuxCache() {
	  try {
	      Runtime rt = Runtime.getRuntime();
	      Process p1 = rt.exec(
	          "sudo /usr/local/sbin/setdropcaches 1");
	      InputStream instd = p1.getInputStream();
	      BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
	      while (buf_reader.readLine() != null) {
	      }
	      buf_reader.close();
	      InputStream errstd = p1.getErrorStream();
	      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
	      while (buf_err_reader.readLine() != null) {  
	      }
	      buf_err_reader.close();
	      p1.waitFor();

	      Process p2 = rt.exec("sync");
	      instd = p2.getInputStream();
	      buf_reader = new BufferedReader(new InputStreamReader(instd));
	      while (buf_reader.readLine() != null) {  
	      }
	      buf_reader.close();
	      errstd = p2.getErrorStream();
	      buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
	      while (buf_err_reader.readLine() != null) {  
	      }
	      buf_err_reader.close();
	      p2.waitFor();
	    } catch (Exception ex) {
	      ex.printStackTrace();
	    }
//	    Main._logger.outputLog("Done");
  }

  /**
   * Flush buffer cache in windows system
   * 
   */
  protected void flushWindowsCache() {
	  	/*** 
	  	 * http://www.addictivetips.com/windows-tips/clear-windows-7-cache/
	  	 * We don't know how to flush window cache, yet, but if we have a program to do it,
	  	 * then we can use it.
	  	 */
		try {
			Runtime rt = Runtime.getRuntime();
			String strCommand = "C:\\Windows\\System32\\rundll32.exe advapi32.dll, ProcessIdleTasks";
			Process p1 = rt.exec(strCommand);
			InputStream instd = p1.getInputStream();
			BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
			while (buf_reader.readLine() != null) {
			}
			buf_reader.close();
			InputStream errstd = p1.getErrorStream();
			BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
			while (buf_err_reader.readLine() != null) {
			}
			buf_err_reader.close();
			p1.waitFor();

//			Process p2 = rt.exec("C:\\Experiment\\sync");
//			instd = p2.getInputStream();
//			buf_reader = new BufferedReader(new InputStreamReader(instd));
//			tmp_data = null;
//			while ((tmp_data = buf_reader.readLine()) != null) {
//			}
//			buf_reader.close();
//			errstd = p2.getErrorStream();
//			buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
//			tmp_err_data = null;
//			while ((tmp_err_data = buf_err_reader.readLine()) != null) {
//			}
//			buf_err_reader.close();
//			p2.waitFor();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
  }
  
  /**
   * This method is used to read a big file in system as an alternative to flushing HDD cache.
   * @param dummyName dummy file name
   * @return none 
   * specific.
   */
  public void flushDiskDriveCache(String dummyName) { 
	  	File dummy_file = new File(dummyName);
		try {
			BufferedReader buf_reader = new BufferedReader(new FileReader(dummy_file));
			while (buf_reader.readLine() != null) {
			}
			buf_reader.close();
		} catch (IOException ioex) {
		}
	    Main._logger.outputLog("Done");
  }
  
//  /**
//   * Flush disk drive cache in linux system
//   */
//  public void flushLinuxDiskDriveCache(String dummyFileName) {
//	    try {
//	      Runtime rt = Runtime.getRuntime();
//	      Process p0 = rt.exec("grep abcdefg12345 /scratch/data64");
//	      InputStream instd = p0.getInputStream();
//	      BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
//	      String tmp_data = null;
//	      while ((tmp_data = buf_reader.readLine()) != null) {  
//	      }
//	      buf_reader.close();
//	      InputStream errstd = p0.getErrorStream();
//	      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
//	      String tmp_err_data = null;
//	      while ((tmp_err_data = buf_err_reader.readLine()) != null) {  
//	      }
//	      buf_err_reader.close();
//	      p0.waitFor();
//	    } catch (Exception ex) {
//	      ex.printStackTrace();
//	    }  	
//  }
  
//  /**
//   * Flush disk drive cache in windows system
//   */
//  public void flushWindowsDiskDriveCache() {
//		try {
//			Runtime rt = Runtime.getRuntime();
//			Process p0 = rt.exec("FindStr abcdefg12345 C:\\Temp\\data64");
//			InputStream instd = p0.getInputStream();
//			BufferedReader buf_reader = new BufferedReader(
//					new InputStreamReader(instd));
//			String tmp_data = null;
//			while ((tmp_data = buf_reader.readLine()) != null) {
//			}
//			buf_reader.close();
//			InputStream errstd = p0.getErrorStream();
//			BufferedReader buf_err_reader = new BufferedReader(
//					new InputStreamReader(errstd));
//			String tmp_err_data = null;
//			while ((tmp_err_data = buf_err_reader.readLine()) != null) {
//			}
//			buf_err_reader.close();
//			p0.waitFor();
//		} catch (Exception ex) {
//			ex.printStackTrace();
//		}
//		 Main._logger.outputLog("Flushing Window Memory is Done");
//  }
  
  /**
   * This method is used to create tables necessary to retrieve the query plan of the SQL query
   * @param null
   * @return none 
   * @throws Exception if the initialization fails. 
   * specific.
   */
  public abstract void initializeSubjectTables();
  /**
   * This method is used to turn on automatic statistics update
   * @param null
   * @return none 
   * @throws Exception if disabling the update fails. 
   * specific.
   */
  public abstract void enableAutoStatUpdate();
  /**
   * This method is used to turn off the automatic statistics update
   * @param null
   * @return none 
   * @throws Exception if enabling the update fails. 
   * specific.
   */
  public abstract void disableAutoStatUpdate();
  
  protected TimeoutQueryExecution timeOuter;
  protected TimeoutPreparedQueryExecution timePreparedOuter;
  //  protected PreparedStatement query_executor_statement;
  protected Statement query_executor_statement;
  
  /*****
   * Run transactions
   * @return
   */
	public TransactionStat runTransactions() {
		
		return null;
	}

	/****
	 * Execute sql statement 
	 * @param sql a given SQL statement
	 * @throws SQLException
	 */
	public void executeSQLStmt(String sql) throws SQLException {
		if(_statement == null){
			Main._logger.reportError("Statement is null...");
			if(_connection == null){
				Main._logger.reportError("Connection is null...");
				_connection = DriverManager.getConnection(strConnectString,
						strUserName, strPassword);
			}
			_statement = _connection
					.createStatement(ResultSet.TYPE_FORWARD_ONLY,
							ResultSet.CONCUR_UPDATABLE);
		}
		_statement.execute(sql);	
		_statement.close();
	}
  
  
  /**
   * Set DataDefinition object.
   */
//  public void setDataDefinition(DataDefinition myDef) {
//	  _expDataDef = myDef;
//  }
//  
//  /**
//   * Set table prefix.
//   */
//  public void setPrefix(String prefix) {
//	  _expPrefix = prefix;
//  }
  	
  
}
