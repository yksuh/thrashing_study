package plugins.unit_testing;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.junit.Test;

import azdblab.model.experiment.Column;
import plugins.TeradataSubject;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.model.experiment.Table;

public class TeradataSubjectTest {
	private static Connection _connection;
	private static PreparedStatement _pStmt;
	private static String user_name = "azdblab_user";
	private static String password = "azdblab_user";
	private static String connect_string = "jdbc:teradata://192.168.67.131/TMODE=ANSI,CHARSET=UTF8";
	private static String machineName = "192.168.67.131";
	private static String DBMS_DRIVER_CLASS_NAME = "com.teradata.jdbc.TeraDriver";
	private static String lsql = "SELECT t0.id2, SUM(t0.id1)  FROM ft_HT3 t1, ft_lHT1 t0  WHERE  (t1.id4=t0.id3)  GROUP BY t0.id2";
	private static String rsql = "SELECT t0.id2, SUM(t0.id1)  FROM ft_HT3 t1, ft_rHT1 t0  WHERE  (t1.id4=t0.id3)  GROUP BY t0.id2";
	private static long card = 0;

	private static String prefix = "ft_";
	private static String orgTable = prefix + "HT1";
	private static String lTable = "lHT1";
	private static String rTable = "rHT1";
	private static String cloneMaxTableName = "clone_max_" + orgTable;
	private static TeradataSubject ts = null;
	private static Statement _statement;

	/***
	 * Connect to Teradata, instantiating Teradata subject
	 */
	public void connect() {
		try {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
			Class.forName(DBMS_DRIVER_CLASS_NAME);
			_connection = DriverManager.getConnection(connect_string,
					user_name, password);
			_connection.setAutoCommit(false);
			// _statement = _connection.createStatement();
			_statement = _connection.createStatement(
					ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			ts = new TeradataSubject(user_name, password, connect_string, machineName);
			ts.SetConnection(_connection);
			ts.SetStatement(_statement);

			System.out.println(ts.getDBVersion());
			System.out.println(ts.getDBMSDriverClassName());
			System.out.println(ts.getDBMSName());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testTimePreparedQuery() throws Exception{
		connect();

		System.out.println("'Test connection for TeradataSubject");
		int timeOut = 900;

		// for (int i = 1; i <= 10; i++) {
		// card = 860000;
		// ts.copyTable(lTable, cloneMaxTableName, card);
		// ts.updateTableStatistics(lTable);
		// ts.commit();
		// try {
		// _pStmt = _connection.prepareStatement(lsql);
		// } catch (SQLException e) {
		// // TODO Auto-generated catch block
		// e.printStackTrace();
		// }
		//
		// try {
		// System.out.println("timeout: " + timeOut);
		// System.out.println("query: " + lsql);
		// _pStmt.setQueryTimeout(timeOut);
		// System.out.println("executing ... at " + card);
		// long startTime = System.currentTimeMillis();
		// _pStmt.executeQuery();
		// long endTime = System.currentTimeMillis();
		// System.out.println(i + " the execution done : "
		// + (endTime - startTime) + "(ms)");
		// } catch (SQLException e) {
		// // TODO Auto-generated catch block
		// e.printStackTrace();
		// }
		// }

		int col_len = 4;
		Column[] columns = new Column[col_len];
		for (int j = 1; j <= col_len; j++) {
			columns[j - 1] = new Column("id" + j);
		}
//		Table fixedTable = new Table("HT3", prefix, 0, 0, 0, 0, columns);
//		ts.updateTableStatistics(fixedTable);

		Table leftTable, rightTable;
		leftTable = new Table(lTable, prefix, 0, 0, 0, 0, columns);
		rightTable = new Table(rTable, prefix, 0, 0, 0, 0, columns);

		long[] leftCards = { 2000000, 1980000, 860000, 840000, 200000, 20000 };
		for (int i = 0; i < leftCards.length; i++) {
			card = leftCards[i];
			ts.copyTable(leftTable.table_name_with_prefix, cloneMaxTableName,
					card);
			ts.updateTableStatistics(leftTable);
			ts.commit();
			try {
				_pStmt = _connection.prepareStatement(lsql);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				System.out.println("timeout: " + timeOut);
				flushDBMSCache();
				Main._logger.outputLog("Finish Flushing DBMS Cache");

				System.out.println("query: " + lsql);
				_pStmt.setQueryTimeout(timeOut);
				System.out.println("executing ... at " + card);
				long startTime = System.currentTimeMillis();
				_pStmt.executeQuery();
				long endTime = System.currentTimeMillis();
				System.out.println(i + " the execution done : "
						+ (endTime - startTime) + "(ms)");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		long[] rightCards = { 1990000, 1970000, 850000, 830000, 190000, 10000 };
		for (int i = 0; i < rightCards.length; i++) {
			card = rightCards[i];
			ts.copyTable(rightTable.table_name_with_prefix, cloneMaxTableName,
					card);
			ts.updateTableStatistics(rightTable);
			ts.commit();

			try {
				_pStmt = _connection.prepareStatement(rsql);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				System.out.println("timeout: " + timeOut);
				flushDBMSCache();
				Main._logger.outputLog("Finish Flushing DBMS Cache");

				System.out.println("query: " + rsql);
				_pStmt.setQueryTimeout(timeOut);
				System.out.println("executing ... at " + card);
				long startTime = System.currentTimeMillis();
				_pStmt.executeQuery();
				long endTime = System.currentTimeMillis();
				System.out.println(i + " the execution done : "
						+ (endTime - startTime) + "(ms)");
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		try {
			_pStmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			_connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			_statement.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ts.close();
	}

	private void flushDBMSCache() {
		try {
			Process p = Runtime.getRuntime().exec("/usr/tdbms/bin/fsuflusher");
			p.waitFor();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}