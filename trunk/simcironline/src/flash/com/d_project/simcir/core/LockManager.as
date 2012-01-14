package com.d_project.simcir.core {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * LockManager
	 * @author kazuhiko arase
	 */
	public class LockManager extends EventDispatcher {

		private static var _instance : LockManager = null;

		public static function getInstance() : LockManager {
			if (_instance == null) {
				_instance = new LockManager();
			}
			return _instance;
		}

		private var _lockCount : int = 0;

		public function LockManager() {
			if (_instance != null) {
				throw new Error();
			}
			_instance = this;
		}
		
		public function lock() : void {
			lockCount(1);
		}

		public function unlock() : void {
			lockCount(-1);
		}

		private function lockCount(inc : int) : void {
			
			var lastLocked : Boolean = locked;
			
			_lockCount += inc;
			
			if (_lockCount < 0) {
				throw new Error();
			}
			
			if (lastLocked != locked) {
				dispatchEvent(new Event(Event.CHANGE) );
			}
		}		

		public function get locked() : Boolean {
			return _lockCount > 0;
		}
	}
}