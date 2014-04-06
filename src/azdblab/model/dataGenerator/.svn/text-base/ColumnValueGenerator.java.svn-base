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
package azdblab.model.dataGenerator;

import azdblab.Constants;
import azdblab.exception.analysis.ColumnAttributeException;
import azdblab.labShelf.GeneralDBMS;

/**
 * For each column used by the data generator, an object of this type can be used to 
 * generator values for a column. Each column has its own column value generator.  The generator
 * knows the size, range, data type, and data generator type.  It uses these contraints to generator
 * values for the column.
 * 
 * @author Kevan Holdaway
 *
 */
public class ColumnValueGenerator {

	/**
	 * Creates a generator that will generator values as defined by the parameters.
	 * @param data_type The data type of the values that should be generated.
	 * @param dataLength The length of the values that should be generated.
	 * @param data_gen_type The data generation type, this could be random or sequential.
	 * @param min_val The minimum value that the generator should produce.
	 * @param max_val The maximum value that the generator should produce.
	 * @throws ColumnAttributeException Thrown if there is an unsupported attribute for this column.  This could 
	 * occur because the data type is not supported by AZDBLab.
	 */
	public ColumnValueGenerator(int data_type, int dataLength, int data_gen_type, long min_val, long max_val)
		throws ColumnAttributeException {
		myDataGenType = data_gen_type;
		myDataType = data_type;
		myMinValue = min_val;
		myMaxValue = max_val;
		myDomainSize = max_val - min_val + 1;
		myLastIntValue = -1;
		myLastStringValue = "";
		myDataLength = dataLength;

		//Error check this for sanity
		if (myMinValue > myMaxValue)
			throw new ColumnAttributeException("Column Minimum Distribution Value is Greater than Maximum Distribution Value");
		if (("" + myMaxValue).length() > dataLength)
			throw new ColumnAttributeException("Column Maximum Distribution Value is Larger than the specified percision allows for this column");
	}

	/**
	 * Returns a random integer for this data type
	 * @return A random integer using the contraints.
	 */
	private long getRandomInt() {
		return (long) ((long) (Math.random() * myDomainSize) + myMinValue);
	}

	/**
	 * Returns a random string for this column.
	 * @return A random string using the constraints.
	 */
	private String getRandomString() {
		int length = (int) (Math.random() * myDataLength + 1);
		char[] string = new char[length];
		//for each character in the string choose a random alpha character and decide if it is 
		//upper or lower case.
		for (int i = 0; i < length; i++) {
			char charCase = ((System.currentTimeMillis() % 2 == 0) ? 'A' : 'a');
			string[i] = (char) ((Math.random() * 26) + charCase);
		}
		return String.copyValueOf(string);
	}

	/**
	 * This returns a random value.  The value will be of the type specified by the column data type.
	 * @return The random value that was generated for this column.
	 */
	public String getRandomValue() {
		switch (myDataType) {
			case GeneralDBMS.I_DATA_TYPE_NUMBER :
				{
					return "" + ((myDataGenType == Constants.I_GEN_TYPE_RANDOM) ? getRandomInt() : getSequentialInt());
				}
			case GeneralDBMS.I_DATA_TYPE_VARCHAR :
				{
					return ((myDataGenType == Constants.I_GEN_TYPE_RANDOM) ? getRandomString() : getSequentialString());
				}
			default :
				{
					return null;
				}
		}
	}

	/**
	 * A sequential integer
	 * @return Returns the next integer in ascending order.
	 */
	private long getSequentialInt() {
		return myMinValue + (++myLastIntValue);
	}

	/** A sequential string.
	 * @return Returns the next string in ascending order.  See code to understand what the sequence is for the
	 * strings.
	 */
	private String getSequentialString() {
		char[] last = myLastStringValue.toCharArray();
		boolean change = false;
		for (int i = 0; i < last.length; i++) {
			if (last[last.length - 1 - i] != 'z') {
				if (last[last.length - 1 - i] != 'Z')
					last[last.length - 1 - i]++;
				else
					last[last.length - 1 - i] = 'a';
				change = true;
				break;
			}
		}
		if (!change && (myLastStringValue.length() + 1) <= myDataLength) {
			//resetting all present characters (works like a counter)
			for (int i = 0; i < last.length; i++)
				last[i] = 'A';
			//must add another character
			myLastStringValue = String.copyValueOf(last);
			myLastStringValue += 'A';
		} else {
			myLastStringValue = String.copyValueOf(last);
		}
		return myLastStringValue;
	}
	/**
	 * The data generation type for this column
	 */
	private int myDataGenType;
	/**
	 * The length or size of values that should be produced.
	 */
	private int myDataLength;

	/**
	 * The data type of the column values.
	 */
	private int myDataType;
	/**
	 * The size of the domain for these values.
	 */
	private long myDomainSize;

	/**
	 * The last integer produced by the sequential generator.
	 */
	private long myLastIntValue;
	/**
	 * The last string produced by the sequential generator.
	 */
	private String myLastStringValue;
	/**
	 * The max value for this generator
	 */
	private long myMaxValue;
	/**
	 * The min value for this generator
	 */
	private long myMinValue;
}
