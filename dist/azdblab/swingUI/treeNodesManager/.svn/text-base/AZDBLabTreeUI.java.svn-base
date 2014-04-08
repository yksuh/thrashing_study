package azdblab.swingUI.treeNodesManager;

import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Insets;
import java.awt.Point;
import java.awt.Rectangle;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;

import javax.swing.Icon;
import javax.swing.JComponent;
import javax.swing.JScrollPane;
import javax.swing.JViewport;
import javax.swing.plaf.basic.BasicTreeUI;
import javax.swing.tree.AbstractLayoutCache;
import javax.swing.tree.TreePath;

//TODO this class is not used at the moment

// If everything is uncommented it will Extend the painted area all the way to the left of the visable area.

// For this to work properly, the following needs to be implemented
// 1) It must also extend all the way to the right
// 2) It should extend SynthTreeUI not BasicTreeUI to get the Icons looking correct
// However as far as I can tell  even in the fully implemented state this will look worse than the default
public class AZDBLabTreeUI extends BasicTreeUI {

	public AZDBLabTreeUI() {
		super();
	}

	private JScrollPane fScrollPane;

	@Override
	public void installUI(JComponent c) {
		super.installUI(c);

		tree.addPropertyChangeListener("ancestor",
				new PropertyChangeListener() {
					public void propertyChange(PropertyChangeEvent evt) {
						parentDidChange();
					}
				});
	}

	private void parentDidChange() {
		if (tree.getParent() instanceof JViewport
				&& tree.getParent().getParent() instanceof JScrollPane) {
			fScrollPane = (JScrollPane) tree.getParent().getParent();
		}
	}

	@Override
	protected AbstractLayoutCache.NodeDimensions createNodeDimensions() {
		return new NodeDimensionsHandler() {

			// TODO this needs to modify node dimensions to full to the Left as
			// well, current expands only to the left
			@Override
			public Rectangle getNodeDimensions(Object value, int row,
					int depth, boolean expanded, Rectangle size) {

				Rectangle dimensions = super.getNodeDimensions(value, row,
						depth, expanded, size);
				if (fScrollPane != null) {
					dimensions.width = fScrollPane.getViewport().getWidth()
							- getRowX(row, depth);
				}
				return dimensions;
			}
		};
	}

	@Override
	protected void paintHorizontalLine(Graphics g, JComponent c, int y,
			int left, int right) {
		// do nothing.
	}

	@Override
	protected void paintVerticalPartOfLeg(Graphics g, Rectangle clipBounds,
			Insets insets, TreePath path) {
		// do nothing.
	}

}
