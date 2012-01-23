package {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	import com.d_project.simcir.devices.DirectCurrent;
	import com.d_project.simcir.devices.LED;
	import com.d_project.simcir.devices.LED4bit;
	import com.d_project.simcir.devices.LEDSeg;
	import com.d_project.simcir.devices.LogicGate;
	import com.d_project.simcir.devices.Oscillator;
	import com.d_project.simcir.devices.RotaryEncoder;
	import com.d_project.simcir.devices.Switch;
	
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
				return new LEDSeg(LEDSeg.$7SEG);
			case "16seg" :
				return new LEDSeg(LEDSeg.$16SEG);
			case "4bit7seg" :
				return new LED4bit();
			case "RotaryEncoder" :
				return new RotaryEncoder();
			default :
				throw new Error(type);
			}
		}
	}
}

