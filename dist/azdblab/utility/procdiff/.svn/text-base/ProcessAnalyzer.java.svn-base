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
package azdblab.utility.procdiff;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.Vector;

import azdblab.Constants;

public abstract class ProcessAnalyzer {
	/***
	 * Process_Output directory
	 */
	public final static String DIRECTORY_PROC_OUTPUT = Constants.DIRECTORY_SCRIPTS+"processOutput/";
	/***
	 * Process output file suffix
	 */
	public final static String suffixName = "ProcessMap";
	/***
	 * Get procs 
	 */
	public final static int ORDERINSENSITIVE = 0;
	/***
	 * Get procs before query execution
	 */
	public final static int PRE_QE = 1;
	/***
	 * Get procs after query execution
	 */
	public final static int POST_QE = 2;
	/***
	 * PLATFORM
	 */
	protected final static int PLATFORM = 0;
	/***
	 * LINUX
	 */
	protected final static int LINUX = 0;
	/***
	 * WINDOWS
	 */
	protected final static int WINDOWS = 1;
	/****
	 * Frequently running processes
	 */
	protected static HashMap<Long, String> freqRunningCurrentProcMap;
	/***
	 * The most frequently running processes 
	 */
	private final static int topK = 10;
	/***
	 * The number of started processes for real phantom presence check
	 */
	private static int numStartedProcs = 0;
	/****
	 * Print current running process map
	 * @param paramMap current running process map
	 */
	protected static void printCurrRunningProcMap(HashMap<Long, ProcessInfo> paramMap) {
		Map<Long, ProcessInfo> map = new TreeMap<Long, ProcessInfo>(paramMap);
		// get all entries from map
		// Move next key and value of HashMap by iterator
		Iterator<?> it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<?, ?> m = (Map.Entry<?, ?>) it.next();
			ProcessInfo pi = (ProcessInfo) m.getValue();
			System.out.println((Long)m.getKey() + " => " + pi.get_command());
		}
	}
	/****
	 * Print frequently-running process map
	 * @param paramMap frequently-running process map
	 */
	protected static void printFreqRunningProcMap(HashMap<Long, String> paramMap) {
		Map<Long, String> map = new TreeMap<Long, String>(paramMap);
		// get all entries from map
		// Move next key and value of HashMap by iterator
		Iterator<?> it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<?, ?> m = (Map.Entry<?, ?>) it.next();
			Long pid = (Long) m.getKey();
			String key = (String) m.getValue();
			System.out.println(pid.longValue() + " => " + key);
		}
	}
	/****
	 * Construct frequently running current process map using current running process map
	 * @param dbmsName : current DBMS subject name
	 */
	public static void buildFrequentlyRunningCurrentProcesses(String dbmsName, 
															  HashMap<Long, ProcessInfo> procMap){
		// initialize 
		freqRunningCurrentProcMap = new HashMap<Long, String>();
		// frequently-running processes file
		String fileName = DIRECTORY_PROC_OUTPUT+dbmsName.toLowerCase()+suffixName;
		// open the file
		final File runningProcessListFile = new File(fileName);
		try {
			BufferedReader buf_reader = new BufferedReader(new FileReader(runningProcessListFile));
			String line = null;
			StringTokenizer st;
			int procCnt = 0;
			while ((line = buf_reader.readLine()) != null) {
				if(procCnt >= topK){
					break;
				}
				line = line.trim();
				st = new StringTokenizer(line, ":");
				String command = st.nextToken();
				Vector<Long> pidVec = locatePIDs(procMap, command);
				if(pidVec.size() == 0){
					continue;
				}
				//create a process entry from name to pid
				for(int i=0;i<pidVec.size();i++){
					long pid = (pidVec.get(i)).longValue();
					freqRunningCurrentProcMap.put(pid, command);
				}
				procCnt++;
//				System.out.println("procCnt: " + procCnt + ", command: " + command);
			}
			buf_reader.close();
		} catch (IOException e1) {}
//		System.out.println("******** < Current Running Processes > *************************");
//		printCurrRunningProcMap(procMap);
//		System.out.println("*********< Frequently-Running Current Processes > **************");
//		printFreqRunningProcMap(freqRunningCurrentProcMap);
//		System.out.println("****************************************************************");
	}
	/****
	 * Locate process ids associated with a frequently-running process
	 * @param paramMap currently running process map
	 * @param procName frequently-running process name
	 * @return process id vector associated with procName
	 */
	private static Vector<Long> locatePIDs(HashMap<Long, ProcessInfo> paramMap, String procName) {
		Vector<Long> resVec = new Vector<Long>();
		// get all entries from map
		// Move next key and value of HashMap by iterator
		Iterator<?> it = paramMap.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<?, ?> m = (Map.Entry<?, ?>)it.next();
			ProcessInfo pi = (ProcessInfo) m.getValue();
			if(pi.get_command().equalsIgnoreCase(procName)){
				resVec.add((Long) m.getKey());
			}
		}
		return resVec;
	}
	/****
	 * Build a string of process list
	 * @param procList
	 * @return
	 */
	protected static String buildProcListStr(Vector<String> procList){
		String res = "";
		for(int i=0;i<procList.size();i++){
			res += procList.get(i);
			if(i < procList.size()-1){
				res += ";\n";
			}
		}
//		res += "]";
		return res;
	}
	/***
	 * Return processes that appeared before 
	 * @param beforeProcMap
	 * @param afterProcMap
	 * @return
	 */
	protected static String stoppedProcList(int platform,
											HashMap<Long, ProcessInfo> beforeProcMap,
										    HashMap<Long, ProcessInfo> afterProcMap){
		Vector<String> procList = new Vector<String>(); 
		Iterator<Long> beforeProcIter = beforeProcMap.keySet().iterator();
		while (beforeProcIter.hasNext()) {
			Long beforeProcKey = beforeProcIter.next();
			if (!afterProcMap.containsKey(beforeProcKey)) {
				String _command = (beforeProcMap.get(beforeProcKey)).get_command();
				if(platform == WINDOWS){
					/****
					 * PsList : windows ps program
					 * conhost: windows program fixing a fundamental problem in the way previous versions 
					 * 			of Windows handled console windows, which broke drag & drop in Vista
					 * 			Refer to http://www.howtogeek.com/howto/4996/what-is-conhost.exe-and-why-is-it-running/.
					 */
					if(!_command.contains("PsList") && !_command.contains("conhost"))
						procList.add(_command);
				}else{
					procList.add(_command);
				}
			}
//			else{
//				if(beforeProcKey.longValue() == 3031  || beforeProcKey.longValue() == 1927){
//					String _command = ((ProcessInfo)(beforeProcMap.get(beforeProcKey))).get_command();
//					procList.add(_command);
//				}
//			}
		}
		if(procList.size() > 0) return buildProcListStr(procList);
		else 					return ""; 
	}
	/***
	 * Return processes that appeared after 
	 * @param beforeProcMap
	 * @param afterProcMap
	 * @return
	 */
	protected static String startedProcList(int platform,
											HashMap<Long, ProcessInfo> beforeProcMap,
			  					            HashMap<Long, ProcessInfo> afterProcMap){
		Vector<String> procList = new Vector<String>(); 
		Iterator<Long> afterProcIter = afterProcMap.keySet().iterator();
		while (afterProcIter.hasNext()) {
			Long afterProcKey = afterProcIter.next();
			if (!beforeProcMap.containsKey(afterProcKey)) {
				String strInfo = (afterProcMap.get(afterProcKey)).getStr();
				if(platform == WINDOWS){
					/****
					 * PsList : windows ps program
					 * conhost: windows program fixing a fundamental problem in the way previous versions 
					 * 			of Windows handled console windows, which broke drag & drop in Vista
					 * 			Refer to http://www.howtogeek.com/howto/4996/what-is-conhost.exe-and-why-is-it-running/.
					 */
					if(!strInfo.contains("PsList") && !strInfo.contains("conhost"))
						procList.add(strInfo);
				}else{
					procList.add(strInfo);
				}
			} 
//			else{
//				if(afterProcKey.longValue() == 15330 || afterProcKey.longValue() == 2624){
//					String strInfo = ((ProcessInfo)(afterProcMap.get(afterProcKey))).getStr();
//					procList.add(strInfo);
//				}
//			}
		}
		if(procList.size() > 0) {
			if(platform == LINUX){
				// set num of started procs for phantom check
				setStartedProcs(procList.size());
			}
			return buildProcListStr(procList);
		}
		else 					return ""; 
	}
	/****
	 * Set the number of started processes
	 * @param size number of started processes
	 */
	private static void setStartedProcs(int size) {
		numStartedProcs = size;
	}
	/***
	 * Return processes that ran in query execution
	 * @param beforeProcMap
	 * @param afterProcMap
	 * @return
	 */
	protected static String diffProcList(int platform,
										 HashMap<Long, ProcessInfo> beforeProcMap,
									     HashMap<Long, ProcessInfo> afterProcMap){
		Vector<String> vecDiffs = new Vector<String>();
		Iterator<Long> beforeProcIter = beforeProcMap.keySet().iterator();
		while (beforeProcIter.hasNext()) {
			Long beforeProcKey = beforeProcIter.next();
			if (afterProcMap.containsKey(beforeProcKey)) {
				// get a process before query execution
				ProcessInfo beforeProc = beforeProcMap.get(beforeProcKey);
				// perform a diff between them
				String diffStr = beforeProc.getDiff(afterProcMap.get(beforeProcKey));
				if(!"".equals(diffStr)){
					// add this to the frequently-running process map
					freqRunningCurrentProcMap.put(beforeProcKey, beforeProc.get_command());
					vecDiffs.add(diffStr);	
				}else{
					// this process was found, but didn't run
					// so it's removed from the frequent list if it exists
					freqRunningCurrentProcMap.remove(beforeProcKey);
				}
			}
		} 
		if(vecDiffs.size() > 0) return buildProcListStr(vecDiffs);
		else 					return "";
	}
	/***
	 * Compute differences between before/after stat info
	 * @param beforeStat stat info before query execution
	 * @param afterStat stat info after query execution
	 * @return tick difference
	 */
	protected static String diffTicks(StatInfo beforeStat,
			 						  StatInfo afterStat){
		Vector<String> vecDiffs = new Vector<String>();
		String diffStr = beforeStat.getDiff(afterStat);
		if(!"".equals(diffStr)){
			vecDiffs.add(diffStr);	
		}
		if(vecDiffs.size() > 0) return buildProcListStr(vecDiffs);
		else 					return "";
	}
	/***
	 * Perform diff between two maps on windows
	 * @param beforeProcMap
	 * @param afterProcMap
	 * @return diff string
	 */
	public static String diffProcMap(int platform,
									 StatInfo beforeStat,
									 StatInfo afterStat){
		String strDiffResults = "";
		if(platform == LINUX){
			String strTicks 	   = diffTicks(beforeStat, afterStat);
			if(!"".equals(strTicks)){
				strDiffResults += "Increased Ticks:\n["+strTicks+"]\n";
			}
			String strPhantomProcs 	= phantomCheck(beforeStat, afterStat);
			if(!"".equals(strPhantomProcs)){
				strDiffResults += "Phantom Processes:\n["+strPhantomProcs+"]\n";
			}
		}
		return strDiffResults;
	}
	
	/***
	 * Perform diff between two maps on windows
	 * @param beforeProcMap
	 * @param afterProcMap
	 * @return diff string
	 */
	public static String myDiffProcMap(int platform,
									 StatInfo beforeStat,
									 StatInfo afterStat)
									// HashMap<Long, ProcessInfo> beforeProcMap,
									// HashMap<Long, ProcessInfo> afterProcMap)
									 {
		String res = ""; 
		String strDiffResults = "";
		//String strDiffs 	   = diffProcList(platform, beforeProcMap, afterProcMap);
		//if(!"".equals(strDiffs)){
		//	strDiffResults += "Number of Runs:\n["+strDiffs+"]\n";
		//}
		//String strStoppedProcs = stoppedProcList(platform, beforeProcMap, afterProcMap);
		//if(!"".equals(strStoppedProcs)){
		//	strDiffResults += "Stopped Processes:\n["+strStoppedProcs+"]\n";
		//}
		//String strStartedProcs = startedProcList(platform, beforeProcMap, afterProcMap);
		//if(!"".equals(strStartedProcs)){
		//	strDiffResults += "Started Processes:\n["+strStartedProcs+"]\n";
		//}
		if(platform == LINUX){
			String strTicks 	   = diffTicks(beforeStat, afterStat);
			if(!"".equals(strTicks)){
				strDiffResults += "Increased Ticks:\n["+strTicks+"]\n";
			}
			String strPhantomProcs 	= phantomCheck(beforeStat, afterStat);
			if(!"".equals(strPhantomProcs)){
				strDiffResults += "Phantom Processes:\n["+strPhantomProcs+"]\n";
			}
		}
		if(!"".equals(strDiffResults)){
			res = strDiffResults;
		}else{
			res = "N/A"; // because "" is disallowed when this query execution is recorded
		}
		return res;
	}

	
	/****
	 * Check number of phantoms
	 * @param beforeStat stat info before query execution
	 * @param afterStat	stat info after query execution (including started processes if present)
	 * @return
	 */
	private static String phantomCheck(StatInfo beforeStat, StatInfo afterStat){
		String str = "";
		// subtract numStartedProcs from after_procs to derive real phantoms
		long actual_procs = afterStat.get_max_pid()-numStartedProcs;
		if (beforeStat.get_max_pid() != actual_procs) {
//System.out.println("before: " + beforeStat.get_max_pid());
//System.out.println("after: " + afterStat.get_max_pid());
//System.out.println("# started procs: " + numStartedProcs);
			str += beforeStat.get_max_pid() + " to " + actual_procs;
		}
		// reset
		numStartedProcs = 0;
		return str;
	}
}