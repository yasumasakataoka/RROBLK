/*[AdSide/DOCLIX common scripts library]*/

/*[check string]*/
String.prototype.has = function (s) {
	var x;
	this.indexOf(s) != -1 ? x = true : x = false;
	return x;
}

String.prototype.is = function (s) {
	var x;
	this == s ? x = true : x = false;
	return x;
}

/*[reverse string]*/
String.prototype.reverse = function () {
	var r = '';
	for (var i = this.length-1; i>=0; i--) {
		r += this.charAt(i);
	}
	return r;
}

var doclix_lib = {
	/*[get elements by...]*/
	_iD : function (s) { /*[by ID]*/
		var e, d = document, i = 'getElementById';
		d[i](s) ? e = d[i](s) : e = false; return e;
	},
	_tN : function (s, obj) { /*[by tag name]*/
		var els = [], gTN = 'getElementsByTagName';
		s = s || '*'; obj = obj || document; els = obj[gTN](s);
		return els;
	},
	_cN : function (s_cn, s_tn, obj) { /*[by class name]*/
		var els = [], c_els = [], gTN = 'getElementsByTagName', cN ='className';
		s_tn = s_tn || '*'; obj = obj || document; els = obj[gTN](s_tn);
		for (var i = 0; i < els.length; i++) {
			if (els[i][cN].has(s_cn)) {
				c_els.push(els[i]);
			}
		}
		return c_els;
	},
	_tAV: function (s_tn, s_an, s_av, obj) { /*[by tag attribute name and/or value]*/
		var dx_l = doclix_lib, els = [], a_els = [], gTN = 'getElementsByTagName', gA = 'getAttribute', r = 'replace';
		s_tn = s_tn || '*';
		obj = obj || document;
		els = obj[gTN](s_tn);
		if (dx_l.ua.is('IE7') || dx_l.ua.is('IEold')) {s_an == 'class' ? s_an = 'className' : s_an = s_an;} /*[special case for IE6-7]*/
		for (var i = 0; i < els.length; i++) {
			if (s_an && s_av) {
				if (els[i][gA](s_an)) {
					if (s_an == 'style') {/*[Firefox rearranges CSS styles, so it is safer to check for each rule separately]*/
						if (!dx_l.ua.has('IE') || (dx_l.ua.has('IE') && els[i][gA](s_an).cssText != '')) {/*[IE thinks that every tag has a style object attached to it, so we only check those which are not empty]*/
							var css = s_av[r](/\b0pt|0px\b/gi, '0');/*[FF treats "0" as "0pt", IE treats "0" as "0px"...]*/
							css = css[r](/;$/, '');/*[remove trailing ";"]*/
							css = css[r](/\s{2,}/g, ' ');
							css = css[r](/\:|,|\(|\)/g, ' ');
							css = css[r](/\s/g, '[\\s\\:\\(\\),]+');
							var a_av = css.split(';');
							var css_matches = 0;
							for (var j = 0; j < a_av.length; j++) {
								if (a_av[j] != '') {
									var re = new RegExp(a_av[j], 'i');
									if (dx_l.ua.has('IE')) {/*[special case for IE style object]*/
										if (re.test(els[i][gA](s_an).cssText[r](/\b0pt|0px\b/gi, '0'))) {
											css_matches++;
										}
									} else {
										if (re.test(els[i][gA](s_an)[r](/\b0pt|0px\b/gi, '0'))) {
											css_matches++;
										}
									}
								}
							}
							if (css_matches == a_av.length) {
								a_els.push(els[i]);
							}
						}
					} else {
						if (els[i][gA](s_an).has(s_av)) {
							a_els.push(els[i]);
						}
					}
				}
			} else if (s_an && !s_av) {
				if (els[i][gA](s_an)) {
					a_els.push(els[i]);
				}
			} else if (!s_an) {
				a_els.push(els[i]);
			}
		}
		return a_els;
	},
	/*[create...]*/
	_cE : function (s) {return document.createElement(s);},
	_cT : function (s) {return document.createTextNode(s);},
	/*[get or set element's text]*/
	_txt : function (obj, str) {
		var tC = 'textContent', iT = 'innerText';
		if (str) {
			if (obj[tC]) {
				obj[tC] = str;
			} else if (obj[iT]) {
				obj[iT] = str;
			}
		} else {
			if (obj[tC]) {
				return obj[tC];
			} else if (obj[iT]) {
				return obj[iT];
			}
		} 
	},
	/*[timeouts and intervals]*/
	_xI: function (n) {
		if (n) {
			if (!isNaN(n)) {
				clearInterval(n);
			} else if (typeof n == 'object') {
				for (var i = 0; i < n.length; i++) {
					clearInterval(n[i]);
				}
			}
		}
	},
	_xT: function (n) {
		if (n) {
			if (!isNaN(n)) {
				clearTimeout(n);
			} else if (typeof n == 'object') {
				for (var i = 0; i < n.length; i++) {
					clearTimeout(n[i]);
				}
			}
		}
	},
	/*[read css]*/
	_css : function (obj, css_s, ie_css_s) { /*[read CSS properties]*/
		var w = window, gCS = 'getComputedStyle', cS = 'currentStyle';
		if (w[gCS]) {
			return w[gCS](obj, null).getPropertyValue(css_s);
		} else if (obj[cS]) {
			return ie_css_s ? obj[cS][ie_css_s] : obj[cS][css_s];
		}
	},
	/*[inflate array]*/
	_inflate_array : function (a, n, i) {
		if (a) {
			var j = i || 0;
			while (a.length > 0 && a.length < n) {
				a.push(a[j]);
				j++;
			}
		}
	},
	/*[preload images]*/
	_preload_images : function (s, p) {
		var r = s.split(','), p = p || '', h = document.location.protocol, d = (h == 'https:' ? (document.domain == 'publisher.doclix.com' ? 'publisher.doclix.com' : 'track.doclix.com') : 'ads.doclix.com');
		for (var i = 0; i < r.length; i ++) {
			var img = new Image();
			img.src = h + '//' + d + '/adserver/serve/img/' + p + r[i]; //document.body.appendChild(img);
		}
	},
	/*[cookie]*/
	cookie : {
		_write : function (name, value, hours) {
			if (hours) {
				var date = new Date();
				date.setTime(date.getTime() + (hours * 60 * 60 * 1000));
				var expires = '; expires=' + date.toGMTString();
			} else {
				var expires = '; expires=Thu, 01-Jan-1970 00:00:01 GMT';/*[delete cookie]*/
			}
			document.cookie = name + '=' + value + expires + '; path=/';
		},
		_read : function (name) {
			var name_eq = name + '=';
			var ca = document.cookie.split(';');
			for (var i = 0; i < ca.length; i++) {
				var c = ca[i];
				while (c.charAt(0) == ' ') c = c.substring(1, c.length);
				if (c.indexOf(name_eq) == 0) return c.substring(name_eq.length, c.length);
			}
			return null;
		}
	},
	_add_event : function (obj, evt, fnc) {
		if (obj.addEventListener) {
			obj.addEventListener(evt, fnc, false);
		} else if (obj.attachEvent) {
			obj['e' + evt + fnc] = fnc;
			obj[evt + fnc] = function () {obj['e' + evt + fnc](window.event);}
			obj.attachEvent( 'on'+evt, obj[evt + fnc] );
		} else {
			evt = 'on' + evt;
			if (typeof obj[evt] == 'function') {
				var oevt = obj[evt];
				obj[evt] = function () {
					oevt(); return fnc();
				}
			} else {
				obj[evt] = fnc;
			}
		}
	},
	_load_file : function (fsrc, ftype, force, chset) {
		var d = document, dx_l = doclix_lib, ef = '', sA = 'setAttribute', aC = 'appendChild';
		typeof dx_l.load_efs == 'undefined' ? dx_l.load_efs = '' : dx_l.load_efs = dx_l.load_efs;
		if (!dx_l.load_efs.has (fsrc) || force == true) { /*[check to see if this object has not already been added to page before proceeding, or force reload]*/
			if (ftype == 'script' || (!ftype && fsrc.has('.js'))) {
				ef = dx_l._cE('script');
				ef[sA]('type', 'text/javascript');
				ef[sA]('src', fsrc);
				ef[sA]('async', 'async');
				if (chset) {
					ef[sA]('charset', chset);
				}
			} else if (ftype == 'style' || (!ftype && fsrc.has('.css'))) {
				ef = dx_l._cE('link');
				ef[sA]('rel', 'stylesheet');
				ef[sA]('type', 'text/css');
				ef[sA]('href', fsrc);
			}
		}
		if (ef != '') {
			if (dx_l._tN('head').length > 0) {
				dx_l._tN('head')[0][aC](ef); /*[if there is no head, most browsers create one, except Safari and Opera, those will throw an error.]*/
			} else {
				document.body[aC](ef);
			}
			dx_l.load_efs += fsrc + ' '; /*[remember this object as being already added to page]*/
		}
	},
	_init_iframe : function (id, url, pN, cN, st, fn) {
		var dx_l = doclix_lib, 	f = dx_l._cE('iframe'), sA = 'setAttribute', gA = 'getAttribute', s = 'style';
		f[sA]('id', id);
		f[sA]('name', id);
		f.marginWidth = f.marginHeight = f.frameBorder = '0';
		f.scrolling = 'no';
		f.allowTransparency = true;
		f[s].visibility = 'hidden';
		if (cN) f.className = cN;
		if (st) f[sA]('style', st);
		dx_l._add_event(f, 'load', function () {
			f[s].visibility = 'visible';
			if (typeof fn == 'function' && !f[gA]('fn')) {
				fn();
				f[sA]('fn', 'called');
			}
		});
		try {
			if (pN) pN.appendChild(f);
			var cd = (f.contentDocument ? f.contentDocument : f.contentWindow.document);
			cd.open();
			cd.write('<body style="background-color:transparent;"' + (url ? ' onload="document.location.replace(\'' + url +'\')">' : '>') + '<\/body>');
			cd.close();
		} catch (e) {
			if (url) f.src = url;
			if (pN) pN.appendChild(f);
		}
		return f;
	},
	home : (document.location.protocol == 'https:' ? (document.domain == 'publisher.doclix.com' ? 'https://publisher.doclix.com' : 'https://track.doclix.com') : 'http://ads.doclix.com'),
	msg_t_urls : '',
	ad_t_urls : '',
	_trace : function (t_type, t_url, t_img, no_trace) {
		var dx_l = doclix_lib;
		if (!no_trace) {
			t_url = t_url.substr(t_url.indexOf('redir.jsp?p=') + 10);
			var r = Math.floor(Math.random() * 10001);
			switch (t_type) {
				case 'message':
					if (!dx_l.msg_t_urls.has(t_url)) {
						t_img.src = dx_l.home + '/adserver/CntImprImg?type=msg&' + t_url + '&r=' + r;
						dx_l.msg_t_urls += t_url + '|';
					}
					break;
				case 'ad':
					if (!dx_l.ad_t_urls.has(t_url)) {
						t_img.src = dx_l.home + '/adserver/CntImprImg?type=ad&' + t_url + '&r=' + r;
						dx_l.ad_t_urls += t_url + '|';
					}
					break;
			}
		}
	},
	/*[viewport props]*/
	vp : {
		mX : 0, /*[mouse x]*/
		mY : 0, /*[mouse y]*/
		vpW : 0, /*[viewport width]*/
		vpH : 0, /*[viewport height]*/
		bW : 0, /*[body width]*/
		bH : 0, /*[body height]*/
		psX : 0, /*[page scroll left]*/
		psY : 0, /*[page scroll top]*/
		boX : 0, /*[body offset x]*/
		boY : 0 /*[body offset y]*/
	},
	_view_port : function () {
		var d = document, dx_l = doclix_lib, w = window, dE = 'documentElement', cH = 'clientHeight', cW = 'clientWidth', iH = 'innerHeight', iW = 'innerWidth', sH = 'scrollHeight', sW = 'scrollWidth', oH = 'offsetHeight', oW = 'offsetWidth', oL = 'offsetLeft', oT = 'offsetTop', sT = 'scrollTop', sL = 'scrollLeft';
		if (d[cH] && d[cW]) { /*[some browsers]*/
			dx_l.vp.vpW = d[cW];
			dx_l.vp.vpH = d[cH];
		} else if (w[iH] && w[iW]) { /*[standards-aware browsers]*/
			dx_l.vp.vpW = w[iW];
			dx_l.vp.vpH = w[iH];
		} else if (d[dE] && (d[dE][cW] || d[dE][cH] )) { /*[IE 6+ in standards-complaint mode]*/
			dx_l.vp.vpW = d[dE][cW];
			dx_l.vp.vpH = d[dE][cH];
		} else if (d.body && (d.body[cW] || d.body[cH])) { /*[IE in quirks mode]*/
			dx_l.vp.vpW = d.body[cW];
			dx_l.vp.vpH = d.body[cH];
		}
		dx_l.vp.bW = Math.max(d.body[sW],d.body[oW],d[dE][sW],d[dE][oW]);
		dx_l.vp.bH = Math.max(d.body[sH],d.body[oH],d[dE][sH],d[dE][oH]);
		dx_l.vp.psX = Math.max(d.body[sL],d[dE][sL]);
		dx_l.vp.psY = Math.max(d.body[sT],d[dE][sT]);
		/*[check for the rare case if document.body is offset in relation to the viewport]*/
		var b_pos = dx_l._css(d.body, 'position', 'position');
		if (b_pos == 'relative') {
			if (dx_l.ua.has('IE')) {
				if (!isNaN(d.body[oL])) {dx_l.vp.boX = d.body[oL];}
			} else { /*[one can only guess, since Mozilla and WebKit incorrectly state computed style "auto" as "0" for the body margin]*/
				var b_W = parseInt(dx_l._css(d.body, 'width'));
				if (!isNaN(b_W) &&dx_l.vp.vpW > b_W) {
					dx_l.vp.boX = parseInt((dx_l.vp.vpW - b_W) / 2);
				}
			}
		} else if (b_pos == 'absolute') {		
			if (dx_l.ua.has('IE')) {
				if (!isNaN(d.body[oL])) {dx_l.vp.boX = d.body[oL];}
				if (!isNaN(d.body[oT])) {dx_l.vp.boY = d.body[oT];}
			} else {
				var b_W	= parseInt(dx_l._css(d.body, 'width'));
				var b_H	= parseInt(dx_l._css(d.body, 'height'));
				var b_T	= parseInt(dx_l._css(d.body, 'top'));
				var b_L	= parseInt(dx_l._css(d.body, 'left'));
				var b_R	= parseInt(dx_l._css(d.body, 'right'));
				var b_B	= parseInt(dx_l._css(d.body, 'bottom'));
				if (!isNaN(b_L)) {
					dx_l.vp.boX = b_L;
				} else if (!isNaN(b_W) && !isNaN(b_R)) {
					dx_l.vp.boX = dx_l.vp.vpW - (b_W + b_R);
				}
				if (!isNaN(b_T)) {
					dx_l.vp.boY = b_T;
				} else if (!isNaN(b_H) && !isNaN(b_B)) {
					dx_l.vp.boY = dx_l.vp.vpH - (b_H + b_B);
				}
			}
		}
		return dx_l.vp.vpW, dx_l.vp.vpH, dx_l.vp.bW, dx_l.vp.bH, dx_l.vp.psY, dx_l.vp.psX, dx_l.vp.boX, dx_l.vp.boY;
	},
	_find_mouse : function (event) {
		doclix_lib.vp.mX = event.clientX;
		doclix_lib.vp.mY = event.clientY;
	},
	_pin_obj : function (obj) {
		var oP = 'offsetParent', oT = 'offsetTop', oL = 'offsetLeft';
		if (obj[oP]) {
			var x = y = 0, o = obj;
			do {
				x += o[oL];
				y += o[oT];
			} while (o = o[oP]);
			obj.pinL = x;
			obj.pinT = y;
		}
	},
	ua : (function () {
			var n = navigator, uA = 'userAgent', aN = 'appName', bro, d = document, dM = 'documentMode';
			if (n[uA].has('iPod')) {
				bro = 'iPod';
			} else if (n[uA].has('iPad')) {
				bro = 'iPad';
			} else if (n[uA].has('iPhone')) {
				bro = 'iPhone';
			} else if (n[aN].is('Opera')) {
				bro = 'Opera';
			} else if (n[aN].is('Microsoft Internet Explorer')) {
				if (d[dM] && d[dM] >= 7) {/*[document mode]*/
					bro = 'IE' + (d[dM] >= 7 ? d[dM] : '');
				} else {
					var re = new RegExp('MSIE ([0-9]{1,}[\.0-9]{0,})'), v;
					if (re.exec(n[uA]) != null) v = parseFloat(RegExp.$1);
					if (v < 10.0 && v >= 9.0) {bro = 'IE9';} else if ((v < 9.0 && v >= 8.0)) {bro = 'IE8';} else if (v < 8.0 && v >= 7.0) {bro = 'IE7';} else if (v < 7.0) {bro = 'IEold';} else {bro = 'IE';}
				}
			} else {
				if ((n[uA].has('Firefox')) && !(n[uA].has('Navigator'))) bro = 'Firefox';
				if (n[uA].has('Safari'))  bro = 'Safari';
				if (n[uA].has('Chrome'))  bro = 'Chrome';
				if (n[uA].has('Navigator'))  bro = 'Navigator';
			} return bro;
	})(),
	quirks : (function () {
		return (document.compatMode && document.compatMode == 'BackCompat' ? true : false);
	})(),
	/*[read setting value by control name (s_str) from string (str)]*/
	_get_setting : function (str, s_str) {
		var iO = 'indexOf';
		if (str && str[iO](s_str)!=-1) {
			var	val_str = str.substr(str[iO](s_str)+s_str.length+1);
			val_str = val_str.substr(0, val_str[iO]('|'));
			return unescape(val_str);
		} else {return false;}
	},
	/*[check for DOM completion in IE]*/
	_safe_start : function (f) {
		if (doclix_lib.ua.has('IE')) {
			(function () {
				try {
					document.documentElement.doScroll('left');
					f();
				} catch (e) {
					setTimeout(arguments.callee, 0);
				}
			})();
		} else {
			f();
		}
	},
	drag : { /*[Ad drag routines, based on dom-drag.js by Aaron Boodman (c) 2001. This code is public domain.]*/
		obj: null,
		_init: function (o, oRoot, minX, maxX, minY, maxY) {
			o.onmousedown = doclix_lib.drag._start;
			o.root = oRoot && oRoot != null ? oRoot : o;
			if (isNaN(parseInt(o.root.style.left))) o.root.style.left = '0px';
			if (isNaN(parseInt(o.root.style.top))) o.root.style.top = '0px';
			o.minX = typeof minX != 'undefined' ? minX : null;
			o.minY = typeof minY != 'undefined' ? minY : null;
			o.maxX = typeof maxX != 'undefined' ? maxX : null;
			o.maxY = typeof maxY != 'undefined' ? maxY : null;
			o.root.onDragStart = new Function();
			o.root.onDragEnd = new Function();
			o.root.onDrag = new Function();
		},
		_start: function (e) {
			e = doclix_lib.drag._fix_ie(e);
			var o = doclix_lib.drag.obj = this, y = parseInt(o.root.style.top), x = parseInt(o.root.style.left);
			o.root.onDragStart(x, y);
			o.lastMouseX = e.clientX;
			o.lastMouseY = e.clientY;
			if (o.minX != null) o.minMouseX = e.clientX - x + o.minX;
			if (o.maxX != null) o.maxMouseX = o.minMouseX + o.maxX - o.minX;
			if (o.minY != null) o.minMouseY = e.clientY - y + o.minY;
			if (o.maxY != null) o.maxMouseY = o.minMouseY + o.maxY - o.minY;
			document.onmousemove = doclix_lib.drag._drag;
			document.onmouseup = doclix_lib.drag._end;
			return false;
		},
		_drag: function (e) {
			e = doclix_lib.drag._fix_ie(e);
			var o = doclix_lib.drag.obj, ey = e.clientY, ex = e.clientX, y = parseInt(o.root.style.top), x = parseInt(o.root.style.left);
			var nx, ny;
			if (o.minX != null) ex = Math.max(ex, o.minMouseX);
			if (o.maxX != null) ex = Math.min(ex, o.maxMouseX);
			if (o.minY != null) ey = Math.max(ey, o.minMouseY);
			if (o.maxY != null) ey = Math.min(ey, o.maxMouseY);
			nx = x + (ex - o.lastMouseX);
			ny = y + (ey - o.lastMouseY);
			doclix_lib.drag.obj.root.style.left = nx + 'px';
			doclix_lib.drag.obj.root.style.top = ny + 'px';
			doclix_lib.drag.obj.lastMouseX = ex;
			doclix_lib.drag.obj.lastMouseY = ey;
			doclix_lib.drag.obj.root.onDrag(nx, ny);
			return false;
		},
		_end: function () {
			document.onmousemove = null;
			document.onmouseup = null;
			doclix_lib.drag.obj.root.onDragEnd(parseInt(doclix_lib.drag.obj.root.style.left), parseInt(doclix_lib.drag.obj.root.style.top));
			doclix_lib.drag.obj = null;
		},
		_fix_ie: function (e) {
			if (typeof e == 'undefined') e = window.event;
			if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
			if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
			return e;
		}
	}, /*[end drag]*/
	/*[common message animation routines]*/
	anim : {
		running : false,
		text : {
			holder : null,
			target : null,
			letter : null,
			index : null,
			printing : null,
			/*[Text Animations]*/
			_type_string : function (obj_id, msg_i, mode) {
				var dx; typeof doclix_banner != 'undefined' ? dx = doclix_banner : dx = doclix_panel;
				var dxa = dx.ad, dxaa = doclix_lib.anim, dxaat = doclix_lib.anim.text;
				if (dxaa.running == false) {
					doclix_lib._xT(dxa.turn); /*[pause rotation]*/
					dxaat.target = doclix_lib._iD(obj_id);
					dxaat.target.innerHTML = '&nbsp;';/*[clear the text]*/
					var msg_str = doclix_ad_messages[msg_i];
					dxaat.index = 0;
					dxaa.running = true;
					if (dx.ads.type == 'panel') {
							dxa._fill_panel(dxaat.target, msg_i, true);
						} else {
							dxa._fill_unit(dxaat.target, msg_i, true);
						}
					if (mode == 3 || mode == 4 || mode == 'type') {
						dxaat.holder = msg_str.split('');
					} else if (mode == 5 || mode == 6 || mode == 'push') {
						dxaat.holder = msg_str.reverse().split('');
					}
					dxaat._type_send(mode);
				}
			},
			_type_send : function (mode) {
				var dx; typeof doclix_banner != 'undefined' ? dx = doclix_banner : dx = doclix_panel;
				var dxa = dx.ad, dxaa = doclix_lib.anim, dxaat = doclix_lib.anim.text;
				if (dxaat.index < dxaat.holder.length) {
					dxaat.printing = setTimeout(function () {
						dxaat._get_letter(dxaat.target, dxaat.index, mode); 
					},	10);
				} else {
					if (dxaat.target.lastChild) dxaat.target.removeChild(dxaat.target.lastChild);
					dxaa.running = false;
					dxa._rotate(dx.ad._get_timer());
				}
			},
			_get_letter : function (trgt, ind, mode) {
				var dxaat = doclix_lib.anim.text;
				dxaat.letter = doclix_lib._cT(dxaat.holder[ind]);
				if (dxaat.letter.value == '\\') dxaat.letter.value = '';
				dxaat._type_letter(trgt,dxaat.letter,mode);
			},
			_type_letter : function (trgt, ltr, mode) {
				var dxaat = doclix_lib.anim.text;
				if (mode == 3 || mode == 4 || mode == 'type') {/*[spell out]*/
					if (trgt.lastChild) trgt.insertBefore(ltr,trgt.lastChild);
				} else if (mode == 5 || mode == 6 || mode == 'push') {/*[push in]*/
					if (trgt.firstChild) trgt.insertBefore(ltr,trgt.firstChild);
				}
				doclix_lib._xT(dxaat.printing);
				dxaat.index++;
				dxaat._type_send(mode);
			}
		},
		css : {
			font_size : undefined,
			font_unit : undefined,
			base_size : undefined,
			hide_kern : 0,
			show_kern : 0,
			change_int : 0,
			_animate : function (obj, ad_id, effect) {
				var dxaa = doclix_lib.anim, dxcss = doclix_lib.anim.css;
				if (dxaa.running == false) {
					doclix_lib._xI(dxcss.change_int);
					var ms, io;
					switch (effect) {
						case 'fade':
							ms = 25;
							if (typeof obj.fade == 'undefined') {
								dxaa._set_fade(obj,0);
							}
							if (obj.fade == 0) {
								io = 'in';
							} else {
								io = 'out';
							}
						break;
						case 'spread':
							if (typeof dxcss.show_kern == 'undefined') {
								if (!isNaN(parseInt(doclix_lib._css(obj, 'letter-spacing', 'letterSpacing')))) {
									dxcss.show_kern = parseInt(doclix_lib._css(obj, 'letter-spacing', 'letterSpacing'));
								} else {
									dxcss.show_kern = 0;
								}
							}
							dxaa._get_font(obj);
							if (dxcss.font_unit != 'px') {/*[IE situation]*/
								if (dxcss.font_unit == '%') {
									dxcss.hide_kern = Math.floor(((dxcss.font_size/100)*11)/2);
								} else if (dxcss.font_unit == 'pt') {
									dxcss.hide_kern = Math.floor(dxcss.font_size/2);
								} else if (dxcss.font_unit == 'em') {
									dxcss.hide_kern = Math.floor(dxcss.base_size*16/2);
								}
							} else {
								dxcss.hide_kern = Math.floor(dxcss.font_size/2);
							}
							ms = 25;
							if (typeof obj.kern == 'undefined') {
								dxaa._set_spread(obj,-dxcss.hide_kern);
							}
							if (obj.kern == -dxcss.hide_kern) {
								io = 'in';
							} else {
								io = 'out';
							}
						break;
						case 'zoom':
							dxaa._get_font(obj);
							ms = 10;
							if (typeof obj.fzoom == 'undefined') {
								dxaa._set_zoom(obj,0,dxcss.font_unit);
							}
							if (obj.fzoom == 0) {
								io = 'in';
							} else {
								io = 'out';
							}
						break;
					}
				dxcss.change_int = setInterval(function () {dxcss._change(obj,ad_id,effect,io)},ms);
				}
			},
			_change : function (obj, ad_id, effect, io) {
				var dx; typeof doclix_banner != 'undefined' ? dx = doclix_banner : dx = doclix_panel;
				var dxaa = doclix_lib.anim, dxcss = doclix_lib.anim.css, ad_code = parseInt(obj.getAttribute('doclix_ad'));
				switch (effect) {
					case 'fade':
					var step = 0.1;
					if (io == 'in') {
						if (obj.fade == 0) {
							dxaa.running = true;
							if (dx.ads.type == 'panel') {
								dx.ad._fill_panel(obj, ad_id);
							} else {
								dx.ad._fill_unit(obj, ad_id);
							}
						}	
						if (obj.fade < 1) {
							dxaa._set_fade(obj,parseFloat(obj.fade) + parseFloat(step));
						} else {
							dxaa._set_fade(obj,1);
							/*[switch ads]*/
							doclix_lib._xI(dxcss.change_int);
							dxaa.running = false;
							dx.ad._rotate(dx.ad._get_timer());
						}
					} else if (io == 'out') {
						if (obj.fade > 0) {
							dxaa._set_fade(obj,parseFloat(obj.fade) - parseFloat(step));
						} else {
							dxaa._set_fade(obj,0);
							dxcss._animate(obj,ad_id,effect);
						}
					}
					break;
					case 'spread':
					var step = 1;
					if (io == 'in') {
						if (obj.kern == -dxcss.hide_kern) {
							dxaa.running = true;
							if (dx.ads.type == 'panel') {
								dx.ad._fill_panel(obj, ad_id);
							} else {
								dx.ad._fill_unit(obj, ad_id);
							}
						}	
						if (obj.kern < dxcss.show_kern) {
							dxaa._set_spread(obj,parseInt(obj.kern) + parseInt(step));
						} else {
							dxaa._set_spread(obj,dxcss.show_kern);
							/*[switch ads]*/
							doclix_lib._xI(dxcss.change_int);
							dxaa.running = false;
							dx.ad._rotate(dx.ad._get_timer());
						}
					} else if (io == 'out') {
						if (obj.kern > -dxcss.hide_kern) {
							dxaa._set_spread(obj,parseInt(obj.kern) - parseInt(step));
						} else {
							dxaa._set_spread(obj,-dxcss.hide_kern);
							dxcss._animate(obj,ad_id,effect);
						}
					}
					break;
					case 'zoom':
					var step = 1;
					if (dxcss.font_unit == '%') {
						step = 5;
					} else if (dxcss.font_unit == 'em') {
						step = 0.1;
					}
					if (io == 'in') {
						if (obj.fzoom == 0) {
							dxaa.running = true;
							if (dx.ads.type == 'panel') {
								dx.ad._fill_panel(obj, ad_id);
							} else {
								dx.ad._fill_unit(obj, ad_id);
							}
						}
						if (obj.fzoom < dxcss.font_size) {
							dxaa._set_zoom(obj,parseFloat(obj.fzoom) + parseFloat(step),dxcss.font_unit);
						} else {
							dxaa._set_zoom(obj,dxcss.font_size,dxcss.font_unit);
							/*[switch ads]*/
							doclix_lib._xI(dxcss.change_int);
							dxaa.running = false;
							dx.ad._rotate(dx.ad._get_timer());
						}
					} else if (io == 'out') {
						if (obj.fzoom > 0) {
							dxaa._set_zoom(obj,parseFloat(obj.fzoom) - parseFloat(step),dxcss.font_unit)
						} else {
							dxaa._set_zoom(obj,0,dxcss.font_unit);
							dxcss._animate(obj,ad_id,effect,dxcss.font_unit);
						}
					}
					break;
				}
			}
		},
		/*[CSS Animation]*/
		/*[Fade: KEEP!]*/
		_set_fade : function (obj,f) {
			var dx_l = doclix_lib, s = 'style';
			obj.fade = f;
			if (dx_l.ua.has('IE')) {
				obj[s].zoom = 1;
				obj[s].filter = (f == 1 ? '' : 'alpha(opacity='+parseInt(f*100)+')'); /*[remove filter at full opacity to restore text anti-aliasing]*/
			} else {
				obj[s].opacity = f;
			}
		},
		/*[Spread]*/
		_set_spread : function (obj,krn) {
			obj.kern = krn;
			obj.style.letterSpacing = krn+'px';
		},
		/*[Zoom]*/
		_get_font : function (obj) {
			var dxcss = doclix_lib.anim.css;
			if (typeof dxcss.font_size == 'undefined') {
				dxcss.font_size = parseFloat(doclix_lib._css(obj, 'font-size', 'fontSize'));
			}
			if (typeof dxcss.font_unit == 'undefined') {
				dxcss.font_unit = doclix_lib._css(obj, 'font-size', 'fontSize').replace(/[0-9\.]/g, '');
			}
			if (typeof dxcss.base_size == 'undefined') {
				if (!isNaN(parseInt(doclix_lib._css(document.body, 'font-size', 'fontSize')))) {
					dxcss.base_size = parseFloat(doclix_lib._css(document.body, 'font-size', 'fontSize'));
				} else {
					dxcss.base_size = 16;
				}
			}
		},
		_set_zoom : function (obj, fs, unit) {
			obj.fzoom = fs;
			obj.style.fontSize = fs+unit;
		},
		/*[Rainbow and Spotlight Animation]*/
		rainbow : {
			tag : 'font',
			hue : 0,
			ray : 0,
			deg : 180,
			brt : 255,
			h_ms : 50,/*[rainbow]*/
			inc : 350,
			h_timers : [],
			_h_stop : function (n) {
				if (this.h_timers[n]) {
					doclix_lib._xI(this.h_timers[n].timer);
				}
			},
			s_ms : 25,/*[spotlight]*/
			s_pause : 4000,
			s_timers : [],
			s_pauses : [],
			s_runs : 100,
			_s_stop : function (n) {
				if (this.s_timers[n]) {
					doclix_lib._xI(this.s_timers[n]);
				}
			},
			color_sets : [],
			color_def : [[50,50,50],[250,250,250]],
			/*	hue=0   is red		(#FF0000)
				hue=60  is yellow	(#FFFF00)
				hue=120 is green	(#00FF00)
				hue=180 is cyan		(#00FFFF)
				hue=240 is blue		(#0000FF)
				hue=300 is magenta	(#FF00FF)
				hue=360 is hue=0	(#FF0000)	*/
			t_ms : 25,/*[tag type]*/
			t_pause : 4000,
			t_timers : [],
			t_pauses : [],
			t_runs : 100,
			_t_stop : function (n) {
				if (this.t_timers[n]) {
					doclix_lib._xI(this.t_timers[n]);
				}
			},
			_wrap : function (obj) {
				var n, str = '';
				for (var i=0; i < obj.childNodes.length; i++) {
					node = obj.childNodes[i];
					if (node.nodeType == 3) {
						str += node.data;
						obj.removeChild(node);
					}
				}
				n = str.length;
				for (var i=0; i < n; i++) {
					var el = doclix_lib._cE(doclix_lib.anim.rainbow.tag);
					el.appendChild(doclix_lib._cT(str.charAt(i)));
					obj.appendChild(el);
				}
			},
			/*	obj - HTML element to apply the effect to (extracts text, wraps each letter into a specified tag and re-attaches to the object, may contain other tags which will be left alone, so the text may be re-arranged if some portion of it were italic or bold)
				hue - what degree of hue to start at (0-359)
				deg - how many hue degrees should be traversed from beginning to end of the string (360 => once around, 720 => twice, etc)
				brt - brightness (0-255, 0 => black, 255 => full color)
				ms - how many ms between _shift_hue calls (less => faster)
				inc - how many hue degrees to move every time _shift_hue is called (0-359, closer to 180 => faster)	*/
			_set : function (obj, hue, deg, brt, ms, inc) {
				var dx_l_ar = doclix_lib.anim.rainbow;
				this.ray = dx_l_ar.ray;
			    this.hue = hue || dx_l_ar.hue;
			    this.deg = deg || dx_l_ar.deg;
			    this.brt = brt || dx_l_ar.brt;
			    this.hue_speed = ms || dx_l_ar.h_ms;
			    this.inc = inc || dx_l_ar.inc;
				for (var i = 0; i < obj.childNodes.length; i++) {
					node = obj.childNodes[i];
					if (node.nodeType == 3) this.length = node.data.length;
				};
			    this.obj = obj;
			    this.h_inc = this.deg/this.length;
			    this.timer = null;
			    dx_l_ar._wrap(obj);
			},
			_spot_color : function (obj) {
				if (typeof obj.s_run == 'undefined') {obj.s_run = 0;}
				var dx_l_ar = doclix_lib.anim.rainbow, o_id = parseInt(obj.id), obj_color, obj_hilite, css_color_str = doclix_lib._css(obj,'color','color'), sA = 'setAttribute';
				css_color_str = css_color_str.replace(/\s|\#|rgb|\(|\)/g, '');
				var is_hex = /^([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?$/;
				if (css_color_str.has(',')) {
					obj_color = [];
					obj_color = css_color_str.split(',');
					obj_color[0] = parseInt(obj_color[0]);
					obj_color[1] = parseInt(obj_color[1]);
					obj_color[2] = parseInt(obj_color[2]);
				} else if (is_hex.test(css_color_str)) {
					if (css_color_str.length == 3) {
						s = css_color_str.charAt(0)+css_color_str.charAt(0)+css_color_str.charAt(1)+css_color_str.charAt(1)+css_color_str.charAt(2)+css_color_str.charAt(2);
						css_color_str = s;
					}
					obj_color = [];
					obj_color[0] = parseInt(css_color_str.substring(0, 2), 16);
					obj_color[1] = parseInt(css_color_str.substring(2, 4), 16);
					obj_color[2] = parseInt(css_color_str.substring(4, 6), 16);
				}
				if (obj_color) {
					var obj_r = obj_color[0], obj_g = obj_color[1], obj_b = obj_color[2];
					obj_hilite = [];
					var obj_hsl = doclix_lib.color._RGBtoHSL(obj_r, obj_g, obj_b);
					var obj_hi_l = doclix_lib.color._HSLtoRGB(obj_hsl[0], obj_hsl[1], 1);
					var obj_hsv = doclix_lib.color._RGBtoHSV(obj_r, obj_g, obj_b);
					var obj_hi_v = doclix_lib.color._HSVtoRGB(obj_hsv[0], obj_hsv[1], 1);
					obj_hilite = [Math.round((obj_hi_l[0] + obj_hi_v[0])/2), Math.round((obj_hi_l[1] + obj_hi_v[1])/2), Math.round((obj_hi_l[2] + obj_hi_v[2])/2)];
					dx_l_ar.color_sets[o_id] = [obj_color, obj_hilite];
				}
				dx_l_ar._s_stop(o_id);
				if (dx_l_ar.s_pauses[o_id]) {
					doclix_lib._xT(dx_l_ar.s_pauses[o_id]);
				} /*[start spotlight animations]*/
				var s_timer = setInterval(function () {
						dx_l_ar._spot_light(obj);
					},	dx_l_ar.s_ms);
				dx_l_ar.s_timers[o_id] = s_timer;
			},
			/*[sets the colors of the children of obj as a moving spotlight]*/
			_spot_light : function (obj) {
				var dx_l_ar = doclix_lib.anim.rainbow, o_id = parseInt(obj.id), r, g, b, R, G, B, x = obj.s_run, n;
				if (dx_l_ar.color_sets[o_id]) {
					r = dx_l_ar.color_sets[o_id][0][0], g = dx_l_ar.color_sets[o_id][0][1], b = dx_l_ar.color_sets[o_id][0][2];
					R = dx_l_ar.color_sets[o_id][1][0], G = dx_l_ar.color_sets[o_id][1][1], B = dx_l_ar.color_sets[o_id][1][2];
				} else {
					r = dx_l_ar.color_def[0][0], g = dx_l_ar.color_def[0][1], b = dx_l_ar.color_def[0][2];
					R = dx_l_ar.color_def[1][0], G = dx_l_ar.color_def[1][1], B = dx_l_ar.color_def[1][2];
				}
				if (typeof obj.n_ltr == 'undefined') {obj.n_ltr = -3;}
				n = obj.n_ltr;
				if (n <= obj.childNodes.length + 3) {
					for (var i = 0; i < obj.childNodes.length; i++) {
						if (obj.childNodes[i].nodeName == dx_l_ar.tag.toUpperCase()) {
							el = obj.childNodes[i];
							if (Math.abs(i - n) == 2) {
								el.style.color = 'rgb(' + parseInt(r + (R - r) / 3) + ', ' + parseInt(g + (G - g) / 3) + ', ' + parseInt(b + (B - b) / 3) + ')';
							} else if (Math.abs(i - n) == 1) {
								el.style.color = 'rgb(' + parseInt(r + ((R - r) / 3) * 2) + ', ' + parseInt(g + ((G - g) / 3) * 2) + ', ' + parseInt(b + ((B - b) / 3) * 2) + ')';
							} else if (i == n) {
								el.style.color = 'rgb(' + R + ', ' + G + ', ' + B + ')';
							} else {
								el.style.color = 'rgb(' + r + ', ' + g + ', ' + b + ')';
							}
						}
					}
				}
				n++;
				if (n > 63) { /*[maximum message length + 3]*/
					n = -3;
					dx_l_ar._s_stop(o_id);
					if (obj.s_run < dx_l_ar.s_runs || doclix_demo_mode) {
						x++;
						obj.s_run = x;
						var s_pause = setTimeout(function () {
							var s_timer = setInterval(function () {
									dx_l_ar._spot_light(obj);
								},	dx_l_ar.s_ms);
							dx_l_ar.s_timers[o_id] = s_timer;
						}, dx_l_ar.s_pause);
						dx_l_ar.s_pauses[o_id] = s_pause;
					}
				}
				obj.n_ltr = n;
			},
			_tag_mode : function (obj, mode) {
				var dx_l_ar = doclix_lib.anim.rainbow, o_id = parseInt(obj.id), s = 'style', n, x;
				if (typeof obj.t_run == 'undefined') {obj.t_run = 0;} x = obj.t_run;
				switch (mode) {
					case 'jump':
						if (typeof obj.n_ltr == 'undefined') {obj.n_ltr = 0;}
						n = obj.n_ltr;
						if (n <= obj.childNodes.length) {
							for (var i = 0; i < obj.childNodes.length; i++) {
								if (obj.childNodes[i].nodeName == dx_l_ar.tag.toUpperCase()) {
									el = obj.childNodes[i];
									el[s].position = 'relative';
									i == n ? el[s].top = '-2px' : el[s].top = '0px';
								}
							}
						}
						n++;
						if (n > 60) {
							n = 0;
							dx_l_ar._t_stop(o_id);
							if (obj.t_run < dx_l_ar.t_runs || doclix_demo_mode) {
								x++;
								obj.t_run = x;
								var t_pause = setTimeout(function () {
									var t_timer = setInterval(function () {
											dx_l_ar._tag_mode(obj, 'jump');
										},	dx_l_ar.t_ms);
									dx_l_ar.t_timers[o_id] = t_timer;
								}, dx_l_ar.t_pause);
								dx_l_ar.s_pauses[o_id] = t_pause;
							}
						}
						obj.n_ltr = n;
						break;
					case 'type':
						if (typeof obj.n_ltr == 'undefined') {obj.n_ltr = 0; obj.t_dec = obj[s].textDecoration; obj[s].textDecoration = 'none';}
						n = obj.n_ltr;
						if (n <= obj.childNodes.length) {
							for (var i = 0; i < obj.childNodes.length; i++) {
								if (obj.childNodes[i].nodeName == dx_l_ar.tag.toUpperCase()) {
									el = obj.childNodes[i];
									el[s].textDecoration = obj.t_dec;
									i > n ? el[s].visibility = 'hidden' : el[s].visibility = 'visible';//type
								}
							}
						}
						n++;
						if (n > 60) {
							n = 0;
							dx_l_ar._t_stop(o_id);
							if (obj.t_run < dx_l_ar.t_runs || doclix_demo_mode) {
								x++;
								obj.t_run = x;
//								var t_pause = setTimeout(function () {
//									var t_timer = setInterval(function () {
//											dx_l_ar._tag_mode(obj, 'type');
//										},	dx_l_ar.t_ms);
//									dx_l_ar.t_timers[o_id] = t_timer;
//								}, dx_l_ar.t_pause);
//								dx_l_ar.s_pauses[o_id] = t_pause;
							}
						}
						obj.n_ltr = n;
						break;
					case 'push':
						if (typeof obj.n_ltr == 'undefined') {obj.n_ltr = obj.childNodes.length; obj.t_dec = obj[s].textDecoration; obj[s].textDecoration = 'none';}
						n = obj.n_ltr;
						if (n >= 0) {
							for (var i = obj.childNodes.length-1; i >= 0; i--) {
								if (obj.childNodes[i].nodeName == dx_l_ar.tag.toUpperCase()) {
									el = obj.childNodes[i];
									el[s].textDecoration = obj.t_dec;
									i < n ? el[s].display = 'none' : el[s].display = 'inline';
								}
							}
						}
						n--;
						if (n == -1) {
							n = obj.childNodes.length;
							dx_l_ar._t_stop(o_id);
							if (obj.t_run < dx_l_ar.t_runs || doclix_demo_mode) {
								x++;
								obj.t_run = x;
//								var t_pause = setTimeout(function () {
//									var t_timer = setInterval(function () {
//											dx_l_ar._tag_mode(obj, 'push');
//										},	dx_l_ar.t_ms);
//									dx_l_ar.t_timers[o_id] = t_timer;
//								}, dx_l_ar.t_pause);
//								dx_l_ar.s_pauses[o_id] = t_pause;
							}
						}
						obj.n_ltr = n;
						break;
					default:
						break;
				}

			}
		}/*[end Rainbow, Spotlight, Tag Type Animation]*/
	},/*[end common message animation routines]*/
	/*[color conversion routines]*/
	color : {
		_RGBtoHSL : function (r, g, b) {
			r /= 255, g /= 255, b /= 255;
		    var max = Math.max(r, g, b), min = Math.min(r, g, b);
		    var h, s, l = (max + min) / 2;
		    if (max == min) {
		        h = s = 0; /*[achromatic]*/
		    } else {
		        var d = max - min;
		        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
		        switch (max) {
		            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
		            case g: h = (b - r) / d + 2; break;
		            case b: h = (r - g) / d + 4; break;
		        }
		        h /= 6;
		    }
		    return [h, s, l];
		},
		_HSLtoRGB : function  (h, s, l) {
		    var r, g, b;
		    if(s == 0) {
		        r = g = b = l; /*[achromatic]*/
		    } else {
		        function _huetoRGB (p, q, t) {
		            if (t < 0) t += 1;
		            if (t > 1) t -= 1;
		            if (t < 1/6) return p + (q - p) * 6 * t;
		            if (t < 1/2) return q;
		            if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
		            return p;
		        }
		        var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
		        var p = 2 * l - q;
		        r = _huetoRGB(p, q, h + 1/3);
		        g = _huetoRGB(p, q, h);
		        b = _huetoRGB(p, q, h - 1/3);
		    }
		    return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
		},
		_RGBtoHSV : function (r, g, b) {
		    r /= 255, g /= 255, b /= 255;
		    var max = Math.max(r, g, b), min = Math.min(r, g, b);
		    var h, s, v = max;
		    var d = max - min;
		    s = max == 0 ? 0 : d / max;
		    if (max == min) {
		        h = 0; /*[achromatic]*/
		    } else {
		        switch (max) {
		            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
		            case g: h = (b - r) / d + 2; break;
		            case b: h = (r - g) / d + 4; break;
		        }
		        h /= 6;
		    }
		    return [h, s, v];
		},
		_HSVtoRGB : function (h, s, v) {
		    var r, g, b;
		    var i = Math.floor(h * 6);
		    var f = h * 6 - i;
		    var p = v * (1 - s);
		    var q = v * (1 - f * s);
		    var t = v * (1 - (1 - f) * s);
		    switch (i % 6) {
		        case 0: r = v, g = t, b = p; break;
		        case 1: r = q, g = v, b = p; break;
		        case 2: r = p, g = v, b = t; break;
		        case 3: r = p, g = q, b = v; break;
		        case 4: r = t, g = p, b = v; break;
		        case 5: r = v, g = p, b = q; break;
		    }
		    return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
		},
		_RGBtoRGB: function (r, g, b) {
			cap = Math.max(255 - Math.max(r, g, b), 128);
			R = Math.min(r + cap, 255);
			G = Math.min(g + cap, 255);
			B = Math.min(b + cap, 255);
			return [R, G, B];
		}
	},
	/*[development]*/
	debug : false,
	_show : function (msg) {
		if (doclix_lib.debug == true) document.title += ' [' + msg +']';
	},
	_idle: function (ms) { /*[reserved]*/
		var o = new Date(), n = 0;
		do {
			n = new Date();
		} while (n - o < ms);
	}
};

/*[sets the colors of the children of [this] as a hue-rotating rainbow starting at this.hue]*/
doclix_lib.anim.rainbow._set.prototype._shift_hue = function () {
	if (this.hue >= 360) this.hue -= 360;
	var clr, lbr = 0;
	var b = this.brt;
	var h = this.hue;
	for (var i = 0; i < this.obj.childNodes.length; i++) {
		if (this.obj.childNodes[i].nodeName == doclix_lib.anim.rainbow.tag.toUpperCase()) {
			if (h >= 360) h -= 360;
			if (h < 60) {clr = Math.floor(((h)/60)*b); R = b; G = clr; B = lbr;}
			else if (h < 120) {clr = Math.floor(((h-60)/60)*b); R = b-clr; G = b; B = lbr;}
			else if (h < 180) {clr = Math.floor(((h-120)/60)*b); R = lbr; G = b; B = clr;}
			else if (h < 240) {clr = Math.floor(((h-180)/60)*b); R = lbr; G = b-clr; B = b;}
			else if (h < 300) {clr = Math.floor(((h-240)/60)*b); R = clr; G = lbr; B = b;}
			else {clr = Math.floor(((h-300)/60)*b); R = b; G = lbr; B = b-clr;}
			h += this.h_inc;
			this.obj.childNodes[i].style.color='rgb('+R+', '+G+', '+B+')';
		}
	}
	this.hue += this.inc;
}
/*[end common library]*/
