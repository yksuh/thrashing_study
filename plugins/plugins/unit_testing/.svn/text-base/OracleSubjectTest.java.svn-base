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

import plugins.OracleSubject;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;

public class OracleSubjectTest {
	private static Connection _connection;
	private static Statement _statement;
	private static String user_name = "azdblab_user";
	private static String password = "azdblab_user";
	private static String connect_string = "jdbc:oracle:thin:@sodb8.cs.arizona.edu:1521:research";
	private static String machineName = "sodb8.cs.arizona.edu";
	private static String DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
//	private static String lsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_lHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";  
//	private static String rsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_rHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";	
	private static String sql = "SELECT t3.id2, t0.id4, t3.id1, SUM(t1.id2) FROM ft_HT4 t1, ft_HT1 t0, ft_HT4 t2, ft_HT4 t3 WHERE (t1.id4=t0.id4 AND t0.id4=t2.id1 AND t2.id1=t3.id3) GROUP BY t3.id2, t0.id4, t3.id1";
	
	public void commit() {
	    try {
	      if (_connection != null && !_connection.isClosed())
	        _connection.commit();
	    } catch (SQLException e) {
	      Main._logger.reportError("Commit failed");
	      //e.printStackTrace();
	    }
	}
	
	@Test
	public void testGetQueryPlan() {
//		fail("Not yet implemented");
		try {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    _connection = DriverManager.getConnection(connect_string, user_name, password);
		    _connection.setAutoCommit(false);
		    _statement = _connection.createStatement();
		    OracleSubject ora = new OracleSubject(user_name, password, connect_string, machineName);
		    ora.SetConnection(_connection);
		    ora.SetStatement(_statement);
		    
		    int col_len = 4;
			Column[] columns = new Column[col_len];
			for (int j = 1; j <= col_len; j++) {
				columns[j - 1] = new Column("id" + j);
			}
//			Table fixedTable = new Table("HT3", prefix, 0, 0, 0, 0, columns);
//			ts.updateTableStatistics(fixedTable);

			String prefix = "ft_";
			String oTable = "HT1";
			String lTable = "lHT1";
			String rTable = "rHT1";
		    String cloneMaxTableName = "clone_max_" + oTable;
		   
		    
			Table leftTable, rightTable;
			leftTable = new Table(lTable, prefix, 0, 0, 0, 0, columns);
			rightTable = new Table(rTable, prefix, 0, 0, 0, 0, columns);
			
		     
		    long card = 2000000;
		    ora.copyTable(leftTable.table_name_with_prefix, cloneMaxTableName, card);
		    ora.updateTableStatistics(leftTable);
			ora.commit();
			ora.getQueryPlan(sql);
		    
//		    card = 760000;
//		    ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(sql);
		    
//			card = 2000000;
//			// create clone table
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//			card = 1990000;
//			ora.copyTable(rTable, rCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
//			
//			card = 1980000;
//			// create clone table
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//			card = 1970000;
//			ora.copyTable(rTable, rCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
			
//			String createTable = "CREATE TABLE " + oriTable + " (id1 NUMBER, id2 NUMBER, id3 NUMBER, id4 NUMBER)";
			
//			// create original table
//			if(ora.tableExists(oriTable)){
//				Main._logger.outputLog("table exists!");
//				ora.dropTable(oriTable);
//			}
//			Main._logger.outputLog("create: " + createTable);
//			_statement.executeUpdate(createTable);
//			
//			// create clone table
//			ora.copyTable(cloneMaxTableName, oriTable);
	        
			// populate clone table
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
//	        		Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
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
//			// oracle's cloning
//			Main._logger.outputLog("cloning starts ... ");
//			ora.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			Main._logger.outputLog("cloning is done ... ");
//			commit();
//			
//			ora.printTableStat(oriTable);
//			
//			// clone statistics
//			// oracle's cloning
//			// first, populate with 2M rows.
//			ora.copyTable(oriTable, cloneMaxTableName);
//			Main._logger.outputLog("1M rows' deletion starts");
//			// next, delete 1M rows.
//			ora.updateTableCardinality(oriTable, requested_cardinality, maximum_cardinality);
//			Main._logger.outputLog("1M rows' deletion is done");
//			commit();
			
//			// print stat
//			ora.printTableStat(oriTable);
//			
//			// print stat
//			ora.printTableStat(sh_oriTable);
		    
//		    _statement.executeUpdate(sql2);
//		    ora.initializeSubjectTables();
//		    ora.updateTableCardinality("FT_HT1", 1150000, 2000000);
//		    PlanNode y = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.15M: " + y.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 1000000, 2000000);
//		    PlanNode x = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1M: " + x.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 2000000, 2000000);
//		    PlanNode o = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 2M: " + o.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1200000, 2000000);
//		    PlanNode a = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.20M:  " + a.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 1150000, 2000000);
//		    PlanNode f = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.15M: " + f.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1140000, 2000000);
//		    PlanNode g = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.14M: " + g.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1100000, 2000000);
//		    PlanNode b = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.10M: " + b.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1010000, 2000000);
//		    PlanNode c = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.01M: " + c.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1005000, 2000000);
//		    PlanNode d = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.005M: " + d.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 1000000, 2000000);
//		    PlanNode z = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1M: " + z.myHashCode());
		} catch (SQLException sqlex) {
//			Main.defaultLogger.logging_normal("exception: " + sql2);
		    sqlex.printStackTrace();
		} catch (ClassNotFoundException e) {
		    e.printStackTrace();
		    System.exit(1); 
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}

}
