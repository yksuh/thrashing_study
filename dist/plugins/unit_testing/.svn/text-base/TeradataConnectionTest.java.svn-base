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


import java.sql.*;

import plugins.TeradataSubject;

public class TeradataConnectionTest {
	public static void main2(String[] args) {
		System.out.println("Initialize"); //172.16.236.128
		TeradataSubject ts = new TeradataSubject("dbc", "dbc", "jdbc:teradata://172.16.236.128/TMODE=ANSI,CHARSET=UTF8", "172.16.236.128");
		System.out.println("Init subject tables");
		//ts.installExperimentTables(myDataDef, myPrefix)
		System.out.println("open");
		ts.open(false);
			/* @mjseo!
			 * Getter method test
			 */
			System.out.println(ts.getDBVersion());
			System.out.println(ts.getDBMSDriverClassName());
			System.out.println(ts.getDBMSName());
//			System.out.println(TeradataSubject.getExperimentSubjectName());
			
			/*
			ResultSet rs = null;
			try {
				ts._statement.execute("database sysadmin;");
			} catch (SQLException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			try {
				rs = ts._statement.executeQuery("select * from test;");
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			try {
				if(rs.next())
					System.out.println(rs.getString(1));
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			*/
			
			// TODO clone table test
			//ts.cloneTable("test4", "test");
			
			// TODO get table info
//			ts.printTableStat("test3");
			//ts.dropAllInstalledTables();
			
			
			
			try {
				ts.getQueryPlan("select * from test;");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// TODO begin testing
			
			
		System.out.println("close");
		ts.close();
		
		
	}	
	public static void main(String[] args) throws ClassNotFoundException {
		// Setting up Teradata Type 4 JDBC Driver URL
		// 172.16.236.128 is virtual machine on Vmplayer
		System.out.println("'Test connection for TeradataSubject");
		String url = "jdbc:teradata://172.16.236.128/TMODE=ANSI,CHARSET=UTF8";
		try {
			// We load the Teradata Driver
			Class.forName("com.teradata.jdbc.TeraDriver");
			// We try to connect to the Teradata database specified in the URL
			// using userid/password.
			System.out.println("We are now connecting to " + url);
			Connection con = DriverManager.getConnection(url, "dbc", "dbc");
			System.out.println("Connection is made successfully.");
			Statement _statement = con.createStatement();
			
			try {
				//_statement.execute("Database sysadmin;");
				
				 
						_statement.executeUpdate("database sysadmin;");	
						//ResultSet rs =	_statement.executeQuery("explain in xml SELECT SUM(t3.id4) FROM ft_HT1 t1, ft_HT4 t2, ft_HT3 t3, ft_HT1 t0 WHERE (t1.id2=t2.id1 AND t2.id1=t3.id2 AND t3.id2=t0.id1)");
						ResultSet rs =	_statement.executeQuery("explain in xml SELECT * from test;");
				if (rs != null) {
					rs.next();
					String ver = rs.getString(1);
					System.out.println(ver);
				}
				System.out.println(rs.getString(1));;
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println("Exception");
			}
			
			con.close();
			System.out.println("You're now disconnected.");
		} catch (SQLException ex) {
			ex.printStackTrace();
			System.out.println("Teradata JDBC test failed.");
		}
	}
}
