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
package azdblab.model.queryGenerator;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.Vector;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import azdblab.Constants;

//import java.util.Date;
import azdblab.exception.analysis.QueryGeneratorValidationException;
import azdblab.executable.Main;
import azdblab.labShelf.RepeatableRandom;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.Query;
import azdblab.labShelf.dataModel.Run;
import azdblab.labShelf.dataModel.User;
import azdblab.model.dataDefinition.DataDefinition;
import azdblab.model.experiment.Column;
import azdblab.model.experiment.Table;
import azdblab.model.experiment.XMLHelper;

class AggregateStmt {
	public AggregateStmt() {
		aggregate_statement = "";
		groupby_statement = "";
		has_groupby = false;
	}

	public String aggregate_statement;
	public String groupby_statement;
	public boolean has_groupby;
}

/**
 * This implementation of QueryGenerator provides a simple select-project-join
 * queries. The user can control the population of queries by tweaking the XML.
 * 
 */
public class DefaultGrammarSpecificGenerator extends QueryGenerator {

	private RepeatableRandom reprand;

	/**
	 * A DomainEdge is an edge that connects two domains. This would be a table
	 * that has a column in both domains and can be used to prevent a cartesian
	 * join from occurring.
	 * 
	 */
	private class DomainEdge {
		/**
		 * The edge is contained in a domain. Thus, the domain edge only needs
		 * to store the destination. This is just like an edge list for graphs.
		 * 
		 * @param domainNameDest
		 *            The other domain that this domain connects to.
		 */
		public DomainEdge(String domainNameDest) {
			_domainNameDest = domainNameDest;
		}

		/**
		 * The other domain that this domain connects to.
		 */
		public String _domainNameDest;
	}

	/**
	 * The graph is drawn using these type of nodes. They are connected by
	 * domain edges.
	 * 
	 */
	private class DomainNode {

		/**
		 * The name of the domain this node represents is the only parameter.
		 * 
		 * @param domainName
		 *            The name of the domain this node represents.
		 */
		public DomainNode(String domainName) {
			_domainName = domainName;
			_edgeList = new Vector<DomainEdge>();
			_tableCount = 0;
		}

		/**
		 * The domain node is constructed for domain name with tableCount
		 * tables.
		 * 
		 * @param domainName
		 *            The name of the domain
		 * @param tableCount
		 *            The number of the tables.
		 */
		public DomainNode(String domainName, int tableCount) {
			_domainName = domainName;
			_edgeList = new Vector<DomainEdge>();
			_tableCount = tableCount;
		}

		/**
		 * @see java.lang.Object#equals(java.lang.Object)
		 */
		public boolean equals(Object o) {
			if (!(o instanceof DomainNode))
				return false;
			DomainNode other = (DomainNode) o;
			return other._domainName == this._domainName;
		}

		/**
		 * The name of the domain
		 */
		public String _domainName;

		/**
		 * The list of edges that this domain can be joined with.
		 */
		public Vector<DomainEdge> _edgeList;

		/**
		 * The number of tables in this domain.
		 */
		public int _tableCount;
	}

	/**
	 * This class is used to store both the name of a table and the alias that
	 * it is given in the FROM clause.
	 */
	private class SQLTableWrapper {
		/**
		 * Creates an SQLTableWrapper
		 * 
		 * @param table
		 *            The name of the table.
		 * @param alias
		 *            The alias that was assigned to the table in the from
		 *            clause.
		 */
		public SQLTableWrapper(Table table, String alias) {
			_table = table;
			_alias = alias;
		}

		/**
		 * @see java.lang.Object#equals(java.lang.Object)
		 */
		public boolean equals(Object o) {
			if (!(o instanceof SQLTableWrapper))
				return false;
			SQLTableWrapper other = (SQLTableWrapper) o;
			return other._alias == this._alias && other._table == this._table;
		}

		/**
		 * The alias that was assigned to the table in the from clause.
		 */
		public String _alias;

		/**
		 * The name of the table
		 */
		public Table _table;
	}

	/**
	 * Creates the DefaultGrammarSpecificGenerator
	 * 
	 * @param root
	 *            The DOM element for this query generator
	 * @param dataDef
	 *            The Data Definition associated with the test that this query
	 *            generator is associated with.
	 * @param schema
	 *            The schema that is used to validate the grammar query
	 *            generator XML.
	 * @param numberQueries
	 *            The number of queries that should be generated.
	 * @param variable
	 *            The variable tables for this test.
	 * @param fixed
	 *            The fixed tables for this test.
	 * @param controller
	 *            The connection to the database internal tables that is used to
	 *            store the queries.
	 * @param exp_name
	 *            The name of the experiment that queries are being generated
	 *            for.
	 * @param test_num
	 *            The test number that the queries are being generated for.
	 * @throws QueryGeneratorValidationException
	 * @throws IOException
	 *             If there is a problem writing a file.
	 */
	public DefaultGrammarSpecificGenerator(Element root,
			DataDefinition dataDef, String schema, int numberQueries,
			LabShelfManager dbController, Table[] variable, Table[] fixed,
			String user_name, String notebook_name, String exp_name)
			throws QueryGeneratorValidationException, IOException {
		super(user_name, notebook_name, exp_name);

		_schemaFile = schema;
		_numberQueries = numberQueries;
		_dataDef = dataDef;
		_xmlFile = File.createTempFile("grammarSpecific", ".xml", new File(
				Constants.DIRECTORY_TEMP));
		_xmlFile.deleteOnExit();

		FileOutputStream out = new FileOutputStream(_xmlFile);
		XMLHelper.writeXMLToOutputStream(out, root);
		out.close();
		_variableTables = variable;
		_fixedTables = fixed;

		// iTestNumber = test_num;

		reprand = new RepeatableRandom();

		// To suppress variable not used warning. For some reason, this warning
		// was showed even though aggregate_frequency_ is being used in init().
		aggregate_frequency_ = 0;
		aggregate_frequency_ = aggregate_frequency_ + 0;

		int res = init();
		if (res == -1) {
			success = false;
		} else {
			success = true;
		}
		/*
		 * if (success) { generateTemp(); } else { _domains = new HashMap();
		 * loadIntoDomains(_variableTables); loadIntoDomains(_fixedTables);
		 * generateTemp(); // System.out.println("failure"); }
		 */

	}

