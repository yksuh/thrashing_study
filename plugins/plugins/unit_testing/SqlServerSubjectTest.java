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
import java.sql.SQLException;
import java.sql.Statement;

import org.junit.Test;

import plugins.SqlServerSubject;
import azdblab.Constants;
import azdblab.executable.Main;

public class SqlServerSubjectTest {
	private static Connection _connection;
	private static Statement _statement;
	private static String user_name = "azdblab_user";
	private static String password = "azdblab_user";
	private static String connect_string = "jdbc:sqlserver://sodb6.cs.arizona.edu:1433";
	private static String machineName = "sodb6.cs.arizona.edu";
	private static String DBMS_DRIVER_CLASS_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	
	private static String lsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_lHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";  
	private static String rsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_rHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";	
	private static String sql = "SELECT t3.id2, t0.id4, t3.id1, SUM(t1.id2)  FROM ft_HT4 t1, ft_HT1 t0, ft_HT4 t2, ft_HT4 t3  WHERE  (t1.id4=t0.id4 AND t0.id4=t2.id1 AND t2.id1=t3.id3)  GROUP BY t3.id2, t0.id4, t3.id1";
	@Test
	public void testgetQueryPlanString() {
//		fail("Not yet implemented");
		try {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    _connection = DriverManager.getConnection(connect_string, user_name, password);
		     _connection.setAutoCommit(false);
	        _statement = _connection.createStatement();
//	        _statement = _connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
	        SqlServerSubject ora = new SqlServerSubject(user_name, password, connect_string, machineName);
	        ora.SetConnection(_connection);
	        ora.SetStatement(_statement);
			
	        _statement.setQueryTimeout(100);
	        
	        long card = 10000;
	        String oTable = "FT_HT1";
	        String oCloneMaxTableName  = "clone_max_" + oTable;
	        ora.updateTableCardinality(oTable,card, 20000);
	        ora.getQueryPlan(sql);
	        
	        ora.copyTable(oTable, oCloneMaxTableName, card);
	        ora.getQueryPlan(sql);
	        
//		    long card = 0;
////		    String oTable = "FT_HT1";
//		    String lTable = "FT_lHT1";
//		    String rTable = "FT_rHT1";
//			String lCloneMaxTableName  = "clone_max_" + lTable;
//			System.out.println("left max table ....");			
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
			
//			sss.flushOSCache();
//			sss.flushDBMSCache();
//			String oriTable = "FT_HT1";
//			String cloneMaxTableName  = "clone_max_" + oriTable;
			
//			String createTable = "CREATE TABLE " + oriTable + " (id1 INT, id2 INT, id3 INT, id4 INT)";
//			
//			// create original table
//			if(sss.tableExists(oriTable)){
//				Main._logger.outputLog("table exists!");
//				sss.dropTable(oriTable);
//				sss.commit();
//			}
//			Main._logger.outputLog("create: " + createTable);
//			_statement.executeUpdate(createTable);
//			sss.commit();
			
//			sss.flushDBMSCache();
			
//			long requested_cardinality = 1320000;
//			System.out.println("test at 132M..");
//			sss.copyTable(oriTable, cloneMaxTableName);
//			sss.commit();
//			sss.getQueryPlan(sql);
//			
//			requested_cardinality = 1310000;
//			System.out.println("test at 1.31M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//			
//			requested_cardinality = 1300000;
//			System.out.println("test at 1.30M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
			
//			 2M plan
//			 create clone table
//			long requested_cardinality = 2000000;
//			System.out.println("test at 2M..");
//			sss.copyTable(oriTable, cloneMaxTableName);
//			sss.commit();
//			
//			sss.getQueryPlan(sql);
//			
//			requested_cardinality = 1700000;
//			System.out.println("test at 1.70M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//			
//			requested_cardinality = 1600000;
//			System.out.println("test at 1.60M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//			
//			requested_cardinality = 1500000;
//			System.out.println("test at 1.5M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//			
//			requested_cardinality = 1040000;
//			// 1.04M plan
//			System.out.println("test at 1.04M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//
//			requested_cardinality = 990000;
//			// 1.04M plan
//			System.out.println("test at 0.99M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//
//			requested_cardinality = 960000;
//			// 1.04M plan
//			System.out.println("test at 0.96M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);
//
//			requested_cardinality = 950000;
//			// 1.04M plan
//			System.out.println("test at 0.95M..");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			sss.commit();
//			sss.getQueryPlan(sql);

			
			_statement.close();
			_connection.close();
			
//			int seed = 1999;
//			int columnnum = 4;
//			RepeatableRandom repRand = new RepeatableRandom(seed);
//			repRand.setMax(requested_cardinality);
//			String  strupdate  = "";
//			for (long i = 0; i < maximum_cardinality; i++){
//				if ((i + 1) % 10000 == 0){
//					Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//					sss.commit();
//				}
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
//			}
//			sss.commit();
			
//			// ssscle's cloning
//			Main._logger.outputLog("cloning starts ... ");
//			sss.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			Main._logger.outputLog("cloning is done ... ");
//			sss.commit();
//			
//			sss.printTableStat(oriTable);
//			
//			// clone statistics
//			// ssscle's cloning
//			// first, populate with 2M rows.
//			sss.copyTable(oriTable, cloneMaxTableName);
//			Main._logger.outputLog("1M rows' deletion starts");
//			// next, delete 1M rows.
//			sss.updateTableCardinality(oriTable, requested_cardinality, maximum_cardinality);
//			Main._logger.outputLog("1M rows' deletion is done");
//			sss.commit();
//			
//			// print stat
//			sss.printTableStat(oriTable);
			
			
//			_statement.executeUpdate(explain_plan);
//			
//			sss.getQueryPlan(sql);
//			sss.getQueryPlan(sql);
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

//	@Test
//	public void testCloneTableStringStringLong() {
//		fail("Not yet implemented");
//	}

	public void commit() {
	    try {
	      if (_connection != null && !_connection.isClosed())
	        _connection.commit();
	    } catch (SQLException e) {
	      System.err.println("Commit failed");
	      //e.printStackTrace();
	    }
	}
}
