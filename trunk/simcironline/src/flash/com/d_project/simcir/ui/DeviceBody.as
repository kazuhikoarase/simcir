package com.d_project.simcir.ui {

	import com.d_project.ui.UIBase;

	import flash.display.Graphics;

	/**
	 * DeviceBody
	 * @author kazuhiko arase
	 */
	public class DeviceBody extends UIBase {

		public function DeviceBody() {
			doubleClickEnabled = true;
		}

		override protected function update(g : Graphics) : void {

			var deviceUI : DeviceUI = parent as DeviceUI;

			g.lineStyle(2, deviceUI.selected?
				UIConstants.SELECTED_BORDER_COLOR:
				UIConstants.BORDER_COLOR);
			g.beginFill(deviceUI.device.color);
			g.drawRoundRect(0, 0, width, height, 4, 4);
			g.endFill();
		}
	}
}
