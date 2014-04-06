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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Timer;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TableNode;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Table;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.utility.procdiff.ProcessInfo;
import azdblab.utility.procdiff.WindowsProcessAnalyzer;

/**
 *
 */
public class SqlServerSubject extends ExperimentSubject {
//	SQLServerConnection conn = (SQLServerConnection) DriverManager.getConnection(connectionString);
//	SQLServerStatement s = (SQLServerStatement) conn.createStatement();
//	SQLServerResultSet rs;	
//	SQLServerPreparedStatement ps = null;
	
//	private SQLServerConnection conn;
//	private SQLServerStatement stmt;
//	private SQLServerResultSet rs;
//	private SQLServerPreparedStatement ps;
	
	String strUserName;
	String strPassword;
	String connectionString;
	/**
	 * 
	 * @param user_name
	 * @param password
	 * @param connect_string
	 */
	public SqlServerSubject(String user_name, String password, String connect_string, String machineName) {
		super(user_name, password, connect_string, machineName);
		strUserName = user_name;
		strPassword = password;
		connectionString = connect_string;
//		try {
//			Class.forName(DBMS_DRIVER_CLASS_NAME);
//			conn.setAutoCommit(false);
//			conn = (SQLServerConnection) DriverManager.getConnection(connectionString);
//			stmt = (SQLServerStatement) conn.createStatement();
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (ClassNotFoundException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
	}
	
	//public SqlServerSubject(String connect_string) {
	//	super(connect_string);
	//	strUserName			= "manzhang";
	//	strPassword			= "manz";
	//}
	
	
//	public String getExperimentSubjectName() {
//		return "SqlServerSubject";
//	}

	
	public String getDBMSName() {
		return DBMS_NAME;
	}
//	  public static String getName(){
//		  return DBMS_NAME;
//	  }
	
	/**
	 * The creates all tables used internally by SQL Server to perform experiments.
	 */
	@Override
	public void initializeSubjectTables(){
		// TODO Auto-generated method stub
	
		/*
		try {
			//This table is used to record which tables have been created.  When AZDBLab uninstalls 
			//All tables found in this table will be deleted.  A tuple is inserted for each table
			
			if (tableExists(CACHE1_TABLE)) {
				_statement.executeUpdate(DROP_CACHE1_TABLE);
			}
			_statement.executeUpdate(CREATE_CACHE1_TABLE);
			
			if (tableExists(CACHE2_TABLE)) {
				_statement.executeUpdate(DROP_CACHE2_TABLE);
			}
			_statement.executeUpdate(CREATE_CACHE2_TABLE);
			
		} catch (SQLException e) {
			Main.defaultLogger.logging_error("SqlServerInterface could not create the table an internal table");
			e.printStackTrace();
			System.exit(1); //this is an install bug
		}
		//inserting 100,000 tuples into each cache table.
		try {
			String columnNames[] =
				new String[] {
					"id1",
					"id2",
					"id3",
					"id4",
					"id5",
					"id6",
					"id7",
					"id8",
					"id9",
					"id10",
					"id11",
					"id12",
					"id13",
					"id14",
					"id15" };
			String columnValues[] =
				new String[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15" };
			int columnDataTypes[] =
				new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER };
			if (Main.verbose)
				Main.defaultLogger.logging_normal("Starting to inserting into the cache tables");
			//for (int i = 0; i < 100000; i++) {
			for (int i = 0; i < 1000; i++) {
				if (Main.verbose)
					if (i % 10000 == 0)
						Main.defaultLogger.logging_normal("Inserted " + i + " rows into the cache tables");
				columnValues[0] = "" + i;
				insertTuple(CACHE1_TABLE, columnNames, columnValues, columnDataTypes);
				insertTuple(CACHE2_TABLE, columnNames, columnValues, columnDataTypes);
			}
			//commit();
			if (Main.verbose)
				Main.defaultLogger.logging_normal("Finished inserting into the cache tables");
		} catch (SQLException e1) {
			e1.printStackTrace();
			System.exit(1);
		}
		*/
	}
	
	
	@Override
	public void disableAutoStatUpdate() {
		// TODO Auto-generated method stub
//		boolean fail = false;
//Main.defaultLogger.logging_normal(">>> Disabling auto Stat update ... ");			
		// TODO Auto-generated method stub
		String strStatUpdateSQL = "ALTER DATABASE research SET AUTO_UPDATE_STATISTICS OFF";
		try {
			//attempts to create the table.  If it fails, the table exists and an exception will be thrown.
			_statement.executeUpdate(strStatUpdateSQL);
			//if the table was created, drop it again.
		} catch (SQLException e) {
//			Main.defaultLogger.logging_error("Turning off the update demon error: '" + strStatUpdateSQL + "'" );
			e.printStackTrace();
//			fail = true;
		}
//		if(!fail) Main.defaultLogger.logging_normal("<<<< Success! ");
	}


	@Override
	public void enableAutoStatUpdate() {
		//Main.defaultLogger.logging_normal(">>> Disabling auto Stat update ... ");			
		// TODO Auto-generated method stub
		String strStatUpdateSQL = "ALTER DATABASE research SET AUTO_UPDATE_STATISTICS ON";
		try {
			//attempts to create the table.  If it fails, the table exists and an exception will be thrown.
			_statement.executeUpdate(strStatUpdateSQL);
			//if the table was created, drop it again.
		} catch (SQLException e) {
//			Main.defaultLogger.logging_error("Turning off the update demon error: '" + strStatUpdateSQL + "'" );
			e.printStackTrace();
		}
//		if(!fail) Main.defaultLogger.logging_normal("<<<< Success! ");
	}


	public void deleteHelperTables() {
		/*
		try {
			//This table is used to record which tables have been created.  When AZDBLab uninstalls 
			//All tables found in this table will be deleted.  A tuple is inserted for each table
			
			//These are two tables that are used to clear the cache.
			if (tableExists(CACHE1_TABLE)) {
				_statement.executeUpdate(DROP_CACHE1_TABLE);
			}
			
			if (tableExists(CACHE2_TABLE)) {
				_statement.executeUpdate(DROP_CACHE2_TABLE);
			}
			
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
		*/
	}
	
	/**
	 * 
	 */
	public void copyTable(String newTable, String oriTable) throws Exception{
		
		try {
			
			if (tableExists(newTable)) {
				_statement.executeUpdate("DROP TABLE " + newTable);
			      // yksuh added commit as below
				commit();
			}
			
			//String	cloneSQL	= "CREATE TABLE " + newTable + " LIKE " + oriTable;
			
			String	cloneSQL	= "SELECT * INTO " + newTable + " FROM " + oriTable;
			
			_statement.executeUpdate(cloneSQL);
			
			String	updateStatistics	= "UPDATE STATISTICS " + newTable + " WITH FULLSCAN";
			
			_statement.executeUpdate(updateStatistics);
			_connection.commit();
			// alter index
						
		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
			close();
			throw new Exception(sqlex.getMessage());
		}
		
	}
	
	
	/**
	 * 
	 */
	public void copyTable(String newTable, String oriTable, long cardinality) throws Exception{
		
		try {
			if (tableExists(newTable)) {
				_statement.executeUpdate("DROP TABLE " + newTable);
			      // yksuh added commit as below
				commit();
			}
			
			//String	cloneSQL	= "CREATE TABLE " + newTable + " LIKE " + oriTable;
			
			String	cloneSQL	= "SELECT * INTO " + newTable + " FROM " + oriTable + " WHERE id1 < " + cardinality;

			_statement.executeUpdate(cloneSQL);
			
//			String	updateStatistics	= "UPDATE STATISTICS " + newTable + " WITH FULLSCAN";
//			
//			_statement.executeUpdate(updateStatistics);
			_connection.commit();
			
		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
			close();
			throw new Exception(sqlex.getMessage());
		}
		
	}
	
	public void dropAllInstalledTables() {
		// TODO Auto-generated method stub
		//String sql = "SELECT t.name " +
		//	     "FROM sys.tables t, sys.sysindexes i " +
		//			 "WHERE t.object_id = i.id and i.indid = 0";
		String sql = "SELECT name FROM sys.tables";
		try {
			Main._logger.outputLog("Find all tables by : " + sql);
			Vector<String> vecTables = new Vector<String>();
			ResultSet rs = _statement.executeQuery(sql);
			while(rs.next()){
				vecTables.add(rs.getString(1));
			}
			rs.close();
			for(int i=0;i<vecTables.size();i++){
				String tblName = (String)vecTables.get(i);
				Main._logger.outputLog("installed tableName: " + tblName);
				dropTable(tblName);		
				this.commit();
			}
		}catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public int getTableCardinality(String tableName){
		int res = 0;
		String countSQL = "SELECT count(*) " + "FROM " + tableName;
		  
		  try {
//			    Main.defaultLogger.logging_normal("count sql: " + countSQL);
			  	ResultSet cs = _statement.executeQuery(countSQL);
			  	if(cs.next()){
//			  		Main.defaultLogger.logging_normal("actual rows: " + cs.getInt(1));
			  		res = cs.getInt(1);
			  	}
			  	cs.close();
			} catch (SQLException e) {
				e.printStackTrace();
				Main._logger.reportError("exception-No statistics for table: " + tableName);
				System.exit(1); // programmer/dbms error
			}
			return res;
	  }
	
	
	public void printTableStat(String tableName){
//		String 		analyzeSQL	= "UPDATE STATISTICS " + tableName + " WITH FULLSCAN";
		
		String statSQL = "SELECT t.name, i.rows, i.dpages " +
						 "FROM sys.tables t, sys.sysindexes i " +
						 "WHERE t.name = '" + tableName.toUpperCase() + "' and t.object_id = i.id and i.indid = 0";
		String countSQL = "SELECT count(*) " + "FROM " + tableName.toUpperCase();
		  
		  try {
//			    Main.defaultLogger.logging_normal("count: " + countSQL);
			  	ResultSet cs = _statement.executeQuery(countSQL);
			  	if(cs.next()){
			  		Main._logger.outputLog("actual rows: " + cs.getInt(1));
			  	}
			  	cs.close();
//			  	Main.defaultLogger.logging_normal(analyzeSQL);
//				_statement.executeUpdate(analyzeSQL);
//				commit();
				// retrieving the statistics from the DBMS.
				Main._logger.outputLog("stat: " + statSQL);
				ResultSet ts = _statement.executeQuery(statSQL);
				while (ts.next()) {
//					Main.defaultLogger.logging_normal("object_id: " + ts.getLong(1));
					Main._logger.outputLog("tableName: " + ts.getString(1));
					Main._logger.outputLog("table_rows: " + ts.getLong(2));
					Main._logger.outputLog("dpages: " + ts.getLong(3));
				} 
//				else {
//					Main.defaultLogger.logging_error("No statistics for table: " + tableName);
//					System.exit(1); 
//				}
				ts.close();
			} catch (SQLException e) {
				e.printStackTrace();
				Main._logger.reportError("exception-No statistics for table: " + tableName);
				reset();
				System.exit(1); // programmer/dbms error
			}
	  }
	
//	public void updateTableStatistics(String tableName, long cardinality, boolean recompute) {
//		//Main.defaultLogger.logging_error("SQLSERVER Doesn't support set table statistics.");
//		String 		sqlUpdateStatistics	= "UPDATE STATISTICS " + tableName + " WITH FULLSCAN";
//		try {
//			_statement.executeUpdate(sqlUpdateStatistics);
//			commit();
//		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
//		}
//	}
	
	public void updateTableStatistics(Table table) {
		String tableName = table.table_name_with_prefix;
		//Main.defaultLogger.logging_error("SQLSERVER Doesn't support set table statistics.");
		String 		sqlUpdateStatistics	= "UPDATE STATISTICS " + tableName + " WITH FULLSCAN";
		try {
			_statement.executeUpdate(sqlUpdateStatistics);
			commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

//	public void populateTable(String tableName, int columnnum, long cardinality, long max_card, RepeatableRandom repRand, boolean isVariableTable) throws Exception{
//		
//		super.populateTable(tableName, columnnum, cardinality, max_card, repRand, isVariableTable);
//		updateTableStatistics(tableName);
//	}
	
	/*
	public void setVirtualTableCardinality(String tableName, long cardinality, boolean isFirstTime, boolean isOptimal) {
		
		super.setVirtualTableCardinality(tableName, cardinality, isFirstTime, isOptimal);
		
		String	updateStatistics	= "UPDATE STATISTICS " + tableName + " WITH SAMPLE " + 1 + " ROWS";
		//String	updateStatistics	= "UPDATE STATISTICS " + tableName + " WITH FULLSCAN, NORECOMPUTE";
		
		try {
			_statement.executeUpdate(updateStatistics);
			_connection.commit();
		}catch (SQLException e1) {
			e1.printStackTrace();
		}
	}*/
	
	
	
	/**
	 * Collects column stats for the specified column.
	 * @param tableName The name of the table which will be used to gather statistics.
	 * @return A vector of ColumnStatistic objects.  One for each column of the table.
	 *
	private Vector getColumnStatistics(String tableName) {
		Vector result = new Vector();
		
		String col_stats =
			"SELECT NUM_DISTINCT, AVG_COL_LEN, COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '"
				+ tableName.toUpperCase()
				+ "'";
		try {
			ResultSet css = _statement.executeQuery(col_stats);
			
			//extracting column stats
			while (css.next()) {
				ColumnStatistic current = new ColumnStatistic();
				current.distinct_count = css.getLong(1);
				current.average_column_length = css.getLong(2);
				current.columnName = css.getString(3);
				result.add(current);
			}
			css.getStatement().close();
		} catch (SQLException e) {
			Main.defaultLogger.logging_error("No statistics for column: " + tableName);
			e.printStackTrace();
			System.exit(1); //fundamental programmer/dbsm problem
		}

		return result;
	}
	*/
	
	
	/**
	 * Given AZDBLab's integer representation of a data type, this produces an SQL Server specific
	 * representation of the data type.
	 * @param dataType The data type
	 * @param length The number of digits for this value.
	 * @return A string representation of this data type/length.  This value can be used in a create table 
	 * statement.
	 */
	protected String getDataTypeAsString(int dataType, int length) {
		switch (dataType) {
			case GeneralDBMS.I_DATA_TYPE_NUMBER :
				{
					return INT;
				}
			case GeneralDBMS.I_DATA_TYPE_VARCHAR :
				{
					return VARCHAR + "(" + length + ")";
				}
			case GeneralDBMS.I_DATA_TYPE_CLOB :
				{
					return IMAGE;
				}
			default :
				{
					Main._logger.reportError("Unknown data type");
					System.exit(1);
					//problem with xml schema.  should have been caught
					return null;
				}
		}
	}

	/*
	private ResultSet aremoreResults(String sql) throws SQLException{
		
		Statement s	= _connection.createStatement();
		s.executeQuery(sql);

        boolean	bmore	= s.getMoreResults();
        
        if (bmore) {
        	return s.getResultSet();
        }
        
        return null;
        
	}
	*/

	public void printColumns(ResultSet 	rs) throws Exception{
		try {
			ResultSetMetaData	meta 			= rs.getMetaData();
			int 				number_columns 	= meta.getColumnCount();
			String[] metaColumnNames = new String[number_columns+1]; 
			for(int i = 1;i<number_columns+1;i++){
				metaColumnNames[i] = meta.getColumnName(i);
				if(i == 3 || i == PHYSICAL_OP_INDEX || i == 4 || i == 9 || i == 10 || i == 11 || i == 12 || i == 13 || i == 18)
					Main._logger.outputDebugWithoutNewLine(" | " + metaColumnNames[i]);
			}
			int newId = 0;
			HashMap<Integer, Integer> idMap = new HashMap<Integer, Integer>();
			Main._logger.outputLog(" |");
			int cnt = 0;
			while (rs.next()) {
				cnt++;
				if(cnt == 1) continue;
				for(int i=1;i<number_columns+1;i++){
					switch(i){
						case NODE_INDEX:{
							String id = "";
							Integer ssID = new Integer(rs.getInt(i));
							Integer idVal = idMap.get(ssID);
							if(idVal == null){
								Integer ourID = new Integer(newId++);
								idMap.put(ssID, ourID);
								id = ourID.toString();
							}else{
								id = idVal.toString();
							}
							Main._logger.outputDebugWithoutNewLine(" | " + id);
							break;
						}
						case PARENT_INDEX:{
							String parent_id = "";
							Integer ssID = new Integer(rs.getInt(i));
							Integer idVal = idMap.get(ssID);
							if(idVal == null){
								parent_id = "-1";
							}else{
								parent_id = idVal.toString();
							}
							Main._logger.outputDebugWithoutNewLine(" | " + parent_id);
							break;
						}
						case PHYSICAL_OP_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getString(i));
							break;
						case ESTIMATE_ROWS_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getDouble(i));
							break;
						case ESTIMATE_IO_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getDouble(i));
							break;
						case ESTIMATE_CPU_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getDouble(i));
							break;
						case AVG_ROW_SIZE_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getInt(i));
							break;
						case TOTAL_SUBTREE_COST_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getDouble(i));
							break;
						case ESTIMATE_EXECUTIONS_INDEX:
							Main._logger.outputDebugWithoutNewLine(" | " + rs.getDouble(i));
							break;
					}
					
				}
				Main._logger.outputDebugWithoutNewLine(" |\n");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
			
	}
		
