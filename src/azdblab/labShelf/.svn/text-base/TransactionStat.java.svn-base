/*
 * Copyright (c) 2012, Arizona Board of Regents
 * 
 * See LICENSE at /cs/projects/tau/azdblab/license
 * See README at /cs/projects/tau/azdblab/readme
 * AZDBLab, http://www.cs.arizona.edu/projects/focal/ergalics/azdblab.html
 * This is a Laboratory Information Management System
 * 
 * Authors:
 * Young-Kyoon Suh (http://www.cs.arizona.edu/~yksuh)
 */
/**
 * This class records all the relevant information about the execution of a transaction
 *
 */
package azdblab.labShelf;

public class TransactionStat {
	/**
	 * The time cost in for executing the query in millisecond.
	 */
	private long latency;
	private int transactionNum;

	public TransactionStat() {
		latency = 0;
		transactionNum = 0;
	}

	/**
	 * Constructs an TransactionStat object with transaction latency information
	 * specified.
	 * 
	 * @param lcy
	 *            the latency of the transaction execution.
	 */
	public TransactionStat(long lcy) {
		latency = lcy;
	}

	/**
	 * Sets the time cost of transaction execution for an instance.
	 * 
	 * @param lcy
	 *            the latency of the transaction execution.
	 */
	public void setLatency(long lcy) {
		latency = lcy;
	}

	/**
	 * Retrieves the latency
	 * 
	 * @return The latency.
	 */
	public long getLatency() {
		return latency;
	}

	public void setTransactionNum(int xactNum) {
		this.transactionNum = xactNum;
	}

	public int getTransactionNum() {
		return transactionNum;
	}
}
