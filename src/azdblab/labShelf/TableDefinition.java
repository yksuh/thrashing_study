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
package azdblab.labShelf;

import java.util.Vector;

import azdblab.Constants;
import azdblab.model.dataDefinition.ForeignKey;

public class TableDefinition {

	public static final InternalTable USER = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_USER, new String[] {
					"UserName", "CreateDate" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE }, new int[] { 100, -1 },
			new int[] { 0, 0 }, null, new String[] { "UserName" }, null, null);

	/**
	 * The definition of the labshelf internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable NOTEBOOK = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_NOTEBOOK, new String[] {
					"UserName", "NotebookName", "CreateDate" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE }, new int[] { 100, 100, -1 }, new int[] { 0, 0, 0 }, null, new String[] {
					"UserName", "NotebookName" },
			new ForeignKey[] { new ForeignKey(new String[] { "UserName" },
					Constants.TABLE_PREFIX + Constants.TABLE_USER,
					new String[] { "UserName" }, " ON DELETE CASCADE") }, null);

	/**
	 * The definition of the experiment internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable EXPERIMENT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT, new String[] {
					"ExperimentID", "UserName", "NotebookName",
					"ExperimentName", "Scenario", "SourceFileName",
					"CreateDate", "SourceXML" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE,
					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 100, 100,
					100, 100, 500, -1, -1 }, new int[] { 0, 0, 0, 0, 0, 0, 0,
					0 }, new String[] { "UserName", "NotebookName",
					"ExperimentName" }, new String[] { "ExperimentID" },
			new ForeignKey[] { new ForeignKey(new String[] { "UserName",
					"NotebookName" }, Constants.TABLE_PREFIX
					+ Constants.TABLE_NOTEBOOK, new String[] { "UserName",
					"NotebookName" }, " ON DELETE CASCADE") },
			Constants.SEQUENCE_EXPERIMENT);

	/**
	 * The definition of the data definition internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable EXPERIMENTSPEC = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTSPEC,
			new String[] { "ExperimentSpecID", "Name", "Kind", "FileName",
					"SourceXML" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 100, 1,
					100, -1 }, new int[] { 0, 0, 0, 0, 0 }, null,
			new String[] { "ExperimentSpecID" }, null,
			"SEQ_EXPERIMENTSPECID");

	public static final InternalTable REFERSEXPERIMENTSPEC = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_REFERSEXPERIMENTSPEC,
			new String[] { "ExperimentID", "Kind", "ExperimentSpecID" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER },
			new int[] { 10, 1, 10 },
			new int[] { 0, 0, 0 },
			null,
			new String[] { "ExperimentID", "Kind", "ExperimentSpecID" },
			new ForeignKey[] {
					new ForeignKey(
							new String[] { "ExperimentID" },
							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT,
							new String[] { "ExperimentID" },
							" ON DELETE CASCADE"),
					new ForeignKey(new String[] { "ExperimentSpecID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_EXPERIMENTSPEC,
							new String[] { "ExperimentSpecID" },
							" ON DELETE CASCADE") }, null);

	/**
	 * The definition of the predefined_query table
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable PREDEFINED_QUERY = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY,
			new String[] { "QueryID", "Username", "Query", "Description",
					"QueryName" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_CLOB,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR, }, new int[] { 10, 100,
					-1, 1024, 100 }, new int[] { 0, 0, 0, 0, 0, 0 },
			new String[] { "QueryName", "Username" },
			new String[] { "QueryID" }, new ForeignKey[] { new ForeignKey(
					new String[] { "Username" }, Constants.TABLE_PREFIX
							+ Constants.TABLE_USER,
					new String[] { "Username" }, "ON DELETE CASCADE"), },
			"SEQ_PREDEFINEDQUERYID");
	/**
	 * The definition for the InstantiatedQuery InternalTable
	 */
	public static final InternalTable INSTANTIATED_QUERY = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_INSTANTIATED_QUERY,
			new String[] { "QueryID", "InstantiatedQueryID", "UserName",
					"NotebookName", "ExperimentName" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 10, 10, 100,
					100, 100 }, new int[] { 0, 0, 0, 0, 0 }, null,
			new String[] { "InstantiatedQueryID" },
			new ForeignKey[] { new ForeignKey(new String[] { "QueryID" },
					Constants.TABLE_PREFIX + Constants.TABLE_PREDEFINED_QUERY,
					new String[] { "QueryID" }, "ON DELETE CASCADE") },
			"SEQ_INSTANTIATEDQUERYID");

	/**
	 * Instantiated_Query Date to implement multiselect for dates in
	 * instantiation
	 * 
	 * #see InternalTable
	 */
	public static final InternalTable INSTANTIATED_QUERYDATE = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_INSTANTIATED_QUERYDATE,
			new String[] { "InstantiatedQueryID", "DateParam" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_DATE },
			new int[] { 10, -1 },
			new int[] { 0, 0 },
			null,
			new String[] { "InstantiatedQueryID", "DateParam" },
			new ForeignKey[] { new ForeignKey(
					new String[] { "InstantiatedQueryID" },
					Constants.TABLE_PREFIX + Constants.TABLE_INSTANTIATED_QUERY,
					new String[] { "InstantiatedQueryID" }, "ON DELETE CASCADE") },
			null);

	/**
	 * The definition for the Paper internal table
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable PAPER = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_PAPER, new String[] {
					"PaperID", "Username", "PaperName", "Description",
					"NotebookName" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 10, 100,
					100, 1024, 100 }, new int[] { 0, 0, 0, 0, 0 },
			new String[] { "Username", "PaperName", "NotebookName" },
			new String[] { "PaperID" }, new ForeignKey[] { new ForeignKey(
					new String[] { "Username", "NotebookName" },
					Constants.TABLE_PREFIX + Constants.TABLE_NOTEBOOK,
					new String[] { "Username", "NotebookName" },
					"ON DELETE CASCADE"), }, "SEQ_PAPERID");

	/**
	 * The definition for the Figure Internal Table
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable FIGURE = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_FIGURE, new String[] {
					"PaperID", "InstantiatedQueryID", "FigureName", "X_VAL",
					"Y_VAL", "Description", "CreationTime", "C_VAL", "C_NUM",
					"ShowLegend", "LineType" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 10, 10, 100,
					100, 100, 1024, -1, 100, 10, 10, 20 }, new int[] { 0, 0,
					0, 0, 0, 0, 0, 0, 0, 0, 0 }, new String[] { "PaperID",
					"FigureName" }, new String[] { "PaperID",
					"InstantiatedQueryID", "FigureName" }, new ForeignKey[] {
					new ForeignKey(new String[] { "PaperID" },
							Constants.TABLE_PREFIX + Constants.TABLE_PAPER,
							new String[] { "PaperID" }, "ON DELETE CASCADE"),
					new ForeignKey(new String[] { "InstantiatedQueryID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_INSTANTIATED_QUERY,
							new String[] { "InstantiatedQueryID" },
							"ON DELETE CASCADE"), }, null);

	/**
	 * The definition of the TABLE internal table
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable TABLE = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_TABLE, new String[] {
					"PaperID", "InstantiatedQueryID", "Description",
					"TableName", "CreationTime" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP }, new int[] { 10, 10,
					1024, 100, -1 }, new int[] { 0, 0, 0, 0, 0 },
			new String[] { "PaperID", "TableName" }, new String[] { "PaperID",
					"InstantiatedQueryID", "TableName" }, new ForeignKey[] {
					new ForeignKey(new String[] { "PaperID" },
							Constants.TABLE_PREFIX + Constants.TABLE_PAPER,
							new String[] { "PaperID" }, "ON DELETE CASCADE"),
					new ForeignKey(new String[] { "InstantiatedQueryID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_INSTANTIATED_QUERY,
							new String[] { "InstantiatedQueryID" },
							"ON DELETE CASCADE"), }, null);

	public static final InternalTable ANALYSIS = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS, new String[] {
					"UserName", "AnalysisName", "AnalysisID", "NotebookName",
					"isFrozen" }, new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 100, 100,
					10, 100, 10 }, new int[] { 0, 0, 0, 0, 0 }, new String[] {
					"UserName", "NotebookName", "AnalysisName" },
			new String[] { "AnalysisID" }, new ForeignKey[] { new ForeignKey(
					new String[] { "UserName", "NotebookName" },
					Constants.TABLE_PREFIX + Constants.TABLE_NOTEBOOK,
					new String[] { "UserName", "NotebookName" },
					"ON DELETE CASCADE") }, "SEQ_ANALYSISID");

	public static final InternalTable ANALYSIS_QUERY = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_QUERY,
			new String[] { "AnalysisID", "InstantiatedQueryID" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER },
			new int[] { 10, 10 },
			new int[] { 0, 0 },
			null,
			new String[] { "AnalysisID", "InstantiatedQueryID" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "AnalysisID" },
							Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS,
							new String[] { "AnalysisID" }, "ON DELETE CASCADE"),
					new ForeignKey(new String[] { "InstantiatedQueryID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_INSTANTIATED_QUERY,
							new String[] { "InstantiatedQueryID" },
							"ON DELETE CASCADE") }, null);

	public static final InternalTable ANALYSIS_SCRIPT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_SCRIPT,
			new String[] { "AnalysisID", "scriptName", "scriptType",
					"scriptText" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 100, 100,
					-1 }, new int[] { 0, 0, 0, 0 }, null, new String[] {
					"AnalysisID", "scriptName" },
			new ForeignKey[] { new ForeignKey(new String[] { "AnalysisID" },
					Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS,
					new String[] { "AnalysisID" }, "ON DELETE CASCADE") }, null);

	public static final InternalTable ANALYSIS_RUN = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RUN,
			new String[] { "AnalysisID", "AnalysisRunID", "DateTimeRun" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP },
			new int[] { 10, 10, -1 }, new int[] { 0, 0, 0 }, new String[] {
					"AnalysisID", "DateTimeRun" },
			new String[] { "AnalysisRunID" },
			new ForeignKey[] { new ForeignKey(new String[] { "AnalysisID" },
					Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS,
					new String[] { "AnalysisID" }, "ON DELETE CASCADE") },
			"SEQ_ANALYSISRUNID");

	public static final InternalTable ANALYSIS_RESULT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYSIS_RESULT,
			new String[] { "AnalysisRunID", "scriptName", "AnalysisID",
					"output" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_CLOB },
			new int[] { 10, 100, 10, -1 }, new int[] { 0, 0, 0, 0 }, null,
			new String[] { "AnalysisRunID", "scriptName", "AnalysisID" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "AnalysisRunID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_ANALYSIS_RUN,
							new String[] { "AnalysisRunID" },
							"ON DELETE CASCADE"),
					new ForeignKey(new String[] { "scriptName", "AnalysisID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_ANALYSIS_SCRIPT,
							new String[] { "scriptName", "AnalysisID" },
							"ON DELETE CASCADE") }, null);

	/**
	 * The definition of the experiment internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable EXPERIMENTRUN = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
			new String[] { "RunID", "ExperimentID", "MachineName", "DBMSName",
					"StartTime", "CurrentStage", "Percentage" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER },
			new int[] { 10, 10, 100, 100, -1, 1000, 10 },
			new int[] { 0, 0, 1, 0, 0, 0, 0 },
			new String[] { "ExperimentID", "StartTime" },
			new String[] { "RunID" },
			new ForeignKey[] {
					new ForeignKey(
							new String[] { "ExperimentID" },
							Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENT,
							new String[] { "ExperimentID" },
							" ON DELETE CASCADE"),

					new ForeignKey(new String[] { "MachineName", "DBMSName" },
							Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR,
							new String[] { "MachineName", "CurrentDBMSName" },
							" ON DELETE CASCADE") }, "SEQ_RUNID");

	/**
	 * The definition of the experiment internal table.
	 * 
	 * @see InternalTable The StartTime is actually the transaction time of each
	 *      change, different from the StartTime in EXPERIMENTRUN
	 */
	public static final InternalTable RUNLOG = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_RUNLOG, new String[] {
					"RunID", "TransactionTime", "CurrentStage", "Percentage" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, -1,
					1000, 10 }, new int[] { 0, 0, 0, 0 }, null, new String[] {
					"RunID", "TransactionTime" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);

	public static final InternalTable EXECUTOR = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR, new String[] {
					"MachineName", "CurrentDBMSName", "CurrentStatus", "Command" },
			new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 100, 100,
					20, 20 }, new int[] { 0, 0, 0, 0 }, null,
			new String[] { "MachineName, CurrentDBMSName" }, null, null);

	public static final InternalTable EXECUTORLOG = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_EXECUTORLOG, new String[] {
					"MachineName", "TransactionTime", "CurrentStatus", "DBMSName",
					"Command" }, new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 100, -1,
					100, 50, 20 }, new int[] { 0, 0, 0, 0, 0 }, null, new String[] {
					"MachineName", "DBMSName", "TransactionTime" },
			new ForeignKey[] { new ForeignKey(new String[] { "MachineName", "DBMSName" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXECUTOR,
					new String[] { "MachineName", "CurrentDBMSName" }, " ON DELETE CASCADE") },
			null);

	public static final InternalTable DEFINEDASPECT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDASPECT,
			new String[] { "AspectID", "UserName", "NotebookName",
					"AspectName", "Style", "Description", "AspectSQL" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 50, 50,
					100, 50, 1000, -1 }, new int[] { 0, 0, 1, 0, 0, 1, 0 },
			new String[] { "UserName", "AspectName" },
			new String[] { "AspectID" }, new ForeignKey[] { new ForeignKey(
					new String[] { "UserName" }, Constants.TABLE_PREFIX
							+ Constants.TABLE_USER,
					new String[] { "UserName" }, " ON DELETE CASCADE") },
			"SEQ_ASPECTID");

	public static final InternalTable DEFINEDANALYTIC = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_DEFINEDANALYTIC,
			new String[] { "AnalyticID", "UserName", "NotebookName",
					"AnalyticName", "Style", "CreateDate", "Description",
					"AnalyticSQL" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 10, 50, 50,
					100, 50, -1, 1000, -1 }, new int[] { 0, 0, 1, 0, 0, 0, 1,
					0, 0 }, new String[] { "UserName", "AnalyticName" },
			new String[] { "AnalyticID" }, new ForeignKey[] { new ForeignKey(
					new String[] { "UserName" }, Constants.TABLE_PREFIX
							+ Constants.TABLE_USER,
					new String[] { "UserName" }, " ON DELETE CASCADE") },
			"SEQ_ANALYTICID");

	public static final InternalTable ANALYTICVALUEOF = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_ANALYTICVALUEOF,
			new String[] { "RunID", "AnalyticID", "AnalyticValue" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR },
			new int[] { 10, 10, 100 },
			new int[] { 0, 0, 0 },
			null,
			new String[] { "RunID", "AnalyticID" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "RunID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_EXPERIMENTRUN,
							new String[] { "RunID" }, " ON DELETE CASCADE"),

					new ForeignKey(new String[] { "AnalyticID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_DEFINEDANALYTIC,
							new String[] { "AnalyticID" }, " ON DELETE CASCADE") },
			null);

	/**
	 * The definition of the version internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable VERSION = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_VERSION, new String[] {
					"VersionName", "CreateDate" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE }, new int[] { 100, -1 },
			new int[] { 0, 0, }, null, new String[] { "VersionName" }, null,
			null);

	/**
	 * The definition of the ScenarioVersionDate Table
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable SCENARIOVERSION = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_SCENARIOVERSION,
			new String[] { "ScenarioName", "Version", "VersionDate" },
			new int[] { GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_DATE }, new int[] { 100, 100,
					-1 }, new int[] { 0, 0, 0 }, null, new String[] {
					"Version", "ScenarioName" }, null, null);

	/**
	 * The definition of the completed_task internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable COMPLETED_TASK = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_COMPLETED_TASK,
			new String[] { "RunID", "TaskNumber", "TransactionTime" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_TIMESTAMP },
			new int[] { 10, 10, 100 }, new int[] { 0, 0, -1 }, null,
			new String[] { "RunID", "TaskNumber" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);

	/**
	 * The definition of the query result internal table.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable QUERY = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_QUERY, new String[] {
					"QueryID", "RunID", "QueryNumber", "QuerySQL" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 10, 10, 10,
					2000 }, new int[] { 0, 0, 0, 0 }, new String[] { "RunID",
					"QueryNumber" }, new String[] { "QueryID" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") },
			"SEQ_QUERYID");

	// public static final InternalTable QUERYRESULT = new InternalTable(
	// MetaData.TABLE_PREFIX + MetaData.TABLE_QUERYRESULT, new String[] {
	// "QueryResultID", "QueryID", "PhaseNumber"},
	// new int[] { MetaData.I_DATA_TYPE_NUMBER,
	// MetaData.I_DATA_TYPE_NUMBER, MetaData.I_DATA_TYPE_NUMBER}, new int[] {
	// 10, 10, 10},
	// new int[] { 0, 0, 0},
	// new String[] { "QueryID", "PhaseNumber" },
	// new String[] { "QueryResultID" },
	// new ForeignKey[] { new ForeignKey(new String[] { "QueryID" },
	// MetaData.TABLE_PREFIX + MetaData.TABLE_QUERY,
	// new String[] { "QueryID" }, " ON DELETE CASCADE") },
	// "SEQ_QUERYRESULTID");

	public static final InternalTable QUERYHASPARAMETER = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYHASPARAMETER,
			new String[] { "QueryID", "ParamName", "Value" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 30, 10 },
			new int[] { 0, 0, 0 }, null,
			new String[] { "QueryID", "ParamName" },
			new ForeignKey[] { new ForeignKey(new String[] { "QueryID" },
					Constants.TABLE_PREFIX + Constants.TABLE_QUERY,
					new String[] { "QueryID" }, " ON DELETE CASCADE") }, null);

	public static final InternalTable QUERYEXECUTION = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTION,
			new String[] { "QueryExecutionID", "QueryID", "Phase",
					"QueryExecutionNumber", "Cardinality", "ResultCardinality",
					"RunTime", "procdiff", "IterNum" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_CLOB,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 10, 10,
					10, 10, 10, 10, -1, 10 }, new int[] { 0, 0, 0, 0, 0, 0,
					1, 0, 0 }, new String[] { "QueryID", "Phase",
					"QueryExecutionNumber", "IterNum" },
			new String[] { "QueryExecutionID" },
			new ForeignKey[] { new ForeignKey(new String[] { "QueryID" },
					Constants.TABLE_PREFIX + Constants.TABLE_QUERY,
					new String[] { "QueryID" }, " ON DELETE CASCADE") },
			"SEQ_QUERYEXECUTIONID");

	public static final InternalTable PLAN = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_PLAN, new String[] {
					"PlanID", "PlanTree" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_CLOB }, new int[] { 20, -1 },
			new int[] { 0, 0 }, null, new String[] { "PlanID" }, null, null);

	public static final InternalTable QUERYEXECUTIONHASPLAN = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTIONHASPLAN,
			new String[] { "QueryExecutionID", "PlanID" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 20 },
			new int[] { 0, 0 }, null, new String[] { "QueryExecutionID" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "QueryExecutionID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_QUERYEXECUTION,
							new String[] { "QueryExecutionID" },
							" ON DELETE CASCADE"),
					new ForeignKey(new String[] { "PlanID" },
							Constants.TABLE_PREFIX + Constants.TABLE_PLAN,
							new String[] { "PlanID" }, " ON DELETE CASCADE") },
			null);

	public static final InternalTable PLANOPERATOR = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_PLANOPERATOR,
			new String[] { "PlanOperatorID", "PlanID", "OperatorName",
					"OperatorOrder" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 20, 20, 100,
					10 }, new int[] { 0, 0, 0, 0 }, new String[] { "PlanID",
					"OperatorOrder" }, new String[] { "PlanOperatorID" },
			new ForeignKey[] { new ForeignKey(new String[] { "PlanID" },
					Constants.TABLE_PREFIX + Constants.TABLE_PLAN,
					new String[] { "PlanID" }, " ON DELETE CASCADE"), },
			"SEQ_PLANOPERATORID");

	public static final InternalTable QUERYEXECUTIONHASSTAT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_QUERYEXECUTIONHASSTAT,
			new String[] { "QueryExecutionID", "Name", "PlanOperatorID",
					"Value" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 30, 20,
					30 }, new int[] { 0, 0, 0, 0 }, null, new String[] {
					"QueryExecutionID", "Name", "PlanOperatorID" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "QueryExecutionID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_QUERYEXECUTION,
							new String[] { "QueryExecutionID" },
							" ON DELETE CASCADE"),
					new ForeignKey(new String[] { "PlanOperatorID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_PLANOPERATOR,
							new String[] { "PlanOperatorID" },
							" ON DELETE CASCADE") }, null);

	public static final InternalTable SATISFIESASPECT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_SATISFIESASPECT,
			new String[] { "QueryID", "AspectID", "AspectValue" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER },
			new int[] { 10, 10, 10 },
			new int[] { 0, 0, 0 },
			null,
			new String[] { "QueryID", "AspectID" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "QueryID" },
							Constants.TABLE_PREFIX + Constants.TABLE_QUERY,
							new String[] { "QueryID" }, " ON DELETE CASCADE"),
					new ForeignKey(new String[] { "AspectID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_DEFINEDASPECT,
							new String[] { "AspectID" }, " ON DELETE CASCADE") },
			null);

	/****************************************************************************************
	 * AZDBLAB BATCH Experiment tables
	 **************************************************************************************/
	/**
	 * AZDBLAB_BATCH table
	 * 
	 */
	public InternalTable BATCH = new InternalTable(Constants.TABLE_PREFIX
			+ Constants.TABLE_BATCH, new String[] { "BatchID", "RunID",
			"BatchSpecXML", "BatchNumber", "AbortRate", "BlockRate", "TPS",
			"NumTransactions" }, new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_XML,
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
			GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 10, -1, 10, 10,
			10, 10, 10 }, new int[] { 0, 0, 0, 0, 1, 1, 1, 0 }, new String[] {
			"BatchNumber", "RunID" }, new String[] { "BatchID" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);

	/**
	 * AZDBLAB_BATCHRESULT table
	 * 
	 */
	public InternalTable BATCHRESULT = new InternalTable(Constants.TABLE_PREFIX
			+ Constants.TABLE_BATCHRESULT, new String[] { "BatchResultID",
			"BatchID", "PhaseNumber" }, new int[] {
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
			GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 10, 10 },
			new int[] { 0, 0, 0 }, new String[] { "BatchID", "PhaseNumber" },
			new String[] { "BatchResultID" },
			new ForeignKey[] { new ForeignKey(new String[] { "BatchID" },
					Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
					new String[] { "BatchID" }, " ON DELETE CASCADE") }, null);

	/**
	 * AZDBLAB_TRANSACTION table
	 * 
	 */
	public InternalTable TRANSACTION = new InternalTable(Constants.TABLE_PREFIX
			+ Constants.TABLE_TRANSACTION, new String[] { "BatchID",
			"TransactionNumber", "TransactionSQL", "StartTime", "RunTime",
			"NumStatements", "WasAborted" }, new int[] {
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
			GeneralDBMS.I_DATA_TYPE_VARCHAR, GeneralDBMS.I_DATA_TYPE_TIMESTAMP,
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_NUMBER,
			GeneralDBMS.I_DATA_TYPE_NUMBER, GeneralDBMS.I_DATA_TYPE_VARCHAR },
			new int[] { 10, 10, 2000, -1, 10, 10, 1 }, new int[] { 0, 0, 0, 0,
					1, 0, 1 }, null, new String[] { "BatchID",
					"TransactionNumber" }, new ForeignKey[] { new ForeignKey(
					new String[] { "BatchID" }, Constants.TABLE_PREFIX
							+ Constants.TABLE_BATCH,
					new String[] { "BatchID" }, " ON DELETE CASCADE") }, null);

	/**
	 * AZDBLAB_STATEMENT table
	 * 
	 */
	public InternalTable STATEMENT = new InternalTable(Constants.TABLE_PREFIX
			+ Constants.TABLE_STATEMENT, new String[] { "BatchID",
			"TransactionNumber", "StatementNumber", "StatementSQL" },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR }, new int[] { 10, 10, 10,
					2000 }, new int[] { 0, 0, 0, 0 }, null, new String[] {
					"BatchID", "TransactionNumber", "StatementNumber" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "BatchID" },
							Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
							new String[] { "BatchID" }, " ON DELETE CASCADE"),
					new ForeignKey(new String[] { "TransactionNumber" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_TRANSACTION,
							new String[] { "TransactionNumber" },
							" ON DELETE CASCADE") }, null);

	/**
	 * AZDBLAB_BATCHHASPARAMETER table
	 * 
	 */
	public InternalTable BATCHSETHASPARAMETER = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BATCHSETHASPARAMETER,
			new String[] { "BatchID", "ParamName", "Value" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER }, new int[] { 10, 30, 10 },
			new int[] { 0, 0, 0 }, new String[] { "ParamName" }, new String[] {
					"BatchID", "ParamName" },
			new ForeignKey[] { new ForeignKey(new String[] { "BatchID" },
					Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
					new String[] { "BatchID" }, " ON DELETE CASCADE") }, null);

	/**
	 * AZDBLAB_BATCHSATISFIESASPECT table
	 * 
	 */
	public InternalTable BATCHSATISFIESASPECT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_BSSATISFIESASPECT,
			new String[] { "BatchID", "AspectID", "AspectValue", },
			new int[] { GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER },
			new int[] { 10, 10, 10 },
			new int[] { 0, 0, 0 },
			new String[] { "ParamName" },
			new String[] { "BatchID", "ParamName" },
			new ForeignKey[] {
					new ForeignKey(new String[] { "BatchID" },
							Constants.TABLE_PREFIX + Constants.TABLE_BATCH,
							new String[] { "BatchID" }, " ON DELETE CASCADE"),
					new ForeignKey(new String[] { "AspectID" },
							Constants.TABLE_PREFIX
									+ Constants.TABLE_DEFINEDASPECT,
							new String[] { "AspectID" }, " ON DELETE CASCADE") },
			null);

	/**
	 * AZDBLAB_COMMENTS table
	 * 
	 */
	public static final InternalTable COMMENT = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_COMMENT, new String[] {
					"RunID", "Comments", "DateAdded" }, new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_CLOB,
					GeneralDBMS.I_DATA_TYPE_DATE },
			new int[] { 10, -1, -1 }, new int[] { 0, 0, 0 }, null,
			new String[] { "RunID", "DateAdded" },
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);
	
	
	public static final InternalTable STUDYRUN = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_STUDYRUN, new String[] {
					"LABSHELF_USER", "LABSHELF_PASSWORD", "CONNECTSTRING", "LABSHELF_NAME",
					"USERNAME", "NOTEBOOKNAME", "EXPERIMENTNAME", "RUNID", "STUDYID"},
					new int[] {
					GeneralDBMS.I_DATA_TYPE_VARCHAR, 
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER
			}, new int[] {255, 255, 255, 255, 255, 255, 255, 10, 10}, 
			new int[] {0,0,0,0,0,0,0,0,0}, null, new String[] {"RUNID", "STUDYID"},
			new ForeignKey[] { new ForeignKey(new String[] { "RunID" },
					Constants.TABLE_PREFIX + Constants.TABLE_EXPERIMENTRUN,
					new String[] { "RunID" }, " ON DELETE CASCADE") }, null);
	
	public static final InternalTable STUDY = new InternalTable(
			Constants.TABLE_PREFIX + Constants.TABLE_STUDY, new String[] {
					"STUDYID", "PAPERID", "NAME", "ITEM",
					"PROTOCOLID", "COMPUTATIONQUERY"},
					new int[] {
					GeneralDBMS.I_DATA_TYPE_NUMBER, 
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_NUMBER,
					GeneralDBMS.I_DATA_TYPE_VARCHAR
			}, new int[] {10, 10, 255, 10, 10, 4000}, 
			new int[] {0,0,0,0,0,0}, null, new String[] {"STUDYID"},
			new ForeignKey[] { new ForeignKey(new String[] { "PaperID" },
					PAPER.TableName,
					new String[] { "PaperID" }, " ON DELETE CASCADE") }, Constants.SEQUENCE_STUDY);

	/**
	 * The a list of all the internal tables that are in Constants.
	 * 
	 * @see InternalTable
	 */
	public static final InternalTable[] INTERNAL_TABLES = new InternalTable[] {
			VERSION, EXECUTOR, EXECUTORLOG, USER, NOTEBOOK, EXPERIMENT,
			EXPERIMENTRUN, RUNLOG, QUERY, QUERYHASPARAMETER, QUERYEXECUTION,
			PLAN, PLANOPERATOR, QUERYEXECUTIONHASPLAN, QUERYEXECUTIONHASSTAT,
			EXPERIMENTSPEC, REFERSEXPERIMENTSPEC, DEFINEDASPECT,
			SATISFIESASPECT, DEFINEDANALYTIC, ANALYTICVALUEOF,
			PREDEFINED_QUERY, INSTANTIATED_QUERY, INSTANTIATED_QUERYDATE,
			PAPER, FIGURE, TABLE, ANALYSIS, ANALYSIS_QUERY, ANALYSIS_SCRIPT,
			ANALYSIS_RUN, ANALYSIS_RESULT, SCENARIOVERSION, COMPLETED_TASK,
			COMMENT, STUDY, STUDYRUN };
	/**
	 * The a list of all the internal tables that are in Constants.
	 * 
	 * @see InternalTable
	 */
//	public static final InternalTable[] INTERNAL_TABLES = new InternalTable[] {
//			VERSION, EXECUTOR, EXECUTORLOG, USER, NOTEBOOK, EXPERIMENT,
//			EXPERIMENTRUN, RUNLOG, 
////			QUERY, QUERYHASPARAMETER, QUERYEXECUTION,
////			PLAN, PLANOPERATOR, QUERYEXECUTIONHASPLAN, QUERYEXECUTIONHASSTAT,
//			EXPERIMENTSPEC, REFERSEXPERIMENTSPEC, 
////			DEFINEDASPECT,
////			SATISFIESASPECT, DEFINEDANALYTIC, ANALYTICVALUEOF,
////			PREDEFINED_QUERY, INSTANTIATED_QUERY, INSTANTIATED_QUERYDATE,
////			PAPER, FIGURE, TABLE, ANALYSIS, ANALYSIS_QUERY, ANALYSIS_SCRIPT,
////			ANALYSIS_RUN, ANALYSIS_RESULT, 
//			SCENARIOVERSION, COMPLETED_TASK,
////			STUDY, STUDYRUN };
//			COMMENT };

	public static Vector<InternalTable> vecPluginTables = new Vector<InternalTable>();
}
