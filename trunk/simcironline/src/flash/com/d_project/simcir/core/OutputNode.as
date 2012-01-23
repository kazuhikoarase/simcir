package com.d_project.simcir.core {

	use namespace simcir_core;

	/**
	 * OutputNode
	 * @author kazuhiko arase
	 * @private
	 */
	public class OutputNode extends Node {

		simcir_core var inputNodes : Array = new Array();

		public function OutputNode(device : Device, id : String) {
			super(device, id);
		}
		
		override public function set value(value : Object) : void {
			super.value = value;
			for (var i : int = 0; i < inputNodes.length; i += 1) {
				inputNodes[i].value = value;
			}
		}

		simcir_core function connectTo(inputNode : InputNode) : void {
			if (inputNode.outputNode != null) {
				inputNode.disconnect();
			}
			inputNodes.push(inputNode);
			inputNode.outputNode = this;
			inputNode.setValue(value, true);
		}

		override simcir_core function disconnect() : void {
			while (inputNodes.length > 0) {
				inputNodes[inputNodes.length - 1].disconnect();
			}
		}
	}
}