package com.d_project.simcir.devices.sound {

	import com.d_project.simcir.core.Device;
	
	import flash.system.LoaderContext;
	
	/**
	 * Wave
	 * @author kazuhiko arase
	 */
	public class Wave extends Device implements SoundSource {
		
		private static const T : Number = 2 * Math.PI / 44100;
		
		private var _t : Number = 0;
		
		private var _f : SoundSource = new Const(440);
		private var _a : SoundSource = new Const(0.5);
		
		private var _last_v : Number = 0;
		private var _last_p : Object = null;
		
		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addOutput().value = this;
		}
		
		public function get_v(position : Number) : Number {
			if (_last_p == position) {
				return _last_v;
			}
			// TODO consider multi out
			var v : Number = Math.sin(_t) * _a.get_v(position);
			_t += T * _f.get_v(position);
			_last_p = position;
			_last_v = v;
			return v;
		}
	}
}