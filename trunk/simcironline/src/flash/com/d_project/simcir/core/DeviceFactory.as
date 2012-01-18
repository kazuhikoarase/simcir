package com.d_project.simcir.core {

	/**
	 * The DeviceFactory interface defines a method that create a device.
	 * @see Device
	 * @author kazuhiko arase
	 */
	public interface DeviceFactory {

		/**
		 * @param deviceDef device definition
		 * @return a device
		 */
		function createDevice(deviceDef : XML) : Device;
	}
}
