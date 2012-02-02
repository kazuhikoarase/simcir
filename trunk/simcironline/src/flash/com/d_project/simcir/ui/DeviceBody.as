package com.d_project.simcir.ui {

	import com.d_project.ui.UIBase;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;

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

			var mat : Matrix = new Matrix();
			mat.createGradientBox(width, height, Math.PI / 2);

			g.lineStyle(2, deviceUI.selected?
				UIConstants.SELECTED_BORDER_COLOR:
				UIConstants.BORDER_COLOR);

			var r : Number = 0.85;
			var c : uint = deviceUI.device.color;
			var h : uint = GraphicsUtil.multiplyColor(c, 1 / r);
			var l : uint = GraphicsUtil.multiplyColor(c, r);

//			g.beginFill(c);
			g.beginGradientFill(
				GradientType.LINEAR,
				[h, c, l], [1, 1, 1], [0, 127, 255],
				mat);			
			g.drawRoundRect(0, 0, width, height, 4, 4);
			g.endFill();
			
			
			
			
		}
	}
}
