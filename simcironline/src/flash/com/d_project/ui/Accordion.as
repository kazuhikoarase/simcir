package com.d_project.ui {

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.MouseEvent;

	/**
	 * Accordion
	 * @author kazuhiko arase
	 */
	public class Accordion extends UIBase {
		
		private var _labelPane : UIBase;
		
		private var _contentPane : UIBase;
		
		private var _selectedIndex : int = 0;

		public function Accordion() {

			_contentPane = new UIBase();
			addChild(_contentPane);

			_labelPane = new UIBase();
			addChild(_labelPane);
		}

		override protected function mouseDownHandler(event : MouseEvent) : void {
			super.mouseDownHandler(event);
			if (event.target is AccordionLabel) {
				selectedIndex = _labelPane.getChildIndex(event.target as DisplayObject);
			}
		}

		public function addContent(content : UIBase, label : String, button : DisplayObject = null) : void {

			_labelPane.addChild(new AccordionLabel(label, button) );
			
			_contentPane.addChild(content);
		}
		
		public function get numContents() : int {
			return _labelPane.numChildren;
		}
		
		public function getLabelAt(index : int) : Label {
			return _labelPane.getChildAt(index) as Label;
		}

		public function getContentAt(index : int) : UIBase {
			return _contentPane.getChildAt(index) as UIBase;
		}
		
		public function forEachContent(f : Function) : void {
			_contentPane.forEachChild(f);
		}
		
		public function set selectedIndex(value : int) : void {
			if (_selectedIndex == value) return;
			_selectedIndex = value;
			invalidate();
		}

		public function get selectedIndex() : int {
			return _selectedIndex;
		}
		
		override protected function update(g : Graphics) : void {

			var contentHeight : Number = height;
			_labelPane.forEachChild(function(l : AccordionLabel) : void {
				contentHeight -= l.getPreferredSize().height;
			} );
			
			var y : Number = 0;
			for (var i : int = 0; i < numContents; i += 1) {
				
				var l : AccordionLabel = _labelPane.getChildAt(i) as AccordionLabel;	
				var c : UIBase = _contentPane.getChildAt(i) as UIBase;	
				
				var selected : Boolean = (selectedIndex == i);

				l.x = 0;
				l.y = y;
				l.width = width;
				l.height = l.getPreferredSize().height;
				l.selected = selected;
				y += l.height;
				
				if (selected) {
					c.x = 0;
					c.y = y;
					c.width = width;
					c.height = contentHeight;
					c.visible = true;
					y += c.height;
				} else {
					c.visible = false;
				}
			}
		}		
	}
}

import com.d_project.ui.GraphicsUtil;
import com.d_project.ui.Label;

import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;

class AccordionLabel extends Label {

	public function AccordionLabel(label : String, button : DisplayObject) {
		super(label, button);
	}
	
	override protected function drawBody(g : Graphics) : void {
		
		g.lineStyle();

		var mat : Matrix;

		mat = new Matrix();
		mat.createGradientBox(width, height, Math.PI / 2);
		
		g.beginGradientFill(GradientType.LINEAR, 
			selected? [0x66cc66, 0x33ff33] : 
			mouseOver? [0xf0f0f0, 0xcccccc] :
			[0x999999, 0xcccccc], [1, 1], [0, 255], mat);
		g.drawRect(0, 0, width, height);
		g.endFill();
		
		mat = new Matrix();
		mat.createGradientBox(width, height / 2, Math.PI / 2);
		
		g.beginGradientFill(GradientType.LINEAR, 
			[0xffffff, 0xffffff], [1, 0.6], [0, 255], mat);
		g.drawRect(0, 0, width, height / 2);
		g.endFill();

		GraphicsUtil.draw3DRect(g, 0, 0, width, height, true);
	}
}
