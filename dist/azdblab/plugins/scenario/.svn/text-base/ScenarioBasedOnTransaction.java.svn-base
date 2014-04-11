package azdblab.plugins.scenario;

/*
* Copyright (c) 2012, Arizona Board of Regents
* 
* See LICENSE at /cs/projects/tau/azdblab/license
* See README at /cs/projects/tau/azdblab/readme
* AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
* This is a Laboratory Information Management System
* 
* Authors:
* Young-Kyoon Suh (http://www.cs.arizona.edu/~yksuh/)
*/
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.TreeSet;
import java.util.Vector;

import azdblab.Constants;
import azdblab.exception.PausedExecutor.PausedExecutorException;
import azdblab.exception.PausedRun.PausedRunException;
import azdblab.exception.sanitycheck.SanityCheckException;
import azdblab.executable.Main;
import azdblab.labShelf.GeneralDBMS;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.TransactionStat;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.model.analyzer.QueryExecution;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

/**
 * This experiment concerns transaction throughput collapse.
 * @author yksuh
 *
 */

public abstract class ScenarioBasedOnTransaction extends Scenario {
	/**
	 * @param expRun
	 *            experiment run instance
	 */
	public ScenarioBasedOnTransaction(ExperimentRun expRun) {
		super(expRun);
	}
	
	/**
	 * number of queries
	 */
	protected int numOfTerminals = 0;
	
//	/**
//	 * all cardinalities to be populated
//	 */
//	protected Vector<Transaction> vecCardinalities;
	
//	/**
//	 * all terminals
//	 */
//	protected List<Terminal> vecTerminals;
	
	/***
	 * Makes as many sessions to a DBMS as numTerminals specifies
	 * @throws Exception
	 */
//	protected abstract void stepA(int numClients) throws Exception;
	protected abstract void stepA(int numClients, double edbSz) throws Exception;
	
	/***
	 * Runs transactions
	 * @throws Exception
	 */
	protected abstract void stepB(int MPL) throws Exception;
	
//	/**
//	 * Populates transaction tables
//	 * @param curr_table
//	 * @throws Exception 
//	 */
//	protected abstract Vector<Long> stepB() throws Exception;
	/**
	 * Setting up the necessary variables for experiment.
	 * 
	 * @throws Exception
	 */
	private void initializeNotebookContent() throws Exception {
		myXactTables = experimentRun.getXactTables();
	}

	/**
	 * Creating and populating experiment tables.
	 * 
	 * @throws Exception
	 */
	private void initializeExperimentTables() throws Exception {
		/*if (myXactTables.length != 1) {
			Main._logger.reportError("OneDimensionalExhaustiveAnalyzer: too many or too few variable "
							+ "tables: " + myXactTables.length);
			System.exit(1);
		}*/

		// boolean isVariable = false;
		// Set up fixed tables
		for (int i = 0; i < myXactTables.length; i++) {
			Table curr_table = myXactTables[i];
			populateXactTable(curr_table);
			// (int)((double)(i + 1) / (double)myVariableTables.length * 100) =
			// % completed
			recordRunProgress((int) ((double) (i + 1)
					/ (double) myXactTables.length * 100),
					"Populating Transaction Tables");
		}
	}

	/**
	 * Initialize notebook content for storing all query execution results.
	 * Populate fixed tables.
	 * @throws Exception
	 */
	protected void preStep() throws Exception {
		initializeNotebookContent();
		// populate fixed tables
		initializeExperimentTables();
	}
	
	
	/**
	 * @see azdblab.plugins.scenario.Scenario#executeSpecificExperiment()
	 */
	protected final void executeSpecificExperiment() throws Exception {
		// initialize labshelf content + experiment tables 
		preStep();
		
		int lastStageCnt = 1, lastStageWaitTime = Constants.WAIT_TIME;
		
		int maxTaskNum = -1, runID = -1; 
		runID = exp_run_.getRunID();
		// get the maximum task number
		maxTaskNum = getMaxTaskNum(runID);
		// run as many transactions as numTerminals specifies 
		for(int MPL=numIncr;MPL<=numTerminals;MPL+=numIncr){
			if(MPL <= maxTaskNum-1){
				Main._logger.outputLog("MPL #" + MPL);
				Main._logger.outputLog("    >>> studied already" );
			}else{
			
				Main._logger.outputLog("::: MPL="+MPL+" Test :::");
				//recordRunProgress(0, "Beginning the initialization of a batch of terminals");
				// create transactions for each terminal
//				ArrayList<Client> clients = stepA(MPL);
				stepA(MPL, effectiveDBSz);
				//recordRunProgress(100, "Done with the initialization of a batch of terminals");
				
				// create transactions for each terminal
				stepB(MPL);
			
				// insert a completed task associated with the query number
				Main._logger.outputLog("before the insertion of the next task number");
				while(lastStageCnt <= Constants.TRY_COUNTS){	
					try {
						// record progress
						recordRunProgress(100, "Done with MPL="+MPL);
						putNextTaskNum(runID, MPL+1);
						break;
					}catch(Exception ex){
						ex.printStackTrace();
						Main._logger.reportError(ex.getMessage());
						lastStageCnt++;
						lastStageWaitTime *= 2;
						Main._logger.outputLog("Exponential backoff for last stage is performed for : " + lastStageWaitTime + " (ms)");
						try {
							Thread.sleep(lastStageWaitTime);
						} catch (InterruptedException e) {}
					}
				}
				// if we fail after 10 times, then an exception is eventually made.
				if(lastStageCnt > Constants.TRY_COUNTS) throw new Exception("JDBC in the last stage is not stable.");
				lastStageCnt = 1; lastStageWaitTime = Constants.WAIT_TIME;
				Main._logger.outputLog("after the insertion  of the next task number");
			}
		}
	}
	
	protected void dropExperimentTables() throws Exception {
		Main._logger.outputLog("## <EndOfExperiment> Purge Already installed tables ##################");
		// 	find all tables in the experimentSubject
		experimentSubject.dropAllInstalledTables();
		Main._logger.outputLog("######################################################################");
		
		// sanity check on table drop
		for (int i = 0; i < myXactTables.length; i++) {
			Table curr_table = myXactTables[i];
			// sanity check for table drop
			if(experimentSubject.tableExists(curr_table.table_name_with_prefix)){
				throw new SanityCheckException("Experiment paused by sanity check violation on table drop of " + curr_table.table_name_with_prefix + ".");
			}
		}
	}
//	/**
//	 * Measuring the transaction per second
//	 * @return The <code>TransactionStat</code> instance which contains number of transactions executed.
//	 */
//	protected TransactionStat makeTransactionProcessing() throws Exception {
//		TransactionStat xact_stat = experimentSubject.runTransactions();
//		return xact_stat;
//	}
	
	/**
	 * The tables that are fixed for this experiment.
	 */
	protected static Table[] myXactTables;
}