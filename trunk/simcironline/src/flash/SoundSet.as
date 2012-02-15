package {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceFactory;
	import com.d_project.simcir.devices.sound.Mixer;
	import com.d_project.simcir.devices.sound.Speaker;
	import com.d_project.simcir.devices.sound.Volume;
	import com.d_project.simcir.devices.sound.Wave;
	
	import flash.display.Sprite;

	public class SoundSet extends Sprite implements DeviceFactory {

		public function SoundSet() {
		}

		public function createDevice(deviceDef : XML) : Device {
			var type : String = deviceDef.@type;
			switch(type) {
			case "Volume" :
				return new Volume();
			case "Speaker" :
				return new Speaker();
			case "Wave" :
				return new Wave();
			case "Mixer" :
				return new Mixer();
			default :
				throw new Error(type);
			}
		}		
	}
}