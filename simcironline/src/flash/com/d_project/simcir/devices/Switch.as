package com.d_project.simcir.devices {

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

import com.d_project.simcir.devices.Switch;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

class Control extends UIBase {

	private var _sw : Switch;

	private var _down : Boolean = false;

	public function Control(sw : Switch) : void {
		_sw = sw;
	}

	override protected function update(g : Graphics) : void {
		super.update(g);
		var size : Number = UIConstants.UNIT;
		g.lineStyle(2, mouseOver?
			0x6666ff :
			UIConstants.BORDER_COLOR);
		var mat : Matrix = new Matrix();
		var rx : Number = (parent.width - size) / 2;
		var ry : Number = (parent.height - size) / 2;
		mat.createGradientBox(size, size, Math.PI / 2, rx, ry);
//		g.beginFill(_down? 0x999999 : _sw.color);
		g.beginGradientFill(
			GradientType.LINEAR,
			_down?
				[0x3333cc, 0xddddff] : 
				[0xddddff, 0x3333cc],
			[1, 1], [0, 255],mat);
		g.drawRoundRect(rx, ry, size, size, 4, 4);
		g.endFill();
	}

	override protected function mouseDownHandler(event : MouseEvent) : void {
		super.mouseDownHandler(event);
		switch(_sw.type) {
		case Switch.PUSH_ON :
			_sw.on = true;
			_down = true;
			break;
		case Switch.PUSH_OFF :
			_sw.on = false;
			_down = true;
			break;
		case Switch.TOGGLE :
			_sw.on = !_sw.on;
			_down = _sw.on;
			break;
		default :
			throw new Error();
		}
	}

	override protected function mouseUpHandler(event : Event) : void {
		super.mouseUpHandler(event);
		switch(_sw.type) {
		case Switch.PUSH_ON :
			_sw.on = false;
			_down = false;
			break;
		case Switch.PUSH_OFF :
			_sw.on = true;
			_down = false;
			break;
		case Switch.TOGGLE :
			_down = _sw.on;
			break;
		default :
			throw new Error();
		}
	}
}
