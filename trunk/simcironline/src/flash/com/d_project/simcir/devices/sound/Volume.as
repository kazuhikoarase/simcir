package com.d_project.simcir.devices.sound {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.system.LoaderContext;
	
	/**
	 * Volume
	 * @author kazuhiko arase
	 */
	public class Volume extends Device implements SoundSource {

		private var _value : Number = 0;
		
		public function Volume() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			addOutput().value = this;
		}
		
		public function set value(value : Number) : void {
			_value = value;
		}
		
		public function get value() : Number {
			return _value;
		}

		override public function get color() : uint {
			return 0x999999;
		}
		
		override public function createControl() : DisplayObject {
			return new Control(this);
		}
		
		public function get_v(position : Number) : Number {
			return value;
		}
	}
}

import com.d_project.simcir.devices.sound.Volume;
import com.d_project.simcir.ui.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.events.MouseEvent;

class Control extends UIBase {
	
	private static const _MIN_ANGLE : Number = 45;
	private static const _MAX_ANGLE : Number = 315;

	private var _vol : Volume;

	private var _theta : Number = 0;

	public function Control(vol : Volume) : void {
		_vol = vol;
		angle = 45;
	}
	
	public function set angle(value : Number) : void {

		_theta = angleToTheta(Math.max(_MIN_ANGLE,
			Math.min(value, _MAX_ANGLE) ) );
		
		_vol.value = (angle - _MIN_ANGLE) / (_MAX_ANGLE - _MIN_ANGLE);

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
		var radius : Number = (parent.width - size) * 0.75;

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
