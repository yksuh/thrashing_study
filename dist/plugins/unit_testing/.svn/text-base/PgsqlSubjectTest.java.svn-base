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
package plugins.unit_testing;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.Test;

import azdblab.executable.Main;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableNode;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;

import plugins.PgsqlSubject;
import plugins.TeradataSubject;

public class PgsqlSubjectTest {
	private static Connection _connection;
	private static Statement _statement;
//	private static String user_name = "azdblab_user";
//	private static String password = "azdblab_user";
//	private static String connect_string = "jdbc:postgresql://sodb11.cs.arizona.edu:5432/research";
	private static String user_name = "dataware";
	private static String password = "dataware";
	private static String connect_string = "jdbc:postgresql://sodb7.cs.arizona.edu:5432/dataware";
	private static String machineName = "sodb7.cs.arizona.edu";
	private static String DBMS_DRIVER_CLASS_NAME = "org.postgresql.Driver";	
	private static String sql  = "SELECT t0.id2, SUM(t0.id1)  FROM ft_HT3 t1, ft_HT1 t0  WHERE  (t1.id4=t0.id3)  GROUP BY t0.id2";
	private static String lsql = "SELECT t0.id3, t2.id4, t2.id2, SUM(t1.id4) FROM ft_lHT1 t2, ft_HT4 t3, ft_lHT1 t0, ft_HT3 t1 WHERE (t2.id2=t3.id4 AND t3.id4=t0.id3 AND t0.id3=t1.id4) GROUP BY t0.id3, t2.id4, t2.id2";
	private static String rsql = "SELECT t0.id2, SUM(t0.id1)  FROM ft_HT3 t1, ft_rHT1 t0  WHERE  (t1.id4=t0.id3)  GROUP BY t0.id2";
	
	private static String varTableName = "HT1";
	private static String prefix = "ft_";
	private static String orgTable = prefix + varTableName;
	private static String lTable = "l" + varTableName;
	private static String rTable = "r" + varTableName;
	private static String cloneMaxTableName = "clone_max_" + orgTable;
	private static PgsqlSubject pgsql = null;
	
	/**
	 * Replace the even/odd state table name by the original variable table name.
	 * 
	 * @param node the root node
	 * @return the sequence of traversed <code>PlanNode</code> according to
	 *         pre-order.
	 */
	private void restoreVarTableName(PlanNode node, String search, String replacement) {
		if (node instanceof TableNode) {
			String tableName = ((TableNode) node).getTableName();
			Pattern p = Pattern.compile(search, Pattern.CASE_INSENSITIVE);
			Matcher m = p.matcher(tableName);
			tableName = m.replaceAll(replacement);
	        ((TableNode) node).setTableName(tableName);
		} else {
			int numchild = ((OperatorNode) node).getChildNumber();
			for (int i = 0; i < numchild; i++) {
				restoreVarTableName(((OperatorNode) node).getChild(i), search, replacement);
			}
		}
	}
	
	@Test
	public void testCloneTableStringStringLong() {
		try {
			 Class.forName(DBMS_DRIVER_CLASS_NAME);
			 _connection = DriverManager.getConnection(connect_string, user_name, password);
		     _connection.setAutoCommit(false);
		     _statement = _connection.createStatement();
		     pgsql = new PgsqlSubject(user_name, password, connect_string, machineName);
		     pgsql.SetConnection(_connection);
		     pgsql.SetStatement(_statement);
		     System.out.println("test completion");
		     System.exit(0);
//		     _statement.setQueryTimeout(1000);
//		     System.out.println("timeout: " + _statement.getQueryTimeout());
		     long card = 2000000;
		    
		    int col_len = 4;
			Column[] columns = new Column[col_len];
			for (int j = 1; j <= col_len; j++) {
				columns[j - 1] = new Column("id" + j);
			}
			
		    // create clone table
		    Table leftTable, rightTable;
			leftTable = new Table(lTable, prefix, 0, 0, 0, 0, columns);
			rightTable = new Table(rTable, prefix, 0, 0, 0, 0, columns);

			PlanNode plan = null;
			String statePrefix = "l";
			long[] leftCards = { 2000000 };
			for (int i = 0; i < leftCards.length; i++) {
				card = leftCards[i];
				pgsql.copyTable(leftTable.table_name_with_prefix, cloneMaxTableName, card);
				pgsql.updateTableStatistics(leftTable);
				pgsql.commit();
				try {
					plan = pgsql.getQueryPlan(lsql);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				System.out.println("org plan: " + plan.toString());
				restoreVarTableName(plan, (leftTable.table_name_with_prefix).toUpperCase(), (orgTable).toUpperCase());
				System.out.println("restored plan: " + plan.toString());
				restoreVarTableName(plan, (orgTable).toUpperCase(), (leftTable.table_name_with_prefix).toUpperCase());
				System.out.println("org plan: " + plan.toString());
				
//				System.out.println("restored plan: " + plan.toString());
//				restoreVarTableName(plan, prefix+"l"+varTableName, leftTable.table_name_with_prefix);
//				System.out.println("org plan: " + plan.toString());
			}

//			long[] rightCards = { 1990000 };
//			statePrefix= "r";
//			for (int i = 0; i < rightCards.length; i++) {
//				card = rightCards[i];
//				pgsql.copyTable(rightTable.table_name_with_prefix, cloneMaxTableName, card);
//				pgsql.updateTableStatistics(rightTable);
//				pgsql.commit();
//				try {
//					plan = pgsql.getQueryPlan(rsql);
//				} catch (SQLException e) {
//					// TODO Auto-generated catch block
//					e.printStackTrace();
//				}
//				System.out.println("org plan: " + plan.toString());
//				restoreVarTableName(plan, prefix+statePrefix, prefix);
//				System.out.println("restored plan: " + plan.toString());
//				restoreVarTableName(plan, prefix, prefix+statePrefix);
//				System.out.println("org plan: " + plan.toString());
//			}

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
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
