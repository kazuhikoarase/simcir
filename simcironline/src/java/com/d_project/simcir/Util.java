package com.d_project.simcir;

import java.io.ByteArrayOutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.zip.DeflaterOutputStream;
import java.util.zip.InflaterOutputStream;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

/**
 * Util
 * @author kazuhiko arase
 */
public class Util {

	private Util() {
	}
	
	public static boolean isEmpty(String s) {
		return s == null || s.length() == 0;
	}

	public static String trim(String s) {
		if (s == null) {
			return "";
		}
		return s.replaceAll("^[\\s\\u3000]+|[\\s\\u3000]+$", "");
	}

	public static String truncate(String s, int length) {
		if (s == null) {
			return "";
		}
		if (s.length() > length) {
			return s.substring(0, length);
		}
		return s;
	}
	
	public static int parseInt(String s) {
		try {
			if (isEmpty(s) ) {
				return 0;
			}
			return Integer.parseInt(s);
		} catch(Exception e) {
			return 0;
		}
	}
	
	public static byte[] compress(byte[] b) throws Exception {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		DeflaterOutputStream out = new DeflaterOutputStream(bout);
		try {
			out.write(b);
		} finally {
			out.close();
		}
		return bout.toByteArray();
	}
	
	public static byte[] uncompress(byte[] b) throws Exception {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		InflaterOutputStream out = new InflaterOutputStream(bout);
		try {
			out.write(b);
		} finally {
			out.close();
		}
		return bout.toByteArray();
	}
	
	public static Document parseDocument(String xml) throws Exception {
		StringReader in = new StringReader(xml);
		try {
			Document doc = DocumentBuilderFactory.
				newInstance().newDocumentBuilder().
				parse(new InputSource(in) );
			trimTextNode(doc);
			doc.setXmlStandalone(true);
			return doc;
		} finally {
			in.close();
		}
	}
	
	private static void trimTextNode(Node node) {
		Node child = node.getFirstChild();
		while (child != null) {
			if (child.getNodeType() == Node.TEXT_NODE) {
				child.setNodeValue(trim(child.getNodeValue() ) );
			}
			if (child.hasChildNodes() ) {
				trimTextNode(child);
			}
			child = child.getNextSibling();
		}
	}
	
	public static String toXMLString(Document doc) throws Exception {
		StringWriter out = new StringWriter();
		try {
			TransformerFactory.newInstance().
				newTransformer().
				transform(new DOMSource(doc), new StreamResult(out) );
		} finally {
			out.close();
		}
		return out.toString();
	}
}