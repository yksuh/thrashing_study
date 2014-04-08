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

import java.lang.reflect.Method;
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
public class AspectPluginNode extends ObjectNode {

	private String strDateCreate;

	public AspectPluginNode() {
		strNodeName = "Aspect Plugins";
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

	private JPanel createAspectPanel() {

		// Info Section
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "All the Aspect Plugins";
		info += "</font></BODY></HTML>";

		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Aspect Plugin Info", createTextPaneFromString(info));
		
		return npl_toRet;
	}

	public JPanel getDataPanel() {
		return createAspectPanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void loadChildNodes() {
//		Vector<PluginData> myPlugins = Main.masterManager
//				.getPluginsWithSuperclass(azdblab.plugins.aspect.Aspect.class);
//
//		for (int i = 0; i < myPlugins.size(); i++) {
//			try {
//				Method method = null;
//				Class[] params = new Class[0];
//				method = myPlugins.get(i).pluginClass.getDeclaredMethod(
//						"getAspectStyleName", params);
//				String version_tag = myPlugins.get(i).pluginFileName.substring(
//						myPlugins.get(i).pluginFileName.indexOf("_") + 1,
//						myPlugins.get(i).pluginFileName.indexOf("."));
//				Object[] paramobj = new Object[0];
//				String styleName = method.invoke(null, paramobj).toString()
//						+ "_" + version_tag;
//
//				String detail = myPlugins.get(i).lastUpdated.toString();
//				parent.add(new AZDBLABMutableTreeNode(new PluginNode(styleName
//						+ "###" + detail,myPlugins.get(i).pluginVersion)));
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}

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
		return "This node contains information regarding an installed aspect";
	}

}
