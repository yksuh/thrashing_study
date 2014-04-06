import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.StringTokenizer;

class LinuxProcess {
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

public class procdiffTest {
	/****
	 * Young's revision using perl script parsing the output of 'ps aux'
	 * 
	 * @return
	 */
	public static HashMap<Integer, LinuxProcess> GetProcesses() {
		HashMap<Integer, LinuxProcess> process_map = new HashMap<Integer, LinuxProcess>();
		String command = "perl proc_diff.pl";
		try {
			Process p = Runtime.getRuntime().exec(command);
			BufferedReader buf_reader = new BufferedReader(
					new InputStreamReader(p.getInputStream()));
			String input_string = null;
			buf_reader.readLine();
			StringTokenizer string_tokenizer = null;
			while ((input_string = buf_reader.readLine()) != null) {
System.out.println(input_string);
				input_string = input_string.trim();
				string_tokenizer = new StringTokenizer(input_string, ";");
				String owner = "";
				String id = "";
				String time = "";
				String exec = "";
				while (string_tokenizer.hasMoreTokens()) {
					owner =  string_tokenizer.nextToken();
					id =  string_tokenizer.nextToken();
					time =  string_tokenizer.nextToken();
					exec = string_tokenizer.nextToken();
				}
				LinuxProcess linux_process = new LinuxProcess(
						Integer.parseInt(id),
						owner, exec,
						time);
				process_map.put(new Integer(id), linux_process);
			}
			return process_map;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		HashMap<Integer, LinuxProcess> procMap = procdiffTest.GetProcesses();
		Iterator it = procMap.entrySet().iterator();
		while(it.hasNext()){
			Map.Entry m = (Map.Entry)it.next();
	        int id = ((Integer)m.getKey()).intValue();
	        LinuxProcess lp = (LinuxProcess)m.getValue();
	        System.out.println("("+id+") => " + lp.toString());
		}
	}
}
