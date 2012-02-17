package {

	import com.adobe.images.PNGEncoder;
	import com.d_project.simcir.core.buildInDevice.DeviceRef;
	import com.d_project.simcir.ui.DeviceBody;
	import com.d_project.simcir.ui.DeviceUI;
	import com.d_project.simcir.ui.Workspace;
	import com.d_project.util.Base64;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * simcir
	 * @author kazuhiko arase
	 */
	[SWF(backgroundColor="0xffffff", frameRate="24")]
	public class simcir extends Sprite {

		private var _ws : Workspace;

		public function simcir() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event : Event) : void {

			// setup stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// create workspace
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
			// standalone
			var sa : String = stage.loaderInfo.parameters.sa;

			if (e) {
				_ws.editable = (e == "true");
			}
			
			if (s) {
				_ws.showNonVisuals = (s == "true");
			}

			// setup context menu
			contextMenu = createContextMenu(sa == "true");
			
			addChild(_ws);
		}
		
		private function createContextMenu(standalone : Boolean) : ContextMenu {
			var cm : ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			if (standalone) {
				var items : Array = [];
				items.push(createMenuItem("Save Circuit", save) );
				items.push(createMenuItem("Load Circuit", load) );
				cm.customItems = items;
			}
			return cm;
		}
		
		private function createMenuItem(caption : String, handler : Function) : ContextMenuItem {
			var item : ContextMenuItem = new ContextMenuItem(caption);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event : Event) : void {
				handler();
			} );
			return item;
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
				_ws.loadToolboxUrl(t);
			}
//			_ws.loadToolbox("BasicSet.xml");
			
			if (tl) {
				_ws.loadToolboxListUrl(tl);
			}			
//			_ws.loadToolboxList("/toolbox-list.xml");
			
			if (l) {
				_ws.loadLibraryUrl(l);
			}
//			_ws.loadLibrary("library.xml");
			
			if (c) {
				_ws.loadCircuitUrl(c);
			}
//			_ws.loadCircuit("simcir.xml");
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
			var url : String = deviceUI.device.params["url"];
			ExternalInterface.call(o, url);
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
		
		private function save() : void {
			var ref : FileReference = new FileReference();
			ref.save(toXMLString(_ws.xml), "Circuit" + getTimestamp() +".xml");
		}
		
		private function load() : void {
			var ref : FileReference = new FileReference();
			ref.addEventListener(Event.SELECT, function(event : Event) : void {
				ref.load();
			} );
			ref.addEventListener(Event.COMPLETE, function(event : Event) : void {
				_ws.loadCircuitXml(new XML(ref.data) );
			} );
			ref.browse([new FileFilter("Circuit File", "*.xml")]);
		}
		
		private static function toXMLString(xml : XML) : String {
			return xml.toXMLString();
		}
		
		private static function toImgString(bmp : BitmapData) : String {
			return Base64.encode(PNGEncoder.encode(bmp) )
		}
		
		private static function getTimestamp(date : Date = null) : String {
			if (date == null) {
				date = new Date();
			}
			var ymd : String = '' + (
				date.getFullYear() * 10000 +
				(date.getMonth() + 1) * 100 +
				date.getDate() );
			var hms : String = '' + (
				(1000 + date.getHours() ) * 10000 +
				date.getMinutes() * 100 +
				date.getSeconds() );
			return ymd + hms.substring(2);
		}
	}
}

