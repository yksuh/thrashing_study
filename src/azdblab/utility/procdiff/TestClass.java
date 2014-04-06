package azdblab.utility.procdiff;

import java.io.File;
import java.io.IOException;

public class TestClass {

	/**
	 * @param args
	 * @throws IOException 
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws IOException, InterruptedException {
	// time insertion sort
		int num_runs = 1;
		while(num_runs <= 2048) {
			
			StringBuilder b = new StringBuilder();
			for (int i = 0; i < num_runs; i++)
				b.append(" 3");
			
			Runtime rt = Runtime.getRuntime();
			Process monitor = rt.exec("./phantom");
			StatInfo beforeStat = LinuxProcessAnalyzer.getStatInfo();
			
			/****
			 * do increment work
			 */
			
			long start_time = System.currentTimeMillis();
			Process work = rt.exec("./timecheck " + b.toString());
			work.waitFor();
			long finish_time = System.currentTimeMillis();
			StatInfo afterStat = LinuxProcessAnalyzer.getStatInfo();
			monitor.destroy();

			System.out.printf("diff:%s\n start: %d, finish: %d\n", LinuxProcessAnalyzer.myDiffProcMap(
					LinuxProcessAnalyzer.PLATFORM, beforeStat, afterStat), start_time, finish_time);
			num_runs *= 2; 
			File dst = new File(num_runs + ".dat");
			dst.delete();
			File src = new File("phantoms.dat");
			src.renameTo(dst);
		}

	}

}
