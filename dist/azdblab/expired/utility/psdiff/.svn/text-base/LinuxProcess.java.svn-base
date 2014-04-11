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
package azdblab.expired.utility.psdiff;

public class LinuxProcess {
  public LinuxProcess(int pid, String owner,
                      String command, String time) {
    pid_ = pid;
    owner_ = owner;
    command_ = command;
    time_ = time;
  }
  
  
  public int get_pid() {
    return pid_;
  }
  
  
  public String get_owner() {
    return owner_;
  }
  
  
  public String get_time() {
    return time_;
  }
  
  
  public String get_command() {
    return command_;
  }
    
  public String toString(){
	  return owner_+";"+pid_+";"+time_+";"+command_+";";
  }
  
  private int pid_;
  private String owner_;
  private String command_;
  private String time_;
}
