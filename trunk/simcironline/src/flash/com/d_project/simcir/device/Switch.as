package com.d_project.simcir.device {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.LoaderContext;

	/**
	 * Switch
	 * @author kazuhiko arase
	 */
	public class Switch extends Device {

		public static const PUSH_ON : String = "pushOn";
		public static const PUSH_OFF : String = "pushOff";
		public static const TOGGLE : String = "toggle";

		private var _type : String;

		private var _on : Boolean = false;

		public function Switch(type : String) {
			_type = type;
		}

		public function get type() : String {
			return _type;
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();
			addOutput();
			if (type == PUSH_OFF) {
				on = true;
			} else {
				on = false;
			}
		}

		public function set on(value : Boolean) : void {
			_on = value;
			doOutput();
		}

		public function get on() : Boolean {
			return _on;
		}

		override protected function inputValueChangeHandler(event : NodeEvent) : void {
			doOutput();
		}

		private function doOutput() : void {
			outputs[0].value = on? inputs[0].value : null;
		}

		override public function get color() : uint {
			return 0xccccff;
		}

		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.core.Device;
import com.d_project.simcir.device.Switch;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;

class Control extends UIBase {

	private var _device : Device;

	private var _down : Boolean = false;

	public function Control(device : Device) : void {
		_device = device;
	}

	override protected function update(g : Graphics) : void {
		super.update(g);
		var sw : Switch = _device as Switch;
		var size : Number = UIConstants.UNIT;
		g.lineStyle(2, mouseOver?
			0x6666ff :
			UIConstants.BORDER_COLOR);
		g.beginFill(_down? 0x999999 : _device.color);
		g.drawRoundRect(
			(parent.width - size) / 2,
			(parent.height - size) / 2,
			size, size, 4, 4);
		g.endFill();
	}

	override protected function mouseDownHandler(event : MouseEvent) : void {
		super.mouseDownHandler(event);
		var sw : Switch = _device as Switch;
		switch(sw.type) {
		case Switch.PUSH_ON :
			sw.on = true;
			_down = true;
			break;
		case Switch.PUSH_OFF :
			sw.on = false;
			_down = true;
			break;
		case Switch.TOGGLE :
			sw.on = !sw.on;
			_down = sw.on;
			break;
		default :
			throw new Error();
		}
	}

	override protected function mouseUpHandler(event : Event) : void {
		super.mouseUpHandler(event);
		var sw : Switch = _device as Switch;
		switch(sw.type) {
		case Switch.PUSH_ON :
			sw.on = false;
			_down = false;
			break;
		case Switch.PUSH_OFF :
			sw.on = true;
			_down = false;
			break;
		case Switch.TOGGLE :
			_down = sw.on;
			break;
		default :
			throw new Error();
		}
	}
}
