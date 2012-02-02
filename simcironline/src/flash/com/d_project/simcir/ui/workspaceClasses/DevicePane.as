package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.simcir.core.InputNode;
	import com.d_project.simcir.core.OutputNode;
	import com.d_project.simcir.core.simcir_core;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.UIConstants;
	import com.d_project.ui.UIBase;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.utils.getTimer;

	use namespace simcir_core;

	[Event(name="complete", type="flash.events.Event")]

	/**
	 * DevicePane
	 * @author kazuhiko arase
	 */
	public class DevicePane extends UIBase {
		
		private var _title : String = "";
		
		private var _ready : Boolean = true;

		private var _editable : Boolean = true;
		
		private var _showNonVisuals : Boolean = true;

		public function DevicePane() {
		}
		
		public function get title() : String {
			return _title;
		}

		public function get ready() : Boolean {
			return _ready;
		}
		
		public function set editable(value : Boolean) : void {
			if (_editable == value) return;
			_editable = value;
			invalidate();
		}
		
		public function get editable() : Boolean {
			return _editable;
		}
		
		public function set showNonVisuals(value : Boolean) : void {
			if (_showNonVisuals == value) return;
			_showNonVisuals = value;
			invalidate();
		}

		public function get showNonVisuals() : Boolean {
			return _showNonVisuals;
		}
		
		public function loadUrl(url : String) : void {
			
			_ready = false;

			var loader : DeviceLoader = new DeviceLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.loadUrl(url);
		}
		
		public function loadXml(xml : XML) : void {
			
			_ready = false;
			
			var loader : DeviceLoader = new DeviceLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.loadXml(xml);
		}

		private function loader_completeHandler(event : Event) : void {
			
			var loader : DeviceLoader = event.target as DeviceLoader;

			removeAllChildren();
			for (var i : int = 0; i < loader.devices.length; i += 1) {
				var deviceUI : DeviceUI = new DeviceUI(loader.devices[i]);
				deviceUI.editable = editable;
				deviceUI.showNonVisuals = showNonVisuals;
				addChild(deviceUI);
			}
			adjust(true);

			_title = loader.xml.@title;
			_ready = true;

			dispatchEvent(event);
			
			invalidate();
		}

		public function get xml() : XML {

			// root
			var xml : XML = <simcir/>;
			xml.setNamespace(DeviceLoader.NS);

			// renumber device-id
			var idCount : int = 0;
			forEachChild(function(deviceUI : DeviceUI) : void {
				deviceUI.device.id = "d" + idCount;
				idCount += 1;
			} );

			forEachChild(function(deviceUI : DeviceUI) : void {
				var deviceDef : XML = deviceUI.device.deviceDef;
				deviceDef.@id = deviceUI.device.id;
				deviceDef.@x = Math.floor(deviceUI.x);
				deviceDef.@y = Math.floor(deviceUI.y);
				deviceDef.@label = deviceUI.label;
				xml.appendChild(deviceDef.copy() );
			} );

			forEachChild(function(deviceUI : DeviceUI) : void {
				var inputs : Array = deviceUI.device.inputs;
				for (var i : int = 0; i < inputs.length; i += 1) {
					var input : InputNode = inputs[i];
					var output : OutputNode = input.getOutputNode();
					if (output == null) {
						// not connected.
						continue;
					}
					var inDevId : String = deviceUI.device.id;
					var outDevId : String = output.device.id;
					var connector : XML = <connector/>;
					connector["@in"] = inDevId + "." + input.id;
					connector["@out"] = outDevId + "." + output.id;
					xml.appendChild(connector);
				}
			} );

			return xml;
		}

		override protected function update(g : Graphics) : void {
			super.update(g);

			// setup editable
			mouseEnabled = editable;
			forEachChild(function(deviceUI : DeviceUI) : void {
				deviceUI.editable = editable;
			} );

			// snv
			forEachChild(function(deviceUI : DeviceUI) : void {
				deviceUI.showNonVisuals = showNonVisuals;
			} );

			// draw background
			var p : Number = UIConstants.UNIT / 2;
			var bmp : BitmapData = new BitmapData(p, p, false, 0xffffffff);
			bmp.setPixel(0, 0, 0xcccccc);

			g.lineStyle(0, 0x999999);
			g.beginBitmapFill(bmp);
			g.drawRect(0, 0, width - 1, height - 1);
			g.endFill();
		}

		public function adjust(ignoreRegion : Boolean = false) : void {

			var pitch : Number = UIConstants.UNIT / 2;
			var fit : Function = function(n : Number) : Number {
				return Math.round(n / pitch) * pitch;
			}

			forEachChild(function(deviceUI : DeviceUI) : void {
				if (!ignoreRegion) {
					deviceUI.x = Math.max(pitch, Math.min(deviceUI.x, width - deviceUI.width - pitch) );
					deviceUI.y = Math.max(pitch, Math.min(deviceUI.y, height - deviceUI.height - pitch) );
				}
				deviceUI.x = fit(deviceUI.x);
				deviceUI.y = fit(deviceUI.y);
			} );
		}
	}
}
