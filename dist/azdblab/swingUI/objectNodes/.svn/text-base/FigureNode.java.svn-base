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
package azdblab.swingUI.objectNodes;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Vector;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import com.panayotis.gnuplot.swing.JPlot;

import azdblab.Constants;
import azdblab.labShelf.dataModel.Figure;
import azdblab.labShelf.dataModel.InstantiatedQuery;
import azdblab.labShelf.dataModel.Paper;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * A FigureNode is a collection of all the Figures It contains two tabs, the
 * first tab has a list of all Figures. The second tab contains a nodepanel
 * consisting of various information
 * 
 * @author mwj
 * 
 */

public class FigureNode extends ObjectNode {
	private NodePanel jpl_viewPanel;
	private int paperID;
	private JList lst_figureList;
	private JPanel jpl_GNUPanel;
	private JPanel jpl_Description;
	private JPanel jpl_Query;
	private JPanel jpl_MiscData;

	public FigureNode(int ID) {
		strNodeName = "Figures";
		willHaveChildren = false;
		paperID = ID;
			}

	public JPanel getButtonPanel() {
		return createButtonPanel();
	}

	private JPanel createButtonPanel() {
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new FlowLayout());
		JButton button = new JButton("Add Figure");
		buttonPanel.add(button);
		button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				AddFigureActionPerformed(ev);
			}
		});
		return buttonPanel;

	}

	private void AddFigureActionPerformed(ActionEvent ev) {

	}

	/**
	 * 
	 * @return the LHS
	 */
	private JPanel createFigurePanel() {

		NodePanel figurePanel = new NodePanel();

		figurePanel.addComponentToTab("Select Figure", initializeSelect());
		figurePanel.addComponentToTab("View Figure", initializeView());
		return figurePanel;
	}

	/**
	 * Sets up the list containing all the figures present in this paper
	 * 
	 * @return
	 */
	private JPanel initializeSelect() {
		DefaultListModel data = new DefaultListModel();
		List<Figure> vecFigures = Paper.getPaper(paperID).getAllFigures();

		for (int i = 0; i < vecFigures.size(); i++) {
			data.addElement(vecFigures.get(i));
		}
		lst_figureList = new JList(data);

		JButton btn_display = new JButton("Display Figure");
		btn_display.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent q) {
				try {
					btn_displayActionPreformed();
				} catch (Exception e) {
					JOptionPane
							.showMessageDialog(null, "Failed to draw Figure");
					e.printStackTrace();
				}
			}
		});

		JPanel selectPanel = new JPanel();
		selectPanel.setLayout(new BorderLayout());
		selectPanel.add(lst_figureList, BorderLayout.CENTER);
		selectPanel.add(btn_display, BorderLayout.SOUTH);
		return selectPanel;
	}

	/**
	 * Sets up the view contiaining the detailed query info
	 * 
	 * @return
	 */
	private JPanel initializeView() {
		jpl_viewPanel = new NodePanel();
		jpl_GNUPanel = new JPanel();
		jpl_Description = new JPanel();
		jpl_Query = new JPanel();
		jpl_MiscData = new JPanel();
		jpl_viewPanel.addComponentToTab("GNUPlot", jpl_GNUPanel);
		jpl_viewPanel.addComponentToTab("Description", jpl_Description);
		jpl_viewPanel.addComponentToTab("Query", jpl_Query);
		jpl_viewPanel.addComponentToTab("Misc.", jpl_MiscData);
		return jpl_viewPanel;
	}

	/**
	 * Fetches the query from the database, runs it and populates the necessary
	 * fields in the panel created by initializeView()
	 * 
	 * @throws Exception
	 *             all errors in fetching result in a draw failure
	 * @see goButton_ActionPreformed in QueryCreateNode for explanation on
	 *      JavaPlot
	 */
	private void btn_displayActionPreformed() throws Exception {
		if (lst_figureList.getSelectedIndex() == -1) {
			return;
		}
		jpl_GNUPanel.removeAll();
		jpl_Description.removeAll();
		jpl_Query.removeAll();
		jpl_MiscData.removeAll();

		Figure selectedFigure = (Figure) lst_figureList.getSelectedValue();

		// the top panel has the basic data
		JLabel nameInfo = new JLabel("Figure Name:"
				+ selectedFigure.getFigureName());
		JLabel dateInfo = new JLabel("Creation Date:"
				+ selectedFigure.getCreationTime());

		jpl_MiscData.setLayout(new GridLayout(20, 1));
		jpl_MiscData.add(nameInfo);
		jpl_MiscData.add(dateInfo);

		JTextArea txt_Description = new JTextArea(selectedFigure
				.getDescription());
		txt_Description.setLineWrap(true);
		txt_Description.setEditable(false);
		txt_Description.setPreferredSize(new Dimension(700, 200));

		// step1 get the query

		String predef_query = InstantiatedQuery.getInstantiatedQuery(
				selectedFigure.getInstantiatedQueryID()).getInstantiatedSQL();

		JPlot plot = new JPlot();
		plot.setPreferredSize(new Dimension(750, 600));
		plot.setJavaPlot(selectedFigure.getJavaPlot());
		plot.plot();
		jpl_GNUPanel.add(plot);

		JTextArea txt_Query = new JTextArea(predef_query);
		txt_Query.setEditable(false);
		txt_Query.setLineWrap(true);
		txt_Query.setPreferredSize(new Dimension(700, 200));

		jpl_Query.setLayout(new BorderLayout());
		jpl_Query.add(new JLabel("Query for Figure:"
				+ selectedFigure.getFigureName()), BorderLayout.NORTH);
		jpl_Query.add(txt_Query, BorderLayout.CENTER);

		jpl_Description.setLayout(new BorderLayout());
		jpl_Description.add(new JLabel("Description of Figure:"
				+ selectedFigure.getFigureName()), BorderLayout.NORTH);
		jpl_Description.add(txt_Description, BorderLayout.CENTER);

		jpl_GNUPanel.repaint();
		jpl_Description.repaint();
		jpl_Query.repaint();
		jpl_MiscData.repaint();
	}

	public JPanel getDataPanel() {
		AZDBLabObserver.putInfo("You are looking at a Figure Node");

		return createFigurePanel();
	}

	public String getIconResource(boolean open) {
		if (open) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "figure_open.png");
		} else {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "figure_close.png");
		}
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information on all of the figures associated with a paper";
	}

}