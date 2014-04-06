package TimeChecker;

import java.io.*;
import java.util.*;

public class CheckIOStat {

  public CheckIOStat() {

  }

  public void CheckIO(String data_file) {
    try {
      FileReader frin = new FileReader(data_file);
      BufferedReader brin = new BufferedReader(frin);
      int state = 0;
      String inline = "";
      long start_blk_0 = 0;
      long end_blk_0 = 0;
      long start_blk_1 = 0;
      long end_blk_1 = 0;
      long start_blk_2 = 0;
      long end_blk_2 = 0;
      Vector<Long> vec_blk_dif_0 = new Vector<Long>();
      Vector<Long> vec_blk_dif_1 = new Vector<Long>();
      Vector<Long> vec_blk_dif_2 = new Vector<Long>();
      Vector<String> vec_run_time = new Vector<String>();
      while ((inline = brin.readLine()) != null) {
        inline = inline.trim();
        if (inline.compareTo("") == 0) {
          continue;
        }
        if (inline.equals("-------------------")) {
          state = 1;
          continue;
        }
        if (inline.startsWith("sda") && state == 1) {
          String[] details = inline.split("[ ]");
          start_blk_0 = Long.parseLong(details[details.length - 2].trim());
          continue;
        }
        if (inline.startsWith("sdb") && state == 1) {
          String[] details = inline.split("[ ]");
          start_blk_1 = Long.parseLong(details[details.length - 2].trim());
          continue;
        }
        if (inline.startsWith("md0") && state == 1) {
          String[] details = inline.split("[ ]");
          start_blk_2 = Long.parseLong(details[details.length - 2].trim());
          state = 3;
          continue;
        }
        if (state == 3) {
          vec_run_time.add(inline);
          state = 2;
          continue;
        }
        if (inline.startsWith("sda") && state == 2) {
          String[] details = inline.split("[ ]");
          end_blk_0 = Long.parseLong(details[details.length - 2].trim());
          vec_blk_dif_0.add(end_blk_0 - start_blk_0);
          continue;
        }
       if (inline.startsWith("sdb") && state == 2) {
          String[] details = inline.split("[ ]");
          end_blk_1 = Long.parseLong(details[details.length - 2].trim());
          vec_blk_dif_1.add(end_blk_1 - start_blk_1);
          continue;
        }

        if (inline.startsWith("md0") && state == 2) {
          String[] details = inline.split("[ ]");
          end_blk_2 = Long.parseLong(details[details.length - 2].trim());
          vec_blk_dif_2.add(end_blk_2 - start_blk_2);
          state = 3;
          continue;
        }
      }
      frin.close();
      brin.close();
      for (int i = 0; i < vec_blk_dif_0.size(); i++) {
        System.out.print(vec_blk_dif_0.get(i) + "\t");
        System.out.print(vec_blk_dif_1.get(i) + "\t");
        System.out.print(vec_blk_dif_2.get(i) + "\t");
        System.out.println(vec_run_time.get(i));
      }
    } catch (IOException ioex) {
      ioex.printStackTrace();
    }
  }

  public static void Usage() {
    //System.out.println("Usage: java CheckIOStat filename > outputfile");
    System.out.println("Usage: java -jar checkiostat.jar filename > outputfile");
  }


  public static void main(String[] args) {
    if (args.length != 1) {
      CheckIOStat.Usage();
      return;
    }
    CheckIOStat cios = new CheckIOStat();
    cios.CheckIO(args[0]);
  }
}
