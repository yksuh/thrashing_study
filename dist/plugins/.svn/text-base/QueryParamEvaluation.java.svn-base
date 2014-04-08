package plugins;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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

import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import plugins.QueryStatEvaluation;

import azdblab.Constants;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.dataModel.Experiment;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.plugins.evaluation.Evaluation;
import azdblab.swingUI.objectNodes.CompletedRunNode;
import azdblab.swingUI.objectNodes.ExperimentNode;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.objectNodes.QueryGenDefNode;
import azdblab.swingUI.objectNodes.QueryNode;
import azdblab.swingUI.objectNodes.ScenarioNode;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;

public class QueryParamEvaluation extends Evaluation {
	public static String MYNAME = "QueryParamEvaluation";

	public QueryParamEvaluation(ObjectNode sent) {
		super(sent);
		
		if (!LabShelfManager.getShelf().tableExists(QueryParamEvaluation.PKQUERYPARAM.TableName)) {
			String alterTblSQL = "alter table " + QueryParamEvaluation.PKQUERYPARAM + " MODIFY value NUMBER(10, 3)";
			try{
				LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);	
			}catch(Exception e){
				System.err.println(e.getMessage());
			}
		}
		
		testNames[0] = "NoGroupBy";
		testNames[1] = "PK_InGroupBy";
		testNames[2] = "PK_NotInGroupBy";
		testNames[3] = "PK_InOnesideJoin";
		testNames[4] = "PK_InBothSideJoin";
		testNames[5] = "PK_NotInJoin";
		testNames[6] = "NumQueriesWithNoPKInPredicates";
	}
	
	private String strPKColumn = "id1";

	private final int NUM_TESTS = 7;
	private String[] testNames = new String[NUM_TESTS];
	private String[] strQueries = null;

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
		final int T6 = 6;
		
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
		testResMap.put(testNames[T0], 		new Double(testRes[T0]));
		testResMap.put(testNames[T1], 		new Double(testRes[T1]));
		testResMap.put(testNames[T2], 	new Double(testRes[T2]));
		testResMap.put(testNames[T3], 	new Double(testRes[T3]));
		testResMap.put(testNames[T4], new Double(testRes[T4]));  
		testResMap.put(testNames[T5], new Double(testRes[T5]));
		if(!flag)
			testResMap.put(testNames[T6], 		new Double(1));
		else
			testResMap.put(testNames[T6], 		new Double(0));
		return testResMap;
	}
	
	public static String strVersion = "1.01";
	public static String getVersion() {
		return strVersion;
	}

	@Override
	public String getName() {
		return MYNAME;
	}
	
	public void computeExpPKQueryParam(Experiment exp) {
		int expID = exp.getExperimentID();
		
		if(exp.getExperimentName().contains("pk")){
			
			String sql = "select experimentid from " + QueryParamEvaluation.PKQUERYPARAM + " where experimentid = " + expID;
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			try {
				while(rs.next()){
					if(rs.getLong(1) == expID){
						JOptionPane.showMessageDialog(null,
								"The queries in this experiment have been already analyzed.");
						return;
					}
				}
				rs.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			if(strQueries != null){
				for(int i=0;i<strQueries.length;i++){
					String query = strQueries[i];
								
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
					
					HashMap<String, Double> resMap = ExaminePKTest(projection, predicateList, groupByList);
				        Map testResMap = new TreeMap(resMap);
						Iterator iter = testResMap.entrySet().iterator();
						while(iter.hasNext()){
							Map.Entry testEntry =(Map.Entry)iter.next();
					        String testName = (String)testEntry.getKey();
					        double testValue = ((Double)testEntry.getValue()).doubleValue();
	//				        String insertSQL = "INSERT INTO " + TABLE_NAME + " VALUES (" +
	//				        				   queryID + ",'" +
	//				        				   testName + "'," +
	//				        				   testValue + ")";
					        try {
								LabShelfManager.getShelf().insertTuple(
										QueryParamEvaluation.PKQUERYPARAM.TableName,
										QueryParamEvaluation.PKQUERYPARAM.columns,
										new String[] { String.valueOf(expID), String.valueOf(i), testName, String.valueOf(testValue) },
										QueryParamEvaluation.PKQUERYPARAM.columnDataTypes);
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
					        LabShelfManager.getShelf().commit();
					        LabShelfManager.getShelf().commitlabshelf();
						}
				}
			}
		}else{
			JOptionPane.showMessageDialog(null,
					"This experiment does not concern primary key.");
		}
	}

	/**
	 * returns the query generation definition button
	 * @param queries 
	 * 
	 * @return
	 */
	private Vector<JButton> getQueryGenDefLevelButtons(String[] queries) {
		strQueries = queries;
		
		JButton btn_ComputeQueryExecutionData = new JButton(
				"Evaluate PK Query Parameters");

		btn_ComputeQueryExecutionData.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
//				computeQueryExecutionStats(User
//						.getUser(
//								((CompletedRunNode) myObjectNode).getUserName())
//						.getNotebook(
//								((CompletedRunNode) myObjectNode)
//										.getNotebookName())
//						.getExperiment(
//								((CompletedRunNode) myObjectNode)
//										.getExperimentName()));

				computeExpPKQueryParam(User.getUser(
						((QueryGenDefNode) myObjectNode).getUserName())
				.getNotebook(
						((QueryGenDefNode) myObjectNode)
								.getNotebookName())
				.getExperiment(
						((QueryGenDefNode) myObjectNode)
								.getExperimentName()));
			}
		});

		JButton btn_ShowStatData = new JButton(
				"Show the Overall Statistics");

		btn_ShowStatData.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				computeStat(User.getUser(
						((QueryGenDefNode) myObjectNode).getUserName())
				.getNotebook(
						((QueryGenDefNode) myObjectNode)
								.getNotebookName())
				.getExperiment(
						((QueryGenDefNode) myObjectNode)
								.getExperimentName()));
			}
		});
		
		
		Vector<JButton> toRet = new Vector<JButton>();
		toRet.add(btn_ComputeQueryExecutionData);
		toRet.add(btn_ShowStatData);
		return toRet;
	}
	
	protected void computeStat(Experiment experiment) {
		if(!experiment.getExperimentName().contains("pk")){
			JOptionPane.showMessageDialog(null,	"This experiment does not concern primary key.");
		}
		
		int expID = experiment.getExperimentID();
		long totalQueries = 0;
		String sql = "select count(*) from " + QueryParamEvaluation.PKQUERYPARAM + " where experimentid = " + expID + " and paramname = '" + testNames[0] +"'";
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		try {
			rs.next();
			totalQueries = rs.getLong(1);
			rs.close();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		String strResult = "";
		sql = "select paramname, sum(value) " 
			+ " from " + QueryParamEvaluation.PKQUERYPARAM 
		    + " where experimentid = " + expID + " group by paramname";
		rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		try {
			while(rs.next()){
				String paramName = rs.getString(1);
				long value = rs.getLong(2);
				double pct = ((double)value / (double)totalQueries)*100;
				strResult += paramName + " => " + String.format("%.2f", pct) + " (%)\n";
			}
			rs.close();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		JOptionPane.showMessageDialog(null,	strResult);
	}

	public static InternalTable PKQUERYPARAM = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_PKQUERYPARAM,
			new String[] { "ExperimentID", "QueryNumber", "ParamName", "Value" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER},
			new int[] { 10, 10, 30, 10},
			new int[] { 0, 0, 0, 0 },
			null,
			new String[] { "ExperimentID", "QueryNumber", "ParamName"},
			new ForeignKey[] { new ForeignKey(
					new String[] { "ExperimentID" }, Constants.TABLE_PREFIX
							+ Constants.TABLE_EXPERIMENT,
					new String[] { "ExperimentID" }, " ON DELETE CASCADE") },
			null);
	
	@Override
	public List<JButton> getButtons() {
		if (myObjectNode instanceof QueryGenDefNode) {
			return getQueryGenDefLevelButtons(((QueryGenDefNode)myObjectNode).getQueries());
		}
		return null;
	}

	@Override
	public JPanel getTabs() {
		return null;
	}

	private boolean refreshTable = false;
	
	@Override
	public Vector<InternalTable> getTables() {
		if (refreshTable) {
			LabShelfManager.getShelf()
					.dropTable(PKQUERYPARAM.TableName);
		}

		Vector<InternalTable> toRet = new Vector<InternalTable>();
		toRet.add(PKQUERYPARAM);
		// toRet.add(COMMENT);
		return toRet;
	}

	@Override
	public List<String> getSupportedClasses() {
		Vector<String> toRet = new Vector<String>();
		toRet.add("QueryGenDefNode");
		return toRet;
	}

	@Override
	public Evaluation getInstance(ObjectNode sent) {
		return new QueryParamEvaluation(sent);
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}