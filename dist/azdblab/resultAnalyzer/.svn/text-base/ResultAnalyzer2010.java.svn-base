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
package azdblab.resultAnalyzer;


import java.sql.ResultSet;
import java.sql.SQLException;

import azdblab.executable.Main;
import azdblab.labShelf.dataModel.LabShelfManager;
import azdblab.labShelf.dataModel.User;
import azdblab.plugins.aspect.Aspect;



public class ResultAnalyzer2010 {
  
  public static void AnalyzeResult() {
	  
  }
  
  public static void AnalyzeQueriesForExperimentRun(
      String user_name, String labshelf_name,
      String experiment_name, String start_time) {
	  User.getUser(user_name).
        getNotebook(labshelf_name).getExperiment(experiment_name).
        getRun(start_time).analyzeAllQueries(
            user_name, labshelf_name, experiment_name, start_time);
  }
  
  
  public static void ComputeAspect(
      String user_name, String labshelf_name,
      String experiment_name, String start_time,
      String aspect_sql, String aspect_name, int opt_card,
      int min_card, int max_card) {
    Aspect.processAspect(
        user_name, labshelf_name, experiment_name, start_time, aspect_sql,
        aspect_name, opt_card, min_card, max_card, 0);
  }
  
  
  public void get_DBMS_Operators(String username, String expname, String start_time) {
	    Main._logger.outputLog("**** DBMSes & Operator ****");
	    String expnameClause =
	        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
	        expname + "%' AND er.starttime = '" + start_time + "' ";
	    String sql =
	        "SELECT DISTINCT er.DBMS, po.OperatorName " +
	        "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er, " +
	            "AZDBLAB_QUERY qr, AZDBLAB_QUERYEXECUTION qn, AZDBLAB_QRHASPLAN hp, " +
	            "AZDBLAB_PLANOPERATOR po " +
	        "WHERE " + expnameClause + "AND " +
	            "ex.experimentid = er.experimentid AND er.runid = qr.runid AND " +
	            "qr.queryid = qn.queryID AND qn.QueryExecutionID = hp.QueryExecutionID AND " +
	            "hp.PlanID = po.PlanID " +
	        "ORDER BY er.DBMS";
	    try {
	      ResultSet  rs = LabShelfManager.getShelf().executeQuerySQL(sql);
	      Main._logger.outputLog("DBMS \t % OperatorName");
	      while (rs.next()) {
	        Main._logger.outputLog(rs.getString(1) + " \t " + rs.getString(2));        
	      }
	      rs.close();
	    } catch (SQLException sqlex) {
	      sqlex.printStackTrace();
	    }
	  }
  
  
  public void get_NUMFROM_SubOptimal(String username, String expname,
          String aspectname, String start_time) {
    Main._logger.outputLog("**** Num Cor-name in FROM & SubOpt ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = '" + start_time + "' ";
    String sql =
        "SELECT temp.NUMFROM AS NUMFROM, sa.AspectValue AS ASPVAL " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, qr.QueryID AS QID, " +
        "ps.Value AS NUMFROM " +
        "FROM AZDBLAB_QUERYHASPARAMETER ps, AZDBLAB_QUERY qr, " +
        "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
        "WHERE " + expnameClause + "AND " +
        "ex.experimentid = er.experimentid AND " +
        "er.runid = qr.runid AND qr.queryid = ps.QueryID AND " +
        "ps.PARAMNAME = 'NUMCNFRM' " +
        "ORDER BY ex.ExperimentName, qr.QueryID, NUMFROM) temp " +
        "LEFT JOIN AZDBLAB_SATISFIESASPECT sa ON " +
        "temp.QID = sa.QueryID AND sa.AspectID " +
        "IN (SELECT da.AspectID " +
        "FROM AZDBLAB_DEFINEDASPECT da " +
        "WHERE da.AspectName = '" + aspectname + "') " +
        "ORDER BY ASPVAL, NUMFROM";
    try {
        ResultSet rs = LabShelfManager.getShelf().executeQuerySQL(sql);
        Main._logger.outputLog("NUM FRM \t SubOptimal/Optimal(1/0)");
        while (rs.next()) {
            Main._logger.outputLog(rs.getInt(1) + " \t " + rs.getInt(2));
        }
        rs.close();
    } catch (SQLException sqlex) {
        sqlex.printStackTrace();
    }
  }
  public static void main(String[] args) {
    String user_name = "";
    String labshelf_name = "";
    String experiment_name = "";
    String start_time = "";
    
    ResultAnalyzer2010.AnalyzeQueriesForExperimentRun(
        user_name, labshelf_name, experiment_name, start_time);
  }
    
/*  
  public void get_fastest_and_slowest(String username, String expname) {
    Main.defaultLogger.logging_normal("**** Percentage of SubOpt ****");
    String expnameClause =
      " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
      expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
    "SELECT qr.QueryNumber AS QNUM, MAX(cp.RunTime) " +
    "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er, " +
        "AZDBLAB_QUERY qr, AZDBLAB_QUERYEXECUTION cp " +
    "WHERE " + expnameClause + " AND er.RunID = qr.RunID AND " +
        "qr.QueryID = cp.QueryID " +
    "GROUP BY (qr.QueryNumber) " +
    "ORDER BY QNUM";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + "\t" + rs.getInt(2));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  
  public void getAllRuns() {
    String sql =
        "SELECT ex.UserName, ex.NotebookName, ex.ExperimentName, " +
            "er.StartTime " +
        "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er " +
        "WHERE ex.experimentid = er.experimentid AND er.Percentage = 100 AND " +
            "er.CurrentStage='Completed' ORDER BY ex.UserName, " +
            "ex.NotebookName, ex.ExperimentName, er.StartTime";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("un \t nn \t en \t st");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + "\t" + rs.getString(2) + 
                           " \t " + rs.getString(3) + "\t" + rs.getString(4));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void get_AllRunTime(String experiment_name) {
    String sql =
      "SELECT er.StartTime, qr.QueryNumber, qn.Cardinality, qn.RunTime " +
      "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er, " +
          "AZDBLAB_QUERY qr, AZDBLAB_QUERYEXECUTION qn, AZDBLAB_QRHASPLAN qp " +
      "WHERE ex.ExperimentName = '" + experiment_name + 
          "' AND ex.experimentid = er.experimentid AND " +
          "er.percentage = 100 AND er.currentstage='Completed' " +
          "AND er.runid = qr.runid AND qr.queryid = qn.queryid AND " +
          "qn.QueryExecutionID = qp.QueryExecutionID " +
      "ORDER BY er.StartTime, qr.QueryNumber, qn.Cardinality";
    try {
      FileWriter fout = new FileWriter(
          new File("/home/ruizhang/Desktop/query_runtime.txt"));
      BufferedWriter bout = new BufferedWriter(fout);
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("starttime \t querynum \t plannumber \t runtime");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + "\t" + rs.getInt(2) + " \t " +
                           rs.getLong(3) + "\t" + rs.getInt(4));
        bout.append(rs.getString(1) + "\t" + rs.getInt(2) + " \t " +
                    rs.getLong(3) + "\t" + rs.getInt(4) + "\n");
      }
      rs.close();
      bout.close();
      fout.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    } catch (IOException ioex) {
      ioex.printStackTrace();
    }
  }
 
  
  // Get the curve for suboptimality percentage along with different thresholds.
  public void get_SubOptimal_Graph(String username, String expname,
                                   String aspectname) {
    Main.defaultLogger.logging_normal("**** Percentage of SubOpt ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT er.StartTime AS STARTTIME, ex.experimentname AS EXPNAME, " +
            "da.AspectName AS RATIO, count(qr.QueryID) AS NUM " +
        "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er, " +
            "AZDBLAB_QUERY qr, AZDBLAB_SATISFIESASPECT sa, " +
            "AZDBLAB_DEFINEDASPECT da " +
        "WHERE " + expnameClause + "AND " +
            "ex.experimentid = er.experimentid AND er.runid = qr.runid AND " +
            "qr.queryid = sa.queryid AND sa.AspectID = da.AspectID AND " +
            "da.AspectName like '" + aspectname + "%' " +
        "GROUP BY (er.StartTime, ex.experimentname, da.AspectName) " +
        "ORDER BY er.StartTime, ex.experimentname";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("Ratio \t Num SubOpt");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + "\t" + rs.getString(2) + " \t " +
                           rs.getString(3) + "\t" + rs.getInt(4));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void get_CorName_Query(String username, String expname) {
    Main.defaultLogger.logging_normal("**** Num Cor-name in FROM & # Queries ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT ex.experimentname, ps.Value, count(ps.QueryID) AS NumQueries " +
        "FROM AZDBLAB_QUERYHASPARAMETER ps, AZDBLAB_QUERY qr, " +
            "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
        "WHERE " + expnameClause + " AND " +
            "ex.experimentid = er.experimentid AND er.runid = qr.runid AND " +
            "qr.queryid = ps.queryid AND ps.PARAMNAME = 'NUMCNFRM' " +
        "GROUP BY (ex.experimentname, ps.Value) " +
        "ORDER BY ex.experimentname, ps.Value";
    try {
      ResultSet  rs  = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("Run \t # Cor-Names \t # Queries");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + "\t" + rs.getInt(2) + " \t " +
                           rs.getInt(3));        
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void get_NUMFROM_SubOptimal(String username, String expname,
                                     String aspectname) {
    Main.defaultLogger.logging_normal("**** Num Cor-name in FROM & SubOpt ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT temp.NUMFROM AS NUMFROM, sa.AspectValue AS ASPVAL " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, qr.QueryID AS QID, " +
                   "ps.Value AS NUMFROM " +
                   "FROM AZDBLAB_QUERYHASPARAMETER ps, AZDBLAB_QUERY qr, " +
                       "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
                   "WHERE " + expnameClause + "AND " +
                   		"ex.experimentid = er.experimentid AND " +
                   		"er.runid = qr.runid AND qr.queryid = ps.QueryID AND " +
                   		"ps.PARAMNAME = 'NUMCNFRM' " +
                   "ORDER BY ex.ExperimentName, qr.QueryID, NUMFROM) temp " +
            "LEFT JOIN AZDBLAB_SATISFIESASPECT sa ON " +
            "temp.QID = sa.QueryID AND sa.AspectID " +
        "IN (SELECT da.AspectID " +
             "FROM AZDBLAB_DEFINEDASPECT da " +
             "WHERE da.AspectName = '" + aspectname + "') " +
        "ORDER BY ASPVAL, NUMFROM";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("NUM FRM \t SubOptimal/Optimal(1/0)");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getInt(1) + " \t " + rs.getInt(2));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  

  
  public void get_DBMS_CEPS_SubOptimal(String username, String expname,
                                       String aspectname) {
    Main.defaultLogger.logging_normal("**** CEPS & SubOpt ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT DISTINCT temp.DBMS, temp.CEPS, sum(sa.AspectValue) " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, er.DBMS AS DBMS, " +
                   "qr.QueryID AS QID, count(DISTINCT pl.PlanID) AS CEPS " +
               "FROM AZDBLAB_PLAN pl, AZDBLAB_QRHASPLAN hp, " +
                   "AZDBLAB_QUERYEXECUTION qn, AZDBLAB_QUERY qr, " +
                   "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
               "WHERE " + expnameClause + "AND " +
                   "ex.experimentid = er.experimentid AND " +
                   "er.runid = qr.runid AND qr.queryid = qn.queryid AND " +
                   "qn.QueryExecutionID = hp.QueryExecutionID AND hp.PlanID = pl.PlanID " +
               "GROUP BY (ex.ExperimentName, er.DBMS, qr.QueryID) " +
               "ORDER BY CEPS) temp, " +
            "AZDBLAB_SATISFIESASPECT sa, AZDBLAB_DEFINEDASPECT ap " +
        "WHERE temp.QID = sa.QueryID AND sa.AspectID = ap.AspectID AND " +
            "ap.AspectName = '" + aspectname + "' " +
        "GROUP BY (temp.DBMS, temp.CEPS) " +
        "ORDER BY temp.DBMS, temp.CEPS"; 
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("DBMS \t CEPS \t # SubOptimal");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + " \t " + rs.getInt(2) + " \t " +
                           rs.getInt(3));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void get_DBMS_CEPS_Query(String username, String expname) {
    Main.defaultLogger.logging_normal("**** CEPS & SubOpt ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT temp.DBMS, temp.CEPS, count(DISTINCT temp.QID) " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, er.DBMS AS DBMS," +
                   "qr.QueryID AS QID, count(DISTINCT pl.PlanID) AS CEPS " +
               "FROM AZDBLAB_PLAN pl, AZDBLAB_QRHASPLAN hp, " +
                   "AZDBLAB_QUERYEXECUTION qn, AZDBLAB_QUERY qr, " +
                   "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
               "WHERE " + expnameClause + "AND " +
                   "ex.experimentid = er.experimentid AND " +
                   "er.runid = qr.runid AND qr.queryid = qn.queryid AND " +
                   "qn.QueryExecutionID = hp.QueryExecutionID AND hp.PlanID = pl.PlanID " + 
               "GROUP BY (ex.ExperimentName, er.DBMS, qr.QueryID) " +
               "ORDER BY CEPS) temp " +
        "GROUP BY (temp.DBMS, temp.CEPS) " +
        "ORDER BY temp.DBMS, temp.CEPS";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("DBMS \t CEPS \t # Queries");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + " \t " + rs.getInt(2) + " \t " +
                           rs.getInt(3));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void get_DBMS_CEPS_TTest(String username, String expname,
                                  String aspectname) {
    Main.defaultLogger.logging_normal("**** CEPS T-Test ****");    
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT temp.CEPS AS CEPS, sa.AspectValue AS ASPVAL " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, qr.QueryID AS QID, " +
                   "count(DISTINCT pl.PlanID) AS CEPS " +
               "FROM AZDBLAB_PLAN pl, AZDBLAB_QRHASPLAN hp, " +
                   "AZDBLAB_QUERYEXECUTION qn, AZDBLAB_QUERY qr, " +
                   "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
               "WHERE " + expnameClause + " AND " +
                   "ex.experimentid = er.experimentid AND " +
                   "er.runid = qr.runid AND qr.queryid = qn.queryid AND " +
                   "qn.QueryExecutionID = hp.QueryExecutionID AND hp.PlanID = pl.PlanID " +
               "GROUP BY (ex.ExperimentName, qr.QueryID) " +
               "ORDER BY ex.ExperimentName, qr.QueryID, CEPS) temp LEFT JOIN " +
            "AZDBLAB_SATISFIESASPECT sa ON " +
                "temp.QID = sa.QueryID AND sa.AspectID " +
            "IN (SELECT da.AspectID " +
                 "FROM AZDBLAB_DEFINEDASPECT da " +
                 "WHERE da.AspectName = '" + aspectname + "') " +
        "ORDER BY ASPVAL, CEPS";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("Ceps \t F/NonF(1/0)");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getInt(1) + " \t " + rs.getInt(2));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void getRunTimeDifference(String username, String expname,
                                   String aspectname) {
    String expnameClause =
      " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
      expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String  sql  =
        "SELECT DISTINCT temp3.QRYNUM occ, temp3.PERCENT " +
        "FROM (SELECT temp2.EN, temp2.QN AS QRYNUM, " +
                   "((temp2.RT - temp2.MT) / temp2.MT * 100) AS PERCENT " +
               "FROM (SELECT temp.EXPNAME AS EN, temp.QNUM AS QN, " +
                          "temp.RT AS RT, temp.MT AS MT " +
                      "FROM (SELECT ex.ExperimentName AS EXPNAME, er.RunID, " +
                                 "qr.QueryNumber AS QNUM, cp.RunTime AS RT, " +
                                 "min(mcp.RunTime) AS MT " +
                             "FROM AZDBLAB_EXPERIMENT ex, " +
                                 "AZDBLAB_EXPERIMENTRUN er, " +
                                 "AZDBLAB_QUERY qr, AZDBLAB_QUERYEXECUTION cp, " +
                                 "AZDBLAB_QUERYEXECUTION mcp, " +
                                 "AZDBLAB_SATISFIESASPECT sa, " +
                                 "AZDBLAB_DEFINEDASPECT ap " +
                             "WHERE " + expnameClause + " AND " +
                                 "er.RunID = qr.RunID AND " +
                                 "qr.QueryID = cp.QueryID AND " +
                                 "cp.queryExecutionNumber = -1 AND " +
                                 "qr.QueryID = mcp.QueryID AND " +
                                 "qr.QueryID = sa.QueryID AND " +
                                 "sa.AspectID = ap.AspectID AND " +
                                 "ap.AspectName = '" + aspectname + "'" +
                             "GROUP BY (ex.ExperimentName, er.RunID, " +
                                 "qr.QueryNumber, cp.queryExecutionNumber, " +
                                 "cp.RunTime) " +
                             "ORDER BY qr.QueryNumber) temp " +
        "WHERE temp.RT > temp.MT) temp2) temp3 " +
        "ORDER BY temp3.PERCENT";
    try {
      ResultSet  rs  = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("Query Number \t Percentage");
      int count = 0;
      while (rs.next()) {
        Main.defaultLogger.logging_normal(++count + "\t" + rs.getInt(1) + "\t" +
                           rs.getDouble(2));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void getWidthSubOptimal(String username, String expname,
                                 String aspectname) {
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT sa.AspectValue, count(sa.QUERYID) " +
        "FROM AZDBLAB_EXPERIMENT ex, AZDBLAB_EXPERIMENTRUN er, " +
            "AZDBLAB_QUERY qr, AZDBLAB_SATISFIESASPECT sa, " +
            "AZDBLAB_DEFINEDASPECT ap " +
        "WHERE " + expnameClause + " AND " +
            "ex.ExperimentID = er.ExperimentID AND " +
            "er.RunID = qr.RunID AND qr.QueryID = sa.QueryID AND " +
            "sa.AspectID = ap.AspectID AND ap.AspectName IN " + aspectname +
        "GROUP BY (sa.AspectValue) " +
        "ORDER BY sa.AspectValue";
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("DBMS \t Width \t Number of Queries");
      double sum = 0.0;
      while (rs.next()) {
        sum += (double)rs.getInt(2);
        Main.defaultLogger.logging_normal(rs.getInt(1) + "\t" + rs.getInt(2) + "\t" + sum +
                           "\t" + sum / 266.0 * 100.0);
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void getCEPS_Width(String username, String expname,
                            String ceps_aspect, String width_aspect) {
    Main.defaultLogger.logging_normal("**** CEPS & Width ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT DISTINCT temp.DBMS, temp.CEPS, SUM(sa.AspectValue), " +
            "AVG(sa2.AspectValue) " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, er.DBMS AS DBMS, " +
                   "qr.QueryID AS QID, count(DISTINCT pl.PlanID) AS CEPS " +
               "FROM AZDBLAB_PLAN pl, AZDBLAB_QRHASPLAN hp, " +
                   "AZDBLAB_QUERYEXECUTION qn, AZDBLAB_QUERY qr, " +
                   "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
               "WHERE " + expnameClause + "AND " +
                   "ex.experimentid = er.experimentid AND " +
                   "er.runid = qr.runid AND qr.queryid = qn.queryid AND " +
                   "qn.QueryExecutionID = hp.QueryExecutionID AND hp.PlanID = pl.PlanID " +
               "GROUP BY (ex.ExperimentName, er.DBMS, qr.QueryID) " +
               "ORDER BY CEPS) temp, " +
            "AZDBLAB_SATISFIESASPECT sa, AZDBLAB_SATISFIESASPECT sa2, " +
            "AZDBLAB_DEFINEDASPECT ap, AZDBLAB_DEFINEDASPECT ap2 " +
        "WHERE temp.QID = sa.QueryID AND sa.AspectID = ap.AspectID AND " +
            "ap.AspectName = '" + ceps_aspect + "' AND " +
            "temp.QID = sa2.QueryID AND sa2.AspectID = ap2.AspectID AND " +
            "ap2.AspectName IN " + width_aspect +
        " GROUP BY (temp.DBMS, temp.CEPS) " +
        "ORDER BY temp.DBMS, temp.CEPS"; 
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("DBMS \t CEPS \t # Subopt \t Avg. Width");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getString(1) + " \t " + rs.getInt(2) + " \t " +
                           rs.getInt(3) + "\t" + rs.getDouble(4));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  
  public void getNUMFROM_Width(String username, String expname,
                               String corname_aspect, String width_aspect) {
    Main.defaultLogger.logging_normal("**** Num Cor-name in FROM & Width ****");
    String expnameClause =
        " ex.username = '" + username + "' AND ex.experimentname LIKE '" +
        expname + "%' AND er.starttime = 'MEDIAN RUN SUMMARY' ";
    String sql =
        "SELECT temp.NUMFROM AS NUMFROM, SUM(sa.AspectValue), " +
            "AVG(sa2.AspectValue) " +
        "FROM (SELECT ex.ExperimentName AS EXPNAME, qr.QueryID AS QID, " +
                   "ps.Value AS NUMFROM " +
               "FROM AZDBLAB_QUERYHASPARAMETER ps, AZDBLAB_QUERY qr, " +
                   "AZDBLAB_EXPERIMENTRUN er, AZDBLAB_EXPERIMENT ex " + 
               "WHERE " + expnameClause + "AND " +
               	   "ex.experimentid = er.experimentid AND " +
               	   "er.runid = qr.runid AND qr.queryid = ps.QueryID AND " +
               	   "ps.PARAMNAME = 'NUMCNFRM' " +
               "ORDER BY ex.ExperimentName, qr.QueryID, NUMFROM) temp, " +
            "AZDBLAB_SATISFIESASPECT sa, AZDBLAB_SATISFIESASPECT sa2, " +
            "AZDBLAB_DEFINEDASPECT ap, AZDBLAB_DEFINEDASPECT ap2 " +
        "WHERE temp.QID = sa.QueryID AND sa.AspectID = ap.AspectID AND " +
            "ap.AspectName = '" + corname_aspect + "' AND " +
            "temp.QID = sa2.QueryID AND sa2.AspectID = ap2.AspectID AND " +
            "ap2.AspectName IN " + width_aspect +
    " GROUP BY (temp.NUMFROM) " +
    "ORDER BY temp.NUMFROM"; 
    try {
      ResultSet rs = labNoteBook.executeQuerySQL(sql);
      Main.defaultLogger.logging_normal("# Corname \t # Subopt \t Avg. Width");
      while (rs.next()) {
        Main.defaultLogger.logging_normal(rs.getInt(1) + " \t " + rs.getInt(2) + "\t" +
                           rs.getDouble(3));
      }
      rs.close();
    } catch (SQLException sqlex) {
      sqlex.printStackTrace();
    }
  }
  */
}