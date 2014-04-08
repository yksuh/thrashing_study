package plugins.unit_testing;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import azdblab.Constants;
import azdblab.executable.Main;

public class XactProtoTypeTest {
	private static Connection _connection;
	private static Statement _statement;
	private static String _user_name = "azdblab_xact";
	private static String _password = "azdblab_xact";
	private final static String logDir = "log-files";
	
	private static String _conn_str = "jdbc:oracle:thin:@sodb8.cs.arizona.edu:1521:research";
	private static String DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
	private static String loggerType = "Transaction";
//	private static String lsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_lHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";  
//	private static String rsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_rHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";	
//	private static String sql = "SELECT t3.id2, t0.id4, t3.id1, SUM(t1.id2) FROM ft_HT4 t1, ft_HT1 t0, ft_HT4 t2, ft_HT4 t3 WHERE (t1.id4=t0.id4 AND t0.id4=t2.id1 AND t2.id1=t3.id3) GROUP BY t3.id2, t0.id4, t3.id1";

	/****
	 *  logger for logging
	 */
	public static AZDBLabLogger _logger;	// logger for each mode

	/*****
	 * Set up logger
	 * @param selMode
	 */
	public static void setAZDBLabLogger(String loggerTypeName) {
		_logger = new AZDBLabLogger(loggerTypeName);
		
		SimpleDateFormat logsdf = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
		String strLoggingTime = logsdf.format(new Date(System.currentTimeMillis()));
		String logFileName = logDir + File.separator + loggerTypeName + "_" + strLoggingTime + ".log";
		
		try {
			_logger.setAZDBLabAppender(logFileName);
		} catch (IOException e) {
			System.err.println("Appender cannot be created " +  e.getMessage());
			System.err.println("Please retry again.");
			System.exit(-1);
		}
		
		_logger.setAZDBLabLoggerName(logFileName);
	}

	
	/****
	 * Connect to DBMS!
	 */
	public static void connectToDBMS() {
		try {
			Class.forName(DBMS_DRIVER_CLASS_NAME);
			_logger.outputLog("connecting to labshelf");
			_connection = DriverManager.getConnection(_conn_str, _user_name, _password);
			_connection.setAutoCommit(false);
_logger.outputLog("connected.");
_logger.outputLog("creating statement ...");
			_statement = _connection.createStatement();
_logger.outputLog("statement created.");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/***
	 * Close a DBMS
	 */
	private static void closeDBMS() {
		try {
			if(_statement != null)
				_statement.close();
			if(_connection != null)
				_connection.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void commit() {
	    try {
	      if (_connection != null && !_connection.isClosed())
	        _connection.commit();
	    } catch (SQLException e) {
	      _logger.reportError("Commit failed");
	      //e.printStackTrace();
	    }
	}
	
	protected static ArrayList<Worker> createTerminals(){
		ArrayList<Worker> terminals = new ArrayList<Worker>();
		return terminals;
	}
	
	
	
	private static ArrayList<Thread> workerThreads;
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		/****
		 * Setup logger
		 */
		setAZDBLabLogger(loggerType);
		_logger.outputLog("<<< Experiment Starts! >>>");
		
		connectToDBMS();

		ArrayList<Worker> workers = createTerminals();
        workerThreads = new ArrayList<Thread>(workers.size());
		for (Worker worker : workers) {
			 Thread thread = new Thread(worker);
			 thread.start();
			 workerThreads.add(thread);
		}
		
		int success = 0;
		for (int i = 0; i < workerThreads.size(); ++i) {
			try {
				workerThreads.get(i).join(60000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			success += workers.get(i).getRequests();
			workers.get(i).tearDown();
		}
		
		closeDBMS();
		System.out.println("number of sucesses: " + success);
		_logger.outputLog("<<< Experiment Finished! >>>");
	}
}
