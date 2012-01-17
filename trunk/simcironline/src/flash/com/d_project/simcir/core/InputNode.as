package com.d_project.simcir.core {

	use namespace simcir_core;

	/**
	 * InputNode
	 * @author kazuhiko arase
	 * @private
	 */
	public class InputNode extends Node {

		simcir_core var outputNode : OutputNode = null

		public function InputNode(device : Device, id : String) {
			super(device, id);
		}

		simcir_core function getOutputNode() : OutputNode {
			return outputNode;
		}

		override simcir_core function disconnect() : void {
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