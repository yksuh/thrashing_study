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
* Minjun Seo
*/
package plugins;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;

import azdblab.executable.Main;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TableNode;
import azdblab.labShelf.dataModel.StateData;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;

class JavaDBPlan {
	/*
	 * Fields declaration.
	 */
	private HashMap<String, Integer> planStringMap;
	public static final String BEGIN = "Statement Execution Plan Text:";
	public static final String JOIN = "^.*Join ResultSet:.*";
	public static final String LEFT = "^(.*)Left result set:(.*)";
	public static final String RIGHT = "^(.*)Right result set:(.*)";
	public static final String[][] planStrings = {
		{"SQL","Statement Text:"},
		{"BEGIN", "Statement Execution Plan Text:"},
		{"JOIN", "^.*Join ResultSet:.*"},
		{"LEFT", "^(.*)Left result set:(.*)"},
		{"RIGHT", "^(.*)Right result set:(.*)"}
	};
	
	/**
	 * Constructor
	 */
	public JavaDBPlan() {
		planStringMap = new HashMap<String, Integer>();
		for(int i = 0 ; i < planStrings.length; i++) {
			planStringMap.put(planStrings[i][0], i);
		}
	}
	

	String getRegex(String plan) {
		Integer index = planStringMap.get(plan);
		return (index==null) ? "" : planStrings[index][1];
	}
	


	String result = "";
	int countSpace(String s) {
		int count = 0;
		for(int i = 0 ; i < s.length(); i++)  {
			if( s.charAt(i) == ' ') {
				count++;
			}
			else {
				break;
			}
		}
		return count;
	}
	int getLevel(String s) {
		return countSpace(s) / 8;
	}
	//id:0 parent:-1 level:-1 JOIN	 string:"Hash Join ResultSet:"
	class JavaDBPlanNode {
		int id;
		int parent;
		int level;
		String cond1="";
		String cond2="";
		String content="";
		public JavaDBPlanNode(int id, int parent, int level, String cond1, String cond2, String content) {
			this.id = id;
			this.parent = parent;
			this.level = level;
			this.cond1 = cond1;
			this.cond2 = cond2;
			this.content = content;
		}
		@Override
		public String toString() {
			String result = String.format("%d %d %d %s %s\n %s\n", id, parent, level, cond1, cond2, content.substring(0, 20)+"..." );
			return result;
		}
	}
	private ArrayList<JavaDBPlanNode> plist = new ArrayList<JavaDBPlanNode>();
	private String SQL = "";
	
	void openFromString(String result) throws IOException {
		StringReader sr = new StringReader(result);
		openFromReader(sr);
	}
	void openFromFile(String filename) throws FileNotFoundException, IOException {
		openFromReader(new FileReader(filename));
	}
	void openFromReader(Reader r) throws IOException {
		BufferedReader br = new BufferedReader(r );
		String s = "";
		int id = 0;
		int weight = 0;
		int level = 0;
		
		plist.clear();
		
		String content = "";
		while( (s = br.readLine()) != null) {
			if ( s != null && s.length() > 0  ) {
				if (s.matches( getRegex("SQL" ))) {
					SQL = br.readLine();
				}
				if (s.matches( getRegex("JOIN") )) {
					level = ( id==0 ) ? -1 : getLevel(s) + weight;
					JavaDBPlanNode pn = new JavaDBPlanNode(id++, level, level, "JOIN", s.trim() , content);
					plist.add(pn);
					weight = getLevel(s);;
				}				
				if (s.matches(LEFT)) {
					level = getLevel(s) + weight ;
					JavaDBPlanNode pn = new JavaDBPlanNode(id++, level, level, "LEFT", s.trim() , content);
					plist.add(pn);
				}
				if (s.matches(RIGHT)) {
					level = getLevel(s) + weight;
					JavaDBPlanNode pn = new JavaDBPlanNode(id++, level, level, "RIGHT", s.trim() , content);
					plist.add(pn);
					weight--;
					
				}				
				content += "\t" +  s + "\n";
			}
			result += s+"\n";
		}
	}
	@Override
	public String toString() {
		String result="SQL:"+SQL +"\n";
		for(int i = 0 ; i < plist.size(); i++) {
			result += plist.get(i).toString();
		}
		return result;
	}
	void print() {
		System.out.println(result);
	}
	
