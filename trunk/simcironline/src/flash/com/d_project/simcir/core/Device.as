package com.d_project.simcir.core {

	import com.d_project.simcir.ui.UIConstants;
	import com.d_project.simcir.ui.UISupport;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;

	use namespace simcir_core;

	/**
	 * Dispatched when value of some input node is changed.
	 */
	[Event(name="nodeValueChange", type="com.d_project.simcir.NodeEvent")]

	/**
	 * @private
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * The Device is the base class of all devices.
	 * @includeExample ../../../../SimpleSwitch.as -noswf
	 * @includeExample ../../../../MyToolbox.as -noswf
	 * @includeExample ../../../../MyToolbox.xml -noswf
	 * @see DeviceFactory
	 * @author kazuhiko arase
	 */
	public class Device extends EventDispatcher implements UISupport {

		private var _deviceDef : XML = null;

		private var _inputs : Array = new Array();

		private var _outputs : Array = new Array();

		private var _label : String = "";
		
		private var _active : Boolean = true;
		
		/**
		 * @private
		 */
		simcir_core var id : String = "";

		/**
		 * @private
		 */
		simcir_core var async : Boolean = false;

		/**
		 * @private
		 */
		simcir_core var holder : Object = null;
		
		/**
		 * Constructor
		 */
		public function Device() {
		}

		/**
		 * Initialize a device.
		 * @param loaderContext LoaderContent
		 * @param deviceDef device definition
		 */
		public function init(loaderContext : LoaderContext, deviceDef : XML) : void {
			_deviceDef = deviceDef;
			id = _deviceDef.@id;
			label = ("" + _deviceDef.@label) || _deviceDef.@type;
		}

		/**
		 * Destroy a device. 
		 */
		public function destroy() : void {
		}

		public function get deviceDef() : XML {
			return _deviceDef;
		}
		
		/**
		 * Input nodes
		 */
		public function get inputs() : Array {
			return _inputs;
		}

		/**
		 * Output nodes
		 */
		public function get outputs() : Array {
			return _outputs;
		}

		public function set label(value : String) : void {
			_label = value;
		}
		
		public function get label() : String {
			return _label;
		}
		
		public function set active(value : Boolean) : void {
			_active = value;
		}
		
		public function get active() : Boolean {
			return _active;
		}

		/**
		 * Check if a value of node is hot or not.
		 * @param value value of node
		 * @return true if a value means hot; false otherwise.
		 */
		public function isHot(value : Object) : Boolean {
			return value != null;
		}

		/**
		 * Add an input node.
		 * @param label label of node
		 * @return node that added
		 */
		public function addInput(label : String = "") : InputNode {
			var node : InputNode = new InputNode(this, "" + _inputs.length);
			node.label = label;
			node.addEventListener(NodeEvent.NODE_VALUE_CHANGE,
				node_nodeValueChangeHandler);
			_inputs.push(node);
			return node;
		}

		/**
		 * Add an output node.
		 * @param label label of node
		 * @return node that added
		 */
		public function addOutput(label : String = "") : OutputNode {
			var node : OutputNode = new OutputNode(this, "" + _outputs.length);
			node.label = label;
			_outputs.push(node);
			return node;
		}

		/**
		 * Called when value of some input node is changed.
		 * @param event Event
		 */
		protected function inputValueChangeHandler(event : NodeEvent) : void {
		}

		/**
		 *  @inheritDoc
		 */
		public function get widthInUnit() : Number {
			return 2;
		}

		/**
		 *  @inheritDoc
		 */
		public function get heightInUnit() : Number {
			return Math.max(2, inputs.length, outputs.length);
		}
		
		/**
		 *  @inheritDoc
		 */
		public function get color() : uint {
			return UIConstants.DEVICE_COLOR;
		}

		/**
		 *  @inheritDoc
		 */
		public function createControl() : DisplayObject {
			return new Sprite();
		}
		
		private function node_nodeValueChangeHandler(event : NodeEvent) : void {
			
			inputValueChangeHandler(event);
			
			dispatchEvent(event);
		}
	}
}