	/**
	 * This is used when a cartesian product is not wanted. If all the tables
	 * selected from the FROM clause cannot be joined to avoid a cartesian
	 * product then some of them are removed until a cartesian product has been
	 * avoided. The eliminator string is a string that can be appended to the
	 * WHERE clause (joined by an AND) and a cartesian product will not occur.
	 * 
	 * @param usedFromTables
	 *            The tables that were used in the FROM clause.
	 * @param queryDomains
	 *            The query domains used in the FROM clause.
	 * @return The eliminator string which can be connected to the WHERE clause
	 *         to avoid a cartesian product.
	 */
	// This will prune both the usedFromTables and queryDomains if it needs to
	// in order to eliminate a cartesian product.
	private String buildEliminator(
			Vector<SQLTableWrapper> usedFromTables,
			HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains) {
		String eliminatorPredicate = null;

		// A graph of all the domains for this query.
		Vector<DomainNode> completeGraph = createEliminatorGraph(queryDomains);

		// Breaks the subgraphs into connected components. If all the domains
		// are connected then
		// there should only be one.
		Vector<Vector<DomainNode>> subGraphs = splitEliminatorGraph(completeGraph);

		int max = 0;
		int maxIndex = 0;
		boolean useTableCount = (getRandomNumber(0, 1) == 0);
		// finding largest component (i.e. has most domains)
		for (int i = 0; i < subGraphs.size(); i++) {
			if (!useTableCount) {
				// uses maximum number of domains to decidge what subgraph to
				// keep
				int currGraphSize = ((Vector<?>) subGraphs.get(i)).size();
				if (currGraphSize > max) {
					max = currGraphSize;
					maxIndex = i;
				}
			} else {
				// uses maximum number of tables to decide what subgraph to keep
				Vector<?> currGraph = (Vector<?>) subGraphs.get(i);
				int totalTables = 0;
				for (int j = 0; j < currGraph.size(); j++) {
					DomainNode currNode = (DomainNode) currGraph.get(j);
					totalTables += currNode._tableCount;
				}
				if (totalTables > max) {
					max = totalTables;
					maxIndex = i;
				}
			}
		}

		// removing the subgraph that will be used.
		completeGraph = (Vector<DomainNode>) subGraphs.remove(maxIndex);

		// The rest of the subgraphs are dead graphs.
		Vector<Vector<DomainNode>> deadGraphs = subGraphs;

		// removes the dead subgraphs from the FROM clause and the query
		// Domains. This prevents
		// them from being used in the generation of the SELECT and WHERE
		// clause.
		cutOffDeadSubGraphs(usedFromTables, queryDomains, deadGraphs);

		// using the subgraph to build an predicate that will avoid the
		// cartesian product.
		for (int i = 0; i < completeGraph.size(); i++) {
			// Get a domain
			String currentDomainName = completeGraph.get(i)._domainName;

			// Get the tables from the domain
			HashMap<?, ?> domainTables = queryDomains.get(currentDomainName);
			Iterator<?> j = domainTables.keySet().iterator();

			// the previous table and it columns
			SQLTableWrapper prevTable = null;
			String prevColumn = null;

			// the current table and its columns
			SQLTableWrapper currTable = (SQLTableWrapper) j.next();
			HashMap<?, ?> currColumns = (HashMap<?, ?>) domainTables
					.get(currTable);
			Object[] columnNames = currColumns.keySet().toArray();
			String currColumn = (String) columnNames[getRandomNumber(0,
					columnNames.length - 1)];

			// after selecting the current table, choose another table to build
			// the predicate.
			for (; j.hasNext();) {
				// setting current to previous
				prevTable = currTable;
				prevColumn = currColumn;

				// getting a new table and its columns
				currTable = (SQLTableWrapper) j.next();
				currColumns = (HashMap<?, ?>) domainTables.get(currTable);
				columnNames = currColumns.keySet().toArray();
				currColumn = (String) columnNames[getRandomNumber(0,
						columnNames.length - 1)];

				if (eliminatorPredicate != null)
					eliminatorPredicate += " AND " + prevTable._alias + "."
							+ prevColumn + "=" + currTable._alias + "."
							+ currColumn;
				else
					eliminatorPredicate = prevTable._alias + "." + prevColumn
							+ "=" + currTable._alias + "." + currColumn;
				;
			}
		}

		if (eliminatorPredicate != null)
			eliminatorPredicate = " (" + eliminatorPredicate + ") ";

		// System.err.println("eliminatorPredicate: " + eliminatorPredicate);

		return eliminatorPredicate;
	}

	/**
	 * Constructs the build clause of the query.
	 * 
	 * @param usedFromTables
	 *            The tables that will be in the from clause.
	 * @return A string that is the FROM clause of the SQL query.
	 */
	private String buildFromClause(Vector<SQLTableWrapper> usedFromTables) {

		SQLTableWrapper currentTable = usedFromTables.get(0);
		String fromSQL = " FROM " + currentTable._table.table_name_with_prefix
				+ " " + currentTable._alias;

		int numTables = usedFromTables.size();
		for (int i = 1; i < numTables; i++) {
			currentTable = usedFromTables.get(i);
			fromSQL += ", " + currentTable._table.table_name_with_prefix + " "
					+ currentTable._alias;
		}
		fromSQL += " ";

		return fromSQL;
	}

	/**
	 * 
	 * @return The aggregate statements.
	 */
	public static AggregateStmt BuildAggregateStatement(String function_name,
			Vector<String> selected_attributes, RepeatableRandom reprand,
			String selectSQL) {
		AggregateStmt aggregate_stmt = new AggregateStmt();
		int num_selected_attributes = selected_attributes.size();
		int target_attribute_id = (int) reprand.getNextRandomInt()
				% num_selected_attributes;
		aggregate_stmt.aggregate_statement = selectSQL;
		if (num_selected_attributes == 1) {
			aggregate_stmt.groupby_statement = "";
			aggregate_stmt.has_groupby = false;
			aggregate_stmt.aggregate_statement = "SELECT " + function_name
					+ "(" + selected_attributes.get(0) + ") ";
		} else {
			aggregate_stmt.aggregate_statement = "SELECT ";
			StringBuffer stmt_buf = new StringBuffer();
			stmt_buf.append(" GROUP BY ");
			int valid_groupby_entries = 0;
			for (int i = 0; i < num_selected_attributes; ++i) {
				if (i == target_attribute_id) {
					continue;
				}
				if (valid_groupby_entries > 0) {
					stmt_buf.append(", ");
					aggregate_stmt.aggregate_statement += ", ";
				}
				aggregate_stmt.aggregate_statement += selected_attributes
						.get(i);
				stmt_buf.append(selected_attributes.get(i));
				++valid_groupby_entries;
			}
			stmt_buf.append(" ");
			aggregate_stmt.groupby_statement = stmt_buf.toString();
			aggregate_stmt.has_groupby = true;
			aggregate_stmt.aggregate_statement += ", " + function_name + "("
					+ selected_attributes.get(target_attribute_id) + ") ";
		}
		return aggregate_stmt;
	}

	private String generateQuery() {

		int numCorrelationNamesInFrom = getRandomNumber(_minTables, _maxTables);
		int numExpectedSelfjoins = getRandomNumber(_minTables, _maxTables);
		// I'm pretty sure it ignores this
		int numAggregates = getRandomNumber(_minAggregate, _maxAggregate);
		boolean add_aggregate = numAggregates == 1;

		int numColumnsInSelect = getRandomNumber(_minColumns, _maxColumns);
		int numSimplePredicates = 0;
		Vector<SQLTableWrapper> usedFromTables = selectFromTablesWithUniformSelfjoins(
				numCorrelationNamesInFrom, numExpectedSelfjoins);
		if (_maxAbsolute) {
			if (usedFromTables.size() > 1) {
				int minInequalityPredicates = _minInequality, maxInequalityPredicates = _maxInequality;
				if (minInequalityPredicates > usedFromTables.size() - 1) {
					minInequalityPredicates = usedFromTables.size() - 1;
				}
				if (maxInequalityPredicates > usedFromTables.size() - 1) {
					maxInequalityPredicates = usedFromTables.size() - 1;
				}
				numSimplePredicates = getRandomNumber(minInequalityPredicates,
						maxInequalityPredicates);
			} else
				numSimplePredicates = 0;

			Main._logger.outputLog("# of corrNames: "
					+ numCorrelationNamesInFrom + " / numOfPredicates : "
					+ numSimplePredicates);
		} else {
			if (usedFromTables.size() > 1) {
				int minInequalityPredicates = _minInequality, maxInequalityPredicates = _maxInequality;
				if (minInequalityPredicates > usedFromTables.size() - 1) {
					minInequalityPredicates = usedFromTables.size() - 1;
				}
				if (maxInequalityPredicates > usedFromTables.size() - 1) {
					maxInequalityPredicates = usedFromTables.size() - 1;
				}
				numSimplePredicates = getRandomNumber(minInequalityPredicates
						* usedFromTables.size(), maxInequalityPredicates
						* usedFromTables.size());
			} else
				numSimplePredicates = 0;
		}
		HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains = buildQueryDomains(usedFromTables);

		String cartesianEliminator = null;
		if (!_cartesianPossible)
			cartesianEliminator = buildEliminator(usedFromTables, queryDomains);
		Vector<String> selected_attributes = new Vector<String>();
		String fromSQL = buildFromClause(usedFromTables);
		String selectSQL = buildSelectClause(usedFromTables,
				numColumnsInSelect, selected_attributes);
		String whereSQL = buildWhereClause(queryDomains, usedFromTables,
				numSimplePredicates, cartesianEliminator);
		if (add_aggregate) {
			AggregateStmt aggregate_stmt = DefaultGrammarSpecificGenerator
					.BuildAggregateStatement(aggfunction_name_,
							selected_attributes, reprand, selectSQL);
			return aggregate_stmt.aggregate_statement + fromSQL + whereSQL
					+ aggregate_stmt.groupby_statement;
		} else {
			return selectSQL + fromSQL + whereSQL;
		}
	}

