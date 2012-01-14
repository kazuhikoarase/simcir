//---------------------------------------------------------------------
// DOM Builder
//
// Copyright (c) 2011 Kazuhiko Arase
//
// URL: http://www.d-project.com/
//
// Licensed under the MIT license:
//	http://www.opensource.org/licenses/mit-license.php
//
//---------------------------------------------------------------------

var domBuilder = function(doc) {

	var str = function(s) {
		return (typeof s == 'undefined')? '' : '' + s;
	};

	var isArray = function(o) {
		return typeof o.length == 'number' &&
			typeof o.splice == 'function';
	};

	var setAttrs = function(e, a) {
		for (var k in a) {
			e.setAttribute(k, a[k]);
		}
	};

	var id = function(k, n) {
		k = str(k);
		var b = n? n[n.length - 1].k : '';
		if (k.length > 0 && b.length > 0) {
			b += '/';
		}
		return b + k;
	};

	var nest = function(k, n) {
		k = str(k).replace(/\/+$/,'');
		var i = k.indexOf('/');
		if (i != -1) {
			n = nest(k.substring(0, i), n);
			n = nest(k.substring(i + 1), n);
		} else if (typeof n == 'undefined') {
		} else if (k == '') {
			// root
			n = n.slice(0, 1);
		} else if (k == '..') {
			// parent
			if (n.length > 1) {
				n = n.slice(0, n.length - 1);
			}
		} else if (k == '.') {
			// current
		} else {
			var c = n[n.length - 1];
			var o = (typeof c.v != 'undefined')? c.v[k] : undefined;
			n = n.slice();
			n.push({k: id(k, n), v: o});
		}
		return n;
	};

	var _di = function(r, p, n) {

		var _d = function() {
			return _d.node.apply(null, arguments);
		};

		// create node
		_d.node = function(t, a) {
			if (typeof t == 'undefined') {
				return p;
			}
			t = t.replace(/\/+$/,'');
			var i = t.indexOf('/');
			if (i != -1) {
				return _d.node(t.substring(0, i) ).node(t.substring(i + 1), a);
			} else if (t == '#text') {
				return function(t) {
					if (typeof t != 'undefined') {
						p.appendChild(doc.createTextNode(t) );
					}
					return _di(r, p, n);
				};
			} else if (t == '') {
				// root
				return _di(r, r, n);
			} else if (t == '..') {
				// parent
				return _di(r, p.parentNode || p, n);
			} else {

				var e;
				var i;

				if ( (i = t.indexOf('.') ) != -1) {
					e = doc.createElement(t.substring(0, i) );
					e.className = t.substring(i + 1);
				} else {
					e = doc.createElement(t);
				}

				setAttrs(e, a);

				if (p) {
					p.appendChild(e);
				}
				return _di(r || e, e, n);
			}
		};

		// attributes
		_d.attrs = function(a) {
			setAttrs(_d(), a);
			return _di(r, p, n);
		};

		// style
		_d.style = function(s) {
			var e = _d();
			for (var k in s) {
				e.style[k] = s[k];
			}
			return _di(r, p, n);
		};

		// add/remove className
		_d.className = function(c, rmv) {

			var e = _d();

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

			return _di(r, p, n);
		};

		// set root object
		_d.root = function(o, k) {
			return _di(r, p, [{k: str(k), v: o}]);
		};

		// move nest by key
		_d.nest = function(k) {
			return _di(r, p, nest(k, n) );
		};

		// call
		_d.call = function(f, idx, len) {
			var o = _d.get();
			if (typeof o == 'undefined') {
			} else if (isArray(o) ) {
				var d = _d;
				for (var i = 0; i < o.length; i += 1) {
					d = d.nest(i).call(f, i, o.length).nest('..');
				}
			} else {
				f(_di(r, p, n), idx, len);
			}
			return _di(r, p, n);
		};

		// get id
		_d.id = function(k) {
			if (n) {
				var c = nest(k || '.', n);
				return c[c.length - 1].k;
			}
			return undefined;
		};

		// get current object
		_d.get = function(k) {
			if (n) {
				var c = nest(k || '.', n);
				return c[c.length - 1].v;
			}
			return undefined;
		};

		return _d;
	};

	return _di();
}(document);
