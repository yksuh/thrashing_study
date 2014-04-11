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
 * Windows process information class
 * @author yksuh
 *
 */
public class WindowsProcessInfo extends ProcessInfo {
	/**
	 * pri
	 */
	private long _pri;
	/***
	 * thd
	 */
	private long _thd;
	/***
	 * hnd
	 */
	private long _hnd;
	/***
	 * priv
	 */
	private long _priv;
	/***
	 * cputime
	 */
	private long _cTime;
	/***
	 * stime
	 */
	private long _eTime;
	
	/***
	 * Constructor of ProcessInfo
	 * @param pid
	 * @param command
	 * @param min_flt
	 * @param maj_flt
	 * @param uTime
	 * @param sTime
	 */
	public WindowsProcessInfo(long pid, 
							  String command,
							  long pri,
							  long thd,
							  long hnd,
							  long priv,
							  long cTime,
							  long eTime) {
		_pid = pid;
		_command = command;
		_pri = pri;
		_thd = thd;
		_hnd = hnd;
		_priv = priv;
		_cTime = cTime;
		_eTime = eTime;
	}
	public long get_pri() {
		return _pri;
	}
	public long get_thd() {
		return _thd;
	}
	public long get_hnd() {
		return _hnd;
	}
	public long get_priv() {
		return _priv;
	}
	public long get_cTime() {
		return _cTime;
	}
	public long get_eTime() {
		return _eTime;
	}
	/***
	 * Get diff between this obj and a given obj
	 * @param gpi process info
	 * @return diff string
	 */
	public String getDiff(ProcessInfo gpi){
		WindowsProcessInfo pi = (WindowsProcessInfo)gpi;
		String res = "";
		String conjunct = " to ";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecDiff = new Vector<String>();
		if(!_command.equalsIgnoreCase("PsList") && !_command.contains("Idle")
				&& _pid == pi.get_pid() && _command.equalsIgnoreCase(pi.get_command())){
//			if(_pri != pi.get_pri()){
//				long diff = pi.get_pri() - _pri;
//				vecDiff.add("\tpri:"+normalformat.format(_pri)+conjunct+normalformat.format(pi.get_pri())+" = " + diff);
//			}
//			if(_thd != pi.get_thd()){
//				long diff = pi.get_thd() - _thd;
//				vecDiff.add("\tthd:"+normalformat.format(_thd)+conjunct+normalformat.format(pi.get_thd())+" = " + diff);
//			}
//			if(_hnd != pi.get_hnd()){
//				long diff = pi.get_hnd() - _hnd;
//				vecDiff.add("\thnd:"+normalformat.format(_hnd)+conjunct+normalformat.format(pi.get_hnd())+" = " + diff);
//			}
//			if(_priv != pi.get_priv()){
//				long diff = pi.get_priv() - _priv;
//				vecDiff.add("\tpriv:"+normalformat.format(_priv)+conjunct+normalformat.format(pi.get_priv())+" = " + diff);
//			}
			if(_cTime != pi.get_cTime()){
				long diff = pi.get_cTime() - _cTime;
				vecDiff.add("\tcTime  :"+normalformat.format(_cTime)+conjunct+normalformat.format(pi.get_cTime())+" = " + diff);
//				vecDiff.add("\tcTime:" + diff);
			}else{
				vecDiff.add("\tcTime  :"+normalformat.format(_cTime)+conjunct+normalformat.format(pi.get_cTime())+" = " + 0);
			}
//			if(_eTime != pi.get_eTime()){
//				long diff = pi.get_eTime() - _eTime;
////				vecDiff.add("\teTime  :"+normalformat.format(_eTime)+conjunct+normalformat.format(pi.get_eTime())+" = " + diff);
//				vecDiff.add("\teTime:" + diff);
//			}
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
	public String getStr() {
		String res = "";
		NumberFormat pidformat = new DecimalFormat("00000");
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecData = new Vector<String>();
		vecData.add("\tpri:"+normalformat.format(_pri));
		vecData.add("\tthd:"+normalformat.format(_thd));
		vecData.add("\thnd:"+normalformat.format(_hnd));
		vecData.add("\tpriv:"+normalformat.format(_priv));
		vecData.add("\tcTime:"+normalformat.format(_cTime));
		vecData.add("\teTime:"+normalformat.format(_eTime));
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