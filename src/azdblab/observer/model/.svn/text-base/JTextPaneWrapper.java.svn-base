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

package azdblab.observer.model;

import javax.swing.JTextPane;

import azdblab.swingUI.JColorTextPane;


/**
 * The main purpose of this class is to provide a meaningful name for the JTextPane when being displayed in
 * the tree.  The JTree uses the toString method to determine what is displayed for an object that is contained
 * in a node in the tree.
 * @author Kevan Holdaway
 *
 */
public class JTextPaneWrapper {
	/**
	 * Creates a JTextPaneWrapper containing the TextPane obj and returning a name of name.
	 * @param obj The JTextPane stored in this object.
	 * @param name The name of the JTextPane that will be displayed in the JTree.
	 */
	public JTextPaneWrapper(JTextPane obj, String name) {
		myTextPane = obj;
		if (obj instanceof JColorTextPane)
			 ((JColorTextPane) myTextPane).init();

		myName = name;
	}

	/**
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return myName;
	}
	/**
	 * The name of the JTextPane that will be displayed in the JTree.
	 */
	public String myName;
	/**
	 * The JTextPane that will be displayed when the appropriate node is selected in the JTree.
	 */
	public JTextPane myTextPane;
}
