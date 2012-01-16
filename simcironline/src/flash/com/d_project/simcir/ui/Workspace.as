package com.d_project.simcir.ui {

	import com.d_project.simcir.core.InputNode;
	import com.d_project.simcir.core.LockManager;
	import com.d_project.simcir.core.OutputNode;
	import com.d_project.simcir.core.simcir_core;
	import com.d_project.simcir.ui.workspaceClasses.DevicePane;
	import com.d_project.simcir.ui.workspaceClasses.DragConnect;
	import com.d_project.simcir.ui.workspaceClasses.DragDevice;
	import com.d_project.simcir.ui.workspaceClasses.DragOperation;
	import com.d_project.simcir.ui.workspaceClasses.DragSelection;
	import com.d_project.simcir.ui.workspaceClasses.DragToolboxDevice;
	import com.d_project.simcir.ui.workspaceClasses.IconButton;
	import com.d_project.simcir.ui.workspaceClasses.ToolboxList;
	import com.d_project.simcir.ui.workspaceClasses.ToolboxPane;
	import com.d_project.ui.Accordion;
	import com.d_project.ui.UIBase;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	/**
	 * Workspace
	 * @author kazuhiko arase
	 */
	public class Workspace extends UIBase {

		use namespace simcir_core;

		simcir_core var toolboxesPane : Accordion;
		simcir_core var devicePane : DevicePane;
		simcir_core var connectorPane : UIBase;
		simcir_core var temporaryPane : UIBase;

		private var _popupPane : UIBase;
		private var _lockPane : UIBase;

		private var _toolboxPane : ToolboxPane;
		private var _libraryPane : ToolboxPane;
		private var _toolboxList : ToolboxList;
		
		private var _dragOp : DragOperation = null;

		public function Workspace() {

			toolboxesPane = new Accordion();
			addChild(toolboxesPane);

			var btn : UIBase = new IconButton(IconButton.DROP_DOWN);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, toolboxButton_mouseDownHandler);
			
			_toolboxPane = new ToolboxPane();
			_toolboxPane.addEventListener(Event.COMPLETE, toolboxPane_completeHandler);
//			toolboxesPane.addContent(_toolboxPane, "Toolbox", btn);
			toolboxesPane.addContent(_toolboxPane, "Toolbox");

			_libraryPane = new ToolboxPane();
			toolboxesPane.addContent(_libraryPane, "Library");

			devicePane = new DevicePane();
			addChild(devicePane);

			connectorPane = new UIBase();
			connectorPane.mouseEnabled = false;
			connectorPane.mouseChildren = false;
			addChild(connectorPane);

			temporaryPane = new UIBase();
			temporaryPane.mouseEnabled = false;
			temporaryPane.mouseChildren = false;
			addChild(temporaryPane);
			
			_popupPane = new UIBase();
			addChild(_popupPane);
			
			_lockPane = new UIBase();
			addChild(_lockPane);

			_toolboxList = new ToolboxList();
			_toolboxList.addEventListener(Event.CHANGE, toolboxList_changeHandler);
			_toolboxList.addEventListener(Event.COMPLETE, toolboxList_completeHandler);

		}
		
		public function set editable(value : Boolean) : void {
			devicePane.editable = value;
			toolboxesPane.visible = value;
		}

		public function loadCircuit(url : String) : void {
			devicePane.load(url);
		}

		public function loadToolbox(url : String) : void {
			_toolboxPane.load(url);
		}

		public function loadLibrary(url : String) : void {
			_libraryPane.load(url);
		}

		public function loadToolboxList(url : String) : void {
			_toolboxList.load(url);
		}
		
		public function get xml() : XML {
			return devicePane.xml;
		}
		
		public function capture(scale : Number = 1.0) : BitmapData {
			var bmp : BitmapData = new BitmapData(
				devicePane.width * scale,
				devicePane.height * scale, false);
			var mat : Matrix = new Matrix();
			mat.translate(-devicePane.x, -devicePane.y);
			mat.scale(scale, scale);
			bmp.draw(stage, mat);
			return bmp;
		}

		public function get ready() : Boolean {
			return devicePane.ready && _toolboxList.ready;
		}

		override protected function addedToStageHandler(event : Event) : void {
			super.addedToStageHandler(event);	
			LockManager.getInstance().addEventListener(Event.CHANGE, lockManager_changeHandler);
		}
		
		override protected function removedFromStageHandler(event : Event) : void {
			super.removedFromStageHandler(event);
			LockManager.getInstance().removeEventListener(Event.CHANGE, lockManager_changeHandler);
		}
		
		override protected function enterFrameHandler(event : Event) : void {
			super.enterFrameHandler(event);
			drawConnectors();
		}
		
		override protected function mouseDownHandler(event : MouseEvent) : void {
			super.mouseDownHandler(event);

			if (event.target is UIBase && !event.target.isDescendantOf(_popupPane) ) {
				removePopup();				
			}

			if (event.target == devicePane) {
				_dragOp = new DragSelection(this);
			} else if (event.target is DeviceBody &&
					event.target.isDescendantOf(devicePane) ) {
				_dragOp = new DragDevice(this);
			} else if (event.target is DeviceBody &&
					findToolboxPane(event.target) != null) {
				_dragOp = new DragToolboxDevice(this, 
					findToolboxPane(event.target) );
			} else if (event.target is NodeBody) {
				_dragOp = new DragConnect(this);
			} else {
				_dragOp = null;
			}

			if (_dragOp != null) {
				_dragOp.beginDrag(event);
			}
		}

		override protected function mouseDragHandler(event : MouseEvent) : void {
			super.mouseDragHandler(event);
			if (_dragOp != null) {
				_dragOp.doDrag(event);
			}
		}

		override protected function mouseUpHandler(event : Event) : void {
			super.mouseUpHandler(event);
			if (_dragOp != null) {
				_dragOp.endDrag(event);
			}
		}
		
		public function deselectAll() : void {
			devicePane.forEachChild(function(deviceUI : DeviceUI) : void {
				deviceUI.selected = false;
			} );
			toolboxesPane.forEachContent(function(toolboxPane : ToolboxPane) : void {
				toolboxPane.forEachContent(function(deviceUI : DeviceUI) : void {
					deviceUI.selected = false;
				} );
			} );
		}

		override protected function update(g : Graphics) : void {

			var toolboxWidth : Number = UIConstants.UNIT * 8;

			toolboxesPane.x = 0;
			toolboxesPane.y = 0;
			toolboxesPane.width = toolboxWidth;
			toolboxesPane.height = height;

			devicePane.x = toolboxesPane.visible? toolboxWidth : 0;
			devicePane.y = 0;
			devicePane.width = width - devicePane.x;
			devicePane.height = height - devicePane.y;

			connectorPane.x = devicePane.x;
			connectorPane.y = devicePane.y;

			g.beginFill(0xff0000);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}

		private function drawConnectors() : void {

			var g : Graphics = connectorPane.graphics;

			g.clear();
			g.lineStyle(1, UIConstants.CONNECTOR_COLOR);

			devicePane.forEachChild(function(deviceUI : DeviceUI) : void {

				var inputs : Array = deviceUI.device.inputs;
				
				for (var n : int = 0; n < inputs.length; n += 1) {
					
					var inNode : InputNode = inputs[n];
					var outNode : OutputNode = inNode.getOutputNode();
					
					if (outNode == null) {
						continue;
					}

					var inUI : NodeUI = inNode.holder as NodeUI;
					var outUI : NodeUI = outNode.holder as NodeUI;
					g.moveTo(
						inUI.x + inUI.deviceUI.x,
						inUI.y + inUI.deviceUI.y);
					g.lineTo(
						outUI.x + outUI.deviceUI.x,
						outUI.y + outUI.deviceUI.y);
				}
			} );
		}
		
		private function lockManager_changeHandler(event : Event) : void {

			if (LockManager.getInstance().locked) {

				var g : Graphics = _lockPane.graphics;
				g.clear();
				g.beginFill(0x000000, 0.1);
				g.drawRect(0, 0, width, height);				
				g.endFill();
				
				_lockPane.visible = true;

			} else {
				_lockPane.visible = false;
			}
		}
		
		private function findToolboxPane(target : *) : ToolboxPane {
			var result : ToolboxPane = null;
			toolboxesPane.forEachContent(function(toolboxPane : ToolboxPane) : void {
				if (target.isDescendantOf(toolboxPane) ) {
					result = toolboxPane;
				}
			} );
			return result;
		}
		
		private function toolboxPane_completeHandler(event : Event) : void {
			toolboxesPane.getLabelAt(0).text = _toolboxPane.title || "untitled";
		}
		
		private function addPopup(popup : DisplayObject) : void {
			_popupPane.addChild(popup);
		}	
		
		private function removePopup() : void {
			_popupPane.removeAllChildren();
		}
		
		private function toolboxButton_mouseDownHandler(event : Event) : void {

			_toolboxList.x = 0;
			_toolboxList.y = event.target.parent.height;
			_toolboxList.width = event.target.parent.width;
			
			addPopup(_toolboxList);
		}
		
		private function toolboxList_changeHandler(event : Event) : void {
			if (event.target != _toolboxList) {
				return;
			}
			removePopup();
			loadToolbox(_toolboxList.getToolboxUrlAt(
				_toolboxList.selectedIndex) );
		}
		
		private function toolboxList_completeHandler(event : Event) : void {
			if (_toolboxList.numToolboxes > 0) {
				_toolboxList.selectedIndex = 0;
				loadToolbox(_toolboxList.getToolboxUrlAt(
					_toolboxList.selectedIndex) );
			}
		}
		
		public function get toolboxListXml() : XML {
			return _toolboxList.xml;
		}
	}
}
