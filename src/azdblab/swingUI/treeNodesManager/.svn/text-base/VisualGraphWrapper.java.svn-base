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

package azdblab.swingUI.treeNodesManager;

import salvo.jesus.graph.visual.VisualGraph;
import salvo.jesus.graph.visual.layout.ForceDirectedLayout;
import salvo.jesus.graph.visual.layout.LayeredTreeLayout;

/**
 * The main purpose of the VisualGraphWrapper is to allow the toString method to return a meaningful
 * identifier that will be used in the JTree.  A JTree uses the toString method to determine what 
 * test is displayed for an object being stored in the tree.  
 * @author Kevan Holdaway
 *
 */
public class VisualGraphWrapper {
	/**
	 * Creates a VisualGraphWrapper with the display name name and the actual object obj.
	 * @param obj The VisualGraph that will be displayed by the result browser when it is selected in the tree.
	 * @param name The name that will appear for this object in the tree.
	 */
	public VisualGraphWrapper(VisualGraph obj, String name) {
		myVisualGraph = obj;
		myName = name;
		myLayeredLayout = new LayeredTreeLayout(myVisualGraph);
		myForcedLayout = new ForceDirectedLayout(myVisualGraph);
	}

	/**
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return myName;
	}
	/**
	 * A handle to the layout that corresponds with this VisualGraph.  This is also known as the 
	 * moving layout.
	 */
	public ForceDirectedLayout myForcedLayout;
	/**
	 * A handle to the layout that corresponds with this VisualGraph.  This is also known as the traditional
	 * layout. 
	 */
	public LayeredTreeLayout myLayeredLayout;
	/**
	 * The name of the graph that will appear in the tree.
	 */
	public String myName;
	/**
	 * The graph object that will be displayed when the node in the tree is selected.
	 */
	public VisualGraph myVisualGraph;

}
