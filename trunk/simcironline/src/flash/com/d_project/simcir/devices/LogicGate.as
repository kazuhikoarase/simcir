package com.d_project.simcir.devices {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.system.LoaderContext;

	/**
	 * LogicGate
	 * @author kazuhiko arase
	 */
	public class LogicGate extends Device {

		private var _opFunc : Function = null;
		private var _outFunc : Function = null;

		public function LogicGate() {
		}

		override public function init(loaderContext : LoaderContext, deviceDef : XML):void {

			super.init(loaderContext, deviceDef);

			var type : String = deviceDef.@type;

			switch(type) {
			case "BUF" :
				_opFunc = null;
				_outFunc = BUF;
				break;
			case "NOT" :
				_opFunc = null;
				_outFunc = NOT;
				break;
			case "AND" :
				_opFunc = AND;
				_outFunc = BUF;
				break;
			case "NAND" :
				_opFunc = AND;
				_outFunc = NOT;
				break;
			case "OR" :
				_opFunc = OR;
				_outFunc = BUF;
				break;
			case "NOR" :
				_opFunc = OR;
				_outFunc = NOT;
				break;
			case "EOR" :
				_opFunc = EOR;
				_outFunc = BUF;
				break;
			case "ENOR" :
				_opFunc = EOR;
				_outFunc = NOT;
				break;
			default :
				throw new Error(type);
			}

			// input (variable);
			var numInputs : int = params["numInputs"];
			numInputs = Math.max(numInputs, (_opFunc != null)? 2 : 1);
			for (var i : int = 0; i < numInputs; i += 1) {
				addInput();
			}

			// output (1 out only)
			addOutput();
		}

		override protected function inputValueChangeHandler(
			event : NodeEvent
		) : void {

			var b : int = intValue(inputs[0].value);

			if (_opFunc != null) {
				for (var i : int = 1; i < inputs.length; i += 1) {
					b = _opFunc(b, intValue(inputs[i].value) );
				}
			}

			b = _outFunc(b);
			outputs[0].value = (b == 1)? 1 : null;
		}

		protected function intValue(value : Object) : int {
			return (value != null)? 1 : 0;
		}
		
		override public function get visualDevice() : Boolean {
			return false;
		}

		override public function get halfPitch() : Boolean {
			return inputs.length > 2;
		}

		override public function createControl() : DisplayObject {
			return new Control(this);
		}

		private static function AND(a : int, b : int) : int {
			return a & b;
		}

		private static function OR(a : int, b : int) : int {
			return a | b;
		}

		private static function EOR(a : int, b : int) : int {
			return a ^ b;
		}

		private static function BUF(a : int) : int {
			return (a == 1)? 1 : 0;
		}

		private static function NOT(a : int) : int {
			return (a == 1)? 0 : 1;
		}
	}
}

import com.d_project.simcir.devices.LogicGate;
import com.d_project.simcir.ui.GraphicsUtil;
import com.d_project.simcir.ui.UIConstants;
import com.d_project.ui.UIBase;

import flash.display.Graphics;

class Control extends UIBase {

	private var _device : LogicGate;
	private var _draw : Function;

	public function Control(device : LogicGate) : void {
		_device = device;
		mouseEnabled = false;

		var type : String = device.deviceDef.@type;

		switch(type) {
		case "BUF" :
			_draw = GraphicsUtil.drawBuffer;
			break;
		case "NOT" :
			_draw = GraphicsUtil.drawNOT;
			break;
		case "AND" :
			_draw = GraphicsUtil.drawAND;
			break;
		case "NAND" :
			_draw = GraphicsUtil.drawNAND;
			break;
		case "OR" :
			_draw = GraphicsUtil.drawOR;
			break;
		case "NOR" :
			_draw = GraphicsUtil.drawNOR;
			break;
		case "EOR" :
			_draw = GraphicsUtil.drawEOR;
			break;
		case "ENOR" :
			_draw = GraphicsUtil.drawENOR;
			break;
		default :
			throw new Error(type);
		}
	}

	override protected function update(g : Graphics) : void {
		super.update(g);
		g.lineStyle(1, 0x000000);
		var size : Number = UIConstants.UNIT;
		_draw(g,
			(parent.width - size) / 2,
			(parent.height - size) / 2,
			size, size);
	}
}
