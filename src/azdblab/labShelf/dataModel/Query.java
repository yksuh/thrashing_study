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
package azdblab.labShelf.dataModel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import azdblab.Constants;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.TableNode;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.XMLHelper;

/**
 * Used to store essential information about a query for the user.
 * 
 * @author Kevan Holdaway, Ben Youngblood
 * 
 */
public class Query extends TableDefinition {
	public int iQueryID;

	/**
	 * The query number for the query.
	 */
	public int iQueryNumber;

	/**
	 * The query SQL source for the query.
	 */
	public String strQuerySQL;

	private String userName;
	private String notebookName;
	
	private HashMap<Long, Integer> _plan_num_map;	// plan number hash map
	private int 				   _next_plan_num;	// plan number of gui

	/**
	 * Creates a query object with queryNumber and sql as the actual query
	 * source.
	 * 
	 * @param queryNumber
	 *            The query number for this query.
	 * @param sql
	 *            The SQL source for the query.
	 * @param parent
	 */
	public Query(String userName, String notebookName,
			     int queryID, int queryNumber, String sql) {
		this.userName = userName;
		this.notebookName = notebookName;
		iQueryID = queryID;
		iQueryNumber = queryNumber;
		strQuerySQL = sql;
		
		_plan_num_map = new HashMap<Long, Integer>();
		_next_plan_num = 0;
	}
	
	/***
	 * Return a corresponding plan number associated with plan_code
	 * @param plan_code
	 * @return
	 */
	public int obtainPlanNum(long plan_code){
		Long planCode = new Long(plan_code);
		Integer iPlanNum = _plan_num_map.get(planCode);
		if(iPlanNum == null){
			iPlanNum = new Integer(_next_plan_num++);
			// new plan
			_plan_num_map.put(planCode, iPlanNum);
		}
		return iPlanNum.intValue();
	}

	public HashMap<Long, Integer> getPlanNumMap(){
		return _plan_num_map;
	}
	public int getNextPlanNum(){
		return _next_plan_num;
	}
	
	
	public int getQueryID() {
		return iQueryID;
	}

	/**
	 * @return the iQueryNumber
	 */
	public int getiQueryNumber() {
		return iQueryNumber;
	}

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @return
	 */
	public int getExperimentRunQueryNumber() {

		return iQueryNumber;

	}

	/**
	 * @return the strQuerySQL
	 */
	public String getStrQuerySQL() {
		return strQuerySQL;
	}

