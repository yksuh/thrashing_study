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
package azdblab.observer.api;


/**
 * Provides an interface for opening an experiment.
 * @author Kevan Holdaway
 *
 */
public interface ResultOpenInterface {
	/**
	 * Opens an experiment in the result browser.
	 * @param experiment The experiment that will be opened.
	 */
	//public void openExperiment(String expName);	
	
    //TODO: changed interface

    /**
     * Creates a new experiment.
     *
     * @param expName - path name of experiment
     */
    public void loadExperiment( String expName );
    
}
