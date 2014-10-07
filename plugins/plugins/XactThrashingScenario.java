package plugins;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.SQLTimeoutException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Timer;
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
import azdblab.plugins.scenario.ScenarioBasedOnBatchSet;

/**
 * We study DBMS thrashing
 * 
 * @author yksuh
 * 
 */

public class XactThrashingScenario extends ScenarioBasedOnBatchSet {
	public static final boolean refreshTable = false;

	public XactThrashingScenario(ExperimentRun expRun) {
		super(expRun);
		// TODO Auto-generated constructor stub
		installTables();
	}
	
	// Collect transaction run stat
	class XactRunStatPerClient{
		long numXactsToHave;
		long id;
		long num = 0;
		long numExecXacts = 0;
		long numMeasuredExecXacts = 0;
		long sumOfElapsedTime = 0;
		long runTime = 0;
		HashMap<Long, Long> xactNumToIDMap;
		HashMap<Long, Vector<Long>> xactNumToRunTimeVecMap;
//		boolean valid;
//		long numExtraXacts;
		boolean timeOut = false;
	}
	
	public XactRunStatPerClient[] _clientRunStats;

	/****
	 * Get tables to be installed for this thrashing study
	 * 
	 * @return
	 */
	public Vector<InternalTable> getTables() {
		if (refreshTable) {
			LabShelfManager.getShelf().dropTable(BATCHSET.TableName);
			LabShelfManager.getShelf().dropTable(BATCH.TableName);
			LabShelfManager.getShelf().dropTable(CLIENT.TableName);
			LabShelfManager.getShelf().dropTable(TRANSACTION.TableName);
			LabShelfManager.getShelf().dropTable(COMPLETED_BATCHSETTASK.TableName);
			// LabShelfManager.getShelf().dropTable(STATEMENT.TableName);
			
			// result table
			LabShelfManager.getShelf().dropTable(BATCHSETHASRESULT.TableName);
			LabShelfManager.getShelf().dropTable(BATCHHASRESULT.TableName);
			LabShelfManager.getShelf().dropTable(CLIENTHASRESULT.TableName);
			LabShelfManager.getShelf().dropTable(TRANSACTIONHASRESULT.TableName);
			// LabShelfManager.getShelf().dropTable(STATEMENTHASRESULT.TableName);

			// LabShelfManager.getShelf().dropTable(BSSATISFIESASPECT.TableName);
		}

		Vector<InternalTable> toRet = new Vector<InternalTable>();
		toRet.add(BATCHSET);
		toRet.add(BATCH);
		toRet.add(CLIENT);
		toRet.add(TRANSACTION);
		toRet.add(COMPLETED_BATCHSETTASK);
		// toRet.add(STATEMENT);

		toRet.add(BATCHSETHASRESULT);
		toRet.add(BATCHHASRESULT);
		toRet.add(CLIENTHASRESULT);
		toRet.add(TRANSACTIONHASRESULT);
		// toRet.add(STATEMENTHASRESULT);

		// toRet.add(BATCHSETHASPARAMETER);
		// toRet.add(BSSATISFIESASPECT);
		return toRet;
	}

	/***
	 * Creates sequence for some tables
	 * 
	 * @param seqName
	 *            sequence name
	 * @throws Exception
	 */
	private void createSequence(String seqName, int startNum) throws Exception {
		String createSequence = "CREATE SEQUENCE " + seqName + " START WITH "
				+ startNum + " NOMAXVALUE";
		Main._logger.outputLog(createSequence);
		LabShelfManager.getShelf().executeUpdateSQL(createSequence);
		LabShelfManager.getShelf().commitlabshelf();
		Main._logger.outputLog(seqName + " Created");
	}

