package com.d_project.simcir.core {

	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;

	/**
	 * DeviceLoaderContext
	 * @author kazuhiko arase
	 */
	public class DeviceLoaderContext {

		private var _checkPolicyFile : Boolean;
		private var _applicationDomain : ApplicationDomain;
		private var _securityDomain : SecurityDomain;

		public function DeviceLoaderContext(
			checkPolicyFile : Boolean = false,
			applicationDomain : ApplicationDomain = null,
			securityDomain : SecurityDomain = null
		) {
			_checkPolicyFile = checkPolicyFile;
			_applicationDomain = applicationDomain;
			_securityDomain = securityDomain;
		}

		public function get checkPolicyFile() : Boolean {
			return _checkPolicyFile;
		}
		public function get applicationDomain() : ApplicationDomain {
			return _applicationDomain;
		}
		public function get securityDomain() : SecurityDomain {
			return _securityDomain;
		}
	}
}