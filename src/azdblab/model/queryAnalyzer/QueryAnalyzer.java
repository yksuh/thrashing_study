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
package azdblab.model.queryAnalyzer;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;

public class QueryAnalyzer {

	public int iNumCnSel; // # Correlation names in Select
	public int iNumCnFrm; // # Correlation names in From
	public int iNumEqWhere; // # Equal Realtion in Where
	public int iNumInEqWhere; // # Inequal Realtion in Where
	public int iNumAndRel; // # AND Realtion in Where
	public int num_aggregate_functions_;

	public int iNumPredicate;

	public int iNumSelfJoin;

	public int iVarTabMultiInFrom;

	public int iTwoSidedPKJoin;
	public int iOneSidedPKJoin;
	public int iZeroSidedPKJoin;

	public int num_queries_with_1_corname = 0;
	public int num_queries_with_2_corname = 0;
	public int num_queries_with_3_corname = 0;
	public int num_queries_with_4_corname = 0;

	private final int NUM_TESTS = 10;
	private String strPKColumn = "id1";
	
	class QueryStruct {

		private String strSELECTStmt;
		private String strFROMStmt;
		private String strWHEREStmt;

		public QueryStruct(String selectStmt, String fromStmt, String whereStmt) {
			strSELECTStmt = selectStmt;
			strFROMStmt = fromStmt;
			strWHEREStmt = whereStmt;
		}

		public QueryStruct(String selectStmt, String fromStmt) {
			strSELECTStmt = selectStmt;
			strFROMStmt = fromStmt;
			strWHEREStmt = "";
		}

		public int GetNumOfAggregateFunctions() {
			int num_aggregate_funcs = 0;
			String[] selected_attributes = strSELECTStmt.split(",");
			for (int i = 0; i < selected_attributes.length; ++i) {
				if (selected_attributes[i].contains("SUM")
						|| selected_attributes[i].contains("AVG")
						|| selected_attributes[i].contains("MAX")
						|| selected_attributes[i].contains("MIN")
						|| selected_attributes[i].contains("COUNT")) {
					++num_aggregate_funcs;
				}
			}
			return num_aggregate_funcs;
		}

		public int getNumofCorNameInSelect() {

			String[] corNames = strSELECTStmt.split(",");

			return corNames.length;

		}

		public int getNumofCorNameInFrom() {

			String[] corNames = strFROMStmt.split(",");

			return corNames.length;

		}

		public int getNumofInequalInWhere() {
			String[] inequalInstance = strWHEREStmt.split("[<>]");
			return inequalInstance.length;
		}

		public int getNumofequalInWhere() {
			String[] equalInstance = strWHEREStmt.split("=");
			return equalInstance.length;
		}

		public int getNumofANDRelationInWhere() {
			String[] andRelInstance = strWHEREStmt.split("AND");
			return andRelInstance.length;
		}

		public int getNumofPredicate() {
			String[] predicates = strWHEREStmt.split("[AND/OR]");
			int count = 0;

			for (int i = 0; i < predicates.length; i++) {
				if (predicates[i].trim().length() > 0) {
					count++;
				}
			}

			return count;
		}

		public int getNumofSelfJoin() {

			// Parsing the Alias for correlation names.
			String[] corNames = strFROMStmt.split(",");

			// HashMap<String, String> mapTabName = new HashMap<String,
			// String>();

			HashSet<String> setTabName = new HashSet<String>();

			int count = 0;

			for (int i = 0; i < corNames.length; i++) {
				String[] detail = corNames[i].trim().split(" ");
				// mapTabName.put(detail[1], detail[0]);
				if (setTabName.contains(detail[0])) {
					count++;
				} else {
					setTabName.add(detail[0]);
				}
			}

			return count;

			// Check alias for self joins
			/*
			 * String[] predicates = strWHEREStmt.split("[AND/OR]"); int count =
			 * 0;
			 * 
			 * for ( int i = 0; i < predicates.length; i++ ) { if
			 * (predicates[i].trim().length() > 0) {
			 * 
			 * String[] detail = predicates[i].trim().split("="); String left =
			 * detail[0].trim().replaceAll("[(/)]", "").split("\\.")[0]; String
			 * right = detail[1].trim().replaceAll("[(/)]", "").split("\\.")[0];
			 * 
			 * if (mapTabName.get(left).equals(mapTabName.get(right))) {
			 * count++; }
			 * 
			 * } }
			 * 
			 * return count;
			 */

		}