	public PlanNode getQueryPlan(String sql) throws Exception {
		String 		explain_plan 		= "SET SHOWPLAN_ALL ON";
		String 		explain_plan_off 	= "SET SHOWPLAN_ALL OFF";
		
		ResultSet 	rs;
		
		Statement stmt	= _connection.createStatement();
		try {
			// remove old query plan
			// ask sql server to provide the new query plan
//			_statement.executeUpdate(explain_plan);
			stmt.executeUpdate(explain_plan);
			/** 
			 * execute the explain first, 
			 * CONVERT and put the result into plan_table as in SQL Server result storage.
			 * Then retrieve the result from plan_table
			 */

			//extracting the query plan from the DBMS
	
			rs 			= stmt.executeQuery(sql);
		}catch (SQLException e1) {
			Main._logger.outputLog("error sql: "+sql);
			e1.printStackTrace();
			return null;
		}
		
		PlanNode result = createPlanTree(rs);

//System.out.println("plan_code: " + result.myHashCode());
//System.out.println("plan_string: " + result.toString());
//try {
//	Statement stmt2	= _connection.createStatement();
//	ResultSet rs2 = stmt2.executeQuery(sql);
//	printColumns(rs2);
//	rs2.close();
//	stmt2.close();
//} catch (Exception e1) {
//	// TODO Auto-generated catch block
//	e1.printStackTrace();
//}
	
		stmt.executeUpdate(explain_plan_off);
		rs.close();
		stmt.close();
		return result;
	}

