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
package azdblab.exception.analysis;

/**
 * Thrown if an experiment is invalid.
 * @author Kevan Holdaway
 *
 */
public class InvalidExperimentException extends Exception {
	private static final long serialVersionUID =  System
	.identityHashCode("InvalidExperimentException");
	/**
	 * Creates a DBMS an exception of this type.
	 */
	public InvalidExperimentException() {
		super();
	}

	/**
	 * Creates an exception of this type with the specified message.
	 * @param message The message to be displayed with this exception.
	 */
	public InvalidExperimentException(String message) {
		super(message);
	}

	/**
	 * Creates an exception of this type with the cause passed as a 
	 * parameter.
	 * @param cause The exception that is the cause of this exception.
	 */
	public InvalidExperimentException(Throwable cause) {
		super(cause);
	}

	/**
	 * Creates an exception of this type with the cause passed as a
	 * parameter and a message passed as a parameter.
	 * @param message The message that will be displayed for this exception.
	 * @param cause The cause of this exception.
	 */
	public InvalidExperimentException(String message, Throwable cause) {
		super(message, cause);
	}

}
