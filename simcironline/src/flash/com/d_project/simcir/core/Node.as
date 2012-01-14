package com.d_project.simcir.core {

	import flash.events.EventDispatcher;

	[Event(name="nodeValueChange", type="com.d_project.simcir.NodeEvent")]

	/**
	 * Node
	 * @author kazuhiko arase
	 */
	public class Node extends EventDispatcher {

		use namespace simcir_core;

		private var _id : String;

		private var _device : Device;

		private var _label : String = "";

		private var _value : Object = null;

		simcir_core var holder : Object = null;

		public function Node(device : Device, id : String) {
			_device = device;
			_id = id;
			addEventListener(NodeEvent.NODE_VALUE_CHANGE,
				nodeValueChangeHandler);
		}

		public function get id() : String {
			return _id;
		}

		public function get device() : Device {
			return _device;
		}

		public function set label(value : String) : void {
			_label = value;
		}

		public function get label() : String {
			return _label;
		}

		public function set value(value : Object) : void {

			if (_value == value) {
				return;
			}

			var oldValue : Object = _value;
			_value = value;

			var event : NodeEvent = new NodeEvent(
				NodeEvent.NODE_VALUE_CHANGE, oldValue, value);
			EventQueue.getInstance().postEvent(this, event);
		}

		public function get value() : Object{
			return _value;
		}

		public function disconnect() : void {
			throw new Error("not implemented");
		}

		protected function nodeValueChangeHandler(event : NodeEvent) : void {
		}
	}
}