	/**
	 * Builds query domains. This provides the query generator with the
	 * capability to generate meaningful queries. Simple predicates should be
	 * domain compatible.
	 * 
	 * @param usedFromTables
	 *            The tables that will be used in the Query.
	 * @return A structure that maps the columns/tables on domains.
	 */
	private HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> buildQueryDomains(
			Vector<SQLTableWrapper> usedFromTables) {
		HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains = new HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>>();
		// for each table
		for (int i = 0; i < usedFromTables.size(); i++) {
			SQLTableWrapper tableWrapper = usedFromTables.get(i);
			Table table = tableWrapper._table;
			if (_domains == null) {
				Main._logger
						.reportError("error _domains null at 666 DefaultGrammerSpecificGenerator");
				_domains = new HashMap<String, HashMap<String, HashMap<String, String>>>();
			}
			Set<String> domains = _domains.keySet();
			// for each of the global domains
			for (Iterator<String> j = domains.iterator(); j.hasNext();) {
				String domainName = j.next();
				HashMap<?, ?> currDomain = _domains.get(domainName);
				if (currDomain != null) {
					// domainName should exist because init created it.
					HashMap<?, ?> tableMap = (HashMap<?, ?>) currDomain
							.get(table.table_name);
					if (tableMap != null) {
						// table is in domain and should be added to query
						// domain
						HashMap<SQLTableWrapper, HashMap<?, ?>> queryCurrentDomain = queryDomains
								.get(domainName);
						if (queryCurrentDomain == null) {
							// if this domain doesnt exist for this query
							queryCurrentDomain = new HashMap<SQLTableWrapper, HashMap<?, ?>>();
							queryDomains.put(domainName, queryCurrentDomain);
						}
						HashMap<?, ?> queryTableMap = queryCurrentDomain
								.get(table.table_name);
						if (queryTableMap == null) {
							// if this table doesn't exist for this domain in
							// this query
							queryCurrentDomain.put(tableWrapper, tableMap);
						}
					}
				}
			}
		}
		return queryDomains;
	}

	/**
	 * Builds the SELECT clause for the query.
	 * 
	 * @param usedFromTables
	 *            The tables that were used in the FROM clause.
	 * @param numColumns
	 *            The number of columns that will be in the SELECT clause.
	 * @return The SELECT clause of the SQL statement.
	 */
	private String buildSelectClause(Vector<SQLTableWrapper> usedFromTables,
			int numColumns, Vector<String> selected_attributes) {
		if (_selectAll)
			return "SELECT * ";

		Set<String> usedColumns = new HashSet<String>();

		String selectSQL = "";

		while (usedColumns.size() < numColumns) {
			SQLTableWrapper currTable = usedFromTables.get(getRandomNumber(0,
					usedFromTables.size() - 1));
			int columnIndex = getRandomNumber(0,
					currTable._table.columns.length - 1);
			Column currColumn = currTable._table.columns[columnIndex];
			String selectColumn = currTable._alias + "." + currColumn.myName;
			usedColumns.add(selectColumn);
		}
		Iterator<String> iter = usedColumns.iterator();
		int count = 0;
		while (iter.hasNext()) {
			String selectColumn = iter.next();
			selectSQL += ((count == 0) ? ("SELECT " + selectColumn)
					: (", " + selectColumn));
			count++;
			selected_attributes.add(selectColumn);
		}
		return selectSQL;
	}

	/**
	 * Builds the WHERE clause of the query
	 * 
	 * @param queryDomains
	 *            The domains used in the query.
	 * @param usedFromTables
	 *            The tables used in the query.
	 * @param numSimplePredicates
	 *            The number of predicates that should be generated.
	 * @param cartesianEliminator
	 *            The complex predicate that will eliminate the cartesian
	 *            product.
	 * @return The WHERE clause of the SQL statement.
	 */
	private String buildWhereClause(
			HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains,
			Vector<SQLTableWrapper> usedFromTables, int numSimplePredicates,
			String cartesianEliminator) {
		String whereSQL = "";
		if (cartesianEliminator != null)
			whereSQL = " WHERE " + cartesianEliminator;

		if (numSimplePredicates == 0)
			return whereSQL;

		Vector<String> simplePredicates = new Vector<String>();

		// Vector copyUsedFromTables = (Vector)usedFromTables.clone();

		// count how many times each binary operator is being used.
		int op_count[] = new int[_binaryOperators.length];
		for (int k = 0; k < _binaryOperators.length; k++) {
			op_count[k] = 0;
		}

		// Creating the simple predicates.
		for (int i = 0; i < numSimplePredicates; i++) {
			// getting the first table
			SQLTableWrapper currTable = usedFromTables.get(getRandomNumber(0,
					usedFromTables.size() - 1));

			// getting the first column
			int columnIndex = getRandomNumber(0,
					currTable._table.columns.length - 1);
			Column currColumn = currTable._table.columns[columnIndex];

			// building the left side of the predicate
			String leftColumn = currTable._alias + "." + currColumn.myName;

			// getting the left column data type
			String columnDataType = _dataDef.getColumnDataTypeASString(
					currTable._table.table_name, currColumn.myName);

			// getting domain with this data type for this query
			HashMap<?, ?> domain = queryDomains.get(columnDataType);
			if (domain == null)
				continue;
			// this predicate is not added

			// getting tables in this domain fo rthis query
			Set<?> otherTableSet = domain.keySet();
			Object[] otherTables = otherTableSet.toArray();

			Vector<Object> newTables = new Vector<Object>();
			for (int j = 0; j < otherTables.length; j++) {
				if (!((SQLTableWrapper) otherTables[j])._alias
						.equalsIgnoreCase(currTable._alias)) {
					newTables.add(otherTables[j]);
				}
			}
			otherTables = newTables.toArray();

			// selecting the other table from this domain
			int otherTableIndex = getRandomNumber(0, otherTables.length - 1);
			HashMap<?, ?> otherTableMap = (HashMap<?, ?>) domain
					.get(otherTables[otherTableIndex]);

			// getting the columns for the other table
			Set<?> otherColumnSet = otherTableMap.keySet();
			Object[] otherColumns = otherColumnSet.toArray();

			// selecting the other column
			int otherColumnIndex = getRandomNumber(0, otherColumns.length - 1);

			// building the right side of the predicate
			String rightColumn = ((SQLTableWrapper) otherTables[otherTableIndex])._alias
					+ "." + ((String) otherColumns[otherColumnIndex]);

			if (rightColumn.equals(leftColumn))
				continue;
			// don't add meaning less predicates, no recovery
			int op_id = getRandomNumber(0, _binaryOperators.length - 1);
			String operator = _binaryOperators[op_id];
			// unless the chosen operator exceeds its appearance limit
			String simplePredicate = leftColumn + " " + operator + " "
					+ rightColumn;
			if (!simplePredicates.contains(simplePredicate)) {
				// Main._logger.outputLog("predicate: " +
				// simplePredicate);
				simplePredicates.add(simplePredicate);
			} else {
				continue; // don't add same predicate twice
			}
		}

		// joining simple predicates to for the predicate of the WHERE clause.
		while (simplePredicates.size() > 1) {
			int unary = getRandomNumber(0, 100);
			String newPredicate = "";
			if (unary < _unaryUsePercent) {
				// create a logical unary complex predicate
				String simplePredicate = simplePredicates
						.remove(getRandomNumber(0, simplePredicates.size() - 1));
				// RALOW add support for more unary operators
				if (!simplePredicate.startsWith(_unaryLogicalOperators[0]))
					newPredicate += _unaryLogicalOperators[0] + " "
							+ simplePredicate;
				else
					newPredicate += simplePredicate;
			} else {
				// create a logical binary complex predicate
				String simplePredicateLeft = simplePredicates
						.remove(getRandomNumber(0, simplePredicates.size() - 1));
				String simplePredicateRight = simplePredicates
						.remove(getRandomNumber(0, simplePredicates.size() - 1));
				simplePredicateLeft += " "
						+ _binaryLogicalOperators[getRandomNumber(0,
								_binaryLogicalOperators.length - 1)] + " "
						+ simplePredicateRight;
				newPredicate = simplePredicateLeft;
			}
			int parenthesis = getRandomNumber(0, 100);
			if (parenthesis < _usePercentComplex)
				newPredicate = "(" + newPredicate + ")";
			simplePredicates.add(getRandomNumber(0, simplePredicates.size()),
					newPredicate);
		}

		if (simplePredicates.size() > 0) {
			if (whereSQL.equals(""))
				whereSQL = " WHERE " + simplePredicates.get(0);
			else
				whereSQL += " AND " + simplePredicates.get(0);
		}
		return whereSQL;
	}