	private PlanNode createPlanTree(ResultSet rs) {
		
		Vector<PlanNode>	v_tree	= new Vector<PlanNode>();
		int numOps = 0;
		int newId = 0;
		HashMap<Integer, Integer> idMap = new HashMap<Integer, Integer>();
		int i,j;

		try {
			ResultSetMetaData	meta 			= rs.getMetaData();
			int 				number_columns 	= meta.getColumnCount();
			Vector<TableNode> tableNodeList = new Vector<TableNode>();
			
			String pos = null;
			while (rs.next()) {
				numOps++;
				if(numOps == 1) continue;		// skip the first row which contains a query text
//				else if(numOps == 2){
//					// set how many number should be subtracted from each node id so that node id can start with 0
//					relID = Integer.parseInt(rs.getString(NODE_INDEX));
//				}
				
				boolean tableObjectNeeded = false;
				HashMap<String, Double> mapRunStat = new HashMap<String, Double>();
				String id = null, 
					   parent_id = null, 
					   operation_name = null, 
					   object_estimate_rows = null,
					   object_estimate_io = null,
					   object_estimate_cpu = null,
					   object_avg_row_size = null,
					   object_total_subtree_cost = null,
					   object_estimate_executions = null;
					   
				String[] columnNames = new String[number_columns+1];	// assign one more column name for storing OBJECT_NAME 
				String[] columnValues = new String[number_columns+1];	// assign one more column value for storing OBJECT_NAME 
				// for each column of this tuple
				for (i = 1; i <= number_columns; i++) {
					String tempValue = rs.getString(i);
					if (tempValue != null) tempValue = tempValue.trim();
					columnNames[i-1] = meta.getColumnName(i);
					columnValues[i-1] = tempValue;
					
					switch (i) {
						case SqlServerSubject.NODE_INDEX: {
							Integer ssID = new Integer(rs.getInt(i));
							Integer idVal = idMap.get(ssID);
							if(idVal == null){
								Integer ourID = new Integer(newId++);
								idMap.put(ssID, ourID);
								id = ourID.toString();
							}else{
								id = idVal.toString();
							}
							pos = id;
							break;
						}
						case SqlServerSubject.PARENT_INDEX: {
							Integer ssID = new Integer(rs.getInt(i));
							Integer idVal = idMap.get(ssID);
							if(idVal == null){
								parent_id = "-1";
							}else{
								parent_id = idVal.toString();
							}
							break;
						}
						case SqlServerSubject.PHYSICAL_OP_INDEX: {
							operation_name = tempValue;
							// change the orginal column name, 'PhysicalOp'
							// to 'OPERATION' for compatibility with other subjects
							// Then we don't have to call setPropertyValue, since the change reflects the call.
							columnNames[i-1] = "OPERATION";
							if (operation_name.equals("Table Scan")) {
								// create a table node later
								tableObjectNeeded = true;
							}
							break;
						}
						case SqlServerSubject.ESTIMATE_ROWS_INDEX: {
							object_estimate_rows = tempValue;
							if(object_estimate_rows != null)
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_ROWS", Double.parseDouble(object_estimate_rows));
							else
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_ROWS", -1.0);
							break;
						}
						case SqlServerSubject.ESTIMATE_IO_INDEX: {
							object_estimate_io = tempValue;
							if(object_estimate_rows != null)
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_IO", Double.parseDouble(object_estimate_io));
							else
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_IO", -1.0);
							break;
						}
						case SqlServerSubject.ESTIMATE_CPU_INDEX: {
							object_estimate_cpu = tempValue;
							if(object_estimate_cpu != null)
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_CPU", Double.parseDouble(object_estimate_cpu));
							else
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_CPU", -1.0);
							break;
						}
						case SqlServerSubject.AVG_ROW_SIZE_INDEX: {
							object_avg_row_size = tempValue;
							if(object_avg_row_size != null)
								mapRunStat.put(COST_MODEL_PREFIX+"AVG_ROW_SIZE", Double.parseDouble(object_avg_row_size));
							else
								mapRunStat.put(COST_MODEL_PREFIX+"AVG_ROW_SIZE", -1.0);
							break;
						}
						case SqlServerSubject.TOTAL_SUBTREE_COST_INDEX: {
							object_total_subtree_cost = tempValue;
							if(object_total_subtree_cost != null)
								mapRunStat.put(COST_MODEL_PREFIX+"TOTAL_SUBTREE_COST", Double.parseDouble(object_total_subtree_cost));
							else
								mapRunStat.put(COST_MODEL_PREFIX+"TOTAL_SUBTREE_COST", -1.0);
							break;
						}
						case SqlServerSubject.ESTIMATE_EXECUTIONS_INDEX: {
							object_estimate_executions = tempValue;
							if(object_estimate_executions != null)
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_EXECUTIONS", Double.parseDouble(object_estimate_executions));
							else
								mapRunStat.put(COST_MODEL_PREFIX+"ESTIMATE_EXECUTIONS", -1.0);
							break;
						}
					} // end of switch
				} // end of for
				
				// number_columns : the last index of columnNames/Values
				columnNames[number_columns] = "OBJECT_NAME";
				columnValues[number_columns] = null; 
				             
				// create the plan node and add it to the plan tree
				PlanNode newnode = null;
				// A operatorNode
				newnode = new OperatorNode(id, 
										   parent_id, 
										   pos,
										   operation_name, 
										   columnNames, 
										   columnValues);
//				newnode.setPropertyValue("OPERATION", operation_name);
//Main._logger.outputLog(id + " | " + parent_id + " | " + pos + " | " + operation_name + " | ");
//				// set cost estimates
				newnode.setOpCostEstimates(mapRunStat);
								
				if(tableObjectNeeded){
					String table_name = "";
					String strValues = rs.getString(1).trim().substring(3);
					int maxOccurence = 3;
					int startindex = 0,endindex = 0;
					for (j = 0; j < maxOccurence; j++){
						startindex = strValues.indexOf('[',startindex)+1;
						endindex = strValues.indexOf(']',endindex)+1;
					}
					endindex--;
					if (startindex<strValues.length() && endindex<strValues.length() && startindex <= endindex) {
						table_name = strValues.substring(startindex,endindex);
					}			
					// storing table name into "OBJECT_NAME" column value
					columnValues[number_columns] = table_name;
					// add TableNode List;
					TableNode tblNode = new TableNode(id, 			// node id : default to its parent id
										    		 id, 			// parent id
										    		 pos,			// node position : default to its parent position
										    		 (table_name).toUpperCase(), 
										    		 columnNames, 
										    		 columnValues);
//					tblNode.setPropertyValue("OBJECT_NAME", table_name);
//					//set original TableNode properties to null 
//					for (j = 0; j < columnNames.length; j++) {
//						if (columnNames[j] != null && columnNames[j].compareTo("PARENT_ID") != 0
//								&& columnNames[j].compareTo("POSITION") != 0 
//								&& columnNames[j].compareTo("OBJECT_NAME") != 0
//								&& columnNames[j].compareTo("ID") != 0) {
//							tblNode.setPropertyValue(columnNames[j],null);
//						}
//					}
					tableNodeList.add(tblNode);
				}
				if (newnode != null)
					v_tree.add(newnode);
			} // end of while
			
			int lastPos = Integer.parseInt(pos);
			// finally, add table nodes to v_tree
			addTableNodes(v_tree, tableNodeList, lastPos);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		PlanNode	root	= null;
		PlanNode	pn		= buildTree(root, v_tree);
		return pn;
	}
	
	private void addTableNodes(Vector<PlanNode> vTree, 
							   Vector<TableNode> tableNodeList, int lastPos) {
		// TODO Auto-generated method stub
		for(int i=0;i<tableNodeList.size();i++){
			lastPos++;
			TableNode tblNode = tableNodeList.elementAt(i);
			tblNode.setNodeID(lastPos);
			tblNode.setPosition(lastPos);
//Main._logger.outputLog(tblNode.getNodeID() + " | " + tblNode.getParentID() + " | " + tblNode.getPosition()
//		+ " | " + tblNode.getTableName() + " | ");
			vTree.add(tblNode);
		}
	}

//	private PlanNode createPlanTree(ResultSet rs) {
//		
//		Vector<PlanNode>	v_tree	= new Vector<PlanNode>();
//		
//		int	position = 0;
//		
//		int i,j;
//		
//		String pos;
//		
//		try {
//			ResultSetMetaData	meta 			= rs.getMetaData();
//			int 				number_columns 	= meta.getColumnCount();
//			while (rs.next() ) {
//				String	id;
//				String parid;
//				
//				String 		type=null;
//	
//				String		operation=null;
//				
//				id = new Integer(rs.getInt("NodeId") - 3).toString();
//				
//				//if (id.equals("-2")) {
//				//	parid	= "-1";
//				//} else {
//					
//				if (rs.getInt("Parent") == 1 ) {
//					parid = new Integer(-1).toString();
//				}
//				else {
//					parid = new Integer(rs.getInt("Parent") - 3).toString();
//				}
//				//}
//				
//				String[] columnNames = new String[number_columns + 1];
//				String[] columnValues = new String[number_columns + 1];
//				
//				// Get properties
//				for (i = 0; i < number_columns - PROPERTY_INIT; i++) {
//					columnNames[i] = meta.getColumnName(i + 1 + PROPERTY_INIT);
//					columnValues[i] = rs.getString(i + 1 + PROPERTY_INIT);
//				}
//
//				columnNames[i] = "ID";
//				columnValues[i++] = id;
//
//				columnNames[i] = "PARENT_ID";
//				columnValues[i++] = parid;
//
//				columnNames[i] = "POSITION";
//				pos = new Integer(position).toString();
//				columnValues[i++] = pos;
//
//				columnNames[i] = "OPERATION";
//				columnValues[i++] = null;
//
//				columnNames[i] = "OBJECT_NAME";
//				columnValues[i] = null;
//				
//				String strValues	= rs.getString(1).trim().substring(3);
//				
////				String Operator="Hash Match";
//				//String Table="Table Scan";
//				
////				boolean isTableScan = false;
//				int maxOccurence=3;
//				
//				int startindex = 0,endindex = 0;
//
//				if (columnValues[0] != null && (columnValues[0].equals("Table Scan") )) {
//					// table node
//					type = "TABLE";
//					operation = columnValues[0];
//					
//					operation.trim();
//					
//					for (j = 0; j < maxOccurence; j++)
//					{
//						startindex = strValues.indexOf('[',startindex)+1;
//						endindex = strValues.indexOf(']',endindex)+1;
//					}
//					endindex--;
//				//Main.defaultLogger.logging_normal("startindex:"+startindex+"endindex:"+endindex+"strlen:"+strValues.length());
//					if (startindex<strValues.length() && endindex<strValues.length() && startindex <= endindex) {
//						strValues = strValues.substring(startindex,endindex);
//				//Main.defaultLogger.logging_normal("strValues left:" + strValues);
//					}					
//				} else {
//					// operation node
//					type = "OPERATOR";
//					if (columnValues[0] == null) {
//					//	operation	= columnValues[11];
//						continue;
//					} else {
//						operation = columnValues[0];
//					}
//					
//					operation.trim();
//					
//					strValues=null;
//				}
//
//			    PlanNode	newnode = null;
//			    
//				if (type.equals("OPERATOR")) {
//					//columnNames[i] = "OPERATION";
//					columnValues[--i] = operation;
//					// A operatorNode
//									
//					newnode	= new OperatorNode(id,
//							parid,
//							pos,
//							operation, //operation name
//							//option,
//							//object_name,
//							columnNames,
//							columnValues);
//					// set cost estimates
////	Main.defaultLogger.logging_normal("[OperatorNode]id:"+id+"\tparent_id:"+parid+"\tnode_order:"+pos+"\toperation_name:"+operation);
//	//Main.defaultLogger.logging_normal("object_name:"+object_name+"columnNames:"+columnNames+"columnValues"+columnValues);
//				} else if (type.equals("TABLE")){
//					//columnNames[i] = "OBJECT_NAME";
//					columnValues[i] = strValues;
//					// A TableNode
//					newnode = new TableNode(id,
//							parid,
//							pos,
//							//operation_name,
//							//option,
//							strValues, // table name
//							columnNames,
//							columnValues);
////	Main.defaultLogger.logging_normal("[TableNode]id:"+id+"\tparent_id:"+parid+"\tnode_order:"+pos+"\ttable_name:"+strValues);
//	//Main.defaultLogger.logging_normal("object_name:"+object_name+"columnNames:"+columnNames+"columnValues"+columnValues);
//				}
//				
//				if (newnode != null)
//					v_tree.add(newnode);
//				
//				
//				position++;
//			}
//
//			insertTabScan(v_tree,number_columns);
//		
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//
//		PlanNode	root	= null;
//		PlanNode	pn		= buildTree(root, v_tree);
//		return pn;
//	}
//	
//	private void insertTabScan(Vector<PlanNode> v_tree, int number_columns) {
//		int 		i;
//		//int 		num_nodes = v_tree.size();
//		PlanNode 	current;
//		PlanNode	newnode = null;
//		
//		String		oldid, newid;
//		String 		parid;
//		
//		String 		pos;
//		
//
//		String		operation=null;
//		
//		TableNode 	t;
//
//		int oldmaxid = 0;
//		int tmpid = 0;
//		// get old maximum id
//		for (i = 0; i<v_tree.size(); i++) {
//			current = (PlanNode)v_tree.elementAt(i);
//			tmpid = Integer.parseInt(String.valueOf(current.getNodeID()));
//
//			if (tmpid > oldmaxid) {
//				oldmaxid = tmpid;
//			}
//		
//		}
//				
//		Vector<PlanNode> tmpvtree = new Vector<PlanNode>(v_tree);
//		
////		Main.defaultLogger.logging_normal("old v_tree.size(): " + tmpvtree.size());
//		
//		for (i=0;i<tmpvtree.size(); i++) {
//
//			current	= (PlanNode)tmpvtree.elementAt(i);
//		
//			if (current instanceof TableNode) {
//				// create a new OperatorNode for it
//				t = (TableNode)current;
//				oldid = String.valueOf(t.getNodeID());
//				newid =  new String(new Integer(++oldmaxid).toString());
//				
//				parid = String.valueOf(t.getParentID());
//				pos =  String.valueOf(t.getPosition());
//			//	pos = new String((String)(t.getPropertyValue("ID")));
//				
//				
//				String[] columnNames = new String[number_columns + 1];
//				String[] columnValues = new String[number_columns + 1];
//				
//				operation = "Table Scan";
//				
//				columnNames = t.getProperties();
//				
//				//Main.defaultLogger.logging_normal("columnNames.length: " + columnNames.length);
//				
//				for (int j = 0; j < columnNames.length; j++) {
////					Main.defaultLogger.logging_normal("columnNames["+j+"]" + columnNames[j]);
//					if ( columnNames[j].compareTo("ID") == 0) {
//						columnValues[j] = oldid;
//					}
//					else if (columnNames[j].compareTo("PARENT_ID") == 0) {
//						columnValues[j] = parid;
//					}
//					else if (columnNames[j].compareTo("POSITION") == 0) {
//						columnValues[j] = pos;
//					}
//					else if (columnNames[j].compareTo("OPERATION") == 0) {
//						columnValues[j] = operation;
//					}
//					else if (columnNames[j].compareTo("OBJECT_NAME") == 0) {
//						columnValues[j] = null;
//					}
//					else {
//						columnValues[j] = (String)t.getPropertyValue(columnNames[j]);
//					}
//				}
//
////				Main.defaultLogger.logging_normal("operation: " + operation);
//				
//				newnode	= new OperatorNode(oldid,
//						parid,
//						pos,
//						operation, //operation name
//						//option,
//						//object_name,
//						columnNames,
//						columnValues);
//				
//				if (newnode != null)
//					v_tree.add(newnode);
//				
//				// update original TableNode's parid
//				t.setParentID(Integer.parseInt(oldid));
//				t.setNodeID(Integer.parseInt(newid));
//				t.setPosition(Integer.parseInt(newid));
//				
//				//set original TableNode properties to null 
//				for (int j = 0; j < columnNames.length; j++) {
//					if (columnNames[j] != null && columnNames[j].compareTo("PARENT_ID") != 0
//							&& columnNames[j].compareTo("POSITION") != 0 
//							&& columnNames[j].compareTo("OBJECT_NAME") != 0
//							&& columnNames[j].compareTo("ID") != 0) {
//						t.setPropertyValue(columnNames[j],null);
//					}
//				}
//			}
//		}
//		
////		Main.defaultLogger.logging_normal("new v_tree.size(): " + v_tree.size());
//	}

	/**
	 * Builds a plan tree by ordering the node correctly.  Nodes are ordered by node id such that
	 * a pre-order traversal of the tree will yield the nodes in ascending order.
	 * @param v_tree
	 */
	private PlanNode buildTree(PlanNode root, Vector<PlanNode> v_tree) {
		
		//Vector sorted = new Vector();
		//inserting the root into the sorted list first.
		int num_nodes = v_tree.size();
//Main.defaultLogger.logging_normal("v_tree.size:"+num_nodes);		
		if (num_nodes == 0 || root instanceof TableNode) {
			return root;
		}
		
		if (root == null) {
			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = (PlanNode) v_tree.get(i);
				if (current.getParent() == null) {
					root	= (PlanNode)v_tree.remove(i);
					break;
				}
			}
//Main.defaultLogger.logging_normal("root is null, new root id: " + String.valueOf(root.getPropertyValue("ID")));
//Main.defaultLogger.logging_normal("root is null, new root parid: " + String.valueOf(root.getPropertyValue("PARENT_ID")));
			
			buildTree(root, v_tree);
			
		} else {
			
			int	id		= Integer.parseInt(String.valueOf(root.getNodeID()));
			int	chcount	= 0;
			
			for ( int i = 0; i < num_nodes; i++ ) {
				PlanNode current = (PlanNode) v_tree.get(i);
				int	pid	= Integer.parseInt(String.valueOf(current.getParentID()));
//				Main.defaultLogger.logging_normal("set child, id: " + String.valueOf(current.getPropertyValue("ID")));
//				Main.defaultLogger.logging_normal("set child, parid: " + String.valueOf(current.getPropertyValue("PARENT_ID")));
				if (pid == id) {
					current	= (PlanNode) v_tree.remove(i);
					num_nodes--;
					i--;
					((OperatorNode)root).setChild(chcount++, current);					
				}
			}
			
			int chnum	= ((OperatorNode)root).getChildNumber();
			for ( int j = 0; j < chnum; j++ ) {
				PlanNode	tmpnode	= ((OperatorNode)root).getChild(j);
				buildTree(tmpnode, v_tree);
			}
			
		}
		
		return root;
		
	}
	

