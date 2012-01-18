package {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	
	import flash.display.Sprite;

	public class MyToolbox extends Sprite implements DeviceFactory {

		public function createDevice(deviceDef : XML) : Device {
			
			var type : String = deviceDef.@type;

			if (type == "Switch") {
				return new SimpleSwitch();			
			} else {
				throw new Error("unknown type:" + type);
			}
		}
	}
}