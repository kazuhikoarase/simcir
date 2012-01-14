package com.d_project.ui {

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * ScrollPane
	 * @author kazuhiko arase
	 */
	public class ScrollPane extends UIBase {

		private var _hBar : ScrollBar;
		private var _vBar : ScrollBar;
		private var _contentPane : UIBase;
		private var _mask : Sprite;
		private var _barWidth : Number = 16;

		public function ScrollPane() {

			_contentPane = new UIBase();
			addChild(_contentPane);

			_mask = new Sprite();
			addChild(_mask);
			_contentPane.mask = _mask;

			_vBar = new ScrollBar(ScrollBar.VERTICAL);
			_vBar.addEventListener(Event.CHANGE, bar_changeHandler);
			addChild(_vBar);

			_hBar = new ScrollBar(ScrollBar.HORIZONTAL);
			_hBar.addEventListener(Event.CHANGE, bar_changeHandler);
			addChild(_hBar);
		}

		public function get hBar() : ScrollBar {
			return _hBar;
		}

		public function get vBar() : ScrollBar {
			return _vBar;
		}

		protected function get contentPane() : UIBase {
			return _contentPane;
		}

		public function set barWidth(value : Number) : void {
			if (_barWidth == value) return;
			_barWidth = value;
			invalidate();
		}

		public function get barWidth() : Number {
			return _barWidth;
		}

		private function bar_changeHandler(event : Event) : void {
			invalidate();
		}

		override protected function update(g : Graphics) : void {
			super.update(g);

			g.lineStyle();
			g.beginFill(0xffffff);
			g.drawRect(0, 0, width, height);
			g.endFill();

			// hBar
			_hBar.x = 0;
			_hBar.y = height - barWidth;
			_hBar.width = width;
			if (_hBar.visible) {
				_hBar.width -= barWidth;
			}
			_hBar.height = barWidth;

			// vBar
			_vBar.x = width - barWidth;
			_vBar.y = 0;
			_vBar.width = barWidth;
			_vBar.height = height;
			if (_hBar.visible) {
				_vBar.height -= barWidth;
			}

			// mask
			drawMask();
		}

		public function getContentRect() : Rectangle {
			var w : Number = width;
			var h : Number = height;
			if (_vBar.visible) {
				w -= barWidth;
			}
			if (_hBar.visible) {
				h -= barWidth;
			}
			return new Rectangle(0, 0, w, h);
		}

		private function drawMask() : void {
			var r : Rectangle = getContentRect();
			var g : Graphics = _mask.graphics;
			g.clear();
			g.beginFill(0x000000);
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
		}

		public function forEachContent(f : Function) : void {
			contentPane.forEachChild(f);
		}
	}
}