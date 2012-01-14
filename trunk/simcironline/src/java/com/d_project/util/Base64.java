package com.d_project.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

/**
 * Base64
 * @author Kazuhiko Arase
 */
public class Base64 {

    private Base64() {
    }

    public static byte[] encode(byte[] data) throws IOException {

        ByteArrayOutputStream bout = new ByteArrayOutputStream();

        try {

        	Base64EncodeOutputStream out = new Base64EncodeOutputStream(bout);

            try {
                out.write(data);
            } finally {
                out.close();
            }

        } finally {
        	bout.close();
        }

        return bout.toByteArray();
    }

    public static byte[] decode(byte[] data) throws IOException {

        ByteArrayOutputStream bout = new ByteArrayOutputStream();

        try {

            Base64DecodeInputStream in = new Base64DecodeInputStream(new ByteArrayInputStream(data) );

            try {

            	int b;
                while ( (b = in.read() ) != -1) {
                    bout.write(b);
                }

            } finally {
                in.close();
            }

        } finally {
            bout.close();
        }

        return bout.toByteArray();
    }
}

