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
package azdblab.plugins.evaluation;

import java.lang.reflect.Constructor;
import java.util.List;
import java.util.Vector;

import azdblab.executable.Main;
import azdblab.plugins.PluginData;
import azdblab.swingUI.objectNodes.ObjectNode;

public class EvaluationPluginManager {

	/**
	 * 
	 * This should do two things, first it should Be able to read files in the
	 * loaded plugins from the plugins directory
	 * 
	 * The second should be to give the plugins to a class
	 */

	private Vector<Evaluation> allPlugins;

	public EvaluationPluginManager() {
		allPlugins = new Vector<Evaluation>();
		init();
		
	}

	@SuppressWarnings("unchecked")
	private void init(){
		Vector<PluginData> myPlugins = Main.masterManager.getPluginsWithSuperclass(Evaluation.class);
		for(int i = 0; i < myPlugins.size(); i++){
			try{
			Class partypes[] = new Class[1];
			partypes[0] = ObjectNode.class;
			Object arglist[] = new Object[1];
			arglist[0] = null;
			Constructor constructor = myPlugins.get(i).pluginClass.getConstructor(partypes);
			Evaluation newPlugin = (Evaluation) constructor
					.newInstance(arglist);
			allPlugins.add(newPlugin);
			newPlugin.installIfNeeded();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	}
	
	public List<Evaluation> getPlugins(ObjectNode sent) {
		String[] tmp = sent.getClass().getName().split("\\.");
		String className = tmp[tmp.length - 1];

		Vector<Evaluation> toRet = new Vector<Evaluation>();
		for (int i = 0; i < allPlugins.size(); i++) {
			List<String> supported = allPlugins.get(i).getSupportedClasses();
			for (int j = 0; j < supported.size(); j++) {
				if (className.equalsIgnoreCase(supported.get(j))) {
					toRet.add(allPlugins.get(i).getInstance(sent));
				}
			}
		}
		return toRet;
	}

}
