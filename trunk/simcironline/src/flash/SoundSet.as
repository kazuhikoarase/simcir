package {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	import com.d_project.simcir.devices.sound.Knob;
	import com.d_project.simcir.devices.sound.Mixer;
	import com.d_project.simcir.devices.sound.Speaker;
	import com.d_project.simcir.devices.sound.VCO;
	
	import flash.display.Sprite;

	public class SoundSet extends Sprite implements DeviceFactory {

		public function SoundSet() {
		}

		public function createDevice(deviceDef : XML) : Device {
			var type : String = deviceDef.@type;
			switch(type) {
			case "Knob" :
				return new Knob();
			case "Speaker" :
				return new Speaker();
			case "VCO" :
				return new VCO();
			case "Mixer" :
				return new Mixer();
			default :
				throw new Error(type);
			}
		}		
	}
}