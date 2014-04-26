package plugins;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.TimerTask;
import java.util.Vector;

import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.InternalTable;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TableDefinition;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.model.dataDefinition.ForeignKey;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;
import azdblab.plugins.scenario.ScenarioBasedOnTransaction;

/**
 * We study DBMS thrashing
 * 
 * @author yksuh
 * 
 * Default Setting: read committed, a single core, MPL=100
 */

public class ThrashingScenario extends ScenarioBasedOnTransaction {
//	protected class TimeoutTerminals extends TimerTask{
//		ArrayList<Client> clients = null; 
//	    public TimeoutTerminals(ArrayList<Client> cls) { 
//	    	clients = cls;
//	    }
//
//	    public void run() {
//	      try {
//	    	  for(Client c : clients){
//	    		  c.close();
//	    	  }
//	      } catch (Exception ex) {
//	        Main._logger.outputDebug(ex.getMessage());
//	      }
//	    }
//	  }
	
	public static final boolean refreshTable = true;
	
	public ThrashingScenario(ExperimentRun expRun) {
		super(expRun);
		// TODO Auto-generated constructor stub
		installTables();
	}

	public Vector<InternalTable> getTables() {
		if (refreshTable) {
//			LabShelfManager.getShelf()
//					.dropTable(QUERYSTATEVALUATION.TableName);
//			LabShelfManager.getShelf().dropTable(RUNHASASPECT.TableName);
//			LabShelfManager.getShelf().dropTable(QUERYEXECUTIONPROCS.TableName);
		}

		Vector<InternalTable> toRet = new Vector<InternalTable>();
//		toRet.add(QUERYSTATEVALUATION);
//		toRet.add(RUNHASASPECT);
		return toRet;
	}
	
	/***
	 * Creates sequence
	 * @param seqName	sequence name
	 */
	private void createSequence(String seqName, int startNum) {
		String createSequence = "CREATE SEQUENCE " + seqName + " START WITH "+ startNum +" NOMAXVALUE";
		LabShelfManager.getShelf().executeUpdateSQL(createSequence);
		System.out.println(seqName + " Created");
	}
	
	private void installTables() {
		Vector<InternalTable> lstInternalTables = getTables();
		if (lstInternalTables == null) {
			return;
		}
//		TableDefinition.vecPluginTables.addAll(lstInternalTables);
		for (int i = 0; i < lstInternalTables.size(); i++) {
			InternalTable tmp = lstInternalTables.get(i);
			if (!LabShelfManager.getShelf().tableExists(tmp.TableName)) {
				LabShelfManager.getShelf().createTable(tmp.TableName,
						tmp.columns, tmp.columnDataTypes,
						tmp.columnDataTypeLengths, tmp.primaryKey,
						tmp.foreignKey);
//				if(tmp.TableName.equalsIgnoreCase(QueryParamEvaluation.PKQUERYPARAM.TableName)){
//					String alterTblSQL = "alter table " + QueryParamEvaluation.PKQUERYPARAM + " MODIFY value NUMBER(10, 3)";
//					LabShelfManager.getShelf().executeUpdateSQL(alterTblSQL);
//				}
				if (tmp.strSequenceName != null) {
					createSequence(tmp.strSequenceName, 1);
				}
			}
		}
	}

//	/***
//	 * Installs all internal tables
//	 * @throws Exception
//	 */
//	private void installAll() throws Exception {
//		for (int i = 0; i < INTERNAL_TABLES.length; i++) {
//System.out.println(INTERNAL_TABLES[i].TableName + " Creating...");
//			createTable(INTERNAL_TABLES[i].TableName,
//					INTERNAL_TABLES[i].columns,
//					INTERNAL_TABLES[i].columnDataTypes,
//					INTERNAL_TABLES[i].columnDataTypeLengths,
//					INTERNAL_TABLES[i].columnNullable,
//					INTERNAL_TABLES[i].uniqueConstraintColumns,
//					INTERNAL_TABLES[i].primaryKey,
//					INTERNAL_TABLES[i].foreignKey);
//System.out.println(INTERNAL_TABLES[i].TableName + " Created");
//			if (INTERNAL_TABLES[i].strSequenceName != null) {
//				createSequence(INTERNAL_TABLES[i].strSequenceName);
//			}
//		}
	
	public Client[] clients;
	protected boolean timeOut = false;
	static class TransactionGenerator{
		private static double effectiveDBSz = 0;
		private static double selectivity = 0;
		
