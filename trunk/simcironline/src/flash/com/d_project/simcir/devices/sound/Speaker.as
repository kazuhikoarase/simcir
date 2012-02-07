package com.d_project.simcir.devices.sound {

	import com.d_project.simcir.core.Device;
	
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.LoaderContext;

	/**
	 * Speaker
	 * @author kazuhiko arase
	 */
	public class Speaker extends Device {

		private var _sound : Sound = null;
		private var _channel : SoundChannel = null;
		
		public function Speaker() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();

			_sound = new Sound();
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sound_sampleDataHandler);
			_channel = _sound.play();
		}
		
		override public function destroy() : void {
			_channel.stop();
			_channel = null;
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sound_sampleDataHandler);
			_sound = null;
		}	
		
		private function sound_sampleDataHandler(event : SampleDataEvent) : void {
			var src : SoundSource = inputs[0].value as SoundSource;
			if (src == null) {
				noSignal(event);
				return;
			}
			for (var i : int = 0; i < 4096; i += 1) {
				var v : Number = src.get_v(event.position + i);
				event.data.writeFloat(v);
				event.data.writeFloat(v);
			}			
		}

		private function noSignal(event : SampleDataEvent) : void {
			for (var i : int = 0; i < 4096; i += 1) {
				event.data.writeFloat(0);
				event.data.writeFloat(0);
			}			
		}
	}
}