	protected Element constructQueryResultElem(Document root, 
											Vector<QueryExecution> rqe) {
//Main._logger.outputLog("**<BEGIN> build result xml result on all query executions ********");
		Element queryResult = root.createElement("queryResult");
		queryResult.setAttribute("sql", strQuerySQL);
		for(int i=0;i<rqe.size();i++){
			QueryExecution curr_qe = (QueryExecution)rqe.get(i);
			Element query_execution;
			query_execution = root.createElement("queryExecution");
			query_execution.setAttribute("executionTime", curr_qe.exec_time + "");
			query_execution.setAttribute("procdiff", curr_qe.proc_diff_ + "");
			query_execution.setAttribute("iternum", curr_qe.iternum + "");
			query_execution.setAttribute("units", "milli seconds");
			query_execution.setAttribute("planNumber", curr_qe.planNumber + "");
			query_execution.setAttribute("phaseNumber", curr_qe.phaseNumber + "");
			for (int k = 0; k < curr_qe.myQueryExecutionTables.length; k++) {
				Element table = root.createElement("table");
//				table.setAttribute("name", "ft_HT1");
				table.setAttribute("cardinality", curr_qe.myQueryExecutionTables[k].max_val + "");
				query_execution.appendChild(table);
			}
			queryResult.appendChild(query_execution);
		}
		return queryResult;
//Main._logger.outputLog("**<END> build result xml result on all query executions ********");
	}
		
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @return
	 */
	public Element getQueryResult(int[] phases) {

		int queryID = iQueryID;

		if (queryID == -1) {
			System.err.println("get Query Result Err.");
			return null;
		}

		String query_id = String.valueOf(queryID);
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setIgnoringElementContentWhitespace(true);
			DocumentBuilder builder;
			builder = factory.newDocumentBuilder();

			int numVarTbls = 1;
	        
			// Creating a blank new document.
			Document resultXML = builder.newDocument();
			Element resultElement = resultXML.createElement("result");
			
			// construct query execution result list
			Vector<QueryExecution> qeList = new Vector<QueryExecution>();
			// Retrieves the result and validates it.
			for (int i = 0; i < phases.length; i++) {
				String sqlQueryHasResult = "SELECT qe.Cardinality, qe.iterNum, qe.runtime, qe.procdiff, qep.planid " +
										   "FROM " + QUERY + " q, " + QUERYEXECUTION + " qe, " 
										   		   + QUERYEXECUTIONHASPLAN + " qep " +
										   "WHERE q.QueryID = " + query_id + " AND q.QueryID = qe.QueryID " +
										   "AND qe.QueryExecutionID = qep.queryexecutionid " +  
										   "AND PhaseNumber = " + phases[i] + " " + 
										   "ORDER BY qe.Cardinality desc, qe.iternum asc ";
//Main._logger.outputLog("SQL: " + sqlQueryHasResult);
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sqlQueryHasResult);
		        try {
					while (rs.next()) {
						QueryExecution qe = new QueryExecution(numVarTbls);
						qe.myQueryExecutionTables[0].min_val 	= rs.getLong(1);
						qe.myQueryExecutionTables[0].max_val	= rs.getLong(1);
						qe.exec_time 		= rs.getLong(2);
						qe.iternum	 		= rs.getInt(3);
						qe.proc_diff_		= LabShelfManager.getShelf().getStringFromClob(rs, 4);
						qe.planNumber 		= this.obtainPlanNum(rs.getInt(5));
						qeList.add(qe);						
					}
				} catch (SQLException e) {
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			Element queryResult = constructQueryResultElem(resultXML, qeList);
			try{
				FileInputStream err_template = new FileInputStream(
						new File(
								Constants.CHOSEN_QUERYRESULTERR_TEMPLATE));
				resultElement
				.appendChild(resultXML
						.importNode(
								XMLHelper
										.validate(
												new FileInputStream(
														new File(
																Constants.CHOSEN_QUERY_RESULT_SCHEMA)),
												err_template)
										.getDocumentElement(),
								true));
				resultElement.appendChild(queryResult);
			}catch(Exception ex){
				ex.printStackTrace();
			}
			return resultElement;
		} catch (ParserConfigurationException e) {
			return null;
		}
	}
	

	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @return
	 */
	public List<String> getSatisfiedAspect() {

		int queryID = iQueryID;

		if (queryID == -1) {
			System.err.println("get Satisfied Aspect for Query Err.");
			return null;
		}

		Vector<String> result = new Vector<String>();

		String sql = "SELECT da.AspectName " + " " + "FROM "
				+ DEFINEDASPECT.TableName + " da, " + SATISFIESASPECT.TableName
				+ " sa " + "WHERE da.AspectID = sa.AspectID AND sa.QueryID = "
				+ queryID + "";

		try {
			// Queries the DBMS for the test results of an experiment.
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);

			if (rs == null) {
				return null;
			}

			String source = " Defined by user " + userName;
			if ((notebookName != null)
					&& (!notebookName.equals(""))) {
				source += " with notebook " + notebookName;
			}

			while (rs.next()) {

				String aspName = rs.getString(1);
				// String aspValue = rs.getString(2);

				result.add(aspName + "##" + source + "\n");

			}

			return result;

		} catch (SQLException sqlex) {
			// sqlex.printStackTrace();
			return null;
		}
	}

	
	/****
	 * Insert a query execution into notebook.
	 * @param phase
	 * @param queryNumber
	 * @param queryexecution_number
	 * @param cardinality
	 * @param resultCardinality
	 * @param runTime
	 * @param proc_diff
	 * @param iterNum
	 * @return QueryExecutionID query execution id
	 */
	public int insertQueryExecution(int phase, int queryNumber, int queryexecution_number,
			long cardinality, long resultCardinality, long runTime, String proc_diff,
			int iterNum, int type) throws Exception{	
		int	queryID	= iQueryID;
		
		if (queryID == -1) {
			System.err.println("insert QueryExecution Err.");
			return -1;
		}
		
		Main._logger.outputLog("Inserting query execution : " + queryexecution_number + " for query " + queryNumber);
//		Main._logger.outputLog("On LabShelf : " + Constants.getLABNOTEBOOKNAME());
		int			QueryExecutionID		= LabShelfManager.getShelf().getSequencialID("SEQ_QUERYEXECUTIONID");

		String[] columnNames = new String[] {"QueryExecutionID", 
											 "QueryID", 
											 "Phase", 
											 "queryExecutionNumber", 
											 "Cardinality", 
											 "ResultCardinality", 
											 "RunTime", 
											 "procdiff", 
											 "iterNum"};
		String[] columnValues = new String[] { String.valueOf(QueryExecutionID),
				String.valueOf(queryID), String.valueOf(phase),
				queryexecution_number + "", cardinality + "", resultCardinality + "",
				runTime + "", proc_diff, String.valueOf(iterNum) + ""};
		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
				GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
//				GeneralDBMS.I_DATA_TYPE_VARCHAR,
				GeneralDBMS.I_DATA_TYPE_CLOB,
				GeneralDBMS.I_DATA_TYPE_NUMBER};
		try {
			//inserts a change point into the the internal tables.
//			LabShelfManager.getShelf().insertTupleToNotebook(QUERYEXECUTION.TableName, columnNames, columnValues, dataTypes);
			LabShelfManager.getShelf().insertQueryExecution(QUERYEXECUTION.TableName, columnNames, columnValues, dataTypes);
			LabShelfManager.getShelf().commitlabshelf();
			Main._logger.outputLog("finish inserting query execution");
			return QueryExecutionID;
		} catch (SQLException e) {
			Main._logger.reportError(QueryExecutionID + "\t" + queryID + "\t" + phase + "\t" + queryexecution_number + "\t" + cardinality + "\t" + resultCardinality + "\t" + runTime + "\t" + proc_diff + "\t" + iterNum);
			Main._logger.reportError("Failed to insert query execution...");
			try {
				
				String deleteSQL = "";
				if(type == Constants.SCENARIO_BASED_ON_QUERY){
					deleteSQL = "DELETE FROM " + QUERYEXECUTION.TableName +" WHERE QueryID = '" + queryID +"'";
				}else{
					deleteSQL = "DELETE FROM " + QUERYEXECUTION.TableName +" WHERE QueryID = '" + queryID +"' and Cardinality="+cardinality; // based on cardinality
				}
//				String 
				Main._logger.outputLog(deleteSQL);
				Main._logger.outputLog("delete incomplete query execution .. ");
				LabShelfManager.getShelf().executeUpdateSQL(deleteSQL);
				Main._logger.outputLog("... done ");
//				shelf.commitlabshelf();
				Main._logger.outputLog("Re-insert query execution... ");
				LabShelfManager.getShelf().insertTupleToNotebook(QUERYEXECUTION.TableName, columnNames, columnValues, dataTypes);
//				shelf.commitlabshelf();
				Main._logger.outputLog("... done ");
				return QueryExecutionID;
			} catch (SQLException e1) {
				e1.printStackTrace();
				throw new Exception(e1.getMessage());
			}
		}
	}
	
	
	/**
	 * The purpose of InsertPlanOperator() is to insert plan operator in each plan. 
	 * This function gets invoked by insertPlan(). 
	 *
	 * First, this function inserts an plan operator into AZDBLAB_PLANOPERATOR, using plan operator id, plan id, 
	 * and node name and order. A plan operator id is sequentially generated, and serves as surrogate 
	 * for AZDBLAB_PLANOPERATOR table. 
	 * 
	 *  @param QueryExecutionID : query run id
	 *  @param planID     : plan id
	 *  @param node       : operator node
	 *  @return nothing
     */

	public void insertPlanOperator(int QueryExecutionID,
								   long planID, 
								   PlanNode node) {
		if (node instanceof TableNode) {
			return;
		} 
		else {	
			int operator_order = node.getNodeID();
		
			
			int planOperatorID	= LabShelfManager.getShelf().getSequencialID("SEQ_PLANOPERATORID");
	        String		sqlInsert	= "INSERT INTO " + PLANOPERATOR.TableName 
									+ " VALUES ("
									+ planOperatorID + ", "
									+ planID + ", "
									+ "'" + ((OperatorNode)node).getOperatorName() + "', " 
									+ operator_order 
									+ ")";
	        LabShelfManager.getShelf().executeUpdateSQL(sqlInsert);
			int numchild = ((OperatorNode)node).getChildNumber();
	        for (int i = 0; i < numchild; i++) {
	        	insertPlanOperator(QueryExecutionID, planID, ((OperatorNode)node).getChild(i));
	        }
		}
	}
	
