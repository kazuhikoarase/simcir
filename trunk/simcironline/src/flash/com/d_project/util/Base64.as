package com.d_project.util {

	import flash.utils.ByteArray;

	/**
	 * Base64
	 * @author kazuhiko arase
	 */
	public class Base64 {

		public function Base64() {
			throw new Error();
		}

		public static function encode(data : ByteArray) : String {
			var bout : Base64EncodeOutputStream =
				new Base64EncodeOutputStream();
			for (var i : int = 0; i < data.length; i += 1) {
				bout.writeByte(data[i]);
			}
			bout.flush();
			return bout.toString();
		}

		public static function decode(str : String) : ByteArray {
			var data : ByteArray = new ByteArray();
			var bin : Base64DecodeInputStream =
				new Base64DecodeInputStream(str);
			var b : int;
			while ( (b = bin.read() ) != -1) {
				data.writeByte(b);
			}
			return data;
		}
	}
}
