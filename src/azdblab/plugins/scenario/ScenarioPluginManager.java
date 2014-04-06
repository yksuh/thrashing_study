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
package azdblab.plugins.scenario;

import java.lang.reflect.Constructor;
import java.lang.reflect.Modifier;
import java.util.Collections;
import java.util.List;
import java.util.Vector;
import azdblab.Constants;
import azdblab.VersionTag;
import azdblab.VersionedPlugin;
import azdblab.executable.Main;
import azdblab.model.experiment.ExperimentRun;
import azdblab.plugins.PluginData;

public class ScenarioPluginManager {
	private String strScenarioName;
	private ExperimentRun myExpRun;
	Vector<Scenario> vecScenarios;

	public Scenario getScenarioInstance(String scenName, ExperimentRun expRun) {
		strScenarioName = scenName;
		myExpRun = expRun;
		loadPlugins();
		return getPlugins().get(0);
	}
	
	public List<Scenario> getPlugins() {
		return vecScenarios;
	}

	@SuppressWarnings("unchecked")
	public void loadPlugins() {
		vecScenarios = new Vector<Scenario>();
		Vector<VersionedPlugin> versioned_plugins = new Vector<VersionedPlugin>();
		Vector<PluginData> myPlugins = Main.masterManager.getPluginsWithSuperclass(azdblab.plugins.scenario.Scenario.class);
		try{
			for(int i = 0; i < myPlugins.size(); i++){
				String version_tag = myPlugins.get(i).pluginFileName.substring(
						myPlugins.get(i).pluginFileName.indexOf("_") + 1, myPlugins.get(i).pluginFileName
								.indexOf("."));
				if (Modifier.isAbstract(myPlugins.get(i).pluginClass.getModifiers())) {
					continue;
				}

				String scenarioName = myPlugins.get(i).pluginClass.getSimpleName()
						.replaceAll("Scenario", "");
				if (scenarioName.toLowerCase().equals(
						strScenarioName.toLowerCase())) {
					Class partypes[] = new Class[1];
					partypes[0] = ExperimentRun.class;
					Constructor constructor = myPlugins.get(i).pluginClass
							.getConstructor(partypes);
					Object arglist[] = new Object[1];
					arglist[0] = myExpRun;
					VersionedPlugin tmp_vp = new VersionedPlugin(
							new VersionTag(version_tag, scenarioName
									.toLowerCase()),
							(Object) (Scenario) constructor
									.newInstance(arglist));
					Main._logger.outputLog("adding scenario plugin - "
							+ scenarioName.toLowerCase());
					versioned_plugins.add(tmp_vp);
					vecScenarios.add((Scenario) tmp_vp.class_object_);
					return;
				}
			}
			VersionTag current_ver_tag = new VersionTag(Constants
					.getCurrentVersion(), "");
			Scenario scenInstance = null;
			Collections.sort(versioned_plugins,
					(new VersionedPlugin()).new VersionedPluginComparor());
			for (int i = 0; i < versioned_plugins.size(); i++) {
				VersionedPlugin tmp_plugin = versioned_plugins.get(i);
				if (VersionTag.CompareVersions(tmp_plugin.version_tag_,
						current_ver_tag) <= 0) {
					scenInstance = (Scenario) tmp_plugin.class_object_;
					break;
				}
			}
			if (scenInstance == null) {
				Main._logger.reportError("No matched scenario plugin found!");
				System.exit(0);
			}
			Main._logger.outputLog(strScenarioName + " IS SELECTED");
			vecScenarios = new Vector<Scenario>();
			vecScenarios.add(scenInstance);
			return;
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
}
