package com.d_project.simcir.devices.sound {

	/**
	 * Const
	 * @author kazuhiko arase
	 */
	public class Const implements SoundSource {
		
		private var _v : Number;
		
		public function Const(v : Number = 1) {
			_v = v;
		}
		
		public function set_v(v : Number) : void {
			_v = v;
		}
		
		public function get_v(position : Number) : Number {
			return _v;
		}
	}
}