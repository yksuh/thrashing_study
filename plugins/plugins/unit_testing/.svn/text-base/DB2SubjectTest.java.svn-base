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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


import org.junit.Test;

import plugins.DB2Subject;

import azdblab.Constants;
import azdblab.executable.Main;

public class DB2SubjectTest {
	private static Connection _connection;
	private static Statement _statement;
	private static String user_name = "db2";
	private static String password = "gotneh2o";
	private static String connect_string = "jdbc:db2://sodb9.cs.arizona.edu:50001/research";
	private static String machineName = "sodb9.cs.arizona.edu";
//	private static String connect_string = "jdbc:db2://sodb2.cs.arizona.edu:50000/research";
	private static String DBMS_DRIVER_CLASS_NAME = "com.ibm.db2.jcc.DB2Driver";
		
	@Test	
	public void testgetQueryPlan(){
//		fail("Not yet implemented");
		try {
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    _connection = DriverManager.getConnection(connect_string, user_name, password);
		     _connection.setAutoCommit(false);
	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
	        DB2Subject ora = new DB2Subject(user_name, password, connect_string, machineName);
	        ora.SetStatement(_statement);
	        ora.SetConnection(_connection);
			
//	        ora.flushDBMSCache();
//	        long time1 = System.currentTimeMillis();
//	        _statement.execute(sql);
//	        long time2 = System.currentTimeMillis();
//	        long time = time2-time1;
//	        System.out.println("time1: " + time);
//	        
//	        ora.flushDBMSCache();
//	        time1 = System.currentTimeMillis();
//	        _statement.execute(sql);
//	        time2 = System.currentTimeMillis();
//	        time = time2-time1;
//	        System.out.println("time2: " + time);
//	        
//	        ora.flushDBMSCache();
//	        time1 = System.currentTimeMillis();
//	        _statement.execute(sql);
//	        time2 = System.currentTimeMillis();
//	        time = time2-time1;
//	        System.out.println("time3: " + time);
//	        
//	        ora.flushDBMSCache();
//	        time1 = System.currentTimeMillis();
//	        _statement.execute(sql);
//	        time2 = System.currentTimeMillis();
//	        time = time2-time1;
//	        System.out.println("time4: " + time);
	        
	        
	        
//		    long card = 0;
////		    String oTable = "FT_HT1";
//		    String lTable = "FT_lHT1";
//		    String rTable = "FT_rHT1";
//			String lCloneMaxTableName  = "clone_max_" + lTable;
//			String rCloneMaxTableName  = "clone_max_" + rTable;
//System.out.println("left max table ....");			
//			card = 2000000;
//System.out.println("Cardinality: " + card);			
//			// create clone table
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			card = 1990000;
//System.out.println("Cardinality: " + card);			
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//			card = 1980000;
//System.out.println("Cardinality: " + card);
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//			card = 1970000;
//System.out.println("Cardinality: " + card);
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//System.out.println("right max table ....");
//			card = 2000000;
//System.out.println("Cardinality: " + card);			
//			// create clone table
//			ora.copyTable(rTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
//			card = 1990000;
//System.out.println("Cardinality: " + card);			
//			ora.copyTable(rTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
//			
//			card = 1980000;
//System.out.println("Cardinality: " + card);
//			ora.copyTable(rTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
//			
//			card = 1970000;
//System.out.println("Cardinality: " + card);
//			ora.copyTable(rTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
			
//			String oriTable = "FT_HT1";
//			String cloneMaxTableName  = "clone_max_" + oriTable;
//		    
//			String createTable = "CREATE TABLE " + oriTable + " (id1 INT, id2 INT, id3 INT, id4 INT)";
//			
//			// create original table
//			if(db2.tableExists(oriTable)){
//				Main.defaultLogger.logging_info("table exists!");
//				db2.dropTable(oriTable);
//			}
//			Main.defaultLogger.logging_info("create: " + createTable);
//			_statement.executeUpdate(createTable);
//			
//			// create clone table
//			db2.copyTable(cloneMaxTableName, oriTable);
//	        
//			// populate clone table
//			long maximum_cardinality = 2000000;
//			long requested_cardinality = 1000000;
//			
//			int seed = 1999;
//			int columnnum = 4;
//			RepeatableRandom repRand = new RepeatableRandom(seed);
//			repRand.setMax(requested_cardinality);
//			String  strupdate  = "";
//	        for (long i = 0; i < maximum_cardinality; i++){
//	        	if ((i + 1) % 10000 == 0){
//	        		Main.defaultLogger.logging_info("\t Inserted " + (i + 1) + " Rows");
//	        		commit();
//	        	}
//				String  strdata  = "";
//				// Assume all data fields are of integer data type
//				for ( int j = 0; j < columnnum - 1; j++ ) {
//					if (j == columnnum - 2) {
//						strdata  += repRand.getNextRandomInt();
//					} else {
//						strdata  += repRand.getNextRandomInt() + ",";
//					}
//				}
//				strupdate = "INSERT INTO " + cloneMaxTableName + " VALUES(" + i + "," + strdata + ")";
//				_statement.executeUpdate(strupdate);
//	        }
//			commit();
//			
//			// db2cle's cloning
//			Main.defaultLogger.logging_info("cloning starts ... ");
//			db2.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			Main.defaultLogger.logging_info("cloning is done ... ");
//			commit();
//			
//			db2.printTableStat(oriTable);
//			
//			// clone statistics
//			// db2cle's cloning
//			// first, populate with 2M rows.
//			db2.copyTable(oriTable, cloneMaxTableName);
//			Main.defaultLogger.logging_info("1M rows' deletion starts");
//			// next, delete 1M rows.
////			long card = maximum_cardinality;
////			for (long i = 0; i <= 100; i++){
////				db2.updateTableCardinality(oriTable, card, maximum_cardinality);
////				card -= 10000;
////			}
//			db2.updateTableCardinality(oriTable, requested_cardinality, maximum_cardinality);
//			Main.defaultLogger.logging_info("1M rows' deletion is done");
//			commit();
//			
//			// print stat
//			db2.printTableStat(oriTable);
			
//			db2.flushDBMSCache();
			
//			db2.initializeSubjectTables();
//			db2.getQueryPlan(sql);
			
//			db2.getQueryPlan(sql);
//			db2.timeQuery(sql, plan, 1220000, 99999);
//			commit();
		} catch (SQLException sqlex) {
		    sqlex.printStackTrace();
		} catch (ClassNotFoundException e) {
		    e.printStackTrace();
		    System.exit(1); 
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}	

//	private static String cloneMaxTableName = "clone_max_ft_ht1";
//	@Test
//	public void testCloneTableStringString() {
////		fail("Not yet implemented");
//		try {
//		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//	        _connection.setAutoCommit(false);
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//			DB2Subject db2 = new DB2Subject(user_name, password, connect_string);
//			String  clearSQL  = "DELETE FROM " + tableName;
//			_statement.executeUpdate(clearSQL);
//			db2.SetStatement(_statement);
//			db2.copyTable(cloneMaxTableName, tableName);
//			Main.defaultLogger.logging_info("testing.... ");
//	        String  testSQL  = "select count(*) FROM " + cloneMaxTableName;
//			ResultSet rs = _statement.executeQuery(testSQL);
//			int res = 0;
//			while(rs.next()){
//				res = rs.getInt(1);
//			}			
//			assertEquals(0, res);
//			Main.defaultLogger.logging_info("testing.... done");
//			
//			RepeatableRandom repRand = new RepeatableRandom();
//			long maximum_cardinality  = 10000;
//			String  strupdate  = "";
//			int columnnum = 4; 
//			for (long i = 0; i < maximum_cardinality; i++){
//				if ((i + 1) % 10000 == 0){
//					Main.defaultLogger.logging_info("\t Inserted " + (i + 1) + " Rows");
//					commit();
//				}
//				String  strdata  = "";
//				// 	Assume all data fields are of integer data type
//				for ( int j = 0; j < columnnum - 1; j++ ) {
//					if (j == columnnum - 2) {
//						strdata  += repRand.getNextRandomInt();
//					} else {
//						strdata  += repRand.getNextRandomInt() + ",";
//					}
//				}
//				strupdate = "INSERT INTO " + cloneMaxTableName + " VALUES(" + i + "," + strdata + ")";
//			    _statement.executeUpdate(strupdate);
//			}
//			commit();
//			
//			Main.defaultLogger.logging_info("second testing... ");
//			res = 0;
//			testSQL  = "select count(*) FROM " + cloneMaxTableName;
//			rs = _statement.executeQuery(testSQL);
//			while(rs.next()){
//				res = rs.getInt(1);
//			}
//			assertEquals(maximum_cardinality, res);
//			Main.defaultLogger.logging_info("testing.... done");
//		} catch (SQLException sqlex) {
//		    sqlex.printStackTrace();
//		} catch (ClassNotFoundException e) {
//		    e.printStackTrace();
//		    System.exit(1); 
//		}		
//	}

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
//			DB2Subject db2 = new DB2Subject(user_name, password, connect_string);
//			long actual_cardinality = 5000;
//			db2.SetStatement(_statement);
//			db2.copyTable(tableName, cloneMaxTableName, actual_cardinality);
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
	@Test
	public void testdisableAutoStatUpdate(){
//		fail("Not yet implemented");
		try {
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    _connection = DriverManager.getConnection(connect_string, user_name, password);
		     _connection.setAutoCommit(false);
	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
	        DB2Subject db2 = new DB2Subject(user_name, password, connect_string, machineName);
			db2.SetStatement(_statement);
			db2.SetConnection(_connection);
			db2.disableAutoStatUpdate();
			commit();
		} catch (SQLException sqlex) {
		    sqlex.printStackTrace();
		} catch (ClassNotFoundException e) {
		    e.printStackTrace();
		    System.exit(1); 
		}	
	}
//	@Test
//	public void testcleanupDirtyPages(){
////		fail("Not yet implemented");
//		try {
//		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		     _connection.setAutoCommit(false);
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//	        DB2Subject db2 = new DB2Subject(user_name, password, connect_string);
//			db2.SetStatement(_statement);
//			db2.SetConnection(_connection);
//			db2.cleanupDirtyPages();
//			commit();
//		} catch (SQLException sqlex) {
//		    sqlex.printStackTrace();
//		} catch (ClassNotFoundException e) {
//		    e.printStackTrace();
//		    System.exit(1); 
//		}	
//	}
//	@Test
//	public void testflushMemory(){
////		fail("Not yet implemented");
//		try {
//		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		     _connection.setAutoCommit(false);
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//	        DB2Subject db2 = new DB2Subject(user_name, password, connect_string);
////			db2.flushMemory();
//		} catch (SQLException sqlex) {
//		    sqlex.printStackTrace();
//		} catch (ClassNotFoundException e) {
//		    e.printStackTrace();
//		    System.exit(1); 
//		}	
//	}
	
//	@Test
//	public void testupdateStat(){
////		fail("Not yet implemented");
//		try {
//		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		     _connection.setAutoCommit(false);
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//	        DB2Subject db2 = new DB2Subject(user_name, password, connect_string);
//			db2.SetStatement(_statement);
//			db2.SetConnection(_connection);
//			db2.updateStat();
//			commit();
//		} catch (SQLException sqlex) {
//		    sqlex.printStackTrace();
//		} catch (ClassNotFoundException e) {
//		    e.printStackTrace();
//		    System.exit(1); 
//		}	
//	}
	
//	@Test
//	public void testupdateTableStatisticsStringLongBoolean(){
////		fail("Not yet implemented");
//		try {
//		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		    //turn off auto-commit.  If this is turned on there will be a huge performance hit for inserting tuples 
//		//into the DBMS.
//	        _connection.setAutoCommit(false);
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
//	        DB2Subject db2 = new DB2Subject(user_name, password, connect_string);
//			long actual_cardinality = 700000;
////			
//			tableName = "FT_HT2";
//			db2.SetStatement(_statement);
//			db2.SetConnection(_connection);
//			String testSQL  
//			= "select card FROM sysstat.tables where tabname = '" + tableName.toUpperCase() + "'";
//			Main.defaultLogger.logging_info("sql: " + testSQL);
//			db2.updateTableStatistics(tableName, actual_cardinality, true);
//			commit();
//			int res = 0;
//			ResultSet rs;
//			rs = _statement.executeQuery(testSQL);
//			while(rs.next()){
//				res = rs.getInt(1);
//			}
//			Main.defaultLogger.logging_info(tableName + ", card: " + res);
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
