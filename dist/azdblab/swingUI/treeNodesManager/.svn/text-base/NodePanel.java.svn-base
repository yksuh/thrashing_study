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

import java.awt.Dimension;
import java.awt.BorderLayout;

import javax.swing.JTabbedPane;

import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import salvo.jesus.graph.visual.VisualGraph;

import salvo.jesus.graph.visual.GraphScrollPane;

/**
 * This code was edited or generated using CloudGarden's Jigloo SWT/Swing GUI
 * Builder, which is free for non-commercial use. If Jigloo is being used
 * commercially (ie, by a corporation, company or business for any purpose
 * whatever) then you should purchase a license for each developer using Jigloo.
 * Please visit www.cloudgarden.com for details. Use of Jigloo implies
 * acceptance of these licensing terms. A COMMERCIAL LICENSE HAS NOT BEEN
 * PURCHASED FOR THIS MACHINE, SO JIGLOO OR THIS CODE CANNOT BE USED LEGALLY FOR
 * ANY CORPORATE OR COMMERCIAL PURPOSE.
 */
public class NodePanel extends JPanel {

	static final long serialVersionUID = System.identityHashCode("NodePanel");

	private JTabbedPane tab_Content;

	// private JTabbedPane tab_extendedContent;

	public NodePanel() {
		super();
		initGUI();
	}

	private void initGUI() {
		try {
			setPreferredSize(new Dimension(400, 300));
			BorderLayout thisLayout = new BorderLayout();
			this.setLayout(thisLayout);
			{
				tab_Content = new JTabbedPane();
				this.add(tab_Content);
				tab_Content.setBounds(0, 0, 399, 301);

				// tab_extendedContent = new JTabbedPane();
				// this.add(tab_extendedContent);
				// tab_extendedContent.setBounds(0, 0, 399, 301);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void addComponentToTab(String title, JComponent component) {
		JScrollPane scrpan_content = new JScrollPane(component);
		JPanel contentPanel = new JPanel();
		BorderLayout layout = new BorderLayout();
		contentPanel.setLayout(layout);
		contentPanel.add(scrpan_content);
		tab_Content.addTab(title, contentPanel);
	}

	public void addComponentToTabLight(String title, JComponent component) {
		tab_Content.addTab(title, component);
	}

	public void addComponentToTab(String title, VisualGraph graphcomponent) {
		JScrollPane scrGraphPane = new GraphScrollPane(graphcomponent);
		JPanel graphPanel = new JPanel();
		BorderLayout layout = new BorderLayout();
		graphPanel.setLayout(layout);
		graphPanel.add(scrGraphPane);
		tab_Content.addTab(title, graphPanel);
	}

	public void removeComponentFromTab(String title) {
		for (int i = 0; i < tab_Content.getTabCount(); i++) {
			if (title.equals(tab_Content.getTitleAt(i))) {
				tab_Content.removeTabAt(i);
				break;
			}
		}
	}

	public void updateContent() {
		tab_Content.updateUI();
	}

	public JTabbedPane getContentPane() {
		return tab_Content;
	}

}
