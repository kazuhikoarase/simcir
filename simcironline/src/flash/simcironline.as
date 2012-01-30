package {

	import com.adobe.images.PNGEncoder;
	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.simcir.core.buildInDevice.DeviceRef;
	import com.d_project.simcir.ui.DeviceBody;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.Workspace;
	import com.d_project.util.Base64;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenu;

	/**
	 * simcironline
	 * @author kazuhiko arase
	 */
	[SWF(backgroundColor="0xffffff", frameRate="24")]
	public class simcironline extends Sprite {

		private var _ws : Workspace;

		public function simcironline() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event : Event) : void {

			// setup stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// setup context menu
			var cm : ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			contextMenu = cm;
			
			createWorkspace();

			// externals
			ExternalInterface.addCallback("getData", getData);
			ExternalInterface.addCallback("setShowNonVisuals", setShowNonVisuals);
		} 

		private function createWorkspace() : void {
			
			_ws = new Workspace();
			_ws.addEventListener(Event.ADDED_TO_STAGE,
				ws_addedToStageHandler);
			_ws.addEventListener(Event.ENTER_FRAME,
				ws_enterFrameHandler);
			_ws.addEventListener(MouseEvent.DOUBLE_CLICK,
				ws_doubleClickHandler);

			// editable
			var e : String = stage.loaderInfo.parameters.e;
			// showNonVisuals
			var s : String = stage.loaderInfo.parameters.s;

			if (e) {
				_ws.editable = (e == "true");
			}
			
			if (s) {
				_ws.showNonVisuals = (s == "true");
			}
			
			addChild(_ws);
		}
		
		private function ws_addedToStageHandler(event : Event) : void {

			// toolbox
			var t : String = stage.loaderInfo.parameters.t;
			// toolboxList
			var tl : String = stage.loaderInfo.parameters.tl;
			// library
			var l : String = stage.loaderInfo.parameters.l;
			// circuit
			var c : String = stage.loaderInfo.parameters.c;

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
		}
		
		private function ws_enterFrameHandler(event : Event) : void {
			_ws.width = stage.stageWidth;
			_ws.height = stage.stageHeight;
		}
		
		private function ws_doubleClickHandler(event : MouseEvent) : void {

			// openCircuitHandler
			var o : String = stage.loaderInfo.parameters.o;
			if (!o) {
				return;
			}

			if (!(event.target is DeviceBody) ) {
				return;
			}
			
			var deviceUI : DeviceUI =
				event.target.parent as DeviceUI;
			if (!(deviceUI.device is DeviceRef) ) {
				return;
			}
			
			if (deviceUI.editable && deviceUI.active) {
				//return;
			}

			// call openCircuitHandler with url.
			var ns : Namespace = DeviceLoader.NS;
			var deviceDef : XML = deviceUI.device.deviceDef;
			var url : String = deviceDef.ns::param.(@name == "url").@value;
			ExternalInterface.call(o, url);
		}
		
		private function toXMLString(xml : XML) : String {
			return xml.toXMLString();
		}
		
		private function toImgString(bmp : BitmapData) : String {
			return Base64.encode(PNGEncoder.encode(bmp) )
		}
		
		private function getData() : Object {
			
			// validate now for capture.
			_ws.deselectAll();
			_ws.validate();

			return {
				xml : toXMLString(_ws.xml),
				img : toImgString(_ws.capture(1.0) ),
				tn : toImgString(_ws.capture(0.2) ),
				tlxml : toXMLString(_ws.toolboxListXml),
				ready : _ws.ready
			}
		}
		
		private function setShowNonVisuals(value : Boolean) : void {		
			_ws.showNonVisuals = value;
		}
	}
}

