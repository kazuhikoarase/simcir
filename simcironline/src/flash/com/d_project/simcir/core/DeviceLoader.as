package com.d_project.simcir.core {

	import com.d_project.simcir.core.buildInDevice.BuiltInDeviceFactory;
	import com.d_project.simcir.core.deviceLoaderClasses.CachedLoaderTask;
	import com.d_project.simcir.core.deviceLoaderClasses.CachedURLLoaderTask;
	import com.d_project.simcir.core.deviceLoaderClasses.LoaderTask;
	import com.d_project.simcir.core.deviceLoaderClasses.TaskQueue;
	import com.d_project.simcir.core.deviceLoaderClasses.URLLoaderTask;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	use namespace simcir_core;
	
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * DeviceLoader
	 * @author kazuhiko arase
	 */
	public class DeviceLoader extends EventDispatcher {

		public static const NS : Namespace =
			new Namespace("", "http://www.d-project.com/simcir/2012");

		private var _loaderContext : LoaderContext;

		private var _xml : XML = null;

		private var _devices : Array = null;

		private var _numLoadings : int = 0;
		
		private var _asyncLoadedDevices : Array = null;

		public function DeviceLoader(loaderContext : LoaderContext = null) {
			if (loaderContext == null) {
				loaderContext = createDefaultContext();
			}
			_loaderContext = loaderContext;
			addEventListener(Event.COMPLETE, completeHandler);
		}
		
		public function get xml() : XML {
			return _xml;
		}

		public function get devices() : Array {
			return _devices;
		}

		public function loadUrl(url : String) : void {
			
			LockManager.getInstance().lock();
			
//			var task : URLLoaderTask = new URLLoaderTask(url);
			var task : URLLoaderTask = new CachedURLLoaderTask(url);
			task.addEventListener(Event.COMPLETE, function(event : Event) : void {
				loadXml(new XML(task.data) );
			} );

			var unlockHandler : Function = function(event : Event) : void {
				LockManager.getInstance().unlock();
			};
			task.addEventListener(Event.COMPLETE, unlockHandler);
			task.addEventListener(IOErrorEvent.IO_ERROR, unlockHandler);
			task.addEventListener(SecurityErrorEvent.SECURITY_ERROR, unlockHandler);

			TaskQueue.getInstance().postTask(task);
		}

		public function loadXml(xml : XML) : void {

			LockManager.getInstance().lock();

			default xml namespace = NS;

			_xml = xml;
			_asyncLoadedDevices = new Array();

			var deviceDefs : XMLList = _xml.device;

			if (deviceDefs.length() == 0) {
				_devices = new Array();
				dispatchEvent(new Event(Event.COMPLETE) );
				return;
			}

			_numLoadings = deviceDefs.length();

			for (var i : int = 0; i < deviceDefs.length(); i += 1) {
				loadDevice(deviceDefs[i], i);
			}
		}
		
		protected function completeHandler(event : Event) : void {
			LockManager.getInstance().unlock();
		}
		
		private function loadDevice(deviceDef : XML, index : int) : void {

			var url : String = deviceDef.@factory;

			if (url) {
//				var task : LoaderTask = new LoaderTask(url);
				var task : LoaderTask = new CachedLoaderTask(url, _loaderContext);
				task.addEventListener(Event.COMPLETE, function(event : Event) : void {
					var factory : DeviceFactory = DeviceFactory(task.content);
					createDevice(factory, deviceDef, index);
				} );
				TaskQueue.getInstance().postTask(task);

			} else {
				var factory : DeviceFactory = new BuiltInDeviceFactory();
				createDevice(factory, deviceDef, index);
			}
		}

		private function createDevice(factory : DeviceFactory, deviceDef : XML, index : int) : void {
			var device : Device = factory.createDevice(deviceDef);
			if (device.async) {
				device.addEventListener(Event.COMPLETE, function(event : Event) : void {
					addDevice(device, index);
				} );
				device.init(_loaderContext, deviceDef);
			} else {
				device.init(_loaderContext, deviceDef);
				addDevice(device, index);
			}
		}

		private function addDevice(device : Device, index : int) : void {
			_asyncLoadedDevices.push({device: device, index: index});
			_numLoadings -= 1;
			if (_numLoadings == 0) {
				postLoad();
			}
		}

		private function postLoad() : void {

			// sort index order
			_asyncLoadedDevices.sort(function(d1 : *, d2 : *) : * {
				return (d1.index < d2.index)? -1 : 1;
			} );

			// create device array
			_devices = new Array();
			for (var i : int = 0; i < _asyncLoadedDevices.length; i += 1) {
				_devices.push(_asyncLoadedDevices[i].device);
			}

			// clean temporary array
			_asyncLoadedDevices = null;

			// connect nodes.
			connectNodes();

			dispatchEvent(new Event(Event.COMPLETE) );
		}

		private function connectNodes() : void {

			var connectorDefs : XMLList = _xml.connector;
			var deviceMap : Object = createDeviceMap();

			for (var i : int = 0; i < connectorDefs.length(); i += 1) {
				var connectorDef : XML = connectorDefs[i];
				var inNode : Array = String(connectorDef["@in"]).split(/\./);
				var outNode : Array = String(connectorDef["@out"]).split(/\./);
				deviceMap[outNode[0]].outputs[outNode[1]].
					connectTo(deviceMap[inNode[0]].inputs[inNode[1]]);
			}
		}

		private function createDeviceMap() : Object {
			var map : Object = {};
			for (var i : int = 0; i < _devices.length; i += 1) {
				var device : Device = _devices[i];
				map[device.id] = device;
			}
			return map;
		}
		
		private function createDefaultContext() : LoaderContext {
			return new LoaderContext(
				true,
				ApplicationDomain.currentDomain,
				SecurityDomain.currentDomain);
		}
	}
}