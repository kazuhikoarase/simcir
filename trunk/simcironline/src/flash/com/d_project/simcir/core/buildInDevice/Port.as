package com.d_project.simcir.core.buildInDevice {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceLoaderContext;
	import com.d_project.simcir.core.NodeEvent;

	import flash.display.DisplayObject;

	/**
	 * Port
	 * @author kazuhiko arase
	 */
	public class Port extends Device {

		public static const IN : String = "in";
		public static const OUT : String = "out";

		private var _type : String;

		public function Port(type : String) {
			_type = type;
		}

		public function get type() : String {
			return _type;
		}

		override public function init(loaderContext : DeviceLoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();
			addOutput();
		}

		override protected function inputValueChangeHandler(event : NodeEvent) : void {
			outputs[0].value = inputs[0].value;
		}

		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.core.Device;
import com.d_project.simcir.core.buildInDevice.Port;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;

class Control extends UIBase {

	private var _device : Device;

	public function Control(device : Device) : void {
		_device = device;
		mouseEnabled = false;
	}

	override protected function update(g : Graphics) : void {
		super.update(g);

		var port : Port = _device as Port;
		var cx : Number = parent.width / 2;
		var cy : Number = parent.height / 2;
		var size : Number = UIConstants.UNIT;

		g.lineStyle(2, UIConstants.BORDER_COLOR);
		g.beginFill(port.type == Port.IN?
			UIConstants.INPUT_NODE_COLOR :
			UIConstants.OUTPUT_NODE_COLOR);
		g.drawCircle(cx, cy, size / 2);
		g.endFill();

		// hole
		g.lineStyle(2, 0x000000);
		g.beginFill(0x000000);
		g.drawCircle(cx, cy, size / 4);
		g.endFill();
	}
}
