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

import java.util.Date;

public class PluginData {

	public Date lastUpdated;
	public Class<?> pluginClass;
	public String pluginFileName;
	public String pluginVersion;

	public PluginData(Class<?> myClass, Date lastUpdated,
			String pluginFileName, String version) {
		this.lastUpdated = lastUpdated;
		this.pluginClass = myClass;
		this.pluginFileName = pluginFileName;
		this.pluginVersion = version;
	}

	@Override
	public String toString() {
		return pluginClass.getName();
	}

}