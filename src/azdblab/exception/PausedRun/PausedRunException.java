package azdblab.exception.PausedRun;

public class PausedRunException extends Exception {
	private static final long serialVersionUID =  System
			.identityHashCode("PausedRunException");

	/**
	 * Creates an exception of this type.
	 */
	public PausedRunException() {
		this("", null);
	}

	/**
	 * Creates an exception of this type with the specified message.
	 * @param message The message to be displayed with this exception.
	 */
	public PausedRunException(String message) {
		this(message, null);
	}

	/**
	 * Creates an exception of this type with the cause passed as a 
	 * parameter.
	 * @param cause The exception that is the cause of this exception.
	 */
	public PausedRunException(Throwable cause) {
		this("", cause);
	}

	/**
	 * Creates an exception of this type with the cause passed as a
	 * parameter and a message passed as a parameter.
	 * @param message The message that will be displayed for this exception.
	 * @param cause The cause of this exception.
	 */
	public PausedRunException(String message, Throwable cause) {
		super("Paused Run Exception on " + message + ".", cause);
	}
}
