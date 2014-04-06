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
package azdblab.utility.psdiff;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;
import java.util.StringTokenizer;

import azdblab.Constants;
import azdblab.executable.Main;

public class ProcessTeller {
  public ProcessTeller() {
  
  }
  
  
  public long GetNumProcesses() {
    File proc_stat_file = new File(SYSTEM_PROC_DIR_ + "/stat");
    try {
      FileReader file_reader = new FileReader(proc_stat_file);
      BufferedReader buf_reader = new BufferedReader(file_reader);
      String input_line = null;
      StringTokenizer string_tokenizer;
      while ((input_line = buf_reader.readLine()) != null) {
        input_line = input_line.trim();
        if (input_line.startsWith("proce")) {
          string_tokenizer = new StringTokenizer(input_line, " ");
          // iterate to the 2nd token, which is the num of processes.          
          string_tokenizer.nextToken();
          num_processes_ = Long.parseLong(string_tokenizer.nextToken());
          break;
        }
      }
      file_reader.close();
      buf_reader.close();
      return num_processes_;
    } catch (IOException ioex) {
      return -1;
    }
  }
  
	/****
	 * Young's revision using perl script parsing the output of 'ps aux'
	 * 
	 * @return
	 * @throws Exception 
	 */
	public HashMap<Integer, LinuxProcess> GetProcesses() throws Exception {
		HashMap<Integer, LinuxProcess> process_map = new HashMap<Integer, LinuxProcess>();
		String command = "perl " + Constants.DIRECTORY_SCRIPTS+"/proc_diff.pl";
		try {
			Process p = Runtime.getRuntime().exec(command);
			if(p.waitFor() != 0){
				// do something
			}
			BufferedReader buf_reader = new BufferedReader(
					new InputStreamReader(p.getInputStream()));
			String input_string = null;
			buf_reader.readLine();
			StringTokenizer st = null;
			while ((input_string = buf_reader.readLine()) != null) {
				input_string = input_string.trim();
				st = new StringTokenizer(input_string, ";");
				if(st.countTokens() < 4 || st.countTokens() > 4){
					if(st.countTokens() < 4){
						Main._logger.reportError("Parsed elements on '"+input_string+"' are insufficient!");
					}else{
						Main._logger.reportError("Parsed elements on '"+input_string+"' are too many!");
					}
					continue;
				}
				String owner = "";
				String id = "";
				String time = "";
				String exec = "";
				while (st.hasMoreTokens()) {
					owner =  st.nextToken();
					id =  st.nextToken();
					time = st.nextToken();
					String exec_name = st.nextToken();
					if(exec.length() > 4000)
						exec = exec_name.substring(0,4000);
//yksuh;23917;0:07;/usr/lib/jvm/java-6-sun-1.6.0.26/bin/java-Xms1024M-Xmx4096M-Dfile.encoding=UTF-8-classpath/cs/projects/tau/working/yksuh/project/AZDBLAB/src:/cs/projects/tau/working/yksuh/project/libs/xercesImpl.jar:/cs/projects/tau/working/yksuh/project/libs/jaxp.jar:/cs/projects/tau/working/yksuh/project/libs/crimson.jar:/cs/projects/tau/working/yksuh/project/libs/xml-apis.jar:/cs/projects/tau/working/yksuh/project/libs/serializer.jar:/cs/projects/tau/working/yksuh/project/libs/xalan.jar:/cs/projects/tau/working/yksuh/project/libs/ant.jar:/cs/projects/tau/working/yksuh/project/libs/db2jcc.jar:/cs/projects/tau/working/yksuh/project/libs/db2jcc_license_cu.jar:/cs/projects/tau/working/yksuh/project/libs/jakarta-ant-1.4.1-optional.jar:/cs/projects/tau/working/yksuh/project/libs/jaxen-1.1-beta-10.jar:/cs/projects/tau/working/yksuh/project/libs/junit.jar:/cs/projects/tau/working/yksuh/project/libs/libsvm.jar:/cs/projects/tau/working/yksuh/project/libs/mysql-connector-java-5.0.3-bin.jar:/cs/projects/tau/working/yksuh/project/libs/postgresql-8.2-504.jdbc4.jar:/cs/projects/tau/working/yksuh/project/libs/salvo.jar:/cs/projects/tau/working/yksuh/project/libs/sqljdbc4.jar:/cs/projects/tau/working/yksuh/project/libs/xmlParserAPIs.jar:/cs/projects/tau/working/yksuh/project/libs/ojdbc14.jar:/usr/local/eclipse-jee-indigo-linux-gtk-x86_64/eclipse/plugins/org.junit_4.8.2.v4_8_2_v20110321-1705/junit.jar:/usr/local/eclipse-jee-indigo-linux-gtk-x86_64/eclipse/plugins/org.hamcrest.core_1.1.0.v20090501071000.jar:/cs/projects/tau/working/yksuh/project/libs/commons-dbcp-1.4.jar:/cs/projects/tau/working/yksuh/project/libs/commons-pool-1.5.5.jar:/cs/projects/tau/working/yksuh/project/libs/log4j-1.2.16.jar:/cs/projects/tau/azdblab/bin/matt_executable/libs/JavaPlot.jar:/cs/projects/tau/azdblab/bin/matt_executable/libs/xerces.jarazdblab.executable.Main-verbose-executorexperimentsubject_oracle.xmloracle$1
				}
				LinuxProcess linux_process = new LinuxProcess(
						Integer.parseInt(id),
						owner, exec,
						time);
				process_map.put(new Integer(id), linux_process);
				continue;
			}
			buf_reader.close();
			p.destroy();	// added by yksuh so that the perl program can exit.
			return process_map;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception("Cannot run the ps diff script"); 
		}
	}

