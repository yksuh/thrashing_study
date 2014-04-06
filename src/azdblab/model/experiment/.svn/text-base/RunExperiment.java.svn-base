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
package azdblab.model.experiment;

import azdblab.exception.analysis.InvalidExperimentException;
import azdblab.executable.Main;

public class RunExperiment extends Thread {
  private String strUserName;
  private String strNotebookName;
  private String strExperimentName;
  private String strExpUserName;
  private String strExpPassword; 
  private String strMachineName;
  private String strDBMS;
  private String strStartTime;
  private String strConnectString;
  //private String current_version_;
  private static boolean bIsRunning = false;

  public RunExperiment(
      String userName, String notebookName, String experimentName,
      String expUserName, String expPassword, String machineName, String connectString, String dbms,
      String startTime) {
    strUserName = userName;
    strNotebookName = notebookName;
    strExperimentName = experimentName;
    strExpUserName = expUserName;
    strExpPassword = expPassword; 
    strMachineName = machineName;
    strConnectString = connectString;
    strDBMS = dbms;
    strStartTime = startTime;
  }
  
  public void run() {
    try {
      if (bIsRunning) {
        Main._logger.outputLog("Experiment is Running");
        return;
      }
      Main._logger.outputLog("Running Experiment Started");
      bIsRunning  = true;
      Main.runExperiment(strUserName, strNotebookName, strExperimentName,
                         strExpUserName, strExpPassword, strMachineName,
                         strConnectString, strDBMS, strStartTime);
      bIsRunning  = false;
      if(!Main.isNotDone)
    	  Main._logger.outputLog("Running Experiment Finished");
    } catch (InvalidExperimentException e) {
      e.printStackTrace();
    }
  }
  
  public static boolean getIsRunning() {
    return bIsRunning;
  }
}