	public Vector<PlanNode> toPlanNodes() {

		Vector<PlanNode> v_tree = new Vector<PlanNode>();
		for (int i = 0; i < plist.size(); i++) {
			PlanNode newnode = null;
			if (plist.get(i).cond1.equals("JOIN")) { // operator
				/*
				 * The constructor specifies the basic OperatorNode information
				 * 
				 * Parameters: node_id ID of the node parent_id ID of the parent
				 * of current node node_order the position of node in pre-order
				 * traversal name the name of the OperatorNode. either a table
				 * name or a operator name. columnNames the properties of the
				 * OperatorNode. columnValues the values of the properties of
				 * the OperatorNode.
				 */

				newnode = new OperatorNode(plist.get(i).id + "", plist.get(i).parent
						+ "", i + "", plist.get(i).id + "",
						new String[] { "OPERATION" },
						new String[] { "JOIN" + i });

				HashMap<String, Double> value = null;
				if (value == null) {
					value = new HashMap<String, Double>();
					value.put("ROWS", 0.0);
				}

				newnode.setOpCostEstimates(value);
			} else {
				// type Table
				newnode = new TableNode(plist.get(i).id + "", plist.get(i).parent
						+ "", i + "",
						plist.get(i).id + ":" + plist.get(i).id,
						new String[] { "OBJECT_NAME" },
						new String[] { "TABLENAME" + i });
				HashMap<String, Double> value = null;
				if (value == null) {
					// System.err.println("ecase2");
					value = new HashMap<String, Double>();
					value.put("ROWS", 0.0);
				}
			}
			if (newnode != null)
				v_tree.add(newnode);
		}

		return v_tree;

	}
}

public class JavaDBSubject extends ExperimentSubject {
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
	public JavaDBSubject(String userName, String password, String connectString, String machineName) {
		super(userName, password, connectString, machineName);
//		System.err.printf("start _JavaDBSubject %s-%s-%s",userName, password, connectString);
		
	}
	
	public void SetStatement(Statement stmt) {
		_statement = stmt;
	}

