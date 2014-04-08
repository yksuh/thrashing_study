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
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.StringTokenizer;

public class WindowsProcessAnalyzer extends ProcessAnalyzer{
	/***
	 * WINDOWS PLATFORM (LINUX = 0, WINDOWS = 1)
	 */
	public final static int PLATFORM = 1;
	/** 
	 * Windows ps program directory
	 */
	private final static String PSLIST_DIR = "C:\\Utils\\PsTools\\";
	/** 
	 * Windows ps program
	 */
	private final static String PSLIST_NAME = "PsList.exe";
	/****
	 * Build process info from pslist
	 * @param pid process id
	 * @return ProcessInfo
	 */
	public static WindowsProcessInfo buildProcInfo(String line){
		final int CMD_IDX = 0, 
				  PID_IDX = 1, 
				  PRI_IDX = 2, 
				  THD_IDX = 3, 
				  HND_IDX = 4, 
				  PRIV_IDX = 5, 
				  CPU_TIME_IDX = 6, 
				  ELAPSED_TIME_IDX = 7;
		String command = "";
    	long pid = 0, pri = 0, thd = 0, hnd = 0, priv = 0, cpu_time=0, elapsed_time=0; 
		int cnt = 0;
		StringTokenizer st = new StringTokenizer(line, " ");
		while(st.hasMoreTokens()){
			String token = st.nextToken();
			switch(cnt++){
				case CMD_IDX://0
					if(token.contains("Core")){
						command = token;
						command += " " + st.nextToken();
					}else{
						command = token;
					}
					continue;
				case PID_IDX://1
					pid = Long.parseLong(token);
					continue;
				case PRI_IDX://2
					pri = Long.parseLong(token);
					continue;
				case THD_IDX://3
					thd = Long.parseLong(token);
					continue;
				case HND_IDX://4
					hnd = Long.parseLong(token);
					continue;
				case PRIV_IDX://5
					priv = Long.parseLong(token);
					continue;
				case CPU_TIME_IDX://6
					cpu_time = getMillSecTime(token);
					continue;
				case ELAPSED_TIME_IDX://7
					elapsed_time = getMillSecTime(token);
					break;
			}
		}
		return new WindowsProcessInfo(pid, command, pri, thd, hnd, priv, cpu_time, elapsed_time);
	}
	/****
	 * Extract process info
	 * @return a map of (process id - process) entries
	 */
	public static HashMap<Long, ProcessInfo> extractProcInfo(int order) {
		HashMap<Long, ProcessInfo> resMap = new HashMap<Long, ProcessInfo>();
		try {
			Runtime rt = Runtime.getRuntime();
			Process p0 = rt.exec(PSLIST_DIR+PSLIST_NAME);
			InputStream instd = p0.getInputStream();
			BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
			String line = null;
			boolean readStart = false;
			while ((line = buf_reader.readLine()) != null) {
        		line = line.trim();
        		if(!line.contains("Name")) {
        			if(!readStart) continue;
        		}else{
        			readStart = true;
        			continue;
        		}
        		WindowsProcessInfo wpi = buildProcInfo(line);
        		if(order == ORDERINSENSITIVE){
        			resMap.put(wpi.get_pid(), wpi);
        		}else{
        			/****
	    			 *  In the case of pre-QE, build infrequent processes first. 
	    			 *  In the case of post-QE, build frequent processes first.
	    			 */
        			if(order == PRE_QE){
        				// infrequent processes
	        			if(freqRunningCurrentProcMap.get(wpi.get_pid()) == null){
	        				resMap.put(wpi.get_pid(), wpi);	
	        			}
        			}
	        		else if(order == POST_QE){
        				// frequent processes
	        			if(freqRunningCurrentProcMap.get(wpi.get_pid()) != null){
	        				resMap.put(wpi.get_pid(), wpi);	
	        			}
	        		}
        		}
			}
			buf_reader.close();
			p0.waitFor();
			
			/**
			 * Execute 'pslist' one more 
			 * so that we can obtain the info from (in)frequent processes in the case of PRE(POST)_QE
			 */
			if(order != ORDERINSENSITIVE){
				rt = Runtime.getRuntime();
				p0 = rt.exec(PSLIST_DIR+PSLIST_NAME);
				instd = p0.getInputStream();
				buf_reader = new BufferedReader(new InputStreamReader(instd));
				line = null;
				readStart = false;
				while ((line = buf_reader.readLine()) != null) {
	        		line = line.trim();
	        		if(!line.contains("Name")) {
	        			if(!readStart) continue;
	        		}else{
	        			readStart = true;
	        			continue;
	        		}
	        		// check infrequent process
        			WindowsProcessInfo wpi = buildProcInfo(line);
        			/****
	    			 *  In the case of pre-QE, build frequent processes. 
	    			 *  In the case of post-QE, build infrequent processes.
	    			 */
        			if(order == PRE_QE){
        				// frequent processes
	        			if(freqRunningCurrentProcMap.get(wpi.get_pid()) != null){
	        				resMap.put(wpi.get_pid(), wpi);	
	        			}
	        		}
        			else if(order == POST_QE){
	        			// infrequent processes
	        			if(freqRunningCurrentProcMap.get(wpi.get_pid()) == null){
	        				resMap.put(wpi.get_pid(), wpi);	
	        			}
	        		}
				}
				buf_reader.close();
				p0.waitFor();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return resMap;
	}
	private static long getMillSecTime(String token) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    return (Timestamp.valueOf(sdf.format(new java.util.Date(System.currentTimeMillis()))+" "+token)).getTime();
	}
}