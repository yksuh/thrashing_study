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
package azdblab.observer.controller.listeners;

import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreePath;
//import AZDBLab.browser.gui.leftHandSide.JComponentWrapper;
import salvo.jesus.graph.visual.VisualGraph;

import azdblab.observer.api.ResultNavigationTreeInterface;
import azdblab.swingUI.objectNodes.ObjectNode;
import azdblab.swingUI.treeNodesManager.VisualGraphWrapper;

/**
 * This tree listener handles navagation events that occur on the tree that appears on the left pane of 
 * the result browser.  
 * @author Kevan Holdaway
 *
 */
public class ExperimentTreeListener implements TreeSelectionListener {
	/**
	 * Takes an interface that allows the listener to manipulate the tree.
	 * @param pane The pane that contains this tree.
	 */
	public ExperimentTreeListener(ResultNavigationTreeInterface pane) {
		_result = pane;
	}
	/**
	 * @see javax.swing.event.TreeSelectionListener#valueChanged(javax.swing.event.TreeSelectionEvent)
	 */
	public void valueChanged(TreeSelectionEvent e) {

		//Recording the previous selection in the tree (if this is a new selection, this will become the old selection)
		TreePath prevSelected = _result.getCurrentSelectionPath();
		
		//Recording the new selection.
		TreePath newSelected = e.getNewLeadSelectionPath();
		
		//The previous selection is used if the current experiment is close.  The result browser will then display
		//the experiment that was being displayed previously.
		if (newSelected != null) {
			//if something new was selected in the tree.
			if (prevSelected == null && newSelected.getPathCount() > 1) {
				//If there was no previous selection, set this to the current selection.
				_result.setCurrentSelectionPath(e.getNewLeadSelectionPath());
			} else {
				//If there was something selected before this event
				if (newSelected.getPathCount() > 1) {
					if (newSelected.getPathComponent(1).equals(prevSelected.getPathComponent(1))) {
						//update current selected but not previous since the same experiment is still selected.
						_result.setCurrentSelectionPath(newSelected);
					} else {
						//update last selected and current selected
						_result.setPreviousSelectionPath(prevSelected);
						_result.setCurrentSelectionPath(newSelected);
					}

				}
			}
			Object end = ((DefaultMutableTreeNode) newSelected.getLastPathComponent()).getUserObject();
			
			
			//if (end instanceof JTextPaneWrapper) {
			//	_result.setRightSideAsEditor(((JTextPaneWrapper) end).myTextPane);
			
				
			//Updating the right side of the browser to display the correct view.
			//if( end instanceof JComponentWrapper ) {
             //   if( ( (JComponentWrapper) end ).getType(  ) == JComponentWrapper.TEXT_PANE_TYPE ) {
             //       _result.setRightSideAsEditor( (JTextPane) ( (JComponentWrapper) end )
              //                                    .getComponent(  ) );
               // } else if( ( (JComponentWrapper) end ).getType(  ) == JComponentWrapper.QUERY_PANEL_TYPE ) {
                //    _result.setRightSideAsPanel( (JPanel) ( (JComponentWrapper) end )
                 //                                .getComponent(  ) );
                //} else if( ( (JComponentWrapper) end ).getType(  ) == JComponentWrapper.PANEL_TYPE_PANE ) {
                 //   _result.setRightSideAsPanel( (JPanel) ( (JComponentWrapper) end )
                  //          .getComponent(  ) );
                //}
                
			//} else if (end instanceof ObjectNode) {
			if (end instanceof ObjectNode) {
				_result.setRightSideAsPanel(((ObjectNode)end).getModifiedDataPanel());
				_result.setRightSideAsPanel1(((ObjectNode)end).getModifiedButtonPanel());
				((ObjectNode)end).loadChildren();
			}
			
			
			else if (end instanceof VisualGraphWrapper) {
				VisualGraphWrapper w = (VisualGraphWrapper) end;
				VisualGraph v = w.myVisualGraph;
				_result.setRightSideAsGraph(v);
				_result.setLayouts(w.myLayeredLayout, w.myForcedLayout);
			} else {
				//do nothing since unknown type
			}
		} else {
			_result.clearRightComponent();
		}
	}

	/**
	 * Used to manipulate the actual JTree.
	 */
	private ResultNavigationTreeInterface _result;

}
