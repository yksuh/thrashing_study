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
package azdblab.plugins;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Date;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;

public class MasterPluginManager {

	private Vector<PluginData> myPlugins;

	public MasterPluginManager() {
		myPlugins = new Vector<PluginData>();
		initializePlugins();
	}

	@SuppressWarnings("unchecked")
	public Vector<PluginData> getPluginsWithSuperclass(Class mySuperClass) {
		Vector<PluginData> toRet = new Vector<PluginData>();
		for (int i = 0; i < myPlugins.size(); i++) {
			try {
				if (mySuperClass.isAssignableFrom(myPlugins.get(i).pluginClass)) {
					toRet.add(myPlugins.get(i));
				}
			} catch (Exception e) {
				continue;
			}
		}
		return toRet;
	}

	private void initializePlugins() {

		try {

			String strDirPlugin = Constants.DIRECTORY_PLUGINS.replace("/", ".");

			File[] plugins = (new File(Constants.DIRECTORY_PLUGINS))
					.listFiles();

			for (int i = 0; i < plugins.length; i++) {
				String plugin_file_name = plugins[i].getName();
				if (plugin_file_name.contains(".jar")) {
					String[] name_detail = plugin_file_name.replace(".jar", "")
							.split("_");
					if (name_detail.length != 7) {
						Main._logger.reportError(plugin_file_name
								+ " is not a valid plugin file.");
						continue;
					}
					String plugin_class_name = plugin_file_name.substring(0,
							plugin_file_name.indexOf("_"));

					ClassLoader classLoader = new URLClassLoader(
							new URL[] { new URL("file:"
									+ plugins[i].getAbsolutePath()) });
					Class<Plugin> myClass = (Class<Plugin>)classLoader.loadClass(strDirPlugin + plugin_class_name);

					Method aMethod = myClass.getMethod("getVersion", null);
					String plugin_version = (String) aMethod.invoke(myClass, new Object[0]);

					Date updateDate = new Date(plugins[i].lastModified());

					myPlugins.add(new PluginData(myClass, updateDate,
							plugins[i].getName(), plugin_version));

				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
