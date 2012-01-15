package com.d_project.simcir.device {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceLoaderContext;
	import com.d_project.simcir.ui.UIConstants;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	/**
	 * LED7seg
	 * @author kazuhiko arase
	 */
	public class LED7seg extends Device {
		
		public function LED7seg() {
		}
		
		override public function init(loaderContext : DeviceLoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			for (var i : int = 0; i < 8; i += 1) {
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

import com.d_project.simcir.core.Device;
import com.d_project.simcir.device.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.display.Sprite;

class Control extends UIBase {

	private const _PATTERNS : String= "abcdefg.";
	
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

		var pattern : String = "";
		for (var i : int = 0; i < _PATTERNS.length; i += 1) {
			if (_device.isHot(_device.inputs[i].value) ) {
				pattern += _PATTERNS.charAt(i);
			}
		}

		var g7s : Graphics = _7seg.graphics;
		g7s.clear();
		var size : Object = GraphicsUtil.drawSegment(
			g7s, pattern,
			0xff0000, 0x660000, 0x000000);

		var scale : Number = UIConstants.UNIT * 5 / size.height;
		_7seg.scaleX = scale;
		_7seg.scaleY = scale;
		_7seg.x = (parent.width - _7seg.width) / 2;
		_7seg.y = (parent.height - _7seg.height) / 2;
	}
}
