package com.d_project.util;

import java.io.EOFException;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Base64DecodeInputStream
 * @author Kazuhiko Arase
 */
public class Base64DecodeInputStream extends FilterInputStream {

    private int buffer = 0;
    private int buflen = 0;

    public Base64DecodeInputStream(InputStream in) {
        super(in);
    }

    public int read() throws EOFException, IOException {

    	while (buflen < 8) {

            int c = super.read();

            if (c == -1) {

                if (buflen == 0) {
                    return -1;
                }

                throw new EOFException("unexpected end of file./" + buflen);

            } else if (c == '=') {

            	buflen = 0;
            	return -1;

            } else if (Character.isWhitespace( (char)c) ) {
                // ignore if whitespace.
                continue;
            }

            buffer = (buffer << 6) | decode(c);
            buflen += 6;
        }

        int n = buffer >>> (buflen - 8);
        buflen -= 8;
        return n;
    }

    private static int decode(int c) {
        if ('A' <= c && c <= 'Z') {
            return c - 'A';
        } else if ('a' <= c && c <= 'z') {
            return c - 'a' + 26;
        } else if ('0' <= c && c <= '9') {
            return c - '0' + 52;
        } else if (c == '+') {
            return 62;
        } else if (c == '/') {
            return 63;
        } else {
            throw new IllegalArgumentException("c:" + c);
        }
    }
}

