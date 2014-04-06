package plugins.unit_testing;

import static org.junit.Assert.*;

import org.junit.Test;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringReader;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.regex.Pattern;

import oracle.jdbc.OracleResultSet;
import oracle.sql.CLOB;

import org.junit.Test;

import plugins.OracleSubject;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.OperatorNode;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.TableNode;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.User;

public class LabShelfServerTest {
	private static Connection _connection;
	private static Statement _statement;
//	private static String user_name = "azdblab_6_0";
//	private static String password = "azdblab_6_0";
	private static String user_name = "azdblab_soc";
	private static String password = "azdblab_soc";
	
	private static String connect_string = "jdbc:oracle:thin:@sodb7.cs.arizona.edu:1521:notebook";
	private static String DBMS_DRIVER_CLASS_NAME = "oracle.jdbc.driver.OracleDriver";
//	private static String lsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_lHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";  
//	private static String rsql = "SELECT t0.id1, t0.id2, t0.id3, SUM(t0.id4)  FROM ft_rHT1 t0  GROUP BY t0.id1, t0.id2, t0.id3";	
	private static String sql = "SELECT t3.id2, t0.id4, t3.id1, SUM(t1.id2) FROM ft_HT4 t1, ft_HT1 t0, ft_HT4 t2, ft_HT4 t3 WHERE (t1.id4=t0.id4 AND t0.id4=t2.id1 AND t2.id1=t3.id3) GROUP BY t3.id2, t0.id4, t3.id1";

	public void commit() {
	    try {
	      if (_connection != null && !_connection.isClosed())
	        _connection.commit();
	    } catch (SQLException e) {
	      Main._logger.reportError("Commit failed");
	      //e.printStackTrace();
	    }
	}
	
	/**
	 * This helper method returns a string from the specified clob.
	 * 
	 * @param clob
	 * @return
	 * @throws Exception
	 */
	public static String getStringFromClob(ResultSet rs, int colIdx) throws Exception {
		Clob clob = ((OracleResultSet) rs).getCLOB(colIdx);
		BufferedReader reader = new BufferedReader(new InputStreamReader(clob.getAsciiStream()));
		
//		char[] byteArray = new char[(int)clob.length()];
//		reader.read(byteArray);
//		for(int i=0;i<byteArray.length;i++)
//			System.out.format("%x", (byte)byteArray[i]);
		
		StringBuilder sb = new StringBuilder();
		String line = null;
		while ((line = reader.readLine()) != null)
		  	sb.append(line + "\n");
		return sb.toString();
	}
	
	public static void updateClobAsString(Connection conn,
										  String plan_id, 
										  String content) {
	     PreparedStatement prepStmt = null;
	     ResultSet rs = null;
	     try {
	        prepStmt = conn.prepareStatement("UPDATE azdblab_plan SET xmldocument = ? WHERE planid =" + plan_id);
	        prepStmt.setString(1,content);
//	        prepStmt.setClob(1,content);
	        prepStmt.execute();
	     } 
	     catch(Exception sqlEx) {
	        sqlEx.printStackTrace();
	     }
	  }
	
	private String visitNode2(PlanNode node) {
		if (node instanceof TableNode) {
			return ((TableNode) node).getTableName();
		} else {
			int numchild = ((OperatorNode) node).getChildNumber();
			String strnodes = "";
			for (int i = 0; i < numchild; i++) {
				strnodes += visitNode(((OperatorNode) node).getChild(i)) + "  ";
			}
			String operatorName = ((OperatorNode) node).getOperatorName();
			return (strnodes + "  " + operatorName);
		}
	}

