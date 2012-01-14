package com.d_project.simcir.device {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceLoaderContext;
	
	import flash.display.DisplayObject;

	/**
	 * DirectCurrent
	 * @author kazuhiko arase
	 */
	public class DirectCurrent extends Device {

		public function DirectCurrent() {
		}

		override public function init(loaderContext : DeviceLoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addOutput();
			outputs[0].value = 1;
		}

		override public function get color() : uint {
			return 0xffcccc;
		}

		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.core.Device;
import com.d_project.ui.UIBase;

import flash.display.Graphics;

class Control extends UIBase {

	private var _device : Device;

	public function Control(device : Device) : void {
		_device = device;
	}

	override protected function update(g : Graphics) : void {
		super.update(g);
	}
}
