package com.d_project.simcir.core.buildInDevice {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.simcir.core.Node;
	import com.d_project.simcir.core.NodeEvent;
	import com.d_project.simcir.core.simcir_core;
	
	import flash.events.Event;
	import flash.system.LoaderContext;

	use namespace simcir_core;
	
	/**
	 * DeviceRef
	 * @author kazuhiko arase
	 */
	public class DeviceRef extends Device {

		private var _devices : Array = null;
		
		public function DeviceRef() {
			async = true;
		}
		
		public function get devices() : Array {
			return _devices;
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);

			var loader : DeviceLoader = new DeviceLoader(loaderContext);
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.loadUrl(params["url"]);

			var st : String = new Error().getStackTrace();
			if (st != null) {
//				trace(st);
				// show nest
				trace(label, "nest:", st.split(/[\r\n]+/g).length);
			}
		}

		private function loader_completeHandler(event : Event) : void {

			var loader : DeviceLoader = event.target as DeviceLoader;

			setupDevices(loader.devices);

			// async complete
			dispatchEvent(new Event(Event.COMPLETE) );
		}

		private function setupDevices(devices : Array) : void {

			_devices = devices;
			
			var i : int;
			
			var deviceMap : Object = {};
			var inputPorts : Array = new Array();
			var outputPorts : Array = new Array();
			
			
			for (i = 0; i < _devices.length; i += 1) {
				
				var device : Device = _devices[i] as Device;
				
				if (!device.id) {
					// device in toolbox
					continue;
				}
				
				deviceMap[device.id] = device;
				
				if (device is Port) {
					if (Port(device).type == Port.IN) {
						inputPorts.push(device);
					} else {
						outputPorts.push(device);
					}
				}
			}
			
			// sort ports by location
			var sortPorts : Function = function(ports : Array) : void {
				ports.sort(function(p1 : Port, p2 : Port) : int {
					var x1 : Number = p1.deviceDef.@x;
					var y1 : Number = p1.deviceDef.@y;
					var x2 : Number = p2.deviceDef.@x;
					var y2 : Number = p2.deviceDef.@y;
					if (x1 == x2) {
						return (y1 < y2)? -1 : 1;
					}
					return (x1 < x2)? -1 : 1;
				} );
			};
			sortPorts(inputPorts);
			sortPorts(outputPorts);
			
			for (i = 0; i < inputPorts.length; i += 1) {
				var inputPort : Port = deviceMap[inputPorts[i].id];
				connectInternal(addInput(inputPort.label),
					inputPort.inputs[0]);
			}
			
			for (i = 0; i < outputPorts.length; i += 1) {
				var outputPort : Port = deviceMap[outputPorts[i].id];
				connectInternal(outputPort.outputs[0],
					addOutput(outputPort.label) );
			}
		}

		override public function destroy() : void {
			super.destroy();
			
			// destroy all devices.
			if (_devices == null) return;
			for (var i : int = 0; i < _devices.length; i += 1) {
				_devices[i].destroy();
			}
			_devices = null;
		}
		
		override public function get visualDevice() : Boolean {
			return false;
		}
		
		private function connectInternal(src : Node, dst : Node) : void {
			src.addEventListener(NodeEvent.NODE_VALUE_CHANGE, function(event : NodeEvent) : void {
				dst.value = src.value;
			} );
		}

		override public function get widthInUnit() : Number {
			return super.widthInUnit + 2;
		}
	}
}