	/**
	 * Creates a graph between the domains which can be used to eliminate
	 * cartesian products.
	 * 
	 * @param queryDomains
	 *            The queryDomains used by the query.
	 * @return The graph of the query domains.
	 */
	// creates the graph between the domains
	private Vector<DomainNode> createEliminatorGraph(
			HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains) {
		Vector<DomainNode> result = new Vector<DomainNode>();
		Set<String> d = queryDomains.keySet();
		Object[] domains = d.toArray();

		// create a node for each domain. Each node has an empty edgelist
		DomainNode completeGraph[] = new DomainNode[domains.length];
		for (int i = 0; i < domains.length; i++) {
			int tableCount = queryDomains.get(domains[i]).size();
			completeGraph[i] = new DomainNode((String) domains[i], tableCount);
			result.add(completeGraph[i]);
		}

		// for each domain
		for (int i = 0; i < domains.length; i++) {
			String domain1Name = (String) domains[i];
			HashMap<?, ?> domain1 = queryDomains.get(domain1Name);
			// compare this domain to each other domain
			for (int j = i + 1; j < domains.length; j++) {
				String domain2Name = (String) domains[j];
				HashMap<?, ?> domain2 = queryDomains.get(domain2Name);
				Set<?> domain1Tables = domain1.keySet();
				// For every table in domain 1
				for (Iterator<?> k = domain1Tables.iterator(); k.hasNext();) {
					SQLTableWrapper domain1CurrTable = (SQLTableWrapper) k
							.next();

					// check to see if that table is in domain 2
					if (domain2.containsKey(domain1CurrTable)) {
						completeGraph[i]._edgeList.add(new DomainEdge(
								domain2Name));
						completeGraph[j]._edgeList.add(new DomainEdge(
								domain1Name));
					}
				}
			}
		}
		return result;
	}

	/**
	 * The method takes the subgraphs that are being discarded and removes the
	 * tables which are not in live domains from the from tables and removes the
	 * dead domains from the query domain
	 * 
	 * @param usedFromTables
	 *            The old set of tables. This needs to be pruned.
	 * @param queryDomains
	 *            The old set of query domains. This needs to be pruned.
	 * @param deadGraphs
	 *            The graphs that are dead and need to be removed from the above
	 *            parameters.
	 */
	private void cutOffDeadSubGraphs(
			Vector<SQLTableWrapper> usedFromTables,
			HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains,
			Vector<Vector<DomainNode>> deadGraphs) {

		// remove domains from queryDomains that are found in deadGraphs
		for (int i = 0; i < deadGraphs.size(); i++) {
			Vector<?> currentGraph = (Vector<?>) deadGraphs.get(i);
			for (int j = 0; j < currentGraph.size(); j++) {
				DomainNode currentDomain = (DomainNode) currentGraph.get(j);
				String domainName = currentDomain._domainName;
				queryDomains.remove(domainName); // this is a dead domain
			}
		}

		// add tables from queryDomains into userFromTables
		usedFromTables.removeAllElements();
		Set<String> domains = queryDomains.keySet();
		for (Iterator<String> i = domains.iterator(); i.hasNext();) {
			String domainName = i.next();
			HashMap<SQLTableWrapper, ?> tablesHash = queryDomains
					.get(domainName);
			Set<SQLTableWrapper> tables = tablesHash.keySet(); // should be
																// SQLTableWrappers
			for (Iterator<SQLTableWrapper> j = tables.iterator(); j.hasNext();) {
				usedFromTables.add(j.next());
			}

		}
	}

	/**
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object o) {
		if (!(o instanceof DefaultGrammarSpecificGenerator))
			return false;
		DefaultGrammarSpecificGenerator other = (DefaultGrammarSpecificGenerator) o;
		Element otherSelect = (Element) other.getRoot()
				.getElementsByTagName(SELECT).item(0);
		Element thisSelect = (Element) this.getRoot()
				.getElementsByTagName(SELECT).item(0);

		if (!otherSelect.getAttribute(SELECT_MAX_COLUMNS).equals(
				thisSelect.getAttribute(SELECT_MAX_COLUMNS)))
			return false;

		Element otherFrom = (Element) other.getRoot()
				.getElementsByTagName(FROM).item(0);
		Element thisFrom = (Element) this.getRoot().getElementsByTagName(FROM)
				.item(0);
		if (!otherFrom.getAttribute(FROM_MAX_TABLES).equals(
				thisFrom.getAttribute(FROM_MAX_TABLES)))
			return false;
		if (!otherFrom.getAttribute(FROM_USE_DUPLICATES).equals(
				thisFrom.getAttribute(FROM_USE_DUPLICATES)))
			return false;

		Element otherWhere = (Element) other.getRoot()
				.getElementsByTagName(WHERE).item(0);
		Element thisWhere = (Element) this.getRoot()
				.getElementsByTagName(WHERE).item(0);
		if (!otherWhere.getAttribute(WHERE_MAX_PREDICATES).equals(
				thisWhere.getAttribute(WHERE_MAX_PREDICATES)))
			return false;
		if (!otherWhere.getAttribute(WHERE_USE_PERCENT_COMPLEX).equals(
				thisWhere.getAttribute(WHERE_USE_PERCENT_COMPLEX)))
			return false;
		if (!otherWhere.getAttribute(WHERE_MAX_IS_ABSOLUTE).equals(
				thisWhere.getAttribute(WHERE_MAX_IS_ABSOLUTE)))
			return false;

		NodeList thisOperators = ((Element) this.getRoot()
				.getElementsByTagName(WHERE_BINARY_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);
		NodeList otherOperators = ((Element) other.getRoot()
				.getElementsByTagName(WHERE_BINARY_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);

		if (thisOperators.getLength() != otherOperators.getLength())
			return false;

		for (int i = 0; i < thisOperators.getLength(); i++)
			if (!((Element) thisOperators.item(i)).getAttribute(WHERE_SYMBOL)
					.equals(((Element) otherOperators.item(i))
							.getAttribute(WHERE_SYMBOL)))
				return false;

		thisOperators = ((Element) this.getRoot()
				.getElementsByTagName(WHERE_BINARY_LOGICAL_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);
		otherOperators = ((Element) other.getRoot()
				.getElementsByTagName(WHERE_BINARY_LOGICAL_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);

		if (thisOperators.getLength() != otherOperators.getLength())
			return false;

		for (int i = 0; i < thisOperators.getLength(); i++)
			if (!((Element) thisOperators.item(i)).getAttribute(WHERE_SYMBOL)
					.equals(((Element) otherOperators.item(i))
							.getAttribute(WHERE_SYMBOL)))
				return false;

		thisOperators = ((Element) this.getRoot()
				.getElementsByTagName(WHERE_UNARY_LOGICAL_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);
		otherOperators = ((Element) other.getRoot()
				.getElementsByTagName(WHERE_UNARY_LOGICAL_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);

		if (thisOperators.getLength() != otherOperators.getLength())
			return false;

		for (int i = 0; i < thisOperators.getLength(); i++)
			if (!((Element) thisOperators.item(i)).getAttribute(WHERE_SYMBOL)
					.equals(((Element) otherOperators.item(i))
							.getAttribute(WHERE_SYMBOL)))
				return false;

		return true;
	}

	/**
	 * @see azdblab.analysis.api.QueryGenerator#generateQueries()
	 */
	// TODO this is where the magic happens
	/*
	 * public int generateQueries(String startTime) { Run exp_run =
	 * User.getUser(strUserName).getNotebook(strNotebookName)
	 * .getExperiment(strExperimentName).getRun(startTime);
	 * exp_run.deleteExperimentRunQueries(); _domains = new HashMap<String,
	 * HashMap<String, HashMap<String, String>>>();
	 * loadIntoDomains(_variableTables); loadIntoDomains(_fixedTables);
	 * 
	 * for (int i = 0; i < _numberQueries; i++) {
	 * 
	 * String query = generateQuery(); // String query =
	 * buildQuery(add_aggregate); Main._logger.outputLog("generated query: " +
	 * query);
	 * 
	 * exp_run.insertQuery(strUserName, strNotebookName, strExperimentName,
	 * startTime, i, query); }
	 * 
	 * return _numberQueries; }
	 */

