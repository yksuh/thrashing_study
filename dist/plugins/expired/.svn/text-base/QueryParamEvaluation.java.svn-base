package plugins.expired;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.Vector;
import java.util.regex.Pattern;

//import azdblab.Constants;
//import azdblab.executable.Main;
//import azdblab.labShelf.dataModel.Experiment;
//import azdblab.labShelf.dataModel.LabShelfManager;
//import azdblab.labShelf.dataModel.Run;
//import azdblab.labShelf.dataModel.User;
//import azdblab.swingUI.dialogs.ProgressDlg;
//import azdblab.swingUI.objectNodes.ScenarioNode;

public class QueryParamEvaluation {
	public static String MYNAME = "QueryParamEvaluation";
	
	private static Connection _connection;
	private static Statement _statement;
	private static String     user_name = "azdblab_6_0";
	private static String 	 password = "azdblab_6_0";

	private static String 	 connect_string = "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook";
	private static String 	DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
	private String strPKColumn = "id1";

	private static String TABLE_NAME   = "azdblab_temp";
    
	public String[] strQueries = {"SELECT t3.id3, t1.id3, t1.id2, SUM(t2.id3)  " +
								"FROM ft_HT1 t1, ft_HT1 t0, ft_HT4 t3, ft_HT1 t2  " +
								"WHERE  (t1.id1=t0.id2 AND t0.id2=t3.id2 AND t3.id2=t2.id3)  " +
								"GROUP BY t3.id3, t1.id3, t1.id1", 
								"SELECT t3.id3, t1.id1, t1.id1, SUM(t2.id1)  " +
								"FROM ft_HT1 t1, ft_HT1 t0, ft_HT4 t3, ft_HT1 t2  " +
								"WHERE  (t1.id1=t0.id1 AND t0.id2=t3.id1 AND t3.id2=t2.id1)", 
								"SELECT t0.id1 " +
								"FROM ft_HT1 t0, ft_HT1 t1  " +
								"WHERE  (t0.id1=t1.id1)"};

	private final int NUM_TESTS = 10;

	public QueryParamEvaluation(){
	}

	private String[] parseQuery(String query){
		String[] splitString = query.split("SELECT|FROM|WHERE|GROUP BY");
		Vector<String> resVec = new Vector<String>();
		for(int i=0;i<splitString.length;i++){
			String str = splitString[i].trim();
			if(str.length() > 0){
				resVec.add(str);
			}
		}
		/***
		 * Convert vector to string array again
		 */
		String[] strResArr = new String[resVec.size()];
		for(int i=0;i<resVec.size();i++){
			strResArr[i] = resVec.get(i);
		}
		return strResArr;
	}
	
	/****
	 * Extract only predicates 
	 * @param predicateList
	 * @return
	 */
	private String[] extractPredicates(String whereClause){
		if(whereClause != null){
			whereClause = whereClause.replaceAll(" |\\(|\\)", "");
			return whereClause.split("AND");
		}
		return null;
	}
	
	/***
	 * Make a copy of field to range set map
	 * @param paramMap	: field to range set map
	 * @return a copy of the map
	 */
	public static HashMap<String, Integer> copyTestResultMap(
			HashMap<String, Integer> paramMap) {
		HashMap<String, Integer> resMap = new HashMap<String, Integer>();
		
		Iterator it = paramMap.entrySet().iterator();
		while(it.hasNext()){
			 // key=value separator this by Map.Entry to get key and value
	        Map.Entry m =(Map.Entry)it.next();
	        // getKey is used to get key of HashMap
	        String key = (String)m.getKey();
	        Integer value = (Integer)m.getValue();
	        resMap.put(key, value);
		}
		return resMap;
	}
	
