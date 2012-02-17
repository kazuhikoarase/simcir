package com.d_project.simcir.devices.sound {

	import com.d_project.simcir.core.Device;
	
	import flash.system.LoaderContext;

	/**
	 * Mixer
	 * @author kazuhiko arase
	 */
	public class Mixer extends Device implements SoundSource {

		public function Mixer() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();
			addInput();
			addOutput().value = this;
		}

		public function get_v(position : Number) : Number {
			var s0 : SoundSource = inputs[0].value as SoundSource;
			var s1 : SoundSource = inputs[1].value as SoundSource;
			var v0 : Number = s0? s0.get_v(position) : 0;
			var v1 : Number = s1? s1.get_v(position) : 0;
			return v0 + v1;
		}
	}
}
