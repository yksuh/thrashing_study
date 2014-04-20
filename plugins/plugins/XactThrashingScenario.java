package plugins;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.TimerTask;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.ScenarioBasedOnTransaction;

/**
 * We study DBMS thrashing
 * 
 * @author yksuh
 *
 */

public class XactThrashingScenario extends ScenarioBasedOnTransaction {
	public static final boolean refreshTable = true;
	
	public XactThrashingScenario(ExperimentRun expRun) {
		super(expRun);
		// TODO Auto-generated constructor stub
		installTables();
	}


	/****
	 * Get tables to be installed for this thrashing study
	 * @return
	 */
	public Vector<InternalTable> getTables() {
		if (refreshTable) {
			LabShelfManager.getShelf().dropTable(BATCHSET.TableName);
			LabShelfManager.getShelf().dropTable(BATCHSETHASPARAMETER.TableName);
			LabShelfManager.getShelf().dropTable(BSSATISFIESASPECT.TableName);
			LabShelfManager.getShelf().dropTable(BATCH.TableName);
			LabShelfManager.getShelf().dropTable(CLIENT.TableName);
			LabShelfManager.getShelf().dropTable(TRANSACTION.TableName);
			LabShelfManager.getShelf().dropTable(STATEMENT.TableName);
			LabShelfManager.getShelf().dropTable(BATCHHASRESULT.TableName);
			LabShelfManager.getShelf().dropTable(CLIENTHASRESULT.TableName);
			LabShelfManager.getShelf().dropTable(TRANSACTIONHASRESULT.TableName);
			LabShelfManager.getShelf().dropTable(STATEMENTHASRESULT.TableName);
		}

		Vector<InternalTable> toRet = new Vector<InternalTable>();
		toRet.add(BATCHSET);
		toRet.add(BATCHSETHASPARAMETER);
		toRet.add(BSSATISFIESASPECT);
		toRet.add(BATCH);
		toRet.add(CLIENT);
		toRet.add(TRANSACTION);
		toRet.add(STATEMENT);	
		toRet.add(BATCHHASRESULT);
		toRet.add(CLIENTHASRESULT);
		toRet.add(TRANSACTIONHASRESULT);
		toRet.add(STATEMENTHASRESULT);
		return toRet;
	}
	
	/***
	 * Creates sequence for some tables
	 * @param seqName	sequence name
	 * @throws Exception 
	 */
	private void createSequence(String seqName, int startNum) throws Exception {
		String createSequence = "CREATE SEQUENCE " + seqName + " START WITH "+ startNum +" NOMAXVALUE";
		Main._logger.outputLog(createSequence);
		LabShelfManager.getShelf().executeUpdateSQL(createSequence);
		Main._logger.outputLog(seqName + " Created");
	}
	
