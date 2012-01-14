package com.d_project.ui {
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Label extends UIBase {

		private var _gutter : Number = 2;
		
		private var _paddingTop : Number = 2;
		private var _paddingBottom : Number = 2;
		private var _paddingLeft : Number = 4;
		private var _paddingRight : Number = 4;
		
		private var _labelField : TextField;
		private var _button : DisplayObject;
		
		private var _selected : Boolean = false;
		
		public function Label(label : String, button : DisplayObject = null, editable : Boolean = false) {
			
			_labelField = new TextField();
			_labelField.defaultTextFormat =
				new TextFormat("_sans", 16, null, true);
			_labelField.autoSize = TextFieldAutoSize.NONE;

			if (editable) {
				_labelField.type = TextFieldType.INPUT;
			} else {
				_labelField.type = TextFieldType.DYNAMIC;
				_labelField.mouseEnabled = false;
			}

			_labelField.text = label;
			addChild(_labelField);
			
			_button = button;
			if (_button != null) {
				addChild(_button);
			}
		}
		
		public function set text(value : String) : void {
			_labelField.text = value;	
		}
		
		public function get text() : String {
			return _labelField.text;
		}
		
		public function set selected(value : Boolean) : void {
			if (_selected == value) return;
			_selected = value;
			invalidate();
		}
		
		public function get selected() : Boolean {
			return _selected;
		}
		
		public function getPreferredSize() : Object {
			
			var width : Number = _labelField.textWidth + _gutter * 2;
			var height : Number = _labelField.textHeight + _gutter * 2;
			
			if (_button) {
				width += _button.width;
				height = Math.max(height, _button.height);
			}
			
			width += _paddingLeft + _paddingRight;
			height += _paddingTop + _paddingBottom;
			
			return { width: width, height: height };
		}
		
		override protected function update(g : Graphics) : void {
			
			drawBody(g);
			
			_labelField.width = width - (_paddingLeft + _paddingRight);
			if (_button) {
				_labelField.width -= _paddingRight;
				_labelField.width -= _button.width;				
			}
			_labelField.height = _labelField.textHeight + _gutter * 2;
			_labelField.x = _paddingLeft;
			_labelField.y = (height - _labelField.height) / 2;
			
			if (_button) {
				_button.x = width - _paddingRight - _button.width;
				_button.y = (height - _button.height) / 2;
			}
			
			if (_labelField.type == TextFieldType.INPUT) {
				g.lineStyle(1, 0x666666);
				g.beginFill(0xffffff);
				g.drawRect(
					_labelField.x,
					_labelField.y,
					_labelField.width - 1,
					_labelField.height - 1);
				g.endFill();
			}
		}
		
		protected function drawBody(g : Graphics) : void {
			g.lineStyle();
			g.beginFill(0xcccccc);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
	}
}
	