package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.core.DeviceLoader;
	import com.d_project.ui.UIBase;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;

	[Event(name="change", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * ToolboxList
	 * @author kazuhiko arase
	 */
	public class ToolboxList extends UIBase {

		private var _xml : XML = <simcir xmlns={DeviceLoader.NS}/>;

		private var _ready : Boolean = false;

		private var _selectedIndex : int = -1;
		
		private var _itemsValid : Boolean = false;
		
		private var _defaultURL : String = "http://";
		
		private var _addToolboxListItem : ToolboxListItem = null;
		
		public function ToolboxList() {
		}

		public function get xml() : XML {
			return _xml;
		}

		public function get ready() : Boolean {
			return _ready;
		}
		
		public function set selectedIndex(value : int) : void {
			if (_selectedIndex == value) return;
			_selectedIndex = value;
			invalidate();
		}
		
		public function get selectedIndex() : int {
			return _selectedIndex;
		}
		
		public function load(url : String) : void {
			_ready = false;
			/* deep loading causes fatal error.
			var loader : DeviceLoader = new DeviceLoader();
			loader.addEventListener(Event.COMPLETE, function(event : Event) : void {
			_xml = loader.xml;
			invalidateItems();
			invalidate();
			dispatchEvent(event);
			} );
			loader.loadUrl(url);
			*/
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.load(new URLRequest(url) );
		}
		
		private function loader_completeHandler(event : Event) : void {
			var loader : URLLoader = event.target as URLLoader;
			_xml = new XML(loader.data);
			_ready = true;
			invalidateItems();
			invalidate();
			dispatchEvent(event);
		}
		
		public function getToolboxUrlAt(index : int) : String {
			var ns : Namespace = DeviceLoader.NS;
			return _xml.
				ns::device[index].
				ns::param.(@name == 'url').@value;
		}
		
		public function get numToolboxes() : int {
			var ns : Namespace = DeviceLoader.NS;
			return _xml.ns::device.length();
		}
		
		private function item_clickHandler(event : Event) : void {
			if (!(event.target is ToolboxListItem) ) {
				return;	
			}
			var item : ToolboxListItem = event.target as ToolboxListItem;
			selectedIndex = getChildIndex(item);
			dispatchEvent(new Event(Event.CHANGE) );	
		}
		
		private function addBtn_clickHandler(event : Event) : void {
			addNewItem();
		}
		
		private function item_keyDownHandler(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.ENTER) {
				addNewItem();
			}			
		}

		private function addNewItem() : void {

			var item : ToolboxListItem = _addToolboxListItem;

			var url : String = item.text;

			if (!url || url == _defaultURL) {
				return;
			}
			
			var loader : DeviceLoader = new DeviceLoader();
			loader.addEventListener(Event.COMPLETE, function(event : Event) : void {
				var label : String = String(loader.xml.@title) || "untitled";				
				_xml.appendChild(<device xmlns={DeviceLoader.NS} label={label} type="Ref">
					<param name="url" value={url}/> 
				</device>);
				invalidateItems();
				invalidate();
			} );
			loader.loadUrl(url);
		}
		
		private function rmvBtn_clickHandler(event : Event) : void {
			
			// remove clicked item
			
			var item : ToolboxListItem = event.target.parent as ToolboxListItem;
			var index : int = getChildIndex(item);

			if (selectedIndex == index) {
				selectedIndex = -1;
			}
			
			delete _xml.children()[index];
			invalidateItems();
			invalidate();
		}

		protected function invalidateItems() : void {
			_itemsValid = false;	
		}
		
		protected function validateItems() : void {
			
			if (_itemsValid) {
				return;
			}
			
			createItems();
			
			_itemsValid = true;
			
			invalidate();
		}
		
		override public function validate() : void {
			validateItems();
			super.validate();
		}
		
		private function createItems() : void {
			
			removeAllChildren();
			
			var item : ToolboxListItem;
			
			var ns : Namespace = DeviceLoader.NS;
			var toolboxes : XMLList = _xml.ns::device;
			
			for (var i : int = 0; i < toolboxes.length(); i += 1) {
				
				var toolbox : XML = toolboxes[i];
				
				var rmvBtn : UIBase = new IconButton(IconButton.REMOVE);
				rmvBtn.addEventListener(MouseEvent.CLICK, rmvBtn_clickHandler);
				
				item = new ToolboxListItem(toolbox.@label, rmvBtn, false);
				item.addEventListener(MouseEvent.CLICK, item_clickHandler);
				addChild(item);
			}
			
			// add url
			
			var addBtn : UIBase = new IconButton(IconButton.ADD);
			addBtn.addEventListener(MouseEvent.CLICK, addBtn_clickHandler);
			
			_addToolboxListItem = new ToolboxListItem(_defaultURL, addBtn, true);
			_addToolboxListItem.mouseEnabled = false;
			_addToolboxListItem.addEventListener(KeyboardEvent.KEY_DOWN, item_keyDownHandler);
			addChild(_addToolboxListItem);
		}

		override protected function update(g : Graphics) : void {
			
			super.update(g);

			var y : Number = 0;
			var i : int = 0;
			
			forEachChild(function(b : ToolboxListItem) : void {

				var selected : Boolean = (selectedIndex == i);
				
				var size : Object = b.getPreferredSize();
				
				b.x = 0;
				b.y = y;
				b.width = width;
				b.height = size.height;
				b.selected = selected;
				
				y += b.height;
				i += 1;
			} );
		}
	}
}

import com.d_project.ui.Label;

import flash.display.DisplayObject;
import flash.display.Graphics;


class ToolboxListItem extends Label {

	public function ToolboxListItem(label : String, button : DisplayObject, editable : Boolean) {
		super(label, button, editable);
	}
	
	override protected function drawBody(g : Graphics) : void {

		if (!editable) {
			g.lineStyle();
			g.beginFill(mouseDown?
				0x999999 : mouseOver?
				0xf0f0f0 : 0xdddddd);
			g.drawRect(0, 0, width, height);
			g.endFill();
		} else {
			g.lineStyle();
			g.beginFill(0xdddddd);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
	}
}
