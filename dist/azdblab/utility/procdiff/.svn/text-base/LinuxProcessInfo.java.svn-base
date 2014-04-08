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
package azdblab.utility.procdiff;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Vector;

/***
 * Process information class
 * @author yksuh
 *
 */
public class LinuxProcessInfo extends ProcessInfo {
	/**
	 * min_flt
	 */
	private long _min_flt;
	/***
	 * maj_flt
	 */
	private long _maj_flt;
	/***
	 * utime
	 */
	private long _uTick;
	/***
	 * stime
	 */
	private long _sTick;
	/***
	 * startTime
	 */
	private long _startTime;
	/***
	 * Constructor of ProcessInfo
	 * @param pid
	 * @param command
	 * @param min_flt
	 * @param maj_flt
	 * @param uTick
	 * @param sTick
	 */
	public LinuxProcessInfo(long pid, 
					String command,
					long min_flt,
					long maj_flt,
					long uTick,
					long sTick, 
					long startTime) {
		_pid = pid;
		_command = command;
		_min_flt = min_flt;
		_maj_flt = maj_flt;
		_uTick = uTick;
		_sTick = sTick;
		_startTime = startTime;
	}
	/***
	 * Get min_flt
	 * @return _min_flt
	 */
	public long get_min_flt() {
		return _min_flt;
	}

	/***
	 * Get maj_flt
	 * @return _maj_flt
	 */
	public long get_maj_flt() {
		return _maj_flt;
	}

	/***
	 * Get utime
	 * @return _uTick
	 */
	public long get_uTick() {
		return _uTick;
	}

	/***
	 * Get stime
	 * @return _sTick
	 */
	public long get_sTick() {
		return _sTick;
	}
	/***
	 * Get start time
	 * @return _startTime
	 */
	public long get_startTime() {
		return _startTime;
	}
//	/***
//	 * Return a string having all
//	 */
//	public String toString(){
//		return _pid+";"+_command+";"+_min_flt+";"+_maj_flt+";"+_uTick+";"+_sTick+";";
//	}
	/***
	 * Get diff between this obj and a given obj
	 * @param pi
	 * @return diff string
	 */
	public String getDiff(ProcessInfo gpi){
		LinuxProcessInfo pi = (LinuxProcessInfo)gpi;
		String res = "";
		String conjunct = " to ";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecDiff = new Vector<String>();
		if( _pid == pi.get_pid() && _command.equalsIgnoreCase(pi.get_command())){
			if(_min_flt != pi.get_min_flt()){
				long diff = pi.get_min_flt() - _min_flt;
				vecDiff.add("\tmin_flt:"+normalformat.format(_min_flt)+conjunct+normalformat.format(pi.get_min_flt())+" = " + diff);
			}
			if(_maj_flt != pi.get_maj_flt()){
				long diff = pi.get_maj_flt() - _maj_flt;
				vecDiff.add("\tmaj_flt:"+normalformat.format(_maj_flt)+conjunct+normalformat.format(pi.get_maj_flt())+" = " + diff);
			}
			if(_uTick != pi.get_uTick()){
				long diff = pi.get_uTick() - _uTick;
				vecDiff.add("\tuTick  :"+normalformat.format(_uTick)+conjunct+normalformat.format(pi.get_uTick())+" = " + diff);
			}
			if(_sTick != pi.get_sTick()){
				long diff = pi.get_sTick() - _sTick;
				vecDiff.add("\tsTick  :"+normalformat.format(_sTick)+conjunct+normalformat.format(pi.get_sTick())+" = " + diff);
			}
			for(int i=0;i<vecDiff.size();i++){
				if(i==0){
					res += pidformat.format(_pid)+"(";
					res += _command+",\n";
				}
				res += (String)vecDiff.get(i);
				if(i < vecDiff.size()-1){
					res += ",\n";
				}
				if(i == vecDiff.size()-1){
					res += ")";
				}
			}
		}
		return res;
	}
	/***
	 * Get process info string
	 */
	public String getStr() {
		// TODO Auto-generated method stub
		String res = "";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecData = new Vector<String>();
		vecData.add("\tmin_flt    :"+normalformat.format(_min_flt));
		vecData.add("\tmaj_flt    :"+normalformat.format(_maj_flt));
		vecData.add("\tuTick      :"+normalformat.format(_uTick));
		vecData.add("\tsTick      :"+normalformat.format(_sTick));
		vecData.add("\tstartTime  :"+normalformat.format(_startTime));
		for(int i=0;i<vecData.size();i++){
			if(i==0){
				res += pidformat.format(_pid)+"(";
				res += _command+",\n";
			}
			res += (String)vecData.get(i);
			if(i < vecData.size()-1){
				res += ",\n";
			}
			if(i == vecData.size()-1){
				res += ")";
			}
		}
		return res;
	}
}