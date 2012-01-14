package {

	import com.adobe.images.PNGEncoder;
	import com.d_project.simcir.core.Device;
	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.simcir.core.buildInDevice.DeviceRef;
	import com.d_project.simcir.ui.DeviceBody;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.Workspace;
	import com.d_project.util.Base64;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;

	/**
	 * simcironline
	 * @author kazuhiko arase
	 */
	[SWF(backgroundColor="0xffffff", frameRate="24")]
	public class simcironline extends Sprite {

		private var _tf : TextField;

		private var _ws : Workspace;

		public function simcironline() {

			_tf = new TextField();
			_tf.type = TextFieldType.DYNAMIC;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = 0x00ff00;
			_tf.defaultTextFormat = new TextFormat("_typewriter", 14);
//			_tf.mouseEnabled = false;
			addChild(_tf);

			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			ExternalInterface.addCallback("getData", getData);
		}

		private function log(msg : String) : void {
			_tf.appendText(msg + "\n");
		}

		private function getData() : Object {
			return {
				xml : _ws.xml.toXMLString(),
				img : Base64.encode(
					PNGEncoder.encode(_ws.capture(1.0) ) ),
				tn : Base64.encode(
					PNGEncoder.encode(_ws.capture(0.2) ) ),
				tlxml : _ws.toolboxListXml.toXMLString()
			}
		}

		private function addedToStageHandler(event : Event) : void {

			// toolbox
			var t : String = stage.loaderInfo.parameters.t;
			// toolboxList
			var tl : String = stage.loaderInfo.parameters.tl;
			// library
			var l : String = stage.loaderInfo.parameters.l;
			// circuit
			var c : String = stage.loaderInfo.parameters.c;
			// editable
			var e : String = stage.loaderInfo.parameters.e;

			// setup stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var cm : ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			contextMenu = cm;

			_ws = new Workspace();
			_ws.addEventListener(MouseEvent.DOUBLE_CLICK, ws_doubleClickHandler);

			if (t) {
				_ws.loadToolbox(t);
			}
//			_ws.loadToolbox("BasicSet.xml");

			if (l) {
				_ws.loadLibrary(l);
			}
//			_ws.loadLibrary("library.xml");

			if (c) {
				_ws.loadCircuit(c);
			}
//			_ws.loadCircuit("simcir.xml");

			if (tl) {
				_ws.loadToolboxList(tl);
			}			
//			_ws.loadToolboxList("/toolbox-list.xml");
			
			if (e) {
				_ws.editable = (e == "true");
			}

			addChildAt(_ws, 0);

			var layout : Function = function() : void {
				_ws.width = stage.stageWidth;
				_ws.height = stage.stageHeight;
			};

			layout();

			addEventListener(Event.ENTER_FRAME, function(event : Event) : void {
				layout();
			} );
		}
		
		private function ws_doubleClickHandler(event : MouseEvent) : void {

			// openCircuitHandler
			var o : String = stage.loaderInfo.parameters.o;
			if (!o) {
				return;
			}

			if (event.target is DeviceBody) {
				
				var deviceUI : DeviceUI =
					event.target.parent as DeviceUI;

				if (!deviceUI.editable && deviceUI.device is DeviceRef) {
					var ns : Namespace = DeviceLoader.NS;
					var deviceDef : XML = deviceUI.device.deviceDef;
					var url : String = deviceDef.ns::param.(@name == "url").@value;
					ExternalInterface.call(o, url);
				}
			}
		}
	}
}