	/**
	 * Gets the table statistics from the DBMS.
	 * @param tableName The name of the table
	 * @return A TableStatistic Object that contains important information about the table 
	 * statistics.
	 *
	private TableStatistic getTableStatistics(String tableName) {
		TableStatistic result = new TableStatistic();
		ResultSet ts;
		String stats = "";

		stats =
			"SELECT dpages,rows FROM sysindexes WHERE id=OBJECT_ID('"
				+ tableName.toUpperCase()
				+ "')";
		try {
			//retrieving the statistics from the DBMS.
			ts = _statement.executeQuery(stats);

			if (ts.next()) {
				result.numblocks = ts.getLong(1);
				result.average_row_length = 0;
				result.num_rows = ts.getLong(2);
				result.tableName = tableName;
			} else {
				Main.defaultLogger.logging_error("No statistics for table: " + tableName);
				System.exit(1); //programmer/dbms error
			}
			ts.getStatement().close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main.defaultLogger.logging_error("No statistics for table: " + tableName);
			System.exit(1); //programmer/dbms error
		}

		return result;
	}
	*/
	
	
	 //public void installExperimentTables(DataDefinitionModule myDataDef, String myPrefix, String[] myTables) {
	public void installExperimentTables(DataDefinition myDataDef, String myPrefix) {	
		
		String myTables[] = myDataDef.getTables();
		
			if (Main.verbose)
				Main._logger.outputLog("Installing Tables");

			if (!isInstalled(myPrefix, myTables)) {
				//install(myDataDef);
//				initializeSubjectTables();

				for (int i = 0; i < myTables.length; i++) {
					
//					if (myExpSubject.tableExists(myPrefix + myTables[i])) {
//					Main.defaultLogger.logging_normal("Table " + myPrefix + myTables[i] + " Exists.");
//						myExpSubject.dropTable(myPrefix + myTables[i]);
//						continue;
//					}
					
					//String SQL = "CREATE TABLE " + myPrefix + myTables[i] + "(";
					String[] primary = null;
					ForeignKey[] foreign = null;

					//appending the column information to the CREATE TABLE statement.
					String[] columns = myDataDef.getTableColumns(myTables[i]);
					int[] columnDataTypes = new int[columns.length];
					int[] columnDataTypeLengths = new int[columns.length];
					for (int j = 0; j < columns.length; j++) {
						columnDataTypes[j] = myDataDef.getColumnDataType(myTables[i], columns[j]);
						columnDataTypeLengths[j] = myDataDef.getColumnDataLength(myTables[i], columns[j]);
					}

					//returning the pimary key and foreign key info
					primary = myDataDef.getTablePrimaryKey(myTables[i]);
					foreign = myDataDef.getTableForeignKeys(myTables[i]);
					
					createTable(
						myPrefix + myTables[i],
						columns,
						columnDataTypes,
						columnDataTypeLengths,
						primary,
						foreign );
				}
				
			}

			//commit();
	}
	 
	
	/**
	 * Tests to see if the correct tables are installed.
	 * @see azdblab.labShelf.GeneralDBMS#isInstalled()
	 */
	public boolean isInstalled(String strPrefix, String[] tables) {
		//boolean cache = (tableExists(CACHE1_TABLE) && tableExists(CACHE2_TABLE));

		//for ( int i = 0; i < tables.length; i++ ) {
		//	if (!tableExists(strPrefix + tables[i]))
		//		return false;
		//}
		
		//return cache;
		return false;
	}
	


	
	/**
	 * Sets the table statistics, currently only the cardinality.
	 * @see azdblab.labShelf.GeneralDBMS#setTableStats(java.lang.String, long)
	 */
	public void setVirtualTableCardinality(String tableName, long cardinality, RepeatableRandom repRand) {
		//TableStatistic table;
		
		//if (cardinality > CurrentCardinality){
		//	Main.defaultLogger.logging_error("Create an cardinality exception here: setTableStats@SQLServerAPI"+cardinality+","+ CurrentCardinality);
		//	return;
		//}

		// ID is 0 based
		String	sqldelete	= "DELETE FROM " + tableName + " WHERE id1 >= " + cardinality + ";"; 

		try {
			//for ( long i = this.iRecordNum; i > cardinality; i-- ){
			_statement.executeUpdate(sqldelete);
	
		} catch (SQLException sqlex){
			sqlex.printStackTrace();
		}
	}	
		
//	/**
//	 * Checks to see if a table exists.
//	 * @see azdblab.labShelf.GeneralDBMS#tableExists(java.lang.String)
//	 */
//	public boolean tableExists(String table) {
//		try {
////Main.defaultLogger.logging_normal("tablename*****"+table);
//			//attempts to create the table.  If it fails, the table exists and an exception will be thrown.
//			_statement.executeUpdate("CREATE TABLE " + table + " (Name varchar(1))");
//			//if the table was created, drop it again.
//			_statement.executeUpdate("DROP TABLE " + table);
//			return false;
//		} catch (SQLException e) {
////Main.defaultLogger.logging_normal("return true");
//			return true;
//		}
//	}
	