	public int generateQueries(String startTime) {
	    List<Query> testQueries = null;
	    Run exp_run =
	    		 User.getUser(strUserName).getNotebook(strNotebookName)
	    		 .getExperiment(strExperimentName).getRun(startTime);
	    while (testQueries == null) {
	      testQueries = exp_run.getExperimentRunQueries();
	    }
//		String cases[] = {"1:0",
//		                  "2:0", "2:1",
//		                  "3:0", "3:1", "3:2",
//		                  "4:0", "4:1", "4:2", "4:3"};
		String cases[] = {"2:0", "2:1",
	            		  "3:0", "3:1", "3:2",
	            		  "4:0", "4:1", "4:2", "4:3"};
		boolean add_aggregate;
	    if (testQueries.size() != _numberQueries) {
	      // something got killed during query generation (not analysis)
	      // _labnotebook.deleteTestQueries(_experimentName, _testNumber);
	      exp_run.deleteExperimentRunQueries();
	      try {
	        String queryFileName =
	            Constants.DIRECTORY_TEMP + "/" + strExperimentName + "_randomQuery";
	System.out.println("Writing random queries to file: " + queryFileName + ".xml");
	        FileWriter file_writer = new FileWriter(queryFileName + ".xml");
	        BufferedWriter buf_writer = new BufferedWriter(file_writer);
	        buf_writer.append(
	            "<predefinedQueries name = \"" + queryFileName + "\" >\n");
	        for (int i = 0; i < _numberQueries; i++) {
	          //String query = buildQuery();
	          if (i / cases.length % 2 == 0) {
	            add_aggregate = true;
	          } else {
	            add_aggregate = false;
	          }
	          String query = buildQueryForThe10Cases(i, cases[i % cases.length], add_aggregate);
//	          String query = buildQuery(add_aggregate);
	          System.out.println("generated query: " + query);
	      
	          buf_writer.append("<query sql=\"" + query + " \"/>\n");
	          exp_run.insertQuery(strUserName, strNotebookName,
	                              strExperimentName, startTime, i, query);
	          
	        }
	        buf_writer.append("</predefinedQueries>\n");
	        buf_writer.close();
	        file_writer.close();
	       
	      } catch (IOException ioex) {
	        ioex.printStackTrace();
	      }
	    } else {
	      for (int i = 0; i < testQueries.size(); i++) {
	        Query testQuery = (Query) testQueries.get(i);
	        if (!exp_run.queryExist(strUserName, strNotebookName,
	                                strExperimentName, startTime,
	                                testQuery.iQueryNumber)) {
	          // query result does not exist
	          exp_run.deleteQuery(testQuery.iQueryNumber);
	          exp_run.insertQuery(strUserName, strNotebookName,
	                              strExperimentName, startTime,
	                              testQuery.iQueryNumber, testQuery.strQuerySQL);
	        }
	        if (Main.verbose) {
	          System.out.println("Query Retrieved from DBMS: "
	                                 + testQuery.strQuerySQL);
	        }
	      }
	    }
	    return _numberQueries;
	  }
	public Query getQuery(int numJoins, int numSelects, int aggregate) {
		_domains = new HashMap<String, HashMap<String, HashMap<String, String>>>();
		loadIntoDomains(_variableTables);
		loadIntoDomains(_fixedTables);
		String query = "";
		if (aggregate == 1) {
			query = buildQuery(numJoins, numSelects, true);
			// query = buildQueryForThe10Cases(0, (numJoins + 1) + ":" +
			// numCorr,
			// true);
		} else {
			query = buildQuery(numJoins, numSelects, false);
			// query = buildQueryForThe10Cases(0, (numJoins + 1) + ":"
			// + numCorr, false);
		}
		return new Query(strUserName, strNotebookName, 0, 0, query.replace(
				"null", "SUM"));

	}

	// This produces a query in which two parameters are uniformly distributed
		// among the batch being generated. The two parameters are the
		// aggregate existence, # correlation names in FROM and (combined) with
		// # selfjoins.
		private String buildQueryForThe10Cases(int query_num, String picked_case,
				                               boolean add_aggregate) {
			// determining the number of tables, select columns and simple
			// predicates.
			String[] case_detail = picked_case.split(":");
			int numCorrelationNamesInFrom = Integer.parseInt(case_detail[0]);
			int numExpectedSelfjoins = Integer.parseInt(case_detail[1]);
			
			int numColumnsInSelect = getRandomNumber(1, _maxColumns);
			int numSimplePredicates = 0;
			// Choosing the FROM tables.
			//Vector usedFromTables = selectFromTables(numTables);
			Vector usedFromTables = selectFromTablesWithUniformSelfjoins(numCorrelationNamesInFrom, numExpectedSelfjoins);
			// calculating the number of simple predicates based on the attribute of whether the maxPredicates values is absolute.
			if (_maxAbsolute) {
				if(usedFromTables.size() > 1){
					int minInequalityPredicates = _minInequality, maxInequalityPredicates = _maxInequality;
					// choose the min between _minInequality and usedFromTables.size()-1
					if(minInequalityPredicates > usedFromTables.size()-1){
						minInequalityPredicates = usedFromTables.size()-1;
					}
					// choose the min between _maxInequality and usedFromTables.size()-1
					if(maxInequalityPredicates > usedFromTables.size()-1){
						maxInequalityPredicates = usedFromTables.size()-1;
					}
					numSimplePredicates = getRandomNumber(minInequalityPredicates, maxInequalityPredicates);
				}
				else
					numSimplePredicates = 0;
				
	System.out.println("# of corrNames: " + numCorrelationNamesInFrom + " / numOfPredicates : " + numSimplePredicates);
//				numSimplePredicates = getRandomNumber(0, _maxPredicates);
			} else {
				// is relative
				if(usedFromTables.size() > 1){
					int minInequalityPredicates = _minInequality, maxInequalityPredicates = _maxInequality;
					// choose the min between _minInequality and usedFromTables.size()-1
					if(minInequalityPredicates > usedFromTables.size()-1){
						minInequalityPredicates = usedFromTables.size()-1;
					}
					// choose the min between _maxInequality and usedFromTables.size()-1
					if(maxInequalityPredicates > usedFromTables.size()-1){
						maxInequalityPredicates = usedFromTables.size()-1;
					}
					numSimplePredicates = getRandomNumber(minInequalityPredicates*usedFromTables.size(), maxInequalityPredicates*usedFromTables.size());
				}
				else
					numSimplePredicates = 0;
//				numSimplePredicates = getRandomNumber(0, _maxPredicates	* usedFromTables.size());			
			}

			// Construct the query domains.
			HashMap queryDomains = buildQueryDomains(usedFromTables);

			String cartesianEliminator = null;
			if (!_cartesianPossible)
				cartesianEliminator = buildEliminator(usedFromTables, queryDomains);
			// this may trim the number of tables/domains in the from clause tables

			Vector<String> selected_attributes = new Vector<String>();
			// building the pieces of the SQL query.
			String fromSQL = buildFromClause(usedFromTables);
			String selectSQL = buildSelectClause(usedFromTables, numColumnsInSelect,
					                             selected_attributes);
			String whereSQL = buildWhereClause(
	            queryDomains, usedFromTables,
	            numSimplePredicates, cartesianEliminator);
//			if (use_aggregate_ &&
//	            (reprand.getNextRandomInt() % aggregate_frequency_ == 0)) {
			if (add_aggregate) {
			  AggregateStmt aggregate_stmt = DefaultGrammarSpecificGenerator.
	              BuildAggregateStatement(
	                  aggfunction_name_, selected_attributes, reprand, selectSQL);
			  return aggregate_stmt.aggregate_statement +
			      fromSQL + whereSQL + aggregate_stmt.groupby_statement;
			} else {
	          return selectSQL + fromSQL + whereSQL;
			}
		}

