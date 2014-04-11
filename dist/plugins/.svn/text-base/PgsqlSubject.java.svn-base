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

import java.util.HashMap;
import java.util.StringTokenizer;
import java.sql.ResultSet;
import java.util.Vector;

import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableNode;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Table;
import azdblab.plugins.experimentSubject.ExperimentSubject;

public class PgsqlSubject extends ExperimentSubject {
	
  public PgsqlSubject(String user_name, String password, String connect_string, String machineName) {
    super(user_name, password, connect_string, machineName);
    // strUserName = "ruizhang";
    // strPassword = "ruizhang";
    //strConnectString = "jdbc:postgresql://sodb12.cs.arizona.edu:5432/research";
  }
	
//  public String getExperimentSubjectName() {
//    return "PostgreSQLSubject";
//  }
	
  public String getDBMSName() {
    return DBMS_NAME;
  }
//  public static String getName(){
//	  return DBMS_NAME;
//  }
  
  public void deleteHelperTables() {
  }
  
  public void copyTable(String newTable, String oriTable) throws Exception{
    try {
      if (tableExists(newTable)) {
    	  _statement.executeUpdate("ROLLBACK");
    	  commit();
    	  _statement.executeUpdate("DROP TABLE " + newTable);
	      // yksuh added commit as below
    	  commit();
      }
      String cloneSQL = "CREATE TABLE " + newTable + " AS SELECT * FROM " + oriTable;
      Main._logger.outputLog(cloneSQL);
      _statement.executeUpdate(cloneSQL);
//   // create an implicit index associated with the primary key
//      if(_expDataDef != null){
//    	  String[] primaryKey = null;
////  		ForeignKey[] foreignKey = null;
//    	  String[] tokens = newTable.split(_expPrefix);
//    	  if(tokens[0].equalsIgnoreCase("")){
//    		  String tblName = tokens[1];
//    		  primaryKey = _expDataDef.getTablePrimaryKey(tblName);
////    		  foreignKey = _expDataDef.getTableForeignKeys(newTable);
//    		  if (primaryKey != null) {
//    			  String commonNotNullSQL = "ALTER TABLE " + newTable + " ALTER COLUMN ";
//    			  for (int i = 0; i < primaryKey.length; i++) {
//    				  String notNullSQL = commonNotNullSQL + primaryKey[i] + " SET NOT NULL";
//    				  _statement.executeUpdate(notNullSQL);
//    			  }
//    			  String alterTable = "ALTER TABLE " + newTable + " ADD PRIMARY KEY(";
//    			  for (int i = 0; i < primaryKey.length; i++) {
//    				  alterTable += primaryKey[i];
//    				  if (i == primaryKey.length - 1) {
//    					  break;
//    				  }
//    				  alterTable += ", ";
//    			  }
//    			  alterTable += ")";
//    			  _statement.executeUpdate(alterTable);
//    		  }
//    	  }
//      }
      commit();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
      throw new Exception(sqlex.getMessage());
    }
  }
	
  public void copyTable(String newTable, String oriTable, long cardinality) throws Exception{
    try {
//    	Main._logger.outputLog("tables: " + newTable + ", " + oriTable + ", card:" + cardinality);
      if (tableExists(newTable)) {
    	  _statement.executeUpdate("DROP TABLE " + newTable);
	      // yksuh added commit as below
    	  commit();
      }
      commit();
      String cloneSQL = "CREATE TABLE " + newTable + " AS SELECT * FROM " +
          oriTable + " WHERE id1 < " + cardinality;
//      Main._logger.outputLog("clone: " + cloneSQL);
      _statement.executeUpdate(cloneSQL);
      
//   // create an implicit index associated with the primary key
//      if(_expDataDef != null){
//    	  String[] primaryKey = null;
////  		ForeignKey[] foreignKey = null;
//    	  String[] tokens = newTable.split(_expPrefix);
//    	  if(tokens[0].equalsIgnoreCase("")){
//    		  String tblName = tokens[1];
//    		  primaryKey = _expDataDef.getTablePrimaryKey(tblName);
////    		  foreignKey = _expDataDef.getTableForeignKeys(newTable);
//    		  if (primaryKey != null) {
//    			  String commonNotNullSQL = "ALTER TABLE " + newTable + " ALTER COLUMN ";
//    			  for (int i = 0; i < primaryKey.length; i++) {
//    				  String notNullSQL = commonNotNullSQL + primaryKey[i] + " SET NOT NULL";
//    				  _statement.executeUpdate(notNullSQL);
//    			  }
//    			  String alterTable = "ALTER TABLE " + newTable + " ADD PRIMARY KEY(";
//    			  for (int i = 0; i < primaryKey.length; i++) {
//    				  alterTable += primaryKey[i];
//    				  if (i == primaryKey.length - 1) {
//    					  break;
//    				  }
//    				  alterTable += ", ";
//    			  }
//    			  alterTable += ")";
//    			  _statement.executeUpdate(alterTable);
//    		  }
//    	  }
//      }
      commit();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
      throw new Exception(sqlex.toString());
    }
  }

