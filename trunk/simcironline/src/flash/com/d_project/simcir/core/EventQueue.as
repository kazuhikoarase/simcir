package com.d_project.simcir.core {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * EventQueue
	 * @author kazuhiko arase
	 */
	public class EventQueue implements Runnable {

		private static var _instance : EventQueue = null;

		public static function getInstance() : EventQueue {
			if (_instance == null) {
				_instance = new EventQueue();
			}
			return _instance;
		}

		private var _events : Array = null;

		public function EventQueue() {
			if (_instance != null) {
				throw new Error();
			}
			_instance = this;

			Runner.getInstance().register(this);
		}

		public function postEvent(target : EventDispatcher, event : Event) : void {
			if (_events == null) {
				_events = new Array();
			}
			_events.push({target: target, event: event});
		}

		public function get available() : Boolean {
			return _events != null;
		}

		public function run() : void {

			// get events ref.
			var events : Array = _events;
			_events = null;

			// dispatch current events.
			for (var i : int = 0; i < events.length; i += 1) {
				var e : * = events[i];
				e.target.dispatchEvent(e.event);
			}
		}
	}
}