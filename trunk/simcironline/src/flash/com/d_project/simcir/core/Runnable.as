package com.d_project.simcir.core {

	/**
	 * Runnable
	 * @author kazuhiko arase
	 */
	public interface Runnable {

		function get available() : Boolean;

		function run() : void;
	}
}