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
import java.util.StringTokenizer;
import java.util.Vector;

import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;

public class LinuxProcessAnalyzer extends ProcessAnalyzer{
	/***
	 * LINUX PLATFORM (LINUX = 0, WINDOWS = 1)
	 */
	public final static int PLATFORM = 0;
	/***
	 * proc dir
	 */
	private final static String _PROC_DIR = "/proc";
	/***
	 * stat dir
	 */
	private final static String _STAT_DIR = "stat";
	/***
	 * pid position
	 */
	private final static int PID_IDX 	= 0;	
	/***
	 * command position
	 */
	private final static int COMMAND_IDX = 1;
	/***
	 * min_flt position
	 */
	private final static int MIN_FLT_IDX = 9;
	/***
	 * maj_flt position
	 */
	private final static int MAJ_FLT_IDX = 11;
	/***
	 * utick position
	 */
	private final static int UTICK_IDX 	= 13;
	/***
	 * stick position
	 */
	private final static int STICK_IDX	= 14;
	/***
	 * Start time position
	 */
	private static final int STARTTIME_IDX = 21;
	/***
	 * The amount of time, measured in units of USER_HZ, that the system spent in user mode
	 * (USER_HZ: 1/100ths of a second on most architectures, use sysconf(_SC_CLK_TCK) 
	 * to obtain the right value)
	 */
	private static final int USER_MODE_IDX = 1;
	/***
	 * The amount of time that the system spent in user mode with low priority (nice)
	 */
	private static final int LOW_PRIORITY_USER_MODE_IDX = 2;
	/***
	 * The amount of time that the system spent in system mode
	 */
	private static final int SYSTEM_MODE_IDX = 3;
	/***
	 * The amount of time that the system spent in idle task
	 */
	private static final int IDLE_TASK_MODE_IDX = 4;
	/***
	 * The amount of time waiting for I/O to complete
	 */
	private static final int IO_WAIT_IDX = 5;
	/***
	 * The amount of time servicing interrupts 
	 */
	private static final int IRQ_IDX = 6;
	/***
	 * The amount of time servicing softirq 
	 */
	private static final int SOFT_IRQ_IDX = 7;
	/***
	 * The amount of time spent in other OSes when running in a virtualized environment
	 */
	private static final int STEAL_STOLEN_IDX = 8;
	/***
	 * The amount of time spent running a virtual CPU for guest 
	 * operating systems under the control of the Linux kernel
	 */
	private static final int GUEST_IDX = 9;
	/****
	 * Build process info from /proc/pid/stat directory
	 * @param pid process id
	 * @return ProcessInfo
	 */
	public static LinuxProcessInfo buildProcInfo(long pid){
		long min_flt = 0, maj_flt = 0, utick=0, stick=0, startTime=-1; 
		String command = "";
		// This file is process dir.
		final File procStatFile = new File(_PROC_DIR+"/"+pid+"/", _STAT_DIR);
        try {
        	BufferedReader buf_reader = new BufferedReader(new FileReader(procStatFile));
        	String line = null;
        	StringTokenizer st;
        	int cnt = 0;
        	while ((line = buf_reader.readLine()) != null) {
        		line = line.trim();
        		st = new StringTokenizer(line, " ");
        		while(st.hasMoreTokens()){
        			String token = st.nextToken();
        			switch(cnt++){
        				case PID_IDX:
        					pid = Long.parseLong(token);
        					continue;
        				case COMMAND_IDX:
        					command = token;
        					command = command.replaceAll("\\(|\\)", "");
        					continue;
        				case MIN_FLT_IDX:
        					min_flt = Long.parseLong(token);
        					continue;
        				case MAJ_FLT_IDX:
        					maj_flt = Long.parseLong(token);
        					continue;
        				case UTICK_IDX:
        					utick = Long.parseLong(token);
        					continue;
        				case STICK_IDX:
        					stick = Long.parseLong(token);
        					continue;
        				case STARTTIME_IDX:
	    					startTime = Long.parseLong(token);
	    					break;
        			}
        		}
        	}
        	buf_reader.close();
	    }catch (IOException e1) {
//	    	Main._logger.reportError(e1.getMessage());
	    	e1.printStackTrace();
//	    	Main._logger.reportError("No directory for '" + pid + "' ");
	    	return null;
	    }
	    return new LinuxProcessInfo(pid, command, min_flt, maj_flt, utick, stick, startTime);
	}
	/****
	 * Extract process info
	 * @return a map of (process id - process) entries
	 */
	public static HashMap<Long, ProcessInfo> extractProcInfo(int order) throws SanityCheckException{
		HashMap<Long, ProcessInfo> resMap = new HashMap<Long, ProcessInfo>();
		Vector<Long> vecFreqRunningProcs   = null;
		Vector<Long> vecInFreqRunningProcs = null;
		if(order != ORDERINSENSITIVE){
			/*****
			 * While iterating stat dir, separate currently-running pids from frequently-running ones
			 */
			vecFreqRunningProcs   = new Vector<Long>();
			vecInFreqRunningProcs = new Vector<Long>();
		}

		final File dir = new File(_PROC_DIR);
	    final String[] filedirArray = dir.list();
	    for(String filedir : filedirArray) {
	    	final File procFile = new File(dir, filedir);
	    	// if this file is directory
	    	if (procFile.isDirectory()) {
	    		long pid = 0;
	    		try {
	    			// get pid from the dir name directly
	    			pid = Long.parseLong(filedir);
	    		}catch (NumberFormatException e) {
	    			continue;
                }   
	    		if(order == ORDERINSENSITIVE){
	    			resMap.put(pid,  buildProcInfo(pid));	
	    		}else{
	    			/****
	    			 *  In the case of pre-QE, build infrequent processes followed by frequent ones. 
	    			 *  In the case of post-QE, build frequent processes followed by infrequent ones.
	    			 */
	    			if(freqRunningCurrentProcMap.get(pid) == null){
	    				// infrequent process
	    				if(order == PRE_QE){
	    					resMap.put(pid,  buildProcInfo(pid));	
	    				}else if(order == POST_QE){
	    					vecInFreqRunningProcs.add(pid);
	    				}
	    			}else{
	    				// frequent process
	    				if(order == PRE_QE){
	    					vecFreqRunningProcs.add(pid);	
	    				}else if(order == POST_QE){
	    					resMap.put(pid,  buildProcInfo(pid));
	    				}
	    			}	    			
	    		}
	    	} // end if proc dir
	    } // end for
	    if(order != ORDERINSENSITIVE){
	    	 /**** 
		     * In case that the function gets invoked before query execution,
		     * now add all frequent-running process info to resMap 
		     */
		    if(order == PRE_QE){
			    // now check frequent process
			    for(int i=0;i<vecFreqRunningProcs.size();i++){
			    	long pid = ((Long)vecFreqRunningProcs.get(i)).longValue();
			    	LinuxProcessInfo pi = buildProcInfo(pid);
			    	if(pi != null) 
			    		resMap.put(pid, pi);	
			    }
		    }else if(order == POST_QE){
			    // now check infrequent processes
			    for(int i=0;i<vecInFreqRunningProcs.size();i++){
			    	long pid = ((Long)vecInFreqRunningProcs.get(i)).longValue();
			    	LinuxProcessInfo pi = buildProcInfo(pid);
			    	if(pi != null) 
			    		resMap.put(pid, pi);	
			    }
		    }
	    }
	    return resMap;
	}
	
