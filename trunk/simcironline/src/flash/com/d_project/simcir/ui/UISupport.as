package com.d_project.simcir.ui {

	import flash.display.DisplayObject;

	/**
	 * UISupport
	 * @author kazuhiko arase
	 */
	public interface UISupport {

		function get widthInUnit() : Number;

		function get heightInUnit() : Number;

		function get color() : uint;

		function createControl() : DisplayObject;
	}
}
