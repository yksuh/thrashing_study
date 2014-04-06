import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.Vector;


public class ProcDiffTimeTest {
	public static final String WINDOWS_DUMMY_FILE = "C:\\Temp\\data64";
	public static final String LINUX_DUMMY_FILE = "/scratch/data64";
	/**
	   * This method is used to read a big file in system as an alternative to flushing HDD cache.
	   * @param dummyName dummy file name
	   * @return none 
	   * specific.
	   */
	public static void flushDiskDriveCache(String dummyName) { 
		  	File dummy_file = new File(dummyName);
			try {
				BufferedReader buf_reader = new BufferedReader(new FileReader(dummy_file));
				while (buf_reader.readLine() != null) {
				}
				buf_reader.close();
			} catch (IOException ioex) {
			}
	  }
	  /**
	   * Flush buffer cache in linux system
	   */
	  public static  void flushLinuxCache() {
		  try {
		      Runtime rt = Runtime.getRuntime();
		      Process p1 = rt.exec(
		          "sudo /usr/local/sbin/setdropcaches 1");
		      InputStream instd = p1.getInputStream();
		      BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
		      while (buf_reader.readLine() != null) {
		      }
		      buf_reader.close();
		      InputStream errstd = p1.getErrorStream();
		      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
		      while (buf_err_reader.readLine() != null) {  
		      }
		      buf_err_reader.close();
		      p1.waitFor();

		      Process p2 = rt.exec("sync");
		      instd = p2.getInputStream();
		      buf_reader = new BufferedReader(new InputStreamReader(instd));
		      while (buf_reader.readLine() != null) {  
		      }
		      buf_reader.close();
		      errstd = p2.getErrorStream();
		      buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
		      while (buf_err_reader.readLine() != null) {  
		      }
		      buf_err_reader.close();
		      p2.waitFor();
		    } catch (Exception ex) {
		      ex.printStackTrace();
		    }
	  }
	  /**
	   * Flush buffer cache in windows system
	   * 
	   */
	  public static void flushWindowsCache() {
		  	/*** 
		  	 * http://www.addictivetips.com/windows-tips/clear-windows-7-cache/
		  	 * We don't know how to flush window cache, yet, but if we have a program to do it,
		  	 * then we can use it.
		  	 */
			try {
				Runtime rt = Runtime.getRuntime();
				String strCommand = "C:\\Windows\\System32\\rundll32.exe advapi32.dll, ProcessIdleTasks";
				Process p1 = rt.exec(strCommand);
				InputStream instd = p1.getInputStream();
				BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
				while (buf_reader.readLine() != null) {
				}
				buf_reader.close();
				InputStream errstd = p1.getErrorStream();
				BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
				while (buf_err_reader.readLine() != null) {
				}
				buf_err_reader.close();
				p1.waitFor();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
	  }
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String dbms = args[0];
System.out.println("dbms: " + dbms);	
		HashMap<Long, ProcessInfo> procMap = new HashMap<Long, ProcessInfo>();
	    if((dbms.toLowerCase()).contains("sqlserver")){
	    	procMap = WindowsProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
	    }else{
	    	try {
				procMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
	    // read existing running process
	    ProcessAnalyzer.buildFrequentlyRunningCurrentProcesses(dbms.toLowerCase(), procMap);
	    
	    final int cnt = 100;
	    long exec_time = 0;
	    for(int i=0;i<cnt;i++){
			// get processes
			HashMap<Long, ProcessInfo> beforeMap = new HashMap<Long, ProcessInfo>();
			HashMap<Long, ProcessInfo> afterMap = new HashMap<Long, ProcessInfo>();
			long start_time, end_time;
			// get proc
			if((dbms.toLowerCase()).contains("sqlserver")){
				flushDiskDriveCache(LINUX_DUMMY_FILE);
				flushWindowsCache();
				start_time = System.currentTimeMillis();
				beforeMap = WindowsProcessAnalyzer.extractProcInfo(ProcessAnalyzer.PRE_QE);
				end_time = System.currentTimeMillis();
		    }else{
		    	flushDiskDriveCache(WINDOWS_DUMMY_FILE);
				flushLinuxCache();
		    	start_time = System.currentTimeMillis();
		    	try {
					beforeMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.PRE_QE);
				} catch (Exception e) {
					e.printStackTrace();
				}
		    	end_time = System.currentTimeMillis();
		    }
			long temp = end_time - start_time;
			exec_time += temp;
			System.out.println("Execution Time"+i+": " + temp);
	    }
	    System.out.println("Avg Execution Time: " + (double)exec_time / (double)cnt);
	}

}