		public static double getEffectiveDBRatio(){
			return effectiveDBSz;
		}
		
		public static double getSelectivity(){
			return selectivity;
		}
		
		private static RepeatableRandom reprand = new RepeatableRandom();
		
//		public static String buildSQL(){
//			String res = "";
//			return res;
//		}
		
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
		private static int getRandomNumber(int start, int finish) {
			int range = finish - start;
			range++; // since Math.random never returns 1.0
			// int result = (int) ( range * Math.random() );

			// The cast to INT truncates, so we will get an integer between 0 and
			// (finish - start)
			int result = 0;
			result = (int) (range * reprand.getNextDouble());
			// ensure range is from start to finish
			result += start;
			return result;
		}
		
		
		public static String buildDML() {
			/** UPDATE ft_HT1 SET id3 = 1 WHERE id2 < 0 **/
			String idxCol = "id1";
//			int tblNum = getRandomNumber(0, 4);
			int tblNum = 0;
			int chosenCol = getRandomNumber(0, 4);
			int newValue = 1;
			
			Table tbl = null;
			Column[] cols = null;
//			for(int i=0;i<myXactTables.length;i++){
				tbl = myXactTables[tblNum];
				cols = myXactTables[tblNum].columns;
//			}
			
			/*********************************
			 * Ver1: MPL 1000
			 */
			/*double selectivity = 0.2;
//			long chosenCard = (long)((double)getRandomNumber(1, 10) / (double)100) * tbl.hy_min_card;
			int chosenCard = (int)(selectivity * tbl.hy_min_card);				
			int maxRange = (int)tbl.hy_min_card-chosenCard;
			long min = (long)((double)getRandomNumber(0, maxRange));*/
			/***************************/
			
			/*********************************
			 * Ver2: MPL 1000 with different effective db size 
			 */
			selectivity = Constants.BASE_SELECTIVITY;
//			long chosenCard = (long)((double)getRandomNumber(1, 10) / (double)100) * tbl.hy_min_card;
			int numLocks = (int)(selectivity * tbl.hy_min_card);
			int min = 0;
			int max = (int)((double)tbl.hy_min_card * effectiveDBSz);
			long pivot = (long)((double)getRandomNumber(0, max-numLocks));
			/***************************/
				
			String sql = "UPDATE ";
			sql += tbl.table_name_with_prefix + " ";
			sql += "SET " + cols[chosenCol].myName + " = " + newValue + " ";
			sql += "WHERE " + idxCol + " >= " + pivot + " and " + idxCol +" < " + (pivot+numLocks);
			
//			String sql = "SELECT count(*) ";
//			sql += "FROM " + tbl.table_name_with_prefix + " ";
//			sql += "WHERE " + idxCol + " >= " + min + " and " + idxCol +" < " + (min+chosenCard);
		
//			Vector<String> selected_attributes = new Vector<String>();
//			// building the pieces of the SQL query.
//			String fromSQL = buildFromClause(usedFromTables);
//			String selectSQL = buildSelectClause(usedFromTables, numColumnsInSelect, selected_attributes);
//			String whereSQL = buildWhereClause(queryDomains, usedFromTables, numSimplePredicates, cartesianEliminator);
//			// if (use_aggregate_ &&
//			// (reprand.getNextRandomInt() % aggregate_frequency_ == 0)) {
//			if (aggregate) {
//				AggregateStmt aggregate_stmt = DefaultGrammarSpecificGenerator
//						.BuildAggregateStatement(aggfunction_name_,
//								selected_attributes, reprand, selectSQL);
//				return aggregate_stmt.aggregate_statement + fromSQL + whereSQL
//						+ aggregate_stmt.groupby_statement;
//			} else {
//				return selectSQL + fromSQL + whereSQL;
//			}
			return sql;
		}

		public static void setEffectiveDBSz(double edb_size) {
			effectiveDBSz = edb_size;
		}
	}
	
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
		private String driverName = "";
		private String connStr = "";
		private String userName = "";
		private String password = "";
		
		public Client(int i){
			_id = i;
		}
		
