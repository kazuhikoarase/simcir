package com.d_project.simcir.ui {

	import flash.display.DisplayObject;

	/**
	 * The UISupport interface defines methods 
	 * for user interface support of the device.
	 * @see com.d_project.simcir.core.Device
	 * @author kazuhiko arase
	 */
	public interface UISupport {

		/**
		 * Width in unit
		 */
		function get widthInUnit() : Number;

		/**
		 * Height in unit
		 */
		function get heightInUnit() : Number;

		/**
		 * Body color of a device
		 */
		function get color() : uint;
		
		/**
		 * Visual device
		 */
		function get visualDevice() : Boolean;

		/**
		 * Create a control for a device.
		 */
		function createControl() : DisplayObject;
	}
}
