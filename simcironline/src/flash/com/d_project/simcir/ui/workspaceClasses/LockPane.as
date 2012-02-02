package com.d_project.simcir.ui.workspaceClasses {
	
	import com.d_project.ui.UIBase;
	
	import flash.display.Graphics;

	/**
	 * LockPane
	 * @author kazuhiko arase
	 */
	public class LockPane extends UIBase {
		
		private var _anim : Anim;
		
		public function LockPane() {
			_anim = new Anim();
			addChild(_anim);
		}
		
		public function reset() : void {		
			_anim.reset();
		}
		
		override protected function update(g : Graphics):void {

			var scale : Number = 0.1;
			var aw : Number = _anim.width * scale;
			var ah : Number = _anim.height * scale;
			_anim.x = (width - aw) / 2;
			_anim.y = (height - ah) / 2;
			_anim.scaleX = scale;
			_anim.scaleY = scale;
			
			g.beginFill(0x000000, 0.1);
			g.drawRect(0, 0, width, height);				
			g.endFill();
		}
	}
}

import com.d_project.simcir.ui.GraphicsUtil;
import com.d_project.simcir.ui.graphicsUtilClasses.Seg;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;

class Anim extends Sprite {
	
	private var _seg : Seg;

	private var _delay : int = 0;
	private var _index : int = 0;
	
	public function Anim() {

		_seg = GraphicsUtil._16SEG;

		for (var i : int = 0; i < _seg.allSegments.length; i += 1) {
			var sp : Sprite = new Sprite();
			var g : Graphics = sp.graphics;
			g.clear();
			GraphicsUtil.drawSeg(_seg, g, _seg.allSegments.charAt(i),
				0xffffff, -1, -1);
			addChild(sp);
		}
		
		reset();
		
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}

	public function reset() : void {
		_delay = 24;
		_index = 0;
		for (var i : int = 0; i < _seg.allSegments.length; i += 1) {
			var sp : Sprite = getChildAt(i) as Sprite;
			sp.alpha = 0;
		}
	}
	
	override public function get width() : Number {
		return _seg.width;
	}
	
	override public function get height() : Number {
		return _seg.height;
	}

	public function enterFrameHandler(event : Event) : void {
		
		if (_delay > 0) {
			_delay -= 1;
			return;
		}
		
		for (var i : int = 0; i < numChildren; i += 1) {
			var sp : Sprite = getChildAt(i) as Sprite;
			if (i == _index) {
				sp.alpha = 1;
			} else {		
				if (sp.alpha > 0) {
					sp.alpha = Math.max(0, sp.alpha - 0.05);
				}
			}
		}
		
		_index = (_index + 1) % _seg.allSegments.length;
	}
}
