if ( typeof jQuery.cookie === "undefined" ) {
	jQuery.cookie = function(name, value, options) {
		if (typeof value != 'undefined') { // name and value given, set cookie
			options = options || {};
			if (value === null) {
				value = '';
				options.expires = -1;
			}
			var expires = '';
			if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
				var date;
				if (typeof options.expires == 'number') {
					date = new Date();
					date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
				} else {
					date = options.expires;
				}
				expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
			}
			// CAUTION: Needed to parenthesize options.path and options.domain
			// in the following expressions, otherwise they evaluate to undefined
			// in the packed version for some reason...
			var path = options.path ? '; path=' + (options.path) : '';
			var domain = options.domain ? '; domain=' + (options.domain) : '';
			var secure = options.secure ? '; secure' : '';
			document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
		} else { // only name given, get cookie
			var cookieValue = null;
			if (document.cookie && document.cookie != '') {
				var cookies = document.cookie.split(';');
				for (var i = 0; i < cookies.length; i++) {
					var cookie = jQuery.trim(cookies[i]);
					// Does this cookie string begin with the name we want?
					if (cookie.substring(0, name.length + 1) == (name + '=')) {
						cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
						break;
					}
				}
			}
			return cookieValue;
		}
	};
}





/*
 *	jquery.suggest 1.1 - 2007-08-06
 *	
 *	Uses code and techniques from following libraries:
 *	1. http://www.dyve.net/jquery/?autocomplete
 *	2. http://dev.jquery.com/browser/trunk/plugins/interface/iautocompleter.js	
 *
 *	All the new stuff written by Peter Vulgaris (www.vulgarisoip.com)	
 *	Feel free to do whatever you want with this file
 *
 */

