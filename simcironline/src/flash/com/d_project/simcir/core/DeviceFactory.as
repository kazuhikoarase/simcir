package com.d_project.simcir.core {

	/**
	 * DeviceFactory
	 * @author kazuhiko arase
	 */
	public interface DeviceFactory {
		function createDevice(deviceDef : XML) : Device;
	}
}
