package azdblab.utility.procdiff;

import java.util.Random;

public class TestWork {
	
	
	public static void insertionSort(int numElem, int[] array) {
		// pure java mode
		int i, j, temp;
		for (i = 1; i < numElem; i++) {
			temp = array[i];
			j = i - 1;
			while ((j >= 0) && (temp < array[j])) {
				array[j + 1] = array[j];
				j = j - 1;
			}
			array[j + 1] = temp;
		}

	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		int numElem = 100000;
		int[] array = new int[numElem];
		
		for (int i = 0; i < Integer.parseInt(args[0]); i++) {
			Random r = new Random();
			for (int j = 0; j < numElem; j++) {
				array[j] = r.nextInt();
			}
			insertionSort(numElem, array);
		}

	}

}
