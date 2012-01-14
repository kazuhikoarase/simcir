package com.d_project.util;

import java.io.ByteArrayOutputStream;

import junit.framework.Assert;

import org.junit.Test;

public class Base64Test {

	private byte[] createData(int len) throws Exception {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		for (int i = 0; i < len; i += 1) {
			bout.write(i);
		}
		bout.close();
		return bout.toByteArray();
	}
	@Test
	public void test() throws Exception {

		for (int i = 0; i < 256; i += 1) {
			byte[] b = createData(i);
			byte[] b2 = Base64.decode(Base64.encode(b) );
			Assert.assertEquals(new String(b,"ISO-8859-1"), new String(b2,"ISO-8859-1") );
		}
	}
}