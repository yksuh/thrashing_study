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
import java.awt.Component;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;

import javax.swing.JTree;
import javax.swing.tree.DefaultTreeCellRenderer;

public class AZDBLABTreeCellRenderer extends DefaultTreeCellRenderer {

	public static final long serialVersionUID = System
			.identityHashCode("AZDBLABTreeCellRenderer");

	public AZDBLABTreeCellRenderer() {
		super();
		setTextSelectionColor(Color.black); 
	}

	/**
	 * Configures the renderer based on the passed in components. The value is
	 * set from messaging the tree with <code>convertValueToText</code>, which
	 * ultimately invokes <code>toString</code> on <code>value</code>. The
	 * foreground color is set based on the selection and the icon is set based
	 * on the <code>leaf</code> and <code>expanded</code> parameters.
	 */
	public Component getTreeCellRendererComponent(JTree tree, Object value,
			boolean sel, boolean expanded, boolean leaf, int row,
			boolean hasFocus) {

		super.getTreeCellRendererComponent(tree, value, sel, expanded, leaf,
				row, hasFocus);

		if (value instanceof AZDBLABMutableTreeNode) {
			setIcon(((AZDBLABMutableTreeNode) value).getNodeIcon(expanded));

			if (((AZDBLABMutableTreeNode) value).getIsNodeSpecial()) {
				// Main._logger.outputLog("The Special Node");
				setForeground(((AZDBLABMutableTreeNode) value)
						.getNodeForegroundColor());

				// setOpaque(true);
				// setBackgroundSelectionColor(((AZDBLABMutableTreeNode)value).getNodeBackgroundColor());

			}
		}

		return this;

	}
	//TODO this will add a gradation
	/*
	@Override
	protected void paintComponent(Graphics g) {
		// if ( !isOpaque( ) )
		// {
		// super.paintComponent( g );
		// return;
		// }
		Graphics2D g2d = (Graphics2D) g;
		int w = getWidth();
		int h = getHeight();

		Color clr_Default = Color.lightGray;
		// Paint a gradient from top to bottom
		GradientPaint gp = new GradientPaint(0, 0, clr_Default, w, h,
				Color.white);

		g2d.setPaint(gp);
		g2d.fillRect(0, 0, w, h);

		setOpaque(false);
		super.paintComponent(g);
		setOpaque(true);
	}
	*/
	public void updateUI() {
		super.updateUI();
	}

}
