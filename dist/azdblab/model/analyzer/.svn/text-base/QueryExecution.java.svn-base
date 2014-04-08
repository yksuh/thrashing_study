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
package azdblab.model.analyzer;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;

/**
 * This object store information about change points that can be 
 * used to record them in the internal tables for AZDBLab.
 *
 */
public class QueryExecution {
	/**
	 * This internal class stores information about change point tables
	 * that can be used to record them in the internal tables for AZDBLab.
	 * 
	 */
	public class QueryExecutionTable {
		/**
		 * The max value that defined the change point.  The min and max will be the same
		 * once AZDBLab has located the change point.
		 */
		public long max_val; //max is the hy card value where change occured
		/**
		 * The min value that defined the change point.  The min and max will be the same 
		 * once AZDBLab has located the change point.
		 */
		public long min_val; //min is value right before it changes
		/**
		 * The name of the table that has these min and max cardinalities.
		 */
		public String table_name;
		
	}
	
	private int numOfOperators; 	
	
	public int getNumOfOperators(){
		return numOfOperators;
	}
	
	public void setNumOfOperators(int ops){
		numOfOperators = ops;
	}
	
	/**
	 * The number of tables that this change point has.  Currently there 
	 * is only one variable table so this will be one.
	 * @param num_tables The number of variable tables.
	 */
	public QueryExecution(int num_tables) {
		myQueryExecutionTables = new QueryExecutionTable[num_tables];
		for (int i = 0; i < num_tables; i++)
			myQueryExecutionTables[i] = new QueryExecutionTable();
	}
	
	public QueryExecution(int num_tables, 
						  PlanNode plan, 
						  long min, 
						  long max, 
						  String tableName, 
						  QueryExecutionStat qes, 
						  int iterNum,
						  int phaseNum) {
		myQueryExecutionTables = new QueryExecutionTable[num_tables];
		for (int i = 0; i < num_tables; i++)
			myQueryExecutionTables[i] = new QueryExecutionTable();
		this.plan = plan;
		this.myQueryExecutionTables[0].max_val = min;
		this.myQueryExecutionTables[0].min_val = max;
		this.myQueryExecutionTables[0].table_name = tableName;
		if (qes != null) {
			this.exec_time = qes.getQueryTime();
			this.proc_diff_ = qes.getProcDiff();
		}
		this.iternum = iterNum;
		this.phaseNumber = phaseNum;
	}
	
	
	/**
	 * The number of tables that this change point has.  Currently there 
	 * is only one variable table so this will be one.
	 * @param num_tables The number of variable tables.
	 */
	public QueryExecution(String name, int num_tables) {
		myQueryExecutionTables = new QueryExecutionTable[num_tables];
		for (int i = 0; i < num_tables; i++){
			myQueryExecutionTables[i] = new QueryExecutionTable();
		}
	}
		
	/**
	 * The execution time for this change point being run on the DBMS.
	 */
	public long exec_time;
	
	public String proc_diff_;
//	/**
//	 * Indicates whether this change point is the optimal change point or 
//	 * has the query plan that is the optimal query plan.
//	 */
//	public boolean isOptimal;
	/**
	 * An array of change point tables for this change point.  These tables and their
	 * cardinality define the change point.
	 */
	public QueryExecutionTable[] myQueryExecutionTables;
	/**
	 * The query plan that is associated with this change point.
	 */
	public PlanNode plan;
	/**
	 * The plan number for this change point's query plan.
	 */
	//public int plan_number;
	public long	planID;
	
	public int planNumber;
	
	public int phaseNumber;
	public long max_exec_time;
	public long min_exec_time;
	public int iternum;
	
	/**
	 * We create cost estimate map associated with each plan operator
	 * e.g) Sort Operator (indexed by an integer which is order) : <IO_Cost, 10.0>, <CPU_Cost, 30.0>
	 */
//	private HashMap<String, Double>[] mapRunStats = null; 	
//	private ArrayList<HashMap<String, Double>> mapRunStats = null;
	
//	/**
//	 * Returns the current run stat map associated with this query run
//	 * 
//	 *  @param None
//	 *  @return HashMap<String, Double>[]
//	 */
//	public ArrayList<HashMap<String, Double>> getMapRunStats() {
//		return mapRunStats;
//	}
//	
//	/**
//	 * Returns the current array of run stat maps associated with this query run
//	 * 
//	 *  @param HashMap<String, Double>[] : array of run stat maps 
//	 *  @return None
//	 */
//	public void setMapRunStats(ArrayList<HashMap<String, Double>> runstats) {
//		mapRunStats = runstats;
//	}
	
	public int getResultCardinality(){
		int resValue = 0;
		PlanNode rootNode = this.plan;
		HashMap<String, Double> resMap = rootNode.getOpCostEstimates();
		Set<?> s = resMap.entrySet();
        // Move next key and value of HashMap by iterator
        Iterator<?> it=s.iterator();
        while(it.hasNext())
        {
            // key=value separator this by Map.Entry to get key and value
            Map.Entry<?, ?> m =(Map.Entry<?, ?>)it.next();
            // getKey is used to get key of HashMap
            String key = (String)m.getKey();
            // getValue is used to get value of key in HashMap
            Double value = (Double)m.getValue();
            
            key = key.toUpperCase();
            // DBMS-specific name of resultCardinality
            if(key.contains("CARDINALITY")   // oracle
            || key.contains("STREAM_COST")   // db2
            || key.contains("ESTIMATEROWS")  // sqlserver
            || key.contains("ROWS"))		 // postgres/mysql/Teradata
            {
//            	Main._logger.outputLog("====== < " + ((OperatorNode)rootNode).getOperatorName() +">============");
//                Main._logger.outputLog("(" + key + ", " + value + ")");
            	resValue = value.intValue();
            	break;
            }
        }
        return resValue;
	}
	
//	public void collectRunStats() {
//		// TODO Auto-generated method stub
//		// get a plan
//		// get all cost estimates associated with this plan
//		int ops = plan.getNumOfOperators();
////Main._logger.outputLog("# of ops : " + ops);
//		this.setNumOfOperators(ops);
////		HashMap<String, Double>[] mapRunStats = new HashMap[ops];
////		ArrayList<HashMap<String, Double>> mapRunStatList = new ArrayList<HashMap<String, Double>>(ops);
////		mapRunStats = new ArrayList<HashMap<String, Double>>(ops);
//		PlanNode root = this.plan;
//		for(int i=0;i<ops;i++){
//			PlanNode iterNode = root.findPlanNode(root, i);
//			if(iterNode == null) continue;
//			HashMap<String, Double> resMap = iterNode.getOpCostEstimates();
//			// Get hashmap in Set interface to get key and value
//	        Set s = resMap.entrySet();
//	        // Move next key and value of HashMap by iterator
//	        Iterator it=s.iterator();
////	        Main._logger.outputLog("====== < " + ((OperatorNode)iterNode).getOperatorName() +">============");
//	        HashMap<String, Double> mapEntry = new HashMap<String, Double>();
//	        while(it.hasNext())
//	        {
//	            // key=value separator this by Map.Entry to get key and value
//	            Map.Entry m =(Map.Entry)it.next();
//	            // getKey is used to get key of HashMap
//	            String key = (String)m.getKey();
//	            // getValue is used to get value of key in HashMap
//	            Double value = (Double)m.getValue();
////	            Main._logger.outputLog("(" + key + ", " + value + ")");
//	            mapEntry.put(key, value);
////	            mapRunStats[i].put(key, value);
//	        }
//	        mapRunStats.add(mapEntry);
////	        Main._logger.outputLog("===================");			
//		}
//	}
}