	public static String ProcessMapDiff(long num_processes1,
			long num_processes2, Map<Integer, LinuxProcess> proc_map1,
			Map<Integer, LinuxProcess> proc_map2) {
		StringBuffer result_buf = new StringBuffer();
		if (num_processes1 != num_processes2) {
			result_buf.append("phantom [#1: " + num_processes1 + ", #2: "
					+ num_processes2 + "]");
		}
		Iterator<Integer> iter1 = proc_map1.keySet().iterator();
		Vector<String> diff_proc_name = new Vector<String>();
		Vector<String> diff_proc_time = new Vector<String>();
		Vector<String> diff_started_name = new Vector<String>();
		Vector<String> diff_stopped_name = new Vector<String>();
		while (iter1.hasNext()) {
			Integer proc_key1 = iter1.next();
			LinuxProcess proc1 = proc_map1.get(proc_key1);
			if (proc_map2.containsKey(proc_key1)) {
				LinuxProcess proc2 = proc_map2.get(proc_key1);
				if (!proc2.get_time().equals(proc1.get_time())) {
					diff_proc_time.add(proc2.get_command() + "<"
							+ proc2.get_time() + "> vs. " + proc1.get_command()
							+ "<" + proc1.get_time() + ">");
				}
			} else {
				diff_started_name.add(proc_map1.get(proc_key1) + " stopped");
			}
		}
		Iterator<Integer> iter2 = proc_map2.keySet().iterator();
		while (iter2.hasNext()) {
			Integer proc_key2 = iter2.next();
			if (!proc_map1.containsKey(proc_key2)) {
				diff_proc_name.add(proc_map2.get(proc_key2) + " started");
			}
		}
		
		//append new psdiff info to string
		if (diff_proc_name.size() > 0) {
			result_buf.append("proc diff: ");
			for (int i = 0; i < diff_proc_name.size(); ++i) {
				result_buf.append("[" + i + "]" + diff_proc_name.get(i) + "; ");
			}
		}
		if (diff_proc_time.size() > 0) {
			result_buf.append("\nproc time diff: ");
			for (int i = 0; i < diff_proc_time.size(); ++i) {
				result_buf.append("[" + i + "]" + diff_proc_time.get(i) + "; ");
			}
		}
		if (diff_started_name.size() > 0) {
			result_buf.append("\nStarted procs: ");
			for (int i = 0; i < diff_started_name.size(); ++i) {
				result_buf.append("[" + i + "]" + diff_started_name.get(i) + "; ");
			}
		}
		if (diff_stopped_name.size() > 0) {
			result_buf.append("\nStopped procs: ");
			for (int i = 0; i < diff_stopped_name.size(); ++i) {
				result_buf.append("[" + i + "]" + diff_stopped_name.get(i) + "; ");
			}
		}
		return result_buf.toString();
	}
  
  public static String SYSTEM_PROC_DIR_ = "/proc";
  private long num_processes_ = -1;
}
