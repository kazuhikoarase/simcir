package com.d_project.simcir.devices {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.system.LoaderContext;
	
	/**
	 * RotaryEncoder
	 * @author kazuhiko arase
	 */
	public class RotaryEncoder extends Device {

		private var _value : int = 0;
		
		public function RotaryEncoder() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addInput();
			for (var i : int = 0; i < 4; i += 1) {
				addOutput();
			}
		}
		
		public function set value(value : int) : void {
			_value = value;
			doOutput();
		}
		
		public function get value() : int {
			return _value;
		}
		
		override protected function inputValueChangeHandler(event : NodeEvent) : void {
			doOutput();
		}
		
		private function doOutput() : void {
			for (var i : int = 0; i < 4; i += 1) {
				outputs[i].value = (value & (1 << i) )? inputs[0].value : null;
			}
		}
		
		override public function get widthInUnit():Number {
			return 4;
		}
		
		override public function get color() : uint {
			return 0x999999;
		}
		
		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.devices.RotaryEncoder;
import com.d_project.simcir.ui.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.events.MouseEvent;

class Control extends UIBase {
	
	private static const _MIN_ANGLE : Number = 45;
	private static const _MAX_ANGLE : Number = 315;

	private var _vol : RotaryEncoder;

	private var _theta : Number = 0;

	public function Control(vol : RotaryEncoder) : void {
		_vol = vol;
		angle = 45;
	}
	
	public function set angle(value : Number) : void {

		_theta = angleToTheta(Math.max(_MIN_ANGLE,
			Math.min(value, _MAX_ANGLE) ) );
		
		_vol.value = Math.min( ( (angle - _MIN_ANGLE) /
			(_MAX_ANGLE - _MIN_ANGLE) * 16), 15);

		invalidate();
	}

	public function get angle() : Number {
		return thetaToAngle(_theta);
	}
	
	override protected function update(g : Graphics) : void {
		super.update(g);

		var cx : Number = parent.width / 2;
		var cy : Number = parent.height / 2;
		var size : Number = UIConstants.UNIT;
		var radius : Number = (parent.width - size) / 2;

		GraphicsUtil.drawVolume(g, cx, cy, radius, _theta);
	}

	override protected function mouseDragHandler(event : MouseEvent) : void {
		
		var cx : Number = parent.width / 2;
		var cy : Number = parent.height / 2;
		var dx : Number = mouseX - cx;
		var dy : Number = mouseY - cy;

		if (dx == 0 && dy == 0) return;
		
		angle = thetaToAngle(Math.atan2(dy, dx) );
	} 
	
	private static function thetaToAngle(theta : Number) : Number {
		var angle : Number = (theta - Math.PI / 2) / Math.PI * 180;
		while (angle < 0) {
			angle += 360;
		}
		while (angle > 360) {
			angle -= 360;
		}
		return angle;
	}
	
	private static function angleToTheta(angle : Number) : Number {
		return angle / 180 * Math.PI + Math.PI / 2;
	}
}
