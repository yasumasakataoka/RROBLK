

var Nabble = new Object();


Nabble.embeddingUrl = null;
Nabble.embedForumID = 0;
Nabble.isEmbedded = false;

try {
	Nabble.embedForumID = top.nabbleinfo.location.search.substring(7);
	var hash = top.nabbleinfo.location.hash.substring(1).split('|');
	Nabble.embeddingUrl = hash[0];
	Nabble.isEmbedded = true;
} catch(err) {}

Nabble.embeddedTarget = function(defaultTarget) {
	return Nabble.isEmbedded? ' target="nabbleiframe" ' : ' target="' + defaultTarget + '" ';
};

Nabble.topLeftBar = function() {
	if (Nabble.isEmbedded) {
		var r = Nabble.get("nabble.root");
		if (r) r.innerHTML = "<a href='" + top.nabbleinfo.forumUrl + "' target='nabbleiframe'>Forum</a>&nbsp;";
	}
};

Nabble.isChildOf = function(childID) {
	try{
		return top.nabbleinfo.isChildOf(childID);
	} catch(er) {}
	return false;
};

Nabble.runEmbedFix = function() {
	var bodyEmbed = document.body.getAttribute('embed');
	if (bodyEmbed == 'fixScroll') window.scroll(0,0);

	var links = document.getElementsByTagName('a');
	for (var i = 0; i < links.length; i++) {
		var embed = links[i].getAttribute('embed');
		if (links[i] && links[i].href && typeof(embed) == 'string') {
			var pos = embed.indexOf('fixTarget');
			if (pos > -1) {
				var modify = true;
				var posOpen = embed.indexOf('[', pos);
				var posClose = embed.indexOf(']', posOpen);
				if (posOpen != -1 && posClose != -1) {
					var forumID = embed.substring(posOpen+1, posClose);
					modify = Nabble.embedForumID == forumID || Nabble.isChildOf(forumID);
				}

				if (modify)
					links[i].setAttribute('target', 'nabbleiframe');
			}
		}
	}
};

Nabble.setTop = function(url) {
	if (Nabble.isEmbedded) top.nabbleiframe.location=url;
	else top.location=url;
};

        Nabble.getTop = function() {
	if (Nabble.isEmbedded) return top.nabbleiframe.location;
	else return top.location;
};

Nabble.getMyHeight = function() {
	if ($.browser.msie) return document.body.scrollHeight;
	if ($.browser.mozilla) return document.body.offsetHeight;
	else if ($.browser.opera) return document.documentElement.clientHeight;
	else return Math.max(document.body.scrollHeight, document.body.offsetHeight);
};

Nabble.evalInTop = function(js) {
	$.get("/util/MySession.jtp?action=set&key=resizejs&value=" + encodeURIComponent(js), function() {
            	top.nabbleresize.location = "http://old.nabble.com/util/Empty.jtp";
	});
};

