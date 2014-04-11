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

public class NewQueryParamEvaluation {
	public static String MYNAME = "NewQueryParamEvaluation";
	
	private static Connection _connection;
	private static Statement _statement;
	private static String     user_name = "azdblab_6_0";
	private static String 	 password = "azdblab_6_0";
//	private static String     user_name = "azdblab_5_20";
//	private static String 	 password = "azdblab_5_20";

	private static String 	 connect_string = "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook";
	private static String 	DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
	private String strPKColumn = "id1";

//	private static String TABLE_NAME   = "azdblab_pk_temp";
//	private static String TABLE_NAME   = "azdblab_pk_param";
	private static String TABLE_NAME   = "azdblab_pk_param_new";
    
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

	private final int NUM_TESTS = 6;

	
	public NewQueryParamEvaluation(){
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
		vecRun.add(new Integer(221));// primary key experiment with 230 queries for 6.0
		vecRun.add(new Integer(319));// primary key experiment with 160 queries for 6.0
//		vecRun.add(new Integer(97));// primary key experiment with 230 queries for 5.20
		// 160 pk exp starts from 5011 query id 
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
//					String tables = splitSQLClause[1];
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
					HashMap<String, Double> resMap = ExaminePKTest(projection, predicateList, groupByList);
			        Map testResMap = new TreeMap(resMap);
					Iterator iter = testResMap.entrySet().iterator();
					while(iter.hasNext()){
				        Map.Entry testEntry =(Map.Entry)iter.next();
				        String testName = (String)testEntry.getKey();
				        double testValue = ((Double)testEntry.getValue()).doubleValue();
				        String insertSQL = "INSERT INTO " + TABLE_NAME + " VALUES (" +
				        				   queryID + ",'" +
				        				   testName + "'," +
				        				   testValue + ")";
System.out.println(insertSQL);
				        stmt.executeUpdate(insertSQL);
				        _connection.commit();
					}
					 stmt.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private HashMap<String, Double> ExaminePKTest(String projection, String[] predicateList, String groupBy) {
		HashMap<String, Double> testResMap = new HashMap<String, Double>();
		
		/***
		 * T0 : the presence of Grouping columns in aggregate function
		 * T1 : the proportion of the presence of primary key in the Grouping columns in aggregate function
		 * T2 : the proportion of the absence  of primary key in the Grouping columns in aggregate function
		 * T3 : the proportion of the presence of primary key in one side join condition
		 * T4 : the proportion of the presence of primary key in both side join condition
		 * T5 : the proportion of the absence  of primary key in a join condition
		 */
		final int T0 = 0;
		final int T1 = 1;
		final int T2 = 2;
		final int T3 = 3;
		final int T4 = 4;
		final int T5 = 5;
		
		double[] testRes = new double[NUM_TESTS];
		
		/***
		 * Test T0 & T1 & T2
		 */
		int totalGroupByCols = 0;
		int totalGroupByPKs = 0;
		if(groupBy != "" && groupBy != null){
			groupBy = groupBy.trim();
			String[] groupByCols = groupBy.split(",| ");
			for(int j=0;j<groupByCols.length;j++){
				String groupByCol = groupByCols[j];
				groupByCol = groupByCol.trim();
				if(groupByCol != null && !groupByCol.equals("")){
					totalGroupByCols++;
					if(groupByCol.contains(strPKColumn)){
						totalGroupByPKs++;
					}
				}
			}
		}
		
		/***
		 * Compute the proportion of PK in Group-By
		 */
		if(totalGroupByCols == 0){
			testRes[T0] = 1;	/*** true or false */
		}else{
			testRes[T1] = (double)totalGroupByPKs / (double)totalGroupByCols;
			testRes[T2] = (double)(totalGroupByCols-totalGroupByPKs) / (double)totalGroupByCols;
		}
		
		int totalNumJoins = 0; 
		int totalNumOneSideJoins = 0;
		int totalNumBothSideJoins = 0;
		int totalNumNonPKJoins = 0;
		boolean flag = false;
		for(int i=0;i<predicateList.length;i++){
			String predicate = predicateList[i];
			if(predicate != null && !predicate.equals(""))
				totalNumJoins++;
			String[] joinColumns = predicate.split("=");
			int count = 0;
			for(int j=0;j<joinColumns.length;j++){
				String joinCol = joinColumns[j];
				if(joinCol.contains(strPKColumn)){
					count++;
				}	
			}
			if(count == 1) totalNumOneSideJoins++;
			if(count == 2) totalNumBothSideJoins++;
			if(count == 0) 
				totalNumNonPKJoins++;
			
			if(count > 0){ // there exists a join condition on PK
				if(!flag) flag = true;
			}
			
			count = 0;
		}
		
		/***
		 * Compute the proportion of PK in one side join
		 */
		testRes[T3] = (double)totalNumOneSideJoins  / (double)totalNumJoins;
		/***
		 * Compute the proportion of PK in both side join
		 */
		testRes[T4] = (double)totalNumBothSideJoins / (double)totalNumJoins;
		/***
		 * Compute the proportion of PK not involved in join
		 */
		testRes[T5] = (double)totalNumNonPKJoins    / (double)totalNumJoins;
		
//		/***
//		 * Create test result map
//		 */
//		testResMap.put("NoGroupBy", 		new Double(testRes[T0]));
//		testResMap.put("PK_InGroupBy", 		new Double(testRes[T1]));
//		testResMap.put("PK_NotInGroupBy", 	new Double(testRes[T2]));
//		testResMap.put("PK_InOnesideJoin", 	new Double(testRes[T3]));
//		testResMap.put("PK_InBothSideJoin", new Double(testRes[T4]));  
//		testResMap.put("PK_NotInJoin", 		new Double(testRes[T5]));
//		if(!flag)
//			testResMap.put("PK_NoJoin", 		new Double(1));
//		else
//			testResMap.put("PK_NoJoin", 		new Double(0));
		/***
		 * Create test result map
		 */
		testResMap.put("NoGroupBy", 		new Double(testRes[T0]));
		testResMap.put("PK_InGroupBy", 		new Double(testRes[T1]));
		testResMap.put("PK_NotInGroupBy", 	new Double(testRes[T2]));
		testResMap.put("PK_InOnesideJoin", 	new Double(testRes[T3]));
		testResMap.put("PK_InBothSideJoin", new Double(testRes[T4]));  
		testResMap.put("PK_NotInJoin", new Double(testRes[T5]));
		if(!flag)
			testResMap.put("NumQueriesWithNoPKInPredicates", 		new Double(1));
		else
			testResMap.put("NumQueriesWithNoPKInPredicates", 		new Double(0));
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
		    
		    //String dropSQL     = "DROP table " + TABLE_NAME;
//			String cloneTblSQL = "create table " + TABLE_NAME + " as SELECT * FROM azdblab_queryhasparameter";
//			String deleteSQL   = "DELETE FROM " + TABLE_NAME;
//			String alterTblSQL = "alter table " + TABLE_NAME + " MODIFY value NUMBER(10, 2)";
		    
		    //try{
			    //_statement.execute(dropSQL);
//System.out.println(dropSQL);  
			    //_connection.commit();
//			    _statement.execute(cloneTblSQL);
//System.out.println(cloneTblSQL);			    
//			    _connection.commit();
//			     _statement.executeUpdate(deleteSQL);
//System.out.println(deleteSQL);			    
//			    _connection.commit();
//			    _statement.execute(alterTblSQL);
//System.out.println(alterTblSQL);			    
//			    _connection.commit();
//		    }catch(Exception e){
//		    	e.printStackTrace();
//		    }
		    
		    NewQueryParamEvaluation qpe = new NewQueryParamEvaluation();
		    qpe.calculateQueryParameters();
		    _statement.close();
		    _connection.close();
		}catch(Exception e){
			e.printStackTrace();
		}

	}
}