  @Override
  public void dropAllInstalledTables() {
	  // TODO Auto-generated method stub
	  String sql = "SELECT relname FROM pg_stat_user_tables";
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
			}
	  }catch (SQLException e) {
		  e.printStackTrace();
	  }
  }
  
  public void printTableStat(String tableName){
//	  String sql_set_stats1 = "ALTER TABLE " + tableName + " ALTER id1 SET STATISTICS 1000";
//	  String sql_set_stats2 = "ALTER TABLE " + tableName + " ALTER id2 SET STATISTICS 1000";
//	  String sql_set_stats3 = "ALTER TABLE " + tableName + " ALTER id3 SET STATISTICS 1000";
//	  String sql_set_stats4 = "ALTER TABLE " + tableName + " ALTER id4 SET STATISTICS 1000";
//	  String analyzeSQL = "ANALYZE " + tableName;
//	  String vaccumSQL = "VACUUM " + tableName;
	  String countSQL = "SELECT count(*) " + "FROM " + tableName;

	  String statSQL = "SELECT reltuples, relpages FROM pg_class where relname = '" + tableName.toLowerCase() + "'";
	  try {
//		    Main.defaultLogger.logging_normal("count: " + countSQL);
		  	ResultSet cs = _statement.executeQuery(countSQL);
		  	if(cs.next()){
		  		Main._logger.outputLog("actual rows: " + cs.getInt(1));
		  	}
		  	cs.close();
//		  	_statement.executeUpdate(sql_set_stats1);
//	      	_statement.executeUpdate(sql_set_stats2);
//	      	_statement.executeUpdate(sql_set_stats3);
//	      	_statement.executeUpdate(sql_set_stats4);
//	      	commit();
//	      	Main.defaultLogger.logging_normal(analyzeSQL);
//			_statement.executeUpdate(analyzeSQL);
//			commit();
			// retrieving the statistics from the DBMS.
			ResultSet ts = _statement.executeQuery(statSQL);
			if (ts.next()) {
				Main._logger.outputLog("tableName: " + tableName.toLowerCase());
				Main._logger.outputLog("NUM_ROWS: " + ts.getLong(1));
				Main._logger.outputLog("NUM Pages: " + ts.getLong(2));
			} else {
				Main._logger.reportError("No statistics for table: " + tableName);
				System.exit(1); // programmer/dbms error
			}
//			Main.defaultLogger.logging_normal("VACCUMMING .... ");
//			_statement.executeUpdate(vaccumSQL);
//			Main.defaultLogger.logging_normal(".... done ");
//			commit();
//			ts = _statement.executeQuery(statSQL);
//			if (ts.next()) {
//				Main.defaultLogger.logging_normal("tableName: " + tableName.toUpperCase());
//				Main.defaultLogger.logging_normal("NUM_ROWS: " + ts.getLong(1));
//				Main.defaultLogger.logging_normal("NUM Pages: " + ts.getLong(2));
//			} else {
//				Main.defaultLogger.logging_error("No statistics for table: " + tableName);
//				System.exit(1); // programmer/dbms error
//			}
			// ts.getStatement().close();
		} catch (SQLException e) {
			e.printStackTrace();
			Main._logger.reportError("No statistics for table: " + tableName);
			System.exit(1); // programmer/dbms error
		}
  }

  @Override
	public void updateTableStatistics(Table table) {
	  	String tableName = table.table_name_with_prefix;
	  	String sql_set_stats1 = "ALTER TABLE " + tableName + " ALTER id1 SET STATISTICS 1000";
	    String sql_set_stats2 = "ALTER TABLE " + tableName + " ALTER id2 SET STATISTICS 1000";
	    String sql_set_stats3 = "ALTER TABLE " + tableName + " ALTER id3 SET STATISTICS 1000";
	    String sql_set_stats4 = "ALTER TABLE " + tableName + " ALTER id4 SET STATISTICS 1000";
	    
	    String sql_update_table_stats = "ANALYZE " + tableName;
	    try {
	      _statement.executeUpdate(sql_set_stats1);
	      commit();
	      _statement.executeUpdate(sql_set_stats2);
	      commit();
	      _statement.executeUpdate(sql_set_stats3);
	      commit();
	      _statement.executeUpdate(sql_set_stats4);
	      commit();
	      _statement.executeUpdate(sql_update_table_stats);
	      commit();
	    } catch (SQLException sqlex) {
	      sqlex.printStackTrace();
	    }
	}
  
  protected String getDataTypeAsString(int dataType, int length) {
    switch (dataType) {
      case GeneralDBMS.I_DATA_TYPE_NUMBER : {
        return NUMBER;
      }
      case GeneralDBMS.I_DATA_TYPE_VARCHAR : {
        return VARCHAR + "(" + length + ")";
      }
      case GeneralDBMS.I_DATA_TYPE_CLOB : {
        return BLOB;
      }
      default : {
        Main._logger.reportError("Unknown data type");
        System.exit(1);
        return null;
      }
    }
  }
  
	public PlanNode getQueryPlan(String sql) throws Exception {
		String explain_plan = "EXPLAIN " + sql;
		ResultSet rs;
		Vector<String> vecDetail = new Vector<String>();
		try {
			rs = _statement.executeQuery(explain_plan);
			Vector<Integer> vecID = new Vector<Integer>();
			Vector<Integer> vecDent = new Vector<Integer>();
			int id = 0;
			int parid = -1;
			int position = 0;
			int flag = 0;
			String type = null;
			String operation = null;
			String tablename = null;
			String cost = null;
			String rows = null;
			String width = null;
			int statementID = 0;
			while (rs.next()) {
				int startindex = 0;
				int endindex = 0;
				String strValues = rs.getString(1);
				// Main.defaultLogger.logging_normal(strValues);
				// strValues = strValues.replace(" ", "#");

				// Main.defaultLogger.logging_normal(strValues);

				int dent = strValues.indexOf("->");

				if (id != 0 && dent < 0) {
					continue;
				}

				// Main.defaultLogger.logging_normal("-" + strValues + " AT DENT " + dent);

				if (strValues.contains("Join") 
				 || strValues.contains("Sort")
				 || strValues.contains("Nested Loop")
				 || strValues.contains("Hash")
				 || strValues.contains("Materialized")) {

					type = "OPERATOR";

					strValues = strValues.replace("->", "").trim();

					operation = strValues.substring(0, strValues.indexOf("(") - 2);

					startindex = strValues.indexOf('(') + 1;
					endindex = strValues.indexOf(')');
					strValues = strValues.substring(startindex, endindex);
					startindex = strValues.indexOf('=') + 1;
					endindex = strValues.indexOf(' ');
					cost = strValues.substring(startindex, endindex);
					strValues = strValues.substring(endindex).trim();
					startindex = strValues.indexOf('=') + 1;
					endindex = strValues.indexOf(' ');
					rows = strValues.substring(startindex, endindex);
					strValues = strValues.substring(endindex).trim();
					startindex = strValues.indexOf('=') + 1;
					width = strValues.substring(startindex);
					tablename = null;
					flag = 1;

					if (id == 0) {
						vecID.add(new Integer(id));
						vecDent.add(new Integer(0));
						parid = -1;

					} else {
						for (int i = vecDent.size() - 1; i >= 0; i--) {
							int oldDent = vecDent.get(i);
							if (dent > oldDent) {
								parid = vecID.get(vecID.size() - 1).intValue();
								vecID.add(new Integer(id));
								vecDent.add(new Integer(dent));
								break;
							}

							if (dent < oldDent) {
								vecID.remove(i);
								vecDent.remove(i);
								continue;
							}

							if (dent == oldDent) {
								vecID.remove(i);
								parid = vecID.get(vecID.size() - 1).intValue();
								vecID.add(new Integer(id));
								break;
							}

						}
					}

				} else if (strValues.contains("on")) {
					type = "TABLE";

					strValues = strValues.replace("->", "").trim();

					tablename = strValues.substring(0,
							strValues.indexOf("(") - 2);
					startindex = strValues.indexOf('(') + 1;
					endindex = strValues.indexOf(')');
					strValues = strValues.substring(startindex, endindex);
					startindex = strValues.indexOf('=') + 1;
					endindex = strValues.indexOf(' ');
					cost = strValues.substring(startindex, endindex);
					strValues = strValues.substring(endindex).trim();
					startindex = strValues.indexOf('=') + 1;
					endindex = strValues.indexOf(' ');
					rows = strValues.substring(startindex, endindex);
					strValues = strValues.substring(endindex).trim();
					startindex = strValues.indexOf('=') + 1;
					width = strValues.substring(startindex);
					flag = 2;

					if (vecID.size() < 1) {
						parid = -1;
					} else {
						parid = vecID.get(vecID.size() - 1).intValue();
					}

				}

				if (flag == 1) {

					String insValues = statementID + "," + id + "," + parid
							+ "," + position + "," + cost + "," + rows + ","
							+ width + "," + operation + "," + type + ","
							+ tablename;
//					Main.defaultLogger.logging_normal(insValues);

					vecDetail.add(insValues);

					// insert_values[statementID]= insValues;

					// Main.defaultLogger.logging_normal(insert_values[statementID]);
					statementID++;

					id++;
					position++;
					flag = 0;

				} else if (flag == 2) {

					String[] strDet = tablename.split(" on ");

					String insValues = statementID + "," + id + "," + parid
							+ "," + position + "," + cost + "," + rows + ","
							+ width + "," + strDet[0] + "," + "OPERATOR" + ","
							+ "";
//					Main.defaultLogger.logging_normal(insValues);

					vecDetail.add(insValues);

					statementID++;
					id++;
					position++;

					insValues = statementID + "," + id + "," + (id - 1) + ","
							+ position + "," + cost + "," + rows + "," + width
							+ "," + "" + "," + "TABLE" + "," + (((strDet[1]).split(" "))[0]).toUpperCase();
//					Main.defaultLogger.logging_normal(insValues);
//System.out.println(insValues);
					vecDetail.add(insValues);

					// Main.defaultLogger.logging_normal(insert_values[statementID]);
					statementID++;
					id++;
					position++;
					flag = 0;
				}

			}

			// for(int i =0;i<statementID;i++){
			// Main.defaultLogger.logging_normal(insert_values[i]);
			// _statement.executeUpdate("INSERT INTO PLAN_TABLE VALUES (" +
			// insert_values[i] + ")");
			// vecDetail.add(insert_values[i]);
			// }

		} catch (SQLException e1) {
			e1.printStackTrace();
			// throw new Exception(empty_plan + "\n", e1);
		}

		PlanNode result = null;

		// try {

		// rs = _statement.executeQuery(select_plan);
		// building a PostgreSQL Plan Tree
		// result = createPlanTree(rs);
		// rs.getStatement().close();
		// }
		// catch (SQLException e) {
		// throw new Exception(select_plan, e);
		// }

		result = createPlanTree(vecDetail);
//System.out.println("plan_code: " + result.myHashCode());
//System.out.println("plan_string: " + result.toString());
		return result;

	}
	
	private PlanNode createPlanTree(Vector<String> vecDetail) {
		Vector<PlanNode> v_tree = new Vector<PlanNode>();
		int numOps = 0;
		for (int i = 0; i < vecDetail.size(); i++) {
			String[] meta = vecDetail.get(i).split(",");
			int number_columns = meta.length;
			// String stmt_id = null;
			String id = null;
			String parent_id = null;
			String node_order = null;
			String operation_name = null;
			String object_type = null;
			String object_name = null;
			String rows = null;
			String width = null;
			String[] columnNames = new String[number_columns];
			String[] columnValues = new String[number_columns];
			HashMap<String, Double> mapRunStat = new HashMap<String, Double>();
			for (int j = 0; j < number_columns; j++) {
				String tempValue = meta[j];
				if (tempValue != null) {
					tempValue = tempValue.trim();
				} else {
					tempValue = "";
				}
				columnNames[j] = PLAN_DETAIL_FIELDS[j];
				columnValues[j] = tempValue;
				switch (j) {

				case PgsqlSubject.STATEMENT_ID_INDEX: {
					// stmt_id = tempValue;
					break;
				}
				case PgsqlSubject.ID_INDEX: {
					id = tempValue;
					break;
				}
				case PgsqlSubject.PARENT_ID_INDEX: {
					parent_id = tempValue;
					break;
				}
				case PgsqlSubject.NODE_ORDER_INDEX: {
					node_order = tempValue;
					break;
				}
				case PgsqlSubject.COST_INDEX: {
					// object_startup_cost = tempValue;
					Vector<?> vecCosts = parseCost(tempValue);
					String startUpCost = (String) vecCosts.get(0);
					String totalCost = (String) vecCosts.get(1);
					if (startUpCost != null)
						mapRunStat.put(COST_MODEL_PREFIX + "STARTUP_COST",
								Double.parseDouble(startUpCost));
					else
						mapRunStat.put(COST_MODEL_PREFIX + "STARTUP_COST", -1.0);
					if (startUpCost != null)
						mapRunStat.put(COST_MODEL_PREFIX + "TOTAL_COST", Double.parseDouble(totalCost));
					else
						mapRunStat.put(COST_MODEL_PREFIX + "TOTAL_COST", -1.0);
					break;
				}
				case PgsqlSubject.ROWS_INDEX: {
					rows = tempValue;
					if (rows != null)
						mapRunStat.put(COST_MODEL_PREFIX + "ROWS", Double.parseDouble(rows));
					else
						mapRunStat.put(COST_MODEL_PREFIX + "ROWS", -1.0);
					break;
					
				}
				case PgsqlSubject.WIDTH_INDEX: {
					width = tempValue;
					if (rows != null)
						mapRunStat.put(COST_MODEL_PREFIX + "WIDTH", Double.parseDouble(width));
					else
						mapRunStat.put(COST_MODEL_PREFIX + "WIDTH", -1.0);
					break;
				}
				case PgsqlSubject.OPERATION_NAME_INDEX: {
					operation_name = tempValue;
					break;
				}
				case PgsqlSubject.OBJECT_NAME_INDEX: {
					object_name = tempValue;
					break;
				}
				case PgsqlSubject.OBJECT_TYPE_INDEX: {
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
				
//				Vector<HashMap<String, Double>> resVec = newnode.getPlanOpCostEstimates();
//				Main.defaultLogger.logging_normal("========='" + ((OperatorNode)newnode).getOperatorName() + "(" + resVec.size() + ")'========");
//				for(i=0;i < resVec.size();i++){
//					HashMap<String, Double> resMap = (HashMap<String, Double>)resVec.get(i);
//					switch (i){
//						case 0 :
//							Main.defaultLogger.logging_normal("STARTUP_COST: " + resMap.get(COST_MODEL_PREFIX + "STARTUP_COST"));
//							break;
//						case 1: 
//							Main.defaultLogger.logging_normal("TOTAL_COST: " + resMap.get(COST_MODEL_PREFIX + "TOTAL_COST"));
//							break;
//						case 2 :
//							Main.defaultLogger.logging_normal("ROWS: " + resMap.get(COST_MODEL_PREFIX + "ROWS"));
//							break;
//						case 3 :
//							Main.defaultLogger.logging_normal("WIDTH: " + resMap.get(COST_MODEL_PREFIX + "WIDTH"));
//							break;
//					}
//				}
//				Main.defaultLogger.logging_normal("==================================================================");
			} else if (object_type.equals("TABLE")) {
				// A TableNode
				newnode = new TableNode(id, parent_id, node_order, object_name,
						columnNames, columnValues);
			}
			if (newnode != null) {
				v_tree.add(newnode);
			}
		}

		PlanNode root = null;

		PlanNode pn = buildTree(root, v_tree);
		// debug only
		// Main.defaultLogger.logging_normal("PLAN_TREE START");
		// Main.defaultLogger.logging_normal(this.toString());
		// Main.defaultLogger.logging_normal("PLAN_TREE_END");
		return pn;
	}
	
  private Vector<String> parseCost(String tempValue) {
	  	Vector<String> resVec = new Vector<String>(); 
		// TODO Auto-generated method stub
	  	String str = tempValue;
//	  	Main.defaultLogger.logging_normal("---- Split by comma '..' ------");
	  	StringTokenizer st = new StringTokenizer(str,"..");	
	  	while(st.hasMoreElements()){
	  		String decimal_token = (String)st.nextElement();
	  		String point_token = (String)st.nextElement();
	  		String cost = decimal_token+"."+point_token;
	  		resVec.add(cost);
//	  		Main.defaultLogger.logging_normal(cost);
	  	}
		return resVec;
	}

protected PlanNode buildTree(PlanNode root, Vector<PlanNode> v_tree) {
    int num_nodes = v_tree.size();
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
      buildTree(root, v_tree);
    } else {
      int	id		= Integer.parseInt(String.valueOf(root.getNodeID()));
      int	chcount	= 0;
      for ( int i = 0; i < num_nodes; i++ ) {
        PlanNode current = (PlanNode) v_tree.get(i);
        int	pid	= Integer.parseInt(String.valueOf(current.getParentID()));
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
	
	public void installExperimentTables(DataDefinition myDataDef, String myPrefix) {
		if (Main.verbose)
			Main._logger.outputLog("Installing Tables");
	
		String[]	myTables	= myDataDef.getTables();
		
		if (!isInstalled(myPrefix, myTables)) {
//			initializeSubjectTables();			// do nothing
			
			for (int i = 0; i < myTables.length; i++) {
				
				//String SQL = "CREATE TABLE " + myPrefix + myTables[i] + "(";
				String[] primary = null;
				ForeignKey[] foreign = null;
				String[] columns = myDataDef.getTableColumns(myTables[i]);
				int[] columnDataTypes = new int[columns.length];
				int[] columnDataTypeLengths = new int[columns.length];
				for (int j = 0; j < columns.length; j++) {
					columnDataTypes[j] = myDataDef.getColumnDataType(myTables[i], columns[j]);
					columnDataTypeLengths[j] = myDataDef.getColumnDataLength(myTables[i], columns[j]);
				}
	
				primary = myDataDef.getTablePrimaryKey(myTables[i]);
				foreign = myDataDef.getTableForeignKeys(myTables[i]);
				
				createTable(
						myPrefix + myTables[i],
						columns,
						columnDataTypes,
						columnDataTypeLengths,
						primary,
						foreign );
//				String[] sortedOns = myDataDef.getSortedOnCols(myTables[i]);
//				String[] hIdxes = myDataDef.getHashIndexColumns(myTables[i]);
//				String[] btIdxes = myDataDef.getBtreeIndexColumns(myTables[i]);
//				String[] uqs = myDataDef.getUniqueCols(myTables[i]);
//				Table tbl = new Table(myTables[i],				// table name
//									  myPrefix,					// table prefix
//									  columns,					// table columns
//									  columnDataTypes,			// table column types
// 									  columnDataTypeLengths,	// table column data length
//									  primary,					// primary keys
//									  foreign,					// foreign keys
//									  sortedOns,				// columns on which this table should be sorted 
//									  hIdxes,					// columns having hash indexes
//									  btIdxes,					// columns having btree indexes
//									  uqs);						// columns having unique constraints
//				createTable(tbl);	
//				createIndex(tbl);
			}
		}
	}
	
	public boolean isInstalled(String strPrefix, String[] tables) {
		/*
		boolean cache = (tableExists(CACHE1_TABLE) && tableExists(CACHE2_TABLE));
	
		for ( int i = 0; i < tables.length; i++ ) {
			if (!tableExists(strPrefix + tables[i]))
				return false;
		}
		
		return cache;
		*/
		return false;
	}
	
//	/**
//	 * @see azdblab.plugins.experimentSubject#timeQuery() 
//	 * As Postgres does not properly support setQueryTimeOut(), we stick to the old method using
//	 * a timer thread to handle timeout.
//	 */
//	public QueryExecutionStat timeQuery(String sqlQuery, PlanNode plan,
//			long cardinality, int time_out) throws SQLException, Exception {
//		PlanNode curr_plan = getQueryPlan(sqlQuery);
//		// verifies that the current query plan is the plan that AZDBLAB thought
//		// it was timing.
//		if (!curr_plan.equals(plan)) {
//			Main._logger.outputLog("query: " + sqlQuery);
//			Main._logger.outputLog("cardinality: " + cardinality);
//			Main._logger.outputLog("hash code for a given plan: "
//					+ plan.myHashCode());
//			Main._logger.outputLog("a given plan: " + plan.toString());
//			Main._logger.outputLog("hash code for a current plan: "
//					+ curr_plan.myHashCode());
//			Main._logger.outputLog("a current plan: " + curr_plan.toString());
//			throw new Exception(
//					"timeQuery: detected plan error.  Tried to time different plan from change point plan");
//		}
//		Main._logger.outputLog("Time out for Postgres is : " + Constants.EXP_TIME_OUT_MS + " (msecs)");
//		String timedQuerySQL = sqlQuery;
//		long start_time;
//		long finish_time;
//		long exec_time = 0;
//		String proc_diff = "N/A";
//		timeOuter = new TimeoutQueryExecution();
//
//		Timer timer = new Timer();
//		try {
//			flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
//			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
//			flushOSCache();
//			Main._logger.outputLog("Finish Flushing OS Cache");
//			flushDBMSCache();
//			Main._logger.outputLog("Finish Flushing DBMS Cache");
//			// create a statement to execute the query
//			query_executor_statement = _connection.createStatement();
//			// set up time out thread
//			timer.scheduleAtFixedRate(timeOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
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
//					LinuxProcessAnalyzer.PLATFORM, beforeStat, afterStat,
//					beforeMap, afterMap);
//			// get the time
//			exec_time = finish_time - start_time;
//			// cancel scheduled timer
//			timer.cancel();
//			// cancel timeout thread
//			timeOuter.cancel();
//			// close the created statement
//			query_executor_statement.close();
//		} catch (SQLException e) {
//			e.printStackTrace();
//			exec_time = Constants.MAX_EXECUTIONTIME;
//			Main._logger.outputLog("Execution too long: Execution time set to "
//					+ exec_time);
//		}
//		if (Main.verbose) {
//			Main._logger.outputLog("Query Plan Execution Time: " + exec_time);
//		}
//		return new QueryExecutionStat(exec_time, proc_diff);
//	}

//	/**
//	 * @see azdblab.plugins.experimentSubject#timePreparedQuery() 
//	 * As MySQL does not properly support setQueryTimeOut(), we stick to the old method using
//	 * a timer thread to handle timeout.
//	 */
//	public QueryExecutionStat timePreparedQuery(String sqlQuery,
//			PreparedStatement pstmt, PlanNode plan, long cardinality,
//			int time_out) throws SQLException, Exception {
//		PlanNode curr_plan = getQueryPlan(sqlQuery);
//		// verifies that the current query plan is the plan that AZDBLAB thought
//		// it // was timing.
//		if (!curr_plan.equals(plan)) {
//			Main._logger.outputLog("query: " + sqlQuery);
//			Main._logger.outputLog("cardinality: " + cardinality);
//			Main._logger.outputLog("hash code for a given plan: "
//					+ plan.myHashCode());
//			Main._logger.outputLog("a given plan: " + plan.toString());
//			Main._logger.outputLog("hash code for a current plan: "
//					+ curr_plan.myHashCode());
//			Main._logger.outputLog("a current plan: " + curr_plan.toString());
//			throw new Exception(
//					"timeQuery: detected plan error.  Tried to time different plan from change point plan");
//		}
//		Main._logger.outputLog("Time out for MySQL is : " + Constants.EXP_TIME_OUT_MS + " (msecs)");
//		long start_time;
//		long finish_time;
//		long exec_time = 0;
//		String proc_diff = "N/A";
//		timePreparedOuter = new TimeoutPreparedQueryExecution(pstmt);
//		
//		Timer timer = new Timer();
//		try {
//			flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
//			Main._logger.outputLog("Finish Flushing Disk Drive Cache");
//			flushOSCache();
//			Main._logger.outputLog("Finish Flushing OS Cache");
//			flushDBMSCache();
//			Main._logger.outputLog("Finish Flushing DBMS Cache");
//			// set up time out thread
//			timer.scheduleAtFixedRate(timePreparedOuter, Constants.EXP_TIME_OUT_MS, Constants.EXP_TIME_OUT_MS);
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
//												  	   afterStat,
//												  	   beforeMap, 
//												  	   afterMap);
//			// get the time
//			exec_time = finish_time - start_time;
//			// cancel scheduled timer
//			timer.cancel();
//			// cancel timeout thread
//			timePreparedOuter.cancel();
//		} catch (SQLException e) {
//			e.printStackTrace();
//			exec_time = Constants.MAX_EXECUTIONTIME;
//			Main._logger.outputLog("Execution too long: Execution time set to " + exec_time);
//		}
//		if (Main.verbose) {
//			Main._logger.outputLog("Query Plan Execution Time: "
//					+ exec_time);
//		}
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
		return PLAN_DETAIL_FIELDS;
	}
	
	public String[] getPlanOperators() {
	return PLAN_OPERATORS;
	}
	
	
//	public boolean tableExists(String table) {
//		try {
//			//attempts to create the table.  If it fails, the table exists and an exception will be thrown.
//			_statement.executeUpdate("CREATE TABLE " + table + " (Name char(1))");
//			commit();
//			//if the table was created, drop it again.
//			_statement.executeUpdate("DROP TABLE " + table);
//			commit();
//			return false;
//		} catch (SQLException e) {
//			commit();
//			return true;
//		}
//	}
	
	
	public void setOptimizerFeature(String featureName, String featureValue) {
		try {
			_statement.execute("set geqo_threshold = 2");
			_statement.execute("set geqo to on");
			
			Main._logger.outputLog("Set PGSQL Optimizer Feature to: Level " + featureValue);
			
			if (featureValue.equals("00")) {
				_statement.execute("set ENABLE_SEQSCAN TO OFF");
				_statement.execute("set ENABLE_INDEXSCAN TO OFF");
				_statement.execute("set ENABLE_TIDSCAN TO OFF");
				_statement.execute("set ENABLE_SORT TO OFF");
				_statement.execute("set ENABLE_NESTLOOP TO OFF");
				_statement.execute("set ENABLE_MERGEJOIN TO OFF");
				_statement.execute("set ENABLE_HASHJOIN TO OFF");
				
				_connection.commit();
				
				ResultSet	rs;
				
				rs	= _statement.executeQuery("SHOW ENABLE_SEQSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SEQSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_INDEXSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_INDEXSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_TIDSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_TIDSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_SORT");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SORT = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_NESTLOOP");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_NESTLOOP = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_MERGEJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_MERGEJOIN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_HASHJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_HASHJOIN = " + rs.getString(1));
				}
				rs.close();
				
			} else if (featureValue.equals("10")) {
				_statement.execute("SET ENABLE_SEQSCAN TO OFF");
				_statement.execute("SET ENABLE_INDEXSCAN TO OFF");
				_statement.execute("SET ENABLE_TIDSCAN TO OFF");
				_statement.execute("SET ENABLE_SORT TO ON");
				_statement.execute("SET ENABLE_NESTLOOP TO ON");
				_statement.execute("SET ENABLE_MERGEJOIN TO ON");
				_statement.execute("SET ENABLE_HASHJOIN TO OFF");
				
				_connection.commit();
				
				ResultSet	rs;
				
				rs	= _statement.executeQuery("SHOW ENABLE_SEQSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SEQSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_INDEXSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_INDEXSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_TIDSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_TIDSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_SORT");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SORT = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_NESTLOOP");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_NESTLOOP = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_MERGEJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_MERGEJOIN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_HASHJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_HASHJOIN = " + rs.getString(1));
				}
				rs.close();
								
				
			} else if (featureValue.equals("20")) {
				_statement.execute("set ENABLE_SEQSCAN TO OFF");
				_statement.execute("set ENABLE_INDEXSCAN TO OFF");
				_statement.execute("set ENABLE_TIDSCAN TO OFF");
				_statement.execute("set ENABLE_SORT TO OFF");
				_statement.execute("set ENABLE_NESTLOOP TO ON");
				_statement.execute("set ENABLE_MERGEJOIN TO OFF");
				_statement.execute("set ENABLE_HASHJOIN TO ON");
				
				_connection.commit();
				
				
				ResultSet	rs;
				
				rs	= _statement.executeQuery("SHOW ENABLE_SEQSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SEQSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_INDEXSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_INDEXSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_TIDSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_TIDSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_SORT");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SORT = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_NESTLOOP");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_NESTLOOP = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_MERGEJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_MERGEJOIN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_HASHJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_HASHJOIN = " + rs.getString(1));
				}
				rs.close();
				
				
				
			} else if (featureValue.equals("30")) {
				_statement.execute("set ENABLE_SEQSCAN TO OFF");
				_statement.execute("set ENABLE_INDEXSCAN TO OFF");
				_statement.execute("set ENABLE_TIDSCAN TO OFF");
				_statement.execute("set ENABLE_SORT TO ON");
				_statement.execute("set ENABLE_NESTLOOP TO ON");
				_statement.execute("set ENABLE_MERGEJOIN TO ON");
				_statement.execute("set ENABLE_HASHJOIN TO ON");
				
				_connection.commit();
				
				
				ResultSet	rs;
				
				rs	= _statement.executeQuery("SHOW ENABLE_SEQSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SEQSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_INDEXSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_INDEXSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_TIDSCAN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_TIDSCAN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_SORT");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_SORT = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_NESTLOOP");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_NESTLOOP = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_MERGEJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_MERGEJOIN = " + rs.getString(1));
				}
				rs.close();
				
				rs	= _statement.executeQuery("SHOW ENABLE_HASHJOIN");
				while (rs.next()) {
					Main._logger.outputLog("ENABLE_HASHJOIN = " + rs.getString(1));
				}
				rs.close();
				
			} else {
			
				Main._logger.outputLog("not a valid optimizer level");
				System.exit(0);
			
			}
			
			
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
	}
	
	public String getDBMSDriverClassName() {
		return DBMS_DRIVER_CLASS_NAME;
	}
	
	
	@Override
	public void flushDBMSCache() {
//		try {
//		String strFlush = "ALTER SYSTEM FLUSH BUFFER_CACHE";
//		_statement.execute(strFlush);
//		commit();
//		strFlush = "ALTER SYSTEM FLUSH SHARED_POOL";
//		_statement.execute(strFlush);
//		commit();
//		strFlush = "ALTER SYSTEM CHECKPOINT";
//		_statement.execute(strFlush);
//		_connection.commit();
//	} catch (SQLException sqlex) {
//		sqlex.printStackTrace();
//	}
//		try {
//			Main._logger.outputLog("flush PostgreSQL DBMS cache ...");
//			commit();
//			String stop_command = "sudo /etc/init.d/postgresql-9.2 stop";
//			Process p = Runtime.getRuntime().exec(stop_command);
//			p.waitFor();
//			Main._logger.outputLog("-- stop postgres");
//			String start_command = "/etc/init.d/postgresql-9.2 start";
//			p = Runtime.getRuntime().exec(start_command);
//			p.waitFor();
//			Main._logger.outputLog("-- restart postgres");
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		
		//sync; /etc/init.d/postgresql-9.0 stop; echo 1 > /proc/sys/vm/drop_caches; /etc/init.d/postgresql-9.0 start
	}
	
	public void flushOSCache() { 
		flushLinuxCache(); 
	}
	
	/**
	 * The office name of the CLOB
	 */
	private static final String BLOB = "BLOB";
	
	/**
	 * An array of operators specified in PostgreSQL DBMS-- To be changed
	 */
	public static final String[] PLAN_OPERATORS	= 
		new String[] {
		"HASH JOIN"
	};
	
	/**
	 * An array of column names for the table PLAN_TABLE in PostgreSQL.
	 */
	public static final String[] PLAN_DETAIL_FIELDS =
		new String[] {
			"STATEMENTID",
			"ID",
			"PARENT_ID",
			"POSITION",
			"COST",
			"ROWS",
			"WIDTH",
			"OPERATION",
			"OBJECT_TYPE",
			"OBJECT_NAME"
			};
		
	
	public static final String[] PLAN_TABLE_PROPERTIES =
		new String[] {
			"STATEMENTID",
			"SELECT_TYPE",
			"POSSIBLE_KEYS",
			"KEY_NAME",
			"KEY_LEN",
			"REF",
			"ROWS",
			"EXTRA"};
	
	/**
	 * The index of the prefix for postgres cost model
	 */
	private static final String COST_MODEL_PREFIX = "PG_";
		
	private static final int STATEMENT_ID_INDEX = 0;
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
	 * The index of the column that has the parent id for the plan_table.
	 */
	private static final int COST_INDEX = 4;
	/**
	 * The index of the column that has the parent id for the plan_table.
	 */
	private static final int ROWS_INDEX = 5;
	/**
	 * The index of the column that has the parent id for the plan_table.
	 */
	private static final int WIDTH_INDEX = 6;
	/**
	 * The index of the column that has the parent id for the plan_table.
	 */
	private static final int OPERATION_NAME_INDEX = 7;
	/**
	 * The index of the column that has the object type for the plan_table.
	 */
	private static final int OBJECT_TYPE_INDEX = 8;
	
	
	private static final int OBJECT_NAME_INDEX = 9;
	/**
	 * The name of the data type to store integer numbers in Oracle.
	 */
	private static final String NUMBER = "INT";
	
	/**
	 * The name of the character data type for PGSQL.
	 */
	private static final String VARCHAR = "VARCHAR";
	
	private static final String DBMS_NAME	= "Pgsql";
	
	private static final String DBMS_DRIVER_CLASS_NAME = "org.postgresql.Driver";

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
		Main._logger.outputLog("Install subject tables ...");
	}

	@Override
	public void disableAutoStatUpdate() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void enableAutoStatUpdate() {
		// TODO Auto-generated method stub
		
	}

	public void SetConnection(Connection connection) {
		// TODO Auto-generated method stub
		_connection = connection;
	}

	public void SetStatement(Statement statement) {
		// TODO Auto-generated method stub
		_statement = statement;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}