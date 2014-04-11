package azdblab.utility.watcher;
/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
*  Jennifer Dempsey
*/
import azdblab.swingUI.objectNodes.PausedRunNode;
import azdblab.swingUI.objectNodes.PendingRunNode;
/**
 * MBeanInterface implemented by Executor.java.
 * The methods defined here are accessible to the
 * JMXServer and watcher.
 * @author jendempsey
 *
 */
public interface ExecutorMBean {
	 public void loadRunningRuns();
	 public void loadPendingRuns();
	 public void loadPausedRuns();
	 public PendingRunNode getRunnablePendingRun();
	 public PausedRunNode getPausedRun();
	 public void performTasks();
	 public void execute();

}
