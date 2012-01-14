/**
 * X Side
 * @author Kazuhiko Arase
 */

XS.forEach = function(o) {
	return function(f) {
		if (XS.isArray(o) ) {
			for (var i = 0; i < o.length; i += 1) {
				f(o[i], i);
			}
		} else {
			for (var k in o) {
				f(o[k], k);
			}
		}
	};
};

XS.isArray = function(o) {
	return o && typeof o == 'object' &&
		typeof o.length == 'number' &&
		typeof o.splice == 'function';
};

XS.format = function() {
	var s = arguments[0];
	for (var i = 1; i < arguments.length; i += 1) {
		s = s.replace(new RegExp('\\{' + (i - 1) + '\\}', 'g'), arguments[i]);
	}
	return s;
};
