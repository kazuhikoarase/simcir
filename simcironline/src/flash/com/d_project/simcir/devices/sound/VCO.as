package com.d_project.simcir.devices.sound {

	import com.d_project.simcir.core.Device;
	
	import flash.system.LoaderContext;
	
/*

VCO:
	in:
		type(SINE/SQUARE/TRIANGLE/NOISE)
		freq
		gain(1/100 - 1)
	out:
		out

VCA
	in:
		gain(1/100 - 1)
		in
	out:
		out
	
VCF
	in:
		type(LPF/BPF/HPF)
		freq
		cutoff
		resonance
		in
	out:
		out

ENV
	out:
		out
	
	*/
	/**
	 * VCO
	 * @author kazuhiko arase
	 */
	public class VCO extends Device implements SoundSource {
		
		private static const T : Number = 2 * Math.PI / 44100;
		
		private var _t : Number = 0;

		private var _last_v : Number = 0;
		private var _last_p : Object = null;
		
		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput("f");
			addOutput().value = this;
		}
		
		public function get_v(position : Number) : Number {
			if (_last_p == position) {
				return _last_v;
			}
			// TODO consider multi out
			var sf : SoundSource = inputs[0].value as SoundSource;
			var vf : Number = sf? sf.get_v(position) : 0;
			var v : Number = Math.sin(_t);// * _a.get_v(position);
			_t += T * 20 * Math.pow(10, vf * 3);
			_last_p = position;
			_last_v = v;
			return v;
		}
	}
}