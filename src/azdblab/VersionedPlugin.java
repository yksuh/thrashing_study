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
package azdblab;

import java.util.Comparator;

public class VersionedPlugin {
  public VersionTag version_tag_;
  public Object class_object_;
  
  public VersionedPlugin() {
	  
  }
  
  
  public VersionedPlugin(VersionTag version_tag, Object class_object) {
    version_tag_ = version_tag;
    class_object_ = class_object;
  }
  
  
  public class VersionedPluginComparor implements Comparator<VersionedPlugin> {
	  public int compare(VersionedPlugin vp1, VersionedPlugin vp2) {
	    return -VersionTag.CompareVersions(vp1.version_tag_, vp2.version_tag_);
	  }  
	}
}


