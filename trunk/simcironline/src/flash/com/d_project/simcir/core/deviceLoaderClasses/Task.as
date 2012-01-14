package com.d_project.simcir.core.deviceLoaderClasses {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Task
	 * @author kazuhiko arase
	 */
	public class Task extends EventDispatcher {

		public function start() : void {
			dispatchEvent(new Event(Event.COMPLETE) );
		}
	}
}