import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.CallableStatement;
import java.util.Date;

public class JDBCTester {
  public JDBCTester() {
    _is_opened = false;
    _drv_name = "oracle.jdbc.driver.OracleDriver";
    _connect_string = "jdbc:oracle:thin:@sodb1.cs.arizona.edu:1521:research";
    _user_name = "rui";
    _password = "rui";
    InitializeConnection();
  }
  
  public void InitializeConnection() {
    while (!_is_opened) {
      try {
        Class.forName(_drv_name);
        _connection = DriverManager.getConnection(
            _connect_string, _user_name, _password);
        _connection.setAutoCommit(false);
        _statement = _connection.createStatement(
            ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
        _is_opened = true;
        return;
      } catch (SQLException sqlex) {
        sqlex.printStackTrace();
        _is_opened = false;
      } catch (ClassNotFoundException e) {
        e.printStackTrace();
        System.exit(1);
      }	
    }
  }
  
  public void CloseConnection() {
    try {
      _connection.commit();
      _statement.close();
      _connection.close();
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }
  
  public void FlushDBCache() {	
    try {

      String strFlush = "ALTER SYSTEM FLUSH BUFFER_CACHE";
      _statement.execute(strFlush);
      _connection.commit();
      
      strFlush = "ALTER SYSTEM FLUSH SHARED_POOL";
      _statement.execute(strFlush);
      _connection.commit();
      
      strFlush = "ALTER SYSTEM CHECKPOINT";
      _statement.execute(strFlush);
      _connection.commit();

      
      /*
      String stats_update =
    	  "{execute DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(interval => 0)}";

      CallableStatement cs = _connection.prepareCall(stats_update);
      cs.executeUpdate();
      cs.close();
      _connection.commit();
      */
	} catch (SQLException sqlex) {
      sqlex.printStackTrace();
	}
  }
  
  public void FlushOSCache() {
    try {
      Runtime.getRuntime().exec("grep abcdefg12345 /scratch/data64").waitFor();
      Runtime.getRuntime().exec("sudo /usr/local/sbin/setdropcaches 1").waitFor();
      Runtime.getRuntime().exec("sync").waitFor();
    } catch (Exception ioex) {
      ioex.printStackTrace();
    }
  }
  
  public void OracleEmptyTask() {
    try {
      String strFlush = "NULL;";
      _statement.execute(strFlush);
      _connection.commit();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void OutputStats(int monitor_type) {
    try {
      if (monitor_type == 0) {
        Runtime.getRuntime().exec("./produce_psaux_result").waitFor();
      } else if (monitor_type == 1) {
        Runtime.getRuntime().exec("./produce_pidstat_result").waitFor();
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public void TestJDBC(int monitor_type) {
    long start_time;
    long finish_time;
    long exec_time;
    //String sqlquery = "SELECT * FROM test_table";
    String sqlquery = "SELECT * FROM v$version WHERE BANNER LIKE 'Oracle%'";
    try {
      PreparedStatement ps = _connection.prepareStatement(sqlquery);
      FlushDBCache();
      FlushOSCache();
      OutputStats(monitor_type);
      start_time = System.currentTimeMillis();
      System.out.print((new Date(start_time)).toString() + "\t");
      ps.execute();
      finish_time = System.currentTimeMillis();
      OutputStats(monitor_type);
      exec_time = finish_time - start_time;
      System.out.println(exec_time);
      ps.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }

  public static void Usage() {
    System.out.println("java -jar jdbctester.jar monitor_type");
    System.out.println("monitor_type: 0 - ps aux; 1 - pidstat");
  }
  
  private Connection _connection;
  private Statement _statement;
  private boolean _is_opened;
  private String _drv_name;
  private String _connect_string;
  private String _user_name;
  private String _password;
  
  static public void main(String[] args) {
    if (args.length < 1) {
      //Usage();
      return;
    }
    JDBCTester jdbc_tester = new JDBCTester();
    jdbc_tester.TestJDBC(Integer.parseInt(args[0]));
    jdbc_tester.CloseConnection();
  }
}
