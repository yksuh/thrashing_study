package plugins.unit_testing;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import com.mysql.jdbc.ResultSet;

public class Worker implements Runnable {
	private static String DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
	private int id;
	protected Connection conn;
	protected Statement stmt;
	private static String _conn_str = "jdbc:oracle:thin:@sodb8.cs.arizona.edu:1521:research";
	private static String _user_name = "azdblab_xact";
	private static String _password = "azdblab_xact";
	
	private static int count = 10;
	public Worker(int id) {
		this.id = id;
	}
	
	public void initialize() {
		try {
			Class.forName(DBMS_DRIVER_CLASS_NAME);
			conn = DriverManager.getConnection(_conn_str, _user_name, _password);
			conn.setAutoCommit(false);
			stmt = conn.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void tearDown() {
		try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void doWork(){
		ResultSet rs;
		try {
			rs = (ResultSet) stmt.executeQuery("select count(*) from ft_ht1 where id1 < 10000");
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public int success = 0;
	
	public final void run() {
	    Thread t = Thread.currentThread();
	    try {
		    this.initialize();
		} catch (Throwable ex) {
		   
		}
		
	    long testDurationSecs = 180;
		long startTime = System.currentTimeMillis();
        long endTime = startTime + (1000l * testDurationSecs);
        long currentTime = startTime;
       
        while (endTime > currentTime)
        {
        	doWork();
    	    success++;        	
        	currentTime = System.currentTimeMillis();
        }
	    
		tearDown();
	}

	public int getRequests() {
		return success;
	}
}