	public QueryExecutionStat timePreparedQuery(String sqlQuery, PreparedStatement pstmt, PlanNode plan,
			long cardinality, int time_out) throws SQLException, Exception {
		PlanNode curr_plan = getQueryPlan(sqlQuery);
		// verifies that the current query plan is the plan that AZDBLAB thought
		// it // was timing.
		if (!curr_plan.equals(plan)) {
			Main._logger.outputLog("query: " + sqlQuery);
			Main._logger.outputLog("cardinality: " + cardinality);
			Main._logger.outputLog("hash code for a given plan: "
					+ plan.myHashCode());
			Main._logger.outputLog("hash code for a current plan: "
					+ curr_plan.myHashCode());
			throw new Exception(
					"timeQuery: detected plan error.  Tried to time different plan from change point plan");
		}
		long start_time;
		long finish_time;
		long exec_time = 0;
		String proc_diff = "N/A";
//		timeOuter = new TimeoutQueryExecution();
//
//		Timer timer = new Timer();
		try {
			flushDiskDriveCache(Constants.WINDOWS_DUMMY_FILE);
			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
			flushOSCache();
			Main._logger.outputLog("Finish Flushing OS Cache");
			flushDBMSCache();
			Main._logger.outputLog("Finish Flushing DBMS Cache");

//			query_executor_statement = _connection.createStatement();
//			query_executor_statement.setQueryTimeout(900);
//			timer.scheduleAtFixedRate(timeOuter, time_out, time_out);
			// set up timer
			pstmt.setQueryTimeout(900);
			// get processes
			HashMap<Long, ProcessInfo> beforeMap = WindowsProcessAnalyzer.extractProcInfo(WindowsProcessAnalyzer.PRE_QE);

			// get stat
			// start time
			start_time = System.currentTimeMillis();
			// execute time
			pstmt.executeQuery();
			// finish time
			finish_time = System.currentTimeMillis();
			
			// get processes
			HashMap<Long, ProcessInfo> afterMap = WindowsProcessAnalyzer.extractProcInfo(WindowsProcessAnalyzer.POST_QE);

			// do map diff
			proc_diff = WindowsProcessAnalyzer.diffProcMap(WindowsProcessAnalyzer.PLATFORM, 
														 null,	// N/A 
														 null//,  // N/A
														 //beforeMap, 
														 //afterMap
														 );

			// get the time
			exec_time = finish_time - start_time;
//			timer.cancel();
//			timeOuter.cancel();
			
			
		} catch (SQLException e) {
			e.printStackTrace();
			exec_time = Constants.MAX_EXECUTIONTIME;
			Main._logger.outputLog("Execution too long: Execution time set to "
					+ exec_time);
		}
		if (Main.verbose) {
			Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
		}
		return new QueryExecutionStat(exec_time, proc_diff);
	  }
	
