package com.d_project.simcir.device {

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * GraphicsUtil
	 * @author kazuhiko arase
	 */
	public class GraphicsUtil {

		public static function drawGlass(
			g : Graphics,
			x : Number, y : Number, radius : Number,
			color : uint, hot : Boolean = true
		) : void {

			g.lineStyle();
			g.beginFill(color);
			g.drawCircle(x, y, radius);
			g.endFill();

			drawShadow(g, x, y, radius);
			if (hot) {
				drawLight(g, x, y, radius);
			}
			drawReflect(g, x, y, radius);
		}

		private static function drawLight(
			g : Graphics,
			x : Number, y : Number, radius : Number
		) : void {

			var gradRadius : Number = radius;

			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(gradRadius, gradRadius, -2 * Math.PI * 90 / 360);
			matrix.translate(x - gradRadius / 2, y - gradRadius / 2);

			g.beginGradientFill(
				GradientType.RADIAL,
				[0xffffff, 0xffffff],
				[1, 0],
				[0x20, 0xff],
				matrix,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				0.2);
			g.drawCircle(x, y, radius);
			g.endFill();
		}

		private static function drawShadow(
			g : Graphics,
			x : Number, y : Number, radius : Number
		) : void {

			var gradRadius : Number = radius * 8;

			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(gradRadius, gradRadius / 2, -2 * Math.PI * 90 / 360);
			matrix.translate(x - gradRadius / 2, y - radius - radius * 0.04);

			g.beginGradientFill(
				GradientType.RADIAL,
				[0x000000, 0x000000],
				[0.8, 0],
				[0x0, 0x60],
				matrix,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				1.0);
			g.drawCircle(x, y, radius);
			g.endFill();
		}

		private static function drawReflect(
			g : Graphics, x : Number, y : Number, radius : Number
		) : void {

			var gradRadius : Number = radius * 8;

			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(gradRadius, radius * 4, -2 * Math.PI * 90 / 360);
			matrix.translate(x - gradRadius / 2, y - radius - radius * 0.04);

			g.beginGradientFill(
				GradientType.RADIAL,
				[0xffffff, 0xffffff],
				[0.8, 0],
				[0x0, 0x60],
				matrix,
				SpreadMethod.PAD,
				InterpolationMethod.RGB,
				1.0);

			drawCrescent(
				g, x, y, radius * 0.95,
				x, y + radius * 1.6, radius * 1.8);

			g.endFill();

		}

		private static function drawCrescent(g : Graphics,
			x1 : Number, y1 : Number, r1 : Number,
			x2 : Number, y2 : Number, r2 : Number
		) : void {

			var dx : Number = x2 - x1;
			var dy : Number = y2 - y1;

			var l : Number = Math.sqrt(dx * dx + dy * dy);

			if (l < Math.abs(r1 - r2) || l > r1 + r2) {
				return;
			}

			var t1 : Number = Math.atan2(dy, dx);
			var t2 : Number = t1 + Math.PI;

			var dt1 : Number = Math.acos( (r1 * r1 + l * l - r2 * r2) / (2 * r1 * l) );
			var dt2 : Number = Math.acos( (r2 * r2 + l * l - r1 * r1) / (2 * r2 * l) );

			drawArc(g, x1, y1, r1, t1 + dt1, t1 - dt1 + Math.PI * 2);
			drawArc(g, x2, y2, r2, t2 + dt2, t2 - dt2, false);
		}

		private static function drawArc(
			g : Graphics,
			x : Number, y : Number, r : Number,
			t1 : Number, t2 : Number,
			moveTo : Boolean = true
		) : void {

			var div : int = Math.max(1, Math.floor(Math.abs(t2 - t1) / 0.4) );
			var lastT : Number;

			for (var i : int = 0; i <= div; i += 1) {

				var t : Number = t1 + (t2 - t1) * i / div;
				var rx : Number = r * Math.cos(t) + x;
				var ry : Number = r * Math.sin(t) + y;

				if (i == 0) {
					if (moveTo) {
						g.moveTo(rx, ry);
					}
				} else {
					var cp : Point = getControlPoint(x, y, r, lastT, t);
					g.curveTo(cp.x, cp.y, rx, ry);
				}

				lastT = t;
			}
		}

		public static function getControlPoint(
			x : Number, y : Number, r : Number,
			t1 : Number, t2 : Number
		) : Point {
			var cl : Number = r / Math.cos(Math.abs(t2 - t1) / 2);
			var ct : Number = (t1 + t2) / 2;
			return new Point(
				cl * Math.cos(ct) + x,
				cl * Math.sin(ct) + y);
		}

		public static function drawBuffer(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			g.moveTo(x, y);
			g.lineTo(x + width, y + height / 2);
			g.lineTo(x, y + height);
			g.lineTo(x, y);
		}

		public static function drawAND(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			g.moveTo(x, y);
			g.curveTo(x + width, y, x + width, y + height / 2);
			g.curveTo(x + width, y + height, x, y + height);
			g.lineTo(x, y);
		}

		public static function drawOR(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			var depth : Number = width * 0.2;
			g.moveTo(x, y);
			g.curveTo(x + width, y, x + width, y + height / 2);
			g.curveTo(x + width, y + height, x, y + height);
			g.curveTo(x + depth, y + height, x + depth, y + height / 2);
			g.curveTo(x + depth, y, x, y);
		}

		public static function drawEOR(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			drawOR(g, x + 3, y, width - 3, height);
			var depth : Number = (width - 3) * 0.2;
			g.moveTo(x, y + height);
			g.curveTo(x + depth, y + height, x + depth, y + height / 2);
			g.curveTo(x + depth, y, x, y);
		}

		public static function drawNOT(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			drawBuffer(g, x, y, width - 4, height);
			g.drawCircle(x + width - 2, y + height / 2, 2);
		}

		public static function drawNAND(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			drawAND(g, x, y, width - 4, height);
			g.drawCircle(x + width - 2, y + height / 2, 2);
		}

		public static function drawNOR(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			drawOR(g, x, y, width - 4, height);
			g.drawCircle(x + width - 2, y + height / 2, 2);
		}

		public static function drawENOR(
			g : Graphics,
			x : Number, y : Number, width : Number, height : Number
		) : void {
			drawEOR(g, x, y, width - 4, height);
			g.drawCircle(x + width - 2, y + height / 2, 2);
		}

		public static function drawSegment(
			g : Graphics,
			pattern : String,
			hiColor : uint,
			loColor : uint,
			bgColor : uint
		) : Object {
			
			g.beginFill(bgColor);
			g.drawRect(0, 0, 
				_7seg.SEG_WIDTH,
				_7seg.SEG_HEIGHT);
			g.endFill();

			var on : Boolean;
			
			for (var i : int = 0; i < _7seg.ALL_SEGMENT.length; i += 1) {
				var c : String = _7seg.ALL_SEGMENT.charAt(i);
				on = (pattern != null && pattern.indexOf(c) != -1);
				_7seg.drawSegment(g, c, on? hiColor : loColor);
			}
			
			on = (pattern != null && pattern.indexOf(".") != -1);
			_7seg.drawPoint(g, on? hiColor : loColor);
			
			return {
				width: _7seg.SEG_WIDTH,
				height: _7seg.SEG_HEIGHT
			};
		}
	}
}

