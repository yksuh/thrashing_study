package azdblab.executable;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import azdblab.Constants;

public class LabShelfServerMonitor {
	private static Connection _connection;
	private static Statement _statement;
	private static String user_name = "azdblab_6_1";
	private static String password = "azdblab_6_1";
	private static String connect_string = "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook";
	private static String DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";

//	private static String expsub_user_name = "azdblab_user";
//	private static String expsub_password = "azdblab_user";
//	private static String expsub_connect_string = "jdbc:postgresql://sodb11.cs.arizona.edu:5432/research";
//	private static String EXPSUB_DRIVER_CLASS_NAME = "org.postgresql.Driver";	
//	private static Connection expsub_connection;
//	private static Statement expsub_statement;
	
//	public void commit() {
//	    try {
//	      if (expsub_connection != null && !expsub_connection.isClosed())
//	    	  expsub_statement.commit();
//	    } catch (SQLException e) {
//	    	e.printStackTrace();
//	    }
//	}

	public static void connectToLabshelf(){
		try {
			Class.forName(DBMS_DRIVER_CLASS_NAME);
			_connection = DriverManager.getConnection(connect_string, user_name, password);
			_connection.setAutoCommit(false);
			_statement = _connection.createStatement();	
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void closeLabshelf(){
		try {
			_statement.close();
			_connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
//	public void connectToExpSubject(){
//		Class.forName(EXPSUB_DRIVER_CLASS_NAME);
//		expsub_connection = DriverManager.getConnection(expsub_connect_string, expsub_user_name, expsub_password);
//		expsub_connection.setAutoCommit(false);
//		expsub_statement = conn.createStatement();	
//	}
//	
//	public void closeExpSubject(){
//		expsub_statement.close();
//		expsub_connection.close();
//	}
	
	public static void executeStatement(int trial) throws Exception{
		String sql = "select count(*) from azdblab_completedtask";
		ResultSet rs = _statement.executeQuery(sql);
		int count = 0;
		while(rs.next()){
			count = rs.getInt(1);
		}
		System.out.println(trial + " trial => count: " + count);
		rs.close();
	}
	
	public static void monitor() throws Exception{
		int trials = 5;
		int mainStageCnt = 1, mainWaitTime = Constants.WAIT_TIME; 
		
		int i = 1;
		do{
			try{
				// execute a sql statement.
				executeStatement(i);
				// intentionally close a labshelf. 
				closeLabshelf();
				System.out.println(">> Wait for 3 seconds.");
				// wait for some time.
				Thread.sleep(3000);
				System.out.println("<< Done. ");
			}catch(Exception ex){
				System.err.println(ex.getMessage());
				System.out.println("Exponential backoff for main stage is performed for : " + mainWaitTime + " (ms)");
				// do exponential backoff
				Thread.sleep(mainWaitTime);
				mainStageCnt++;
				if(mainStageCnt > trials) 
					throw new Exception("LabShelfServer does not respond.");
				mainWaitTime *= 2;
				// reconnect labshelf for the next iteration
				connectToLabshelf();
				continue;
			}
			i++;
		}while(true);
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		connectToLabshelf();
//			connectToExpSubject();
		try{
			monitor();
		}catch(Exception ex){
			// call watcher!
			System.err.println("Watcher should be invoked.");
			System.err.println(ex.getMessage());
		}
//			closeExpSubject();
		closeLabshelf();
	}
}