	/**
	 * This is the query level method that calculates parameters
	 * 
	 * @throws Exception
	 */
	private void calculateQueryParameters() throws Exception {
		
		Vector<Integer> vecRun = new Vector<Integer>();
		vecRun.add(new Integer(221));// primary key experiment for 6.0
		
		for(int i=0;i<vecRun.size();i++){
			String sql = "SELECT queryid, querysql        " +
						 "FROM   azdblab_query q " + 
						 "WHERE  q.runid = " + (vecRun.get(i)).intValue() + " " + 
//						 " AND querynumber < 10 " +
						 "ORDER BY querynumber";
			try {
//				/***
//				 * Queryid, Parameter Name, Parameter Value
//				 */
//				HashMap<Integer, HashMap<String, Integer>> queryParamMap = new HashMap<Integer, HashMap<String, Integer>>();
				
System.out.println(sql);
				ResultSet rs = _statement.executeQuery(sql);
				while (rs.next()) {
					int queryID = rs.getInt(1);
					String query = rs.getString(2);
System.out.println("query["+queryID+"]:" + query);
					
					String[] splitSQLClause = parseQuery(query);
					String projection = splitSQLClause[0];
//System.out.println("projection:" + projection);
					String tables = splitSQLClause[1];
//System.out.println("tables:" + tables);
					String predicates = splitSQLClause[2];
					String[] predicateList = extractPredicates(predicates);
//for(int j=0;j<predicateList.length;j++){
//	String predicate = predicateList[j];
//	System.out.println("predicate: " + predicate);
//}
					String groupByList = null;
					if(splitSQLClause.length == 4){
						groupByList = splitSQLClause[3];
System.out.println("group-by:" + groupByList);
					}
					
					Statement stmt = _connection.createStatement();
					HashMap<String, Integer> resMap = ExaminePKTest(projection, predicateList, groupByList);
//					HashMap<String, Integer> resMap = copyTestResultMap(tempMap);
//System.out.println("size:" + resMap.size());
//					queryParamMap.put(new Integer(queryID), resMap);
					// Move next key and value of HashMap by iterator
//					Map sortedMap = new TreeMap(queryParamMap);
//					Iterator it = sortedMap.entrySet().iterator();
//					while(it.hasNext()){
//				        // key=value separator this by Map.Entry to get key and value
//				        Map.Entry m =(Map.Entry)it.next();
//				        // getKey is used to get key of HashMap
//				        Integer qID = (Integer)m.getKey();
//				        // getValue is used to get value of key in HashMap
//				        HashMap<String, Integer> valueMap = (HashMap<String, Integer>)m.getValue();
				        Map testResMap = new TreeMap(resMap);
						Iterator iter = testResMap.entrySet().iterator();
						while(iter.hasNext()){
					        Map.Entry testEntry =(Map.Entry)iter.next();
					        String testName = (String)testEntry.getKey();
					        int testValue = ((Integer)testEntry.getValue()).intValue();
					        String insertSQL = "INSERT INTO " + TABLE_NAME + " VALUES (" +
					        				   queryID + ",'" +
					        				   testName + "'," +
					        				   testValue + ")";
					        System.out.println(insertSQL);
					        stmt.executeUpdate(insertSQL);
					        _connection.commit();
						}
//					}
					 stmt.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private HashMap<String, Integer> ExaminePKTest(String projection, String[] predicateList, String groupBy) {
		HashMap<String, Integer> testResMap = new HashMap<String, Integer>();
		
		/***
		 * T1 : if the primary key is not on any of the joining column for tables (or there is only one table involved in the query)
		 * T2 : if the primary key is not on any of the Grouping columns in aggregate function and is not on any columns involved in the joins
		 * T3 : if the primary key is not on any of the Grouping columns in aggregate function but is on the columns involved on the joins
		 * T4 : if the primary key is on one side of a join condition, for a subset of the joins
		 * T5 : if the primary key is on one side of a join condition, for all the joins
		 * T6 : if the primary key is on both sides of a join condition, for a subset of the joins
		 * T7 : if the primary key is on both side of a join condition, for all of the joins
		 * T8 : if the primary key is on a non-empty subset of SELECT /GROUP BY columns in an aggregate
		 * T9 : if the primary key is on all the columns of SELECT /GROUP BY columns in aggregate
		 * T10: if the presence of primary keys on non-GROUP BY columns
		 */
		final int T1 = 0;
		final int T2 = 1;
		final int T3 = 2;
		final int T4 = 3;
		final int T5 = 4;
		final int T6 = 5;
		final int T7 = 6;
		final int T8 = 7;
		final int T9 = 8;
		final int T10 = 9;
		
		int[] testRes = new int[NUM_TESTS];
		for(int i=0;i<NUM_TESTS;i++){
			testRes[i] = 1;
		}
		
		/**
		 * Test T2
		 */
//		String aggCol = "";
		boolean existenceInProjection = false, existenceInPredicates = false, existenceInGroupBy = false;
		int totalNumPKAppearancesInProjection = 0;
		int totalProjectionCols = 0;
		projection = projection.trim();
		String[] projCols = projection.split(",| ");
		for(int j=0;j<projCols.length;j++){
			String projCol = projCols[j];
//			if(projCol.contains("SUM")){
//				String[] splitString2 = projCol.split("\\(|\\)");
//				aggCol =  splitString2[1];
//			}
//			if(aggCol != "" && aggCol.contains(strPKColumn)){
//				if(testRes[T2] == 1){
//					testRes[T2] = 0;
//				}
//				if(testRes[T3] == 1){
//					testRes[T3] = 0;
//				}
//			}
			if(projCol.contains(strPKColumn)){
				totalNumPKAppearancesInProjection++;
				existenceInProjection = true;
			}
		}
		totalProjectionCols = projCols.length;
		
		short totalNumOneSideJoins = 0;
		short totalNumBothSideJoins = 0;
		boolean inJoin = false;
		for(int i=0;i<predicateList.length;i++){
			String predicate = predicateList[i];
//System.out.println(predicate);
			/***
			 * PK exists in predicates
			 */
			if(predicate.contains(strPKColumn)){
				/***
				 * Test T1
				 */
				if(testRes[T1] == 1){	
					testRes[T1] = 0;
				}
				/***
				 * Test T2
				 */
				if(testRes[T2] == 1){
					testRes[T2] = 0;
				}
				/***
				 * Test T3
				 */
				if(testRes[T3] == 1 && !inJoin){
					inJoin = true;	
				}
			}
			
			String[] joinColumns = predicate.split("=");
			short count = 0;
			for(int j=0;j<joinColumns.length;j++){
				String joinCol = joinColumns[j];
				if(joinCol.contains(strPKColumn)){
					count++;
					existenceInPredicates = true;
				}	
			}
			if(count == 1) totalNumOneSideJoins++;
			if(count == 2) totalNumBothSideJoins++;
			count = 0;
		}
		
		/***
		 * Test T3
		 */
		if(!inJoin) testRes[T3] = 0;
		
		/***
		 * Test T4
		 */
		if(totalNumOneSideJoins > 0 
		&& totalNumOneSideJoins < predicateList.length) 
			testRes[T4] = 1;
		else testRes[T4] = 0;
		
		/***
		 * Test T5
		 */
		if(totalNumOneSideJoins > 0 
		&& totalNumOneSideJoins == predicateList.length) 
			testRes[T5] = 1;
		else testRes[T5] = 0;
		
		/***
		 * Test T6
		 */
		if(totalNumBothSideJoins > 0 
		&& totalNumBothSideJoins < predicateList.length) 
			testRes[T6] = 1;
		else testRes[T6] = 0;
		
		/***
		 * Test T7
		 */
		if(totalNumBothSideJoins > 0 
		&& totalNumBothSideJoins == predicateList.length) 
			testRes[T7] = 1;
		else testRes[T7] = 0;
		
		/***
		 * Test T8
		 */
		if(totalNumPKAppearancesInProjection > 0 
		&& totalNumPKAppearancesInProjection < totalProjectionCols)
			testRes[T8] = 1;
		else testRes[T8] = 0;
		
		/***
		 * Test T9
		 */
		if(totalNumPKAppearancesInProjection > 0 
		&& totalNumPKAppearancesInProjection == totalProjectionCols)
			testRes[T9] = 1;
		else testRes[T9] = 0;
		
		
		/***
		 * Test T2, T3, and T10
		 */
		if(groupBy != "" && groupBy != null){
			groupBy = groupBy.trim();
			String[] groupByCols = groupBy.split(",| ");
			for(int j=0;j<groupByCols.length;j++){
				String groupByCol = groupByCols[j];
				if(groupByCol.contains(strPKColumn)){
					existenceInGroupBy = true;
					if(groupByCol.contains(strPKColumn)){
						if(testRes[T2] == 1){
							testRes[T2] = 0;
						}
						if(testRes[T3] == 1){
							testRes[T3] = 0;
						}
					}
				}
			}
		}
		if(existenceInProjection && existenceInPredicates && !existenceInGroupBy)
			testRes[T10] = 1;
		else testRes[T10] = 0;

		/***
		 * Create test result map
		 */
		testResMap.put("PK_NotInWhere", 				new Integer(testRes[T1]));
		testResMap.put("PK_NotInGroupByOrJoin", 		new Integer(testRes[T2]));
		testResMap.put("PK_NotInGroupByButInJoin", 		new Integer(testRes[T3]));
		testResMap.put("PK_InOSJoinForSubsetOfJoins", 	new Integer(testRes[T4]));	// os: one side
		testResMap.put("PK_InOSJoinForAllJoins", 		new Integer(testRes[T5]));	
		testResMap.put("PK_InBSJoinForSubsetOfJoins", 	new Integer(testRes[T6]));  // bs: both side
		testResMap.put("PK_InBSJoinForAllJoins", 		new Integer(testRes[T7]));
		testResMap.put("PK_InSubsetOfSelectOrGroupBy", 	new Integer(testRes[T8]));
		testResMap.put("PK_InAllSelectOrGroupBy", 		new Integer(testRes[T9]));
		testResMap.put("PK_InNonGroupBy", 				new Integer(testRes[T10]));
		
		return testResMap;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			Class.forName(DBMS_DRIVER_CLASS_NAME);
		    _connection = DriverManager.getConnection(connect_string, user_name, password);
		    _connection.setAutoCommit(false);
		    _statement = _connection.createStatement();
		    
		    String dropSQL     = "DROP table " + TABLE_NAME;
			String cloneTblSQL = "create table " + TABLE_NAME + " as SELECT * FROM azdblab_queryhasparameter";
		    String deleteSQL   = "DELETE FROM " + TABLE_NAME;
			
		    try{
			    _statement.execute(dropSQL);
			    _connection.commit();
			    _statement.execute(cloneTblSQL);
			    _connection.commit();
			    _statement.executeUpdate(deleteSQL);
			    _connection.commit();
		    }catch(Exception e){
		    	e.printStackTrace();
		    }
		    
		    QueryParamEvaluation qpe = new QueryParamEvaluation();
		    qpe.calculateQueryParameters();
		    _statement.close();
		    _connection.close();
		}catch(Exception e){
			e.printStackTrace();
		}

	}
}