	/****
	 * Build cpu stat info other than max pid that will be given later
	 * @param cpuLine cpu line in /proc/stat
	 * @return CPU stat info
	 */
	private static StatInfo buildCPUStatInfo(String cpuLine){
		// get cpu stat
		StringTokenizer st = new StringTokenizer(cpuLine, " ");
		int cnt = 0;
		long userModeTick = 0, lowPriorityUserModeTick = 0, systemModeTick = 0, idleTaskTick = 0;
		long ioWaitTick = 0, irq = 0, softirq = 0, stealStolenTick = 0, guestTick = 0;
		while(st.hasMoreTokens()){
			String token = st.nextToken();
			switch(cnt++){
				case USER_MODE_IDX:
					userModeTick = Long.parseLong(token);
					continue;
				case LOW_PRIORITY_USER_MODE_IDX:
					lowPriorityUserModeTick = Long.parseLong(token);
					continue;
				case SYSTEM_MODE_IDX:
					systemModeTick = Long.parseLong(token);
					continue;
				case IDLE_TASK_MODE_IDX:
					idleTaskTick = Long.parseLong(token);
					continue;
				case IO_WAIT_IDX:
					ioWaitTick = Long.parseLong(token);
					continue;
				case IRQ_IDX:
					irq = Long.parseLong(token);
					continue;
				case SOFT_IRQ_IDX:
					softirq = Long.parseLong(token);
					continue;
				case STEAL_STOLEN_IDX:
					stealStolenTick = Long.parseLong(token);
					continue;
				case GUEST_IDX:
					guestTick = Long.parseLong(token);
					break;
			}
		}
		return new StatInfo(0, 				// this will be set later 
							userModeTick, 
							lowPriorityUserModeTick, 
							systemModeTick, 
							idleTaskTick,
							ioWaitTick, 
							irq, 
							softirq, 
							stealStolenTick, 
							guestTick);
	}
	/****
	 * Get StatInfo having cpu information
	 * @return a StatInfo object
	 */
	public static StatInfo getCPUStatInfo() {
		File proc_stat_file = new File(_PROC_DIR + "/" + _STAT_DIR);
		try {
			BufferedReader buf_reader = new BufferedReader(new FileReader(proc_stat_file));
			String input_line = null;
			String cpu_line = null;
			// first stat info then # procs
			while ((input_line = buf_reader.readLine()) != null) {
				input_line = input_line.trim();
				if (input_line.startsWith("cpu")) {
					cpu_line  = input_line;
					break;
				}
			}
			buf_reader.close();
			// return StatInfo object 
			return buildCPUStatInfo(cpu_line);
		} catch (IOException ioex) {
			System.out.println(ioex.getMessage());
			return null;
		}
	}
	/****
	 * Get max pid
	 * @return max pid
	 */
	public static long getMaxPID() {
		File proc_stat_file = new File(_PROC_DIR + "/" + _STAT_DIR);
		try {
			long maxPID = 0;
			BufferedReader buf_reader = new BufferedReader(new FileReader(proc_stat_file));
			String input_line = null;
			while ((input_line = buf_reader.readLine()) != null) {
				input_line = input_line.trim();
				if (input_line.startsWith("proce")) {
					// get max pid
					StringTokenizer st = new StringTokenizer(input_line, " ");
					// iterate to the 2nd token, which is the num of processes.
					st.nextToken();
					maxPID = Long.parseLong(st.nextToken());
					break;
				}
			}
			buf_reader.close();
			return maxPID;
		} catch (IOException ioex) {
			System.out.println(ioex.getMessage());
			return -1;
		}
	}
	/****
	 * Get StatInfo 
	 * @return a StatInfo object
	 */
	public static StatInfo getStatInfo() {
		File proc_stat_file = new File(_PROC_DIR + "/" + _STAT_DIR);
		try {
			BufferedReader buf_reader = new BufferedReader(new FileReader(proc_stat_file));
			String input_line = null;
			String cpu_line = null;
			String max_pid_line = null;
			// first stat info then # procs
			while ((input_line = buf_reader.readLine()) != null) {
				input_line = input_line.trim();
				if (input_line.startsWith("cpu")) {
					cpu_line  = input_line;
					continue;
				}
				if (input_line.startsWith("proce")) {
					max_pid_line  = input_line;
					break;
				}
			}
			buf_reader.close();
			// return StatInfo object 
			return buildStatInfo(max_pid_line, cpu_line);
		} catch (IOException ioex) {
			System.out.println(ioex.getMessage());
			return null;
		}
	}
	/****
	 * Build stat info
	 * @param maxPIDLine max pid line in /proc/stat
	 * @param cpuLine cpu line in /proc/stat
	 * @return stat info
	 */
	private static StatInfo buildStatInfo(String maxPIDLine, String cpuLine){
		// get max pid
		StringTokenizer st = new StringTokenizer(maxPIDLine, " ");
		// iterate to the 2nd token, which is the num of processes.
		st.nextToken();
		long maxPID = Long.parseLong(st.nextToken());
		// get cpu stat
		st = new StringTokenizer(cpuLine, " ");
		int cnt = 0;
		long userModeTick = 0, lowPriorityUserModeTick = 0, systemModeTick = 0, idleTaskTick = 0;
		long ioWaitTick = 0, irq = 0, softirq = 0, stealStolenTick = 0, guestTick = 0;
		while(st.hasMoreTokens()){
			String token = st.nextToken();
			switch(cnt++){
				case USER_MODE_IDX:
					userModeTick = Long.parseLong(token);
					continue;
				case LOW_PRIORITY_USER_MODE_IDX:
					lowPriorityUserModeTick = Long.parseLong(token);
					continue;
				case SYSTEM_MODE_IDX:
					systemModeTick = Long.parseLong(token);
					continue;
				case IDLE_TASK_MODE_IDX:
					idleTaskTick = Long.parseLong(token);
					continue;
				case IO_WAIT_IDX:
					ioWaitTick = Long.parseLong(token);
					continue;
				case IRQ_IDX:
					irq = Long.parseLong(token);
					continue;
				case SOFT_IRQ_IDX:
					softirq = Long.parseLong(token);
					continue;
				case STEAL_STOLEN_IDX:
					stealStolenTick = Long.parseLong(token);
					continue;
				case GUEST_IDX:
					guestTick = Long.parseLong(token);
					break;
			}
		}
		return new StatInfo(maxPID,
							userModeTick, 
							lowPriorityUserModeTick, 
							systemModeTick, 
							idleTaskTick,
							ioWaitTick, 
							irq, 
							softirq, 
							stealStolenTick, 
							guestTick);
	}
}