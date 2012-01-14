package com.d_project.util {

	/**
	 * Base64DecodeInputStream
	 * @author kazuhiko arase
	 */
	public class Base64DecodeInputStream {

		private var _str : String;
		private var _pos : int = 0;
		private var _buffer : int = 0;
		private var _buflen : int = 0;

		public function Base64DecodeInputStream(str : String) {
			_str = str;
		}

		public function read() : int {

			while (_buflen < 8) {

				if (_pos >= _str.length) {
					if (_buflen == 0) {
						return -1;
					}
					throw new Error("unexpected end of file./" + _buflen);
				}

				var c : String = _str.charAt(_pos);
				_pos += 1;

				if (c == "=") {
					_buflen = 0;
					return -1;
				} else if (c.match(/^\s$/) ) {
					// ignore if whitespace.
					continue;
				}

				_buffer = (_buffer << 6) | decode(c.charCodeAt(0) );
				_buflen += 6;
			}

			var n : int = (_buffer >>> (_buflen - 8) ) & 0xff;
			_buflen -= 8;
			return n;
		}

		private function decode(c : int) : int {
			if (0x41 <= c && c <= 0x5a) {
				return c - 0x41;
			} else if (0x61 <= c && c <= 0x7a) {
				return c - 0x61 + 26;
			} else if (0x30 <= c && c <= 0x39) {
				return c - 0x30 + 52;
			} else if (c == 0x2b) {
				return 62;
			} else if (c == 0x2f) {
				return 63;
			} else {
				throw new Error("c:" + c);
			}
		}
	}
}