package com.d_project.simcir.core {

	import flash.events.Event;

	/**
	 * A node object dispatches a NodeEvent when it's value is changed. 
	 * @see Node
	 * @see Device
	 * @author kazuhiko arase
	 */
	public class NodeEvent extends Event {

		public static const NODE_VALUE_CHANGE : String = "nodeValueChange";

		private var _oldValue : Object;
		private var _newValue : Object;

		public function NodeEvent(type : String, oldValue : Object, newValue : Object) {
			super(type);
			_oldValue = oldValue;
			_newValue = newValue;
		}

		public function get oldValue() : Object {
			return _oldValue;
		}

		public function get newValue() : Object {
			return _newValue;
		}

		override public function clone() : Event {
			return new NodeEvent(type, _oldValue, _newValue);
		}
	}
}