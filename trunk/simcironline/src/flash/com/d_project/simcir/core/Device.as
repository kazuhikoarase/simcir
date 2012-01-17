package com.d_project.simcir.core {

	import com.d_project.simcir.ui.UIConstants;
	import com.d_project.simcir.ui.UISupport;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;

	use namespace simcir_core;

	[Event(name="nodeValueChange", type="com.d_project.simcir.NodeEvent")]

	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Device
	 * @author kazuhiko arase
	 */
	public class Device extends EventDispatcher implements UISupport {

		private var _deviceDef : XML = null;

		private var _inputs : Array = new Array();

		private var _outputs : Array = new Array();

		private var _label : String = "";

		public var id : String = "";

		public var active : Boolean = true;
		
		public var async : Boolean = false;

		simcir_core var holder : Object = null;

		public function Device() {
		}

		public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			_deviceDef = deviceDef;
			id = _deviceDef.@id;
			label = _deviceDef.@label;
		}

		public function destroy() : void {
		}

		public function get deviceDef() : XML {
			return _deviceDef;
		}

		public function set label(value : String) : void {
			_label = value;
		}

		public function get label() : String {
			return _label;
		}

		public function get inputs() : Array {
			return _inputs;
		}

		public function get outputs() : Array {
			return _outputs;
		}

		public function isHot(value : Object) : Boolean {
			return value != null;
		}

		public function addInput(label : String = "") : InputNode {
			var node : InputNode = new InputNode(this, "" + _inputs.length);
			node.label = label;
			node.addEventListener(NodeEvent.NODE_VALUE_CHANGE,
				node_nodeValueChangeHandler);
			_inputs.push(node);
			return node;
		}

		public function addOutput(label : String = "") : OutputNode {
			var node : OutputNode = new OutputNode(this, "" + _outputs.length);
			node.label = label;
			_outputs.push(node);
			return node;
		}

		private function node_nodeValueChangeHandler(event : NodeEvent) : void {

			inputValueChangeHandler(event);

			dispatchEvent(event);
		}

		protected function inputValueChangeHandler(event : NodeEvent) : void {
		}

		public function get color() : uint {
			return UIConstants.DEVICE_COLOR;
		}

		public function get widthInUnit() : Number {
			return 2;
		}

		public function get heightInUnit() : Number {
			return Math.max(2, inputs.length, outputs.length);
		}

		public function createControl() : DisplayObject {
			return new Sprite();
		}
	}
}