	public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan,
			long cardinality, int time_out) throws SQLException, Exception {
		PlanNode curr_plan = getQueryPlan(sqlQuery);
		// verifies that the current query plan is the plan that AZDBLAB thought
		// it // was timing.
		if (!curr_plan.equals(plan)) {
			Main._logger.outputLog("query: " + sqlQuery);
			Main._logger.outputLog("cardinality: " + cardinality);
			Main._logger.outputLog("hash code for a given plan: "
					+ plan.myHashCode());
			Main._logger.outputLog("hash code for a current plan: "
					+ curr_plan.myHashCode());
			throw new Exception(
					"timeQuery: detected plan error.  Tried to time different plan from change point plan");
		}
		String timedQuerySQL = sqlQuery;
		long start_time;
		long finish_time;
		long exec_time = 0;
		String proc_diff = "N/A";
//		timeOuter = new TimeoutQueryExecution();
//
//		Timer timer = new Timer();
		try {
			flushDiskDriveCache(Constants.WINDOWS_DUMMY_FILE);
			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
			flushOSCache();
			Main._logger.outputLog("Finish Flushing OS Cache");
			flushDBMSCache();
			Main._logger.outputLog("Finish Flushing DBMS Cache");

			query_executor_statement = _connection.createStatement();
			// set up timer
			query_executor_statement.setQueryTimeout(900);
//			timer.scheduleAtFixedRate(timeOuter, time_out, time_out);
			
			// get processes
			HashMap<Long, ProcessInfo> beforeMap = WindowsProcessAnalyzer.extractProcInfo(WindowsProcessAnalyzer.PRE_QE);

			// get stat
			// start time
			start_time = System.currentTimeMillis();
			// execute time
			query_executor_statement.executeQuery(timedQuerySQL);
			// finish time
			finish_time = System.currentTimeMillis();
			
			// get processes
			HashMap<Long, ProcessInfo> afterMap = WindowsProcessAnalyzer.extractProcInfo(WindowsProcessAnalyzer.POST_QE);

			// do map diff
			proc_diff = WindowsProcessAnalyzer.diffProcMap(WindowsProcessAnalyzer.PLATFORM, 
														null, 
														null//, 
														//beforeMap, 
														//afterMap
														);

			// get the time
			exec_time = finish_time - start_time;
//			timer.cancel();
//			timeOuter.cancel();
			query_executor_statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
			exec_time = Constants.MAX_EXECUTIONTIME;
			Main._logger.outputLog("Execution too long: Execution time set to "
					+ exec_time);
		}
		if (Main.verbose) {
			Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
		}
		return new QueryExecutionStat(exec_time, proc_diff);
	  }
	  