//	/**
//	 * The purpose of InsertPlanOperatorAndRunStats() is to insert plan operator and all run stats per operator
//	 * in each plan. This function gets invoked by insertPlan(). 
//	 *
//	 * First, this function inserts an plan operator into AZDBLAB_PLANOPERATOR, using plan operator id, plan id, 
//	 * and node name and order. A plan operator id is sequentially generated, and serves as surrogate 
//	 * for AZDBLAB_PLANOPERATOR table. 
//	 * 
//	 * For each inserted operator, we get its run stat into AZDBLAB_QUERYEXECUTIONHASSTAT. The run stat gets different, 
//	 * depending which query run, which plan, and which operator would be. So AZDBLAB_QUERYEXECUTIONHASSTAT is the table 
//	 * created to represent the above tertiary relationship among AZDBLAB_QUERYEXECUTION/AZDBLAB_PLAN/AZDBLAB_PLANOPERATOR tables.
//	 * AZDBLAB_QUERYEXECUTIONHASSTAT has QueryExecutionID, PLANOPERATORID, QUERYEXECUTIONSTATNAME, and VALUE columns, and each record in this 
//	 * table can be accessed by a primary key having a pair of (QueryExecutionID, QUERYEXECUTIONSTATNAME, PLANOPERATORID). 
//	 * 
//	 * A run stat per operator can be obtained from the execution plan explained by each experiment subject.
//	 * 
//	 * See the following example:
//	 * operator_id | parent_id |  operator_name      | TOTAL_COST | CPU_COST | IO_COST 
//	 *        0    |     -1    | 'Select Statement'  |    40      |   32.2   |   24
//	 *        1    |     0     | 'Sort Operator'     |    20      |   10     |   10
//	 *        2    |     1     | 'Table Scan'    	 |    10      |   5      |   10
//	 *        
//	 * From this result, the run stat of an operator is collected as hash map consisting of a stat name-value pair(s).
//	 * 'Sort Operator' could have run stat map consisting of these elements: 
//	 * <Total_Cost, 20>, <IO_Cost, 30.0>, <CPU_Cost, 10> ...
//	 * 
//	 * Iterating each element in hash map, 
//	 * the function finally gets each run stat into AZDBLAB_QUERYEXECUTIONHASSTAT usinq query run id and node given as parameters.
//	 * 
//	 *  @param QueryExecutionID : query run id
//	 *  @param planID     : plan id
//	 *  @param node       : operator node
//	 *  @return nothing
//     */
//
//	public void insertPlanOperatorAndRunStats(int QueryExecutionID,
//											  long planID, 
//											  PlanNode node) {
//		if (node instanceof TableNode) {
//			return;
//		} 
//		else {	
//			int operator_order = node.getNodeID();
//			
//			// delete an existing operator from AZDBLAB_PLANOPERATOR by unique key constraint if any
//			String deleteSQL = "DELETE FROM " + PLANOPERATOR.TableName +" WHERE planid = " + planID + 
//							" and operatororder = " + operator_order;
////			System.err.println(deleteSQL);
////			System.err.println("delete previous plan operator .. ");
//			shelf.executeUpdateSQL(deleteSQL);
//			
//			int planOperatorID	= shelf.getSequencialID("SEQ_PLANOPERATORID");
//			Main._logger.outputLog("====== < " + ((OperatorNode)node).getOperatorName() +">============");
//	        String		sqlInsert	= "INSERT INTO " + PLANOPERATOR.TableName 
//									+ " VALUES ("
//									+ planOperatorID + ", "
//									+ planID + ", "
//									+ "'" + ((OperatorNode)node).getOperatorName() + "', " 
//									+ operator_order 
//									+ ")";
////	        Main._logger.outputLog(" >> start insert: " + sqlInsert);
//			shelf.executeUpdateSQL(sqlInsert);
////			Main._logger.outputLog(" << end insert");
//			shelf.commitlabshelf();
////			Main._logger.outputLog(" ** committed");
//	        
//			Main._logger.outputLog("$$$$$$$$$$$ Insert run stats associated with this op $$$$$$");
//			long planOperID  = getPlanOpID(planID, node.getNodeID());
//			if(planOperID == -1){
//				Main._logger.outputLog("cannot find planoperatorID");
//			}
//			HashMap<String, Double> resMap = node.getOpCostEstimates();
//			// Get hashmap in Set interface to get key and value
//	        Set s = resMap.entrySet();
//	        // Move next key and value of HashMap by iterator
//	        Iterator it=s.iterator();
//	        Main._logger.outputLog("before <insert run stat details>");
//	        while(it.hasNext()){
//	            // key=value separator this by Map.Entry to get key and value
//	            Map.Entry m =(Map.Entry)it.next();
//	            // getKey is used to get key of HashMap
//	            String key = (String)m.getKey();
//	            // getValue is used to get value of key in HashMap
//	            Double value = (Double)m.getValue();
//	            sqlInsert	= "INSERT INTO " + QUERYEXECUTIONHASSTAT.TableName + " VALUES (" + 
//	            				QueryExecutionID + ", '" +
//					            key + "', " +
//								planOperID + ", " +
//								value + ")";
////				Main._logger.outputLog(" >> start insert");
//				Main._logger.outputLog(" insert SQL : " + sqlInsert);
//				shelf.executeUpdateSQL(sqlInsert);
////				Main._logger.outputLog(" << end insert");
//				shelf.commitlabshelf();
////				Main._logger.outputLog(" ** committed");
//	        }
//	        Main._logger.outputLog("$$$$$$$$ done <insert run stat details> $$$$$$");
//	        int numchild = ((OperatorNode)node).getChildNumber();
//	        for (int i = 0; i < numchild; i++) {
//	        	insertPlanOperatorAndRunStats(QueryExecutionID, planID, ((OperatorNode)node).getChild(i));
//	        }
//		}
//	}

	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @param queryexecution_number
	 * @param runTime
	 * @param rootnode
	 */
	public long insertPlan(	int queryNumber,
							int queryexecution_number,
							int QueryExecutionID,
							PlanNode rootnode ) {
		/*
		int			QueryExecutionID		= getQueryExecutionID(queryNumber, queryexecution_number);
		
		if (QueryExecutionID == -1) {
			System.err.println("insert Plan Err.");
			return;
		}
		*/
		
		long		planID				= rootnode.myHashCode();
		
Main._logger.outputLog("QueryExecutionID: " + QueryExecutionID + "\t New Plan ID: " + planID);
		
		try {
				
				File	planFile	= File.createTempFile("plantree", "plan");
				planFile.deleteOnExit();
			
				FileOutputStream	foutStream	= new FileOutputStream(planFile);
				
				PlanNode.savePlanNode(rootnode, foutStream);
				foutStream.close();
				
				String clobColumnName = "PlanTree";
				String[] columns = new String[] { "PlanID" };
				String[] columnValues = new String[] { String.valueOf(planID) };
				int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };
				
				FileInputStream		finStream	= new FileInputStream(planFile);
				
				//Uploads the data definition from the DBMS
				int	inserted	= LabShelfManager.getShelf().putDocument(
																PLAN.TableName,
																clobColumnName,
																columns,
																columnValues,
																dataTypes,
																finStream
															);
				LabShelfManager.getShelf().commitlabshelf();
				Main._logger.outputLog("insert plan: " + inserted);				
				if (inserted == 0){
					Main._logger.outputLog("####### Begin to insert plan operators #############");
					insertPlanOperator(QueryExecutionID, planID, rootnode);
					Main._logger.outputLog("####################################################");
				}
			} catch (IOException ioex) {
				ioex.printStackTrace();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			
		try {
			String[] columnNames = new String[] {"QueryExecutionID", "PlanID"};
			String[] columnValues = new String[] {String.valueOf(QueryExecutionID), String.valueOf(planID)};
			int[] dataTypes = new int[] {GeneralDBMS.I_DATA_TYPE_NUMBER,
                                         GeneralDBMS.I_DATA_TYPE_NUMBER};
			LabShelfManager.getShelf().insertTupleToNotebook(QUERYEXECUTIONHASPLAN.TableName, columnNames, columnValues, dataTypes);
			LabShelfManager.getShelf().commitlabshelf();
			
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
		}
		Main._logger.outputLog("done inserting plan");
		return planID;
	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @param queryexecution_number
	 * @return
	 */
	public int getQueryExecutionID(int queryID, int queryexecution_number) {
		
		try {
			
			String		sqlID	= 	"SELECT QueryExecutionID " + 
									"FROM " + QUERYEXECUTION.TableName + " " + 
									"WHERE QueryID = " + queryID + " AND queryExecutionNumber = " + queryexecution_number + "";
			
			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);
			
			if (rsID != null && rsID.next()) {
				int		id		= rsID.getInt(1);
				rsID.close();
				return id;
			}
			return -1;
			
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}
		
	}
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @param queryexecution_number
	 * @return
	 */
	public long getPlanID(int queryID, int queryexecution_number) {
		
		try {
			
			int			QueryExecutionID	= getQueryExecutionID(queryID, queryexecution_number);
			
			String		sqlID			= 	"SELECT PlanID " + 
											"FROM " + QUERYEXECUTIONHASPLAN.TableName + " " + 
											"WHERE QueryExecutionID = " + QueryExecutionID;
			
			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlID);
			
			if (rsID != null && rsID.next()) {
				long	id				= rsID.getLong(1);
				rsID.close();
				return id;
			}
			return -1;
			
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return -1;
		}
		
	}
	
	
	/**
	 * 
	 * @param userName
	 * @param notebookName
	 * @param experimentName
	 * @param startTime
	 * @param testNumber
	 * @param queryNumber
	 * @param change_point_number
	 * @return
	 * @throws SQLException
	 */
	public PlanNode getPlan(int queryExecutionNumber ) throws SQLException {

		//System.out.println("qen= " +queryExecutionNumber);
		//System.out.println("iqid" + iQueryID);
		long	planID	= getPlanID(iQueryID, queryExecutionNumber);
//Main._logger.outputLog("iQueryID: " + iQueryID);
//Main._logger.outputLog("PlanID: " + planID);			
		

		if (planID == -1) {
			System.err.println("get Plan Nodes Err.");
			return null;
		}

		String 				columnName 		= "PlanTree";
		String[] 			columnNames		= new String[] { "PlanID" };
		String[] 			columnValues 	= new String[] { String.valueOf(planID) };
		int[] 				dataTypes 		= new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };

		//Retrieves the result and validates it.
	//	FileInputStream finStream = shelf.getDocument(PLAN.TableName,
	//			columnName, columnNames, columnValues, dataTypes);
		InputStream finStream = LabShelfManager.getShelf().getDocument(PLAN.TableName,
						columnName, columnNames, columnValues, dataTypes);
		PlanNode			planNode		= null;
		
		try {
			planNode	= (PlanNode)PlanNode.loadPlanNode(finStream);
// I have to recollect all plan operator stat from database, it is not correct just to use the stat when 
// this plan was stored for the first time.
// update stat information of this plan node
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return planNode;
		
	}

	private long getPlanOpID(long planID, int order) {
		// TODO Auto-generated method stub
		try {
			String sqlPlanOpID = "SELECT PLANOPERATORID " 
							   + "FROM " + PLANOPERATOR.TableName + " " 
							   + "WHERE PLANID = " + planID + " AND " + "OPERATORORDER = " + order;

//Main._logger.outputLog("get plan op id: " + sqlPlanOpID);
			ResultSet rsID = LabShelfManager.getShelf().executeQuerySQL(sqlPlanOpID);

			if (rsID != null && rsID.next()) {
				long id = rsID.getLong(1);
				rsID.close();
				return id;
			}
			return -1;

		} catch (SQLException sqlex) {
			Main._logger.reportError(sqlex.getMessage());
			return -1;
		}
	}
	
	private void setPlanOpRunStat(int qrid, 
								  long planID,
								  PlanNode node){
		if (node instanceof TableNode) {
			return;
		} 
		
		
		long planOperID  = getPlanOpID(planID, node.getNodeID());
		if(planOperID == -1){
			System.err.println("setPlanOpRunStat : cannot find planoperatorID");
			return;
		}
		
		try {
			String strStatSQL = "SELECT NAME, VALUE " + 
						    	"FROM " + QUERYEXECUTIONHASSTAT.TableName + " " + 
						    	"WHERE QueryExecutionID = " + qrid + " AND PLANOPERATORID = " + planOperID + " ORDER BY NAME";
//Main._logger.outputLog("get stat: " + strStatSQL);
//Main._logger.outputLog("====== < " + ((OperatorNode)node).getOperatorName() +">============");
			HashMap<String, Double> mapRunStat = new HashMap<String, Double>();
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(strStatSQL);
			while(rs.next()){
				String strCostName = rs.getString(1);
				Double dValue = rs.getDouble(2);
//Main._logger.outputLog("(" + strCostName + ", " + dValue + ")");
				if(strCostName.contains("DB2_")){
					strCostName.replaceAll("DB2_", "Z");
				}
				mapRunStat.put(strCostName, dValue);
			}
			rs.close();
			node.setOpCostEstimates(mapRunStat);
		} catch (SQLException sqlex) {
			sqlex.printStackTrace();
			return;
		}
		// TODO this is where the problem is
		int numchild = ((OperatorNode)node).getChildNumber();
        for (int i = 0; i < numchild; i++) {
        	setPlanOpRunStat(qrid, planID, ((OperatorNode)node).getChild(i));
        }	
	}
	
	public void restoreCostEstimateForPlanOperator(int queryid, 
												   int queryExecutionNumber,
												   PlanNode rootNode) {
//		int queryid = LabShelf.getShelf().getUser(strUserName)
//		.getNotebook(strNotebookName).getExperiment(strExpName).getRun(strStartTime)
//		.getQuery(iQueryNum).getQueryID();
//Main._logger.outputLog("queryid: " + queryid);
		int QueryExecutionID = getQueryExecutionID(queryid, queryExecutionNumber);
		long	planID = getPlanID(queryid, queryExecutionNumber);
//Main._logger.outputLog("QueryExecutionID: " + QueryExecutionID + ", planID: " + planID);
		setPlanOpRunStat(QueryExecutionID, planID, rootNode);
	} 
	
	//select * from AZDBLAB_QUERYEXECUTIONHASSTAT where QueryExecutionID = 36515 and planoperatorid = 117438;