	private String buildQuery(int numJoins, int numSelects, boolean aggregate) {
		int numCorrelationNamesInFrom = numJoins + 1;
		int numExpectedSelfjoins = getRandomNumber(0,
				numCorrelationNamesInFrom - 1);

		int numColumnsInSelect = numSelects;
		int numSimplePredicates = 0;
		// Choosing the FROM tables.
		// Vector usedFromTables = selectFromTables(numTables);
		Vector<SQLTableWrapper> usedFromTables = selectFromTablesWithUniformSelfjoins(
				numCorrelationNamesInFrom, numExpectedSelfjoins);
		// calculating the number of simple predicates based on the attribute of
		// whether the maxPredicates values is absolute.
		if (_maxAbsolute) {
			if (usedFromTables.size() > 1) {
				int minInequalityPredicates = _minInequality, maxInequalityPredicates = _maxInequality;
				// choose the min between _minInequality and
				// usedFromTables.size()-1
				if (minInequalityPredicates > usedFromTables.size() - 1) {
					minInequalityPredicates = usedFromTables.size() - 1;
				}
				// choose the min between _maxInequality and
				// usedFromTables.size()-1
				if (maxInequalityPredicates > usedFromTables.size() - 1) {
					maxInequalityPredicates = usedFromTables.size() - 1;
				}
				numSimplePredicates = getRandomNumber(minInequalityPredicates,
						maxInequalityPredicates);
			} else
				numSimplePredicates = 0;

			Main._logger.outputLog("# of corrNames: "
					+ numCorrelationNamesInFrom + " / numOfPredicates : "
					+ numSimplePredicates);
			// numSimplePredicates = getRandomNumber(0, _maxPredicates);
		} else {
			// is relative
			if (usedFromTables.size() > 1) {
				int minInequalityPredicates = _minInequality, maxInequalityPredicates = _maxInequality;
				// choose the min between _minInequality and
				// usedFromTables.size()-1
				if (minInequalityPredicates > usedFromTables.size() - 1) {
					minInequalityPredicates = usedFromTables.size() - 1;
				}
				// choose the min between _maxInequality and
				// usedFromTables.size()-1
				if (maxInequalityPredicates > usedFromTables.size() - 1) {
					maxInequalityPredicates = usedFromTables.size() - 1;
				}
				numSimplePredicates = getRandomNumber(minInequalityPredicates
						* usedFromTables.size(), maxInequalityPredicates
						* usedFromTables.size());
			} else
				numSimplePredicates = 0;
			// numSimplePredicates = getRandomNumber(0, _maxPredicates *
			// usedFromTables.size());
		}

		// Construct the query domains.
		HashMap<String, HashMap<SQLTableWrapper, HashMap<?, ?>>> queryDomains = buildQueryDomains(usedFromTables);

		String cartesianEliminator = null;
		if (!_cartesianPossible)
			cartesianEliminator = buildEliminator(usedFromTables, queryDomains);
		// this may trim the number of tables/domains in the from clause tables

		Vector<String> selected_attributes = new Vector<String>();
		// building the pieces of the SQL query.
		String fromSQL = buildFromClause(usedFromTables);
		String selectSQL = buildSelectClause(usedFromTables,
				numColumnsInSelect, selected_attributes);
		String whereSQL = buildWhereClause(queryDomains, usedFromTables,
				numSimplePredicates, cartesianEliminator);
		// if (use_aggregate_ &&
		// (reprand.getNextRandomInt() % aggregate_frequency_ == 0)) {
		if (aggregate) {
			AggregateStmt aggregate_stmt = DefaultGrammarSpecificGenerator
					.BuildAggregateStatement(aggfunction_name_,
							selected_attributes, reprand, selectSQL);
			return aggregate_stmt.aggregate_statement + fromSQL + whereSQL
					+ aggregate_stmt.groupby_statement;
		} else {
			return selectSQL + fromSQL + whereSQL;
		}
	}

