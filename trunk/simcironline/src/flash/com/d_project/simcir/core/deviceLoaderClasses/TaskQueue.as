package com.d_project.simcir.core.deviceLoaderClasses {

	import com.d_project.simcir.core.Runnable;
	import com.d_project.simcir.core.Runner;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 * TaskQueue
	 * @author kazuhiko arase
	 * Task queue to serialize loading tasks.
	 */
	public class TaskQueue implements Runnable {

		private static var _instance : TaskQueue = null;

		public static function getInstance() : TaskQueue {
			if (_instance == null) {
				_instance = new TaskQueue();
			}
			return _instance;
		}

		private var _tasks : Array = new Array();

		private var _currTask : Task = null;

		public function TaskQueue() {
			if (_instance != null) {
				throw new Error();
			}
			_instance = this;

			Runner.getInstance().register(this);
		}

		public function postTask(task : Task) : void {
			_tasks.push(task);
		}

		public function get available() : Boolean {
			// no current task and has some tasks
			return _currTask == null && _tasks.length > 0;
		}

		public function run() : void {
			_currTask = _tasks.shift();
			_currTask.addEventListener(Event.COMPLETE, task_completeHandler, false, -1);
			_currTask.addEventListener(IOErrorEvent.IO_ERROR, task_errotHandler, false, -1);
			_currTask.addEventListener(SecurityErrorEvent.SECURITY_ERROR, task_errotHandler, false, -1);
			_currTask.start();
		}

		private function task_completeHandler(event : Event) : void {
			_currTask = null;
		}

		private function task_errotHandler(event : Event) : void {
			_currTask = null;
		}
	}
}
