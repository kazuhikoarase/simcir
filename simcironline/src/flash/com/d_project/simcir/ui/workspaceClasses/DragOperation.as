package com.d_project.simcir.ui.workspaceClasses {

	import com.d_project.simcir.ui.Workspace;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * DragOperation
	 * @author kazuhiko arase
	 */
	public class DragOperation {

		private var _workspace : Workspace;

		private var _dragTarget : Object = null;

		private var _dragPoint : Point = null;

		public function DragOperation(workspace : Workspace) {
			_workspace = workspace;
		}

		public function get workspace() : Workspace {
			return _workspace;
		}

		public function get dragTarget() : Object {
			return _dragTarget;
		}

		public function get dragPoint() : Point {
			return _dragPoint;
		}

		public function beginDrag(event : MouseEvent) : void {
			_dragTarget = event.target;
			_dragPoint = new Point(
				_dragTarget.mouseX, _dragTarget.mouseY);
		}

		public function doDrag(event : MouseEvent) : void {
		}

		public function endDrag(event : Event) : void {
		}
	}
}