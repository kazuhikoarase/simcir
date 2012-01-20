package com.d_project.simcir.device {

	import com.d_project.simcir.core.Device;
	
	import flash.system.LoaderContext;

	/**
	 * DirectCurrent
	 * @author kazuhiko arase
	 */
	public class DirectCurrent extends Device {

		public function DirectCurrent() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addOutput();
			outputs[0].value = 1;
		}

		override public function get color() : uint {
			return 0xffcccc;
		}
		
		override public function get visualDevice() : Boolean {
			return false;
		}
	}
}
