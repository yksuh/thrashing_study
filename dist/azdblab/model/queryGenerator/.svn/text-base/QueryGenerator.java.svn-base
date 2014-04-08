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
package azdblab.model.queryGenerator;

import org.w3c.dom.Element;

import azdblab.labShelf.dataModel.LabShelfManager;

import java.io.File;

/**
 * This API allows AZDBLab to have multiple query generators.  These can then be
 * specified by the XML.  They will all behave the same.
 * @author Kevan Holdaway
 *
 */
public abstract class QueryGenerator {

	protected String strUserName;

	protected String strNotebookName;

	protected String strExperimentName;
	
	protected String strStartTime;
	
	protected LabShelfManager shelf = LabShelfManager.getShelf();
	
	
	public QueryGenerator(String userName, String notebookName, String experimentName) {
		strUserName			= userName;
		strNotebookName		= notebookName;
		strExperimentName	= experimentName;
	}
	
	/**
	 * Determines if two queries generator's XML are the same.
	 * @param o The other query generator
	 * @return true - if they query generators are the same class and have the same
	 * XML<BR>false - if the query generators are not the same class or have
	 * different XML.
	 */
	public abstract boolean equals(Object o);

	
	/**
	 * Invoking this will cause the query generator to generate
	 * its queries.
	 */
	public abstract int generateQueries(String startTime);
	/**
	 * Returns the XML Document DOM root.
	 * @return The XML documents root element.
	 */
	public abstract Element getRoot();
	
	
	public abstract String getDescription(boolean hasResult);
	
	
	public void setTestTime(String testTime) {
		strStartTime		= testTime;
	}
	
	public abstract String getQueryDefName();
	
	
	public abstract File getQueryDefFile();
	
//	public abstract boolean checkSuccess();
	
}
