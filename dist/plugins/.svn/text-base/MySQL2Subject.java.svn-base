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

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Random;
import java.util.StringTokenizer;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.procmonitor.ProcMonitorException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.TableNode;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Table;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.utility.procdiff.LinuxProcessAnalyzer;
import azdblab.utility.procdiff.StatInfo;

/**
 * 
 *
 */
public class MySQL2Subject extends ExperimentSubject {

	protected class TimeoutQueryExecutionMySQL extends TimerTask {
		public TimeoutQueryExecutionMySQL() {
		}

		public void run() {
			try {
				Statement tmp_stmt = _connection.createStatement();
				// tmp_stmt.execute("KILL QUERY " +
				// ((com.mysql.jdbc.Connection)_connection).shutdownServer())
				tmp_stmt.cancel();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
	}

	private static final String COST_MODEL_PREFIX = "MY_";

	TimeoutQueryExecutionMySQL mysql_timeOuter;

	/**
	 * 
	 * @param user_name
	 * @param password
	 * @param connect_string
	 */
	public MySQL2Subject(String user_name, String password, String connect_string, String machineName) {
		super(user_name, password, connect_string, machineName);
	}

	/**
	 * 
	 * @param connect_string
	 */
	// public MySQLSubject(String connect_string) {
	// super(connect_string);
	// strUserName = "ruizhang";
	// strPassword = "ineedmoney";
	// strConnectString = "jdbc:mysql://sodb4.cs.arizona.edu/AZDBLAB";
	// }

	public void setConnection(Connection conn) {
		// TODO Auto-generated method stub
		_connection = conn;
	}

	public void SetStatement(Statement stmt) {
		_statement = stmt;
	}

	// public String getExperimentSubjectName() {
	// return "MySQLSubject";
	// }

	public String getDBMSName() {
		return DBMS_NAME;
	}

	// public static String getName(){
	// return DBMS_NAME;
	// }

	public void deleteHelperTables() {
	}

	/**
	 * 
	 */
	public void copyTable(String newTable, String oriTable) throws Exception{

		try {

			if (tableExists(newTable)) {
				_statement.executeUpdate("DROP TABLE " + newTable);
				commit();
			}

			String cloneSQL = "CREATE TABLE " + newTable + " AS SELECT * FROM "
					+ oriTable;

			_statement.executeUpdate(cloneSQL);

			// Main._logger.outputLog("Clone table finished!");

		} catch (SQLException sqlex) {
			close();			
//			sqlex.printStackTrace();
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

			String cloneSQL = "CREATE TABLE " + newTable + " AS SELECT * FROM "
					+ oriTable + " WHERE id1 < " + cardinality;

			_statement.executeUpdate(cloneSQL);

			// Main._logger.outputLog("Clone table finished!");

		} catch (SQLException sqlex) {
			close();			
//			sqlex.printStackTrace();
			throw new Exception(sqlex.getMessage());
		}

	}

	@Override
	public void dropAllInstalledTables() {
		// TODO Auto-generated method stub
		String sql = "SELECT TABLE_NAME FROM information_schema.TABLES where TABLE_SCHEMA = 'AZDBLAB'";
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
				dropTable(tblName);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void printTableStat(String tableName) {
		String countSQL = "SELECT count(*) " + "FROM " + tableName;

		String statSQL = "SELECT table_rows, "
				+ "data_length, "
				+ "max_data_length, "
				+ "avg_row_length "
				+ "FROM information_schema.TABLES where TABLE_SCHEMA = 'AZDBLAB' and TABLE_NAME = '"
				+ tableName + "'";

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
			if (ts.next()) {
				Main._logger.outputLog("tableName: " + tableName.toUpperCase());
				Main._logger.outputLog("table_rows: " + ts.getLong(1));
				Main._logger.outputLog("In-memory data resourse usage: "
						+ ts.getLong(2));
				Main._logger.outputLog("Disk data resourse usage: "
						+ ts.getLong(3));
				Main._logger.outputLog("avg_row_length: " + ts.getLong(4));
			} else {
				Main._logger.reportError("No statistics for table: "
						+ tableName);
				System.exit(1);
			}
			ts.close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main._logger.reportError("exception-No statistics for table: "
					+ tableName);
			System.exit(1); // programmer/dbms error
		}

	}

	public void updateTableStatistics(Table table) {
		String tableName = table.table_name_with_prefix;
		String sqlUpdateStatistics = "ANALYZE TABLE " + tableName;
		try {
			_statement.executeUpdate(sqlUpdateStatistics);
			commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

	}

	/**
	 * Given AZDBLAB's integer represenation of a data type, this produces a
	 * representation of the data type.
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
			return NUMBER + "(" + length + ")";
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
			// problem with xml schema. should have been caught
			return null;
		}
		}
	}

	/**
	 * Returns a query plan for this SQL query.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#getQueryPlan(java.lang.String)
	 */
	public PlanNode getQueryPlan(String sql) throws Exception {
		// String empty_plan = "DELETE FROM " + QUERY_PLAN_TABLE;
		// String select_plan = "SELECT ";
		// for (int i = 0; i < PLAN_TABLE_COLUMNS.length; i++) {
		// select_plan += PLAN_TABLE_COLUMNS[i];
		// if (i == PLAN_TABLE_COLUMNS.length - 1)
		// break;
		// select_plan += ", ";
		// }

		// select_plan += " FROM " + QUERY_PLAN_TABLE;
		String explain_plan = "EXPLAIN " + sql;
		ResultSet rs;

		Vector<String> vecDetail = new Vector<String>();

		try {
			// remove old query plan
			// _statement.executeUpdate(empty_plan);
			// myJDBCWrapper.commit();
			// ask oracle to provide the new query plan

			rs = _statement.executeQuery(explain_plan);

			// Statement newstatement = _connection.createStatement();

			rs.afterLast();

			/*
			 * Conversion
			 */
			int id = 0;
			int parid = -1;
			int position = 0;

			String tabletype = "TABLE";
			String operatortype = "OPERATOR";

			// int count = 0;

			while (rs.previous()) {

				String strValues = null;

				/*
				 * strValues = rs.getLong(1) * 10 + "," + id + "," + parid + ","
				 * + position + "," + "''" + "," + "''" + "," + "'" +
				 * rs.getString(4) + "'" + "," + "''" + "," + "''" + "," + + 0 +
				 * "," + "''" + "," + + 0 + "," + "''" + "," + "'" +
				 * operatortype + "'";
				 */
				String strOp = rs.getString(4);
				if (strOp.equalsIgnoreCase("ALL")) {
					strOp = "ALL:Full Table Scan";
				}
				
				String extra = rs.getString(10);
				String oper_details = "";
				if(extra != null && !(extra.equalsIgnoreCase(""))) {
					StringTokenizer st = new StringTokenizer(extra, ";");
					int numTokens = st.countTokens();
					for(int i=0;i<numTokens;i++){
						oper_details += " + ";
						oper_details += (st.nextToken()).trim();
					}
				}
				
				if(oper_details.contains("join")){
					strOp += " with Join ";
				}
				
				strValues = rs.getLong(1) * 10 + "," + id + "," + parid + ","
						+ position + "," + "" + "," + // 2
						"" + "," + // 3
						"" + strOp + "," + // 4
						"" + "," + // 5
						"" + "," + // 6
						+0 + "," + // 7
						"" + "," + // 8
						+rs.getLong(9) + "," + // 9
						"" + "," + // 10
						"" + operatortype;

				// Main.defaultLogger.logging_normal("full values: " +
				// strValues);

				// _statement.executeUpdate("INSERT INTO PLAN_TABLE VALUES (" +
				// strValues + ")");
				// newstatement.executeUpdate("INSERT INTO PLAN_TABLE VALUES ("
				// + strValues + ")");

				vecDetail.add(strValues);

				id++;
				position++;

				if (parid == -1) {
					parid = 0;
				} else {
					parid += 2;
				}

				/*
				 * strValues = rs.getLong(1) + "," + id + "," + parid + "," +
				 * position + "," + "'" + rs.getString(2) + "'" + "," + "'" +
				 * rs.getString(3) + "'" + "," + "'" + rs.getString(4) + "'" +
				 * "," + "'" + rs.getString(5) + "'" + "," + "'" +
				 * rs.getString(6) + "'" + "," + + rs.getInt(7) + "," + "'" +
				 * rs.getString(8) + "'" + "," + + rs.getLong(9) + "," + "'" +
				 * rs.getString(10) + "'" + "," + "'" + tabletype + "'";
				 */

				strValues = rs.getLong(1) + "," + id + "," + parid + ","
						+ position + "," + rs.getString(2)
						+ ","
						+ rs.getString(3)
						+ ","
						+
						// rs.getString(4) + "," +
						strOp + "," + rs.getString(5) + "," + rs.getString(6)
						+ "," + rs.getInt(7) + "," + rs.getString(8) + ","
						+ rs.getLong(9) + "," + rs.getString(10) + ","
						+ tabletype;

				// _statement.executeUpdate("INSERT INTO PLAN_TABLE VALUES (" +
				// strValues + ")");
				// newstatement.executeUpdate("INSERT INTO PLAN_TABLE VALUES ("
				// + strValues + ")");

				vecDetail.add(strValues);

				id++;
				position++;

			}

		} catch (SQLException e1) {
			e1.printStackTrace();
			// throw new Exception(empty_plan + "\n" + explain_plan, e1);
		}

		PlanNode result = null;

		/*
		 * try {
		 * 
		 * 
		 * // execute the explain first, // CONVERT and put the result into
		 * plan_table as in oracle result storeage. // Then retrieve the result
		 * from plan_table // //extracting the query plan from the DBMS //rs =
		 * _statement.executeQuery(select_plan); //rs =
		 * myRS.getQueryPlanFromTable(select_plan); //building an Oracle Plan
		 * Tree result = createPlanTree(rs); //rs.getStatement().close(); }
		 * catch (SQLException sqlex) { sqlex.printStackTrace(); //throw new
		 * Exception(select_plan, e); }
		 */

		result = createPlanTree(vecDetail);

		return result;
	}

	private PlanNode createPlanTree(Vector<String> vecDetail) {

		Vector<PlanNode> v_tree = new Vector<PlanNode>();

		int numOps = 0;
		// For each tuple or plan step in the query plan do the following
		for (int i = 0; i < vecDetail.size(); i++) {

			String[] meta = vecDetail.get(i).split(",");
			int number_columns = meta.length;

			String id = null, parent_id = null, node_order = null, operation_name = null,
			// option = null,
			object_name = null, numOfRows = null;

			String object_type = null;

			String[] columnNames = new String[number_columns];
			String[] columnValues = new String[number_columns];
			HashMap<String, Double> mapRunStat = new HashMap<String, Double>();
			// for each column of this tuple
			for (int j = 0; j < number_columns; j++) {
				// Read a value from the ith + 1 column
				String tempValue = meta[j];
				if (tempValue != null) {
					tempValue = tempValue.trim();
				} else {
					tempValue = "";
				}
				// filling in the value and name of each column. This is used by
				// the Plan Node for
				// the other info field.
				// columnNames[i] = meta.getColumnName(i + 1);
				columnNames[j] = PLAN_DETAIL_FIELDS[j];
				columnValues[j] = tempValue;
				// if the column is one of the special columns, record its value
				switch (j) {

				case MySQL2Subject.OPERATION_NAME_INDEX: {
					operation_name = tempValue;
					break;
				}
				case MySQL2Subject.ROW_INDEX: {
					numOfRows = tempValue;
					if (numOfRows != null)
						mapRunStat.put(COST_MODEL_PREFIX + "ROWS",
								Double.parseDouble(numOfRows));
					else
						mapRunStat.put(COST_MODEL_PREFIX + "ROWS", -1.0);
					break;
				}
				case MySQL2Subject.OPTION_INDEX: {
					// option = tempValue;
					break;
				}
				case MySQL2Subject.OBJECT_NAME_INDEX: {
					object_name = tempValue;
					break;
				}
				case MySQL2Subject.ID_INDEX: {
					id = tempValue;
					break;
				}
				case MySQL2Subject.PARENT_ID_INDEX: {
					parent_id = tempValue;
					break;
				}
				case MySQL2Subject.NODE_ORDER_INDEX: {
					node_order = tempValue;
					break;
				}
				case MySQL2Subject.OBJECT_TYPE_INDEX: {
					object_type = tempValue;
					break;
				}
				}

			}
			// create the plan node and add it to the plan tree
			PlanNode newnode = null;

			if (object_type.equals("OPERATOR")) {
				numOps++;

				// A operatorNode
				newnode = new OperatorNode(id, parent_id, node_order,
						operation_name, columnNames, columnValues);
				newnode.setOpCostEstimates(mapRunStat);
			} else if (object_type.equals("TABLE")) {
				// A TableNode
				newnode = new TableNode(id, parent_id, node_order, object_name,
						columnNames, columnValues);
			}
			if (newnode != null)
				v_tree.add(newnode);
		}

		PlanNode root = null;

		PlanNode pn = buildTree(root, v_tree);
		return pn;
	}

	/**
	 * Builds a plan tree by ordering the node correctly. Nodes are ordered by
	 * node id such that a pre-order traversal of the tree will yield the nodes
	 * in ascending order.
	 * 
	 * @param v_tree
	 */
	protected PlanNode buildTree(PlanNode root, Vector<PlanNode> v_tree) {

		// inserting the root into the sorted list first.
		int num_nodes = v_tree.size();

		if (num_nodes == 0 || root instanceof TableNode) {
			return root;
		}

		if (root == null) {

			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = (PlanNode) v_tree.get(i);
				if (current.getParent() == null) {
					root = (PlanNode) v_tree.remove(i);
					break;
				}
			}
			buildTree(root, v_tree);

		} else {

			int id = Integer.parseInt(String.valueOf(root.getNodeID()));
			int chcount = 0;

			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = (PlanNode) v_tree.get(i);
				int pid = Integer
						.parseInt(String.valueOf(current.getParentID()));
				if (pid == id) {
					current = (PlanNode) v_tree.remove(i);
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

		}

		return root;

	}

	/**
	 * Gets the table statistics from the DBMS.
	 * 
	 * @param tableName
	 *            The name of the table
	 * @return A TableStatistic Object that contains important information about
	 *         the table statistics.
	 * 
	 *         private TableStatistic getTableStatistics(String tableName) {
	 *         TableStatistic result = new TableStatistic(); ResultSet ts;
	 *         String stats = ""; //try { //Have oracle gather correct
	 *         statistics. //myJDBCWrapper.executeUpdate("ANALYZE TABLE " +
	 *         tableName + " COMPUTE STATISTICS"); //
	 *         myJDBCWrapper.executeUpdate("ANALYZE TABLE " + tableName +
	 *         " COMPUTE STATISTICS"); //} catch (SQLException e1) { //
	 *         Main.defaultLogger
	 *         .logging_error("No statistics computed for table: " + tableName);
	 *         // e1.printStackTrace(); // System.exit(1); //programmer/dbms
	 *         error //} //USER_TABLES is an oracle view which can be queried to
	 *         gather statistics. //stats = //
	 *         "SELECT Blocks, Avg_Row_Len, Num_Rows FROM USER_TABLES WHERE Table_Name = '"
	 *         // + tableName.toUpperCase() // + "'";
	 * 
	 *         stats =
	 *         "SELECT AVG_ROW_LENGTH, TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '"
	 *         + tableName.toUpperCase() + "'";
	 * 
	 *         try { //retrieving the statistics from the DBMS. ts =
	 *         _statement.executeQuery(stats);
	 * 
	 *         if (ts.next()) { result.numblocks = 0;//ts.getLong(1);
	 *         result.average_row_length = ts.getLong(1); result.num_rows =
	 *         ts.getLong(2); result.tableName = tableName; } else {
	 *         Main.defaultLogger.logging_error("No statistics for table: " +
	 *         tableName); System.exit(1); //programmer/dbms error }
	 *         //ts.getStatement().close(); } catch (SQLException e) {
	 *         e.printStackTrace();
	 *         Main.defaultLogger.logging_error("No statistics for table: " +
	 *         tableName); System.exit(1); //programmer/dbms error }
	 * 
	 *         return result; }
	 */

	public void installExperimentTables(DataDefinition myDataDef,
			String myPrefix) {

		if (Main.verbose)
			Main._logger.outputLog("Installing Tables");

		String[] myTables = myDataDef.getTables();

		if (!isInstalled(myPrefix, myTables)) {
			// initializeSubjectTables(); // do nothing
			for (int i = 0; i < myTables.length; i++) {

				String[] primary = null;
				ForeignKey[] foreign = null;

				// appending the column information to the CREATE TABLE
				// statement.
				String[] columns = myDataDef.getTableColumns(myTables[i]);
				int[] columnDataTypes = new int[columns.length];
				int[] columnDataTypeLengths = new int[columns.length];
				for (int j = 0; j < columns.length; j++) {
					columnDataTypes[j] = myDataDef.getColumnDataType(
							myTables[i], columns[j]);
					columnDataTypeLengths[j] = myDataDef.getColumnDataLength(
							myTables[i], columns[j]);
				}

				// returning the pimary key and foreign key info
				primary = myDataDef.getTablePrimaryKey(myTables[i]);
				foreign = myDataDef.getTableForeignKeys(myTables[i]);

				createTable(myPrefix + myTables[i], columns, columnDataTypes,
						columnDataTypeLengths, primary, foreign);

				// commit();

			}

		}

		// commit();
	}

	/**
	 * Tests to see if the correct tables are installed.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#isInstalled()
	 */
	private boolean isInstalled(String strPrefix, String[] tables) {
		/*
		 * boolean cache = (tableExists(CACHE1_TABLE) &&
		 * tableExists(CACHE2_TABLE)); //boolean plan =
		 * tableExists(QUERY_PLAN_TABLE);
		 * 
		 * for ( int i = 0; i < tables.length; i++ ) { if
		 * (!tableExists(strPrefix + tables[i])) return false; }
		 * 
		 * return cache;
		 */
		return false;
	}

//	public boolean tableExists(String tableName){
//		try {
//			// attempts to create the table. If it fails, the table exists and
//			// an exception will be thrown.
//			_statement.executeUpdate("CREATE TABLE " + tableName
//					+ " (Name char(1))");
//			commit();
//			// if the table was created, drop it again.
//			_statement.executeUpdate("DROP TABLE " + tableName);
//			commit();
//			return false;
//		} catch (SQLException e) {
//			String errMsg = (e.getMessage()).toLowerCase();
//			if(!(errMsg.contains("already") 
//			  || errMsg.contains("exist") 
//			  || errMsg.contains("creat"))){ // this is not a real error!
////				e.printStackTrace();
//				Main._logger.reportError(e.getMessage());
//			}
//			if(_statement == null){
//				reset();
//			}
//			else{
//				commit();
//			}
//			return true;
//		}
//  }
	

	@Override
	public void flushDBMSCache() {
		try {
			/***
			 * Young:
			 * In MySQL 5.6.5, a non-root user, say azdblab_user, can flush tables.
			 * To permit it, log in as root to MySQL monitor.
			 *  
			 * GRANT RELOAD ON *.* TO 'azdblab_user'@'localhost'; 
			 * flush priviledges;
			 */
			/**
			 * "FLUSH TABLES" command need to be executed by root. Thus, a
			 * separation connection for root is made to do that.
			 * 
			 * What "FLUSH TABLES" does is to close all open tables, force all
			 * tables in use to be closed, and flush the query cache. FLUSH
			 * TABLES also removes all query results from the query cache, like
			 * the RESET QUERY CACHE statement. For more details, see
			 * http://dev.mysql.com/doc/refman/5.1/en/flush.html
			 * GRANT ALL PRIVILEGES ON *.* TO 'azdblab_user@%' IDENTIFIED BY 'azdblab_user' WITH GRANT OPTION;
			 * GRANT RELOAD ON *.* TO 'azdblab_user'@'localhost';
			 */
//			Connection conn = DriverManager.getConnection(getMachineName(),
//					"root", "QCEvU5V5");
//			conn.setAutoCommit(false);
//			Statement stmt = conn.createStatement();
//			String strFlush = "FLUSH TABLES";
//			stmt.execute(strFlush);
//			conn.commit();
//			stmt.close();
//			conn.close();
			_statement.executeUpdate("FLUSH TABLES");
			_connection.commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	public void flushOSCache() {
		flushLinuxCache();
	}

	/**
	 * @see azdblab.plugins.experimentSubject#timeQuery() 
	 * As MySQL does not properly support setQueryTimeOut(), we stick to the old method using
	 * a timer thread to handle timeout.
	 */
	public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan,
			long cardinality, int time_out) throws SQLException, Exception {
		PlanNode curr_plan = getQueryPlan(sqlQuery);
		// verifies that the current query plan is the plan that AZDBLAB thought
		// it was timing.
		if (!curr_plan.equals(plan)) {
			Main._logger.outputLog("query: " + sqlQuery);
			Main._logger.outputLog("cardinality: " + cardinality);
			Main._logger.outputLog("hash code for a given plan: "
					+ plan.myHashCode());
			Main._logger.outputLog("a given plan: " + plan.toString());
			Main._logger.outputLog("hash code for a current plan: "
					+ curr_plan.myHashCode());
			Main._logger.outputLog("a current plan: " + curr_plan.toString());
			throw new Exception(
					"timeQuery: detected plan error.  Tried to time different plan from change point plan");
		}
		Main._logger.outputLog("Time out for MySQL is : " + Constants.EXP_TIME_OUT_MS + " (msecs)");
		String timedQuerySQL = sqlQuery;
		long start_time;
		long finish_time;
		long exec_time = 0;
		String proc_diff = "";
		timeOuter = new TimeoutQueryExecution();

		Timer timer = new Timer();
		// process monitor
		Process procMon = null;
		// overall stat
		StatInfo beforeStat = null, afterStat = null;
		try {
			flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
			flushOSCache();
			Main._logger.outputLog("Finish Flushing OS Cache");
			flushDBMSCache();
			Main._logger.outputLog("Finish Flushing DBMS Cache");
			// create a statement to execute the query
			query_executor_statement = _connection.createStatement();
			// set up time out thread
			timer.scheduleAtFixedRate(timeOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
			
//			// get processes
//			HashMap<Long, ProcessInfo> beforeMap = LinuxProcessAnalyzer
//					.extractProcInfo(LinuxProcessAnalyzer.PRE_QE);
//			// // get cpu stat
//			// StatInfo beforeStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// // get max pid
//			// beforeStat.set_max_pid(LinuxProcessAnalyzer.getMaxPID());
//			StatInfo beforeStat = LinuxProcessAnalyzer.getStatInfo();
//			// start time
//			start_time = System.currentTimeMillis();
//			// execute the query
//			query_executor_statement.executeQuery(timedQuerySQL);
//			// finish time
//			finish_time = System.currentTimeMillis();
//			// // get max pid
//			// long max_pid = LinuxProcessAnalyzer.getMaxPID();
//			// // get cpu stat
//			// StatInfo afterStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// // set max pid
//			// afterStat.set_max_pid(max_pid);
//			StatInfo afterStat = LinuxProcessAnalyzer.getStatInfo();
//			// get processes
//			HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer
//					.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
//			// do map diff
//			proc_diff = LinuxProcessAnalyzer.diffProcMap(
//					LinuxProcessAnalyzer.PLATFORM, beforeStat, afterStat//,
//					//beforeMap, afterMap
//					);
//			// get the time
//			exec_time = finish_time - start_time;
			
			// start process monitor
			int portNum = ((new Random()).nextInt(10000))+7000;
			procMon = runProcMonitor(portNum);
			
			// proc monitor timeouter 
			TimeoutProcMonitor procMonTimeOuter = new TimeoutProcMonitor(procMon);
			Timer procMonTimer = new Timer();
			procMonTimer.scheduleAtFixedRate(procMonTimeOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
			
			boolean runningOnVM = !azdblab.executable.Executor.VMProcMonHostname.isEmpty();
			
			beforeStat = LinuxProcessAnalyzer.getStatInfo();
			
			Socket localProcMonSock = new Socket("localhost", portNum);
			Socket hostProcMonSock = null;
			
			if (runningOnVM)
				hostProcMonSock = new Socket(azdblab.executable.Executor.VMProcMonHostname, 
						azdblab.executable.Executor.VMProcMonPortNum);
			
						
			byte[] b = new byte[3];
			localProcMonSock.getInputStream().read(b);
			
			if (runningOnVM)
				hostProcMonSock.getInputStream().read(b);

			
			// start time
			start_time = System.currentTimeMillis();
			
			// execute the query
			query_executor_statement.executeQuery(timedQuerySQL);
			// finish time
			finish_time = System.currentTimeMillis();
//			// get max pid
//			long max_pid = LinuxProcessAnalyzer.getMaxPID();
//			// get cpu stat
//			StatInfo afterStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// set max pid
//			afterStat.set_max_pid(max_pid);
			
			proc_diff = getProcDiff(localProcMonSock);
			if (runningOnVM)
				proc_diff += "VM:\n"+getProcDiff(hostProcMonSock);
			afterStat = LinuxProcessAnalyzer.getStatInfo();
			
			
			// get processes
			//HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
			// do map diff
			proc_diff += LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
													   beforeStat,
												  	   afterStat//,
												  	   //beforeMap, 
												  	   //afterMap
												  	   );
			// get the time
			exec_time = finish_time - start_time;
			
			
			// kiil process monitor
			if(procMon != null)
				killProcMonitor(procMon);
			
			// cancel scheduled timer
			timer.cancel();
			// cancel timeout thread
			timeOuter.cancel();
			
			// cancel proc monitor timer
			procMonTimer.cancel();
			// cancel proc monitor timeout thread
			procMonTimeOuter.cancel();
			
			// close the created statement
			query_executor_statement.close();
		}
		catch(ProcMonitorException pmex){
			if(procMon != null)
				killProcMonitor(procMon);
			if (!bProcMonitorError) {
				bProcMonitorError = true;
				QueryExecutionStat result = timeQuery(sqlQuery, plan, cardinality, time_out);
				bProcMonitorError = false;
				return result;
			}
			else{
				throw pmex;
			}
				
		}
		catch (Exception e) {
			e.printStackTrace();
			
			if(procMon != null)
				// kiil process monitor
				killProcMonitor(procMon);
			
			exec_time = Constants.MAX_EXECUTIONTIME;
			Main._logger.outputLog("Execution too long: Execution time set to "
					+ exec_time);
		}
		if (Main.verbose) {
			Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
		}
		return new QueryExecutionStat(exec_time, proc_diff);
	}

	/**
	 * @see azdblab.plugins.experimentSubject#timePreparedQuery() 
	 * As MySQL does not properly support setQueryTimeOut(), we stick to the old method using
	 * a timer thread to handle timeout.
	 */
	public QueryExecutionStat timePreparedQuery(String sqlQuery,
			PreparedStatement pstmt, PlanNode plan, long cardinality,
			int time_out) throws SQLException, Exception {
		PlanNode curr_plan = getQueryPlan(sqlQuery);
		// verifies that the current query plan is the plan that AZDBLAB thought
		// it // was timing.
		if (!curr_plan.equals(plan)) {
			Main._logger.outputLog("query: " + sqlQuery);
			Main._logger.outputLog("cardinality: " + cardinality);
			Main._logger.outputLog("hash code for a given plan: "
					+ plan.myHashCode());
			Main._logger.outputLog("a given plan: " + plan.toString());
			Main._logger.outputLog("hash code for a current plan: "
					+ curr_plan.myHashCode());
			Main._logger.outputLog("a current plan: " + curr_plan.toString());
			throw new Exception(
					"timeQuery: detected plan error.  Tried to time different plan from change point plan");
		}
		Main._logger.outputLog("Time out for MySQL is : " + Constants.EXP_TIME_OUT_MS + " (msecs)");
		long start_time;
		long finish_time;
		long exec_time = 0;
		String proc_diff = "";
		timePreparedOuter = new TimeoutPreparedQueryExecution(pstmt);
		
		Timer timer = new Timer();
		
		// process monitor
		Process procMon = null;
		// overall stat
		StatInfo beforeStat = null, afterStat = null;
		try {
			flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
			flushOSCache();
			Main._logger.outputLog("Finish Flushing OS Cache");
			flushDBMSCache();
			Main._logger.outputLog("Finish Flushing DBMS Cache");
			// set up time out thread
			timer.scheduleAtFixedRate(timePreparedOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
			
			/*****
			 * Tucson Timing Protocol v1 written by Young
			 */
//			// get processes
//			HashMap<Long, ProcessInfo> beforeMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.PRE_QE);
////			// get cpu stat
////			StatInfo beforeStat = LinuxProcessAnalyzer.getCPUStatInfo();
////			// get max pid
////			beforeStat.set_max_pid(LinuxProcessAnalyzer.getMaxPID());
//			StatInfo beforeStat = LinuxProcessAnalyzer.getStatInfo();
//			// start time
//			start_time = System.currentTimeMillis();
//			// execute the prepared query
//			pstmt.executeQuery();
//			// finish time
//			finish_time = System.currentTimeMillis();
////			// get max pid
////			long max_pid = LinuxProcessAnalyzer.getMaxPID();
////			// get cpu stat
////			StatInfo afterStat = LinuxProcessAnalyzer.getCPUStatInfo();
//			// set max pid
////			afterStat.set_max_pid(max_pid);
//			StatInfo afterStat = LinuxProcessAnalyzer.getStatInfo();
//			// get processes
//			HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
//			// do map diff
//			proc_diff = LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
//													   beforeStat,
//												  	   afterStat//,
//												  	   //beforeMap, 
//												  	   //afterMap
//												  	   );
//			// get the time
//			exec_time = finish_time - start_time;
			
			/*****
			 * Tucson Timing Protocol v2 written by Andrey
			 */
			// start process monitor
			int portNum = ((new Random()).nextInt(10000))+7000;
			procMon = runProcMonitor(portNum);
			
			// proc monitor timeouter 
			TimeoutProcMonitor procMonTimeOuter = new TimeoutProcMonitor(procMon);
			Timer procMonTimer = new Timer();
			procMonTimer.scheduleAtFixedRate(procMonTimeOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
			
			boolean runningOnVM = !azdblab.executable.Executor.VMProcMonHostname.isEmpty();

			// get processes
			beforeStat = LinuxProcessAnalyzer.getStatInfo();
									
			Socket localProcMonSock = new Socket("localhost", portNum);
			Socket hostProcMonSock = null;
			
			if (runningOnVM)
				hostProcMonSock = new Socket(azdblab.executable.Executor.VMProcMonHostname, 
						azdblab.executable.Executor.VMProcMonPortNum);
			
			byte[] b = new byte[3];
			localProcMonSock.getInputStream().read(b);
			
			if (runningOnVM)
				hostProcMonSock.getInputStream().read(b);
			
			// start time
			start_time = System.currentTimeMillis();
			// execute the prepared query
			pstmt.executeQuery();
			// finish time
			finish_time = System.currentTimeMillis();
			
			proc_diff = getProcDiff(localProcMonSock);
			if (runningOnVM)
				proc_diff += "VM:\n"+getProcDiff(hostProcMonSock);
			afterStat = LinuxProcessAnalyzer.getStatInfo();
			
			
			// get processes
			//HashMap<Long, ProcessInfo> afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
			// do map diff
			proc_diff += LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
													   beforeStat,
												  	   afterStat//,
												  	   //beforeMap, 
												  	   //afterMap
												  	   );
			// get the time
			exec_time = finish_time - start_time;
			
			// kill process monitor
			if(procMon != null)
				killProcMonitor(procMon);
						
			// cancel scheduled timer
			timer.cancel();
			// cancel timeout thread
			timePreparedOuter.cancel();
							
			// cancel proc monitor timer
			procMonTimer.cancel();
			// cancel proc monitor timeout thread
			procMonTimeOuter.cancel();
			
		}
		catch(ProcMonitorException pmex){
			if(procMon != null)
				killProcMonitor(procMon);
			if (!bProcMonitorError) {
				bProcMonitorError = true;
				QueryExecutionStat result = timePreparedQuery(sqlQuery, pstmt, plan, cardinality, time_out);
				bProcMonitorError = false;
				return result;
			}
			else{
				throw pmex;
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			exec_time = Constants.MAX_EXECUTIONTIME;
			Main._logger.outputLog("Execution too long: Execution time set to " + exec_time);
			
			if(procMon != null)
				killProcMonitor(procMon);
			
			reset();
		}
		if (Main.verbose) {
			Main._logger.outputLog("Query Plan Execution Time: "
					+ exec_time);
		}
		return new QueryExecutionStat(exec_time, proc_diff);
	}

	public String getDBVersion() {
		try {
			ResultSet rs = _statement.executeQuery("SELECT VERSION();");
			if (rs != null) {
				rs.first();
			}
			return rs.getString(1);
		} catch (SQLException e) {
			return null;
		}
	}

	public String[] getPlanProperties() {
		return PLAN_PROPERTIES;
	}

	public String[] getPlanOperators() {
		return PLAN_OPERATORS;
	}

	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}

	public void setOptimizerFeature(String featureName, String featureValue) {

	}

	private static final String BLOB = "BLOB";

	/**
	 * An array of column names for the table PLAN_TABLE in Oracle. public
	 * static final String[] PLAN_TABLE_COLUMNS = new String[] { "STATEMENT_ID",
	 * "TIMESTAMP", "REMARKS", "OPERATION", "OPTIONS", "OBJECT_NODE",
	 * "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_INSTANCE", "OBJECT_TYPE",
	 * "OPTIMIZER", "SEARCH_COLUMNS", "ID", "PARENT_ID", "POSITION", "COST",
	 * "CARDINALITY", "BYTES", "OTHER_TAG", "PARTITION_START", "PARTITION_STOP",
	 * "PARTITION_ID", "OTHER", "DISTRIBUTION" };
	 */

	/**
	 * An array of operators specified in Oracle DBMS
	 */
	public static final String[] PLAN_OPERATORS = new String[] { "MYSQL HASH JOIN" };

	/**
	 * An array of column names for the Description of Plans in MySQL.
	 */
	public static final String[] PLAN_DETAIL_FIELDS = new String[] {
			"STATEMENTID", "ID", "PARENT_ID",
			"POSITION",
			// THE ABOVE 3 ATTRIBUTES ARE NOT INCLUDED IN THE RESULT OF MYSQL.
			// BUT ADDED HERE FOR CREATING PROPER PLAN_TREE.
			"SELECT_TYPE", "OBJECT_NAME", "OPERATION", "POSSIBLE_KEYS",
			"KEY_NAME", "KEY_LEN", "REF", "ROWS", "EXTRA", "OBJECT_TYPE" };

	public static final String[] PLAN_PROPERTIES = new String[] {
			"STATEMENTID", "SELECT_TYPE", "POSSIBLE_KEYS", "KEY_NAME",
			"KEY_LEN", "REF", "ROWS", "EXTRA" };

	/**
	 * The name of the table that stores which tables have been created by
	 * AZDBLab.
	 */
	// private static final String EXPERIMENT_RECORD_TABLE =
	// AZDBLab.TABLE_PREFIX + "TABLE_RECORD";

	/**
	 * The index of the id for the cache tables.
	 */
	private static final int ID_INDEX = 1;
	/**
	 * The index of the column in the cache tables that are used for ordering.
	 */
	private static final int NODE_ORDER_INDEX = 3;
	/**
	 * The index of the column that has the object name for the plan_table.
	 */
	private static final int OBJECT_NAME_INDEX = 5;
	/**
	 * The index of the column that has the operation name for the plan_table.
	 */
	private static final int OPERATION_NAME_INDEX = 6;
	/**
	 * The index of the column that has the number of rows index for the
	 * plan_table.
	 */
	private static final int ROW_INDEX = 11;
	/**
	 * The index of the column that has the option index for the plan_table.
	 */
	private static final int OPTION_INDEX = 12;
	/**
	 * The index of the column that has the parent id for the plan_table.
	 */
	private static final int PARENT_ID_INDEX = 2;

	/**
	 * The index of the column that has the object type for the plan_table.
	 */
	private static final int OBJECT_TYPE_INDEX = 13;

	/**
	 * The name of the data type to store integer numbers in Oracle.
	 */
	// private static final String NUMBER = "NUMBER";
	private static final String NUMBER = "INT";

	/**
	 * The name of the character data type for ORACLE.
	 */
	// private static final String VARCHAR = "VARCHAR2";
	private static final String VARCHAR = "VARCHAR";

	private static final String DBMS_DRIVER_CLASS_NAME = "com.mysql.jdbc.Driver";

	private static final String DBMS_NAME = "MySQL2";

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
	public void initializeSubjectTables() {
		// TODO Auto-generated method stub

	}

	@Override
	public void disableAutoStatUpdate() {
		// // TODO Auto-generated method stub
		// boolean fail = false;
		// //Main.defaultLogger.logging_normal(">>> Disabling auto Stat update ... ");
		// // TODO Auto-generated method stub
		// String strStatUpdateSQL = "SET GLOBAL innodb_stats_on_metadata=OFF";
		// try {
		// //attempts to create the table. If it fails, the table exists and an
		// exception will be thrown.
		// _statement.executeUpdate(strStatUpdateSQL);
		// //if the table was created, drop it again.
		// } catch (SQLException e) {
		// Main.defaultLogger.logging_error("Turning off the update demon error: '"
		// +
		// strStatUpdateSQL + "'" );
		// e.printStackTrace();
		// fail = true;
		// }
		// if(!fail) Main.defaultLogger.logging_normal("<<<< Success! ");
	}

	@Override
	public void enableAutoStatUpdate() {
		// // TODO Auto-generated method stub
		// boolean fail = false;
		// //Main.defaultLogger.logging_normal(">>> Enabling auto Stat update ... ");
		// // TODO Auto-generated method stub
		// String strStatUpdateSQL = "SET GLOBAL innodb_stats_on_metadata=ON";
		// try {
		// //attempts to create the table. If it fails, the table exists and an
		// exception will be thrown.
		// _statement.executeUpdate(strStatUpdateSQL);
		// //if the table was created, drop it again.
		// } catch (SQLException e) {
		// Main.defaultLogger.logging_error("Turning on the update demon error: '"
		// +
		// strStatUpdateSQL + "'" );
		// e.printStackTrace();
		// fail = true;
		// }
		// if(!fail) Main.defaultLogger.logging_normal("<<<< Success! ");
	}

	@Override
	public int getTableCardinality(String tableName) {
		int res = 0;
		String countSQL = "SELECT count(*) " + "FROM " + tableName;
		try {
			// Main.defaultLogger.logging_normal("count sql: " + countSQL);
			ResultSet cs = _statement.executeQuery(countSQL);
			if (cs.next()) {
				// Main.defaultLogger.logging_normal("actual rows: " +
				// cs.getInt(1));
				res = cs.getInt(1);
			}
			cs.close();
		} catch (SQLException e) {
			close();
			e.printStackTrace();
			Main._logger.reportError("exception-No statistics for table: "
					+ tableName);
			System.exit(1); // programmer/dbms error
		}
		return res;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
