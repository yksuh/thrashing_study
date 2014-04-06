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

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import azdblab.executable.Main;

/**
 * Handles the XML errors for validation.  Basically this just prints the message
 * to stderr.
 * @author Kevan Holdaway
 *
 */
public class ExperimentErrorHandler implements ErrorHandler {

	/**
	 * Create an error handler without a source.
	 */
	public ExperimentErrorHandler() {
		myXMLSource = null;
	}

	/**
	 * Creates the error handler with the source XML.
	 * @param xmlSource The path to the source of the XML file.
	 */
	public ExperimentErrorHandler(String xmlSource) {
		myXMLSource = xmlSource;
	}

	/**
	 * @see org.xml.sax.ErrorHandler#error(org.xml.sax.SAXParseException)
	 */
	public void error(SAXParseException e) throws SAXException {
		e.printStackTrace();
		if (myXMLSource != null) {
			Main._logger.reportError(
				"error (file="
					+ myXMLSource
					+ ", line="
					+ e.getLineNumber()
					+ ", column="
					+ e.getColumnNumber()
					+ "):");
			Main._logger.reportError("\t" + e.getMessage());
		}
		hasErrors = true;

	}

	/**
	 * @see org.xml.sax.ErrorHandler#fatalError(org.xml.sax.SAXParseException)
	 */
	public void fatalError(SAXParseException e) throws SAXException {
		e.printStackTrace();
		if (myXMLSource != null) {
			Main._logger.reportError(
				"fatal error (file="
					+ myXMLSource
					+ ", line="
					+ e.getLineNumber()
					+ ", column="
					+ e.getColumnNumber()
					+ "):");
			Main._logger.reportError("\t" + e.getMessage());
		}
		hasErrors = true;
	}

	/**
	 * @see org.xml.sax.ErrorHandler#warning(org.xml.sax.SAXParseException)
	 */
	public void warning(SAXParseException e) throws SAXException {
		e.printStackTrace();
		if (myXMLSource != null) {
			Main._logger.reportError(
				"warning (file="
					+ myXMLSource
					+ ", line="
					+ e.getLineNumber()
					+ ", column="
					+ e.getColumnNumber()
					+ "):");
			Main._logger.reportError("\t" + e.getMessage());
		}
		hasErrors = true;

	}
	/**
	 * This is set to true if an error is found.  That allows the caller to determine the action
	 * after an error has been detected.
	 */
	public static boolean hasErrors = false;

	/**
	 * The source XML file that is being parsed.
	 */
	private String myXMLSource = null;
}
