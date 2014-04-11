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

import java.util.Random;

/**
 * This class is used to generate random numbers to be filled into experiment tables. 
 * And it is repeatable in the sense that its random seed can be explicitly captured and set.
 * This is extremely important if user wants to repeat the exact same experiment as before, once one knows the random seed(s) for the previous experiment.
 * </p>
 * <p>
 * A example of result:
 * </p>
 * <p>7305	4456	2578	4129	592	(Mark1)	6722	2441	3682	8188	3568</p>	
 * <p>[Reset]	</p>
 * <p>7305	4456	2578	4129	592	6722	2441	(Mark2)	3682	8188	3568</p>	
 * <p>[Back]</p>	
 * <p>3682	8188	3568	3706	6526</p>
 * <p>	
 * In which the random number generator first generated 5 numbers, and then the user set a mark there and then continued to generate 5 values.
 * Then the user called the <code>reset()</code>, after which the generated new numbers are identical to the first 10.
 * The user set another mark at position 7, and after the all 10 values were completed, the user called <code>returnToMark()</code>, 
 * which brought back the random number generator to the lastest marked position, and the numbers generated thereafter are identical to those after the marked position. 
 * </p>
 *
 */
public class RepeatableRandom {

		/**
		 * The random number generator
		 */
		private	Random		rand;
		
		/**
		 * Seed to be set for the random number generator
		 */
		private long		iSeed;
		
		/**
		 * The position in a sequence of randomly generated numbers 
		 * at which the user may want to mark and check back at a later time
		 */
		private long		iMarkPos;
		
		/**
		 * The seed of the random number generator at the time 
		 * that mark is called 
		 */
		private long		iMarkSeed;
		
		/**
		 * The position of last generated random number in the sequence 
		 */
		private long		iCurrentPos;
		
		
		/**
		 * The size of the domain for these values.
		 */
		private long myDomainSize;
		/**
		 * The max value for this generator
		 */
		private long myMaxValue	= 10000;
		/**
		 * The min value for this generator
		 */
		private long myMinValue	= 0;
		
	
		/**
		 * Constructs a RepeatableRandom object, and implicitly set it's seed as the system current time in milliseconds.
		 */
		public RepeatableRandom(){
				rand		= new Random();
				iSeed		= System.currentTimeMillis();	// Using system time as seed
				rand.setSeed(iSeed);
				iMarkPos	= 0;
				iCurrentPos	= 0;
				
				myDomainSize = myMaxValue - myMinValue + 1;
		}
		
		/**
		 * Constructs a RepeatableRandom object with the random seed explicitly specified. 
		 * @param seed The random seed to be passed for generating random numbers.
		 */
		public RepeatableRandom(long seed){
				rand		= new Random();
				iSeed		= seed;							// Passing in seed as parameter
				rand.setSeed(iSeed);
				iMarkPos	= 0;
				iCurrentPos	= 0;
				
				myDomainSize = myMaxValue - myMinValue + 1;
		}
		
		
		/**
		 * 
		 * @param Range
		 */
		public void setMax(long MaxValue) {
			myMaxValue	= MaxValue;
			myDomainSize = myMaxValue - myMinValue + 1;
		}
		
		/**
		 * Resets the random number generator.
		 * after which it will generate the same sequence of numbers as before.
		 *
		 */
		public void reset(){
			iCurrentPos	= 0;
			rand.setSeed(iSeed);
		}
		
		/**
		 * Sets the seed of random number generator.
		 * @param seed The seed to be set for the random number generator.
		 */
		public void setSeed(long seed){
				iSeed	= seed;
		}
		
		/**
		 * Retrieves the current seed of random number generator.
		 * @return The current seed of random number generator.
		 */
		public long getSeed(){
				return iSeed;
		}
		
		/**
		 * Retrieves the seed at the time the last <code>mark()</code> method was invoked.
		 * @return The seed of the random number generator at the time the last <code>mark()</code> method was invoked.
		 */
		public long getMarkSeed(){
				return iMarkSeed;
		}
		
		/**
		 * Generates the next random integer number in the sequence.
		 * @return A random integer number.
		 */
		public long getNextRandomInt(){
				iCurrentPos++;
				return (long)(rand.nextFloat() * myDomainSize) + myMinValue;
		}
		
		public double getNextDouble(){
			//currentPos++;
			double	num	= rand.nextDouble();
			
			//Main._logger.outputLog(num);
			
			return num;
		}
		
		/**
		 * Records the position of last generated random number.
		 * @return The position of last generated random number.
		 */
		public long mark(){
				iMarkSeed	= iSeed;
				iMarkPos	= iCurrentPos;
				return iMarkPos;
		}
					
		/**
		 * Returns to the position which has been marked most recently.
		 * From that point on, the success random number sequence will be the same as the sequence before returning back. 
		 *
		 */
		public void returnToMark(){
				this.reset();
				for ( long i = 0; i < iMarkPos; i++ ){
						rand.nextFloat();						
				}
		}
		
}
