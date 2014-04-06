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

public class VersionTag {
  public String prefix_;
  public int mm;
  public int dd;
  public int yyyy;
  public int hh;
  public int MM;
  public int ss;
  
  public VersionTag(String ver_tag, String prefix) {
    prefix_ = prefix;
    String[] ver_tag_info = ver_tag.split("_");
    if (ver_tag_info.length != 6) {
      System.err.println("Warning: verion tag not prperly formatted.");
    }
    mm = Integer.parseInt(ver_tag_info[0]);
    dd = Integer.parseInt(ver_tag_info[1]);
    yyyy = Integer.parseInt(ver_tag_info[2]);
    hh = Integer.parseInt(ver_tag_info[3]);
    MM = Integer.parseInt(ver_tag_info[4]);
    ss = Integer.parseInt(ver_tag_info[5]);
  }
  
  
  public String toString() {
    return String.format("%02d_%02d_%04d_%02d_%02d_%02d",
                         mm, dd, yyyy, hh, MM, ss);
  }
  
  
  public static int CompareVersions(
      VersionTag version1, VersionTag version2) {
    if (version1.yyyy < version2.yyyy) {
      return -1;
    } else if (version1.yyyy > version2.yyyy) {
      return 1;
    } else {
      if (version1.mm < version2.mm) {
        return -2;
      } else if (version1.mm > version2.mm) {
        return 2;
      } else {
        if (version1.dd < version2.dd) {
          return -3;
        } else if (version1.dd > version2.dd) {
          return 3;
        } else {
          if (version1.hh < version2.hh) {
            return -3;
          } else if (version1.hh > version2.hh) {
            return 3;
          } else {
            if (version1.MM < version2.MM) {
              return -4;
            } else if (version1.MM > version2.MM) {
              return 4;
            } else {
              if (version1.ss < version2.ss) {
                return -5;
              } else if (version1.ss > version2.ss) {
                return 5;
              } else {
                return 0;
              }
            }
          }
        }
      }
    }
  }
}

class VersionTagComparor implements Comparator<VersionTag> {
  public int compare(VersionTag v1, VersionTag v2) {
    return -VersionTag.CompareVersions(v1, v2);
  }
}
