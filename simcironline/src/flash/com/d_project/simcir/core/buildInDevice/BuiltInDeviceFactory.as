package com.d_project.simcir.core.buildInDevice {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;

	/**
	 * BuiltInDeviceFactory
	 * @author kazuhiko arase
	 */
	public class BuiltInDeviceFactory implements DeviceFactory {

		public function BuiltInDeviceFactory() {
		}

		public function createDevice(deviceDef : XML) : Device {
			var type : String = deviceDef.@type;
			switch(type) {
			case "In" :
				return new Port(Port.IN);
			case "Out" :
				return new Port(Port.OUT);
			case "Ref" :
				return new DeviceRef();
			default :
				throw new Error("type:" + type);
			}
		}
	}
}

