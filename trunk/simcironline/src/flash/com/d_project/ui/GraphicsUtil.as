package com.d_project.ui {
	import flash.display.ColorCorrection;
	import flash.display.Graphics;

	public class GraphicsUtil {
		
		public static function draw3DRect(
			g : Graphics,
			x : Number,
			y : Number,
			width : Number,
			height : Number,
			outset : Boolean
		) : void {
			
			var dark : uint = 0x666666;
			var light : uint = 0xf0f0f0;

			// bottom, right
			var br : uint = outset? dark : light;
			
			// top, left
			var tl : uint = outset? light : dark;
			
			g.lineStyle(1, br);
			g.moveTo(x, height - 1);
			g.lineTo(width, height - 1);
			g.lineTo(width, y);
			
			g.lineStyle(1, tl);
			g.moveTo(x, height - 1);
			g.lineTo(x, y);
			g.lineTo(width - 1, y);			
		}
		
	}
}