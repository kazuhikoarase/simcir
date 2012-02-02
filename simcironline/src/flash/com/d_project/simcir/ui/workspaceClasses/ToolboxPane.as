package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.UIConstants;
	import com.d_project.ui.GraphicsUtil;
	import com.d_project.ui.ScrollPane;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[Event(name="complete", type="flash.events.Event")]

	/**
	 * ToolboxPane
	 * @author kazuhiko arase
	 */
	public class ToolboxPane extends ScrollPane {

		private var _title : String = "";
		
		public function ToolboxPane() {
			hBar.visible = false;
		}
		
		public function get title() : String {
			return _title;
		}

		public function loadUrl(url : String) : void {
			var loader : DeviceLoader = new DeviceLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.loadUrl(url);
		}

		private function loader_completeHandler(event : Event) : void {

			var loader : DeviceLoader = event.target as DeviceLoader;
			
			contentPane.removeAllChildren();
			for (var i : int = 0; i < loader.devices.length; i += 1) {
				var deviceUI : DeviceUI = new DeviceUI(loader.devices[i]);
				deviceUI.active = false;
				contentPane.addChild(deviceUI);
			}
			init();
			
			_title = loader.xml.@title;
			dispatchEvent(event);
		}
		
		override protected function update(g : Graphics) : void {
			super.update(g);
			GraphicsUtil.draw3DRect(g, 0, 0, width, height, false);
			layout();
		}

		public function init() : void {
			vBar.setValues(0, 1, 1, 1, 1);
			vBar.value = 0;
			layout();
		}

		private function layout() : void {

			if (contentPane.numChildren == 0) {
				return;
			}

			// measure heights
			var heights : Array = new Array();
			forEachContent(function(deviceUI : DeviceUI) : void {
				deviceUI.measure();
				heights.push(Math.round(deviceUI.height / UIConstants.UNIT + 2)
					* UIConstants.UNIT);
			} );

			var r : Rectangle = getContentRect();

			// calc max index
			var max : int = function() : int {
				var totalHeight : Number = 0;
				for (var i : int = heights.length - 1; i >= 0; i -= 1) {
					totalHeight += heights[i];
					if (totalHeight > r.height) {
						return i + 1;
					}
				}
				return heights.length - 1;
			}();

			vBar.setValues(0, max, 1, 1, 1);

			// layout
			var y : Number = 0;
			var i : int = 0;
			forEachContent(function(deviceUI : DeviceUI) : void {
				if (Math.round(vBar.value) <= i && y < r.height) {
					var h : Number = heights[i];
					deviceUI.visible = true;
					deviceUI.x = (r.width - deviceUI.width) / 2;
					deviceUI.y = y + (h - deviceUI.height) / 2;
					y += h;
				} else {
					deviceUI.visible = false;
				}
				i += 1;
			} );
		}
	}
}