Nabble.quote = function(s) {
	return "'" + s.replace(/\\/,"\\\\").replace(/'/,"\\'") + "'";
};

Nabble.resizeFrames = function(h) {
	if (top.nabbleresize) {
		var height = h && typeof h == 'number'? h : Math.max(Nabble.getMyHeight() + 100, 500);
		var title = document.title.replace(/Nabble - /, "");
		var js = "Nabble.resizeFrames(" + height + "," + Nabble.quote(title) + ");";
		if (js != Nabble.currentJs) {
			Nabble.currentJs = js;
			Nabble.evalInTop(js);
		}
	}
};

$(document).ready(function(){
	Nabble.topLeftBar();
	if (Nabble.isEmbedded) {
		var isFramedView = Nabble.get('nabble.frameset');
		
		if (window.parent == window.top && !isFramedView) {
			Nabble.resizeFrames();
			$(window).resize(Nabble.resizeFrames);
		} else if (isFramedView) {
			Nabble.resizeFrames(650);
		}
		$(window).load(Nabble.runEmbedFix);
	}
});



Nabble.get = function(id) {
	return document.getElementById(id);
};

Nabble.height = function() {
	if( typeof( window.innerHeight ) == 'number' ) {
		return window.innerHeight;
	} else if( document.documentElement && document.documentElement.clientHeight ) {
		return document.documentElement.clientHeight;
	} else if( document.body && document.body.clientHeight ) {
		return document.body.clientHeight;
	}
};

Nabble.knowsHeight = navigator.userAgent.toLowerCase().indexOf('safari') == -1;

Nabble.prepend = function(tag,html) {
	if( tag.insertAdjacentHTML ) {
		tag.insertAdjacentHTML("AfterBegin",html);
	} else {
		var elem = document.createElement("span");
		tag.insertBefore(elem,tag.firstChild);
		elem.innerHTML = html;
	}
};

Nabble.escapeHTML = function(str) {
	var div = document.createElement('div');
	var text = document.createTextNode(str);
	div.appendChild(text);
	return div.innerHTML;
};

// date formatting

Nabble.months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

Nabble.fmt2 = function(i) {
	var s = "" + i;
	if( s.length == 1 )
		s = "0" + s;
	return s;
};

Nabble.now = new Date();

Nabble.isToday = function(date) {
	return date.toDateString() == this.now.toDateString();
};

Nabble.isThisYear = function(date) {
	return date.getYear() == this.now.getYear();
};

Nabble.dateFormatters = {
	us: new (function(){
		this.formatTime = function(date) {
			var hours = date.getHours();
			if( hours < 12 ) {
				var xm = "am";
				if( hours==0 )
					hours = 12;
			} else {
				var xm = "pm";
				if( hours > 12 )
					hours -= 12;
			}
			return Nabble.fmt2(hours) + ":" + Nabble.fmt2(date.getMinutes()) + xm;
		};
		this.formatDateOnly = function(date) {
			return Nabble.months[date.getMonth()] + " " + Nabble.fmt2(date.getDate()) + ", " + date.getFullYear();
		};
		this.formatDateLong = function(date) {
			return this.formatDateOnly(date) + "; " + this.formatTime(date);
		};
		this.formatDateShort = function(date) {
			if( Nabble.isToday(date) )
				return this.formatTime(date);
			if( Nabble.isThisYear(date) )
				return Nabble.months[date.getMonth()] + " " + Nabble.fmt2(date.getDate());
			return this.formatDateOnly(date);
		};
	})()
	,
	euro: new (function(){
		this.formatTime = function(date) {
			return Nabble.fmt2(date.getHours()) + ":" + Nabble.fmt2(date.getMinutes());
		};
		this.formatDateOnly = function(date) {
			return Nabble.fmt2(date.getDate()) + "." + Nabble.months[date.getMonth()] + "." + date.getFullYear();
		};
		this.formatDateLong = function(date) {
			return this.formatTime(date) + ", " + this.formatDateOnly(date);
		};
		this.formatDateShort = function(date) {
			if( Nabble.isToday(date) )
				return this.formatTime(date);
			if( Nabble.isThisYear(date) )
				return Nabble.fmt2(date.getDate()) + "." + Nabble.months[date.getMonth()];
			return this.formatDateOnly(date);
		};
	})()
	,
	tech: new (function(){
		this.formatTime = function(date) {
			return Nabble.fmt2(date.getHours()) + ":" + Nabble.fmt2(date.getMinutes());
		};
		this.formatDateOnly = function(date) {
			return "" + date.getFullYear() + "-" + Nabble.fmt2(date.getMonth()+1) + "-" + Nabble.fmt2(date.getDate())
		};
		this.formatDateLong = function(date) {
			return this.formatDateOnly(date) + " " + this.formatTime(date);
		};
		this.formatDateShort = function(date) {
			if( Nabble.isToday(date) )
				return this.formatTime(date);
			if( Nabble.isThisYear(date) )
				return Nabble.fmt2(date.getMonth()+1) + "-" + Nabble.fmt2(date.getDate());
			return this.formatDateOnly(date);
		};
	})()
};

Nabble.getDateFmt = function() {
	var dateFmt = Nabble.getCookie("date_fmt");
	return dateFmt==null ? "us" : dateFmt;
};

Nabble.formatDateOnly = function(date) {
	return Nabble.dateFormatters[Nabble.getDateFmt()].formatDateOnly(date);
};

Nabble.formatDateLong = function(date) {
	return Nabble.dateFormatters[Nabble.getDateFmt()].formatDateLong(date);
};

Nabble.formatDateShort = function(date) {
	var fmt = Nabble.dateFormatters[Nabble.getDateFmt()];
	return '<span title="' + fmt.formatDateLong(date) + '">' 
		+ fmt.formatDateShort(date) + '</span>';
};



Nabble.getCookie = function(name) {
	var dc = document.cookie;
	var prefix = name + "=";
	var begin = dc.indexOf("; " + prefix);
	if (begin == -1) {
		begin = dc.indexOf(prefix);
		if (begin != 0) return null;
	} else
		begin += 2;
	var end = document.cookie.indexOf(";", begin);
	if (end == -1)
		end = dc.length;
	return unescape(dc.substring(begin + prefix.length, end));
};

Nabble.setCookie = function(name, value) {
	if( Nabble.isEmbedded ) {
		return top.nabbleinfo.setCookie(name,value);
	}
	var curCookie = name + "=" + escape(value) + "; path=/";
	document.cookie = curCookie;
};

Nabble.setPersistentCookie = function(name, value) {
	if( Nabble.isEmbedded ) {
		return top.nabbleinfo.setPersistentCookie(name,value);
	}
	var expires = new Date();
	expires.setFullYear(expires.getFullYear()+10);
	var curCookie = name + "=" + escape(value) + "; expires=" + expires.toGMTString() + "; path=/";
	document.cookie = curCookie;
};

Nabble.deleteCookie = function(name) {
	if( Nabble.isEmbedded ) {
		return top.nabbleinfo.deleteCookie(name);
	}
	if (this.getCookie(name)) {
		document.cookie = name + "=" +
			"; path=/"  +
			"; expires=Thu, 01-Jan-1970 00:00:01 GMT";
	}
};

Nabble.user = Nabble.getCookie("userId");
Nabble.email = Nabble.getCookie("email");
Nabble.username = Nabble.getCookie("username");

Nabble.vars = ["skin","prev","notice","customStyle"];
Nabble.pvars = ["tview"];  // persistent

(function(){
	for( var i=0; i<Nabble.vars.length; i++ ) {
		var v = Nabble.vars[i];
		Nabble[v] = Nabble.getCookie(v);
	}
	for( var i=0; i<Nabble.pvars.length; i++ ) {
		var v = Nabble.pvars[i];
		Nabble[v] = Nabble.getCookie(v);
	}
})();

Nabble.handleVars = function() {
	for( var i=0; i<Nabble.vars.length; i++ ) {
		var v = Nabble.vars[i];
		if( Nabble[v] != Nabble.getCookie(v) ) {
			Nabble.setVar(v,Nabble[v]);
		}
	}
	for( var i=0; i<Nabble.pvars.length; i++ ) {
		var v = Nabble.pvars[i];
		if( Nabble[v] != Nabble.getCookie(v) ) {
			Nabble.setVar(v,this[v]);
		}
	}
};

Nabble.contains = function(a,v) {
	for( var i=0; i<a.length; i++ ) {
		if( a[i]==v )
			return true;
	}
	return false;
};

Nabble.setVar = function(v,val) {
	Nabble[v] = val;
	try {
		parent.Nabble[v] = val;
	} catch(err) {}
	if( val ) {
		if( this.contains(this.vars,v) ) {
			this.setCookie(v,val);
		} else if( this.contains(this.pvars,v) ) {
			this.setPersistentCookie(v,val);
		} else {
			throw new Error("var not found: "+v);
		}
	} else {
		this.deleteCookie(v);
	}
};



Nabble.loadScript = function(url) {
	var e = document.createElement("script");
	e.src = url;
	e.type="text/javascript";
	document.getElementsByTagName("head")[0].appendChild(e);
};

Nabble.selectOption = function(select,value) {
	var options = select.options;
	for( var i=0; i<options.length; i++ ) {
		var option = options[i];
		if( option.value == value )
			option.selected = true;
	}
};

Nabble.hilt = function(searchterms, elem) {
    if (elem.childNodes && elem.childNodes.length > 0) {
        for (var i=0; i<elem.childNodes.length; i++) {
            this.hilt(searchterms, elem.childNodes[i]);
        }
    } else if (elem.nodeType) {
        if (elem.nodeType == document.TEXT_NODE || elem.nodeType == 3) {
            var txt = elem.nodeValue;
            var rgx = new RegExp("\\b("+searchterms+")\\w*\\b", "gi");
            var result;
            var start = 0;
            var newFragment = document.createElement("span");
            while ((result = rgx.exec(txt)) != null) {
                var end = result.index;
                var textNode = document.createTextNode(txt.slice(start, end));
                newFragment.appendChild(textNode);
                var hlNode = document.createElement("b");
				hlNode.className = "highlight";
                hlNode.appendChild(document.createTextNode(result[0]));
                newFragment.appendChild(hlNode);
                start = end + result[0].length;
            }
            newFragment.appendChild(document.createTextNode(txt.slice(start)));
            elem.parentNode.replaceChild(newFragment, elem);
        }
    }
};

Nabble.getSearchterms = function() {
	var searchterms = this.getCookie("searchterms");
	if (document.referrer) {
		var result = Nabble.getSearchTerms2(document.referrer);
		if (result!=null) {
			var query = decodeURIComponent(result);
			searchterms = query.replace(/\W+/g,"|").replace(/^\|/,"").replace(/\|$/,"");
			this.setCookie("searchterms", searchterms);
			Nabble.gquery = query.replace(/\+/g," ");
		}
	}
	return searchterms;
};

// logic from _uOrg() in urchin.js
Nabble.getSearchTerms2 = function(referrer) {
	if( typeof(_uOsr)=="undefined" || typeof(_uOkw)=="undefined" )
		return null;
	var searchEngines = _uOsr;  // from urchin
	var searchQueries = _uOkw;  // from urchin
	var i;
	if( referrer==null || (i=referrer.indexOf("://")) < 0 )
		return null;
	var h = referrer.substring(i+3);
	if (h.indexOf("/") > -1) {
		h = h.substring(0,h.indexOf("/"));
	}
	for (var ii=0; ii<searchEngines.length; ii++) {
		var searchEngine = searchEngines[ii];
		var searchQuery = searchQueries[ii];
		if (h.toLowerCase().indexOf(searchEngine.toLowerCase()) > -1) {
			if ((i=referrer.indexOf("?"+searchQuery+"=")) > -1 || (i=referrer.indexOf("&"+searchQuery+"=")) > -1) {
				var k = referrer.substring(i+searchQuery.length+2,referrer.length);
				if ((i=k.indexOf("&")) > -1)
					k = k.substring(0,i);
				return k;
			}
		}
	}
	return null;
};


Nabble.subscribeWindow = function(url) {
	subsWin = window.open(url,'subsWin','height=400,width=600,scrollbars');
	subsWin.focus();
};

Nabble.toggle = function(id, callback) {
	$('#'+id).slideToggle('slow', function(){
		if (callback) callback();
		Nabble.resizeFrames();
	});			
};

Nabble.embedPermalink = function(url) {
	if (!Nabble.isEmbedded)
		return url;
	var permalink = '';
	if (url.indexOf('?') > 0)
		permalink = url + "&embedf=" + Nabble.embedForumID;
	else if (url.indexOf('.html') > 0)
		permalink = url.replace('.html', 'ef' + Nabble.embedForumID + '.html');
	else
		permalink = url + "?embedf=" + Nabble.embedForumID;
	return permalink;
};

Nabble.getPermalink = function() {
	return Nabble.embedPermalink(top.nabbleiframe.location.href);
};

Nabble.permalinkLabel = function() {
	if (!Nabble.isEmbedded)
		return '';
	var p = "<script>function openPermalink() { prompt('Copy this:', Nabble.getPermalink()); };</script>";
	p += "<a href='javascript: void openPermalink();'>Permalink</a>&nbsp;&nbsp;&nbsp;";
	return p;
};

Nabble.userHeader = function(forum) {
	
$(document).ready(function(){
	var s = '';
	if (Nabble.user==null) {
		s += '';
		s += Nabble.permalinkLabel();
		s += '<a href="/user/Login.jtp?nextUrl='+encodeURIComponent(Nabble.getTop())+'" embed="fixTarget" target="_top">Login</a>';
		s += ' : ';
		s += '<a href="/user/Register.jtp?nextUrl='+encodeURIComponent(Nabble.getTop())+'" embed="fixTarget" target="_top">Register</a>';
	} else {
		s += '';
		s += Nabble.permalinkLabel();
		s += Nabble.favoriteForumsHeader(forum);
		s += '<a href="/user/UserProfile.jtp?user=' + Nabble.user + '" embed="fixTarget" target="_top">';
		s += Nabble.escapeHTML(Nabble.username);
		s += '</a>';
	}
	$("#nabble-user-header").html(s);
});
};

// favorite forums

Nabble.favoriteForumsHeader = function(forum) {
var fmt = Nabble.getCookie("favorites");
if( fmt == "link" ) {
	return Nabble.favoriteForumsLinkHeader(forum);
} else {
	return Nabble.favoriteForumsSelectHeader(forum);
}
};

Nabble.favoriteForumsLinkHeader = function(forum) {
var s = '';
s += '<a href="/forum/Favorites.jtp" target="_top">Favorite Forums</a>';
s += ' <span id="nabble.add_fav"></span> ';
s += ' - ';
return s;
};

Nabble.favoriteForumsSelectHeader = function(forum) {
var isSelectPathetic = navigator.appName.indexOf("Microsoft") != -1;
var s = '';
if( isSelectPathetic ) {
	s += '<span class="favorites" style="width:10em;overflow:hidden;" onmouseover="Nabble.loadFavorites('+forum+')">';
	s += '<select style="width:101%;"';
} else {
	s += '<select class="favorites" style="width:10em;"';
}
s += ' id="nabble.favorites" onchange="Nabble.favoritesSelect();" ';
if( isSelectPathetic ) {
	s += 'onmouseover="this.style.width=\'auto\';setActive();" ondeactivate="this.style.width=\'100%\';"';
} else {
	s += 'onmouseover="Nabble.loadFavorites(' + forum + ')"';
}
s += '>';
s += '<option value="">Favorite Forums</option>';
s += '</select>';
if( isSelectPathetic ) {
	s += '</span>';
}
s += ' &nbsp; ';
if( isSelectPathetic ) {
	setTimeout(
		  'Nabble.get("nabble.favorites").style.width = "100%";'
		, 1
	)
}
return s;
};

Nabble.gotFavorites = false;

Nabble.loadFavorites = function(forum) {
if( this.gotFavorites )
	return;
var url = "/forum/FavoriteForums.jtp";
if( forum )
	url += "?forum=" + forum;
this.loadScript(url);
this.gotFavorites = true;
};

Nabble.favoritesSelect = function() {
var select = this.get("nabble.favorites");
var url = select.options[select.selectedIndex].value;
select.options[0].selected = true;
if( !url )
	return;
this.gotFavorites = false;
parent.location = url;
};


Nabble.pngIEChg = function() {
if( event.propertyName != "src" )
	return;
var img = event.srcElement;
img.parentNode.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+img.src+"');display:inline-block;";
};

Nabble.fixPng = function(parent, filter) {
if (navigator.appVersion.indexOf("MSIE 6") == -1)
	return;
var img = filter? 'img' + filter : 'img';
$(img, parent).each(function(){
	if (this.style.filter)
		return;
	var src = $(this).attr('src');
	if (src && src.match(/\.png$/i)) {
		this.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=0)";
		this.onpropertychange = "Nabble.pngIEChg();";
		this.outerHTML =
			'<span style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\''+src+'\');display:inline-block;'+(this.parentNode.tagName=="A"?"cursor:pointer;":"")+'">'
			+ this.outerHTML
			+ '</span>';
	}
});

};

