import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;
import java.util.Timer;

//import azdblab.Constants;
//import azdblab.exception.procmonitor.ProcMonitorException;
//import azdblab.executable.Main;
//import azdblab.labShelf.PlanNode;
//import azdblab.labShelf.QueryExecutionStat;
//import azdblab.plugins.experimentSubject.ExperimentSubject.TimeoutProcMonitor;
//import azdblab.utility.procdiff.LinuxProcessAnalyzer;
//import azdblab.utility.procdiff.StatInfo;

public class UnitTestingProg {
//	private static Connection _connection;
//	private static Statement _statement;
//	private static String user_name = "azdblab_user";
//	private static String password = "azdblab_user";
//	private static String connect_string = "jdbc:mysql://sodb9.cs.arizona.edu/AZDBLAB";
//	private static String DBMS_DRIVER_CLASS_NAME = "com.mysql.jdbc.Driver";
//	
//	/***
//     * Connect to Mysql 
//     */
//	public static void connect() {
//		try {
//			Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		    _connection.setAutoCommit(false);
//		    _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//		    System.out.println("Connected.");
//		}catch(Exception e){
//			e.printStackTrace();
//		}
//	}
//	
//	public static void flushDBMSCache() {
//		try {
//			/**
//			 * "FLUSH TABLES" command need to be executed by root. Thus, a
//			 * separation connection for root is made to do that.
//			 * 
//			 * What "FLUSH TABLES" does is to close all open tables, force all
//			 * tables in use to be closed, and flush the query cache. FLUSH
//			 * TABLES also removes all query results from the query cache, like
//			 * the RESET QUERY CACHE statement. For more details, see
//			 * http://dev.mysql.com/doc/refman/5.1/en/flush.html
//			 */
////			Connection conn = DriverManager.getConnection(getMachineName(),
////					"root", "4tune8ly");
////			conn.setAutoCommit(false);
////			Statement stmt = conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,
////					ResultSet.CONCUR_UPDATABLE);
////			String strFlush = "FLUSH TABLES";
////			stmt.execute(strFlush);
////			conn.commit();
////			stmt.close();
////			conn.close();
//			String strFlush = "FLUSH TABLES";
//			_statement.execute(strFlush);
//		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
//		}
//	}
//	
//	public static void close(){
//		try {
//			_statement.close();
//			_connection.close();
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		
//	}
//	
//	public static void executeStatement(){
//		String sql = "SELECT user, host, password, select_priv, insert_priv, shutdown_priv, grant_priv FROM mysql.user";
//		ResultSet rs = _statement.executeQuery(sql);
//		while(rs.next()){
//			
//		}
//	}
	
	  public static void testProcMonitor() {
			long start_time;
			long finish_time;
			long exec_time = 0;
			String proc_diff = "";

			// process monitor
			Process procMon = null;
			// overall stat
			StatInfo beforeStat = null, afterStat = null;
			
			int portNum = ((new Random()).nextInt(10000))+7000;
			// start process monitor
			procMon = runProcMonitor(portNum);
				
//			beforeStat = LinuxProcessAnalyzer.getStatInfo();
			// start time
										
			Socket localProcMonSock = new Socket("localhost", portNum);
			Socket hostProcMonSock = null;
				
			byte[] b = new byte[3];
			localProcMonSock.getInputStream().read(b);
				
			start_time = System.currentTimeMillis();
			
			//runAlgorithm();
			
			// finish time
			finish_time = System.currentTimeMillis();

			proc_diff = getProcDiff(localProcMonSock);
			
//			afterStat = LinuxProcessAnalyzer.getStatInfo();
			
			// get processes
			//HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
			// do map diff
//			proc_diff += LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
//													   beforeStat,
//												  	   afterStat);
			// get the time
			exec_time = finish_time - start_time;

			// kill process monitor
			if(procMon != null)
				killProcMonitor(procMon);
			
			System.out.println(proc_diff);
	  }
	  
	  /****
	   * Run proc monitor
	   * @return proc monitor process
	   * @throws ProcMonitorException 
	   */
	  protected Process runProcMonitor(int portNum) throws Exception {
		  try {
		      Runtime rt = Runtime.getRuntime();
		      final Process p0 = rt.exec("./"+Constants.PROC_MONITOR_NAME + " " + portNum);
		      Thread.sleep(3000);
		      return p0;
		    } catch (Exception ex) {
		      ex.printStackTrace();
		      throw new Exception(ex.getMessage());
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
	    	  System.err.println(line);
	      }
	      buf_err_reader.close();	      
	      Thread.sleep(3000);
	  }
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
//		connect();
		
		//for(int i=0;i<5;i++){
//			System.out.println("flush DBMS cache start");
//			flushDBMSCache();
//			System.out.println("flush DBMS cache end");
		//}
//		close();
		testProcMonitor();
	}

}