	public void SetConnection(Connection connection) {
		_connection = connection;
	}


	
	/**
	 * JAVADB can copy table with following syntax
	 * CREATE TABLE [Target] AS SELECT * FROM [Source] WITH NO DATA;
	 * INSERT INTO [Target] SELECT * FROM [Source];
	 * 
	 * Since JavaDB cannot support WITH DATA option until now(version 10.8),
	 * We must use additional "INSERT" statement for copying data.
	 */
	@Override
	public void copyTable(String newTable, String oriTable) {
		try {

			if (tableExists(newTable)) {
				dropTable(newTable);
			}
			String cloneStructureSQL = 
					String.format("CREATE TABLE %s AS %s WITH NO DATA;",newTable, oriTable);
			String cloneDataSQL = 
					String.format("INSERT INTO %s SELECT * from %s WHERE id1 < %d", 
							newTable, oriTable);
			commit();
			// Logging and Execution
			Main._logger.outputLog(cloneStructureSQL);
			_statement.executeUpdate(cloneStructureSQL);
			Main._logger.outputLog(cloneDataSQL);
			_statement.executeUpdate(cloneDataSQL);

			// When executed successfully
			Main._logger.outputLog("Clone table finished!");

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}
	/**
	 * JAVADB can copy table with following syntax
	 * CREATE TABLE [Target] AS SELECT * FROM [Source] WITH NO DATA;
	 * INSERT INTO [Target] SELECT * FROM [Source];
	 * 
	 * Since JavaDB cannot support WITH DATA option until now(version ***),
	 * We must use additional "INSERT" statement for copying data.
	 */
	@Override
	public void copyTable(String newTable, String oriTable, long cardinality) {
		try {

			if (tableExists(newTable)) {
				dropTable(newTable);
			}
			String cloneStructureSQL = 
					String.format("CREATE TABLE %s AS %s WITH NO DATA;",newTable, oriTable);
			String cloneDataSQL = 
					String.format("INSERT INTO %s SELECT * from %s WHERE id1 < %d", 
							newTable, oriTable, cardinality);
			// Logging and Execution
			Main._logger.outputLog(cloneStructureSQL);
			_statement.executeUpdate(cloneStructureSQL);
			Main._logger.outputLog(cloneDataSQL);
			_statement.executeUpdate(cloneDataSQL);

			// When executed successfully
			Main._logger.outputLog("Clone table finished!");

		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	@Override
	public void deleteHelperTables() {
	} // not implemented yet

	@Override
	public void disableAutoStatUpdate() {
	} // not implemented

	/**
	 * Find tables excluding system tables;
	 *   elect TABLENAME from sys.systables where TABLETYPE='T';
	 */
	@Override
	public void dropAllInstalledTables() {
		String sql = "select TABLENAME from sys.systables where TABLETYPE='T'";
		Main._logger.outputLog("Find all tables by : " + sql);
		try {
			ResultSet rs = _statement.executeQuery(sql);
			Vector<String> vecNames = new Vector<String>();

			while (rs.next()) {
				vecNames.add(rs.getString(1));
			}
			rs.close();
			for (int i = 0; i < vecNames.size(); i++) {
				Main._logger.outputLog("installed tableName: "
						+ vecNames.get(i));
				dropTable(vecNames.get(i));
			}
			commit();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public void enableAutoStatUpdate() {
	}// not implemented

	@Override
	public void flushDBMSCache() {
	} // not implemented

	public static final String DBMS_NAME = "JavaDB";

	@Override
	public String getDBMSName() {
		return DBMS_NAME;
	}

	@Override
	public String[] getPlanOperators() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String[] getPlanProperties() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public StateData getPreparedState(StateData state) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public PlanNode getQueryPlan(String sqlQuery) throws Exception {
		// TODO @mjseo should know how to get information in DB
		// ResultSet rs =
		// _statement.executeQuery("explain in xml SELECT * from test;");
		ResultSet rs;
		//Vector<String> vecDetail = null;
		PlanNode result = null;

		// Step1 - enable run-time statistics
		_statement.executeUpdate("CALL SYSCS_UTIL.SYSCS_SET_RUNTIMESTATISTICS(1)");
		_statement.executeUpdate("CALL SYSCS_UTIL.SYSCS_SET_STATISTICS_TIMING(1)");
		
		// Step2 - Run SQL Statement
		rs = _statement.executeQuery(sqlQuery);
				while (rs.next()) {}
		rs.close();
		
		// Step3 - retrieve query plan and run-time statistics
		rs = _statement.executeQuery("VALUES SYSCS_UTIL.SYSCS_GET_RUNTIMESTATISTICS()");
		rs.next();
		String plan_str = rs.getString(1);
		
		// Step4 - Analyzing plan result
		JavaDBPlan jdp = new JavaDBPlan();
		jdp.openFromString(plan_str);

		
		Vector<PlanNode> v_tree = jdp.toPlanNodes();
		PlanNode root = null;
		result = buildTree(root, v_tree);		
		
		return result;

	}

	protected PlanNode buildTree(PlanNode root, Vector<PlanNode> v_tree) {
		return null;
	}
	
	@Override
	public void initializeSubjectTables() {
		Main._logger.outputLog("Install subject (plan) tables ...");
//		// TODO Auto-generated method stub
//		// delete all rows in EXPLAIN_INSTANCE table
//		String explain_inst_tbl = "EXPLAIN_INSTANCE"; // TODO unsure if this
//														// works
//		String empty_table = "DELETE FROM " + strUserName + "." // TODO unsure
//																// if this works
//				+ explain_inst_tbl;
//		try { // remove old query plan
//			_statement.executeUpdate(empty_table);
//		} catch (SQLException e1) {
//			e1.printStackTrace();
//		}
//		if (tableExists(QUERY_PLAN_TABLE)) {
//			dropTable(QUERY_PLAN_TABLE);
//		}
//		try { // create a new plan table
//			Main._logger.outputLog(CREATE_PLAN_TABLE);
//			_statement.executeUpdate(CREATE_PLAN_TABLE);
//		} catch (SQLException e1) {
//			e1.printStackTrace();
//		}
		Main._logger.outputLog("... done!! ");

	}

	@Override
	public void installExperimentTables(DataDefinition myDataDef,
			String myPrefix) {
		if (Main.verbose)
			Main._logger.outputLog("Installing Tables");
		String[] myTables = myDataDef.getTables();
		if (!isInstalled(myPrefix, myTables)) {
			// initializeSubjectTables();
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
				commit();
			}
		}
		commit();
		Main._logger.outputLog("installExperimentTables Done!");
	}

	private boolean isInstalled(String myPrefix, String[] myTables) {
		System.err.println("myPrefix:" +myPrefix);
		for(int i = 0 ; i < myTables.length; i++) 
			System.err.println(myTables[i]);
		return false; // TODO not implemented in DB2
	}

	@Override
	public void printTableStat(String tableName) {
		String countSQL = "SELECT count(*) " + "FROM " + tableName;
		try {
			ResultSet cs = _statement.executeQuery(countSQL);
			if (cs.next()) {
				Main._logger.outputLog("actual rows: " + cs.getInt(1));
			}
			cs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}// the above "should" work

		// String schemaName = strUserName;
		// String statSQL = "SELECT tabname, card, npages, fpages " +
		// "FROM sysstat.tables " +
		// "WHERE tabschema='" + schemaName.toUpperCase() + "' and tabname = '"
		// + tableName.toUpperCase() + "'";
		String nameSQL = "select TABLENAME from SYS.SYSTABLES";
		try {
			ResultSet rs = _statement.executeQuery(nameSQL);
			while (rs.next()) {
				Main._logger.outputLog("TableName:" + rs.getString(1));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// TODO Auto-generated method stub

	}

	@Override
	public void setOptimizerFeature(String featureName, String featureValue) {
		// TODO Auto-generated method stub

	}

	@Override
	public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan,
			long cardinality, int timeOut) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateTableStatistics(Table table) {
		// TODO Auto-generated method stub

	}

	@Override
	public void deleteRows(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// TODO Auto-generated method stub

	}

	@Override
	public void executeDeleteSQL(String sql) throws SQLException {
		_statement.executeUpdate(sql);
	}

	@Override
	public ResultSet executeQuerySQL(String sql) {
		try {
			return _statement.executeQuery(sql);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
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
		        for ( long i = 0; i < actual_cardinality; i++ ){
		          if ((i + 1) % 10000 == 0){
		            Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//		            commit();
		          }
		          String  strdata  = "";
		          Column[] column = table.getColumns();
		          // Assume all data fields are of integer data type
		          for ( int j = 1; j < columnnum; j++ ) {
		        	  if(column[j].myName.contains("val")){
		        		  strdata += "'Dallas, long scarred by the guilt and shame of being the place Pres. JFK was assassinated.'";
		        	  }else{
		        		  strdata += repRand.getNextRandomInt();
		        	  }
		        	  if(j < columnnum -1){
		        		  strdata += ",";  
		        	  }
		          }
		          strupdate = "INSERT INTO " + tableName + " VALUES(" + i + "," +
		                      strdata + ")";
		          _statement.addBatch(strupdate);
		          if((i + 1) % 30000 == 0){
		        	  _statement.executeBatch();
		        	  System.out.print("Committing ... ");
		        	  commit();
		        	  System.out.println("... done...");
		          }
		        }
		      _statement.executeBatch();
		      commit();
		    } catch (SQLException sqlex){
		      sqlex.printStackTrace();
		    }
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

	public void updateStat() {

	}
	
	@Override
	public void executeUpdateSQL(String sql) {
		try {
			_statement.executeUpdate(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}

	@Override
	public String getDBVersion() {
		ResultSet rs;
		String version = "JavaDB(Derby)";
		try {
			rs = _statement.executeQuery("values syscs_util.syscs_get_database_property( 'DataDictionaryVersion' )");
			if (rs!=null) {
				rs.next();
				version += " " + rs.getString(1);
			}
			rs.close();		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


		return version;
	}

	@Override
	protected String getDataTypeAsString(int dataType, int length) {
		switch (dataType) {
			case GeneralDBMS.I_DATA_TYPE_NUMBER: {
				return NUMBER;
			}
			case GeneralDBMS.I_DATA_TYPE_VARCHAR: {
				return VARCHAR + "(" + length + ")";
			}
			case GeneralDBMS.I_DATA_TYPE_CLOB: {
				return CLOB + "(" + length + ")";
			}
			default: {
				Main._logger.reportError("Unknown data type");
				System.exit(1);
				return null;
			}
		}
	}

	@Override
	public boolean tableExists(String tableName) {
		try {
			_statement.executeUpdate("CREATE TABLE " + tableName
					+ " (Name varchar(1))");
			_statement.executeUpdate("DROP TABLE " + tableName);
			return false;
		} catch (SQLException e) {
			Main._logger.outputLog(tableName + "... exists !! ");
			return true;
		}

	}
	  public void setVirtualTableCardinality(String tableName, long cardinality, RepeatableRandom repRand) {
		    //TableStatistic table;
		    
		    //if (cardinality > CurrentCardinality){
		    //  System.err.println("Create an cardinality exception here: setTableStats@SQLServerAPI"+cardinality+","+ CurrentCardinality);
		    //  return;
		    //}

		    // ID is 0 based
		    String  sqldelete  = "DELETE FROM " + tableName + " WHERE id1 >= " + cardinality + ";"; 

		    try {
		      //for ( long i = this.iRecordNum; i > cardinality; i-- ){
		      _statement.executeUpdate(sqldelete);
		  
		    } catch (SQLException sqlex){
		      sqlex.printStackTrace();
		    }
		  }	
//	public String getExperimentSubjectName() {
//		return "javadb";
//	}

	public static final String VARCHAR = "VARCHAR";
	public static final String NUMBER = "INT";
	public static final String CLOB = "CLOB";
	private static final String DBMS_DRIVER_CLASS_NAME = "org.apache.derby.jdbc.ClientDriver";
	
	@Override
	public String getSupportedShelfs() {
		// TODO Auto-generated method stub
		return "7.X";
	}
}