		public int getID(){
			return _id;
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
		
		public void init(String drvName, String strConnStr, String strUserName, String strPassword, double edbSz){
//Main._logger.outputLog("login details: " + strConnStr + ", " + strUserName + ", " + strPassword);
			try{
				driverName=drvName; connStr=strConnStr; userName=strUserName; password=strPassword;
				// Main._logger.outputLog("login details: " + strConnectString +  ", " +  strUserName + ", " + strPassword + ", " + strdrvname);
				Class.forName(drvName);
				_conn = DriverManager.getConnection(strConnStr, strUserName, strPassword);
//Main._logger.outputLog(experimentSubject.getDBMSName());
//				if(experimentSubject.getDBMSName().toLowerCase().contains("teradata")){
//					experimentSubject.open(false);
//				}
				_stmt = _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
//				TransactionGenerator tg = new TransactionGenerator();
				
				/****
				 * Ver2
				 */
				_sql = TransactionGenerator.buildDML();
Main._logger.outputLog(_sql); // this should later be replaced by sql array
				return;
			} catch (SQLException | ClassNotFoundException sqlex) {
//				sqlex.printStackTrace();
//				Main._logger.outputLog("login details: " + strConnStr + ", " + strUserName + ", " + strPassword);
			} 
//			catch (ClassNotFoundException e) {
//				e.printStackTrace();
//				System.exit(1); 
//			}
		}
		
		
		public void run(){
//			long starttime = System.currentTimeMillis();
			while(true){
				if(timeOut) break;
//			while(System.currentTimeMillis() - starttime < duration*1000){
//			boolean localTimeOut = false;
//			while(true){
				try {
					if(_conn == null){ 
						Class.forName(driverName);
						_conn = DriverManager.getConnection(connStr, userName, password);
					}
					_conn.setAutoCommit(false);
					_stmt = _conn.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
					if(experimentSubject.getDBMSName().toLowerCase().contains("teradata")){
						_stmt.executeUpdate("DATABASE azdblab_user;");
						_conn.commit();
					}
					_stmt.execute(_sql);
					_stmt.close();
					_conn.commit();
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
				} catch (SQLException | ClassNotFoundException e) {
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
			return;
		}
		
		public int getNumTransactions(){
			timeOut = true;
			return numTrans;
		}
	}
	
	protected void stepA(int numClients, double edbSz) throws Exception {
//		recordRunProgress(0, "Beginning the initialization of a batch of terminals");
//		ArrayList<Client> ret = new ArrayList<Client>();
		// assume that numClients > 0
		TransactionGenerator.setEffectiveDBSz(edbSz);
		clients = new Client[numClients];
		for(int i=0;i<numClients;i++){
//			Thread thread1 = new Thread() {
//				public void run() {
//					try {
//						String strDrvName = experimentSubject.getDBMSDriverClassName();
//						String strConnStr = experimentSubject.getConnectionString();
//						String strUserName = experimentSubject.getUserName();
//						String strPassword = experimentSubject.getPassword();
//						System.out.format("Client %d is being initialized... (login-details: %s, %s, %s, %s)\n", (i+1), strDrvName, strConnStr, strUserName, strPassword);
//						clients[i] = new Client(i+1);
//						clients[i].init(strDrvName,strConnStr,strUserName,strPassword);
//						ret.add(clients[i]);
//					} catch (IOException e) {
//						// TODO Auto-generated catch block
//						e.printStackTrace();
//					}
//				}
//			};
//			thread1.start();
			String strDrvName = experimentSubject.getDBMSDriverClassName();
			String strConnStr = experimentSubject.getConnectionString();
			String strUserName = experimentSubject.getUserName();
			String strPassword = experimentSubject.getPassword();
Main._logger.outputLog("Client " + (i+1) + " is being initialized...");
			clients[i] = new Client(i+1);
			clients[i].init(strDrvName,strConnStr,strUserName,strPassword, edbSz);
//			ret.add(clients[i]);
//			recordRunProgress((int) ((double) (i + 1) / (double) numClients* 100), "Initializing a batch of terminals");
		}
//		recordRunProgress(100, "Done with the initialization of a batch of terminals");
//		return ret;
	}

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_TPS_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_TPS_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}

	protected void stepB(int MPL) throws Exception {
		
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
			while((elapsedTimeMillis=(System.currentTimeMillis() - startTime)) < duration*1000){// global timer
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
				Main._logger.outputLog("Client #"+c.getID()+"> # of total transactions: " + numXacts);
				totalXacts += numXacts;
			}
			
			
	//		CloseClient[] clist = new CloseClient[clients.size()];
	//		for (int i = 0; i < clients.size(); i++) {
	//			clist[i] = new CloseClient(clients.get(i));
	//			clist[i].start();
	//		}
	//		for(Client c : clients){
	////			c.close();
	////			Main._logger.outputLog("Waiting for Client #"+c.getID()+" to die...");
	////			c.join();
	////			Main._logger.outputLog("Done..");
	//		}
	//		close(clients);
	//		recordRunProgress(100, "Done with running the batch");
	//		long elapsedTimeMillis = endTime - startTime;
			long elapsedTimeInSec = elapsedTimeMillis / 1000;
			if(elapsedTimeInSec != duration){ k--; continue; }
			recordTPSResult(MPL, totalXacts, elapsedTimeMillis, TransactionGenerator.getEffectiveDBRatio(), k, TransactionGenerator.getSelectivity());
			
			// wait for three minutes to clean up any remaining transactions 
			try{
				Thread.sleep(Constants.THINK_TIME); 
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}
	
	class CloseClient extends Thread{
		public Client currClient = null;
		public CloseClient(Client c) {
			currClient = c;
		}
		
		public void run() {
			try {
				currClient.join();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
//	class CloseClient extends Thread {
//		public Client currClient = null;
//
//		public CloseClient(Client c) {
//			currClient = c;
//		}
//
//		public void run() {
//			try {
//				currClient.join();
//				Main._logger.outputLog("Client #" + currClient.getID() + " has been dead...");
//				// currClient.join();
//			} catch (Exception ex) {
//				// Main._logger.outputDebug(ex.getMessage());
//			}
//		}
//	}
//	
//	protected void close(ArrayList<Client> clients) throws Exception {
//		CloseClient[] clist = new CloseClient[clients.size()];
//		for (int i = 0; i < clients.size(); i++) {
//			clist[i] = new CloseClient(clients.get(i));
//		}
//		for (CloseClient cc : clist) {
//			Main._logger.outputLog("Client #" + cc.currClient.getID() + " is waiting to die ...");
//			cc.start();
//		}
//	}
	
//	/**
//	 * The definition of the data definition internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable EXPERIMENTSPEC = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTSPEC,
//			new String[] { "ExperimentSpecID", "Name", "Kind", "FileName",
//					"SourceXML" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 100, 1,
//					100, -1 }, new int[] { 0, 0, 0, 0, 0 }, null,
//			new String[] { "ExperimentSpecID" }, null,
//			Constants.SEQUENCE_EXPERIMENTSPEC);
//	
	public static InternalTable BATCHSET = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_RUNHASASPECT,
			new String[] { "AspectName", "RunID" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 100, 10 },
			new int[] { 0, 0 }, null, new String[] { "AspectName", "RunID" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);
//	
//	public static InternalTable QUERYSTATEVALUATION = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_QUERYSTATEVALUATION,
//			new String[] { "QueryExecutionID", "TotalOtherTime",
//					"NumPhantomsPresent", "TotalFaults", "StoppedProcesses",
//					"TotalDBMSTime", "NumStartedProcesses",
//					"NumExecutedProcesses", "userModeTicks",
//					"lowPriorityUserModeTicks", "systemModeTicks",
//					"idleTaskTicks", "ioWait", "irq", "softirq",
//					"stealStolenTicks", "NumBadProcs", "dbmsIOWait", "otherIOWait" },
//			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_NUMBER},
//			new int[] { 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
//					10, 10, 10, 10, 10 },
//			new int[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
//			null,
//			new String[] { "QueryExecutionID" },
//			new ForeignKey[] { new ForeignKey(
//					new String[] { "QueryExecutionID" }, Constants.TABLE_PREFIX
//							+ Constants.TABLE_QUERYEXECUTION,
//					new String[] { "QueryExecutionID" }, " ON DELETE CASCADE") },
//			null);
//	

	@Override
	protected void analyzeBatchSet(int batchSetID, double transactionSize,
			double eXclusiveLocks, double effectiveDBSize, int totalBatchSets)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void stepA(int batchSetID, double transactionSize,
			double exclusiveLockRatio, double effectiveDBRatio)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void stepB(int batchID, int MPL, double transactionSize,
			double eXclusiveLcks, double effectiveDBSize) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void stepC(int MPL) throws Exception {
		// TODO Auto-generated method stub
		
	}

//	
//	private void saveAllProcesses(int runID) {
//		try {
//			LabShelfManager.getShelf().insertTuple( 
//				Constants.TABLE_PREFIX
//					+ Constants.TABLE_QUERYEXECUTIONPROCS,
//				QUERYEXECUTIONPROCS.columns,
//				new String[] {
//					String.valueOf(queryExecutionID),
//					String.valueOf(curProc.processID),
//					curProc.vm?"1":"0",
//					String.valueOf(curProc.processName.trim()),
//					String.valueOf(curProc.uTick),
//					String.valueOf(curProc.sTick),
//					String.valueOf(curProc.uTick+curProc.sTick),
//					String.valueOf(curProc.min_flt),
//					String.valueOf(curProc.maj_flt),
//                	String.valueOf(curProc.blockio_count),
//                	String.valueOf(curProc.blockio_delay),
//                	String.valueOf(curProc.btime),
//                    String.valueOf(curProc.cpu_count),
//                    String.valueOf(curProc.cpu_delay),
//                    String.valueOf(curProc.cpu_run_real_total),
//	                String.valueOf(curProc.cpu_run_virtual_total),
//        	        String.valueOf(curProc.cpu_scaled_run_real_total),
//                	String.valueOf(curProc.etime),
//                    String.valueOf(curProc.freepgs_count),
//                    String.valueOf(curProc.freepgs_delay),
//                    String.valueOf(curProc.nivcsw),
//	                String.valueOf(curProc.nvcsw),
//        	        String.valueOf(curProc.read_bytes),
//                	String.valueOf(curProc.read_char),
//                    String.valueOf(curProc.read_syscalls),
//                    String.valueOf(curProc.sTickScaled),
//                    String.valueOf(curProc.swapin_count),
//	                String.valueOf(curProc.swapin_delay),
//        	        String.valueOf(curProc.uTickScaled),
//                	String.valueOf(curProc.write_bytes),
//                    String.valueOf(curProc.write_char),
//                    String.valueOf(curProc.write_syscalls) },
//				QUERYEXECUTIONPROCS.columnDataTypes);
//
//		} catch (Exception e) {
//			e.printStackTrace();
//			String updateSQL = "Update " + Constants.TABLE_PREFIX
//					+ Constants.TABLE_QUERYEXECUTIONPROCS
//					+ " set ProcessName = '" + toSave.get(i).processName.trim()+"',"
//			        + " UTicks = " + toSave.get(i).uTick + ","
//					+ " STicks = " + toSave.get(i).sTick + " , " 
//					+ " min_flt = " + toSave.get(i).min_flt+ ", " 
//					+ " maj_flt = " + toSave.get(i).maj_flt+ ", "
//					+ " blkio_count = " + toSave.get(i).blockio_count+ ", "
//					+ " blockio_delay = " + toSave.get(i).blockio_delay+ ", "
//					+ " btime = " + toSave.get(i).btime+ ", "
//					+ " cpu_count = " + toSave.get(i).cpu_count+ ", "
//					+ " cpu_delay = " + toSave.get(i).cpu_delay+ ", "
//					+ " cpu_run_real_total = " + toSave.get(i).cpu_run_real_total+ ", "
//					+ " cpu_run_virtual_total = " + toSave.get(i).cpu_run_virtual_total+ ", "
//					+ " cpu_scaled_run_real_total = " + toSave.get(i).cpu_scaled_run_real_total+ ", "
//					+ " etime = " + toSave.get(i).etime+ ", "
//					+ " freepgs_count = " + toSave.get(i).freepgs_count+ ", "
//					+ " freepgs_delay = " + toSave.get(i).freepgs_delay+ ", "
//					+ " nivcsw = " + toSave.get(i).nivcsw+ ", "
//					+ " nvcsw = " + toSave.get(i).nvcsw+ ", "
//					+ " ProcessID = " + toSave.get(i).processID+ ", "
//					+ " read_bytes = " + toSave.get(i).read_bytes+ ", "
//					+ " read_char = " + toSave.get(i).read_char+ ", "
//					+ " read_syscalls = " + toSave.get(i).read_syscalls+ ", "
//					+ " sTickScaled = " + toSave.get(i).sTickScaled+ ", "
//					+ " swapin_count = " + toSave.get(i).swapin_count+ ", "
//					+ " swapin_delay = " + toSave.get(i).swapin_delay+ ", "
//					+ " uTickScaled = " + toSave.get(i).uTickScaled+ ", "
//					+ " write_bytes = " + toSave.get(i).write_bytes+ ", "
//					+ " write_char = " + toSave.get(i).write_char+ ", "
//					+ " write_syscalls = " + toSave.get(i).write_syscalls
//					+ " where QueryExecutionID = " + queryExecutionID
//					+ " and processID = " + toSave.get(i).processID;
//			LabShelfManager.getShelf().executeUpdateSQL(updateSQL);
//		}
//		LabShelfManager.getShelf().commit();
//	}
//	
//	/**
//	 * The definition of the experiment internal table.
//	 * 
//	 * @see InternalTable
//	 */
//	public static final InternalTable EXPERIMENT = new InternalTable(
//			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT, new String[] {
//					"ExperimentID", "UserName", "NotebookName",
//					"ExperimentName", "Scenario", "SourceFileName",
//					"CreateDate", "SourceXML" }, new int[] {
//					GeneralDBMS.I_DATA_TYPE_NUMBER,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_VARCHAR,
//					GeneralDBMS.I_DATA_TYPE_DATE,
//					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 100, 100,
//					100, 100, 500, -1, -1 }, new int[] { 0, 0, 0, 0, 0, 0, 0,
//					0 }, new String[] { "UserName", "NotebookName",
//					"ExperimentName" }, new String[] { "ExperimentID" },
//			new ForeignKey[] { new ForeignKey(new String[] { "UserName",
//					"NotebookName" }, Constants.TABLE_PREFIX
//					+ Constants.TABLE_NOTEBOOK, new String[] { "UserName",
//					"NotebookName" }, " ON DELETE CASCADE") },
//			Constants.SEQUENCE_EXPERIMENT);
//	/***
//	 * Creates sequence
//	 * @param seqName	sequence name
//	 */
//	private void createSequence(String seqName) {
//		String createSequence = "CREATE SEQUENCE " + seqName + " START WITH 1 NOMAXVALUE";
//		try {
//			stmt.execute(createSequence);
//			System.out.println(seqName + " Created");
//		} catch (SQLException e) {
//			System.out.println(seqName + " already Exists");
//		}
//	}
//	/***
//	 * Installs all internal tables
//	 * @throws Exception
//	 */
//	private void installAll() throws Exception {
//		for (int i = 0; i < INTERNAL_TABLES.length; i++) {
//System.out.println(INTERNAL_TABLES[i].TableName + " Creating...");
//			createTable(INTERNAL_TABLES[i].TableName,
//					INTERNAL_TABLES[i].columns,
//					INTERNAL_TABLES[i].columnDataTypes,
//					INTERNAL_TABLES[i].columnDataTypeLengths,
//					INTERNAL_TABLES[i].columnNullable,
//					INTERNAL_TABLES[i].uniqueConstraintColumns,
//					INTERNAL_TABLES[i].primaryKey,
//					INTERNAL_TABLES[i].foreignKey);
//System.out.println(INTERNAL_TABLES[i].TableName + " Created");
//			if (INTERNAL_TABLES[i].strSequenceName != null) {
//				createSequence(INTERNAL_TABLES[i].strSequenceName);
//			}
//		}
	
//	/**
//	 * 
//	 * @param userName
//	 * @param notebookName
//	 * @param experimentName
//	 * @param dbms
//	 * @param startTime
//	 * @param currentStage
//	 * @param percentage
//	 * @throws SQLException
//	 */
//	public void insertExperimentRun(String dbms, String startTime,
//			String currentStage, double percentage) throws SQLException {
//		int expID = getExperimentID(userName, notebookName, experimentName);
//		//Main._logger.outputLog("getting experiment id .... done! ");
//		if (expID == -1) {
//			Main._logger.reportError("Insert ExperimentRun Err.");
//			return;
//		}
//
//		int runID = LabShelfManager.getShelf().getSequencialID("SEQ_RUNID");
//		//Main._logger.outputLog("getting run id .... done! ");
//
//		String[] columns = new String[] { "RunID", "ExperimentID", "DBMSName",
//				"StartTime", "CurrentStage", "Percentage" };
//		String[] columnValues = new String[] { String.valueOf(runID),
//				String.valueOf(expID), dbms, startTime, currentStage,
//				String.valueOf(percentage) };
//		int[] dataTypes = new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
//				GeneralDBMS.I_DATA_TYPE_NUMBER,
//				GeneralDBMS.I_DATA_TYPE_VARCHAR,
//				GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
//				GeneralDBMS.I_DATA_TYPE_VARCHAR, GeneralDBMS.I_DATA_TYPE_NUMBER };
//
//		// Inserts a test into the DBMS with no test result.
//		LabShelfManager.getShelf().insertTupleToNotebook(
//				EXPERIMENTRUN.TableName, columns, columnValues, dataTypes);
//		//Main._logger.outputLog("getting experiment run inserted .... done! ");
//
//		LabShelfManager.getShelf().commitlabshelf();
//	}
}
