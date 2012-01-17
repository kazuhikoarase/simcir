package com.d_project.simcir.ui {

	import flash.text.TextFormat;

	/**
	 * UIConstants
	 * @author kazuhiko arase
	 * @private
	 */
	public class UIConstants {

		public function UIConstants() {
			throw new Error();
		}

		public static const UNIT : int = 16;

		public static const INPUT_NODE_COLOR : uint = 0xffcc00;

		public static const OUTPUT_NODE_COLOR : uint = 0xffffff;

		public static const DEVICE_COLOR : uint = 0xcccccc;

		public static const BORDER_COLOR : uint = 0x666666;

		public static const SELECTED_BORDER_COLOR : uint = 0x0000ff;

		public static const CONNECTOR_COLOR : uint = 0x0000ff;

		public static const NODE_BORDER_COLOR : uint = 0x000000;

		public static const OVER_NODE_BORDER_COLOR : uint = 0xffff00;

		public static const HOT_NODE_BORDER_COLOR : uint = 0xff0000;

		public static const DEFAULT_TEXT_FORMAT : TextFormat = new TextFormat("_typewriter", 12, 0x000000);
	}
}