	public Run getRun(String expName, String startTime) {
		return User.getUser(strUserName).getNotebook(strNotebookName)
				.getExperiment(expName).getRun(startTime);
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
	private int getRandomNumber(int start, int finish) {
		int range = finish - start;
		range++; // since Math.random never returns 1.0
		// int result = (int) ( range * Math.random() );

		// The cast to INT truncates, so we will get an integer between 0 and
		// (finish - start)
		int result = (int) (range * reprand.getNextDouble());

		// ensure range is from start to finish
		result += start;
		return result;
	}

	/**
	 * @see azdblab.analysis.api.QueryGenerator#getRoot()
	 */
	public Element getRoot() {
		return myRoot;
	}

	public String getQueryDefName() {
		return null;
	}

	public File getQueryDefFile() {
		return null;
	}

	/**
	 * Called by the constructor to parse the XML for the query generator.
	 * 
	 * @throws FileNotFoundException
	 */
	private int init() throws FileNotFoundException {
		// System.out.println("schema: " + _schemaFile);
		myRoot = XMLHelper.validate(
				new FileInputStream(new File(Constants.XML_SCHEMA_DIRECTORY
						+ _schemaFile)), new FileInputStream(_xmlFile))
				.getDocumentElement();

		// Main._logger.outputLog("xml schema file: " +
		// MetaData.XML_SCHEMA_DIRECTORY + _schemaFile);
		// Main._logger.outputLog("xml file: " +
		// MetaData.XML_SCHEMA_DIRECTORY + _xmlFile);
		NodeList select = myRoot.getElementsByTagName(SELECT);
		String maxColumns = ((Element) select.item(0))
				.getAttribute(SELECT_MAX_COLUMNS);
		if (((Element) select.item(0)).hasAttribute(SELECT_MIN_COLUMNS)) {
			_minColumns = Integer.parseInt(((Element) select.item(0))
					.getAttribute(SELECT_MIN_COLUMNS));
		} else {
			_minColumns = 1;
		}
		_selectAll = maxColumns.equals(SELECT_ALL);
		if (_selectAll) {
			_maxColumns = 1;
		} else {
			_maxColumns = Integer.parseInt(maxColumns);
		}

		NodeList from = myRoot.getElementsByTagName(FROM);
		String maxTables = ((Element) from.item(0))
				.getAttribute(FROM_MAX_TABLES);
		String minTables = ((Element) from.item(0))
				.getAttribute(FROM_MIN_TABLES);

		String useDuplicates = ((Element) from.item(0))
				.getAttribute(FROM_USE_DUPLICATES);

		if (!minTables.equals("")) {
			if (minTables.equals(FROM_ACTUAL))
				_minTables = _fixedTables.length + _variableTables.length;
			else
				_minTables = Integer.parseInt(minTables);
			// Main._logger.outputLog("min correlation names: "
			// + _minTables);
		} else {
			// it is set to 1 as default
			_minTables = 1;
		}

		if (maxTables.equals(FROM_ACTUAL))
			_maxTables = _fixedTables.length + _variableTables.length;
		else
			_maxTables = Integer.parseInt(maxTables);
		// Main._logger.outputLog("max correlation names: " + _maxTables);

		_useDuplicates = Boolean.valueOf(useDuplicates).booleanValue();

		NodeList where = myRoot.getElementsByTagName(WHERE);
		String maxPredicates = ((Element) where.item(0))
				.getAttribute(WHERE_MAX_PREDICATES);
		String usePercentComplex = ((Element) where.item(0))
				.getAttribute(WHERE_USE_PERCENT_COMPLEX);
		String maxType = ((Element) where.item(0))
				.getAttribute(WHERE_MAX_IS_ABSOLUTE);
		String cartPossible = ((Element) where.item(0))
				.getAttribute(WHERE_CARTESIAN_POSSIBLE);
		String minInequality = ((Element) where.item(0))
				.getAttribute(WHERE_MIN_INEQUALITY);
		String maxInequality = ((Element) where.item(0))
				.getAttribute(WHERE_MAX_INEQUALITY);

		// Later this should be changed to more detailed control such as
		// number of attributes in agg functions... Right now, this just
		// tells whether there should be agg function.
		NodeList aggregate_nodes = myRoot.getElementsByTagName(AGGREGATE);
		if (aggregate_nodes == null || aggregate_nodes.item(0) == null) {
			use_aggregate_ = false;
		} else {
			use_aggregate_ = true;
			aggfunction_name_ = ((Element) aggregate_nodes.item(0))
					.getAttribute("function_name");
			String agg_percent = ((Element) aggregate_nodes.item(0))
					.getAttribute("percentage");
			if (agg_percent == null) {
				aggregate_frequency_ = 1;
			} else {
				try {
					aggregate_frequency_ = (int) (1 / (Double
							.parseDouble(agg_percent) / 100.0));
				} catch (Exception e) {
					aggregate_frequency_ = 0;
				}
			}
			if (((Element) aggregate_nodes.item(0)).hasAttribute(MIN_AGGREGATE)) {
				_minAggregate = Integer.parseInt(((Element) aggregate_nodes
						.item(0)).getAttribute(MIN_AGGREGATE));
			}
			if (((Element) aggregate_nodes.item(0)).hasAttribute(MAX_AGGREGATE)) {
				_maxAggregate = Integer.parseInt(((Element) aggregate_nodes
						.item(0)).getAttribute(MAX_AGGREGATE));
			}

		}
		_maxAbsolute = Boolean.valueOf(maxType).booleanValue();
		_usePercentComplex = Integer.parseInt(usePercentComplex);
		Integer.parseInt(maxPredicates);
		_cartesianPossible = Boolean.valueOf(cartPossible).booleanValue();

		if (minInequality == null || minInequality.equals("")) {
			_minInequality = 0;
		} else {
			_minInequality = Integer.parseInt(minInequality);
		}
		// Main.defaultLogger
		// .log_normal("minimum inequalities: " + _minInequality);
		if (maxInequality == null || maxInequality.equals("")) {
			_maxInequality = 0;
		} else {
			_maxInequality = Integer.parseInt(maxInequality);
		}
		// Main.defaultLogger
		// .log_normal("maximum inequalities: " + _maxInequality);

		NodeList binaryOperators = ((Element) myRoot.getElementsByTagName(
				WHERE_BINARY_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);
		_binaryOperators = new String[binaryOperators.getLength()];

		// if cartesianPossible is false and "=" operator is not specified in
		// binaryOperators, a semantic error occurs.
		// otherwise, predicates are built based upon one of the binary
		// operators.
		boolean semanticError = false;
		if (!_cartesianPossible) {
			semanticError = true;
		}

		for (int i = 0; i < binaryOperators.getLength(); i++) {
			_binaryOperators[i] = ((Element) binaryOperators.item(i))
					.getAttribute(WHERE_SYMBOL);
			// Main._logger.outputLog("binary operator: "
			// + _binaryOperators[i]);
			if (_binaryOperators[i].equals("=")) {
				semanticError = false;
			}
		}

		if (semanticError) {
			return -1;
		}

		if (!_cartesianPossible) {
			// exclude "=" operator, since "=" operator will be used for
			// eliminating cartesian product
			Vector<String> binaryOps = new Vector<String>();
			for (int i = 0; i < _binaryOperators.length; i++) {
				if (!_binaryOperators[i].equalsIgnoreCase("=")) {
					binaryOps.add((String) _binaryOperators[i]);
				}
			}
			if (binaryOps.size() > 0) {
				_binaryOperators = new String[binaryOps.size()];
				for (int i = 0; i < binaryOps.size(); i++) {
					_binaryOperators[i] = binaryOps.get(i);
				}
			}
		}

		NodeList binaryLogicalOperators = ((Element) myRoot
				.getElementsByTagName(WHERE_BINARY_LOGICAL_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);
		_binaryLogicalOperators = new String[binaryLogicalOperators.getLength()];
		for (int i = 0; i < binaryLogicalOperators.getLength(); i++) {
			_binaryLogicalOperators[i] = ((Element) binaryLogicalOperators
					.item(i)).getAttribute(WHERE_SYMBOL);
		}

		NodeList unaryLogicalOperators = ((Element) myRoot
				.getElementsByTagName(WHERE_UNARY_LOGICAL_OPERATORS).item(0))
				.getElementsByTagName(WHERE_OPERATOR);
		_unaryLogicalOperators = new String[unaryLogicalOperators.getLength()];
		for (int i = 0; i < unaryLogicalOperators.getLength(); i++) {
			_unaryLogicalOperators[i] = ((Element) unaryLogicalOperators
					.item(i)).getAttribute(WHERE_SYMBOL);
		}
		_unaryUsePercent = Integer.parseInt(((Element) unaryLogicalOperators
				.item(0)).getAttribute(WHERE_USE_PERCENT));

		_domains = new HashMap<String, HashMap<String, HashMap<String, String>>>();

		loadIntoDomains(_variableTables);
		loadIntoDomains(_fixedTables);

		return 0;
	}

	/**
	 * Loads all the tables into domains. A table may appear in many domains if
	 * it has columns from different domains.
	 * 
	 * @param tables
	 *            The tables that need to be loaded into domains.
	 */
	private void loadIntoDomains(Table[] tables) {
		// for each table
		for (int i = 0; i < tables.length; i++) {
			Table table = tables[i];
			// for each column in the table
			for (int j = 0; j < table.columns.length; j++) {
				Column column = table.columns[j];
				String dataDomain = _dataDef.getColumnDataTypeASString(
						table.table_name, column.myName);
				HashMap<String, HashMap<String, String>> currDomain = _domains
						.get(dataDomain);
				// determine if the domain for this data type exists
				if (currDomain == null) {
					// creating the domains since it doesn't exist
					currDomain = new HashMap<String, HashMap<String, String>>();
					_domains.put(dataDomain, currDomain);
				}
				HashMap<String, String> tableMap = currDomain
						.get(table.table_name);
				if (tableMap == null) {
					// creating the hashmap for the table since it doesn't exist
					tableMap = new HashMap<String, String>();
					currDomain.put(table.table_name, tableMap);
				}
				String columnName = tableMap.get(column.myName);
				if (columnName == null) {
					tableMap.put(column.myName, column.myName);
				}
			}
		}
	}

	private Vector<SQLTableWrapper> selectFromTablesWithUniformSelfjoins(
			int numTables, int numSelfjoins) {
		Vector<Table> allFromTables = new Vector<Table>();
		Vector<SQLTableWrapper> usedFromTables = new Vector<SQLTableWrapper>();
		for (int i = 0; i < _variableTables.length; i++) {
			allFromTables.add(_variableTables[i]);
		}
		// must have at least one variable table
		int table_index = getRandomNumber(0, allFromTables.size() - 1);
		Table currTable = (Table) ((_useDuplicates) ? allFromTables
				.get(table_index) : allFromTables.remove(table_index));
		String alias = "t" + usedFromTables.size();
		// String fromSQL = " FROM " + currTable.table_name_with_prefix + " " +
		// alias;
		usedFromTables.add(new SQLTableWrapper(currTable, alias));
		for (int i = 0; i < numSelfjoins; ++i) {
			alias = "t" + usedFromTables.size();
			usedFromTables.add(new SQLTableWrapper(currTable, alias));
		}
		for (int i = 0; i < _fixedTables.length; i++) {
			allFromTables.add(_fixedTables[i]);
		}
		for (int i = usedFromTables.size(); i < numTables; i++) {
			table_index = getRandomNumber(_variableTables.length,
					allFromTables.size() - 1);
			currTable = (Table) ((_useDuplicates) ? allFromTables
					.get(table_index) : allFromTables.remove(table_index));
			alias = "t" + usedFromTables.size();
			// fromSQL += ", " + currTable.table_name_with_prefix + " " + alias;
			usedFromTables.add(new SQLTableWrapper(currTable, alias));
			if (allFromTables.size() == 0) {
				break;
			}
		}
		return usedFromTables;
	}

	/**
	 * This method divides the graph of domains for this query into connected
	 * subgraphs.
	 * 
	 * @param completeGraph
	 *            The original graph of the domains.
	 * @return The subgraphs.
	 */
	private Vector<Vector<DomainNode>> splitEliminatorGraph(
			Vector<DomainNode> completeGraph) {
		Vector<Vector<DomainNode>> subGraphs = new Vector<Vector<DomainNode>>();

		while (completeGraph.size() > 0) {
			Vector<DomainNode> subgraph = new Vector<DomainNode>();
			Vector<DomainNode> queue = new Vector<DomainNode>();

			DomainNode unexploredDomainNode = completeGraph.remove(0);
			subgraph.add(unexploredDomainNode);
			queue.add(unexploredDomainNode);

			// doing a bread first search
			while (queue.size() > 0) {
				DomainNode currentNode = queue.remove(0); // grab
				// first
				// element
				// for each domain it touches
				for (int i = 0; i < currentNode._edgeList.size(); i++) {
					DomainEdge currentEdge = (DomainEdge) currentNode._edgeList
							.get(i); // first domain it reaches
					int indexOtherDomain = completeGraph
							.indexOf(new DomainNode(currentEdge._domainNameDest));
					if (indexOtherDomain > -1) {
						// this domain is connected and has not been removed yet
						// from list
						unexploredDomainNode = completeGraph
								.remove(indexOtherDomain);
						subgraph.add(unexploredDomainNode);
						queue.add(unexploredDomainNode);
					}
				}
			}
			subGraphs.add(subgraph);

		}
		return subGraphs;
	}

	public void setTestTime(String test_time) {
		strStartTime = test_time;
	}

	public String getDescription(boolean hasResult) {

		String strDescription = "";

		if (hasResult) {
			List<Query> queries = User.getUser(strUserName)
					.getNotebook(strNotebookName)
					.getExperiment(strExperimentName).getRun(strStartTime)
					.getExperimentRunQueries();

			for (int i = 0; i < queries.size(); i++) {
				Query query = queries.get(i);
				strDescription += query.iQueryNumber + "\t" + query.strQuerySQL
						+ "\n";
			}

		} else {
			return "Default Grammar Specific Generator";
		}

		return strDescription;

	}

	public boolean checkSuccess() {
		return success;
	}

	public int getMaxColumns() {
		return _maxColumns;
	}

	public boolean getUseAggregate() {
		return use_aggregate_;
	}

	public int getMaxJoins() {
		return _maxTables - 1;
	}

	/**
	 * indicate whether query generator is successfully generated.
	 */
	private boolean success;

	/**
	 * The FROM Keyword
	 */
	private static final String FROM = "from";

	/**
	 * Denotes actual number of tables used.
	 */
	private static final String FROM_ACTUAL = "actual";

	/**
	 * The maximumn number of tables.
	 */
	private static final String FROM_MAX_TABLES = "maxNumCorrelationNames";

	/**
	 * The maximumn number of tables.
	 */
	private static final String FROM_MIN_TABLES = "minNumCorrelationNames";
	/**
	 * The minimum number of aggregates
	 */
	private static final String MIN_AGGREGATE = "minAggregates";

	/**
	 * The maximum number of aggregates
	 */
	private static final String MAX_AGGREGATE = "maxAggregates";
	/**
	 * Whether duplicates are allowed to appear in the from clause.
	 */
	private static final String FROM_USE_DUPLICATES = "useDuplicates";

	/**
	 * The select keyword
	 */
	private static final String SELECT = "select";

	/**
	 * Indicates that all columns should be selected or SELECT *
	 */
	private static final String SELECT_ALL = "all";

	/**
	 * The maximum number of columns in the SELECT clause.
	 */
	private static final String SELECT_MAX_COLUMNS = "maxColumns";
	/**
	 * The minimum number of columns in the select clause
	 */
	private static final String SELECT_MIN_COLUMNS = "minColumns";
	/**
	 * The WHERE keyword
	 */
	private static final String WHERE = "where";

	private static final String AGGREGATE = "aggregate";

	/**
	 * The attribute for binary logical operators.
	 */
	private static final String WHERE_BINARY_LOGICAL_OPERATORS = "binaryLogicalOperators";

	/**
	 * The attribute for binary operators.
	 */
	private static final String WHERE_BINARY_OPERATORS = "binaryOperators";

	/**
	 * The attribute for determining if cartesian product is possible.
	 */
	private static final String WHERE_CARTESIAN_POSSIBLE = "cartesianPossible";

	/**
	 * The attribute that determines whether the maxIsAbsolute.
	 */
	private static final String WHERE_MAX_IS_ABSOLUTE = "maxIsAbsolute";

	/**
	 * The attribute that determines the max number of predicates.
	 */
	private static final String WHERE_MAX_PREDICATES = "maxPredicates";

	/**
	 * The attribute that determines the min number of inequality.
	 */
	private static final String WHERE_MIN_INEQUALITY = "minNumInequality";

	/**
	 * The attribute that determines the max number of inequality.
	 */
	private static final String WHERE_MAX_INEQUALITY = "maxNumInequality";

	/**
	 * The attribute that identifies the operator.
	 */
	private static final String WHERE_OPERATOR = "operator";

	/**
	 * The symbol for the operator.
	 */
	private static final String WHERE_SYMBOL = "symbol";

	/**
	 * The atttribute for unary logical operators.
	 */
	private static final String WHERE_UNARY_LOGICAL_OPERATORS = "unaryLogicalOperators";

	/**
	 * The percentage of use for this option.
	 */
	private static final String WHERE_USE_PERCENT = "usePercentage";

	/**
	 * The percent use for complex predicates.
	 */
	private static final String WHERE_USE_PERCENT_COMPLEX = "complexUsePercentage";

	/**
	 * The binary logical operators for this generator
	 */
	private String[] _binaryLogicalOperators;

	/**
	 * The binary operators for this generator
	 */
	private String[] _binaryOperators;

	/**
	 * The cartesian product possibility variable.
	 */
	private boolean _cartesianPossible;

	/**
	 * The minimum inequality predicates
	 */
	private int _minInequality;

	/**
	 * The maximum inequality predicates
	 */
	private int _maxInequality;

	/**
	 * The data definition for this query generator.
	 */
	private DataDefinition _dataDef;

	/**
	 * The domains that this query will use.
	 */
	// DOMAIN SUPPORT
	private HashMap<String, HashMap<String, HashMap<String, String>>> _domains;

	/**
	 * The fixed tables for this query generator
	 */
	private Table[] _fixedTables;

	/**
	 * Determines if the max value is absolute
	 */
	private boolean _maxAbsolute;

	private boolean use_aggregate_;
	private int aggregate_frequency_;
	private String aggfunction_name_;

	/**
	 * The maximum number of columns in the select clause.
	 */
	private int _maxColumns = 0;

	/**
	 * the minimum number of columns in the select clause
	 */
	private int _minColumns = 0;

	/**
	 * The maximum number of aggregates
	 */
	private int _maxAggregate = 0;

	/**
	 * The minimum number of aggregates
	 */
	private int _minAggregate = 0;

	/**
	 * The maximum number of tables in the FROM clause.
	 */
	private int _maxTables = 0;

	/**
	 * The minimum number of tables in the FROM clause. Unless specified, its
	 * default value is 1.
	 */
	private int _minTables = 1;

	/**
	 * The number of queries that will be generated.
	 */
	private int _numberQueries;

	/**
	 * The schema used to validate this grammar XML.
	 */
	private String _schemaFile;

	/**
	 * Indicates whether or not all columns should be in the select clause.
	 */
	private boolean _selectAll;

	/**
	 * The unary logical operators for this query generator.
	 */
	private String[] _unaryLogicalOperators;

	/**
	 * The percentage of use of the unary operators.
	 */
	private int _unaryUsePercent;

	/**
	 * Determines whether or not the query generator allows duplicates in the
	 * FROM clause.
	 */
	private boolean _useDuplicates;

	/**
	 * The percentage of time that the complex predicates are formed.
	 */
	private int _usePercentComplex;

	/**
	 * The variable tables for this query generator.
	 */
	private Table[] _variableTables;

	/**
	 * The XML source for query generator.
	 */
	private File _xmlFile;

	/**
	 * The DOM root for the query generator.
	 */
	private Element myRoot;

}