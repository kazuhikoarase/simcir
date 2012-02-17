package com.d_project.simcir.devices {
	
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.ui.GraphicsUtil;
	import com.d_project.simcir.ui.UIConstants;
	import com.d_project.simcir.ui.graphicsUtilClasses.Seg;
	
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

		private var _seg : Seg = null;
		
		public function LEDSeg(type : String) {
			_type = type;
		}
		
		public function get type() : String {
			return _type;
		}
		
		public function get seg() : Seg {		
			return _seg;
		}
		
		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);

			switch(type) {
			case $7SEG :
				_seg = GraphicsUtil._7SEG;
				break;
			case $16SEG :
				_seg = GraphicsUtil._16SEG;
				break;
			default :
				throw new Error(type);
			}

			var numInputs : int = _seg.allSegments.length + 1;
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

import com.d_project.simcir.devices.LEDSeg;
import com.d_project.simcir.ui.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;
import flash.display.Sprite;

class Control extends UIBase {

	private var _device : LEDSeg;

	private var _patterns : String;

	private var _seg : Sprite;
	private var _hiColor : uint;
	private var _loColor : uint;
	
	public function Control(device : LEDSeg) : void {
		
		_device = device;
		mouseEnabled = false;
		mouseChildren = false;

		_patterns = _device.seg.allSegments + ".";

		_seg = new Sprite();
		addChild(_seg);

		_hiColor = GraphicsUtil.parseColor(device.params["color"]) || 0xff0000;
		_loColor = GraphicsUtil.multiplyColor(_hiColor, 0.25);
	}

	override protected function update(g : Graphics) : void {
		super.update(g);

		var pattern : String = "";
		for (var i : int = 0; i < _patterns.length; i += 1) {
			if (_device.isHot(_device.inputs[i].value) ) {
				pattern += _patterns.charAt(i);
			}
		}

		var segG : Graphics = _seg.graphics;
		segG.clear();
		GraphicsUtil.drawSeg(
			_device.seg,
			segG, pattern,
			_hiColor, _loColor, 0x000000);

		var sw : Number = _device.seg.width;
		var sh : Number = _device.seg.height;
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
