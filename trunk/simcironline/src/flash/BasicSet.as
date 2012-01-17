package {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	import com.d_project.simcir.device.DirectCurrent;
	import com.d_project.simcir.device.LED;
	import com.d_project.simcir.device.LED4bit;
	import com.d_project.simcir.device.LED7seg;
	import com.d_project.simcir.device.LogicGate;
	import com.d_project.simcir.device.Oscillator;
	import com.d_project.simcir.device.Switch;
	import com.d_project.simcir.device.Volume4bit;
	
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
			case "BUF" :
			case "NOT" :
			case "AND" :
			case "NAND" :
			case "OR" :
			case "NOR" :
			case "EOR" :
			case "ENOR" :
				return new LogicGate();
			case "OSC" :
				return new Oscillator();
			case "7seg" :
				return new LED7seg();
			case "4bit7seg" :
				return new LED4bit();
			case "4bitVol" :
				return new Volume4bit();
			default :
				throw new Error(type);
			}
		}
	}
}

