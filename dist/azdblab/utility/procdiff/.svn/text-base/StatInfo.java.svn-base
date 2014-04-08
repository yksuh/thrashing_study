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

/****
 * Stores the CPU and max PID information in /proc/stat 
 * @author yksuh
 *
 */
public class StatInfo {
	/***
	 * Max PID
	 */
	private long _max_pid;	
	/****
	 * User mode tick
	 */
	private long _user_mode_tick;
	/****
	 * User mode with low priority tick
	 */
	private long _low_priority_user_mode_tick;
	/****
	 * System mode tick
	 */
	private long _system_mode_tick;
	/****
	 * Idle task tick
	 */
	private long _idle_task_tick;
	/****
	 * IO wait tick
	 */
	private long _io_wait_tick;
	/****
	 * Interrupt service tick
	 */
	public long _irq;
	/****
	 * Soft interrupt service tick
	 */
	private long _soft_irq;
	/****
	 * Ticks for other operating systems when running in a virtualized environment
	 */
	private long _steal_stolen_tick;
	/****
	 * Ticks for running a virtual CPU for guest OSes under the control of the Linux kernel
	 */
	private long _guest_tick;
	/***
	 * Constructor of ProcessInfo
	 * @param pid
	 * @param command
	 * @param min_flt
	 * @param maj_flt
	 * @param uTime
	 * @param sTime
	 */
	public StatInfo(long maxPID,
					long userModeTick, 
					long lowPriorityUserModeTick, 
					long systemModeTick,
					long idleTaskTick,
					long ioWaitTick,
					long irq, 
					long softirq,
					long stealStolenTick,
					long guestTick) {	// guest tick: N/A
		_max_pid = maxPID;
		_user_mode_tick = userModeTick;
		_low_priority_user_mode_tick = lowPriorityUserModeTick;
		_system_mode_tick = systemModeTick;
		_idle_task_tick = idleTaskTick;
		_io_wait_tick = ioWaitTick;
		_irq = irq;
		_soft_irq = softirq;
		_steal_stolen_tick = stealStolenTick;
		_guest_tick = guestTick;
		
//String printOut = _user_mode_tick + " ";
//printOut += _low_priority_user_mode_tick + " ";
//printOut += _system_mode_tick + " ";
//printOut += _idle_task_tick + " ";
//printOut += _io_wait_tick + " ";
//printOut += _io_wait_tick + " ";
//printOut += _irq + " ";
//printOut += _irq + " ";
//printOut += _soft_irq + " ";
//printOut += _steal_stolen_tick + " ";
//printOut += _guest_tick + " ";
//printOut += "("+_max_pid + ")";
//System.out.println(printOut);			
	}
	/***
	 * Set the max pid
	 * @param maxPID current max pid
	 */
	public void set_max_pid(long maxPID) {
		_max_pid = maxPID;
	}
	/***
	 * Get the max PID
	 * @return _max_pid
	 */
	public long get_max_pid() {
		return _max_pid;
	}
	/***
	 * Get the user mode tick
	 * @return _user_mode_tick
	 */
	public long get_user_mode_tick() {
		return _user_mode_tick;
	}
	/***
	 * Get the lower priority user mode tick
	 * @return _low_priority_user_mode_tick
	 */
	public long get_low_priority_user_mode_tick() {
		return _low_priority_user_mode_tick;
	}
	/***
	 * Get the system mode tick
	 * @return _system_mode_tick
	 */
	public long get_system_mode_tick() {
		return _system_mode_tick;
	}
	/***
	 * Get the idle task tick
	 * @return _idle_task_tick
	 */
	public long get_idle_task_tick() {
		return _idle_task_tick;
	}
	/***
	 * Get the io wait tick
	 * @return _io_wait_tick
	 */
	public long get_io_wait_tick() {
		return _io_wait_tick;
	}
	/***
	 * Get the irq tick
	 * @return _irq
	 */
	public long get_irq() {
		return _irq;
	}
	/***
	 * Get the soft irq tick
	 * @return _soft_irq
	 */
	public long get_soft_irq() {
		return _soft_irq;
	}
	/***
	 * Get the steal and stolen tick
	 * @return _steal_stolen_tick
	 */
	public long get_steal_stolen_tick() {
		return _steal_stolen_tick;
	}
	/***
	 * Get the guest tick
	 * @return _guest_tick
	 */
	public long get_guest_tick() {
		return _guest_tick;
	}
	/***
	 * Get diff between this obj and a given obj
	 * @param pi
	 * @return diff string
	 */
	public String getDiff(StatInfo si){
		String res = "";
//		String conjunct = " to ";
		NumberFormat normalformat = new DecimalFormat("0000000000");
		Vector<String> vecDiff = new Vector<String>();
//		long totalTicks = 0;
		if(_user_mode_tick != si.get_user_mode_tick()){
			long diff = si.get_user_mode_tick() - _user_mode_tick;
//			totalTicks += diff;
//			vecDiff.add("\tuserModeTicks:"+normalformat.format(_user_mode_tick)+conjunct+normalformat.format(si.get_user_mode_tick())+" = " + diff);
			vecDiff.add("userModeTicks           :"+normalformat.format(diff));
		}
		if(_low_priority_user_mode_tick != si.get_low_priority_user_mode_tick()){
			long diff = si.get_low_priority_user_mode_tick() - _low_priority_user_mode_tick;
//			totalTicks += diff;
//			vecDiff.add("\tlowPriorityUserModeTicks:"+normalformat.format(_low_priority_user_mode_tick)+conjunct+normalformat.format(si.get_low_priority_user_mode_tick())+" = " + diff);
			vecDiff.add(" lowPriorityUserModeTicks:"+normalformat.format(diff));
		}
		if(_system_mode_tick != si.get_system_mode_tick()){
			long diff = si.get_system_mode_tick() - _system_mode_tick;
//			totalTicks += diff;
//			vecDiff.add("\tsystemModeTicks:"+normalformat.format(_system_mode_tick)+conjunct+normalformat.format(si.get_system_mode_tick())+" = " + diff);
			vecDiff.add(" systemModeTicks         :"+normalformat.format(diff));
		}
		if(_idle_task_tick != si.get_idle_task_tick()){
			long diff = si.get_idle_task_tick() - _idle_task_tick;
//			totalTicks += diff;
//			vecDiff.add("\tidleTaskTicks:"+normalformat.format(_idle_task_tick)+conjunct+normalformat.format(si.get_idle_task_tick())+" = " + diff);
			vecDiff.add(" idleTaskTicks           :"+ normalformat.format(diff));
		}
		if(_io_wait_tick != si.get_io_wait_tick()){
			long diff = si.get_io_wait_tick() - _io_wait_tick;
//			totalTicks += diff;
//			vecDiff.add("\tioWaitTicks:"+normalformat.format(_io_wait_tick)+conjunct+normalformat.format(si.get_io_wait_tick())+" = " + diff);
			vecDiff.add(" ioWaitTicks             :"+ normalformat.format(diff));
		}
		if(_irq != si.get_irq()){
			long diff = si.get_irq() - _irq;
//			totalTicks += diff;
//			vecDiff.add("\tirq:"+normalformat.format(_irq)+conjunct+normalformat.format(si.get_irq())+" = " + diff);
			vecDiff.add(" irq				  :"+ normalformat.format(diff));
		}
		if(_soft_irq != si.get_soft_irq()){
			long diff = si.get_soft_irq() - _soft_irq;
//			totalTicks += diff;
//			vecDiff.add("\tsoftirq:"+normalformat.format(_soft_irq)+conjunct+normalformat.format(si.get_soft_irq())+" = " + diff);
			vecDiff.add(" softirq            :"+ normalformat.format(diff));
		}
		if(_steal_stolen_tick != si.get_steal_stolen_tick()){
			long diff = si.get_steal_stolen_tick() - _steal_stolen_tick;
//			totalTicks += diff;
//			vecDiff.add("\tstealStolenTicks:"+normalformat.format(_steal_stolen_tick)+conjunct+normalformat.format(si.get_steal_stolen_tick())+" = " + diff);
			vecDiff.add(" stealStolenTicks        :"+ normalformat.format(diff));
		}
		if(_guest_tick != si.get_guest_tick()){
			long diff = si.get_guest_tick() - _guest_tick;
//			totalTicks += diff;
//			vecDiff.add("\tguestTicks:"+normalformat.format(_guest_tick)+conjunct+normalformat.format(si.get_guest_tick())+" = " + diff);
			vecDiff.add(" guestTicks              :"+ normalformat.format(diff));
		}
//		res += "totalTicks              :"+normalformat.format(totalTicks) + ",\n";
		for(int i=0;i<vecDiff.size();i++){
//			if(i==0){
//				res += "(";
//			}
			res += (String)vecDiff.get(i);
			if(i < vecDiff.size()-1){
				res += ",\n";
			}
//			if(i == vecDiff.size()-1){
//				res += ")";
//			}
		}
		return res;
	}
}
