package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.simcir_core;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.Workspace;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	use namespace simcir_core;

	/**
	 * DragSelection
	 * @author kazuhiko arase
	 */
	public class DragSelection extends DragOperation {

		public function DragSelection(workspace : Workspace) {
			super(workspace);
		}

		override public function beginDrag(event : MouseEvent) : void {
			super.beginDrag(event);
			workspace.deselectAll();
		}

		override public function doDrag(event : MouseEvent):void {
			super.doDrag(event);

			var g : Graphics =  workspace.temporaryPane.graphics;
			g.clear();

			var selection : Rectangle = new Rectangle(
				Math.min(dragPoint.x, dragTarget.mouseX),
				Math.min(dragPoint.y, dragTarget.mouseY),
				Math.abs(dragPoint.x - dragTarget.mouseX),
				Math.abs(dragPoint.y - dragTarget.mouseY) );


			g.lineStyle(1, 0x000000);
			g.drawRect(
				workspace.devicePane.x + selection.x,
				workspace.devicePane.y + selection.y,
				selection.width,
				selection.height);

			workspace.devicePane.forEachChild(function(deviceUI : DeviceUI) : void {
				deviceUI.selected = selection.intersects(
					deviceUI.getBounds(workspace.devicePane) );
			} );
		}

		override public function endDrag(event : Event) : void {
			super.endDrag(event);

			var g : Graphics =  workspace.temporaryPane.graphics;
			g.clear();
		}
	}
}