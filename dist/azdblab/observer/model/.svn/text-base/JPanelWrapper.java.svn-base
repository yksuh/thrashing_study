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

import javax.swing.JPanel;


/**
 * The main purpose of this class is to provide a meaningful name for the
 * JPanel when being displayed in the tree.  The JTree uses the toString
 * method to determine what is displayed for an object that is contained in a
 * node in the tree.
 *
 * @author Siou Lin
 */
public class JPanelWrapper {
    //~ Constructors 

    /**
     * Creates a JTextPaneWrapper containing the TextPane obj and returning a
     * name of name.
     *
     * @param obj The JTextPane stored in this object.
     * @param name The name of the JTextPane that will be displayed in the
     *        JTree.
     */
    public JPanelWrapper( JPanel obj,
                          String name ) {
        myPanel = obj;

        if( obj instanceof JPanel ) {
            //((JPanel) myPanel).init();
        }

        myName = name;
    }

    //~ Methods 

    /**
     * @see java.lang.Object#toString()
     */
    public String toString(  ) {
        return myName;
    }

    //~ Instance fields 

    /**
     * The JTextPane that will be displayed when the appropriate node is
     * selected in the JTree.
     */
    public JPanel myPanel;

    /** The name of the JTextPane that will be displayed in the JTree. */
    public String myName;
    
}
