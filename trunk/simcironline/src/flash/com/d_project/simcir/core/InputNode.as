package com.d_project.simcir.core {

	/**
	 * InputNode
	 * @author kazuhiko arase
	 */
	public class InputNode extends Node {

		use namespace simcir_core;

		simcir_core var outputNode : OutputNode = null

		public function InputNode(device : Device, id : String) {
			super(device, id);
		}

		public function getOutputNode() : OutputNode {
			return outputNode;
		}

		override public function disconnect() : void {
			if (outputNode == null) {
				return;
			}
			var index : int = outputNode.inputNodes.indexOf(this);
			if (index == -1) {
				throw new Error();
			}
			outputNode.inputNodes = outputNode.inputNodes.slice(0, index).
				concat(outputNode.inputNodes.slice(index + 1) )
			outputNode = null;
			value = null;
		}
	}
}