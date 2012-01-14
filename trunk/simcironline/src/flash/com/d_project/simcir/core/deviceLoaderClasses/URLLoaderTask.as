package com.d_project.simcir.core.deviceLoaderClasses {

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * URLLoaderTask
	 * @author kazuhiko arase
	 */
	public class URLLoaderTask extends Task {

		private var _url : String;

		private var _loader : URLLoader = null;
		private var _data : * = null;

		public function URLLoaderTask(url : String) {
			_url = url;
		}

		public function get url() : String {
			return _url;
		}

		public function get data() : * {
			return _data;
		}

		protected function setData(data : *) : void {
			_data = data;
		}

		override public function start() : void {
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			_loader.load(new URLRequest(url) );
		}

		private function loader_completeHandler(event : Event) : void {
			var loader : URLLoader = event.target as URLLoader;
			setData(loader.data);
			dispatchEvent(event);
		}

		private function loader_errorHandler(event : Event) : void {
			dispatchEvent(event);
		}
	}
}