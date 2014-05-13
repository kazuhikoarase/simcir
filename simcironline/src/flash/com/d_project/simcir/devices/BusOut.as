package com.d_project.simcir.devices {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.system.LoaderContext;

	/**
	 * BusOut
	 * @author kazuhiko arase
	 */
	public class BusOut extends Device {

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			var numLines : int = params["numLines"];
			for (var i : int = 0; i < numLines; i += 1) {
				addInput();
			}
			addOutput();
		}

		override protected function inputValueChangeHandler(event : NodeEvent) : void {
			var values : Array = new Array();
			for (var i : int = 0; i < inputs.length; i += 1) {
				values.push(inputs[i].value);
			}
			outputs[0].value = values;
		}

		override public function get halfPitch() : Boolean {
			return true;
		}
		
		override public function get visualDevice() : Boolean {
			return false;
		}
	}
}