Nabble.pngBackgroundIEFix = function() {
var sheet=document.styleSheets[0];
sheet.addRule(".nabble .top-shadow","background-image: none;filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/topShadow.png', sizingMethod='crop');"); 
};

Nabble.divIEFix = function() {
if( navigator.appVersion.indexOf("MSIE 6") == -1 )
	return
var a = Nabble.get("nabble").getElementsByTagName("div");
for( var i=0; i<a.length; i++ ) {
	var t = a[i];
	if( t.getAttribute("no_zoom") )
		continue;
	t.style.zoom = "100%";
}
};

Nabble.addHandler = function(obj,attr,fn) {
var oldFn = obj[attr];
if( oldFn ) {
	obj[attr] = function() {
		oldFn();
		fn();
	}
} else {
	obj[attr] = fn;
}
};

$(window).load(function(){

if( navigator.appVersion.indexOf("MSIE 6") != -1 ) {
	Nabble.fixPng($('#nabble'));
	Nabble.pngBackgroundIEFix();
	Nabble.divIEFix();
}
});

$(window).focus(function(){
if (self==top) {
	Nabble.handleVars();
}
});

Nabble.fixTopicLinks = function() {
if( Nabble.tview == "dump" )
	return;
var a = Nabble.get("nabble").getElementsByTagName("a");
for( var i=0; i<a.length; i++ ) {
	var tag = a[i];
	var href = tag.getAttribute("framed_href");
	if( href==null )
		continue;

	var href2 = null;
	if (Nabble.tview == "newthreaded") {
		href2 = tag.getAttribute("new_threaded_href");
	} else if (Nabble.tview == "newchron") {
		href2 = tag.getAttribute("new_chron_href");
	} else if (Nabble.tview == "classic") {
		href2 = tag.getAttribute("classic_href");
	}

	if (href2 != null) {
		tag.href = href2;
		continue;
	}
	tag.href = href;
}
};

