package com.d_project.simcir.ui.graphicsUtilClasses {

	import flash.display.Graphics;

	/**
	 * Seg
	 * @author kazuhiko arase
	 */
	public class Seg {
		
		private var _width : Number;	
		private var _height : Number;	
		private var _allSegments : String;
		
		public function Seg(width : Number, height : Number, allSegments : String){
			_width = width;
			_height = height;
			_allSegments = allSegments;
		}
		
		public function get width() : Number {
			return _width;
		}

		public function get height() : Number {
			return _height;
		}

		public function get allSegments() : String {
			return _allSegments;
		}
		
		public function drawSegment(
			g : Graphics,
			segment : String,
			color : int
		) : void {
		}

		public function drawPoint(
			g : Graphics,
			color: int
		) : void {
		}
	}
}