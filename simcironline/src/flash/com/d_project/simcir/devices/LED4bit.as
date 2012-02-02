package com.d_project.simcir.devices {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.ui.UIConstants;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.system.LoaderContext;
	
	/**
	 * LED4bit
	 * @author kazuhiko arase
	 */
	public class LED4bit extends Device {
		
		public function LED4bit() {
		}
		
		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			for (var i : int = 0; i < 4; i += 1) {
				addInput();
			}
		}

		override public function get color() : uint {
			return 0x999999;
		}
		
		override public function get widthInUnit():Number {
			return 4;
		}
		
		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import com.d_project.simcir.core.DeviceLoader;
import com.d_project.simcir.devices.LED4bit;
import com.d_project.simcir.ui.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.simcir.ui.graphicsUtilClasses.Seg;
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
	
	private var _device : LED4bit;
	private var _seg : Sprite;
	private var _hiColor : uint;
	private var _loColor : uint;
	
	public function Control(device : LED4bit) : void {
		
		_device = device;
		mouseEnabled = false;
		mouseChildren = false;
		
		_seg = new Sprite();
		addChild(_seg);
		
		var ns : Namespace = DeviceLoader.NS;
		_hiColor = GraphicsUtil.parseColor(
			device.deviceDef.ns::param.(@name == "color").@value) || 0xff0000;
		_loColor = GraphicsUtil.multiplyColor(_hiColor, 0.25);
	}
	
	override protected function update(g : Graphics) : void {
		super.update(g);

		var value : int = 0;
		for (var i : int = 0; i < 4; i += 1) {
			if (_device.isHot(_device.inputs[i].value) ) {
				value += (1 << i);
			}
		}

		var segG : Graphics = _seg.graphics;
		segG.clear();
		var seg : Seg = GraphicsUtil._7SEG;
		GraphicsUtil.drawSeg(
			seg,
			segG, getPattern(value),
			_hiColor, _loColor, 0x000000);
		
		var sw : Number = seg.width;
		var sh : Number = seg.height;
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
