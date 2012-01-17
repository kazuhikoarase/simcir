package com.d_project.simcir.ui {

	import com.d_project.simcir.core.InputNode;
	import com.d_project.simcir.core.Node;
	import com.d_project.simcir.core.NodeEvent;
	import com.d_project.simcir.core.simcir_core;
	import com.d_project.ui.UIBase;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	use namespace simcir_core;

	[Event(name="nodeValueChange", type="com.d_project.simcir.NodeEvent")]

	/**
	 * NodeUI
	 * @author kazuhiko arase
	 */
	public class NodeUI extends UIBase {

		private var _node : Node;

		private var _body : NodeBody;
		private var _labelField : TextField;

		public function NodeUI(node : Node) {

			_node = node;
			_node.holder = this;
			_node.addEventListener(NodeEvent.NODE_VALUE_CHANGE,
				node_nodeValueChangeHandler);

			mouseEnabled = false;

			_body = new NodeBody();
			addChild(_body);

			_labelField = new TextField();
			_labelField.type = TextFieldType.DYNAMIC;
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			_labelField.defaultTextFormat = UIConstants.DEFAULT_TEXT_FORMAT;
			_labelField.text = node.label;
			_labelField.selectable = false;
			_labelField.mouseEnabled = false;
			addChild(_labelField);
		}

		public function get node() : Node {
			return _node;
		}

		public function get body() : NodeBody {
			return _body;
		}

		public function get deviceUI() : DeviceUI {
			var c : DisplayObject = this;
			while (c.parent != null) {
				if (c.parent is DeviceUI) {
					return c.parent as DeviceUI;
				}
				c = c.parent;
			}
			return null;
		}

		private function node_nodeValueChangeHandler(event : NodeEvent) : void {
			_body.invalidate();
			invalidate();
		}

		override protected function update(g : Graphics) : void {

			var off : Number = UIConstants.UNIT / 8 * 3;

			if (node is InputNode) {
				_labelField.x = off;
			} else {
				_labelField.x = -_labelField.width - off;
			}
			_labelField.y = -_labelField.height / 2;
		}
	}
}