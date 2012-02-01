package com.d_project.simcir.devices.devGraphicsUtilClasses {

	import flash.display.Graphics;

	public class _16seg extends Seg {

		public function _16seg() {
			super(690, 1000, "abcdefghijklmnop");
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
			g.drawCircle(610, 900, 30);
			g.endFill();
		}

		private static const _SEGMENT_DATA : Object = {
			"a" : [255, 184, 356, 184, 407, 142, 373, 102, 187, 102],
			"b" : [418, 144, 451, 184, 552, 184, 651, 102, 468, 102],
			"c" : [557, 190, 507, 455, 540, 495, 590, 454, 656, 108],
			"d" : [487, 550, 438, 816, 506, 898, 573, 547, 539, 507],
			"e" : [281, 863, 315, 903, 500, 903, 432, 821, 331, 821],
			"f" : [35, 903, 220, 903, 270, 861, 236, 821, 135, 821],
			"g" : [97, 548, 30, 897, 129, 815, 180, 547, 147, 507],
			"h" : [114, 455, 148, 495, 198, 454, 248, 189, 181, 107],
			"i" : [233, 315, 280, 452, 341, 493, 326, 331, 255, 200],
			"j" : [361, 190, 334, 331, 349, 485, 422, 312, 445, 189, 412, 149],
			"k" : [430, 316, 354, 492, 432, 452, 522, 334, 547, 200],
			"l" : [354, 502, 408, 542, 484, 542, 534, 500, 501, 460, 434, 460],
			"m" : [361, 674, 432, 805, 454, 691, 405, 550, 351, 509],
			"n" : [265, 693, 242, 816, 276, 856, 326, 815, 353, 676, 343, 518],
			"o" : [255, 546, 165, 671, 139, 805, 258, 689, 338, 510],
			"p" : [153, 502, 187, 542, 254, 542, 338, 500, 278, 460, 203, 460]
		}
	}
}