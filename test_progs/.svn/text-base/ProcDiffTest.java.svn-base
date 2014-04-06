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

public class ProcDiffTest {
//	/****
//	 * Sample function to do some computation taking about 3 secs
//	 */
//	private static void doSomeWork(){
//		long dummy = 0;
//		System.out.println("work starts..."+dummy);
//		final int MAX = 100000;
//		final int C = 6;
//		for(int i=0;i<C;i++){
//			dummy = 0;
//			for(int j=0;j<MAX;j++){
//				for(int k=0;k<MAX;k++){
//					dummy++;
//				}
//			}
//		}
//		System.out.println("done..." + dummy);
//	}
	
	public static void flushDBMSCache() {
		try {
			// db2 user needs to run 'db2pdcfg -flushbp -db research' to clean dirty pages
			// change user to db2
			//Process p1 = rt.exec("sudo su db2;source /data/db2/sqllib/db2cshrc;db connect to research;db2pdcfg -flushbp -db research;sexit");
//			Process p1 = Runtime.getRuntime().exec("sudo su db2");
//			p1.waitFor();
//			p1 = Runtime.getRuntime().exec("source /data/db2/sqllib/db2cshrc;db2 connect to research;db2pdcfg -flushbp -db research;exit");
//			p1.waitFor();
			Process p1 = Runtime.getRuntime().exec("perl db2_flush_cache.pl");
//			Process p1 = Runtime.getRuntime().exec("sudo su db2 --command=\"source /data/db2/sqllib/db2cshrc;db2 connect to research;db2pdcfg -flushbp -db research;\"");
			 InputStream instd = p1.getInputStream();
			 String str = "";
		      BufferedReader buf_reader = new BufferedReader(new InputStreamReader(instd));
		      while ((str=buf_reader.readLine()) != null) {
		    	  System.out.println(str);
		      }
		      buf_reader.close();
		      InputStream errstd = p1.getErrorStream();
		      BufferedReader buf_err_reader = new BufferedReader(new InputStreamReader(errstd));
		      while ((str=buf_err_reader.readLine()) != null) {
		    	  System.out.println(str);
		      }
		      buf_err_reader.close();
		      p1.waitFor();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	public static void main(String[] args) {
		System.out.println("start to flush dbms cache...");
		flushDBMSCache();
		System.out.println("finish flushing dbms cache...");
//		String dbms = args[0];
//	System.out.println("dbms: " + dbms);	
//		final int RUNS = 100;
//		try {
//			for(int p=1;p<=RUNS;p++){
//				String fileName = "timing-variance-test-output-"+dbms+"/prodiff" + p;
//				FileOutputStream fo = new FileOutputStream(new File(fileName));
//				PrintStream ps = new PrintStream(fo);
//				
//				HashMap<Long, ProcessInfo> procMap = new HashMap<Long, ProcessInfo>();
//			    if((dbms.toLowerCase()).contains("sqlserver")){
//			    	procMap = WindowsProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
//			    }else{
//			    	try {
//						procMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.ORDERINSENSITIVE);
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
//			    }
//			    // read existing running process
//			    ProcessAnalyzer.buildFrequentlyRunningCurrentProcesses(dbms.toLowerCase(), procMap);
//			    
//				// get processes
//				HashMap<Long, ProcessInfo> beforeMap = new HashMap<Long, ProcessInfo>();
//				HashMap<Long, ProcessInfo> afterMap = new HashMap<Long, ProcessInfo>();
//		
//				// get proc
//				if((dbms.toLowerCase()).contains("sqlserver")){
//					beforeMap = WindowsProcessAnalyzer.extractProcInfo(ProcessAnalyzer.PRE_QE);
//			    }else{
//			    	beforeMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.PRE_QE);
//			    }
//				long before_procs = 0;
//				if((dbms.toLowerCase()).contains("sqlserver")){
//				}else{
//					before_procs = LinuxProcessAnalyzer.GetNumProcesses();
//				}
//				// get time
//				long start_time = System.currentTimeMillis();
//				doSomeWork();
//				// get time
//				long end_time = System.currentTimeMillis();
//				// get proc
//				long after_procs = 0;
//				if((dbms.toLowerCase()).contains("sqlserver")){
//				}else{
//					after_procs = LinuxProcessAnalyzer.GetNumProcesses();
//				}
//				// get proc
//				if((dbms.toLowerCase()).contains("sqlserver")){
//					afterMap = WindowsProcessAnalyzer.extractProcInfo(ProcessAnalyzer.POST_QE);
//			    }else{
//			    	afterMap = LinuxProcessAnalyzer.extractProcInfo(ProcessAnalyzer.POST_QE);
//			    }
//				
//				// derive execution time
//				long exec_time = end_time - start_time;
//				System.out.println("Execution Time: " + exec_time + " <= " + start_time + "/" + end_time);
//				ps.println("Execution Time: " + exec_time + " <= " + start_time + "/" + end_time);
//				// do map diff
//				String proc_diff = "";
//				if((dbms.toLowerCase()).contains("sqlserver")){
//					proc_diff = WindowsProcessAnalyzer.diffProcMap(WindowsProcessAnalyzer.PLATFORM,
//																  before_procs,
//																  after_procs,
//																  beforeMap, 
//																  afterMap);
//			    }else{
//			    	proc_diff = LinuxProcessAnalyzer.diffProcMap(LinuxProcessAnalyzer.PLATFORM,
//								  before_procs,
//								  after_procs,
//								  beforeMap, 
//								  afterMap);
//			    }
//				System.out.println(proc_diff);
//				ps.println(proc_diff);
//				ps.close();
//			} // end for
//		}catch (Exception e1) {
//			e1.printStackTrace();
//		}
	}
}

abstract class ProcessInfo {
	/**
	 * pid
	 */
	protected long _pid;
	/***
	 * command
	 */
	protected String _command;
	/***
	 * Get pid
	 * @return _pid
	 */
	public long get_pid() {
		return _pid;
	}
	/***
	 * Get command
	 * @return _command
	 */
	public String get_command() {
//		if("".equalsIgnoreCase(_command)){
//			System.out.println("command: " + _command);
//			System.exit(-1);
//		}
		return _command;
	}
	/***
	 * Get process info string
	 */
	public abstract String getStr();
	/***
	 * Get diff between this obj and a given obj
	 * @param pi
	 * @return diff string
	 */
	public abstract String getDiff(ProcessInfo gpi);
}

/***
 * Process information class
 * @author yksuh
 *
 */
class LinuxProcessInfo extends ProcessInfo {
	/**
	 * min_flt
	 */
	private long _min_flt;
	/***
	 * maj_flt
	 */
	private long _maj_flt;
	/***
	 * utime
	 */
	private long _uTime;
	/***
	 * stime
	 */
	private long _sTime;
	/***
	 * startTime
	 */
	private long _startTime;
	/***
	 * Constructor of ProcessInfo
	 * @param pid
	 * @param command
	 * @param min_flt
	 * @param maj_flt
	 * @param uTime
	 * @param sTime
	 */
	public LinuxProcessInfo(long pid, 
					String command,
					long min_flt,
					long maj_flt,
					long uTime,
					long sTime,
					long startTime) {
		_pid = pid;
		_command = command;
		_min_flt = min_flt;
		_maj_flt = maj_flt;
		_uTime = uTime;
		_sTime = sTime;
		_startTime = startTime;
	}
	/***
	 * Get min_flt
	 * @return _min_flt
	 */
	public long get_min_flt() {
		return _min_flt;
	}

	/***
	 * Get maj_flt
	 * @return _maj_flt
	 */
	public long get_maj_flt() {
		return _maj_flt;
	}

	/***
	 * Get utime
	 * @return _uTime
	 */
	public long get_uTime() {
		return _uTime;
	}

	/***
	 * Get stime
	 * @return _sTime
	 */
	public long get_sTime() {
		return _sTime;
	}
	/***
	 * Get start time
	 * @return _startTime
	 */
	public long get_startTime() {
		return _startTime;
	}
//	/***
//	 * Return a string having all
//	 */
//	public String toString(){
//		return _pid+";"+_command+";"+_min_flt+";"+_maj_flt+";"+_uTime+";"+_sTime+";";
//	}
	/***
	 * Get diff between this obj and a given obj
	 * @param pi
	 * @return diff string
	 */
	public String getDiff(ProcessInfo gpi){
		LinuxProcessInfo pi = (LinuxProcessInfo)gpi;
		String res = "";
		String conjunct = " to ";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecDiff = new Vector<String>();
		if( _pid == pi.get_pid() && _command.equalsIgnoreCase(pi.get_command())){
			if(_min_flt != pi.get_min_flt()){
				long diff = pi.get_min_flt() - _min_flt;
				vecDiff.add("\tmin_flt:"+normalformat.format(_min_flt)+conjunct+normalformat.format(pi.get_min_flt())+" = " + diff);
			}
			if(_maj_flt != pi.get_maj_flt()){
				long diff = pi.get_maj_flt() - _maj_flt;
				vecDiff.add("\tmaj_flt:"+normalformat.format(_maj_flt)+conjunct+normalformat.format(pi.get_maj_flt())+" = " + diff);
			}
			if(_uTime != pi.get_uTime()){
				long diff = pi.get_uTime() - _uTime;
				vecDiff.add("\tuTime  :"+normalformat.format(_uTime)+conjunct+normalformat.format(pi.get_uTime())+" = " + diff);
			}
			if(_sTime != pi.get_sTime()){
				long diff = pi.get_sTime() - _sTime;
				vecDiff.add("\tsTime  :"+normalformat.format(_sTime)+conjunct+normalformat.format(pi.get_sTime())+" = " + diff);
			}
			for(int i=0;i<vecDiff.size();i++){
				if(i==0){
					res += pidformat.format(_pid)+"(";
					res += _command+",\n";
				}
				res += vecDiff.get(i);
				if(i < vecDiff.size()-1){
					res += ",\n";
				}
				if(i == vecDiff.size()-1){
					res += ")";
				}
			}
		}
		return res;
	}
	/***
	 * Get process info string
	 */
	public String getStr() {
		// TODO Auto-generated method stub
		String res = "";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecData = new Vector<String>();
		vecData.add("\tmin_flt:"+normalformat.format(_min_flt));
		vecData.add("\tmaj_flt:"+normalformat.format(_maj_flt));
		vecData.add("\tuTime  :"+normalformat.format(_uTime));
		vecData.add("\tsTime  :"+normalformat.format(_sTime));
		vecData.add("\tstartTime:"+normalformat.format(_startTime));
		for(int i=0;i<vecData.size();i++){
			if(i==0){
				res += pidformat.format(_pid)+"(";
				res += _command+",\n";
			}
			res += vecData.get(i);
			if(i < vecData.size()-1){
				res += ",\n";
			}
			if(i == vecData.size()-1){
				res += ")";
			}
		}
		return res;
	}
}

class WindowsProcessInfo extends ProcessInfo {
	/**
	 * pri
	 */
	private long _pri;
	/***
	 * thd
	 */
	private long _thd;
	/***
	 * hnd
	 */
	private long _hnd;
	/***
	 * priv
	 */
	private long _priv;
	/***
	 * cputime
	 */
	private long _cTime;
	/***
	 * stime
	 */
	private long _eTime;
	
	/***
	 * Constructor of ProcessInfo
	 * @param pid
	 * @param command
	 * @param min_flt
	 * @param maj_flt
	 * @param uTime
	 * @param sTime
	 */
	public WindowsProcessInfo(long pid, 
							  String command,
							  long pri,
							  long thd,
							  long hnd,
							  long priv,
							  long cTime,
							  long eTime) {
		_pid = pid;
		_command = command;
		_pri = pri;
		_thd = thd;
		_hnd = hnd;
		_priv = priv;
		_cTime = cTime;
		_eTime = eTime;
	}
	public long get_pri() {
		return _pri;
	}
	public long get_thd() {
		return _thd;
	}
	public long get_hnd() {
		return _hnd;
	}
	public long get_priv() {
		return _priv;
	}
	public long get_cTime() {
		return _cTime;
	}
	public long get_eTime() {
		return _eTime;
	}
	/***
	 * Get diff between this obj and a given obj
	 * @param gpi process info
	 * @return diff string
	 */
	public String getDiff(ProcessInfo gpi){
		WindowsProcessInfo pi = (WindowsProcessInfo)gpi;
		String res = "";
		String conjunct = " to ";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecDiff = new Vector<String>();
		if(!_command.equalsIgnoreCase("PsList") && !_command.contains("Idle")
				&& _pid == pi.get_pid() && _command.equalsIgnoreCase(pi.get_command())){
//			if(_pri != pi.get_pri()){
//				long diff = pi.get_pri() - _pri;
//				vecDiff.add("\tpri:"+normalformat.format(_pri)+conjunct+normalformat.format(pi.get_pri())+" = " + diff);
//			}
//			if(_thd != pi.get_thd()){
//				long diff = pi.get_thd() - _thd;
//				vecDiff.add("\tthd:"+normalformat.format(_thd)+conjunct+normalformat.format(pi.get_thd())+" = " + diff);
//			}
//			if(_hnd != pi.get_hnd()){
//				long diff = pi.get_hnd() - _hnd;
//				vecDiff.add("\thnd:"+normalformat.format(_hnd)+conjunct+normalformat.format(pi.get_hnd())+" = " + diff);
//			}
//			if(_priv != pi.get_priv()){
//				long diff = pi.get_priv() - _priv;
//				vecDiff.add("\tpriv:"+normalformat.format(_priv)+conjunct+normalformat.format(pi.get_priv())+" = " + diff);
//			}
			if(_cTime != pi.get_cTime()){
				long diff = pi.get_cTime() - _cTime;
				vecDiff.add("\tcTime  :"+normalformat.format(_cTime)+conjunct+normalformat.format(pi.get_cTime())+" = " + diff);
//				vecDiff.add("\tcTime:" + diff);
			}
//			if(_eTime != pi.get_eTime()){
//				long diff = pi.get_eTime() - _eTime;
////				vecDiff.add("\teTime  :"+normalformat.format(_eTime)+conjunct+normalformat.format(pi.get_eTime())+" = " + diff);
//				vecDiff.add("\teTime:" + diff);
//			}
			for(int i=0;i<vecDiff.size();i++){
				if(i==0){
					res += pidformat.format(_pid)+"(";
					res += _command+",\n";
				}
				res += vecDiff.get(i);
				if(i < vecDiff.size()-1){
					res += ",\n";
				}
				if(i == vecDiff.size()-1){
					res += ")";
				}
			}
		}
		return res;
	}
	public String getStr() {
		String res = "";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecData = new Vector<String>();
		vecData.add("\tpri:"+normalformat.format(_pri));
		vecData.add("\tthd:"+normalformat.format(_thd));
		vecData.add("\thnd:"+normalformat.format(_hnd));
		vecData.add("\tpriv:"+normalformat.format(_priv));
		vecData.add("\tcTime:"+normalformat.format(_cTime));
		vecData.add("\teTime:"+normalformat.format(_eTime));
		for(int i=0;i<vecData.size();i++){
			if(i==0){
				res += pidformat.format(_pid)+"(";
				res += _command+",\n";
			}
			res += vecData.get(i);
			if(i < vecData.size()-1){
				res += ",\n";
			}
			if(i == vecData.size()-1){
				res += ")";
			}
		}
		return res;
	}
}

abstract class ProcessAnalyzer {
	/***
	 * Process_Output directory
	 */
	public final static String DIRECTORY_PROC_OUTPUT = "processOutput/";
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
	/***
	 * The most frequently running processes 
	 */
	public final static int topK = 10;
	/****
	 * Frequently running processes
	 */
	protected static HashMap<Long, String> freqRunningCurrentProcMap;
	/****
	 * Print current running process map
	 * @param paramMap current running process map
	 */
	protected static void printCurrRunningProcMap(HashMap<Long, ProcessInfo> paramMap) {
		Map map = new TreeMap(paramMap);
		// get all entries from map
		// Move next key and value of HashMap by iterator
		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry m = (Map.Entry) it.next();
			ProcessInfo pi = (ProcessInfo) m.getValue();
			System.out.println((Long)m.getKey() + " => " + pi.get_command());
		}
	}
	/****
	 * Print frequently-running process map
	 * @param paramMap frequently-running process map
	 */
	protected static void printFreqRunningProcMap(HashMap<Long, String> paramMap) {
		long res = -1;
		Map map = new TreeMap(paramMap);
		// get all entries from map
		// Move next key and value of HashMap by iterator
		Iterator it = map.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry m = (Map.Entry) it.next();
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
		System.out.println("fileName: " + fileName);
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
				System.out.println("procCnt: " + procCnt + ", command: " + command);
			}
			buf_reader.close();
		} catch (IOException e1) {}
		System.out.println("******** < Current Running Processes > *************************");
		printCurrRunningProcMap(procMap);
		System.out.println("*********< Frequently-Running Current Processes > **************");
		printFreqRunningProcMap(freqRunningCurrentProcMap);
		System.out.println("****************************************************************");
		System.exit(-1);
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
		Iterator it = paramMap.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry m = (Map.Entry)it.next();
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
	protected static String buildProcListStr(Vector procList){
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
				String _command = ((beforeProcMap.get(beforeProcKey))).get_command();
				if(platform == WINDOWS){
//					if(!_command.contains("PsList"))
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
				String strInfo = ((afterProcMap.get(afterProcKey))).getStr();
				if(platform == WINDOWS){
//					if(!strInfo.contains("PsList"))
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
		if(procList.size() > 0) return buildProcListStr(procList);
		else 					return ""; 
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
//				if("ERROR".equals(diffStr)){
//					throw new Exception("diff is performed on different processes.");
//				}
				if(!"".equals(diffStr)){
					// add this to the frequently-running process map
					freqRunningCurrentProcMap.put(beforeProcKey, beforeProc.get_command());
					vecDiffs.add(diffStr);	
				}
			} 
		} 
		if(vecDiffs.size() > 0) return buildProcListStr(vecDiffs);
		else 					return "";
	}
	/***
	 * Perform diff between two maps on windows
	 * @param beforeProcMap
	 * @param afterProcMap
	 * @return
	 */
	public static String diffProcMap(int platform,
									 long before_procs,
									 long after_procs,
									 HashMap<Long, ProcessInfo> beforeProcMap,
									 HashMap<Long, ProcessInfo> afterProcMap){
		String res = ""; 
		String strDiffResults = "";
		String strDiffs 	   = diffProcList(platform, beforeProcMap, afterProcMap);
		if(!"".equals(strDiffs)){
			strDiffResults += "Existing Processes:\n["+strDiffs+"]\n";
		}
		String strStoppedProcs = stoppedProcList(platform, beforeProcMap, afterProcMap);
		if(!"".equals(strStoppedProcs)){
			strDiffResults += "Stopped Processes:\n["+strStoppedProcs+"]\n";
		}
		String strStartedProcs = startedProcList(platform, beforeProcMap, afterProcMap);
		if(!"".equals(strStartedProcs)){
			strDiffResults += "Started Processes:\n["+strStartedProcs+"]\n";
		}
		if(platform == LINUX){
			String strPhantomProcs 	= phantomCheck(before_procs, after_procs);
			if(!"".equals(strPhantomProcs)){
				strDiffResults += "Phantom Processes:\n["+strPhantomProcs+"]\n";
			}
		}
		if(!"".equals(strDiffResults)){
			res = strDiffResults;
		}
		return res;
	}
	/****
	 * Check number of phantoms
	 * @param before_procs	# processes before query execution
	 * @param after_procs	# processes after query execution
	 * @return
	 */
	private static String phantomCheck(long before_procs, long after_procs){
		String str = "";
		if (before_procs != after_procs) {
			str += before_procs + " to " + after_procs;
		}
//		else{
//			str += before_procs + " to " + after_procs;
//		}
		return str;
	}
}

