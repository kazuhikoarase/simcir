/**
 * Client Side
 * @author Kazuhiko Arase
 */

var trace = function() {

	var _trc = null;

	return function() {
		var s = '';
		for (var i = 0; i < arguments.length; i += 1) {
			var a = '' + arguments[i];
			if (s && a) {
				s += ' ';
			}
			s += a;
		}
		var doc = document;
		if (_trc == null) {
			_trc = doc.body.appendChild(doc.createElement('DIV') );
		}
		_trc.appendChild(doc.createElement('DIV') ).
			appendChild(doc.createTextNode(s) );
	};
}();

var XS = function() {

	var _XS = function(id){
		return document.getElementById(id) || {};
	};

	var _crtX = null;
	var _addL = null;
	var _rmvL = null;

	_XS.addL = function(target, type, listener) {
		if (_addL == null) {
			if (typeof target.addEventListener == 'function') {
				_addL = function(target, type, listener) {
					target.addEventListener(type, listener, false);
				};
			} else {
				_addL = function(target, type, listener) {
					target.attachEvent('on' + type, listener);
				};
			}
		}
		_addL(target, type, listener);
	};

	_XS.rmvL = function(target, type, listener) {
		if (_rmvL == null) {
			if (typeof target.removeEventListener == 'function') {
				_rmvL = function(target, type, listener) {
					target.removeEventListener(type, listener, false);
				};
			} else {
				_rmvL = function(target, type, listener) {
					target.detachEvent('on' + type, listener);
				};
			}
		}
		_rmvL(target, type, listener);
	};

	_XS.crtX = function() {

		if (_crtX != null) {
			return _crtX();
		}

		if (typeof XMLHttpRequest == 'function') {

			// native (FF etc...)
			_crtX = function() { return new XMLHttpRequest(); };
			return _crtX();

		} else if (typeof XMLHttpRequest == 'object') {

			// native (Safari)
			_crtX = function() { return new XMLHttpRequest(); };
			return _crtX();

		} else {

			// legacy IE

			var ax = [
				'Msxml2.XMLHTTP',
				'Microsoft.XMLHTTP'
			];

			for (var i = 0; i < ax.length; i += 1) {
				try {
					var test = function() { return new ActiveXObject(ax[i]); };
					var xhr = test();
					_crtX = test;
					return xhr;
				} catch(e) {}
			}
		}
	};

	_XS.invoke = function(sn, fn, lk) {

		return function() {

			var args = new Array();
			for (var i = 0; i < arguments.length; i += 1) {
				args.push(arguments[i]);
			}

			return function(res) {

				var ll;

				if (lk) {
					ll = _XS.ui.lockLayer();
					ll.open();
				}

				var xhr = _XS.crtX();

				xhr.onreadystatechange = function() {

					if (xhr.readyState != 4) {
						// not completed.
						return;
					}

					if (lk) {
						ll.close();
					}

					if (xhr.status != 200) {
						// not ok
						//alert('SC:' + xhr.status);
						document.body.innerHTML = xhr.responseText.replace
							(/^.+<body>|<\/body>.+$/gi,'');
						return;
					}

					res(json.deserialize(xhr.responseText) );
				};

				xhr.open('POST', 'service', true);
				xhr.setRequestHeader('Content-Type', 'text/plain;charset=Utf-8');
				xhr.send(json.serialize({sn: sn, fn: fn, args: args}) );
			};
		};
	};

	_XS.removeAllChildren = function(elm) {
		while (elm.firstChild) {
			elm.removeChild(elm.firstChild);
		}
	};

	_XS.setNode = function(parent, elm) {
		_XS.removeAllChildren(parent);
		parent.appendChild(elm);
	};

	_XS.isChildOf = function(elm, owner) {
		while (elm != null) {
			if (elm == owner) {
				return true;
			}
			elm = elm.parentNode;
		}
		return false;
	};

	_XS.getEventTarget = function(event) {
		return event['target']? event['target'] : event['srcElement'];
	};
	
	_XS.className = function(e, c, rmv) {

		var newCls = '';

		var newClsNms = c.split(/\s+/g);
		var newClsMap = {};
		for (var i = 0; i < newClsNms.length; i += 1) {
			newClsMap[newClsNms[i]] = true;
		}

		var curClsNms = (e.className || '').split(/\s+/g);

		for (var i = 0; i < curClsNms.length; i += 1) {
			var cls = curClsNms[i];
			if (newClsMap[cls]) {
				continue;
			}
			newCls += '\u0020';
			newCls += cls;
		}

		if (!rmv) {
			for (var i = 0; i < newClsNms.length; i += 1) {
				newCls += '\u0020';
				newCls += newClsNms[i];
			};
		}

		e.className = newCls;
	};
	
	return _XS;
}();