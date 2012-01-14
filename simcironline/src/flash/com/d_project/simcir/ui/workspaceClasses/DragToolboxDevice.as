package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.simcir.core.simcir_core;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.Workspace;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * DragToolboxDevice
	 * @author kazuhiko arase
	 */
	public class DragToolboxDevice extends DragOperation {

		use namespace simcir_core;

		private var _toolboxPane : ToolboxPane;
		private var _dragEnd : Boolean = false;
		private var _newDeviceUI : DeviceUI = null;

		public function DragToolboxDevice(workspace : Workspace, toolboxPane : ToolboxPane) {
			super(workspace);
			_toolboxPane = toolboxPane;
		}

		override public function beginDrag(event : MouseEvent) : void {
			super.beginDrag(event);

			var deviceUI : DeviceUI = dragTarget.parent as DeviceUI;

			// select
			workspace.deselectAll();
			deviceUI.selected = true;

			var loader : DeviceLoader = new DeviceLoader();
			var xml : XML = <device/>;
			xml.appendChild(deviceUI.device.deviceDef.copy() );
			loader.addEventListener(Event.COMPLETE, function(event : Event) : void {
				if (_dragEnd) {
					// too late.
					return;
				}
				_newDeviceUI = new DeviceUI(loader.devices[0]);
				_newDeviceUI.x = deviceUI.x + _toolboxPane.x;
				_newDeviceUI.y = deviceUI.y + _toolboxPane.y;
				_newDeviceUI.selected = true;
				_newDeviceUI.validate();
				workspace.temporaryPane.addChild(_newDeviceUI);
			} );
			loader.loadXml(xml);
		}

		override public function doDrag(event : MouseEvent):void {
			super.doDrag(event);

			if (_newDeviceUI == null) {
				// not loaded yet.
				return;
			}

			var dx : Number = _newDeviceUI.mouseX - dragPoint.x;
			var dy : Number = _newDeviceUI.mouseY - dragPoint.y;
			_newDeviceUI.x += dx;
			_newDeviceUI.y += dy;
		}

		override public function endDrag(event : Event) : void {
			super.endDrag(event);

			_dragEnd = true;

			// clear temporary
			workspace.temporaryPane.removeAllChildren();

			if (!readyToAdd() ) {
				return;
			}

			// add to device pane.
			_newDeviceUI.x -= workspace.devicePane.x;
			_newDeviceUI.y -= workspace.devicePane.y;
			_newDeviceUI.selected = true;

			workspace.deselectAll();
			workspace.devicePane.addChild(_newDeviceUI);
			workspace.devicePane.adjust();
		}

		private function readyToAdd() : Boolean {
			return _newDeviceUI != null &&
				workspace.devicePane.getBounds(workspace).
				intersects(_newDeviceUI.getBounds(workspace) );
		}
	}
}