package com.d_project.simcir.core.deviceLoaderClasses {

	import com.d_project.simcir.core.DeviceLoaderContext;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * CachedLoaderTask
	 * @author kazuhiko arase
	 */
	public class CachedLoaderTask extends LoaderTask {

		private static var _cache : Object = new Object();

		public function CachedLoaderTask(url : String, loaderContext : DeviceLoaderContext) {
			super(url, loaderContext);
		}

		override public function get content() : DisplayObject {
			return _cache[url] || super.content;
		}

		override protected function setContent(content : DisplayObject) : void {
			super.setContent(content);
			_cache[url] = content;
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