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

package azdblab.observer.api;

import javax.swing.JTextPane;
import javax.swing.JPanel;
import javax.swing.tree.TreePath;
import salvo.jesus.graph.visual.VisualGraph;
import salvo.jesus.graph.visual.layout.ForceDirectedLayout;
import salvo.jesus.graph.visual.layout.LayeredTreeLayout;

/**
 * Provides an interface for controlling the contents of the right pane and the
 * tree on the left.
 * @author Kevan Holdaway
 *
 */
public interface ResultNavigationTreeInterface {
	/**
	 *  Removes the content from the right pane.  It will appear blank.
	 */
	public void clearRightComponent();
	
	/**
	 * Returns the current selection path in the tree.
	 * @return The current selection path in the tree.
	 */
	public TreePath getCurrentSelectionPath();
	
	/**
	 * Sets the current selection path to curr
	 * @param curr The selection path that is set to the current selection path.
	 */
	public void setCurrentSelectionPath(TreePath curr);
	
	/**
	 * Sets the layouts for a graph.
	 * @param layout1 The traditional layout
	 * @param layout2 The moving layout.
	 */
	public void setLayouts(LayeredTreeLayout layout1, ForceDirectedLayout layout2);
	
	/**
	 * Sets the previous selection path.  This used if the current experiment is closed. 
	 * @param old The previous selection path.
	 */
	public void setPreviousSelectionPath(TreePath old);
	
	/**
	 * Sets the content of the right pane as a JTextPane.
	 * @param right The JTextPane that will be on the right.
	 */
	public void setRightSideAsEditor(JTextPane right);
	
	
	/**
	 * 
	 * @param right
	 */ 
	public void setRightSideAsPanel(JPanel rightup);
	public void setRightSideAsPanel1(JPanel rightbottom);
	
	
	/**
	 * 
	 * @param right
	 */ 
	//public void setRightSideAsPanel(ObjectNode objNode);
	
	
	/**
	 * 
	 * @param right
	 */
	//public void setRightSideAsFrame(JInternalFrame right);
	
	/**
	 * Sets the content of the right pane to a VisualGraph.
	 * @param right The VisualGraph that will be on the right.
	 */
	public void setRightSideAsGraph(VisualGraph right);
}
