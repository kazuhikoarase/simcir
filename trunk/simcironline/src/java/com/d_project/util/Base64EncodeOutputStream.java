package com.d_project.util;

import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * Base64EncodeOutputStream
 * @author Kazuhiko Arase
 */
public class Base64EncodeOutputStream extends FilterOutputStream {

    private int buffer;
    private int buflen;
    private int length;

    public Base64EncodeOutputStream(OutputStream out) {
        super(out);
        this.buffer = 0;
        this.buflen = 0;
        this.length = 0;
    }

    public void write(int n) throws IOException {

        buffer = (buffer << 8) | (n & 0xff);
        buflen += 8;
        length += 1;

        while (buflen >= 6) {
            writeEncoded(buffer >>> (buflen - 6) );
            buflen -= 6;
        }
    }

    public void flush() throws IOException {

        if (buflen > 0) {
            writeEncoded(buffer << (6 - buflen) );
            buffer = 0;
            buflen = 0;
        }

        if (length % 3 != 0) {
            // padding
            int padlen = 3 - length % 3;
            for (int i = 0; i < padlen; i += 1) {
                super.write('=');
            }
        }

        super.flush();
    }

    private void writeEncoded(int b) throws IOException {
        super.write(encode(b & 0x3f) );
    }

    private static int encode(int n) {
        if (n < 0) {
        	// error.
        } else if (n < 26) {
            return 'A' + n;
        } else if (n < 52) {
            return 'a' + (n - 26);
        } else if (n < 62) {
            return '0' + (n - 52);
        } else if (n == 62) {
            return '+';
        } else if (n == 63) {
            return '/';
        }
        throw new IllegalArgumentException("n:" + n);
    }
}

