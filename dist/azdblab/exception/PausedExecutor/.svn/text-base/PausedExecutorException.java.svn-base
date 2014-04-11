package azdblab.exception.PausedExecutor;

public class PausedExecutorException extends Exception {
	private static final long serialVersionUID =  System
			.identityHashCode("PausedExecutorException");

	/**
	 * Creates an exception of this type.
	 */
	public PausedExecutorException() {
		this("", null);
	}

	/**
	 * Creates an exception of this type with the specified message.
	 * @param message The message to be displayed with this exception.
	 */
	public PausedExecutorException(String message) {
		this(message, null);
	}

	/**
	 * Creates an exception of this type with the cause passed as a 
	 * parameter.
	 * @param cause The exception that is the cause of this exception.
	 */
	public PausedExecutorException(Throwable cause) {
		this("", cause);
	}

	/**
	 * Creates an exception of this type with the cause passed as a
	 * parameter and a message passed as a parameter.
	 * @param message The message that will be displayed for this exception.
	 * @param cause The cause of this exception.
	 */
	public PausedExecutorException(String message, Throwable cause) {
		super("Paused Executor Exception on " + message + ".", cause);
	}
}
