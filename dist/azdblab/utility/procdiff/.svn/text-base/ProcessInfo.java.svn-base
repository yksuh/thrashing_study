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
package azdblab.utility.procdiff;

public abstract class ProcessInfo {
	/**
	 * pid
	 */
	protected long _pid;
	/***
	 * command
	 */
	protected String _command;
	/***
	 * Get pid
	 * @return _pid
	 */
	public long get_pid() {
		return _pid;
	}
	/***
	 * Get command
	 * @return _command
	 */
	public String get_command() {
//		if("".equalsIgnoreCase(_command)){
//			System.out.println("command: " + _command);
//			System.exit(-1);
//		}
		return _command;
	}
	/***
	 * Get process info string
	 */
	public abstract String getStr();
	/***
	 * Get diff between this obj and a given obj
	 * @param pi
	 * @return diff string
	 */
	public abstract String getDiff(ProcessInfo gpi);
}