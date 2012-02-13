package com.d_project.simcir.core.deviceLoaderClasses {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;

	/**
	 * LoaderTask
	 * @author kazuhiko arase
	 */
	public class LoaderTask extends Task {

		private var _url : String;
		private var _loaderContext : LoaderContext;

		private var _loader : Loader = null;
		private var _content : DisplayObject = null;

		public function LoaderTask(url : String, loaderContext : LoaderContext) {
			_url = url;
			_loaderContext = loaderContext;
		}

		public function get url() : String {
			return _url;
		}

		public function get content() : DisplayObject {
			return _content;
		}

		protected function setContent(content : DisplayObject) : void {
			_content = content;
		}

		override public function start() : void {

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			_loader.load(new URLRequest(url), _loaderContext);
		}

		private function loader_completeHandler(event : Event) : void {
			var loaderInfo : LoaderInfo = event.target as LoaderInfo;
			setContent(loaderInfo.content);
			trace("loaded", getQualifiedClassName(loaderInfo.content) );
			dispatchEvent(event);
		}

		private function loader_errorHandler(event : Event) : void {
			dispatchEvent(event);
		}
	}
}