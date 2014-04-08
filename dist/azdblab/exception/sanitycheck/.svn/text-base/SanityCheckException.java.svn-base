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
package azdblab.exception.sanitycheck;

/**
 * This exception is thrown when a variety of sanity checks for experiment tables 
 * are violated.  This might result from unstable network connection or incomplete commit.
 * After this exception happens, a running experiment is supposed to be paused. 
 * 
 * @author Young-Kyoon Suh
 *
 */
public class SanityCheckException extends Exception {
	private static final long serialVersionUID =  System
			.identityHashCode("SanityCheckException");

	/**
	 * Creates an exception of this type.
	 */
	public SanityCheckException() {
		this("", null);
	}

	/**
	 * Creates an exception of this type with the specified message.
	 * @param message The message to be displayed with this exception.
	 */
	public SanityCheckException(String message) {
		this(message, null);
	}

	/**
	 * Creates an exception of this type with the cause passed as a 
	 * parameter.
	 * @param cause The exception that is the cause of this exception.
	 */
	public SanityCheckException(Throwable cause) {
		this("", cause);
	}

	/**
	 * Creates an exception of this type with the cause passed as a
	 * parameter and a message passed as a parameter.
	 * @param message The message that will be displayed for this exception.
	 * @param cause The cause of this exception.
	 */
	public SanityCheckException(String message, Throwable cause) {
		super("Sanity check violation on " + message + ".", cause);
	}
}