//	/**
//	 * @see azdblab.labShelf.GeneralDBMS#timeQuery(java.lang.String, azdblab.dbms.api.PlanTree)
//	 */
//	public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan, long cardinality, int time_out) throws SQLException, Exception {
//		Main._logger.outputLog("\nIn time query....");
//		
//		// close existing connection.
//		//close();
//		
//		PlanNode curr_plan = getQueryPlan(sqlQuery);
//		//verifies that the current query plan is the plan that AZDBLab thought it was timing.
//		if (!curr_plan.equals(plan)) {
//			Main._logger.outputLog("query: " + sqlQuery);
//			Main._logger.outputLog("cardinality: " + cardinality);
//			Main._logger.outputLog("hash code for a given plan: " + plan.myHashCode());
//			Main._logger.outputLog("hash code for a current plan: " + curr_plan.myHashCode());
//			throw new Exception("timeQuery: detected plan error.  Tried to time different plan from change point plan");
//		}
//
//		String timedQuerySQL = sqlQuery;
//
//		long 	start_time;
//		long	finish_time; 
//		long	exec_time	= 0;
//		String proc_diff = "N/A";
//		
//		timeOuter = new TimeoutQueryExecution();
//		Timer timer = new Timer();
//		Main._logger.outputLog("Begin to time the current query");
//		try {
////			flushCache();
////			flushMemory();
////			Main.defaultLogger.logging_normal("Finish Clearing Memory");
//			
//			
////			ProcessTeller process_teller = new ProcessTeller();
//			Main._logger.outputLog("Start Timing query");
//			
//			start_time = System.currentTimeMillis();
//			
////			Map<Integer, WindowsProcess> proc_map1 = process_teller.GetProcesses();
////		    long num_processes1 = process_teller.GetNumProcesses();
//		    
//			_statement.execute(timedQuerySQL);
//			
////			Map<Integer, WindowsProcess> proc_map2 = process_teller.GetProcesses();
////		    long num_processes2 = process_teller.GetNumProcesses();
//			
//			finish_time = System.currentTimeMillis();
////			proc_diff = ProcessTeller.ProcessMapDiff(num_processes1, 
////												   num_processes2, 
////												   proc_map1, 
////												   proc_map2);
//			exec_time = finish_time - start_time;
//
//			timer.cancel();
//		} catch (SQLException e) {
//			exec_time	= MetaData.MAX_EXECUTIONTIME;
//			Main._logger.outputLog("Execution too long: Execution time set to " + exec_time);
//			timer.cancel();
//		}finally{
//		}
//		Main._logger.outputLog("Finished timing the query");
//		if (Main.verbose) {
//			Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
//		}
//
//		//return new QueryStat(minimum_execution_time);
//		return new QueryExecutionStat(exec_time, proc_diff);
//	}
	
	public String getDBVersion(){
		try {
			ResultSet	rs	= _statement.executeQuery("SELECT @@VERSION");
			
			rs.next();
			
			return rs.getString(1);
		} catch (SQLException e) {
			return null;
		}
	}
		
	public String[] getPlanProperties() {
		return PLAN_TABLE_PROPERTIES;
	}

	public String[] getPlanOperators() {
		return PLAN_OPERATORS;
	}
	
	
	public void setOptimizerFeature(String featureName, String featureValue) {
		String		strTruncateLog	= "backup log DBResearch with truncate_only";
		try {
			_statement.execute(strTruncateLog);
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}
	
	public void flushDBMSCache() {
		try {
//			String strFlush1 = "GRANT EXECUTE ON DBO.FREEPROCCACHE TO AZDBLAB_USER";
//			_statement.execute(strFlush1);
//			commit();
//			strFlush1 = "GRANT EXECUTE ON DBO.DROPCLEANBUFFERS TO AZDBLAB_USER";
//			_statement.execute(strFlush1);
//			commit();
			String strFlush = "DBCC FREEPROCCACHE";
			_statement.execute(strFlush);
			commit();
			strFlush = "DBCC DROPCLEANBUFFERS";
			_statement.execute(strFlush);
			commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}
		
	public void flushOSCache() { 
		flushWindowsCache(); 
	}
	
	/**
	 * A constant used to specifiy the size of the buffer that is used to move data between a CLOB and file or vice versa.
	 */
	//private static final int BUFFER_SIZE = 1024;

	/**
	 * The name of the first cache table.
	 */
	//private static final String CACHE1_TABLE = AZDBLAB.TABLE_PREFIX + "CACHE_1";
	/**
	 * The name of the second cache table.
	 */
	//private static final String CACHE2_TABLE = AZDBLAB.TABLE_PREFIX + "CACHE_2";

	/**
	 * The office name of the CLOB
	 */
	private static final String IMAGE = "IMAGE";
	/**
	 * The CREATE TABLE statement for the first cache table
	 */
	//private static final String CREATE_CACHE1_TABLE =
	//	"CREATE TABLE "
	//		+ CACHE1_TABLE
	//		+ "(id1 INT, id2 INT, id3 INT, id4 INT, id5 INT, id6 INT, id7 INT, id8 INT, id9 INT, id10 INT, id11 INT, id12 INT, id13 INT, id14 INT, id15 INT)";
	/**
	 * The CREATE TABLE statement for the second cache table.
	 */
	//private static final String CREATE_CACHE2_TABLE =
	//	"CREATE TABLE "
	//		+ CACHE2_TABLE
	//		+ "(id1 INT, id2 INT, id3 INT, id4 INT, id5 INT, id6 INT, id7 INT, id8 INT, id9 INT, id10 INT, id11 INT, id12 INT, id13 INT, id14 INT, id15 INT)";
	
	//private static final String DROP_CACHE1_TABLE =
	//	"DROP TABLE " + CACHE1_TABLE;
	
	//private static final String DROP_CACHE2_TABLE =
	//	"DROP TABLE " + CACHE2_TABLE;
	
	
	/**
	 * An array of operators specified in SQL Server
	 */
	public static final String[] PLAN_OPERATORS	= 
		new String[] {
		"AGGREGATE",
		"ASSERT",
		"BITMAP",
		"CLUSTERED INDEX DELETE",
		"CLUSTERED INDEX INSERT",
		"CLUSTERED INDEX SCAN",
		"CLUSTERED INDEX SEEK",
		"CLUSTERED INDEX UPDATE",
		"COLLAPSE",
		"COMPUTE SCALAR",
		"CONCATENATION",
		"HASH MATCH",
		"HASH MATCH TEAM",
		"INSERTED SCAN",
		"LOG ROW SCAN",
		"MERGE INTERVAL",
		"MERGE JOIN",
		"NESTED LOOPS",
		"NONCLUSTERED INDEX UPDATE",
		"NONCLUSTERED INDEX SPOOL",
		"NONCLUSTERED INDEX SEEK",
		"NONCLUSTERED INDEX SCAN",
		"NONCLUSTERED INDEX INSERT",
		"NONCLUSTERED INDEX DELETE",
		"ONLINE INDEX INSERT",
		"PARALLELISM",
		"PARAMETER TABLE SCAN",
		"REMOTE DELETE",
		"REMOTE INSERT",
		"REMOTE UPDATE",
		"REMOTE SCAN",
		"REMOTE UPDATE",
		"RID LOOKUP",
		"ROW COUNT SPOOL",
		"SEGMENT",
		"SEQUENCE",
		"SEQUENCEPROJECT",
		"SORT",
		"SPLIT",
		"STREAM AGGREGATE",
		"SWITCH",
		"TABLE DELETE",
		"TABLE INSERT",
		"TABLE SCAN",
		"TABLE SPOOL",
		"TABLE UPDATE",
		"TABLE-VALUED FUNCTION",
		"TOP",
		"UDX",
		"CURSOR LOGICAL AND PHYSICAL SHOWPLAN OPERATORS"
	};
	
	
	public static final String[] PLAN_TABLE_PROPERTIES =
		new String[] {
			"PHYSICALOP",
			"LOGICALOP",
			"ARGUMENT",
			"DEFINEDVALUES",
			"ESTIMATEROWS",
			"ESTIMATEIO",
			"ESTIMATECPU",
			"AVGROWSIZE",
			"TOTALSUBTREECOST",
			"OUTPUTLIST",
			"WARNINGS",
			"TYPE",
			"PARALLEL",
			"ESTIMATEEXECUTIONS"};
	
	/**
	 * The SQL CREATE TABLE statement that will create the PLAN_TABLE.
	 */

	/**
	 * The name of the table that stores which tables have been created by AZDBLab.
	 */
	//private static final String EXPERIMENT_RECORD_TABLE = AZDBLab.TABLE_PREFIX + "TABLE_RECORD";
	
	/**
	 * The SQL CREATE TABLE statement that will create the RECORD_TABLE TABLE.
	 */
//	private static final int STATEMENT_TEXT_INDEX = 1;
//	private static final int STATEMENT_ID_INDEX = 2;
	private static final int NODE_INDEX = 3;
	private static final int PARENT_INDEX = 4;
	private static final int PHYSICAL_OP_INDEX = 5;
//	private static final int LOGICAL_OP_INDEX = 6;
//	private static final int ARGUMENT_INDEX = 7;
//	private static final int DEFINED_VALUES_INDEX = 8;
	private static final int ESTIMATE_ROWS_INDEX = 9;
	private static final int ESTIMATE_IO_INDEX = 10;
	private static final int ESTIMATE_CPU_INDEX = 11;
	private static final int AVG_ROW_SIZE_INDEX = 12;
	private static final int TOTAL_SUBTREE_COST_INDEX = 13;
//	private static final int OUTPUT_LIST_INDEX = 14;
//	private static final int WARNINGS_INDEX = 15;
//	private static final int TYPE_INDEX = 16;
//	private static final int PARALLEL_INDEX = 17;
	private static final int ESTIMATE_EXECUTIONS_INDEX = 18;
	
//	/**
//	 * The index of the id for the cache tables.
//	 */
//	private static final int ID_INDEX = 0;
//	/**
//	 * The index of the column in the cache tables that are used for ordering.
//	 */
//	private static final int NODE_ORDER_INDEX = 2;
//
//	/**
//	 * The index of the column that has the object name for the plan_table.
//	 */
//	private static final int OBJECT_NAME_INDEX = 3;
//	/**
//	 * The index of the column that has the operation name for the plan_table.
//	 */
//	private static final int OPERATION_NAME_INDEX = 4;
//
//	/**
//	 * The index of the column that has the parent id for the plan_table.
//	 */
//	private static final int PARENT_ID_INDEX = 1;
//	
//	/**
//	 * The index of the column that has the object type for the plan_table.
//	 */
//	private static final int OBJECT_TYPE_INDEX = 5;
//
	/**
	 * The name of the character data type.
	 */
	/**
	 * The name of the data type to store integer numbers .
	 */
	private static final String INT = "INT";
	
	/**
	 * The name of the character data type.
	 */
	private static final String VARCHAR = "VARCHAR";
	/**
	 * A reference to the connect string that was passed in upon creation of this object.
	 */
	//private String myConnectString;
	/**
	 * A reference to the JDBCWrapper used to communicate with the DBMS.
	 */
	//private JDBCWrapper _statement;
	/**
	 * A cache of the last timed table's column statistics.
	 */
	//private Vector myLastColumnStats;
	/**
	 * A cache of the last timed table's table statistics.
	 */
	//private TableStatistic myLastTableStat;
	

	/*************************************NEW**********************************/
	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}
	
	
	private static final String DBMS_DRIVER_CLASS_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	private static final String	DBMS_NAME	= "SqlServer";
	private static final String COST_MODEL_PREFIX = "SS_";

	public void SetStatement(Statement stmt){
		_statement = stmt;
	}
	public void SetConnection(Connection connection){
		_connection = connection;
	}
	
	@Override
	public void deleteRows(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public ResultSet executeQuerySQL(String sql) {
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
	public ResultSet executeSimpleQuery(String tableName,
			String[] selectColumns, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
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
	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
	/************************************END NEW**********************************/
}
