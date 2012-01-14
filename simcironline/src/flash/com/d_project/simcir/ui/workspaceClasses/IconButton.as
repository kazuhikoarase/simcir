package com.d_project.simcir.ui.workspaceClasses {
	
	import com.d_project.ui.UIBase;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;
	
	/**
	 * IconButton
	 * @author kazuhiko arase
	 */
	public class IconButton extends UIBase {
		
		public static const ADD : String = "add";
		public static const REMOVE : String = "remove";
		public static const DROP_DOWN : String = "dropDown";
		
		private var _type : String;

		private var _symbolColor : uint = 0x000000;
		
		public function IconButton(type : String) {
			_type = type;
			width = 16;
			height = 16;
		}

		override protected function mouseDownHandler(event : MouseEvent) : void {
			super.mouseDownHandler(event);
			event.stopPropagation();
		}
		
		override protected function mouseOverHandler(event : MouseEvent) : void {
			super.mouseOverHandler(event);
			event.stopPropagation();
		}

		override protected function update(g : Graphics) : void {
			
			g.lineStyle();

			g.beginFill(mouseDown?
				0x999999 : mouseOver?
				0xf0f0f0 : 0xcccccc);
			g.drawCircle(width / 2, height / 2, width / 2);
			g.endFill();
			
			switch(_type) {
			case ADD :
				drawAdd(g);
				break;
			case REMOVE :
				drawRemove(g);
				break;
			case DROP_DOWN :
				drawDropDown(g);
				break;
			default :
				break;
			}
		}
		
		private function drawAdd(g : Graphics) : void {
			
			var l : Number = 5;
			var s : Number = 1;
			
			g.beginFill(_symbolColor);
			g.drawRect(width / 2 - l, height / 2 - s, l * 2, s * 2);
			g.endFill();

			g.beginFill(_symbolColor);
			g.drawRect(width / 2 - s, height / 2 - l, s * 2, l * 2);
			g.endFill();
		}
		
		private function drawRemove(g : Graphics) : void {
			
			var l : Number = 5;
			var s : Number = 1;
			
			g.beginFill(_symbolColor);
			g.drawRect(width / 2 - l, height / 2 - s, l * 2, s * 2);
			g.endFill();
		}

		private function drawDropDown(g : Graphics) : void {

			var w : Number = 4;
			var t : Number = 3;
			var b : Number = 4;
			
			g.beginFill(_symbolColor);
			g.moveTo(width / 2, height / 2 + b);
			g.lineTo(width / 2 - w, height / 2 - t);
			g.lineTo(width / 2 + w, height / 2 - t);
			g.lineTo(width / 2, height / 2 + b);
			g.endFill();
		}
	}
}
