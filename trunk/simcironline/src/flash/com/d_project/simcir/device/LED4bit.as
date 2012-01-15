package com.d_project.simcir.device {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceLoaderContext;
	import com.d_project.simcir.ui.UIConstants;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	/**
	 * LED4bit
	 * @author kazuhiko arase
	 */
	public class LED4bit extends Device {
		
		public function LED4bit() {
		}
		
		override public function init(loaderContext : DeviceLoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			for (var i : int = 0; i < 4; i += 1) {
				addInput();
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
import com.d_project.simcir.device.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.display.Sprite;

class Control extends UIBase {

	private static const _PATTERNS : Object = {
		"0" : "abcdef",
		"1" : "bc",
		"2" : "abdeg",
		"3" : "abcdg",
		"4" : "bcfg",
		"5" : "acdfg",
		"6" : "acdefg",
		"7" : "abc",
		"8" : "abcdefg",
		"9" : "abcdfg",	

		"a" : "abcefg",
		"b" : "cdefg",
		"c" : "adef",
		"d" : "bcdeg",
		"e" : "adefg",
		"f" : "aefg"
	};

	private static function getPattern(value : int) : String {
		return _PATTERNS["0123456789abcdef".charAt(value)];
	}
	
	private var _device : Device;
	private var _7seg : Sprite;

	public function Control(device : Device) : void {
		
		_device = device;
		mouseEnabled = false;
		mouseChildren = false;
		
		_7seg = new Sprite();
		addChild(_7seg);
	}
	
	override protected function update(g : Graphics) : void {
		super.update(g);

		var value : int = 0;
		for (var i : int = 0; i < 4; i += 1) {
			if (_device.isHot(_device.inputs[i].value) ) {
				value += (1 << i);
			}
		}

		var size : Object = GraphicsUtil.drawSegment(
			_7seg.graphics, getPattern(value),
			0xff0000, 0x660000, 0x000000);
		
		var scale : Number = UIConstants.UNIT * 3.5 / size.height;
		_7seg.scaleX = scale;
		_7seg.scaleY = scale;
		_7seg.x = (parent.width - _7seg.width) / 2;
		_7seg.y = (parent.height - _7seg.height) / 2;
	}
}
