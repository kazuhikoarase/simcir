package com.d_project.ui {

	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * ScrollBar
	 * @author kazuhiko arase
	 */
	public class ScrollBar extends UIBase {

		public var MIN_BAR_SIZE : Number = 16;

		public static const HORIZONTAL : String = "horizontal";
		public static const VERTICAL : String = "vertical";

		private var _orientation : String;
		private var _incButton : Button;
		private var _decButton : Button;
		private var _barButton : Button;

		private var _value : Number = 1;

		private var _min : Number = 1;
		private var _max : Number = 10;
		private var _bar : Number = 2;
		private var _unitIncrements : Number = 1;
		private var _pageIncrements : Number = 2;

		private var _buttonSize : Number = 0;
		private var _barAreaSize : Number = 0;

		private var _dragTarget : Object = null;
		private var _dragPoint : Point = null;

		private var _timer : Timer = null;

		public function ScrollBar(orientation : String) : void {

			switch (orientation) {
			case HORIZONTAL :
				_orientation = orientation;
				break;
			case VERTICAL :
				_orientation = orientation;
				break;
			default :
				throw new Error(orientation);
			}

			_incButton = new Button();
			addChild(_incButton);
			_decButton = new Button();
			addChild(_decButton);
			_barButton = new Button();
			addChild(_barButton);
		}

		public function get orientation() : String {
			return _orientation;
		}

		public function set value(value : Number) : void {
			_value = Math.max(_min, Math.min(value, _max) );
			invalidate();
		}

		public function get value() : Number {
			return _value;
		}

		public function setValues(
			min : Number,
			max : Number,
			bar : Number,
			unitIncrements : Number,
			pageIncrements : Number
		) : void {
			_min = min;
			_max = max;
			_bar = bar;
			_unitIncrements = unitIncrements;
			_pageIncrements = pageIncrements;
			value = _value;
			invalidate();
		}

		override protected function mouseDownHandler(event : MouseEvent) : void {
			super.mouseDownHandler(event);

			if (event.target == _barButton) {
				_dragTarget = _barButton;
				_dragPoint = new Point(
					_dragTarget.mouseX,
					_dragTarget.mouseY);
			} else if (event.target == _incButton) {
				doIncrement(function() : void {
					value += _unitIncrements; } );
			} else if (event.target == _decButton) {
				doIncrement(function() : void {
					value -= _unitIncrements; } );
			} else if (event.target == this) {
				switch (orientation) {
				case HORIZONTAL :
					if (mouseX < _barButton.x) {
						doIncrement(function() : void {
							value -= _pageIncrements; } );
					} else {
						doIncrement(function() : void {
							value += _pageIncrements; } );
					}
					break;
				case VERTICAL :
					if (mouseY < _barButton.y) {
						doIncrement(function() : void {
							value -= _pageIncrements; } );
					} else {
						doIncrement(function() : void {
							value += _pageIncrements; } );
					}
					break;
				default :
					throw new Error(orientation);
				}
			}
		}

		private function doIncrement(inc : Function) : void {

			var incWithEvent : Function = function() : void {
				inc();
				dispatchEvent(new Event(Event.CHANGE) );
			};

			incWithEvent();

			var delay : int = 5;

			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, function(event : TimerEvent) : void {
				if (delay > 0) {
					delay -= 1;
					return;
				}
				incWithEvent();
			} );
			_timer.start();
		}

		override protected function mouseDragHandler(event : MouseEvent) : void {
			super.mouseDragHandler(event);

			if (_dragTarget == null) {
				return;
			}

			var barPos : Number = 0;

			switch (orientation) {
			case HORIZONTAL :
				barPos = _barButton.x + _dragTarget.mouseX - _dragPoint.x;
				break;
			case VERTICAL :
				barPos = _barButton.y + _dragTarget.mouseY - _dragPoint.y;
				break;
			default :
				throw new Error(orientation);
			}

			value = (barPos - _buttonSize) *
				(_max - _min + _bar) / _barAreaSize + _min;
			dispatchEvent(new Event(Event.CHANGE) );
		}

		override protected function mouseUpHandler(event : Event) : void {
			super.mouseUpHandler(event);

			_dragTarget = null;
			_dragPoint = null;

			if (_timer != null) {
				_timer.stop();
				_timer = null;
			}
		}

		override protected function update(g : Graphics) : void {
			super.update(g);

			g.lineStyle();
			g.beginFill(0xf0f0f0);
			g.drawRect(0, 0, width, height);
			g.endFill();

			switch (orientation) {
			case HORIZONTAL :
				_buttonSize = Math.min(height, width / 2);
				_barAreaSize = width - _buttonSize * 2;
				_incButton.x = width - height;
				_incButton.y = 0;
				_incButton.width = _buttonSize;
				_incButton.height = height;
				_decButton.x = 0;
				_decButton.y = 0;
				_decButton.width = _buttonSize;
				_decButton.height = height;
				break;
			case VERTICAL :
				_buttonSize = Math.min(width, height / 2);
				_barAreaSize = height - _buttonSize * 2;
				_incButton.x = 0;
				_incButton.y = height - width;
				_incButton.width = width;
				_incButton.height = _buttonSize;
				_decButton.x = 0;
				_decButton.y = 0;
				_decButton.width = width;
				_decButton.height = _buttonSize;
				break;
			default :
				throw new Error(orientation);
			}

			var barSize : Number = int(_barAreaSize *_bar /
				(_max - _min + _bar) );

			var barPos : Number =  _buttonSize + (_barAreaSize - barSize) *
				(_value - _min) / (_max - _min);

			_barButton.visible = _barAreaSize >= MIN_BAR_SIZE &&
				_max != _min;

			if (_barButton.visible) {
				switch (orientation) {
				case HORIZONTAL :
					_barButton.x = barPos;
					_barButton.y = 0;
					_barButton.width = barSize;
					_barButton.height = height;
					break;
				case VERTICAL :
					_barButton.x = 0;
					_barButton.y = barPos;
					_barButton.width = width;
					_barButton.height = barSize;
					break;
				default :
					throw new Error(orientation);
				}
			}
		}
	}
}