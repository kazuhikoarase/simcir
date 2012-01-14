package com.d_project.simcir;

import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringReader;

import org.junit.Test;

public class UtilTest {

	@Test
	public void test() throws Exception {
		String xml = load("src/flash/BasicSet.xml");
		
		System.out.println(xml);
		
		xml = Util.toXMLString(Util.parseDocument(xml) );

		System.out.println(xml);
	}
	
	private String load(String path) throws Exception {
		StringBuilder b = new StringBuilder();
		Reader in = new InputStreamReader(new FileInputStream(path), "UTF-8");
		try {
			int c;
			while ( (c = in.read() ) != -1) {
				b.append( (char)c);
			}
		} finally {
			in.close();
		}
		return b.toString();
	}
}