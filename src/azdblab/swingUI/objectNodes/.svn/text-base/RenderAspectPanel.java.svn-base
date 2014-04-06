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

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.ListModel;
import javax.swing.DefaultListModel;
import java.util.List;
import azdblab.labShelf.dataModel.User;
import azdblab.swingUI.AZDBLabObserver;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.treeNodesManager.*;

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
public class RenderAspectPanel extends javax.swing.JPanel {

	static final long serialVersionUID = System
			.identityHashCode("RenderAspectPanel");

	private JScrollPane scrpan_AspectList;
	private JList lst_AspectList;
	private JButton btn_Clear;
	private JButton btn_Indicate;

	private List<String> vecAspects;

	private AZDBLABMutableTreeNode tnCurrentNode;

	private String strUserName;

	private String strNotebookName;

	private String strExperimentName;

	private String strStartTime;

	public RenderAspectPanel(String userName, String notebookName,
			String experimentName, String startTime,
			AZDBLABMutableTreeNode currentNode) {
		super();

		initVAR(userName, notebookName, experimentName, startTime, currentNode);

		initGUI();
	}

	private void initVAR(String userName, String notebookName,
			String experimentName, String startTime,
			AZDBLABMutableTreeNode currentNode) {

		strUserName = userName;
		strNotebookName = notebookName;
		strExperimentName = experimentName;
		strStartTime = startTime;
		tnCurrentNode = currentNode;

		vecAspects = User.getUser(strUserName).getAspectNamesByUser();
	}

	private void initGUI() {
		try {
			this.setPreferredSize(new java.awt.Dimension(491, 384));
			this.setLayout(null);
			{
				scrpan_AspectList = new JScrollPane();
				this.add(scrpan_AspectList);
				scrpan_AspectList.setBounds(0, 0, 490, 294);
				{
					ListModel lst_AspectListModel = new DefaultListModel();

					for (int i = 0; i < vecAspects.size(); i++) {
						((DefaultListModel) lst_AspectListModel)
								.addElement(vecAspects.get(i));
					}

					lst_AspectList = new JList();
					scrpan_AspectList.setViewportView(lst_AspectList);
					lst_AspectList.setModel(lst_AspectListModel);
				}
			}
			{
				btn_Indicate = new JButton();
				this.add(btn_Indicate);
				btn_Indicate.setText("Indicate");
				btn_Indicate.setBounds(91, 315, 126, 28);
				btn_Indicate.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent evt) {
						btn_IndicateActionPerformed(evt);
					}
				});
			}
			{
				btn_Clear = new JButton();
				this.add(btn_Clear);
				btn_Clear.setText("Clear");
				btn_Clear.setBounds(259, 315, 133, 28);
				btn_Clear.addActionListener(new ActionListener() {
					public void actionPerformed(ActionEvent evt) {
						btn_ClearActionPerformed(evt);
					}
				});
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void btn_IndicateActionPerformed(ActionEvent evt) {
		// Main._logger.outputLog("btn_Indicate.actionPerformed, event=" + evt);
		// TODO add your code for btn_Indicate.actionPerformed
		String aspectName = (String) lst_AspectList.getSelectedValue();

		if (aspectName == null || aspectName.equals("")) {
			return;
		}

		List<Integer> vecQueryNum = User.getUser(strUserName).getNotebook(
				strNotebookName).getExperiment(strExperimentName).getRun(
				strStartTime).getQueryNumsWithAspect(aspectName);

		for (int i = 0; i < vecQueryNum.size(); i++) {
			int id = vecQueryNum.get(i);
			AZDBLABMutableTreeNode tnode = (AZDBLABMutableTreeNode) tnCurrentNode
					.getChildAt(id + 2);
			((ObjectNode) tnode.getUserObject()).setIsSpecial(true);
		}

	}

	private void btn_ClearActionPerformed(ActionEvent evt) {
		// Main._logger.outputLog("btn_Clear.actionPerformed, event=" + evt);
		// TODO add your code for btn_Clear.actionPerformed
		for (int i = 0; i < tnCurrentNode.getChildCount(); i++) {
			AZDBLABMutableTreeNode tnode = (AZDBLABMutableTreeNode) tnCurrentNode
					.getChildAt(i);
			((ObjectNode) tnode.getUserObject()).setIsSpecial(false);
		}

	}

}
