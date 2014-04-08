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
package azdblab.labShelf;


/**
 * This class records all the relevant information about the execution of a query.
 *
 */

public class QueryExecutionStat {
  /**
   * The time cost in for executing the query in millisecond.
   */
  private String proc_diff_;
  private long queryTime;
  private PlanNode plan;
  private int iterNum;
  
  private long plan_code;
  private int queryNum;
  private int phaseNum;
  /**
   * The relevant information about the query execution.
   */
  private static final String[] statProperties = new String[] {"queryTime", "procdiff"};
		
  public QueryExecutionStat(){
	  proc_diff_ = "";
	  queryTime = 0;
	  plan = null;
	  plan_code = 0;
	  queryNum = 0;
	  phaseNum = 0;
	  iterNum = 0;
  }
  
  /**
   * Constructs an QueryStat object with queryTime information specified.
   * @param queryTime time cost of the query execution.
   */
  public QueryExecutionStat(long query_time, String proc_diff){
    queryTime = query_time;
    proc_diff_= proc_diff;
  }
	
  /**
   * Retrieves the list of properties used in this instance.
   * @return list of properties relevant to query execution.
   */
  public String[] getStatProperties(){
    return statProperties;
  }
		
  /**
   * Sets the time cost of query execution for an instance.
   * @param queryTime Time cost of query execution for an instance.
   */
  public void setQueryTime(long query_time){
    queryTime	= query_time;
  }
		
  /**
   * Retrieves the query execution time.
   * @return The query execution time.
   */
  public long getQueryTime(){
    return queryTime;
  }
  
  public void setProcDiff(String str) {
	    proc_diff_ = str;
  }
  
  public String getProcDiff() {
    return proc_diff_;
  }
		
  /**
   * Sets the value of a specific property for the <code>QueryStat</code> object.
   * @param property The property whose value to be set.
   * @param value The value of the property.
   */
  public void setStatProperty(String property, Object value){
  }
		
  /**
   * Retrieves the value of a specific property.
   * @param property The name of the property whose value to be retrieved.
   * @return The value of the property.
   */
  public Object getStatProperty(String property){
    return new Object();
  }
		
  /**
   * Checks if a property is actually included in the <code>QueryStat</code> class.
   * @param property The property name to be examined.
   * @return <code>true</code> if the property is included in the <code>QueryStat</code> class. Otherwise <code>false</code>
   */
  public boolean isStatProperty(String property){
    return true;
  }

  public void setPlan(PlanNode plan_node) {
    plan = plan_node;
  }
		
  public PlanNode getPlan() {
    return plan;
  }

	public void setPlan_code(long plan_code) {
		this.plan_code = plan_code;
	}
	
	public long getPlan_code() {
		return plan_code;
	}
	
	public void setQueryNum(int queryNum) {
		this.queryNum = queryNum;
	}
	
	public int getQueryNum() {
		return queryNum;
	}
	
	public void setPhaseNum(int phaseNum) {
		this.phaseNum = phaseNum;
	}
	
	public int getPhaseNum() {
		return phaseNum;
	}
	
	public int getIterNum() {
		return iterNum;
	}
	
	public void setIterNum(int num) {
		this.iterNum = num;
	}
}
