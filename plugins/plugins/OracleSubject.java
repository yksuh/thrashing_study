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

import oracle.jdbc.OracleResultSet;
import oracle.sql.CLOB;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Vector;
import azdblab.exception.dbms.DBMSInvalidConnectionParameterException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableNode;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.dataDefinition.*;
import azdblab.model.experiment.Table;

import java.sql.Statement;
import java.sql.Connection;

/**
 * 
 *
 */
public class OracleSubject extends LabShelfManager {
	/**
	 * 
	 */
	private class TableStatistic {
	/**
		 * The average size of a tuple in the table.
		 */
		public long average_row_length;
		/**
		 * The number of rows in the table. This is the cardinality.
		 */
		public long num_rows;
		/**
		 * The number of blocks this table used.
		 */
		public long numblocks;
		/**
		 * The name of the table.
		 */
		public String tableName;
	}

	/**
	 * Constructor
	 * 
	 * @param user_name
	 * @param password
	 * @param connect_string
	 */
	public OracleSubject(String user_name, String password,
			String connect_string, String machineName) {
		super(user_name, password, connect_string, machineName);
		labUsername = user_name;
		labPassword = password;
		labConnectString = connect_string;
	}

//	public String getExperimentSubjectName() {
//		return "OracleSubject";
//	}
	
	public String getDBMSName(){
		return DBMS_NAME;
	}
	
//	public static String getName(){
//		return DBMS_NAME;
//	}

	// /**
	// * The creates all tables used internally by oracle to perform
	// experiments.
	// */
	public void initializeSubjectTables() {
		// try {
		// This table is used by Oracle's EXPLAIN PLAN to store the results
		// of a query plan.
		// if (tableExists(QUERY_PLAN_TABLE)) {
		// _statement.executeUpdate(DROP_QUERY_PLAN_TABLE);
		// }
		// _statement.executeUpdate(CREATE_QUERY_PLAN_TABLE);
		// commit();
		// } catch (SQLException e) {
		// Main._logger.logging_error(
		// "OracleInterface could not create the table an internal table");
		// e.printStackTrace();
		// System.exit(1); // this is an install bug
		// }
	}

	@Override
	public void disableAutoStatUpdate() {
	}

	@Override
	public void enableAutoStatUpdate() {
	}

	public void deleteHelperTables() {
		// try {
		// // This table is used by Oracle's EXPLAIN PLAN to store the results
		// // of a query plan.
		// if (tableExists(QUERY_PLAN_TABLE)) {
		// _statement.executeUpdate(DROP_QUERY_PLAN_TABLE);
		// commit();
		// }
		// } catch (SQLException sqlex) {
		// sqlex.printStackTrace();
		// }
	}

	/**
   * 
   */
	public void copyTable(String newTable, String oriTable) throws Exception{
		// Main._logger.outputLog("Copying table " + newTable
		// + " in Oracle");
		try {
			if (tableExists(newTable)) {
				_statement.executeUpdate("DROP TABLE " + newTable);
				commit();
			}
			String cloneSQL = "CREATE TABLE " + newTable + " AS SELECT * FROM "
					+ oriTable;
			_statement.executeUpdate(cloneSQL);
			commit();
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
			String cloneSQL = "CREATE TABLE " + newTable + " AS SELECT * FROM "
					+ oriTable + " WHERE id1 < " + cardinality;
			_statement.executeUpdate(cloneSQL);
			commit();
		} catch (SQLException sqlex) {
//			sqlex.printStackTrace();
			close();
			throw new Exception(sqlex.getMessage());
		}
	}

