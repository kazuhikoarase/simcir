package com.d_project.simcir.devices {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;

	import flash.system.LoaderContext;

	/**
	 * BusIn
	 * @author kazuhiko arase
	 */
	public class BusIn extends Device {

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();
			var numLines : int = params["numLines"];
			for (var i : int = 0; i < numLines; i += 1) {
				addOutput();
			}
		}

		override protected function inputValueChangeHandler(event : NodeEvent) : void {
			var value : Object = inputs[0].value;
			for (var i : int = 0; i < outputs.length; i += 1) {
				outputs[i].value = (value is Array)? value[i] : value;
			}
		}

		override public function get halfPitch() : Boolean {
			return true;
		}
	}
}