import flash.display.Graphics;

class _7seg {

	public static function drawSegment(
		g : Graphics,
		segment : String,
		color : uint
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
	
	public static function drawPoint(
		g : Graphics,
		color: uint
	) : void {
		if (color < 0) {
			return;
		}
		g.beginFill(color);
		g.drawCircle(542, 840, 46);
		g.endFill();
	}
	
	public static const SEG_WIDTH : Number = 636;
	public static const SEG_HEIGHT : Number = 1000;
	public static const ALL_SEGMENT : String = "abcdefg";
	
	private static const _SEGMENT_DATA : Object = {
		'a' : [575, 138, 494, 211, 249, 211, 194, 137, 213, 120, 559, 120],
		'b' : [595, 160, 544, 452, 493, 500, 459, 456, 500, 220, 582, 146],
		'c' : [525, 560, 476, 842, 465, 852, 401, 792, 441, 562, 491, 516],
		'd' : [457, 860, 421, 892, 94, 892, 69, 864, 144, 801, 394, 801],
		'e' : [181, 560, 141, 789, 61, 856, 48, 841, 96, 566, 148, 516],
		'f' : [241, 218, 200, 453, 150, 500, 115, 454, 166, 162, 185, 145],
		'g' : [485, 507, 433, 555, 190, 555, 156, 509, 204, 464, 451, 464]
	}
}