	/**
	 * Given AZDBLab's integer represenation of a data type, this produces an
	 * ORACLE specific representation of the data type.
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
			return CLOB;
		}
		case GeneralDBMS.I_DATA_TYPE_XML: {
			return XMLTYPE;
		}
		case GeneralDBMS.I_DATA_TYPE_DATE: {
			return DATE;
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
		// flushCache();

		String empty_plan = "DELETE FROM " + QUERY_PLAN_TABLE;
		String select_plan = "SELECT ";
		// select_plan += " * FROM " + QUERY_PLAN_TABLE;
		select_plan += " * FROM " + QUERY_PLAN_TABLE + " ORDER BY ID ASC";
		String explain_plan = "EXPLAIN PLAN FOR " + sql;
		ResultSet rs;
		try {
			// remove old query plan
			_statement.executeUpdate(empty_plan);
			commit();
			// ask oracle to provide the new query plan
			_statement.executeUpdate(explain_plan);
			commit();
		} catch (SQLException e1) {
			e1.printStackTrace();
			// throw new Exception(empty_plan + "\n" + explain_plan, e1);
		}
		PlanNode result = null;
		try {
			// extracting the query plan from the DBMS
			rs = _statement.executeQuery(select_plan);
			// building an Oracle Plan Tree
			result = createPlanTree(rs);
			rs.close();
		} catch (SQLException e) {
			throw new Exception(select_plan, e);
		}

		return result;
	}



	public void SetStatement(Statement stmt) {
		_statement = stmt;
	}

	public void SetConnection(Connection connection) {
		_connection = connection;
	}

	public void printColumns(ResultSet rs) throws Exception {
		try {
			ResultSetMetaData meta = rs.getMetaData();
			int number_columns = meta.getColumnCount();
			String[] metaColumnNames = new String[number_columns + 1];
			// Main._logger.outputLog("# of cols: " + number_columns);
			for (int i = 1; i < number_columns + 1; i++) {
				metaColumnNames[i] = meta.getColumnName(i);
				if (i == ID_INDEX || i == PARENT_ID_INDEX
						|| i == OPERATION_NAME_INDEX || i == OBJECT_NAME_INDEX
						|| i == OBJECT_TYPE_INDEX || i == COST_INDEX
						|| i == CARDINALITY_INDEX || i == BYTES_INDEX
						|| i == CPU_COST_INDEX || i == IO_COST_INDEX
						|| i == TEMP_SPACE_INDEX || i == TIME_INDEX)
					Main._logger.outputLogWithoutNewLine(" | "
							+ metaColumnNames[i]);

			}
			Main._logger.outputLog(" | ");
			int cnt = 0;

			while (rs.next()) {
				// Main._logger.logging_normal("error!");
				cnt++;
				for (int i = 1; i < number_columns + 1; i++) {
					if (i == ID_INDEX || i == PARENT_ID_INDEX
							|| i == OPERATION_NAME_INDEX
							|| i == OBJECT_NAME_INDEX || i == OBJECT_TYPE_INDEX
							|| i == COST_INDEX || i == CARDINALITY_INDEX
							|| i == BYTES_INDEX || i == CPU_COST_INDEX
							|| i == IO_COST_INDEX || i == TEMP_SPACE_INDEX
							|| i == TIME_INDEX) {
						switch (i) {
						case OPERATION_NAME_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getString(i));
							break;
						case OBJECT_NAME_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getString(i));
							break;
						case OBJECT_TYPE_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getString(i));
							break;
						case ID_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getInt(i));
							break;
						case PARENT_ID_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getInt(i));
							break;
						case COST_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getDouble(i));
							break;
						case CARDINALITY_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getInt(i));
							break;
						case BYTES_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getInt(i));
							break;
						case CPU_COST_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getDouble(i));
							break;
						case IO_COST_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getDouble(i));
							break;
						case TEMP_SPACE_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getInt(i));
							break;
						case TIME_INDEX:
							Main._logger.outputLogWithoutNewLine(" | "
									+ rs.getInt(i));
							break;
						}
					}

				}
				Main._logger.outputDebug("");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}


	/**
	 * 
	 * @param rs
	 * @return
	 */
	private PlanNode createPlanTree(ResultSet rs) {
		Vector<PlanNode> v_tree = new Vector<PlanNode>();

		try {
			ResultSetMetaData meta = rs.getMetaData();
			int number_columns = meta.getColumnCount();
			String[] columnNames = new String[number_columns];
			for (int i = 0; i < number_columns; i++) {
				columnNames[i] = meta.getColumnName(i + 1);
			}
			while (rs.next()) {
				String id = null, parent_id = null, node_order = null, operation_name = null, object_name = null;
				String object_type = null;
				String[] columnValues = new String[number_columns];

				// create a map of cost estimates
				HashMap<String, Double> mapRunStat = new HashMap<String, Double>();
				// for each column of this tuple
				for (int i = 1; i <= number_columns; i++) {
					// Read a value from the ith column
					String tempValue = rs.getString(i);
					if (tempValue != null) {
						tempValue = tempValue.trim();
					}

					// filling in the value and name of each column. This is
					// used by the Plan Node for
					// the other info field.
					columnValues[i - 1] = tempValue;
					// if the column is one of the special columns, record its
					// value
					switch (i) {
					case OracleSubject.ID_INDEX:
						id = tempValue;
						node_order = tempValue;
						break;
					case OracleSubject.PARENT_ID_INDEX:
						parent_id = tempValue;
						break;
					case OracleSubject.OPERATION_NAME_INDEX:
						operation_name = tempValue;
						break;
					case OracleSubject.OBJECT_NAME_INDEX:
						object_name = tempValue;
						break;
					case OracleSubject.OBJECT_TYPE_INDEX:
						object_type = tempValue;
						break;
					case OracleSubject.COST_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "COST", Double
									.parseDouble(tempValue));
						else
							mapRunStat.put(COST_MODEL_PREFIX + "COST", -1.0);
						break;
					}
					case OracleSubject.CARDINALITY_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "CARDINALITY",
									Double.parseDouble(tempValue));
						else
							mapRunStat.put(COST_MODEL_PREFIX + "CARDINALITY",
									-1.0);
						break;
					}
					case OracleSubject.BYTES_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "BYTES", Double
									.parseDouble(tempValue));
						else
							mapRunStat.put(COST_MODEL_PREFIX + "BYTES", -1.0);
						break;
					}
					case OracleSubject.CPU_COST_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "CPU_COST",
									Double.parseDouble(tempValue));
						else
							mapRunStat
									.put(COST_MODEL_PREFIX + "CPU_COST", -1.0);
						break;
					}
					case OracleSubject.IO_COST_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "IO_COST",
									Double.parseDouble(tempValue));
						else
							mapRunStat.put(COST_MODEL_PREFIX + "IO_COST", -1.0);
						break;
					}
					case OracleSubject.TEMP_SPACE_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "TEMPSPACE",
									Double.parseDouble(tempValue));
						else
							mapRunStat.put(COST_MODEL_PREFIX + "TEMPSPACE",
									-1.0);
						break;
					}
					case OracleSubject.TIME_INDEX: {
						if (tempValue != null)
							mapRunStat.put(COST_MODEL_PREFIX + "TIME", Double
									.parseDouble(tempValue));
						else
							mapRunStat.put(COST_MODEL_PREFIX + "TIME", -1.0);
						break;
					}
					} // switch
				} // for
				// Main._logger.logging_normal(" | ");

				// create the plan node and add it to the plan tree
				PlanNode newnode = null;
				if (object_type == null) {
					// A operatorNode
					newnode = new OperatorNode(id, parent_id, node_order,
							operation_name, columnNames, columnValues);
					newnode.setOpCostEstimates(mapRunStat);
				} else if (object_type.equals("TABLE")
						|| object_type.contains("INDEX")) {
					// A TableNode
					if (!object_type.equals("TABLE")) {
						object_name += "_" + object_type;
					}
					newnode = new TableNode(id, parent_id, node_order,
							object_name, columnNames, columnValues);
				} else if (object_type.equals("VIEW")) {
					// A operatorNode
					operation_name += ":" + object_name;
					newnode = new OperatorNode(id, parent_id, node_order,
							operation_name, columnNames, columnValues);
					newnode.setOpCostEstimates(mapRunStat);
				}
				if (newnode != null) {
					v_tree.add(newnode);
					// System.out.println("node id: " + newnode.getNodeID() +
					// ", object_name:"+newnode.toString());
				} else {
					// System.out.println("null-node id: " + id +
					// ", object_name:"+object_name);
				}
			} // while
		} catch (SQLException e) {
			e.printStackTrace();
		}
		PlanNode root = null;
		PlanNode pn = buildTree(root, v_tree);
		// pn.setNumOfOperators(numOps);
		// pn.setNumOfOperators(numOps);
		return pn;
	}

	/**
	 * Builds a plan tree by ordering the node correctly. Nodes are ordered by
	 * node id such that a pre-order traversal of the tree will yield the nodes
	 * in ascending order.
	 * 
	 * @param v_tree
	 */
	private PlanNode buildTree(PlanNode node, Vector<PlanNode> v_tree) {
		// inserting the root into the sorted list first.
		int num_nodes = v_tree.size();
		if (num_nodes == 0 || node instanceof TableNode) {
			return node;
		}
		if (node == null) {
			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = (PlanNode) v_tree.get(i);
				if (current.getParent() == null) {
					node = (PlanNode) v_tree.remove(i);
					break;
				}
			}
			buildTree(node, v_tree);
		} else {
			int id = Integer.parseInt(String.valueOf(node.getNodeID()));
			int child_count = 0;
			for (int i = 0; i < num_nodes; i++) {
				PlanNode current = (PlanNode) v_tree.get(i);
				int pid = Integer.parseInt(String
						.valueOf(current.getParentID()));
				if (pid == id) {
					current = (PlanNode) v_tree.remove(i);
					num_nodes--;
					i--;
					((OperatorNode) node).setChild(child_count++, current);
				}
			}
			int chnum = ((OperatorNode) node).getChildNumber();
			for (int j = 0; j < chnum; j++) {
				PlanNode tmpnode = ((OperatorNode) node).getChild(j);
				buildTree(tmpnode, v_tree);
			}
		}
		return node;
	}

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
	}

	/**
	 * Tests to see if the correct tables are installed.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#isInstalled()
	 */
	private boolean isInstalled(String strPrefix, String[] tables) {
		boolean plan = tableExists(QUERY_PLAN_TABLE);
		for (int i = 0; i < tables.length; i++) {
			if (!tableExists(strPrefix + tables[i]))
				return false;
		}
		return plan;
	}

	/**
	 * Gets the table statistics from the DBMS.
	 * 
	 * @param tableName
	 *            The name of the table
	 * @return A TableStatistic Object that contains important information about
	 *         the table statistics.
	 */
	private TableStatistic getTableStatistics(String tableName) {
		TableStatistic result = new TableStatistic();
		ResultSet ts;
		String stats = "";
		try {
			// Have oracle gather correct statistics.
			_statement.executeUpdate("ANALYZE TABLE " + tableName
					+ " COMPUTE STATISTICS");
		} catch (SQLException e1) {
			Main._logger.reportError("No statistics computed for table: "
					+ tableName);
			e1.printStackTrace();
			System.exit(1); // programmer/dbms error
		}
		// USER_TABLES is an oracle view which can be queried to gather
		// statistics.
		stats = "SELECT Blocks, Avg_Row_Len, Num_Rows FROM USER_TABLES WHERE Table_Name = '"
				+ tableName.toUpperCase() + "'";
		try {
			// retrieving the statistics from the DBMS.
			ts = _statement.executeQuery(stats);
			if (ts.next()) {
				result.numblocks = ts.getLong(1);
				result.average_row_length = ts.getLong(2);
				result.num_rows = ts.getLong(3);
				result.tableName = tableName;
			} else {
				Main._logger.reportError("No statistics for table: "
						+ tableName);
				System.exit(1); // programmer/dbms error
			}
			// ts.getStatement().close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main._logger.reportError("No statistics for table: " + tableName);
			System.exit(1); // programmer/dbms error
		}
		return result;
	}

	public void dropAllInstalledTables() {
		String sql = "SELECT TABLE_NAME " + "FROM USER_TABLES ";
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


		String statSQL = "SELECT NUM_ROWS, BLOCKS, AVG_ROW_LEN FROM USER_TABLES WHERE TABLE_NAME = '"
				+ tableName.toUpperCase() + "'";
		try {
			// _statement.executeUpdate(analyzeSQL);
			// retrieving the statistics from the DBMS.
			String countSQL = "SELECT count(*) " + "FROM "
					+ tableName.toUpperCase();
			// Main._logger.logging_normal("count: " + countSQL);
			ResultSet cs = _statement.executeQuery(countSQL);
			if (cs.next()) {
				Main._logger.outputLog("actual rows: " + cs.getInt(1));
			}
			cs.close();
			ResultSet ts = _statement.executeQuery(statSQL);
			if (ts.next()) {
				Main._logger.outputLog("tableName: " + tableName.toUpperCase());
				Main._logger.outputLog("NUM_ROWS: " + ts.getLong(1));
				Main._logger.outputLog("BLOCKS: " + ts.getLong(2));
				Main._logger.outputLog("AVG_ROW_LEN: " + ts.getLong(3));
			} else {
				Main._logger.reportError("No statistics for table: "
						+ tableName);
				System.exit(1); // programmer/dbms error
			}
			// ts.getStatement().close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main._logger.reportError("No statistics for table: " + tableName);
			System.exit(1); // programmer/dbms error
		}
	}

	/**
	 * Sets the table statistics, currently only the cardinality.
	 * 
	 */
	@Override
	public void updateTableStatistics(Table table) {
		String tableName = table.table_name_with_prefix;
	  	getTableStatistics(tableName);
	}


	/**
	 * Checks to see if a table exists.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#tableExists(java.lang.String)
	 */
	public boolean tableExists(String table) {
		try {

			Statement statement;

			if (_statement != null) {
				// experimentsubject
				statement = _statement;
			} else {
				// labshelf
				statement = labStatement;
			}
			// attempts to create the table. If it fails, the table exists and
			// an exception will be thrown.
			statement.executeUpdate("CREATE TABLE " + table
					+ " (Name varchar(1))");
			// if the table was created, drop it again.
			statement.executeUpdate("DROP TABLE " + table);
			return false;
		} catch (SQLException e) {
			return true;
		}
	}

	/**
	 * Drops table <code>tableName</code> from the database.
	 * 
	 * @param tableName
	 *            The name of the table that will be dropped from the DBMS.
	 * @param Table_Record_Table
	 *            the table used to keep track of the relevant tables in AZDBLab
	 *            when deleting, the corresponding table record should be
	 *            deleted from <code>Table_Record_Table</code> as well.
	 */
	public void dropTable(String tableName) {
		if (Main.verbose)
			Main._logger.outputLog("Dropping Table: " + tableName);
		try {
			Statement statement;
			if (_statement != null) {
				// experimentsubject
				statement = _statement;
			} else {
				// labshelf
				statement = labStatement;
			}
			// drop the table from the DBMS.
			if (tableExists(tableName)) {
				statement.executeUpdate("DROP TABLE " + tableName
						+ " CASCADE CONSTRAINTS");
			}
			commit();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Creates a DBMS table named tableName with the characteristics described
	 * by the parameters. All parameters that are arrays must be the same
	 * length. If they are not the same length an AZDBLab will terminate. Also,
	 * the index i for each array represents information about column i.
	 * 
	 * @param tableName
	 *            The name of the table that will be created.
	 * @param columnNames
	 *            The names of the columns that belong to the table.
	 * @param columnDataTypes
	 *            The data types of the columns that belong to the table.
	 * @param columnDataTypeLengths
	 *            The number of characters/digits that each column will use.
	 * @param primaryKey
	 *            The columns that will be part of the primary key.
	 * @param foreignKeys
	 *            The foreign keys for this table.
	 * @param Table_Record_Table
	 *            The table used to keep track of all relevant tables in the
	 *            AZDBLab
	 */
	@Override
	public void createTable(String tableName, String[] columnNames,
			int[] columnDataTypes, int[] columnDataTypeLengths,
			int[] columnNullable, String[] uniqueConstraintColumns,
			String[] primaryKey, ForeignKey[] foreignKeys) {
		if (tableExists(tableName)) {
			return;
		}
		// If all arrays are not the same length exit
		if ((columnNames.length != columnDataTypes.length)
				|| (columnDataTypes.length != columnDataTypeLengths.length)) {
			System.err
					.println("createTable: Parameter Arrays must have same length");
			System.exit(1); // programmer bug, should be able to create a table
		}
		// assemble the CREATE TABLE statement
		String createTable = "CREATE TABLE " + tableName + " ( ";
		for (int i = 0; i < columnNames.length; i++) {

			createTable += columnNames[i]
					+ " "
					+ getDataTypeAsString(columnDataTypes[i],
							columnDataTypeLengths[i]);
			if (columnNullable[i] == 0) {
				createTable += " NOT NULL";
			} else if (columnNullable[i] == 1) {
				createTable += " NULL";
			}
			if (i == columnNames.length - 1)
				break;
			createTable += ", ";
		}
		if (uniqueConstraintColumns != null
				&& uniqueConstraintColumns.length > 0) {
			String constraint = ", CONSTRAINT unique_" + tableName
					+ " UNIQUE (";
			for (int i = 0; i < uniqueConstraintColumns.length; i++) {
				constraint += uniqueConstraintColumns[i];
				if (i == uniqueConstraintColumns.length - 1) {
					break;
				}
				constraint += ",";
			}
			constraint += ")";
			createTable += constraint;
		}
		// creating the primary key SQL
		if (primaryKey != null) {
			createTable += ", PRIMARY KEY(";
			for (int i = 0; i < primaryKey.length; i++) {
				createTable += primaryKey[i];
				if (i == primaryKey.length - 1)
					break;
				createTable += ", ";
			}
			createTable += ")";
		}
		// creating the Foreign Key SQL
		if (foreignKeys != null) {
			for (int i = 0; i < foreignKeys.length; i++) {
				createTable += ", FOREIGN KEY(";
				if (foreignKeys[i].columns.length != foreignKeys[i].columnsReferenced.length) {
					System.err
							.println("The two arrays in a Foreign Key Object must be the same length");
					System.exit(1);
				}
				for (int j = 0; j < foreignKeys[i].columns.length; j++) {
					createTable += foreignKeys[i].columns[j];
					if (j == foreignKeys[i].columns.length - 1)
						break;
					createTable += ", ";
				}
				createTable += ") REFERENCES " + foreignKeys[i].tableReferenced
						+ " (";
				for (int j = 0; j < foreignKeys[i].columnsReferenced.length; j++) {
					createTable += foreignKeys[i].columnsReferenced[j];
					if (j == foreignKeys[i].columnsReferenced.length - 1)
						break;
					createTable += ", ";
				}
				createTable += ")";
				if (foreignKeys[i].strCascadeOption != null) {
					createTable += foreignKeys[i].strCascadeOption;
				}
			}
		}
		createTable += ")";
		if (Main.verbose)
			Main._logger.outputLog("Creating Table: " + tableName);
		// Executing the SQL to create the table
		try {
			Statement statement;
			if (_statement != null) {
				// experimentsubject
				statement = _statement;
			} else {
				// labshelf
				statement = labStatement;
			}
			statement.executeUpdate(createTable);
			commit();
		} catch (SQLException e) {
			Main._logger.reportError(createTable);
			e.printStackTrace();
			System.exit(1);
		}
	}

	@Override
	public void flushDBMSCache() {
		try {
			String strFlush = "ALTER SYSTEM FLUSH BUFFER_CACHE";
			_statement.execute(strFlush);
			commit();
			strFlush = "ALTER SYSTEM FLUSH SHARED_POOL";
			_statement.execute(strFlush);
			commit();
			strFlush = "ALTER SYSTEM CHECKPOINT";
			_statement.execute(strFlush);
			_connection.commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	public void flushOSCache() {
		flushLinuxCache();
	}

	public String getDBVersion() {
		try {
			ResultSet rs = _statement
					.executeQuery("SELECT * FROM v$version WHERE BANNER LIKE 'Oracle%'");
			rs.next();
			String version = rs.getString(1);
			rs.close();
			return version;
		} catch (SQLException e) {
			return null;
		}
	}

	public String[] getPlanProperties() {
		// return PLAN_TABLE_COLUMNS;
		return null;
	}

	public String[] getPlanOperators() {
		return PLAN_OPERATORS;
	}

	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}

	public void setOptimizerFeature(String featureName, String featureValue) {
		if (Main.verbose) {
			Main._logger
					.outputLog("Optimization Feature is NOT Valid in Oracle");
		}
	}

	/************ START OF NOTEBOOK IMPLEMENTATION ************************/

	// private Statement labStatement;
	// private Statement regStatement;
	// private Connection labConnection;
	// private Connection regConnection;

	/**
	 * Closes the DBMS connection that was opened by the open call.
	 */
	public void closelabshelf() {
		try {
			labConnection.commit();
			labStatement.close();
			regStatement.close();
			labConnection.close();
			regConnection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		labConnection = null;
		regConnection = null;
	}

	/**
	 * Commits all update operations made to the dbms. This must be called for
	 * inserts statements to be seen.
	 */
	public void commitlabshelf() {
		boolean committed = false;
		while (!committed) {
			try {
				if (labConnection != null && !labConnection.isClosed())
					labConnection.commit();
				committed = true;
			} catch (SQLException e) {
				Main._logger.reportError("Commit failed");
				// e.printStackTrace();
				committed = false;
			}
		}
	}

	/**
	 * Opens the connection to the DBMS.
	 * 
	 * @throws DBMSInvalidConnectionParameterException
	 */
	public void openlabshelf() throws DBMSInvalidConnectionParameterException {
		try {
			String strdrvname = getDBMSDriverClassName();
			Class.forName(strdrvname).newInstance();
			labConnection = DriverManager.getConnection(labConnectString,
					labUsername, labPassword);
			labConnection.setAutoCommit(false);
			labStatement = labConnection.createStatement(
					ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
			regConnection = DriverManager.getConnection(labConnectString,
					labUsername, labPassword);
			regConnection.setAutoCommit(false);
			regStatement = regConnection.createStatement();
			reg_ParellelStatement = regConnection.createStatement();
		} catch (SQLException e) {
			String error = "DBMS Connection parameters were not correct.";
			error += " account:" + labUsername + " password:" + labPassword
					+ " conn str:" + labConnectString;
			throw new DBMSInvalidConnectionParameterException(error);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			System.exit(1); // programmer/dbms error
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}

	}

	/**
	 * Builds the SQL query from the parameters. Queries are tailored to run on
	 * Oracle.
	 * 
	 * @param tableName
	 *            The name of the table. This appears in the from clause.
	 * @param selectColumns
	 *            The columns in the select clause.
	 * @param columnNames
	 *            The names of columns used in the where clause.
	 * @param columnValues
	 *            The values of columns used in the where clause.
	 * @param columnDataTypes
	 *            The data types of teh columns.
	 * @return The SQL query built from the parameters.
	 */
	protected String buildQuerySQL(String tableName, String[] selectColumns,
			String[] columnNames, String[] columnValues, int[] columnDataTypes) {
		// checking to make sure all columns are the same length. If they are
		// not exit because only
		// an internal programming error could cause this. This is not a user
		// error.
		if ((columnNames != null && columnValues != null && columnDataTypes != null)
				&& ((columnNames.length != columnValues.length) || (columnValues.length != columnDataTypes.length))) {
			System.err
					.println("executeSimpleQuery: Parameter arrays must be same length");
			System.exit(1); // this is a programmers bug
		}
		// Assembling the SQL query.
		String querySQL = "SELECT ";
		if (selectColumns == null)
			querySQL += "* ";
		else {
			for (int i = 0; i < selectColumns.length; i++) {
				querySQL += selectColumns[i];
				if (i == selectColumns.length - 1)
					break;
				querySQL += ", ";
			}
		}
		querySQL += " FROM " + tableName;
		if (columnNames != null) {
			for (int i = 0; i < columnNames.length; i++) {
				if (i == 0) {
					querySQL += " WHERE ";
				} else {
					if (columnValues[i] == null || columnValues[i].equals("")) {
						continue;
					}
					querySQL += " AND ";
				}
				querySQL += columnNames[i]
						+ "="
						+ formatColumnValue(columnValues[i], columnDataTypes[i]);
			}
		}
		return querySQL;
	}

	/**
	 * Puts a document into the database. This is implemented using an ORACLE
	 * CLOB.
	 * 
	 * @see azdblab.labShelf.LabShelf#putDocument(java.lang.String,
	 *      java.lang.String, java.lang.String[], java.lang.String[], int[],
	 *      java.io.FileInputStream)
	 */
	public int putDocument(String tableName, String clobColumnName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes,
			FileInputStream document) {
		// Builds an SQL query used after the tuple has been inserted with the
		// value EMPTY_CLOB()
		String querySQL = buildQuerySQL(tableName,
				new String[] { clobColumnName }, columnNames, columnValues,
				columnDataTypes);
		Main._logger.outputLog(querySQL);
		querySQL += " FOR UPDATE";
		String colNames[] = new String[columnNames.length + 1];
		String colValues[] = new String[columnValues.length + 1];
		int[] dataTypes = new int[columnDataTypes.length + 1];
		for (int i = 0; i < columnNames.length; i++) {
			colNames[i] = columnNames[i];
			colValues[i] = columnValues[i];
			dataTypes[i] = columnDataTypes[i];
		}
		colNames[colNames.length - 1] = clobColumnName;
		colValues[colValues.length - 1] = "EMPTY_CLOB()";
		dataTypes[dataTypes.length - 1] = GeneralDBMS.I_DATA_TYPE_CLOB;
		String insertSQL = buildInsertSQL(tableName, colNames, colValues,
				dataTypes);
		InputStream in;
		OutputStream out;
		byte[] data = new byte[BUFFER_SIZE];
		try {
			// inserts the tuple for this document into the database.
			labStatement.executeUpdate(insertSQL);
			labConnection.commit();
			// queries for this tuple
			// ResultSet rs = labStatement.executeQuery(querySQL);
			ResultSet rs = commonExecuteQuerySQL(labStatement, querySQL);
			if (!rs.next()) {
				throw new SQLException();
			}
			CLOB clob = ((OracleResultSet) rs).getCLOB(1);
			if (clob == null) {
				Main._logger.reportError(insertSQL);
				Main._logger.reportError(querySQL);
				System.exit(1); // programemer/dbsm error
			}
			// open an input stream from the document.
			in = new BufferedInputStream(document);
			// open an output stream to the clob.
			out = new BufferedOutputStream(clob.getAsciiOutputStream());// getAsciiOutputStream());
			// transferring the data from the file to the document.
			for (int len; (len = in.read(data, 0, BUFFER_SIZE)) > 0; out.write(
					data, 0, len)) {
			}
			out.close();
			in.close();
			rs.close();
			commit();
			return 0;
		} catch (SQLException sqlex) {
			if (sqlex.getErrorCode() == 1) {
				Main._logger.reportError("Plan Already Existed");
			} else {
				sqlex.printStackTrace();
			}
			return -1;
		} catch (IOException e) {
			System.err.println("putDocument encountered a fatal error.");
			e.printStackTrace();
			return -2;
		}
	}

	public int putDocument(String tableName, String clobColumnName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes,
			String content) {

		// Builds an SQL query used after the tuple has been inserted with the
		// value EMPTY_CLOB()
		String querySQL = buildQuerySQL(tableName,
				new String[] { clobColumnName }, columnNames, columnValues,
				columnDataTypes);
		Main._logger.outputLog(querySQL);
		querySQL += " FOR UPDATE";
		String colNames[] = new String[columnNames.length + 1];
		String colValues[] = new String[columnValues.length + 1];
		int[] dataTypes = new int[columnDataTypes.length + 1];
		for (int i = 0; i < columnNames.length; i++) {
			colNames[i] = columnNames[i];
			colValues[i] = columnValues[i];
			dataTypes[i] = columnDataTypes[i];
		}
		colNames[colNames.length - 1] = clobColumnName;
		colValues[colValues.length - 1] = "EMPTY_CLOB()";
		dataTypes[dataTypes.length - 1] = GeneralDBMS.I_DATA_TYPE_CLOB;
		String insertSQL = buildInsertSQL(tableName, colNames, colValues,
				dataTypes);
		OutputStream out;
		try {
			System.out.println(insertSQL);
			labStatement.executeUpdate(insertSQL);
			labConnection.commit();
			// ResultSet rs = labStatement.executeQuery(querySQL);
			ResultSet rs = commonExecuteQuerySQL(labStatement, querySQL);
			if (!rs.next())
				throw new SQLException();
			CLOB clob = ((OracleResultSet) rs).getCLOB(1);
			if (clob == null) {
				Main._logger.reportError(insertSQL);
				Main._logger.reportError(querySQL);
				System.exit(1); // programemer/dbsm error
			}
			rs.close();
			// open an input stream from the document.
			out = new BufferedOutputStream(clob.getAsciiOutputStream());
			out.write(content.getBytes());
			out.close();

			return 0;
		} catch (SQLException e) {
			System.err
					.println("InternalDataBaseController.insertExperiment encountered a fatal "
							+ "error.  Inserted value not present.");
			e.printStackTrace();
			return -1;
		} catch (IOException e) {
			Main._logger
					.reportError("InternalDataBaseController.insertExperiment "
							+ "encountered a fatal error.");
			e.printStackTrace();
			return -2;
		}
	}

	/**
	 * @see azdblab.labShelf.LabShelf#updateDocument(java.lang.String,
	 *      java.lang.String, java.lang.String[], java.lang.String[], int[],
	 *      java.io.FileInputStream)
	 */
	public void updateDocument(String tableName, String documentColumnName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes,
			FileInputStream document) {
		String querySQL = buildQuerySQL(tableName,
				new String[] { documentColumnName }, columnNames, columnValues,
				columnDataTypes);
		querySQL += " FOR UPDATE";
		// The value EMPTY_CLOB() will delete the current value of the CLOB
		String updateSQL = "UPDATE " + tableName + " SET " + documentColumnName
				+ "=EMPTY_CLOB() ";
		for (int i = 0; i < columnNames.length; i++) {
			if (i == 0) {
				updateSQL += " WHERE ";
			} else {
				updateSQL += " AND ";
			}
			updateSQL += columnNames[i] + "="
					+ formatColumnValue(columnValues[i], columnDataTypes[i]);
		}
		InputStream in;
		OutputStream out;
		byte[] data = new byte[BUFFER_SIZE];
		try {
			// Deleting old value of the CLOB
			labStatement.executeUpdate(updateSQL);
			labConnection.commit();
			// Query to get a handle to the tuple that will hold the clob.
			// ResultSet rs = labStatement.executeQuery(querySQL);
			ResultSet rs = commonExecuteQuerySQL(labStatement, querySQL);
			if (!rs.next())
				throw new SQLException();
			CLOB clob = ((OracleResultSet) rs).getCLOB(1);
			if (clob == null) {
				Main._logger.reportError(updateSQL);
				Main._logger.reportError(querySQL);
				System.exit(1); // programmer error or dbsm error
			}
			// opening an input stream to the file that will be uploaded.
			in = new BufferedInputStream(document);
			// opening an output stream to the CLOB
			out = new BufferedOutputStream(clob.getAsciiOutputStream());// clob.getAsciiOutputStream());
			// Transferring the file to the CLOB
			for (int len; (len = in.read(data, 0, BUFFER_SIZE)) > 0; out.write(
					data, 0, len))
				;
			out.close();
			in.close();
			rs.close();
		} catch (SQLException e) {
			System.err
					.println("InternalDataBaseController.insertExperiment encountered a fatal"
							+ " error. Inserted value not present.");
			e.printStackTrace();
			System.exit(1);
		} catch (IOException e) {
			Main._logger
					.reportError("InternalDataBaseController.insertExperiment "
							+ "encountered a fatal error.");
			e.printStackTrace();
			System.exit(1);
		}
	}

	/**
	 * @see azdblab.labShelf.LabShelf#updateDocument(java.lang.String,
	 *      java.lang.String, java.lang.String[], java.lang.String[], int[],
	 *      java.io.FileInputStream)
	 */
	public void updateDocument(String tableName, String documentColumnName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes,
			ByteArrayInputStream contentStream) {
		String querySQL = buildQuerySQL(tableName,
				new String[] { documentColumnName }, columnNames, columnValues,
				columnDataTypes);
		querySQL += " FOR UPDATE";
		// The value EMPTY_CLOB() will delete the current value of the CLOB
		String updateSQL = "UPDATE " + tableName + " SET " + documentColumnName
				+ "=EMPTY_CLOB() ";
		for (int i = 0; i < columnNames.length; i++) {
			if (i == 0) {
				updateSQL += " WHERE ";
			} else {
				updateSQL += " AND ";
			}
			updateSQL += columnNames[i] + "="
					+ formatColumnValue(columnValues[i], columnDataTypes[i]);
		}
		InputStream in;
		OutputStream out;
		byte[] data = new byte[BUFFER_SIZE];
		try {
			// Deleting old value of the CLOB
			labStatement.executeUpdate(updateSQL);
			labConnection.commit();
			// Query to get a handle to the tuple that will hold the clob.
			// ResultSet rs = labStatement.executeQuery(querySQL);
			ResultSet rs = commonExecuteQuerySQL(labStatement, querySQL);
			if (!rs.next())
				throw new SQLException();
			CLOB clob = ((OracleResultSet) rs).getCLOB(1);
			if (clob == null) {
				Main._logger.reportError(updateSQL);
				Main._logger.reportError(querySQL);
				System.exit(1); // programmer error or dbsm error
			}
			// opening an input stream to the file that will be uploaded.
			in = new BufferedInputStream(contentStream);
			// opening an output stream to the CLOB
			out = new BufferedOutputStream(clob.getAsciiOutputStream());// clob.getAsciiOutputStream());
			// Transferring the file to the CLOB
			for (int len; (len = in.read(data, 0, BUFFER_SIZE)) > 0; out.write(
					data, 0, len))
				;
			out.close();
			in.close();
			rs.close();
		} catch (SQLException e) {
			System.err
					.println("InternalDataBaseController.insertExperiment encountered a fatal"
							+ " error. Inserted value not present.");
			e.printStackTrace();
			System.exit(1);
		} catch (IOException e) {
			Main._logger
					.reportError("InternalDataBaseController.insertExperiment "
							+ "encountered a fatal error.");
			e.printStackTrace();
			System.exit(1);
		}

	}

	/**
	 * Retrieves a document from the DBMS. Documents are stored as CLOBS in
	 * oracle.
	 * 
	 * @see azdblab.labShelf.LabShelf#getDocument(java.lang.String,
	 *      java.lang.String, java.lang.String[], java.lang.String[], int[])
	 */
	public InputStream getDocument(String tableName, String clobColumnName,
			String[] columnNames, String[] columnValues, int[] columnDataTypes) {

		String querySQL = buildQuerySQL(tableName,
				new String[] { clobColumnName }, columnNames, columnValues,
				columnDataTypes);

		ResultSet rs = executeQuerySQL(querySQL);
		// ensure that CLOB data doesn't get corrupted
		// retry to get it right until the max attempts
		try {
			rs.next();
			CLOB clob = ((OracleResultSet) rs).getCLOB(1);

			rs.close();
			// open an input stream from the clob
			return clob.getAsciiStream();
			// in = new BufferedInputStream(clob.getAsciiStream());
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}

		return null;

	}

	/**
	 * Deletes tuples from the DBMS.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#deleteRows(java.lang.String,
	 *      java.lang.String[], java.lang.String[], int[])
	 */
	public void deleteRows(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		// If all arrays are not the same length then EXIT.
		if ((columnNames.length != columnValues.length)
				|| (columnValues.length != columnDataTypes.length)) {
			System.err
					.println("deleteRows: Parameter arrays must be same length");
			System.exit(1); // programmer bug
		}
		// Assemblying the DELETE SQL.
		String deleteSQL = "DELETE FROM " + tableName;
		for (int i = 0; i < columnNames.length; i++) {
			if (i == 0) {
				deleteSQL += " WHERE ";
			} else {
				deleteSQL += " AND ";
			}
			deleteSQL += columnNames[i] + "="
					+ formatColumnValue(columnValues[i], columnDataTypes[i]);
		}
		try {
			labStatement.executeUpdate(deleteSQL);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Execute a simple select project query with an order clause.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#executeSimpleOrderedQuery(java.lang.String,
	 *      java.lang.String[], int, int, java.lang.String[],
	 *      java.lang.String[], int[])
	 */
	public ResultSet executeSimpleOrderedQuery(String tableName,
			String[] selectColumns, int indexOfOrderedColumn,
			int orderedDataType, String[] columnNames, String[] columnValues,
			int[] columnDataTypes) {
		String querySQL = buildQuerySQL(tableName, selectColumns, columnNames,
				columnValues, columnDataTypes);
		// The index of the order column must be between 0 and selectColumns -
		// 1.
		if (indexOfOrderedColumn < 0
				|| indexOfOrderedColumn > (selectColumns.length - 1)) {
			Main._logger.reportError("OracleAPI.executeSimpleOrderedQuery(): "
					+ "Invalid indexOfOrderedColumn: " + indexOfOrderedColumn);
			System.exit(1); // okay since fatal programmer error no user error
		}
		// Cannot use this for SELECT * queries. The select clause must specify
		// column names.
		if (selectColumns[indexOfOrderedColumn].equals("*")) {
			System.err
					.println("OracleAPI.executeSimpleOrderedQuery(): Invalid Order Column: "
							+ selectColumns[indexOfOrderedColumn]);
			System.exit(1); // okay since fatal programmer error no user error
		}
		// cannot do an order by with a CLOB data type
		if (orderedDataType == GeneralDBMS.I_DATA_TYPE_CLOB) {
			Main._logger.reportError("OracleAPI.executeSimpleOrderedQuery(): "
					+ "Invalid Order Column Data Type: CLOB");
			System.exit(1); // okay since fatal programmer error no user error
		}
		querySQL += " ORDER BY " + selectColumns[indexOfOrderedColumn];

		ResultSet rs = executeQuerySQL(querySQL);
		return rs;
	}

	/**
	 * Executes a simple select project query.
	 * 
	 * @see azdblab.labShelf.GeneralDBMS#executeSimpleQuery(java.lang.String,
	 *      java.lang.String[], java.lang.String[], java.lang.String[], int[])
	 */
	public ResultSet executeSimpleQuery(String tableName,
			String[] selectColumns, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) {
		String querySQL = buildQuerySQL(tableName, selectColumns, columnNames,
				columnValues, columnDataTypes);

		ResultSet rs = executeQuerySQL(querySQL);
		return rs;
	}

	private void insertTupleWithoutCommit(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) throws SQLException{
		String insertSQL = buildInsertSQL(tableName, columnNames, columnValues,
				columnDataTypes);
		Main._logger.outputLog("insert statement for labshelf: " + insertSQL);
		System.out.println(insertSQL);
		labStatement.executeUpdate(insertSQL);
	}
	
	public void insertTupleToNotebook(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) throws SQLException {
		insertTupleWithoutCommit(tableName, columnNames, columnValues, columnDataTypes);
		commitlabshelf();
	}
	
	/***
	 * insert query execution having clob data for psdiff (to be renamed prodiff) 
	 */
	public void insertQueryExecution(String tableName, String[] columnNames,
			String[] columnValues, int[] columnDataTypes) throws SQLException {
		insertTupleWithoutCommit(tableName, columnNames, columnValues, columnDataTypes);
		for (int i = 0; i < columnDataTypes.length; i++) {
			if (columnDataTypes[i] == GeneralDBMS.I_DATA_TYPE_CLOB) {
				String sql = "SELECT " + columnNames[i] + " FROM " + tableName + " WHERE " + columnNames[0] + " = " + columnValues[0];
				ResultSet rset = labStatement.executeQuery(sql);
			    rset.next();
			    CLOB clob = ((OracleResultSet)rset).getCLOB(1);
			    InputStream is = new ByteArrayInputStream(columnValues[i].getBytes());
			    // opening an input stream to the file that will be uploaded.
			    BufferedInputStream in = new BufferedInputStream(is);
				// opening an output stream to the CLOB
			    BufferedOutputStream out = new BufferedOutputStream(clob.getAsciiOutputStream());// clob.getAsciiOutputStream());
			    int size = clob.getBufferSize();
			    byte[] buffer = new byte[size];
			    int length = -1;
			    try {
					while ((length = in.read(buffer)) != -1)
						out.write(buffer, 0, length);
					in.close();
			    	out.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			    rset.close();
			}
		}
		commitlabshelf();
//	    String sql2 = "SELECT psdiff FROM AZDBLAB_QUERYEXECUTION WHERE " + columnNames[0] + " = " + columnValues[0];
//	    ResultSet rset2 = labStatement.executeQuery(sql2);
//	    rset2.next();
//	    try {
//			System.out.println("clob_string: " + getStringFromClob(rset2, 1));
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	    rset2.close();
//	    sql2 = "delete from azdblab_queryexecution WHERE " + columnNames[0] + " = " + columnValues[0];
//	    labStatement.executeUpdate(sql2);
//	    commitlabshelf();
	}

	protected void reestablishConnection() {
		try {
			regConnection = DriverManager.getConnection(labConnectString,
					labUsername, labPassword);
			regConnection.setAutoCommit(false);
			regStatement = regConnection.createStatement();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void executeUpdateSQL(String sql) {
		try {
			labStatement.executeUpdate(sql);
			commitlabshelf();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	@Override
	public void executeDeleteSQL(String sql) throws SQLException {
		try {
			_statement.executeUpdate(sql);
			commit();
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}

	public void exportResultData(String expFacilityPath, String resultFile) {
		String strExecute = "RUI/RUI FILE="
				+ resultFile
				+ " TABLES=AZDBLAB_USER,AZDBLAB_NOTEBOOK,AZDBLAB_EXPERIMENT,"
				+ "AZDBLAB_EXPERIMENTRUN,AZDBLAB_RUNLOG,AZDBLAB_TEST,AZDBLAB_QUERY,"
				+ "AZDBLAB_QUERYHASPARAMETER,AZDBLAB_CHANGEPOINT,AZDBLAB_PLAN,"
				+ "AZDBLAB_PLANOPERATOR,AZDBLAB_CPHASPLAN,AZDBLAB_TESTSPEC,"
				+ "AZDBLAB_REFERSTESTSPEC,AZDBLAB_DEFINEDASPECT,"
				+ "AZDBLAB_DEFINEDANALYTIC,AZDBLAB_SATISFIESASPECT,"
				+ "AZDBLAB_ANALYTICVALUEOF,AZDBLAB_DATADEFINITION,"
				+ "AZDBLAB_QUERYDEFINITION,AZDBLAB_TABLECONFIG,"
				+ "AZDBLAB_REFERSDATADEF,AZDBLAB_REFERSDQUERYDEF,"
				+ "AZDBLAB_REFERSTABLECONFIG,AZDBLAB_EXECUTOR,AZDBLAB_EXECUTORLOG";
		strExecute = expFacilityPath + "/exp " + strExecute;
		try {
			Runtime.getRuntime().exec(strExecute).waitFor();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void importResultData(String impFacilityPath, String inputFile) {

	}

	/************************ END NOTEBOOK IMPLEMENTATION ******************/

	/**
	 * A constant used to specifiy the size of the buffer that is used to move
	 * data between a CLOB and file or vice versa.
	 */
	private static final int BUFFER_SIZE = 1024;

	/**
	 * The office name of the XMLTYPE
	 */
	private static final String XMLTYPE = "XMLType";

	/**
	 * The office name of the CLOB
	 */
	private static final String CLOB = "CLOB";
	/**
	 * An array of operators specified in Oracle DBMS
	 */
	public static final String[] PLAN_OPERATORS = new String[] { "HASH JOIN" };

	private static final String QUERY_PLAN_TABLE = "PLAN_TABLE";

	private static final String COST_MODEL_PREFIX = "ORA_";
	/**
	 * An array of column names for the table PLAN_TABLE in Oracle.
	 */

	private static final int OPERATION_NAME_INDEX = 5;
	private static final int OBJECT_NAME_INDEX = 9;
	private static final int OBJECT_TYPE_INDEX = 12;
	private static final int ID_INDEX = 15;
	private static final int PARENT_ID_INDEX = 16;
	private static final int COST_INDEX = 19;
	private static final int CARDINALITY_INDEX = 20;
	private static final int BYTES_INDEX = 21;
	private static final int CPU_COST_INDEX = 29;
	private static final int IO_COST_INDEX = 30;
	private static final int TEMP_SPACE_INDEX = 31;
	private static final int TIME_INDEX = 35;

	/**
	 * The name of the data type to store integer numbers in Oracle.
	 */
	private static final String NUMBER = "NUMBER";
	/**
	 * The name of the character data type for ORACLE.
	 */
	private static final String VARCHAR = "VARCHAR2";
	/**
	 * The name of the date data type for ORACLE.
	 */
	private static final String DATE = "DATE";
	/**
	 * A cache of the last timed table's table statistics.
	 */
	private static final String DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
	//private static final String DBMS_NAME = "oracle";
	public static final String DBMS_NAME = "Oracle";
	/**
	 * The connection specific information need to connect to the DBMS.
	 */
	private String labConnectString = null;
	/**
	 * The password used to connect to the DBMS system.
	 */
	private String labPassword = null;
	/**
	 * The username used to connect to the DBMS system.
	 */
	private String labUsername = null;
	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
