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
import org.xml.sax.*;
import org.xml.sax.helpers.*;
import javax.swing.*;
import javax.swing.tree.*;

import java.util.*;


public class TreeViewer extends DefaultHandler {

  private Stack<MutableTreeNode> nodes;
  
  // Initialize the per-document data structures
  public void startDocument() throws SAXException {
    
    // The stack needs to be reinitialized for each document
    // because an exception might have interrupted parsing of a
    // previous document, leaving an unempty stack.
    nodes = new Stack<MutableTreeNode>();
    
  }
 
  // Make sure we always have the root element
  private TreeNode root;
 
  // Initialize the per-element data structures
  public void startElement(String namespaceURI, String localName,
   String qualifiedName, Attributes atts) {
  
    String data;
    if (namespaceURI.equals("")) data = localName;
    else {
      data = '{' + namespaceURI + "} " + qualifiedName;
    }
    MutableTreeNode node = new DefaultMutableTreeNode(data);
    try {
      MutableTreeNode parent = (MutableTreeNode) nodes.peek();
      parent.insert(node, parent.getChildCount()); 
    }
    catch (EmptyStackException e) {
      root = node; 
    }
    nodes.push(node);
   
  }
  
  public void endElement(String namespaceURI, String localName,
   String qualifiedName) {
    nodes.pop();
  }

  // Flush and commit the per-document data structures
  public void endDocument() {
    
    JTree tree = new JTree(root);
    JScrollPane treeView = new JScrollPane(tree);
    JFrame f  = new JFrame("XML Tree");
    
    f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    f.getContentPane().add(treeView);
    f.pack();
    f.setVisible(true);
    
    
  }
    

  public static void main(String[] args) {
      
    try {
      XMLReader parser = XMLReaderFactory.createXMLReader(
        "org.apache.xerces.parsers.SAXParser"
      );
      ContentHandler handler = new TreeViewer();
      parser.setContentHandler(handler);
  
        parser.parse("./plugins/plugins/unit_testing/result.xml");

    }
    catch (Exception e) {
      System.err.println(e);
    }
  
  }   // end main()
   
} // end TreeViewer