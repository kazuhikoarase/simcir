package com.d_project.util {

	/**
	 * Base64EncodeOutputStream
	 * @author kazuhiko arase
	 */
	public class Base64EncodeOutputStream {

		private var _buffer : int = 0;
		private var _buflen : int = 0;
		private var _length : int = 0;
		private var _base64 : String = "";

		public function Base64EncodeOutputStream() {
		}

		public function writeByte(n : int) : void {

			_buffer = (_buffer << 8) | (n & 0xff);
			_buflen += 8;
			_length += 1;

			while (_buflen >= 6) {
				writeEncoded(_buffer >>> (_buflen - 6) );
				_buflen -= 6;
			}
		}

		public function flush() : void {

			if (_buflen > 0) {
				writeEncoded(_buffer << (6 - _buflen) );
				_buffer = 0;
				_buflen = 0;
			}

			if (_length % 3 != 0) {
				// padding
				var padlen  : int = 3 - _length % 3;
				for (var i : int = 0; i < padlen; i += 1) {
					_base64 += "=";
				}
			}
		}

		public function toString() : String {
			return _base64;
		}

		private function writeEncoded(b : int) : void {
			_base64 += String.fromCharCode(encode(b & 0x3f) );
		};

		private function encode(n : int) : int {
			if (n < 0) {
				// error.
			} else if (n < 26) {
				return 0x41 + n;
			} else if (n < 52) {
				return 0x61 + (n - 26);
			} else if (n < 62) {
				return 0x30 + (n - 52);
			} else if (n == 62) {
				return 0x2b;
			} else if (n == 63) {
				return 0x2f;
			}
			throw new Error("n:" + n);
		}
	}
}
