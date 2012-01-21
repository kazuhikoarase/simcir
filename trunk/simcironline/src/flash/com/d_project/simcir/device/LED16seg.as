package com.d_project.simcir.device {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.ui.UIConstants;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.system.LoaderContext;
	
	/**
	 * LED16seg
	 * @author kazuhiko arase
	 */
	public class LED16seg extends Device {
		
		public function LED16seg() {
		}
		
		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			for (var i : int = 0; i < Control.PATTERNS.length; i += 1) {
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
import com.d_project.simcir.core.DeviceLoader;
import com.d_project.simcir.device.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.display.Sprite;

class Control extends UIBase {

	public static const PATTERNS : String= "abcdefghijklmnop.";
	
	private var _device : Device;
	private var _seg : Sprite;
	private var _hiColor : uint;
	private var _loColor : uint;
	
	public function Control(device : Device) : void {
		
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

		var pattern : String = "";
		for (var i : int = 0; i < PATTERNS.length; i += 1) {
			if (_device.isHot(_device.inputs[i].value) ) {
				pattern += PATTERNS.charAt(i);
			}
		}

		var segG : Graphics = _seg.graphics;
		segG.clear();
		var size : Object = GraphicsUtil.draw16seg(
			segG, pattern,
			_hiColor, _loColor, 0x000000);

		var scale : Number = UIConstants.UNIT * 5 / size.height;
		_seg.scaleX = scale;
		_seg.scaleY = scale;
		_seg.x = (parent.width - _seg.width) / 2;
		_seg.y = (parent.height - _seg.height) / 2;
	}
}