//	Main._logger.outputLog("querynumber: " + iQueryNum);			
//	Main._logger.outputLog("queryExecutionNumber: " + queryExecutionNum);		


	/**
	 * The purpose of insertQueryExecutionStat() is to insert plan operators' run stats. 
	 *
	 * For each operator, we get its run stat into AZDBLAB_QUERYEXECUTIONHASSTAT. The run stat gets different, 
	 * depending which query run, which plan, and which operator would be. So AZDBLAB_QUERYEXECUTIONHASSTAT is the table 
	 * created to represent the above tertiary relationship among AZDBLAB_QUERYEXECUTION/AZDBLAB_PLAN/AZDBLAB_PLANOPERATOR tables.
	 * AZDBLAB_QUERYEXECUTIONHASSTAT has QueryExecutionID, PLANOPERATORID, QUERYEXECUTIONSTATNAME, and VALUE columns, and each record in this 
	 * table can be accessed by a primary key having a pair of (QueryExecutionID, QUERYEXECUTIONSTATNAME, PLANOPERATORID). 
	 * 
	 * A run stat per operator can be obtained from the execution plan explained by each experiment subject.
	 * 
	 * See the following example:
	 * operator_id | parent_id |  operator_name      | TOTAL_COST | CPU_COST | IO_COST 
	 *        0    |     -1    | 'Select Statement'  |    40      |   32.2   |   24
	 *        1    |     0     | 'Sort Operator'     |    20      |   10     |   10
	 *        2    |     1     | 'Table Scan'    	 |    10      |   5      |   10
	 *        
	 * From this result, the run stat of an operator is collected as hash map consisting of a stat name-value pair(s).
	 * 'Sort Operator' could have run stat map consisting of these elements: 
	 * <Total_Cost, 20>, <IO_Cost, 30.0>, <CPU_Cost, 10> ...
	 * 
	 * Iterating each element in hash map, 
	 * the function finally gets each run stat into AZDBLAB_QUERYEXECUTIONHASSTAT usinq query run id and node given as parameters.
	 * 
	 *  @param QueryExecutionID : query run id
	 *  @param planID 	  : plan id
	 *  @param node       : operator node
	 *  @return nothing
	 * @throws Exception 
    */
	public void insertQueryExecutionStat(int QueryExecutionID, 
							       long planID,
							       PlanNode node) throws Exception{
		if (node instanceof TableNode) {
			return;
		} 
		
//Main._logger.outputLog("$$$$$$$$$$$ Insert run stats associated with <<" + ((OperatorNode)node).getOperatorName()  +">> $$$$$$");
		long planOperID  = getPlanOpID(planID, node.getNodeID());
		if(planOperID == -1){
			System.err.println("insertQueryExecutionStat : cannot find planoperatorID");
			throw new Exception("cannot find planoperatorID");
		}
		HashMap<String, Double> resMap = node.getOpCostEstimates();
		// Get hashmap in Set interface to get key and value
        Set s = resMap.entrySet();
        // Move next key and value of HashMap by iterator
        Iterator it=s.iterator();
//        Main._logger.outputLog("before <insert run stat details>");
        while(it.hasNext()){
            // key=value separator this by Map.Entry to get key and value
            Map.Entry m =(Map.Entry)it.next();
            // getKey is used to get key of HashMap
            String key = (String)m.getKey();
            // getValue is used to get value of key in HashMap
            Double value = (Double)m.getValue();
            String sqlInsert	= "INSERT INTO " + QUERYEXECUTIONHASSTAT.TableName + " VALUES (" + 
            				QueryExecutionID + ", '" +
				            key + "', " +
							planOperID + ", " +
							value + ")";
//			Main._logger.outputLog(" >> start insert");
//			Main._logger.outputLog(" insert SQL : " + sqlInsert);
            LabShelfManager.getShelf().executeUpdateSQL(sqlInsert);
//			Main._logger.outputLog(" << end insert");
//			shelf.commitlabshelf();
//			Main._logger.outputLog(" ** committed");
        }
//        Main._logger.outputLog("$$$$$$$$ done <insert run stat details> $$$$$$");
        int numchild = ((OperatorNode)node).getChildNumber();
        for (int i = 0; i < numchild; i++) {
        	insertQueryExecutionStat(QueryExecutionID, planID, ((OperatorNode)node).getChild(i));
        }		
	}


	public void restorePlanNum(int phase, int maxIters, Vector<Long> cardVec) throws Exception {
		String sqlQueryHasResult = "SELECT qe.Cardinality, qep.planid " +
								   "FROM " + QUERY.TableName + " q, " + QUERYEXECUTION.TableName + " qe, " 
								   		   + QUERYEXECUTIONHASPLAN.TableName + " qep " +
								   "WHERE q.QueryID = " + iQueryID + " AND q.QueryID = qe.QueryID " +
								   "AND qe.QueryExecutionID = qep.queryexecutionid " +  
								   "AND qe.Phase = " + phase + " " + " AND qe.iterNum = " + maxIters + " " +
								   "ORDER BY qe.Cardinality desc, qe.iternum asc ";
Main._logger.outputLog("SQL: " + sqlQueryHasResult);
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sqlQueryHasResult);
		try {
			int i = 0;
			while (rs.next()) {
				long currCard = ((Long)cardVec.get(i++)).longValue();
				long retCard = rs.getLong(1);
				if(currCard != retCard){
					String errMsg = "The retrieved card("+rs.getLong(1)+") is not consistent with the given card("+currCard+")";
						  // errMsg += "(curr card: " + currCard + ", record cardinality: " + rs.getLong(1)+")";
					Main._logger.reportError(errMsg);
					throw new SanityCheckException(errMsg);
				}
				// plan number is being restored.
				this.obtainPlanNum(rs.getLong(2));
//Main._logger.outputDebug("plan number: " + plan_num + " at " + currCard);		
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("Failed to fetch query execution record due to DB conn error.!");
		}
	}
}