package {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	import com.d_project.simcir.devices.BusIn;
	import com.d_project.simcir.devices.BusOut;
	
	import flash.display.Sprite;
	
	public class BusSet extends Sprite implements DeviceFactory {
		
		public function BusSet() {
		}
		
		public function createDevice(deviceDef : XML) : Device {
			var type : String = deviceDef.@type;
			switch(type) {
				case "BusIn" :
					return new BusIn();
				case "BusOut" :
					return new BusOut();
				default :
					throw new Error(type);
			}
		}		
	}
}
