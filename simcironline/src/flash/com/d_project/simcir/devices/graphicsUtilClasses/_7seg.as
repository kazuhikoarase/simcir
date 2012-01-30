package com.d_project.simcir.devices.graphicsUtilClasses {

	import flash.display.Graphics;

	public class _7seg extends Seg {
		
		public function _7seg() {
			super(636, 1000, "abcdefg");
		}
		
		override public function drawSegment(
			g : Graphics,
			segment : String,
			color : int
		) : void {
			
			if (color < 0) {
				return;
			}
			
			var data : Array = _SEGMENT_DATA[segment];
			var numPoints : int = data.length / 2;
			
			g.beginFill(color);
			
			for (var i : int = 0; i < numPoints; i += 1) {
				
				var x : Number = data[i * 2];
				var y : Number = data[i * 2 + 1];
				
				if (i == 0) {
					g.moveTo(x, y);
				} else {
					g.lineTo(x, y);
				}
			}
			
			g.endFill();
		}
		
		override public function drawPoint(
			g : Graphics,
			color: int
		) : void {
			if (color < 0) {
				return;
			}
			g.beginFill(color);
			g.drawCircle(542, 840, 46);
			g.endFill();
		}

		private static const _SEGMENT_DATA : Object = {
			"a" : [575, 138, 494, 211, 249, 211, 194, 137, 213, 120, 559, 120],
			"b" : [595, 160, 544, 452, 493, 500, 459, 456, 500, 220, 582, 146],
			"c" : [525, 560, 476, 842, 465, 852, 401, 792, 441, 562, 491, 516],
			"d" : [457, 860, 421, 892, 94, 892, 69, 864, 144, 801, 394, 801],
			"e" : [181, 560, 141, 789, 61, 856, 48, 841, 96, 566, 148, 516],
			"f" : [241, 218, 200, 453, 150, 500, 115, 454, 166, 162, 185, 145],
			"g" : [485, 507, 433, 555, 190, 555, 156, 509, 204, 464, 451, 464]
		}
	}
}