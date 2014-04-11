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


import java.lang.reflect.Modifier;
import java.util.Vector;

import javax.swing.JPanel;
import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.plugins.PluginData;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The data module for each user object. Used in creating the views for user in
 * the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class ScenarioPluginNode extends ObjectNode {

	private String strDateCreate;


	public ScenarioPluginNode() {
		strNodeName = "Scenario Plugins";
	}

	public void setCreateDate(String create) {
		strDateCreate = create;
	}

	public String getCreateDate() {
		return strDateCreate;
	}

	public String getIconResource(boolean open) {
		if (open) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "plugin_parent.png");
		} else {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "plugin_parent.png");
		}
	}

	private JPanel createScenarioPanel() {

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "All the Scenario Plugins";
		info += "</font></BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Scenario Plugin Info", createTextPaneFromString(info));
		// return new JComponentWrapper(userPanel, strUserName,
		// JComponentWrapper.PANEL_TYPE_PANE);
		return npl_toRet;
	}

	public JPanel getDataPanel() {
		return createScenarioPanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {
		loadChilds(Main.masterManager
				.getPluginsWithSuperclass(azdblab.plugins.scenario.Scenario.class));
		
	//	loadChilds(Main.masterManager
	//			.getPluginsWithSuperclass(ScenarioBasedOnQuery.class));
	//	loadChilds(Main.masterManager
	//			.getPluginsWithSuperclass(ScenarioBasedOnCardinality.class));

	}
	
	private void loadChilds(Vector<PluginData> myPlugins){
		for (int i = 0; i < myPlugins.size(); i++) {
			try {
				if (Modifier.isAbstract(myPlugins.get(i).pluginClass.getModifiers())) {
					return;
				}

				String version_tag = myPlugins.get(i).pluginFileName.substring(
						myPlugins.get(i).pluginFileName.indexOf("_") + 1,
						myPlugins.get(i).pluginFileName.indexOf("."));
				String styleName = myPlugins.get(i).pluginClass.getSimpleName().replaceAll("Scenario", "")
						+ "_" + version_tag;

				String detail = myPlugins.get(i).lastUpdated.toString();
				parent.add(new AZDBLABMutableTreeNode(new PluginNode(styleName + "###"
						+ detail,myPlugins.get(i).pluginVersion)));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}
	
	

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Young-Kyoon Suh");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information regarding an installed scenario plugin";
	}
}
