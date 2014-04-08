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

import java.sql.PreparedStatement;
import java.sql.SQLException;

import azdblab.labShelf.PlanNode;
import azdblab.model.experiment.Table;

public class StateData{
	public Table[] table;
	public PreparedStatement pstmt;
	public long card;
	public PlanNode plan;
	public long alreadyRunCard;
	public String query;
	
//	public StateData(Table[] variableTables, boolean state){
//		table = new Table[variableTables.length];
//	}
	public StateData(Table[] variableTables){
		table = new Table[variableTables.length];
	}
	
	public void setQuery(Table[] variableTables, String sql) throws SQLException{
		query = sql.replaceAll(variableTables[0].table_name_with_prefix, 
							   table[0].table_name_with_prefix);
//		Main._logger.outputDebug("sql: " + sql);
//		Main._logger.outputDebug("new sql: " + query);
		if(pstmt != null){
			pstmt.close();
		}
		pstmt = null;
		card = 0;
		plan = null;
		alreadyRunCard = 0;
	}
}