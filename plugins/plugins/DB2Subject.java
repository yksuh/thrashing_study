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
package plugins;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.CallableStatement;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TableNode;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;
import azdblab.plugins.experimentSubject.ExperimentSubject;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.Vector;

/**
 * This is an implementation of the DBMSIndependentAPI for DB2. It provides all
 * services specified by the DBMSInterfaceAPI and provides a good model for
 * extending OSAT to run with other DBMS systems.
 * 
 * @author Youngkyoon Suh
 * 
 */
public class DB2Subject extends ExperimentSubject {
	/**
	 * This class is a structure that contains information about column
	 * statistics. Currently this is not used. The information here is specific
	 * to the DB2.
	 * 
	 * @author Youngkyoon Suh
	 * 
	 */
	private String QUERY_PLAN_TABLE = strUserName + ".PLAN_TABLE";

	private final String DB2Version = "V10.1";
	
	public void SetStatement(Statement stmt) {
		_statement = stmt;
	}

	public void SetConnection(Connection connection) {
		_connection = connection;
	}

	/**
	 * Initializes tables into which execution-plan data are placed.
	 * 
	 * @see azdblab.dbms.api.GeneralDBMS#getQueryPlan(java.lang.String)
	 */
	@Override
	public void initializeSubjectTables() {
		Main._logger.outputLog("Install subject (plan) tables ...");
		// TODO Auto-generated method stub
		// delete all rows in EXPLAIN_INSTANCE table
		String explain_inst_tbl = "EXPLAIN_INSTANCE";
		String empty_table = "DELETE FROM " + strUserName + "."
				+ explain_inst_tbl;
		try { // remove old query plan
			_statement.executeUpdate(empty_table);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		if (tableExists(QUERY_PLAN_TABLE)) {
			dropTable(QUERY_PLAN_TABLE);
		}
		try { // create a new plan table
			Main._logger.outputLog(CREATE_PLAN_TABLE);
			_statement.executeUpdate(CREATE_PLAN_TABLE);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		Main._logger.outputLog("... done!! ");
	}

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
//		        String strUpdate = "INSERT INTO " + tableName + "(";
//       		Column[] column2 = table.getColumns();
//		        // Assume all data fields are of integer data type
//		        for ( int j = 0; j < columnnum; j++ ) {
//		        	strUpdate += column2[j].myName;
//		        	if(j < columnnum -1){
//		        		strUpdate += ",";  
//		        	}
//		        }
//		        strUpdate += ")";  
//		        strUpdate += " VALUES (";
//		        for ( int j = 0; j < columnnum; j++ ) {
//		        	strUpdate += "?";
//		        	if(j < columnnum -1){
//		        		strUpdate += ",";  
//		        	}
//		        }
//		        strUpdate += ")";
//		        PreparedStatement pstmt = _connection.prepareStatement(strUpdate);
//		        Main._logger.outputLog(strUpdate);
		        final int BATCHSZ = 30000;
		        for ( long i = 0; i < actual_cardinality; i++ ){
		          if ((i + 1) == actual_cardinality){
		            Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//		            commit();
		          }
//		          int pos = 1;
//		          pstmt.setLong(pos, i);
//		          System.out.println(String.format("<%d, %d>", pos++, i));
		          String  strdata  = "";
		          Column[] column = table.getColumns();
		          // Assume all data fields are of integer data type
		          for ( int j = 1; j < columnnum; j++ ) {
//		        	  if(column[j].myName.contains("val")){
//		        		  strdata += "'Dallas, long scarred by the guilt and shame of being the place Pres. JFK was assassinated.'";
//		        	  }else{
//		        		  strdata += repRand.getNextRandomInt();
//		        	  }
//		        	  if(j < columnnum -1){
//		        		  strdata += ",";  
//		        	  }
		        	  if(column[j].myName.contains("val")){
		        		  String str = "'Dallas, long scarred by the guilt and shame of being the place Pres. JFK was assassinated.'";
		        		  strdata += str;
//		        		  pstmt.setString(pos, str);
//		        		  System.out.println(String.format("<%d, %s>", pos++, str));
		        	  }else{
		        		  long val = repRand.getNextRandomInt();
		        		  strdata += val;
//		        		  pstmt.setLong(pos, val);
//		        		  System.out.println(String.format("<%d, %d>", pos++, val));
		        	  }
		        	  if(j < columnnum -1){
		        		  strdata += ",";  
		        	  }
		          }
		          strupdate = "INSERT INTO " + tableName + " VALUES(" + i + "," +
		                      strdata + ")";
//		          System.out.println(strupdate);
////		          _statement.executeUpdate(strupdate);
		          _statement.addBatch(strupdate);
//		          if((i + 1) % 30000 == 0){
//		        	  _statement.executeBatch();
//		        	  commit();
//		          }
//		          pstmt.execute();
		          //pstmt.addBatch();
		          if((i + 1) % BATCHSZ == 0){
		        	  _statement.executeBatch();
		        	  //pstmt.executeBatch();
		        	  Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
		        	  commit();
		          }
		        }
		      _statement.executeBatch();
//			  pstmt.execute();
		      //pstmt.executeBatch();
		      commit();
		    } catch (SQLException sqlex){
		      sqlex.printStackTrace();
		      throw new Exception("Table population terminated with an exception");
		    }
		  }
	 