class LinuxProcessAnalyzer extends ProcessAnalyzer{
	/***
	 * LINUX PLATFORM (LINUX = 0, WINDOWS = 1)
	 */
	public final static int PLATFORM = 0;
	/***
	 * proc dir
	 */
	public final static String _PROC_DIR = "/proc";
	/***
	 * stat dir
	 */
	public final static String _STAT_DIR = "stat";
	/***
	 * pid position
	 */
	public final static int PID_IDX 	= 0;	
	/***
	 * command position
	 */
	public final static int COMMAND_IDX = 1;
	/***
	 * min_flt position
	 */
	public final static int MIN_FLT_IDX = 9;
	/***
	 * maj_flt position
	 */
	public final static int MAJ_FLT_IDX = 11;
	/***
	 * utime position
	 */
	public final static int UTIME_IDX 	= 13;
	/***
	 * stime position
	 */
	public final static int STIME_IDX	= 14;
	/***
	 * Start time position
	 */
	private static final int STARTTIME_IDX = 21;
	/****
	 * Build process info from /proc/pid/stat directory
	 * @param pid process id
	 * @return ProcessInfo
	 */
	public static LinuxProcessInfo buildProcInfo(long pid){
		long min_flt = 0, maj_flt = 0, utime=0, stime=0, startTime=-1; 
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
        				case UTIME_IDX:
        					utime = Long.parseLong(token);
        					continue;
        				case STIME_IDX:
        					stime = Long.parseLong(token);
        					continue;
        				case STARTTIME_IDX:
	    					startTime = Long.parseLong(token);
	    					break;
        			}
        		}
        	}
        	buf_reader.close();
	    }catch (IOException e1) {
	    	return null;
	    }
        return new LinuxProcessInfo(pid, command, min_flt, maj_flt, utime, stime, startTime);
	}
	/****
	 * Extract process info
	 * @return a map of (process id - process) entries
	 */
	public static HashMap<Long, ProcessInfo> extractProcInfo(int order) throws Exception{
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
	    					resMap.put(pid,  buildProcInfo(pid));	
	    				}else if(order == POST_QE){
	    					vecInFreqRunningProcs.add(pid);
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
			    // check frequent process
			    for(int i=0;i<vecFreqRunningProcs.size();i++){
			    	long pid = (vecFreqRunningProcs.get(i)).longValue();
			    	LinuxProcessInfo pi = buildProcInfo(pid);
			    	// sanity check: if pid directory is still alive, put it 
			    	if(pi != null) 
			    		resMap.put(pid, pi);	
//			    	else{
//			    		throw new Exception("Frequent process id '"+pid+"' does not exist in " +
//			    				""+_PROC_DIR+"/"+pid+"/"+_STAT_DIR);
//			    	}
			    }
		    }else if(order == POST_QE){
			    // check infrequent processes
			    for(int i=0;i<vecInFreqRunningProcs.size();i++){
			    	long pid = (vecInFreqRunningProcs.get(i)).longValue();
			    	LinuxProcessInfo pi = buildProcInfo(pid);
			    	// sanity check: if pid directory is still alive, put it 
			    	if(pi != null) 
			    		resMap.put(pid, pi);	
//			    	else{
//			    		throw new Exception("Infrequent process id '"+pid+"' does not exist in " +
//			    				""+_PROC_DIR+"/"+pid+"/"+_STAT_DIR);
//			    	}
			    }
		    }
	    }
	    return resMap;
	}
	/****
	 * Get number of process since the machine is up
	 * @return
	 */
	public static long GetNumProcesses() {
		long res = 0;
		File proc_stat_file = new File(_PROC_DIR + "/" + _STAT_DIR);
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
					res = Long.parseLong(string_tokenizer.nextToken());
					break;
				}
			}
			file_reader.close();
			buf_reader.close();
			return res;
		} catch (IOException ioex) {
			System.out.println(ioex.getMessage());
			return -1;
		}
	}
}

class WindowsProcessAnalyzer extends ProcessAnalyzer{
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