Nabble.forumLinkStart = function() {
if( navigator.appName.indexOf("Microsoft") != -1 ) {
	document.write('<span class="forum-link-ie">');
} else {
	document.write('<div class="forum-link">');
}
};

Nabble.forumLinkEnd = function() {
if( navigator.appName.indexOf("Microsoft") != -1 ) {
	document.write('</span');
} else {
	document.write('</div>');
}
};

Nabble.currentStyle = function(t) {
return t.currentStyle ? t.currentStyle : getComputedStyle(t,null);
};

Nabble.addCssRule = function(sheet,selector,style) {
if( sheet.addRule ) {
	sheet.addRule(selector,style);
} else {
	sheet.insertRule(selector+'{'+style+'}',sheet.cssRules.length);
}
};

Nabble.writeReturnToLink = function(link) {
document.writeln('<br /><p>&#171; '+link+'</p>');
};

Nabble.messageTextWidth = function() {
var maxWidth = Nabble.getCookie("max_width");
if( maxWidth==null )
	return;
document.write("<style>.nabble .message-text {max-width: "+maxWidth+";}</style>");
};

Nabble.setFontSize = function() {
var fontSize = Nabble.getCookie("font_size");
if( fontSize )
	document.write("<style>body, table .nabble {font-size: "+fontSize+";}</style>");
};

