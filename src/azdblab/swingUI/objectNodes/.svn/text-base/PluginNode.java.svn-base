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

import java.util.Vector;

import javax.swing.JPanel;

import azdblab.Constants;
import azdblab.swingUI.treeNodesManager.NodePanel;

public class PluginNode extends ObjectNode {

	private String strPluginName;

	private String strPluginInfo;

	private String strPluginVersion;

	public PluginNode(String pluginInfo, String pluginVersion) {

		String[] detail = pluginInfo.split("###");

		strPluginName = detail[0];
		strNodeName = detail[0];

		strPluginInfo = detail[1];

		strPluginVersion = pluginVersion;
		willHaveChildren = false;
	}

	public String getIconResource(boolean open) {
		if (open) {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "plugin_new.png");
		} else {
			return (Constants.DIRECTORY_IMAGE_LFHNODES + "plugin_new.png");
		}
	}

	private JPanel createPluginPanel() {

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "Plugin Info";
		info += "<p> Plugin Name: " + strPluginName + "</p>";
		info += "<p> Created on: " + strPluginInfo + "</p>";
		info += "<p> Plugin Version " + strPluginVersion + "</p>";
		info += "</font></BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Description", createTextPaneFromString(info));
		// return new JComponentWrapper(userPanel, strUserName,
		// JComponentWrapper.PANEL_TYPE_PANE);
		return npl_toRet;
	}

	public JPanel getDataPanel() {
		return createPluginPanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@Override
	protected void loadChildNodes() {
	}

	@Override
	protected Vector<String> getAuthors() {
		Vector<String> vecToRet = new Vector<String>();
		vecToRet.add("Rui Zhang");
		vecToRet.add("Young-Kyoon Suh");
		vecToRet.add("Matthew Johnson");
		return vecToRet;
	}

	@Override
	protected String getDescription() {
		return "This node contains information pertaining to an installed plugin";
	}

}
