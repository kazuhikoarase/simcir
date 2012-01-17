package com.d_project.simcir.device {

	import com.d_project.simcir.core.Device;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.system.LoaderContext;

	/**
	 * LED
	 * @author kazuhiko arase
	 */
	public class LED extends Device {

		public function LED() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();
		}

		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.core.Device;
import com.d_project.simcir.device.GraphicsUtil;
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
		var hot : Boolean = _device.isHot(_device.inputs[0].value);
		var color : int = hot? 0xff0000 : 0x000000;
		GraphicsUtil.drawGlass(g,
			parent.width / 2,
			parent.height / 2,
			UIConstants.UNIT * 0.6, color, hot);
	}
}
