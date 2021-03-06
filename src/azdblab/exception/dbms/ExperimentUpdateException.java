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
package azdblab.exception.dbms;

/**
 * An exception that indicates that the Experiment Could not be 
 * updated.  This only occurs if all tests have been change or are
 * different for the experiment stored in the DBMS.
 * @author Kevan Holdaway
 *
 */
public class ExperimentUpdateException extends Exception {
	private static final long serialVersionUID =  System
	.identityHashCode("ExperimentUpdateException");
	/**
	 * Creates a DBMS an exception of this type.
	 */
	public ExperimentUpdateException() {
		super();
	}

	/**
	 * Creates an exception of this type with the specified message.
	 * @param message The message to be displayed with this exception.
	 */
	public ExperimentUpdateException(String message) {
		super(message);
	}

	/**
	 * Creates an exception of this type with the cause passed as a
	 * parameter and a message passed as a parameter.
	 * @param message The message that will be displayed for this exception.
	 * @param cause The cause of this exception.
	 */
	public ExperimentUpdateException(String message, Throwable cause) {
		super(message, cause);
	}

	/**
	 * Creates an exception of this type with the cause passed as a 
	 * parameter.
	 * @param cause The exception that is the cause of this exception.
	 */
	public ExperimentUpdateException(Throwable cause) {
		super(cause);
	}

}
