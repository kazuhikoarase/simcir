package com.d_project.simcir.device {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.system.LoaderContext;
	
	/**
	 * Volume4bit
	 * @author kazuhiko arase
	 */
	public class Volume4bit extends Device {

		private var _value : int = 0;
		
		public function Volume4bit() {
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

import com.d_project.simcir.core.Device;
import com.d_project.simcir.device.Volume4bit;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.geom.Matrix;

class Control extends UIBase {
	
	private static const _MIN_ANGLE : Number = 45;
	private static const _MAX_ANGLE : Number = 315;

	private var _device : Device;

	private var _theta : Number = 0;

	public function Control(device : Device) : void {
		_device = device;
		angle = 45;
	}
	
	public function set angle(value : Number) : void {

		_theta = angleToTheta(Math.max(_MIN_ANGLE,
			Math.min(value, _MAX_ANGLE) ) );
		
		var vol : Volume4bit = _device as Volume4bit;
		vol.value = Math.min( ( (angle - _MIN_ANGLE) /
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

		var mat : Matrix = new Matrix();
		mat.createGradientBox(radius * 4, radius * 4, 0, -radius * 1.5, -radius * 1.5);
		
		g.beginGradientFill(GradientType.RADIAL, [0x666666, 0x000000], [1, 1], [0, 255], mat);
		g.drawCircle(cx, cy, radius);
		g.endFill();
		
		var r1 : Number = radius * 0.4; 
		var r2 : Number = radius - 3 / 2; 
		
		g.lineStyle(3, 0xffffff, 0.8);
		g.moveTo(Math.cos(_theta) * r1 + cx, Math.sin(_theta) * r1 + cx);
		g.lineTo(Math.cos(_theta) * r2 + cx, Math.sin(_theta) * r2 + cx);
		
		g.lineStyle(1, 0, 1);
		g.drawCircle(cx, cy, radius);		
		
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
