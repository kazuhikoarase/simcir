package {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	import com.d_project.simcir.device.DirectCurrent;
	import com.d_project.simcir.device.LED;
	import com.d_project.simcir.device.LogicGate;
	import com.d_project.simcir.device.Oscillator;
	import com.d_project.simcir.device.Switch;
	
	import flash.display.Sprite;

	/**
	 * BasicSet
	 * @author kazuhiko arase
	 */
	public class BasicSet extends Sprite implements DeviceFactory {

		public function BasicSet() {
		}

		public function createDevice(deviceDef : XML) : Device {
			var type : String = deviceDef.@type;
			switch(type) {
			case "DC" :
				return new DirectCurrent();
			case "PushOn" :
				return new Switch(Switch.PUSH_ON);
			case "PushOff" :
				return new Switch(Switch.PUSH_OFF);
			case "Toggle" :
				return new Switch(Switch.TOGGLE);
			case "LED" :
				return new LED();
			case "OSC" :
				return new Oscillator();
			default :
				// gates
				return new LogicGate();
			}
		}
	}
}

