/**
 * ui
 * @author Kazuhiko Arase
 */

(function(XS) {

	var _ui = {};

	var noop = function() {
		return false;
	};

	_ui.disableSelection = function(elm) {
		if (typeof(elm.onselectstart) != 'undefined') {
			elm.onselectstart = noop;
		} else {
			elm.onmousedown = noop;
		}
	};

	_ui.getViewPosition = function() {
		var f = function(s) {
			return document.documentElement[s] || document.body[s];
		};
		return { x: f('scrollLeft'), y: f('scrollTop') };
	};

	_ui.getViewSize = function() {
		var f = function(s) {
			return window['inner' + s] ||
				document.documentElement['client' + s] ||
				document.body['client' + s];
		};
		return { width: f('Width'), height: f('Height') };
	};

	_ui.getBodySize = function() {
		var f = function(s) {
			return document.documentElement[s] || document.body[s];
		};
		return {width : f('scrollWidth'), height: f('scrollHeight')};
	};

	_ui.getAbsolutePosition = function(elm) {

		var p = {x: 0, y: 0};

		if (elm.getBoundingClientRect) {

			var d = _ui.getViewPosition();
 	        var r = elm.getBoundingClientRect();
		    p.x = r.left + d.x;
		    p.y = r.top + d.y;

		} else {

			var e;

			e = elm;
			while (e.offsetParent != null) {
				p.x += e.offsetLeft;
				p.y += e.offsetTop;
				e = e.offsetParent;
			}

			e = elm;
			while (e.parentNode != null) {
		 		p.x -= e.scrollLeft;
				p.y -= e.scrollTop;
				e = e.parentNode;
			}
		}

		return p;
	};

	_ui.button = function(d, label, click) {
		var bt = d('SPAN.ui-button/#text')(label);
		_ui.disableSelection(bt() );
		XS.addL(bt(), 'click', click);
		XS.addL(bt(), 'mouseover', function() {
			bt.className('ui-over ui-button-over');
		} );
		XS.addL(bt(), 'mouseout', function() {
			bt.className('ui-over ui-button-over', true);
		});
		return bt;
	};

	_ui.link = function(d, label, click) {
		var ln = d('SPAN.ui-link/#text')(label);
		_ui.disableSelection(ln() );
		XS.addL(ln(), 'click', click);
		XS.addL(ln(), 'mouseover', function() {
			ln.className('ui-link-over');
		} );
		XS.addL(ln(), 'mouseout', function() {
			ln.className('ui-link-over', true);
		});
		return ln;
	};

	_ui.lockLayer = function() {

		var _content = document.createElement('DIV');
		_content.className = 'ui-lock-layer';

		_ui.disableSelection(_content);

		var _adjust = function() {
			var bs = _ui.getBodySize();
			var vs = _ui.getViewSize();
			_content.style.left = '0px';
			_content.style.top = '0px';
			_content.style.width = Math.max(bs.width, vs.width) + 'px';
			_content.style.height = Math.max(bs.height, vs.height) + 'px';
		};

		var _lockLayer = {};
		var _opened = false;

		_lockLayer.open = function() {
			if (_opened) { return; }
			XS.addL(window, 'resize', _adjust);
			XS.addL(window, 'scroll', _adjust);
			document.body.appendChild(_content);
			_adjust();
			_opened = true;
		};

		_lockLayer.close = function() {
			if (!_opened) { return; }
			XS.rmvL(window, 'resize', _adjust);
			XS.rmvL(window, 'scroll', _adjust);
			document.body.removeChild(_content);
			_opened = false;
		};

		return _lockLayer;
	};

	_ui.dialog = function(c) {

		var _ll = _ui.lockLayer();

		var d = domBuilder('DIV.ui-dialog');
		c(d);

		var _content = d();

		var _adjust = function() {
			var vl = _ui.getViewPosition();
			var vs = _ui.getViewSize();
			var cw = _content.clientWidth;
			var ch = _content.clientHeight;
			_content.style.left = (vl.x + (vs.width - cw) / 2) + 'px';
			_content.style.top = (vl.y + (vs.height - ch) / 2) + 'px';
		};

		var _dialog = {};
		var _opened = false;

		_dialog.open = function() {
			if (_opened) { return; }
			_ll.open();
			XS.addL(window, 'resize', _adjust);
			XS.addL(window, 'scroll', _adjust);
			document.body.appendChild(_content);
			_adjust();
			_opened = true;
		};

		_dialog.close = function() {
			if (!_opened) { return; }
			XS.rmvL(window, 'resize', _adjust);
			XS.rmvL(window, 'scroll', _adjust);
			document.body.removeChild(_content);
			_ll.close();
			_opened = false;
		};

		return _dialog;
	};

	_ui.popup = function(c) {

		var d = domBuilder('DIV.ui-popup');
		c(d);

		var _content = d();

		var _close = function(event) {
			var target = XS.getEventTarget(event);
			if (XS.isChildOf(target, _owner) ||
					XS.isChildOf(target, _content) ) {
				return;
			}
			_popup.close();
		};

		var _owner = null;

		var _popup = {};
		var _opened = false;

		_popup.open = function(owner) {
			if (_opened) { return; }
			_owner = owner;
			XS.addL(document.body, 'click', _close);
			XS.addL(window, 'scroll', _close);
			document.body.appendChild(_content);
			_opened = true;
		};

		_popup.closeHandler = null;

		_popup.close = function() {
			if (!_opened) { return; }
			XS.rmvL(document.body, 'click', _close);
			XS.rmvL(window, 'scroll', _close);
			document.body.removeChild(_content);
			_opened = false;
			if (_popup.closeHandler) {
				_popup.closeHandler();
			}
		};

		_popup.measure = function() {

			if (!_opened) {
				_content.style.visibility = 'hidden';
				document.body.appendChild(_content);
			}

			var size = {
				width: _content.offsetWidth,
				height: _content.offsetHeight};

			if (!_opened) {
				document.body.removeChild(_content);
				_content.style.visibility = 'visible';
			}

			return size;
		};

		_popup.content = _content;

		return _popup;
	};

	_ui.alert = function() {

		var _buttons = ['YES', 'NO', 'OK', 'CANCEL'];

		// NLS
		var _labels = {
			YES: 'Yes',
			NO: 'No',
			OK: 'Okay',
			CANCEL: 'Cancel'
		};

		var _alert = function(message, buttons) {

			buttons = buttons || _alert.OK;

			var _close = null;

			var _dlg = _ui.dialog(function(d) {

				var m = d('SPAN');
				XS.forEach(message.split(/\n/g) )(function(msg, i) {
					if (i > 0) {
						m('BR');
					}
					m('#text')(msg);
				} );

				var btns = d('DIV.ui-alert-buttons');

				var addBtn = function(b) {
					var bid = _alert[b];
					if ( (bid & buttons) == 0) {
						return;
					}
					_ui.button(btns, _labels[b], function() {
						_dlg.close();
						if (_close) {
							_close(bid);
						}
					} );
				};

				for (var i = 0; i < _buttons.length; i += 1) {
					addBtn(_buttons[i]);
				}
			} );

			_dlg.open();

			return function(closeHandler) {
				_close = closeHandler;
			};
		};

		_alert.YES = 1;
		_alert.NO = 2;
		_alert.OK = 4;
		_alert.CANCEL = 8;

		return _alert;

	}();

	XS.ui = _ui;
}(XS) );
