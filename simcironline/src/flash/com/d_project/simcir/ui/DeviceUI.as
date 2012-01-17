package com.d_project.simcir.ui {

	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.NodeEvent;
	import com.d_project.simcir.core.simcir_core;
	import com.d_project.ui.UIBase;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	use namespace simcir_core;

	/**
	 * DeviceUI
	 * @author kazuhiko arase
	 */
	public class DeviceUI extends UIBase {

		private var _device : Device;
		private var _inputs : Array;
		private var _outputs : Array;

		private var _body : DeviceBody;
		private var _control : DisplayObject;
		private var _labelField : TextField;

		private var _selected : Boolean = false;

		private var _active : Boolean = true;
		
		private var _editable : Boolean = true;

		public function DeviceUI(device : Device) {

			_device = device;
			_device.holder = this;
			_device.addEventListener(NodeEvent.NODE_VALUE_CHANGE,
				device_nodeValueChangeHandler);

			x = device.deviceDef.@x;
			y = device.deviceDef.@y;
			mouseEnabled = false;

			// label
			_labelField = new TextField();
			_labelField.type = TextFieldType.INPUT;
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			_labelField.defaultTextFormat = UIConstants.DEFAULT_TEXT_FORMAT;
			_labelField.text = device.deviceDef.@label;
			_labelField.maxChars = 30;
			_labelField.addEventListener(Event.CHANGE, label_changeHandler);
			addChild(_labelField);

			// body
			_body = new DeviceBody();
			addChild(_body);

			// in and out
			_inputs = new Array();
			_outputs = new Array();
			var i : int;
			var nodeUI : NodeUI;

			for (i = 0; i < device.inputs.length; i += 1) {
				nodeUI = new NodeUI(device.inputs[i]);
				_inputs.push(nodeUI);
				_body.addChild(nodeUI);
			}

			for (i = 0; i < device.outputs.length; i += 1) {
				nodeUI = new NodeUI(device.outputs[i]);
				_outputs.push(nodeUI);
				_body.addChild(nodeUI);
			}

			// control
			_control = device.createControl();
			_body.addChild(_control);

			layout();
		}

		public function set active(value : Boolean) : void {
			_active = value;

			_body.mouseChildren = value;
			_labelField.mouseEnabled = value;
			_device.active = value;
		}

		public function get active() : Boolean {
			return _active;
		}
		
		public function set editable(value : Boolean) : void {
			_editable = value;
			
			var i : int;
			//_body.mouseEnabled = value;
			for (i = 0; i < inputs.length; i += 1) {
				inputs[i].body.mouseEnabled = value;
			}
			for (i = 0; i < outputs.length; i += 1) {
				outputs[i].body.mouseEnabled = value;
			}
			_labelField.mouseEnabled = value;
			_labelField.selectable = value;
		}

		public function get editable() : Boolean {
			return _editable;
		}
			
		public function get label() : String {
			return _labelField.text;
		}

		public function get device() : Device {
			return _device;
		}

		public function get inputs() : Array {
			return _inputs;
		}

		public function get outputs() : Array {
			return _outputs;
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set selected(value : Boolean) : void {
			_selected = value;
			_invalidate();
		}

		private function device_nodeValueChangeHandler(event : Event) : void {
			_invalidate();
		}

		private function label_changeHandler(event : Event) : void {
			_invalidate();
		}

		private function _invalidate() : void {
			_body.invalidate();
			if (_control is UIBase) {
				UIBase(_control).invalidate();
			}
			invalidate();
		}

		override protected function update(g : Graphics) : void {

			layout();

			_body.width = width;
			_body.height = height;

			_labelField.x = width / 2 - _labelField.width / 2;
			_labelField.y = height;
		}

		public function measure() : void {
			width = UIConstants.UNIT * device.widthInUnit;
			height = UIConstants.UNIT * device.heightInUnit;
		}

		private function layout() : void {

			measure();

			var layoutNodes : Function = function(nodes : Array, x : Number) : void {
				var offset : Number = (height - UIConstants.UNIT * (nodes.length - 1) ) / 2;
				for (var i : int = 0; i < nodes.length; i += 1) {
					var nodeUI : NodeUI = nodes[i];
					nodeUI.x = x;
					nodeUI.y = UIConstants.UNIT * i + offset;
				}
			};

			layoutNodes(inputs, 0);
			layoutNodes(outputs, width);
		}
	}
}
