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

import javax.swing.SizeRequirements;
import javax.swing.text.Element;
import javax.swing.text.View;
import javax.swing.text.ViewFactory;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.InlineView;
import javax.swing.text.html.ParagraphView;
import javax.swing.text.html.StyleSheet;

public class AZDBLABHtmlEditorKit extends HTMLEditorKit {
	private static final long serialVersionUID = System
			.identityHashCode("AZDBLABHtmlEditorKit");

	public AZDBLABHtmlEditorKit() {
		setupCSS();
	}
	
	private void setupCSS(){
		StyleSheet ss = getStyleSheet();
		ss.addRule("html { background-image:url('http://www.cs.arizona.edu/projects/tau/img/azdblabLogo.png');background-repeat:no-repeat; background-position:right top;");
	}

	@Override
	public ViewFactory getViewFactory() {

		return new HTMLFactory() {

			public View create(Element e) {
				View v = super.create(e);
				if (v instanceof InlineView) {
					return new InlineView(e) {
						public int getBreakWeight(int axis, float pos, float len) {
							return GoodBreakWeight;
						}

						public View breakView(int axis, int p0, float pos,
								float len) {
							if (axis == View.X_AXIS) {
								checkPainter();
								int p1 = getGlyphPainter().getBoundedPosition(
										this, p0, pos, len);
								if (p0 == getStartOffset()
										&& p1 == getEndOffset()) {
									return this;
								}
								return createFragment(p0, p1);
							}
							return this;
						}
					};
				} else if (v instanceof ParagraphView) {
					return new ParagraphView(e) {
						protected SizeRequirements calculateMinorAxisRequirements(
								int axis, SizeRequirements r) {
							if (r == null) {
								r = new SizeRequirements();
							}
							float pref = layoutPool.getPreferredSpan(axis);
							float min = layoutPool.getMinimumSpan(axis);
							r.minimum = (int) min;
							r.preferred = Math.max(r.minimum, (int) pref);
							r.maximum = Integer.MAX_VALUE;
							r.alignment = 0.5f;
							return r;
						}

					};
				}
				return v;
			}
		};
	}
}
