package com.d_project.ui {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * UIBase
	 * @author kazuhiko arase
	 */
	public class UIBase extends Sprite {

		private var _width : Number = 100;
		private var _height : Number = 100;
		
		private var _valid : Boolean = false;
		
		private var _mouseDown : Boolean = false;
		private var _mouseOver : Boolean = false;
		
		private var _stage : Stage = null;
		
		public function UIBase() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		override public function get width() : Number {
			return _width;
		}

		override public function set width(value : Number) : void {
			if (_width == value) return;
			_width = value;
			invalidate();
		}

		override public function get height() : Number {
			return _height;
		}

		override public function set height(value : Number) : void {
			if (_height == value) return;
			_height = value;
			invalidate();
		}

		public function toFront() : void {
			if (parent != null) {
				var p : DisplayObjectContainer = parent;
				p.removeChild(this);
				p.addChild(this);
			}
		}

		public function get mouseDown() : Boolean {
			return _mouseDown;
		}

		public function get mouseOver() : Boolean {
			return _mouseOver;
		}

		protected function addedToStageHandler(event : Event) : void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		protected function removedFromStageHandler(event : Event) : void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		protected function enterFrameHandler(event : Event) : void {
			if (_valid) {
				return;
			}
			validate();
		}

		public function validate() : void {

			if (_valid) {
				return;
			}

			var g : Graphics = graphics;
			g.clear();
			update(g);

			forEachChild(function(child : DisplayObject) : void {
				if (child is UIBase) {
					UIBase(child).validate();
				}
			} );

			_valid = true;
		}

		public function invalidate() : void {
			_valid = false;
			if (parent is UIBase) {
				UIBase(parent).invalidate();
			}
		}

		protected function update(g : Graphics) : void {
		}

		protected function mouseDownHandler(event : MouseEvent) : void {
			if (_mouseDown) return;
			_stage = stage;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
			_mouseDown = true;
			invalidate();
		}

		protected function mouseDragHandler(event : MouseEvent) : void {
		}

		protected function mouseUpHandler(event : Event) : void {
		}

		private function mouseRelease(event : Event) : void {
			if (!_mouseDown) return;
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseLeaveHandler);
			_stage = null;
			_mouseDown = false;
			mouseUpHandler(event);
			invalidate();
		}

		private function stage_mouseMoveHandler(event : MouseEvent) : void {
			mouseDragHandler(event);
		}

		private function stage_mouseUpHandler(event : MouseEvent) : void {
			mouseRelease(event);
		}

		private function stage_mouseLeaveHandler(event : Event) : void {
			mouseRelease(event);
		}

		protected function mouseOverHandler(event : MouseEvent) : void {
			_mouseOver = true;
			invalidate();
		}

		protected function mouseOutHandler(event : MouseEvent) : void {
			_mouseOver = false;
			invalidate();
		}

		public function isAncestorOf(descendant : *) : Boolean {
			var comp : DisplayObject = descendant.parent;
			while (comp != null) {
				if (comp == this) {
					return true;
				}
				comp = comp.parent;
			}
			return false;
		}

		public function isDescendantOf(ancestor : *) : Boolean {
			var comp : DisplayObject = this.parent;
			while (comp != null) {
				if (comp == ancestor) {
					return true;
				}
				comp = comp.parent;
			}
			return false;
		}

		public function forEachChild(f : Function) : void {
			for (var i : int = 0; i < numChildren; i += 1) {
				f(getChildAt(i) );
			}
		}

		public function removeAllChildren() : void {
			while (numChildren > 0) {
				removeChildAt(numChildren  -1);
			}
		}
	}
}