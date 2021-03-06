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
package plugins.unit_testing;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.FileAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;

import azdblab.Constants;


/*****
 * Logger (extension) class for AZDBLab logging
 * @author ys186001
 */
public class AZDBLabLogger extends Logger{
	/***
     * Logging utility for recording execution logs
     */
    protected static Logger _logger;
    /***
     * Logger name
     */
    protected static String _name;
    /***
     * Constructor for AZDBLab logger
     * @param name
     */
    public AZDBLabLogger(String loggerName) {
    	super(loggerName);
//    	configuration for keeping logging information
    	_logger = Logger.getLogger(loggerName);
//    	_logger.setLevel(Level.INFO);
//    	_logger.setLevel(Level.ERROR);
//    	_logger.setLevel(Level.DEBUG);
    	_logger.setLevel(Level.ALL);
    }
    
    /***
     * Get AZDBLab logger's name
     * @return _name
     */
    public String getAZDBLabLoggerName(){
    	return _name;
    }
    /***
     * Set logger name using log file name
     * @param fileName log file name
     * 
     */
    public void setAZDBLabLoggerName(String fileName) {
    	_name = fileName;
    }
    /***
     * Return the current logger
     * @return AZDBLab logger
     */
    public static Logger getAZDBLabLogger(String loggerName){
    	return _logger;
    }

    /****
     * Build a file appender using log file and appender name
     * @param appName appender namer
     */
    public void setAZDBLabAppender(String logFileName) throws IOException{
    	String pattern = "%d %-5p - %m %n";
    	PatternLayout layout = new PatternLayout(pattern);
    	FileAppender fileappender = new FileAppender(layout, logFileName);
    	_logger.addAppender(fileappender);
    }
    
    /***
     * Prints out log message without writing into log file
     * @param logMsg log message to print to standard output
     */
    public void printToStdout(String logMsg){
    	System.out.println(logMsg);
    }
    /***
     * Write out into log 
     * @param logMsg log message to write 
     */
    public void writeIntoLog(String logMsg){
    	_logger.info(logMsg);
    }
    /***
     * Prints out debugging messages to the corresponding log file
     * @param debugMsg debugging message to print
     */
    public void outputDebug(String debugMsg){
    	System.out.println(debugMsg);
    	_logger.debug(debugMsg);
    }
    /***
     * Prints out log messages to the corresponding log file
     * @param logMsg log message to print
     */
    public void outputLog(String logMsg){
    	System.out.println(logMsg);
//    	_logger.info(logMsg);
    }
    /***
     * Prints out log messages to the corresponding log file
     * @param logMsg log message to print
     */
    public void outputLogWithoutNewLine(String logMsg){
    	System.out.print(logMsg);
    	_logger.info(logMsg);
    }
    /***
     * Prints out consoleMsg to the terminal and logMsg to the log file
     * @param consoleMsg console message to print
     * @param logMsg log message to print
     */
    public void outputLogWithoutNewLine(String consoleMsg, String logMsg){
    	System.out.print(consoleMsg);
    	_logger.info(logMsg);
    }
    /***
     * Prints out error messages to log file
     * @param errorMsg	error message
     */
    public void reportError(String errorMsg){
    	_logger.error(errorMsg);
    	System.err.println("[ERROR]"+errorMsg);
    }
    public void reportError2(String errorMsg){
    	_logger.error(errorMsg);
    }
	public void outputDebugWithoutNewLine(String logMsg) {
		System.out.print(logMsg);
    	_logger.debug(logMsg);
	}
}