	@Override
	public void disableAutoStatUpdate() {
		// TODO Auto-generated method stub
		// Prepare the CALL statement for SYSPROC.ADMIN_CMD.
		String sql = "CALL SYSPROC.ADMIN_CMD(?)";
		String strStatUpdateSQL = "UPDATE DB CONFIG USING AUTO_MAINT OFF AUTO_TBL_MAINT OFF AUTO_RUNSTATS OFF";
		try {
			CallableStatement callStmt = _connection.prepareCall(sql);
			callStmt.setString(1, strStatUpdateSQL);
			callStmt.execute();
			callStmt.close();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	@Override
	public void enableAutoStatUpdate() {
		// TODO Auto-generated method stub
		// Prepare the CALL statement for SYSPROC.ADMIN_CMD.
		String sql = "CALL SYSPROC.ADMIN_CMD(?)";
		String strStatUpdateSQL = "UPDATE DB CFG FOR research USING AUTO_RUNSTATS ON";
		try {
			CallableStatement callStmt = _connection.prepareCall(sql);
			callStmt.setString(1, strStatUpdateSQL);
			callStmt.execute();
			callStmt.close();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	/**
	 * The constructor sets up the data base connection by creating a
	 * JDBCWrapper. This object will use only the JDBCWrapper to communicate
	 * with the DBMS.
	 * 
	 * @param user_name
	 *            The user name for the DB2 account that stores the tables of
	 *            OSAT.
	 * @param password
	 *            The password to authenticate with the DBMS.
	 * @param connect_string
	 *            The connect string specifies the drivers, port, ip, and other
	 *            critical information to connect using JDBC.
	 */
	public DB2Subject(String user_name, String password, String connect_string, String machineName) {

		super(user_name, password, connect_string, machineName);

	}

	/**
	 * whole copy
	 */
	public void copyTable(String newTable, String oriTable) throws Exception{
		try {
			if (tableExists(newTable)) {
				_statement.executeUpdate("DROP TABLE " + newTable);
				// yksuh added commit as below
				commit();
			}

			String cloneSQL = "CREATE TABLE " + newTable
					+ " AS (SELECT * FROM " + oriTable + ") DEFINITION ONLY";
			// String cloneSQL = "CREATE TABLE " + newTable + " LIKE " +
			// oriTable;
			// Main.defaultLogger.logging_normal("newTable: " + newTable +
			// ", oriTable: " + oriTable);
			Main._logger.outputLog("cloneSQL: " + cloneSQL);
			_statement.executeUpdate(cloneSQL);
			String populateTable = "INSERT INTO " + newTable
					+ " SELECT * FROM " + oriTable;
			// Main._logger.outputLog("cloning variable table: " +
			// populateTable);
			_statement.executeUpdate(populateTable);
			Main._logger.outputLog("Clone table finished!");
			commit();
		} catch (SQLException sqlex) {
//			close();
//			sqlex.printStackTrace();
//			System.exit(-1);
			close();
			throw new Exception(sqlex.getMessage());
		}

	}

	/**
	 * partial copy
	 */
	public void copyTable(String newTable, String oriTable, long cardinality) throws Exception{
		try {
			if (tableExists(newTable)) {
				_statement.executeUpdate("DROP TABLE " + newTable);
				commit();
			}

			String cloneSQL = "CREATE TABLE " + newTable
					+ " AS (SELECT * FROM " + oriTable + ") DEFINITION ONLY";
			_statement.executeUpdate(cloneSQL);
			String populateTable = "INSERT INTO " + newTable
					+ " SELECT * FROM " + oriTable + " WHERE id1 < "
					+ cardinality;
			 Main._logger.outputLog("populateTable: " +
			 populateTable);
			_statement.executeUpdate(populateTable);
			// Main._logger.outputLog("Clone table finished!");
			commit();
		} catch (SQLException sqlex) {
//			close();
//			sqlex.printStackTrace();
			close();
			throw new Exception(sqlex.getMessage());
		}
	}

	/**
	 * Collects column stats for the specified column.
	 * 
	 * @param tableName
	 *            The name of the table which will be used to gather statistics.
	 * @return A vector of ColumnStatistic objects. One for each column of the
	 *         table.
	 */
	// private Vector getColumnStatistics(String tableName) {
	// Vector result = new Vector();
	//
	// // SYSIBM.SYSCOLUMNS is a DB2 table which contains stats for columns.
	// String col_stats =
	// "SELECT AVGDISTINCTPERPAGE, AVGCOLLEN, NAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME = '"
	// + tableName.toUpperCase() + "'";
	// try {
	// ResultSet css = _statement.executeQuery(col_stats);
	//
	// // extracting column stats
	// while (css.next()) {
	// // ColumnStatistic current = new ColumnStatistic();
	// // current.distinct_count = css.getLong(1);
	// // current.average_column_length = css.getInt(2);
	// // current.columnName = css.getString(3);
	// // result.add(current);
	// }
	// css.getStatement().close();
	// } catch (SQLException e) {
	// System.err.println("No statistics for column: " + tableName);
	// e.printStackTrace();
	// System.exit(1);
	// }
	//
	// return result;
	// }

	/**
	   * This method populates table with random records with amount equals to cardinality.
	   * @param tableName This table will be populated.
	   * @param actual_cardinality The new number of records to be filled in.
	   * @param repRand The <code>RepeatableRandom</code> instance used to generate random values for table
	   * @param isVariableTable Whether or not is the table to be populated a variable table. 
	   *   It only matters when clone table mechanism has to be implemented. This implementation assumes the cloning mechanism is activated. 
	   *   (OracleSubject has to override this to ignore this flag) 
	   */
	  public void populateTable2(
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
	          strupdate = "INSERT INTO " + cloneMaxTableName + " VALUES(" +
	                      i + "," + strdata + ")";
	          _statement.executeUpdate(strupdate);
	        }
	        commit();
//	        Below is the old code that's not consistent with stepC.
//	        copyTable(tableName, cloneMaxTableName, actual_cardinality);
//	        commit();
	      }
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
//	            commit();
	            if ((i + 1) % 30000 == 0){
		            _statement.executeBatch();
		  	      	commit();
	            }
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
//	            commit();
	            if ((i + 1) % 30000 == 0){
	            	_statement.executeBatch();
		  	      	commit();
	            }
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
	 * Given OSAT's integer representation of a data type, this produces a DB2
	 * specific representation of the data type.
	 * 
	 * @param dataType
	 *            The data type
	 * @param length
	 *            The number of digits for this value.
	 * @return A string representation of this data type/length. This value can
	 *         be used in a create table statement.
	 */
	protected String getDataTypeAsString(int dataType, int length) {
		switch (dataType) {
		case GeneralDBMS.I_DATA_TYPE_NUMBER: {
			return NUMBER;
		}
		case GeneralDBMS.I_DATA_TYPE_VARCHAR: {
			return VARCHAR + "(" + length + ")";
		}
		case GeneralDBMS.I_DATA_TYPE_CLOB: {
			return BLOB;
		}
		default: {
			Main._logger.reportError("Unknown data type");
			System.exit(1);
			return null;
		}
		}
	}

	/**
	 * Sets the table statistics, currently only the cardinality.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#setTableStats(java.lang.String, long)
	 */
	public void setVirtualTableCardinality(String tableName, long cardinality,
			RepeatableRandom repRand) {
		// TableStatistic table;

		// if (cardinality > CurrentCardinality){
		// System.err.println("Create an cardinality exception here: setTableStats@SQLServerAPI"+cardinality+","+
		// CurrentCardinality);
		// return;
		// }

		// ID is 0 based
		String sqldelete = "DELETE FROM " + tableName + " WHERE id1 >= "
				+ cardinality + ";";

		try {
			// for ( long i = this.iRecordNum; i > cardinality; i-- ){
			_statement.executeUpdate(sqldelete);

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	// /**
	// * Sets the table statistics, currently only the cardinality.
	// *
	// * @see azdblab.dbms.api.GeneralDBMS#setTableStats(java.lang.String, long)
	// */
	// public void setVirtualTableCardinality(String tableName, long
	// cardinality,
	// RepeatableRandom repRand) {
	//
	// TableStatistic table;
	//
	// String sqldelete = "DELETE FROM " + tableName + " WHERE id1 >= "
	// + cardinality + ";";
	//
	// try {
	//
	// _statement.executeUpdate(sqldelete);
	//
	// CurrentCardinality = cardinality;
	//
	// } catch (SQLException sqlex) {
	// sqlex.printStackTrace();
	// }
	// }

	// private ResultSet aremoreResults(String sql) throws SQLException {
	//
	// Statement s = _connection.createStatement();
	// s.executeQuery(sql);
	//
	// boolean bmore = s.getMoreResults();
	//
	// if (bmore) {
	// return s.getResultSet();
	// }
	//
	// return null;
	// }

	// EXPLAIN_INSTANCE /* top element table, one row per execution plan */
	// EXPLAIN_STREAM
	// EXPLAIN_OBJECT
	// EXPLAIN_ARGUMENT
	// EXPLAIN_STATEMENT
	// EXPLAIN_PREDICATE
	// EXPLAIN_OPERATOR
	// public void printResultSet(ResultSet rs){
	// if (rs != null) {
	// try {
	// while(rs.next()){
	// Main._logger.outputLog(rs.getInt(1) + " | " +
	// rs.getInt(2) + " | " +
	// rs.getInt(3) + " | " +
	// rs.getString(4) + " | " +
	// rs.getString(5) + " | " +
	// rs.getString(6) + " | " +
	// rs.getDouble(7) + " | " +
	// rs.getDouble(8) + " | " +
	// rs.getDouble(9) + " | " +
	// rs.getDouble(10) + " | " +
	// rs.getDouble(11) + " | " +
	// rs.getDouble(12) + " | " +
	// rs.getDouble(13) + " | " +
	// rs.getDouble(14) + " | " +
	// rs.getDouble(15) + " | " +
	// rs.getDouble(16) + " | " +
	// rs.getDouble(17) + " | " +
	// rs.getDouble(18) + " | " +
	// rs.getDouble(19) + " | "
	// );
	// }
	// } catch (SQLException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// }
	// }

	// public void getQueryPlanCost() throws Exception{
	// String result_sql =
	// "SELECT O.Operator_ID, S2.Target_ID, O.Operator_Type, S.Object_Name, ";
	// result_sql += "CAST(O.Total_Cost AS REAL) TOTAL_COST, ";
	// result_sql += "CAST(O.IO_COST AS REAL) IO_COST, ";
	// result_sql += "CAST(O.CPU_COST AS REAL) CPU_COST,";
	// result_sql += "CAST(O.FIRST_ROW_COST AS REAL) FIRST_ROW_COST, ";
	// result_sql += "CAST(O.RE_TOTAL_COST AS REAL) RE_TOTAL_COST, ";
	// result_sql += "CAST(O.RE_IO_COST AS REAL) RE_IO_COST, ";
	// result_sql += "CAST(O.RE_CPU_COST AS REAL) RE_CPU_COST, ";
	// result_sql += "CAST(O.COMM_COST AS REAL) COMM_COST, ";
	// result_sql += "CAST(O.FIRST_COMM_COST AS REAL) FIRST_COMM_COST, ";
	// result_sql += "CAST(O.BUFFERS AS REAL) BUFFERS, ";
	// result_sql += "CAST(O.REMOTE_TOTAL_COST AS REAL) REMOTE_TOTAL_COST, ";
	// result_sql += "CAST(O.REMOTE_COMM_COST AS REAL) REMOTE_COMM_COST ";
	// result_sql += "FROM " + strUserName + ".EXPLAIN_OPERATOR O";
	// result_sql += "     LEFT OUTER JOIN " + strUserName +
	// ".EXPLAIN_STREAM S2 ";
	// result_sql += "                     ON O.Operator_ID=S2.Source_ID ";
	// result_sql += "     LEFT OUTER JOIN " + strUserName +
	// ".EXPLAIN_STREAM S ";
	// result_sql += "                     ON O.Operator_ID = S.Target_ID ";
	// result_sql += "                    AND O.Explain_Time = S.Explain_Time ";
	// result_sql += "                    AND S.Object_Name IS NOT NULL ";
	// result_sql += "ORDER BY O.Explain_Time ASC, Operator_ID ASC ";
	//    
	// ResultSet rs;
	// String sql =
	// "SELECT SUM(t2.id3)  FROM ft_HT3 t1, ft_HT1 t0, ft_HT2 t2  WHERE  (t1.id3=t0.id2 AND t0.id2=t2.id2)";
	// String explain_plan = "EXPLAIN PLAN FOR " + sql;
	// try {
	// // execute explain statement
	// _statement.executeUpdate("DELETE FROM EXPLAIN_INSTANCE");
	// _statement.executeUpdate(explain_plan);
	// }catch (SQLException e1) {
	// e1.printStackTrace();
	// throw new Exception(explain_plan + "\n", e1);
	// }
	// try {
	// // get execution plan data on a given sql from DB2
	// rs = _statement.executeQuery(result_sql);
	// }catch (SQLException e1) {
	// e1.printStackTrace();
	// throw new Exception(result_sql + "\n", e1);
	// }
	//     
	// if (rs != null) {
	// while(rs.next()){
	// Main._logger.outputLog(rs.getInt(1) + " | " +
	// rs.getInt(2) + " | " +
	// rs.getString(3) + " | " +
	// rs.getString(4) + " | " +
	// rs.getDouble(5) + " | " +
	// rs.getDouble(6) + " | " +
	// rs.getDouble(7) + " | " +
	// rs.getDouble(8) + " | " +
	// rs.getDouble(9) + " | " +
	// rs.getDouble(10) + " | " +
	// rs.getDouble(11) + " | " +
	// rs.getDouble(12) + " | " +
	// rs.getDouble(13) + " | " +
	// rs.getDouble(14) + " | " +
	// rs.getDouble(15) + " | " +
	// rs.getDouble(16) + " | " +
	// rs.getDouble(17) + " | "
	// );
	// }
	// }
	// rs.close();
	// }

	/**
	 * Returns a query plan for this SQL query.
	 * 
	 * @see azdblab.dbms.api.GeneralDBMS#getQueryPlan(java.lang.String)
	 */
	public PlanNode getQueryPlan(String sql) throws Exception {
		sql = sql.trim();
		String explain_plan = "EXPLAIN PLAN FOR " + sql;
		Vector<String> insertSQL = new Vector<String>();
		String result_sql = "SELECT O.Operator_ID, S2.Target_ID, O.Operator_Type, S.Object_Name, ";
		result_sql += "CAST(O.Total_Cost AS REAL) TOTAL_COST, ";
		result_sql += "CAST(O.IO_COST AS REAL) IO_COST, ";
		result_sql += "CAST(O.CPU_COST AS REAL) CPU_COST,";
		result_sql += "CAST(O.FIRST_ROW_COST AS REAL) FIRST_ROW_COST, ";
		result_sql += "CAST(O.RE_TOTAL_COST AS REAL) RE_TOTAL_COST, ";
		result_sql += "CAST(O.RE_IO_COST AS REAL) RE_IO_COST, ";
		result_sql += "CAST(O.RE_CPU_COST AS REAL) RE_CPU_COST, ";
		result_sql += "CAST(O.COMM_COST AS REAL) COMM_COST, ";
		result_sql += "CAST(O.FIRST_COMM_COST AS REAL) FIRST_COMM_COST, ";
		result_sql += "CAST(O.BUFFERS AS REAL) BUFFERS, ";
		result_sql += "CAST(O.REMOTE_TOTAL_COST AS REAL) REMOTE_TOTAL_COST, ";
		result_sql += "CAST(O.REMOTE_COMM_COST AS REAL) REMOTE_COMM_COST, ";
		result_sql += "CAST(S2.STREAM_COUNT AS REAL) STREAM_COUNT ";
		result_sql += "FROM " + strUserName + ".EXPLAIN_OPERATOR O";
		result_sql += "     LEFT OUTER JOIN " + strUserName
				+ ".EXPLAIN_STREAM S2 ";
		result_sql += "                     ON O.Operator_ID=S2.Source_ID ";
		result_sql += "     LEFT OUTER JOIN " + strUserName
				+ ".EXPLAIN_STREAM S ";
		result_sql += "                     ON O.Operator_ID = S.Target_ID ";
		result_sql += "                    AND O.Explain_Time = S.Explain_Time ";
		result_sql += "                    AND S.Object_Name IS NOT NULL ";
		result_sql += "ORDER BY O.Explain_Time ASC, Operator_ID ASC ";

		ResultSet rs;
		try {
			// Main.defaultLogger.logging_normal("explain : " + result_sql);
			// execute explain statement
			_statement.executeUpdate(explain_plan);
		} catch (SQLException e1) {
			e1.printStackTrace();
			throw new Exception(explain_plan + "\n", e1);
		}
		try {
			// get execution plan data on a given sql from DB2
			rs = _statement.executeQuery(result_sql);
		} catch (SQLException e1) {
			e1.printStackTrace();
			throw new Exception(result_sql + "\n", e1);
		}

		int num_of_rows = 0;
		if (rs != null) {
			int id = 0, parid = -1, position = 0;
			String operation_name = null, object_type = null, object_name = null;
			while (rs.next()) {
				id = rs.getInt(1) - 1;
				parid = rs.getInt(2) - 1;
				String strValues = rs.getString(3); // get operator type
				String temp = strValues.toUpperCase();
				if (temp.contains("SCAN")) {
					object_name = rs.getString(4);
					if (object_name != null) {
						object_type = "TABLE";
						operation_name = strValues;
					} else {
						object_type = "OPERATOR";
						operation_name = strValues;
						object_name = null;
					}
				} else {
					// if(temp.contains("RETURN")) continue;
					object_type = "OPERATOR";
					operation_name = strValues;
					object_name = null;
				}
				double cpu_cost, io_cost, total_cost;
				double first_row_cost, re_total_cost, re_io_cost, re_cpu_cost, comm_cost, first_comm_cost;
				double buffer_cost, remote_total_cost, remote_comm_cost, result_card;
				total_cost = rs.getDouble(5);
				io_cost = rs.getDouble(6);
				cpu_cost = rs.getDouble(7);
				first_row_cost = rs.getDouble(8);
				re_total_cost = rs.getDouble(9);
				re_io_cost = rs.getDouble(10);
				re_cpu_cost = rs.getDouble(11);
				comm_cost = rs.getDouble(12);
				first_comm_cost = rs.getDouble(13);
				buffer_cost = rs.getDouble(14);
				remote_total_cost = rs.getDouble(15);
				remote_comm_cost = rs.getDouble(16);
				result_card = rs.getDouble(17);

				String insValues = id + "," + parid + "," + position + ","
						+ "'" + object_name + "'" + "," + // object_name, NULL
															// if object_type =
															// "operator"
						"'" + operation_name + "'" + "," + // operation_name
						"'" + object_type + "'" + "," + // object_type
						"" + total_cost + "" + "," + // total_cost
						"" + cpu_cost + "" + "," + // cpu_cost
						"" + io_cost + "" + "," + // io_cost
						"" + first_row_cost + "" + "," + // first_row_cost
						"" + re_total_cost + "" + "," + // re_total_cost
						"" + re_io_cost + "" + "," + // re_io_cost
						"" + re_cpu_cost + "" + "," + // re_cpu_cost
						"" + comm_cost + "" + "," + // comm_cost
						"" + first_comm_cost + "" + "," + // first_comm_cost
						"" + buffer_cost + "" + "," + // buffer_cost
						"" + remote_total_cost + "" + "," + // remote_total_cost
						"" + remote_comm_cost + "" + "," + // remote_comm_cost
						"" + result_card + ""; // cardinality
				String ins_sql = "INSERT INTO " + QUERY_PLAN_TABLE
						+ " VALUES (" + insValues + ")";
				insertSQL.add(ins_sql);
				// if (parid == -1){ parid = 0; }
				// else { if (id % 2 == 0) { parid += 2; } }
				// id++;
				position++;
			}
			num_of_rows = position;
		}
		rs.close();

		try {
			for (int i = 0; i < insertSQL.size(); i++) {
				String ins_sql = insertSQL.get(i);
				// Main.defaultLogger.logging_normal(ins_sql);
				_statement.executeUpdate(ins_sql);
			}
			// cardinality information update
			String selectSQL = "SELECT " + PLAN_TABLE_COLUMNS[18] + " FROM "
					+ QUERY_PLAN_TABLE + " WHERE " + PLAN_TABLE_COLUMNS[0]
					+ " = 1";
			String updateSQL = "UPDATE " + QUERY_PLAN_TABLE + " SET "
					+ PLAN_TABLE_COLUMNS[18] + " = (" + selectSQL + ")"
					+ " WHERE " + PLAN_TABLE_COLUMNS[0] + " = 0";
			// Main.defaultLogger.logging_normal(updateSQL);
			_statement.executeUpdate(updateSQL);

		} catch (SQLException e1) {
			e1.printStackTrace();
		}

		String select_plan = "SELECT ";
		for (int i = 0; i < PLAN_TABLE_COLUMNS.length; i++) {
			select_plan += PLAN_TABLE_COLUMNS[i];
			if (i == PLAN_TABLE_COLUMNS.length - 1)
				break;
			select_plan += ", ";
		}

		select_plan += " FROM " + QUERY_PLAN_TABLE + " ORDER BY ID";
		PlanNode result = null;
		try {
			ResultSet rs2 = _statement.executeQuery(select_plan); // building a
																	// db2 Plan
																	// Tree
			result = createPlanTree(rs2, num_of_rows);
			rs2.close();
		} catch (SQLException e) {
			throw new Exception(select_plan, e);
		}

		// System.out.println("plan_code: " + result.myHashCode());
		// try {
		// //Main.defaultLogger.logging_normal(select_plan);
		// ResultSet rs3 = _statement.executeQuery(select_plan); // building a
		// db2 Plan Tree
		// printResultSet(rs3);
		// rs3.close();
		// } catch(SQLException e) {
		// throw new Exception(select_plan, e);
		// }

		// drop plan table
		try {
			String drop_sql = "DELETE FROM " + strUserName
					+ ".EXPLAIN_INSTANCE";
			_statement.executeUpdate(drop_sql);
			drop_sql = "DELETE FROM " + QUERY_PLAN_TABLE;
			_statement.executeUpdate(drop_sql);
			commit();
		} catch (SQLException e1) {
			Main._logger
					.outputLog("Error: Failed to delete query execution plan");
			// e1.printStackTrace();
		}

		// PlanNode rootNode = result;
		// HashMap<String, Double> resMap = rootNode.getOpCostEstimates();
		// Set s = resMap.entrySet();
		// // Move next key and value of HashMap by iterator
		// Iterator it=s.iterator();
		// HashMap<String, Double> mapEntry = new HashMap<String, Double>();
		// while(it.hasNext())
		// {
		// // key=value separator this by Map.Entry to get key and value
		// Map.Entry m =(Map.Entry)it.next();
		// // getKey is used to get key of HashMap
		// String key = (String)m.getKey();
		// // getValue is used to get value of key in HashMap
		// Double value = (Double)m.getValue();
		//            
		// key = key.toUpperCase();
		// // DBMS-specific name of resultCardinality
		// if(key.contains("CARDINALITY") // oracle
		// || key.contains("RESULT_CARD") // db2
		// || key.contains("ESTIMATEROWS") // sqlserver
		// || key.contains("ROWS")) // postgres/mysql
		// {
		// Main.defaultLogger.logging_normal("====== < " +
		// ((OperatorNode)rootNode).getOperatorName() +">============");
		// Main.defaultLogger.logging_normal("(" + key + ", " + value + ")");
		// break;
		// }
		// }
		return result;
	}

	private PlanNode createPlanTree(ResultSet rs, int last_pos) {
		Vector<PlanNode> v_tree = new Vector<PlanNode>();

		int numOps = 0;
		try {
			ResultSetMetaData meta = rs.getMetaData();
			int number_columns = meta.getColumnCount();

			while (rs.next()) {
				numOps++;
				// Main.defaultLogger.logging_normal(" | " + rs.getInt(1) +
				// " | " + rs.getInt(2) + " | " + rs.getInt(3) + " | " +
				// rs.getString(4) + " | " + rs.getString(5) + " | " +
				// rs.getString(6) + " | " + rs.getInt(7));
				// Vector<HashMap<String, Double>> vecPlanOpCostEstimate = new
				// Vector<HashMap<String, Double>>();
				// HashMap<String, HashMap<String, Double>>
				// mapPlanOpCostEstimate = null;

				HashMap<String, Double> mapRunStat = new HashMap<String, Double>();
				String id = null, parent_id = null, node_order = null, operation_name = null, object_name = null, object_total_cost = null, object_io_cost = null, object_cpu_cost = null, object_first_row_cost = null, object_re_total_cost = null, object_re_io_cost = null, object_re_cpu_cost = null, object_comm_cost = null, object_first_comm_cost = null, object_buffer_cost = null, object_remote_total_cost = null, object_remote_comm_cost = null, object_card = null;

				String object_type = null;
				String[] columnNames = new String[number_columns];
				String[] columnValues = new String[number_columns];
				// HashMap<String, Double> mapRunStat = null; // collect runstat
				// info when object is an operator
				// for each column of this tuple
				for (int i = 0; i < number_columns; i++) {
					String tempValue = rs.getString(i + 1);
					if (tempValue != null)
						tempValue = tempValue.trim();
					// filling in the value and name of each column. This is
					// used by the Plan Node for
					// the other info field.
					columnNames[i] = meta.getColumnName(i + 1);
					columnValues[i] = tempValue;
					// Main.defaultLogger.logging_normal("columnName[" + i +
					// "]: " + meta.getColumnName(i + 1) + ", value: " +
					// tempValue);
					switch (i + 1) {
					case DB2Subject.ID_INDEX: {
						id = tempValue;
						break;
					}
					case DB2Subject.PARENT_ID_INDEX: {
						parent_id = tempValue;
						break;
					}
					case DB2Subject.NODE_ORDER_INDEX: {
						node_order = tempValue;
						break;
					}
					case DB2Subject.OPERATION_NAME_INDEX: {
						operation_name = tempValue;
						break;
					}
					case DB2Subject.OBJECT_NAME_INDEX: {
						object_name = tempValue;
						break;
					}
					case DB2Subject.OBJECT_TYPE_INDEX: {
						object_type = tempValue;
						break;
					}
					case DB2Subject.OBJECT_TOTAL_COST_INDEX: {
						object_total_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "TOTAL_COST", Double
								.parseDouble(object_total_cost));
						break;
					}
					case DB2Subject.OBJECT_IO_COST_INDEX: {
						object_io_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "IO_COST", Double
								.parseDouble(object_io_cost));
						break;
					}
					case DB2Subject.OBJECT_CPU_COST_INDEX: {
						object_cpu_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "CPU_COST", Double
								.parseDouble(object_cpu_cost));
						break;
					}
					case DB2Subject.OBJECT_FIRST_ROW_COST_INDEX: {
						object_first_row_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "FIRST_ROW_COST",
								Double.parseDouble(object_first_row_cost));
						break;
					}
					case DB2Subject.OBJECT_RE_TOTAL_COST_INDEX: {
						object_re_total_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "RE_TOTAL_COST",
								Double.parseDouble(object_re_total_cost));
						break;
					}
					case DB2Subject.OBJECT_RE_IO_COST_INDEX: {
						object_re_io_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "RE_IO_COST", Double
								.parseDouble(object_re_io_cost));
						break;
					}
					case DB2Subject.OBJECT_RE_CPU_COST_INDEX: {
						object_re_cpu_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "RE_CPU_COST",
								Double.parseDouble(object_re_cpu_cost));
						break;
					}
					case DB2Subject.OBJECT_COMM_COST_INDEX: {
						object_comm_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "COMM_COST", Double
								.parseDouble(object_comm_cost));
						break;
					}
					case DB2Subject.OBJECT_FIRST_COMM_COST_INDEX: {
						object_first_comm_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "FIRST_COMM_COST",
								Double.parseDouble(object_first_comm_cost));
						break;
					}
					case DB2Subject.OBJECT_BUFFER_COST_INDEX: {
						object_buffer_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "BUFFER_COST",
								Double.parseDouble(object_buffer_cost));
						break;
					}
					case DB2Subject.OBJECT_REMOTE_TOTAL_COST_INDEX: {
						object_remote_total_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "REMOTE_TOTAL_COST",
								Double.parseDouble(object_remote_total_cost));
						break;
					}
					case DB2Subject.OBJECT_REMOTE_COMM_COST_INDEX: {
						object_remote_comm_cost = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "REMOTE_COMM_COST",
								Double.parseDouble(object_remote_comm_cost));
						break;
					}
					case DB2Subject.OBJECT_STREAM_COST_INDEX: {
						object_card = tempValue;
						mapRunStat.put(COST_MODEL_PREFIX + "STREAM_COST",
								Double.parseDouble(object_card));
						break;
					}
					}
				}

				// create the plan node and add it to the plan tree
				PlanNode newnode = null;
				PlanNode newnode2 = null;

				if (object_type.equals("OPERATOR")) {
					// Main.defaultLogger.logging_normal("id: " + id +
					// "operation_name: " + operation_name);
					// A operatorNode
					newnode = new OperatorNode(id, parent_id, node_order,
							operation_name, columnNames, columnValues);
					newnode.setPropertyValue("OPERATION", operation_name);

					// set cost estimates
					newnode.setOpCostEstimates(mapRunStat);
				} else if (object_type.equals("TABLE")) {
					newnode = new OperatorNode(id, parent_id, node_order,
							operation_name, columnNames, columnValues);
					newnode.setPropertyValue("OPERATION", operation_name);
					// set cost estimates
					newnode.setOpCostEstimates(mapRunStat);

					last_pos++;
					String node_id = Integer.toString(last_pos);
					newnode2 = new TableNode(node_id, id, node_order,
							object_name, columnNames, columnValues);
				}

				if (newnode != null) {
					v_tree.add(newnode);
				}
				if (newnode2 != null) {
					v_tree.add(newnode2);
				}

			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		PlanNode root = null;
		PlanNode pn = buildTree(root, v_tree);
		return pn;

	}

	// /**
	// * Builds a plan tree by ordering the node correctly. Nodes are ordered by
	// * node id such that a pre-order traversal of the tree will yield the
	// nodes
	// * in ascending order.
	// *
	// * @param v_tree
	// */
	// private PlanNode buildTree(PlanNode node, Vector<PlanNode> v_tree) {
	// Main.defaultLogger.logging_normal("num of nodes: " + v_tree.size());
	// int num_nodes = v_tree.size();
	// if (node == null) {
	// for (int i = 0; i < num_nodes; i++) {
	// PlanNode current = (PlanNode) v_tree.get(i);
	// if (current.getParent() == null) {
	// node = (PlanNode) v_tree.remove(i);
	// break;
	// }
	// }
	// buildTree(node, v_tree);
	// } else {
	// Main._logger.outputLog("node-" + node.getNodeID());
	// Main.defaultLogger.logging_normal(" " +
	// node.getPropertyValue("OPERATION"));
	// int id = Integer.parseInt(String.valueOf(node.getNodeID()));
	// int child_count = 0;
	// for (int i = 0; i < num_nodes; i++) {
	// PlanNode current = (PlanNode) v_tree.get(i);
	// int pid = Integer.parseInt(String.valueOf(current.getParentID()));
	// if (pid == id) {
	// current = (PlanNode) v_tree.remove(i);
	// num_nodes--;
	// i--;
	// ((OperatorNode) node).setChild(child_count++, current);
	// if(current instanceof OperatorNode){
	// Main.defaultLogger.logging_normal("child: " + current.getNodeID() +
	// ", operation_name: " + current.getPropertyValue("OPERATION"));
	// }
	// else if(current instanceof TableNode){
	// Main.defaultLogger.logging_normal("child: " + current.getNodeID() +
	// ", object_name: " + current.getPropertyValue("OBJECT_NAME"));
	// }
	// }
	// }
	// if(node instanceof OperatorNode){ // nonterminal node
	// int chnum = ((OperatorNode) node).getChildNumber();
	// for (int j = 0; j < chnum; j++) {
	// PlanNode tmpnode = ((OperatorNode) node).getChild(j);
	// if(tmpnode instanceof OperatorNode){
	// Main.defaultLogger.logging_normal("tmpnode: " + tmpnode.getNodeID() +
	// "operation_name: " + tmpnode.getPropertyValue("OPERATION"));
	// }
	// else if(tmpnode instanceof TableNode){
	// Main.defaultLogger.logging_normal("tmpnode: " + tmpnode.getNodeID() +
	// "object_name: " + tmpnode.getPropertyValue("OBJECT_NAME"));
	// }
	// buildTree(tmpnode, v_tree);
	// }
	// }
	// else if(node instanceof TableNode){ // terminal node
	// return node;
	// }
	// }
	// return node;
	// }

	/**
	 * Builds a plan tree by ordering the node correctly. Nodes are ordered by
	 * node id such that a pre-order traversal of the tree will yield the nodes
	 * in ascending order.
	 * 
	 * @param v_tree
	 */

	protected PlanNode buildTree(PlanNode root, Vector<PlanNode> v_tree) {
		int num_nodes = v_tree.size();
		if (num_nodes == 0 || root instanceof TableNode) {
			return null;
		}
		if (root == null) { // it needs to get updated to its child's
			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = v_tree.get(i);
				if (current.getParent() == null) {
					root = v_tree.remove(i);
					break;
				}
			}
			buildTree(root, v_tree);
			return root;
		}

		else {
			int id = Integer.parseInt(String.valueOf(root.getNodeID()));
			int chcount = 0;

			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = v_tree.get(i);
				int pid = Integer.parseInt(String
						.valueOf(current.getParentID()));
				if (pid == id) {
					current = v_tree.remove(i);
					num_nodes--;
					i--;
					((OperatorNode) root).setChild(chcount++, current);
				}

			}
			int chnum = ((OperatorNode) root).getChildNumber();
			for (int j = 0; j < chnum; j++) {
				PlanNode tmpnode = ((OperatorNode) root).getChild(j);
				buildTree(tmpnode, v_tree);
			}
			return null;
		}
	}

	// /**
	// * Gets the table statistics from the DBMS.
	// *
	// * @param tableName
	// * The name of the table
	// * @return A TableStatistic Object that contains important information
	// about
	// * the table statistics.
	// */
	// private TableStatistic getTableStatistics(String tableName) {
	//
	// TableStatistic result = new TableStatistic();
	// ResultSet ts;
	// String table_stats = "";
	//
	// table_stats =
	// "SELECT NPAGES,AVGROWSIZE,CARD FROM SYSIBM.SYSTABLES WHERE NAME = '"
	// + tableName.toUpperCase() + "'";
	// try {
	// // retrieving the statistics from the DBMS.
	// ts = _statement.executeQuery(table_stats);
	//
	// if (ts.next()) {
	// result.numblocks = ts.getInt(1);
	// result.average_row_length = ts.getInt(2);
	// result.num_rows = ts.getLong(3);
	// result.tableName = tableName;
	// } else {
	// System.err.println("No statistics for table: " + tableName);
	// System.exit(1); // programmer/dbms error
	// }
	// ts.getStatement().close();
	// } catch (SQLException e) {
	// e.printStackTrace();
	// System.err.println("No statistics for table: " + tableName);
	// System.exit(1); // programmer/dbms error
	// }
	//
	// return result;
	// }

	public void installExperimentTables(DataDefinition myDataDef,
			String myPrefix) {
		if (Main.verbose)
			Main._logger.outputLog("Installing Tables");
		String[] myTables = myDataDef.getTables();
		if (!isInstalled(myPrefix, myTables)) {
			// initializeSubjectTables();
			for (int i = 0; i < myTables.length; i++) {
				String[] primary = null;
				String[] unique = null;
				String[] index = null;
				ForeignKey[] foreign = null;
				// appending the column information to the CREATE TABLE
				// statement.
				String[] columns = myDataDef.getTableColumns(myTables[i]);
				int[] columnDataTypes = new int[columns.length];
				int[] columnDataTypeLengths = new int[columns.length];
				int[] columnDataTypeDecimalPoints = new int[columns.length];
				for (int j = 0; j < columns.length; j++) {
					columnDataTypes[j] = myDataDef.getColumnDataType(
							myTables[i], columns[j]);
					columnDataTypeLengths[j] = myDataDef.getColumnDataLength(
							myTables[i], columns[j]);
					columnDataTypeDecimalPoints[j] = myDataDef.getColumnDecimalPoint(
							myTables[i], columns[j]);
				}

				// returning the pimary key and foreign key info
				primary = myDataDef.getTablePrimaryKey(myTables[i]);
				foreign = myDataDef.getTableForeignKeys(myTables[i]);
//				createTable(myPrefix + myTables[i], columns, columnDataTypes,
//						columnDataTypeLengths, primary, foreign);
//	System.out.println("column data type lengths: " + columnDataTypeLengths[i]);
				createTable(myPrefix + myTables[i], columns, columnDataTypes,
						columnDataTypeLengths, columnDataTypeDecimalPoints, primary, foreign, unique, index);
				commit();
			}
		}
		commit();
	}

	// public void installExperimentTables(DataDefinition myDataDef, String
	// myPrefix) {
	//
	// if (Main.verbose)
	// Main.defaultLogger.logging_normal("Installing Tables");
	//
	// String[] myTables = myDataDef.getTables();
	//
	// if (!isInstalled(myPrefix, myTables)) {
	// //createDB2Tables();
	// for (int i = 0; i < myTables.length; i++) {
	//
	// String SQL = "CREATE TABLE " + myPrefix + myTables[i] + "(";
	//        
	// String[] primary = null;
	// ForeignKey[] foreign = null;
	//        
	// //appending the column information to the CREATE TABLE statement.
	// String[] columns = myDataDef.getTableColumns(myTables[i]);
	// int[] columnDataTypes = new int[columns.length];
	// int[] columnDataTypeLengths = new int[columns.length];
	// for (int j = 0; j < columns.length; j++) {
	// columnDataTypes[j] = myDataDef.getColumnDataType(myTables[i],
	// columns[j]);
	// columnDataTypeLengths[j] = myDataDef.getColumnDataLength(myTables[i],
	// columns[j]);
	// }
	//
	// primary = myDataDef.getTablePrimaryKey(myTables[i]);
	// foreign = myDataDef.getTableForeignKeys(myTables[i]);
	//
	// createTable(
	// myPrefix + myTables[i],
	// columns,
	// columnDataTypes,
	// columnDataTypeLengths,
	// primary,
	// foreign );
	// //commit();
	// }
	//
	// }
	//
	// // commit();
	// }
	
	public boolean tableExists(String tableName){
		try {
			// attempts to create the table. If it fails, the table exists and
			// an exception will be thrown.
			_statement.executeUpdate("CREATE TABLE " + tableName
					+ " (Name char(1))");
			commit();
			// if the table was created, drop it again.
			_statement.executeUpdate("DROP TABLE " + tableName);
			commit();
			return false;
		} catch (SQLException e) {
//			String errMsg = (e.getMessage()).toLowerCase();
//			if(!(errMsg.contains("already") 
//			  || errMsg.contains("exist") 
//			  || errMsg.contains("creat"))){ // this is not a real error!
//				e.printStackTrace();
//				Main._logger.reportError(e.getMessage());
//			}
			if(_statement == null){
				reset();
			}
			else{
				commit();
			}
			return true;
		}
  }
	
	public boolean isInstalled(String strPrefix, String[] tables) {
		// boolean cache = (tableExists(CACHE1_TABLE) &&
		// tableExists(CACHE2_TABLE));
		// boolean plan = tableExists(PLAN_TABLE);
		//
		// for (int i = 0; i < tables.length; i++) {
		// if (!tableExists(strPrefix + tables[i]))
		// return false;
		// }
		//
		// return cache && plan;
		return false;
	}

	public String[] getPlanProperties() {
		return PLAN_TABLE_PROPERTIES;
	}

	public String[] getPlanOperators() {
		return PLAN_OPERATORS;
	}

	// /**
	// * Checks to see if a table exists.
	// *
	// * @see azdblab.dbms.api.GeneralDBMS#tableExists(java.lang.String)
	// */
	// public boolean tableExists(String table) {
	// boolean res = false;
	// // Statement stmt = null;
	// try {
	// // attempts to create the table. If it fails, the table exists and
	// // an exception will be thrown.
	// //
	// Main.defaultLogger.logging_normal("Existing tables are examined ... ");
	// // stmt = _connection.createStatement();
	// // Main.defaultLogger.logging_normal("Statement was created ... ");
	// // stmt.executeUpdate("CREATE TABLE " + table + " (Name varchar(1))");
	// // Main.defaultLogger.logging_normal(table + " does not exist!! ");
	// // stmt.executeUpdate("DROP TABLE " + table);
	//      
	// _statement.executeUpdate("CREATE TABLE " + table + " (Name varchar(1))");
	// // if the table was created, drop it again.
	// _statement.executeUpdate("DROP TABLE " + table);
	// } catch (SQLException e) {
	// // Main._logger.outputLog(table + "... exists !! ");
	// res = true;
	// }
	// // try {
	// // if(stmt != null) stmt.close();
	// // } catch (SQLException e) {
	// // // TODO Auto-generated catch block
	// // e.printStackTrace();
	// // }
	// return res;
	// }

	// /**
	// * @see azdblab.labShelf.GeneralDBMS#timeQuery(java.lang.String,
	// azdblab.dbms.api.PlanTree)
	// */
	// public QueryExecutionStat timeQuery(String sqlQuery,
	// PlanNode plan,
	// long cardinality,
	// int time_out) throws SQLException, Exception {
	// Main._logger.outputLog("\nIn time query.... : " + sqlQuery);
	// //Main.defaultLogger.logging_normal("(cardinality .... : " + cardinality
	// + ")");
	//    
	// PlanNode curr_plan = getQueryPlan(sqlQuery);
	// if(curr_plan == null){
	// System.err.println("the current plan does not exist.!");
	// System.exit(-1);
	// }
	// //verifies that the current query plan is the plan that AZDBLAB thought
	// it was timing.
	// if (!curr_plan.equals(plan)) {
	// Main._logger.outputLog("current plan:  " + curr_plan.myHashCode() + "\n"
	// +
	// "existing plan: " + plan.myHashCode() + ", card: " + cardinality + "\n");
	// throw new
	// Exception("timeQuery: detected plan error.  Tried to time different plan from change point plan");
	// }
	//
	// String timedQuerySQL = sqlQuery;
	//
	// // We output the cardinality of the result to force oracle to time the
	// // entire query.
	// //insertPrefix = "SELECT COUNT(*) FROM (";
	//
	// //timedQuerySQL = insertPrefix + sqlQuery + ")";
	// // Main.defaultLogger.logging_normal(timedQuerySQL);
	//
	// //cacheClearSQL = insertPrefix + cacheClearSQL + ")";
	// // Main.defaultLogger.logging_normal(cacheClearSQL);
	//
	// long start_time;
	// long finish_time;
	// long exec_time = 0;
	// String proc_diff = "N/A";
	// //long minimum_execution_time = Long.MAX_VALUE;
	// //long maximum_execution_time = -1;
	// //int count = 10;
	//    
	// //long total_exetime = 0;
	//    
	// // The query is timed count times. The minimum time is the time that is
	// // returned.
	// /*
	// for (int i = 0; i < count; i++) {
	// try {
	// PreparedStatement ps = _connection
	// .prepareStatement(timedQuerySQL);
	//
	// PreparedStatement cs = _connection
	// .prepareStatement(cacheClearSQL);
	// // clear the cache.
	// ResultSet rs;
	// cs.execute();
	// rs = cs.getResultSet();
	// if (rs.next()) {
	// rs.getString(1);
	// Main._logger.outputLog(cacheClearSQL);
	// Main.defaultLogger.logging_normal(". Row Count: " + rs.getString(1));
	// Main.defaultLogger.logging_normal();
	// }
	// rs.close();
	//
	// // execute garbage collection
	// System.gc();
	// Runtime.getRuntime().gc();
	//
	// start_time = System.currentTimeMillis();
	// ps.execute();
	// rs = ps.getResultSet();
	// if (rs.next()) {
	// rs.getString(1);
	// Main._logger.outputLog(timedQuerySQL);
	// Main.defaultLogger.logging_normal(". Row Count: " + rs.getString(1));
	// Main.defaultLogger.logging_normal();
	// }
	// rs.close();
	// finish_time = System.currentTimeMillis();
	// exec_time = finish_time - start_time;
	//        
	// total_exetime += exec_time;
	//        
	// if (exec_time < minimum_execution_time)
	// minimum_execution_time = exec_time;
	//        
	// if (exec_time > maximum_execution_time)
	// maximum_execution_time = exec_time;
	//
	//
	// ps.close();
	// cs.close();
	//
	// } catch (SQLException e) {
	// e.printStackTrace();
	// throw new SQLException(cacheClearSQL + "\n" + sqlQuery + "\n"
	// + e.getMessage());
	// }
	// }
	// */
	//    
	// timeOuter = new TimeoutQueryExecution();
	// Timer timer = new Timer();
	//    
	// try {
	// flushCache();
	// //flushMemory();
	// Main._logger.outputLog("Finish Clearing Memory");
	// cleanupDirtyPages();
	// updateStat();
	//      
	// PreparedStatement ps = _connection.prepareStatement(timedQuerySQL);
	// Main._logger.outputLog("Statement prepared");
	// // ps.setQueryTimeout(time_out);
	// // timer.scheduleAtFixedRate(timeOuter, time_out, time_out);
	// // commit();
	// //Statement tempStatement = _connection.createStatement();
	//
	// ProcessTeller process_teller = new ProcessTeller();
	//
	// Main._logger.outputLog("Start Timing query");
	// start_time = System.currentTimeMillis();
	//      
	// Map<Integer, LinuxProcess> proc_map1 = process_teller.GetProcesses();
	// long num_processes1 = process_teller.GetNumProcesses();
	//        
	// ps.execute();
	//      
	// Map<Integer, LinuxProcess> proc_map2 = process_teller.GetProcesses();
	// long num_processes2 = process_teller.GetNumProcesses();
	//        
	// finish_time = System.currentTimeMillis();
	// proc_diff = ProcessTeller.ProcessMapDiff(
	// num_processes1, num_processes2, proc_map1, proc_map2);
	// exec_time = finish_time - start_time;
	// timer.cancel();
	//      
	// Main._logger.outputLog("Finishing Timing query");
	//      
	// ps.close();
	// } catch (SQLException e) {
	// e.printStackTrace();
	// //throw new SQLException(cacheClearSQL + "\n" + sqlQuery + "\n"
	// // + e.getMessage());
	// exec_time = MetaData.MAX_EXECUTIONTIME;
	// Main._logger.outputLog("Execution too long: Execution time set to " +
	// exec_time);
	// exec_time = 99999;
	// }
	//    
	// if (Main.verbose) {
	// Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
	// }
	//
	// //return new QueryStat(minimum_execution_time);
	// return new QueryExecutionStat(exec_time, proc_diff);
	//
	// }

	// /**
	// * @see azdblab.labNotebook.GeneralDBMS#timeQuery(java.lang.String,
	// azdblab.dbms.api.PlanTree)
	// */
	// public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan, long
	// cardinality)
	// throws SQLException, Exception {
	// PlanNode curr_plan = getQueryPlan(sqlQuery);
	// // verifies that the current query plan is the plan that OSAT thought it
	// // was timing.
	// if (!curr_plan.equals(plan)) {
	// throw new Exception(
	// "timeQuery: detected plan error.  Tried to time different plan from change point plan");
	// }
	//
	// // This SQL statement is used to clear the cache.
	// String cacheClearSQL = "SELECT t1.id1, t2.id1, t1.id3, t2.id4 FROM "
	// + CACHE1_TABLE + " t1, " + CACHE2_TABLE + " t2 ";
	// cacheClearSQL += " WHERE t1.id1 = t2.id1";
	// String timedQuerySQL = sqlQuery;
	// String insertPrefix = null;
	//
	// // We output the cardinality of the result to force oracle to time the
	// // entire query.
	// insertPrefix = "SELECT COUNT(*) FROM (";
	//
	// timedQuerySQL = insertPrefix + sqlQuery + ")";
	// // Main.defaultLogger.logging_normal(timedQuerySQL);
	//
	// cacheClearSQL = insertPrefix + cacheClearSQL + ")";
	// // Main.defaultLogger.logging_normal(cacheClearSQL);
	//
	// long start_time, finish_time, exec_time;
	// long minimum_execution_time = Long.MAX_VALUE;
	// int count = 3;
	// // The query is timed count times. The minimum time is the time that is
	// // returned.
	// for (int i = 0; i < count; i++) {
	// try {
	// PreparedStatement ps = _connection
	// .prepareStatement(timedQuerySQL);
	//
	// PreparedStatement cs = _connection
	// .prepareStatement(cacheClearSQL);
	// // clear the cache.
	// ResultSet rs;
	// // cs.execute();
	// // rs = cs.getResultSet();
	// // if (rs.next()) {
	// // rs.getString(1);
	// // //Main._logger.outputLog(cacheClearSQL);
	// // //Main.defaultLogger.logging_normal(". Row Count: " +
	// rs.getString(1));
	// // //Main.defaultLogger.logging_normal();
	// // }
	// // rs.close();
	//
	// // execute garbage collection
	// System.gc();
	// Runtime.getRuntime().gc();
	//
	// start_time = System.currentTimeMillis();
	// // ps.execute();
	// // rs = ps.getResultSet();
	// // if (rs.next()) {
	// // rs.getString(1);
	// // //Main._logger.outputLog(timedQuerySQL);
	// // //Main.defaultLogger.logging_normal(". Row Count: " +
	// rs.getString(1));
	// // //Main.defaultLogger.logging_normal();
	// // }
	// // rs.close();
	// finish_time = System.currentTimeMillis();
	// exec_time = finish_time - start_time;
	// if (exec_time < minimum_execution_time)
	// minimum_execution_time = exec_time;
	//
	// ps.close();
	// cs.close();
	//
	// } catch (SQLException e) {
	// e.printStackTrace();
	// throw new SQLException(cacheClearSQL + "\n" + sqlQuery + "\n"
	// + e.getMessage());
	// }
	// }
	//
	// Main.defaultLogger.logging_normal("Query Plan Execution Time: "
	// + minimum_execution_time);
	//
	// return new QueryStat((minimum_execution_time / 100) * 100);
	// // only valid til the 1/10 of a second
	// }

	@Override
	public void deleteRows(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// TODO Auto-generated method stub

	}

	@Override
	public ResultSet executeSimpleQuery(String tableName,
			String[] selectColumns, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ResultSet executeSimpleOrderedQuery(String tableName,
			String[] selectColumns, int indexOfOrderedColumn,
			int orderedDataType, String[] columnNames, String[] columnValues,
			int[] columnDataTypes) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ResultSet executeQuerySQL(String sql) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void executeUpdateSQL(String sql) {
		// TODO Auto-generated method stub

	}

	@Override
	public void executeDeleteSQL(String sql) throws SQLException {
		// TODO Auto-generated method stub
		_statement.executeUpdate(sql);
		commit();
	}

//	public String getExperimentSubjectName() {
//		return "DB2Subject";
//	}

	public String getDBMSName() {
		return DBMS_NAME;
	}

//	public String getName() {
//		return DBMS_NAME;
//	}

	public static final String DBMS_NAME = "DB2";

	// private long CurrentCardinality = 50000;
	//
	// public void setCurrentCardinality(long crntCard) {
	// CurrentCardinality = crntCard;
	// }

	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}

	public String getDBVersion() {
		return "DB2 Whatever Version";
	}

	@Override
	public void flushDBMSCache() {
		try {
			// below is the command for 9.8
			// String strFlush = "FLUSH BUFFERPOOLS";
			// _statement.execute(strFlush);
			// commit();
			// if not executed below before, then do it just once.
			// String strFlush =
			// "ALTER tablespace SYSCATSPACE no file system caching";
			// _statement.execute(strFlush);
			// commit();
			// strFlush = "ALTER tablespace TEMPSPACE1 no file system caching";
			// _statement.execute(strFlush);
			// commit();
			// strFlush = "ALTER tablespace USERSPACE1 no file system caching";
			// _statement.execute(strFlush);
			// commit();
			// strFlush =
			// "ALTER tablespace SYSTOOLSPACE no file system caching";
			// _statement.execute(strFlush);
			// commit();
			// strFlush =
			// "ALTER tablespace SYSTOOLSTMPSPACE no file system caching";
			// _statement.execute(strFlush);
			// commit();
			// db2 user needs to run 'db2pdcfg -flushbp -db research' to clean
			// dirty pages
			// change user to db2
			// Process p1 =
			// Runtime.getRuntime().exec("perl "+Constants.DIRECTORY_SCRIPTS+"db2_flush_cache.pl");
			// // Process p1 =
			// Runtime.getRuntime().exec("sudo su db2 --command=\"source /data/db2/sqllib/db2cshrc;db2 connect to research;db2pdcfg -flushbp -db research;\"");
			// InputStream instd = p1.getInputStream();
			// String str = "";
			// BufferedReader buf_reader = new BufferedReader(new
			// InputStreamReader(instd));
			// while ((str=buf_reader.readLine()) != null) {
			// Main._logger.outputLog(str);
			// }
			// buf_reader.close();
			// InputStream errstd = p1.getErrorStream();
			// BufferedReader buf_err_reader = new BufferedReader(new
			// InputStreamReader(errstd));
			// while ((str=buf_err_reader.readLine()) != null) {
			// Main._logger.outputLog(str);
			// }
			// buf_err_reader.close();
			// p1.waitFor();
			Main._logger.outputLog("flush DB2 cache ...");
			commit();
			String deactivate_command = "sudo /opt/ibm/db2/"+DB2Version+"/bin/db2 deactivate database research";
			Process p = Runtime.getRuntime().exec(deactivate_command);
			p.waitFor();
			Main._logger.outputLog("-- deactivate database finished.");
			String activate_command = "sudo /opt/ibm/db2/"+DB2Version+"/bin/db2 activate database research";
			p = Runtime.getRuntime().exec(activate_command);
			p.waitFor();
			Main._logger.outputLog("++ activate database finished.");
			/*
			 * BufferedReader buf_reader = new BufferedReader(new
			 * InputStreamReader(p.getErrorStream())); String input_string =
			 * null; while ((input_string = buf_reader.readLine()) != null) {
			 * System.out.println(input_string); } buf_reader.close();
			 * buf_reader = new BufferedReader(new
			 * InputStreamReader(p.getInputStream())); while ((input_string =
			 * buf_reader.readLine()) != null) {
			 * System.out.println(input_string); } buf_reader.close();
			 */
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		// try {
		// // Prepare the CALL statement for SYSPROC.ADMIN_CMD.
		// String sql = "CALL SYSPROC.ADMIN_CMD(?)";
		// String dbName = "research";
		// String flushSQL = "db2pdcfg -db "+dbName+" -flushbp";
		// CallableStatement callStmt = _connection.prepareCall(sql);
		// callStmt.setString(1, flushSQL);
		// callStmt.execute();
		// callStmt.close();
		// } catch (SQLException sqlex) {
		// sqlex.printStackTrace();
		// }

	}

	@Override
	public void flushOSCache() {
		flushLinuxCache();
	}

	// public void cleanupDirtyPages() {
	// // select tabname from sysstat.tables where tabschema='DB2' and tabname
	// LIKE 'FT_%'
	// Main._logger.outputLog("Vacuuming dirty pages ... before timing a query");
	// try {
	// // Prepare the CALL statement for SYSPROC.ADMIN_CMD.
	// String sql = "CALL SYSPROC.ADMIN_CMD(?)";
	//      
	// String schemaName = strUserName;
	// String tblNameSQL =
	// "select tabname from sysstat.tables where tabschema='" +
	// schemaName.toUpperCase() + "' and tabname LIKE 'FT_%'";
	// // Statement stmt = _connection.createStatement();
	// // ResultSet rs = stmt.executeQuery(tblNameSQL);
	// ResultSet rs = _statement.executeQuery(tblNameSQL);
	// while(rs.next()){
	// String tableName = rs.getString(1);
	// String sqlUpdateStatistics = "REORG TABLE " + schemaName.toUpperCase() +
	// "." + tableName.toUpperCase();
	// // Main.defaultLogger.logging_normal("command: " + sqlUpdateStatistics);
	//        
	// CallableStatement callStmt = _connection.prepareCall(sql);
	// callStmt.setString(1, sqlUpdateStatistics);
	// callStmt.execute();
	// callStmt.close();
	// }
	// rs.close();
	// // stmt.close();
	//      
	// } catch (SQLException sqlex) {
	// // Main.defaultLogger.logging_normal("... db2' vacumming error!!!!");
	// sqlex.printStackTrace();
	// }
	// Main._logger.outputLog("Finishing vacuuming");
	// }

	public void printTableStat(String tableName) {
		// updateTableStatistics(tableName, 0, true);
		String countSQL = "SELECT count(*) " + "FROM " + tableName;

		String schemaName = strUserName;
		String statSQL = "SELECT tabname, card, npages, fpages "
				+ "FROM sysstat.tables " + "WHERE tabschema='"
				+ schemaName.toUpperCase() + "' and tabname = '"
				+ tableName.toUpperCase() + "'";

		try {
			// Main.defaultLogger.logging_normal("count: " + countSQL);
			ResultSet cs = _statement.executeQuery(countSQL);
			if (cs.next()) {
				Main._logger.outputLog("actual rows: " + cs.getInt(1));
			}
			cs.close();
			// retrieving the statistics from the DBMS.
			Main._logger.outputLog("stat: " + statSQL);
			ResultSet ts = _statement.executeQuery(statSQL);
			while (ts.next()) {
				// Main.defaultLogger.logging_normal("object_id: " +
				// ts.getLong(1));
				Main._logger.outputLog("tableName: " + ts.getString(1));
				Main._logger.outputLog("table_rows: " + ts.getLong(2));
				Main._logger.outputLog("npages: " + ts.getLong(3));
				Main._logger.outputLog("fpages: " + ts.getLong(4));
				// Main.defaultLogger.logging_normal("active blocks: " +
				// ts.getLong(5));
			}
			// else {
			// System.err.println("No statistics for table: " + tableName);
			// System.exit(1);
			// }
			ts.close();
		} catch (SQLException e) {
			e.printStackTrace();
			System.err.println("exception-No statistics for table: "
					+ tableName);
			System.exit(1); // programmer/dbms error
		}
	}

	@Override
	public void dropAllInstalledTables() {
		// TODO Auto-generated method stub
		String sql = "SELECT TABNAME FROM SYSCAT.TABLES WHERE TABSCHEMA NOT LIKE 'SYS%' AND TYPE = 'T'";
		try {
			Main._logger.outputLog("Find all tables by : " + sql);
			Vector<String> vecTables = new Vector<String>();
			ResultSet rs = _statement.executeQuery(sql);
			while (rs.next()) {
				vecTables.add(rs.getString(1));
			}
			rs.close();
			for (int i = 0; i < vecTables.size(); i++) {
				String tblName = (String) vecTables.get(i);
				Main._logger.outputLog("installed tableName: " + tblName);
				if (tblName.contains("EXPLAIN") || tblName.contains("ADVISE") || tblName.toLowerCase().contains(Constants.CLONE_TABLE_PREFIX)) {
					// do nothing
				} else {
					dropTable(tblName);
				}
			}
			String explain_inst_tbl = "EXPLAIN_INSTANCE";
			String empty_table = "DELETE FROM " + strUserName + "."
					+ explain_inst_tbl;
			_statement.executeUpdate(empty_table);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void updateStat() {
		// select tabname from sysstat.tables where tabschema='DB2' and tabname
		// LIKE 'FT_%'
		Main._logger.outputLog("start updating table statistics");
		try {
			// Prepare the CALL statement for SYSPROC.ADMIN_CMD.
			String sql = "CALL SYSPROC.ADMIN_CMD(?)";

			String schemaName = strUserName;
			String tblNameSQL = "select tabname from sysstat.tables where tabschema='"
					+ schemaName.toUpperCase() + "' and tabname LIKE 'FT_%'";
			// Statement stmt = _connection.createStatement();
			// ResultSet rs = stmt.executeQuery(tblNameSQL);
			ResultSet rs = _statement.executeQuery(tblNameSQL);
			while (rs.next()) {
				String tableName = rs.getString(1);
				String sqlUpdateStatistics = "RUNSTATS ON TABLE "
						+ schemaName.toUpperCase() + "."
						+ tableName.toUpperCase();
				// Main.defaultLogger.logging_normal("command: " +
				// sqlUpdateStatistics);

				CallableStatement callStmt = _connection.prepareCall(sql);
				callStmt.setString(1, sqlUpdateStatistics);
				callStmt.execute();
				callStmt.close();
			}
			// stmt.close();
			rs.close();

		} catch (SQLException sqlex) {
			Main._logger.outputLog("... db2' tbl update error!!!!");
			sqlex.printStackTrace();
		}
		Main._logger.outputLog("Finishing updating stat");
	}

	// public void updateTableStatistics(String tableName, long cardinality) {
	// // below does not work for FT_HT1 which is derived from CLONE_MAX_FT_HT1
	// // String sqlUpdateStatistics
	// // = "UPDATE sysstat.tables set card = " + cardinality +
	// " where tabname = '" + tableName.toUpperCase() + "'";
	// //// Main.defaultLogger.logging_normal("sqlstatement: " +
	// sqlUpdateStatistics);
	// // try {
	// // _statement.executeUpdate(sqlUpdateStatistics);
	// // commit();
	// // int res = 0;
	// // String testSQL
	// // = "select card FROM sysstat.tables where tabname = '" +
	// tableName.toUpperCase() + "'";
	// // ResultSet rs;
	// // rs = _statement.executeQuery(testSQL);
	// // while(rs.next()){
	// // res = rs.getInt(1);
	// // }
	// // if(res != cardinality) Main.defaultLogger.logging_normal(" >>>>> '" +
	// tableName + "' table stat update error! ");
	// // } catch (SQLException sqlex) {
	// // sqlex.printStackTrace();
	// // }
	// //
	// Main.defaultLogger.logging_normal("... db2's table stat update done!");
	// //
	// // Prepare the CALL statement for SYSPROC.ADMIN_CMD.
	// String sql = "CALL SYSPROC.ADMIN_CMD(?)";
	//    
	// //Main.defaultLogger.logging_normal("tableName: " + tableName);
	// String schemaName = strUserName;
	// //// update sysstat.tables set card = 100 where tabname = 'TEST'
	// // String sqlUpdateStatistics = "REORGCHK UPDATE STATISTICS on SCHEMA " +
	// schemaName;
	// // String sqlUpdateStatistics =
	// "REORGCHK UPDATE STATISTICS on TABLE ALL";
	// String sqlUpdateStatistics = "RUNSTATS ON TABLE " +
	// schemaName.toUpperCase() + "." + tableName.toUpperCase();
	// // Main.defaultLogger.logging_normal("sql: " + sqlUpdateStatistics);
	// try {
	// CallableStatement callStmt = _connection.prepareCall(sql);
	// callStmt.setString(1, sqlUpdateStatistics);
	// callStmt.execute();
	// callStmt.close();
	// } catch (SQLException sqlex) {
	// Main._logger.outputLog("... db2's table stat update error!!!!");
	// sqlex.printStackTrace();
	// // System.exit(1);
	// }
	// commit();
	// Main.defaultLogger.logging_normal("... db2's table stat update done!");
	// }

	@Override
	public void updateTableStatistics(Table table) {
		String tableName = table.table_name_with_prefix;
		// Prepare the CALL statement for SYSPROC.ADMIN_CMD.
		String sql = "CALL SYSPROC.ADMIN_CMD(?)";
		String schemaName = strUserName;
		String sqlUpdateStatistics = "RUNSTATS ON TABLE "
				+ schemaName.toUpperCase() + "." + tableName.toUpperCase();
		try {
			CallableStatement callStmt = _connection.prepareCall(sql);
			callStmt.setString(1, sqlUpdateStatistics);
			callStmt.execute();
			callStmt.close();
		} catch (SQLException sqlex) {
			Main._logger.outputLog("... db2's table stat update error!!!!");
			Main._logger.reportError(sqlex.getMessage());
		}
		commit();
	}

	public void deleteHelperTables() {
	}

	public void setOptimizerFeature(String featureName, String featureValue) {

	}

	/**
	 * A constant used to specifiy the size of the buffer that is used to move
	 * data between a CLOB and file or vice versa.
	 */
	// private static final int BUFFER_SIZE = 1024;

	// /**
	// * The name of the first cache table.
	// */
	// private static final String CACHE1_TABLE = AZDBLAB.TABLE_PREFIX +
	// "CACHE_1";
	// /**
	// * The name of the second cache table.
	// */
	// private static final String CACHE2_TABLE = AZDBLAB.TABLE_PREFIX +
	// "CACHE_2";

	/**
	 * The office name of the CLOB
	 */
	// private static final String CLOB = "CLOB";
	private static final String BLOB = "BLOB";

	// /**
	// * The CREATE TABLE statement for the first cache table
	// */
	// private static final String CREATE_CACHE1_TABLE = "CREATE TABLE "
	// + CACHE1_TABLE
	// +
	// "(id1 INT, id2 INT, id3 INT, id4 INT, id5 INT, id6 INT, id7 INT, id8 INT, id9 INT, id10 INT, id11 INT, id12 INT, id13 INT, id14 INT, id15 INT)";
	// /**
	// * The CREATE TABLE statement for the second cache table.
	// */
	// private static final String CREATE_CACHE2_TABLE = "CREATE TABLE "
	// + CACHE2_TABLE
	// +
	// "(id1 INT, id2 INT, id3 INT, id4 INT, id5 INT, id6 INT, id7 INT, id8 INT, id9 INT, id10 INT, id11 INT, id12 INT, id13 INT, id14 INT, id15 INT)";

	/*
	 * /** An array of operators specified in DB2-- To be changed
	 */
	public static final String[] PLAN_OPERATORS = new String[] { "TBSCAN", // Table
																			// Scan
			"IXSCAN", // Index Scan
			"FETCH", // Fetch from table
			"MSJOIN", // Merge Scan Join
			"NLJOIN", // Nested Loop Join
			"HSJOIN", // Hash Join GRPBY // Group By
			"SUM", // Sum
			"AVG", // Average
			"MIN", // Minimum
			"MAX", // Maximum
			"TEMP", // Insert into temp table
			"SORT", // Sort
			"IXAND", // Index ANDing
			"RIDSCA", // Index ORing or List Prefetch
			"IXA", // Star Schema Bitmap Indexing
			"BTQ", // Broadcast Table Queue
			"DTQ", // Directed Table Queue
			"MDTQ", // Merge Directed Table Queue
			"MBTQ", // Merge Broadcast Table Queue
			"LTQ", // Local Table Queue, for intra-partition parallelism
	};

	/**
	 * An array of column names for the table PLAN_TABLE in Oracle.
	 */
	public static final String[] PLAN_TABLE_COLUMNS = new String[] { "ID",
			"PARID", "NODE_ORDER", "OBJECT_NAME", "OPERATION", "OBJECT_TYPE",
			"TOTAL_COST", "IO_COST", "CPU_COST", "FIRST_ROW_COST",
			"RE_TOTAL_COST", "RE_IO_COST", "RE_CPU_COST", "COMM_COST",
			"FIRST_COMM_COST", "BUFFER_COST", "REMOTE_TOTAL_COST",
			"REMOTE_COMM_COST", "STREAM_COST" };

	/**
	 * An array of column names for the table PLAN_TABLE in Oracle.
	 */
	public static final String[] PLAN_TABLE_PROPERTIES = new String[] { "ID",
			"PARID", "NODE_ORDER", "OBJECT_NAME", "OPERATION_NAME",
			"OBJECT_TYPE", "TOTAL_COST" };

	// /**
	// * The SQL CREATE TABLE statement that will create the QUERY_PLAN_TABLE.
	// */

	// public void printCreatePlanTbl(){
	// Main.defaultLogger.logging_normal("plan_table: " + CREATE_PLAN_TABLE);
	// }
	private final String CREATE_PLAN_TABLE = "CREATE TABLE " + QUERY_PLAN_TABLE
			+ " (" + PLAN_TABLE_COLUMNS[0] + " INTEGER      NOT NULL,"
			+ PLAN_TABLE_COLUMNS[1] + " INTEGER      NOT NULL,"
			+ PLAN_TABLE_COLUMNS[2] + " INTEGER      NOT NULL,"
			+ PLAN_TABLE_COLUMNS[3] + " VARCHAR(128)   NOT NULL,"
			+ PLAN_TABLE_COLUMNS[4] + " VARCHAR(128)   NOT NULL,"
			+ PLAN_TABLE_COLUMNS[5] + " VARCHAR(128)   NOT NULL,"
			+ PLAN_TABLE_COLUMNS[6] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[7] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[8] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[9] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[10] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[11] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[12] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[13] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[14] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[15] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[16] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[17] + " DOUBLE           NOT NULL,"
			+ PLAN_TABLE_COLUMNS[18] + " DOUBLE          NOT NULL" + ")";

	public static final String COST_MODEL_PREFIX = "DB2_";

	/**
	 * The index of the id for the cache tables.
	 */
	private static final int ID_INDEX = 1;
	/**
	 * The index of the column that has the parent id for the plan_table.
	 */
	private static final int PARENT_ID_INDEX = 2;
	/**
	 * The index of the column in the cache tables that are used for ordering.
	 */
	private static final int NODE_ORDER_INDEX = 3;
	/**
	 * The index of the column that has the object name for the plan_table.
	 */
	private static final int OBJECT_NAME_INDEX = 4;
	/**
	 * The index of the column that has the operation name for the plan_table.
	 */
	private static final int OPERATION_NAME_INDEX = 5;
	/**
	 * The index of the column that has the object type for the plan_table.
	 */
	private static final int OBJECT_TYPE_INDEX = 6;
	/**
	 * The index of the column that has the object total cost for the
	 * plan_table.
	 */
	private static final int OBJECT_TOTAL_COST_INDEX = 7;
	/**
	 * The index of the column that has the object io cost for the plan_table.
	 */
	private static final int OBJECT_IO_COST_INDEX = 8;
	/**
	 * The index of the column that has the object cpu cost for the plan_table.
	 */
	private static final int OBJECT_CPU_COST_INDEX = 9;
	/**
	 * The index of the column that has the object first row cost for the
	 * plan_table.
	 */
	private static final int OBJECT_FIRST_ROW_COST_INDEX = 10;
	/**
	 * The index of the column that has the object re total cost for the
	 * plan_table.
	 */
	private static final int OBJECT_RE_TOTAL_COST_INDEX = 11;
	/**
	 * The index of the column that has the object re io cost for the
	 * plan_table.
	 */
	private static final int OBJECT_RE_IO_COST_INDEX = 12;
	/**
	 * The index of the column that has the object re cpu cost for the
	 * plan_table.
	 */
	private static final int OBJECT_RE_CPU_COST_INDEX = 13;
	/**
	 * The index of the column that has the object comm cost for the plan_table.
	 */
	private static final int OBJECT_COMM_COST_INDEX = 14;
	/**
	 * The index of the column that has the object first comm cost for the
	 * plan_table.
	 */
	private static final int OBJECT_FIRST_COMM_COST_INDEX = 15;
	/**
	 * The index of the column that has the object buffer cost for the
	 * plan_table.
	 */
	private static final int OBJECT_BUFFER_COST_INDEX = 16;
	/**
	 * The index of the column that has the object remote total cost for the
	 * plan_table.
	 */
	private static final int OBJECT_REMOTE_TOTAL_COST_INDEX = 17;
	/**
	 * The index of the column that has the object remote comm cost for the
	 * plan_table.
	 */
	private static final int OBJECT_REMOTE_COMM_COST_INDEX = 18;
	/**
	 * The index of the column that has the object remote comm cost for the
	 * plan_table.
	 */
	private static final int OBJECT_STREAM_COST_INDEX = 19;

	/**
	 * The name of the data type to store integer numbers in Oracle.
	 */
	// private static final String NUMBER = "NUMBER";
	private static final String NUMBER = "BIGINT";

	/**
	 * The name of the character data type for ORACLE.
	 */
	// private static final String VARCHAR = "VARCHAR2";
	private static final String VARCHAR = "VARCHAR";
	/**
	 * A reference to the connect string that was passed in upon creation of
	 * this object.
	 */
	// private String myConnectString;
	/**
	 * A cache of the last timed table's column statistics.
	 */
	// private Vector myLastColumnStats;
	/**
	 * A cache of the last timed table's table statistics.
	 */
	// private TableStatistic myLastTableStat;
	/**
	 * The password to connect to the DBMS.
	 */
	// private String myPassword;
	/**
	 * The username to connect to the DBMS.
	 */
	// private String myUserName;

	private static final String DBMS_DRIVER_CLASS_NAME = "com.ibm.db2.jcc.DB2Driver";

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