	private String visitNode(PlanNode node) {
		if (node instanceof TableNode) {
			return ((TableNode) node).getTableName();
		} else {
			int numchild = ((OperatorNode) node).getChildNumber();
			if(numchild == 1){
				((OperatorNode) node).setOperator("ALL:Full Table Scan");
			}else{
				((OperatorNode) node).setOperator("ALL:Full Table Scan with Join");
			}
			
			String strnodes = "";
			for (int i = 0; i < numchild; i++) {
				strnodes += visitNode(((OperatorNode) node).getChild(i)) + "  ";
			}
			String operatorName = ((OperatorNode) node).getOperatorName();
			return (strnodes + "  " + operatorName);
		}
	}
	
//	@test
	public void testGetQueryPlan() {
//		fail("Not yet implemented");
		try {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
		    
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
			Connection conn = DriverManager.getConnection(connect_string, user_name, password);
			conn.setAutoCommit(false);
			Statement stmt = conn.createStatement();
		    
			ResultSet rs = stmt.executeQuery("select proc_diff from AZDBLab_NewAlgRunResult2 where runid = 5312 and iternum = 144");
			rs.next();
			String line = getStringFromClob(rs, 1);
			System.out.println(line);
		}
		catch(Exception e){
		}
	}
	
		 
	
	
	//@Test
	public void testGetQueryPlan2() {
//		fail("Not yet implemented");
		try {
			Main.setAZDBLabLogger(Constants.AZDBLAB_EXECUTOR);
		    Class.forName(DBMS_DRIVER_CLASS_NAME);
//		    _connection = DriverManager.getConnection(connect_string, user_name, password);
//		    _connection.setAutoCommit(false);
//		    _statement = _connection.createStatement();
//		    OracleSubject ora = new OracleSubject(user_name, password, connect_string);
//		    ora.SetConnection(_connection);
//		    ora.SetStatement(_statement);
		    
//		    String[] labshelves = {"azdblab_5_19", "azdblab_5_20", "azdblab_5_3", "azdblab_6_0"};
//		    String[] labshelves = {"azdblab_6_0"};
		    String[] labshelves = {"azdblab_soc"};
			for(int i=0;i<labshelves.length;i++){
				String labShelfUser     = labshelves[i];
				String labShelfPassword = labshelves[i];
				Class.forName(DBMS_DRIVER_CLASS_NAME);
				Connection conn = DriverManager.getConnection(connect_string, labShelfUser, labShelfPassword);
				conn.setAutoCommit(false);
				Statement stmt = conn.createStatement();
				
				String sql = "select procdiff from azdblab_newalgrunresult2 where algrunid = 5692 and iternum IN (535)";
				ResultSet rs = stmt.executeQuery(sql);
				rs.next();
				String str = getStringFromClob(rs, 1);
				System.out.println(str);
				rs.close();
				stmt.close();
				conn.close();
//				PlanNode rootNode = User.getUser(strUserName).getNotebook(
//						strNotebookName).getExperiment(strExpName).getRun(
//						strStartTime).getQuery(iQueryNum)
//						.getPlan(queryExecutionNum);
//				if (node instanceof TableNode) {
//
//					if (o == null) { // this plan only contains a single table
//						tree.add(v);
//					}
//					return;
//
//				} else if (node instanceof OperatorNode) {
//					int chnum = ((OperatorNode) node).getChildNumber();
//					for (int j = 0; j < chnum; j++) {
//						PlanNode tmpnode = ((OperatorNode) node).getChild(j);
//						buildTree(tmpnode, tree, verticies);
//					}
//
//				}
				
//				String sql = "select distinct qp.planID, qe.QUERYEXECUTIONNUMBER from AZDBLAB_QUERYEXECUTIONHASPLAN qp, AZDBLAB_QUERYEXECUTION qe where qe.queryid = "
//						+ queryID
//						+ " and qe.queryexecutionid = qp.queryexecutionid order by qe.QUERYEXECUTIONNUMBER asc ";

				
//				Vector<Long> planIDVec = new Vector<Long>();
//				
//				String query =  "SELECT distinct qp.planid " +
//								"FROM azdblab_query q, azdblab_queryexecution qe, azdblab_queryexecutionhasplan qep, azdblab_plan qp " +
//								"WHERE q.runid IN (611, 614) " +
//								"and q.queryid = qe.queryid "  +
//								"and qe.queryexecutionid = qep.queryexecutionid " +
//								"and qep.planid = qp.planid " +
//								"order by qp.planid";
//				ResultSet rs = stmt.executeQuery(query);
//				while(rs.next()){
//					planIDVec.add(rs.getLong(1));
//				}
//				
//				String 				columnName 		= "PlanTree";
//				String[] 			columnNames		= new String[] { "PlanID" };
//				int[] 				dataTypes 		= new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER };
//
//				for(int j=0;j<planIDVec.size();j++){
//					long planID = (planIDVec.get(j)).longValue();
//					String[] 			columnValues 	= new String[] { String.valueOf(planID) };
//					InputStream finStream = LabShelfManager.getShelf().getDocument(Constants.TABLE_PREFIX + "temp_plan",
//									columnName, columnNames, columnValues, dataTypes);
//					PlanNode			planNode		= null;
//					try {
//						planNode	= (PlanNode)PlanNode.loadPlanNode(finStream);
//						visitNode(planNode);
//						visitNode2(planNode);
//						// update plan
//					} catch (Exception ex) {
//						ex.printStackTrace();
//					}
//					
////					File	planFile	= File.createTempFile("plantree", "plan");
////					planFile.deleteOnExit();
////					FileOutputStream	foutStream	= new FileOutputStream(planFile);
////					PlanNode.savePlanNode(planNode, foutStream);
////					foutStream.close();
////					FileInputStream		newFinStream	= new FileInputStream(planFile);
////					LabShelfManager.getShelf().updateDocument(Constants.TABLE_PREFIX + "temp_plan",
////							columnName, columnNames, columnValues, dataTypes, newFinStream);
////					LabShelfManager.getShelf().commitlabshelf();
//				}
				
//				// Retrieve the case history for incident 71164
//				Statement stmt = conn.createStatement();
//				ResultSet rs = stmt.executeQuery (
//				"select CaseHistory from Cases where IncidentID=71164");
//
//				rs.next(); // position to the row
//				Blob data = rs.getClob (1); // populate our Blob object with the data
//				Rs.close();
//
//				// now let's insert this history into another table
//				stmt.setClob (1, data); 
//				// data is the Clob object we retrieved from the history table
//
//				int InsertCount = stmt.executeUpdate (
//
//				"insert into AZDBLAB_PLAN (IncidentID, CaseHistory, Owner)"
//				+ " Values (71164, ?, 'Goodson') ");

			}
		    
//			String sql2 = "SELECT " + strProcDiffCol + " FROM " + resTblName + " WHERE algRunID = 121 and dataNum= 1 and iterNum=238";
//		    ResultSet rset2 = _statement.executeQuery(sql2);
//		    rset2.next();
//		    try {
//		    	String clobStr = rset2.getString(1);
//		    	Vector<ProcessInfo> piVec = parseProcDiff(clobStr);
//		    	for(int i=0;i<piVec.size();i++){
//		    		String insertSQL = "INSERT INTO " + createAlgRunResProcInfoTblSQL + " VALUES ";
//		    			   insertSQL += "('" + qSetNum + "'," + queryNum + ",'" + dbms + "'," + subOpt + ")";
//		    	}
//			} catch (Exception e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		    rset2.close();
		    
		    
//		    String suboptTotalTable    = "Analysis_QWSO_Ver1";
//		    String analysisQuery = "SELECT * " +
//		    					   "FROM " + suboptTotalTable + " " +
//		    					   "ORDER BY QSETNUM asc, QUERYNUM asc, DBMS asc";
//		    
//		    String[] labshelves = {"azdblab_5_19", "azdblab_5_20", "azdblab_5_3"};
//		    for(int i=0;i<labshelves.length;i++){
//			    String labShelfUser     = labshelves[i];
//			    String labShelfPassword = labshelves[i];
//		        Class.forName(DBMS_DRIVER_CLASS_NAME);
//			    Connection conn = DriverManager.getConnection(connect_string, labShelfUser, labShelfPassword);
//			    conn.setAutoCommit(false);
//			    Statement stmt = conn.createStatement();
//			    
//			    ResultSet rs = stmt.executeQuery(analysisQuery);
//			    int count = 0;
//			    while(rs.next()){
//			    	String qSetNum = rs.getString(1);
//			    	int queryNum = rs.getInt(2);
//	//		    	int runID = rs.getInt(3);
//			    	String dbms = rs.getString(3);
//			    	int subOpt = rs.getInt(4);
//			    	
//			    	String insertSQL = "INSERT INTO " + suboptTotalTable + " VALUES ";
//			    	insertSQL += "('" + qSetNum + "'," + queryNum + ",'" + dbms + "'," + subOpt + ")";
//	//		    	insertSQL += "('" + qSetNum + "'," + runID + "," + queryNum + ",'" + dbms + "'," + subOpt + ")";
//	System.out.print(insertSQL);
//					_statement.executeUpdate(insertSQL);
//					count++;
//	System.out.print(" done : " + count + "!\n");
//			    }
//			    stmt.close();
//			    conn.close();
//			    _connection.commit();
//		    }
		  
//		    _connection.close();
//		    _statement.close();
		    					   
 //		    String psdiff = "Number of Runs: [00001(init,	min_flt:0000003050 to 0000003056 = 6,	maj_flt:0000000060 to 0000000065 = 5);24814(fsustart,	min_flt:0000045195 to 0000046068 = 873,	maj_flt:0000000222 to 0000000247 = 25,	sTime  :0000006379 to 0000006421 = 42);14128(gnome-power-man,	min_flt:0000002092 to 0000002100 = 8,	maj_flt:0000000275 to 0000000277 = 2);14129(gnome-volume-ma,	min_flt:0000004975 to 0000005019 = 44,	maj_flt:0000000154 to 0000000164 = 10); 24820(fsustart,	min_flt:0000043347 to 0000044279 = 932,	maj_flt:0000000258 to 0000000259 = 1, sTime  :0000006328 to 0000006350 = 22);24718(tvsa_agent,	min_flt:0000002902 to 0000002917 = 15,	maj_flt:0000000173 to 0000000179 = 6);15004(java,	min_flt:0013582824 to 0013686119 = 103295,	maj_flt:0000180412 to 0000185079 = 4667,	uTime  :0000009825 to 0000009834 = 9,	sTime  :0000011570 to 0000011643 = 73);24709(tvsaallocator,	min_flt:0000011004 to 0000011116 = 112,	maj_flt:0000001356 to 0000001384 = 28,	sTime  :0000000140 to 0000000141 = 1);24707(tvsaallocator,	min_flt:0000011144 to 0000011155 = 11,	maj_flt:0000001394 to 0000001398 = 4);14518(gnome-screensav,	min_flt:0000001335 to 0000001336 = 1,	maj_flt:0000000116 to 0000000117 = 1);03751(vmware-guestd,	min_flt:0000051933 to 0000052056 = 123,	maj_flt:0000000211 to 0000000231 = 20,	uTime  :0000000060 to 0000000061 = 1,	sTime  :0000000038 to 0000000039 = 1);02792(dbus-daemon,	min_flt:0000001351 to 0000001414 = 63,	maj_flt:0000000126 to 0000000135 = 9,uTime  :0000000038 to 0000000039 = 1,	sTime  :0000000024 to 0000000025 = 1);24337(X,	min_flt:0000793229 to 0000793591 = 362,	maj_flt:0000001367 to 0000001418 = 51,	uTime  :0000001029 to 0000001032 = 3,	sTime  :0000000446 to 0000000450 = 4);13667(gnome-session,	maj_flt:0000000201 to 0000000203 = 2);24364(master,	min_flt:0000001328 to 0000001355 = 27,	maj_flt:0000000125 to 0000000132 = 7);14197(intlclock-apple,	min_flt:0000016625 to 0000016626 = 1,	uTime  :0000000085 to 0000000086 = 1);24766(gtwgateway,	min_flt:0000517517 to 0000518029 = 512); 24999(disstart, 	min_flt:0000389358 to 0000389411 = 53,	maj_flt:0000007266 to 0000007317 = 51,	sTime  :0000000683 to 0000000684 = 1);13754(nautilus,	min_flt:0000041179 to 0000041248 = 69,	maj_flt:0000000524 to 0000000570 = 46,	uTime  :0000000312 to 0000000314 = 2,sTime  :0000000214 to 0000000216 = 2);13752(gnome-panel,	min_flt:0000242601 to 0000243791 = 1190,	maj_flt:0000000578 to 0000000587 = 9,	uTime  :0000000069 to 0000000070 = 1,	sTime  :0000000280 to 0000000281 = 1);13758(main-menu,	min_flt:0000025604 to 0000025815 = 211,	maj_flt:0000000926 to 0000000994 = 68,	sTime  :0000000232 to 0000000233 = 1);24260(nscd,	min_flt:0000001619 to 0000001646 = 27,	maj_flt:0000000309 to 0000000327 = 18);13740(metacity,	min_flt:0000006416 to 0000006631 = 215,	maj_flt:0000000290 to 0000000385 = 95,	sTime  :0000000013 to 0000000015 = 2);13718(gconfd-2,	min_flt:0000005180 to 0000005324 = 144,	maj_flt:0000000378 to 0000000431 = 53);14664(gnome-terminal,	min_flt:0000030947 to 0000031279 = 332,	maj_flt:0000002487 to 0000002678 = 191,	uTime  :0000000292 to 0000000294 = 2,	sTime  :0000000172 to 0000000179 = 7);13727(gnome-settings-,	min_flt:0000004997 to 0000005002 = 5,	maj_flt:0000000101 to 0000000104 = 3);24295(wfxrd,	min_flt:0000000765 to 0000000813 = 48,	maj_flt:0000000119 to 0000000134 = 15,	sTime  :0000000013 to 0000000014 = 1);13708(gpg-agent,maj_flt:0000000034 to 0000000035 = 1);13709(ssh-agent,	min_flt:0000000264 to 0000000271 = 7,	maj_flt:0000000053 to 0000000054 = 1);24850(actmain,	min_flt:0004919774 to 0004951274 = 31500,	maj_flt:0000003156 to 0000003188 = 32,	uTime  :0000152168 to 0000152437 = 269,sTime  :0000035511 to 0000035543 = 32);03331(hald-addon-stor,min_flt:0000000315 to 0000000316 = 1,	maj_flt:0000000015 to 0000000017 = 2);24847(actmain,	min_flt:0004901978 to 0004940565 =38587,	maj_flt:0000003527 to 0000003579 = 52,	uTime  :0000151838 to 0000152147 = 309,	sTime  :0000036068 to 0000036105 = 37);24843(bash,	min_flt:0000001369 to 0000001741 = 372,	maj_flt:0000000019 to 0000000037 = 18,	sTime  :0000000000 to 0000000001 = 1);02883(hald,	min_flt:0000008421 to 0000008599 = 178,	maj_flt:0000000276 to 0000000299 = 23,	sTime  :0000000029 to 0000000030 = 1);23950(slpd,	min_flt:0000000472 to 0000000494 = 22,	maj_flt:0000000050 to 0000000055 = 5);00225(kswapd0,	sTime  :0000003758 to 0000004161 = 403);13764(vmware-user,	min_flt:0000005201 to 0000005204 = 3,	maj_flt:0000000191 to 0000000197=6,uTime  :0000000428 to 0000000437 = 9,	sTime  :0000000184 to 0000000186 = 2);13766(zen-updater,	min_flt:0000007470 to 0000007472 = 2,	maj_flt:0000000453 to 0000000457 = 4,	uTime  :0000000028 to 0000000029 =1);17947(pickup,	min_flt:0000001155 to 0000001185 = 30,	maj_flt:0000000067 to 0000000070 =3);24225(portmgmt,	min_flt:0000000276 to 0000000288 = 12,	maj_flt:0000000023 to 0000000027 = 4);24236(ntpd,	min_flt:0000000990 to 0000000991 = 1,	maj_flt:0000000200 to 0000000201 = 1)]Started Processes:[26132(more,	min_flt    :0000000341,	maj_flt    :0000000012,	uTime      :0000000000,	sTime      :0000000001,	startTime  :0004223381)]Increased Ticks:[userModeTicks           :0000000028, lowPriorityUserModeTicks:0000000579, systemModeTicks         :0000000605,idleTaskTicks           :0000000008,ioWaitTicks             :0000002882,irq				  :0000000008, softirq            :0000000023]Phantom Processes:[57989 to 58029]";
//		    CLOB clob;
		    
//		    ora.OpenLabShelf();
//		    String columnNames[] = {"QueryExecutionID", "QueryID", "Phase", 
//		    		"queryExecutionNumber", "Cardinality", "ResultCardinality", "RunTime", "psdiff", "iterNum"
//		    };
//		    String columnValues[] = {"100000000", "1", "1", 
//		    		"0", "2000000", "0", "45776", psdiff, "4"
//		    };
//		    int columnDataTypes[] = {GeneralDBMS.I_DATA_TYPE_SEQUENCE, GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER, 
//		    		GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER, 
//		    		GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_CLOB, GeneralDBMS.I_DATA_TYPE_NUMBER
//		    };
//		    String tableName = Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTION;
//		    ora.insertQueryExecution(tableName, columnNames, columnValues, columnDataTypes);
		    
//		    String sql = "INSERT INTO AZDBLAB_QUERYEXECUTION(QueryExecutionID, QueryID, Phase, queryExecutionNumber, Cardinality, ResultCardinality, RunTime, psdiff, iterNum) VALUES (100000000, 1, 1, 0, 2000000, 0, 45776, empty_clob(), 4)";
//		    System.out.println(sql);
//		    _statement.executeUpdate(sql);
//		    
//		    sql = "SELECT * FROM AZDBLAB_QUERYEXECUTION WHERE QueryExecutionID=100000000";
//		    ResultSet rset = _statement.executeQuery(sql);
//		    rset.next();
//		    clob = ((OracleResultSet)rset).getCLOB(8);
//		    InputStream is = new ByteArrayInputStream(psdiff.getBytes());
//		    // opening an input stream to the file that will be uploaded.
//		    BufferedInputStream in = new BufferedInputStream(is);
//			// opening an output stream to the CLOB
//		    BufferedOutputStream out = new BufferedOutputStream(clob.getAsciiOutputStream());// clob.getAsciiOutputStream());
//		    int size = clob.getBufferSize();
//		    byte[] buffer = new byte[size];
//		    int length = -1;
//		    while ((length = in.read(buffer)) != -1)
//		    	out.write(buffer, 0, length);
//	    	in.close();
//	    	out.close();
		    
//		    ResultSet rs = _statement.executeQuery("select psdiff from AZDBLAB_QUERYEXECUTION where QueryExecutionID=13463");
//		    while(rs.next()){
//		    	clob = ((OracleResultSet) rs).getCLOB(1);
//		    	BufferedReader reader = new BufferedReader(new InputStreamReader(clob.getAsciiStream()));
//			    StringBuilder sb = new StringBuilder();
//			    String line = null;
//			    while ((line = reader.readLine()) != null) {
//			    	sb.append(line + "\n");
//			    }
//			    String txt = sb.toString();
//			    System.out.println("clob string2: " + txt);
//		    }
//		    rs.close();
//		    sql = "delete FROM AZDBLAB_QUERYEXECUTION WHERE QueryExecutionID=100000000";
//		    _statement.executeUpdate(sql);
//		    _statement.close();
//		    _connection.close();
//		    SimpleDateFormat creationDateFormater = new SimpleDateFormat(Constants.NEWTIMEFORMAT);
//		    String createDate = creationDateFormater.format(new Date(System.currentTimeMillis()));
//		    String dateQuery = "INSERT INTO scratch " + " VALUES (to_date('" + createDate + "', '" + Constants.DATEFORMAT + "'))";
//		    System.out.println(dateQuery);
//		    _statement.execute(dateQuery);
//		    String dateQuery2 = "select * from scratch where d = " + "to_date('" + createDate + "', '" + Constants.DATEFORMAT + "')";
//		    System.out.println(dateQuery2);
//		    ResultSet rs = _statement.executeQuery(dateQuery2);
//		    while(rs.next()){
//		    	Date dt = rs.getDate(1);
//		    	String creationDate = new SimpleDateFormat(Constants.NEWDATEFORMAT).format(dt);
//		    	System.out.println("creation date: " + creationDate);
//		    }
//		    
//		    String transactionTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(new Date(System.currentTimeMillis()));
//		    String tsQuery = "insert into scratch2 values (to_timestamp('" + transactionTime + "'" + ", '" + Constants.TIMESTAMPFORMAT + "'))";
//System.out.println(tsQuery);
//		    _statement.execute(tsQuery);
//		    
//		    String tsQuery2 = "select * from scratch2 where t = " + "to_timestamp('" + transactionTime + "', '" + Constants.TIMESTAMPFORMAT + "')";
//System.out.println(tsQuery2);
//		    rs = _statement.executeQuery(tsQuery2);
//		    while(rs.next()){
//		    	String startTime = new SimpleDateFormat(Constants.TIMEFORMAT).format(rs.getTimestamp(1));
//		    	System.out.println("start time: " + startTime);
//		    }
//		    _connection.commit();
		    
//		    _statement.close();
//		    _connection.close();
		    
//		    String lTable = "ft_HT1";
//		    String lCloneMaxTableName = "clone_max_" + lTable;
//		    
//		    long card = 2000000;
//		    ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(sql);
		    
//		    card = 760000;
//		    ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(sql);
		    
//			card = 2000000;
//			// create clone table
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//			card = 1990000;
//			ora.copyTable(rTable, rCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
//			
//			card = 1980000;
//			// create clone table
//			ora.copyTable(lTable, lCloneMaxTableName, card);
//			ora.updateTableStatistics(lTable);
//			ora.commit();
//			ora.getQueryPlan(lsql);
//			
//			card = 1970000;
//			ora.copyTable(rTable, rCloneMaxTableName, card);
//			ora.updateTableStatistics(rTable);
//			ora.commit();
//			ora.getQueryPlan(rsql);
			
//			String createTable = "CREATE TABLE " + oriTable + " (id1 NUMBER, id2 NUMBER, id3 NUMBER, id4 NUMBER)";
			
//			// create original table
//			if(ora.tableExists(oriTable)){
//				Main._logger.outputLog("table exists!");
//				ora.dropTable(oriTable);
//			}
//			Main._logger.outputLog("create: " + createTable);
//			_statement.executeUpdate(createTable);
//			
//			// create clone table
//			ora.copyTable(cloneMaxTableName, oriTable);
	        
			// populate clone table
//			long maximum_cardinality = 2000000;
//			long requested_cardinality = 1000000;
//			
//			int seed = 1999;
//			int columnnum = 4;
//			RepeatableRandom repRand = new RepeatableRandom(seed);
//			repRand.setMax(requested_cardinality);
//			String  strupdate  = "";
//	        for (long i = 0; i < maximum_cardinality; i++){
//	        	if ((i + 1) % 10000 == 0){
//	        		Main._logger.outputLog("\t Inserted " + (i + 1) + " Rows");
//	        		commit();
//	        	}
//				String  strdata  = "";
//				// Assume all data fields are of integer data type
//				for ( int j = 0; j < columnnum - 1; j++ ) {
//					if (j == columnnum - 2) {
//						strdata  += repRand.getNextRandomInt();
//					} else {
//						strdata  += repRand.getNextRandomInt() + ",";
//					}
//				}
//				strupdate = "INSERT INTO " + cloneMaxTableName + " VALUES(" + i + "," + strdata + ")";
//				_statement.executeUpdate(strupdate);
//	        }
//			commit();
//			
//			// oracle's cloning
//			Main._logger.outputLog("cloning starts ... ");
//			ora.copyTable(oriTable, cloneMaxTableName, requested_cardinality);
//			Main._logger.outputLog("cloning is done ... ");
//			commit();
//			
//			ora.printTableStat(oriTable);
//			
//			// clone statistics
//			// oracle's cloning
//			// first, populate with 2M rows.
//			ora.copyTable(oriTable, cloneMaxTableName);
//			Main._logger.outputLog("1M rows' deletion starts");
//			// next, delete 1M rows.
//			ora.updateTableCardinality(oriTable, requested_cardinality, maximum_cardinality);
//			Main._logger.outputLog("1M rows' deletion is done");
//			commit();
			
//			// print stat
//			ora.printTableStat(oriTable);
//			
//			// print stat
//			ora.printTableStat(sh_oriTable);
		    
//		    _statement.executeUpdate(sql2);
//		    ora.initializeSubjectTables();
//		    ora.updateTableCardinality("FT_HT1", 1150000, 2000000);
//		    PlanNode y = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.15M: " + y.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 1000000, 2000000);
//		    PlanNode x = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1M: " + x.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 2000000, 2000000);
//		    PlanNode o = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 2M: " + o.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1200000, 2000000);
//		    PlanNode a = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.20M:  " + a.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 1150000, 2000000);
//		    PlanNode f = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.15M: " + f.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1140000, 2000000);
//		    PlanNode g = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.14M: " + g.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1100000, 2000000);
//		    PlanNode b = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.10M: " + b.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1010000, 2000000);
//		    PlanNode c = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.01M: " + c.myHashCode());
////		    
//		    ora.updateTableCardinality("FT_HT1", 1005000, 2000000);
//		    PlanNode d = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1.005M: " + d.myHashCode());
//		    
//		    ora.updateTableCardinality("FT_HT1", 1000000, 2000000);
//		    PlanNode z = ora.getQueryPlan(sql);
//		    Main.defaultLogger.logging_normal("at 1M: " + z.myHashCode());
		} catch (SQLException sqlex) {
//			Main.defaultLogger.logging_normal("exception: " + sql2);
		    sqlex.printStackTrace();
		    
		} catch (ClassNotFoundException e) {
		    e.printStackTrace();
		    System.exit(1); 
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
}