	/****
	 * Install tables for thrashing study
	 */
	private void installTables() {
		Vector<InternalTable> lstInternalTables = getTables();
		if (lstInternalTables == null) {
			return;
		}
		for (int i = 0; i < lstInternalTables.size(); i++) {
			InternalTable tmp = lstInternalTables.get(i);
			if (!LabShelfManager.getShelf().tableExists(tmp.TableName)) {
				LabShelfManager.getShelf().createTable(tmp.TableName,
						tmp.columns, tmp.columnDataTypes,
						tmp.columnDataTypeLengths, tmp.primaryKey,
						tmp.foreignKey);
				if(tmp.TableName.equalsIgnoreCase(Constants.TABLE_PREFIX+Constants.TABLE_BATCHSETHASPARAMETER)){
					String alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX+Constants.TABLE_BATCHSETHASPARAMETER 
							+ " MODIFY DBMSBufferCacheSize NUMBER(10, 2)";
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX+Constants.TABLE_BATCHSETHASPARAMETER 
							+ " MODIFY TransactionSize NUMBER(10, 2)";
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX+Constants.TABLE_BATCHSETHASPARAMETER 
							+ " MODIFY ExclusiveLockRatio NUMBER(10, 4)";
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX+Constants.TABLE_BATCHSETHASPARAMETER 
							+ " MODIFY EffectiveDBRatio NUMBER(10, 2)";
					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
				}
				if (tmp.strSequenceName != null) {
					try {
						createSequence(tmp.strSequenceName, 1);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}
	}
	
	/***
	 * Clients in a batch
	 */
	public Client[] clients;
	protected boolean timeOut = false;
	
	static class TransactionGenerator{
		private static double effectiveDBSz = 0;
		private static double selectivity = 0;
		
		/****
		 * Transaction number to transaction ID map
		 */
		private static HashMap<Long, Long> xactNumToIDMap = new HashMap<Long, Long>();
		/****
		 * Statement number to transaction ID map
		 */
		private static HashMap<Long, Long> stmtNumToIDMap = new HashMap<Long, Long>();
		
		/***
		 * Effective DB Size
		 */
		private static double effectiveDBSize = 0;
		/***
		 * Transaction Size 
		 */
		private static double xactSize = 0;
		/***
		 * eXclusive Locks 
		 */
		private static double xLocks = 0;
	
		/*** For target table. Used for FROM and UPDATE clause ***/
		private static RepeatableRandom repRandForTable  = new RepeatableRandom();
		/*** For update ***/
		private static RepeatableRandom repRandForSET    = new RepeatableRandom();
		private static RepeatableRandom repRandForWhereInUpdate = new RepeatableRandom();
		/*** For select ***/
		private static RepeatableRandom repRandForSELECT 	 	= new RepeatableRandom();
		private static RepeatableRandom repRandForWhereInSELECT = new RepeatableRandom();
		/*** Generating values to be updated ***/
		private static RepeatableRandom repRandForVal    = new RepeatableRandom();
		
		/****
		 * Get xact number to id map
		 * @return xactNumToIDMap
		 */
		public static HashMap<Long, Long> getXactNumToIDMap(){ 
			return xactNumToIDMap;
		}
		/****
		 * Get statment number to id map
		 * @return xactNumToIDMap
		 */
		public static HashMap<Long, Long> getStmtNumToIDMap(){ 
			return stmtNumToIDMap;
		}
	
		public static double getEffectiveDBRatio(){
			return effectiveDBSz;
		}
		
		public static double getSelectivity(){
			return selectivity;
		}
		
		/****
		 * Set transaction size (# of locks)
		 * @param xactSz
		 */
		public static void setXactSize(double xactSz) {
			xactSize = xactSz;
		}
		/****
		 * Set exclusive locks (# of locks)
		 * @param eXclusiveLocks 
		 */
		public static void setXLocks(double eXclusiveLockRatio) {
			xLocks = eXclusiveLockRatio;
		}
		
		/**
		 * Gets a random number greater than or equal to start and less than or
		 * equal to finish.
		 * 
		 * @param start
		 *            The lower bound for the random number.
		 * @param finish
		 *            The upper bound for the random number.
		 * @return The random number is returned.
		 */
		private static int getRandomNumber(RepeatableRandom rr, int start, int finish) {
			int range = finish - start;
			range++; // since Math.random never returns 1.0
			// int result = (int) ( range * Math.random() );

			// The cast to INT truncates, so we will get an integer between 0 and
			// (finish - start)
			int result = 0;
			result = (int) (range * rr.getNextDouble());
			// ensure range is from start to finish
			result += start;
			return result;
		}

		/***
		 * Set effective database size
		 * @param edb_size
		 */
		public static void setEffectiveDBSz(double edb_size) {
			effectiveDBSz = edb_size;
		}

		/*****
		 * Build SELECT clause for SELECT statement
		 * @param tbl a chosen tbl
		 * @return SELECT clause
		 */
		static String buildSELECTForSelect(Table tbl){
			String str = "SELECT ";
			// get number of columns
			int numCols = tbl.columns.length;
			Vector<String> colNamesVec = new Vector<String>();
			// copy column names
			for(int i=0;i<numCols;i++){
				colNamesVec.add(tbl.columns[i].myName);
			}
			// build projection list
			String strProjectionList = "";
			long numChosenCols  = (long)((double)getRandomNumber(repRandForSELECT, 1, numCols));
			for(int i=0;i<numChosenCols;i++){
				int idx = (int)((double)getRandomNumber(repRandForSELECT, 0, colNamesVec.size()-1));
				String colName = colNamesVec.get(idx);
				colNamesVec.remove(idx);
				strProjectionList = colName;
				if(i < numChosenCols-1){
					strProjectionList += ",";
				}
			}
			str += strProjectionList;
			return str;
		}

		/*****
		 * Build FROM clause for select statement
		 * @param tbl a chosen tbl
		 * @return FROM clause
		 */
		static String buildFROMForSelect(Table tbl){
			String str = "FROM ";
			str += tbl.table_name_with_prefix;
			return str;
		}
		
		/*****
		 * Build WHERE clause for SELECT
		 * @param tbl a chosen tbl
		 * @return WHERE clause
		 */
		static String buildWHEREForSelect(Table tbl){
			// control lock range with the first column
			String idxCol = "id1";
			// determine the number of requested locks using transaction size
			int numReqLocks = (int)(xactSize * (double)tbl.hy_min_card);
			// determine end range using effective db size
			int start = 0;
			// determine end range using effective db size
			int end = (int)((double)tbl.hy_min_card * effectiveDBSz);
			// compute low key
			loKey = (long)((double)getRandomNumber(repRandForWhereInSELECT, start, end-numReqLocks));
			// set high key
			hiKey = (loKey+numReqLocks);
			String str = "WHERE " + idxCol + " >= " + loKey + " and " + idxCol +" < " + hiKey;
			return str;
		}
		
		/****
		 * Get random string 
		 * @param size
		 * @return a random string
		 */
		public static String RandomAlphaNumericString(int size){
		    String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		    String ret = "";
		    int length = chars.length();
		    for (int i = 0; i < size; i ++){
		        ret += chars.split("")[ (int) (Math.random() * (length - 1)) ];
		    }
		    return ret;
		}

		/***
		 * randomly-generated low key for select
		 */
		private static long loKey = 0;
		/***
		 * randomly-generated high key for select
		 */
		private static long hiKey = 0;
		/****
		 * Transaction number
		 */
		private static long _xactNum;
		/***
		 * Reset keys 
		 */
		public static void resetKeys(){
			loKey = 0;
			hiKey = 0;
		}
		
		/***
		 * Construct update
		 * @param tbl
		 * @return
		 */
		static String buildUPDATEForUpdate(Table tbl){
			String str = "UPDATE ";
			str += tbl.table_name_with_prefix;
			return str;
		}

		/***
		 * Build SET clause for UPDATE
		 * @param tbl
		 * @return
		 */
		static String buildSETForUpdate(Table tbl){
			Column[] cols = tbl.columns;
			int chosenCol = getRandomNumber(repRandForSET, 0, cols.length-1);
			int newValue  = getRandomNumber(repRandForVal, 0, (int)tbl.hy_max_card);
			String colName = cols[chosenCol].myName;
			String str = "";
			// if integer column, set a random value
			if(colName.contains("val")){
				String newStrVal = RandomAlphaNumericString((int)cols[chosenCol].mySize);
				str += "SET " + colName + " = '" + newStrVal + "' ";	
			}else{
				str += "SET " + colName + " = " + newValue + " ";	
			}
			// otherwise, set a random string			
			return str;
		}
		/*****
		 * Assume that this gets invoked when xLocks are greater than zero
		 * @param tbl
		 * @return
		 */
		static String buildWhereForUpdate(Table tbl){
			// control lock range with the first column
			String idxCol = "id1";
			// low key for update
			long loKeyForUpdate = 0;
			// high key for update
			long hiKeyForUpdate = 0;
			if(xLocks == 1.0){
				// determine the number of requested locks using transaction size
				int numReqLocks = (int)(xactSize * (double)tbl.hy_min_card);
				// determine end range using effective db size
				int start = 0;
				// determine end range using effective db size
				int end = (int)((double)tbl.hy_min_card * effectiveDBSz);
				// compute low key
				loKeyForUpdate = (long)((double)getRandomNumber(repRandForWhereInUpdate, start, end-numReqLocks));
				// set high key
				hiKeyForUpdate = (loKeyForUpdate+numReqLocks);
			}else{
				// determine the number of requested locks using transaction size
				int numXLocks = (int)(((double)(xactSize * (double)tbl.hy_min_card))*xLocks);
				// determine end range using effective db size
				long start = loKey;
				// determine end range using effective db size
				long end = hiKey;
				loKeyForUpdate = (long)((double)getRandomNumber(repRandForWhereInUpdate, (int)start, (int)(end-numXLocks)));
				hiKeyForUpdate = (loKeyForUpdate+numXLocks);
			}
			String str = "WHERE " + idxCol + " >= " + loKeyForUpdate + " and " + idxCol +" < " + hiKeyForUpdate;
			return str;
		}
		
		/****
		 * Build transaction
		 * @param clientNum
		 * @return a list of SQL statements
		 */
		public static Vector<String> buildTransaction(long xactNum, int clientNum) {
			// vector for SQL statements for this transaction
			Vector<String> transaction = new Vector<String>();
			// randomly select a table
			int chosenTblNum = getRandomNumber(repRandForTable, 0, myXactTables.length-1);
			Table tbl = myXactTables[chosenTblNum];
			
			// build select clause
			String strSELECT = buildSELECTForSelect(tbl);
			// build from clause
			String strFROM = buildFROMForSelect(tbl);
			// build where clause
			String strWHERE = buildWHEREForSelect(tbl);
			// add this select statement in this transaction
			String strSQLStmt = String.format("%s\n%s\n%s", strSELECT, strFROM, strWHERE);
Main._logger.outputLog(strSQLStmt);
			transaction.add(strSQLStmt);
			// if exclusive lock ratio is greater than zero
			if(xLocks > 0){
				// construct update clause
				String strUPDATE = buildUPDATEForUpdate(tbl);
				// construct set clause
				String strSET 	 = buildSETForUpdate(tbl);
				// construct where clause
				String strWHERE2  = buildWhereForUpdate(tbl);
				// add this update statement in this transaction
				String strSQLStmt2 = String.format("%s\n%s\n%s", strUPDATE, strSET, strWHERE2);
Main._logger.outputLog(strSQLStmt2);
				transaction.add(strSQLStmt2);
			}
			// Insert this client's transaction and its statements while setting number to ID maps
			insertXactAndStmts(clientNum, xactNum, transaction);
			// Reset keys
			resetKeys();
			return transaction;
		}
		
		/****
		 * Insert transaction and statements, while setting the maps of transaction/statement number to ID
		 * @param clientID current client
		 * @param xactNum transaction number
		 * @param transaction transaction
		 */
		private static void insertXactAndStmts(int clientID, long xactNum, Vector<String> transaction) {
			// get transatin id
			int	xactID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_TRANSACTION);
			// add transaction
			try {
				LabShelfManager.getShelf().insertTuple(
							Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTION, 
							TRANSACTION.columns, 
							new String[] {
									String.valueOf(xactID),
									String.valueOf(clientID),
									String.valueOf(xactNum)
							},
							TRANSACTION.columnDataTypes);
				LabShelfManager.getShelf().commitlabshelf();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
Main._logger.outputLog(String.format("Client %d's transaction(%d)", clientID, xactNum));
			// add statement
			for(int stmtNum=0;stmtNum<transaction.size();stmtNum++){
				String strSQLStmt = transaction.get(stmtNum);
Main._logger.outputLog(strSQLStmt);
				// add statement
				try {
					int stmtID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_STATEMENT);
					LabShelfManager.getShelf().insertTuple(
								Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT, 
								STATEMENT.columns, 
								new String[] {
										String.valueOf(stmtID),    // statement ID
										String.valueOf(xactID),    // transaction ID
										String.valueOf(stmtNum),   // statement number
										String.valueOf(strSQLStmt) // statement SQL
								},
								STATEMENT.columnDataTypes);
					LabShelfManager.getShelf().commitlabshelf();
					// build statement number to ID map
					stmtNumToIDMap.put(new Long(stmtNum), new Long(stmtID));
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			// build transaction number to ID map
			xactNumToIDMap.put(new Long(xactNum), new Long(xactID));
			return;
		}
	}
	
	/****
	 * Build a client in a batch
	 * @author yksuh
	 *
	 */
	public class Client extends Thread{
		class TimeoutCloseThread extends TimerTask{
			public void run() {
		      try {
		    	  Main._logger.outputLog("\t>>Closing Client #"+_id+" is timeouted.");
		    	  
		    	  Main._logger.outputLog("\t>>Just return.");
		    	  this.cancel();
		      } catch (Exception ex) {
		      }
		    }
		  }
		
		private Connection _conn;
		private Statement _stmt;
		private String _sql;
		private int numTrans = 0;
//		private long _card = 30000;
		private int _id = 0;
		private String _driverName = "";
		private String _connStr = "";
		private String _userName = "";
		private String _password = "";
		private Vector<String> _transaction = new Vector<String>();
		private int _batchID   = 0; // batch ID for database
		private int _clientNum = 0; // this client's number
		private int _clientID = 0;  // this client ID for database
		private long _xactNum = 0;	// transaction number
		private HashMap<Long, Long> _xactNumToIDMap = new HashMap<Long, Long>();
		private HashMap<Long, Long> _stmtNumToIDMap = new HashMap<Long, Long>();
		private int _numXacts = 1;
		
		public Client(int batchID, int clientNum){
			_batchID = batchID;
			_clientNum = clientNum;
		}
			
		public int getBatchID(){
			return _batchID;
		}
		
		public int getClientNumber(){
			return _clientNum;
		}
		
		public int getClientID(){
			return _clientID;
		}
		
		public void close(){
//			TimeoutCloseThread tct = new TimeoutCloseThread();
//			Timer closeTimer = new Timer();
//			Main._logger.outputLog("\t>>Timer set for closing Client #"+_id);
//			closeTimer.scheduleAtFixedRate(tct, 10000, 10000);
			
			Main._logger.outputLog("\t>>Client #"+_id+" is being closed ... (" + numTrans+")");
			try {
				//System.out.println("DBMS: " + experimentSubject.getDBMSName());
//				try{
////Main._logger.outputLog("Statement is being canceled-Client #"+_id);
////					_stmt.cancel();
//Main._logger.outputLog("\tStatement is being closed-Client #"+_id);
//					_stmt.close();
//Main._logger.outputLog("\tDone with closing statement -Client #"+_id);
//				}catch(Exception ex){
//					if((ex.getMessage()).toLowerCase().contains("closed")){
//						_conn.commit();
//						_conn.close();
////						tct.cancel();
//						return;
//					}
//					if(ex.getMessage().toLowerCase().contains("no current connection"))				return;
//				}
//Main._logger.outputLog("Connection is being committed-Client #"+_id);
//				_conn.commit();
//Main._logger.outputLog("Connection is being closed-Client #"+_id);
				if(_conn != null)
					_conn.close();
Main._logger.outputLog("\tDone with closing connection -Client #"+_id);
//				tct.cancel();
			} catch (SQLException e) {
				//Main._logger.reportError(e.getMessage());
//				tct.cancel();
				return;
			}
		}
		
//		public void init(String drvName, String strConnStr, String strUserName, String strPassword, double edbSz){
////Main._logger.outputLog("login details: " + strConnStr + ", " + strUserName + ", " + strPassword);
//			try{
//				driverName=drvName; connStr=strConnStr; userName=strUserName; password=strPassword;
//				// Main._logger.outputLog("login details: " + strConnectString +  ", " +  strUserName + ", " + strPassword + ", " + strdrvname);
//				Class.forName(drvName);
//				_conn = DriverManager.getConnection(strConnStr, strUserName, strPassword);
////Main._logger.outputLog(experimentSubject.getDBMSName());
////				if(experimentSubject.getDBMSName().toLowerCase().contains("teradata")){
////					experimentSubject.open(false);
////				}
//				_stmt = _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
////				TransactionGenerator tg = new TransactionGenerator();
//				
//				/****
//				 * Ver2
//				 */
//				_sql = TransactionGenerator.buildDML();
//Main._logger.outputLog(_sql); // this should later be replaced by sql array
//				return;
//			} catch (SQLException | ClassNotFoundException sqlex) {
////				sqlex.printStackTrace();
////				Main._logger.outputLog("login details: " + strConnStr + ", " + strUserName + ", " + strPassword);
//			} 
////			catch (ClassNotFoundException e) {
////				e.printStackTrace();
////				System.exit(1); 
////			}
//		}
		
		/***
		 * Insert a client into AZDBLab
		 * @param clientNum client number
		 */
		private int insertClient() {
			// get client id
			int	clientID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_CLIENT);
			// insert this client
			try {
				LabShelfManager.getShelf().insertTuple(
							Constants.TABLE_PREFIX + Constants.TABLE_CLIENT, 
							CLIENT.columns, 
							new String[] {
									String.valueOf(clientID),
									String.valueOf(_batchID),
									String.valueOf(_clientNum)
							},
							CLIENT.columnDataTypes);
Main._logger.outputLog(String.format("Client %d in Batch %d has been inserted ", _clientNum, _batchID));
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return clientID;
		}
		
		public void init(String drvName, String strConnStr, String strUserName, String strPassword){
//Main._logger.outputLog("login details: " + strConnStr + ", " + strUserName + ", " + strPassword);
			try{
				_driverName=drvName; _connStr=strConnStr; _userName=strUserName; _password=strPassword;
				// Main._logger.outputLog("login details: " + strConnectString +  ", " +  strUserName + ", " + strPassword + ", " + strdrvname);
				Class.forName(drvName);
				_conn = DriverManager.getConnection(strConnStr, strUserName, strPassword);
				_stmt = _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
				// insert this client record into database
				_clientID  = insertClient();
				// generating transactions
				for(int i=0;i<_numXacts ;i++){
					_transaction  = TransactionGenerator.buildTransaction(i, _clientNum); // transaction 
					_xactNumToIDMap = TransactionGenerator.getXactNumToIDMap(); // ID associated with transaction number
					_stmtNumToIDMap = TransactionGenerator.getStmtNumToIDMap(); // ID associated with statement number
				}
				return;
			} catch (SQLException | ClassNotFoundException sqlex) {
//				sqlex.printStackTrace();
//				Main._logger.outputLog("login details: " + strConnStr + ", " + strUserName + ", " + strPassword);
			} 
		}
		
//		public void run(){
////			long starttime = System.currentTimeMillis();
//			while(true){
//				if(timeOut) break;
////			while(System.currentTimeMillis() - starttime < duration*1000){
////			boolean localTimeOut = false;
////			while(true){
//				try {
//					if(_conn == null){ 
//						Class.forName(_driverName);
//						_conn = DriverManager.getConnection(_connStr, _userName, _password);
//					}
//					// open a connection to an experiment subject
//					_conn.setAutoCommit(false);
//					_stmt = _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
//					if(experimentSubject.getDBMSName().toLowerCase().contains("teradata")){
//						_stmt.executeUpdate("DATABASE azdblab_user;");
//						_conn.commit();
//					}
//					// run transaction
//					for(int i=0;i<_transaction.size();i++){
//						_stmt.execute(_transaction.get(i));
//					}
//					_stmt.close();
//					_conn.commit();
//	//					synchronized(this){ // this variable could be accessed by multiple threads.
//	//						localTimeOut = timeOut;
//	//					}
//	//					if(!localTimeOut)
//					numTrans++;
//	//					else{
//	//						Main._logger.outputLog("time out >> Client #"+_id+"> # of total transactions: " + numTrans);
//	//						return;
//	//					}
//	//					if(numTrans%10000==0){
//	//						Main._logger.outputLog("Client #"+_id+"> # of current transactions: " + numTrans);
//	//					}
//				} catch (SQLException | ClassNotFoundException e) {
//					//e.printStackTrace();
////					String msg = e.getMessage().toLowerCase();
//////					Main._logger.outputLog("Client #"+_id+"> : " + msg);
////					// DB2: http://www-01.ibm.com/support/docview.wss?uid=swg21424265
////					//DB2 SQL Error: SQLCODE=-952, SQLSTATE=57014 SQL0952N Processing was cancelled due to an interrupt SQLSTATE=57014
////					if(msg.contains("cancel") // sqlserver 
////					|| msg.contains("closed") // oracle
////					||msg.contains("952") // db
////					||msg.contains("interrupt") // mysql
////					||msg.contains("i/o error") // for postgres
////					||msg.contains("no current connection") // for javadb
////					){  
////						//Main._logger.outputLog(msg);
//////						Main._logger.outputLog("Client #"+_id+"> # of total transactions: " + numTrans);
////						return;
////					}
////					else{
////						e.printStackTrace();
////						Main._logger.reportError("An unknown error happened. Retrying ... ");
////						if(!msg.contains("aborted") && !msg.contains("deadlock") && !msg.contains("row error")) 
////							Main._logger.reportError(e.getMessage());
////						break;
////						if(experimentSubject.getDBMSName().toLowerCase().contains("pgsql")){
////							if(msg.contains("aborted")){
////								continue;
////							}
////						}
//						continue;
////						System.exit(-1);
////					}
////					e.printStackTrace();
////					continue;
//				}
////				numTrans++;
////				if(numTrans%30==0){
////					Main._logger.outputLog("Client #"+_id+"> # of current transactions: " + numTrans);
////				}
//			}
//			close();
//			timeOut = false;
//			return;
//		}
		
		public void run(){
			Vector<Long> xactRunTimeVec = new Vector<Long>();
			Vector<Vector<Long>> stmtRunTimeVec = new Vector<Vector<Long>>();
			while(true){
				if(timeOut) break;
				try {
					// run time vector for each statement
					Vector<Long> stmtRunTimePerXactVec = new Vector<Long>();
					// open a connection to an experiment subject
					experimentSubject.open(false);
					long xactStartTime = System.currentTimeMillis();
					// run transaction
					for(int i=0;i<_transaction.size();i++){
						String sql = _transaction.get(i);
						// select
						long startTime = System.currentTimeMillis();
						experimentSubject.executeSQLStmt(sql);
						long elapsedTime = System.currentTimeMillis()-startTime;
						stmtRunTimePerXactVec.add(new Long(elapsedTime));
Main._logger.outputLog("SQL: " + sql + " => " + elapsedTime + " (msec)");
					}
					experimentSubject.commit();
					experimentSubject.close();
					long elapsedTime = System.currentTimeMillis()-xactStartTime;
					stmtRunTimeVec.add(stmtRunTimePerXactVec);
					xactRunTimeVec.add(new Long(elapsedTime));
Main._logger.outputLog("transaction " + _xactNum + " at " + numTrans + " => " + elapsedTime + " (msec)");
	//					synchronized(this){ // this variable could be accessed by multiple threads.
	//						localTimeOut = timeOut;
	//					}
	//					if(!localTimeOut)
					numTrans++;
	//					else{
	//						Main._logger.outputLog("time out >> Client #"+_id+"> # of total transactions: " + numTrans);
	//						return;
	//					}
	//					if(numTrans%10000==0){
	//						Main._logger.outputLog("Client #"+_id+"> # of current transactions: " + numTrans);
	//					}
				} catch (SQLException e) {
					//e.printStackTrace();
//					String msg = e.getMessage().toLowerCase();
////					Main._logger.outputLog("Client #"+_id+"> : " + msg);
//					// DB2: http://www-01.ibm.com/support/docview.wss?uid=swg21424265
//					//DB2 SQL Error: SQLCODE=-952, SQLSTATE=57014 SQL0952N Processing was cancelled due to an interrupt SQLSTATE=57014
//					if(msg.contains("cancel") // sqlserver 
//					|| msg.contains("closed") // oracle
//					||msg.contains("952") // db
//					||msg.contains("interrupt") // mysql
//					||msg.contains("i/o error") // for postgres
//					||msg.contains("no current connection") // for javadb
//					){  
//						//Main._logger.outputLog(msg);
////						Main._logger.outputLog("Client #"+_id+"> # of total transactions: " + numTrans);
//						return;
//					}
//					else{
//						e.printStackTrace();
//						Main._logger.reportError("An unknown error happened. Retrying ... ");
//						if(!msg.contains("aborted") && !msg.contains("deadlock") && !msg.contains("row error")) 
//							Main._logger.reportError(e.getMessage());
//						break;
//						if(experimentSubject.getDBMSName().toLowerCase().contains("pgsql")){
//							if(msg.contains("aborted")){
//								continue;
//							}
//						}
						continue;
//						System.exit(-1);
//					}
//					e.printStackTrace();
//					continue;
				}
//				numTrans++;
//				if(numTrans%30==0){
//					Main._logger.outputLog("Client #"+_id+"> # of current transactions: " + numTrans);
//				}
			}
			close();
			timeOut = false;
			
			// insert transaction results;
			for(int xactNum=0;xactNum<_numXacts;xactNum++){
				long xactID = _xactNumToIDMap.get(new Long(xactNum));
				for(int tIter=0;tIter<xactRunTimeVec.size();tIter++){
					try {
						LabShelfManager.getShelf().insertTuple( 
								Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT,
								BATCHHASRESULT.columns,
								new String[] {
										String.valueOf(xactID), 	// xact ID
										String.valueOf(tIter), 		// iterNum
										String.valueOf(xactRunTimeVec.get(tIter)) // xactRunTime
								},
								BATCHHASRESULT.columnDataTypes);
						LabShelfManager.getShelf().commit();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					// insert statement results 
					Vector<Long> stmtRunTimePerXact = stmtRunTimeVec.get(xactNum);
					if(stmtRunTimePerXact != null){
						for(int sIter=0;sIter<stmtRunTimePerXact.size();sIter++){
							Long stmtID = _stmtNumToIDMap.get(sIter);
							try {
								LabShelfManager.getShelf().insertTuple(Constants.TABLE_PREFIX+Constants.TABLE_STATEMENTHASRESULT, 
																	 STATEMENTHASRESULT.columns, 
																	 new String[]{
																		String.valueOf(xactID), 	// transactionID
																		String.valueOf(tIter), 		// transactionIterNum
																		String.valueOf(stmtID), 	// statement ID
																		String.valueOf(sIter), 		// statmentIterNum
																		String.valueOf(xactRunTimeVec.get(sIter)), // statementRunTime
																		null				 	// statementLockWaitTime
																	 },
																	 STATEMENTHASRESULT.columnDataTypes);
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}
				}
			}
		}
//		private long getStatementID(int stmtNum) {
//			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL("select stmtID " +
//					" from " + Constants.TABLE_PREFIX+Constants.TABLE_STATEMENT 
//					+ " where xactID = " + _xactID + " and stmtNum = " + stmtNum);
//			try {
//				rs.next();
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			long stmtID = -1;
//			try {
//				stmtID = rs.getInt(1);
//			} catch (SQLException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			return stmtID;
//		}
		
		public int getNumTransactions(){
			timeOut = true;
			return numTrans;
		}
	}

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_XACT_THRASHING_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_XACT_THRASHING_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}

	/*****
	 * Analyze a batch set
	 * @param batchSetID batch set ID
	 * @param transactionSize transaction size
	 * @param eXclusiveLocks exclusive locks
	 * @param effectiveDBSize effective DB size
	 * @param totalBatchSets number of batch sets
	 * @throws Exception
	 */
	@Override
	protected void analyzeBatchSet(int batchSetID, 
								   double transactionSize, 
								   double eXclusiveLocks, 
								   double effectiveDBSize,
								   int totalBatchSets) throws Exception {
		// run this batch set atomically
		// run as many clients as specified in MPL
		// have each client run its own transaction repeatedly
		for(int MPL=mplMin;MPL<=mplMax;MPL+=mplIncr){
			int batchID = -1;
			// get existing batchID if this is the case
			String sql = String.format("SELECT batchID FROM AZDBLAB_BATCH WHERE batchSetID = %d and MPL = %d", batchSetID, MPL);
			ResultSet rs =  LabShelfManager.getShelf().executeQuerySQL(sql);
			if(rs != null){
				rs.next();
				batchID = rs.getInt(1);
			}
			else{
				batchID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_BATCH);
			}
			Main._logger.outputLog(String.format("::: MPL=%s (batchID:%d) Test :::", MPL, batchID));
			
			// insert batch set parameter
			stepA(batchSetID, transactionSize, eXclusiveLocks, effectiveDBSize);
			
			// initialize this batch
			stepB(batchID, MPL, transactionSize, eXclusiveLocks, effectiveDBSize);
			
			// create transactions for each terminal
			stepC(batchID);
			
			Main._logger.outputLog(String.format(">> done", MPL, batchID));
		}
	}
	
	@Override
	protected void stepA(int batchSetID, double transactionSize, double exclusiveLockRatio, double effectiveDBRatio){
		// Now, let's insert parameter values into AZDBLab.
		String[] paramVal = new String[BATCHSETHASPARAMETER.columns.length];
		int i=0;
		paramVal[i++] = String.format("%d",   batchSetID);
		paramVal[i++] = String.format("%.2f", dbmsCacheBufferSize);
		paramVal[i++] = String.format("%d",   numCores);
		paramVal[i++] = String.format("%d",   mplIncr);
		paramVal[i++] = String.format("%d",   batchRunTime);
		paramVal[i++] = String.format("%.4f", transactionSize);
		paramVal[i++] = String.format("%.2f", exclusiveLockRatio);
		paramVal[i++] = String.format("%.2f", effectiveDBRatio);
		paramVal[i++] = String.format("%d", 0); // lock wait time
		paramVal[i++] = String.format("%d", 0); // was thrashed
		insertBatchSetParam(paramVal);
	}
	
	@Override
	protected void stepB(int batchID,
						 int MPL, double transactionSize, double eXclusiveLcks, double effectiveDBSize) throws Exception {
		recordRunProgress(0, "Beginning batch ("+ batchID + ") initialization (MPL=" + MPL + ")");
		// number of clients
		int numClients = MPL;
		// set transaction size
		TransactionGenerator.setXactSize(transactionSize);
		// set exclusive locks
		TransactionGenerator.setXLocks(eXclusiveLcks);
		// set effective db size
		TransactionGenerator.setEffectiveDBSz(effectiveDBSize);
		
		clients = new Client[numClients];
		for(int i=0;i<numClients;i++){
			// assign client number
			int clientNum = i+1;
			// ready for open connection
			String strDrvName = experimentSubject.getDBMSDriverClassName();
			String strConnStr = experimentSubject.getConnectionString();
			String strUserName = experimentSubject.getUserName();
			String strPassword = experimentSubject.getPassword();
Main._logger.outputLog("Client " + (clientNum) + " is being initialized...");
			clients[i] = new Client(batchID, clientNum);
			// set up client (i+1)
			clients[i].init(strDrvName,strConnStr,strUserName,strPassword);
		}
		recordRunProgress(100, "Done with batch ("+ batchID + ") initialization (MPL=" + MPL + ")");
	}
	
	/***
	 * Runs transactions per client in a batch
	 * @throws Exception
	 */
	@Override
	protected void stepC(int batchID) throws Exception {
//		TimeoutTerminals terminalTimeOuter = new TimeoutTerminals(clients);
//		Timer xactRunTimer = new Timer();
//		xactRunTimer.scheduleAtFixedRate(terminalTimeOuter, duration*1000, duration*1000);
		
//		recordRunProgress(0, "Before running the batch for specified duration");
//		timeOut = false;
		for(int k=1;k<=Constants.MAX_ITERS;k++){// MAX_ITERS: 5 as did in Jung's paper
			long startTime = System.currentTimeMillis();
	//		long endTime = 0;
			int totalXacts = 0;
			long elapsedTimeMillis = 0;
			boolean runStarted = false;
			while((elapsedTimeMillis=(System.currentTimeMillis() - startTime)) < batchRunTime*1000){// global timer
				if(runStarted) continue;
				try{
					for(Client c : clients){
						c.start();
					}
				}catch(Exception ex){
				}
				runStarted = true;
			}
	//		timeOut = true;
			// record number of transactions successfully executed
			for(Client c : clients){
				int numXacts = c.getNumTransactions();
				insertPerClientResult(c.getClientID(), k, numXacts);
				Main._logger.outputLog("Client #"+c.getClientID()+"> # of total transactions: " + numXacts);
				totalXacts += numXacts;
			}
			long elapsedTimeInSec = elapsedTimeMillis / 1000;
			if(elapsedTimeInSec != batchRunTime){ k--; continue; }
			insertBatchResult(batchID, k, totalXacts, elapsedTimeMillis);
			// wait for a minute to clean up any remaining transactions 
			try{
				Thread.sleep(Constants.THINK_TIME); 
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}
	/******
	 * Insert batch run result
	 * @param batchID batch ID
	 * @param iterNum iteration number
	 * @param totalXacts total transactions executed
	 * @param batchRunTimeMillis elapsed time milliseconds
	 * @throws Exception
	 */
	protected void insertBatchResult(int batchID, int iterNum, int totalXacts, long batchRunTimeMillis) throws Exception {
		Main._logger.outputLog("###<BEGIN>INSERT batch Result ################");
		float elapsedTimeSec = batchRunTimeMillis / 1000F;
		float tps = (float)totalXacts / elapsedTimeSec;
		System.out.format("============== %d> TPS RESULTS =====================\n",iterNum);
		Main._logger.outputLog("Time: "+ batchRunTimeMillis +" ms");
		Main._logger.outputLog("Total transactions: "+totalXacts);
		Main._logger.outputLog("Transactions per second: "+String.format("%.2f", tps));
        Main._logger.outputLog("Inserting tps result : " + numTerminals + " for duration " + duration + " (secs)");
        try{
			LabShelfManager.getShelf().insertTuple( 
					Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT,
					BATCHHASRESULT.columns,
					new String[] {
							String.valueOf(batchID),
							String.valueOf(iterNum),
							String.valueOf(totalXacts),
							String.valueOf(batchRunTimeMillis)
					},
					BATCHHASRESULT.columnDataTypes);
			LabShelfManager.getShelf().commit();
		} catch (Exception e) {
			e.printStackTrace();
			String updateSQL 
					= "Update " + Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT
					+ " SET SUMEXECUTEDXACTS = " + totalXacts + ", elapsedTime = " + batchRunTimeMillis
					+ " WHERE batchID = " + batchID + " and iterNum = " + iterNum;
			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
		}
		Main._logger.outputLog("###<END>INSERT batch Result ###################");
	}
	/****
	 * Insert per-client result into AZDBLab
	 * @param clientID client ID
	 * @param iterNum iteration number
	 * @param numXacts number of transactions executed in this iteration
	 */
	private void insertPerClientResult(int clientID, int iterNum, int numXacts) throws SQLException {
		Main._logger.outputLog("###<BEGIN>INSERT client's transaction running result ################");
		try{
			LabShelfManager.getShelf().insertTuple( 
					Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT,
					CLIENTHASRESULT.columns,
					new String[] {
							String.valueOf(clientID),
							String.valueOf(iterNum),
							String.valueOf(numXacts)
					},
					CLIENTHASRESULT.columnDataTypes);
			LabShelfManager.getShelf().commit();
		} catch (Exception e) {
			e.printStackTrace();
			String updateSQL 
					= "Update " + Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT
					+ " SET numXacts = " + numXacts
					+ " WHERE clientID = " + clientID + " and iterNum = " + iterNum;
			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
		}
		Main._logger.outputLog("###<END>INSERT client's transaction running result ###################");
	}
}