	/***
	 * Drops sequence for some tables
	 * 
	 * @param seqName
	 *            sequence name
	 * @throws Exception
	 */
	private void dropSequence(String seqName) throws Exception {
		String dropSequence = "Drop SEQUENCE " + seqName;
		Main._logger.outputLog(dropSequence);
		LabShelfManager.getShelf().executeUpdateSQL(dropSequence);
		LabShelfManager.getShelf().commitlabshelf();
		Main._logger.outputLog(seqName + " Dropped");
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
						tmp.columnDataTypeLengths, tmp.uniqueConstraintColumns,
						tmp.columnNullable, tmp.primaryKey, tmp.foreignKey);
				if (tmp.TableName.equalsIgnoreCase(Constants.TABLE_PREFIX
						+ Constants.TABLE_BATCHSET)) {
					String alterTblSQL = "";
					// alterTblSQL = "ALTER TABLE " +
					// Constants.TABLE_PREFIX+Constants.TABLE_BATCHSET
					// + " MODIFY MaxMPL NUMBER(10, 2)";
					// LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
					// LabShelfManager.getShelf().commitlabshelf();
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX
							+ Constants.TABLE_BATCHSET
							+ " MODIFY XactSz NUMBER(10, 4)";
					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
					LabShelfManager.getShelf().commitlabshelf();
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX
							+ Constants.TABLE_BATCHSET
							+ " MODIFY XLockRatio NUMBER(10, 2)";
					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
					LabShelfManager.getShelf().commitlabshelf();
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX
							+ Constants.TABLE_BATCHSET
							+ " MODIFY EffectiveDBSz NUMBER(10, 2)";
					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
					LabShelfManager.getShelf().commitlabshelf();
				}
				if (tmp.TableName.equalsIgnoreCase(Constants.TABLE_PREFIX
						+ Constants.TABLE_BATCHSETHASRESULT)) {
					String alterTblSQL = "ALTER TABLE "
							+ Constants.TABLE_PREFIX
							+ Constants.TABLE_BATCHSETHASRESULT
							+ " MODIFY AvgXactProcTime NUMBER(10, 2)";
					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
					LabShelfManager.getShelf().commitlabshelf();
					alterTblSQL = "ALTER TABLE " + Constants.TABLE_PREFIX
							+ Constants.TABLE_BATCHSETHASRESULT
							+ " MODIFY bufferSpace NUMBER(10, 2)";
					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
					LabShelfManager.getShelf().commitlabshelf();
				}
				if (tmp.strSequenceName != null) {
					try {
						if (refreshTable) {
							dropSequence(tmp.strSequenceName);
						}
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
//	protected boolean timeOut = false;

	static class TransactionGenerator {
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
		// private static double effectiveDBSize = 0;
		/***
		 * Transaction Size
		 */
		private static double xactSize = 0;
		/***
		 * eXclusive Locks
		 */
		private static double xLocks = 0;

		/*** For target table. Used for FROM and UPDATE clause ***/
		private static RepeatableRandom repRandForTable = new RepeatableRandom();
		/*** For update ***/
		private static RepeatableRandom repRandForSET = new RepeatableRandom();
		private static RepeatableRandom repRandForWhereInUpdate = new RepeatableRandom();
		/*** For select ***/
		private static RepeatableRandom repRandForSELECT = new RepeatableRandom();
		private static RepeatableRandom repRandForWhereInSELECT = new RepeatableRandom();
		/*** Generating values to be updated ***/
		private static RepeatableRandom repRandForVal = new RepeatableRandom();

		/****
		 * Get xact number to id map
		 * 
		 * @return xactNumToIDMap
		 */
		public static HashMap<Long, Long> getXactNumToIDMap() {
			return xactNumToIDMap;
		}

		/****
		 * Get statment number to id map
		 * 
		 * @return xactNumToIDMap
		 */
		public static HashMap<Long, Long> getStmtNumToIDMap() {
			return stmtNumToIDMap;
		}

		public static double getEffectiveDBRatio() {
			return effectiveDBSz;
		}

		public static double getSelectivity() {
			return selectivity;
		}

		/****
		 * Set transaction size (# of locks)
		 * 
		 * @param xactSz
		 */
		public static void setXactSize(double xactSz) {
			xactSize = xactSz;
		}

		/****
		 * Set exclusive locks (# of locks)
		 * 
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
		private static int getRandomNumber(RepeatableRandom rr, int start,
				int finish) {
			int range = finish - start;
			range++; // since Math.random never returns 1.0
			// int result = (int) ( range * Math.random() );

			// The cast to INT truncates, so we will get an integer between 0
			// and
			// (finish - start)
			int result = 0;
			result = (int) (range * rr.getNextDouble());
			// ensure range is from start to finish
			result += start;
			return result;
		}

		/***
		 * Set effective database size
		 * 
		 * @param edb_size
		 */
		public static void setEffectiveDBSz(double edb_size) {
			effectiveDBSz = edb_size;
		}

		/*****
		 * Build SELECT clause for SELECT statement
		 * 
		 * @param tbl
		 *            a chosen tbl
		 * @return SELECT clause
		 */
		static String buildSELECTForSelect(Table tbl) {
			String str = "SELECT ";
			// get number of columns
			int numCols = tbl.columns.length;
			Vector<String> colNamesVec = new Vector<String>();
			// copy column names
			for (int i = 0; i < numCols; i++) {
				colNamesVec.add(tbl.columns[i].myName);
			}
			// build projection list
			String strProjectionList = "";
			long numChosenCols = (long) ((double) getRandomNumber(
					repRandForSELECT, 1, numCols));
			for (int i = 0; i < numChosenCols; i++) {
				int idx = (int) ((double) getRandomNumber(repRandForSELECT, 0,
						colNamesVec.size() - 1));
				String colName = colNamesVec.get(idx);
				colNamesVec.remove(idx);
				strProjectionList = colName;
				if (i < numChosenCols - 1) {
					strProjectionList += ",";
				}
			}
			str += strProjectionList;
			return str;
		}

		/*****
		 * Build FROM clause for select statement
		 * 
		 * @param tbl
		 *            a chosen tbl
		 * @return FROM clause
		 */
		static String buildFROMForSelect(Table tbl) {
			String str = "FROM ";
			str += tbl.table_name_with_prefix;
			return str;
		}

		/*****
		 * Build WHERE clause for SELECT
		 * 
		 * @param tbl
		 *            a chosen tbl
		 * @return WHERE clause
		 */
		static String buildWHEREForSelect(Table tbl) {
			// control lock range with the first column
			String idxCol = "id1";
			int numChosenRows = 0;
			// determine the number of requested locks using transaction size
			if(xactSize == 0){
				if(Constants.DEFAULT_UPT_ROWS == 0){
					Main._logger.reportError("default update selectivity is " + Constants.DEFAULT_UPT_ROWS);
					System.exit(-1);
				}
				numChosenRows = (int) (Constants.DEFAULT_UPT_ROWS * (double) tbl.hy_min_card);
			}else{
				numChosenRows = (int) (xactSize * (double) tbl.hy_min_card);
			}
			int start = 0;
			// determine end range using effective db size
			int end = (int) ((double) tbl.hy_min_card * effectiveDBSz);
			// compute low key
			loKey = (long) ((double) getRandomNumber(repRandForWhereInSELECT,
					start, end - numChosenRows));
			// set high key
			hiKey = (loKey + numChosenRows);
			String str = "WHERE " + idxCol + " >= " + loKey + " and " + idxCol
					+ " < " + hiKey;
			return str;
		}

		/****
		 * Get random string
		 * 
		 * @param size
		 * @return a random string
		 */
		public static String RandomAlphaNumericString(int size) {
			String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			String ret = "";
			int length = chars.length();
			for (int i = 0; i < size; i++) {
				ret += chars.split("")[(int) (Math.random() * (length - 1))];
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

		/***
		 * Reset keys
		 */
		public static void resetKeys() {
			loKey = 0;
			hiKey = 0;
		}

		/***
		 * Construct update
		 * 
		 * @param tbl
		 * @return
		 */
		static String buildUPDATEForUpdate(Table tbl) {
			String str = "UPDATE ";
			str += tbl.table_name_with_prefix;
			return str;
		}

		/***
		 * Build SET clause for UPDATE
		 * 
		 * @param tbl
		 * @return
		 */
		static String buildSETForUpdate(Table tbl) {
			Column[] cols = tbl.columns;
			int chosenCol = getRandomNumber(repRandForSET, 1, cols.length - 1);
			int newValue = getRandomNumber(repRandForVal, 0, (int) tbl.hy_max_card);
			String colName = cols[chosenCol].myName;
			if(colName.contains("id1")) {
				Main._logger.reportError(cols[chosenCol].myName + " was selected for update.");
				System.exit(-1);
			}
			String str = "";
			// if integer column, set a random value
			if (colName.contains("val")) {
				String newStrVal = RandomAlphaNumericString((int) cols[chosenCol].mySize);
				str += "SET " + colName + " = \"" + newStrVal + "\" ";
			} else {
				str += "SET " + colName + " = " + newValue + " ";
			}
			// otherwise, set a random string
			return str;
		}

//		/*****
//		 * Assume that this gets invoked when xLocks are greater than zero
//		 * 
//		 * @param tbl
//		 * @return
//		 */
//		static String buildWhereForUpdate(Table tbl) {
//			// control lock range with the first column
//			String idxCol = "id1";
//			// low key for update
//			long loKeyForUpdate = 0;
//			// high key for update
//			long hiKeyForUpdate = 0;
//			if (xLocks == 1.0) {
//				// determine the number of requested locks using transaction
//				// size
////				int numReqLocks = (int) (xactSize * (double) tbl.hy_min_card);
////				// determine end range using effective db size
////				int start = 0;
////				// determine end range using effective db size
////				int end = (int) ((double) tbl.hy_min_card * effectiveDBSz);
//				// compute low key
////				loKeyForUpdate = (long) ((double) getRandomNumber(
////						repRandForWhereInUpdate, start, end - numReqLocks));
//				// set high key
////				hiKeyForUpdate = (loKeyForUpdate + numReqLocks);
//				loKeyForUpdate = loKey; 
//				hiKeyForUpdate = hiKey;
//			} else {
//				// determine the number of requested locks using transaction
//				// size
//				int numXLocks = (int) (((double) (xactSize * (double) tbl.hy_min_card)) * xLocks);
//				// determine end range using effective db size
//				long start = loKey;
//				// determine end range using effective db size
//				long end = hiKey;
//				loKeyForUpdate = (long) ((double) getRandomNumber(
//						repRandForWhereInUpdate, (int) start,
//						(int) (end - numXLocks)));
//				hiKeyForUpdate = (loKeyForUpdate + numXLocks);
//			}
//			String str = "WHERE " + idxCol + " >= " + loKeyForUpdate + " and "
//					+ idxCol + " < " + hiKeyForUpdate;
//			return str;
//		}

		/*****
		 * Assume that this gets invoked when xLocks are greater than zero
		 * 
		 * @param tbl
		 * @return
		 */
		static String buildWhereForUpdate(Table tbl) {
			String idxCol = "id1";
			if(xactSize == 0){
				if(Constants.DEFAULT_UPT_ROWS == 0){
					Main._logger.reportError("default update selectivity is " + Constants.DEFAULT_UPT_ROWS);
					System.exit(-1);
				}
			}	
			int numXLocks = (int) (((double) (Constants.DEFAULT_UPT_ROWS * (double) tbl.hy_min_card)) * xLocks);
			int start = 0;
			// determine end range using effective db size
			int end = (int) ((double) tbl.hy_min_card * effectiveDBSz);
			long loKeyForUpdate = (long) ((double) getRandomNumber(
					repRandForWhereInUpdate, (int) start,
					(int) (end - numXLocks)));
			long hiKeyForUpdate = (loKeyForUpdate + numXLocks);
			String str = "WHERE " + idxCol + " >= " + loKeyForUpdate + " and "
					+ idxCol + " < " + hiKeyForUpdate;
			return str;
		}
		
		/****
		 * Build transaction
		 * 
		 * @param clientNum
		 * @return a list of SQL statements
		 */
		public static HashMap<Long, Vector<String>> buildTransaction(int clientID, long xactNum) 
		throws Exception {
			HashMap<Long, Vector<String>> recMap = new HashMap<Long, Vector<String>>();
			// vector for SQL statements for this transaction
			Vector<String> transaction = new Vector<String>();
			// randomly select a table
			int chosenTblNum = getRandomNumber(repRandForTable, 0,	myXactTables.length - 1);
			Table tbl = myXactTables[chosenTblNum];

			if(xactSize == 0){
//				// update only
//				// construct update clause
//				String strUPDATE = buildUPDATEForUpdate(tbl);
//				// construct set clause
//				String strSET = buildSETForUpdate(tbl);
//				// construct where clause
//				String strWHERE = buildWHEREForSelect(tbl);
//				// add this update statement in this transaction
//				String strSQLStmt = String.format("%s %s %s", strUPDATE, strSET, strWHERE);
//				// Main._logger.outputLog(strSQLStmt2);
//				transaction.add(strSQLStmt);
				// construct update clause
				String strUPDATE = buildUPDATEForUpdate(tbl);
				// construct set clause
				String strSET = buildSETForUpdate(tbl);
				// construct where clause
				String strWHERE2 = buildWhereForUpdate(tbl);
				// add this update statement in this transaction
				String strSQLStmt2 = String.format("%s %s %s", strUPDATE,
						strSET, strWHERE2);
				// Main._logger.outputLog(strSQLStmt2);
				transaction.add(strSQLStmt2);
			}else{
				// build select clause
				String strSELECT = buildSELECTForSelect(tbl);
				// build from clause
				String strFROM = buildFROMForSelect(tbl);
				// build where clause
				String strWHERE = buildWHEREForSelect(tbl);
				// add this select statement in this transaction
				String strSQLStmt = String.format("%s %s %s", strSELECT, strFROM, strWHERE);
				// Main._logger.outputLog(strSQLStmt);
				transaction.add(strSQLStmt);
//				// if exclusive lock ratio is greater than zero
//				if (xLocks > 0) {
//					// construct update clause
//					String strUPDATE = buildUPDATEForUpdate(tbl);
//					// construct set clause
//					String strSET = buildSETForUpdate(tbl);
//					// construct where clause
//					String strWHERE2 = buildWhereForUpdate(tbl);
//					// add this update statement in this transaction
//					String strSQLStmt2 = String.format("%s %s %s", strUPDATE,
//							strSET, strWHERE2);
//					// Main._logger.outputLog(strSQLStmt2);
//					transaction.add(strSQLStmt2);
//				}
			}
			
			// Insert this client's transaction and its statements while setting 
			// number to ID maps
			long xactID = insertTransaction(clientID, xactNum, transaction);
			// Reset keys
			resetKeys();
			recMap.put(new Long(xactID), transaction);
			return recMap;
		}


		/*****
		 * Insert a given transaction into DB
		 * @param clientID client ID
		 * @param xactNum transaction number
		 * @param transaction actual statements
		 * @return transaction ID
		 */
		private static long insertTransaction(int clientID, long xactNum, Vector<String> transaction) 
		throws Exception{
			// get transaction string
			String xactStr = "";
			for (int i = 0; i < transaction.size(); i++) {
				xactStr += transaction.get(i);
				if (i < transaction.size() - 1) {
					xactStr += ";";
				}
			}

			// get transaction id
//			int xactID = -1;
//			ResultSet rs = null;
//			try {
//				rs = LabShelfManager.getShelf().executeQuerySQL(
//						"SELECT TransactionID " + "from azdblab_transaction"
//								+ " where clientid = " + clientID
//								+ " and TransactionNum = " + xactNum);
//				while (rs.next()) {
//					xactID = rs.getInt(1);
//				}
//				rs.close();
//			} catch (SQLException e1) {
//				// TODO Auto-generated catch block
//				// e1.printStackTrace();
//			}

			// not existing ...
//			if (xactID == -1) {
				// obtain a new batch set id
				long xactID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_TRANSACTION);
				// add transaction
				try {
					LabShelfManager.getShelf().NewInsertTuple(
							Constants.TABLE_PREFIX
									+ Constants.TABLE_TRANSACTION,
							TRANSACTION.columns,
							new String[] { String.valueOf(xactID),
									String.valueOf(clientID),
									String.valueOf(xactNum),
									String.valueOf(xactStr)
							},
							TRANSACTION.columnDataTypes);
					LabShelfManager.getShelf().commit();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					throw new Exception(e.getMessage());
				}
//			} else { // update transaction string
//				String updateSQL = "UPDATE azdblab_transaction "
//						+ "SET TransactionStr = '" + xactStr + "' "
//						+ "WHERE TransactionID = " + xactID;
//				Main._logger.outputLog(updateSQL);
//				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
//			}

			// Main._logger.outputLog(String.format("Client %d's transaction(%d)-(%d)",
			// clientID, xactNum, xactID));
			// // add statement
			// for(int stmtNum=0;stmtNum<transaction.size();stmtNum++){
			// String strSQLStmt = transaction.get(stmtNum);
			// // add statement
			// int stmtID =
			// LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_STATEMENT);
			// Main._logger.outputLog("\t stmt("+stmtID+")=>"+strSQLStmt);
			// LabShelfManager.getShelf().NewInsertTuple(
			// Constants.TABLE_PREFIX + Constants.TABLE_STATEMENT,
			// STATEMENT.columns,
			// new String[] {
			// String.valueOf(stmtID), // statement ID
			// String.valueOf(xactID), // transaction ID
			// String.valueOf(stmtNum), // statement number
			// String.valueOf(strSQLStmt) // statement SQL
			// },
			// STATEMENT.columnDataTypes);
			// LabShelfManager.getShelf().commit();
			// Long sNum = new Long(stmtNum);
			// // build statement number to ID map
			// stmtNumToIDMap.put(sNum, new Long(stmtID));
			// Long sID = stmtNumToIDMap.get(sNum);
			// if(sID != stmtID){
			// Main._logger.outputLog("Statement ID is different!");
			// System.exit(-1);
			// }
			// } catch (SQLException e) {
			// // TODO Auto-generated catch block
			// e.printStackTrace();
			// }
			// }
			// build transaction number to ID map
//			Long xtNum = new Long(xactNum);
//			Long xtID = new Long(xactID);
//			xactNumToIDMap.put(xtNum, xtID);
//			Long xID = xactNumToIDMap.get(xtNum);
//			if (xID != xtID) {
//				Main._logger.outputLog("Transaction ID is different!");
//				System.exit(-1);
//			}
			return xactID;
		}
	}

	/****
	 * Build a client in a batch
	 * 
	 * @author yksuh
	 * 
	 */
	public class Client extends Thread {

		protected class BatchRunTimeOut extends TimerTask {
			public int cn = 0;
			public Connection co = null;
			public Statement st = null;
			
			public BatchRunTimeOut(int clientNumber, Connection conn,
					Statement stmt) {
				st = stmt;
				co = conn;
				clientNumber = cn;
			}

			public BatchRunTimeOut() {
			}

			public void run() {
				if(_clientRunStats[_clientNum] != null)
					_clientRunStats[_clientNum].timeOut = true;
				try {
					if(co != null) co.commit();
					if (st != null) {
						st.cancel();
						new SQLException("Batch run timeout");
					} 
				} catch (SQLException e) {
					//e.printStackTrace();
					Main._logger.reportErrorNotOnConsole("Client1 #"+_clientNum+"=>"+e.getMessage());
				}
				try {
					if(_conn != null) {
						if(experimentSubject.getDBMSName().toLowerCase().contains("db2")){
							long start		 = System.currentTimeMillis();
							_conn.rollback();
							long rollbackTime = System.currentTimeMillis()-start;
							//if(_clientNum % 20 == 0){
								Main._logger.reportErrorNotOnConsole("Client #"+_clientNum+" rollback time: " + rollbackTime + "(ms)");
							//}
						}else{
							if(!_conn.isClosed()){ 
								_conn.commit();
								if (_stmt != null) {
//									long start		 = System.currentTimeMillis();
									try{
										_stmt.cancel();
									}catch(Exception ex){
										Main._logger.reportErrorNotOnConsole("run-cancel()-Client #"+_clientNum+"=>"+ex.getMessage());
									}
//									long cancelTime = System.currentTimeMillis()-start;
									//if(_clientNum % 20 == 0){
//										Main._logger.reportErrorNotOnConsole("Client #"+_clientNum+" stmt cancel time: " + cancelTime + "(ms)");
									//}
									new SQLException("Batch run timeout");
								} 
							}
						}
					}
				}catch (SQLException e) {
//						e.printStackTrace();
					Main._logger.reportErrorNotOnConsole("run()-Client #"+_clientNum+"=>"+e.getMessage());
				}	
				cancel();
			}
		}
		
		// private Statement _stmt;
		// private String _sql;
		// private long _card = 30000;
		// private String _driverName = "";
		// private String _connStr = "";
		// private String _userName = "";
		// private String _password = "";
		// private int _id = 0;
		// private long _xactNum = 0; // transaction number
		/****
		 * Batch ID in database
		 */
		private int _batchID = 0;
		/****
		 * Assigned this client's number
		 */
		private int _clientNum = 0;
		/*****
		 * Client ID in database
		 */
		private int _clientID = 0;
		/****
		 * Connection object
		 */
		private Connection _conn = null;
//		/***
//		 * Number of measured executed transactions
//		 */
//		public int _numRealExecXacts = 0;
		/****
		 * Number of transactions that this client has For now, we use only one
		 * transaction
		 */
		private int _numXactsToHave = 1;
		/****
		 * Generated Transactions
		 */
		private HashMap<Long, Vector<String>> _transactionMap = null;
		/****
		 * Map of transaction number to ID
		 */
		private HashMap<Long, Long> _xactNumToIDMap = null;
		/****
		 * Map of statement number to ID
		 */
		// private HashMap<Long, Long> _stmtNumToIDMap = null;
		/****
		 * Map of transaction number to its runtime vector
		 */
		public HashMap<Long, Vector<Long>> _xactNumToRunTimeVecMap = null;
//		private HashMap<Long, Vector<Long>> _xactNumToRealRunTimeVecMap = null;
		/***
		 * Number of cumulative executed transactions
		 */
		public int _numExecXacts = 0;
		/****
		 * Sum of elapsed time
		 */
		public long _sumRunTime = 0;
//		private long _sumRealRunTime = 0;
		private Statement _stmt;
//		private String _driverName;
		private String _connStr;
		private String _userName;
		private String _password;
		
		public boolean finalExit = false;
//		private boolean _timeOut;
//		private long _startTime;
//		private boolean _fail;
//		public long _clientRunTime = 0;
//		private long _clientRealRunTime = 0;
		

		/****
		 * Map of statement number to its runtime vector
		 */
		// private HashMap<Long, Vector<Vector<Long>>>
		// _xactNumToStmtRunTimeVecMap = null;

//		public Client(Client c) {
//			_batchID = c.getBatchID();
//			_clientNum = c.getClientNumber();
//			_transactionMap = c.getTransactionMap();
//			_xactNumToIDMap = c.getXactNumToIDMap();
//			_xactNumToRunTimeVecMap = c.getXactNumToRunTimeVecMap();
//		}
		
		public Client(int batchID, int clientNum) {
			_batchID = batchID;
			_clientNum = clientNum;
			_transactionMap = new HashMap<Long, Vector<String>>();
			_xactNumToIDMap = new HashMap<Long, Long>();
			_xactNumToRunTimeVecMap = new HashMap<Long, Vector<Long>>();
		}

//		/***
//		 * Reset transaction execution runtime vector
//		 */
//		private void resetRunTimeVec() {
//			// TODO Auto-generated method stub
//			_xactNumToRunTimeVecMap = new HashMap<Long, Vector<Long>>();
//			_numExecXacts = 0;
//			_sumRunTime = 0;
//		}
		
		public HashMap<Long, Vector<String>> getTransactionMap() {
			return _transactionMap;
		}
		
		public int getBatchID() {
			return _batchID;
		}

		public int getClientNumber() {
			return _clientNum;
		}

		public int getClientID() {
			return _clientID;
		}

		// public void close(){
		// // TimeoutCloseThread tct = new TimeoutCloseThread();
		// // Timer closeTimer = new Timer();
		// // Main._logger.outputLog("\t>>Timer set for closing Client #"+_id);
		// // closeTimer.scheduleAtFixedRate(tct, 10000, 10000);
		//
		// Main._logger.outputLog("\t>>Client #"+_clientNum+" is being closed ... ("
		// + _numExecXacts+")");
		// try {
		// //System.out.println("DBMS: " + experimentSubject.getDBMSName());
		// // try{
		// ////Main._logger.outputLog("Statement is being canceled-Client #"+_id);
		// //// _stmt.cancel();
		// //Main._logger.outputLog("\tStatement is being closed-Client #"+_id);
		// // _stmt.close();
		// //Main._logger.outputLog("\tDone with closing statement -Client #"+_id);
		// // }catch(Exception ex){
		// // if((ex.getMessage()).toLowerCase().contains("closed")){
		// // _conn.commit();
		// // _conn.close();
		// //// tct.cancel();
		// // return;
		// // }
		// //
		// if(ex.getMessage().toLowerCase().contains("no current connection"))
		// return;
		// // }
		// //Main._logger.outputLog("Connection is being committed-Client #"+_id);
		// // _conn.commit();
		// //Main._logger.outputLog("Connection is being closed-Client #"+_id);
		// if(_conn != null)
		// _conn.close();
		// Main._logger.outputLog("\tDone with closing connection -Client #"+_clientNum);
		// // tct.cancel();
		// } catch (SQLException e) {
		// //Main._logger.reportError(e.getMessage());
		// // tct.cancel();
		// return;
		// }
		// }

		// public void init(String drvName, String strConnStr, String
		// strUserName, String strPassword, double edbSz){
		// //Main._logger.outputLog("login details: " + strConnStr + ", " +
		// strUserName + ", " + strPassword);
		// try{
		// driverName=drvName; connStr=strConnStr; userName=strUserName;
		// password=strPassword;
		// // Main._logger.outputLog("login details: " + strConnectString + ", "
		// + strUserName + ", " + strPassword + ", " + strdrvname);
		// Class.forName(drvName);
		// _conn = DriverManager.getConnection(strConnStr, strUserName,
		// strPassword);
		// //Main._logger.outputLog(experimentSubject.getDBMSName());
		// //
		// if(experimentSubject.getDBMSName().toLowerCase().contains("teradata")){
		// // experimentSubject.open(false);
		// // }
		// _stmt =
		// _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
		// // TransactionGenerator tg = new TransactionGenerator();
		//
		// /****
		// * Ver2
		// */
		// _sql = TransactionGenerator.buildDML();
		// Main._logger.outputLog(_sql); // this should later be replaced by sql
		// array
		// return;
		// } catch (SQLException | ClassNotFoundException sqlex) {
		// // sqlex.printStackTrace();
		// // Main._logger.outputLog("login details: " + strConnStr + ", " +
		// strUserName + ", " + strPassword);
		// }
		// // catch (ClassNotFoundException e) {
		// // e.printStackTrace();
		// // System.exit(1);
		// // }
		// }
		
		public void init(String drvName, String strConnStr, String strUserName,
				String strPassword) throws Exception {
			try {
				_connStr = strConnStr;
				_userName = strUserName;
				_password = strPassword;

				Class.forName(drvName);
				int j = 1;
				while(true){
					_conn = DriverManager.getConnection(strConnStr, strUserName, strPassword);
					if(_conn != null) break;
					_conn.setAutoCommit(false);
					if(j++ % 10 == 0){
						throw new Exception("Client " + _clientNum + " cannot have a connection!");
					}
					Thread.sleep(10000);
					Main._logger.outputLog(j+"th connection trial...");
				}
//				_stmt = _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,
//						ResultSet.CONCUR_UPDATABLE);
				_stmt = _conn.createStatement();
				return;
			} catch (SQLException | ClassNotFoundException sqlex) {
//				Main._logger.reportError(sqlex.getMessage());
				//if(_clientNum % 10 == 0)
					Main._logger.reportErrorNotOnConsole("init()-Client #"+_clientNum+"=>"+sqlex.getMessage());
			}
		}

		// public void run(){
		// // long starttime = System.currentTimeMillis();
		// while(true){
		// if(timeOut) break;
		// // while(System.currentTimeMillis() - starttime < duration*1000){
		// // boolean localTimeOut = false;
		// // while(true){
		// try {
		// if(_conn == null){
		// Class.forName(_driverName);
		// _conn = DriverManager.getConnection(_connStr, _userName, _password);
		// }
		// // open a connection to an experiment subject
		// _conn.setAutoCommit(false);
		// _stmt =
		// _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
		// if(experimentSubject.getDBMSName().toLowerCase().contains("teradata")){
		// _stmt.executeUpdate("DATABASE azdblab_user;");
		// _conn.commit();
		// }
		// // run transaction
		// for(int i=0;i<_transaction.size();i++){
		// _stmt.execute(_transaction.get(i));
		// }
		// _stmt.close();
		// _conn.commit();
		// // synchronized(this){ // this variable could be accessed by multiple
		// threads.
		// // localTimeOut = timeOut;
		// // }
		// // if(!localTimeOut)
		// numTrans++;
		// // else{
		// //
		// Main._logger.outputLog("time out >> Client #"+_id+"> # of total transactions: "
		// + numTrans);
		// // return;
		// // }
		// // if(numTrans%10000==0){
		// //
		// Main._logger.outputLog("Client #"+_id+"> # of current transactions: "
		// + numTrans);
		// // }
		// } catch (SQLException | ClassNotFoundException e) {
		// //e.printStackTrace();
		// // String msg = e.getMessage().toLowerCase();
		// //// Main._logger.outputLog("Client #"+_id+"> : " + msg);
		// // // DB2: http://www-01.ibm.com/support/docview.wss?uid=swg21424265
		// // //DB2 SQL Error: SQLCODE=-952, SQLSTATE=57014 SQL0952N Processing
		// was cancelled due to an interrupt SQLSTATE=57014
		// // if(msg.contains("cancel") // sqlserver
		// // || msg.contains("closed") // oracle
		// // ||msg.contains("952") // db
		// // ||msg.contains("interrupt") // mysql
		// // ||msg.contains("i/o error") // for postgres
		// // ||msg.contains("no current connection") // for javadb
		// // ){
		// // //Main._logger.outputLog(msg);
		// ////
		// Main._logger.outputLog("Client #"+_id+"> # of total transactions: " +
		// numTrans);
		// // return;
		// // }
		// // else{
		// // e.printStackTrace();
		// //
		// Main._logger.reportError("An unknown error happened. Retrying ... ");
		// // if(!msg.contains("aborted") && !msg.contains("deadlock") &&
		// !msg.contains("row error"))
		// // Main._logger.reportError(e.getMessage());
		// // break;
		// //
		// if(experimentSubject.getDBMSName().toLowerCase().contains("pgsql")){
		// // if(msg.contains("aborted")){
		// // continue;
		// // }
		// // }
		// continue;
		// // System.exit(-1);
		// // }
		// // e.printStackTrace();
		// // continue;
		// }
		// // numTrans++;
		// // if(numTrans%30==0){
		// //
		// Main._logger.outputLog("Client #"+_id+"> # of current transactions: "
		// + numTrans);
		// // }
		// }
		// close();
		// timeOut = false;
		// return;
		// }

//		/**
//		 * Closes the DBMS connection that was opened by the open call.
//		 */
//		public void terminate() {
//			long stmtClosingTime=0, connClosingTime=0;
//			try {
//				long start = System.currentTimeMillis();
//				Main._logger.outputLog(String.format("\tTerminated Client #%d",_clientNum));
//				if (_stmt != null)
//					_stmt.close();
//				stmtClosingTime = System.currentTimeMillis()-start;
//			} catch (SQLException ex) {
//				// Main._logger.reportError("Statement Close failed");
//				// Main._logger.reportErrorNotOnConsole(ex.getMessage());
//				// ex.printStackTrace();
//			}
//			_stmt = null;
//			try {
//				long start = System.currentTimeMillis();
//				if (_conn != null)
//					_conn.close();
//				connClosingTime = System.currentTimeMillis()-start;
//			} catch (SQLException e) {
//				// Main._logger.reportError("Connection Close failed");
//				// Main._logger.reportErrorNotOnConsole(e.getMessage());
//				// e.printStackTrace();
//			}
//			_conn = null;
////if(_clientNum % 100 == 0){
//	Main._logger.outputLog(String.format("\tTerminated Client #%d(stmt: %d(ms), conn: %d(ms)",_clientNum, 
//			stmtClosingTime, connClosingTime));
////}
//		}

		/***
		 * Return the current connection object
		 * @return
		 */
		public Connection getConnection(){
			return _conn;
		}
		
		/***
		 * Return the current statement
		 * @return
		 */
		public Statement getStatement(){
			return _stmt;
		}
		
		/**
		 * Commits all update operations made to the dbms. This must be called
		 * for inserts statements to be seen.
		 */
		public void NewCommit() {
			long startTime = 0;
			try {
				if (_conn != null && !_conn.isClosed()){
					startTime = System.currentTimeMillis();
					_conn.commit();
				}
			} catch (SQLException e) {
				// e.printStackTrace();
				long elapsedTime = System.currentTimeMillis()-startTime;
				Main._logger.reportErrorNotOnConsole("run()-#"+_clientNum+"=>"+e.getMessage() + ", commit time: "+ elapsedTime +"(ms)");
			}
		}

		/***
		 * Continuously run a transaction of this client
		 */
		public void run() {
			// Get a transaction to run
			int transactionNum = 0;
			Long xactNum = new Long(transactionNum);
			Vector<String> transactionToRun = _transactionMap.get(xactNum);
			assert (transactionToRun != null);
			// }
			/***
			 * Initialize transaction runtime vector
			 */
			Vector<Long> xactRunTimeVec = new Vector<Long>();
			// _xactNumToRunTimeVecMap _xactNumToStmtRunTimeVecMap
			// /***
			// * Initialize statement runtime vector
			// */
			// Vector<Vector<Long>> stmtRunTimeVec = new Vector<Vector<Long>>();
			// long minTime = -1;
			long startTime = System.currentTimeMillis();
			long runTime = 0;
			// conn, stmt for quickly getting out of the loop
			// timeout thread for getting number of transactions and sumElapsedTime
			BatchRunTimeOut brt = new BatchRunTimeOut();
			BatchRunTimeOut brt2 = new BatchRunTimeOut(this._clientNum, _conn, _stmt);
			Timer batchRunTimer = new Timer();
			Timer batchRunTimer2 = new Timer();
			if(experimentSubject.getDBMSName().toLowerCase().contains("mysql")){
				batchRunTimer.scheduleAtFixedRate(brt, batchRunTime * 1000, batchRunTime * 1000);
				batchRunTimer2.scheduleAtFixedRate(brt2, batchRunTime * 1000, batchRunTime * 1000);
			}

			//while((runTime = (System.currentTimeMillis()-startTime)) < batchRunTime * 1000){
			while((runTime = (System.currentTimeMillis()-startTime)) < batchRunTime * 1000){
//				if (_timeOut) {
//					long elapsedTime = System.currentTimeMillis()-_startTime;
//if(_clientNum % 100 == 0){
//	String str = String.format("\t>>TimeOuted Client #%d (%d(ms), #Xacts:%d)", _clientNum, elapsedTime, _numExecXacts);
//	Main._logger.outputLog(str);
//}
//					_timeOut = false;
//					return;
//				}
				//try {
					// run time vector for each statement
					// Vector<Long> stmtRunTimePerXactVec = new Vector<Long>();
					// open a connection to an experiment subject
					if (_conn == null) {
							try {
								_conn = DriverManager.getConnection(_connStr,
										_userName, _password);
								_conn.setAutoCommit(false);
							} catch (SQLException e) {
								//Main._logger.reportErrorNotOnConsole("new conn-#"+_clientNum+"=>"+e.getMessage());
								continue;
							}
					}
					if(_stmt == null){
//						_stmt = _conn.createStatement(
//							ResultSet.TYPE_FORWARD_ONLY,
//							ResultSet.CONCUR_UPDATABLE);
						try {
							_stmt = _conn.createStatement();
						} catch (SQLException e) {
							//Main._logger.reportErrorNotOnConsole("stmt-#"+_clientNum+"=>"+e.getMessage());
							continue;
						}
					}
					try {
						_conn.setAutoCommit(false);
					} catch (SQLException e) {
						//Main._logger.reportErrorNotOnConsole("autocommit-#"+_clientNum+"=>"+e.getMessage());
						continue;
					}
					long xactStartTime = System.currentTimeMillis();
					// run transaction
					for (int i = 0; i < transactionToRun.size(); i++) { 
						String sql = transactionToRun.get(i);
						// select
						// long startTime = System.currentTimeMillis();
						try {
							if(!experimentSubject.getDBMSName().toLowerCase().contains("mysql")){
								long elapsedTime = System.currentTimeMillis() - startTime;
								int remainingTimeout = (int)batchRunTime-((int)elapsedTime)/1000;
								if(remainingTimeout > 0)
									_stmt.setQueryTimeout(remainingTimeout);
								else
									break;
							}
							_stmt.execute(sql); 	// for exploratory
							// reset query timeout 
							// before executing another transaction we will set the new timeout based on remaining time
							//_stmt.setQueryTimeout((int)batchRunTime * 1000);
						} catch(SQLTimeoutException ste){ // timeout has reached 
							if((System.currentTimeMillis() - startTime)/1000 > batchRunTime){
								//Main._logger.reportErrorNotOnConsole("cancel-#"+_clientNum+"=>"+"Client #"+_clientNum+"=>"+ste.getMessage());
								break;
							}
							else continue;
						} catch (SQLException sqe) {
							if((System.currentTimeMillis() - startTime)/1000 > batchRunTime){
								//Main._logger.reportErrorNotOnConsole("querytimeout-#"+_clientNum+"=>"+sqe.getMessage());
								break;
							}
							else continue;
						} catch (Exception ex) {
							if((System.currentTimeMillis() - startTime)/1000 > batchRunTime){
								//Main._logger.reportErrorNotOnConsole("normal-#"+_clientNum+"=>"+ex.getMessage());
								break;
							}
							else continue;
						}
						// long elapsedTime =
						// System.currentTimeMillis()-startTime;
						// stmtRunTimePerXactVec.add(new Long(elapsedTime));
						// Main._logger.outputLog("SQL: " + sql + " => " +
						// elapsedTime + " (msec)");
					}
					//_stmt.executeBatch(); // for confirmatory
					NewCommit();
					// NewClose();
					long elapsedTime = System.currentTimeMillis()- xactStartTime;
					
					if(!_clientRunStats[_clientNum].timeOut){
						_sumRunTime += elapsedTime;
						// stmtRunTimeVec.add(stmtRunTimePerXactVec);
						xactRunTimeVec.add(new Long(elapsedTime));
						_numExecXacts++;
					   // put the current results into the below maps
						_xactNumToRunTimeVecMap.put(xactNum, xactRunTimeVec);
					}
//				} 
//				catch (Exception e) {
//					if(e.getMessage().contains("timeout")){
//						break;
//					}
					// e.printStackTrace();
					// String msg = e.getMessage().toLowerCase();
					// // Main._logger.outputLog("Client #"+_id+"> : " + msg);
					// // DB2:
					// http://www-01.ibm.com/support/docview.wss?uid=swg21424265
					// //DB2 SQL Error: SQLCODE=-952, SQLSTATE=57014 SQL0952N
					// Processing was cancelled due to an interrupt
					// SQLSTATE=57014
					// if(msg.contains("cancel") // sqlserver
					// || msg.contains("closed") // oracle
					// ||msg.contains("952") // db
					// ||msg.contains("interrupt") // mysql
					// ||msg.contains("i/o error") // for postgres
					// ||msg.contains("no current connection") // for javadb
					// ){
					// //Main._logger.outputLog(msg);
					// //
					// Main._logger.outputLog("Client #"+_id+"> # of total transactions: "
					// + numTrans);
					// return;
					// }
					// else{
					// e.printStackTrace();
					// Main._logger.reportError("An unknown error happened. Retrying ... ");
					// if(!msg.contains("aborted") && !msg.contains("deadlock")
					// && !msg.contains("row error"))
					// Main._logger.reportError(e.getMessage());
					// break;
					// if(experimentSubject.getDBMSName().toLowerCase().contains("pgsql")){
					// if(msg.contains("aborted")){
					// continue;
					// }
					// }
//					continue;
					// System.exit(-1);
					// }
					// e.printStackTrace();
					// continue;
//				}
				// numTrans++;
				// if(numTrans%30==0){
				// Main._logger.outputLog("Client #"+_id+"> # of current transactions: "
				// + numTrans);
				// }
			} // while
/************************************************************************************************************************************/		
//if(runTime/1000 > batchRunTime*1.10){
//	if(_clientNum % 100 == 0){
//		String str = String.format("\t>>TimeOuted Client #%d (%d(ms), #Xacts:%d)", _clientNum, runTime, _numExecXacts);
//		Main._logger.writeIntoLog(str);
//	}
//}
/************************************************************************************************************************************/
			_clientRunStats[_clientNum].runTime = runTime;
			_clientRunStats[_clientNum].numMeasuredExecXacts = _numExecXacts;
			finalExit = true;
			if(experimentSubject.getDBMSName().toLowerCase().contains("mysql")){
				batchRunTimer.cancel();
				brt.cancel();
				batchRunTimer2.cancel();
			}
		}

		/****
		 * Return a map of transaction number to ID
		 * 
		 * @return map of transaction number to ID
		 */
		public HashMap<Long, Long> getXactNumToIDMap() {
			return _xactNumToIDMap;
		}

		/****
		 * Return number of transactions that this client has
		 * 
		 * @return number of transactions that this client has
		 */
		public long getNumXactsToHave() {
			return _numXactsToHave;
		}

		/****
		 * Return a map of transaction number to runtime vector
		 * 
		 * @return map of transaction number to runtime vector
		 */
		public HashMap<Long, Vector<Long>> getXactNumToRunTimeVecMap() {
			return _xactNumToRunTimeVecMap;
		}

		/****
		 * Return number of executed transactions
		 * 
		 * @return
		 */
		public int getNumExecXacts() {
			return _numExecXacts;
		}

		public long getSumOfElapsedTime() {
			return _sumRunTime;
		}

		public void destroyed(){
			if (this != null) {
				this.interrupt();
				try {
					this.join();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	        }
		}

		/*****
		 * Obtain client id
		 * @param batchID batch ID
		 * @param clientNum client number
		 * @param iterNum iteration number
		 * @throws Exception 
		 */
		public void setClientID(int batchID, int clientNum) throws Exception {
			// set client id
			int clientID = -1;
			String query = "SELECT clientID from azdblab_client where batchID = "
					+ _batchID + " and clientNum = " + clientNum;
//			Main._logger.writeIntoLog(query);
			
			int succTrials = 1;
			long wait = 10000;
			do{
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQLOnce(query);
				try {
					while (rs.next()) {
						clientID = rs.getInt(1);
					}
					rs.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					Main._logger.reportError(query);
					e.printStackTrace();
				}
				if(clientID == -1){
					Main._logger.reportError("azdblab_client inaccessible <= retry (" + succTrials+")");
					succTrials++;
					try {
						Thread.sleep(wait);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}else{
					break;
				}
			}while(succTrials <= 3);
			
			if(clientID == -1){
				Main._logger.reportError("Tried more than ("+succTrials+") times. Gave up.");
				new Exception("azdblab_client not accessible");
			}
			
			// not existing ...
//			if (clientID == -1) {
//				// obtain a new batch set id
//				clientID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_CLIENT);
//				try {
//					String insertSQL = LabShelfManager.getShelf()
//							.NewInsertTuple(
//									Constants.TABLE_PREFIX
//											+ Constants.TABLE_CLIENT,
//									CLIENT.columns,
//									new String[] { String.valueOf(clientID),
//											String.valueOf(batchID),
//											String.valueOf(clientNum) },
//									CLIENT.columnDataTypes);
//					// Main._logger.outputLog(insertSQL);
//					LabShelfManager.getShelf().commit();
//					// Main._logger.outputLog(String.format("Client %d in Batch %d has been inserted ",
//					// _clientNum, _batchID));
//				} catch (SQLException e) {
//					// // TODO Auto-generated catch block
//					e.printStackTrace();
////					Main._logger.reportError(e.getMessage());
////					System.exit(-1);
//					throw new Exception(e.getMessage());
//				}
//			}
			// set client ID found in DB
			_clientID = clientID;
		}
		
		/*****
		 * Set transactions of clients
		 */
		public void setTransaction() throws Exception {
			// generating transactions
			for (int xactNum = 0; xactNum < _numXactsToHave; xactNum++) {
				Vector<String> transaction = retrieveTransaction(_clientID, xactNum);
				_transactionMap.put(new Long(xactNum), transaction);
			}
		}
		
		/*****
		 * Set transactions of clients
		 */
		public void setTransaction2(HashMap<Long, Long> xactNumToIDMap, 
									HashMap<Long, Vector<String>> tMap) {
			_xactNumToIDMap.putAll(xactNumToIDMap);
			_transactionMap.putAll(tMap);
		}
		
		/****
		 * Retrieve stored transactions
		 * @param clientID
		 * @param xactNum
		 * @return
		 */
		public Vector<String> retrieveTransaction(int clientID, int xactNum) throws Exception {
			Vector<String> retXact = null;
			// get transaction id
			long xactID = -1;
			String xactStatements = "";
			
			long succTrials = 0;
			long waitTime = 10000;
			do{
				ResultSet rs = null;
				try {
//					rs = LabShelfManager.getShelf().executeQuerySQL(
					rs = LabShelfManager.getShelf().executeQuerySQLOnce(
									"SELECT TransactionID, TransactionStr from azdblab_transaction"
									+ " where clientid = " + clientID
									+ " and TransactionNum = " + xactNum);
					while (rs.next()) {
						xactID = rs.getInt(1);
						xactStatements = rs.getString(2);
					}
					rs.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				if(xactID == -1){
					Main._logger.reportError("transaction record is unaccessible for unknown reason ("+succTrials+")");
					succTrials++;
					try{
						Thread.sleep(waitTime);
					}catch(Exception ex){
						ex.printStackTrace();
					}
//					waitTime *= 2;
				}else
					break;
			}while(succTrials <= 3);

			if (xactID == -1) {
				Main._logger.reportError("Tried more than ("+succTrials+") times. Gave up.");
				new Exception("azdblab_transaction not accessible");
			}
			
			// not existing ...
//			if (xactID == -1) {
//				// generation transaction for this client
//				HashMap<Long, Vector<String>> xactMap 	= TransactionGenerator.buildTransaction(_clientID, xactNum);
//				xactID = xactMap.keySet().iterator().next();
//				retXact = xactMap.values().iterator().next();
//			}else{
				retXact = new Vector<String>();
				String[] stmts = xactStatements.split(";");
				for(int i=0;i<stmts.length;i++){
					retXact.add(stmts[i]);
				}
//			}
			
			// build transaction number to ID map
			Long xtNum = new Long(xactNum);
			Long xtID = new Long(xactID);
			
			_xactNumToIDMap.put(xtNum, xtID);
			Long xID = _xactNumToIDMap.get(xtNum);
			if (xID != xtID) {
				Main._logger.outputLog("Transaction ID is different!");
				System.exit(-1);
			}
			return retXact;
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
	 * @param runID
	 *            runID
	 * @param nCores
	 *            # of cores
	 * @param buffCacheSz
	 *            buffer space ratio
	 * @param duration
	 *            duration
	 * @param nRwsFrmUPT
	 *            exclusive locks
	 * @param actvRwPlSz
	 *            effective DB size
	 * @param totalBatchSets
	 *            number of batch sets
	 * @throws Exception
	 */
	@Override
	protected void studyBatchSet(
			int runID, 
			int nCores,
			double buffCacheSz,
			int duration,
			double nRwsFrmSLCT,
			double nRwsFrmUPT, 
			double actvRwPlSz) throws Exception {
		// insert batchset into database
		int batchSetID = stepA(nRwsFrmSLCT, nRwsFrmUPT, actvRwPlSz);
		Main._logger.outputLog(String.format(
				"Start the batchSet #%d(runID:%d,xactSz:%.2f%%/xLcks:%d%%/effDBSz:%d%%) analysis!",
				batchSetID, runID, nRwsFrmSLCT*100, (int)(nRwsFrmUPT*100),
				(int)(actvRwPlSz*100)));

		// make a batchset run result
		int batchSetRunResID = insertBatchSetRunResult(runID, batchSetID, nCores, buffCacheSz, duration);
		
		// prepare for transaction generation
		stepB(nRwsFrmSLCT, nRwsFrmUPT, actvRwPlSz);
				
		// initialize and run this batch set atomically
		// run as many clients as specified in MPL
		// have each client run its own transaction repeatedly
		for (int MPL = smallestMPL; MPL <= largestMPL; MPL += incrMPL) {
			int batchID = insertBatch(batchSetID, MPL);

			int k = 1;
			while(k <= Constants.MAX_ITERS){
//			for (int k = 1; k <= Constants.MAX_ITERS; k++) {// MAX_ITERS: 5 as did in Jung's paper
				Main._logger.outputLog(String.format("<<<<<< %d(/%d) iteration start!", k, Constants.MAX_ITERS));
				
				// run this batch for X times
				int retry = stepC(batchSetRunResID, batchID, MPL, k);
				if(retry == Constants.FAILED_ITER){
					continue;
				}

				Main._logger.outputLog(String.format("<<<<<<<<<< Done!\n"));
				
				// wait for a minute to clean up any remaining transactions
				try{
					Thread.sleep(Constants.THINK_TIME);
				}catch(Exception ex){
					ex.printStackTrace();
				}	
				k++;
			}
			
			// close this batch
			stepD();
		}
		Main._logger.outputLog(String.format(
				"Update the batchset #%d(runID:%d) analysis!", batchSetID,
				runID));
		// Analyze if this batchset thrashes...
		computeMaximumMPL(batchSetRunResID);
	}

	@Override
	protected void stepD() {
		for (Client c : clients) {
			try{
				int num = c.getClientNumber();
				if(c.isAlive()){
					if(num%100==0)
						Main._logger.outputLog(String.format("destroyed Client #d", num));
					c.destroyed();
				}
				if(num % 100 == 0)
					Main._logger.outputLog(String.format("Client #%d has been successfully destroyed.", num));
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}

	private void computeMaximumMPL(int batchSetRunResID) {
		int maxMPL = 0;
		double avgXactProcTime = 0;
		/*****
		 * TODO: Add an algorithm of determining the presence of thrashing on
		 * this batchset
		 */

		// Update this record!
		String updateSQL = "Update " + Constants.TABLE_PREFIX
				+ Constants.TABLE_BATCHSETHASRESULT + " SET MaxMPL = " + maxMPL
				+ ", AvgXactProcTime = " + avgXactProcTime
				+ " WHERE BatchSetRunResID = " + batchSetRunResID;
		Main._logger.outputLog(updateSQL);
		LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
		LabShelfManager.getShelf().commit();
	}

	/****
	 * 
	 * @param runID
	 * @param batchSetID
	 * @return
	 */
	private int insertBatchSetRunResult(int runID, int batchSetID, int numCores, double bufferSpace, int duration) 
	throws Exception{
		Main._logger.outputLog("###<BEGIN>Make a batchsetrun record ################");
		// get batchset run result id
		int batchSetRunResID = -1;

		String sql = "SELECT BatchSetRunResID " + "FROM "
				+ Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASRESULT
				+ " " + "WHERE BatchSetID = " + batchSetID + " and RunID = "
				+ runID;
Main._logger.outputLog(sql);
		int trials = 0;
		int succTrials = 0;
		boolean success = false;
		do{
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			try {
				while (rs.next()) {
					batchSetRunResID = rs.getInt(1);
				}
				rs.close();
				if(batchSetRunResID == -1){
					succTrials++;
					//Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + sql);
					if(succTrials > 5){
						success = true; // not existing
						break;
					}
					continue;
				}
				success = true;
				break;
			} catch (SQLException e1) {
				e1.printStackTrace();
				trials++;
				//Main._logger.writeIntoLog("failed retry " + trials + " <= " + e1.getMessage());
			}
		}while(trials < Constants.TRY_COUNTS);
		
		if(!success)
			throw new Exception ("Labshelf connection is not robust...");
			
		// when not existing ...
		if (batchSetRunResID == -1) {
			// obtain a new batch set id
			batchSetRunResID = LabShelfManager.getShelf().getSequencialID(
					Constants.SEQUENCE_BATCHSETHASRESULT);
			// add transaction
			try {
				String insertSQL = LabShelfManager.getShelf().NewInsertTuple(
						Constants.TABLE_PREFIX
								+ Constants.TABLE_BATCHSETHASRESULT,
						BATCHSETHASRESULT.columns,
						new String[] { 
								String.valueOf(batchSetRunResID),
								String.valueOf(runID),
								String.valueOf(batchSetID), 
								String.valueOf(numCores), 
								String.valueOf(String.format("%.2f", bufferSpace)), 
								String.valueOf(duration), 
								null, 
								null, },
						BATCHSETHASRESULT.columnDataTypes);
Main._logger.outputDebug(insertSQL);
				LabShelfManager.getShelf().commit();
			} catch(SQLIntegrityConstraintViolationException scvex){
				Main._logger.reportError(scvex.getMessage());
//				sql = "SELECT BatchSetRunResID " + "FROM "
//						+ Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASRESULT
//						+ " " + "WHERE BatchSetID = " + batchSetID + " and RunID = "
//						+ runID;
//				
//				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
//				while (rs.next()) {
//					batchSetRunResID = rs.getInt(1);
//				}
//				rs.close();
//					
//				String updateSQL = "Update " + Constants.TABLE_PREFIX
//						+ Constants.TABLE_BATCHSETHASRESULT + " SET "
//						+ " ElapsedTime = " + batchRunTimeMillis + ", "
//						+ " SumExecXacts = " + totalXacts + ", "
//						+ " SumXactProcTime = " + sumXactRunTime
//						+ " WHERE batchSetRunResID = " + batchSetRunResID;
			} catch (Exception e) {
				// TODO Auto-generated catch block
//				System.err.println(e.getMessage());
				Main._logger.reportError(e.getMessage());
			}
		}
Main._logger.outputLog("###<END>Make a batchsetrun record ###################");
		return batchSetRunResID;
	}

	/****
	 * Insert this batch into database
	 * 
	 * @param batchSetID
	 *            batch set ID
	 * @return batch ID
	 */
	private int insertBatch(int batchSetID, int MPL) throws Exception{
		// Check this batch
		int batchID = -1;
		String sql = "SELECT batchID from " + Constants.TABLE_PREFIX
				+ Constants.TABLE_BATCH + " where batchSetID = " + batchSetID
				+ " and MPL = " + MPL;
//		int trials = 0;
//		int succTrials = 0;
//		boolean success = false;
//		do{
//			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
//	//Main._logger.outputLog(sql);
//			try {
//				while (rs.next()) {
//					batchID = rs.getInt(1);
//				}
//				rs.close();
//				if(batchID == -1){
//					succTrials++;
//					Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + sql);
//					if(succTrials > 5){
//						success = true; // not existing
//						break;
//					}
//					continue;
//				}
//				success = true;
//				break;
//			} catch (SQLException e2) {
//				// TODO Auto-generated catch block
//				e2.printStackTrace();
//				trials++;
//				Main._logger.writeIntoLog("failed retry " + trials + " <= " + e2.getMessage());
//			}
//		}while(trials < Constants.TRY_COUNTS);
//		
//		if(!success){
//			throw new Exception ("Labshelf connection is not robust...");
//		}
		
		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
		while (rs.next()) {
			batchID = rs.getInt(1);
		}
		rs.close();
		
		// not existing ...
		if (batchID == -1) {
			// obtain a new batch set id
			batchID = LabShelfManager.getShelf().getSequencialID(
					Constants.SEQUENCE_BATCH);
			try {
				String insertSQL = LabShelfManager.getShelf()
						.NewInsertTuple(
								Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
								BATCH.columns,
								new String[] { String.valueOf(batchID),
										String.valueOf(batchSetID),
										String.valueOf(MPL) },
								BATCH.columnDataTypes);
//Main._logger.outputDebug(insertSQL);
				LabShelfManager.getShelf().commit();
			} catch (Exception e) {
				Main._logger.reportError(e.getMessage());
				e.printStackTrace();
				System.exit(-1);
				// if((e.getMessage()).toLowerCase().contains("unique")){
				// String sql =
				// String.format("SELECT batchID from AZDBLAB_BATCH WHERE batchSetID = %d and MPL = %d",
				// batchSetID, MPL);
				// ResultSet rs2 =
				// LabShelfManager.getShelf().executeQuerySQL(sql);
				// try {
				// while(rs2.next()){
				// batchID = rs2.getInt(1);
				// }
				// rs2.close();
				// } catch (SQLException e1) {
				// // TODO Auto-generated catch block
				// e1.printStackTrace();
				// }
				// }
			}
		}
		return batchID;
	}

	@Override
	protected int stepA(double transactionSize, double exclusiveLockRatio,
			double effectiveDBRatio) {
		int batchSetID = -1;
		String batchSetQuery = "SELECT BatchSetID " + "FROM "
				+ Constants.TABLE_PREFIX + Constants.TABLE_BATCHSET + " "
				+ "WHERE ExperimentID = "
				+ this.getExperimentRun().getMyExperiment().getExperimentID()
				+ " and BatchSzIncr = " + this.incrMPL 
				+ " and XactSz = " + transactionSize 
				+ " and XLockRatio = " + exclusiveLockRatio
				+ " and EffectiveDBSz = " + effectiveDBRatio;
Main._logger.outputDebug(batchSetQuery);
		ResultSet rs = LabShelfManager.getShelf()
				.executeQuerySQL(batchSetQuery);
		try {
			while (rs.next()) {
				batchSetID = rs.getInt(1);
			}
			rs.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		// not existing ...
		if (batchSetID == -1) {
			// obtain a new batch set id
			batchSetID = LabShelfManager.getShelf().getSequencialID(
					Constants.SEQUENCE_BATCHSET);
			// Now, let's insert parameter values into AZDBLab.
			String[] paramVal = new String[BATCHSET.columns.length];
			int i = 0;
			paramVal[i++] = String.format("%d", batchSetID);
			paramVal[i++] = String.format("%d", this.getExperimentRun()
					.getMyExperiment().getExperimentID());
//			paramVal[i++] = String.format("%.2f", dbmsCacheBufferSize);
//			paramVal[i++] = String.format("%d", numCores);
			paramVal[i++] = String.format("%d", incrMPL);
//			paramVal[i++] = String.format("%d", batchRunTime);
			paramVal[i++] = String.format("%.4f", transactionSize);
			paramVal[i++] = String.format("%.2f", exclusiveLockRatio);
			paramVal[i++] = String.format("%.2f", effectiveDBRatio);
			insertBatchSet(paramVal);
		}
		return batchSetID;
	}

	@Override
	protected void stepB(double transactionSize,
			double eXclusiveLcks, double effectiveDBSize) throws Exception {
//		recordRunProgress(0, "Beginning batch (" + batchID
//				+ ") initialization (MPL=" + MPL + ")");
		// number of clients
//		int numClients = MPL;
		// set transaction size
		TransactionGenerator.setXactSize(transactionSize);
		// set exclusive locks
		TransactionGenerator.setXLocks(eXclusiveLcks);
		// set effective db size
		TransactionGenerator.setEffectiveDBSz(effectiveDBSize);
//		recordRunProgress(100, "Done with batch (" + batchID
//				+ ") initialization (MPL=" + MPL + ")");
	}

	private boolean[] barrier;
	private Thread[] terminatingThreadArr;
	
	private long maxConnClosingTime = 0;
	private long maxStmtClosingTime = 0;
	public long maxCommitTime = 0;
	
	/***
	 * Runs transactions per client in a batch
	 * 
	 * @param batchID2
	 * @throws Exception
	 */
	@Override
	protected int stepC(int batchSetRunResID, int batchID, int numClients, int iterNum) throws Exception {
		// TimeoutTerminals terminalTimeOuter = new TimeoutTerminals(clients);
		// Timer xactRunTimer = new Timer();
		// xactRunTimer.scheduleAtFixedRate(terminalTimeOuter, duration*1000,
		// duration*1000);
		// recordRunProgress(0,
		// "Before running the batch for specified duration");
		// timeOut = false;
		clients = new Client[numClients];
		// initialize transaction run stat
		_clientRunStats = new XactRunStatPerClient[numClients+1];		
		for (int i = 0; i < numClients; i++) {
			// assign client number
			int clientNum = i + 1;
			_clientRunStats[clientNum] = new XactRunStatPerClient();
			assert(_clientRunStats[clientNum] != null);
			
			// ready for open connection
			String strDrvName = experimentSubject.getDBMSDriverClassName();
			String strConnStr = experimentSubject.getConnectionString();
			String strUserName = experimentSubject.getUserName();
			String strPassword = experimentSubject.getPassword();
			// Main._logger.outputLog("Client " + (clientNum) +
			// " is being initialized...");
			clients[i] = new Client(batchID, clientNum);
			// set client ID
			clients[i].setClientID(batchID, clientNum);
			// set up client (i+1)
			clients[i].init(strDrvName, strConnStr, strUserName, strPassword);
			// configure this client
			clients[i].setTransaction();
		}

		// flush caches
		experimentSubject.flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
		Main._logger.outputLog("Finish Flushing Disk Drive Cache");
		experimentSubject.flushOSCache();
		Main._logger.outputLog("Finish Flushing OS Cache");
		experimentSubject.flushDBMSCache();
		Main._logger.outputLog("Finish Flushing DBMS Cache");
		
		//batchRunTime = 30;
		long elapsedTimeMillis = 0;
		boolean runStarted = false;
		long startTime = System.currentTimeMillis();
		while ((elapsedTimeMillis = (System.currentTimeMillis() - startTime)) < batchRunTime * 1000) {// global timer
			if (!runStarted){
				for (Client c : clients) {
//					c.setStartTime(startTime);
					c.start();
				}
				runStarted = true;
			}
		}
		
//		boolean runAgain = false;
		// inspect elapsed time
//		long elapsedTimeInSec = elapsedTimeMillis / 1000;
//		if (elapsedTimeInSec > batchRunTime*1.10) {
//			runAgain = true;
//		}
		
		// barrier implementation
		barrier = new boolean[clients.length];
		terminatingThreadArr = new Thread[clients.length];
		for(int i=0;i<clients.length;i++){
			barrier[i] = false;
		}
		maxConnClosingTime = 0;
		maxStmtClosingTime = 0;
		maxCommitTime = 0;
		for (Client c : clients) {
			// locally set timeOut 
			final int clientNum = c.getClientNumber();
			final Connection conn = c.getConnection();
			final Statement st = c.getStatement();
			terminatingThreadArr[clientNum-1] = 
					new Thread(){
				
				public void run(){
					CloseConnection cc = 
							new CloseConnection(clientNum, 
												conn,
												st);
					cc.terminate();
				}
			};
			terminatingThreadArr[clientNum-1].start();
		}
		
		Main._logger.outputLog("------ Barrier Start! -----");
		// Check if every thread reaches the barrier
		boolean exitBarrier;
		long barrierStart = System.currentTimeMillis();
		do{
			exitBarrier = true;
			for(Client c : clients){
				if(c.finalExit) continue; // if yet exit the run routine
				int cNum = c.getClientNumber();
				int i = cNum-1;
				if(!barrier[i]) // ith client has not yet reached the barrier
					exitBarrier = false;
				else{
					if(terminatingThreadArr[i] != null)
						terminatingThreadArr[i].join();
				}
			}
		}while(!exitBarrier);
		long barrierExit = System.currentTimeMillis();
		Main._logger.outputLog("------ Barrier Exit (time: "+ (barrierExit-barrierStart)+"(ms)) ! -----");
		Main._logger.outputLog(String.format("[Commit Max Time: %d(ms), " +
				"Conn Close Max Time: %d(ms), " +
				"Stmt Close Max Time: %d(ms)\n", 
				maxCommitTime,
				maxConnClosingTime, 
				maxStmtClosingTime));
		
		int totalXacts = 0;
		long sumOfBatchRunElapsedTime = 0;
//		XactRunStatPerClient[] stats = new XactRunStatPerClient[clients.length];
		for (Client c : clients) {
			int cNum = c.getClientNumber();
//			if(cNum % 50 == 0){
//				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(ms), " +
//						"batchRunTime: %d(ms), # of execs: %d, timeOut: %d", 
//						cNum, 
//						_clientRunStats[cNum].runTime, 
//						batchRunTime*1000,
//						_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 0 : 1));
//			}
			_clientRunStats[cNum].num				 = cNum;
			_clientRunStats[cNum].id			 	 = c.getClientID();
			_clientRunStats[cNum].numExecXacts 		 = c.getNumExecXacts(); // timeout
			_clientRunStats[cNum].sumOfElapsedTime 	 = c.getSumOfElapsedTime();
			_clientRunStats[cNum].numXactsToHave 		 = c.getNumXactsToHave();
			_clientRunStats[cNum].xactNumToIDMap 		 =  c.getXactNumToIDMap();
			_clientRunStats[cNum].xactNumToRunTimeVecMap = c.getXactNumToRunTimeVecMap();
//			if(_clientRunStats[cNum].timeOut == false 
//			|| _clientRunStats[cNum].numExecXacts != _clientRunStats[cNum].numFinalExecXacts 
//			|| (_clientRunStats[cNum].runTime/1000) > batchRunTime*1.05){
//				if(cNum % 25 == 0){
//					Main._logger.outputLog(String.format("Bad Client #%d => ClientRunTime: %d(ms), " +
//							"batchRunTime: %d(ms), # of execs: %d, timeOut: %d", 
//							cNum, 
//							_clientRunStats[cNum].runTime, 
//							batchRunTime*1000,
//							//_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 0 : 1));
//							_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 1 : 0));
//	//						if(runAgain){
//	//						Main._logger.outputLog(String.format("Iteration #%d failed. Batch #%d will re-run", iterNum, batchID));
//	//				Main._logger.outputLog(String.format("Iteration #%d failed. Batch #%d may need to re-run", iterNum, batchID));
//	//						return Constants.FAILED_ITER;
//				}
//			}
//			if(_clientRunStats[cNum].runTime/1000 > batchRunTime){
//				Main._logger.writeIntoLog(String.format("Client #%d => ClientRunTime: %d(ms)\n", cNum, 
//						_clientRunStats[cNum].runTime));
//			}
//			if(_clientRunStats[cNum].numMeasuredExecXacts != _clientRunStats[cNum].numExecXacts){
//				Main._logger.writeIntoLog(String.format("Client #%d => numMeasured: %d, numCurrXacts: %d\n", cNum, 
//						_clientRunStats[cNum].numMeasuredExecXacts, 
//						_clientRunStats[cNum].numExecXacts));
//			}
			
			totalXacts				 += _clientRunStats[cNum].numExecXacts;
			sumOfBatchRunElapsedTime += _clientRunStats[cNum].sumOfElapsedTime;
		}
		
	

//		i = 0;
//		// record number of transactions successfully executed
//		for (Client c : clients) {
//			_stats[i].id 				= c.getClientID();I
//			_stats[i].num 				= c.getClientNumber();
//			_stats[i].numXactsToHave 	= c.getNumXactsToHave();
//			_stats[i].xactNumToIDMap 	=  c.getXactNumToIDMap();
//			_totalXacts 			  += _stats[i].numRealExecXacts;
//			_sumOfBatchRunElapsedTime += _stats[i].sumOfElapsedTime;
//			i++;
//		}
		
//		for (XactRunStatPerClient stat : _stats) {
//			if(stat.valid == false){
//				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(ms), batchRunTime: %d(ms), # of execs: %d", 
//						stat.num, 
//						stat.clientRunTime, 
//						batchRunTime*1000,
//						stat.numExecXacts));
//			}
//			totalXacts 				 += stat.numExecXacts;
//			sumOfBatchRunElapsedTime += stat.sumOfElapsedTime;
//		}
		
		// insert batch run results
		long batchRunResID = insertBatchRunResult(batchSetRunResID, batchID, iterNum, totalXacts, sumOfBatchRunElapsedTime,
				elapsedTimeMillis);
		//Main._logger.outputLog("batch run result: "+batchRunResID);
		// insert per-client and transaction run results
//		for (XactRunStatPerClient stat : _clientRunStats) {
		for (int i=1;i<= clients.length; i++) {	
			XactRunStatPerClient stat = _clientRunStats[i];
//String str = String.format("client %d's ", stat.id);
//Main._logger.outputLog("###<BEGIN>INSERT " + str + " run result ################");
//Main._logger.outputDebug("executed transactions at Client "	+ stat.num + ": " + stat.numExecXacts);
			long clientRunResID = insertClientRunResult(batchRunResID, stat.id, stat.num, iterNum, stat.sumOfElapsedTime, stat.numExecXacts);
//Main._logger.outputLog("###<End>INSERT " + str + " run result ################");
			
			// insert transaction results
			computeAndInsertXactRunStat(clientRunResID, 		// client run result id
										stat.id, 				// client id
										stat.numXactsToHave,	// # of xacts this client has
										stat.xactNumToIDMap, 	// xact num to id
										stat.numExecXacts,		// number of executed transactions
										stat.xactNumToRunTimeVecMap, // runtime vector 
										iterNum); // iteration number
		}
		long start = System.currentTimeMillis();
		System.gc();
        long elapsedTime = System.currentTimeMillis()-start;
        Main._logger.outputDebug("Executed System.gc(): " + elapsedTime + "(ms)");
        return iterNum;
	}
	
//	private class CloseConnection implements Runnable{
	private class CloseConnection{
		public Connection _conn;
		public Statement _stmt;
		public int _clientNum;
		
		public CloseConnection(int cNum, Connection co, Statement st){
			_conn = co;
			_stmt = st;
			_clientNum = cNum;
		}
		
//		@Override
//		public void run() {
//			terminate();
//		}
		
		public void terminate(){
			// TODO Auto-generated method stub
			long commitTime = 0;
			if(_conn != null){
				long startCommit = System.currentTimeMillis();
				try {
					if(!_conn.isClosed()) _conn.commit();
				} catch (SQLException e) {
					commitTime = System.currentTimeMillis() - startCommit;
					//if(_clientNum % 10 == 0)
						Main._logger.reportErrorNotOnConsole("terminate()-Client #"+_clientNum+"=>"+e.getMessage() + ", commit: "+commitTime+"(ms)");
				}
				commitTime = System.currentTimeMillis() - startCommit;
			}
			
			long start=0, stmtClosingTime = 0;
			long connClosingTime = 0;
			try {
				start = System.currentTimeMillis();
				if(_conn != null && !_conn.isClosed() && _stmt != null) _stmt.close();
				stmtClosingTime = System.currentTimeMillis()-start;
			} catch (SQLException ex) {
				stmtClosingTime = System.currentTimeMillis()-start;
				Main._logger.reportErrorNotOnConsole("stmt-close-#"+_clientNum+"=>"+ex.getMessage()+", stmt: " + stmtClosingTime + "(ms)");
			}
			_stmt = null;
			try {
				start = System.currentTimeMillis();
				if (_conn != null){
					//_conn.abort(null);
//					_conn.rollback();
					if(!_conn.isClosed()) _conn.close();
				}
				connClosingTime = System.currentTimeMillis()-start;
			} catch (SQLException e) {
				connClosingTime = System.currentTimeMillis()-start;
				Main._logger.reportErrorNotOnConsole("conn-close-#"+_clientNum+"=>"+e.getMessage() + ", conn: "+connClosingTime+"(ms)");
			}
			_conn = null;
			
			if(commitTime > maxCommitTime){
				maxCommitTime = connClosingTime;
			}
			if(stmtClosingTime > maxStmtClosingTime){
				maxStmtClosingTime = stmtClosingTime;
			}
			if(connClosingTime > maxConnClosingTime){
				maxConnClosingTime = connClosingTime;
			}
			
/****************************************************************************/
if(commitTime > 180*1000 || stmtClosingTime > 180*1000 || connClosingTime > 180*1000){ // last client
	Main._logger.writeIntoLog(
			String.format("\tTerminated Client #%d(commit: %d(ms), stmt: %d(ms), conn: %d(ms)",
//			String.format("\tTerminated Client #%d(commit: %d(ms), conn: %d(ms)",
					_clientNum, 
					commitTime,
					stmtClosingTime, 
					connClosingTime));
}
/****************************************************************************/
			barrier[_clientNum-1] = true;
		}
	}
	
//	class ClientData{
//		int clientID = -1;
//		HashMap<Long, Vector<String>> xactMap = new HashMap<Long, Vector<String>>();
//		HashMap<Long, Long> tNumToIDMap = new HashMap<Long, Long>();
//	}
//	
//	private ClientData[] cliArray; 
//	
//	void fetchClientIDs(int batchID, int numClients){
//		int iters = numClients / incrMPL;
////		Main._logger.writeIntoLog("maxIters: " + iters + " <= numClients: " + numClients + ", incrMPL:"+incrMPL);
//		for(int j=1;j<=iters;j++){
////			Main._logger.writeIntoLog("("+j+"/"+iters+") labshelf accesss");
//			String clientNumList = "(";
//			for(int i=(j-1)*incrMPL;i<j*incrMPL;i++){
//				cliArray[i] = new ClientData();
//				clientNumList += (i+1);
//				if(i<(j*incrMPL)-1){
//					clientNumList += ",";
//				}
//			}
//			clientNumList += ")";
//			
//			String query = "SELECT clientNum, clientID " +
//					"from azdblab_client " +
//					"where batchID = " + batchID + " and clientNum IN " + clientNumList + " order by clientNum asc";
//			
//			Main._logger.writeIntoLog(query);
//			
//			ResultSet rs = null;
//			try{
//				int clientID = -1;
//				
//				int trials = 0;
//				int succTrials = 0;
//				boolean success = false;
//				
//				do{
//					try{
//						rs = LabShelfManager.getShelf().executeQuerySQL(query);
//						while(rs.next()){
//							int clientNum = rs.getInt(1);
//							clientID = rs.getInt(2);
//							// set client ID found in DB
//							cliArray[clientNum-1].clientID = clientID;
//						}
//						rs.close();
//						if(clientID == -1){
//							succTrials++;
//							Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + query);
//							if(succTrials > 5){
//								success = true; // not existing
//								break;
//							}
//							continue;
//						}
//						success = true;
//						break;
//					}catch(Exception ex){
//						ex.printStackTrace();
//						trials++;
//						Main._logger.writeIntoLog("failed retry " + trials + " <= " + ex.getMessage());
//					}
//				}while(trials < Constants.TRY_COUNTS);
//				
//				if(!success){
//					throw new Exception ("Labshelf connection is not robust...");
//				}
//				
//				if(clientID == -1){
//					for(int i=0;i<numClients;i++){
//						int clientNum = i+1;
//						// obtain a new batch set id
//						clientID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_CLIENT);
//						try {
//							String insertSQL = LabShelfManager.getShelf()
//									.NewInsertTuple(
//											Constants.TABLE_PREFIX
//													+ Constants.TABLE_CLIENT,
//											CLIENT.columns,
//											new String[] { String.valueOf(clientID),
//													String.valueOf(batchID),
//													String.valueOf(clientNum) },
//											CLIENT.columnDataTypes);
//							// Main._logger.outputLog(insertSQL);
//							LabShelfManager.getShelf().commit();
//							// Main._logger.outputLog(String.format("Client %d in Batch %d has been inserted ",
//							// _clientNum, _batchID));
//						} catch (SQLException e) {
//							// // TODO Auto-generated catch block
//							e.printStackTrace();
//							Main._logger.reportError(e.getMessage());
//							System.exit(-1);
//						}
//						// set client ID found in DB
//						cliArray[clientNum-1].clientID = clientID;
//					}
//				}
//			}catch(Exception ex){
//				ex.printStackTrace();
//				
//			}
//		}
//	}
//	
//	void fetchClientXact(int i, int clientID, long numXactsToHave, HashMap<Long, Long> xactNumToIDMap) throws Exception{
//		// generating transactions
//		for (int xactNum = 0; xactNum < numXactsToHave; xactNum++) {
//			Vector<String> transaction = null;
//			// get transaction id
//			long xactID = -1;
//			String xactStatements = "";
//			ResultSet rs = null;
////			try {
//			int trials = 0;
//			int succTrials = 0;
//			boolean success = false;
//			String selectSQL = "";
//			do{
//				try{
//					selectSQL = "SELECT TransactionID, TransactionStr from azdblab_transaction"
//							+ " where clientid = " + clientID
//							+ " and TransactionNum = " + xactNum;
//					rs = LabShelfManager.getShelf().executeQuerySQL(selectSQL);
//					while (rs.next()) {
//						xactID = rs.getInt(1);
//						xactStatements = rs.getString(2);
//					}
//					rs.close();
//					if(xactID == -1){
//						succTrials++;
//						Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + selectSQL);
//						if(succTrials > 5){
//							success = true; // not existing
//							break;
//						}
//						continue;
//					}
//					success = true;
//					break;
//				}catch(Exception ex){
//					ex.printStackTrace();
//					trials++;
//					Main._logger.writeIntoLog("failed retry " + trials + " <= " + ex.getMessage());
//				}
//			}while(trials < Constants.TRY_COUNTS);
//			
//			if(!success){
//				throw new Exception ("Labshelf connection is not robust...");
//			}
////			} catch (SQLException e1) {
////				// TODO Auto-generated catch block
////				e1.printStackTrace();
////			}
//
//			// not existing ...
//			if (xactID == -1) {
//				// generation transaction for this client
//				HashMap<Long, Vector<String>> xactMap 	= TransactionGenerator.buildTransaction(clientID, xactNum);
//				xactID = xactMap.keySet().iterator().next();
//				transaction = xactMap.values().iterator().next();
//			}else{
//				transaction = new Vector<String>();
//				String[] stmts = xactStatements.split(";");
//				for(int j=0;j<stmts.length;j++){
//					transaction.add(stmts[j]);
//				}
//			}
//			
//			// build transaction number to ID map
//			Long xtNum = new Long(xactNum);
//			Long xtID = new Long(xactID);
//			
//			xactNumToIDMap.put(xtNum, xtID);
//			Long xID = xactNumToIDMap.get(xtNum);
//			if (xID != xtID) {
//				Main._logger.outputLog("Transaction ID is different!");
//				System.exit(-1);
//			}
//			cliArray[i].tNumToIDMap = xactNumToIDMap;
//			cliArray[i].xactMap = new HashMap<Long, Vector<String>>();
//			cliArray[i].xactMap.put(new Long(xactNum), transaction);
//		}
//	}
	
//	void setClientData(int i, int batchID, int clientNum, long numXactsToHave, HashMap<Long, Long> xactNumToIDMap){
//		// set client id
//		int clientID = -1;
//		String query = "SELECT clientID from azdblab_client where batchID = "
//				+ batchID + " and clientNum = " + clientNum;
//		Main._logger.writeIntoLog(query);
//		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(query);
//		try {
//			while (rs.next()) {
//				clientID = rs.getInt(1);
//			}
//			rs.close();
//		} catch (SQLException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		// not existing ...
//		if (clientID == -1) {
//			// obtain a new batch set id
//			clientID = LabShelfManager.getShelf().getSequencialID(Constants.SEQUENCE_CLIENT);
//			try {
//				String insertSQL = LabShelfManager.getShelf()
//						.NewInsertTuple(
//								Constants.TABLE_PREFIX
//										+ Constants.TABLE_CLIENT,
//								CLIENT.columns,
//								new String[] { String.valueOf(clientID),
//										String.valueOf(batchID),
//										String.valueOf(clientNum) },
//								CLIENT.columnDataTypes);
//				// Main._logger.outputLog(insertSQL);
//				LabShelfManager.getShelf().commit();
//				// Main._logger.outputLog(String.format("Client %d in Batch %d has been inserted ",
//				// _clientNum, _batchID));
//			} catch (SQLException e) {
//				// // TODO Auto-generated catch block
//				e.printStackTrace();
//				Main._logger.reportError(e.getMessage());
//				System.exit(-1);
//			}
//		}
//		// set client ID found in DB
//		cliArray[i].clientID = clientID;
//		
//		// generating transactions
//		for (int xactNum = 0; xactNum < numXactsToHave; xactNum++) {
//			Vector<String> transaction = null;
//			// get transaction id
//			long xactID = -1;
//			String xactStatements = "";
//			ResultSet rs2 = null;
//			try {
//				rs2 = LabShelfManager.getShelf().executeQuerySQL(
//						"SELECT TransactionID, TransactionStr from azdblab_transaction"
//								+ " where clientid = " + clientID
//								+ " and TransactionNum = " + xactNum);
//				while (rs2.next()) {
//					xactID = rs2.getInt(1);
//					xactStatements = rs2.getString(2);
//				}
//				rs2.close();
//			} catch (SQLException e1) {
//				// TODO Auto-generated catch block
//				// e1.printStackTrace();
//			}
//
//			// not existing ...
//			if (xactID == -1) {
//				// generation transaction for this client
//				HashMap<Long, Vector<String>> xactMap 	= TransactionGenerator.buildTransaction(clientID, xactNum);
//				xactID = xactMap.keySet().iterator().next();
//				transaction = xactMap.values().iterator().next();
//			}else{
//				transaction = new Vector<String>();
//				String[] stmts = xactStatements.split(";");
//				for(int j=0;j<stmts.length;j++){
//					transaction.add(stmts[j]);
//				}
//			}
//			
//			// build transaction number to ID map
//			Long xtNum = new Long(xactNum);
//			Long xtID = new Long(xactID);
//			
//			xactNumToIDMap.put(xtNum, xtID);
//			Long xID = xactNumToIDMap.get(xtNum);
//			if (xID != xtID) {
//				Main._logger.outputLog("Transaction ID is different!");
//				System.exit(-1);
//			}
//			cliArray[i].tNumToIDMap = xactNumToIDMap;
//			cliArray[i].xactMap = new HashMap<Long, Vector<String>>();
//			cliArray[i].xactMap.put(new Long(xactNum), transaction);
//		}
//	}
	
//	/***
//	 * Runs transactions per client in a batch
//	 * 
//	 * @param batchID2
//	 * @throws Exception
//	 */
//	@Override
//	protected int stepC(int batchSetRunResID, int batchID, int numClients, int iterNum) throws Exception {
//		// TimeoutTerminals terminalTimeOuter = new TimeoutTerminals(clients);
//		// Timer xactRunTimer = new Timer();
//		// xactRunTimer.scheduleAtFixedRate(terminalTimeOuter, duration*1000,
//		// duration*1000);
//		// recordRunProgress(0,
//		// "Before running the batch for specified duration");
//		// timeOut = false;
////		clients = new Client[numClients];
////		// initialize transaction run stat
////		_clientRunStats = new XactRunStatPerClient[numClients+1];		
////		for (int i = 0; i < numClients; i++) {
////			// assign client number
////			int clientNum = i + 1;
////			_clientRunStats[clientNum] = new XactRunStatPerClient();
////			// ready for open connection
////			String strDrvName = experimentSubject.getDBMSDriverClassName();
////			String strConnStr = experimentSubject.getConnectionString();
////			String strUserName = experimentSubject.getUserName();
////			String strPassword = experimentSubject.getPassword();
////			// Main._logger.outputLog("Client " + (clientNum) +
////			// " is being initialized...");
////			clients[i] = new Client(batchID, clientNum);
////			// set client ID
////			clients[i].setClientID(batchID, clientNum);
////			// set up client (i+1)
////			clients[i].init(strDrvName, strConnStr, strUserName, strPassword);
////			// configure this client
////			clients[i].setTransaction();
////		}
//		
//		clients = new Client[numClients];
//		// initialize transaction run stat
//		_clientRunStats = new XactRunStatPerClient[numClients+1];
//		if(iterNum == 1){
//			cliArray = new ClientData[numClients];	
//			// set client ID
//			fetchClientIDs(batchID, numClients);
//		}
//		
//		for (int i = 0; i < numClients; i++) {
//			// assign client number
//			int clientNum = i + 1;
//			clients[i] = new Client(batchID, clientNum);
//			_clientRunStats[clientNum] = new XactRunStatPerClient();
//			clients[i].init(experimentSubject.getDBMSDriverClassName(), 
//							experimentSubject.getConnectionString(), 
//							experimentSubject.getUserName(), 
//							experimentSubject.getPassword());
//			// reset measured data
//			clients[i].resetRunTimeVec();
//			// set client id
//			clients[i]._clientID = cliArray[i].clientID;
//			if(iterNum == 1){ // fetch data from labshelf for the first iteration
//				fetchClientXact(i, clients[i]._clientID, clients[i].getNumXactsToHave(), clients[i].getXactNumToIDMap());
//			}
//			clients[i].setTransaction2(cliArray[i].tNumToIDMap, cliArray[i].xactMap);
//		}
//		
//		// flush caches
//		experimentSubject.flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
//		Main._logger.outputLog("Finish Flushing Disk Drive Cache");
//		experimentSubject.flushOSCache();
//		Main._logger.outputLog("Finish Flushing OS Cache");
//		experimentSubject.flushDBMSCache();
//		Main._logger.outputLog("Finish Flushing DBMS Cache");
//		
//		//batchRunTime = 30;
//		long elapsedTimeMillis = 0;
//		boolean runStarted = false;
//		long startTime = System.currentTimeMillis();
//		while ((elapsedTimeMillis = (System.currentTimeMillis() - startTime)) < batchRunTime * 1000) {// global timer
//			if (!runStarted){
//				for (Client c : clients) {
////					c.setStartTime(startTime);
//					c.start();
//				}
//				runStarted = true;
//			}
//		}
//		
////		boolean runAgain = false;
//		// inspect elapsed time
////		long elapsedTimeInSec = elapsedTimeMillis / 1000;
////		if (elapsedTimeInSec > batchRunTime*1.10) {
////			runAgain = true;
////		}
//		
//		for (Client c : clients) {
//			// locally set timeOut 
////			c.setTimeOut();
////			if(c._fail){
////			if(c._numExecXacts-c._numRealExecXacts > 1){
////				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(sec), batchRunTime: %d(sec)", 
////						c._clientNum, 
////						c._clientRunTime, 
////						c._clientRealRunTime,
////						c._numExecXacts, 
////						c._numRealExecXacts, 
////						batchRunTime));
//////				runAgain = true;
////			}
//			c.terminate();
//		}
//		
//		int totalXacts = 0;
//		long sumOfBatchRunElapsedTime = 0;
////		XactRunStatPerClient[] stats = new XactRunStatPerClient[clients.length];
//		for (Client c : clients) {
//			int cNum = c.getClientNumber();
//			if(cNum % 50 == 0){
//				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(ms), " +
//						"batchRunTime: %d(ms), # of execs: %d, timeOut: %d", 
//						cNum, 
//						_clientRunStats[cNum].runTime, 
//						batchRunTime*1000,
//						_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 0 : 1));
//			}
//			_clientRunStats[cNum].num				 = cNum;
//			_clientRunStats[cNum].id			 	 = c.getClientID();
//			_clientRunStats[cNum].numExecXacts 		 = c.getNumExecXacts(); // timeout
//			_clientRunStats[cNum].sumOfElapsedTime 	 = c.getSumOfElapsedTime();
//			_clientRunStats[cNum].numXactsToHave 		 = c.getNumXactsToHave();
//			_clientRunStats[cNum].xactNumToIDMap 		 =  c.getXactNumToIDMap();
//			_clientRunStats[cNum].xactNumToRunTimeVecMap = c.getXactNumToRunTimeVecMap();
//			if(_clientRunStats[cNum].timeOut == false 
//			|| _clientRunStats[cNum].numExecXacts != _clientRunStats[cNum].numFinalExecXacts 
//			|| (_clientRunStats[cNum].runTime/1000) > batchRunTime*1.05){
//				if(cNum % 25 == 0){
//					Main._logger.outputLog(String.format("Bad Client #%d => ClientRunTime: %d(ms), " +
//							"batchRunTime: %d(ms), # of execs: %d, timeOut: %d", 
//							cNum, 
//							_clientRunStats[cNum].runTime, 
//							batchRunTime*1000,
//							_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 1 : 0));
//	//						if(runAgain){
//	//						Main._logger.outputLog(String.format("Iteration #%d failed. Batch #%d will re-run", iterNum, batchID));
//	//				Main._logger.outputLog(String.format("Iteration #%d failed. Batch #%d may need to re-run", iterNum, batchID));
//	//						return Constants.FAILED_ITER;
//				}
//			}
//			totalXacts				 += _clientRunStats[cNum].numExecXacts;
//			sumOfBatchRunElapsedTime += _clientRunStats[cNum].sumOfElapsedTime;
//		}
//		
//	
//
////		i = 0;
////		// record number of transactions successfully executed
////		for (Client c : clients) {
////			_stats[i].id 				= c.getClientID();
////			_stats[i].num 				= c.getClientNumber();
////			_stats[i].numXactsToHave 	= c.getNumXactsToHave();
////			_stats[i].xactNumToIDMap 	=  c.getXactNumToIDMap();
////			_totalXacts 			  += _stats[i].numRealExecXacts;
////			_sumOfBatchRunElapsedTime += _stats[i].sumOfElapsedTime;
////			i++;
////		}
//		
////		for (XactRunStatPerClient stat : _stats) {
////			if(stat.valid == false){
////				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(ms), batchRunTime: %d(ms), # of execs: %d", 
////						stat.num, 
////						stat.clientRunTime, 
////						batchRunTime*1000,
////						stat.numExecXacts));
////			}
////			totalXacts 				 += stat.numExecXacts;
////			sumOfBatchRunElapsedTime += stat.sumOfElapsedTime;
////		}
//		
//		// insert batch run results
//		long batchRunResID = insertBatchRunResult(batchSetRunResID, batchID, iterNum, totalXacts, sumOfBatchRunElapsedTime,
//				elapsedTimeMillis);
//		//Main._logger.outputLog("batch run result: "+batchRunResID);
//		// insert per-client and transaction run results
////		for (XactRunStatPerClient stat : _clientRunStats) {
//		for (int i=1;i<= clients.length; i++) {	
//			XactRunStatPerClient stat = _clientRunStats[i];
////String str = String.format("client %d's ", stat.id);
////Main._logger.outputLog("###<BEGIN>INSERT " + str + " run result ################");
////Main._logger.outputDebug("executed transactions at Client "	+ stat.num + ": " + stat.numExecXacts);
//			long clientRunResID = insertClientRunResult(batchRunResID, stat.id, stat.num, iterNum, stat.sumOfElapsedTime, stat.numExecXacts);
////Main._logger.outputLog("###<End>INSERT " + str + " run result ################");
//			
//			// insert transaction results
//			computeAndInsertXactRunStat(clientRunResID, 		// client run result id
//										stat.id, 				// client id
//										stat.numXactsToHave,	// # of xacts this client has
//										stat.xactNumToIDMap, 	// xact num to id
//										stat.numExecXacts,		// number of executed transactions
//										stat.xactNumToRunTimeVecMap, // runtime vector 
//										iterNum); // iteration number
//		}
//		return iterNum;
//	}
	
//	/***
//	 * Runs transactions per client in a batch
//	 * 
//	 * @param batchID2
//	 * @throws Exception
//	 */
//	@Override
//	protected int stepC(int batchSetRunResID, int batchID, int numClients, int iterNum) throws Exception {
//		// TimeoutTerminals terminalTimeOuter = new TimeoutTerminals(clients);
//		// Timer xactRunTimer = new Timer();
//		// xactRunTimer.scheduleAtFixedRate(terminalTimeOuter, duration*1000,
//		// duration*1000);
//		// recordRunProgress(0,
//		// "Before running the batch for specified duration");
//		// timeOut = false;
//		
//		// only once
//		if(iterNum == 1){
//			clients = new Client[numClients];
//			cliArray = new ClientData[numClients];
//			for (int i = 0; i < numClients; i++) {
//				// assign client number
//				int clientNum = i + 1;
//				clients[i] = new Client(batchID, clientNum);
//				
//				setClientData(clients[i], batchID, clientNum);
//				// set client ID
//				//clients[i].setClientID(batchID, clientNum);
//				// configure this client
//				//clients[i].setTransaction();
//			}
//		}
//		
//		// everytime we should do this
//		// initialize transaction run stat
//		_clientRunStats = new XactRunStatPerClient[numClients+1];
//		for (int i = 0; i < numClients; i++) {
//			// assign client number
//			int clientNum = i + 1;
//			_clientRunStats[clientNum] = new XactRunStatPerClient();
//			// set up client (i+1)
//			clients[i].init(experimentSubject.getDBMSDriverClassName(), 
//							experimentSubject.getConnectionString(), 
//							experimentSubject.getUserName(), 
//							experimentSubject.getPassword());
//			// reset measured data
//			clients[i].resetRunTimeVec();
//			// set client id
//			clients[i]._clientID = cliArray[i].clientID;
//			clients[i].setTransaction2(cliArray[i].tMap);
//		}
//		
//		// flush caches
//		experimentSubject.flushDiskDriveCache(Constants.LINUX_DUMMY_FILE);
//		Main._logger.outputLog("Finish Flushing Disk Drive Cache");
//		experimentSubject.flushOSCache();
//		Main._logger.outputLog("Finish Flushing OS Cache");
//		experimentSubject.flushDBMSCache();
//		Main._logger.outputLog("Finish Flushing DBMS Cache");
//		
//		//batchRunTime = 30;
//		long elapsedTimeMillis = 0;
//		boolean runStarted = false;
//		long startTime = System.currentTimeMillis();
//		while ((elapsedTimeMillis = (System.currentTimeMillis() - startTime)) < batchRunTime * 1000) {// global timer
//			if (!runStarted){
//				for (Client c : clients) {
////					c.setStartTime(startTime);
//					c.start();
//				}
//				runStarted = true;
//			}
//			long msec = System.currentTimeMillis() - startTime;
//			if(msec % 30000 == 0){
//				Main._logger.outputLog("elapsed time: " + msec + " (secs)"); 
//			}
//		}
//		
////		boolean runAgain = false;
//		// inspect elapsed time
////		long elapsedTimeInSec = elapsedTimeMillis / 1000;
////		if (elapsedTimeInSec > batchRunTime*1.10) {
////			runAgain = true;
////		}
//		
//		for (Client c : clients) {
//			// locally set timeOut 
////			c.setTimeOut();
////			if(c._fail){
////			if(c._numExecXacts-c._numRealExecXacts > 1){
////				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(sec), batchRunTime: %d(sec)", 
////						c._clientNum, 
////						c._clientRunTime, 
////						c._clientRealRunTime,
////						c._numExecXacts, 
////						c._numRealExecXacts, 
////						batchRunTime));
//////				runAgain = true;
////			}
//			c.terminate();
//		}
//		
//		int totalXacts = 0;
//		long sumOfBatchRunElapsedTime = 0;
////		XactRunStatPerClient[] stats = new XactRunStatPerClient[clients.length];
//		for (Client c : clients) {
//			int cNum = c.getClientNumber();
//			if(cNum % 50 == 0){
//				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(ms), " +
//						"batchRunTime: %d(ms), # of execs: %d, # of final execs: %d, timeOut: %d", 
//						cNum, 
//						_clientRunStats[cNum].runTime, 
//						batchRunTime*1000,
//						_clientRunStats[cNum].numExecXacts,
//						_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 0 : 1));
//			}
//			_clientRunStats[cNum].num				 = cNum;
//			_clientRunStats[cNum].id			 	 = c.getClientID();
//			_clientRunStats[cNum].numExecXacts 		 = c.getNumExecXacts(); // timeout
//			_clientRunStats[cNum].sumOfElapsedTime 	 = c.getSumOfElapsedTime();
//			_clientRunStats[cNum].numXactsToHave 		 = c.getNumXactsToHave();
//			_clientRunStats[cNum].xactNumToIDMap 		 =  c.getXactNumToIDMap();
//			_clientRunStats[cNum].xactNumToRunTimeVecMap = c.getXactNumToRunTimeVecMap();
//			if(_clientRunStats[cNum].timeOut == false 
//			|| _clientRunStats[cNum].numExecXacts != _clientRunStats[cNum].numFinalExecXacts 
//			|| (_clientRunStats[cNum].runTime/1000) > batchRunTime*1.05){
//				if(cNum % 25 == 0){
//					Main._logger.outputLog(String.format("Bad Client #%d => ClientRunTime: %d(ms), " +
//							"batchRunTime: %d(ms), # of execs: %d, # of final execs: %d, timeOut: %d", 
//							cNum, 
//							_clientRunStats[cNum].runTime, 
//							batchRunTime*1000,
//							_clientRunStats[cNum].numExecXacts,
//	//						_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 0 : 1));
//							_clientRunStats[cNum].numFinalExecXacts, _clientRunStats[cNum].timeOut ? 1 : 0));
//	//						if(runAgain){
//	//						Main._logger.outputLog(String.format("Iteration #%d failed. Batch #%d will re-run", iterNum, batchID));
//	//				Main._logger.outputLog(String.format("Iteration #%d failed. Batch #%d may need to re-run", iterNum, batchID));
//	//						return Constants.FAILED_ITER;
//				}
//			}
//			totalXacts				 += _clientRunStats[cNum].numExecXacts;
//			sumOfBatchRunElapsedTime += _clientRunStats[cNum].sumOfElapsedTime;
//		}
//		
//	
//
////		i = 0;
////		// record number of transactions successfully executed
////		for (Client c : clients) {
////			_stats[i].id 				= c.getClientID();
////			_stats[i].num 				= c.getClientNumber();
////			_stats[i].numXactsToHave 	= c.getNumXactsToHave();
////			_stats[i].xactNumToIDMap 	=  c.getXactNumToIDMap();
////			_totalXacts 			  += _stats[i].numRealExecXacts;
////			_sumOfBatchRunElapsedTime += _stats[i].sumOfElapsedTime;
////			i++;
////		}
//		
////		for (XactRunStatPerClient stat : _stats) {
////			if(stat.valid == false){
////				Main._logger.outputLog(String.format("Client #%d => ClientRunTime: %d(ms), batchRunTime: %d(ms), # of execs: %d", 
////						stat.num, 
////						stat.clientRunTime, 
////						batchRunTime*1000,
////						stat.numExecXacts));
////			}
////			totalXacts 				 += stat.numExecXacts;
////			sumOfBatchRunElapsedTime += stat.sumOfElapsedTime;
////		}
//		
//		// insert batch run results
//		long batchRunResID = insertBatchRunResult(batchSetRunResID, batchID, iterNum, totalXacts, sumOfBatchRunElapsedTime,
//				elapsedTimeMillis);
//		//Main._logger.outputLog("batch run result: "+batchRunResID);
//		// insert per-client and transaction run results
////		for (XactRunStatPerClient stat : _clientRunStats) {
//		for (int i=1;i<= clients.length; i++) {	
//			XactRunStatPerClient stat = _clientRunStats[i];
////String str = String.format("client %d's ", stat.id);
////Main._logger.outputLog("###<BEGIN>INSERT " + str + " run result ################");
////Main._logger.outputDebug("executed transactions at Client "	+ stat.num + ": " + stat.numExecXacts);
//			long clientRunResID = insertClientRunResult(batchRunResID, stat.id, stat.num, iterNum, stat.sumOfElapsedTime, stat.numExecXacts);
////Main._logger.outputLog("###<End>INSERT " + str + " run result ################");
//			
//			// insert transaction results
//			computeAndInsertXactRunStat(clientRunResID, 		// client run result id
//										stat.id, 				// client id
//										stat.numXactsToHave,	// # of xacts this client has
//										stat.xactNumToIDMap, 	// xact num to id
//										stat.numExecXacts,		// number of executed transactions
//										stat.xactNumToRunTimeVecMap, // runtime vector 
//										iterNum); // iteration number
//		}
//		return iterNum;
//	}

	/******
	 * Insert batch run result
	 * 
	 * @param batchID
	 *            batch ID
	 * @param iterNum
	 *            iteration number
	 * @param totalXacts
	 *            total transactions executed
	 * @param batchRunTimeMillis
	 *            elapsed time milliseconds
	 * @throws Exception
	 */
	protected long insertBatchRunResult(long batchSetRunResID, int batchID,
			int iterNum, int totalXacts, long sumXactRunTime,
			long batchRunTimeMillis) throws Exception {
//		Main._logger.outputLog("###<BEGIN>INSERT batch Result ################");
		float elapsedTimeSec = batchRunTimeMillis / 1000F;
		float tps = (float) totalXacts / elapsedTimeSec;
		
		
long batchSetID = -1;
long MPL = 0;
String query = "SELECT BatchSetID, MPL " + "FROM "
		+ Constants.TABLE_PREFIX + Constants.TABLE_BATCH + " "
		+ "WHERE BatchID = " + batchID;
ResultSet rs2 = LabShelfManager.getShelf().executeQuerySQL(query);
try {
	while (rs2.next()) {
		batchSetID = rs2.getInt(1);
		MPL = rs2.getInt(2);
	}
	rs2.close();
} catch (Exception ex) {
	ex.printStackTrace();
}
		String tpsResult = String.format(
				"============== <BatchSet(%d)-MPL(%d)> TPS RESULTS (%d) =====================",
				batchSetID,
				MPL,
				iterNum);
		Main._logger.outputLog(tpsResult);
		Main._logger.outputLog("Time: " + batchRunTimeMillis + " ms");
		Main._logger.outputLog("Total transactions: " + totalXacts);
		Main._logger.outputLog("Transactions per second: "	+ String.format("%.2f", tps));

		// obtain a batchrunresult record identifier
		long batchRunResID = -1;
		String batchSetQuery = "SELECT batchRunResID " + "FROM "
				+ Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT + " "
				+ "WHERE BatchSetRunResID = " + batchSetRunResID
				+ " and BatchID = " + batchID + " and IterNum = " + iterNum;
Main._logger.outputDebug(batchSetQuery);

		int trials = 0;
		int succTrials = 0;
		boolean success = false;
		String selectSQL = "";
		do{
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(batchSetQuery);
			try {
				while (rs.next()) {
					batchRunResID = rs.getInt(1);
				}
				rs.close();
				if(batchRunResID == -1){
					succTrials++;
//					Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + selectSQL);
					if(succTrials > 5){
						success = true; // not existing
						break;
					}
					continue;
				}
				success = true;
				break;
			} catch (Exception ex) {
				ex.printStackTrace();
				trials++;
//				Main._logger.writeIntoLog("failed retry " + trials + " <= " + ex.getMessage());
			}
		}while(trials < Constants.TRY_COUNTS);

		if(!success)
			new Exception("labshelf server is not robust");
//		ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(batchSetQuery);
//		while (rs.next()) {
//			batchRunResID = rs.getInt(1);
//		}
//		rs.close();
				
		String insertSQL = "";
		if (batchRunResID == -1) {
			batchRunResID = LabShelfManager.getShelf().getSequencialIDToLong(
					Constants.SEQUENCE_BATCHHASRESULT);
			assert (batchRunResID < 1) : "Batch result ID is less than 0. So weird...";
			try{
				insertSQL = LabShelfManager.getShelf().NewInsertTuple(
						Constants.TABLE_PREFIX + Constants.TABLE_BATCHHASRESULT,
						BATCHHASRESULT.columns,
						new String[] { String.valueOf(batchRunResID),
								String.valueOf(batchSetRunResID),
								String.valueOf(batchID), String.valueOf(iterNum),
								String.valueOf(batchRunTimeMillis),
								String.valueOf(totalXacts),
								String.valueOf(sumXactRunTime) },
						BATCHHASRESULT.columnDataTypes);
Main._logger.outputDebug(insertSQL);
				LabShelfManager.getShelf().commit();
			}catch(SQLIntegrityConstraintViolationException scve){
				Main._logger.reportError(scve.getMessage());
				String updateSQL = "Update " + Constants.TABLE_PREFIX
						+ Constants.TABLE_BATCHHASRESULT + " SET "
						+ " ElapsedTime = " + batchRunTimeMillis + ", "
						+ " SumExecXacts = " + totalXacts + ", "
						+ " SumXactProcTime = " + sumXactRunTime
						+ " WHERE BatchSetRunResID = " + batchSetRunResID
						+ " and batchID = " + batchID + " and iterNum = " + iterNum;
				Main._logger.outputLog(updateSQL);
				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
			}catch(Exception ex){
				Main._logger.outputDebug(ex.getMessage());
			}
			
		} else {
Main._logger.outputDebug(insertSQL);
			String updateSQL = "Update " + Constants.TABLE_PREFIX
					+ Constants.TABLE_BATCHHASRESULT + " SET "
					+ " ElapsedTime = " + batchRunTimeMillis + ", "
					+ " SumExecXacts = " + totalXacts + ", "
					+ " SumXactProcTime = " + sumXactRunTime
					+ " WHERE BatchSetRunResID = " + batchSetRunResID
					+ " and batchID = " + batchID + " and iterNum = " + iterNum;
Main._logger.outputLog(updateSQL);
			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
		}
		Main._logger.outputLog("==============================================");
		return batchRunResID;
	}

	/****
	 * Insert per-client result into AZDBLab
	 * 
	 * @param batchRunResID
	 * @param clientID
	 *            client ID
	 * @param iterNum
	 *            iteration number
	 * @param sumXactElapsedTime
	 *            sum of elapsed times of transactions executed in this iteration
	 * @param numXacts
	 *            number of transactions executed in this iteration
	 * @return client run result
	 * @throws Exception 
	 */
	private long insertClientRunResult(long batchRunResID, 
									   long clientID,
									   long clientNum,
									   int iterNum, 
									   long sumXactElapsedTime, 
									   long numExecXacts) throws Exception {
		// get client run result identifier
		long clientRunResID = -1;
		try {
			// get client run result id
			String sql = "SELECT ClientRunResID " + "FROM "
					+ Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT
					+ " WHERE BatchRunResID = " + batchRunResID
					+ " and ClientID = " + clientID + " and IterNum = " + iterNum;
//Main._logger.outputDebug(sql);
			int trials = 0;
			int succTrials = 0;
			boolean success = false;
			do{
				try{
					ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
					while (rs.next()) {
						clientRunResID = rs.getInt(1);
					}
					rs.close();
					if(clientRunResID == -1){
						succTrials++;
//						Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + sql);
						if(succTrials > 5){
							success = true; // not existing
							break;
						}
						continue;
					}
					success = true;
					break;
				}catch(Exception ex){
					ex.printStackTrace();
					trials++;
//					Main._logger.writeIntoLog("failed retry " + trials + " <= " + ex.getMessage());
				}
			}while(trials < Constants.TRY_COUNTS);

			if(!success){
				throw new Exception ("Labshelf connection is not robust...");
			}
			
//			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
//			while (rs.next()) {
//				clientRunResID = rs.getInt(1);
//			}
//			rs.close();
			
			String insertSQL = "";
			// when not existing ...
			if (clientRunResID == -1) {
				clientRunResID = LabShelfManager.getShelf()
						.getSequencialIDToLong(
								Constants.SEQUENCE_CLIENTHASRESULT);
				assert (clientRunResID < 1) : "Client result ID is less than 0. So weird...";
				insertSQL = LabShelfManager.getShelf().NewInsertTuple(
						Constants.TABLE_PREFIX
								+ Constants.TABLE_CLIENTHASRESULT,
						CLIENTHASRESULT.columns,
						new String[] { String.valueOf(clientRunResID),
								String.valueOf(batchRunResID),
								String.valueOf(clientID),
								String.valueOf(iterNum),
								String.valueOf(numExecXacts),
								String.valueOf(sumXactElapsedTime) },
						CLIENTHASRESULT.columnDataTypes);
if(clientNum % 100 == 0)
	Main._logger.outputDebug("Client =>"+clientNum+" "+insertSQL);
//				LabShelfManager.getShelf().commit();
			} else {
if(clientNum % barrier.length == 0)
	Main._logger.outputDebug("Client =>"+clientNum+" "+insertSQL);
				String updateSQL = "Update " + Constants.TABLE_PREFIX
						+ Constants.TABLE_CLIENTHASRESULT
						+ " SET NumExecXacts = " + numExecXacts
						+ ", SumXactProcTime = " + sumXactElapsedTime
						+ " WHERE batchRunResID = " + batchRunResID
						+ " and clientID = " + clientID
						+ " and iterNum = " + iterNum;
//Main._logger.outputLog(updateSQL);
				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
				LabShelfManager.getShelf().commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
			Main._logger.reportError(e.getMessage());
			// in case that client run result record is already in the db
			if(e.getMessage().contains("unique")){
				String updateSQL = "Update " + Constants.TABLE_PREFIX
						+ Constants.TABLE_CLIENTHASRESULT
						+ " SET NumExecXacts = " + numExecXacts
						+ ", SumXactProcTime = " + sumXactElapsedTime
						+ " WHERE batchRunResID = " + batchRunResID
						+ " and clientID = " + clientID
						+ " and iterNum = " + iterNum;
//Main._logger.outputLog(updateSQL);
				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
				LabShelfManager.getShelf().commit();
				String sql = "SELECT ClientRunResID " + "FROM "
						+ Constants.TABLE_PREFIX + Constants.TABLE_CLIENTHASRESULT
						+ " WHERE BatchRunResID = " + batchRunResID
						+ " and ClientID = " + clientID + " and IterNum = " + iterNum;
//Main._logger.outputDebug(sql);
				clientRunResID = -1;
//				int trials = 0;
//				int succTrials = 0;
//				boolean success = false;
//				do{
//					try{
//						ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
//						while (rs.next()) {
//							clientRunResID = rs.getInt(1);
//						}
//						rs.close();
//						if(clientRunResID == -1){
//							succTrials++;
//							Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + sql);
//							if(succTrials > 5){
//								success = true; // not existing
//								break;
//							}
//							continue;
//						}
//						success = true;
//						break;
//					}catch(Exception ex){
//						ex.printStackTrace();
//						trials++;
//						Main._logger.writeIntoLog("failed retry " + trials + " <= " + ex.getMessage());
//					}
//				}while(trials < Constants.TRY_COUNTS);
//				if(!success){
//					throw new Exception ("Labshelf connection is not robust...");
//				}
				ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
				while (rs.next()) {
					clientRunResID = rs.getInt(1);
				}
				rs.close();
				return clientRunResID;
			}else{
				throw new SQLException("Labshelf connection has some unknown problem.");
			}
		}
		return clientRunResID;
	}

	// /****
	// * Insert transaction run results of this client
	// * @param c Client
	// * @param clientResID client result ID
	// * @param iterNum iteration number
	// */
	// private void insertTransactionRunResult(Client c, long clientResID, int
	// iterNum) {
	// long numXactsToHave = c.getNumXactsToHave();
	// HashMap<Long, Long> xactNumToIDMap = c.getXactNumToIDMap();
	// // HashMap<Long, Long> stmtNumToIDMap = c.getStmtNumToIDMap();
	// HashMap<Long, Vector<Long>> xactNumToRunTimeVecMap =
	// c.getXactNumToRunTimeVecMap();
	// // HashMap<Long, Vector<Vector<Long>>> stmtRunTimeVecPerXactMap =
	// c.getXactNumToStmtRunTimeVecMap();
	//
	// // insert transaction results;
	// for(int xtNum=0;xtNum<numXactsToHave;xtNum++){
	// Long xactNum = new Long(xtNum);
	// // Get transaction executions results at transaction/statement levels
	// Vector<Long> xactRunTimeVec = xactNumToRunTimeVecMap.get(xactNum);
	// if(xactRunTimeVec == null){
	// System.out.println("transaction runtime vector is null");
	// System.exit(-1);
	// }
	// // Vector<Vector<Long>> stmtRunTimeVecPerXact =
	// stmtRunTimeVecPerXactMap.get(xactNum);
	// // if(stmtRunTimeVecPerXact == null){
	// // System.out.println("Statement runtime vector is null");
	// // System.exit(-1);
	// // }
	// // Get transaction ID in database
	// Long xactID = xactNumToIDMap.get(xactNum);
	// if(xactID == null){
	// System.out.println("Transaction ID can't be null");
	// System.exit(-1);
	// }
	// String str = String.format("Client %d's transaction", c.getClientID());
	// Main._logger.outputLog("###<BEGIN>INSERT "+ str
	// +" run result ################");
	// long sumTotalTime = 0;
	// double avgXactProcTime = 0;
	// long minXactProcTime = Long.MAX_VALUE;
	// long maxXactProcTime = Long.MIN_VALUE;
	// // For each iteration, we insert the transaction results into database.
	// for(int tIter=0;tIter<xactRunTimeVec.size();tIter++){
	// long xactResID = 0;
	// long runTime = xactRunTimeVec.get(tIter);
	// if(runTime > maxXactProcTime)
	// maxXactProcTime = runTime;
	// if(runTime < minXactProcTime)
	// minXactProcTime = runTime;
	// sumTotalTime += runTime;
	// try {
	// // // get transaction run result id
	// // String sql = "SELECT CLIRESID from "+Constants.TABLE_PREFIX +
	// Constants.TABLE_CLIENTHASRESULT
	// // +" where CLIENTID = " + c.getClientID() + " and ITERNUM = " + iterNum;
	// // ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
	// // try {
	// // while(rs.next()){
	// // clientResID = rs.getInt(1);
	// // }
	// // rs.close();
	// // } catch (SQLException e) {
	// // // TODO Auto-generated catch block
	// // e.printStackTrace();
	// // }
	// // // not existing ...
	// // if(xactResID == -1){
	// // xactResID =
	// LabShelfManager.getShelf().getSequencialIDToLong(Constants.SEQUENCE_TRANSACTIONHASRESULT);
	// // assert (xactResID < 1) : "xactResID is less than 1. Weird..";
	// // LabShelfManager.getShelf().NewInsertTuple(
	// // Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTIONHASRESULT,
	// // TRANSACTIONHASRESULT.columns,
	// // new String[] {
	// // String.valueOf(xactResID), // xact has result ID
	// // String.valueOf(clientResID),// client has result ID
	// // String.valueOf(xactID), // xact ID
	// // String.valueOf(tIter), // iterNum
	// // String.valueOf(runTime) // xactRunTime
	// // },
	// // TRANSACTIONHASRESULT.columnDataTypes);
	// // LabShelfManager.getShelf().commit();
	// // }
	// // else{
	// // String updateSQL = "Update " + Constants.TABLE_PREFIX +
	// Constants.TABLE_TRANSACTIONHASRESULT
	// // + " SET RUNTIME = " + runTime
	// // + " WHERE CLIRESID = " + clientResID + " and xactID = " + xactID +
	// " and XACTITERNUM = " + tIter;
	// // Main._logger.outputLog(updateSQL);
	// // LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
	// // }
	// xactResID =
	// LabShelfManager.getShelf().getSequencialIDToLong(Constants.SEQUENCE_TRANSACTIONHASRESULT);
	// assert (xactResID < 1) : "xactResID is less than 1. Weird..";
	// String insertSQL =
	// LabShelfManager.getShelf().NewInsertTuple(
	// Constants.TABLE_PREFIX + Constants.TABLE_TRANSACTIONHASRESULT,
	// TRANSACTIONHASRESULT.columns,
	// new String[] {
	// String.valueOf(xactResID), // xact has result ID
	// String.valueOf(clientResID),// client has result ID
	// String.valueOf(xactID), // xact ID
	// String.valueOf(tIter), // iterNum
	// String.valueOf(runTime) // xactRunTime
	// },
	// TRANSACTIONHASRESULT.columnDataTypes);
	// //Main._logger.outputDebug(insertSQL);
	// LabShelfManager.getShelf().commit();
	// } catch (SQLException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// // // insert statement results
	// // Vector<Long> stmtRunTimePerXact =
	// stmtRunTimeVecPerXact.get(xactNum.intValue());
	// // if(stmtRunTimePerXact != null){
	// // for(int sIter=0;sIter<stmtRunTimePerXact.size();sIter++){
	// // Long stmtIterNum = new Long(sIter);
	// // Long stmtID = stmtNumToIDMap.get(stmtIterNum);
	// // if(stmtID == null){
	// // System.out.println("Statement ID can't be null");
	// // System.exit(-1);
	// // }
	// // try {
	// //
	// LabShelfManager.getShelf().NewInsertTuple(Constants.TABLE_PREFIX+Constants.TABLE_STATEMENTHASRESULT,
	// // STATEMENTHASRESULT.columns,
	// // new String[]{
	// // String.valueOf(xactResID), // transaction has result ID
	// // String.valueOf(stmtID), // statement ID
	// // String.valueOf(sIter), // statmentIterNum
	// // String.valueOf(xactRunTimeVec.get(sIter)), // statementRunTime
	// // null // statementLockWaitTime
	// // },
	// // STATEMENTHASRESULT.columnDataTypes);
	// // LabShelfManager.getShelf().commit();
	// // } catch (SQLException e) {
	// // // TODO Auto-generated catch block
	// // e.printStackTrace();
	// // }
	// // }
	// // }
	// }
	// avgXactProcTime = (double)sumTotalTime / (double)xactRunTimeVec.size();
	// String strStat =
	// String.format("[numXacts: %d, min: %d (ms), max: %d (ms), avg: %.2f (ms)]",
	// xactRunTimeVec.size(),
	// minXactProcTime,
	// maxXactProcTime,
	// avgXactProcTime);
	// Main._logger.outputLog("###<End>INSERT "+ str +" run result => " +
	// strStat);
	// }
	// }

	/*****
	 * Insert transaction run result into DB
	 * @param clientRunResID client run result ID
	 * @param xactID transaction ID
	 * @param numExecXacts number of executed transactions
	 * @param minXactProcTime minimum transaction processing time
	 * @param maxXactProcTime maximum transaction processing time
	 * @param sumXactProcTime sum of transaction processing time
	 * @param sumLockWaitTime sum of lock wait time
	 */
	private void insertTransactionRunResult(long clientRunResID,
											long xactID,
											long numExecXacts,
											long minXactProcTime,
											long maxXactProcTime,
											long sumXactProcTime,
											long sumLockWaitTime) throws Exception{
		String updateSQL = "Update " + Constants.TABLE_PREFIX
				+ Constants.TABLE_TRANSACTIONHASRESULT + " SET "
				+ " NumExecs = " + numExecXacts
				+ ", minXactProcTime = " + minXactProcTime
				+ ", maxXactProcTime = " + maxXactProcTime
				+ ", sumXactProcTime = " + sumXactProcTime
				+ ", sumLockWaitTime = " + sumLockWaitTime
				+ " WHERE clientRunResID = " + clientRunResID + " and TransactionID = " + xactID;
		
		// get transaction run result identifier
		long xactRunResID = -1;
		try {
			int trials = 0;
			int succTrials = 0;
			boolean success = false;
			// get client run result id
			String sql = "SELECT TransactionRunResID " + "FROM "
					+ Constants.TABLE_PREFIX
					+ Constants.TABLE_TRANSACTIONHASRESULT + " "
					+ "WHERE ClientRunResID = " + clientRunResID
					+ " and TransactionID = " + xactID;
//Main._logger.outputDebug(sql);
			do{
				try{
					ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
					while (rs.next()) {
						xactRunResID = rs.getInt(1);
					}
					rs.close();
					if(xactRunResID == -1){
						succTrials++;
//						Main._logger.writeIntoLog("successed retry: " + succTrials + " <= " + sql);
						if(succTrials > 5){
							success = true; // not existing
							break;
						}
						continue;
					}
					success = true;
					break;
				}catch(Exception ex){
					ex.printStackTrace();
					trials++;
//					Main._logger.writeIntoLog("failed retry " + trials + " <= " + ex.getMessage());
				}
			}while(trials < Constants.TRY_COUNTS);

			if(!success){
				throw new Exception ("Labshelf connection is not robust...");
			}
			
			ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
			while (rs.next()) {
				xactRunResID = rs.getInt(1);
			}
			rs.close();
			
			String insertSQL = "";
			// when not existing ...
			if (xactRunResID == -1) {
				xactRunResID = LabShelfManager.getShelf()
						.getSequencialIDToLong(
								Constants.SEQUENCE_TRANSACTIONHASRESULT);
				assert (xactRunResID < 1) : "transaction result ID is less than 0. So weird...";
				insertSQL = LabShelfManager
						.getShelf()
						.NewInsertTuple(
								Constants.TABLE_PREFIX
										+ Constants.TABLE_TRANSACTIONHASRESULT,
								TRANSACTIONHASRESULT.columns,
								new String[] {
										String.valueOf(xactRunResID), // xact has result ID
										String.valueOf(clientRunResID),// client has result ID
										String.valueOf(xactID), 		// xact ID
										String.valueOf(numExecXacts), // numExecs
										String.valueOf(minXactProcTime), // minXactRunTime
										String.valueOf(maxXactProcTime), // maxXactRunTime
										String.valueOf(sumXactProcTime), // sumXactRunTime
										String.valueOf(sumLockWaitTime) // lockWaitTime
								}, TRANSACTIONHASRESULT.columnDataTypes);
				LabShelfManager.getShelf().commit();
//if(clientNum)
//Main._logger.outputLog(insertSQL);
			} else {
//Main._logger.outputLog(insertSQL);
//				Main._logger.outputLog(updateSQL);
				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
				LabShelfManager.getShelf().commit();
			}
		} catch (Exception e) {
			e.printStackTrace();
			Main._logger.reportErrorNotOnConsole(updateSQL);
			Main._logger.reportError(e.getMessage());
			if(e.getMessage().contains("unique")){
				LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
				LabShelfManager.getShelf().commit();
			}else{
				throw new Exception(e.getMessage());
			}
		}
	}
	
	/*****
	 * Compute insert into DB transaction run result stats  
	 * @param clientRunResID client run result identifier
	 * @param clientID client ID
	 * @param numXactsToHave # of transactions
	 * @param xactNumToIDMap transaction number to ID
	 * @param xactNumToRunTimeVecMap transaction number to runTime
	 * @param iterNum iteration number
	 */
	private void computeAndInsertXactRunStat(long clientRunResID,
											 long clientID,
											 long numXactsToHave,
											 HashMap<Long, Long> xactNumToIDMap,
											 long numExecXacts,
											 HashMap<Long, Vector<Long>> xactNumToRunTimeVecMap,
											 int iterNum) throws Exception {
		// HashMap<Long, Long> stmtNumToIDMap = c.getStmtNumToIDMap();
		// HashMap<Long, Vector<Vector<Long>>> stmtRunTimeVecPerXactMap =
		// c.getXactNumToStmtRunTimeVecMap();

		// insert transaction results;
		for (int xtNum = 0; xtNum < numXactsToHave; xtNum++) {
			Long xactNum = new Long(xtNum);
			// Get transaction ID in database
			Long xactID = xactNumToIDMap.get(xactNum);
			if (xactID == null) {
				System.out.println("Transaction ID can't be null");
				System.exit(-1);
			}
			
			// insert transaction run result
			String str = String.format("client (%d)'s transaction (%d) at i=%d", clientID, xactNum, iterNum);
//			Main._logger.outputLog("###<BEGIN>INSERT " + str + " run result ################");
			// Get transaction executions results at transaction/statement
			// levels
			Vector<Long> xactRunTimeVec = xactNumToRunTimeVecMap.get(xactNum);
			if (xactRunTimeVec == null) {
//				System.out.println("transaction runtime vector is null");
				// insert transaction run results
				insertTransactionRunResult(clientRunResID, xactID, 0, -1, -1, -1, -1);
				// print out run stat
				String strStat = String.format("[numXacts: 0]");
				if(clientID % barrier.length == 0)
					Main._logger.writeIntoLog(str + "=>" + strStat);
				return;
			}

			// compute stats of transaction runs
			long sumLockWaitTime = 0;
//			double avgLockWaitTime = 0;
			long sumXactProcTime = 0;
//			double avgXactProcTime = 0;
			long minXactProcTime = Long.MAX_VALUE;
			long maxXactProcTime = Long.MIN_VALUE;
//			numExecXacts = xactRunTimeVec.size();
			// For each iteration, we insert the transaction results into database.
			for (int tIter = 0; tIter < numExecXacts; tIter++) {
				long runTime = xactRunTimeVec.get(tIter);
				if (runTime > maxXactProcTime)
					maxXactProcTime = runTime;
				if (runTime < minXactProcTime)
					minXactProcTime = runTime;
				sumXactProcTime += runTime;
			}
//			avgXactProcTime = (double) sumXactProcTime
//					/ (double) xactRunTimeVec.size();

			// compute lock wait time
			for (int tIter = 0; tIter < numExecXacts; tIter++) {
				long runTime = xactRunTimeVec.get(tIter);
				sumLockWaitTime += (runTime - minXactProcTime);
			}
//			avgLockWaitTime = (double) sumLockWaitTime / (double)numExecXacts;

			if(minXactProcTime == Long.MAX_VALUE) minXactProcTime = -1;
			if(maxXactProcTime == Long.MIN_VALUE) maxXactProcTime = -1;
			// insert transaction run results
			insertTransactionRunResult(clientRunResID, xactID, numExecXacts, minXactProcTime, maxXactProcTime, sumXactProcTime, sumLockWaitTime);
			// print out run stat
			String strStat = String
					.format("[numXacts: %d, min: %d(ms), max: %d(ms), sum: %d(ms), lw: %d(ms)]",
							numExecXacts, minXactProcTime,
							maxXactProcTime, sumXactProcTime, sumLockWaitTime);
			if(clientID % barrier.length == 0)
				Main._logger.outputLog(str + "=>" + strStat);
//			Main._logger.outputLog("###<End>INSERT " + str + " run result => " + strStat);
		} // end for
	}
}