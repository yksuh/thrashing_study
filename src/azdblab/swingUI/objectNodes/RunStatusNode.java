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
package azdblab.swingUI.objectNodes;

import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;

import azdblab.Constants;
import azdblab.labShelf.dataModel.LabShelfManager;

/**
 * The data module for CompletedRun object. Used in creating the view for
 * CompletedRun node in the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public abstract class RunStatusNode extends CommentedObjectNode {

	protected String strUserName;

	protected String strNotebookName;

	protected String strExperimentName;

	protected String strScenario;

	protected String strMachineName;

	protected String strDBMS;

	protected String strStartTime;
	
	// 0: CompeletedRun
	// 1: RunningRun
	// 2: PendingRun
	// 3: PausedRun
	// 4: AbortedRun
	protected int iType; 

	public RunStatusNode(String userName, String notebookName,
			String experimentName, String scenario, String machineName,
			String dbms, String startTime, int type) {
		willHaveChildren = false;
		strUserName = userName;
		strNotebookName = notebookName;
		strExperimentName = experimentName;
		strScenario = scenario;
		strMachineName = machineName;
		strDBMS = dbms;

		strStartTime = startTime;

		iType = type;

	}

	public int getRunID() {
		String sql = "Select runID from " + Constants.TABLE_PREFIX
//				+ Constants.TABLE_EXPERIMENTRUN + " where startTime = '"
//				+ strStartTime + "'";
				+ Constants.TABLE_EXPERIMENTRUN + " where StartTime = " 
				+ "to_timestamp('" + strStartTime + "', '" + Constants.TIMESTAMPFORMAT + "')";
		try {
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
		// return User.getUser(strUserName).getNotebook(strNotebookName)
		// .getExperiment(strExperimentName).getRun(strStartTime)
		// .getRunID();
	}

	public String getRunLogHTML() {
		String toRet = "<HTML><BODY><center>";
		String sql = "select transactiontime, currentStage from azdblab_runlog where runid = "
				+ getRunID() + " order by TRANSACTIONTIME";

		try {
			toRet += "<h1>Experiment RunLog</h1>";
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			toRet += "<table border=\"1\">";
			toRet += "<tr> <th> Transaction Time </th> <th> Current Stage </th></tr>";

			ArrayList<RunInfo> runLst = new ArrayList<RunInfo>();
			while (rs.next()) {
				runLst.add(new RunInfo(new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(1)), rs.getString(2)));
			}
			rs.close();
			//Collections.sort(runLst);
			for (int i = 0; i < runLst.size(); i++) {

				toRet += "<tr> <td>" + runLst.get(i).fullDateString
						+ "</td> <td>" + runLst.get(i).message + "</td> </tr>";
			}
			toRet += "</table>";
		} catch (Exception e) {
			e.printStackTrace();
		}
		toRet += "</center></BODY></HTML>";
		return toRet;
	}

	public String getUserName() {
		return strUserName;
	}

	public String getNotebookName() {
		return strNotebookName;
	}

	public String getExperimentName() {
		return strExperimentName;
	}

	public String getScenario() {
		return strScenario;
	}

	public String getMachineName() {
		return strMachineName;
	}

	public String getShortMachineName()
	{
		String name = "sodb";
		int index =0;
		for(int i=0; i< strMachineName.length(); i++){
			if(strMachineName.charAt(i)=='.'){
				index=i;
				break;
			}
		}
		if(strMachineName.charAt(index-2)=='1')
			name+='1';
		name= name+ strMachineName.charAt(index-1);
		
		return name;
				
	}
	
	
	public String getDBMS() {
		return strDBMS;
	}

	public String getStartTime() {
		return strStartTime;
	}

	public void setType(int type) {
		iType = type;
	}

	public int getType() {
		return iType;
	}

	private class RunInfo implements Comparable<RunInfo> {
		int month;
		int day;
		int year;
		String timestamp;
		String message;
		String fullDateString;

		public RunInfo(String dateString, String message) {
			this.message = message;
			this.fullDateString = dateString;
			String[] tmp = fullDateString.split(" ");
			month = getMonth(tmp[1]);
			day = Integer.parseInt(tmp[2].trim());
			year = Integer.parseInt(tmp[3].trim());
			timestamp = tmp[4].trim();
		}

		private int getMonth(String month) {
			if (month.equalsIgnoreCase("jan")) {
				return 1;
			} else if (month.equalsIgnoreCase("feb")) {
				return 2;
			} else if (month.equalsIgnoreCase("mar")) {
				return 3;
			} else if (month.equalsIgnoreCase("apr")) {
				return 4;
			} else if (month.equalsIgnoreCase("may")) {
				return 5;
			} else if (month.equalsIgnoreCase("jun")) {
				return 6;
			} else if (month.equalsIgnoreCase("jul")) {
				return 7;
			} else if (month.equalsIgnoreCase("aug")) {
				return 8;
			} else if (month.equalsIgnoreCase("sep")) {
				return 9;
			} else if (month.equalsIgnoreCase("nov")) {
				return 10;
			} else if (month.equalsIgnoreCase("oct")) {
				return 11;
			} else if (month.equalsIgnoreCase("dec")) {
				return 12;
			} else {
				System.out
						.println(month
								+ ": is not a recgonized month @RunStatusNode.getMonth()");
				return 0;
			}

		}

		@Override
		public int compareTo(RunInfo o) {
			if (o.year < this.year) {
				return 1;
			} else if (o.year > this.year) {
				return -1;
			}

			if (o.month < this.month) {
				return 1;
			} else if (o.month > this.month) {
				return -1;
			}

			if (o.day < this.day) {
				return 1;
			} else if (o.day > this.day) {
				return -1;
			}

			return this.timestamp.compareTo(o.timestamp);
		}

	}

}