		public int getVarTabMultiInFrom() {

			// Parsing the Alias for correlation names.
			String[] corNames = strFROMStmt.split(",");

			// HashMap<String, String> mapTabName = new HashMap<String,
			// String>();

			HashSet<String> setTabName = new HashSet<String>();

			int count = 0;

			for (int i = 0; i < corNames.length; i++) {
				String[] detail = corNames[i].trim().split(" ");
				// mapTabName.put(detail[1], detail[0]);

				if (setTabName.contains(detail[0])) {
					if (detail[0].equals("ft_HT1")) {
						count++;
					}
				} else {
					setTabName.add(detail[0]);
				}

			}

			if (count > 0) {
				// Main._logger.outputLog(count + "\t" + "1");
				return 1;
			} else {
				// Main._logger.outputLog(count + "\t" + "0");
				return 0;
			}

		}

	}

	private boolean schemaParsed = false;
	private Table[] myTables = new Table[4];

	// private Document myDataSpec;

	public QueryAnalyzer() {

		iNumCnSel = 0;
		iNumCnFrm = 0;
		iNumEqWhere = 0;
		iNumInEqWhere = 0;
		iNumAndRel = 0;

		iNumPredicate = 0;

		iNumSelfJoin = 0;

		iVarTabMultiInFrom = 0;
		iTwoSidedPKJoin = 0;
		iOneSidedPKJoin = 0;
		iZeroSidedPKJoin = 0;

	}

	public void analyzeQuery(Query sqlQuery) {

//		computePrimaryKeyInfo(sqlQuery);

		// Main._logger.outputLog("Analyzing Query: " + sqlQuery);

		String tmpQuery = sqlQuery.strQuerySQL;

		tmpQuery = tmpQuery.replaceFirst("SELECT ", "");
		tmpQuery = tmpQuery.replaceFirst(" FROM ", "TOKEN");
		tmpQuery = tmpQuery.replaceFirst(" WHERE ", "TOKEN");
		tmpQuery = tmpQuery.replaceFirst(" GROUP BY ", "TOKEN");

		String[] queryParts = tmpQuery.split("TOKEN");
		if (sqlQuery.strQuerySQL.contains("GROUP BY")) {
			if (queryParts.length == 3) {
				QueryStruct qs = new QueryStruct(queryParts[0], queryParts[1]);
				iNumCnSel = qs.getNumofCorNameInSelect();
				iNumCnFrm = qs.getNumofCorNameInFrom();
				iNumSelfJoin = qs.getNumofSelfJoin();
				iVarTabMultiInFrom = qs.getVarTabMultiInFrom();
				num_aggregate_functions_ = qs.GetNumOfAggregateFunctions();
			} else if (queryParts.length == 4) {
				QueryStruct qs = new QueryStruct(queryParts[0], queryParts[1],
						queryParts[2]);
				// Main._logger.outputLog("Select Statement: # of cor names " +
				// qs.getNumofCorNameInSelect());
				// Main._logger.outputLog("From Statement: # of cor names " +
				// qs.getNumofCorNameInFrom());
				// Main._logger.outputLog("WHERE Statement: # of = " +
				// (qs.getNumofequalInWhere() - 1));
				// Main._logger.outputLog("WHERE Statement: # of </> " +
				// (qs.getNumofInequalInWhere() - 1));
				// Main._logger.outputLog("WHERE Statement: # of AND pairs " +
				// qs.getNumofANDRelationInWhere());
				// Main._logger.outputLog("WHERE Statement: # of Predicates " +
				// qs.getNumofPredicate());
				// Main._logger.outputLog("WHERE Statement: # of Self Join " +
				// qs.getNumofSelfJoin());
				iNumCnSel = qs.getNumofCorNameInSelect();
				iNumCnFrm = qs.getNumofCorNameInFrom();
				iNumInEqWhere = qs.getNumofequalInWhere() - 1;
				iNumEqWhere = qs.getNumofInequalInWhere() - 1;
				iNumPredicate = qs.getNumofPredicate();
				iNumSelfJoin = qs.getNumofSelfJoin();
				iVarTabMultiInFrom = qs.getVarTabMultiInFrom();
				num_aggregate_functions_ = qs.GetNumOfAggregateFunctions();
			} else {
				Main._logger.reportError("Illeagle Query: "
						+ sqlQuery.strQuerySQL);
				return;
			}
		} else {
			if (queryParts.length == 2) {
				QueryStruct qs = new QueryStruct(queryParts[0], queryParts[1]);
				iNumCnSel = qs.getNumofCorNameInSelect();
				iNumCnFrm = qs.getNumofCorNameInFrom();
				iNumSelfJoin = qs.getNumofSelfJoin();
				iVarTabMultiInFrom = qs.getVarTabMultiInFrom();
				num_aggregate_functions_ = qs.GetNumOfAggregateFunctions();
			} else if (queryParts.length == 3) {
				QueryStruct qs = new QueryStruct(queryParts[0], queryParts[1],
						queryParts[2]);
				// Main._logger.outputLog("Select Statement: # of cor names " +
				// qs.getNumofCorNameInSelect());
				// Main._logger.outputLog("From Statement: # of cor names " +
				// qs.getNumofCorNameInFrom());
				// Main._logger.outputLog("WHERE Statement: # of = " +
				// (qs.getNumofequalInWhere() - 1));
				// Main._logger.outputLog("WHERE Statement: # of </> " +
				// (qs.getNumofInequalInWhere() - 1));
				// Main._logger.outputLog("WHERE Statement: # of AND pairs " +
				// qs.getNumofANDRelationInWhere());
				// Main._logger.outputLog("WHERE Statement: # of Predicates " +
				// qs.getNumofPredicate());
				// Main._logger.outputLog("WHERE Statement: # of Self Join " +
				// qs.getNumofSelfJoin());
				iNumCnSel = qs.getNumofCorNameInSelect();
				iNumCnFrm = qs.getNumofCorNameInFrom();
				iNumInEqWhere = qs.getNumofequalInWhere() - 1;
				iNumEqWhere = qs.getNumofInequalInWhere() - 1;
				iNumPredicate = qs.getNumofPredicate();
				iNumSelfJoin = qs.getNumofSelfJoin();
				iVarTabMultiInFrom = qs.getVarTabMultiInFrom();
				num_aggregate_functions_ = qs.GetNumOfAggregateFunctions();
			} else {
				Main._logger.reportError("Illeagle Query: "
						+ sqlQuery.strQuerySQL);
				return;
			}
		}
		if (iNumCnFrm == 1) {
			++num_queries_with_1_corname;
		} else if (iNumCnFrm == 2) {
			++num_queries_with_2_corname;
		} else if (iNumCnFrm == 3) {
			++num_queries_with_3_corname;
		} else if (iNumCnFrm == 4) {
			++num_queries_with_4_corname;
		}
		// Main._logger.outputLog(iNumCnFrm + " " + iNumSelfJoin);
	}

