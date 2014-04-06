import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;
public class ProcDiffSample {
	/***
	 * Process information class
	 * @author yksuh
	 *
	 */
	private static class ProcessInfo {
		/**
		 * pid
		 */
		private long _pid;
		/***
		 * command
		 */
		private String _command;
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
		 * Constructor of ProcessInfo
		 * @param pid
		 * @param command
		 * @param min_flt
		 * @param maj_flt
		 * @param uTime
		 * @param sTime
		 */
		public ProcessInfo(long pid, 
						String command,
						long min_flt,
						long maj_flt,
						long uTime,
						long sTime) {
			_pid = pid;
			_command = command;
			_min_flt = min_flt;
			_maj_flt = maj_flt;
			_uTime = uTime;
			_sTime = sTime;
		}
		
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
			if("".equalsIgnoreCase(_command)){
				System.out.println("command: " + _command);
				System.exit(-1);
			}
			return _command;
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
		 * Return a string having all
		 */
		public String toString(){
			return _pid+";"+_command+";"+_min_flt+";"+_maj_flt+";"+_uTime+";"+_sTime+";";
		}
		
		/***
		 * Get diff between this obj and a given obj
		 * @param pi
		 * @return diff string
		 */
		public String getDiff(ProcessInfo pi){
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
					res += (String)vecDiff.get(i);
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
			// TODO Auto-generated method stub
			String res = "";
			NumberFormat pidformat = new DecimalFormat("00000");
			NumberFormat normalformat = new DecimalFormat("0000000000");
			Vector<String> vecData = new Vector<String>();
			vecData.add("\tmin_flt:"+normalformat.format(_min_flt));
			vecData.add("\tmaj_flt:"+normalformat.format(_maj_flt));
			vecData.add("\tuTime  :"+normalformat.format(_uTime));
			vecData.add("\tsTime  :"+normalformat.format(_sTime));
			for(int i=0;i<vecData.size();i++){
				if(i==0){
					res += pidformat.format(_pid)+"(";
					res += _command+",\n";
				}
				res += (String)vecData.get(i);
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
	/****
	 * Extract process info
	 * @return a map of (process id - process) entries
	 */
	public static HashMap<Long, ProcessInfo> extractProcInfo() {
		HashMap<Long, ProcessInfo> resMap = new HashMap<Long, ProcessInfo>();
		final File dir = new File(_PROC_DIR);
	    final String[] filedirArray = dir.list();
	    for(String filedir : filedirArray) {
	    	final File procFile = new File(dir, filedir);
	    	// if this file is directory
	    	if (procFile.isDirectory()) {
	    		long pid = 0, min_flt = 0, maj_flt = 0, utime=0, stime=0; 
	    		String command = "";
	    		try {
	    			// get pid from the dir name directly
	    			pid = Long.parseLong(filedir);
	    		}catch (NumberFormatException e) {
	    			continue;
                }   
	    		// This file is process dir.
	    		final File procStatFile = new File(procFile, _STAT_DIR);
                try {
                	BufferedReader buf_reader = new BufferedReader(new FileReader(procStatFile));
                	String line = null;
                	StringTokenizer st;
                	int cnt = 0;
                	while ((line = buf_reader.readLine()) != null) {
                		line = line.trim();
//                		System.out.println("line: " + line);
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
                					break;
                			}
                		}
                	}
                	buf_reader.close();
        	    } catch (IOException e1) {
        	    	
        	    }
                // create a process entry
                resMap.put(pid, new ProcessInfo(pid, command, min_flt, maj_flt, utime, stime));	
	    	} // end if proc dir
	    } // end for
	    return resMap;
	}
	public static void get_procs(){
		File proc_stat_file = new File("/proc/stat");
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
					Long.parseLong(string_tokenizer.nextToken());
					break;
				}
			}
			file_reader.close();
			buf_reader.close();
		} catch (IOException ioex) {
			System.out.println(ioex.getMessage());
		}
	}
	public static void main(String[] args) {
		long start_time = System.currentTimeMillis();
		get_procs();
		long end_time = System.currentTimeMillis();
		long exec_time = end_time - start_time;
		System.out.println("stage1: " + exec_time + " <= " + start_time + "/" + end_time);

		start_time = System.currentTimeMillis();
		extractProcInfo();
		end_time = System.currentTimeMillis();
		exec_time = end_time - start_time;
		System.out.println("stage2: " + exec_time + " <= " + start_time + "/" + end_time);	
	}
}

