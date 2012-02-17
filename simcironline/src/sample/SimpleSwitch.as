package {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	
	import flash.display.DisplayObject;
	import flash.system.LoaderContext;

	public class SimpleSwitch extends Device {

		override public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			super.init(loaderContext, deviceDef);
			// 1 in, 1 out
			addInput();
			addOutput();
		}

		private var _on : Boolean = false;
		
		public function set on(value : Boolean) : void {
			_on = value;
			doOutput();
		}
		
		public function get on() : Boolean {
			return _on;
		}
		
		override protected function inputValueChangeHandler(event : NodeEvent) : void {
			doOutput();
		}
		
		private function doOutput() : void {
			outputs[0].value = on? inputs[0].value : null;
		}
		
		override public function createControl() : DisplayObject {
			return new Control(this);
		}
	}
}

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class Control extends Sprite {
	
	private var _device : SimpleSwitch;
	private var _color : uint;
	
	public function Control(device : SimpleSwitch) {

		_device = device;

		var color : String = device.params["color"];
		_color =
			color == "red"?   0xff0000 :
			color == "green"? 0x00ff00 :
			color == "blue"?  0x0000ff : 0x000000;
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private function addedToStageHandler(event : *) : void {
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	private function mouseDownHandler(event : *) : void {
		_device.on = true;
	}

	private function mouseUpHandler(event : *) : void {
		_device.on = false;
	}
	
	private function enterFrameHandler(event : *) : void {
		var g : Graphics = graphics;
		g.clear();
		g.lineStyle(2, _color);
		g.beginFill(_device.on? 0x666666 : 0xcccccc);
		g.drawCircle(
			parent.width / 2,
			parent.height / 2,
			parent.width / 4);	
		g.endFill();
	}
}
