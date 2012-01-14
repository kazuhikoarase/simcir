package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.InputNode;
	import com.d_project.simcir.core.OutputNode;
	import com.d_project.simcir.core.simcir_core;
	import com.d_project.simcir.ui.NodeBody;
	import com.d_project.simcir.ui.NodeUI;
	import com.d_project.simcir.ui.UIConstants;
	import com.d_project.simcir.ui.Workspace;

	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * DragConnect
	 * @author kazuhiko arase
	 */
	public class DragConnect extends DragOperation {

		use namespace simcir_core;

		public function DragConnect(workspace : Workspace) {
			super(workspace);
		}

		override public function beginDrag(event : MouseEvent) : void {
			super.beginDrag(event);

			var nodeUI : NodeUI = dragTarget.parent as NodeUI;

			if (nodeUI.node is InputNode) {
				nodeUI.node.disconnect();
			}
		}

		override public function doDrag(event : MouseEvent):void {
			super.doDrag(event);

			var nodeUI : NodeUI = dragTarget.parent as NodeUI;

			var g : Graphics = workspace.temporaryPane.graphics;
			g.clear();

			g.lineStyle(1, UIConstants.CONNECTOR_COLOR);
			g.moveTo(
				workspace.devicePane.x + nodeUI.x + nodeUI.deviceUI.x,
				workspace.devicePane.y + nodeUI.y + nodeUI.deviceUI.y);
			g.lineTo(
				workspace.devicePane.x + workspace.devicePane.mouseX,
				workspace.devicePane.y + workspace.devicePane.mouseY);
		}

		override public function endDrag(event : Event) : void {
			super.endDrag(event);

			var g : Graphics = workspace.temporaryPane.graphics;
			g.clear();

			var connTarget : Object = event.target;
			if (connTarget is NodeBody) {
				var node1 : Object = dragTarget.parent.node;
				var node2 : Object = connTarget.parent.node;
				if (node1 is InputNode && node2 is OutputNode) {
					node2.connectTo(node1);
				} else if (node1 is OutputNode && node2 is InputNode) {
					node1.connectTo(node2);
				}
			}
		}
	}
}