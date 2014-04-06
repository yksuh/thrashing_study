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

import java.util.TimerTask;

public class CheckExperiment extends TimerTask {

	private String		strDetail	= "";
	
	public void run() {
		//strDetail		= Main.getStatus();
	}
	
	public String getDetail() {
		return strDetail;
	}
	
}
