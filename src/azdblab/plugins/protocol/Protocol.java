/**
 * 
 */
package azdblab.plugins.protocol;

import java.sql.ResultSet;
import java.util.Hashtable;

import javax.swing.JPanel;

import azdblab.plugins.Plugin;

/**
 * @author akvochko
 *
 */
public abstract class Protocol extends Plugin {

	/* (non-Javadoc)
	 * @see azdblab.plugins.Plugin#getSupportedShelfs()
	 */
	@Override 
	public String getSupportedShelfs() {
		return "7.X";
	}
	
	public abstract JPanel getProtocolStats();

	public abstract ResultSet execute(String prefix, Hashtable<String[], Integer[]> runs);
	

}
