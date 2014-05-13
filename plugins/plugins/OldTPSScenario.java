package plugins;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.TimerTask;
import azdblab.Constants;
import azdblab.executable.Main;
import azdblab.labShelf.RepeatableRandom;
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

//public class OldTPSScenario extends ScenarioBasedOnTransaction {
public class OldTPSScenario extends ScenarioBasedOnTransaction {
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
	
	
	public OldTPSScenario(ExperimentRun expRun) {
		super(expRun);
		// TODO Auto-generated constructor stub
	}

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
	
	//@Override
	protected void stepA(int batchSetID, int numClients, double edbSz) throws Exception {
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

	//@Override
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

	@Override
	protected void analyzeBatchSet(int batchSetID, double transactionSize,
			double eXclusiveLocks, double effectiveDBSize)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected int stepA(double transactionSize, double exclusiveLockRatio, double effectiveDBRatio)
			throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	

//	@Override
	protected void stepC(int batchSetRunResID, int batchID) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected int stepC(int batchSetRunResID, int batchID, int numClients,
			int iterNum) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	protected void stepD() throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void stepB(double transactionSize, double eXclusiveLcks,
			double effectiveDBSize) throws Exception {
		// TODO Auto-generated method stub
		
	}
}
