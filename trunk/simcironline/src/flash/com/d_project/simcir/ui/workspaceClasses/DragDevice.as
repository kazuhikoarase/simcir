package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.simcir_core;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.Workspace;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * DragDevice
	 * @author kazuhiko arase
	 */
	public class DragDevice extends DragOperation {

		use namespace simcir_core;

		private var _dragCanceled : Boolean = false;

		public function DragDevice(workspace : Workspace) {
			super(workspace);
		}

		override public function beginDrag(event : MouseEvent) : void {
			super.beginDrag(event);

			var deviceUI : DeviceUI = dragTarget.parent as DeviceUI;

			if (event.ctrlKey) {
				// selection toggle only
				deviceUI.selected = !deviceUI.selected;
			} else {

				// select
				if (!deviceUI.selected) {
					// single selection
					workspace.deselectAll();
					deviceUI.selected = true;
					// to front.
					deviceUI.toFront();
				}
			}

			if (!deviceUI.selected || !deviceUI.editable) {
				_dragCanceled = true;
			}
		}

		override public function doDrag(event : MouseEvent):void {
			super.doDrag(event);

			if (_dragCanceled) {
				return;
			}

			var dx : Number = dragTarget.mouseX - dragPoint.x;
			var dy : Number = dragTarget.mouseY - dragPoint.y;

			workspace.devicePane.forEachChild(function(deviceUI : DeviceUI) : void {
				if (deviceUI.selected) {
					deviceUI.x += dx;
					deviceUI.y += dy;
				}
			} );
		}

		override public function endDrag(event : Event) : void {
			super.endDrag(event);

			if (_dragCanceled) {
				return;
			}

			if (readyToRemove() ) {
				var selected : Array = getSelected();
				for (var i : int = 0; i < selected.length; i += 1) {
					dispose(selected[i]);
				}
			}

			workspace.devicePane.adjust();
		}

		private function readyToRemove() : Boolean {
			var readyToRemove : Boolean = false;
			workspace.devicePane.forEachChild(function(deviceUI : DeviceUI) : void {
				if (deviceUI.selected) {
					workspace.toolboxesPane.forEachContent(function(toolboxPane : ToolboxPane) : void {
						if (toolboxPane.getBounds(workspace).
							intersects(deviceUI.getBounds(workspace) ) ) {
							readyToRemove = true;
						}
					} );
				}
			} );
			return readyToRemove;
		}

		private function getSelected() : Array {
			var selected : Array = new Array();
			workspace.devicePane.forEachChild(function(deviceUI : DeviceUI) : void {
				if (deviceUI.selected) {
					selected.push(deviceUI);
				}
			} );
			return selected;
		}

		private function dispose(deviceUI : DeviceUI) : void {
			var i : int = 0;
			var inputs : Array = deviceUI.device.inputs;
			var outputs : Array = deviceUI.device.outputs;
			for (i = 0; i < inputs.length; i += 1) {
				inputs[i].disconnect();
			}
			for (i = 0; i < outputs.length; i += 1) {
				outputs[i].disconnect();
			}
			workspace.devicePane.removeChild(deviceUI);
			deviceUI.device.destroy();
		}
	}
}