Nabble.confirmDeletePostQuestionBasic = "Are you sure you want to permanently delete this message and all of its replies?";
Nabble.confirmDeletePostQuestionMailingList = Nabble.confirmDeletePostQuestionBasic + "\n\nNote: This doesn't delete the message from the mailing list or other sites where it may be archived.";
Nabble.confirmDeletePostQuestionPending = Nabble.confirmDeletePostQuestionBasic + "\n\nNote: If you delete this message it will not be sent to the mailing list.";

Nabble.deletePost = function(postId,confirmQuestion) {
if( !confirm(confirmQuestion) )
	return;
var newLocation = "/forum/DeletePost.jtp?post="+postId+"&pwd="+this.getCookie("password");
Nabble.setTop(newLocation);
};

Nabble.abTests = new Object();

Nabble.ratingStars = function(rating) {
if( rating==0 )
	return '<img src="/images/icon_blocked_blue.png" height="12" width="12" border="0" />';
var s = '';
for( var i=0; i<rating; i++ ) {
	s += '<img src="/images/icon_star_blue.png" height="12" width="12" border="0" />';
}
return s;
};


function hideQuotes(context) {
$('div.shrinkable-quote',context).after(
	"<div class='shrink-quote'><span></span> [<a href='#'></a>]</div>"
);
$('div.shrink-quote a', context)
	.toggle(function(){
		var $this = $(this);
		$this.prev().html( "..." );
		$this.html( "show rest of quote" );
		var $text = $this.parent().prev();
		$text.css( 'height' , 10 * $this.parent().height() );
		$text.css( 'overflowY', 'hidden' );
		Nabble.resizeFrames();
	}, function(){
		var $this = $(this);
		$this.prev().html( "&#171;&nbsp;" );
		$this.html( "hide part of quote" );
		var $text = $this.parent().prev();
		$text.css( 'height', 'auto' );
		$text.css( 'overflowY', 'auto' );
		Nabble.resizeFrames();
	})
	.click()
;
}

Nabble.newCaptcha = function() {
var img = Nabble.get("nabble-captcha");
img.src = "/util/Captcha.jtp?z="+Math.random();
};

