package com.d_project.scripting;

/**
 * ScriptUtil
 * @author Kazuhiko Arase
 */
public class ScriptUtil {

	private static final String BEGIN_LINE_COMMENT = "//";
	private static final String BEGIN_BLOCK_COMMENT = "/*";
	private static final String END_BLOCK_COMMENT = "*/";
	private static final char LF = '\n';

	private ScriptUtil() {
	}

	private interface I1 {
		String doLine(String line);
	}

	public static String trimComment(final String s)
	throws Exception {

		final StringBuilder buf = new StringBuilder();

		final boolean[] blockComment = {false};

		I1 i1 = new I1() {
			public String doLine(final String line) {

				if (blockComment[0]) {
					int index = line.indexOf(END_BLOCK_COMMENT);
					if (index == -1) {
						return null;
					}
					blockComment[0] = false;
					return line.substring(index + END_BLOCK_COMMENT.length() );
				}

				final int bcIndex = line.indexOf(BEGIN_BLOCK_COMMENT);
				final int lcIndex = line.indexOf(BEGIN_LINE_COMMENT);

				if (bcIndex != -1 && (lcIndex == -1 || bcIndex < lcIndex) ) {
					buf.append(line.substring(0, bcIndex) );
					blockComment[0] = true;
					return line.substring(bcIndex + BEGIN_BLOCK_COMMENT.length() );
				}

				if (lcIndex != -1) {
					buf.append(line.substring(0, lcIndex) );
					if (line.charAt(line.length() - 1) == LF) {
						buf.append(LF);
					}
					return null;
				}

				buf.append(line);
				return null;
			}
		};

		int start = 0;
		int index;
		String line;

		while ( (index = s.indexOf(LF, start) ) != -1) {
			line = s.substring(start, index + 1);
			while ( (line = i1.doLine(line) ) != null) {}
			start = index + 1;
		}
		line = s.substring(start);
		while ( (line = i1.doLine(line) ) != null) {}

		return buf.toString();
	};

	public static String trimSpace(final String s) {
		final StringBuilder buf = new StringBuilder();
		char lastChar = 0;
		boolean spc = false;
		for (int i = 0; i < s.length(); i += 1) {
			final char c = s.charAt(i);
			if (isWhitespace(c) ) {
				spc = true;
				continue;
			}
			if (spc && isWordChar(c) && isWordChar(lastChar) ) {
				buf.append('\u0020');
			}
			buf.append(c);
			lastChar = c;
			spc = false;
		}
		return buf.toString();
	}

	private static boolean isWordChar(final char c) {
		return 'A' <= c && c <= 'Z' ||
			'a' <= c && c <= 'z' ||
			'0' <= c && c <= '9' ||
			c == '_' || c == '$';
	}

	private static boolean isWhitespace(final char c) {
		return "\u0020\t\r\n".indexOf(c) != -1;
	}
}