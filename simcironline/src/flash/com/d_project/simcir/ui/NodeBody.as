package com.d_project.simcir.ui {

	import com.d_project.simcir.core.InputNode;
	import com.d_project.ui.UIBase;

	import flash.display.Graphics;

	/**
	 * NodeBody
	 * @author kazuhiko arase
	 */
	public class NodeBody extends UIBase {

		public function NodeBody() {
		}

		override protected function update(g : Graphics) : void {

			var nodeUI : NodeUI = parent as NodeUI;
			var color : uint = (nodeUI.node is InputNode)?
				UIConstants.INPUT_NODE_COLOR :
				UIConstants.OUTPUT_NODE_COLOR;
			var hot : Boolean = nodeUI.deviceUI.device.
				isHot(nodeUI.node.value);

			g.lineStyle(1, mouseOver?
				UIConstants.OVER_NODE_BORDER_COLOR :
				(hot ?
					UIConstants.HOT_NODE_BORDER_COLOR :
					UIConstants.NODE_BORDER_COLOR) );
			g.beginFill(color);
			g.drawCircle(0, 0, UIConstants.UNIT / 4);
			g.endFill();
		}
	}
}