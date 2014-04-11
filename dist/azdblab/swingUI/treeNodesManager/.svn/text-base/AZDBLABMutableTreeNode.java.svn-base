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

import java.awt.Color;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.ImageIcon;

import azdblab.swingUI.objectNodes.*;

public class AZDBLABMutableTreeNode extends DefaultMutableTreeNode {
	
	public static final long		serialVersionUID	= System.identityHashCode("AZDBLABMutableTreeNode");
	
	/**
     * Creates a tree node that has no parent and no children, but which
     * allows children.
     */
    public AZDBLABMutableTreeNode() {
    	this(null);
    }

    /**
     * Creates a tree node with no parent, no children, but which allows 
     * children, and initializes it with the specified user object.
     * 
     * @param userObject an Object provided by the user that constitutes
     *                   the node's data
     */
    public AZDBLABMutableTreeNode(Object userObject) {
    	this(userObject, true);
    }

    /**
     * Creates a tree node with no parent, no children, initialized with
     * the specified user object, and that allows children only if
     * specified.
     * 
     * @param userObject an Object provided by the user that constitutes
     *        the node's data
     * @param allowsChildren if true, the node is allowed to have child
     *        nodes -- otherwise, it is always a leaf node
     */
    public AZDBLABMutableTreeNode(Object userObject, boolean allowsChildren) {
		super();
		parent 				= null;
		this.allowsChildren = allowsChildren;
		this.userObject 	= userObject;
		
		if(this.userObject instanceof ObjectNode){
			((ObjectNode)userObject).setParent(this);
		}
		
    }
   
    
    public String toString() {
    	return userObject.toString();
    }
    
    
	public ImageIcon getNodeIcon(boolean open) {
		if (userObject instanceof ObjectNode) {
			
			String	resource		= ((ObjectNode)userObject).getIconResource(open);
			//System.out.println("resource: " + resource);
			if (resource != null) {
				return new ImageIcon(getClass().getClassLoader().getResource(resource));
			}
		}
		return null;
	}
	
	
	public Color getNodeForegroundColor() {
		return Color.red;
	}
	
	public Color getNodeBackgroundColor() {
		return Color.blue;
	}
	
	
	public boolean getIsNodeSpecial() {
		
		if (userObject instanceof ObjectNode) {
			return ((ObjectNode)userObject).getIsSpecial();
		}
		
		return false;
		
	}
	
}
