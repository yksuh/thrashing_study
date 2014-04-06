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
package azdblab.swingUI;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Toolkit;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Vector;

import javax.swing.JTextPane;
import javax.swing.text.Style;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyledDocument;


/**
 * This extension of JTextPane provides the functionality to
 * color lines of text.  There are no other significant changes.
 * @see JTextPane
 * @author Kevan Holdaway
 *
 */
public class JColorTextPane extends JTextPane {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Creates the JColorTextPane with content of file as the 
	 * content.
	 * @param file The file that will be displayed as the content.
	 */
	public JColorTextPane(File file) {
		super();
		myFile = file;
		myDocument = null;
	}

	/**
	 * Colors all lines starting with startLine until endLine the color color.
	 * @param startLine The first line that will be colored.
	 * @param endLine The last line that will be colored.
	 * @param color The color that of these lines.
	 */
	public void colorSection(int startLine, int endLine, Color color) {
		if (myDocument == null)
			init();
		if (startLine < 1 || endLine > myLinePositions.length + 1)
			throw new RuntimeException("Colored Section extended beyond the document");
		Style style = getStyle(color.toString());
		
		//If the style is not part of the document, add it
		if (style == null) {
			style = addStyle(color.toString(), null);
			StyleConstants.setForeground(style, color);
		}
		
		//Set the characteristics for the lines to be colored.
		myDocument.setCharacterAttributes(
			myLinePositions[startLine],
			((myLinePositions[endLine + 1] - 1) - myLinePositions[startLine]),
			style,
			true);
	}

	/**
	 * @see javax.swing.Scrollable#getScrollableTracksViewportWidth()
	 */
	public boolean getScrollableTracksViewportWidth() {
		return myHorizontalWrap;
	}

	/**
	 * Called by the constructor to read the content of the file in from its location.
	 */
	public void init() {
		if (myDocument == null) {
			File temp = null;
			try {
				//Creating a temp file to store the XML
				temp = File.createTempFile("other", ".xml");
				temp.deleteOnExit();

				//A reader to read the file
				FileReader 			fileInput 		= new FileReader(myFile);
				BufferedReader 		in 				= new BufferedReader(fileInput);

				int 				lineCount 		= 0;
				String 				current;
				Vector<Object>		rawLines 		= new Vector<Object>();

				//Reading the lines of the file into a vector
				while ((current = in.readLine()) != null) {
					rawLines.add(lineCount++, current);
				}

				//Creating a PrintWriter to write output to file
				FileOutputStream	outStream 		= new FileOutputStream(temp);
				PrintWriter 		out 			= new PrintWriter(outStream);

				int 				paddingLen 		= 6;
				int 				paddingRoller 	= 1;
				String 				padding 		= "";
				int 				linePos			= 0;
				int 				maxWidth 		= 0;

				//This will store the lines in a formated fashion.
				myLinePositions 					= new int[rawLines.size() + 2]; //1 extra for coloring
				int 				i;
				Font 				font 			= new Font("Monospaced", Font.PLAIN, 12);
				FontMetrics 		f 				= getFontMetrics(font);

				//adding format/spacing
				for (i = 1; i < rawLines.size() + 1; i++) {
					if (i % paddingRoller == 0) {
						paddingRoller *= 10;
						paddingLen--;
						padding = "";
						for (int j = 0; j < paddingLen; j++)
							padding += " ";
					}
					String output = i + padding + (String) rawLines.get(i - 1) + "\n";
					myLinePositions[i] = linePos;
					linePos += output.length();
					out.print(output);
					if (f.stringWidth(output) > maxWidth)
						maxWidth = f.stringWidth(output);
				}
				myLinePositions[i] = linePos;

				out.close();

				read(new FileInputStream(temp), temp);

				setFont(font);
				myDocument = getStyledDocument();

				setEditable(false);//need this for HTML to "behave :)
				Dimension size = getPreferredScrollableViewportSize();
				Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
				if (screenSize.width > maxWidth)
					maxWidth = screenSize.width;
				setPreferredSize(new Dimension(maxWidth, size.height));
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {//do nothing
		}
	}

	/**
	 * Turn on wrapping
	 * @param wrap Is wrapping enabled.
	 */
	public void setScrollableTracksViewportWidth(boolean wrap) {
		myHorizontalWrap = wrap;
	}
	/**
	 * The styled document for this JTextPane
	 */
	private StyledDocument myDocument;
	/**
	 * The file that is the content of this text pane.
	 */
	private File myFile;
	/**
	 * Whether horizontal wrap is on.
	 */
	private boolean myHorizontalWrap = false;

	/**
	 * The character positions where each line begins.
	 */
	private int myLinePositions[];
}