	private boolean getDocument(Query sent) {
		try {
			String sql = "Select rs.experimentSpecID from "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_QUERY
					+ " q, "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_EXPERIMENTRUN
					+ " r, "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_REFERSEXPERIMENTSPEC
					+ " rs where q.queryid = "
					+ sent.iQueryID
					+ " and q.runid = r.runid and r.experimentID = rs.experimentID and rs.kind = 'D'";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			rs.next();
			int myExperimentSpecID = rs.getInt(1);
			rs.close();

			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();

			factory.setValidating(false);
			factory.setNamespaceAware(true);
			factory.setIgnoringComments(true);
			factory.setIgnoringElementContentWhitespace(true);
			factory.setAttribute(Constants.JAXP_SCHEMA_LANGUAGE,
					Constants.W3C_XML_SCHEMA);
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document myDataSpec = builder
					.parse(LabShelfManager
							.getShelf()
							.getDocument(
									Constants.TABLE_PREFIX
											+ Constants.TABLE_EXPERIMENTSPEC,
									"SourceXML",
									new String[] { "ExperimentSpecID" },
									new String[] { String
											.valueOf(myExperimentSpecID) },
									new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER }));

			Element e = myDataSpec.getDocumentElement();
			NodeList nl = e.getElementsByTagName("table");
			for (int i = 0; i < nl.getLength(); i++) {
				Element tmp = (Element) nl.item(i);
				myTables[i] = new Table("ft_"+tmp.getAttribute("name"));

				NodeList colList = tmp.getElementsByTagName("column");
				for (int j = 0; j < colList.getLength(); j++) {
					Element col = (Element) colList.item(j);
					myTables[i].myColumns[j] = new TableColumn(col.getAttribute("name"), Boolean
									.parseBoolean(col
											.getAttribute("inPrimaryKey")));
				}
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	private void computePrimaryKeyInfo(Query sent) {
		// 1) if necessary parse the table info out
		if (!schemaParsed) {
			schemaParsed = getDocument(sent);
		}

		String querySql = sent.strQuerySQL;
		querySql = querySql.replace("SELECT", "");
		querySql = querySql.replace("FROM", "TOKEN");
		querySql = querySql.replace("WHERE", "TOKEN");

		String[] clauses = querySql.split("TOKEN");

		if (clauses.length == 2) {
			// no where clause
			// the number of joins is zero, thus we can just return
			return;
		}

		// 2) We must create a mapping from the queries table name to the
		// schema's table name
		String[] tables = clauses[1].split(",");

		HashMap<String, String> tableMapping = new HashMap<String, String>();
		// table mapping will be key: queryTableName ----> Value:
		// schemaTableName
		for (int i = 0; i < tables.length; i++) {
			String tableString = tables[i].trim();
			String schemaTable = tableString.split(" ")[0];
			String queryTable = tableString.split(" ")[1];
			tableMapping.put(queryTable, schemaTable);
		}

		// 3) We can then look at all of the elements in the where clause to
		// determine wheteher they are zero, one, or two sided pk joins

		String where = clauses[2].replace("(", "");
		where = where.split("\\)")[0].trim();
		String[] joins = where.split("[AND/OR]");
		for (int i = 0; i < joins.length; i++) {
			String clause = joins[i].trim();
			if (clause.equals("") || clause == null) {
				continue;
			}
			boolean leftIsPK = isPK(clause.split("=")[0], tableMapping);
			boolean rightIsPK = isPK(clause.split("=")[1], tableMapping);

			if (leftIsPK == true && rightIsPK == true) {
				iTwoSidedPKJoin++;
			} else if (leftIsPK == true || rightIsPK == true) {
				iOneSidedPKJoin++;
			} else {
				iZeroSidedPKJoin++;
			}
		}
	}

	public boolean isPK(String clause, HashMap<String, String> mapping) {
		String table = mapping.get(clause.split("\\.")[0]);
		String column = clause.split("\\.")[1];
		mapping.get(table);

		for (int i = 0; i < myTables.length; i++) {
			if (myTables[i].tableName.equalsIgnoreCase(table)) {
				for (int j = 0; j < myTables[i].myColumns.length; j++) {
					if (myTables[i].myColumns[j].columnName
							.equalsIgnoreCase(column)) {
						return myTables[i].myColumns[j].isPrimaryKey;
					}
				}
			}
		}
		return false;
	}

	public void reset() {
		iNumCnSel = 0;
		iNumCnFrm = 0;
		iNumEqWhere = 0;
		iNumInEqWhere = 0;
		iNumAndRel = 0;

		iNumPredicate = 0;

		iNumSelfJoin = 0;

		iVarTabMultiInFrom = 0;
		iTwoSidedPKJoin = 0;
		iOneSidedPKJoin = 0;
		iZeroSidedPKJoin = 0;

	}

	private class Table {
		String tableName;
		TableColumn[] myColumns = new TableColumn[4];

		public Table(String name) {
			tableName = name;
		}
	}

	private class TableColumn {
		String columnName;
		boolean isPrimaryKey;

		public TableColumn(String name, boolean isPK) {
			columnName = name;
			isPrimaryKey = isPK;
		}
	}

	/************************************
	 * Young: We have incorporated QueryParamEvaluation Plugin into QueryAnalyzer, to evaluate PK query statistics
	 ************************************/
	
	/*****
	 * Parse a PK query
	 * @param query
	 * @return
	 */
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
	
	/***
	 * Calculate Query Parameters
	 * @param queryObj Query instance
	 */
	public HashMap<String, Double> calculateQueryParameters(Query queryObj) {
		String query = queryObj.strQuerySQL;
System.out.println("query["+queryObj.iQueryID+"]:" + query);
		
		String[] splitSQLClause = parseQuery(query);
		String projection = splitSQLClause[0];
System.out.println("projection:" + projection);
		String tables = splitSQLClause[1];
System.out.println("tables:" + tables);
		String predicates = splitSQLClause[2];
		String[] predicateList = extractPredicates(predicates);
//for(int j=0;j<predicateList.length;j++){
//String predicate = predicateList[j];
//System.out.println("predicate: " + predicate);
//}
		String groupByList = null;
		if(splitSQLClause.length == 4){
			groupByList = splitSQLClause[3];
//System.out.println("group-by:" + groupByList);
		}
		
		HashMap<String, Double> resMap = ExaminePKTest(projection, predicateList, groupByList);
		return resMap;
	}
}
