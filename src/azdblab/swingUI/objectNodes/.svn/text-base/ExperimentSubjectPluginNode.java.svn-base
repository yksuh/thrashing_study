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

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Vector;

import javax.swing.JPanel;
import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.plugins.PluginData;
import azdblab.plugins.experimentSubject.ExperimentSubject;
import azdblab.swingUI.treeNodesManager.AZDBLABMutableTreeNode;
import azdblab.swingUI.treeNodesManager.NodePanel;

/**
 * The data module for each user object. Used in creating the views for user in
 * the GUI
 * 
 * @author ZHANGRUI
 * 
 */
public class ExperimentSubjectPluginNode extends ObjectNode {

	private String strDateCreate;

	public ExperimentSubjectPluginNode() {
		strNodeName = "Experiment Subject Plugins";
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

	private JPanel createExpSubPanel() {

		// Info Section 
		String info = "";
		info += "<HTML><BODY><CENTER><h1>";
		info += "</h1></CENTER> <font color='blue'>";
		info += "All the Experiment Subject Plugins";
		info += "</font></BODY></HTML>";
		
		NodePanel npl_toRet = new NodePanel();
		npl_toRet.addComponentToTab("Experiment Subject Plugin Info", createTextPaneFromString(info));

		return npl_toRet;
	}

	public JPanel getDataPanel() {
		return createExpSubPanel();
	}

	public JPanel getButtonPanel() {
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void loadChildNodes() {
		Vector<PluginData> myPlugins = Main.masterManager
				.getPluginsWithSuperclass(ExperimentSubject.class);
		for (int i = 0; i < myPlugins.size(); i++) {
//			try{
//				Method aMethod = myPlugins.get(i).pluginClass
//					.getMethod("getName", null);
//				String dbms_Name = (String)aMethod.invoke(myPlugins.get(i).pluginClass, new Object[0]);
//				System.out.println("DBMSNAME = " + dbms_Name);
//			}catch(java.lang.NoSuchMethodException ex){
//				//do nothing
//			}catch(Exception e){
//				e.printStackTrace();
//			}
			try {
//				Method method = null;
//				Class[] params = new Class[0];
//				method = myPlugins.get(i).pluginClass.getDeclaredMethod(
//						"getExperimentSubjectName", params);
//				if (method == null) {
//					Main._logger.outputLog("method is null!");
//					System.exit(-1);
//				}
//				Object[] paramobj = new Object[0];
//				Object tempObj = method.invoke(null, paramobj);
//				if (tempObj == null) {
//					Main._logger.outputLog("tempObj is null!");
//					System.exit(-1);
//				}
//				String styleName = tempObj.toString()
//						+ "Subject_"
//						+ myPlugins.get(i).pluginFileName.substring(myPlugins
//								.get(i).pluginFileName.indexOf("_") + 1,
//								myPlugins.get(i).pluginFileName.indexOf("."));

				Class partypes[] = new Class[3];
				partypes[0] = String.class;
				partypes[1] = String.class;
				partypes[2] = String.class;
				Method aMethod = myPlugins.get(i).pluginClass.getMethod(
						"getDBMSName", (Class<?>[])null);
				String dbms_Name = (String) aMethod.invoke(myPlugins.get(i).pluginClass.getConstructor(partypes).newInstance(new Object[3]), new Object[0]);
				String styleName = dbms_Name + "Subject_" + myPlugins.get(i).pluginFileName.substring(myPlugins
						.get(i).pluginFileName.indexOf("_") + 1,myPlugins.get(i).pluginFileName.indexOf("."));
				String detail = myPlugins.get(i).lastUpdated.toString();
				parent.add(new AZDBLABMutableTreeNode(new PluginNode(styleName
						+ "###" + detail,myPlugins.get(i).pluginVersion)));

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
		return "This node contains information regarding an installed experiment subject plugin";
	}

}
