package com.d_project.simcir.core.deviceLoaderClasses {

	import flash.events.Event;

	/**
	 * CachedURLLoaderTask
	 * @author kazuhiko arase
	 */
	public class CachedURLLoaderTask extends URLLoaderTask {

		private static var _cache : Object = new Object();

		public function CachedURLLoaderTask(url : String) {
			super(url);
		}

		override public function get data() : * {
			return _cache[url] || super.data;
		}

		override protected function setData(data : *) : void {
			super.setData(data);
			_cache[url] = data;
		}

		override public function start() : void {
			if (_cache[url]) {
				dispatchEvent(new Event(Event.COMPLETE) );
				return;
			}
			super.start();
		}
	}
}