(function($) {

 $.suggest = function(input, options) {

 var $input = $(input).attr("autocomplete", "off");
 var $results = $(document.createElement("ul"));
 var intervalID = null;
 var timeout = false;		// hold timeout ID for suggestion results to appear	
 var prevWord = "";			// last recorded word of $input.val()
 var cache = [];				// cache MRU list
 var cacheSize = 0;			// size of cache in chars (bytes?)
 var cookie_name = "search"

 if (options["cookie_name"]) cookie_name = options["cookie_name"];		

 $results.addClass(options.resultsClass).appendTo('body');


 resetPosition();
 $(window)
 .load(resetPosition)		// just in case user is changing size of page while loading
 .resize(resetPosition);

 $input.blur(function() {
		 setTimeout(function() { $results.hide() }, 200);
		 });

 // help IE users if possible
 try {
	 $results.bgiframe();
 } catch(e) { }


 $input.focus(function() {
		 intervalID = setInterval(function() {
			 if(prevWord != $input.val()) {
			 suggest();
			 prevWord = $input.val();
			 }
			 }, 300);
		 });

 $input.blur(function(){
		 clearInterval(intervalID);
		 intervalID = null;
		 });

 // I really hate browser detection, but I don't see any other way
 if ($.browser.mozilla) {
	 $input.keypress(processKey);	// onkeypress repeats arrow keys in Mozilla/Opera
	 $input.keyup(processKey);	// for IME
 } else {
	 $input.keydown(processKey);		// onkeydown repeats arrow keys in IE/Safari
 }




 function resetPosition() {
	 // requires jquery.dimension plugin
	 var offset = $input.offset();
	 $results.css({
top: (offset.top + input.offsetHeight) + 'px',
left: offset.left + 'px'
});
}


function processKey(e) {
	// handling up/down/escape requires results to be visible
	// handling enter/tab requires that AND a result to be selected
	if ((/27$|38$|40$/.test(e.keyCode) && $results.is(':visible')) ||
			(/^13$|^9$/.test(e.keyCode) && getCurrentResult())) {

		if ("keyup" == e.type) return;
		if (e.preventDefault) e.preventDefault();
		if (e.stopPropagation) e.stopPropagation();

		e.cancelBubble = true;
		e.returnValue = false;

		switch(e.keyCode) {

			case 38: // up
				prevResult();
				break;

			case 40: // down
				nextResult();
				break;

			case 9:  // tab
			case 13: // return
				selectCurrentResult();
				prevWord = $input.val();
				break;

			case 27: //	escape
				$results.hide();
				break;

		}

	} else {
		if ( 13 == e.keyCode) {
			if($.browser.mozilla && "keyup" == e.type ){
				return;
			}
			prevWord = $input.val();
			$results.hide(); // TODO click時入れる
		}
	}			
}


function suggest() {

	var q = $.trim($input.val());
	var c = $.cookie(cookie_name);

	if (q.length >= options.minchars) {

		cached = checkCache(q);

		if (cached) {
			displayItems(cached['items']);
		} else {
			jQuery.suggestCallback = function(list) {
				$results.hide();

				//var items = parseTxt(txt, q);
				var items = parseList(list, q);

				displayItems(items);
				//addToCache(q, items, txt.length);
				addToCache(q, items, list.length);
			}
			$.getScript(options.source + '?' + $.param({q: q, c: c,callback: 'jQuery.suggestCallback'}));
			/*
			   $.get(options.source, {q: q}, function(list) {

			   $results.hide();

			//var items = parseTxt(txt, q);
			var items = parseList(list, q);

			displayItems(items);
			//addToCache(q, items, txt.length);
			addToCache(q, items, list.length);

			});
			 */
		}

	} else {
		$results.hide();

	}

}


function checkCache(q) {

	for (var i = 0; i < cache.length; i++)
		if (cache[i]['q'] == q) {
			cache.unshift(cache.splice(i, 1)[0]);
			return cache[0];
		}

	return false;

}

function addToCache(q, items, size) {

	while (cache.length && (cacheSize + size > options.maxCacheSize)) {
		var cached = cache.pop();
		cacheSize -= cached['size'];
	}

	cache.push({
q: q,
size: size,
items: items
});

cacheSize += size;

}

function displayItems(items) {

	if (!items)
		return;

	if (!items.length) {
		$results.hide();
		return;
	}

	var html = '';
	for (var i = 0; i < items.length; i++)
		html += '<li>' + items[i] + '</li>';

	$results.html(html).show();

	$results
		.children('li')
		.mouseover(function() {
				$results.children('li').removeClass(options.selectClass);
				$(this).addClass(options.selectClass);
				})
	.click(function(e) {
			e.preventDefault(); 
			e.stopPropagation();
			selectCurrentResult();
			});

}

//function parseTxt(txt, q) {
function parseList(tokens, q) {

	var items = [];
	//var tokens = txt.split(options.delimiter);

	// parse returned data for non-empty items
	for (var i = 0; i < tokens.length; i++) {
		var token = $.trim(tokens[i]);
		if (token) {
			token = token.replace(
					new RegExp(q, 'ig'), 
					function(q) { return '<span class="' + options.matchClass + '">' + q + '</span>' }
					);
			items[items.length] = token;
		}
	}

	return items;
}

function getCurrentResult() {

	if (!$results.is(':visible'))
		return false;

	var $currentResult = $results.children('li.' + options.selectClass);

	if (!$currentResult.length)
		$currentResult = false;

	return $currentResult;

}

function selectCurrentResult() {

	$currentResult = getCurrentResult();

	if ($currentResult) {
		$input.val($currentResult.text());
		$results.hide();
		jQuery(AS1.Form.form).submit();

		if (options.onSelect)
			options.onSelect.apply($input[0]);

	}

}

function nextResult() {

	$currentResult = getCurrentResult();

	if ($currentResult)
		$currentResult
			.removeClass(options.selectClass)
			.next()
			.addClass(options.selectClass);
	else
		$results.children('li:first-child').addClass(options.selectClass);

}

function prevResult() {

	$currentResult = getCurrentResult();

	if ($currentResult)
		$currentResult
			.removeClass(options.selectClass)
			.prev()
			.addClass(options.selectClass);
	else
		$results.children('li:last-child').addClass(options.selectClass);

}

}

$.fn.suggest = function(source, options) {

	if (!source)
		return;

	options = options || {};
	options.source = source;
	options.delay = options.delay || 100;
	options.resultsClass = options.resultsClass || 'ac_results';
	options.selectClass = options.selectClass || 'ac_over';
	options.matchClass = options.matchClass || 'ac_match';
	options.minchars = options.minchars || 1;
	options.delimiter = options.delimiter || '\n';
	options.onSelect = options.onSelect || false;
	options.maxCacheSize = options.maxCacheSize || 65536;

	this.each(function() {
			new $.suggest(this, options);
			});

	return this;

};

})(jQuery);


