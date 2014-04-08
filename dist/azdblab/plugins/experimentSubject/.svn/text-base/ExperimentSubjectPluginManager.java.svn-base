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
package azdblab.plugins.experimentSubject;

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
	private String connectString;
	private String strDbmsName;

	public ExperimentSubject getExperimentSubject(String userName,
			String password, String machineName, String connectString, String dbms_name) {
		strUserName = userName;
		strPassword = password;
		strMachineName = machineName;
		strDbmsName = dbms_name;
		this.connectString = connectString;
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

	@SuppressWarnings("rawtypes")
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
				System.out.println(myPlugins.get(i).pluginFileName);
//				Method method = null;
//				try {
//					Class[] params = new Class[0];
//					method = myPlugins.get(i).pluginClass.getDeclaredMethod(
//							"getExperimentSubjectName", params);
//				} catch (NoSuchMethodException nsmexp) {
//					nsmexp.printStackTrace();
//				}
//				Object[] paramobj = new Object[0];
//				String subjectName = method.invoke(null, paramobj).toString()
//						+ "@" + version_tag;
				Class partypes[] = new Class[4];
				partypes[0] = String.class;
				partypes[1] = String.class;
				partypes[2] = String.class;
				partypes[3] = String.class;
				Method aMethod = myPlugins.get(i).pluginClass.getMethod(
						"getDBMSName", (Class<?>[])null);
				String dbms_Name = (String) aMethod.invoke(myPlugins.get(i).pluginClass.getConstructor(partypes).newInstance(new Object[4]), new Object[0]);
				String subjectName = dbms_Name + "Subject" + "@" + version_tag;
				vecSubjectName.add(subjectName);
				Constructor constructor = myPlugins.get(i).pluginClass
						.getConstructor(partypes);
				Object arglist[] = new Object[4];
				arglist[0] = strUserName;
				arglist[1] = strPassword;
				arglist[2] = connectString;
				arglist[3] = strMachineName;
				declarePlugin(subjectName, (ExperimentSubject) constructor
						.newInstance(arglist));
				System.out.println(strDbmsName + ":" + subjectName + "/");// + subject.getDBMSName());
				
			}
			//
			ExperimentSubject expsubject = null;
			Vector<VersionedPlugin> versioned_plugins = new Vector<VersionedPlugin>();
			for (int i = 0; i < vecSubjectName.size(); i++) {
				String subject_name = vecSubjectName.get(i);
				ExperimentSubject subject = mapExperimentSubject
						.get(subject_name);
				if ((strDbmsName.toLowerCase()).contains((subject.getDBMSName()).toLowerCase())) {
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
}
