package com.d_project.simcir.devices {

	import com.d_project.simcir.core.Device;
	
	import flash.events.TimerEvent;
	import flash.system.LoaderContext;
	import flash.utils.Timer;

	/**
	 * Oscillator
	 * @author kazuhiko arase
	 */
	public class Oscillator extends Device {
		
		private var _timer : Timer = null;
		
		public function Oscillator() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addOutput();
			outputs[0].value = 1;

			_timer = new Timer(1000 / 24); // 24fps
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}
		
		override public function destroy() : void {
			super.destroy();

			if (_timer == null) return;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer = null;
		}
		
		private function timerHandler(event : TimerEvent) : void {
			if (active) {
				outputs[0].value = outputs[0].value? null : 1;
			}
		}

		override public function get color() : uint {
			return 0xffcccc;
		}
		
		override public function get visualDevice() : Boolean {
			return false;
		}
	}
}
