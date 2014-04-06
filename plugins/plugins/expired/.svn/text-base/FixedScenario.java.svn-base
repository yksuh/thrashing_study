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
package plugins.expired;

import azdblab.Constants;
import azdblab.labShelf.PlanNode;
import azdblab.labShelf.QueryExecutionStat;
import azdblab.labShelf.RepeatableRandom;
import azdblab.model.experiment.ExperimentRun;
import azdblab.model.experiment.Table;

/**
 * This experiment scenario times plan execution of "optimal" plans 
 * @author ruizhang; edited by scurrim
 *
 */

/* used by Oracle and non Oracle DBMSs to get running time for queries */
public class FixedScenario extends VaryCardinalityScenario {
  /**
   * @param expRun experiment run instance
   */
  public FixedScenario(ExperimentRun expRun) {
    super(expRun);
  }

  /**
   * <p>Populate the variable tables. This scenario creates a template
   * table which has the same schema as the variable table, and then
   * populates the template table to the maximum cardinality stated by the
   * experiment specification. For studying the "optimal" plan at the "actual"
   * cardinality, it then clones part of the template table as the real variable
   * table such that the variable table will have the same cardinality as the
   * "actual" cardinality specified by the experiment specification.</p>
   * <p>More importantly, the content (data) of the cloned variable table
   * should be identical to as if it had been populated normally. In fact the way the
   * template table was populated guarantees the partial cloning has the
   * effect as expected.</p> 
   * @param variableTables The array of variable tables to be populated
   */
  protected void stepA(int phaseNumber, Table[] variableTables)
      throws Exception {
    for (int i = 0; i < variableTables.length; i++) {
      Table curr_table = variableTables[i];
      RepeatableRandom rr = new RepeatableRandom(curr_table.getTableSeed());
      // Last parameter (true) ensures that a template at the maximum
      // cardinality will be created first, and then partially cloned at the
      // actual cardinality
      
      // main difference between Oracle and non Oracle DBMS is that Oracle lets you
      // modify statistics without actually modifying rows in table. 
      // Hence the last parameter for for experimentSubject.populateTable is TRUE
      // This means that the table need to be cloned
      
      experimentSubject.populateTable(
          curr_table.table_name_with_prefix, curr_table.columns.length,
          curr_table.actual_card, curr_table.hy_max_card, rr, true);
      // For repeatability, ensure statistics are accurate
      experimentSubject.updateTableStatistics(curr_table);
      recordRunProgress(
          (int)((double)(i + 1) / (double)variableTables.length * 100),
          "Populating Variable Tables");
    }
  }

  /**
   * Timing query plan execution by calling <code>timeQueryExecution</code>
   * provided by the superclass.
   * @param sql The query to be executed
   * @param plan the plan to be used for executing the query
   * @param cardinality the cardinality at which the input plan was generated
   * for the input query.
   * @return The <code>QueryStat</code> instance which contains the running
   * time.
   */
  protected QueryExecutionStat stepB(int phaseNumber, String sql, PlanNode plan,
                               long cardinality) throws Exception {
    return timeQueryExecution(sql, plan, cardinality);
  }
  
  /**
   * Get the number of phases of this scenario.
   * @return The number of phases.
   */
  protected int getNumOfPhases() {
    return 1;
  }

	@Override
	protected boolean stepC(int phaseNumber, Table[] variableTables,
			long requested_cardinality) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	protected void setName() {
		scenarioName = Constants.NAME_FIXED_SCENARIO;
	}

	@Override
	protected void setVersion() {
		versionName = Constants.VERSION_FIXED_SCENARIO;
	}

	@Override
	public String getSupportedShelfs() {
		return "7.X";
	}
}
