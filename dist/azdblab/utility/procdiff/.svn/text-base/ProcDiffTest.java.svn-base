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

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.regex.Pattern;

class ParsedProcessInfo {
	int processID;
	String processName;
	long cTime, eTime = 0;
	int uTick, sTick, min_flt, maj_flt;

	public ParsedProcessInfo(int pID, String procName) {
		processID = pID;
		processName = procName;
		cTime = 0;
		uTick = 0;
		sTick = 0;
		min_flt = 0;
		maj_flt = 0;
	}
}

public class ProcDiffTest {
	private static int SECS = 5000;
	/****
	 * Sample function to do some computation taking about 3 secs
	 */
	private static void doSomeWork(){
//		System.out.println("work starts..."+dummy);
//		long dummy = 0;
//		final int MAX = 100000;
//		final int C = 10;
//		for(int i=0;i<C;i++){
//			dummy = 0;
//			for(int j=0;j<MAX;j++){
//				for(int k=0;k<MAX;k++){
//					dummy++;
//				}
//			}
//		}
//		System.out.println("done..." + dummy);
		try {
			Thread.sleep(SECS);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static final String[] DBMSProcessNames = { "oracle", "db2", "mysql",
		"postgres", "sqlserver", "sqlservr", "pgsql", "postmaster" };

	private static boolean isDBMS(String sent) {
		for (int i = 0; i < DBMSProcessNames.length; i++) {
			if (sent.contains(DBMSProcessNames[i])) {
				return true;
			}
		}
		return false;
	}

	/*****
	 * 
	 * @param args
	 */
	public static String parseProcDiff(String procDiff, long execTime){
		int totalUtick = 0;
		int totalStick = 0;
		String res = "";
		try {
			int userModeTicks = 0, 
				lowPriorityUserModeTicks = 0, 
				systemModeTicks = 0, 
				idleTaskTicks = 0, 
				ioWaitTicks = 0, 
				irq = 0, 
				softirq = 0, 
				stealStolenTicks = 0;
			int numPhantoms = 0;
			int numStoppedProcesses = 0;
			int numExecutedProcesses = 0, NumStartedProcesses = 0;
			String toTest = procDiff.replace("\n", " ").toLowerCase();
			/***
			 * Count phantom processes
			 */
			String tmp[] = toTest.split("phantom processes:");
			String body;

			if (tmp.length > 1) {
				body = tmp[0];
				String phantoms = tmp[1];
				phantoms = phantoms.replace("[", "");
				phantoms = phantoms.replace("]", "");
				numPhantoms = phantoms.split(";").length;
			} else {
				body = toTest;
			}

			String[] tickInformation = body.split("increased ticks:");

			if (tickInformation.length > 1) {
				String tickInfo = tickInformation[1];
				tickInfo = tickInfo.replace("increased ticks:", "");
				tickInfo = tickInfo.replace("[", "");
				tickInfo = tickInfo.replace("]", "");
				String[] ticks = tickInfo.split(",");
				for (int i = 0; i < ticks.length; i++) {
					String tmpString = ticks[i];
					tmpString = tmpString.replace(",", "");
					int tmpTick = Integer
							.parseInt(tmpString.split(":")[1].trim());

					if (tmpString.contains("lowpriorityusermodeticks")) {
						lowPriorityUserModeTicks += tmpTick;
					} else if (tmpString.contains("usermodeticks")) {
						userModeTicks += tmpTick;
					} else if (tmpString.contains("systemmodeticks")) {
						systemModeTicks += tmpTick;
					} else if (tmpString.contains("idletaskticks")) {
						idleTaskTicks += tmpTick;
					} else if (tmpString.contains("iowaitticks")) {
						ioWaitTicks += tmpTick;
					} else if (tmpString.contains("softirq")) {
						softirq += tmpTick;
					} else if (tmpString.contains("irq")) {
						irq += tmpTick;
					} else if (tmpString.contains("stealstolenticks")) {
						stealStolenTicks += tmpTick;
					}
				}
			}
			body = tickInformation[0];

			// if I recall correctly, started processes use :, while
			// existing processes use =
			Vector<ParsedProcessInfo> vec_myProcesses = new Vector<ParsedProcessInfo>();
			String[] startedProcesses = body
					.split("started processes:");

			if (startedProcesses.length > 1) {
				String sProc = startedProcesses[1];
				sProc = sProc.replace("started processes:", "");
				sProc = sProc.replace("[", "");
				sProc = sProc.replace("]", "");
				String[] result = Pattern.compile(";").split(sProc);
				for (int i = 0; i < result.length; i++) {
					NumStartedProcesses++;
					int procID = Integer.parseInt(result[i]
							.split("\\(")[0].trim());
					String processBody = result[i].split("\\(")[1]
							.replace(")", "");
					String[] processInfo = processBody.split(",");
					String processName = processInfo[0];
					ParsedProcessInfo myProcess = new ParsedProcessInfo(procID, processName);
					for (int j = 1; j < processInfo.length; j++) {
						String procStat = processInfo[j];
						if (procStat.contains("utime") || procStat.contains("utick")) {
							myProcess.uTick = Integer.parseInt(procStat
									.split(":")[1].trim());
						} else if (procStat.contains("stime") || procStat.contains("stick")) {
							myProcess.sTick = Integer.parseInt(procStat
									.split(":")[1].trim());
						} else if (procStat.contains("ctime")) {
							myProcess.cTime = Long.parseLong(procStat
									.split(":")[1].trim());
						} else if (procStat.contains("min_flt")) {
							myProcess.min_flt = Integer
									.parseInt(procStat.split(":")[1]
											.trim());
						} else if (procStat.contains("maj_flt")) {
							myProcess.maj_flt = Integer
									.parseInt(procStat.split(":")[1]
											.trim());
						} else if (procStat.contains("etime")) {
							myProcess.eTime = Long.parseLong(procStat
									.split(":")[1].trim());
						}
					}
					vec_myProcesses.add(myProcess);
				}
			}
			body = startedProcesses[0];
			/***
			 * Count stopped processes Do not include DBMS processes
			 */
			tmp = body.split("stopped processes:");
			if (tmp.length > 1) {
				String[] tmpSt = tmp[1].split(";");
				for (int i = 0; i < tmpSt.length; i++) {
					if (!isDBMS(tmpSt[i])) {
						numStoppedProcesses++;
					}
				}
			}
			body = tmp[0];
			/***
			 * Parse existing processes to find out other time Do not
			 * include DBMSes
			 */
			body = body.replace("executed processes:", "");
			body = body.replace("number of runs:", "");
			body = body.replace("[", "");
			body = body.replace("]", "");
			String[] result = Pattern.compile(";").split(body);

			for (int i = 0; i < result.length; i++) {
				if (result[i].equals("") || result[i].contains("n/a")) {
					// This is for certain cases where there are no
					// executed processes (Happens occasionally in
					// executions with really short runtimes)
					break;
				}
				numExecutedProcesses++;
				int procID = Integer.parseInt(result[i].split("\\(")[0]
						.trim());
				String processBody = result[i].split("\\(")[1].replace(
						")", "");
				String[] processInfo = processBody.split(",");
				String processName = processInfo[0];
				ParsedProcessInfo myProcess = new ParsedProcessInfo(procID,
						processName);
				for (int j = 1; j < processInfo.length; j++) {
					String procStat = processInfo[j]; 
					if (procStat.contains("utime") || procStat.contains("utick")) { 
						myProcess.uTick = Integer.parseInt(procStat
								.split("=")[1].trim());
					} else if (procStat.contains("stime") || procStat.contains("stick") ) {
						myProcess.sTick = Integer.parseInt(procStat
								.split("=")[1].trim());
					} else if (procStat.contains("ctime")) {
						myProcess.cTime = Integer.parseInt(procStat
								.split("=")[1].trim());
					} else if (procStat.contains("min_flt")) {
						myProcess.min_flt = Integer.parseInt(procStat
								.split("=")[1].trim());
					} else if (procStat.contains("maj_flt")) {
						myProcess.maj_flt = Integer.parseInt(procStat
								.split("=")[1].trim());
					}
				}
				vec_myProcesses.add(myProcess);
			}
			for (int i = 0; i < vec_myProcesses.size(); i++) {
				totalUtick += vec_myProcesses.get(i).uTick;
				totalStick += vec_myProcesses.get(i).sTick;
			}
			res += "[Sum of the Uticks of All Processes: " + totalUtick + ", userModeTicks: " + userModeTicks + "\n";
			res += " Sum of the Sticks of All Processes: " + totalStick + ", systemModeTicks: " + systemModeTicks + "\n";
			res += " Sum of the Process Ticks: " 
					+ (userModeTicks+lowPriorityUserModeTicks+systemModeTicks+idleTaskTicks+ioWaitTicks+stealStolenTicks) 
					+ ", measured_time: " + (execTime/10) + "]\n";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}

	public static void main(String[] args) {
		String dbms = "oracle";
		boolean SEPARATE = false;
		final int RUNS = 100;
		PrintWriter out = null;
		String filePrefix = "execProcDiff";
		String extension = ".log";
		try {
			String fileName = filePrefix+extension;
			out = new PrintWriter(new FileWriter("logs/"+fileName));
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		for(int i=1;i<=RUNS;i++){		
			out.println("===========");
			out.println("iteration " + i);
			HashMap<Long, ProcessInfo> procMap = new HashMap<Long, ProcessInfo>();
//		    if((dbms.toLowerCase()).contains("sqlserver")){
//		    	procMap = WindowsProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
//		    }else{
//		    	try {
//					procMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//		    }
			try {
				procMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
			} catch (Exception e) {
				e.printStackTrace();
			}
		    // read existing running process
		    ProcessAnalyzer.buildFrequentlyRunningCurrentProcesses(dbms.toLowerCase(), procMap);
		    
			// get processes
			HashMap<Long, ProcessInfo> beforeMap = new HashMap<Long, ProcessInfo>();
			HashMap<Long, ProcessInfo> afterMap = new HashMap<Long, ProcessInfo>();
			StatInfo beforeStat = null, afterStat = null;
			try {
				// get proc info
				beforeMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.PRE_QE);
//				if(SEPARATE){
//					// get cpu stat
//					beforeStat = LinuxProcessAnalyzer.getCPUStatInfo();
//					// get max pid
//					beforeStat.set_max_pid(LinuxProcessAnalyzer.getMaxPID());
//				}else{
//					beforeStat = LinuxProcessAnalyzer.getStatInfo();	
//				}
				beforeStat = LinuxProcessAnalyzer.getStatInfo();	
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// get time
			long start_time = System.currentTimeMillis();
			// execute a query
			doSomeWork();
			// get time
			long end_time = System.currentTimeMillis();
			
			try {
//				if(SEPARATE){
//					// get max pid
//					long max_pid = LinuxProcessAnalyzer.getMaxPID();
//					// get cpu stat info
//					afterStat  =  LinuxProcessAnalyzer.getCPUStatInfo();
//					// set max pid
//					afterStat.set_max_pid(max_pid);
//				}else{
//					// get stat info
//					afterStat = LinuxProcessAnalyzer.getStatInfo();
//				}
				afterStat = LinuxProcessAnalyzer.getStatInfo();
				// get proc info
				afterMap = LinuxProcessAnalyzer.extractProcInfo(LinuxProcessAnalyzer.POST_QE);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// derive execution time
			long exec_time = end_time - start_time;
			// do map diff
			String proc_diff = "";
//			if((dbms.toLowerCase()).contains("sqlserver")){
//				proc_diff = WindowsProcessAnalyzer.diffProcMap(WindowsProcessAnalyzer.PLATFORM,
//						 									   beforeStat,
//						 									   afterStat,
//															   beforeMap, 
//															   afterMap);
//		    }else{
//		    	proc_diff = LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
//							  beforeStat,
//							  afterStat,
//							  beforeMap, 
//							  afterMap);
//		    }
			proc_diff = LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
					  beforeStat,
					  afterStat//,
					  //beforeMap, 
					  //afterMap
					  );
			System.out.println("measured_time in java: " + exec_time);
			System.out.println(proc_diff);
			System.out.println(parseProcDiff(proc_diff, exec_time));
			out.println("measured_time in java: " + exec_time);
			out.println(proc_diff);
			out.println(parseProcDiff(proc_diff, exec_time));
			out.println("===========");
		} // end for
		out.close();
	}
}