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
package plugins.unit_testing;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.junit.Test;

import plugins.MySQLSubject;
import plugins.TeradataSubject;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;

public class MySQLSubjectTest {
	private static Connection _connection;
	private static Statement _statement;
	private static PreparedStatement _pStmt;
	private static String user_name = "azdblab_user";
	private static String password = "azdblab_user";
	private static String connect_string = "jdbc:mysql://sodb11.cs.arizona.edu/AZDBLAB";
	private static String machineName = "sodb11.cs.arizona.edu";
	private static String DBMS_DRIVER_CLASS_NAME = "com.mysql.jdbc.Driver";
	private static String lsql = "SELECT t1.id4, SUM(t0.id3)  FROM ft_HT4 t2, ft_HT3 t1, ft_lHT1 t0  WHERE  (t2.id2=t1.id3 AND t1.id3=t0.id1)  GROUP BY t1.id4";  
//	private static String lsql = "SELECT t0.id2, SUM(t0.id1)  FROM ft_HT3 t1, ft_lHT1 t0  WHERE  (t1.id4=t0.id3)  GROUP BY t0.id2";
	private static String rsql = "SELECT t0.id2, SUM(t0.id1)  FROM ft_HT3 t1, ft_rHT1 t0  WHERE  (t1.id4=t0.id3)  GROUP BY t0.id2";	
	private static long card = 0; 
	
	private static String orgTable = "ft_HT1";
	private static String lTable = "ft_lHT1";
	private static String rTable = "ft_rHT1";
	private static String cloneMaxTableName = "clone_max_" + orgTable;
    private static MySQLSubject ts = null;
    
    /***
     * Connect to Teradata, instantiating Teradata subject
     */
	public void connect() {
		try {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    _connection = DriverManager.getConnection(connect_string, user_name, password);
		    _connection.setAutoCommit(false);
		    _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
		    ts = new MySQLSubject(user_name, password, connect_string, machineName);
		    System.out.println("Connected.");
		    ts.setConnection(_connection);
		    ts.SetStatement(_statement);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@Test
	public void flushDBMSCache() {
		connect();
		try {
			/**
			 * "FLUSH TABLES" command need to be executed by root. Thus, a
			 * separation connection for root is made to do that.
			 * 
			 * What "FLUSH TABLES" does is to close all open tables, force all
			 * tables in use to be closed, and flush the query cache. FLUSH
			 * TABLES also removes all query results from the query cache, like
			 * the RESET QUERY CACHE statement. For more details, see
			 * http://dev.mysql.com/doc/refman/5.1/en/flush.html
			 */
//			Connection conn = DriverManager.getConnection(getMachineName(),
//					"root", "4tune8ly");
//			conn.setAutoCommit(false);
//			Statement stmt = conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,
//					ResultSet.CONCUR_UPDATABLE);
//			String strFlush = "FLUSH TABLES";
//			stmt.execute(strFlush);
//			conn.commit();
//			stmt.close();
//			conn.close();
			String strFlush = "FLUSH TABLES";
			_statement.execute(strFlush);
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}
	//@Test
	public void testTimePreparedQuery() {
		connect();
		
		int col_len = 4;
		Column[] columns = new Column[col_len];
		for (int j = 1; j <= col_len; j++) {
			columns[j - 1] = new Column("id" + j);
		}
//		Table fixedTable = new Table("HT3", prefix, 0, 0, 0, 0, columns);
//		ts.updateTableStatistics(fixedTable);

		String prefix = "ft_";
		lTable = "lHT1";
		Table leftTable;
		leftTable = new Table(lTable, prefix, 0, 0, 0, 0, columns);
		
		card = 20000;
	    try {
			ts.copyTable(leftTable.table_name_with_prefix, cloneMaxTableName, card);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
	    System.out.println("Copied");
//		ts.updateTableStatistics(lTable);
		System.out.println("stat updated.");
	    ts.commit();
	    try {
			_pStmt = _connection.prepareStatement(lsql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    try {
	    	for(int i=0;i<10;i++){
	    		ts.getQueryPlan(lsql);
	    	}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	   
	    /*
	    int timeOut = 1;
	    try {
	    	_pStmt.setQueryTimeout(timeOut);
	    	System.out.println("timeout: " + _pStmt.getQueryTimeout());
			System.out.println("executing ... at " + card);
			_pStmt.executeQuery();
			System.out.println("done");
		} catch (SQLException e) {
			try {
				if(_connection.isClosed()){
					System.out.println("connection closed.");
				}
				if(_statement == null){
					System.out.println("statement closed.");
				}
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	    
	    card = 8500;
	    ts.copyTable(rTable, cloneMaxTableName, card);
//	    ts.updateTableStatistics(rTable);
	    ts.commit();
	    try {
			_pStmt = _connection.prepareStatement(rsql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    try {
	    	_pStmt.setQueryTimeout(timeOut);
	    	System.out.println("timeout: " + _pStmt.getQueryTimeout());
			System.out.println("executing ... at " + card);
			_pStmt.executeQuery();
			System.out.println("done");
		} catch (SQLException e) {
			try {
				if(_connection == null && _connection.isClosed()){
					System.out.println("connection closed.");
				}
				if(_statement == null){
					System.out.println("statement closed.");
				}
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	    */
	    
	    try {
			_pStmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    ts.close();
	}
	
	

//	@Test
//	public void testCloneTableStringStringLong() {
////		fail("Not yet implemented");
//		try {
//		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		    //turn off auto-commit.  If this is turned on there will be a huge performance hit for inserting tuples 
//		//into the DBMS.
//	        _connection.setAutoCommit(false);
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//	        MySQLSubject mysql = new MySQLSubject(user_name, password, connect_string);
//			long actual_cardinality = 5000;
//			mysql.SetStatement(_statement);
//			mysql.copyTable(tableName, cloneMaxTableName, actual_cardinality);
//			commit();
//			int res = 0;
//			String testSQL  = "select count(*) FROM " + tableName;
//			ResultSet rs;
//			rs = _statement.executeQuery(testSQL);
//			while(rs.next()){
//				res = rs.getInt(1);
//			}
//			assertEquals(actual_cardinality, res);
//		} catch (SQLException sqlex) {
//		    sqlex.printStackTrace();
//		} catch (ClassNotFoundException e) {
//		    e.printStackTrace();
//		    System.exit(1); 
//		}	
//	}

	public void commit() {
	    try {
	      if (_connection != null && !_connection.isClosed())
	        _connection.commit();
	    } catch (SQLException e) {
	      Main._logger.reportError("Commit failed");
	      //e.printStackTrace();
	    }
	}

}
