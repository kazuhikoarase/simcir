package com.d_project.simcir.core {

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * Runner
	 * @author kazuhiko arase
	 * @private
	 */
	public class Runner {

		private static var _instance : Runner = null;

		public static function getInstance() : Runner {
			if (_instance == null) {
				_instance = new Runner();
			}
			return _instance;
		}

		private var _delay : Number;
		private var _timer : Timer;
		private var _runnables : Array = new Array();

		public function Runner() {
			if (_instance != null) {
				throw new Error();
			}
			_instance = this;

			_delay = 1000 / 24; // 24fps
			_timer = new Timer(_delay);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
		}

		public function register(runnable : Runnable) : void {
			_runnables.push(runnable);
		}

		private function timerHandler(event : TimerEvent) : void {

			// half of delay time
			var limit : Number = _delay / 2;

			var start : int = getTimer();

			for (var i : int = 0; i < _runnables.length; i += 1) {

				var target : Runnable = _runnables[i];

				while (true) {
					if (getTimer() - start > limit) {
						// time up
						return;
					}
					if (!target.available) {
						// not available
						break;
					}
					target.run();
				}
			}
		}
	}
}