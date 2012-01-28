package com.d_project.simcir.devices {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.ui.UIConstants;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.system.LoaderContext;
	
	/**
.	 * LEDSeg
	 * @author kazuhiko arase
	 */
	public class LEDSeg extends Device {
		
		public static const $7SEG : String = "7SEG";
		public static const $16SEG : String = "16SEG";
		
		private var _type : String;
		
		public function LEDSeg(type : String) {
			_type = type;
		}
		
		public function get type() : String {
			return _type;
		}
		
		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);

			var numInputs : int;
			
			switch(type) {
			case $7SEG :
				numInputs = Control.PATTERNS_7.length;
				break;
			case $16SEG :
				numInputs = Control.PATTERNS_16.length;
				break;
			default :
				throw new Error(type);
			}
			
			for (var i : int = 0; i < numInputs; i += 1) {
				addInput();
			}
		}
		
		override public function get color() : uint {
			return 0x999999;
		}
		
		override public function get widthInUnit():Number {
			return 4;
		}
		
		override public function get halfPitch() : Boolean {
			return true;
		}

		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.core.DeviceLoader;
import com.d_project.simcir.devices.GraphicsUtil;
import com.d_project.simcir.devices.LEDSeg;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.display.Sprite;

class Control extends UIBase {

	public static const PATTERNS_7 : String= "abcdefg.";
	public static const PATTERNS_16 : String= "abcdefghijklmnop.";
	
	private var _device : LEDSeg;
	private var _draw : Function;
	private var _seg : Sprite;
	private var _hiColor : uint;
	private var _loColor : uint;
	private var _patterns : String;
	
	public function Control(device : LEDSeg) : void {
		
		_device = device;
		mouseEnabled = false;
		mouseChildren = false;

		switch(device.type) {
		case LEDSeg.$7SEG :
			_patterns = PATTERNS_7;
			_draw = GraphicsUtil.draw7seg;
			break;
		case LEDSeg.$16SEG :
			_patterns = PATTERNS_16;
			_draw = GraphicsUtil.draw16seg;
			break;
		default :
			throw new Error(device.type);
		}

		_seg = new Sprite();
		addChild(_seg);

		var ns : Namespace = DeviceLoader.NS;
		_hiColor = GraphicsUtil.parseColor(
			device.deviceDef.ns::param.(@name == "color").@value) || 0xff0000;
		_loColor = GraphicsUtil.multiplyColor(_hiColor, 0.25);
	}
	
	public function get patterns() : String {
		return _patterns;
	}
	
	override protected function update(g : Graphics) : void {
		super.update(g);

		var pattern : String = "";
		for (var i : int = 0; i < patterns.length; i += 1) {
			if (_device.isHot(_device.inputs[i].value) ) {
				pattern += patterns.charAt(i);
			}
		}

		var segG : Graphics = _seg.graphics;
		segG.clear();
		var size : Object = _draw(
			segG, pattern,
			_hiColor, _loColor, 0x000000);

		var sw : Number = size.width;
		var sh : Number = size.height;
		var dw : Number = _device.widthInUnit;
		var dh : Number = _device.heightInUnit;
		
		var scale : Number = (sw / sh > dw / dh)?
			UIConstants.UNIT * (dw - 1) / sw :
			UIConstants.UNIT * (dh - 1) / sh;

		_seg.scaleX = scale;
		_seg.scaleY = scale;
		_seg.x = (parent.width - _seg.width) / 2;
		_seg.y = (parent.height - _seg.height) / 2;
	}
}