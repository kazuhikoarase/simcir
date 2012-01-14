package com.d_project.ui {

	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Button
	 * @author kazuhiko arase
	 */
	public class Button extends UIBase {

		private var _upBackgroundColor : uint = 0xcccccc;
		private var _downBackgroundColor : uint = 0x666666;
		private var _backgroundColor : uint = _upBackgroundColor;

		public function Button() {
		}

		override protected function mouseDownHandler(event : MouseEvent) : void {
			super.mouseDownHandler(event);
			_backgroundColor = _downBackgroundColor;
			invalidate();
		}

		override protected function mouseUpHandler(event : Event) : void {
			super.mouseUpHandler(event);
			_backgroundColor = _upBackgroundColor;
			invalidate();
		}

		override protected function update(g : Graphics) : void {

			g.lineStyle();
			g.beginFill(_backgroundColor);
			g.drawRect(0, 0, width, height);
			g.endFill();

			GraphicsUtil.draw3DRect(g, 0, 0, width, height, !mouseDown);
		}
	}
}
