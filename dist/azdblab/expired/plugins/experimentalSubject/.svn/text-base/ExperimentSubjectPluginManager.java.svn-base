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
package azdblab.expired.plugins.experimentalSubject;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;
import java.util.Map;

import azdblab.*;
import azdblab.executable.Main;
import azdblab.plugins.PluginData;
import azdblab.plugins.experimentSubject.ExperimentSubject;

public class ExperimentSubjectPluginManager {
	private Map<String, ExperimentSubject> mapExperimentSubject;
	private Vector<ExperimentSubject> loadedSubjects;

	private String strUserName;
	private String strPassword;
	private String strMachineName;
	private String strDbmsName;

	public ExperimentSubject getExperimentSubject(String userName,
			String password, String machineName, String dbms_name) {
		strUserName = userName;
		strPassword = password;
		strMachineName = machineName;
		strDbmsName = dbms_name;
		mapExperimentSubject = new HashMap<String, ExperimentSubject>();
		loadPlugins();
		return getPlugins().get(0);
	}

	private void declarePlugin(String strStyleName,
			ExperimentSubject expSubPlugin) {
		mapExperimentSubject.put(strStyleName, expSubPlugin);
	}

	public List<ExperimentSubject> getPlugins() {
		return loadedSubjects;
	}

	@SuppressWarnings("unchecked")
	public void loadPlugins() {

		Vector<PluginData> myPlugins = Main.masterManager
				.getPluginsWithSuperclass(ExperimentSubject.class);
		VersionTag current_ver_tag = new VersionTag(Constants
				.getCurrentVersion(), "");
		loadedSubjects = new Vector<ExperimentSubject>();
		Vector<String> vecSubjectName = new Vector<String>();
		try {
			for (int i = 0; i < myPlugins.size(); i++) {
				String version_tag = myPlugins.get(i).pluginFileName.substring(
						myPlugins.get(i).pluginFileName.indexOf("_") + 1,
						myPlugins.get(i).pluginFileName.indexOf("."));
				Method method = null;
				try {
					Class[] params = new Class[0];
					method = myPlugins.get(i).pluginClass.getDeclaredMethod(
							"getExperimentSubjectName", params);
				} catch (NoSuchMethodException nsmexp) {
					nsmexp.printStackTrace();
				}
				Object[] paramobj = new Object[0];
				String subjectName = method.invoke(null, paramobj).toString()
						+ "@" + version_tag;
				vecSubjectName.add(subjectName);
				Class partypes[] = new Class[3];
				partypes[0] = String.class;
				partypes[1] = String.class;
				partypes[2] = String.class;
				Constructor constructor = myPlugins.get(i).pluginClass
						.getConstructor(partypes);
				Object arglist[] = new Object[3];
				arglist[0] = strUserName;
				arglist[1] = strPassword;
				arglist[2] = strMachineName;
				declarePlugin(subjectName, (ExperimentSubject) constructor
						.newInstance(arglist));
			}

			ExperimentSubject expsubject = null;
			Vector<VersionedPlugin> versioned_plugins = new Vector<VersionedPlugin>();
			for (int i = 0; i < vecSubjectName.size(); i++) {
				String subject_name = vecSubjectName.get(i);
				ExperimentSubject subject = mapExperimentSubject
						.get(subject_name);
				if (strDbmsName.contains(subject.getDBMSName())) {
					String[] subject_name_detail = subject_name.split("@");
					VersionedPlugin new_vp = new VersionedPlugin(
							new VersionTag(subject_name_detail[1],
									subject_name_detail[0]), subject);
					versioned_plugins.add(new_vp);
					// expsubject = subject;
					// break;
				}
			}

			Collections.sort(versioned_plugins,
					(new VersionedPlugin()).new VersionedPluginComparor());
			for (int i = 0; i < versioned_plugins.size(); ++i) {
				VersionedPlugin tmp_plugin = versioned_plugins.get(i);
				if (VersionTag.CompareVersions(tmp_plugin.version_tag_,
						current_ver_tag) <= 0) {
					expsubject = (ExperimentSubject) tmp_plugin.class_object_;
					break;
				}
			}

			if (expsubject == null) {
				Main._logger.reportError("No matched plugin found!");
				System.exit(0);
			}
			loadedSubjects.add(expsubject);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/*
	 * Old loadPlugins content
	 * 
	 * 
	 * try { String strDirPlugin = Constants.DIRECTORY_PLUGINS.replace("/",
	 * "."); File[] plugins = (new File(Constants.DIRECTORY_PLUGINS))
	 * .listFiles(); mapExperimentSubject = new HashMap<String,
	 * ExperimentSubject>(); Vector<String> vecSubjectName = new
	 * Vector<String>(); for (int i = 0; i < plugins.length; i++) { String
	 * plugin_file_name = plugins[i].getName(); if
	 * (plugin_file_name.contains(".jar")) { String[] name_detail =
	 * plugin_file_name.replace(".jar", "") .split("_"); if (name_detail.length
	 * != 7) { Main._logger.reportError(plugin_file_name +
	 * " is not a valid plugin file."); continue; } String plugin_class_name =
	 * plugin_file_name.substring(0, plugin_file_name.indexOf("_")); String
	 * version_tag = plugin_file_name.substring( plugin_file_name.indexOf("_") +
	 * 1, plugin_file_name .indexOf(".")); ClassLoader classLoader = new
	 * URLClassLoader( new URL[] { new URL("file:" +
	 * plugins[i].getAbsolutePath()) }); Class expClass =
	 * classLoader.loadClass(strDirPlugin + plugin_class_name); if
	 * (!(expClass.getSuperclass() .equals(ExperimentSubject.class))) { if
	 * (!(expClass.getSuperclass().getSuperclass()
	 * .equals(ExperimentSubject.class))) { continue; } } Method method = null;
	 * try { Class[] params = new Class[0]; method = expClass.getDeclaredMethod(
	 * "getExperimentSubjectName", params); } catch (NoSuchMethodException
	 * nsmexp) { nsmexp.printStackTrace(); } Object[] paramobj = new Object[0];
	 * String subjectName = method.invoke(null, paramobj) .toString() + "@" +
	 * version_tag; vecSubjectName.add(subjectName); Class partypes[] = new
	 * Class[3]; partypes[0] = String.class; partypes[1] = String.class;
	 * partypes[2] = String.class; Constructor constructor =
	 * expClass.getConstructor(partypes); Object arglist[] = new Object[3];
	 * arglist[0] = strUserName; arglist[1] = strPassword; arglist[2] =
	 * strMachineName; declarePlugin(subjectName, (ExperimentSubject)
	 * constructor .newInstance(arglist)); } } ExperimentSubject expsubject =
	 * null; Vector<VersionedPlugin> versioned_plugins = new
	 * Vector<VersionedPlugin>(); for (int i = 0; i < vecSubjectName.size();
	 * i++) { String subject_name = vecSubjectName.get(i); ExperimentSubject
	 * subject = mapExperimentSubject .get(subject_name); if
	 * (strDbmsName.contains(subject.getDBMSName())) { String[]
	 * subject_name_detail = subject_name.split("@"); VersionedPlugin new_vp =
	 * new VersionedPlugin( new VersionTag(subject_name_detail[1],
	 * subject_name_detail[0]), subject); versioned_plugins.add(new_vp); //
	 * expsubject = subject; // break; } }
	 * 
	 * Collections.sort(versioned_plugins, (new VersionedPlugin()).new
	 * VersionedPluginComparor()); for (int i = 0; i < versioned_plugins.size();
	 * ++i) { VersionedPlugin tmp_plugin = versioned_plugins.get(i); if
	 * (VersionTag.CompareVersions(tmp_plugin.version_tag_, current_ver_tag) <=
	 * 0) { expsubject = (ExperimentSubject) tmp_plugin.class_object_; break; }
	 * }
	 * 
	 * if (expsubject == null) {
	 * Main._logger.reportError("No matched plugin found!"); System.exit(0); }
	 * loadedSubjects = new Vector<ExperimentSubject>();
	 * loadedSubjects.add(expsubject); } catch (ClassNotFoundException cnfexp) {
	 * cnfexp.printStackTrace(); } catch (IllegalAccessException iaexp) {
	 * iaexp.printStackTrace(); } catch (InstantiationException instexp) {
	 * instexp.printStackTrace(); } catch (NoSuchMethodException nsmexp) {
	 * nsmexp.printStackTrace(); } catch (InvocationTargetException itexp) {
	 * itexp.printStackTrace(); } catch (MalformedURLException muexp) {
	 * muexp.printStackTrace(); }
	 */
}
