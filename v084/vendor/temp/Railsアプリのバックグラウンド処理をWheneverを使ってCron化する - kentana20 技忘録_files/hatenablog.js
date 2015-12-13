// XXX: twitterのwidget.jsがwindow.defineを定義している．
//      それによって，jquery.cookieがdefineあるときはAMD形式のexportするので，jquery.cookieが定義されなくなる．
//      その対策として，先にwindow.define消しておく．
window.define = undefined;

/*!
	Colorbox 1.6.3
	license: MIT
	http://www.jacklmoore.com/colorbox
*/
(function(t,e,i){function n(i,n,o){var r=e.createElement(i);return n&&(r.id=Z+n),o&&(r.style.cssText=o),t(r)}function o(){return i.innerHeight?i.innerHeight:t(i).height()}function r(e,i){i!==Object(i)&&(i={}),this.cache={},this.el=e,this.value=function(e){var n;return void 0===this.cache[e]&&(n=t(this.el).attr("data-cbox-"+e),void 0!==n?this.cache[e]=n:void 0!==i[e]?this.cache[e]=i[e]:void 0!==X[e]&&(this.cache[e]=X[e])),this.cache[e]},this.get=function(e){var i=this.value(e);return t.isFunction(i)?i.call(this.el,this):i}}function h(t){var e=W.length,i=(A+t)%e;return 0>i?e+i:i}function a(t,e){return Math.round((/%/.test(t)?("x"===e?E.width():o())/100:1)*parseInt(t,10))}function s(t,e){return t.get("photo")||t.get("photoRegex").test(e)}function l(t,e){return t.get("retinaUrl")&&i.devicePixelRatio>1?e.replace(t.get("photoRegex"),t.get("retinaSuffix")):e}function d(t){"contains"in x[0]&&!x[0].contains(t.target)&&t.target!==v[0]&&(t.stopPropagation(),x.focus())}function c(t){c.str!==t&&(x.add(v).removeClass(c.str).addClass(t),c.str=t)}function g(e){A=0,e&&e!==!1&&"nofollow"!==e?(W=t("."+te).filter(function(){var i=t.data(this,Y),n=new r(this,i);return n.get("rel")===e}),A=W.index(_.el),-1===A&&(W=W.add(_.el),A=W.length-1)):W=t(_.el)}function u(i){t(e).trigger(i),ae.triggerHandler(i)}function f(i){var o;if(!G){if(o=t(i).data(Y),_=new r(i,o),g(_.get("rel")),!$){$=q=!0,c(_.get("className")),x.css({visibility:"hidden",display:"block",opacity:""}),I=n(se,"LoadedContent","width:0; height:0; overflow:hidden; visibility:hidden"),b.css({width:"",height:""}).append(I),j=T.height()+k.height()+b.outerHeight(!0)-b.height(),D=C.width()+H.width()+b.outerWidth(!0)-b.width(),N=I.outerHeight(!0),z=I.outerWidth(!0);var h=a(_.get("initialWidth"),"x"),s=a(_.get("initialHeight"),"y"),l=_.get("maxWidth"),f=_.get("maxHeight");_.w=Math.max((l!==!1?Math.min(h,a(l,"x")):h)-z-D,0),_.h=Math.max((f!==!1?Math.min(s,a(f,"y")):s)-N-j,0),I.css({width:"",height:_.h}),J.position(),u(ee),_.get("onOpen"),O.add(F).hide(),x.focus(),_.get("trapFocus")&&e.addEventListener&&(e.addEventListener("focus",d,!0),ae.one(re,function(){e.removeEventListener("focus",d,!0)})),_.get("returnFocus")&&ae.one(re,function(){t(_.el).focus()})}var p=parseFloat(_.get("opacity"));v.css({opacity:p===p?p:"",cursor:_.get("overlayClose")?"pointer":"",visibility:"visible"}).show(),_.get("closeButton")?B.html(_.get("close")).appendTo(b):B.appendTo("<div/>"),w()}}function p(){x||(V=!1,E=t(i),x=n(se).attr({id:Y,"class":t.support.opacity===!1?Z+"IE":"",role:"dialog",tabindex:"-1"}).hide(),v=n(se,"Overlay").hide(),L=t([n(se,"LoadingOverlay")[0],n(se,"LoadingGraphic")[0]]),y=n(se,"Wrapper"),b=n(se,"Content").append(F=n(se,"Title"),R=n(se,"Current"),P=t('<button type="button"/>').attr({id:Z+"Previous"}),K=t('<button type="button"/>').attr({id:Z+"Next"}),S=n("button","Slideshow"),L),B=t('<button type="button"/>').attr({id:Z+"Close"}),y.append(n(se).append(n(se,"TopLeft"),T=n(se,"TopCenter"),n(se,"TopRight")),n(se,!1,"clear:left").append(C=n(se,"MiddleLeft"),b,H=n(se,"MiddleRight")),n(se,!1,"clear:left").append(n(se,"BottomLeft"),k=n(se,"BottomCenter"),n(se,"BottomRight"))).find("div div").css({"float":"left"}),M=n(se,!1,"position:absolute; width:9999px; visibility:hidden; display:none; max-width:none;"),O=K.add(P).add(R).add(S)),e.body&&!x.parent().length&&t(e.body).append(v,x.append(y,M))}function m(){function i(t){t.which>1||t.shiftKey||t.altKey||t.metaKey||t.ctrlKey||(t.preventDefault(),f(this))}return x?(V||(V=!0,K.click(function(){J.next()}),P.click(function(){J.prev()}),B.click(function(){J.close()}),v.click(function(){_.get("overlayClose")&&J.close()}),t(e).bind("keydown."+Z,function(t){var e=t.keyCode;$&&_.get("escKey")&&27===e&&(t.preventDefault(),J.close()),$&&_.get("arrowKey")&&W[1]&&!t.altKey&&(37===e?(t.preventDefault(),P.click()):39===e&&(t.preventDefault(),K.click()))}),t.isFunction(t.fn.on)?t(e).on("click."+Z,"."+te,i):t("."+te).live("click."+Z,i)),!0):!1}function w(){var e,o,r,h=J.prep,d=++le;if(q=!0,U=!1,u(he),u(ie),_.get("onLoad"),_.h=_.get("height")?a(_.get("height"),"y")-N-j:_.get("innerHeight")&&a(_.get("innerHeight"),"y"),_.w=_.get("width")?a(_.get("width"),"x")-z-D:_.get("innerWidth")&&a(_.get("innerWidth"),"x"),_.mw=_.w,_.mh=_.h,_.get("maxWidth")&&(_.mw=a(_.get("maxWidth"),"x")-z-D,_.mw=_.w&&_.w<_.mw?_.w:_.mw),_.get("maxHeight")&&(_.mh=a(_.get("maxHeight"),"y")-N-j,_.mh=_.h&&_.h<_.mh?_.h:_.mh),e=_.get("href"),Q=setTimeout(function(){L.show()},100),_.get("inline")){var c=t(e);r=t("<div>").hide().insertBefore(c),ae.one(he,function(){r.replaceWith(c)}),h(c)}else _.get("iframe")?h(" "):_.get("html")?h(_.get("html")):s(_,e)?(e=l(_,e),U=_.get("createImg"),t(U).addClass(Z+"Photo").bind("error."+Z,function(){h(n(se,"Error").html(_.get("imgError")))}).one("load",function(){d===le&&setTimeout(function(){var e;_.get("retinaImage")&&i.devicePixelRatio>1&&(U.height=U.height/i.devicePixelRatio,U.width=U.width/i.devicePixelRatio),_.get("scalePhotos")&&(o=function(){U.height-=U.height*e,U.width-=U.width*e},_.mw&&U.width>_.mw&&(e=(U.width-_.mw)/U.width,o()),_.mh&&U.height>_.mh&&(e=(U.height-_.mh)/U.height,o())),_.h&&(U.style.marginTop=Math.max(_.mh-U.height,0)/2+"px"),W[1]&&(_.get("loop")||W[A+1])&&(U.style.cursor="pointer",t(U).bind("click."+Z,function(){J.next()})),U.style.width=U.width+"px",U.style.height=U.height+"px",h(U)},1)}),U.src=e):e&&M.load(e,_.get("data"),function(e,i){d===le&&h("error"===i?n(se,"Error").html(_.get("xhrError")):t(this).contents())})}var v,x,y,b,T,C,H,k,W,E,I,M,L,F,R,S,K,P,B,O,_,j,D,N,z,A,U,$,q,G,Q,J,V,X={html:!1,photo:!1,iframe:!1,inline:!1,transition:"elastic",speed:300,fadeOut:300,width:!1,initialWidth:"600",innerWidth:!1,maxWidth:!1,height:!1,initialHeight:"450",innerHeight:!1,maxHeight:!1,scalePhotos:!0,scrolling:!0,opacity:.9,preloading:!0,className:!1,overlayClose:!0,escKey:!0,arrowKey:!0,top:!1,bottom:!1,left:!1,right:!1,fixed:!1,data:void 0,closeButton:!0,fastIframe:!0,open:!1,reposition:!0,loop:!0,slideshow:!1,slideshowAuto:!0,slideshowSpeed:2500,slideshowStart:"start slideshow",slideshowStop:"stop slideshow",photoRegex:/\.(gif|png|jp(e|g|eg)|bmp|ico|webp|jxr|svg)((#|\?).*)?$/i,retinaImage:!1,retinaUrl:!1,retinaSuffix:"@2x.$1",current:"image {current} of {total}",previous:"previous",next:"next",close:"close",xhrError:"This content failed to load.",imgError:"This image failed to load.",returnFocus:!0,trapFocus:!0,onOpen:!1,onLoad:!1,onComplete:!1,onCleanup:!1,onClosed:!1,rel:function(){return this.rel},href:function(){return t(this).attr("href")},title:function(){return this.title},createImg:function(){var e=new Image,i=t(this).data("cbox-img-attrs");return"object"==typeof i&&t.each(i,function(t,i){e[t]=i}),e},createIframe:function(){var i=e.createElement("iframe"),n=t(this).data("cbox-iframe-attrs");return"object"==typeof n&&t.each(n,function(t,e){i[t]=e}),"frameBorder"in i&&(i.frameBorder=0),"allowTransparency"in i&&(i.allowTransparency="true"),i.name=(new Date).getTime(),i.allowFullscreen=!0,i}},Y="colorbox",Z="cbox",te=Z+"Element",ee=Z+"_open",ie=Z+"_load",ne=Z+"_complete",oe=Z+"_cleanup",re=Z+"_closed",he=Z+"_purge",ae=t("<a/>"),se="div",le=0,de={},ce=function(){function t(){clearTimeout(h)}function e(){(_.get("loop")||W[A+1])&&(t(),h=setTimeout(J.next,_.get("slideshowSpeed")))}function i(){S.html(_.get("slideshowStop")).unbind(s).one(s,n),ae.bind(ne,e).bind(ie,t),x.removeClass(a+"off").addClass(a+"on")}function n(){t(),ae.unbind(ne,e).unbind(ie,t),S.html(_.get("slideshowStart")).unbind(s).one(s,function(){J.next(),i()}),x.removeClass(a+"on").addClass(a+"off")}function o(){r=!1,S.hide(),t(),ae.unbind(ne,e).unbind(ie,t),x.removeClass(a+"off "+a+"on")}var r,h,a=Z+"Slideshow_",s="click."+Z;return function(){r?_.get("slideshow")||(ae.unbind(oe,o),o()):_.get("slideshow")&&W[1]&&(r=!0,ae.one(oe,o),_.get("slideshowAuto")?i():n(),S.show())}}();t[Y]||(t(p),J=t.fn[Y]=t[Y]=function(e,i){var n,o=this;return e=e||{},t.isFunction(o)&&(o=t("<a/>"),e.open=!0),o[0]?(p(),m()&&(i&&(e.onComplete=i),o.each(function(){var i=t.data(this,Y)||{};t.data(this,Y,t.extend(i,e))}).addClass(te),n=new r(o[0],e),n.get("open")&&f(o[0])),o):o},J.position=function(e,i){function n(){T[0].style.width=k[0].style.width=b[0].style.width=parseInt(x[0].style.width,10)-D+"px",b[0].style.height=C[0].style.height=H[0].style.height=parseInt(x[0].style.height,10)-j+"px"}var r,h,s,l=0,d=0,c=x.offset();if(E.unbind("resize."+Z),x.css({top:-9e4,left:-9e4}),h=E.scrollTop(),s=E.scrollLeft(),_.get("fixed")?(c.top-=h,c.left-=s,x.css({position:"fixed"})):(l=h,d=s,x.css({position:"absolute"})),d+=_.get("right")!==!1?Math.max(E.width()-_.w-z-D-a(_.get("right"),"x"),0):_.get("left")!==!1?a(_.get("left"),"x"):Math.round(Math.max(E.width()-_.w-z-D,0)/2),l+=_.get("bottom")!==!1?Math.max(o()-_.h-N-j-a(_.get("bottom"),"y"),0):_.get("top")!==!1?a(_.get("top"),"y"):Math.round(Math.max(o()-_.h-N-j,0)/2),x.css({top:c.top,left:c.left,visibility:"visible"}),y[0].style.width=y[0].style.height="9999px",r={width:_.w+z+D,height:_.h+N+j,top:l,left:d},e){var g=0;t.each(r,function(t){return r[t]!==de[t]?(g=e,void 0):void 0}),e=g}de=r,e||x.css(r),x.dequeue().animate(r,{duration:e||0,complete:function(){n(),q=!1,y[0].style.width=_.w+z+D+"px",y[0].style.height=_.h+N+j+"px",_.get("reposition")&&setTimeout(function(){E.bind("resize."+Z,J.position)},1),t.isFunction(i)&&i()},step:n})},J.resize=function(t){var e;$&&(t=t||{},t.width&&(_.w=a(t.width,"x")-z-D),t.innerWidth&&(_.w=a(t.innerWidth,"x")),I.css({width:_.w}),t.height&&(_.h=a(t.height,"y")-N-j),t.innerHeight&&(_.h=a(t.innerHeight,"y")),t.innerHeight||t.height||(e=I.scrollTop(),I.css({height:"auto"}),_.h=I.height()),I.css({height:_.h}),e&&I.scrollTop(e),J.position("none"===_.get("transition")?0:_.get("speed")))},J.prep=function(i){function o(){return _.w=_.w||I.width(),_.w=_.mw&&_.mw<_.w?_.mw:_.w,_.w}function a(){return _.h=_.h||I.height(),_.h=_.mh&&_.mh<_.h?_.mh:_.h,_.h}if($){var d,g="none"===_.get("transition")?0:_.get("speed");I.remove(),I=n(se,"LoadedContent").append(i),I.hide().appendTo(M.show()).css({width:o(),overflow:_.get("scrolling")?"auto":"hidden"}).css({height:a()}).prependTo(b),M.hide(),t(U).css({"float":"none"}),c(_.get("className")),d=function(){function i(){t.support.opacity===!1&&x[0].style.removeAttribute("filter")}var n,o,a=W.length;$&&(o=function(){clearTimeout(Q),L.hide(),u(ne),_.get("onComplete")},F.html(_.get("title")).show(),I.show(),a>1?("string"==typeof _.get("current")&&R.html(_.get("current").replace("{current}",A+1).replace("{total}",a)).show(),K[_.get("loop")||a-1>A?"show":"hide"]().html(_.get("next")),P[_.get("loop")||A?"show":"hide"]().html(_.get("previous")),ce(),_.get("preloading")&&t.each([h(-1),h(1)],function(){var i,n=W[this],o=new r(n,t.data(n,Y)),h=o.get("href");h&&s(o,h)&&(h=l(o,h),i=e.createElement("img"),i.src=h)})):O.hide(),_.get("iframe")?(n=_.get("createIframe"),_.get("scrolling")||(n.scrolling="no"),t(n).attr({src:_.get("href"),"class":Z+"Iframe"}).one("load",o).appendTo(I),ae.one(he,function(){n.src="//about:blank"}),_.get("fastIframe")&&t(n).trigger("load")):o(),"fade"===_.get("transition")?x.fadeTo(g,1,i):i())},"fade"===_.get("transition")?x.fadeTo(g,0,function(){J.position(0,d)}):J.position(g,d)}},J.next=function(){!q&&W[1]&&(_.get("loop")||W[A+1])&&(A=h(1),f(W[A]))},J.prev=function(){!q&&W[1]&&(_.get("loop")||A)&&(A=h(-1),f(W[A]))},J.close=function(){$&&!G&&(G=!0,$=!1,u(oe),_.get("onCleanup"),E.unbind("."+Z),v.fadeTo(_.get("fadeOut")||0,0),x.stop().fadeTo(_.get("fadeOut")||0,0,function(){x.hide(),v.hide(),u(he),I.remove(),setTimeout(function(){G=!1,u(re),_.get("onClosed")},1)}))},J.remove=function(){x&&(x.stop(),t[Y].close(),x.stop(!1,!0).remove(),v.remove(),G=!1,x=null,t("."+te).removeData(Y).removeClass(te),t(e).unbind("click."+Z).unbind("keydown."+Z))},J.element=function(){return t(_.el)},J.settings=X)})(jQuery,document,window);
/*! jQuery UI - v1.10.0 - 2013-01-17
* http://jqueryui.com
* Includes: jquery.ui.datepicker-ja.js
* Copyright 2013 jQuery Foundation and other contributors; Licensed MIT */
jQuery(function(e){e.datepicker.regional.ja={closeText:"閉じる",prevText:"&#x3C;前",nextText:"次&#x3E;",currentText:"今日",monthNames:["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],monthNamesShort:["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],dayNames:["日曜日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日"],dayNamesShort:["日","月","火","水","木","金","土"],dayNamesMin:["日","月","火","水","木","金","土"],weekHeader:"週",dateFormat:"yy/mm/dd",firstDay:0,isRTL:!1,showMonthAfterYear:!0,yearSuffix:"年"},e.datepicker.setDefaults(e.datepicker.regional.ja)});
// tipsy, facebook style tooltips for jquery
// version 1.0.0a
// (c) 2008-2010 jason frame [jason@onehackoranother.com]
// released under the MIT license

(function($, window, undefined) {

    function maybeCall(thing, ctx) {
        return (typeof thing == 'function') ? (thing.call(ctx)) : thing;
    }

    function isElementInDOM(ele) {
        while (ele = ele.parentNode) {
            if (ele == document) return true;
        }
        return false;
    }

	// Returns true if it is a DOM element
	// http://stackoverflow.com/a/384380/999
	function isElement(o){
		return (
			typeof HTMLElement === "object" ? o instanceof HTMLElement : //DOM2
			o && typeof o === "object" && o.nodeType === 1 && typeof o.nodeName==="string"
		);	
	}

    var tipsyIDcounter = 0;
    function tipsyID() {
        return "tipsyuid" + (tipsyIDcounter++);
    }

    function Tipsy(element, options) {
        this.$element = $(element);
        this.options = options;
        this.enabled = true;
        this.fixTitle();
    }

    Tipsy.prototype = {
        show: function() {
            if (!isElementInDOM(this.$element[0])) {
                return;
            }

            if (isElement(this.$element) && !this.$element.is(':visible')) { 
                return; 
            }
            
            var title;
            if (this.enabled && (title = this.getTitle())) {
                var $tip = this.tip();

                $tip.find('.tipsy-inner' + this.options.theme)[this.options.html ? 'html' : 'text'](title);

                $tip[0].className = 'tipsy' + this.options.theme; // reset classname in case of dynamic gravity
                if (this.options.className) {
                    $tip.addClass(maybeCall(this.options.className, this.$element[0]));
                }

                $tip.remove().css({top: 0, left: 0, visibility: 'hidden', display: 'block'}).prependTo(document.body);

                var pos = $.extend({}, this.$element.offset());

                // If the element is contained in a SVG object, use getBBox
                if (this.$element.parents('svg').size() > 0) {
                    pos = $.extend(pos, this.$element[0].getBBox());
                } else {
                    pos = $.extend(pos, {
                        width: this.$element[0].offsetWidth || 0,
                        height: this.$element[0].offsetHeight || 0
                    });
                }

                var actualWidth = $tip[0].offsetWidth,
                    actualHeight = $tip[0].offsetHeight,
                    gravity = maybeCall(this.options.gravity, this.$element[0]);

                var tp;
                switch (gravity.charAt(0)) {
                    case 'n':
                        tp = {top: pos.top + pos.height + this.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
                        break;
                    case 's':
                        tp = {top: pos.top - actualHeight - this.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
                        break;
                    case 'e':
                        tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth - this.options.offset};
                        break;
                    case 'w':
                        tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width + this.options.offset};
                        break;
                    default:
                        break;
                }

                if (gravity.length == 2) {
                    if (gravity.charAt(1) == 'w') {
                        tp.left = pos.left + pos.width / 2 - 15;
                    } else {
                        tp.left = pos.left + pos.width / 2 - actualWidth + 15;
                    }
                }

                $tip.css(tp).addClass('tipsy-' + gravity + this.options.theme);
                $tip.find('.tipsy-arrow' + this.options.theme)[0].className = 'tipsy-arrow' + this.options.theme + ' tipsy-arrow-' + gravity.charAt(0) + this.options.theme;
                $tip.css({width: (actualWidth - 10) + 'px'});

                if (this.options.fade) {
                    if(this.options.shadow)
                        $(".tipsy-inner").css({'box-shadow': '0px 0px '+this.options.shadowBlur+'px '+this.options.shadowSpread+'px rgba(0, 0, 0, '+this.options.shadowOpacity+')', '-webkit-box-shadow': '0px 0px '+this.options.shadowBlur+'px '+this.options.shadowSpread+'px rgba(0, 0, 0, '+this.options.shadowOpacity+')'});
                    $tip.stop().css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: this.options.opacity}, this.options.fadeInTime);
                } else {
                    $tip.css({visibility: 'visible', opacity: this.options.opacity});
                }

                if (this.options.aria) {
                    var $tipID = tipsyID();
                    $tip.attr("id", $tipID);
                    this.$element.attr("aria-describedby", $tipID);
                }
            }
        },

        hide: function() {
            if (this.options.fade) {
                this.tip().stop().fadeOut(this.options.fadeOutTime, function() { $(this).remove(); });
            } else {
                this.tip().remove();
            }
            if (this.options.aria) {
                this.$element.removeAttr("aria-describedby");
            }
        },

        fixTitle: function() {
            var $e = this.$element;
            if ($e.attr('title') || typeof($e.attr('original-title')) != 'string') {
                $e.attr('original-title', $e.attr('title') || '').removeAttr('title');
            }
        },

        getTitle: function() {
            var title, $e = this.$element, o = this.options;
            this.fixTitle();
            if (typeof o.title == 'string') {
                title = $e.attr(o.title == 'title' ? 'original-title' : o.title);
            } else if (typeof o.title == 'function') {
                title = o.title.call($e[0]);
            }
            title = ('' + title).replace(/(^\s*|\s*$)/, "");
            return title || o.fallback;
        },

        tip: function() {
            if (!this.$tip) {
                this.$tip = $('<div class="tipsy' + this.options.theme + '"></div>').html('<div class="tipsy-arrow' + this.options.theme + '"></div><div class="tipsy-inner' + this.options.theme + '"></div>').attr("role","tooltip");
                this.$tip.data('tipsy-pointee', this.$element[0]);
            }
            return this.$tip;
        },

        validate: function() {
            if (!this.$element[0].parentNode) {
                this.hide();
                this.$element = null;
                this.options = null;
            }
        },

        enable: function() { this.enabled = true; },
        disable: function() { this.enabled = false; },
        toggleEnabled: function() { this.enabled = !this.enabled; }
    };

    $.fn.tipsy = function(options) {

        $.fn.tipsy.enable();

        if (options === true) {
            return this.data('tipsy');
        } else if (typeof options == 'string') {
            var tipsy = this.data('tipsy');
            if (tipsy) tipsy[options]();
            return this;
        }

        options = $.extend({}, $.fn.tipsy.defaults, options);

        // Establish theme
        options.theme = (options.theme && options.theme !== '') ? '-' + options.theme : '';

        function get(ele) {
            var tipsy = $.data(ele, 'tipsy');
            if (!tipsy) {
                tipsy = new Tipsy(ele, $.fn.tipsy.elementOptions(ele, options));
                $.data(ele, 'tipsy', tipsy);
            }
            return tipsy;
        }

        function enter() {
            if ($.fn.tipsy.enabled !== true) {
                return;
            }
            var tipsy = get(this);
            tipsy.hoverState = 'in';
            if (options.delayIn === 0) {
                tipsy.show();
            } else {
                tipsy.fixTitle();
                setTimeout(function() {
                    if (tipsy.hoverState == 'in' && isElementInDOM(tipsy.$element)) {
                        tipsy.show();
                    }
                }, options.delayIn);
            }
        }

        function leave() {
            var tipsy = get(this);
            tipsy.hoverState = 'out';
            if (options.delayOut === 0) {
                tipsy.hide();
            } else {
                setTimeout(function() { if (tipsy.hoverState == 'out' || !tipsy.$element || !tipsy.$element.is(':visible')) tipsy.hide(); }, options.delayOut);
            }
        }

        if (!options.live) this.each(function() { get(this); });

        if (options.trigger != 'manual') {
            var eventIn  = options.trigger == 'hover' ? 'mouseenter mouseover' : 'focus',
                eventOut = options.trigger == 'hover' ? 'mouseleave mouseout' : 'blur';

            if (options.live && options.live !== true) {
                $(this).on(eventIn, options.live, enter);
                $(this).on(eventOut, options.live, leave);
            } else {
                if (options.live && !$.live) {
                    //live === true and using jQuery >= 1.9
                    throw "Since jQuery 1.9, pass selector as live argument. eg. $(document).tipsy({live: 'a.live'});";
                }
                var binder = options.live ? 'live' : 'bind';
                this[binder](eventIn, enter)[binder](eventOut, leave);
            }
        }

        return this;

    };

    $.fn.tipsy.defaults = {
        aria: false,
        className: null,
        delayIn: 0,
        delayOut: 0,
        fade: false,
        fadeInTime: 400,
        fadeOutTime: 400, 
        shadow: false,
        shadowBlur: 8,
        shadowOpacity: 1,
        shadowSpread: 0,
        fallback: '',
        gravity: 'n',
        html: false,
        live: false,
        offset: 0,
        opacity: 0.8,
        title: 'title',
        trigger: 'hover',
        theme: ''
    };

    $.fn.tipsy.revalidate = function() {
      $('.tipsy').each(function() {
        var pointee = $.data(this, 'tipsy-pointee');
        if (!pointee || !isElementInDOM(pointee)) {
          $(this).remove();
        }
      });
    };

    $.fn.tipsy.enable = function() {
        $.fn.tipsy.enabled = true;
    };

    $.fn.tipsy.disable = function() {
        $.fn.tipsy.enabled = false;
    };

    // Overwrite this method to provide options on a per-element basis.
    // For example, you could store the gravity in a 'tipsy-gravity' attribute:
    // return $.extend({}, options, {gravity: $(ele).attr('tipsy-gravity') || 'n' });
    // (remember - do not modify 'options' in place!)
    $.fn.tipsy.elementOptions = function(ele, options) {
        return $.metadata ? $.extend({}, options, $(ele).metadata()) : options;
    };

    $.fn.tipsy.autoNS = function() {
        return $(this).offset().top > ($(document).scrollTop() + $(window).height() / 2) ? 's' : 'n';
    };

    $.fn.tipsy.autoWE = function() {
        return $(this).offset().left > ($(document).scrollLeft() + $(window).width() / 2) ? 'e' : 'w';
    };

    $.fn.tipsy.autoNWNE = function() {
        return $(this).offset().left > ($(document).scrollLeft() + $(window).width() / 2) ? 'ne' : 'nw';
    };

    $.fn.tipsy.autoSWSE = function() {
        return $(this).offset().left > ($(document).scrollLeft() + $(window).width() / 2) ? 'se' : 'sw';
    };

    /**
     * yields a closure of the supplied parameters, producing a function that takes
     * no arguments and is suitable for use as an autogravity function like so:
     *
     * @param margin (int) - distance from the viewable region edge that an
     *        element should be before setting its tooltip's gravity to be away
     *        from that edge.
     * @param prefer (string, e.g. 'n', 'sw', 'w') - the direction to prefer
     *        if there are no viewable region edges effecting the tooltip's
     *        gravity. It will try to vary from this minimally, for example,
     *        if 'sw' is preferred and an element is near the right viewable
     *        region edge, but not the top edge, it will set the gravity for
     *        that element's tooltip to be 'se', preserving the southern
     *        component.
     */
    $.fn.tipsy.autoBounds = function(marginNorth, marginEast, prefer) {
        return function() {
            var dir = {ns: prefer[0], ew: (prefer.length > 1 ? prefer[1] : false)},
                boundTop = $(document).scrollTop() + marginNorth,
                boundLeft = $(document).scrollLeft() + marginEast,
                $this = $(this);

            if ($this.offset().top < boundTop) dir.ns = 'n';
            if ($this.offset().left < boundLeft) dir.ew = 'w';
            if ($(window).width() + $(document).scrollLeft() - $this.offset().left < marginEast) dir.ew = 'e';
            if ($(window).height() + $(document).scrollTop() - $this.offset().top < marginNorth) dir.ns = 's';

            return dir.ns + (dir.ew ? dir.ew : '');
        };
    };

    /**
     * Improved version of autoBounds for automatic placement of chunky tips
     * The original autoBounds failed in two regards: 1. it would never return a 'w' or 'e', gravity even if they
     * were preferred and/or optimal, 2. it only respected the margin between the left hand side of an element and
     * left hand side of the viewport, and the top of an element and the top of the viewport. This version checks
     * to see if the bottom of an element is too close to the bottom of the screen, similarly for the right hand side
     */
    $.fn.tipsy.autoBounds2 = function(margin, prefer) {
        return function() {
            var dir = {},
                boundTop = $(document).scrollTop() + margin,
                boundLeft = $(document).scrollLeft() + margin,
                $this = $(this);

            // bi-directional string (ne, se, sw, etc...)
            if (prefer.length > 1) {
                dir.ns = prefer[0];
                dir.ew = prefer[1];
            } else {
                // single direction string (e, w, n or s)
                if (prefer[0] == 'e' || prefer[0] == 'w') {
                    dir.ew = prefer[0];
                } else {
                    dir.ns = prefer[0];
                }
            }

            if ($this.offset().top < boundTop) dir.ns = 'n';
            if ($this.offset().left < boundLeft) dir.ew = 'w';
            if ($(window).width() + $(document).scrollLeft() - ($this.offset().left + $this.width()) < margin) dir.ew = 'e';
            if ($(window).height() + $(document).scrollTop() - ($this.offset().top + $this.height()) < margin) dir.ns = 's';

            if (dir.ns) {
                return dir.ns + (dir.ew ? dir.ew : '');
            }
            return dir.ew;
        }
    };
    
})(jQuery, window);
/**
 * jquery.Jcrop.min.js v0.9.12 (build:20130202)
 * jQuery Image Cropping Plugin - released under MIT License
 * Copyright (c) 2008-2013 Tapmodo Interactive LLC
 * https://github.com/tapmodo/Jcrop
 */
(function(a){a.Jcrop=function(b,c){function i(a){return Math.round(a)+"px"}function j(a){return d.baseClass+"-"+a}function k(){return a.fx.step.hasOwnProperty("backgroundColor")}function l(b){var c=a(b).offset();return[c.left,c.top]}function m(a){return[a.pageX-e[0],a.pageY-e[1]]}function n(b){typeof b!="object"&&(b={}),d=a.extend(d,b),a.each(["onChange","onSelect","onRelease","onDblClick"],function(a,b){typeof d[b]!="function"&&(d[b]=function(){})})}function o(a,b,c){e=l(D),bc.setCursor(a==="move"?a:a+"-resize");if(a==="move")return bc.activateHandlers(q(b),v,c);var d=_.getFixed(),f=r(a),g=_.getCorner(r(f));_.setPressed(_.getCorner(f)),_.setCurrent(g),bc.activateHandlers(p(a,d),v,c)}function p(a,b){return function(c){if(!d.aspectRatio)switch(a){case"e":c[1]=b.y2;break;case"w":c[1]=b.y2;break;case"n":c[0]=b.x2;break;case"s":c[0]=b.x2}else switch(a){case"e":c[1]=b.y+1;break;case"w":c[1]=b.y+1;break;case"n":c[0]=b.x+1;break;case"s":c[0]=b.x+1}_.setCurrent(c),bb.update()}}function q(a){var b=a;return bd.watchKeys
(),function(a){_.moveOffset([a[0]-b[0],a[1]-b[1]]),b=a,bb.update()}}function r(a){switch(a){case"n":return"sw";case"s":return"nw";case"e":return"nw";case"w":return"ne";case"ne":return"sw";case"nw":return"se";case"se":return"nw";case"sw":return"ne"}}function s(a){return function(b){return d.disabled?!1:a==="move"&&!d.allowMove?!1:(e=l(D),W=!0,o(a,m(b)),b.stopPropagation(),b.preventDefault(),!1)}}function t(a,b,c){var d=a.width(),e=a.height();d>b&&b>0&&(d=b,e=b/a.width()*a.height()),e>c&&c>0&&(e=c,d=c/a.height()*a.width()),T=a.width()/d,U=a.height()/e,a.width(d).height(e)}function u(a){return{x:a.x*T,y:a.y*U,x2:a.x2*T,y2:a.y2*U,w:a.w*T,h:a.h*U}}function v(a){var b=_.getFixed();b.w>d.minSelect[0]&&b.h>d.minSelect[1]?(bb.enableHandles(),bb.done()):bb.release(),bc.setCursor(d.allowSelect?"crosshair":"default")}function w(a){if(d.disabled)return!1;if(!d.allowSelect)return!1;W=!0,e=l(D),bb.disableHandles(),bc.setCursor("crosshair");var b=m(a);return _.setPressed(b),bb.update(),bc.activateHandlers(x,v,a.type.substring
(0,5)==="touch"),bd.watchKeys(),a.stopPropagation(),a.preventDefault(),!1}function x(a){_.setCurrent(a),bb.update()}function y(){var b=a("<div></div>").addClass(j("tracker"));return g&&b.css({opacity:0,backgroundColor:"white"}),b}function be(a){G.removeClass().addClass(j("holder")).addClass(a)}function bf(a,b){function t(){window.setTimeout(u,l)}var c=a[0]/T,e=a[1]/U,f=a[2]/T,g=a[3]/U;if(X)return;var h=_.flipCoords(c,e,f,g),i=_.getFixed(),j=[i.x,i.y,i.x2,i.y2],k=j,l=d.animationDelay,m=h[0]-j[0],n=h[1]-j[1],o=h[2]-j[2],p=h[3]-j[3],q=0,r=d.swingSpeed;c=k[0],e=k[1],f=k[2],g=k[3],bb.animMode(!0);var s,u=function(){return function(){q+=(100-q)/r,k[0]=Math.round(c+q/100*m),k[1]=Math.round(e+q/100*n),k[2]=Math.round(f+q/100*o),k[3]=Math.round(g+q/100*p),q>=99.8&&(q=100),q<100?(bh(k),t()):(bb.done(),bb.animMode(!1),typeof b=="function"&&b.call(bs))}}();t()}function bg(a){bh([a[0]/T,a[1]/U,a[2]/T,a[3]/U]),d.onSelect.call(bs,u(_.getFixed())),bb.enableHandles()}function bh(a){_.setPressed([a[0],a[1]]),_.setCurrent([a[2],
a[3]]),bb.update()}function bi(){return u(_.getFixed())}function bj(){return _.getFixed()}function bk(a){n(a),br()}function bl(){d.disabled=!0,bb.disableHandles(),bb.setCursor("default"),bc.setCursor("default")}function bm(){d.disabled=!1,br()}function bn(){bb.done(),bc.activateHandlers(null,null)}function bo(){G.remove(),A.show(),A.css("visibility","visible"),a(b).removeData("Jcrop")}function bp(a,b){bb.release(),bl();var c=new Image;c.onload=function(){var e=c.width,f=c.height,g=d.boxWidth,h=d.boxHeight;D.width(e).height(f),D.attr("src",a),H.attr("src",a),t(D,g,h),E=D.width(),F=D.height(),H.width(E).height(F),M.width(E+L*2).height(F+L*2),G.width(E).height(F),ba.resize(E,F),bm(),typeof b=="function"&&b.call(bs)},c.src=a}function bq(a,b,c){var e=b||d.bgColor;d.bgFade&&k()&&d.fadeTime&&!c?a.animate({backgroundColor:e},{queue:!1,duration:d.fadeTime}):a.css("backgroundColor",e)}function br(a){d.allowResize?a?bb.enableOnly():bb.enableHandles():bb.disableHandles(),bc.setCursor(d.allowSelect?"crosshair":"default"),bb
.setCursor(d.allowMove?"move":"default"),d.hasOwnProperty("trueSize")&&(T=d.trueSize[0]/E,U=d.trueSize[1]/F),d.hasOwnProperty("setSelect")&&(bg(d.setSelect),bb.done(),delete d.setSelect),ba.refresh(),d.bgColor!=N&&(bq(d.shade?ba.getShades():G,d.shade?d.shadeColor||d.bgColor:d.bgColor),N=d.bgColor),O!=d.bgOpacity&&(O=d.bgOpacity,d.shade?ba.refresh():bb.setBgOpacity(O)),P=d.maxSize[0]||0,Q=d.maxSize[1]||0,R=d.minSize[0]||0,S=d.minSize[1]||0,d.hasOwnProperty("outerImage")&&(D.attr("src",d.outerImage),delete d.outerImage),bb.refresh()}var d=a.extend({},a.Jcrop.defaults),e,f=navigator.userAgent.toLowerCase(),g=/msie/.test(f),h=/msie [1-6]\./.test(f);typeof b!="object"&&(b=a(b)[0]),typeof c!="object"&&(c={}),n(c);var z={border:"none",visibility:"visible",margin:0,padding:0,position:"absolute",top:0,left:0},A=a(b),B=!0;if(b.tagName=="IMG"){if(A[0].width!=0&&A[0].height!=0)A.width(A[0].width),A.height(A[0].height);else{var C=new Image;C.src=A[0].src,A.width(C.width),A.height(C.height)}var D=A.clone().removeAttr("id").
css(z).show();D.width(A.width()),D.height(A.height()),A.after(D).hide()}else D=A.css(z).show(),B=!1,d.shade===null&&(d.shade=!0);t(D,d.boxWidth,d.boxHeight);var E=D.width(),F=D.height(),G=a("<div />").width(E).height(F).addClass(j("holder")).css({position:"relative",backgroundColor:d.bgColor}).insertAfter(A).append(D);d.addClass&&G.addClass(d.addClass);var H=a("<div />"),I=a("<div />").width("100%").height("100%").css({zIndex:310,position:"absolute",overflow:"hidden"}),J=a("<div />").width("100%").height("100%").css("zIndex",320),K=a("<div />").css({position:"absolute",zIndex:600}).dblclick(function(){var a=_.getFixed();d.onDblClick.call(bs,a)}).insertBefore(D).append(I,J);B&&(H=a("<img />").attr("src",D.attr("src")).css(z).width(E).height(F),I.append(H)),h&&K.css({overflowY:"hidden"});var L=d.boundary,M=y().width(E+L*2).height(F+L*2).css({position:"absolute",top:i(-L),left:i(-L),zIndex:290}).mousedown(w),N=d.bgColor,O=d.bgOpacity,P,Q,R,S,T,U,V=!0,W,X,Y;e=l(D);var Z=function(){function a(){var a={},b=["touchstart"
,"touchmove","touchend"],c=document.createElement("div"),d;try{for(d=0;d<b.length;d++){var e=b[d];e="on"+e;var f=e in c;f||(c.setAttribute(e,"return;"),f=typeof c[e]=="function"),a[b[d]]=f}return a.touchstart&&a.touchend&&a.touchmove}catch(g){return!1}}function b(){return d.touchSupport===!0||d.touchSupport===!1?d.touchSupport:a()}return{createDragger:function(a){return function(b){return d.disabled?!1:a==="move"&&!d.allowMove?!1:(e=l(D),W=!0,o(a,m(Z.cfilter(b)),!0),b.stopPropagation(),b.preventDefault(),!1)}},newSelection:function(a){return w(Z.cfilter(a))},cfilter:function(a){return a.pageX=a.originalEvent.changedTouches[0].pageX,a.pageY=a.originalEvent.changedTouches[0].pageY,a},isSupported:a,support:b()}}(),_=function(){function h(d){d=n(d),c=a=d[0],e=b=d[1]}function i(a){a=n(a),f=a[0]-c,g=a[1]-e,c=a[0],e=a[1]}function j(){return[f,g]}function k(d){var f=d[0],g=d[1];0>a+f&&(f-=f+a),0>b+g&&(g-=g+b),F<e+g&&(g+=F-(e+g)),E<c+f&&(f+=E-(c+f)),a+=f,c+=f,b+=g,e+=g}function l(a){var b=m();switch(a){case"ne":return[
b.x2,b.y];case"nw":return[b.x,b.y];case"se":return[b.x2,b.y2];case"sw":return[b.x,b.y2]}}function m(){if(!d.aspectRatio)return p();var f=d.aspectRatio,g=d.minSize[0]/T,h=d.maxSize[0]/T,i=d.maxSize[1]/U,j=c-a,k=e-b,l=Math.abs(j),m=Math.abs(k),n=l/m,r,s,t,u;return h===0&&(h=E*10),i===0&&(i=F*10),n<f?(s=e,t=m*f,r=j<0?a-t:t+a,r<0?(r=0,u=Math.abs((r-a)/f),s=k<0?b-u:u+b):r>E&&(r=E,u=Math.abs((r-a)/f),s=k<0?b-u:u+b)):(r=c,u=l/f,s=k<0?b-u:b+u,s<0?(s=0,t=Math.abs((s-b)*f),r=j<0?a-t:t+a):s>F&&(s=F,t=Math.abs(s-b)*f,r=j<0?a-t:t+a)),r>a?(r-a<g?r=a+g:r-a>h&&(r=a+h),s>b?s=b+(r-a)/f:s=b-(r-a)/f):r<a&&(a-r<g?r=a-g:a-r>h&&(r=a-h),s>b?s=b+(a-r)/f:s=b-(a-r)/f),r<0?(a-=r,r=0):r>E&&(a-=r-E,r=E),s<0?(b-=s,s=0):s>F&&(b-=s-F,s=F),q(o(a,b,r,s))}function n(a){return a[0]<0&&(a[0]=0),a[1]<0&&(a[1]=0),a[0]>E&&(a[0]=E),a[1]>F&&(a[1]=F),[Math.round(a[0]),Math.round(a[1])]}function o(a,b,c,d){var e=a,f=c,g=b,h=d;return c<a&&(e=c,f=a),d<b&&(g=d,h=b),[e,g,f,h]}function p(){var d=c-a,f=e-b,g;return P&&Math.abs(d)>P&&(c=d>0?a+P:a-P),Q&&Math.abs
(f)>Q&&(e=f>0?b+Q:b-Q),S/U&&Math.abs(f)<S/U&&(e=f>0?b+S/U:b-S/U),R/T&&Math.abs(d)<R/T&&(c=d>0?a+R/T:a-R/T),a<0&&(c-=a,a-=a),b<0&&(e-=b,b-=b),c<0&&(a-=c,c-=c),e<0&&(b-=e,e-=e),c>E&&(g=c-E,a-=g,c-=g),e>F&&(g=e-F,b-=g,e-=g),a>E&&(g=a-F,e-=g,b-=g),b>F&&(g=b-F,e-=g,b-=g),q(o(a,b,c,e))}function q(a){return{x:a[0],y:a[1],x2:a[2],y2:a[3],w:a[2]-a[0],h:a[3]-a[1]}}var a=0,b=0,c=0,e=0,f,g;return{flipCoords:o,setPressed:h,setCurrent:i,getOffset:j,moveOffset:k,getCorner:l,getFixed:m}}(),ba=function(){function f(a,b){e.left.css({height:i(b)}),e.right.css({height:i(b)})}function g(){return h(_.getFixed())}function h(a){e.top.css({left:i(a.x),width:i(a.w),height:i(a.y)}),e.bottom.css({top:i(a.y2),left:i(a.x),width:i(a.w),height:i(F-a.y2)}),e.right.css({left:i(a.x2),width:i(E-a.x2)}),e.left.css({width:i(a.x)})}function j(){return a("<div />").css({position:"absolute",backgroundColor:d.shadeColor||d.bgColor}).appendTo(c)}function k(){b||(b=!0,c.insertBefore(D),g(),bb.setBgOpacity(1,0,1),H.hide(),l(d.shadeColor||d.bgColor,1),bb.
isAwake()?n(d.bgOpacity,1):n(1,1))}function l(a,b){bq(p(),a,b)}function m(){b&&(c.remove(),H.show(),b=!1,bb.isAwake()?bb.setBgOpacity(d.bgOpacity,1,1):(bb.setBgOpacity(1,1,1),bb.disableHandles()),bq(G,0,1))}function n(a,e){b&&(d.bgFade&&!e?c.animate({opacity:1-a},{queue:!1,duration:d.fadeTime}):c.css({opacity:1-a}))}function o(){d.shade?k():m(),bb.isAwake()&&n(d.bgOpacity)}function p(){return c.children()}var b=!1,c=a("<div />").css({position:"absolute",zIndex:240,opacity:0}),e={top:j(),left:j().height(F),right:j().height(F),bottom:j()};return{update:g,updateRaw:h,getShades:p,setBgColor:l,enable:k,disable:m,resize:f,refresh:o,opacity:n}}(),bb=function(){function k(b){var c=a("<div />").css({position:"absolute",opacity:d.borderOpacity}).addClass(j(b));return I.append(c),c}function l(b,c){var d=a("<div />").mousedown(s(b)).css({cursor:b+"-resize",position:"absolute",zIndex:c}).addClass("ord-"+b);return Z.support&&d.bind("touchstart.jcrop",Z.createDragger(b)),J.append(d),d}function m(a){var b=d.handleSize,e=l(a,c++
).css({opacity:d.handleOpacity}).addClass(j("handle"));return b&&e.width(b).height(b),e}function n(a){return l(a,c++).addClass("jcrop-dragbar")}function o(a){var b;for(b=0;b<a.length;b++)g[a[b]]=n(a[b])}function p(a){var b,c;for(c=0;c<a.length;c++){switch(a[c]){case"n":b="hline";break;case"s":b="hline bottom";break;case"e":b="vline right";break;case"w":b="vline"}e[a[c]]=k(b)}}function q(a){var b;for(b=0;b<a.length;b++)f[a[b]]=m(a[b])}function r(a,b){d.shade||H.css({top:i(-b),left:i(-a)}),K.css({top:i(b),left:i(a)})}function t(a,b){K.width(Math.round(a)).height(Math.round(b))}function v(){var a=_.getFixed();_.setPressed([a.x,a.y]),_.setCurrent([a.x2,a.y2]),w()}function w(a){if(b)return x(a)}function x(a){var c=_.getFixed();t(c.w,c.h),r(c.x,c.y),d.shade&&ba.updateRaw(c),b||A(),a?d.onSelect.call(bs,u(c)):d.onChange.call(bs,u(c))}function z(a,c,e){if(!b&&!c)return;d.bgFade&&!e?D.animate({opacity:a},{queue:!1,duration:d.fadeTime}):D.css("opacity",a)}function A(){K.show(),d.shade?ba.opacity(O):z(O,!0),b=!0}function B
(){F(),K.hide(),d.shade?ba.opacity(1):z(1),b=!1,d.onRelease.call(bs)}function C(){h&&J.show()}function E(){h=!0;if(d.allowResize)return J.show(),!0}function F(){h=!1,J.hide()}function G(a){a?(X=!0,F()):(X=!1,E())}function L(){G(!1),v()}var b,c=370,e={},f={},g={},h=!1;d.dragEdges&&a.isArray(d.createDragbars)&&o(d.createDragbars),a.isArray(d.createHandles)&&q(d.createHandles),d.drawBorders&&a.isArray(d.createBorders)&&p(d.createBorders),a(document).bind("touchstart.jcrop-ios",function(b){a(b.currentTarget).hasClass("jcrop-tracker")&&b.stopPropagation()});var M=y().mousedown(s("move")).css({cursor:"move",position:"absolute",zIndex:360});return Z.support&&M.bind("touchstart.jcrop",Z.createDragger("move")),I.append(M),F(),{updateVisible:w,update:x,release:B,refresh:v,isAwake:function(){return b},setCursor:function(a){M.css("cursor",a)},enableHandles:E,enableOnly:function(){h=!0},showHandles:C,disableHandles:F,animMode:G,setBgOpacity:z,done:L}}(),bc=function(){function f(b){M.css({zIndex:450}),b?a(document).bind("touchmove.jcrop"
,k).bind("touchend.jcrop",l):e&&a(document).bind("mousemove.jcrop",h).bind("mouseup.jcrop",i)}function g(){M.css({zIndex:290}),a(document).unbind(".jcrop")}function h(a){return b(m(a)),!1}function i(a){return a.preventDefault(),a.stopPropagation(),W&&(W=!1,c(m(a)),bb.isAwake()&&d.onSelect.call(bs,u(_.getFixed())),g(),b=function(){},c=function(){}),!1}function j(a,d,e){return W=!0,b=a,c=d,f(e),!1}function k(a){return b(m(Z.cfilter(a))),!1}function l(a){return i(Z.cfilter(a))}function n(a){M.css("cursor",a)}var b=function(){},c=function(){},e=d.trackDocument;return e||M.mousemove(h).mouseup(i).mouseout(i),D.before(M),{activateHandlers:j,setCursor:n}}(),bd=function(){function e(){d.keySupport&&(b.show(),b.focus())}function f(a){b.hide()}function g(a,b,c){d.allowMove&&(_.moveOffset([b,c]),bb.updateVisible(!0)),a.preventDefault(),a.stopPropagation()}function i(a){if(a.ctrlKey||a.metaKey)return!0;Y=a.shiftKey?!0:!1;var b=Y?10:1;switch(a.keyCode){case 37:g(a,-b,0);break;case 39:g(a,b,0);break;case 38:g(a,0,-b);break;
case 40:g(a,0,b);break;case 27:d.allowSelect&&bb.release();break;case 9:return!0}return!1}var b=a('<input type="radio" />').css({position:"fixed",left:"-120px",width:"12px"}).addClass("jcrop-keymgr"),c=a("<div />").css({position:"absolute",overflow:"hidden"}).append(b);return d.keySupport&&(b.keydown(i).blur(f),h||!d.fixedSupport?(b.css({position:"absolute",left:"-20px"}),c.append(b).insertBefore(D)):b.insertBefore(D)),{watchKeys:e}}();Z.support&&M.bind("touchstart.jcrop",Z.newSelection),J.hide(),br(!0);var bs={setImage:bp,animateTo:bf,setSelect:bg,setOptions:bk,tellSelect:bi,tellScaled:bj,setClass:be,disable:bl,enable:bm,cancel:bn,release:bb.release,destroy:bo,focus:bd.watchKeys,getBounds:function(){return[E*T,F*U]},getWidgetSize:function(){return[E,F]},getScaleFactor:function(){return[T,U]},getOptions:function(){return d},ui:{holder:G,selection:K}};return g&&G.bind("selectstart",function(){return!1}),A.data("Jcrop",bs),bs},a.fn.Jcrop=function(b,c){var d;return this.each(function(){if(a(this).data("Jcrop")){if(
b==="api")return a(this).data("Jcrop");a(this).data("Jcrop").setOptions(b)}else this.tagName=="IMG"?a.Jcrop.Loader(this,function(){a(this).css({display:"block",visibility:"hidden"}),d=a.Jcrop(this,b),a.isFunction(c)&&c.call(d)}):(a(this).css({display:"block",visibility:"hidden"}),d=a.Jcrop(this,b),a.isFunction(c)&&c.call(d))}),this},a.Jcrop.Loader=function(b,c,d){function g(){f.complete?(e.unbind(".jcloader"),a.isFunction(c)&&c.call(f)):window.setTimeout(g,50)}var e=a(b),f=e[0];e.bind("load.jcloader",g).bind("error.jcloader",function(b){e.unbind(".jcloader"),a.isFunction(d)&&d.call(f)}),f.complete&&a.isFunction(c)&&(e.unbind(".jcloader"),c.call(f))},a.Jcrop.defaults={allowSelect:!0,allowMove:!0,allowResize:!0,trackDocument:!0,baseClass:"jcrop",addClass:null,bgColor:"black",bgOpacity:.6,bgFade:!1,borderOpacity:.4,handleOpacity:.5,handleSize:null,aspectRatio:0,keySupport:!0,createHandles:["n","s","e","w","nw","ne","se","sw"],createDragbars:["n","s","e","w"],createBorders:["n","s","e","w"],drawBorders:!0,dragEdges
:!0,fixedSupport:!0,touchSupport:null,shade:null,boxWidth:0,boxHeight:0,boundary:2,fadeTime:400,animationDelay:20,swingSpeed:3,minSelect:[0,0],maxSize:[0,0],minSize:[0,0],onChange:function(){},onSelect:function(){},onDblClick:function(){},onRelease:function(){}}})(jQuery);
/**
 * menu-aim is a jQuery plugin for dropdown menus that can differentiate
 * between a user trying hover over a dropdown item vs trying to navigate into
 * a submenu's contents.
 *
 * menu-aim assumes that you have are using a menu with submenus that expand
 * to the menu's right. It will fire events when the user's mouse enters a new
 * dropdown item *and* when that item is being intentionally hovered over.
 *
 * __________________________
 * | Monkeys  >|   Gorilla  |
 * | Gorillas >|   Content  |
 * | Chimps   >|   Here     |
 * |___________|____________|
 *
 * In the above example, "Gorillas" is selected and its submenu content is
 * being shown on the right. Imagine that the user's cursor is hovering over
 * "Gorillas." When they move their mouse into the "Gorilla Content" area, they
 * may briefly hover over "Chimps." This shouldn't close the "Gorilla Content"
 * area.
 *
 * This problem is normally solved using timeouts and delays. menu-aim tries to
 * solve this by detecting the direction of the user's mouse movement. This can
 * make for quicker transitions when navigating up and down the menu. The
 * experience is hopefully similar to amazon.com/'s "Shop by Department"
 * dropdown.
 *
 * Use like so:
 *
 *      $("#menu").menuAim({
 *          activate: $.noop,  // fired on row activation
 *          deactivate: $.noop  // fired on row deactivation
 *      });
 *
 *  ...to receive events when a menu's row has been purposefully (de)activated.
 *
 * The following options can be passed to menuAim. All functions execute with
 * the relevant row's HTML element as the execution context ('this'):
 *
 *      .menuAim({
 *          // Function to call when a row is purposefully activated. Use this
 *          // to show a submenu's content for the activated row.
 *          activate: function() {},
 *
 *          // Function to call when a row is deactivated.
 *          deactivate: function() {},
 *
 *          // Function to call when mouse enters a menu row. Entering a row
 *          // does not mean the row has been activated, as the user may be
 *          // mousing over to a submenu.
 *          enter: function() {},
 *
 *          // Function to call when mouse exits a menu row.
 *          exit: function() {},
 *
 *          // Selector for identifying which elements in the menu are rows
 *          // that can trigger the above events. Defaults to "> li".
 *          rowSelector: "> li",
 *
 *          // You may have some menu rows that aren't submenus and therefore
 *          // shouldn't ever need to "activate." If so, filter submenu rows w/
 *          // this selector. Defaults to "*" (all elements).
 *          submenuSelector: "*",
 *
 *          // Direction the submenu opens relative to the main menu. Can be
 *          // left, right, above, or below. Defaults to "right".
 *          submenuDirection: "right"
 *      });
 *
 * https://github.com/kamens/jQuery-menu-aim
*/
(function($) {

    $.fn.menuAim = function(opts) {
        // Initialize menu-aim for all elements in jQuery collection
        this.each(function() {
            init.call(this, opts);
        });

        return this;
    };

    function init(opts) {
        var $menu = $(this),
            activeRow = null,
            mouseLocs = [],
            lastDelayLoc = null,
            timeoutId = null,
            options = $.extend({
                rowSelector: "> li",
                submenuSelector: "*",
                submenuDirection: "right",
                tolerance: 75,  // bigger = more forgivey when entering submenu
                enter: $.noop,
                exit: $.noop,
                activate: $.noop,
                deactivate: $.noop,
                exitMenu: $.noop
            }, opts);

        var MOUSE_LOCS_TRACKED = 3,  // number of past mouse locations to track
            DELAY = 300;  // ms delay when user appears to be entering submenu

        /**
         * Keep track of the last few locations of the mouse.
         */
        var mousemoveDocument = function(e) {
                mouseLocs.push({x: e.pageX, y: e.pageY});

                if (mouseLocs.length > MOUSE_LOCS_TRACKED) {
                    mouseLocs.shift();
                }
            };

        /**
         * Cancel possible row activations when leaving the menu entirely
         */
        var mouseleaveMenu = function() {
                if (timeoutId) {
                    clearTimeout(timeoutId);
                }

                // If exitMenu is supplied and returns true, deactivate the
                // currently active row on menu exit.
                if (options.exitMenu(this)) {
                    if (activeRow) {
                        options.deactivate(activeRow);
                    }

                    activeRow = null;
                }
            };

        /**
         * Trigger a possible row activation whenever entering a new row.
         */
        var mouseenterRow = function() {
                if (timeoutId) {
                    // Cancel any previous activation delays
                    clearTimeout(timeoutId);
                }

                options.enter(this);
                possiblyActivate(this);
            },
            mouseleaveRow = function() {
                options.exit(this);
            };

        /*
         * Immediately activate a row if the user clicks on it.
         */
        var clickRow = function() {
                activate(this);
            };

        /**
         * Activate a menu row.
         */
        var activate = function(row) {
                if (row == activeRow) {
                    return;
                }

                if (activeRow) {
                    options.deactivate(activeRow);
                }

                options.activate(row);
                activeRow = row;
            };

        /**
         * Possibly activate a menu row. If mouse movement indicates that we
         * shouldn't activate yet because user may be trying to enter
         * a submenu's content, then delay and check again later.
         */
        var possiblyActivate = function(row) {
                var delay = activationDelay();

                if (delay) {
                    timeoutId = setTimeout(function() {
                        possiblyActivate(row);
                    }, delay);
                } else {
                    activate(row);
                }
            };

        /**
         * Return the amount of time that should be used as a delay before the
         * currently hovered row is activated.
         *
         * Returns 0 if the activation should happen immediately. Otherwise,
         * returns the number of milliseconds that should be delayed before
         * checking again to see if the row should be activated.
         */
        var activationDelay = function() {
                if (!activeRow || !$(activeRow).is(options.submenuSelector)) {
                    // If there is no other submenu row already active, then
                    // go ahead and activate immediately.
                    return 0;
                }

                var offset = $menu.offset(),
                    upperLeft = {
                        x: offset.left,
                        y: offset.top - options.tolerance
                    },
                    upperRight = {
                        x: offset.left + $menu.outerWidth(),
                        y: upperLeft.y
                    },
                    lowerLeft = {
                        x: offset.left,
                        y: offset.top + $menu.outerHeight() + options.tolerance
                    },
                    lowerRight = {
                        x: offset.left + $menu.outerWidth(),
                        y: lowerLeft.y
                    },
                    loc = mouseLocs[mouseLocs.length - 1],
                    prevLoc = mouseLocs[0];

                if (!loc) {
                    return 0;
                }

                if (!prevLoc) {
                    prevLoc = loc;
                }

                if (prevLoc.x < offset.left || prevLoc.x > lowerRight.x ||
                    prevLoc.y < offset.top || prevLoc.y > lowerRight.y) {
                    // If the previous mouse location was outside of the entire
                    // menu's bounds, immediately activate.
                    return 0;
                }

                if (lastDelayLoc &&
                        loc.x == lastDelayLoc.x && loc.y == lastDelayLoc.y) {
                    // If the mouse hasn't moved since the last time we checked
                    // for activation status, immediately activate.
                    return 0;
                }

                // Detect if the user is moving towards the currently activated
                // submenu.
                //
                // If the mouse is heading relatively clearly towards
                // the submenu's content, we should wait and give the user more
                // time before activating a new row. If the mouse is heading
                // elsewhere, we can immediately activate a new row.
                //
                // We detect this by calculating the slope formed between the
                // current mouse location and the upper/lower right points of
                // the menu. We do the same for the previous mouse location.
                // If the current mouse location's slopes are
                // increasing/decreasing appropriately compared to the
                // previous's, we know the user is moving toward the submenu.
                //
                // Note that since the y-axis increases as the cursor moves
                // down the screen, we are looking for the slope between the
                // cursor and the upper right corner to decrease over time, not
                // increase (somewhat counterintuitively).
                function slope(a, b) {
                    return (b.y - a.y) / (b.x - a.x);
                };

                var decreasingCorner = upperRight,
                    increasingCorner = lowerRight;

                // Our expectations for decreasing or increasing slope values
                // depends on which direction the submenu opens relative to the
                // main menu. By default, if the menu opens on the right, we
                // expect the slope between the cursor and the upper right
                // corner to decrease over time, as explained above. If the
                // submenu opens in a different direction, we change our slope
                // expectations.
                if (options.submenuDirection == "left") {
                    decreasingCorner = lowerLeft;
                    increasingCorner = upperLeft;
                } else if (options.submenuDirection == "below") {
                    decreasingCorner = lowerRight;
                    increasingCorner = lowerLeft;
                } else if (options.submenuDirection == "above") {
                    decreasingCorner = upperLeft;
                    increasingCorner = upperRight;
                }

                var decreasingSlope = slope(loc, decreasingCorner),
                    increasingSlope = slope(loc, increasingCorner),
                    prevDecreasingSlope = slope(prevLoc, decreasingCorner),
                    prevIncreasingSlope = slope(prevLoc, increasingCorner);

                if (decreasingSlope < prevDecreasingSlope &&
                        increasingSlope > prevIncreasingSlope) {
                    // Mouse is moving from previous location towards the
                    // currently activated submenu. Delay before activating a
                    // new menu row, because user may be moving into submenu.
                    lastDelayLoc = loc;
                    return DELAY;
                }

                lastDelayLoc = null;
                return 0;
            };

        /**
         * Hook up initial menu events
         */
        $menu
            .mouseleave(mouseleaveMenu)
            .find(options.rowSelector)
                .mouseenter(mouseenterRow)
                .mouseleave(mouseleaveRow)
                .click(clickRow);

        $(document).mousemove(mousemoveDocument);

    };
})(jQuery);


/*
 * jQuery Highlight plugin
 *
 * Based on highlight v3 by Johann Burkard
 * http://johannburkard.de/blog/programming/javascript/highlight-javascript-text-higlighting-jquery-plugin.html
 *
 * Code a little bit refactored and cleaned (in my humble opinion).
 * Most important changes:
 *  - has an option to highlight only entire words (wordsOnly - false by default),
 *  - has an option to be case sensitive (caseSensitive - false by default)
 *  - highlight element tag and class names can be specified in options
 *
 * Usage:
 *   // wrap every occurrance of text 'lorem' in content
 *   // with <span class='highlight'> (default options)
 *   $('#content').highlight('lorem');
 *
 *   // search for and highlight more terms at once
 *   // so you can save some time on traversing DOM
 *   $('#content').highlight(['lorem', 'ipsum']);
 *   $('#content').highlight('lorem ipsum');
 *
 *   // search only for entire word 'lorem'
 *   $('#content').highlight('lorem', { wordsOnly: true });
 *
 *   // don't ignore case during search of term 'lorem'
 *   $('#content').highlight('lorem', { caseSensitive: true });
 *
 *   // wrap every occurrance of term 'ipsum' in content
 *   // with <em class='important'>
 *   $('#content').highlight('ipsum', { element: 'em', className: 'important' });
 *
 *   // remove default highlight
 *   $('#content').unhighlight();
 *
 *   // remove custom highlight
 *   $('#content').unhighlight({ element: 'em', className: 'important' });
 *
 *
 * Copyright (c) 2009 Bartek Szopka
 *
 * Licensed under MIT license.
 *
 */
(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // Node/CommonJS
        factory(require('jquery'));
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function (jQuery) {
    jQuery.extend({
        highlight: function (node, re, nodeName, className) {
            if (node.nodeType === 3) {
                var match = node.data.match(re);
                if (match) {
                    var highlight = document.createElement(nodeName || 'span');
                    highlight.className = className || 'highlight';
                    var wordNode = node.splitText(match.index);
                    wordNode.splitText(match[0].length);
                    var wordClone = wordNode.cloneNode(true);
                    highlight.appendChild(wordClone);
                    wordNode.parentNode.replaceChild(highlight, wordNode);
                    return 1; //skip added node in parent
                }
            } else if ((node.nodeType === 1 && node.childNodes) && // only element nodes that have children
                    !/(script|style)/i.test(node.tagName) && // ignore script and style nodes
                    !(node.tagName === nodeName.toUpperCase() && node.className === className)) { // skip if already highlighted
                for (var i = 0; i < node.childNodes.length; i++) {
                    i += jQuery.highlight(node.childNodes[i], re, nodeName, className);
                }
            }
            return 0;
        }
    });

    jQuery.fn.unhighlight = function (options) {
        var settings = { className: 'highlight', element: 'span' };
        jQuery.extend(settings, options);

        return this.find(settings.element + "." + settings.className).each(function () {
            var parent = this.parentNode;
            parent.replaceChild(this.firstChild, this);
            parent.normalize();
        }).end();
    };

    jQuery.fn.highlight = function (words, options) {
        var settings = { className: 'highlight', element: 'span', caseSensitive: false, wordsOnly: false };
        jQuery.extend(settings, options);
        
        if (words.constructor === String) {
            words = [words];
        }
        words = jQuery.grep(words, function(word, i){
          return word != '';
        });
        words = jQuery.map(words, function(word, i) {
          return word.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
        });
        if (words.length == 0) { return this; };

        var flag = settings.caseSensitive ? "" : "i";
        var pattern = "(" + words.join("|") + ")";
        if (settings.wordsOnly) {
            pattern = "\\b" + pattern + "\\b";
        }
        var re = new RegExp(pattern, flag);
        
        return this.each(function () {
            jQuery.highlight(this, re, settings.element, settings.className);
        });
    };
}));

;(function () {
	'use strict';

	/**
	 * @preserve FastClick: polyfill to remove click delays on browsers with touch UIs.
	 *
	 * @codingstandard ftlabs-jsv2
	 * @copyright The Financial Times Limited [All Rights Reserved]
	 * @license MIT License (see LICENSE.txt)
	 */

	/*jslint browser:true, node:true*/
	/*global define, Event, Node*/


	/**
	 * Instantiate fast-clicking listeners on the specified layer.
	 *
	 * @constructor
	 * @param {Element} layer The layer to listen on
	 * @param {Object} [options={}] The options to override the defaults
	 */
	function FastClick(layer, options) {
		var oldOnClick;

		options = options || {};

		/**
		 * Whether a click is currently being tracked.
		 *
		 * @type boolean
		 */
		this.trackingClick = false;


		/**
		 * Timestamp for when click tracking started.
		 *
		 * @type number
		 */
		this.trackingClickStart = 0;


		/**
		 * The element being tracked for a click.
		 *
		 * @type EventTarget
		 */
		this.targetElement = null;


		/**
		 * X-coordinate of touch start event.
		 *
		 * @type number
		 */
		this.touchStartX = 0;


		/**
		 * Y-coordinate of touch start event.
		 *
		 * @type number
		 */
		this.touchStartY = 0;


		/**
		 * ID of the last touch, retrieved from Touch.identifier.
		 *
		 * @type number
		 */
		this.lastTouchIdentifier = 0;


		/**
		 * Touchmove boundary, beyond which a click will be cancelled.
		 *
		 * @type number
		 */
		this.touchBoundary = options.touchBoundary || 10;


		/**
		 * The FastClick layer.
		 *
		 * @type Element
		 */
		this.layer = layer;

		/**
		 * The minimum time between tap(touchstart and touchend) events
		 *
		 * @type number
		 */
		this.tapDelay = options.tapDelay || 200;

		/**
		 * The maximum time for a tap
		 *
		 * @type number
		 */
		this.tapTimeout = options.tapTimeout || 700;

		if (FastClick.notNeeded(layer)) {
			return;
		}

		// Some old versions of Android don't have Function.prototype.bind
		function bind(method, context) {
			return function() { return method.apply(context, arguments); };
		}


		var methods = ['onMouse', 'onClick', 'onTouchStart', 'onTouchMove', 'onTouchEnd', 'onTouchCancel'];
		var context = this;
		for (var i = 0, l = methods.length; i < l; i++) {
			context[methods[i]] = bind(context[methods[i]], context);
		}

		// Set up event handlers as required
		if (deviceIsAndroid) {
			layer.addEventListener('mouseover', this.onMouse, true);
			layer.addEventListener('mousedown', this.onMouse, true);
			layer.addEventListener('mouseup', this.onMouse, true);
		}

		layer.addEventListener('click', this.onClick, true);
		layer.addEventListener('touchstart', this.onTouchStart, false);
		layer.addEventListener('touchmove', this.onTouchMove, false);
		layer.addEventListener('touchend', this.onTouchEnd, false);
		layer.addEventListener('touchcancel', this.onTouchCancel, false);

		// Hack is required for browsers that don't support Event#stopImmediatePropagation (e.g. Android 2)
		// which is how FastClick normally stops click events bubbling to callbacks registered on the FastClick
		// layer when they are cancelled.
		if (!Event.prototype.stopImmediatePropagation) {
			layer.removeEventListener = function(type, callback, capture) {
				var rmv = Node.prototype.removeEventListener;
				if (type === 'click') {
					rmv.call(layer, type, callback.hijacked || callback, capture);
				} else {
					rmv.call(layer, type, callback, capture);
				}
			};

			layer.addEventListener = function(type, callback, capture) {
				var adv = Node.prototype.addEventListener;
				if (type === 'click') {
					adv.call(layer, type, callback.hijacked || (callback.hijacked = function(event) {
						if (!event.propagationStopped) {
							callback(event);
						}
					}), capture);
				} else {
					adv.call(layer, type, callback, capture);
				}
			};
		}

		// If a handler is already declared in the element's onclick attribute, it will be fired before
		// FastClick's onClick handler. Fix this by pulling out the user-defined handler function and
		// adding it as listener.
		if (typeof layer.onclick === 'function') {

			// Android browser on at least 3.2 requires a new reference to the function in layer.onclick
			// - the old one won't work if passed to addEventListener directly.
			oldOnClick = layer.onclick;
			layer.addEventListener('click', function(event) {
				oldOnClick(event);
			}, false);
			layer.onclick = null;
		}
	}

	/**
	* Windows Phone 8.1 fakes user agent string to look like Android and iPhone.
	*
	* @type boolean
	*/
	var deviceIsWindowsPhone = navigator.userAgent.indexOf("Windows Phone") >= 0;

	/**
	 * Android requires exceptions.
	 *
	 * @type boolean
	 */
	var deviceIsAndroid = navigator.userAgent.indexOf('Android') > 0 && !deviceIsWindowsPhone;


	/**
	 * iOS requires exceptions.
	 *
	 * @type boolean
	 */
	var deviceIsIOS = /iP(ad|hone|od)/.test(navigator.userAgent) && !deviceIsWindowsPhone;


	/**
	 * iOS 4 requires an exception for select elements.
	 *
	 * @type boolean
	 */
	var deviceIsIOS4 = deviceIsIOS && (/OS 4_\d(_\d)?/).test(navigator.userAgent);


	/**
	 * iOS 6.0-7.* requires the target element to be manually derived
	 *
	 * @type boolean
	 */
	var deviceIsIOSWithBadTarget = deviceIsIOS && (/OS [6-7]_\d/).test(navigator.userAgent);

	/**
	 * BlackBerry requires exceptions.
	 *
	 * @type boolean
	 */
	var deviceIsBlackBerry10 = navigator.userAgent.indexOf('BB10') > 0;

	/**
	 * Determine whether a given element requires a native click.
	 *
	 * @param {EventTarget|Element} target Target DOM element
	 * @returns {boolean} Returns true if the element needs a native click
	 */
	FastClick.prototype.needsClick = function(target) {
		switch (target.nodeName.toLowerCase()) {

		// Don't send a synthetic click to disabled inputs (issue #62)
		case 'button':
		case 'select':
		case 'textarea':
			if (target.disabled) {
				return true;
			}

			break;
		case 'input':

			// File inputs need real clicks on iOS 6 due to a browser bug (issue #68)
			if ((deviceIsIOS && target.type === 'file') || target.disabled) {
				return true;
			}

			break;
		case 'label':
		case 'iframe': // iOS8 homescreen apps can prevent events bubbling into frames
		case 'video':
			return true;
		}

		return (/\bneedsclick\b/).test(target.className);
	};


	/**
	 * Determine whether a given element requires a call to focus to simulate click into element.
	 *
	 * @param {EventTarget|Element} target Target DOM element
	 * @returns {boolean} Returns true if the element requires a call to focus to simulate native click.
	 */
	FastClick.prototype.needsFocus = function(target) {
		switch (target.nodeName.toLowerCase()) {
		case 'textarea':
			return true;
		case 'select':
			return !deviceIsAndroid;
		case 'input':
			switch (target.type) {
			case 'button':
			case 'checkbox':
			case 'file':
			case 'image':
			case 'radio':
			case 'submit':
				return false;
			}

			// No point in attempting to focus disabled inputs
			return !target.disabled && !target.readOnly;
		default:
			return (/\bneedsfocus\b/).test(target.className);
		}
	};


	/**
	 * Send a click event to the specified element.
	 *
	 * @param {EventTarget|Element} targetElement
	 * @param {Event} event
	 */
	FastClick.prototype.sendClick = function(targetElement, event) {
		var clickEvent, touch;

		// On some Android devices activeElement needs to be blurred otherwise the synthetic click will have no effect (#24)
		if (document.activeElement && document.activeElement !== targetElement) {
			document.activeElement.blur();
		}

		touch = event.changedTouches[0];

		// Synthesise a click event, with an extra attribute so it can be tracked
		clickEvent = document.createEvent('MouseEvents');
		clickEvent.initMouseEvent(this.determineEventType(targetElement), true, true, window, 1, touch.screenX, touch.screenY, touch.clientX, touch.clientY, false, false, false, false, 0, null);
		clickEvent.forwardedTouchEvent = true;
		targetElement.dispatchEvent(clickEvent);
	};

	FastClick.prototype.determineEventType = function(targetElement) {

		//Issue #159: Android Chrome Select Box does not open with a synthetic click event
		if (deviceIsAndroid && targetElement.tagName.toLowerCase() === 'select') {
			return 'mousedown';
		}

		return 'click';
	};


	/**
	 * @param {EventTarget|Element} targetElement
	 */
	FastClick.prototype.focus = function(targetElement) {
		var length;

		// Issue #160: on iOS 7, some input elements (e.g. date datetime month) throw a vague TypeError on setSelectionRange. These elements don't have an integer value for the selectionStart and selectionEnd properties, but unfortunately that can't be used for detection because accessing the properties also throws a TypeError. Just check the type instead. Filed as Apple bug #15122724.
		if (deviceIsIOS && targetElement.setSelectionRange && targetElement.type.indexOf('date') !== 0 && targetElement.type !== 'time' && targetElement.type !== 'month') {
			length = targetElement.value.length;
			targetElement.setSelectionRange(length, length);
		} else {
			targetElement.focus();
		}
	};


	/**
	 * Check whether the given target element is a child of a scrollable layer and if so, set a flag on it.
	 *
	 * @param {EventTarget|Element} targetElement
	 */
	FastClick.prototype.updateScrollParent = function(targetElement) {
		var scrollParent, parentElement;

		scrollParent = targetElement.fastClickScrollParent;

		// Attempt to discover whether the target element is contained within a scrollable layer. Re-check if the
		// target element was moved to another parent.
		if (!scrollParent || !scrollParent.contains(targetElement)) {
			parentElement = targetElement;
			do {
				if (parentElement.scrollHeight > parentElement.offsetHeight) {
					scrollParent = parentElement;
					targetElement.fastClickScrollParent = parentElement;
					break;
				}

				parentElement = parentElement.parentElement;
			} while (parentElement);
		}

		// Always update the scroll top tracker if possible.
		if (scrollParent) {
			scrollParent.fastClickLastScrollTop = scrollParent.scrollTop;
		}
	};


	/**
	 * @param {EventTarget} targetElement
	 * @returns {Element|EventTarget}
	 */
	FastClick.prototype.getTargetElementFromEventTarget = function(eventTarget) {

		// On some older browsers (notably Safari on iOS 4.1 - see issue #56) the event target may be a text node.
		if (eventTarget.nodeType === Node.TEXT_NODE) {
			return eventTarget.parentNode;
		}

		return eventTarget;
	};


	/**
	 * On touch start, record the position and scroll offset.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onTouchStart = function(event) {
		var targetElement, touch, selection;

		// Ignore multiple touches, otherwise pinch-to-zoom is prevented if both fingers are on the FastClick element (issue #111).
		if (event.targetTouches.length > 1) {
			return true;
		}

		targetElement = this.getTargetElementFromEventTarget(event.target);
		touch = event.targetTouches[0];

		if (deviceIsIOS) {

			// Only trusted events will deselect text on iOS (issue #49)
			selection = window.getSelection();
			if (selection.rangeCount && !selection.isCollapsed) {
				return true;
			}

			if (!deviceIsIOS4) {

				// Weird things happen on iOS when an alert or confirm dialog is opened from a click event callback (issue #23):
				// when the user next taps anywhere else on the page, new touchstart and touchend events are dispatched
				// with the same identifier as the touch event that previously triggered the click that triggered the alert.
				// Sadly, there is an issue on iOS 4 that causes some normal touch events to have the same identifier as an
				// immediately preceeding touch event (issue #52), so this fix is unavailable on that platform.
				// Issue 120: touch.identifier is 0 when Chrome dev tools 'Emulate touch events' is set with an iOS device UA string,
				// which causes all touch events to be ignored. As this block only applies to iOS, and iOS identifiers are always long,
				// random integers, it's safe to to continue if the identifier is 0 here.
				if (touch.identifier && touch.identifier === this.lastTouchIdentifier) {
					event.preventDefault();
					return false;
				}

				this.lastTouchIdentifier = touch.identifier;

				// If the target element is a child of a scrollable layer (using -webkit-overflow-scrolling: touch) and:
				// 1) the user does a fling scroll on the scrollable layer
				// 2) the user stops the fling scroll with another tap
				// then the event.target of the last 'touchend' event will be the element that was under the user's finger
				// when the fling scroll was started, causing FastClick to send a click event to that layer - unless a check
				// is made to ensure that a parent layer was not scrolled before sending a synthetic click (issue #42).
				this.updateScrollParent(targetElement);
			}
		}

		this.trackingClick = true;
		this.trackingClickStart = event.timeStamp;
		this.targetElement = targetElement;

		this.touchStartX = touch.pageX;
		this.touchStartY = touch.pageY;

		// Prevent phantom clicks on fast double-tap (issue #36)
		if ((event.timeStamp - this.lastClickTime) < this.tapDelay) {
			event.preventDefault();
		}

		return true;
	};


	/**
	 * Based on a touchmove event object, check whether the touch has moved past a boundary since it started.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.touchHasMoved = function(event) {
		var touch = event.changedTouches[0], boundary = this.touchBoundary;

		if (Math.abs(touch.pageX - this.touchStartX) > boundary || Math.abs(touch.pageY - this.touchStartY) > boundary) {
			return true;
		}

		return false;
	};


	/**
	 * Update the last position.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onTouchMove = function(event) {
		if (!this.trackingClick) {
			return true;
		}

		// If the touch has moved, cancel the click tracking
		if (this.targetElement !== this.getTargetElementFromEventTarget(event.target) || this.touchHasMoved(event)) {
			this.trackingClick = false;
			this.targetElement = null;
		}

		return true;
	};


	/**
	 * Attempt to find the labelled control for the given label element.
	 *
	 * @param {EventTarget|HTMLLabelElement} labelElement
	 * @returns {Element|null}
	 */
	FastClick.prototype.findControl = function(labelElement) {

		// Fast path for newer browsers supporting the HTML5 control attribute
		if (labelElement.control !== undefined) {
			return labelElement.control;
		}

		// All browsers under test that support touch events also support the HTML5 htmlFor attribute
		if (labelElement.htmlFor) {
			return document.getElementById(labelElement.htmlFor);
		}

		// If no for attribute exists, attempt to retrieve the first labellable descendant element
		// the list of which is defined here: http://www.w3.org/TR/html5/forms.html#category-label
		return labelElement.querySelector('button, input:not([type=hidden]), keygen, meter, output, progress, select, textarea');
	};


	/**
	 * On touch end, determine whether to send a click event at once.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onTouchEnd = function(event) {
		var forElement, trackingClickStart, targetTagName, scrollParent, touch, targetElement = this.targetElement;

		if (!this.trackingClick) {
			return true;
		}

		// Prevent phantom clicks on fast double-tap (issue #36)
		if ((event.timeStamp - this.lastClickTime) < this.tapDelay) {
			this.cancelNextClick = true;
			return true;
		}

		if ((event.timeStamp - this.trackingClickStart) > this.tapTimeout) {
			return true;
		}

		// Reset to prevent wrong click cancel on input (issue #156).
		this.cancelNextClick = false;

		this.lastClickTime = event.timeStamp;

		trackingClickStart = this.trackingClickStart;
		this.trackingClick = false;
		this.trackingClickStart = 0;

		// On some iOS devices, the targetElement supplied with the event is invalid if the layer
		// is performing a transition or scroll, and has to be re-detected manually. Note that
		// for this to function correctly, it must be called *after* the event target is checked!
		// See issue #57; also filed as rdar://13048589 .
		if (deviceIsIOSWithBadTarget) {
			touch = event.changedTouches[0];

			// In certain cases arguments of elementFromPoint can be negative, so prevent setting targetElement to null
			targetElement = document.elementFromPoint(touch.pageX - window.pageXOffset, touch.pageY - window.pageYOffset) || targetElement;
			targetElement.fastClickScrollParent = this.targetElement.fastClickScrollParent;
		}

		targetTagName = targetElement.tagName.toLowerCase();
		if (targetTagName === 'label') {
			forElement = this.findControl(targetElement);
			if (forElement) {
				this.focus(targetElement);
				if (deviceIsAndroid) {
					return false;
				}

				targetElement = forElement;
			}
		} else if (this.needsFocus(targetElement)) {

			// Case 1: If the touch started a while ago (best guess is 100ms based on tests for issue #36) then focus will be triggered anyway. Return early and unset the target element reference so that the subsequent click will be allowed through.
			// Case 2: Without this exception for input elements tapped when the document is contained in an iframe, then any inputted text won't be visible even though the value attribute is updated as the user types (issue #37).
			if ((event.timeStamp - trackingClickStart) > 100 || (deviceIsIOS && window.top !== window && targetTagName === 'input')) {
				this.targetElement = null;
				return false;
			}

			this.focus(targetElement);
			this.sendClick(targetElement, event);

			// Select elements need the event to go through on iOS 4, otherwise the selector menu won't open.
			// Also this breaks opening selects when VoiceOver is active on iOS6, iOS7 (and possibly others)
			if (!deviceIsIOS || targetTagName !== 'select') {
				this.targetElement = null;
				event.preventDefault();
			}

			return false;
		}

		if (deviceIsIOS && !deviceIsIOS4) {

			// Don't send a synthetic click event if the target element is contained within a parent layer that was scrolled
			// and this tap is being used to stop the scrolling (usually initiated by a fling - issue #42).
			scrollParent = targetElement.fastClickScrollParent;
			if (scrollParent && scrollParent.fastClickLastScrollTop !== scrollParent.scrollTop) {
				return true;
			}
		}

		// Prevent the actual click from going though - unless the target node is marked as requiring
		// real clicks or if it is in the whitelist in which case only non-programmatic clicks are permitted.
		if (!this.needsClick(targetElement)) {
			event.preventDefault();
			this.sendClick(targetElement, event);
		}

		return false;
	};


	/**
	 * On touch cancel, stop tracking the click.
	 *
	 * @returns {void}
	 */
	FastClick.prototype.onTouchCancel = function() {
		this.trackingClick = false;
		this.targetElement = null;
	};


	/**
	 * Determine mouse events which should be permitted.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onMouse = function(event) {

		// If a target element was never set (because a touch event was never fired) allow the event
		if (!this.targetElement) {
			return true;
		}

		if (event.forwardedTouchEvent) {
			return true;
		}

		// Programmatically generated events targeting a specific element should be permitted
		if (!event.cancelable) {
			return true;
		}

		// Derive and check the target element to see whether the mouse event needs to be permitted;
		// unless explicitly enabled, prevent non-touch click events from triggering actions,
		// to prevent ghost/doubleclicks.
		if (!this.needsClick(this.targetElement) || this.cancelNextClick) {

			// Prevent any user-added listeners declared on FastClick element from being fired.
			if (event.stopImmediatePropagation) {
				event.stopImmediatePropagation();
			} else {

				// Part of the hack for browsers that don't support Event#stopImmediatePropagation (e.g. Android 2)
				event.propagationStopped = true;
			}

			// Cancel the event
			event.stopPropagation();
			event.preventDefault();

			return false;
		}

		// If the mouse event is permitted, return true for the action to go through.
		return true;
	};


	/**
	 * On actual clicks, determine whether this is a touch-generated click, a click action occurring
	 * naturally after a delay after a touch (which needs to be cancelled to avoid duplication), or
	 * an actual click which should be permitted.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onClick = function(event) {
		var permitted;

		// It's possible for another FastClick-like library delivered with third-party code to fire a click event before FastClick does (issue #44). In that case, set the click-tracking flag back to false and return early. This will cause onTouchEnd to return early.
		if (this.trackingClick) {
			this.targetElement = null;
			this.trackingClick = false;
			return true;
		}

		// Very odd behaviour on iOS (issue #18): if a submit element is present inside a form and the user hits enter in the iOS simulator or clicks the Go button on the pop-up OS keyboard the a kind of 'fake' click event will be triggered with the submit-type input element as the target.
		if (event.target.type === 'submit' && event.detail === 0) {
			return true;
		}

		permitted = this.onMouse(event);

		// Only unset targetElement if the click is not permitted. This will ensure that the check for !targetElement in onMouse fails and the browser's click doesn't go through.
		if (!permitted) {
			this.targetElement = null;
		}

		// If clicks are permitted, return true for the action to go through.
		return permitted;
	};


	/**
	 * Remove all FastClick's event listeners.
	 *
	 * @returns {void}
	 */
	FastClick.prototype.destroy = function() {
		var layer = this.layer;

		if (deviceIsAndroid) {
			layer.removeEventListener('mouseover', this.onMouse, true);
			layer.removeEventListener('mousedown', this.onMouse, true);
			layer.removeEventListener('mouseup', this.onMouse, true);
		}

		layer.removeEventListener('click', this.onClick, true);
		layer.removeEventListener('touchstart', this.onTouchStart, false);
		layer.removeEventListener('touchmove', this.onTouchMove, false);
		layer.removeEventListener('touchend', this.onTouchEnd, false);
		layer.removeEventListener('touchcancel', this.onTouchCancel, false);
	};


	/**
	 * Check whether FastClick is needed.
	 *
	 * @param {Element} layer The layer to listen on
	 */
	FastClick.notNeeded = function(layer) {
		var metaViewport;
		var chromeVersion;
		var blackberryVersion;
		var firefoxVersion;

		// Devices that don't support touch don't need FastClick
		if (typeof window.ontouchstart === 'undefined') {
			return true;
		}

		// Chrome version - zero for other browsers
		chromeVersion = +(/Chrome\/([0-9]+)/.exec(navigator.userAgent) || [,0])[1];

		if (chromeVersion) {

			if (deviceIsAndroid) {
				metaViewport = document.querySelector('meta[name=viewport]');

				if (metaViewport) {
					// Chrome on Android with user-scalable="no" doesn't need FastClick (issue #89)
					if (metaViewport.content.indexOf('user-scalable=no') !== -1) {
						return true;
					}
					// Chrome 32 and above with width=device-width or less don't need FastClick
					if (chromeVersion > 31 && document.documentElement.scrollWidth <= window.outerWidth) {
						return true;
					}
				}

			// Chrome desktop doesn't need FastClick (issue #15)
			} else {
				return true;
			}
		}

		if (deviceIsBlackBerry10) {
			blackberryVersion = navigator.userAgent.match(/Version\/([0-9]*)\.([0-9]*)/);

			// BlackBerry 10.3+ does not require Fastclick library.
			// https://github.com/ftlabs/fastclick/issues/251
			if (blackberryVersion[1] >= 10 && blackberryVersion[2] >= 3) {
				metaViewport = document.querySelector('meta[name=viewport]');

				if (metaViewport) {
					// user-scalable=no eliminates click delay.
					if (metaViewport.content.indexOf('user-scalable=no') !== -1) {
						return true;
					}
					// width=device-width (or less than device-width) eliminates click delay.
					if (document.documentElement.scrollWidth <= window.outerWidth) {
						return true;
					}
				}
			}
		}

		// IE10 with -ms-touch-action: none or manipulation, which disables double-tap-to-zoom (issue #97)
		if (layer.style.msTouchAction === 'none' || layer.style.touchAction === 'manipulation') {
			return true;
		}

		// Firefox version - zero for other browsers
		firefoxVersion = +(/Firefox\/([0-9]+)/.exec(navigator.userAgent) || [,0])[1];

		if (firefoxVersion >= 27) {
			// Firefox 27+ does not have tap delay if the content is not zoomable - https://bugzilla.mozilla.org/show_bug.cgi?id=922896

			metaViewport = document.querySelector('meta[name=viewport]');
			if (metaViewport && (metaViewport.content.indexOf('user-scalable=no') !== -1 || document.documentElement.scrollWidth <= window.outerWidth)) {
				return true;
			}
		}

		// IE11: prefixed -ms-touch-action is no longer supported and it's recomended to use non-prefixed version
		// http://msdn.microsoft.com/en-us/library/windows/apps/Hh767313.aspx
		if (layer.style.touchAction === 'none' || layer.style.touchAction === 'manipulation') {
			return true;
		}

		return false;
	};


	/**
	 * Factory method for creating a FastClick object
	 *
	 * @param {Element} layer The layer to listen on
	 * @param {Object} [options={}] The options to override the defaults
	 */
	FastClick.attach = function(layer, options) {
		return new FastClick(layer, options);
	};


	if (typeof define === 'function' && typeof define.amd === 'object' && define.amd) {

		// AMD. Register as an anonymous module.
		define(function() {
			return FastClick;
		});
	} else if (typeof module !== 'undefined' && module.exports) {
		module.exports = FastClick.attach;
		module.exports.FastClick = FastClick;
	} else {
		window.FastClick = FastClick;
	}
}());

/*! overthrow - An overflow:auto polyfill for responsive design. - v0.7.0 - 2013-11-04
* Copyright (c) 2013 Scott Jehl, Filament Group, Inc.; Licensed MIT */
/*! Overthrow. An overflow:auto polyfill for responsive design. (c) 2012: Scott Jehl, Filament Group, Inc. http://filamentgroup.github.com/Overthrow/license.txt */
(function( w, undefined ){
	
	var doc = w.document,
		docElem = doc.documentElement,
		enabledClassName = "overthrow-enabled",

		// Touch events are used in the polyfill, and thus are a prerequisite
		canBeFilledWithPoly = "ontouchmove" in doc,
		
		// The following attempts to determine whether the browser has native overflow support
		// so we can enable it but not polyfill
		nativeOverflow = 
			// Features-first. iOS5 overflow scrolling property check - no UA needed here. thanks Apple :)
			"WebkitOverflowScrolling" in docElem.style ||
			// Test the windows scrolling property as well
			"msOverflowStyle" in docElem.style ||
			// Touch events aren't supported and screen width is greater than X
			// ...basically, this is a loose "desktop browser" check. 
			// It may wrongly opt-in very large tablets with no touch support.
			( !canBeFilledWithPoly && w.screen.width > 800 ) ||
			// Hang on to your hats.
			// Whitelist some popular, overflow-supporting mobile browsers for now and the future
			// These browsers are known to get overlow support right, but give us no way of detecting it.
			(function(){
				var ua = w.navigator.userAgent,
					// Webkit crosses platforms, and the browsers on our list run at least version 534
					webkit = ua.match( /AppleWebKit\/([0-9]+)/ ),
					wkversion = webkit && webkit[1],
					wkLte534 = webkit && wkversion >= 534;
					
				return (
					/* Android 3+ with webkit gte 534
					~: Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13 */
					ua.match( /Android ([0-9]+)/ ) && RegExp.$1 >= 3 && wkLte534 ||
					/* Blackberry 7+ with webkit gte 534
					~: Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en-US) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0 Mobile Safari/534.11+ */
					ua.match( / Version\/([0-9]+)/ ) && RegExp.$1 >= 0 && w.blackberry && wkLte534 ||
					/* Blackberry Playbook with webkit gte 534
					~: Mozilla/5.0 (PlayBook; U; RIM Tablet OS 1.0.0; en-US) AppleWebKit/534.8+ (KHTML, like Gecko) Version/0.0.1 Safari/534.8+ */   
					ua.indexOf( "PlayBook" ) > -1 && wkLte534 && !ua.indexOf( "Android 2" ) === -1 ||
					/* Firefox Mobile (Fennec) 4 and up
					~: Mozilla/5.0 (Mobile; rv:15.0) Gecko/15.0 Firefox/15.0 */
					ua.match(/Firefox\/([0-9]+)/) && RegExp.$1 >= 4 ||
					/* WebOS 3 and up (TouchPad too)
					~: Mozilla/5.0 (hp-tablet; Linux; hpwOS/3.0.0; U; en-US) AppleWebKit/534.6 (KHTML, like Gecko) wOSBrowser/233.48 Safari/534.6 TouchPad/1.0 */
					ua.match( /wOSBrowser\/([0-9]+)/ ) && RegExp.$1 >= 233 && wkLte534 ||
					/* Nokia Browser N8
					~: Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaN8-00/012.002; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.0 Mobile Safari/533.4 3gpp-gba 
					~: Note: the N9 doesn't have native overflow with one-finger touch. wtf */
					ua.match( /NokiaBrowser\/([0-9\.]+)/ ) && parseFloat(RegExp.$1) === 7.3 && webkit && wkversion >= 533
				);
			})();

	// Expose overthrow API
	w.overthrow = {};

	w.overthrow.enabledClassName = enabledClassName;

	w.overthrow.addClass = function(){
		if( docElem.className.indexOf( w.overthrow.enabledClassName ) === -1 ){
			docElem.className += " " + w.overthrow.enabledClassName;
		}
	};

	w.overthrow.removeClass = function(){
		docElem.className = docElem.className.replace( w.overthrow.enabledClassName, "" );
	};

	// Enable and potentially polyfill overflow
	w.overthrow.set = function(){
			
		// If nativeOverflow or at least the element canBeFilledWithPoly, add a class to cue CSS that assumes overflow scrolling will work (setting height on elements and such)
		if( nativeOverflow ){
			w.overthrow.addClass();
		}

	};

	// expose polyfillable 
	w.overthrow.canBeFilledWithPoly = canBeFilledWithPoly;

	// Destroy everything later. If you want to.
	w.overthrow.forget = function(){

		w.overthrow.removeClass();
		
	};
		
	// Expose overthrow API
	w.overthrow.support = nativeOverflow ? "native" : "none";
		
})( this );

/*! Overthrow. An overflow:auto polyfill for responsive design. (c) 2012: Scott Jehl, Filament Group, Inc. http://filamentgroup.github.com/Overthrow/license.txt */
(function( w, o, undefined ){

	// o is overthrow reference from overthrow-polyfill.js
	if( o === undefined ){
		return;
	}

	// Easing can use any of Robert Penner's equations (http://www.robertpenner.com/easing_terms_of_use.html). By default, overthrow includes ease-out-cubic
	// arguments: t = current iteration, b = initial value, c = end value, d = total iterations
	// use w.overthrow.easing to provide a custom function externally, or pass an easing function as a callback to the toss method
	o.easing = function (t, b, c, d) {
		return c*((t=t/d-1)*t*t + 1) + b;
	};

	// tossing property is true during a programatic scroll
	o.tossing = false;

	// Keeper of intervals
	var timeKeeper;

	/* toss scrolls and element with easing

	// elem is the element to scroll
	// options hash:
		* left is the desired horizontal scroll. Default is "+0". For relative distances, pass a string with "+" or "-" in front.
		* top is the desired vertical scroll. Default is "+0". For relative distances, pass a string with "+" or "-" in front.
		* duration is the number of milliseconds the throw will take. Default is 100.
		* easing is an optional custom easing function. Default is w.overthrow.easing. Must follow the easing function signature

	*/
	o.toss = function( elem, options ){
		o.intercept();
		var i = 0,
			sLeft = elem.scrollLeft,
			sTop = elem.scrollTop,
			// Toss defaults
			op = {
				top: "+0",
				left: "+0",
				duration: 50,
				easing: o.easing,
				finished: function() {}
			},
			endLeft, endTop, finished = false;

		// Mixin based on predefined defaults
		if( options ){
			for( var j in op ){
				if( options[ j ] !== undefined ){
					op[ j ] = options[ j ];
				}
			}
		}

		// Convert relative values to ints
		// First the left val
		if( typeof op.left === "string" ){
			op.left = parseFloat( op.left );
			endLeft = op.left + sLeft;
		}
		else {
			endLeft = op.left;
			op.left = op.left - sLeft;
		}
		// Then the top val
		if( typeof op.top === "string" ){

			op.top = parseFloat( op.top );
			endTop = op.top + sTop;
		}
		else {
			endTop = op.top;
			op.top = op.top - sTop;
		}

		o.tossing = true;
		timeKeeper = setInterval(function(){
			if( i++ < op.duration ){
				elem.scrollLeft = op.easing( i, sLeft, op.left, op.duration );
				elem.scrollTop = op.easing( i, sTop, op.top, op.duration );
			}
			else{
				if( endLeft !== elem.scrollLeft ){
					elem.scrollLeft = endLeft;
				} else {
					// if the end of the vertical scrolling has taken place
					// we know that we're done here call the callback
					// otherwise signal that horizontal scrolling is complete
					if( finished ) {
						op.finished();
					}
					finished = true;
				}

				if( endTop !== elem.scrollTop ){
					elem.scrollTop = endTop;
				} else {
					// if the end of the horizontal scrolling has taken place
					// we know that we're done here call the callback
					if( finished ) {
						op.finished();
					}
					finished = true;
				}

				o.intercept();
			}
		}, 1 );

		// Return the values, post-mixin, with end values specified
		return { top: endTop, left: endLeft, duration: o.duration, easing: o.easing };
	};

	// Intercept any throw in progress
	o.intercept = function(){
		clearInterval( timeKeeper );
		o.tossing = false;
	};

})( this, this.overthrow );

/*! Overthrow. An overflow:auto polyfill for responsive design. (c) 2012: Scott Jehl, Filament Group, Inc. http://filamentgroup.github.com/Overthrow/license.txt */
(function( w, o, undefined ){

	// o is overthrow reference from overthrow-polyfill.js
	if( o === undefined ){
		return;
	}

	o.scrollIndicatorClassName = "overthrow";
	
	var doc = w.document,
		docElem = doc.documentElement,
		// o api
		nativeOverflow = o.support === "native",
		canBeFilledWithPoly = o.canBeFilledWithPoly,
		configure = o.configure,
		set = o.set,
		forget = o.forget,
		scrollIndicatorClassName = o.scrollIndicatorClassName;

	// find closest overthrow (elem or a parent)
	o.closest = function( target, ascend ){
		return !ascend && target.className && target.className.indexOf( scrollIndicatorClassName ) > -1 && target || o.closest( target.parentNode );
	};
		
	// polyfill overflow
	var enabled = false;
	o.set = function(){
			
		set();

		// If nativeOverflow or it doesn't look like the browser canBeFilledWithPoly, our job is done here. Exit viewport left.
		if( enabled || nativeOverflow || !canBeFilledWithPoly ){
			return;
		}

		w.overthrow.addClass();

		enabled = true;

		o.support = "polyfilled";

		o.forget = function(){
			forget();
			enabled = false;
			// Remove touch binding (check for method support since this part isn't qualified by touch support like the rest)
			if( doc.removeEventListener ){
				doc.removeEventListener( "touchstart", start, false );
			}
		};

		// Fill 'er up!
		// From here down, all logic is associated with touch scroll handling
			// elem references the overthrow element in use
		var elem,
			
			// The last several Y values are kept here
			lastTops = [],
	
			// The last several X values are kept here
			lastLefts = [],
			
			// lastDown will be true if the last scroll direction was down, false if it was up
			lastDown,
			
			// lastRight will be true if the last scroll direction was right, false if it was left
			lastRight,
			
			// For a new gesture, or change in direction, reset the values from last scroll
			resetVertTracking = function(){
				lastTops = [];
				lastDown = null;
			},
			
			resetHorTracking = function(){
				lastLefts = [];
				lastRight = null;
			},
		
			// On webkit, touch events hardly trickle through textareas and inputs
			// Disabling CSS pointer events makes sure they do, but it also makes the controls innaccessible
			// Toggling pointer events at the right moments seems to do the trick
			// Thanks Thomas Bachem http://stackoverflow.com/a/5798681 for the following
			inputs,
			setPointers = function( val ){
				inputs = elem.querySelectorAll( "textarea, input" );
				for( var i = 0, il = inputs.length; i < il; i++ ) {
					inputs[ i ].style.pointerEvents = val;
				}
			},
			
			// For nested overthrows, changeScrollTarget restarts a touch event cycle on a parent or child overthrow
			changeScrollTarget = function( startEvent, ascend ){
				if( doc.createEvent ){
					var newTarget = ( !ascend || ascend === undefined ) && elem.parentNode || elem.touchchild || elem,
						tEnd;
							
					if( newTarget !== elem ){
						tEnd = doc.createEvent( "HTMLEvents" );
						tEnd.initEvent( "touchend", true, true );
						elem.dispatchEvent( tEnd );
						newTarget.touchchild = elem;
						elem = newTarget;
						newTarget.dispatchEvent( startEvent );
					}
				}
			},
			
			// Touchstart handler
			// On touchstart, touchmove and touchend are freshly bound, and all three share a bunch of vars set by touchstart
			// Touchend unbinds them again, until next time
			start = function( e ){

				// Stop any throw in progress
				if( o.intercept ){
					o.intercept();
				}
				
				// Reset the distance and direction tracking
				resetVertTracking();
				resetHorTracking();
				
				elem = o.closest( e.target );
					
				if( !elem || elem === docElem || e.touches.length > 1 ){
					return;
				}			

				setPointers( "none" );
				var touchStartE = e,
					scrollT = elem.scrollTop,
					scrollL = elem.scrollLeft,
					height = elem.offsetHeight,
					width = elem.offsetWidth,
					startY = e.touches[ 0 ].pageY,
					startX = e.touches[ 0 ].pageX,
					scrollHeight = elem.scrollHeight,
					scrollWidth = elem.scrollWidth,
				
					// Touchmove handler
					move = function( e ){
					
						var ty = scrollT + startY - e.touches[ 0 ].pageY,
							tx = scrollL + startX - e.touches[ 0 ].pageX,
							down = ty >= ( lastTops.length ? lastTops[ 0 ] : 0 ),
							right = tx >= ( lastLefts.length ? lastLefts[ 0 ] : 0 );
							
						// If there's room to scroll the current container, prevent the default window scroll
						if( ( ty > 0 && ty < scrollHeight - height ) || ( tx > 0 && tx < scrollWidth - width ) ){
							e.preventDefault();
						}
						// This bubbling is dumb. Needs a rethink.
						else {
							changeScrollTarget( touchStartE );
						}
						
						// If down and lastDown are inequal, the y scroll has changed direction. Reset tracking.
						if( lastDown && down !== lastDown ){
							resetVertTracking();
						}
						
						// If right and lastRight are inequal, the x scroll has changed direction. Reset tracking.
						if( lastRight && right !== lastRight ){
							resetHorTracking();
						}
						
						// remember the last direction in which we were headed
						lastDown = down;
						lastRight = right;							
						
						// set the container's scroll
						elem.scrollTop = ty;
						elem.scrollLeft = tx;
					
						lastTops.unshift( ty );
						lastLefts.unshift( tx );
					
						if( lastTops.length > 3 ){
							lastTops.pop();
						}
						if( lastLefts.length > 3 ){
							lastLefts.pop();
						}
					},
				
					// Touchend handler
					end = function( e ){

						// Bring the pointers back
						setPointers( "auto" );
						setTimeout( function(){
							setPointers( "none" );
						}, 450 );
						elem.removeEventListener( "touchmove", move, false );
						elem.removeEventListener( "touchend", end, false );
					};
				
				elem.addEventListener( "touchmove", move, false );
				elem.addEventListener( "touchend", end, false );
			};
			
		// Bind to touch, handle move and end within
		doc.addEventListener( "touchstart", start, false );
	};
		
})( this, this.overthrow );

/*! Overthrow. An overflow:auto polyfill for responsive design. (c) 2012: Scott Jehl, Filament Group, Inc. http://filamentgroup.github.com/Overthrow/license.txt */
(function( w, undefined ){
	
	// Auto-init
	w.overthrow.set();

}( this ));
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

function EventEmitter() {
  this._events = this._events || {};
  this._maxListeners = this._maxListeners || undefined;
}
module.exports = EventEmitter;

// Backwards-compat with node 0.10.x
EventEmitter.EventEmitter = EventEmitter;

EventEmitter.prototype._events = undefined;
EventEmitter.prototype._maxListeners = undefined;

// By default EventEmitters will print a warning if more than 10 listeners are
// added to it. This is a useful default which helps finding memory leaks.
EventEmitter.defaultMaxListeners = 10;

// Obviously not all Emitters should be limited to 10. This function allows
// that to be increased. Set to zero for unlimited.
EventEmitter.prototype.setMaxListeners = function(n) {
  if (!isNumber(n) || n < 0 || isNaN(n))
    throw TypeError('n must be a positive number');
  this._maxListeners = n;
  return this;
};

EventEmitter.prototype.emit = function(type) {
  var er, handler, len, args, i, listeners;

  if (!this._events)
    this._events = {};

  // If there is no 'error' event listener then throw.
  if (type === 'error') {
    if (!this._events.error ||
        (isObject(this._events.error) && !this._events.error.length)) {
      er = arguments[1];
      if (er instanceof Error) {
        throw er; // Unhandled 'error' event
      }
      throw TypeError('Uncaught, unspecified "error" event.');
    }
  }

  handler = this._events[type];

  if (isUndefined(handler))
    return false;

  if (isFunction(handler)) {
    switch (arguments.length) {
      // fast cases
      case 1:
        handler.call(this);
        break;
      case 2:
        handler.call(this, arguments[1]);
        break;
      case 3:
        handler.call(this, arguments[1], arguments[2]);
        break;
      // slower
      default:
        len = arguments.length;
        args = new Array(len - 1);
        for (i = 1; i < len; i++)
          args[i - 1] = arguments[i];
        handler.apply(this, args);
    }
  } else if (isObject(handler)) {
    len = arguments.length;
    args = new Array(len - 1);
    for (i = 1; i < len; i++)
      args[i - 1] = arguments[i];

    listeners = handler.slice();
    len = listeners.length;
    for (i = 0; i < len; i++)
      listeners[i].apply(this, args);
  }

  return true;
};

EventEmitter.prototype.addListener = function(type, listener) {
  var m;

  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  if (!this._events)
    this._events = {};

  // To avoid recursion in the case that type === "newListener"! Before
  // adding it to the listeners, first emit "newListener".
  if (this._events.newListener)
    this.emit('newListener', type,
              isFunction(listener.listener) ?
              listener.listener : listener);

  if (!this._events[type])
    // Optimize the case of one listener. Don't need the extra array object.
    this._events[type] = listener;
  else if (isObject(this._events[type]))
    // If we've already got an array, just append.
    this._events[type].push(listener);
  else
    // Adding the second element, need to change to array.
    this._events[type] = [this._events[type], listener];

  // Check for listener leak
  if (isObject(this._events[type]) && !this._events[type].warned) {
    var m;
    if (!isUndefined(this._maxListeners)) {
      m = this._maxListeners;
    } else {
      m = EventEmitter.defaultMaxListeners;
    }

    if (m && m > 0 && this._events[type].length > m) {
      this._events[type].warned = true;
      console.error('(node) warning: possible EventEmitter memory ' +
                    'leak detected. %d listeners added. ' +
                    'Use emitter.setMaxListeners() to increase limit.',
                    this._events[type].length);
      if (typeof console.trace === 'function') {
        // not supported in IE 10
        console.trace();
      }
    }
  }

  return this;
};

EventEmitter.prototype.on = EventEmitter.prototype.addListener;

EventEmitter.prototype.once = function(type, listener) {
  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  var fired = false;

  function g() {
    this.removeListener(type, g);

    if (!fired) {
      fired = true;
      listener.apply(this, arguments);
    }
  }

  g.listener = listener;
  this.on(type, g);

  return this;
};

// emits a 'removeListener' event iff the listener was removed
EventEmitter.prototype.removeListener = function(type, listener) {
  var list, position, length, i;

  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  if (!this._events || !this._events[type])
    return this;

  list = this._events[type];
  length = list.length;
  position = -1;

  if (list === listener ||
      (isFunction(list.listener) && list.listener === listener)) {
    delete this._events[type];
    if (this._events.removeListener)
      this.emit('removeListener', type, listener);

  } else if (isObject(list)) {
    for (i = length; i-- > 0;) {
      if (list[i] === listener ||
          (list[i].listener && list[i].listener === listener)) {
        position = i;
        break;
      }
    }

    if (position < 0)
      return this;

    if (list.length === 1) {
      list.length = 0;
      delete this._events[type];
    } else {
      list.splice(position, 1);
    }

    if (this._events.removeListener)
      this.emit('removeListener', type, listener);
  }

  return this;
};

EventEmitter.prototype.removeAllListeners = function(type) {
  var key, listeners;

  if (!this._events)
    return this;

  // not listening for removeListener, no need to emit
  if (!this._events.removeListener) {
    if (arguments.length === 0)
      this._events = {};
    else if (this._events[type])
      delete this._events[type];
    return this;
  }

  // emit removeListener for all listeners on all events
  if (arguments.length === 0) {
    for (key in this._events) {
      if (key === 'removeListener') continue;
      this.removeAllListeners(key);
    }
    this.removeAllListeners('removeListener');
    this._events = {};
    return this;
  }

  listeners = this._events[type];

  if (isFunction(listeners)) {
    this.removeListener(type, listeners);
  } else {
    // LIFO order
    while (listeners.length)
      this.removeListener(type, listeners[listeners.length - 1]);
  }
  delete this._events[type];

  return this;
};

EventEmitter.prototype.listeners = function(type) {
  var ret;
  if (!this._events || !this._events[type])
    ret = [];
  else if (isFunction(this._events[type]))
    ret = [this._events[type]];
  else
    ret = this._events[type].slice();
  return ret;
};

EventEmitter.listenerCount = function(emitter, type) {
  var ret;
  if (!emitter._events || !emitter._events[type])
    ret = 0;
  else if (isFunction(emitter._events[type]))
    ret = 1;
  else
    ret = emitter._events[type].length;
  return ret;
};

function isFunction(arg) {
  return typeof arg === 'function';
}

function isNumber(arg) {
  return typeof arg === 'number';
}

function isObject(arg) {
  return typeof arg === 'object' && arg !== null;
}

function isUndefined(arg) {
  return arg === void 0;
}

},{}],2:[function(require,module,exports){
/*!
 * JavaScript Cookie v2.0.4
 * https://github.com/js-cookie/js-cookie
 *
 * Copyright 2006, 2015 Klaus Hartl & Fagner Brack
 * Released under the MIT license
 */
(function (factory) {
	if (typeof define === 'function' && define.amd) {
		define(factory);
	} else if (typeof exports === 'object') {
		module.exports = factory();
	} else {
		var _OldCookies = window.Cookies;
		var api = window.Cookies = factory();
		api.noConflict = function () {
			window.Cookies = _OldCookies;
			return api;
		};
	}
}(function () {
	function extend () {
		var i = 0;
		var result = {};
		for (; i < arguments.length; i++) {
			var attributes = arguments[ i ];
			for (var key in attributes) {
				result[key] = attributes[key];
			}
		}
		return result;
	}

	function init (converter) {
		function api (key, value, attributes) {
			var result;

			// Write

			if (arguments.length > 1) {
				attributes = extend({
					path: '/'
				}, api.defaults, attributes);

				if (typeof attributes.expires === 'number') {
					var expires = new Date();
					expires.setMilliseconds(expires.getMilliseconds() + attributes.expires * 864e+5);
					attributes.expires = expires;
				}

				try {
					result = JSON.stringify(value);
					if (/^[\{\[]/.test(result)) {
						value = result;
					}
				} catch (e) {}

				value = encodeURIComponent(String(value));
				value = value.replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent);

				key = encodeURIComponent(String(key));
				key = key.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent);
				key = key.replace(/[\(\)]/g, escape);

				return (document.cookie = [
					key, '=', value,
					attributes.expires && '; expires=' + attributes.expires.toUTCString(), // use expires attribute, max-age is not supported by IE
					attributes.path    && '; path=' + attributes.path,
					attributes.domain  && '; domain=' + attributes.domain,
					attributes.secure ? '; secure' : ''
				].join(''));
			}

			// Read

			if (!key) {
				result = {};
			}

			// To prevent the for loop in the first place assign an empty array
			// in case there are no cookies at all. Also prevents odd result when
			// calling "get()"
			var cookies = document.cookie ? document.cookie.split('; ') : [];
			var rdecode = /(%[0-9A-Z]{2})+/g;
			var i = 0;

			for (; i < cookies.length; i++) {
				var parts = cookies[i].split('=');
				var name = parts[0].replace(rdecode, decodeURIComponent);
				var cookie = parts.slice(1).join('=');

				if (cookie.charAt(0) === '"') {
					cookie = cookie.slice(1, -1);
				}

				try {
					cookie = converter && converter(cookie, name) || cookie.replace(rdecode, decodeURIComponent);

					if (this.json) {
						try {
							cookie = JSON.parse(cookie);
						} catch (e) {}
					}

					if (key === name) {
						result = cookie;
						break;
					}

					if (!key) {
						result[name] = cookie;
					}
				} catch (e) {}
			}

			return result;
		}

		api.get = api.set = api;
		api.getJSON = function () {
			return api.apply({
				json: true
			}, [].slice.call(arguments));
		};
		api.defaults = {};

		api.remove = function (key, attributes) {
			api(key, '', extend(attributes, {
				expires: -1
			}));
		};

		api.withConverter = init;

		return api;
	}

	return init();
}));

},{}],3:[function(require,module,exports){
(function() {
  if (typeof twttr === "undefined" || twttr === null) {
    var twttr = {};
  }

  twttr.txt = {};
  twttr.txt.regexen = {};

  var HTML_ENTITIES = {
    '&': '&amp;',
    '>': '&gt;',
    '<': '&lt;',
    '"': '&quot;',
    "'": '&#39;'
  };

  // HTML escaping
  twttr.txt.htmlEscape = function(text) {
    return text && text.replace(/[&"'><]/g, function(character) {
      return HTML_ENTITIES[character];
    });
  };

  // Builds a RegExp
  function regexSupplant(regex, flags) {
    flags = flags || "";
    if (typeof regex !== "string") {
      if (regex.global && flags.indexOf("g") < 0) {
        flags += "g";
      }
      if (regex.ignoreCase && flags.indexOf("i") < 0) {
        flags += "i";
      }
      if (regex.multiline && flags.indexOf("m") < 0) {
        flags += "m";
      }

      regex = regex.source;
    }

    return new RegExp(regex.replace(/#\{(\w+)\}/g, function(match, name) {
      var newRegex = twttr.txt.regexen[name] || "";
      if (typeof newRegex !== "string") {
        newRegex = newRegex.source;
      }
      return newRegex;
    }), flags);
  }

  twttr.txt.regexSupplant = regexSupplant;

  // simple string interpolation
  function stringSupplant(str, values) {
    return str.replace(/#\{(\w+)\}/g, function(match, name) {
      return values[name] || "";
    });
  }

  twttr.txt.stringSupplant = stringSupplant;

  function addCharsToCharClass(charClass, start, end) {
    var s = String.fromCharCode(start);
    if (end !== start) {
      s += "-" + String.fromCharCode(end);
    }
    charClass.push(s);
    return charClass;
  }

  twttr.txt.addCharsToCharClass = addCharsToCharClass;

  // Space is more than %20, U+3000 for example is the full-width space used with Kanji. Provide a short-hand
  // to access both the list of characters and a pattern suitible for use with String#split
  // Taken from: ActiveSupport::Multibyte::Handlers::UTF8Handler::UNICODE_WHITESPACE
  var fromCode = String.fromCharCode;
  var UNICODE_SPACES = [
    fromCode(0x0020), // White_Space # Zs       SPACE
    fromCode(0x0085), // White_Space # Cc       <control-0085>
    fromCode(0x00A0), // White_Space # Zs       NO-BREAK SPACE
    fromCode(0x1680), // White_Space # Zs       OGHAM SPACE MARK
    fromCode(0x180E), // White_Space # Zs       MONGOLIAN VOWEL SEPARATOR
    fromCode(0x2028), // White_Space # Zl       LINE SEPARATOR
    fromCode(0x2029), // White_Space # Zp       PARAGRAPH SEPARATOR
    fromCode(0x202F), // White_Space # Zs       NARROW NO-BREAK SPACE
    fromCode(0x205F), // White_Space # Zs       MEDIUM MATHEMATICAL SPACE
    fromCode(0x3000)  // White_Space # Zs       IDEOGRAPHIC SPACE
  ];
  addCharsToCharClass(UNICODE_SPACES, 0x009, 0x00D); // White_Space # Cc   [5] <control-0009>..<control-000D>
  addCharsToCharClass(UNICODE_SPACES, 0x2000, 0x200A); // White_Space # Zs  [11] EN QUAD..HAIR SPACE

  var INVALID_CHARS = [
    fromCode(0xFFFE),
    fromCode(0xFEFF), // BOM
    fromCode(0xFFFF) // Special
  ];
  addCharsToCharClass(INVALID_CHARS, 0x202A, 0x202E); // Directional change

  twttr.txt.regexen.spaces_group = regexSupplant(UNICODE_SPACES.join(""));
  twttr.txt.regexen.spaces = regexSupplant("[" + UNICODE_SPACES.join("") + "]");
  twttr.txt.regexen.invalid_chars_group = regexSupplant(INVALID_CHARS.join(""));
  twttr.txt.regexen.punct = /\!'#%&'\(\)*\+,\\\-\.\/:;<=>\?@\[\]\^_{|}~\$/;
  twttr.txt.regexen.rtl_chars = /[\u0600-\u06FF]|[\u0750-\u077F]|[\u0590-\u05FF]|[\uFE70-\uFEFF]/mg;
  twttr.txt.regexen.non_bmp_code_pairs = /[\uD800-\uDBFF][\uDC00-\uDFFF]/mg;

  var latinAccentChars = [];
  // Latin accented characters (subtracted 0xD7 from the range, it's a confusable multiplication sign. Looks like "x")
  addCharsToCharClass(latinAccentChars, 0x00c0, 0x00d6);
  addCharsToCharClass(latinAccentChars, 0x00d8, 0x00f6);
  addCharsToCharClass(latinAccentChars, 0x00f8, 0x00ff);
  // Latin Extended A and B
  addCharsToCharClass(latinAccentChars, 0x0100, 0x024f);
  // assorted IPA Extensions
  addCharsToCharClass(latinAccentChars, 0x0253, 0x0254);
  addCharsToCharClass(latinAccentChars, 0x0256, 0x0257);
  addCharsToCharClass(latinAccentChars, 0x0259, 0x0259);
  addCharsToCharClass(latinAccentChars, 0x025b, 0x025b);
  addCharsToCharClass(latinAccentChars, 0x0263, 0x0263);
  addCharsToCharClass(latinAccentChars, 0x0268, 0x0268);
  addCharsToCharClass(latinAccentChars, 0x026f, 0x026f);
  addCharsToCharClass(latinAccentChars, 0x0272, 0x0272);
  addCharsToCharClass(latinAccentChars, 0x0289, 0x0289);
  addCharsToCharClass(latinAccentChars, 0x028b, 0x028b);
  // Okina for Hawaiian (it *is* a letter character)
  addCharsToCharClass(latinAccentChars, 0x02bb, 0x02bb);
  // Combining diacritics
  addCharsToCharClass(latinAccentChars, 0x0300, 0x036f);
  // Latin Extended Additional
  addCharsToCharClass(latinAccentChars, 0x1e00, 0x1eff);
  twttr.txt.regexen.latinAccentChars = regexSupplant(latinAccentChars.join(""));

  var unicodeLettersAndMarks = "A-Za-z\xAA\xB5\xBA\xC0-\xD6\xD8-\xF6\xF8-\u02C1\u02C6-\u02D1\u02E0-\u02E4\u02EC\u02EE\u0370-\u0374\u0376\u0377\u037A-\u037D\u037F\u0386\u0388-\u038A\u038C\u038E-\u03A1\u03A3-\u03F5\u03F7-\u0481\u048A-\u052F\u0531-\u0556\u0559\u0561-\u0587\u05D0-\u05EA\u05F0-\u05F2\u0620-\u064A\u066E\u066F\u0671-\u06D3\u06D5\u06E5\u06E6\u06EE\u06EF\u06FA-\u06FC\u06FF\u0710\u0712-\u072F\u074D-\u07A5\u07B1\u07CA-\u07EA\u07F4\u07F5\u07FA\u0800-\u0815\u081A\u0824\u0828\u0840-\u0858\u08A0-\u08B2\u0904-\u0939\u093D\u0950\u0958-\u0961\u0971-\u0980\u0985-\u098C\u098F\u0990\u0993-\u09A8\u09AA-\u09B0\u09B2\u09B6-\u09B9\u09BD\u09CE\u09DC\u09DD\u09DF-\u09E1\u09F0\u09F1\u0A05-\u0A0A\u0A0F\u0A10\u0A13-\u0A28\u0A2A-\u0A30\u0A32\u0A33\u0A35\u0A36\u0A38\u0A39\u0A59-\u0A5C\u0A5E\u0A72-\u0A74\u0A85-\u0A8D\u0A8F-\u0A91\u0A93-\u0AA8\u0AAA-\u0AB0\u0AB2\u0AB3\u0AB5-\u0AB9\u0ABD\u0AD0\u0AE0\u0AE1\u0B05-\u0B0C\u0B0F\u0B10\u0B13-\u0B28\u0B2A-\u0B30\u0B32\u0B33\u0B35-\u0B39\u0B3D\u0B5C\u0B5D\u0B5F-\u0B61\u0B71\u0B83\u0B85-\u0B8A\u0B8E-\u0B90\u0B92-\u0B95\u0B99\u0B9A\u0B9C\u0B9E\u0B9F\u0BA3\u0BA4\u0BA8-\u0BAA\u0BAE-\u0BB9\u0BD0\u0C05-\u0C0C\u0C0E-\u0C10\u0C12-\u0C28\u0C2A-\u0C39\u0C3D\u0C58\u0C59\u0C60\u0C61\u0C85-\u0C8C\u0C8E-\u0C90\u0C92-\u0CA8\u0CAA-\u0CB3\u0CB5-\u0CB9\u0CBD\u0CDE\u0CE0\u0CE1\u0CF1\u0CF2\u0D05-\u0D0C\u0D0E-\u0D10\u0D12-\u0D3A\u0D3D\u0D4E\u0D60\u0D61\u0D7A-\u0D7F\u0D85-\u0D96\u0D9A-\u0DB1\u0DB3-\u0DBB\u0DBD\u0DC0-\u0DC6\u0E01-\u0E30\u0E32\u0E33\u0E40-\u0E46\u0E81\u0E82\u0E84\u0E87\u0E88\u0E8A\u0E8D\u0E94-\u0E97\u0E99-\u0E9F\u0EA1-\u0EA3\u0EA5\u0EA7\u0EAA\u0EAB\u0EAD-\u0EB0\u0EB2\u0EB3\u0EBD\u0EC0-\u0EC4\u0EC6\u0EDC-\u0EDF\u0F00\u0F40-\u0F47\u0F49-\u0F6C\u0F88-\u0F8C\u1000-\u102A\u103F\u1050-\u1055\u105A-\u105D\u1061\u1065\u1066\u106E-\u1070\u1075-\u1081\u108E\u10A0-\u10C5\u10C7\u10CD\u10D0-\u10FA\u10FC-\u1248\u124A-\u124D\u1250-\u1256\u1258\u125A-\u125D\u1260-\u1288\u128A-\u128D\u1290-\u12B0\u12B2-\u12B5\u12B8-\u12BE\u12C0\u12C2-\u12C5\u12C8-\u12D6\u12D8-\u1310\u1312-\u1315\u1318-\u135A\u1380-\u138F\u13A0-\u13F4\u1401-\u166C\u166F-\u167F\u1681-\u169A\u16A0-\u16EA\u16F1-\u16F8\u1700-\u170C\u170E-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176C\u176E-\u1770\u1780-\u17B3\u17D7\u17DC\u1820-\u1877\u1880-\u18A8\u18AA\u18B0-\u18F5\u1900-\u191E\u1950-\u196D\u1970-\u1974\u1980-\u19AB\u19C1-\u19C7\u1A00-\u1A16\u1A20-\u1A54\u1AA7\u1B05-\u1B33\u1B45-\u1B4B\u1B83-\u1BA0\u1BAE\u1BAF\u1BBA-\u1BE5\u1C00-\u1C23\u1C4D-\u1C4F\u1C5A-\u1C7D\u1CE9-\u1CEC\u1CEE-\u1CF1\u1CF5\u1CF6\u1D00-\u1DBF\u1E00-\u1F15\u1F18-\u1F1D\u1F20-\u1F45\u1F48-\u1F4D\u1F50-\u1F57\u1F59\u1F5B\u1F5D\u1F5F-\u1F7D\u1F80-\u1FB4\u1FB6-\u1FBC\u1FBE\u1FC2-\u1FC4\u1FC6-\u1FCC\u1FD0-\u1FD3\u1FD6-\u1FDB\u1FE0-\u1FEC\u1FF2-\u1FF4\u1FF6-\u1FFC\u2071\u207F\u2090-\u209C\u2102\u2107\u210A-\u2113\u2115\u2119-\u211D\u2124\u2126\u2128\u212A-\u212D\u212F-\u2139\u213C-\u213F\u2145-\u2149\u214E\u2183\u2184\u2C00-\u2C2E\u2C30-\u2C5E\u2C60-\u2CE4\u2CEB-\u2CEE\u2CF2\u2CF3\u2D00-\u2D25\u2D27\u2D2D\u2D30-\u2D67\u2D6F\u2D80-\u2D96\u2DA0-\u2DA6\u2DA8-\u2DAE\u2DB0-\u2DB6\u2DB8-\u2DBE\u2DC0-\u2DC6\u2DC8-\u2DCE\u2DD0-\u2DD6\u2DD8-\u2DDE\u2E2F\u3005\u3006\u3031-\u3035\u303B\u303C\u3041-\u3096\u309D-\u309F\u30A1-\u30FA\u30FC-\u30FF\u3105-\u312D\u3131-\u318E\u31A0-\u31BA\u31F0-\u31FF\u3400-\u4DB5\u4E00-\u9FCC\uA000-\uA48C\uA4D0-\uA4FD\uA500-\uA60C\uA610-\uA61F\uA62A\uA62B\uA640-\uA66E\uA67F-\uA69D\uA6A0-\uA6E5\uA717-\uA71F\uA722-\uA788\uA78B-\uA78E\uA790-\uA7AD\uA7B0\uA7B1\uA7F7-\uA801\uA803-\uA805\uA807-\uA80A\uA80C-\uA822\uA840-\uA873\uA882-\uA8B3\uA8F2-\uA8F7\uA8FB\uA90A-\uA925\uA930-\uA946\uA960-\uA97C\uA984-\uA9B2\uA9CF\uA9E0-\uA9E4\uA9E6-\uA9EF\uA9FA-\uA9FE\uAA00-\uAA28\uAA40-\uAA42\uAA44-\uAA4B\uAA60-\uAA76\uAA7A\uAA7E-\uAAAF\uAAB1\uAAB5\uAAB6\uAAB9-\uAABD\uAAC0\uAAC2\uAADB-\uAADD\uAAE0-\uAAEA\uAAF2-\uAAF4\uAB01-\uAB06\uAB09-\uAB0E\uAB11-\uAB16\uAB20-\uAB26\uAB28-\uAB2E\uAB30-\uAB5A\uAB5C-\uAB5F\uAB64\uAB65\uABC0-\uABE2\uAC00-\uD7A3\uD7B0-\uD7C6\uD7CB-\uD7FB\uF900-\uFA6D\uFA70-\uFAD9\uFB00-\uFB06\uFB13-\uFB17\uFB1D\uFB1F-\uFB28\uFB2A-\uFB36\uFB38-\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46-\uFBB1\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFB\uFE70-\uFE74\uFE76-\uFEFC\uFF21-\uFF3A\uFF41-\uFF5A\uFF66-\uFFBE\uFFC2-\uFFC7\uFFCA-\uFFCF\uFFD2-\uFFD7\uFFDA-\uFFDC\u0300-\u036F\u0483-\u0489\u0591-\u05BD\u05BF\u05C1\u05C2\u05C4\u05C5\u05C7\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E4\u06E7\u06E8\u06EA-\u06ED\u0711\u0730-\u074A\u07A6-\u07B0\u07EB-\u07F3\u0816-\u0819\u081B-\u0823\u0825-\u0827\u0829-\u082D\u0859-\u085B\u08E4-\u0903\u093A-\u093C\u093E-\u094F\u0951-\u0957\u0962\u0963\u0981-\u0983\u09BC\u09BE-\u09C4\u09C7\u09C8\u09CB-\u09CD\u09D7\u09E2\u09E3\u0A01-\u0A03\u0A3C\u0A3E-\u0A42\u0A47\u0A48\u0A4B-\u0A4D\u0A51\u0A70\u0A71\u0A75\u0A81-\u0A83\u0ABC\u0ABE-\u0AC5\u0AC7-\u0AC9\u0ACB-\u0ACD\u0AE2\u0AE3\u0B01-\u0B03\u0B3C\u0B3E-\u0B44\u0B47\u0B48\u0B4B-\u0B4D\u0B56\u0B57\u0B62\u0B63\u0B82\u0BBE-\u0BC2\u0BC6-\u0BC8\u0BCA-\u0BCD\u0BD7\u0C00-\u0C03\u0C3E-\u0C44\u0C46-\u0C48\u0C4A-\u0C4D\u0C55\u0C56\u0C62\u0C63\u0C81-\u0C83\u0CBC\u0CBE-\u0CC4\u0CC6-\u0CC8\u0CCA-\u0CCD\u0CD5\u0CD6\u0CE2\u0CE3\u0D01-\u0D03\u0D3E-\u0D44\u0D46-\u0D48\u0D4A-\u0D4D\u0D57\u0D62\u0D63\u0D82\u0D83\u0DCA\u0DCF-\u0DD4\u0DD6\u0DD8-\u0DDF\u0DF2\u0DF3\u0E31\u0E34-\u0E3A\u0E47-\u0E4E\u0EB1\u0EB4-\u0EB9\u0EBB\u0EBC\u0EC8-\u0ECD\u0F18\u0F19\u0F35\u0F37\u0F39\u0F3E\u0F3F\u0F71-\u0F84\u0F86\u0F87\u0F8D-\u0F97\u0F99-\u0FBC\u0FC6\u102B-\u103E\u1056-\u1059\u105E-\u1060\u1062-\u1064\u1067-\u106D\u1071-\u1074\u1082-\u108D\u108F\u109A-\u109D\u135D-\u135F\u1712-\u1714\u1732-\u1734\u1752\u1753\u1772\u1773\u17B4-\u17D3\u17DD\u180B-\u180D\u18A9\u1920-\u192B\u1930-\u193B\u19B0-\u19C0\u19C8\u19C9\u1A17-\u1A1B\u1A55-\u1A5E\u1A60-\u1A7C\u1A7F\u1AB0-\u1ABE\u1B00-\u1B04\u1B34-\u1B44\u1B6B-\u1B73\u1B80-\u1B82\u1BA1-\u1BAD\u1BE6-\u1BF3\u1C24-\u1C37\u1CD0-\u1CD2\u1CD4-\u1CE8\u1CED\u1CF2-\u1CF4\u1CF8\u1CF9\u1DC0-\u1DF5\u1DFC-\u1DFF\u20D0-\u20F0\u2CEF-\u2CF1\u2D7F\u2DE0-\u2DFF\u302A-\u302F\u3099\u309A\uA66F-\uA672\uA674-\uA67D\uA69F\uA6F0\uA6F1\uA802\uA806\uA80B\uA823-\uA827\uA880\uA881\uA8B4-\uA8C4\uA8E0-\uA8F1\uA926-\uA92D\uA947-\uA953\uA980-\uA983\uA9B3-\uA9C0\uA9E5\uAA29-\uAA36\uAA43\uAA4C\uAA4D\uAA7B-\uAA7D\uAAB0\uAAB2-\uAAB4\uAAB7\uAAB8\uAABE\uAABF\uAAC1\uAAEB-\uAAEF\uAAF5\uAAF6\uABE3-\uABEA\uABEC\uABED\uFB1E\uFE00-\uFE0F\uFE20-\uFE2D";
  var unicodeNumbers = "0-9\u0660-\u0669\u06F0-\u06F9\u07C0-\u07C9\u0966-\u096F\u09E6-\u09EF\u0A66-\u0A6F\u0AE6-\u0AEF\u0B66-\u0B6F\u0BE6-\u0BEF\u0C66-\u0C6F\u0CE6-\u0CEF\u0D66-\u0D6F\u0DE6-\u0DEF\u0E50-\u0E59\u0ED0-\u0ED9\u0F20-\u0F29\u1040-\u1049\u1090-\u1099\u17E0-\u17E9\u1810-\u1819\u1946-\u194F\u19D0-\u19D9\u1A80-\u1A89\u1A90-\u1A99\u1B50-\u1B59\u1BB0-\u1BB9\u1C40-\u1C49\u1C50-\u1C59\uA620-\uA629\uA8D0-\uA8D9\uA900-\uA909\uA9D0-\uA9D9\uA9F0-\uA9F9\uAA50-\uAA59\uABF0-\uABF9\uFF10-\uFF19";
  var hashtagSpecialChars = "_\u200c\u200d\ua67e\u05be\u05f3\u05f4\u309b\u309c\u30a0\u30fb\u3003\u0f0b\u0f0c\u00b7";

  // A hashtag must contain at least one unicode letter or mark, as well as numbers, underscores, and select special characters.
  twttr.txt.regexen.hashSigns = /[#＃]/;
  twttr.txt.regexen.hashtagAlpha = new RegExp("[" + unicodeLettersAndMarks + "]");
  twttr.txt.regexen.hashtagAlphaNumeric = new RegExp("[" + unicodeLettersAndMarks + unicodeNumbers + hashtagSpecialChars + "]");
  twttr.txt.regexen.endHashtagMatch = regexSupplant(/^(?:#{hashSigns}|:\/\/)/);
  twttr.txt.regexen.hashtagBoundary = new RegExp("(?:^|$|[^&" + unicodeLettersAndMarks + unicodeNumbers + hashtagSpecialChars + "])");
  twttr.txt.regexen.validHashtag = regexSupplant(/(#{hashtagBoundary})(#{hashSigns})(#{hashtagAlphaNumeric}*#{hashtagAlpha}#{hashtagAlphaNumeric}*)/gi);

  // Mention related regex collection
  twttr.txt.regexen.validMentionPrecedingChars = /(?:^|[^a-zA-Z0-9_!#$%&*@＠]|(?:^|[^a-zA-Z0-9_+~.-])(?:rt|RT|rT|Rt):?)/;
  twttr.txt.regexen.atSigns = /[@＠]/;
  twttr.txt.regexen.validMentionOrList = regexSupplant(
    '(#{validMentionPrecedingChars})' +  // $1: Preceding character
    '(#{atSigns})' +                     // $2: At mark
    '([a-zA-Z0-9_]{1,20})' +             // $3: Screen name
    '(\/[a-zA-Z][a-zA-Z0-9_\-]{0,24})?'  // $4: List (optional)
  , 'g');
  twttr.txt.regexen.validReply = regexSupplant(/^(?:#{spaces})*#{atSigns}([a-zA-Z0-9_]{1,20})/);
  twttr.txt.regexen.endMentionMatch = regexSupplant(/^(?:#{atSigns}|[#{latinAccentChars}]|:\/\/)/);

  // URL related regex collection
  twttr.txt.regexen.validUrlPrecedingChars = regexSupplant(/(?:[^A-Za-z0-9@＠$#＃#{invalid_chars_group}]|^)/);
  twttr.txt.regexen.invalidUrlWithoutProtocolPrecedingChars = /[-_.\/]$/;
  twttr.txt.regexen.invalidDomainChars = stringSupplant("#{punct}#{spaces_group}#{invalid_chars_group}", twttr.txt.regexen);
  twttr.txt.regexen.validDomainChars = regexSupplant(/[^#{invalidDomainChars}]/);
  twttr.txt.regexen.validSubdomain = regexSupplant(/(?:(?:#{validDomainChars}(?:[_-]|#{validDomainChars})*)?#{validDomainChars}\.)/);
  twttr.txt.regexen.validDomainName = regexSupplant(/(?:(?:#{validDomainChars}(?:-|#{validDomainChars})*)?#{validDomainChars}\.)/);
  twttr.txt.regexen.validGTLD = regexSupplant(RegExp(
    '(?:(?:' +
    'abb|abbott|abogado|academy|accenture|accountant|accountants|aco|active|actor|ads|adult|aeg|aero|' +
    'afl|agency|aig|airforce|airtel|allfinanz|alsace|amsterdam|android|apartments|app|aquarelle|' +
    'archi|army|arpa|asia|associates|attorney|auction|audio|auto|autos|axa|azure|band|bank|bar|' +
    'barcelona|barclaycard|barclays|bargains|bauhaus|bayern|bbc|bbva|bcn|beer|bentley|berlin|best|' +
    'bet|bharti|bible|bid|bike|bing|bingo|bio|biz|black|blackfriday|bloomberg|blue|bmw|bnl|' +
    'bnpparibas|boats|bond|boo|boots|boutique|bradesco|bridgestone|broker|brother|brussels|budapest|' +
    'build|builders|business|buzz|bzh|cab|cafe|cal|camera|camp|cancerresearch|canon|capetown|capital|' +
    'caravan|cards|care|career|careers|cars|cartier|casa|cash|casino|cat|catering|cba|cbn|ceb|center|' +
    'ceo|cern|cfa|cfd|chanel|channel|chat|cheap|chloe|christmas|chrome|church|cisco|citic|city|' +
    'claims|cleaning|click|clinic|clothing|cloud|club|coach|codes|coffee|college|cologne|com|' +
    'commbank|community|company|computer|condos|construction|consulting|contractors|cooking|cool|' +
    'coop|corsica|country|coupons|courses|credit|creditcard|cricket|crown|crs|cruises|cuisinella|' +
    'cymru|cyou|dabur|dad|dance|date|dating|datsun|day|dclk|deals|degree|delivery|delta|democrat|' +
    'dental|dentist|desi|design|dev|diamonds|diet|digital|direct|directory|discount|dnp|docs|dog|' +
    'doha|domains|doosan|download|drive|durban|dvag|earth|eat|edu|education|email|emerck|energy|' +
    'engineer|engineering|enterprises|epson|equipment|erni|esq|estate|eurovision|eus|events|everbank|' +
    'exchange|expert|exposed|express|fage|fail|faith|family|fan|fans|farm|fashion|feedback|film|' +
    'finance|financial|firmdale|fish|fishing|fit|fitness|flights|florist|flowers|flsmidth|fly|foo|' +
    'football|forex|forsale|forum|foundation|frl|frogans|fund|furniture|futbol|fyi|gal|gallery|game|' +
    'garden|gbiz|gdn|gent|genting|ggee|gift|gifts|gives|giving|glass|gle|global|globo|gmail|gmo|gmx|' +
    'gold|goldpoint|golf|goo|goog|google|gop|gov|graphics|gratis|green|gripe|group|guge|guide|' +
    'guitars|guru|hamburg|hangout|haus|healthcare|help|here|hermes|hiphop|hitachi|hiv|hockey|' +
    'holdings|holiday|homedepot|homes|honda|horse|host|hosting|hoteles|hotmail|house|how|hsbc|ibm|' +
    'icbc|ice|icu|ifm|iinet|immo|immobilien|industries|infiniti|info|ing|ink|institute|insure|int|' +
    'international|investments|ipiranga|irish|ist|istanbul|itau|iwc|java|jcb|jetzt|jewelry|jlc|jll|' +
    'jobs|joburg|jprs|juegos|kaufen|kddi|kim|kitchen|kiwi|koeln|komatsu|krd|kred|kyoto|lacaixa|' +
    'lancaster|land|lasalle|lat|latrobe|law|lawyer|lds|lease|leclerc|legal|lexus|lgbt|liaison|lidl|' +
    'life|lighting|limited|limo|link|live|lixil|loan|loans|lol|london|lotte|lotto|love|ltda|lupin|' +
    'luxe|luxury|madrid|maif|maison|man|management|mango|market|marketing|markets|marriott|mba|media|' +
    'meet|melbourne|meme|memorial|men|menu|miami|microsoft|mil|mini|mma|mobi|moda|moe|mom|monash|' +
    'money|montblanc|mormon|mortgage|moscow|motorcycles|mov|movie|movistar|mtn|mtpc|museum|nadex|' +
    'nagoya|name|navy|nec|net|netbank|network|neustar|new|news|nexus|ngo|nhk|nico|ninja|nissan|nokia|' +
    'nra|nrw|ntt|nyc|office|okinawa|omega|one|ong|onl|online|ooo|oracle|orange|org|organic|osaka|' +
    'otsuka|ovh|page|panerai|paris|partners|parts|party|pet|pharmacy|philips|photo|photography|' +
    'photos|physio|piaget|pics|pictet|pictures|pink|pizza|place|play|plumbing|plus|pohl|poker|porn|' +
    'post|praxi|press|pro|prod|productions|prof|properties|property|pub|qpon|quebec|racing|realtor|' +
    'realty|recipes|red|redstone|rehab|reise|reisen|reit|ren|rent|rentals|repair|report|republican|' +
    'rest|restaurant|review|reviews|rich|ricoh|rio|rip|rocks|rodeo|rsvp|ruhr|run|ryukyu|saarland|' +
    'sakura|sale|samsung|sandvik|sandvikcoromant|sanofi|sap|sarl|saxo|sca|scb|schmidt|scholarships|' +
    'school|schule|schwarz|science|scor|scot|seat|seek|sener|services|sew|sex|sexy|shiksha|shoes|' +
    'show|shriram|singles|site|ski|sky|skype|sncf|soccer|social|software|sohu|solar|solutions|sony|' +
    'soy|space|spiegel|spreadbetting|srl|starhub|statoil|studio|study|style|sucks|supplies|supply|' +
    'support|surf|surgery|suzuki|swatch|swiss|sydney|systems|taipei|tatamotors|tatar|tattoo|tax|taxi|' +
    'team|tech|technology|tel|telefonica|temasek|tennis|thd|theater|tickets|tienda|tips|tires|tirol|' +
    'today|tokyo|tools|top|toray|toshiba|tours|town|toyota|toys|trade|trading|training|travel|trust|' +
    'tui|ubs|university|uno|uol|vacations|vegas|ventures|vermögensberater|vermögensberatung|' +
    'versicherung|vet|viajes|video|villas|vin|vision|vista|vistaprint|vlaanderen|vodka|vote|voting|' +
    'voto|voyage|wales|walter|wang|watch|webcam|website|wed|wedding|weir|whoswho|wien|wiki|' +
    'williamhill|win|windows|wine|wme|work|works|world|wtc|wtf|xbox|xerox|xin|xperia|xxx|xyz|yachts|' +
    'yandex|yodobashi|yoga|yokohama|youtube|zip|zone|zuerich|дети|ком|москва|онлайн|орг|рус|сайт|קום|' +
    'بازار|شبكة|كوم|موقع|कॉम|नेट|संगठन|คอม|みんな|グーグル|コム|世界|中信|中文网|企业|佛山|信息|健康|八卦|公司|公益|商城|商店|商标|在线|大拿|' +
    '娱乐|工行|广东|慈善|我爱你|手机|政务|政府|新闻|时尚|机构|淡马锡|游戏|点看|移动|组织机构|网址|网店|网络|谷歌|集团|飞利浦|餐厅|닷넷|닷컴|삼성|onion' +
    ')(?=[^0-9a-zA-Z@]|$))'));
  twttr.txt.regexen.validCCTLD = regexSupplant(RegExp(
    '(?:(?:' +
    'ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bl|bm|bn|bo|bq|' +
    'br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cw|cx|cy|cz|de|dj|dk|dm|do|dz|' +
    'ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|' +
    'gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|' +
    'la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mf|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|' +
    'my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|' +
    'rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|' +
    'tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|za|zm|zw|ελ|' +
    'бел|мкд|мон|рф|срб|укр|қаз|հայ|الاردن|الجزائر|السعودية|المغرب|امارات|ایران|بھارت|تونس|سودان|' +
    'سورية|عراق|عمان|فلسطين|قطر|مصر|مليسيا|پاکستان|भारत|বাংলা|ভারত|ਭਾਰਤ|ભારત|இந்தியா|இலங்கை|' +
    'சிங்கப்பூர்|భారత్|ලංකා|ไทย|გე|中国|中國|台湾|台灣|新加坡|澳門|香港|한국' +
    ')(?=[^0-9a-zA-Z@]|$))'));
  twttr.txt.regexen.validPunycode = regexSupplant(/(?:xn--[0-9a-z]+)/);
  twttr.txt.regexen.validSpecialCCTLD = regexSupplant(RegExp(
    '(?:(?:co|tv)(?=[^0-9a-zA-Z@]|$))'));
  twttr.txt.regexen.validDomain = regexSupplant(/(?:#{validSubdomain}*#{validDomainName}(?:#{validGTLD}|#{validCCTLD}|#{validPunycode}))/);
  twttr.txt.regexen.validAsciiDomain = regexSupplant(/(?:(?:[\-a-z0-9#{latinAccentChars}]+)\.)+(?:#{validGTLD}|#{validCCTLD}|#{validPunycode})/gi);
  twttr.txt.regexen.invalidShortDomain = regexSupplant(/^#{validDomainName}#{validCCTLD}$/i);
  twttr.txt.regexen.validSpecialShortDomain = regexSupplant(/^#{validDomainName}#{validSpecialCCTLD}$/i);

  twttr.txt.regexen.validPortNumber = regexSupplant(/[0-9]+/);

  twttr.txt.regexen.validGeneralUrlPathChars = regexSupplant(/[a-z0-9!\*';:=\+,\.\$\/%#\[\]\-_~@|&#{latinAccentChars}]/i);
  // Allow URL paths to contain up to two nested levels of balanced parens
  //  1. Used in Wikipedia URLs like /Primer_(film)
  //  2. Used in IIS sessions like /S(dfd346)/
  //  3. Used in Rdio URLs like /track/We_Up_(Album_Version_(Edited))/
  twttr.txt.regexen.validUrlBalancedParens = regexSupplant(
    '\\('                                   +
      '(?:'                                 +
        '#{validGeneralUrlPathChars}+'      +
        '|'                                 +
        // allow one nested level of balanced parentheses
        '(?:'                               +
          '#{validGeneralUrlPathChars}*'    +
          '\\('                             +
            '#{validGeneralUrlPathChars}+'  +
          '\\)'                             +
          '#{validGeneralUrlPathChars}*'    +
        ')'                                 +
      ')'                                   +
    '\\)'
  , 'i');
  // Valid end-of-path chracters (so /foo. does not gobble the period).
  // 1. Allow =&# for empty URL parameters and other URL-join artifacts
  twttr.txt.regexen.validUrlPathEndingChars = regexSupplant(/[\+\-a-z0-9=_#\/#{latinAccentChars}]|(?:#{validUrlBalancedParens})/i);
  // Allow @ in a url, but only in the middle. Catch things like http://example.com/@user/
  twttr.txt.regexen.validUrlPath = regexSupplant('(?:' +
    '(?:' +
      '#{validGeneralUrlPathChars}*' +
        '(?:#{validUrlBalancedParens}#{validGeneralUrlPathChars}*)*' +
        '#{validUrlPathEndingChars}'+
      ')|(?:@#{validGeneralUrlPathChars}+\/)'+
    ')', 'i');

  twttr.txt.regexen.validUrlQueryChars = /[a-z0-9!?\*'@\(\);:&=\+\$\/%#\[\]\-_\.,~|]/i;
  twttr.txt.regexen.validUrlQueryEndingChars = /[a-z0-9_&=#\/]/i;
  twttr.txt.regexen.extractUrl = regexSupplant(
    '('                                                            + // $1 total match
      '(#{validUrlPrecedingChars})'                                + // $2 Preceeding chracter
      '('                                                          + // $3 URL
        '(https?:\\/\\/)?'                                         + // $4 Protocol (optional)
        '(#{validDomain})'                                         + // $5 Domain(s)
        '(?::(#{validPortNumber}))?'                               + // $6 Port number (optional)
        '(\\/#{validUrlPath}*)?'                                   + // $7 URL Path
        '(\\?#{validUrlQueryChars}*#{validUrlQueryEndingChars})?'  + // $8 Query String
      ')'                                                          +
    ')'
  , 'gi');

  twttr.txt.regexen.validTcoUrl = /^https?:\/\/t\.co\/[a-z0-9]+/i;
  twttr.txt.regexen.urlHasProtocol = /^https?:\/\//i;
  twttr.txt.regexen.urlHasHttps = /^https:\/\//i;

  // cashtag related regex
  twttr.txt.regexen.cashtag = /[a-z]{1,6}(?:[._][a-z]{1,2})?/i;
  twttr.txt.regexen.validCashtag = regexSupplant('(^|#{spaces})(\\$)(#{cashtag})(?=$|\\s|[#{punct}])', 'gi');

  // These URL validation pattern strings are based on the ABNF from RFC 3986
  twttr.txt.regexen.validateUrlUnreserved = /[a-z0-9\-._~]/i;
  twttr.txt.regexen.validateUrlPctEncoded = /(?:%[0-9a-f]{2})/i;
  twttr.txt.regexen.validateUrlSubDelims = /[!$&'()*+,;=]/i;
  twttr.txt.regexen.validateUrlPchar = regexSupplant('(?:' +
    '#{validateUrlUnreserved}|' +
    '#{validateUrlPctEncoded}|' +
    '#{validateUrlSubDelims}|' +
    '[:|@]' +
  ')', 'i');

  twttr.txt.regexen.validateUrlScheme = /(?:[a-z][a-z0-9+\-.]*)/i;
  twttr.txt.regexen.validateUrlUserinfo = regexSupplant('(?:' +
    '#{validateUrlUnreserved}|' +
    '#{validateUrlPctEncoded}|' +
    '#{validateUrlSubDelims}|' +
    ':' +
  ')*', 'i');

  twttr.txt.regexen.validateUrlDecOctet = /(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9]{2})|(?:2[0-4][0-9])|(?:25[0-5]))/i;
  twttr.txt.regexen.validateUrlIpv4 = regexSupplant(/(?:#{validateUrlDecOctet}(?:\.#{validateUrlDecOctet}){3})/i);

  // Punting on real IPv6 validation for now
  twttr.txt.regexen.validateUrlIpv6 = /(?:\[[a-f0-9:\.]+\])/i;

  // Also punting on IPvFuture for now
  twttr.txt.regexen.validateUrlIp = regexSupplant('(?:' +
    '#{validateUrlIpv4}|' +
    '#{validateUrlIpv6}' +
  ')', 'i');

  // This is more strict than the rfc specifies
  twttr.txt.regexen.validateUrlSubDomainSegment = /(?:[a-z0-9](?:[a-z0-9_\-]*[a-z0-9])?)/i;
  twttr.txt.regexen.validateUrlDomainSegment = /(?:[a-z0-9](?:[a-z0-9\-]*[a-z0-9])?)/i;
  twttr.txt.regexen.validateUrlDomainTld = /(?:[a-z](?:[a-z0-9\-]*[a-z0-9])?)/i;
  twttr.txt.regexen.validateUrlDomain = regexSupplant(/(?:(?:#{validateUrlSubDomainSegment]}\.)*(?:#{validateUrlDomainSegment]}\.)#{validateUrlDomainTld})/i);

  twttr.txt.regexen.validateUrlHost = regexSupplant('(?:' +
    '#{validateUrlIp}|' +
    '#{validateUrlDomain}' +
  ')', 'i');

  // Unencoded internationalized domains - this doesn't check for invalid UTF-8 sequences
  twttr.txt.regexen.validateUrlUnicodeSubDomainSegment = /(?:(?:[a-z0-9]|[^\u0000-\u007f])(?:(?:[a-z0-9_\-]|[^\u0000-\u007f])*(?:[a-z0-9]|[^\u0000-\u007f]))?)/i;
  twttr.txt.regexen.validateUrlUnicodeDomainSegment = /(?:(?:[a-z0-9]|[^\u0000-\u007f])(?:(?:[a-z0-9\-]|[^\u0000-\u007f])*(?:[a-z0-9]|[^\u0000-\u007f]))?)/i;
  twttr.txt.regexen.validateUrlUnicodeDomainTld = /(?:(?:[a-z]|[^\u0000-\u007f])(?:(?:[a-z0-9\-]|[^\u0000-\u007f])*(?:[a-z0-9]|[^\u0000-\u007f]))?)/i;
  twttr.txt.regexen.validateUrlUnicodeDomain = regexSupplant(/(?:(?:#{validateUrlUnicodeSubDomainSegment}\.)*(?:#{validateUrlUnicodeDomainSegment}\.)#{validateUrlUnicodeDomainTld})/i);

  twttr.txt.regexen.validateUrlUnicodeHost = regexSupplant('(?:' +
    '#{validateUrlIp}|' +
    '#{validateUrlUnicodeDomain}' +
  ')', 'i');

  twttr.txt.regexen.validateUrlPort = /[0-9]{1,5}/;

  twttr.txt.regexen.validateUrlUnicodeAuthority = regexSupplant(
    '(?:(#{validateUrlUserinfo})@)?'  + // $1 userinfo
    '(#{validateUrlUnicodeHost})'     + // $2 host
    '(?::(#{validateUrlPort}))?'        //$3 port
  , "i");

  twttr.txt.regexen.validateUrlAuthority = regexSupplant(
    '(?:(#{validateUrlUserinfo})@)?' + // $1 userinfo
    '(#{validateUrlHost})'           + // $2 host
    '(?::(#{validateUrlPort}))?'       // $3 port
  , "i");

  twttr.txt.regexen.validateUrlPath = regexSupplant(/(\/#{validateUrlPchar}*)*/i);
  twttr.txt.regexen.validateUrlQuery = regexSupplant(/(#{validateUrlPchar}|\/|\?)*/i);
  twttr.txt.regexen.validateUrlFragment = regexSupplant(/(#{validateUrlPchar}|\/|\?)*/i);

  // Modified version of RFC 3986 Appendix B
  twttr.txt.regexen.validateUrlUnencoded = regexSupplant(
    '^'                               + // Full URL
    '(?:'                             +
      '([^:/?#]+):\\/\\/'             + // $1 Scheme
    ')?'                              +
    '([^/?#]*)'                       + // $2 Authority
    '([^?#]*)'                        + // $3 Path
    '(?:'                             +
      '\\?([^#]*)'                    + // $4 Query
    ')?'                              +
    '(?:'                             +
      '#(.*)'                         + // $5 Fragment
    ')?$'
  , "i");


  // Default CSS class for auto-linked lists (along with the url class)
  var DEFAULT_LIST_CLASS = "tweet-url list-slug";
  // Default CSS class for auto-linked usernames (along with the url class)
  var DEFAULT_USERNAME_CLASS = "tweet-url username";
  // Default CSS class for auto-linked hashtags (along with the url class)
  var DEFAULT_HASHTAG_CLASS = "tweet-url hashtag";
  // Default CSS class for auto-linked cashtags (along with the url class)
  var DEFAULT_CASHTAG_CLASS = "tweet-url cashtag";
  // Options which should not be passed as HTML attributes
  var OPTIONS_NOT_ATTRIBUTES = {'urlClass':true, 'listClass':true, 'usernameClass':true, 'hashtagClass':true, 'cashtagClass':true,
                            'usernameUrlBase':true, 'listUrlBase':true, 'hashtagUrlBase':true, 'cashtagUrlBase':true,
                            'usernameUrlBlock':true, 'listUrlBlock':true, 'hashtagUrlBlock':true, 'linkUrlBlock':true,
                            'usernameIncludeSymbol':true, 'suppressLists':true, 'suppressNoFollow':true, 'targetBlank':true,
                            'suppressDataScreenName':true, 'urlEntities':true, 'symbolTag':true, 'textWithSymbolTag':true, 'urlTarget':true,
                            'invisibleTagAttrs':true, 'linkAttributeBlock':true, 'linkTextBlock': true, 'htmlEscapeNonEntities': true
                            };

  var BOOLEAN_ATTRIBUTES = {'disabled':true, 'readonly':true, 'multiple':true, 'checked':true};

  // Simple object cloning function for simple objects
  function clone(o) {
    var r = {};
    for (var k in o) {
      if (o.hasOwnProperty(k)) {
        r[k] = o[k];
      }
    }

    return r;
  }

  twttr.txt.tagAttrs = function(attributes) {
    var htmlAttrs = "";
    for (var k in attributes) {
      var v = attributes[k];
      if (BOOLEAN_ATTRIBUTES[k]) {
        v = v ? k : null;
      }
      if (v == null) continue;
      htmlAttrs += " " + twttr.txt.htmlEscape(k) + "=\"" + twttr.txt.htmlEscape(v.toString()) + "\"";
    }
    return htmlAttrs;
  };

  twttr.txt.linkToText = function(entity, text, attributes, options) {
    if (!options.suppressNoFollow) {
      attributes.rel = "nofollow";
    }
    // if linkAttributeBlock is specified, call it to modify the attributes
    if (options.linkAttributeBlock) {
      options.linkAttributeBlock(entity, attributes);
    }
    // if linkTextBlock is specified, call it to get a new/modified link text
    if (options.linkTextBlock) {
      text = options.linkTextBlock(entity, text);
    }
    var d = {
      text: text,
      attr: twttr.txt.tagAttrs(attributes)
    };
    return stringSupplant("<a#{attr}>#{text}</a>", d);
  };

  twttr.txt.linkToTextWithSymbol = function(entity, symbol, text, attributes, options) {
    var taggedSymbol = options.symbolTag ? "<" + options.symbolTag + ">" + symbol + "</"+ options.symbolTag + ">" : symbol;
    text = twttr.txt.htmlEscape(text);
    var taggedText = options.textWithSymbolTag ? "<" + options.textWithSymbolTag + ">" + text + "</"+ options.textWithSymbolTag + ">" : text;

    if (options.usernameIncludeSymbol || !symbol.match(twttr.txt.regexen.atSigns)) {
      return twttr.txt.linkToText(entity, taggedSymbol + taggedText, attributes, options);
    } else {
      return taggedSymbol + twttr.txt.linkToText(entity, taggedText, attributes, options);
    }
  };

  twttr.txt.linkToHashtag = function(entity, text, options) {
    var hash = text.substring(entity.indices[0], entity.indices[0] + 1);
    var hashtag = twttr.txt.htmlEscape(entity.hashtag);
    var attrs = clone(options.htmlAttrs || {});
    attrs.href = options.hashtagUrlBase + hashtag;
    attrs.title = "#" + hashtag;
    attrs["class"] = options.hashtagClass;
    if (hashtag.charAt(0).match(twttr.txt.regexen.rtl_chars)){
      attrs["class"] += " rtl";
    }
    if (options.targetBlank) {
      attrs.target = '_blank';
    }

    return twttr.txt.linkToTextWithSymbol(entity, hash, hashtag, attrs, options);
  };

  twttr.txt.linkToCashtag = function(entity, text, options) {
    var cashtag = twttr.txt.htmlEscape(entity.cashtag);
    var attrs = clone(options.htmlAttrs || {});
    attrs.href = options.cashtagUrlBase + cashtag;
    attrs.title = "$" + cashtag;
    attrs["class"] =  options.cashtagClass;
    if (options.targetBlank) {
      attrs.target = '_blank';
    }

    return twttr.txt.linkToTextWithSymbol(entity, "$", cashtag, attrs, options);
  };

  twttr.txt.linkToMentionAndList = function(entity, text, options) {
    var at = text.substring(entity.indices[0], entity.indices[0] + 1);
    var user = twttr.txt.htmlEscape(entity.screenName);
    var slashListname = twttr.txt.htmlEscape(entity.listSlug);
    var isList = entity.listSlug && !options.suppressLists;
    var attrs = clone(options.htmlAttrs || {});
    attrs["class"] = (isList ? options.listClass : options.usernameClass);
    attrs.href = isList ? options.listUrlBase + user + slashListname : options.usernameUrlBase + user;
    if (!isList && !options.suppressDataScreenName) {
      attrs['data-screen-name'] = user;
    }
    if (options.targetBlank) {
      attrs.target = '_blank';
    }

    return twttr.txt.linkToTextWithSymbol(entity, at, isList ? user + slashListname : user, attrs, options);
  };

  twttr.txt.linkToUrl = function(entity, text, options) {
    var url = entity.url;
    var displayUrl = url;
    var linkText = twttr.txt.htmlEscape(displayUrl);

    // If the caller passed a urlEntities object (provided by a Twitter API
    // response with include_entities=true), we use that to render the display_url
    // for each URL instead of it's underlying t.co URL.
    var urlEntity = (options.urlEntities && options.urlEntities[url]) || entity;
    if (urlEntity.display_url) {
      linkText = twttr.txt.linkTextWithEntity(urlEntity, options);
    }

    var attrs = clone(options.htmlAttrs || {});

    if (!url.match(twttr.txt.regexen.urlHasProtocol)) {
      url = "http://" + url;
    }
    attrs.href = url;

    if (options.targetBlank) {
      attrs.target = '_blank';
    }

    // set class only if urlClass is specified.
    if (options.urlClass) {
      attrs["class"] = options.urlClass;
    }

    // set target only if urlTarget is specified.
    if (options.urlTarget) {
      attrs.target = options.urlTarget;
    }

    if (!options.title && urlEntity.display_url) {
      attrs.title = urlEntity.expanded_url;
    }

    return twttr.txt.linkToText(entity, linkText, attrs, options);
  };

  twttr.txt.linkTextWithEntity = function (entity, options) {
    var displayUrl = entity.display_url;
    var expandedUrl = entity.expanded_url;

    // Goal: If a user copies and pastes a tweet containing t.co'ed link, the resulting paste
    // should contain the full original URL (expanded_url), not the display URL.
    //
    // Method: Whenever possible, we actually emit HTML that contains expanded_url, and use
    // font-size:0 to hide those parts that should not be displayed (because they are not part of display_url).
    // Elements with font-size:0 get copied even though they are not visible.
    // Note that display:none doesn't work here. Elements with display:none don't get copied.
    //
    // Additionally, we want to *display* ellipses, but we don't want them copied.  To make this happen we
    // wrap the ellipses in a tco-ellipsis class and provide an onCopy handler that sets display:none on
    // everything with the tco-ellipsis class.
    //
    // Exception: pic.twitter.com images, for which expandedUrl = "https://twitter.com/#!/username/status/1234/photo/1
    // For those URLs, display_url is not a substring of expanded_url, so we don't do anything special to render the elided parts.
    // For a pic.twitter.com URL, the only elided part will be the "https://", so this is fine.

    var displayUrlSansEllipses = displayUrl.replace(/…/g, ""); // We have to disregard ellipses for matching
    // Note: we currently only support eliding parts of the URL at the beginning or the end.
    // Eventually we may want to elide parts of the URL in the *middle*.  If so, this code will
    // become more complicated.  We will probably want to create a regexp out of display URL,
    // replacing every ellipsis with a ".*".
    if (expandedUrl.indexOf(displayUrlSansEllipses) != -1) {
      var displayUrlIndex = expandedUrl.indexOf(displayUrlSansEllipses);
      var v = {
        displayUrlSansEllipses: displayUrlSansEllipses,
        // Portion of expandedUrl that precedes the displayUrl substring
        beforeDisplayUrl: expandedUrl.substr(0, displayUrlIndex),
        // Portion of expandedUrl that comes after displayUrl
        afterDisplayUrl: expandedUrl.substr(displayUrlIndex + displayUrlSansEllipses.length),
        precedingEllipsis: displayUrl.match(/^…/) ? "…" : "",
        followingEllipsis: displayUrl.match(/…$/) ? "…" : ""
      };
      for (var k in v) {
        if (v.hasOwnProperty(k)) {
          v[k] = twttr.txt.htmlEscape(v[k]);
        }
      }
      // As an example: The user tweets "hi http://longdomainname.com/foo"
      // This gets shortened to "hi http://t.co/xyzabc", with display_url = "…nname.com/foo"
      // This will get rendered as:
      // <span class='tco-ellipsis'> <!-- This stuff should get displayed but not copied -->
      //   …
      //   <!-- There's a chance the onCopy event handler might not fire. In case that happens,
      //        we include an &nbsp; here so that the … doesn't bump up against the URL and ruin it.
      //        The &nbsp; is inside the tco-ellipsis span so that when the onCopy handler *does*
      //        fire, it doesn't get copied.  Otherwise the copied text would have two spaces in a row,
      //        e.g. "hi  http://longdomainname.com/foo".
      //   <span style='font-size:0'>&nbsp;</span>
      // </span>
      // <span style='font-size:0'>  <!-- This stuff should get copied but not displayed -->
      //   http://longdomai
      // </span>
      // <span class='js-display-url'> <!-- This stuff should get displayed *and* copied -->
      //   nname.com/foo
      // </span>
      // <span class='tco-ellipsis'> <!-- This stuff should get displayed but not copied -->
      //   <span style='font-size:0'>&nbsp;</span>
      //   …
      // </span>
      v['invisible'] = options.invisibleTagAttrs;
      return stringSupplant("<span class='tco-ellipsis'>#{precedingEllipsis}<span #{invisible}>&nbsp;</span></span><span #{invisible}>#{beforeDisplayUrl}</span><span class='js-display-url'>#{displayUrlSansEllipses}</span><span #{invisible}>#{afterDisplayUrl}</span><span class='tco-ellipsis'><span #{invisible}>&nbsp;</span>#{followingEllipsis}</span>", v);
    }
    return displayUrl;
  };

  twttr.txt.autoLinkEntities = function(text, entities, options) {
    options = clone(options || {});

    options.hashtagClass = options.hashtagClass || DEFAULT_HASHTAG_CLASS;
    options.hashtagUrlBase = options.hashtagUrlBase || "https://twitter.com/#!/search?q=%23";
    options.cashtagClass = options.cashtagClass || DEFAULT_CASHTAG_CLASS;
    options.cashtagUrlBase = options.cashtagUrlBase || "https://twitter.com/#!/search?q=%24";
    options.listClass = options.listClass || DEFAULT_LIST_CLASS;
    options.usernameClass = options.usernameClass || DEFAULT_USERNAME_CLASS;
    options.usernameUrlBase = options.usernameUrlBase || "https://twitter.com/";
    options.listUrlBase = options.listUrlBase || "https://twitter.com/";
    options.htmlAttrs = twttr.txt.extractHtmlAttrsFromOptions(options);
    options.invisibleTagAttrs = options.invisibleTagAttrs || "style='position:absolute;left:-9999px;'";

    // remap url entities to hash
    var urlEntities, i, len;
    if(options.urlEntities) {
      urlEntities = {};
      for(i = 0, len = options.urlEntities.length; i < len; i++) {
        urlEntities[options.urlEntities[i].url] = options.urlEntities[i];
      }
      options.urlEntities = urlEntities;
    }

    var result = "";
    var beginIndex = 0;

    // sort entities by start index
    entities.sort(function(a,b){ return a.indices[0] - b.indices[0]; });

    var nonEntity = options.htmlEscapeNonEntities ? twttr.txt.htmlEscape : function(text) {
      return text;
    };

    for (var i = 0; i < entities.length; i++) {
      var entity = entities[i];
      result += nonEntity(text.substring(beginIndex, entity.indices[0]));

      if (entity.url) {
        result += twttr.txt.linkToUrl(entity, text, options);
      } else if (entity.hashtag) {
        result += twttr.txt.linkToHashtag(entity, text, options);
      } else if (entity.screenName) {
        result += twttr.txt.linkToMentionAndList(entity, text, options);
      } else if (entity.cashtag) {
        result += twttr.txt.linkToCashtag(entity, text, options);
      }
      beginIndex = entity.indices[1];
    }
    result += nonEntity(text.substring(beginIndex, text.length));
    return result;
  };

  twttr.txt.autoLinkWithJSON = function(text, json, options) {
    // map JSON entity to twitter-text entity
    if (json.user_mentions) {
      for (var i = 0; i < json.user_mentions.length; i++) {
        // this is a @mention
        json.user_mentions[i].screenName = json.user_mentions[i].screen_name;
      }
    }

    if (json.hashtags) {
      for (var i = 0; i < json.hashtags.length; i++) {
        // this is a #hashtag
        json.hashtags[i].hashtag = json.hashtags[i].text;
      }
    }

    if (json.symbols) {
      for (var i = 0; i < json.symbols.length; i++) {
        // this is a $CASH tag
        json.symbols[i].cashtag = json.symbols[i].text;
      }
    }

    // concatenate all entities
    var entities = [];
    for (var key in json) {
      entities = entities.concat(json[key]);
    }

    // modify indices to UTF-16
    twttr.txt.modifyIndicesFromUnicodeToUTF16(text, entities);

    return twttr.txt.autoLinkEntities(text, entities, options);
  };

  twttr.txt.extractHtmlAttrsFromOptions = function(options) {
    var htmlAttrs = {};
    for (var k in options) {
      var v = options[k];
      if (OPTIONS_NOT_ATTRIBUTES[k]) continue;
      if (BOOLEAN_ATTRIBUTES[k]) {
        v = v ? k : null;
      }
      if (v == null) continue;
      htmlAttrs[k] = v;
    }
    return htmlAttrs;
  };

  twttr.txt.autoLink = function(text, options) {
    var entities = twttr.txt.extractEntitiesWithIndices(text, {extractUrlsWithoutProtocol: false});
    return twttr.txt.autoLinkEntities(text, entities, options);
  };

  twttr.txt.autoLinkUsernamesOrLists = function(text, options) {
    var entities = twttr.txt.extractMentionsOrListsWithIndices(text);
    return twttr.txt.autoLinkEntities(text, entities, options);
  };

  twttr.txt.autoLinkHashtags = function(text, options) {
    var entities = twttr.txt.extractHashtagsWithIndices(text);
    return twttr.txt.autoLinkEntities(text, entities, options);
  };

  twttr.txt.autoLinkCashtags = function(text, options) {
    var entities = twttr.txt.extractCashtagsWithIndices(text);
    return twttr.txt.autoLinkEntities(text, entities, options);
  };

  twttr.txt.autoLinkUrlsCustom = function(text, options) {
    var entities = twttr.txt.extractUrlsWithIndices(text, {extractUrlsWithoutProtocol: false});
    return twttr.txt.autoLinkEntities(text, entities, options);
  };

  twttr.txt.removeOverlappingEntities = function(entities) {
    entities.sort(function(a,b){ return a.indices[0] - b.indices[0]; });

    var prev = entities[0];
    for (var i = 1; i < entities.length; i++) {
      if (prev.indices[1] > entities[i].indices[0]) {
        entities.splice(i, 1);
        i--;
      } else {
        prev = entities[i];
      }
    }
  };

  twttr.txt.extractEntitiesWithIndices = function(text, options) {
    var entities = twttr.txt.extractUrlsWithIndices(text, options)
                    .concat(twttr.txt.extractMentionsOrListsWithIndices(text))
                    .concat(twttr.txt.extractHashtagsWithIndices(text, {checkUrlOverlap: false}))
                    .concat(twttr.txt.extractCashtagsWithIndices(text));

    if (entities.length == 0) {
      return [];
    }

    twttr.txt.removeOverlappingEntities(entities);
    return entities;
  };

  twttr.txt.extractMentions = function(text) {
    var screenNamesOnly = [],
        screenNamesWithIndices = twttr.txt.extractMentionsWithIndices(text);

    for (var i = 0; i < screenNamesWithIndices.length; i++) {
      var screenName = screenNamesWithIndices[i].screenName;
      screenNamesOnly.push(screenName);
    }

    return screenNamesOnly;
  };

  twttr.txt.extractMentionsWithIndices = function(text) {
    var mentions = [],
        mentionOrList,
        mentionsOrLists = twttr.txt.extractMentionsOrListsWithIndices(text);

    for (var i = 0 ; i < mentionsOrLists.length; i++) {
      mentionOrList = mentionsOrLists[i];
      if (mentionOrList.listSlug == '') {
        mentions.push({
          screenName: mentionOrList.screenName,
          indices: mentionOrList.indices
        });
      }
    }

    return mentions;
  };

  /**
   * Extract list or user mentions.
   * (Presence of listSlug indicates a list)
   */
  twttr.txt.extractMentionsOrListsWithIndices = function(text) {
    if (!text || !text.match(twttr.txt.regexen.atSigns)) {
      return [];
    }

    var possibleNames = [],
        slashListname;

    text.replace(twttr.txt.regexen.validMentionOrList, function(match, before, atSign, screenName, slashListname, offset, chunk) {
      var after = chunk.slice(offset + match.length);
      if (!after.match(twttr.txt.regexen.endMentionMatch)) {
        slashListname = slashListname || '';
        var startPosition = offset + before.length;
        var endPosition = startPosition + screenName.length + slashListname.length + 1;
        possibleNames.push({
          screenName: screenName,
          listSlug: slashListname,
          indices: [startPosition, endPosition]
        });
      }
    });

    return possibleNames;
  };


  twttr.txt.extractReplies = function(text) {
    if (!text) {
      return null;
    }

    var possibleScreenName = text.match(twttr.txt.regexen.validReply);
    if (!possibleScreenName ||
        RegExp.rightContext.match(twttr.txt.regexen.endMentionMatch)) {
      return null;
    }

    return possibleScreenName[1];
  };

  twttr.txt.extractUrls = function(text, options) {
    var urlsOnly = [],
        urlsWithIndices = twttr.txt.extractUrlsWithIndices(text, options);

    for (var i = 0; i < urlsWithIndices.length; i++) {
      urlsOnly.push(urlsWithIndices[i].url);
    }

    return urlsOnly;
  };

  twttr.txt.extractUrlsWithIndices = function(text, options) {
    if (!options) {
      options = {extractUrlsWithoutProtocol: true};
    }
    if (!text || (options.extractUrlsWithoutProtocol ? !text.match(/\./) : !text.match(/:/))) {
      return [];
    }

    var urls = [];

    while (twttr.txt.regexen.extractUrl.exec(text)) {
      var before = RegExp.$2, url = RegExp.$3, protocol = RegExp.$4, domain = RegExp.$5, path = RegExp.$7;
      var endPosition = twttr.txt.regexen.extractUrl.lastIndex,
          startPosition = endPosition - url.length;

      // if protocol is missing and domain contains non-ASCII characters,
      // extract ASCII-only domains.
      if (!protocol) {
        if (!options.extractUrlsWithoutProtocol
            || before.match(twttr.txt.regexen.invalidUrlWithoutProtocolPrecedingChars)) {
          continue;
        }
        var lastUrl = null,
            asciiEndPosition = 0;
        domain.replace(twttr.txt.regexen.validAsciiDomain, function(asciiDomain) {
          var asciiStartPosition = domain.indexOf(asciiDomain, asciiEndPosition);
          asciiEndPosition = asciiStartPosition + asciiDomain.length;
          lastUrl = {
            url: asciiDomain,
            indices: [startPosition + asciiStartPosition, startPosition + asciiEndPosition]
          };
          if (path
              || asciiDomain.match(twttr.txt.regexen.validSpecialShortDomain)
              || !asciiDomain.match(twttr.txt.regexen.invalidShortDomain)) {
            urls.push(lastUrl);
          }
        });

        // no ASCII-only domain found. Skip the entire URL.
        if (lastUrl == null) {
          continue;
        }

        // lastUrl only contains domain. Need to add path and query if they exist.
        if (path) {
          lastUrl.url = url.replace(domain, lastUrl.url);
          lastUrl.indices[1] = endPosition;
        }
      } else {
        // In the case of t.co URLs, don't allow additional path characters.
        if (url.match(twttr.txt.regexen.validTcoUrl)) {
          url = RegExp.lastMatch;
          endPosition = startPosition + url.length;
        }
        urls.push({
          url: url,
          indices: [startPosition, endPosition]
        });
      }
    }

    return urls;
  };

  twttr.txt.extractHashtags = function(text) {
    var hashtagsOnly = [],
        hashtagsWithIndices = twttr.txt.extractHashtagsWithIndices(text);

    for (var i = 0; i < hashtagsWithIndices.length; i++) {
      hashtagsOnly.push(hashtagsWithIndices[i].hashtag);
    }

    return hashtagsOnly;
  };

  twttr.txt.extractHashtagsWithIndices = function(text, options) {
    if (!options) {
      options = {checkUrlOverlap: true};
    }

    if (!text || !text.match(twttr.txt.regexen.hashSigns)) {
      return [];
    }

    var tags = [];

    text.replace(twttr.txt.regexen.validHashtag, function(match, before, hash, hashText, offset, chunk) {
      var after = chunk.slice(offset + match.length);
      if (after.match(twttr.txt.regexen.endHashtagMatch))
        return;
      var startPosition = offset + before.length;
      var endPosition = startPosition + hashText.length + 1;
      tags.push({
        hashtag: hashText,
        indices: [startPosition, endPosition]
      });
    });

    if (options.checkUrlOverlap) {
      // also extract URL entities
      var urls = twttr.txt.extractUrlsWithIndices(text);
      if (urls.length > 0) {
        var entities = tags.concat(urls);
        // remove overlap
        twttr.txt.removeOverlappingEntities(entities);
        // only push back hashtags
        tags = [];
        for (var i = 0; i < entities.length; i++) {
          if (entities[i].hashtag) {
            tags.push(entities[i]);
          }
        }
      }
    }

    return tags;
  };

  twttr.txt.extractCashtags = function(text) {
    var cashtagsOnly = [],
        cashtagsWithIndices = twttr.txt.extractCashtagsWithIndices(text);

    for (var i = 0; i < cashtagsWithIndices.length; i++) {
      cashtagsOnly.push(cashtagsWithIndices[i].cashtag);
    }

    return cashtagsOnly;
  };

  twttr.txt.extractCashtagsWithIndices = function(text) {
    if (!text || text.indexOf("$") == -1) {
      return [];
    }

    var tags = [];

    text.replace(twttr.txt.regexen.validCashtag, function(match, before, dollar, cashtag, offset, chunk) {
      var startPosition = offset + before.length;
      var endPosition = startPosition + cashtag.length + 1;
      tags.push({
        cashtag: cashtag,
        indices: [startPosition, endPosition]
      });
    });

    return tags;
  };

  twttr.txt.modifyIndicesFromUnicodeToUTF16 = function(text, entities) {
    twttr.txt.convertUnicodeIndices(text, entities, false);
  };

  twttr.txt.modifyIndicesFromUTF16ToUnicode = function(text, entities) {
    twttr.txt.convertUnicodeIndices(text, entities, true);
  };

  twttr.txt.getUnicodeTextLength = function(text) {
    return text.replace(twttr.txt.regexen.non_bmp_code_pairs, ' ').length;
  };

  twttr.txt.convertUnicodeIndices = function(text, entities, indicesInUTF16) {
    if (entities.length == 0) {
      return;
    }

    var charIndex = 0;
    var codePointIndex = 0;

    // sort entities by start index
    entities.sort(function(a,b){ return a.indices[0] - b.indices[0]; });
    var entityIndex = 0;
    var entity = entities[0];

    while (charIndex < text.length) {
      if (entity.indices[0] == (indicesInUTF16 ? charIndex : codePointIndex)) {
        var len = entity.indices[1] - entity.indices[0];
        entity.indices[0] = indicesInUTF16 ? codePointIndex : charIndex;
        entity.indices[1] = entity.indices[0] + len;

        entityIndex++;
        if (entityIndex == entities.length) {
          // no more entity
          break;
        }
        entity = entities[entityIndex];
      }

      var c = text.charCodeAt(charIndex);
      if (0xD800 <= c && c <= 0xDBFF && charIndex < text.length - 1) {
        // Found high surrogate char
        c = text.charCodeAt(charIndex + 1);
        if (0xDC00 <= c && c <= 0xDFFF) {
          // Found surrogate pair
          charIndex++;
        }
      }
      codePointIndex++;
      charIndex++;
    }
  };

  // this essentially does text.split(/<|>/)
  // except that won't work in IE, where empty strings are ommitted
  // so "<>".split(/<|>/) => [] in IE, but is ["", "", ""] in all others
  // but "<<".split("<") => ["", "", ""]
  twttr.txt.splitTags = function(text) {
    var firstSplits = text.split("<"),
        secondSplits,
        allSplits = [],
        split;

    for (var i = 0; i < firstSplits.length; i += 1) {
      split = firstSplits[i];
      if (!split) {
        allSplits.push("");
      } else {
        secondSplits = split.split(">");
        for (var j = 0; j < secondSplits.length; j += 1) {
          allSplits.push(secondSplits[j]);
        }
      }
    }

    return allSplits;
  };

  twttr.txt.hitHighlight = function(text, hits, options) {
    var defaultHighlightTag = "em";

    hits = hits || [];
    options = options || {};

    if (hits.length === 0) {
      return text;
    }

    var tagName = options.tag || defaultHighlightTag,
        tags = ["<" + tagName + ">", "</" + tagName + ">"],
        chunks = twttr.txt.splitTags(text),
        i,
        j,
        result = "",
        chunkIndex = 0,
        chunk = chunks[0],
        prevChunksLen = 0,
        chunkCursor = 0,
        startInChunk = false,
        chunkChars = chunk,
        flatHits = [],
        index,
        hit,
        tag,
        placed,
        hitSpot;

    for (i = 0; i < hits.length; i += 1) {
      for (j = 0; j < hits[i].length; j += 1) {
        flatHits.push(hits[i][j]);
      }
    }

    for (index = 0; index < flatHits.length; index += 1) {
      hit = flatHits[index];
      tag = tags[index % 2];
      placed = false;

      while (chunk != null && hit >= prevChunksLen + chunk.length) {
        result += chunkChars.slice(chunkCursor);
        if (startInChunk && hit === prevChunksLen + chunkChars.length) {
          result += tag;
          placed = true;
        }

        if (chunks[chunkIndex + 1]) {
          result += "<" + chunks[chunkIndex + 1] + ">";
        }

        prevChunksLen += chunkChars.length;
        chunkCursor = 0;
        chunkIndex += 2;
        chunk = chunks[chunkIndex];
        chunkChars = chunk;
        startInChunk = false;
      }

      if (!placed && chunk != null) {
        hitSpot = hit - prevChunksLen;
        result += chunkChars.slice(chunkCursor, hitSpot) + tag;
        chunkCursor = hitSpot;
        if (index % 2 === 0) {
          startInChunk = true;
        } else {
          startInChunk = false;
        }
      } else if(!placed) {
        placed = true;
        result += tag;
      }
    }

    if (chunk != null) {
      if (chunkCursor < chunkChars.length) {
        result += chunkChars.slice(chunkCursor);
      }
      for (index = chunkIndex + 1; index < chunks.length; index += 1) {
        result += (index % 2 === 0 ? chunks[index] : "<" + chunks[index] + ">");
      }
    }

    return result;
  };

  var MAX_LENGTH = 140;

  // Characters not allowed in Tweets
  var INVALID_CHARACTERS = [
    // BOM
    fromCode(0xFFFE),
    fromCode(0xFEFF),

    // Special
    fromCode(0xFFFF),

    // Directional Change
    fromCode(0x202A),
    fromCode(0x202B),
    fromCode(0x202C),
    fromCode(0x202D),
    fromCode(0x202E)
  ];

  // Returns the length of Tweet text with consideration to t.co URL replacement
  // and chars outside the basic multilingual plane that use 2 UTF16 code points
  twttr.txt.getTweetLength = function(text, options) {
    if (!options) {
      options = {
          // These come from https://api.twitter.com/1/help/configuration.json
          // described by https://dev.twitter.com/docs/api/1/get/help/configuration
          short_url_length: 23,
          short_url_length_https: 23
      };
    }
    var textLength = twttr.txt.getUnicodeTextLength(text),
        urlsWithIndices = twttr.txt.extractUrlsWithIndices(text);
    twttr.txt.modifyIndicesFromUTF16ToUnicode(text, urlsWithIndices);

    for (var i = 0; i < urlsWithIndices.length; i++) {
    	// Subtract the length of the original URL
      textLength += urlsWithIndices[i].indices[0] - urlsWithIndices[i].indices[1];

      // Add 23 characters for URL starting with https://
      // http:// URLs still use https://t.co so they are 23 characters as well
      if (urlsWithIndices[i].url.toLowerCase().match(twttr.txt.regexen.urlHasHttps)) {
         textLength += options.short_url_length_https;
      } else {
        textLength += options.short_url_length;
      }
    }

    return textLength;
  };

  // Check the text for any reason that it may not be valid as a Tweet. This is meant as a pre-validation
  // before posting to api.twitter.com. There are several server-side reasons for Tweets to fail but this pre-validation
  // will allow quicker feedback.
  //
  // Returns false if this text is valid. Otherwise one of the following strings will be returned:
  //
  //   "too_long": if the text is too long
  //   "empty": if the text is nil or empty
  //   "invalid_characters": if the text contains non-Unicode or any of the disallowed Unicode characters
  twttr.txt.isInvalidTweet = function(text) {
    if (!text) {
      return "empty";
    }

    // Determine max length independent of URL length
    if (twttr.txt.getTweetLength(text) > MAX_LENGTH) {
      return "too_long";
    }

    if (twttr.txt.hasInvalidCharacters(text)) {
      return "invalid_characters";
    }

    return false;
  };

  twttr.txt.hasInvalidCharacters = function(text) {
    for (var i = 0; i < INVALID_CHARACTERS.length; i++) {
      if (text.indexOf(INVALID_CHARACTERS[i]) >= 0) {
        return true;
      }
    }
    return false;
  };

  twttr.txt.isValidTweetText = function(text) {
    return !twttr.txt.isInvalidTweet(text);
  };

  twttr.txt.isValidUsername = function(username) {
    if (!username) {
      return false;
    }

    var extracted = twttr.txt.extractMentions(username);

    // Should extract the username minus the @ sign, hence the .slice(1)
    return extracted.length === 1 && extracted[0] === username.slice(1);
  };

  var VALID_LIST_RE = regexSupplant(/^#{validMentionOrList}$/);

  twttr.txt.isValidList = function(usernameList) {
    var match = usernameList.match(VALID_LIST_RE);

    // Must have matched and had nothing before or after
    return !!(match && match[1] == "" && match[4]);
  };

  twttr.txt.isValidHashtag = function(hashtag) {
    if (!hashtag) {
      return false;
    }

    var extracted = twttr.txt.extractHashtags(hashtag);

    // Should extract the hashtag minus the # sign, hence the .slice(1)
    return extracted.length === 1 && extracted[0] === hashtag.slice(1);
  };

  twttr.txt.isValidUrl = function(url, unicodeDomains, requireProtocol) {
    if (unicodeDomains == null) {
      unicodeDomains = true;
    }

    if (requireProtocol == null) {
      requireProtocol = true;
    }

    if (!url) {
      return false;
    }

    var urlParts = url.match(twttr.txt.regexen.validateUrlUnencoded);

    if (!urlParts || urlParts[0] !== url) {
      return false;
    }

    var scheme = urlParts[1],
        authority = urlParts[2],
        path = urlParts[3],
        query = urlParts[4],
        fragment = urlParts[5];

    if (!(
      (!requireProtocol || (isValidMatch(scheme, twttr.txt.regexen.validateUrlScheme) && scheme.match(/^https?$/i))) &&
      isValidMatch(path, twttr.txt.regexen.validateUrlPath) &&
      isValidMatch(query, twttr.txt.regexen.validateUrlQuery, true) &&
      isValidMatch(fragment, twttr.txt.regexen.validateUrlFragment, true)
    )) {
      return false;
    }

    return (unicodeDomains && isValidMatch(authority, twttr.txt.regexen.validateUrlUnicodeAuthority)) ||
           (!unicodeDomains && isValidMatch(authority, twttr.txt.regexen.validateUrlAuthority));
  };

  function isValidMatch(string, regex, optional) {
    if (!optional) {
      // RegExp["$&"] is the text of the last match
      // blank strings are ok, but are falsy, so we check stringiness instead of truthiness
      return ((typeof string === "string") && string.match(regex) && RegExp["$&"] === string);
    }

    // RegExp["$&"] is the text of the last match
    return (!string || (string.match(regex) && RegExp["$&"] === string));
  }

  if (typeof module != 'undefined' && module.exports) {
    module.exports = twttr.txt;
  }

  if (typeof define == 'function' && define.amd) {
    define([], twttr.txt);
  }

  if (typeof window != 'undefined') {
    if (window.twttr) {
      for (var prop in twttr) {
        window.twttr[prop] = twttr[prop];
      }
    } else {
      window.twttr = twttr;
    }
  }
})();

},{}],4:[function(require,module,exports){
//     Underscore.js 1.8.3
//     http://underscorejs.org
//     (c) 2009-2015 Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
//     Underscore may be freely distributed under the MIT license.

(function() {

  // Baseline setup
  // --------------

  // Establish the root object, `window` in the browser, or `exports` on the server.
  var root = this;

  // Save the previous value of the `_` variable.
  var previousUnderscore = root._;

  // Save bytes in the minified (but not gzipped) version:
  var ArrayProto = Array.prototype, ObjProto = Object.prototype, FuncProto = Function.prototype;

  // Create quick reference variables for speed access to core prototypes.
  var
    push             = ArrayProto.push,
    slice            = ArrayProto.slice,
    toString         = ObjProto.toString,
    hasOwnProperty   = ObjProto.hasOwnProperty;

  // All **ECMAScript 5** native function implementations that we hope to use
  // are declared here.
  var
    nativeIsArray      = Array.isArray,
    nativeKeys         = Object.keys,
    nativeBind         = FuncProto.bind,
    nativeCreate       = Object.create;

  // Naked function reference for surrogate-prototype-swapping.
  var Ctor = function(){};

  // Create a safe reference to the Underscore object for use below.
  var _ = function(obj) {
    if (obj instanceof _) return obj;
    if (!(this instanceof _)) return new _(obj);
    this._wrapped = obj;
  };

  // Export the Underscore object for **Node.js**, with
  // backwards-compatibility for the old `require()` API. If we're in
  // the browser, add `_` as a global object.
  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = _;
    }
    exports._ = _;
  } else {
    root._ = _;
  }

  // Current version.
  _.VERSION = '1.8.3';

  // Internal function that returns an efficient (for current engines) version
  // of the passed-in callback, to be repeatedly applied in other Underscore
  // functions.
  var optimizeCb = function(func, context, argCount) {
    if (context === void 0) return func;
    switch (argCount == null ? 3 : argCount) {
      case 1: return function(value) {
        return func.call(context, value);
      };
      case 2: return function(value, other) {
        return func.call(context, value, other);
      };
      case 3: return function(value, index, collection) {
        return func.call(context, value, index, collection);
      };
      case 4: return function(accumulator, value, index, collection) {
        return func.call(context, accumulator, value, index, collection);
      };
    }
    return function() {
      return func.apply(context, arguments);
    };
  };

  // A mostly-internal function to generate callbacks that can be applied
  // to each element in a collection, returning the desired result — either
  // identity, an arbitrary callback, a property matcher, or a property accessor.
  var cb = function(value, context, argCount) {
    if (value == null) return _.identity;
    if (_.isFunction(value)) return optimizeCb(value, context, argCount);
    if (_.isObject(value)) return _.matcher(value);
    return _.property(value);
  };
  _.iteratee = function(value, context) {
    return cb(value, context, Infinity);
  };

  // An internal function for creating assigner functions.
  var createAssigner = function(keysFunc, undefinedOnly) {
    return function(obj) {
      var length = arguments.length;
      if (length < 2 || obj == null) return obj;
      for (var index = 1; index < length; index++) {
        var source = arguments[index],
            keys = keysFunc(source),
            l = keys.length;
        for (var i = 0; i < l; i++) {
          var key = keys[i];
          if (!undefinedOnly || obj[key] === void 0) obj[key] = source[key];
        }
      }
      return obj;
    };
  };

  // An internal function for creating a new object that inherits from another.
  var baseCreate = function(prototype) {
    if (!_.isObject(prototype)) return {};
    if (nativeCreate) return nativeCreate(prototype);
    Ctor.prototype = prototype;
    var result = new Ctor;
    Ctor.prototype = null;
    return result;
  };

  var property = function(key) {
    return function(obj) {
      return obj == null ? void 0 : obj[key];
    };
  };

  // Helper for collection methods to determine whether a collection
  // should be iterated as an array or as an object
  // Related: http://people.mozilla.org/~jorendorff/es6-draft.html#sec-tolength
  // Avoids a very nasty iOS 8 JIT bug on ARM-64. #2094
  var MAX_ARRAY_INDEX = Math.pow(2, 53) - 1;
  var getLength = property('length');
  var isArrayLike = function(collection) {
    var length = getLength(collection);
    return typeof length == 'number' && length >= 0 && length <= MAX_ARRAY_INDEX;
  };

  // Collection Functions
  // --------------------

  // The cornerstone, an `each` implementation, aka `forEach`.
  // Handles raw objects in addition to array-likes. Treats all
  // sparse array-likes as if they were dense.
  _.each = _.forEach = function(obj, iteratee, context) {
    iteratee = optimizeCb(iteratee, context);
    var i, length;
    if (isArrayLike(obj)) {
      for (i = 0, length = obj.length; i < length; i++) {
        iteratee(obj[i], i, obj);
      }
    } else {
      var keys = _.keys(obj);
      for (i = 0, length = keys.length; i < length; i++) {
        iteratee(obj[keys[i]], keys[i], obj);
      }
    }
    return obj;
  };

  // Return the results of applying the iteratee to each element.
  _.map = _.collect = function(obj, iteratee, context) {
    iteratee = cb(iteratee, context);
    var keys = !isArrayLike(obj) && _.keys(obj),
        length = (keys || obj).length,
        results = Array(length);
    for (var index = 0; index < length; index++) {
      var currentKey = keys ? keys[index] : index;
      results[index] = iteratee(obj[currentKey], currentKey, obj);
    }
    return results;
  };

  // Create a reducing function iterating left or right.
  function createReduce(dir) {
    // Optimized iterator function as using arguments.length
    // in the main function will deoptimize the, see #1991.
    function iterator(obj, iteratee, memo, keys, index, length) {
      for (; index >= 0 && index < length; index += dir) {
        var currentKey = keys ? keys[index] : index;
        memo = iteratee(memo, obj[currentKey], currentKey, obj);
      }
      return memo;
    }

    return function(obj, iteratee, memo, context) {
      iteratee = optimizeCb(iteratee, context, 4);
      var keys = !isArrayLike(obj) && _.keys(obj),
          length = (keys || obj).length,
          index = dir > 0 ? 0 : length - 1;
      // Determine the initial value if none is provided.
      if (arguments.length < 3) {
        memo = obj[keys ? keys[index] : index];
        index += dir;
      }
      return iterator(obj, iteratee, memo, keys, index, length);
    };
  }

  // **Reduce** builds up a single result from a list of values, aka `inject`,
  // or `foldl`.
  _.reduce = _.foldl = _.inject = createReduce(1);

  // The right-associative version of reduce, also known as `foldr`.
  _.reduceRight = _.foldr = createReduce(-1);

  // Return the first value which passes a truth test. Aliased as `detect`.
  _.find = _.detect = function(obj, predicate, context) {
    var key;
    if (isArrayLike(obj)) {
      key = _.findIndex(obj, predicate, context);
    } else {
      key = _.findKey(obj, predicate, context);
    }
    if (key !== void 0 && key !== -1) return obj[key];
  };

  // Return all the elements that pass a truth test.
  // Aliased as `select`.
  _.filter = _.select = function(obj, predicate, context) {
    var results = [];
    predicate = cb(predicate, context);
    _.each(obj, function(value, index, list) {
      if (predicate(value, index, list)) results.push(value);
    });
    return results;
  };

  // Return all the elements for which a truth test fails.
  _.reject = function(obj, predicate, context) {
    return _.filter(obj, _.negate(cb(predicate)), context);
  };

  // Determine whether all of the elements match a truth test.
  // Aliased as `all`.
  _.every = _.all = function(obj, predicate, context) {
    predicate = cb(predicate, context);
    var keys = !isArrayLike(obj) && _.keys(obj),
        length = (keys || obj).length;
    for (var index = 0; index < length; index++) {
      var currentKey = keys ? keys[index] : index;
      if (!predicate(obj[currentKey], currentKey, obj)) return false;
    }
    return true;
  };

  // Determine if at least one element in the object matches a truth test.
  // Aliased as `any`.
  _.some = _.any = function(obj, predicate, context) {
    predicate = cb(predicate, context);
    var keys = !isArrayLike(obj) && _.keys(obj),
        length = (keys || obj).length;
    for (var index = 0; index < length; index++) {
      var currentKey = keys ? keys[index] : index;
      if (predicate(obj[currentKey], currentKey, obj)) return true;
    }
    return false;
  };

  // Determine if the array or object contains a given item (using `===`).
  // Aliased as `includes` and `include`.
  _.contains = _.includes = _.include = function(obj, item, fromIndex, guard) {
    if (!isArrayLike(obj)) obj = _.values(obj);
    if (typeof fromIndex != 'number' || guard) fromIndex = 0;
    return _.indexOf(obj, item, fromIndex) >= 0;
  };

  // Invoke a method (with arguments) on every item in a collection.
  _.invoke = function(obj, method) {
    var args = slice.call(arguments, 2);
    var isFunc = _.isFunction(method);
    return _.map(obj, function(value) {
      var func = isFunc ? method : value[method];
      return func == null ? func : func.apply(value, args);
    });
  };

  // Convenience version of a common use case of `map`: fetching a property.
  _.pluck = function(obj, key) {
    return _.map(obj, _.property(key));
  };

  // Convenience version of a common use case of `filter`: selecting only objects
  // containing specific `key:value` pairs.
  _.where = function(obj, attrs) {
    return _.filter(obj, _.matcher(attrs));
  };

  // Convenience version of a common use case of `find`: getting the first object
  // containing specific `key:value` pairs.
  _.findWhere = function(obj, attrs) {
    return _.find(obj, _.matcher(attrs));
  };

  // Return the maximum element (or element-based computation).
  _.max = function(obj, iteratee, context) {
    var result = -Infinity, lastComputed = -Infinity,
        value, computed;
    if (iteratee == null && obj != null) {
      obj = isArrayLike(obj) ? obj : _.values(obj);
      for (var i = 0, length = obj.length; i < length; i++) {
        value = obj[i];
        if (value > result) {
          result = value;
        }
      }
    } else {
      iteratee = cb(iteratee, context);
      _.each(obj, function(value, index, list) {
        computed = iteratee(value, index, list);
        if (computed > lastComputed || computed === -Infinity && result === -Infinity) {
          result = value;
          lastComputed = computed;
        }
      });
    }
    return result;
  };

  // Return the minimum element (or element-based computation).
  _.min = function(obj, iteratee, context) {
    var result = Infinity, lastComputed = Infinity,
        value, computed;
    if (iteratee == null && obj != null) {
      obj = isArrayLike(obj) ? obj : _.values(obj);
      for (var i = 0, length = obj.length; i < length; i++) {
        value = obj[i];
        if (value < result) {
          result = value;
        }
      }
    } else {
      iteratee = cb(iteratee, context);
      _.each(obj, function(value, index, list) {
        computed = iteratee(value, index, list);
        if (computed < lastComputed || computed === Infinity && result === Infinity) {
          result = value;
          lastComputed = computed;
        }
      });
    }
    return result;
  };

  // Shuffle a collection, using the modern version of the
  // [Fisher-Yates shuffle](http://en.wikipedia.org/wiki/Fisher–Yates_shuffle).
  _.shuffle = function(obj) {
    var set = isArrayLike(obj) ? obj : _.values(obj);
    var length = set.length;
    var shuffled = Array(length);
    for (var index = 0, rand; index < length; index++) {
      rand = _.random(0, index);
      if (rand !== index) shuffled[index] = shuffled[rand];
      shuffled[rand] = set[index];
    }
    return shuffled;
  };

  // Sample **n** random values from a collection.
  // If **n** is not specified, returns a single random element.
  // The internal `guard` argument allows it to work with `map`.
  _.sample = function(obj, n, guard) {
    if (n == null || guard) {
      if (!isArrayLike(obj)) obj = _.values(obj);
      return obj[_.random(obj.length - 1)];
    }
    return _.shuffle(obj).slice(0, Math.max(0, n));
  };

  // Sort the object's values by a criterion produced by an iteratee.
  _.sortBy = function(obj, iteratee, context) {
    iteratee = cb(iteratee, context);
    return _.pluck(_.map(obj, function(value, index, list) {
      return {
        value: value,
        index: index,
        criteria: iteratee(value, index, list)
      };
    }).sort(function(left, right) {
      var a = left.criteria;
      var b = right.criteria;
      if (a !== b) {
        if (a > b || a === void 0) return 1;
        if (a < b || b === void 0) return -1;
      }
      return left.index - right.index;
    }), 'value');
  };

  // An internal function used for aggregate "group by" operations.
  var group = function(behavior) {
    return function(obj, iteratee, context) {
      var result = {};
      iteratee = cb(iteratee, context);
      _.each(obj, function(value, index) {
        var key = iteratee(value, index, obj);
        behavior(result, value, key);
      });
      return result;
    };
  };

  // Groups the object's values by a criterion. Pass either a string attribute
  // to group by, or a function that returns the criterion.
  _.groupBy = group(function(result, value, key) {
    if (_.has(result, key)) result[key].push(value); else result[key] = [value];
  });

  // Indexes the object's values by a criterion, similar to `groupBy`, but for
  // when you know that your index values will be unique.
  _.indexBy = group(function(result, value, key) {
    result[key] = value;
  });

  // Counts instances of an object that group by a certain criterion. Pass
  // either a string attribute to count by, or a function that returns the
  // criterion.
  _.countBy = group(function(result, value, key) {
    if (_.has(result, key)) result[key]++; else result[key] = 1;
  });

  // Safely create a real, live array from anything iterable.
  _.toArray = function(obj) {
    if (!obj) return [];
    if (_.isArray(obj)) return slice.call(obj);
    if (isArrayLike(obj)) return _.map(obj, _.identity);
    return _.values(obj);
  };

  // Return the number of elements in an object.
  _.size = function(obj) {
    if (obj == null) return 0;
    return isArrayLike(obj) ? obj.length : _.keys(obj).length;
  };

  // Split a collection into two arrays: one whose elements all satisfy the given
  // predicate, and one whose elements all do not satisfy the predicate.
  _.partition = function(obj, predicate, context) {
    predicate = cb(predicate, context);
    var pass = [], fail = [];
    _.each(obj, function(value, key, obj) {
      (predicate(value, key, obj) ? pass : fail).push(value);
    });
    return [pass, fail];
  };

  // Array Functions
  // ---------------

  // Get the first element of an array. Passing **n** will return the first N
  // values in the array. Aliased as `head` and `take`. The **guard** check
  // allows it to work with `_.map`.
  _.first = _.head = _.take = function(array, n, guard) {
    if (array == null) return void 0;
    if (n == null || guard) return array[0];
    return _.initial(array, array.length - n);
  };

  // Returns everything but the last entry of the array. Especially useful on
  // the arguments object. Passing **n** will return all the values in
  // the array, excluding the last N.
  _.initial = function(array, n, guard) {
    return slice.call(array, 0, Math.max(0, array.length - (n == null || guard ? 1 : n)));
  };

  // Get the last element of an array. Passing **n** will return the last N
  // values in the array.
  _.last = function(array, n, guard) {
    if (array == null) return void 0;
    if (n == null || guard) return array[array.length - 1];
    return _.rest(array, Math.max(0, array.length - n));
  };

  // Returns everything but the first entry of the array. Aliased as `tail` and `drop`.
  // Especially useful on the arguments object. Passing an **n** will return
  // the rest N values in the array.
  _.rest = _.tail = _.drop = function(array, n, guard) {
    return slice.call(array, n == null || guard ? 1 : n);
  };

  // Trim out all falsy values from an array.
  _.compact = function(array) {
    return _.filter(array, _.identity);
  };

  // Internal implementation of a recursive `flatten` function.
  var flatten = function(input, shallow, strict, startIndex) {
    var output = [], idx = 0;
    for (var i = startIndex || 0, length = getLength(input); i < length; i++) {
      var value = input[i];
      if (isArrayLike(value) && (_.isArray(value) || _.isArguments(value))) {
        //flatten current level of array or arguments object
        if (!shallow) value = flatten(value, shallow, strict);
        var j = 0, len = value.length;
        output.length += len;
        while (j < len) {
          output[idx++] = value[j++];
        }
      } else if (!strict) {
        output[idx++] = value;
      }
    }
    return output;
  };

  // Flatten out an array, either recursively (by default), or just one level.
  _.flatten = function(array, shallow) {
    return flatten(array, shallow, false);
  };

  // Return a version of the array that does not contain the specified value(s).
  _.without = function(array) {
    return _.difference(array, slice.call(arguments, 1));
  };

  // Produce a duplicate-free version of the array. If the array has already
  // been sorted, you have the option of using a faster algorithm.
  // Aliased as `unique`.
  _.uniq = _.unique = function(array, isSorted, iteratee, context) {
    if (!_.isBoolean(isSorted)) {
      context = iteratee;
      iteratee = isSorted;
      isSorted = false;
    }
    if (iteratee != null) iteratee = cb(iteratee, context);
    var result = [];
    var seen = [];
    for (var i = 0, length = getLength(array); i < length; i++) {
      var value = array[i],
          computed = iteratee ? iteratee(value, i, array) : value;
      if (isSorted) {
        if (!i || seen !== computed) result.push(value);
        seen = computed;
      } else if (iteratee) {
        if (!_.contains(seen, computed)) {
          seen.push(computed);
          result.push(value);
        }
      } else if (!_.contains(result, value)) {
        result.push(value);
      }
    }
    return result;
  };

  // Produce an array that contains the union: each distinct element from all of
  // the passed-in arrays.
  _.union = function() {
    return _.uniq(flatten(arguments, true, true));
  };

  // Produce an array that contains every item shared between all the
  // passed-in arrays.
  _.intersection = function(array) {
    var result = [];
    var argsLength = arguments.length;
    for (var i = 0, length = getLength(array); i < length; i++) {
      var item = array[i];
      if (_.contains(result, item)) continue;
      for (var j = 1; j < argsLength; j++) {
        if (!_.contains(arguments[j], item)) break;
      }
      if (j === argsLength) result.push(item);
    }
    return result;
  };

  // Take the difference between one array and a number of other arrays.
  // Only the elements present in just the first array will remain.
  _.difference = function(array) {
    var rest = flatten(arguments, true, true, 1);
    return _.filter(array, function(value){
      return !_.contains(rest, value);
    });
  };

  // Zip together multiple lists into a single array -- elements that share
  // an index go together.
  _.zip = function() {
    return _.unzip(arguments);
  };

  // Complement of _.zip. Unzip accepts an array of arrays and groups
  // each array's elements on shared indices
  _.unzip = function(array) {
    var length = array && _.max(array, getLength).length || 0;
    var result = Array(length);

    for (var index = 0; index < length; index++) {
      result[index] = _.pluck(array, index);
    }
    return result;
  };

  // Converts lists into objects. Pass either a single array of `[key, value]`
  // pairs, or two parallel arrays of the same length -- one of keys, and one of
  // the corresponding values.
  _.object = function(list, values) {
    var result = {};
    for (var i = 0, length = getLength(list); i < length; i++) {
      if (values) {
        result[list[i]] = values[i];
      } else {
        result[list[i][0]] = list[i][1];
      }
    }
    return result;
  };

  // Generator function to create the findIndex and findLastIndex functions
  function createPredicateIndexFinder(dir) {
    return function(array, predicate, context) {
      predicate = cb(predicate, context);
      var length = getLength(array);
      var index = dir > 0 ? 0 : length - 1;
      for (; index >= 0 && index < length; index += dir) {
        if (predicate(array[index], index, array)) return index;
      }
      return -1;
    };
  }

  // Returns the first index on an array-like that passes a predicate test
  _.findIndex = createPredicateIndexFinder(1);
  _.findLastIndex = createPredicateIndexFinder(-1);

  // Use a comparator function to figure out the smallest index at which
  // an object should be inserted so as to maintain order. Uses binary search.
  _.sortedIndex = function(array, obj, iteratee, context) {
    iteratee = cb(iteratee, context, 1);
    var value = iteratee(obj);
    var low = 0, high = getLength(array);
    while (low < high) {
      var mid = Math.floor((low + high) / 2);
      if (iteratee(array[mid]) < value) low = mid + 1; else high = mid;
    }
    return low;
  };

  // Generator function to create the indexOf and lastIndexOf functions
  function createIndexFinder(dir, predicateFind, sortedIndex) {
    return function(array, item, idx) {
      var i = 0, length = getLength(array);
      if (typeof idx == 'number') {
        if (dir > 0) {
            i = idx >= 0 ? idx : Math.max(idx + length, i);
        } else {
            length = idx >= 0 ? Math.min(idx + 1, length) : idx + length + 1;
        }
      } else if (sortedIndex && idx && length) {
        idx = sortedIndex(array, item);
        return array[idx] === item ? idx : -1;
      }
      if (item !== item) {
        idx = predicateFind(slice.call(array, i, length), _.isNaN);
        return idx >= 0 ? idx + i : -1;
      }
      for (idx = dir > 0 ? i : length - 1; idx >= 0 && idx < length; idx += dir) {
        if (array[idx] === item) return idx;
      }
      return -1;
    };
  }

  // Return the position of the first occurrence of an item in an array,
  // or -1 if the item is not included in the array.
  // If the array is large and already in sort order, pass `true`
  // for **isSorted** to use binary search.
  _.indexOf = createIndexFinder(1, _.findIndex, _.sortedIndex);
  _.lastIndexOf = createIndexFinder(-1, _.findLastIndex);

  // Generate an integer Array containing an arithmetic progression. A port of
  // the native Python `range()` function. See
  // [the Python documentation](http://docs.python.org/library/functions.html#range).
  _.range = function(start, stop, step) {
    if (stop == null) {
      stop = start || 0;
      start = 0;
    }
    step = step || 1;

    var length = Math.max(Math.ceil((stop - start) / step), 0);
    var range = Array(length);

    for (var idx = 0; idx < length; idx++, start += step) {
      range[idx] = start;
    }

    return range;
  };

  // Function (ahem) Functions
  // ------------------

  // Determines whether to execute a function as a constructor
  // or a normal function with the provided arguments
  var executeBound = function(sourceFunc, boundFunc, context, callingContext, args) {
    if (!(callingContext instanceof boundFunc)) return sourceFunc.apply(context, args);
    var self = baseCreate(sourceFunc.prototype);
    var result = sourceFunc.apply(self, args);
    if (_.isObject(result)) return result;
    return self;
  };

  // Create a function bound to a given object (assigning `this`, and arguments,
  // optionally). Delegates to **ECMAScript 5**'s native `Function.bind` if
  // available.
  _.bind = function(func, context) {
    if (nativeBind && func.bind === nativeBind) return nativeBind.apply(func, slice.call(arguments, 1));
    if (!_.isFunction(func)) throw new TypeError('Bind must be called on a function');
    var args = slice.call(arguments, 2);
    var bound = function() {
      return executeBound(func, bound, context, this, args.concat(slice.call(arguments)));
    };
    return bound;
  };

  // Partially apply a function by creating a version that has had some of its
  // arguments pre-filled, without changing its dynamic `this` context. _ acts
  // as a placeholder, allowing any combination of arguments to be pre-filled.
  _.partial = function(func) {
    var boundArgs = slice.call(arguments, 1);
    var bound = function() {
      var position = 0, length = boundArgs.length;
      var args = Array(length);
      for (var i = 0; i < length; i++) {
        args[i] = boundArgs[i] === _ ? arguments[position++] : boundArgs[i];
      }
      while (position < arguments.length) args.push(arguments[position++]);
      return executeBound(func, bound, this, this, args);
    };
    return bound;
  };

  // Bind a number of an object's methods to that object. Remaining arguments
  // are the method names to be bound. Useful for ensuring that all callbacks
  // defined on an object belong to it.
  _.bindAll = function(obj) {
    var i, length = arguments.length, key;
    if (length <= 1) throw new Error('bindAll must be passed function names');
    for (i = 1; i < length; i++) {
      key = arguments[i];
      obj[key] = _.bind(obj[key], obj);
    }
    return obj;
  };

  // Memoize an expensive function by storing its results.
  _.memoize = function(func, hasher) {
    var memoize = function(key) {
      var cache = memoize.cache;
      var address = '' + (hasher ? hasher.apply(this, arguments) : key);
      if (!_.has(cache, address)) cache[address] = func.apply(this, arguments);
      return cache[address];
    };
    memoize.cache = {};
    return memoize;
  };

  // Delays a function for the given number of milliseconds, and then calls
  // it with the arguments supplied.
  _.delay = function(func, wait) {
    var args = slice.call(arguments, 2);
    return setTimeout(function(){
      return func.apply(null, args);
    }, wait);
  };

  // Defers a function, scheduling it to run after the current call stack has
  // cleared.
  _.defer = _.partial(_.delay, _, 1);

  // Returns a function, that, when invoked, will only be triggered at most once
  // during a given window of time. Normally, the throttled function will run
  // as much as it can, without ever going more than once per `wait` duration;
  // but if you'd like to disable the execution on the leading edge, pass
  // `{leading: false}`. To disable execution on the trailing edge, ditto.
  _.throttle = function(func, wait, options) {
    var context, args, result;
    var timeout = null;
    var previous = 0;
    if (!options) options = {};
    var later = function() {
      previous = options.leading === false ? 0 : _.now();
      timeout = null;
      result = func.apply(context, args);
      if (!timeout) context = args = null;
    };
    return function() {
      var now = _.now();
      if (!previous && options.leading === false) previous = now;
      var remaining = wait - (now - previous);
      context = this;
      args = arguments;
      if (remaining <= 0 || remaining > wait) {
        if (timeout) {
          clearTimeout(timeout);
          timeout = null;
        }
        previous = now;
        result = func.apply(context, args);
        if (!timeout) context = args = null;
      } else if (!timeout && options.trailing !== false) {
        timeout = setTimeout(later, remaining);
      }
      return result;
    };
  };

  // Returns a function, that, as long as it continues to be invoked, will not
  // be triggered. The function will be called after it stops being called for
  // N milliseconds. If `immediate` is passed, trigger the function on the
  // leading edge, instead of the trailing.
  _.debounce = function(func, wait, immediate) {
    var timeout, args, context, timestamp, result;

    var later = function() {
      var last = _.now() - timestamp;

      if (last < wait && last >= 0) {
        timeout = setTimeout(later, wait - last);
      } else {
        timeout = null;
        if (!immediate) {
          result = func.apply(context, args);
          if (!timeout) context = args = null;
        }
      }
    };

    return function() {
      context = this;
      args = arguments;
      timestamp = _.now();
      var callNow = immediate && !timeout;
      if (!timeout) timeout = setTimeout(later, wait);
      if (callNow) {
        result = func.apply(context, args);
        context = args = null;
      }

      return result;
    };
  };

  // Returns the first function passed as an argument to the second,
  // allowing you to adjust arguments, run code before and after, and
  // conditionally execute the original function.
  _.wrap = function(func, wrapper) {
    return _.partial(wrapper, func);
  };

  // Returns a negated version of the passed-in predicate.
  _.negate = function(predicate) {
    return function() {
      return !predicate.apply(this, arguments);
    };
  };

  // Returns a function that is the composition of a list of functions, each
  // consuming the return value of the function that follows.
  _.compose = function() {
    var args = arguments;
    var start = args.length - 1;
    return function() {
      var i = start;
      var result = args[start].apply(this, arguments);
      while (i--) result = args[i].call(this, result);
      return result;
    };
  };

  // Returns a function that will only be executed on and after the Nth call.
  _.after = function(times, func) {
    return function() {
      if (--times < 1) {
        return func.apply(this, arguments);
      }
    };
  };

  // Returns a function that will only be executed up to (but not including) the Nth call.
  _.before = function(times, func) {
    var memo;
    return function() {
      if (--times > 0) {
        memo = func.apply(this, arguments);
      }
      if (times <= 1) func = null;
      return memo;
    };
  };

  // Returns a function that will be executed at most one time, no matter how
  // often you call it. Useful for lazy initialization.
  _.once = _.partial(_.before, 2);

  // Object Functions
  // ----------------

  // Keys in IE < 9 that won't be iterated by `for key in ...` and thus missed.
  var hasEnumBug = !{toString: null}.propertyIsEnumerable('toString');
  var nonEnumerableProps = ['valueOf', 'isPrototypeOf', 'toString',
                      'propertyIsEnumerable', 'hasOwnProperty', 'toLocaleString'];

  function collectNonEnumProps(obj, keys) {
    var nonEnumIdx = nonEnumerableProps.length;
    var constructor = obj.constructor;
    var proto = (_.isFunction(constructor) && constructor.prototype) || ObjProto;

    // Constructor is a special case.
    var prop = 'constructor';
    if (_.has(obj, prop) && !_.contains(keys, prop)) keys.push(prop);

    while (nonEnumIdx--) {
      prop = nonEnumerableProps[nonEnumIdx];
      if (prop in obj && obj[prop] !== proto[prop] && !_.contains(keys, prop)) {
        keys.push(prop);
      }
    }
  }

  // Retrieve the names of an object's own properties.
  // Delegates to **ECMAScript 5**'s native `Object.keys`
  _.keys = function(obj) {
    if (!_.isObject(obj)) return [];
    if (nativeKeys) return nativeKeys(obj);
    var keys = [];
    for (var key in obj) if (_.has(obj, key)) keys.push(key);
    // Ahem, IE < 9.
    if (hasEnumBug) collectNonEnumProps(obj, keys);
    return keys;
  };

  // Retrieve all the property names of an object.
  _.allKeys = function(obj) {
    if (!_.isObject(obj)) return [];
    var keys = [];
    for (var key in obj) keys.push(key);
    // Ahem, IE < 9.
    if (hasEnumBug) collectNonEnumProps(obj, keys);
    return keys;
  };

  // Retrieve the values of an object's properties.
  _.values = function(obj) {
    var keys = _.keys(obj);
    var length = keys.length;
    var values = Array(length);
    for (var i = 0; i < length; i++) {
      values[i] = obj[keys[i]];
    }
    return values;
  };

  // Returns the results of applying the iteratee to each element of the object
  // In contrast to _.map it returns an object
  _.mapObject = function(obj, iteratee, context) {
    iteratee = cb(iteratee, context);
    var keys =  _.keys(obj),
          length = keys.length,
          results = {},
          currentKey;
      for (var index = 0; index < length; index++) {
        currentKey = keys[index];
        results[currentKey] = iteratee(obj[currentKey], currentKey, obj);
      }
      return results;
  };

  // Convert an object into a list of `[key, value]` pairs.
  _.pairs = function(obj) {
    var keys = _.keys(obj);
    var length = keys.length;
    var pairs = Array(length);
    for (var i = 0; i < length; i++) {
      pairs[i] = [keys[i], obj[keys[i]]];
    }
    return pairs;
  };

  // Invert the keys and values of an object. The values must be serializable.
  _.invert = function(obj) {
    var result = {};
    var keys = _.keys(obj);
    for (var i = 0, length = keys.length; i < length; i++) {
      result[obj[keys[i]]] = keys[i];
    }
    return result;
  };

  // Return a sorted list of the function names available on the object.
  // Aliased as `methods`
  _.functions = _.methods = function(obj) {
    var names = [];
    for (var key in obj) {
      if (_.isFunction(obj[key])) names.push(key);
    }
    return names.sort();
  };

  // Extend a given object with all the properties in passed-in object(s).
  _.extend = createAssigner(_.allKeys);

  // Assigns a given object with all the own properties in the passed-in object(s)
  // (https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Object/assign)
  _.extendOwn = _.assign = createAssigner(_.keys);

  // Returns the first key on an object that passes a predicate test
  _.findKey = function(obj, predicate, context) {
    predicate = cb(predicate, context);
    var keys = _.keys(obj), key;
    for (var i = 0, length = keys.length; i < length; i++) {
      key = keys[i];
      if (predicate(obj[key], key, obj)) return key;
    }
  };

  // Return a copy of the object only containing the whitelisted properties.
  _.pick = function(object, oiteratee, context) {
    var result = {}, obj = object, iteratee, keys;
    if (obj == null) return result;
    if (_.isFunction(oiteratee)) {
      keys = _.allKeys(obj);
      iteratee = optimizeCb(oiteratee, context);
    } else {
      keys = flatten(arguments, false, false, 1);
      iteratee = function(value, key, obj) { return key in obj; };
      obj = Object(obj);
    }
    for (var i = 0, length = keys.length; i < length; i++) {
      var key = keys[i];
      var value = obj[key];
      if (iteratee(value, key, obj)) result[key] = value;
    }
    return result;
  };

   // Return a copy of the object without the blacklisted properties.
  _.omit = function(obj, iteratee, context) {
    if (_.isFunction(iteratee)) {
      iteratee = _.negate(iteratee);
    } else {
      var keys = _.map(flatten(arguments, false, false, 1), String);
      iteratee = function(value, key) {
        return !_.contains(keys, key);
      };
    }
    return _.pick(obj, iteratee, context);
  };

  // Fill in a given object with default properties.
  _.defaults = createAssigner(_.allKeys, true);

  // Creates an object that inherits from the given prototype object.
  // If additional properties are provided then they will be added to the
  // created object.
  _.create = function(prototype, props) {
    var result = baseCreate(prototype);
    if (props) _.extendOwn(result, props);
    return result;
  };

  // Create a (shallow-cloned) duplicate of an object.
  _.clone = function(obj) {
    if (!_.isObject(obj)) return obj;
    return _.isArray(obj) ? obj.slice() : _.extend({}, obj);
  };

  // Invokes interceptor with the obj, and then returns obj.
  // The primary purpose of this method is to "tap into" a method chain, in
  // order to perform operations on intermediate results within the chain.
  _.tap = function(obj, interceptor) {
    interceptor(obj);
    return obj;
  };

  // Returns whether an object has a given set of `key:value` pairs.
  _.isMatch = function(object, attrs) {
    var keys = _.keys(attrs), length = keys.length;
    if (object == null) return !length;
    var obj = Object(object);
    for (var i = 0; i < length; i++) {
      var key = keys[i];
      if (attrs[key] !== obj[key] || !(key in obj)) return false;
    }
    return true;
  };


  // Internal recursive comparison function for `isEqual`.
  var eq = function(a, b, aStack, bStack) {
    // Identical objects are equal. `0 === -0`, but they aren't identical.
    // See the [Harmony `egal` proposal](http://wiki.ecmascript.org/doku.php?id=harmony:egal).
    if (a === b) return a !== 0 || 1 / a === 1 / b;
    // A strict comparison is necessary because `null == undefined`.
    if (a == null || b == null) return a === b;
    // Unwrap any wrapped objects.
    if (a instanceof _) a = a._wrapped;
    if (b instanceof _) b = b._wrapped;
    // Compare `[[Class]]` names.
    var className = toString.call(a);
    if (className !== toString.call(b)) return false;
    switch (className) {
      // Strings, numbers, regular expressions, dates, and booleans are compared by value.
      case '[object RegExp]':
      // RegExps are coerced to strings for comparison (Note: '' + /a/i === '/a/i')
      case '[object String]':
        // Primitives and their corresponding object wrappers are equivalent; thus, `"5"` is
        // equivalent to `new String("5")`.
        return '' + a === '' + b;
      case '[object Number]':
        // `NaN`s are equivalent, but non-reflexive.
        // Object(NaN) is equivalent to NaN
        if (+a !== +a) return +b !== +b;
        // An `egal` comparison is performed for other numeric values.
        return +a === 0 ? 1 / +a === 1 / b : +a === +b;
      case '[object Date]':
      case '[object Boolean]':
        // Coerce dates and booleans to numeric primitive values. Dates are compared by their
        // millisecond representations. Note that invalid dates with millisecond representations
        // of `NaN` are not equivalent.
        return +a === +b;
    }

    var areArrays = className === '[object Array]';
    if (!areArrays) {
      if (typeof a != 'object' || typeof b != 'object') return false;

      // Objects with different constructors are not equivalent, but `Object`s or `Array`s
      // from different frames are.
      var aCtor = a.constructor, bCtor = b.constructor;
      if (aCtor !== bCtor && !(_.isFunction(aCtor) && aCtor instanceof aCtor &&
                               _.isFunction(bCtor) && bCtor instanceof bCtor)
                          && ('constructor' in a && 'constructor' in b)) {
        return false;
      }
    }
    // Assume equality for cyclic structures. The algorithm for detecting cyclic
    // structures is adapted from ES 5.1 section 15.12.3, abstract operation `JO`.

    // Initializing stack of traversed objects.
    // It's done here since we only need them for objects and arrays comparison.
    aStack = aStack || [];
    bStack = bStack || [];
    var length = aStack.length;
    while (length--) {
      // Linear search. Performance is inversely proportional to the number of
      // unique nested structures.
      if (aStack[length] === a) return bStack[length] === b;
    }

    // Add the first object to the stack of traversed objects.
    aStack.push(a);
    bStack.push(b);

    // Recursively compare objects and arrays.
    if (areArrays) {
      // Compare array lengths to determine if a deep comparison is necessary.
      length = a.length;
      if (length !== b.length) return false;
      // Deep compare the contents, ignoring non-numeric properties.
      while (length--) {
        if (!eq(a[length], b[length], aStack, bStack)) return false;
      }
    } else {
      // Deep compare objects.
      var keys = _.keys(a), key;
      length = keys.length;
      // Ensure that both objects contain the same number of properties before comparing deep equality.
      if (_.keys(b).length !== length) return false;
      while (length--) {
        // Deep compare each member
        key = keys[length];
        if (!(_.has(b, key) && eq(a[key], b[key], aStack, bStack))) return false;
      }
    }
    // Remove the first object from the stack of traversed objects.
    aStack.pop();
    bStack.pop();
    return true;
  };

  // Perform a deep comparison to check if two objects are equal.
  _.isEqual = function(a, b) {
    return eq(a, b);
  };

  // Is a given array, string, or object empty?
  // An "empty" object has no enumerable own-properties.
  _.isEmpty = function(obj) {
    if (obj == null) return true;
    if (isArrayLike(obj) && (_.isArray(obj) || _.isString(obj) || _.isArguments(obj))) return obj.length === 0;
    return _.keys(obj).length === 0;
  };

  // Is a given value a DOM element?
  _.isElement = function(obj) {
    return !!(obj && obj.nodeType === 1);
  };

  // Is a given value an array?
  // Delegates to ECMA5's native Array.isArray
  _.isArray = nativeIsArray || function(obj) {
    return toString.call(obj) === '[object Array]';
  };

  // Is a given variable an object?
  _.isObject = function(obj) {
    var type = typeof obj;
    return type === 'function' || type === 'object' && !!obj;
  };

  // Add some isType methods: isArguments, isFunction, isString, isNumber, isDate, isRegExp, isError.
  _.each(['Arguments', 'Function', 'String', 'Number', 'Date', 'RegExp', 'Error'], function(name) {
    _['is' + name] = function(obj) {
      return toString.call(obj) === '[object ' + name + ']';
    };
  });

  // Define a fallback version of the method in browsers (ahem, IE < 9), where
  // there isn't any inspectable "Arguments" type.
  if (!_.isArguments(arguments)) {
    _.isArguments = function(obj) {
      return _.has(obj, 'callee');
    };
  }

  // Optimize `isFunction` if appropriate. Work around some typeof bugs in old v8,
  // IE 11 (#1621), and in Safari 8 (#1929).
  if (typeof /./ != 'function' && typeof Int8Array != 'object') {
    _.isFunction = function(obj) {
      return typeof obj == 'function' || false;
    };
  }

  // Is a given object a finite number?
  _.isFinite = function(obj) {
    return isFinite(obj) && !isNaN(parseFloat(obj));
  };

  // Is the given value `NaN`? (NaN is the only number which does not equal itself).
  _.isNaN = function(obj) {
    return _.isNumber(obj) && obj !== +obj;
  };

  // Is a given value a boolean?
  _.isBoolean = function(obj) {
    return obj === true || obj === false || toString.call(obj) === '[object Boolean]';
  };

  // Is a given value equal to null?
  _.isNull = function(obj) {
    return obj === null;
  };

  // Is a given variable undefined?
  _.isUndefined = function(obj) {
    return obj === void 0;
  };

  // Shortcut function for checking if an object has a given property directly
  // on itself (in other words, not on a prototype).
  _.has = function(obj, key) {
    return obj != null && hasOwnProperty.call(obj, key);
  };

  // Utility Functions
  // -----------------

  // Run Underscore.js in *noConflict* mode, returning the `_` variable to its
  // previous owner. Returns a reference to the Underscore object.
  _.noConflict = function() {
    root._ = previousUnderscore;
    return this;
  };

  // Keep the identity function around for default iteratees.
  _.identity = function(value) {
    return value;
  };

  // Predicate-generating functions. Often useful outside of Underscore.
  _.constant = function(value) {
    return function() {
      return value;
    };
  };

  _.noop = function(){};

  _.property = property;

  // Generates a function for a given object that returns a given property.
  _.propertyOf = function(obj) {
    return obj == null ? function(){} : function(key) {
      return obj[key];
    };
  };

  // Returns a predicate for checking whether an object has a given set of
  // `key:value` pairs.
  _.matcher = _.matches = function(attrs) {
    attrs = _.extendOwn({}, attrs);
    return function(obj) {
      return _.isMatch(obj, attrs);
    };
  };

  // Run a function **n** times.
  _.times = function(n, iteratee, context) {
    var accum = Array(Math.max(0, n));
    iteratee = optimizeCb(iteratee, context, 1);
    for (var i = 0; i < n; i++) accum[i] = iteratee(i);
    return accum;
  };

  // Return a random integer between min and max (inclusive).
  _.random = function(min, max) {
    if (max == null) {
      max = min;
      min = 0;
    }
    return min + Math.floor(Math.random() * (max - min + 1));
  };

  // A (possibly faster) way to get the current timestamp as an integer.
  _.now = Date.now || function() {
    return new Date().getTime();
  };

   // List of HTML entities for escaping.
  var escapeMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#x27;',
    '`': '&#x60;'
  };
  var unescapeMap = _.invert(escapeMap);

  // Functions for escaping and unescaping strings to/from HTML interpolation.
  var createEscaper = function(map) {
    var escaper = function(match) {
      return map[match];
    };
    // Regexes for identifying a key that needs to be escaped
    var source = '(?:' + _.keys(map).join('|') + ')';
    var testRegexp = RegExp(source);
    var replaceRegexp = RegExp(source, 'g');
    return function(string) {
      string = string == null ? '' : '' + string;
      return testRegexp.test(string) ? string.replace(replaceRegexp, escaper) : string;
    };
  };
  _.escape = createEscaper(escapeMap);
  _.unescape = createEscaper(unescapeMap);

  // If the value of the named `property` is a function then invoke it with the
  // `object` as context; otherwise, return it.
  _.result = function(object, property, fallback) {
    var value = object == null ? void 0 : object[property];
    if (value === void 0) {
      value = fallback;
    }
    return _.isFunction(value) ? value.call(object) : value;
  };

  // Generate a unique integer id (unique within the entire client session).
  // Useful for temporary DOM ids.
  var idCounter = 0;
  _.uniqueId = function(prefix) {
    var id = ++idCounter + '';
    return prefix ? prefix + id : id;
  };

  // By default, Underscore uses ERB-style template delimiters, change the
  // following template settings to use alternative delimiters.
  _.templateSettings = {
    evaluate    : /<%([\s\S]+?)%>/g,
    interpolate : /<%=([\s\S]+?)%>/g,
    escape      : /<%-([\s\S]+?)%>/g
  };

  // When customizing `templateSettings`, if you don't want to define an
  // interpolation, evaluation or escaping regex, we need one that is
  // guaranteed not to match.
  var noMatch = /(.)^/;

  // Certain characters need to be escaped so that they can be put into a
  // string literal.
  var escapes = {
    "'":      "'",
    '\\':     '\\',
    '\r':     'r',
    '\n':     'n',
    '\u2028': 'u2028',
    '\u2029': 'u2029'
  };

  var escaper = /\\|'|\r|\n|\u2028|\u2029/g;

  var escapeChar = function(match) {
    return '\\' + escapes[match];
  };

  // JavaScript micro-templating, similar to John Resig's implementation.
  // Underscore templating handles arbitrary delimiters, preserves whitespace,
  // and correctly escapes quotes within interpolated code.
  // NB: `oldSettings` only exists for backwards compatibility.
  _.template = function(text, settings, oldSettings) {
    if (!settings && oldSettings) settings = oldSettings;
    settings = _.defaults({}, settings, _.templateSettings);

    // Combine delimiters into one regular expression via alternation.
    var matcher = RegExp([
      (settings.escape || noMatch).source,
      (settings.interpolate || noMatch).source,
      (settings.evaluate || noMatch).source
    ].join('|') + '|$', 'g');

    // Compile the template source, escaping string literals appropriately.
    var index = 0;
    var source = "__p+='";
    text.replace(matcher, function(match, escape, interpolate, evaluate, offset) {
      source += text.slice(index, offset).replace(escaper, escapeChar);
      index = offset + match.length;

      if (escape) {
        source += "'+\n((__t=(" + escape + "))==null?'':_.escape(__t))+\n'";
      } else if (interpolate) {
        source += "'+\n((__t=(" + interpolate + "))==null?'':__t)+\n'";
      } else if (evaluate) {
        source += "';\n" + evaluate + "\n__p+='";
      }

      // Adobe VMs need the match returned to produce the correct offest.
      return match;
    });
    source += "';\n";

    // If a variable is not specified, place data values in local scope.
    if (!settings.variable) source = 'with(obj||{}){\n' + source + '}\n';

    source = "var __t,__p='',__j=Array.prototype.join," +
      "print=function(){__p+=__j.call(arguments,'');};\n" +
      source + 'return __p;\n';

    try {
      var render = new Function(settings.variable || 'obj', '_', source);
    } catch (e) {
      e.source = source;
      throw e;
    }

    var template = function(data) {
      return render.call(this, data, _);
    };

    // Provide the compiled source as a convenience for precompilation.
    var argument = settings.variable || 'obj';
    template.source = 'function(' + argument + '){\n' + source + '}';

    return template;
  };

  // Add a "chain" function. Start chaining a wrapped Underscore object.
  _.chain = function(obj) {
    var instance = _(obj);
    instance._chain = true;
    return instance;
  };

  // OOP
  // ---------------
  // If Underscore is called as a function, it returns a wrapped object that
  // can be used OO-style. This wrapper holds altered versions of all the
  // underscore functions. Wrapped objects may be chained.

  // Helper function to continue chaining intermediate results.
  var result = function(instance, obj) {
    return instance._chain ? _(obj).chain() : obj;
  };

  // Add your own custom functions to the Underscore object.
  _.mixin = function(obj) {
    _.each(_.functions(obj), function(name) {
      var func = _[name] = obj[name];
      _.prototype[name] = function() {
        var args = [this._wrapped];
        push.apply(args, arguments);
        return result(this, func.apply(_, args));
      };
    });
  };

  // Add all of the Underscore functions to the wrapper object.
  _.mixin(_);

  // Add all mutator Array functions to the wrapper.
  _.each(['pop', 'push', 'reverse', 'shift', 'sort', 'splice', 'unshift'], function(name) {
    var method = ArrayProto[name];
    _.prototype[name] = function() {
      var obj = this._wrapped;
      method.apply(obj, arguments);
      if ((name === 'shift' || name === 'splice') && obj.length === 0) delete obj[0];
      return result(this, obj);
    };
  });

  // Add all accessor Array functions to the wrapper.
  _.each(['concat', 'join', 'slice'], function(name) {
    var method = ArrayProto[name];
    _.prototype[name] = function() {
      return result(this, method.apply(this._wrapped, arguments));
    };
  });

  // Extracts the result from a wrapped and chained object.
  _.prototype.value = function() {
    return this._wrapped;
  };

  // Provide unwrapping proxy for some methods used in engine operations
  // such as arithmetic and JSON stringification.
  _.prototype.valueOf = _.prototype.toJSON = _.prototype.value;

  _.prototype.toString = function() {
    return '' + this._wrapped;
  };

  // AMD registration happens at the end for compatibility with AMD loaders
  // that may not enforce next-turn semantics on modules. Even though general
  // practice for AMD registration is to be anonymous, underscore registers
  // as a named module because, like jQuery, it is a base library that is
  // popular enough to be bundled in a third party lib, but not be part of
  // an AMD load request. Those cases could generate an error when an
  // anonymous define() is called outside of a loader request.
  if (typeof define === 'function' && define.amd) {
    define('underscore', [], function() {
      return _;
    });
  }
}.call(this));

},{}],5:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

/**
 * similar to _.findIndex(), but returns array size if no element pass the test.
 * @param {Array} array
 * @param {function} test
 * @return {number}
 */
var findIndex = function findIndex(array, test) {
    for (var i = 0; i < array.length; i++) {
        if (test(array[i])) {
            return i;
        }
    }
    return i;
};

/**
 * アクセスログのグラフに対応するクラス
 * プロットには$.plot を利用する
 */
var AccessLog = function AccessLog() {
    this.init.apply(this, arguments);
};

AccessLog.prototype = {

    /**
     * コンストラクタ
     * @param {[number]} counts - アクセスログ
     * @param {Object} opts
     * @param {number} opts.unit                 - グラフの横軸の単位 msec
     * @param {number} opts.number               - プロットする期間を分割する数
     * @param {jQuery} opts.parent               - プロット部分のコンテナ要素
     * @param {number} opts.barWidth             - $.plotのオプション
     * @param {number} opts.minTickSize          - $.plotのオプション
     * @param {number} opts.timeformat           - $.plotのオプション
     * @param {number} opts.graphAreaMarginRight - $.plotのオプション
     */
    init: function init(counts, opts) {
        // アクセスログからプロット用データを作成
        this.data = this.generateData(counts, opts.unit, opts.number);

        // コンテナ要素を表示
        this.$parent = opts.parent;
        this.$parent.css({
            width: this.$parent.parent().width() - (opts.graphAreaMarginRight || 50),
            height: +this.$parent.attr('data-graph-height')
        }).show();

        // 描画
        this.graph = this.plot(opts.barWidth, opts.minTickSize, opts.timeformat);

        // tooltip作成
        this.$tooltip = this.$parent.find('.tooltip');
        if (this.$tooltip.length === 0) {
            this.$tooltip = $('<div class="tooltip"></div>');
            this.$tooltip.appendTo(this.$parent).hide();
        }

        // 親要素にhoverしたらtooltip表示
        this.$parent.on('plothover', this.onMouseOver.bind(this));
    },

    /**
     * アクセスログを$.plotに渡す形式に変換する
     *
     * @param {[number]} counts   - アクセスログ
     * @param {number}   unit     - 単位 msec
     * @param {number}   interval - start から end を分割する数
     */
    generateData: function generateData(counts, unit, number) {
        var end = Math.floor(new Date().getTime() / unit) * unit + unit;
        var start = end - unit * number;
        var offset = new Date().getTimezoneOffset() * 60 * 1000;
        var logInterval = 60 * 15 * 1000; // アクセスログは15分毎に記録されている

        var data = [];
        var acc = 0;

        for (var t = start; t <= end; t += logInterval) {
            acc += counts[t] || 0;

            // jQuery flot は UTC で表示してしまうので、
            // あらかじめ offset を計算して epoch をズラす
            var epoch = t - offset;
            if (epoch % unit === 0) {
                data.push([epoch - unit, acc]);
                acc = 0;
            }
        }

        return data;
    },

    /**
     * $.plotを呼ぶ
     * @param {number} barWidth
     * @param {[number, string]} minTickSize
     * @param {string} timeformat
     */
    plot: function plot(barWidth, minTickSize, timeformat) {
        return $.plot(this.$parent, [{
            label: '',
            data: this.data,
            bars: { show: true, lineWidth: barWidth || 15 },
            legend: { show: false }
        }], {
            xaxis: {
                mode: 'time',
                minTickSize: minTickSize,
                timeformat: timeformat
            },
            yaxis: {
                min: 0,
                minTickSize: 1,
                autoscaleMargin: 0.5,
                labelWidth: +this.$parent.attr('data-yaxis-width'),
                tickFormatter: function tickFormatter(number) {
                    return number.toString();
                }
            },
            grid: {
                axisMargin: 5,
                labelMargin: 5,
                minBorderMargin: 0,
                borderWidth: 1,
                borderColor: '#CCCCCC',
                hoverable: true
            }
        });
    },

    /**
     * 親要素にhoverしたらtooltip表示
     * @param {Event} e
     * @param {{x: number, y: number}} pos
     */
    onMouseOver: function onMouseOver(e, pos) {
        var axes = this.graph.getAxes();

        if (pos.x < axes.xaxis.min || pos.x > axes.xaxis.max) {
            return;
        }
        if (pos.y < axes.yaxis.min || pos.y > axes.yaxis.max) {
            return;
        }

        var series = this.graph.getData()[0];

        // マウス位置に近い時刻のデータを取得する
        var n = findIndex(series.data, function (data) {
            return data[0] > pos.x;
        });

        // マウス位置左右のデータについて、有効 && より近い方のデータを選ぶ
        var p1 = series.data[n - 1],
            p2 = series.data[n];

        if (!p1 && !p2) {
            return;
        }

        var p = !p1 ? p2 : !p2 ? p1 : pos.x - p1[0] < p2[0] - pos.x ? p1 : p2;

        // 選ばれたデータに対しtooltipを表示
        this.showTooltip(axes.xaxis.p2c(p[0]), axes.yaxis.p2c(p[1]), p[1]);
    },

    /**
     * tooltipを表示する
     * @param {number} x
     * @param {number} y
     * @param {string} contents
     */
    showTooltip: function showTooltip(x, y, contents) {
        this.$tooltip.css({
            position: 'absolute',
            top: y - 25,
            left: x + 13
        }).text(contents).show();
    }

};

/** @static */
AccessLog.showGraph = function (counts, opts) {
    return new AccessLog(counts, opts);
};

module.exports = AccessLog;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],6:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Cookie = require('js-cookie');
var Logger = require('../../Base/Logger');
var globalData = require('../../Base/globalData');
var decodeParam = require('../../Util/decodeParam');

/**
 * バックアップされたデータの値オブジェクト
 * 不変性を持つ
 */
var BackupData = function BackupData(args) {
    this.init.apply(this, arguments);
};
BackupData.prototype = {

    /**
     * @constructor
     *
     * @param {string} args.id       - formで指定されたdata-backup-id
     * @param {string} args.data     - バックアップしたformの内容
     * @param {Number} args.modified - バックアップが保存された時刻のepoch
     */
    init: function init(args) {
        this.id = args.id;
        this.data = args.data;
        this.modified = args.modified;
    },

    toJSON: function toJSON() {
        return {
            id: this.id,
            data: this.data,
            modified: this.modified
        };
    }
};

var Backup = function Backup() {
    this.init.apply(this, arguments);
};
Backup.prototype = {

    init: function init($form) {
        var self = this;
        self.$form = $form;

        this.localStorageKey = 'backup'; // formIdを反映する

        // サーバーでbackupするのは廃止になったので
        // ローカルストレージに対応していないブラウザの場合は即returnする
        if (!self.localStorageEnabled()) {
            return;
        }

        $(document).on('clearBackup', this.clearBackup.bind(this));

        self.deletePreviousBackup();
    },

    /**
     * 対応するformの状態を監視し、定期的にバックアップする
     * 既にwatchしている場合は何もしない
     * @public
     */
    watch: function watch() {
        var self = this;
        if (self.timer) {
            return;
        }

        // localStorage使えたら頻繁に，使えなかったら通信発生するので頻度低く
        var defaultInterval = this.localStorageEnabled() ? 3000 : 9000;

        self.timer = setInterval(function () {
            self.save();
        }, +self.$form.attr('data-backup-interval') * 1000 || defaultInterval);
    },

    localStorageEnabled: function localStorageEnabled() {
        // localStorageが使えて，かつ，デザイン設定画面でないとき有効
        // デザイン設定のプレビューはバックアップを通してやってるため
        var enabled = false;
        try {
            enabled = window.localStorage && globalData('page') !== 'user-blog-config-design-detail';
        } catch (ignore_error) {}
        return enabled;
    },

    /**
     * localStorageのバックアップをリセットする
     * @public
     */
    clearBackup: function clearBackup() {
        localStorage.removeItem(this.localStorageKey);
    },

    /**
     * 以前のバックアップを消すようにというあれがあればlocalStorageのバックアップをリセット
     * このcookieは記事投稿成功時にセットされ，クリアしたらクライアント側で消す
     */
    deletePreviousBackup: function deletePreviousBackup() {
        if (!Cookie.get('clear_backup')) {
            return;
        }

        localStorage.removeItem(this.localStorageKey);
        Cookie.remove('clear_backup', { path: '/' });
    },

    /**
     * 対応するformのバックアップをlocalStorageからロードする
     * @return {$.Promise<BackupData>}
     */
    load: function load() {
        var self = this;

        var backupId = self.$form.attr('data-backup-id');
        self.$form.data('backup', self.serialize());

        var loaded = $.Deferred();

        _.defer(function () {
            var backup;
            try {
                var values = JSON.parse(localStorage.getItem(self.localStorageKey));
                backup = new BackupData(values);
            } catch (ignore_error) {}

            // バックアップがあり，formのidが一致する事をチェック
            if (!backup || backup.id !== backupId) {
                loaded.reject();return;
            }

            // バックアップが古すぎる場合はreject
            var backupTime = new Date(+backup.modified * 1000);
            if (new Date() - backupTime > 1000 * 60 * 60) {
                loaded.reject();return;
            }

            Logger.LOG(['backup.load', backup]);
            loaded.resolve(backup);
        });

        return loaded.promise();
    },

    /**
     * localStorageにBackupDataを保存し、backup-saveイベントを発行する
     * @return {undefined}
     */
    save: function save(force) {
        var self = this;

        var id = self.$form.attr('data-backup-id');
        var prev = self.$form.data('backup');
        var now = self.serialize();

        // フォームの状態が変化していないとき何もしない
        if (prev === now && !force) {
            return;
        }

        self.$form.trigger('backup-presave');

        self.$form.data('backup', now);

        var backupTime = Math.floor(new Date().getTime() / 1000);

        var backup = new BackupData({
            id: id,
            data: now,
            modified: backupTime
        });
        localStorage.setItem(self.localStorageKey, JSON.stringify(backup));

        Logger.LOG(['backup.save', backup]);
        this.$form.trigger('backup-save');
    },

    /**
     * form内のデータを文字列にシリアライズする
     * @return {string}
     */
    serialize: function serialize() {
        var values = [];
        var inputs = this.$form.find('input[type="text"], textarea, input[data-with-backup], input[type="hidden"].backup, input[type="radio"].backup, input[type="checkbox"].backup-button');
        for (var i = 0, it; it = inputs[i]; i++) {
            if (!it.name) continue;
            if (it.type == 'radio' && !it.checked) continue;
            // selectされてない場合は0を送る
            if (it.type == 'checkbox' && !it.checked) {
                values.push(encodeURIComponent(it.name) + '=0');
                continue;
            }
            values.push(encodeURIComponent(it.name) + '=' + encodeURIComponent(it.value));
        }
        this.$form.find('select').each(function () {
            var select = this;
            var $select = $(select);
            if (select.getAttribute('data-without-backup') !== null) {
                return;
            }

            var selectItem = $select.find('option:selected');
            if (selectItem.length === 0) {
                return;
            }

            values.push(encodeURIComponent(select.name) + '=' + encodeURIComponent($(selectItem[0]).val()));
        });
        return values.join('&');
    },

    /**
     * @param {string} formData - formのシリアライズドデータ
     * @public
     */
    restoreBackup: function restoreBackup(formData) {
        Logger.LOG('restore backup');
        this.formDataBeforeRestore = this.serialize(); // restore直前の状態を保存する
        this.assignData(formData);
    },

    /**
     * 直前のrestoreをロールバックする
     * @param {string} prevFormData - restore以前のformのシリアライズドデータ
     * @public
     */
    clearRestore: function clearRestore() {
        Logger.LOG('clear restore');
        this.assignData(this.formDataBeforeRestore);
    },

    /**
     * シリアライズされたデータからformを復元する
     * @param {string} formData - restore以前のformのシリアライズドデータ
     * @private
     */
    assignData: function assignData(formData) {
        var params = decodeParam(formData);
        // XXX
        // categoryのbackupデータを復元するにはCategoryEditor.appendを利用する必要がある
        // CategoryEditorがbackup-restore-paramsをlistenしてappendしてくれるのでここではSKIPする
        for (var name in params) if (params.hasOwnProperty(name) && name !== 'category') {
            this.$form.find('input[name="' + name + '"], textarea[name="' + name + '"]').val(params[name]);
        }

        this.$form.data('backup', formData);
        this.$form.trigger('backup-restore', formData);
        this.$form.trigger('backup-restore-params', [params]);
    }
};

module.exports = Backup;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/Logger":44,"../../Base/globalData":52,"../../Util/decodeParam":162,"js-cookie":2,"underscore":4}],7:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Locale = require('../../Locale');
var Backup = require('./Backup');

/**
 * バックアップメッセージの抽象クラス
 * ViewとControllerを担当する
 */
var BackupMessage = function BackupMessage(args) {
    this.init.apply(this, arguments);
};
BackupMessage.prototype = {
    init: function init($form, $editarea) {
        this.$form = $form;
        this.$editarea = $editarea;

        this.model = new Backup($form);
        this.restore();
        this.model.watch();
    },

    /**
     * localStorageからデータをロードし、formの状態を復元する
     * @public
     */
    restore: function restore() {
        var self = this;

        var backupData;
        return self.model.load().then(function (res) {
            backupData = res;

            // 自動で復元 or 復元しますかメッセージを出す
            if (self.shouldAutoRestore()) {
                self.promptAutoRestored(res);
                return true;
            } else {
                return self.promptRestore(res);
            }
        }).then(function () {
            self.model.restoreBackup(backupData.data);
        });
    },

    /**
     * 自動復元するかどうか判断する
     * UIによって答えが変わるので、Modelでは判断できない
     * @return {Boolean}
     */
    shouldAutoRestore: function shouldAutoRestore() {},

    /**
     * 復元しますか？メッセージを出す
     * @param {BackupData} backupData - 復元するバックアップデータ
     * @return {$.Promise<Boolean>}
     */
    promptRestore: function promptRestore(backupData) {},

    /**
     * 自動復元した旨のメッセージを出す
     * 復元をクリアするリンクも表示する
     * @param {BackupData} backupData - 復元したバックアップデータ
     */
    promptAutoRestored: function promptAutoRestored(backupData) {}
};

module.exports = BackupMessage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Locale":151,"./Backup":6,"underscore":4}],8:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Locale = require('../../Locale');
var extend = require('../../Util/extend');
var URLGenerator = require('../../Base/URLGenerator');

var BackupMessage = require('./BackupMessage');

var BackupMessagePC = function BackupMessagePC(args) {
    this.init.apply(this, arguments);
};
extend(BackupMessagePC.prototype, BackupMessage.prototype);

BackupMessagePC.prototype.init = function () {
    BackupMessage.prototype.init.apply(this, arguments);
    this.initMessage();
};

BackupMessagePC.prototype.initMessage = function () {
    this.$message = $('<div class="backup-message" style="display: none; margin-buttom: -1px;" />');
    this.$closeButton = $('<div class="backup-message-close">' + '  <img src="' + URLGenerator.static_url('/images/admin/close.gif') + '" />' + '</div>');
    this.$message.append(this.$closeButton).insertBefore(this.$editarea);

    // 下部のボーダーをeditareaのボーダーに重ねるために,
    // 上部のボーダーを含み, 下部のボーダーを含まないように計算する
    this.height = this.$message.outerHeight() - (parseInt(this.$message.css('border-width'), 10) || 1);

    this.$form.data('backup-message', this.$message);

    var self = this;

    // ユーザーがメッセージを無視して編集し始めたらメッセージを消す
    this.$form.on('backup-presave', function () {
        self.closeMessage();
    });

    // 閉じるボタンでメッセージを消す
    this.$closeButton.on('click', function () {
        self.closeMessage();
    });

    // 編集タブ以外では隠す
    $('#editor-main .ui-tabs').on('tabsactivate', function (event, ui) {
        if (ui.newPanel.attr('aria-labelledby') === 'ui-id-1') {
            self.$message.show();
        } else {
            self.$message.hide();
        }
    });
};

BackupMessagePC.prototype.closeMessage = function () {
    this.$message.remove();
    this.$form.trigger('backup-message-close');
};

/**
 * 自動復元するかどうか判断する
 * 新規投稿かつタイトルと本文が空のとき自動で復元
 * @return {Boolean}
 */
BackupMessagePC.prototype.shouldAutoRestore = function () {
    var newEntryBackupIDRegex = new RegExp("user/blog/edit-\\d+-new");
    var isNewEntry = newEntryBackupIDRegex.test(this.$form.attr('data-backup-id'));

    var $title = this.$form.find(':input[name="title"]');
    var titleIsEmpty = $title[0] && $title.val().length === 0;

    var $body = this.$form.find(':input[name="body"]');
    var bodyIsEmpty = $body[0] && $body.val().length === 0;

    return isNewEntry && titleIsEmpty && bodyIsEmpty;
};

/**
 * 復元しますか？メッセージを出す
 * @param {BackupData} backupData - 復元するバックアップデータ
 * @return {$.Promise<Boolean>}
 */
BackupMessagePC.prototype.promptRestore = function (backupData) {
    var self = this;
    var backupTime = new Date(+backupData.modified * 1000);

    var d = $.Deferred();

    var time = Locale.text('backup.notice', '<time data-relative data-epoch="' + backupTime.getTime() + '"></time>');
    var $restore = $('<a href="javascript:void(0)">(' + Locale.text('backup.restore') + ')</a>');
    this.$message.prepend(time, $restore).show();

    Locale.updateTimestamps(this.$message[0]);

    $restore.on('click', function () {
        d.resolve();
        self.closeMessage();
    });

    return d.promise();
};

/**
 * 自動復元した旨のメッセージを出す
 * 復元をクリアするリンクも表示する
 * @param {BackupData} backupData - 復元したバックアップデータ
 */
BackupMessagePC.prototype.promptAutoRestored = function (backupData) {
    var self = this;

    var backupTime = new Date(+backupData.modified * 1000);

    var time = Locale.text('backup.notice.auto_restored', '<time data-relative data-epoch="' + backupTime.getTime() + '"></time>');
    var $clear = $('<a href="javascript:void(0)">(' + Locale.text('backup.clear_restore') + ')</a>');
    this.$message.prepend(time, $clear).show();

    Locale.updateTimestamps(this.$message[0]);

    $clear.on('click', function () {
        self.model.clearRestore();
        self.closeMessage();
    });
};

module.exports = BackupMessagePC;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/URLGenerator":48,"../../Locale":151,"../../Util/extend":163,"./BackupMessage":7,"underscore":4}],9:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Locale = require('../../Locale');
var extend = require('../../Util/extend');

var BackupMessage = require('./BackupMessage');

var BackupMessageTouch = function BackupMessageTouch(args) {
  this.init.apply(this, arguments);
};
extend(BackupMessageTouch.prototype, BackupMessage.prototype);

/**
 * 自動復元するかどうか判断する
 * touch版では自動的に復元せずに、手動で復元する
 * @return {Boolean}
 */
BackupMessageTouch.prototype.shouldAutoRestore = function () {
  return false;
};

/**
 * 復元しますか？メッセージを出す
 * @param {BackupData} backupData - 復元するバックアップデータ
 * @return {$.Promise<Boolean>}
 */
BackupMessageTouch.prototype.promptRestore = function (backupData) {
  var self = this;

  var d = $.Deferred();

  var backupTime = new Date(+backupData.modified * 1000);
  if (confirm(Locale.text('backup.notice.ask_restore', backupTime))) {
    d.resolve();
  }

  return d.promise();
};

/**
 * Touch版では自動復元しない
 */
BackupMessageTouch.prototype.promptAutoRestored = function (backupData) {};

module.exports = BackupMessageTouch;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Locale":151,"../../Util/extend":163,"./BackupMessage":7,"underscore":4}],10:[function(require,module,exports){
'use strict';

var BackupMessagePC = require('./BackupMessagePC');
var BackupMessageTouch = require('./BackupMessageTouch');

module.exports = {
    createMessage: function createMessage($form, $editarea) {
        if (Hatena.Diary.Pages.device() === 'pc') {
            return new BackupMessagePC($form, $editarea);
        } else {
            return new BackupMessageTouch($form, $editarea);
        }
    }
};

},{"./BackupMessagePC":8,"./BackupMessageTouch":9}],11:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

/**
 * ブログ公開設定コンポーネント
 */
var BlogPermission = function BlogPermission() {
    this.init.apply(this, arguments);
};

BlogPermission.prototype = {

    /**
     * @constructor
     * @param {jQuery} $element
     */
    init: function init($element) {
        this.$element = $element;

        // authconfig = 公開設定
        this.$authconfigs = this.$element.find('.permission-authconfigs');
        this.$newAuthconfig = this.$element.find('#new-authconfig');
        this.$authconfigSelect = this.$element.find('#viewable-id-select');

        // カスタム公開範囲設定
        this.$customConfigs = this.$element.find('#permission-custom-viewable-id');
        this.$newCustomConfig = this.$element.find('.authconfig-detail-new');

        this.$checkboxes = this.$element.find('[name = "permission"]');
        this.$customCheckbox = this.$element.find('#permission-custom');
        this.$publicCheckbox = this.$element.find('#permission-public');

        this.$inputOverlay = this.$element.find('.config-private-overlay');

        this.initEvents();
    },

    initEvents: function initEvents() {
        var self = this;

        this.$newAuthconfig.on('click', function () {
            self.$element.find('#create-authconfig').submit();
        });

        // 認証セットの選択にあわせて、対応する編集リンクなどを出したり消したりする
        this.$authconfigSelect.on('change', function () {
            var selected = $(this).find('option:selected');
            var detailId = selected.attr('data-ac');
            self.$authconfigs.find('.authconfig-detail').addClass('hide');
            self.$authconfigs.find('.' + detailId).removeClass('hide');
        }).change();

        this.$checkboxes.on('change', function () {
            if (self.$publicCheckbox.prop('checked')) {
                self.$inputOverlay.show();
            } else {
                self.$inputOverlay.hide();
            }

            // 認証セット存在するときは，設定によって表示/非表示を切り替える
            // 存在しないときは，新しい認証セットを作れるようにするため，常に設定UIを表示する
            if (self.customAuthConfigExists()) {
                if (self.$customCheckbox.prop('checked')) {
                    self.$customConfigs.show();
                } else {
                    self.$customConfigs.hide();
                }
            } else {
                self.$customConfigs.show();
                self.$newCustomConfig.show();
            }
        }).change();
    },

    // 既存の認証セットが存在するかどうか
    // 存在しないときdisabledがついてることを利用
    customAuthConfigExists: function customAuthConfigExists() {
        return !this.$customCheckbox.attr('disabled');
    }

};

module.exports = BlogPermission;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],12:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var EventEmitter = require('events').EventEmitter;
var Location = require('../../Base/Location');

// パンくず編集画面のActions．ルールをロードして，rulesLoadedを発火する

var Actions = (function (_EventEmitter) {
    _inherits(Actions, _EventEmitter);

    function Actions() {
        _classCallCheck(this, Actions);

        _get(Object.getPrototypeOf(Actions.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(Actions, [{
        key: 'loadRules',
        value: function loadRules() {
            var _this = this;

            $.ajax({
                url: 'rules.json',
                data: {
                    spreadsheet_uri: Location.param('spreadsheet_uri')
                },
                dataType: 'json'
            }).done(function (rules) {
                return _this.emit('rulesLoaded', rules);
            });
        }
    }]);

    return Actions;
})(EventEmitter);

module.exports = new Actions();

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/Location":43,"events":1}],13:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var EventEmitter = require('events').EventEmitter;

var Actions = require('./Actions');

// パンくず編集画面のStore．パンくずルールを保持する．
// stateについて
//   rules: サーバーから受信したパンくずJSON
//   maxItemsLength: パンくずアイテム最大何個あるか．テーブル末尾に空のセルを埋めるために必要

var Store = (function (_EventEmitter) {
    _inherits(Store, _EventEmitter);

    function Store() {
        var _this = this;

        _classCallCheck(this, Store);

        _get(Object.getPrototypeOf(Store.prototype), 'constructor', this).call(this);

        this.state = {
            rules: [],
            maxItemsLength: 2
        };

        Actions.on('rulesLoaded', function (rules) {
            _this.setRules(rules);
            _this.emit('change');
        });
    }

    _createClass(Store, [{
        key: 'initialize',
        value: function initialize() {
            Actions.loadRules();
        }

        /**
         * Editorをロードする
         * @param {Array[{page_id, category, rules}} rules
         */
    }, {
        key: 'setRules',
        value: function setRules(rules) {
            this.state.rules = rules;

            var lengthes = rules.map(function (item) {
                return Math.ceil(item.rules.length / 2);
            });

            this.state.maxItemsLength = Math.max.apply(Math, _toConsumableArray(lengthes));
        }
    }, {
        key: 'getState',
        value: function getState() {
            return this.state;
        }
    }]);

    return Store;
})(EventEmitter);

module.exports = new Store();

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Actions":12,"events":1}],14:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _ = require('underscore');

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);

var URLGenerator = require('../../../Base/URLGenerator');

// ルールひとつをあらわすクラス

var Rule = (function (_React$Component) {
    _inherits(Rule, _React$Component);

    function Rule() {
        _classCallCheck(this, Rule);

        _get(Object.getPrototypeOf(Rule.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(Rule, [{
        key: 'render',
        value: function render() {
            return React.createElement(
                'tr',
                null,
                React.createElement(
                    'th',
                    null,
                    this.props.pageType
                ),
                React.createElement(
                    'td',
                    null,
                    this.props.category
                ),
                this.renderRules()
            );
        }
    }, {
        key: 'renderRules',
        value: function renderRules() {
            var _this = this;

            var pairs = [];
            for (var i = 0; i < this.props.rules.length; i += 2) {
                pairs.push([this.props.rules[i], this.props.rules[i + 1]]);
            }

            while (pairs.length < this.props.maxItemsLength) {
                pairs.push([]);
            }

            return pairs.map(function (rule) {
                if (rule[0]) {
                    return React.createElement(
                        'td',
                        null,
                        React.createElement(
                            'div',
                            null,
                            _this.formatLabel(rule[0])
                        ),
                        React.createElement(
                            'div',
                            null,
                            _this.renderLink(rule[1])
                        )
                    );
                } else {
                    return React.createElement('td', null);
                }
            });
        }
    }, {
        key: 'formatLabel',
        value: function formatLabel(label) {
            if (!label) {
                return label;
            }

            if (label.match(/^:/)) {
                return React.createElement(
                    'i',
                    null,
                    label
                );
            }

            return React.createElement(
                'b',
                null,
                label
            );
        }
    }, {
        key: 'renderLink',
        value: function renderLink(uri) {
            if (!uri) {
                return uri;
            }

            if (uri.match(/^:/)) {
                return React.createElement(
                    'i',
                    null,
                    uri
                );
            }

            var label = uri;
            var href = uri;
            if (href[0] === '/') {
                href = URLGenerator.user_blog_url(href);
            }
            return React.createElement(
                'a',
                { href: href, target: 'blank' },
                label
            );
        }
    }]);

    return Rule;
})(React.Component);

Rule.propTypes = {
    pageType: React.PropTypes.string,
    category: React.PropTypes.string,
    rules: React.PropTypes.array,
    maxItemsLength: React.PropTypes.integer
};

module.exports = Rule;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Base/URLGenerator":48,"underscore":4}],15:[function(require,module,exports){
(function (global){
'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _ = require('underscore');

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var Rule = require('./Rule');

var Store = require('../Store');

// ルール集の表をあらわすクラス

var RulesTable = (function (_React$Component) {
    _inherits(RulesTable, _React$Component);

    function RulesTable() {
        _classCallCheck(this, RulesTable);

        _get(Object.getPrototypeOf(RulesTable.prototype), 'constructor', this).call(this);

        this.state = Store.getState();

        this.updateState = this._updateState.bind(this);
    }

    _createClass(RulesTable, [{
        key: 'componentDidMount',
        value: function componentDidMount() {
            Store.on('change', this.updateState);
        }
    }, {
        key: 'componentWillUnmount',
        value: function componentWillUnmount() {
            Store.removeListener('change', this.updateState);
        }
    }, {
        key: '_updateState',
        value: function _updateState() {
            var newState = Store.getState();
            this.setState({
                rules: newState.rules,
                maxItemsLength: newState.maxItemsLength
            });
        }
    }, {
        key: 'render',
        value: function render() {
            if (!this.state.rules.length) {
                return React.createElement('table', null);
            }

            return React.createElement(
                'table',
                { className: 'table' },
                this.renderHeader(),
                this.renderRules()
            );
        }
    }, {
        key: 'renderHeader',
        value: function renderHeader() {
            return React.createElement(
                'tr',
                null,
                React.createElement(
                    'th',
                    null,
                    'pageType'
                ),
                React.createElement(
                    'th',
                    null,
                    'category'
                ),
                _.times(this.state.maxItemsLength, function (i) {
                    return React.createElement(
                        'th',
                        null,
                        'item',
                        i + 1
                    );
                })
            );
        }
    }, {
        key: 'renderRules',
        value: function renderRules() {
            var _this = this;

            return this.state.rules.map(function (rule) {
                return React.createElement(Rule, _extends({}, rule, { maxItemsLength: _this.state.maxItemsLength }));
            });
        }
    }]);

    return RulesTable;
})(React.Component);

module.exports = RulesTable;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Store":13,"./Rule":14,"underscore":4}],16:[function(require,module,exports){
(function (global){
'use strict';

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var RulesTable = require('./components/RulesTable');
var Store = require('./Store');

/**
 * パンくず編集エディタ
 */
var BreadcrumbEditor = {
    init: function init(containerElement) {
        Store.initialize();

        React.render(React.createElement(RulesTable, null), containerElement);
    }
};

module.exports = BreadcrumbEditor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Store":13,"./components/RulesTable":15}],17:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

var globalData = require('../../Base/globalData');

/**
 * @constant
 */
var CONTAINER_CLASS = {
    user: 'module-category-sortable-container'
};
var ITEM_CLASS = {
    user: 'module-category-sortable-item'
};

/**
 * カテゴリモジュールの更新, sortable要素のセットアップ
 */

var CategoryEditor = (function () {
    function CategoryEditor() {
        _classCallCheck(this, CategoryEditor);

        this.categoryTemplate = _.template($('.js-categories-template').html());
        this.$categoryContainer = $('.js-categories-container');
    }

    _createClass(CategoryEditor, [{
        key: 'updateCategoryPreview',
        value: function updateCategoryPreview() {
            var _this = this;

            var orderType = $('.js-categories-order-type option:selected').val();

            // 並び順プレビュー
            $.ajax({
                url: this.$categoryContainer.data('getUrl'),
                data: {
                    order_type: orderType
                }
            }).done(function (data) {
                // data.categoriesは
                // { count : 記事数, name : カテゴリ名 }
                // 形式のカテゴリー情報からなる配列
                _this.$categoryContainer.html(_this.categoryTemplate({
                    categories: data.categories,
                    sortableContainerClass: CONTAINER_CLASS[orderType] || '',
                    sortableItemClass: ITEM_CLASS[orderType] || ''
                }));

                if (orderType === 'user') {
                    _this.setupSortable();
                }
            });
        }
    }, {
        key: 'setupSortable',
        value: function setupSortable() {
            var _this2 = this;

            var $sortableContainer = this.$categoryContainer.find('.js-categories-sortable');

            $sortableContainer.sortable({
                stop: function stop() {
                    var $sortedItems = _this2.$categoryContainer.find('.js-categories-sortable-item');

                    var sortedCategoryNames = $sortedItems.map(function (idx, element) {
                        return $(element).data('categoryName');
                    }).get();

                    $.ajax({
                        type: 'POST',
                        url: $sortableContainer.data('sortUrl'),
                        data: {
                            category_names: sortedCategoryNames,
                            rkm: globalData('rkm'),
                            rkc: globalData('rkc')
                        },
                        traditional: true
                    });
                }
            });
        }
    }]);

    return CategoryEditor;
})();

module.exports = CategoryEditor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/globalData":52,"underscore":4}],18:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

// ヘッダのinputの操作，更新するとupdatedイベント発行
// display_areaはPC版のみに存在し，touch版にはない．
// imageSize: {width, height}
var HeaderImage = function HeaderImage($container, imageSize) {
    var self = this;
    self.imageSize = imageSize;
    self.$container = $container;
    self.$image_src = $container.find('.js-image-src');
    self.$image_id = $container.find('.js-image-id');
    self.$display_area = $container.find('.js-display-area');
    _.defer(function () {
        // 初回，observeまだかもしれないので，ちょっと待つ
        self.updated();
    });
};
HeaderImage.prototype = {
    setImage: function setImage(src, id) {
        this.$image_src.val(src);
        this.$image_id.val(id);
        this.$display_area.val('');
        if (this.$display_area.length) {
            // トリミング位置あるときは，displayAreaが揃うまでは不完全な状態なのでupdateしない
        } else {
                // トリミング位置ないときはこの時点で完成なのでupdate
                this.updated();
            }
    },
    // displayArea: { x, y, x2, y2 }
    setDisplayArea: function setDisplayArea(area) {
        this.$display_area.val(JSON.stringify(area));
        this.updated();
    },
    // 画像を外す
    clear: function clear() {
        this.$image_src.val('');
        this.$image_id.val('');
        this.$display_area.val('');
        this.updated();
    },
    getImageSrc: function getImageSrc() {
        return this.$image_src.val();
    },
    getThumbnailSrc: function getThumbnailSrc() {
        return this.getImageSrc().replace(/\.(jpg|png|gif)$/, '_120.jpg');
    },
    getImageId: function getImageId() {
        return this.$image_id.val();
    },
    // displayArea: { x, y, x2, y2 }
    getDisplayArea: function getDisplayArea() {
        var value;
        try {
            value = JSON.parse(this.$display_area.val());
        } catch (ignore) {}
        return value;
    },
    // trimmingArea: [ x, y, x2, y2 ] TrimmingWindowに渡す形式
    // 指定されていないときは左上からコンストラクタで指定されたサイズ
    getTrimmingArea: function getTrimmingArea() {
        var area = this.getDisplayArea();
        if (area) {
            return [area.x, area.y, area.x2, area.y2];
        } else {
            return [0, 0, this.imageSize.width, this.imageSize.height];
        }
    },
    updated: function updated() {
        var self = this;
        $(self).triggerHandler('updated');
    }
};

module.exports = HeaderImage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],19:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var HeaderImagePreview = function HeaderImagePreview($container) {
    this.$container = $container;
    this.jcrop = $.Jcrop(this.$container.find('.js-header-image-thumbnail'), {
        bgOpacity: '0.4',
        addClass: 'jcrop-dark',
        allowSelect: false,
        allowResize: false,
        allowMove: false
    });
};

HeaderImagePreview.prototype = {
    // url: オリジナル画像のURL
    // thumbnailUrl: サムネイルのURL
    // (area): トリミング位置 {x, y, x2, y2}
    render: function render(url, thumbnailUrl, area) {
        var self = this;
        if (url) {
            self.jcrop.setImage(thumbnailUrl, function () {
                if (area) {
                    self.setArea(url, thumbnailUrl, area);
                }
            });
        } else if (area) {
            self.setArea(url, thumbnailUrl, area);
        }
        self.$container.show();
    },
    clear: function clear() {
        var self = this;
        self.$container.hide();
    },
    // 元画像とサムネイルのサイズからサムネイルの表示位置を決める
    setArea: function setArea(url, thumbnailUrl, area) {
        var self = this;

        Hatena.Diary.Util.loadImages([url, thumbnailUrl]).done(function (imgs) {
            var image = imgs[0];
            var thumbnail = imgs[1];

            var rateY = thumbnail.height / image.height;

            var thumbnailArea = [0, area.y * rateY, area.w, area.y2 * rateY];
            self.jcrop.setSelect(thumbnailArea);
        });
    }
};

module.exports = HeaderImagePreview;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],20:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var EditDesign = require('../EditDesign');

/**
 * テーマ、背景画像、背景色を変更したらCSSを更新する
 */
var ListItemSelector = {

    init: function init() {
        var $css = $('#css');

        // テーマ選択時の処理
        // テーマリスト内の要素をクリックしたらCSSを更新し、
        // クリックした要素に ui-selected クラスを付ける
        var themeListItems = $('#themes li');
        themeListItems.addClass('ui-selectee').on('click', function (e) {
            var $item = $(e.currentTarget);
            var link = $item.attr('data-css').replace(/\s+/g, ' ');
            var id = $item.attr('data-id');

            var design = new EditDesign($css.val());
            design.setData('theme', id, '@import "' + link + '";');
            $css.val(design.getCSS());
            $css.trigger('change');

            themeListItems.removeClass('ui-selected');
            $item.addClass('ui-selected');
        });

        var bgImageThumbnail = $('#background-image-thumbnail');
        var backgroundListItems = $('#backgrounds li');
        var backgroundColorListItems = $('#background-colors li');

        // 背景画像選択時の処理
        // テーマと同様
        backgroundListItems.addClass('ui-selectee').on('click', function (e) {
            var $item = $(e.currentTarget);
            var style = $item.attr('data-css').replace(/\s+/g, ' ');
            var id = $item.attr('data-id');

            var design = new EditDesign($css.val());
            design.setData('background', id, style);
            $css.val(design.getCSS());
            $css.trigger('change');

            backgroundListItems.removeClass('ui-selected');
            backgroundColorListItems.removeClass('ui-selected');
            $item.addClass('ui-selected');

            // アップロードした背景画像からもクラスを外す
            bgImageThumbnail.removeClass('ui-selected');
            $('input[name="bg-image-selected"]').val(0);
        });

        // 背景色選択時の処理
        // テーマと同様
        backgroundColorListItems.addClass('ui-selectee').on('click', function (e) {
            var $item = $(e.currentTarget);
            var style = $item.attr('data-css').replace(/\s+/g, ' ');
            var id = $item.attr('data-id');
            var design = new EditDesign($css.val());

            // カスタム背景画像が選択されていて，かつ，CSSに，背景画像の設定が書かれている場合は、background-colorだけ変える
            // CSSに既存の背景画像の設定が書かれていないときは単に背景色を設定する
            var backgroundContent = design.getData('background').content;
            if (bgImageThumbnail.hasClass('ui-selected') && backgroundContent) {
                style = backgroundContent.replace(/background-color:(.*?);/, 'background-color:#' + id + ';');

                id = 'custom';
            }
            backgroundListItems.removeClass('ui-selected');

            design.setData('background', id, style);
            $css.val(design.getCSS());
            $css.trigger('change');

            backgroundColorListItems.removeClass('ui-selected');
            $item.addClass('ui-selected');
        });

        // 現在設定されているテーマ、背景に ui-selected クラスを付ける
        var design = new EditDesign($css.val());

        var currentTheme = design.getData('theme').selected;
        if (currentTheme) {
            themeListItems.filter('[data-id="' + currentTheme + '"]').addClass('ui-selected');
        } else {
            themeListItems.removeClass('ui-selected');
        }

        var currentBackground = design.getData('background').selected;
        if (currentBackground) {
            $('#backgrounds, #background-colors').find('[data-id="' + currentBackground + '"]').addClass('ui-selected');
        } else {
            backgroundListItems.removeClass('ui-selected');
        }
    }

};

module.exports = ListItemSelector;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../EditDesign":26}],21:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Locale = require('../../Locale');

var EventEmitter = require('events').EventEmitter;

/**
 * デザイン設定画面のモジュール1つを表す
 * モジュールは，type, title, valueの組で表される
 *
 * @property {jQuery} $element - .module クラスを持つDOM要素
 * @property {string} type     - "profile"とか
 * @property {string} title    - モジュールのタイトル
 * @property {Object} value
 */

var Module = (function (_EventEmitter) {
    _inherits(Module, _EventEmitter);

    function Module($element) {
        var _this = this;

        _classCallCheck(this, Module);

        _get(Object.getPrototypeOf(Module.prototype), 'constructor', this).call(this);

        this.$element = $element;

        this.type = this.$element.find('input.js-module-type').val();
        this.title = this.$element.find('input.js-module-title').val();
        this.value = {};

        try {
            this.value = JSON.parse(this.$element.find('input.js-module-value').val());
        } catch (ignore) {}

        this.$element.on('click', '.js-edit-module', function () {
            _this.edit();
            return false;
        }).on('click', '.js-remove-module', function () {
            if (confirm(Locale.text('blog.confirm.delete'))) {
                _this.remove();
            }
            return false;
        });
    }

    /**
     * DOMに属さない新たなモジュールを作って返す
     * modulesType: "sidebar"など，モジュールの配置される場所
     * @static
     * @param {string} position
     */

    /**
     * editイベントを発行する
     * modulesがこのイベントを見て編集UIを出す
     */

    _createClass(Module, [{
        key: 'edit',
        value: function edit() {
            this.emit('edit');
        }

        /**
         * elementを消し，removedイベントを発行する
         * modulesがこのイベントを見てプレビュー更新してくれる
         */
    }, {
        key: 'remove',
        value: function remove() {
            this.$element.remove();
            this.emit('removed');
        }

        /**
         * 指定された値に更新し描画
         * @param {string} type
         * @param {string} title
         * @param {string} value
         */
    }, {
        key: 'update',
        value: function update(type, title, value) {
            this.type = type;
            this.title = title;
            this.value = value;
            this.render();
            this.emit('updated');
        }

        /**
         * 新たに追加中のモジュール？
         * @returns {boolean}
         */
    }, {
        key: 'isNewModule',
        value: function isNewModule() {
            return this.isNew;
        }

        /**
         * 新たに追加中のモジュール状態にする
         */
    }, {
        key: 'setAsNewModule',
        value: function setAsNewModule() {
            this.isNew = true;
            this.$element.addClass('created');
        }

        /**
         * 新たに追加中のモジュール状態を解除する
         */
    }, {
        key: 'unsetAsNewModule',
        value: function unsetAsNewModule() {
            this.isNew = false;
            this.$element.removeClass('created');
        }

        /**
         * 編集中(選択中)のモジュール状態にする
         */
    }, {
        key: 'setAsSelected',
        value: function setAsSelected() {
            this.$element.addClass('selected');
        }

        /**
         * 編集中(選択中)のモジュール状態を解除する
         */
    }, {
        key: 'unsetAsSelected',
        value: function unsetAsSelected() {
            this.$element.removeClass('selected');
        }

        /**
         * 描画．既存のelementを書き換える．
         * inputの設定，クラスの追加，表示用のラベルの設定
         */
    }, {
        key: 'render',
        value: function render() {
            this.$element.find('input.js-module-type').val(this.getType());
            this.$element.find('input.js-module-title').val(this.getTitle());
            this.$element.find('input.js-module-value').val(this.getValueAsJSON());
            this.$element.addClass(this.getType()); // このクラスは何のために使っている？
            this.$element.find('.title, .clipped-content').text(this.getTitleForPreview());
        }

        /**
         * @returns {string}
         */
    }, {
        key: 'getType',
        value: function getType() {
            return this.type;
        }

        /**
         * @returns {string}
         */
    }, {
        key: 'getTitle',
        value: function getTitle() {
            return this.title;
        }

        /**
         * @returns {string}
         */
    }, {
        key: 'getValue',
        value: function getValue() {
            return this.value;
        }

        /**
         * @returns {jQuery}
         */
    }, {
        key: 'getElement',
        value: function getElement() {
            return this.$element;
        }

        /**
         * 表示用のタイトル．
         * タイトルか，HTMLモジュールのときは本文の先頭か，HTMLモジュールのときは"HTML"
         * @returns {string}
         */
    }, {
        key: 'getTitleForPreview',
        value: function getTitleForPreview() {
            var title = this.getTitle();
            if (!title && this.getType() === 'html') {
                title = this.removeTag(this.value['module-value'] || '') || Locale.text('blog.module.html');
            }
            return title;
        }

        /**
         * valueは，inputにはJSON化して格納する
         * @returns {string}
         */
    }, {
        key: 'getValueAsJSON',
        value: function getValueAsJSON() {
            return JSON.stringify(this.value);
        }

        /**
         * HTML文字列からタグっぽい箇所を削除する
         * @param {string} html
         * @returns {string}
         */
    }, {
        key: 'removeTag',
        value: function removeTag(html) {
            return html.replace(/<.*?>/g, '');
        }
    }]);

    return Module;
})(EventEmitter);

Module.initializeWithModulesPosition = function (position) {
    var template = $('.new-module-template').html();
    var moduleHtml = _.template(template)({ position: position });
    var $element = $($.parseHTML(moduleHtml));

    return new Module($element);
};

module.exports = Module;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Locale":151,"events":1,"underscore":4}],22:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// moduleの編集モーダルウィンドウ
// 編集と追加でDOMは共通で，hide-radiosというクラスを付与すると，パネル選択UIが消える
var ModuleEditor = function ModuleEditor($modalWindow) {
    var self = this;
    self.$modalWindow = $modalWindow;

    // $modalWindowはposition: relative内に入ってる．overlayは画面全体を覆ってほしいので，bodyの末尾にappendし直す
    self.$modalWindow.appendTo(document.body);

    self.$dialogBox = self.$modalWindow.find('.dialog-box'); // モーダルで出てくるboxの本体
    self.$dialogOverray = self.$modalWindow.find('.dialog-overray');
    self.$applyButton = self.$modalWindow.find('.submit button.apply');
    self.$cancelButton = self.$modalWindow.find('.submit button.cancel');
    self.$radios = self.$modalWindow.find('.radios');

    // sessionはモーダル表示中に有効．保存でresolve，キャンセルでreject
    // 初回だけsessionないと難しいので，ダミーの値を入れておく
    self.session = $.Deferred();
    self.session.reject();

    self.init();
};

ModuleEditor.prototype = {
    init: function init() {
        var self = this;

        // 新規モジュール追加時はモジュールのタイプを選べるので，changeイベントを見る
        self.$radios.find('input:radio').change(function () {
            var $checked = self.$radios.find('input:radio:checked');
            var type = $checked.val();
            self.selectPanelByType(type);
        });

        // IEではchangeイベントが発行されないので，clickイベントを見る
        self.$modalWindow.find('.radio').click(function () {
            var type = $(this).find('input:radio').val();
            self.selectPanelByType(type);
        });

        // リンクモジュール，リンクを1行追加
        self.$modalWindow.find('#module-value-component-link').each(function () {
            var $linkModule = $(this);
            $linkModule.find('#add-link-input-button').click(function () {
                var $linkInput = $linkModule.find('.link-input').eq(0).clone();
                $linkInput.find(':input').val('');
                $linkInput.insertAfter($linkModule.find('.link-input').eq(-1));

                var $scrolled = self.$modalWindow.find('.module-value-box-inner');
                $scrolled.scrollTop($scrolled[0].scrollHeight);
            });
        });

        // リンクを削除
        self.$modalWindow.delegate('.delete-link-input-button', 'click', function () {
            // 追加するとき，1件目をcloneするので，最後の1件だけは消せないようになってる．
            if (self.$modalWindow.find('.link-input').length > 1) {
                $(this).closest('.link-input').remove();
            }
            return false;
        });

        // セッション終了イベントの監視
        self.$applyButton.click(function () {
            self.applyEdit();
        });
        self.$dialogOverray.click(function () {
            self.cancelEdit();
        });
        self.$cancelButton.click(function () {
            self.cancelEdit();
        });
        $(window).keyup(function (e) {
            if (keyString(e) == 'S-ESC') {
                self.cancelEdit();
            }
        });

        // カテゴリーモジュール
        self.$modalWindow.find('.js-categories-order-type').change(function () {
            $(self).triggerHandler('change-category-order-type');
        });
    },
    // 新規モジュール追加
    editNewModule: function editNewModule(module) {
        var self = this;
        self.session.reject();
        self.session = $.Deferred();
        self.editingModule = module;

        self.setupValues();

        // 追加のときはcreatedクラスを足し，hide-radiosクラスを消し，キャンセルボタンを隠す
        self.$modalWindow.addClass('created').removeClass('hide-radios');
        self.$cancelButton.show();

        self.show();

        return self.session.promise();
    },
    // 既存のモジュールの編集
    editModule: function editModule(module) {
        var self = this;
        self.session.reject();
        self.session = $.Deferred();
        self.editingModule = module;

        self.setupValues();

        // 編集のときはcreatedクラスを消し，hide-radiosクラスを足し，キャンセルボタンを隠す
        self.$modalWindow.removeClass('created').addClass('hide-radios');
        self.$cancelButton.hide();

        self.selectPanelByType(module.getType());

        self.show();

        self.fillValuesFromModule(module);

        // カテゴリモジュールは既定のorder_typeでプレビューをセット
        // module.value['order_type']
        $(self).triggerHandler('edit-new-module');

        return self.session.promise();
    },
    // 指定されたtypeのパネルを選択し，表示する
    // type: "profile", "html"など
    selectPanelByType: function selectPanelByType(type) {
        var self = this;

        self.$radios.find('.radio').removeClass('selected');
        var $selected_label = self.$radios.find('.radio.module-' + type).closest('.radio');
        $selected_label.addClass('selected');
        // propではchangeイベントが発火しないことによって無限ループせずに済んでる
        $selected_label.find('input:radio').prop('checked', true);

        self.$modalWindow.find('.module-value-component').hide();
        self.$modalWindow.find('#module-value-component-' + type).show();
    },
    // 現在選択中のパネルのtypeを返す．未選択ならnull
    getSelectedPanelType: function getSelectedPanelType() {
        var self = this;
        var $selected = self.$radios.find('input:enabled:checked');
        if ($selected.length) {
            return $selected.val();
        } else {
            return null;
        }
    },
    // モーダルウィンドウ内のinputを初期状態に戻す．
    // モーダルウィンドウは1つだけ存在し，使い回されるので，初期化しないと，前回のモジュールの編集内容が出てくることになる．
    setupValues: function setupValues() {
        var self = this;

        // textを空にする
        self.$modalWindow.find('textarea, input[type=text], input[type=number]').val('');
        // チェックボックスのチェックを外す
        self.$modalWindow.find('input[type=checkbox]').prop('checked', false);

        // セレクトボックスの値をデフォルトに初期化する
        // もしも「data-default-option」属性でデフォルトの値が指定されている場合はそれに従う
        self.$modalWindow.find('select').each(function () {
            if ($(this).attr('data-default-option')) {
                // デフォルト値が設定されていた場合
                $(this).val($(this).attr('data-default-option'));
            } else {
                // デフォルト値の設定がない場合は，一番初めの要素を選択状態にする
                $(this).find('option:first').prop('selected', true);
            }
        });

        // なにも選択されていなかったら，最初のペインを選択
        if (!self.getSelectedPanelType()) {
            self.selectPanelByType('profile');
        }
    },
    // ウィンドウを表示する
    show: function show() {
        var self = this;

        // サイドバー内を下までスクロールして追加した要素を見せる
        var $scrolled = $('#tab-customize');
        $scrolled.scrollTop($scrolled[0].scrollHeight);

        self.$modalWindow.show();
        self.setPosition();
        self.$dialogBox.find('input[type=text]:visible:first').focus();
    },
    // モーダルウィンドウを中央揃えにする
    setPosition: function setPosition() {
        var self = this;
        var winHeight = $(document).height();
        var winWidth = $(window).width();
        var dialogTop = winHeight / 2 - self.$dialogBox.height() / 2;
        var dialogLeft = winWidth / 2 - self.$dialogBox.width() / 2;
        self.$dialogBox.css({ top: dialogTop, left: dialogLeft });
        self.$dialogOverray.css({ height: winHeight, width: winWidth });
    },
    // 変更を適応する．inputからモジュールを表す表現を作り，sessionをresolveする．
    applyEdit: function applyEdit() {
        var self = this;
        var data = self.extractInputToModuleValues();
        self.session.resolve(data);
        self.hide();
    },
    // 編集セッションを終了してウィンドウを隠す
    cancelEdit: function cancelEdit() {
        var self = this;
        self.session.reject();
        self.hide();
    },
    // モーダルウィンドウを隠す
    hide: function hide() {
        var self = this;
        self.$modalWindow.hide();
    },
    // モジュール編集のとき，モジュールの値をウィンドウにコピー
    // :visibleを見てるのでshow()したあとに呼ぶ必要がある
    fillValuesFromModule: function fillValuesFromModule(module) {
        var self = this;
        var val = module.getValue();
        var moduleType = module.getType();
        for (var name in val) {

            if (moduleType === 'link' && (name === 'link_title' || name === 'link_url')) {
                self.setLinkInput(self.$dialogBox, val, name);
            } else {
                var $inputs = self.$dialogBox.find(':input:visible').filter(function () {
                    return $(this).attr('name') == name;
                });
                $inputs.eq(0).val(val[name]);
                if ($inputs.eq(0).attr('type') == 'checkbox' && val[name]) {
                    $inputs.eq(0).prop('checked', true);
                }
            }
        }
        // module-valueにmodule-titleが入っていることもあるのでタイトルは後から設定
        self.$dialogBox.find('input[name=module-title]:visible').val(module.getTitle());
    },
    extractInputToModuleValues: function extractInputToModuleValues() {
        // ウィンドウ内のinputの値をモジュール用の表現に変換して返す
        var self = this;

        var moduleTitle = self.$dialogBox.find('input[name=module-title]:visible').val();

        // モジュールタイプは，新しいモジュール追加するときはDOMから拾う
        // 編集時は，編集中のmoduleオブジェクトのtypeを引き継ぐ
        var moduleType;
        if (self.editingModule.isNewModule()) {
            moduleType = self.getSelectedPanelType();
        } else {
            moduleType = self.editingModule.getType();
        }
        var moduleValue = {};

        // タイトルが未記入の場合、初期値を埋める(HTMLモジュールは埋めない)
        if (!moduleTitle && moduleType !== 'html') {
            var defaultTitle = self.$radios.find('input:checked').attr('data-default-module-title');
            moduleTitle = defaultTitle;
        }

        self.$dialogBox.find(':input:visible').each(function () {
            var $input = $(this);
            var name = $input.attr('name');
            var val = $input.val();

            // module-titleのinputもdialogBox内に存在するが，
            // タイトルは別のinputに保存するため，ここではスキップする
            if (name === 'module-title') {
                return;
            }

            if ($input.attr('type') == 'checkbox') {
                if ($input.prop('checked')) {
                    val = 1;
                } else {
                    val = 0;
                }
            }

            if (!name) {
                return;
            }
            // 同じ名前の値が複数来たらarrayにする
            if (typeof moduleValue[name] === 'undefined') {
                moduleValue[name] = val;
            } else if (moduleValue[name] instanceof Array) {
                moduleValue[name].push(val);
            } else {
                moduleValue[name] = [moduleValue[name], val];
            }
        });

        return {
            type: moduleType,
            title: moduleTitle,
            value: moduleValue
        };
    },
    // リンクモジュールのフィルイン
    // リンクモジュールはフィールド一つでタイトル全部 / URL全部を表す．link-titleとlink-value．
    setLinkInput: function setLinkInput($dialogBox, val, name) {
        var $inputs = $dialogBox.find(':input:visible').filter(function () {
            return $(this).attr('name') == name;
        });
        var $linkInput;
        if (val[name] instanceof Array) {
            var addInput = val[name].length > $inputs.length ? true : false;
            var diff = addInput ? val[name].length - $inputs.length : $inputs.length - val[name].length;

            for (var i = 0; i < diff; i++) {
                if (addInput) {
                    $linkInput = $dialogBox.find('.link-input:visible').eq(0).clone();
                    $linkInput.find(':input').val('');
                    $linkInput.insertAfter($dialogBox.find('.link-input').eq(-1));
                } else {
                    $linkInput = $dialogBox.find('.link-input:visible').eq(-1);
                    $linkInput.remove();
                }
            }
            $inputs = $dialogBox.find(':input:visible').filter(function () {
                return $(this).attr('name') == name;
            });
            $inputs.each(function () {
                $(this).val(val[name].shift());
            });
        } else {
            // 1つしか要素がない場合、inputを１つにする
            while ($inputs.length > 1) {
                $linkInput = $dialogBox.find('.link-input:visible').eq(-1);
                $linkInput.remove();
                $inputs = $dialogBox.find(':input:visible').filter(function () {
                    return $(this).attr('name') == name;
                });
            }
            $inputs.eq(0).val(val[name]);
        }
    }
};

module.exports = ModuleEditor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],23:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Module = require('./Module');

// モジュール置き場(全体のサイドバー、トップページのメインカラムなど)に付きひとつできる
// $elementはdiv[data-modules-type="sidebar"].sidebar-boxなど
// editorは ModuleEditorのインスタンス
var Modules = function Modules($element, editor) {
    var self = this;
    self.$element = $element;
    self.editor = editor;
    self.init();
};

Modules.prototype = {
    init: function init() {
        var self = this;

        // "sidebar"など，このモジュール置き場の位置
        self.position = self.$element.attr('data-modules-type');

        self.modules = [];

        // 追加ボタン押したらモジュール追加
        self.$element.on('click', '.js-add-module', function () {
            self.addNewModule();
            return false;
        });

        self.$element.find('.module').each(function () {
            self.addModuleFromElement($(this));
        });

        // 並べ替え可能にする．終わったらupdate
        self.$element.find('.modules').sortable({
            containment: 'parent',
            stop: function stop() {
                self.onSorted();
            }
        });
    },
    // 既存のDOM要素からモジュールを作り監視を始める
    addModuleFromElement: function addModuleFromElement($element) {
        var self = this;
        var module = new Module($element);
        self.awareModule(module);
        module.render();
    },
    // モジュールのイベントを監視する
    awareModule: function awareModule(module) {
        var self = this;
        self.modules.push(module);
        module.on('removed', function () {
            self.onModuleRemoved(module);
        }).on('updated', function () {
            self.onUpdated();
        }).on('edit', function () {
            self.editModule(module);
        });
    },
    // 並び順が変わったらself.modulesも追従する．DOMから.modulesを取ってきて，getElementして要素が一致したものを選ぶ．
    onSorted: function onSorted() {
        var self = this;

        var sortedModules = self.$element.find('.module').map(function () {
            var element = this;

            var matchedModule = _.find(self.modules, function (module) {
                return module.getElement()[0] === element;
            });

            return matchedModule;
        }).toArray();

        self.modules = sortedModules;

        self.onUpdated();
    },
    // モジュールが消えたら，modulesから消して，updatedメソッドを発行
    onModuleRemoved: function onModuleRemoved(module) {
        var self = this;
        self.modules = _.difference(self.modules, [module]);
        self.onUpdated();
    },
    // 既存のモジュールの編集．editorの呼び出し，完了時に更新，失敗したら何もしない
    editModule: function editModule(module) {
        var self = this;
        var session = self.editor.editModule(module);
        module.setAsSelected();
        session.done(function (data) {
            // data の更新
            module.update(data.type, data.title, data.value);
        }).always(function () {
            module.unsetAsSelected();
        });
    },
    // 新しいモジュールを追加する．DOMの追加，editorの呼び出し，完了時に更新，失敗したら消す
    addNewModule: function addNewModule() {
        var self = this;
        var module = Module.initializeWithModulesPosition(self.position);
        module.setAsNewModule();
        module.setAsSelected();
        self.$element.find('.modules').append(module.getElement());
        var session = self.editor.editNewModule(module);
        session.done(function (data) {
            self.awareModule(module);
            module.update(data.type, data.title, data.value);
            module.unsetAsNewModule();
            module.unsetAsSelected();
        }).fail(function () {
            module.remove();
        });
    },
    // updatedイベントを発行する．外で待ち構えてプレビューの更新などを行う
    onUpdated: function onUpdated() {
        var self = this;
        $(self).triggerHandler('updated');
    }
};

module.exports = Modules;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Module":21,"underscore":4}],24:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('../../Base/globalData');

var PreviewUpdater = function PreviewUpdater(args) {
    var self = this;
    self.$form = args.$form;
    self.$loading = args.$loading;
    self.$preview = args.$preview;
    self.formState = args.formState;
    self.$deviceInput = self.$form.find(':input[name=device]');
    self.device = self.$deviceInput.val();
    self.pageType = 'index';
    self.failedCount = 0;
};

PreviewUpdater.prototype = {
    // トップページをプレビューする状態にする
    setAsIndexPreview: function setAsIndexPreview() {
        var self = this;
        self.pageType = 'index';
    },
    // エントリページをプレビューする状態にする
    setAsPermalinkPreview: function setAsPermalinkPreview() {
        var self = this;
        self.pageType = 'permalink';
    },
    getPageType: function getPageType() {
        var self = this;
        return self.pageType;
    },
    // PC版プレビュー状態にする
    setDeviceAsPC: function setDeviceAsPC() {
        var self = this;
        self._setDevice('pc');
    },
    // touch版プレビュー状態にする
    setDeviceAsTouch: function setDeviceAsTouch() {
        var self = this;
        self._setDevice('touch');
    },
    // 内部的なプレビュー状態切り替え
    // inputの値設定，プレビュー更新を依頼
    _setDevice: function _setDevice(device) {
        var self = this;
        self.device = device;
        self.$deviceInput.val(self.device);
        self.requestPreview();

        // touchのとき，iframeに.device=touchクラス追加
        self.$preview.toggleClass('device-touch', device === 'touch');
    },
    // previewの更新を依頼する．formの状態が変わっていなければ何もしない
    requestPreview: function requestPreview() {
        var self = this;

        var serialized = self.$form.serialize();
        if (serialized === self.serialized) return;
        self.serialized = serialized;

        self.preview();
    },
    // previewを更新する．失敗したらやり直し．あまりに失敗したらもうなにもしない．
    preview: function preview() {
        var self = this;

        if (self.failedCount > 10) return;

        self.showEffect();

        if (!self.serialized) {
            self.serialized = self.$form.serialize();
        }
        var serialized = self.serialized;

        var getSignature = self.getSignature(serialized);
        getSignature.done(function (signature) {
            self.onGotSignature(signature);
            self.failedCount = 0;
        }).fail(function () {
            self.failedCount++;
            self.requestPreview();
        });
    },
    // signatureゲットしたらresolveするDeferredを返す
    getSignature: function getSignature(serialized) {
        var self = this;

        var got = $.Deferred();

        $.ajax({
            url: '../../preview/design',
            type: "post",
            dataType: 'json',
            data: serialized
        }).done(function (data) {
            // 通信してる間に状態が変わっていなければ成功，変わってたら失敗
            if (serialized === self.$form.serialize()) {
                got.resolve(data.signature);
            } else {
                got.reject();
            }
        }).fail(function () {
            got.reject();
        });

        return got.promise();
    },
    // signature揃ったので実際にプレビュー
    // formのactionとtargetを書き換えて，signatureを追加してsubmitし，即座に元の状態に戻している．
    onGotSignature: function onGotSignature(signature) {
        var self = this;

        // iframe内のJSでwindow.nameが書き換えられているとsubmit先のwindowがなくなってポップアップが開いてしまうので，毎回作り直す
        var $previewIframe = $('#preview-iframe');
        var $newPreviewIframe = $previewIframe.clone();
        $previewIframe.replaceWith($newPreviewIframe);
        self.$preview = $newPreviewIframe;

        var $form = self.$form;

        var actionBefore = $form.attr('action');
        var targetBefore = $form.attr('target');
        var confirmEnabledBefore = self.formState.isConfirmEnabled();

        $form.attr('action', self.getAction());
        $form.attr('target', self.$preview.attr('name'));
        var $signature = $('<textarea/>').attr('name', 'signature').val(signature);
        $signature.appendTo($form);

        self.formState.disableConfirm();
        $form.submit();

        $signature.remove();
        $form.attr('action', actionBefore);
        $form.attr('target', targetBefore);

        if (confirmEnabledBefore) {
            self.formState.enableConfirm();
        } else {
            self.formState.disableConfirm();
        }
    },
    // 読み込み中出してしばらく知たら消す(雑)
    showEffect: function showEffect() {
        var self = this;
        self.$loading.fadeIn('fast');
        setTimeout(function () {
            self.$loading.fadeOut('fast');
        }, 1000);
    },
    // プレビューエンドポイント．indexとpermalinkのどちらか．
    getAction: function getAction() {
        var self = this;
        var base = globalData('blogs-uri-base');
        return base + '/preview/' + self.pageType + '_design';
    }
};

module.exports = PreviewUpdater;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/globalData":52}],25:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Window = require('../../Base/Window');

// ヘッダ画像トリミングするモーダルウィンドウ
var TrimmingWindow = function TrimmingWindow($container) {
    this.$container = $container;
    this.init();
};
TrimmingWindow.prototype = {
    init: function init() {
        var self = this;
        // ページの末尾に移動する
        self.$container.appendTo(document.body);

        // sessionはトリミング中有効なDeferred，doneでトリミング成功，rejectで失敗
        self.session = $.Deferred();
        self.session.reject();

        self.jcrop = $.Jcrop(self.$container.find('.js-header-image-resizer'), {
            bgOpacity: '0.4',
            addClass: 'jcrop-dark',
            allowSelect: false,
            keySupport: false,
            allowResize: false
        });

        self.$container.on('click', '.js-header-image-apply-button', function () {
            self.save();
            return false;
        }).on('click', '.js-header-image-cancel-button', function () {
            self.cancel();
            return false;
        });
    },
    // 指定したURLの画像をトリミングする
    // returns: トリミング成功したらdone, キャンセルされたらrejectされるDeferred
    trim: function trim(url, area) {
        var self = this;
        self.cancel();
        self.session = $.Deferred();
        self.session.always(function () {
            self._hide();
        });

        self.jcrop.setImage(url, function () {
            self.jcrop.setSelect(area);
            self._show();
        });

        return self.session.promise();
    },
    // 以下は直接呼ぶことはないであろう
    save: function save() {
        var self = this;
        self.session.resolve(self.jcrop.tellSelect());
    },
    cancel: function cancel() {
        var self = this;
        self.session.reject(self.jcrop.tellSelect());
    },
    _show: function _show() {
        var self = this;
        Window.show(self.$container, {
            center: true,
            showBackground: true,
            closeExplicitly: true
        });
    },
    _hide: function _hide() {
        var self = this;
        Window.hide(self.$container);
    }
};

module.exports = TrimmingWindow;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/Window":49}],26:[function(require,module,exports){
'use strict';

var EditDesign = function EditDesign() {
    this.init.apply(this, arguments);
};
EditDesign.prototype = {
    init: function init(css) {
        var self = this;
        self.data = {};
        self.setCSS(css);
    },

    setCSS: function setCSS(css) {
        var self = this;
        self.css = css;
        self.scanCSS(function (attrs, content) {
            var section = attrs['section'];
            delete attrs['section'];
            attrs.content = content;
            self.data[section] = attrs;
        });
    },

    getCSS: function getCSS() {
        var self = this;
        var done = {};
        var css = this.scanCSS(function (attrs, content) {
            var section = attrs.section;
            if (done[section]) return '';

            var index = self.indexOf(section);

            var ret = self.getSectionAsCSS(section);
            done[section] = true;

            for (var i = 0, len = index || EditDesign.sections.length; i < len; i++) {
                section = EditDesign.sections[i];
                if (done[section]) continue;
                ret = self.getSectionAsCSS(section) + ret;
                done[section] = true;
            }

            return ret;
        });

        var rest = [];
        for (var key in self.data) if (self.data.hasOwnProperty(key)) rest.push(key);
        rest.sort(function (a, b) {
            return self.indexOf(a) - self.indexOf(b);
        });

        for (var i = 0, it; it = rest[i]; i++) {
            var section = it;
            if (!done[section]) {
                css += self.getSectionAsCSS(section);
            }
        }

        return css.replace(/^\s+|\s+$/g, '');
    },

    getSectionAsCSS: function getSectionAsCSS(section) {
        var self = this;
        if (!self.data[section]) return '';
        var selected = self.data[section].selected;
        var content = self.data[section].content;
        return '\n/* <system section="' + section + '" selected="' + selected + '"> */\n' + content + '\n/* </system> */\n';
    },

    indexOf: function me(section) {
        if (!me.map) {
            me.map = {};
            for (var i = 0, len = EditDesign.sections.length; i < len; i++) {
                me.map[section] = i;
            }
        }
        return me.map[section];
    },

    scanCSS: function scanCSS(callback) {
        return this.css.replace(/\n?\/\* <system([^>]+)> \*\/\n*([\s\S]+?)\n*\/\* <\/system> \*\/\n?/g, function (_, attributes, content) {
            var attrs = {};attributes.replace(/(\S+)="([^"]+)"/g, function (_, key, val) {
                attrs[key] = val;
            });
            var ret = callback(attrs, content);
            return typeof ret == 'undefined' ? _ : ret;
        });
    },

    getData: function getData(section) {
        return this.data[section] || {};
    },

    setData: function setData(section, selected, content) {
        this.data[section] = {
            selected: selected,
            content: content
        };
        delete this.indexOf.me;
    }
};

EditDesign.sections = ['theme', 'background'];

module.exports = EditDesign;

},{}],27:[function(require,module,exports){
'use strict';

var ProgressWatcher = require('./ProgressWatcher');

var ProgressBar = {

    /**
     * @param {jQuery} $bar          - プログレスバー
     * @param {string} apiUrl        - 定期的に叩くAPI
     * @param {string} onCompleteUrl - インポート完了時に遷移するURL
     */
    init: function init($bar, apiUrl, onCompleteUrl) {
        // 進捗を監視する
        var watcher = new ProgressWatcher(apiUrl);

        watcher.on('progress', function (progress) {
            $bar.css('width', progress + '%');
        });

        watcher.on('complete', function () {
            setTimeout(function () {
                location.href = onCompleteUrl;
            }, 1500);
        });
    }

};

module.exports = ProgressBar;

},{"./ProgressWatcher":28}],28:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var EventEmitter = require('events').EventEmitter;

/**
 * 定期的にAPIを叩いて進捗報告するクラス
 * インポート画面で使う
 */

var ProgressWatcher = (function (_EventEmitter) {
    _inherits(ProgressWatcher, _EventEmitter);

    /**
     * @param {string} api_url - 定期的にアクセスされるURL
     */

    function ProgressWatcher(url) {
        _classCallCheck(this, ProgressWatcher);

        _get(Object.getPrototypeOf(ProgressWatcher.prototype), 'constructor', this).call(this);
        this.url = url;

        this.checkProgress();
    }

    /**
     * 進捗APIを叩く
     */

    _createClass(ProgressWatcher, [{
        key: 'checkProgress',
        value: function checkProgress() {
            var _this = this;

            $.ajax({
                url: this.url,
                type: 'GET',
                cache: false,
                dataType: 'json'
            }).done(function (res) {
                _this.handleResponse(res);
            });
        }

        /**
         * APIからのresponseを扱う
         * @param {string} res.status   - started|new|complete|failed
         * @param {number} res.progress - 0~100
         */
    }, {
        key: 'handleResponse',
        value: function handleResponse(res) {
            var _this2 = this;

            if (res.progress) {
                this.emit('progress', res.progress);
            }

            if (res.status === 'complete' || res.status === 'failed') {
                this.emit('complete');
            }
            if (res.status === 'started' || res.status === 'new') {
                setTimeout(function () {
                    return _this2.checkProgress();
                }, 1000);
            }
        }
    }]);

    return ProgressWatcher;
})(EventEmitter);

module.exports = ProgressWatcher;

},{"events":1}],29:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var positionToString = require('../Util/positionToString');
var waitForResource = require('../Util/waitForResource');

// 投稿時の共有するボタンに関連した処理を扱う
var SocializeBox = {
    setup: function setup(entry_id) {
        var self = this;

        self.entry_id = entry_id;

        // 現在の認証情報を保存しておく
        self.saveExternalAuthorizeConfig();

        // 外部連携設定用
        self.setupExternalAuthLink();
    },
    setupExternalAuthLink: function setupExternalAuthLink() {
        var self = this;

        // Bパターンのみ、連携リンクやボタンクリックで新しいwindowが開くように
        var external_auth_href = $('html').attr('data-admin-domain') + "/-/config/external?with_parent_window=1";
        $(document).on('click', '[data-open-external-auth-link=1]', function (e) {
            e.preventDefault();

            var options = { width: 900, height: 600, scrollbars: 'yes' };
            options.left = Math.floor((screen.width - options.width) / 2);
            options.top = Math.floor((screen.height - options.height) / 2);
            var external_auth_window = window.open(external_auth_href, 'external_auth', positionToString(options));

            // 連携完了したらwindowが閉じられるので監視
            // ソーシャルボタンの状態更新をする
            waitForResource(function () {
                return external_auth_window.closed;
            }, function () {
                var $modal = $('.js-socialize-modal');
                // modalがあったら閉じる
                if ($modal.length > 0) {
                    $modal.hide();
                    $('.modal-window-background').fadeOut('fast');
                }

                // 連携情報を再取得し、更新
                self.getExternalAuthStatus().done(function (html) {
                    // 再度連携設定する人がいるかもしれないので最新の情報を保存しておく
                    self.saveExternalAuthorizeConfig();

                    self.refreshSocializeBox(html);

                    var isAuthorized = self.isExternalAuthorizeFinished();
                    if (isAuthorized) {
                        // 連携完了したら適切なメッセージを表示
                        var $external_auth_message = $('.js-socialize-box .js-external-auth-message');
                        var $external_auth_finish_message = $('.js-socialize-box .js-external-auth-finish-message');
                        $external_auth_message.hide();
                        $external_auth_finish_message.show();
                    }
                });
            });

            return false;
        });
    },
    refreshSocializeBox: function refreshSocializeBox(html) {
        $('.js-refresh-socialize-box').empty().html(html);
    },
    saveExternalAuthorizeConfig: function saveExternalAuthorizeConfig() {
        // 認証情報を保存しておく
        // 後で連携完了したか確認する時に使う
        this.externalAuthorizeConfig = {
            twitter: $('.js-authenticated-twitter').size() == 1,
            facebook: $('.js-authenticated-facebook').size() == 1,
            mixi: $('.js-authenticated-mixi').size() == 1
        };
    },
    // 保存しておいて認証情報と比較して変わっていた場合はtrueを返す
    isExternalAuthorizeFinished: function isExternalAuthorizeFinished() {
        var config = this.externalAuthorizeConfig;

        return config.twitter === false && $('.js-authenticated-twitter').size() == 1 || config.facebook === false && $('.js-authenticated-facebook').size() == 1 || config.mixi === false && $('.js-authenticated-mixi').size() == 1;
    },
    // 外部連携情報を取得する
    getExternalAuthStatus: function getExternalAuthStatus() {
        var dfd = $.Deferred();
        $.ajax({
            url: 'socialize_box',
            type: 'GET',
            dataType: 'html',
            data: { entry_id: this.entry_id }
        }).done(function (data) {
            dfd.resolve(data);
        }).fail(function () {
            dfd.reject();
        });

        return dfd.promise();
    }
};

module.exports = SocializeBox;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Util/positionToString":173,"../Util/waitForResource":181}],30:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// Hatena.Diary.AccessLog
// XXX: window.AccessLogとは別なので注意
// XXX: 2箇所でしか使われてないし要らないのでは?
var AccessLog = {
    ping: function ping() {
        var adminDomain = $('html').attr('data-admin-domain');
        if (!adminDomain) return;

        var url = adminDomain + '/api/log';
        var data = {
            uri: location.href,
            referer: document.referrer
        };
        $.ajax({
            url: url,
            type: "get",
            cache: false,
            data: data,
            xhrFields: {
                withCredentials: true
            }
        }).fail(function (e) {
            data._ = new Date().getTime();
            new Image().src = url + '?' + $.param(data);
        });
    }
};

module.exports = AccessLog;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],31:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var match = function match(str) {
    return navigator.userAgent.indexOf(str) !== -1;
};

// https://github.com/wakaba/opentenjs/blob/master/src/Ten.base.js
var Browser = {
    isIE: match('MSIE') || match('Trident/'),
    isIE6: match('MSIE 6.'),
    isIE7: match('MSIE 7.'),
    isIE8: match('MSIE 8.'),
    isIE9: match('MSIE 9.'),
    isIE10: match('MSIE 10.'),
    isIE11: match('Trident/') && match('rv:11.'),
    isMozilla: match('Mozilla') && !match('compatible') && !match('WebKit'),
    isOpera: !!window.opera,
    isSafari: match('WebKit') && match('Chrome/'),
    isChrome: match('Chrome/'),
    isFirefox: match('Firefox/'),
    isDSi: match('Nintendo DSi'),
    is3DS: match('Nintendo 3DS'),
    isWii: match('Nintendo Wii'),
    isAndroid: match('Android'),
    isAndroidMobile: match('Android') && match('Mobile'),
    isAndroidTablet: match('Android') && !match('Mobile'),
    isIPhone: match('iPod;') || match('iPhone;') || match('iPhone Simulator;'),
    isWindowsPhone: match('Windows Phone'),
    isIPad: match('iPad'),
    isSupportsXPath: !!document.evaluate,
    version: {
        string: (/(?:Firefox\/|MSIE |Opera\/|Chrome\/|Version\/)([\d.]+)/.exec(navigator.userAgent) || []).pop(),
        valueOf: function valueOf() {
            return parseFloat(this.string);
        },
        toString: function toString() {
            return this.string;
        }
    }
};
Browser.isTouch = Browser.isIPhone || Browser.isAndroidMobile || Browser.isDSi || Browser.is3DS || Browser.isWindowsPhone;
Browser.isSmartPhone = Browser.isIPhone || Browser.isAndroidMobile || Browser.isWindowsPhone;
Browser.isTablet = Browser.isAndroidTablet || Browser.isIPad;

// サポート切ってるブラウザかどうか
Browser.isObsolete = Browser.isIE6 || Browser.isIE7 || Browser.isIE8;

// XXX ここにあるのおかしいのでは？
Browser.thirdPartyCookiesBlocked = $.Deferred(); // ブロックされてるか分かったら Hatena.Diary.Pages.Blogs['*'].init で resolveされる ブロックされてたらtrue

module.exports = Browser;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],32:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('./globalData');

var Circle = {
    updateMembershipCategory: function updateMembershipCategory($select) {
        var circleId = $select.attr('data-circle-id');
        var blogId = $select.attr('data-blog-id');
        var selection = $select.find('option:selected').val();

        var operation, categoryId;
        if (selection === 'delete') {
            operation = 'delete';
        } else {
            operation = 'update';
            categoryId = selection;
        }

        return $.ajax({
            url: '/api/circle/membership/category',
            type: 'POST',
            data: {
                rkm: globalData('rkm'),
                rkc: globalData('rkc'),
                operation: operation,
                circle_id: circleId,
                blog_id: blogId,
                category_id: categoryId
            }
        });
    }
};

module.exports = Circle;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./globalData":52}],33:[function(require,module,exports){
'use strict';

var Browser = require('./Browser');

var Devices = {

    // PC向けページをスマートフォンで見ている場合、スマートフォン向けページに誘導する
    // - PCの場合は何もしない
    // - touchの場合、cookie, UAを見てリダイレクトする
    use: function use(device) {
        if (this.userAgent() == device) {
            document.cookie = 'device=' + encodeURIComponent(device) + '; expires=' + new Date(0).toUTCString() + '; path=/';
        } else {
            var expires = new Date();
            expires.setFullYear(expires.getFullYear() + 1);
            document.cookie = 'device=' + encodeURIComponent(device) + '; expires=' + expires.toUTCString() + '; path=/';
        }
        location.reload();
    },

    userAgent: function userAgent() {
        // adminドメインのヘッダーにも同じものがあります
        if (Browser.isTouch) {
            return 'touch';
        } else {
            return 'pc';
        }
    }

};

module.exports = Devices;

},{"./Browser":31}],34:[function(require,module,exports){
'use strict';

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var EventEmitter = require('events').EventEmitter;

var Dispatcher = new EventEmitter();

Dispatcher.on('__DISPATCH__', function (action) {
    Dispatcher.emit(action.type, action.payload);
});

// Define Actions class bound with Dispatcher

var Actions = (function () {
    function Actions() {
        _classCallCheck(this, Actions);
    }

    _createClass(Actions, [{
        key: 'emit',
        value: function emit(actionType, payload) {
            Dispatcher.emit('__DISPATCH__', {
                type: actionType,
                payload: payload
            });
        }
    }]);

    return Actions;
})();

var Store = (function (_EventEmitter) {
    _inherits(Store, _EventEmitter);

    function Store() {
        _classCallCheck(this, Store);

        _get(Object.getPrototypeOf(Store.prototype), 'constructor', this).call(this);
        this.state = {};
    }

    _createClass(Store, [{
        key: 'getState',
        value: function getState() {
            return this.state;
        }
    }]);

    return Store;
})(EventEmitter);

Dispatcher.Actions = Actions;
Dispatcher.Store = Store;

module.exports = Dispatcher;

},{"events":1}],35:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Logger = require('./Logger');
var globalData = require('./globalData');
var Window = require('./Window');
var Messenger = require('../Messenger');

var DROPDOWN_ID = 'hatena-diary-dropdown';

var Dropdown = {
    /*
     * options:
     * - show       [Boolean] dropdown の表示非表示を明示的に指定 (無指定でトグル)
     * - key        [String]  すでに dropdown が表示されていてもこの値が違っていたら破棄して作りなおす
     * - parent     [String]  親 dropdown の id を指定する。親が消えたら自分も消える
     * - className  [String]  container要素に指定するクラス。スペース区切りで複数指定 ("a-class b-class")
     * - callback   [function(dropdown, messenger)]
     */
    toggle: function toggle(uri, init, id, options) {
        id = DROPDOWN_ID + (id ? '-' + id : uri.replace(/\//, '-')); // /\//g では？
        options = options || {};

        if (typeof options !== 'object') {
            Logger.BUG('Wrong type of options given: ' + options);
        }

        var $container = $(document.getElementById(id));

        if (options.key) {
            if ($container.length && $container.attr('data-dropdown-key') !== options.key) {
                $container.remove();
                $container = $();
            }
        }

        if ($container.length) {
            var show;
            if ('show' in options) {
                show = !!options.show;
            } else {
                show = !$container.is(':visible');
            }
            $container[show ? 'fadeIn' : 'fadeOut']('fast');
            $container.trigger('dropdown:' + (show ? 'show' : 'hide') + ':start');
        } else if ('show' in options && options.show === false) {
            // nop
        } else {
                $container = $('<div class="hatena-globalheader-window"></div>').hide().attr('id', id).appendTo(document.body);

                if (options.key) {
                    $container.attr('data-dropdown-key', options.key);
                }

                if (options.parent) {
                    var parent = document.getElementById(DROPDOWN_ID + '-' + options.parent);
                    $(parent).on('dropdown:hide:start', function () {
                        $container.fadeOut('fast');
                    });
                }

                if (options.className) {
                    $container.addClass(options.className);
                }

                var iframe = $('<iframe frameborder="0" width="150" height="300"></iframe>').appendTo($container);

                var dropdown = iframe[0];

                if (!/^https?:/.test(uri)) {
                    uri = globalData('admin-domain') + uri;
                }

                var messenger = Messenger.createForFrame(dropdown, uri);
                messenger.addEventListener('close', function () {
                    Window.hide(iframe);
                });

                messenger.addEventListener('init', function (css) {
                    if (css) $container.css(css);
                    messenger.send('init', init);
                });

                messenger.addEventListener('resize', function (css) {
                    if (css) $container.css(css);
                });

                messenger.addEventListener('reload', function (data) {
                    location.reload(true);
                });

                if (options.callback) {
                    options.callback(dropdown, messenger);
                }

                Window.show($container, {
                    destroy: function destroy() {
                        $container.remove();
                        messenger.destroy();
                    },
                    keepOthers: !!options.parent || false
                });

                if (init) {
                    if ('left' in init || 'right' in init || 'top' in init) {
                        var offset = $container.offset();
                        if ('left' in init) {
                            offset.left = init.left;
                        } else if ('right' in init) {
                            offset.left = init.right - $container.width();
                        }
                        if ('top' in init) {
                            offset.top = init.top;
                        }
                        $container.offset(offset);
                    }

                    if ('height' in init) {
                        $container.height(init.height);
                    }
                }
            }
    }
};

module.exports = Dropdown;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152,"./Logger":44,"./Window":49,"./globalData":52}],36:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var decodeParam = require('../Util/decodeParam');
var Messenger = require('../Messenger');

// Hatena.Diary.Editorを外部から触るためのアダプター
// TODO: window.Hatenaへの依存解消
var EditorConnector = {
    // 指定された文字列をエディタに挿入する
    // PC，touch，iOSに対応
    // 全記法向きのテキストが必要
    // Arrayの各行が各要素
    // data: { hatena: [], html: [], markdown: [] }
    insertLines: function insertLines(data) {
        this._validate(data);
        this._setup();
        this._insertLinesImplement(data);
    },

    // iOSアプリから開かれているかどうか
    // 基本的にはEditorConnectorに任せるべきだが, いろいろあってうまくいかないときのため用意
    isiOS: function isiOS() {
        return decodeParam(location.search.substr(1))['ios'];
    },

    // Androidアプリから開かれているかどうか
    isAndroid: function isAndroid() {
        return decodeParam(location.search.substr(1))['android'];
    },

    // 指定されたURLをwindow.openして通信を待つ
    loadServiceOnChildWindow: function loadServiceOnChildWindow(url) {
        var self = this;
        var curationWindow = window.open();
        var messenger = Messenger.createForWindow(curationWindow, url);

        messenger.addEventListener('insertLines', function (data) {
            self.insertLines(data);
        });
    },

    _validate: function _validate(data) {
        _.each(['html', 'hatena', 'markdown'], function (mode) {
            if (!data[mode]) throw "missing " + mode;
        });
    },

    _setup: function _setup() {
        if (this._insertLinesImplement) return;

        // モードに合わせて実装の関数を設定
        var isPC = Hatena.Diary && Hatena.Diary.Pages.device() === 'pc' && Hatena.Diary.Editor.currentEditor;

        var isTouchEditor = Hatena.Diary && Hatena.Diary.Pages.device() === 'touch';

        var isChildFrame = window.opener;

        // ?ios=1というパラメータついてるときiOS
        var isiOS = this.isiOS();
        // ?android=1というパラメーターのときAndroid
        var isAndroid = this.isAndroid();

        if (isiOS || isAndroid) {
            // 規定のURL開く
            this._insertLinesImplement = this._insertLinesOpenURL;
        } else if (isPC) {
            // PC編集画面
            this._insertLinesImplement = this._insertLinesPC;
        } else if (isTouchEditor) {
            // touch編集画面
            this._insertLinesImplement = this._insertLinesTouch;
        } else if (isChildFrame) {
            // 親フレームにpostMessageで送信
            this._insertLinesImplement = this._insertLinesMessenger;
        } else {
            throw "handling failed";
        }
    },

    _insertLinesPC: function _insertLinesPC(data) {
        var editor = Hatena.Diary.Editor.currentEditor;
        var mode = editor.mode;
        var lines = data[mode];
        editor.insertLines(lines);
    },
    _insertLinesTouch: function _insertLinesTouch(data) {
        var syntax = $('#edit-entry').attr('data-entry-syntax');

        // HTMLモードで，contentEditable無効のとき(Androidのデフォルトブラウザなど)，ただのtextareaなので，はてな記法を使う
        if (syntax === 'html' && !Hatena.Diary.Pages.AdminTouch['user-blog-edit'].contentEditableEnabledAndEditorModeIsHTML()) {
            syntax = 'hatena';
        }

        var lines = data[syntax] || data['hatena'] || data['markdown'];

        Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText(lines.join("\n"));
    },
    _insertLinesMessenger: function _insertLinesMessenger(data) {
        var messenger = Messenger.createForParent();
        messenger.send('insertLines', data);
        window.close();
    },
    _insertLinesOpenURL: function _insertLinesOpenURL(data) {
        var html_lines = _.map(data.html, function (line) {
            return '<p>' + line + '</p>';
        });
        location.href = 'hatenablog:/entry/body/insert?' + $.param({
            hatena: data.hatena.join("\n"),
            html: html_lines.join(''),
            markdown: data.markdown.join("\n\n"),
            version: 1
        });
    }
};

module.exports = EditorConnector;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152,"../Util/decodeParam":162,"underscore":4}],37:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var globalData = require('./globalData');

var EventTracker = {};

// 最大で1秒に1回だけトラック
EventTracker.trackEvent = (function () {
    var trackNamesQueue = [];
    var timer = null;

    var postTrackNames = function postTrackNames() {
        timer = null;
        var img = new Image();
        img.src = (globalData('admin-domain') || '') + '/api/track?' + $.param({
            track_name: trackNamesQueue,
            blog: globalData('blogs-uri-base') || 'http://' + globalData('blog')
        });
        trackNamesQueue = [];
    };

    return function (trackNames) {
        if (!timer) {
            timer = setTimeout(postTrackNames, 1000);
        }
        _.each($.makeArray(trackNames), function (name) {
            trackNamesQueue.push(name);
        });
    };
})();

// トラッキングは，data-track-selectorにCSSセレクタを書くことによって特定の要素のみでフィルタできる．
// 1つの要素内に複数のaタグがあるが，クリックされた件数の関係で，複数data-track-nameを設定できない場合に有用．
// returns: セレクタがないか，または，セレクタがあるときマッチしたか
EventTracker.checkSelector = function ($container, $clicked) {
    var selector = $container.attr('data-track-selector');
    if (!selector) return true;

    // クリックされたとき反応する要素たち
    var $candicates = $container.find(selector);

    // クリックされた要素が，反応して良い要素たち自身か，反応して良い要素たちに含まれる？
    return !!($candicates.is($clicked) || $candicates.find($clicked).get(0));
};

// 指定した要素のdata-track-nameを配列で返す
EventTracker.getDataTrackNames = function ($element) {
    var dataTrackAttr = $element.attr('data-track-name');
    var trackNames = dataTrackAttr.split(/\s+/);
    return trackNames;
};

// 今すぐトラック
// イベント名か、イベント名のArrayを渡す
// returns: dfd.promiseオブジェクト。画像の読み込みが成功したらresolve、失敗したらrejectする。
EventTracker.trackEventNow = function (trackNames) {
    var dfd = $.Deferred();

    var img = new Image();
    img.onload = function () {
        dfd.resolve();
    };
    img.onerror = function () {
        dfd.reject();
    };

    img.src = (globalData('admin-domain') || '') + '/api/track?' + $.param({
        track_name: $.makeArray(trackNames),
        blog: globalData('blogs-uri-base') || 'http://' + globalData('blog')
    });

    // ずっと読み込みが終わらなかったら、rejectする
    setTimeout(function () {
        dfd.reject();
    }, 5000);

    return dfd.promise();
};

EventTracker.setupTrack = function () {
    $(document).on('mousedown', '[data-track-name]:not([data-track-once])', function (event) {
        if (event.which !== 1) return; // 左クリックのみ
        var $element = $(this);
        if (!EventTracker.checkSelector($element, $(event.target))) return;

        var trackNames = EventTracker.getDataTrackNames($element);
        EventTracker.trackEvent(trackNames);
    });

    $(document).on('mousedown', '[data-track-name][data-track-once]:not([data-track-once-tracked])', function (event) {
        if (event.which !== 1) return; // 左クリックのみ
        var $element = $(this);
        if (!EventTracker.checkSelector($element, $(event.target))) return;

        var trackNames = EventTracker.getDataTrackNames($element);
        EventTracker.trackEventNow(trackNames);

        // これ以降トラッキングしない
        $element.attr('data-track-once-tracked', '');
    });
};

module.exports = EventTracker;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./globalData":52,"underscore":4}],38:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Window = require('./Window');
var Messenger = require('../Messenger');
var globalData = require('./globalData');

// constant
var FEEDBACK_ID = 'hatena-diary-feedback';

// グローバルヘッダ > メニュー > ヘルプ からフィードバックのダイアログを表示する
var Feedback = {

    toggle: function toggle(uri) {
        var feedback = document.getElementById(FEEDBACK_ID);
        if (feedback) {
            $(feedback).fadeToggle('fast');
        } else {
            var iframe = $('<iframe frameborder="0" width="320" height="320"></iframe>').hide().attr('id', FEEDBACK_ID).appendTo(document.body);

            feedback = iframe[0];

            var messenger = Messenger.createForFrame(feedback, uri + '?uri=' + encodeURIComponent(location.href) + '&page_id=' + encodeURIComponent(globalData('page')));

            messenger.addEventListener('close', function () {
                Window.hide(iframe);
            });

            messenger.addEventListener('resize', function (css) {
                if (css) {
                    iframe.css(css);
                }
            });

            Window.show(iframe, {
                destroy: function destroy() {
                    iframe.remove();
                    messenger.destroy();
                },
                fixScroll: true
            });
        }
    }
};

module.exports = Feedback;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152,"./Window":49,"./globalData":52}],39:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// private
var scrollTop = 0;
var enabled = false;

var scrollHandler = function scrollHandler(event) {
    if ($(window).scrollTop() === scrollTop) {
        return;
    }

    $(window).scrollTop(scrollTop);
};

// モーダル表示中など、スクロールできなくするためのモジュール
var FixScroll = {
    enable: function enable() {
        if (enabled) {
            return;
        }

        scrollTop = $(window).scrollTop();
        $(window).bind('scroll', scrollHandler);
        enabled = true;
    },
    disable: function disable() {
        if (!enabled) {
            return;
        }

        $(window).unbind('scroll', scrollHandler);
        enabled = false;
    }
};

module.exports = FixScroll;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],40:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../Locale');

// フォームを監視し，ページ閉じるときにconfirm出すためのオブジェクト
// フォームなくても使える
var FormState = function FormState() {
    var self = this;
    self.confirmEnabled = false;

    var pageLeaveEvent = window.onbeforeunload !== undefined ? 'beforeunload' : 'unload';

    $(window).on(pageLeaveEvent, function () {
        $(window).triggerHandler('close-preview-window');
        if (self.confirmEnabled) {
            return Locale.text('form.confirm.changed');
        }
    });
};

FormState.prototype = {
    // ページ閉じるときにconfirm出すモードを有効にする
    enableConfirm: function enableConfirm() {
        this.confirmEnabled = true;
    },
    // ページ閉じるときにconfirm出すモードを無効にする
    disableConfirm: function disableConfirm() {
        this.confirmEnabled = false;
    },
    // formを監視する 初期状態をセットし，送信を監視
    observeForm: function observeForm($form) {
        var self = this;
        this.$form = $form;
        this.setFormInitialState();

        $form.on('submit', function () {
            self.disableConfirm();
        });
    },
    // formのchangeイベントを監視
    observeFormChange: function observeFormChange() {
        var self = this;
        self.$form.on('change', function () {
            self.checkFormState();
        });
    },
    // formの状態を確認
    checkFormState: function checkFormState() {
        if (this.$form.serialize() !== this.initialState) {
            this.enableConfirm();
        } else {
            this.disableConfirm();
        }
    },
    // 有効かどうかを返す
    isConfirmEnabled: function isConfirmEnabled() {
        return this.confirmEnabled;
    },
    // 現在のformの値を初期状態とする
    // ここから変わったらconfirmが出る
    // ページロード時にJSで値を差し替えたときに呼ぶ
    setFormInitialState: function setFormInitialState() {
        this.initialState = this.$form.serialize();
        this.disableConfirm();
    }
};

module.exports = FormState;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Locale":151}],41:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);

var HtmlText = (function (_React$Component) {
    _inherits(HtmlText, _React$Component);

    function HtmlText() {
        _classCallCheck(this, HtmlText);

        _get(Object.getPrototypeOf(HtmlText.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(HtmlText, [{
        key: 'render',
        value: function render() {
            var _this = this;

            var body = function body() {
                return { __html: _this.props.body };
            };
            return React.createElement('span', { dangerouslySetInnerHTML: body() });
        }
    }]);

    return HtmlText;
})(React.Component);

module.exports = HtmlText;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],42:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// jQuery Deferredを使った遅延リスト
var LazyList = function LazyList() {
    this.init.apply(this, arguments);
};
LazyList.prototype = {
    /**
     * リスト内のノードの初期化
     * @param  {Function} generator - prevを受け取って次の要素のPromiseを返す関数
     * @param  {LazyList} prev      - 前のLazyList 途中で分岐させる場合だけ渡す
     */
    init: function init(generator, prev) {
        if (!$.isFunction(generator)) {
            throw "generator must be a function (" + generator + ")";
        }
        this.generator = generator;

        if (prev) {
            if (!(prev instanceof LazyList)) {
                throw "prev must be a instance of LazyList";
            }
            this._prev = prev;
        }
    },

    // 値の読み込み，promiseを返す
    promise: function promise() {
        if (!this._promise) {
            var dfd = this.generator(this.prev());
            if (!$.isFunction(dfd.promise)) {
                throw "generator must return a Deferred Object (" + dfd + ")";
            }
            this._promise = dfd.promise();
        }

        return this._promise;
    },

    // 前のノードを得る
    prev: function prev() {
        return this._prev;
    },

    // 次のノードを得る
    next: function next() {
        if (!this._next) {
            this._next = new LazyList(this.generator, this);
        }
        return this._next;
    },

    // 最初のノードを得る
    root: function root() {
        if (this._prev) {
            return this._prev.root();
        } else {
            return this;
        }
    }
};

module.exports = LazyList;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],43:[function(require,module,exports){
'use strict';

var decodeParam = require('../Util/decodeParam');
var data = require('./globalData');

var host;
var _params;

var Location = {
    /**
     * setupは普段は明示的に呼ぶ必要はない
     * テスト時にモックしたい場合に，locationオブジェクトを渡してセットアップしてもよい
     * @param location {Object}
     */
    setup: function setup(location) {
        if (!location) {
            location = window.location;
        }
        var data = location.search.slice(1);
        _params = decodeParam(data);
        host = location.host;
    },

    param: function param(name) {
        return this.params()[name] ? this.params()[name][0] : null;
    },

    params: function params() {
        if (!_params) this.setup();
        return _params;
    },

    /**
     * 表示中のドメインのタイプ
     * Admin もしくは Blogs
     * 特定のはてなのドメイン(b.hatena.ne.jpとか)でAdminドメインとみなされてしまうので
     * admin-domainがあったらその値で判別する
     * なかったら正規表現で判別する
     */
    domainType: function domainType() {
        if (!host) this.setup();

        var domain = '';
        var admin_domain = data('admin-domain');
        if (admin_domain) {
            var is_admin_domain = new RegExp('^(http|https)://' + host + '$').test(admin_domain);
            domain = is_admin_domain ? this.Admin : this.Blogs;
        } else {
            domain = /\.hatena\.ne\.jp(:\d+)?$/.test(host) ? this.Admin : this.Blogs;
        }
        return domain;
    },

    Admin: 'Admin',
    Blogs: 'Blogs'
};

module.exports = Location;

},{"../Util/decodeParam":162,"./globalData":52}],44:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var URLGenerator = require('./URLGenerator');
var globalData = require('./globalData');
var Browser = require('./Browser');

// console.log する関数を返す
// コールバックに渡すのに便利
var LOG = (function () {
    if (window.console && window.console.log) {
        if (console.log.bind) {
            return console.log.bind(console);
        } else {
            return function (obj) {
                console.log(obj);
            };
        }
    } else {
        return function () {};
    }
})();

// エラー発生時、エラーメッセージとスタックトレースを表示する
// 古いIEなど，もうサポートしていないブラウザで発生したエラーは送信しない
var BUG = function BUG(error, append) {

    if (Browser.isObsolete) {
        return;
    }

    $.ajax({
        type: 'get',
        url: URLGenerator.static_url('/js/vendor/stacktrace/stacktrace.js'),
        cache: true,
        dataType: 'script'
    }).done(function () {
        var trace;
        try {
            trace = window.printStackTrace({ e: error });
            trace.pop(); // printStackTraceを除く
        } catch (e) {
            trace = null;
        }
        var msg = '[BUG] ' + (append || '') + ' ' + error;

        var content = [location.href, msg, trace];

        var img = new Image();
        img.src = (globalData('admin-domain') || '') + '/api/bug?content=' + encodeURIComponent(JSON.stringify(content));
        LOG(msg);
        LOG(trace);
    });
};

// BUGする関数を返す
// Ajax の onerror とかにいれる
var REPORT_BUG = function REPORT_BUG(name) {
    return function (error) {
        BUG(error, name);
    };
};

module.exports = {
    LOG: LOG,
    BUG: BUG,
    REPORT_BUG: REPORT_BUG
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Browser":31,"./URLGenerator":48,"./globalData":52}],45:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// private
var loaded;
var MATHJAX_URL = "https://cdn.mathjax.org/mathjax/2.3-latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";

// Google Image Charts APIはdeprecatedなのでmathjaxで置き換える
// 全てのブログで必要になるわけではないので，必要になってから読み込む
// TeX記法生成するとaltにTeXのソースが入ってるので，altがあったら置き換える
// 参考： http://docs.mathjax.org/en/latest/typeset.html
var MathJaxLoader = {
    load: function load($root) {
        var $imgs = $root.find('img[src*="chart.apis.google.com/chart?cht=tx&chl="]');
        if (!$imgs.length) {
            return;
        }

        if (!loaded) {
            loaded = $.getScript(MATHJAX_URL);
        }

        loaded.done(function () {
            $imgs.each(function () {
                var $img = $(this);
                var source = $img.attr('alt');
                if (!source) {
                    return;
                }

                var $script = $('<script type="math/tex">');
                $img.replaceWith($script);
                MathJax.HTML.setScript($script[0], source);
            });
            MathJax.Hub.Queue(["Typeset", MathJax.Hub, $root[0]]);
        });
    }
};

module.exports = MathJaxLoader;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],46:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Location = require('./Location');
var globalData = require('./globalData');
var Logger = require('./Logger');
var Messenger = require('../Messenger');
var SpeedTrack = require('./SpeedTrack');
var Feedback = require('./Feedback');

/**
 * ページ毎のコントローラを呼び出すモジュール
 */
var Pages = {

    Controllers: null,

    Blogs: {},
    Admin: {},
    BlogsTouch: {},
    AdminTouch: {},

    /**
     * グローバルヘッダがロードされて，通信が完了するとresolveされるdeferred
     * loadGlobalHeader内で再代入される
     * ここで定義したdeferredはダミーで，即座にrejectしている
     * 呼び出し元で定義済かどうかをチェックする手間を省くため．
     */
    infoLoaded: (function () {
        var nullObject = $.Deferred();
        nullObject.reject();
        return nullObject.promise();
    })(),

    /**
     * Controllersを外部から挿し込む
     * @param {Object} Controllers - loadControllerで呼ばれるコントローラの集合
     */
    setControllers: function setControllers(Controllers) {
        Pages.Controllers = Controllers;
    },

    /**
     * init.jsonを呼び出す
     * グローバルヘッダから利用する
     * 完了すると，info, privateInfo をresolveするDeferredを返す
     * XXX グローバルヘッダのコンポーネントが処理するべき
     *
     * @return {$.Promise}
     */
    loadInfo: function loadInfo() {
        var blogUri = decodeURIComponent(location.hash.substring(1));
        var circleId = Location.param('circle_id');

        var init;
        if (circleId) {
            init = $.ajax({
                url: '/api/init/circle',
                type: 'get',
                dataType: 'json',
                data: {
                    circle_id: circleId
                }
            });
        } else {
            init = $.ajax({
                url: '/api/init',
                type: "get",
                dataType: 'json',
                data: {
                    name: globalData('name'),
                    blog: blogUri
                }
            });
        }

        var loaded = $.Deferred();
        init.done(function (info) {
            var privateInfo = info['private'];

            // privateに入ってる情報は外側に配信しない．ここで削除しておく
            delete info['private'];

            // 外のフレームに情報送る
            Messenger.send('init', info);

            // グローバルヘッダに情報送る．こっちはprivateInfoも一緒に渡す
            loaded.resolve(info, privateInfo);
        });

        return loaded.promise();
    },

    /**
     * 表示中のテンプレートのデバイスを返す
     * @return {string} 'pc' | 'touch'
     */
    device: function device() {
        var device = globalData('device');

        if (!device) {
            var message = "device is undefined, page: " + globalData('page') + ", location: " + location.href;
            Logger.BUG(message);
        }

        return device || 'pc';
    },

    /**
     * 表示したページのコントローラを呼び出す
     * @public
     */
    loadPage: function loadPage() {
        var domain = Location.domainType();

        var deviceSuffix = Pages.device() === 'pc' ? '' : 'Touch';
        var namespace = domain + deviceSuffix;

        var page = globalData('page');

        SpeedTrack.setDomain(domain);
        SpeedTrack.setPage(page);

        var func;
        try {
            Pages.loadDomain(namespace);
            SpeedTrack.record('Pages["' + namespace + '"]["*"]');

            Pages.loadDomainPage(namespace, page);
            SpeedTrack.record('Pages["' + namespace + '"]["' + page + '"]');

            Pages.loadController(namespace, page);
            SpeedTrack.record('Controllers["' + namespace + '"]["' + page + '"]');
        } catch (e) {
            Logger.BUG(e, 'toplevel');
        }

        // フィードバックボタンを有効にする
        // XXX ここで行うべき処理ではない
        if (page !== 'globalheader') {
            $('a.feedback').on('click', function () {
                Feedback.toggle(globalData('feedback'));
                return false;
            });
        }
    },

    /**
     * ドメイン全体のコントローラを呼び出す
     * @param {string} namespace - /^(admin|blogs)(Touch)?/
     */
    loadDomain: function loadDomain(namespace) {
        Logger.LOG('Pages["' + namespace + '"]["*"]');
        var func = Hatena.Diary.Pages[namespace]["*"];
        if (func) {
            func();
        }
        Logger.LOG('Pages["' + namespace + '"]["*"] done');
    },

    /**
     * 現在のページのコントローラを呼び出す
     * @param {string} namespace - /^(admin|blogs)(Touch)?/
     * @param {string} page      - ページID
     */
    loadDomainPage: function loadDomainPage(namespace, page) {
        Logger.LOG('Pages["' + namespace + '"]["' + page + '"]');
        var func = Hatena.Diary.Pages[namespace][page];
        if (func) {
            func();
        }
        Logger.LOG('Pages["' + namespace + '"]["' + page + '"] done');
    },

    /**
     * loadDomainPage と同様
     * こちらへ移動すること
     *
     */
    loadController: function loadController(domain, pageId) {
        if (!Pages.Controllers) {
            throw new Error('Pages.Controllers not initialized');
        }

        Logger.LOG('Controllers["' + domain + '"]["' + pageId + '"]');
        var controller = Pages.Controllers[domain][pageId];
        if (controller) {
            controller.init();
        }
        Logger.LOG('Controllers["' + domain + '"]["' + pageId + '"] done');
    }

};

module.exports = Pages;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152,"./Feedback":38,"./Location":43,"./Logger":44,"./SpeedTrack":47,"./globalData":52}],47:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var globalData = require('./globalData');

var SpeedTrack = {
    init: function init() {
        if (this.initialized === true) return;

        // fluentdへの送信は100分の1にしたい
        this.fluentdEnabled = Math.floor(Math.random() * 100) === 0;

        var now = new Date();
        this.startTime = now;
        this.data = {};
        this.checkpoints = [];
        this.elapsedTimes = [];

        this.initialized = true;
    },
    setDomain: function setDomain(domain) {
        this.domain = domain;
    },
    setPage: function setPage(page) {
        this.page = page;
    },
    record: function record(name) {
        var endTime = new Date();
        var elapsed = endTime.getTime() - this.startTime.getTime();
        this.checkpoints.push(name);
        this.elapsedTimes.push(elapsed);

        this.sendToFluentd();

        this.sendToUniversalAnalytics(name, elapsed);
    },
    sendToFluentd: function sendToFluentd() {
        if (this._sendToFluentd) return this._sendToFluentd();

        // 1秒に1回まで送信する
        this._sendToFluentd = _.throttle(function () {
            if (!this.fluentdEnabled) return;

            var img = new Image();
            img.src = (globalData('admin-domain') || '') + '/api/track/speed?' + $.param({
                track_domain: this.domain,
                track_page: this.page,
                track_speed_checkpoints: this.checkpoints,
                track_speed_elapsed_times: this.elapsedTimes,
                blog: globalData('blogs-uri-base') || 'http://' + globalData('blog')
            });

            this.checkpoints = [];
            this.elapsedTimes = [];
        }, 1000);

        this._sendToFluentd();
    },
    // UniversalAntlycsはcreateするときにサンプリングレート設定してるので，ここでは構わず送る
    sendToUniversalAnalytics: function sendToUniversalAnalytics(name, elapsed) {
        if (!window.ga) {
            return;
        }

        window.ga('HatenaBlogTracker.send', {
            'hitType': 'timing',
            'timingCategory': 'SpeedTrack',
            'timingVar': name,
            'timingValue': elapsed
        });
    }
};
SpeedTrack.init();

module.exports = SpeedTrack;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./globalData":52,"underscore":4}],48:[function(require,module,exports){
'use strict';

var globalData = require('./globalData');

// JS用URL生成
var URLGenerator = {
    // path指定でユーザブログのURLを返す。APIのURLを作るときなどは必ずこれを利用すること
    user_blog_url: function user_blog_url(path) {
        var blog_url_base = globalData('blogs-uri-base');
        return blog_url_base + path;
    },
    static_url: function static_url(path) {
        var static_base = globalData('static-domain');
        return static_base + path + this._versionParameter();
    },
    _versionParameter: function _versionParameter() {
        var version = globalData('version');

        if (version) {
            return '?version=' + version;
        } else {
            return '';
        }
    }
};

module.exports = URLGenerator;

},{"./globalData":52}],49:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var FixScroll = require('./FixScroll');

// モーダルウィンドウを出したりする為のモジュール
var Window = {
    shown: [],

    init: function init() {
        var self = this;

        $(document.body).click(function (event) {
            var windowClicked = _.any(self.shown, function (win) {
                return win.win[0] === event.target || $.contains(win.win[0], event.target);
            });
            // 表示中のwindowがクリックされたときは閉じない
            if (windowClicked) {
                return;
            }

            self.hideAll();
        });

        self.init = function () {};
    },

    /**
     * opts.closeExplicitlyがtrueだとポップアップウィンドウ以外をクリックしても閉じられない
     * その場合、明示的にポップアップウィンドウを閉じる必要がある
     * opts.keepOthers が真値だと他のポップアップを自動的に閉じない
     */
    show: function show(win, opts) {
        var self = this;
        if (!opts) opts = {};
        self.init();
        if (opts.keepOthers) {
            // nop
        } else {
                self.hideAll();
            }
        if (opts.fixScroll) {
            FixScroll.enable();
        }
        if (opts.center) {
            Hatena.Diary.Window._setCenter(win);
        }
        if (opts.showBackground) {
            Hatena.Diary.Window._showBackground();
        }
        self.shown.push({
            closeExplicitly: !!opts.closeExplicitly,
            win: win,
            destroy: opts.destroy || function () {},
            fixScroll: !!opts.fixScroll,
            showBackground: !!opts.showBackground
        });
        win.fadeIn('fast');
    },

    hide: function hide(win) {
        var self = this;
        for (var i = 0, len = self.shown.length; i < len; i++) {
            var obj = self.shown[i];
            if (obj.win === win) {
                win.fadeOut('fast', obj.destroy);
                $('.modal-window-background').fadeOut('fast');
                if (obj.fixScroll) {
                    FixScroll.disable();
                }
                break;
            }
        }
    },

    hideAll: function hideAll() {
        var self = this,
            restWindows = [];
        for (var i = 0, len = self.shown.length; i < len; i++) {
            if (self.shown[i].closeExplicitly) {
                restWindows.push(self.shown[i]);
            } else {
                self.hide(self.shown[i].win);
            }
        }
        self.shown = restWindows;
    },

    toggle: function toggle(win, option) {
        if (win.is(':visible')) {
            this.hide(win);
            return false;
        } else {
            this.show(win, option);
            return true;
        }
    },

    _setCenter: function _setCenter(win) {
        var setSize = _.throttle(function () {
            if (!$(win).is(':visible')) {
                $(window).off('resize', setSize);
                return;
            }
            var margin_top = ($(window).height() - $(win).height()) / 2;
            var margin_left = ($(window).width() - $(win).width()) / 2;
            $(win).css({
                top: margin_top,
                left: margin_left
            });
        }, 100);

        $(window).on('resize', setSize);

        setSize();
    },

    _showBackground: function _showBackground() {
        var $screen = $('<div>').addClass('modal-window-background');
        $screen.appendTo(document.body);
    }
};

module.exports = Window;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./FixScroll":39,"underscore":4}],50:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var extractSyntax = require('./extractSyntax');

// fotolifeにアップロード完了すると返されるfotolife記法を:plain形式のHTMLに展開
// 成功したとき { image, syntax, html } を返すDeferredを返す
var extractFotolifeSyntax = function extractFotolifeSyntax(string) {
    var ret = $.Deferred();
    var match = string.match(/f:id:([^:]+):(\d+)([jpg]):image/);
    if (match) {
        var syntax = '[' + match[0].replace(':image', ':plain') + ']';
        var name = match[1];
        var id = match[2];
        var type = match[3];
        var path = [name.substring(0, 1), name, id.substring(0, 8), id].join('/');
        var image = 'http://cdn-ak.f.st-hatena.com/images/fotolife/' + path + '_120.jpg';

        extractSyntax(syntax).done(function (data) {
            ret.resolve({
                image: image,
                syntax: syntax,
                html: data.html
            });
        }).fail(function (error) {
            ret.reject(error);
        });
    } else {
        _.defer(function () {
            ret.reject('Invalid format? ' + string);
        });
    }
    return ret.promise();
};

module.exports = extractFotolifeSyntax;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./extractSyntax":51,"underscore":4}],51:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var globalData = require('./globalData');

// はてな記法展開
// hatena_syntax: String or [String]，Arrayのとき，各行が<p>で囲まれる
// 成功したとき { html } を返すDeferredを返す
var extractSyntax = function extractSyntax(hatena_syntax) {
    var dfd = $.Deferred();
    if (_.isArray(hatena_syntax)) {
        hatena_syntax = hatena_syntax.join("\n\n");
    }

    $.ajax({
        url: "/api/support.expand",
        type: "POST",
        data: {
            syntax: hatena_syntax,
            rkm: globalData('rkm'),
            rkc: globalData('rkc')
        },
        dataType: 'json'
    }).done(function (data) {
        dfd.resolve({
            html: data.html
        });
    }).fail(function (error) {
        dfd.reject(error);
    });

    return dfd;
};

module.exports = extractSyntax;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./globalData":52,"underscore":4}],52:[function(require,module,exports){
'use strict';

// html要素のdata属性を取得する
// テンプレートからJSにデータを渡すのに使う
var globalData = function globalData(name) {
    var html = document.documentElement;
    return html.getAttribute('data-' + name);
};

module.exports = globalData;

},{}],53:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var decodeParam = require('../Util/decodeParam');

// locationのviaをリンクに引き継ぐ
var inheritVia = function inheritVia(via) {
    if (!via) return;

    $('a[data-inherit-via]').each(function () {
        var $self = $(this);
        var href = $self.attr('href').split(/\?/);
        var query = href[1] || '';

        var params = decodeParam(query);
        params['via'] = via;

        $self.attr('href', href[0] + '?' + $.param(params));
    });
};

module.exports = inheritVia;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Util/decodeParam":162}],54:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../Messenger');
var globalData = require('./globalData');
var Devices = require('./Devices');
var Logger = require('./Logger');
var SpeedTrack = require('./SpeedTrack');
var canonicalizeColor = require('../Util/canonicalizeColor');

/**
 * グローバルヘッダクラス
 */
var GlobalHeader = function GlobalHeader() {
    this.init.apply(this, arguments);
};

GlobalHeader.prototype = {

    /**
     * グローバルヘッダ要素を取得
     */
    createGlobalHeader: function createGlobalHeader() {
        var globalheader = document.querySelector('iframe#globalheader');

        // スマフォの企業ブログではglobalheader消されてることがあるので，ここで非表示でくっつける
        if (!globalheader) {
            var $globalheader = $('<iframe id="globalheader" style="display: none"></iframe>');
            $globalheader.appendTo(document.body);
            globalheader = $globalheader[0];
        }

        return globalheader;
    },

    /**
     * 文字色を取得
     */
    getColor: function getColor() {
        return canonicalizeColor($(this.globalheader).css('color')) || '000000';
    },

    /**
     * 背景色を取得
     */
    getBackgroundColor: function getBackgroundColor() {
        var backgroundColor = null;

        var target = this.globalheader;
        while (!backgroundColor && target && target != document.documentElement) {
            var css = $(target).css('backgroundColor');
            backgroundColor = canonicalizeColor(css);
            target = target.parentNode;
        }

        if (!backgroundColor) {
            backgroundColor = 'ffffff';
        }

        return backgroundColor;
    },

    /**
     * どのデバイス用のヘッダを出すかを取得
     */
    getDevice: function getDevice() {
        var globalheaderType = globalData('globalheader-type') || 'auto';

        if (globalheaderType === 'auto') {
            return Devices.userAgent();
        } else {
            return globalheaderType;
        }
    },

    getCircleId: function getCircleId() {
        return globalData('circle-id');
    },

    /**
     * 親ページのカテゴリを取得
     */
    getPageCategory: function getPageCategory() {
        if (/\.hatena\.ne\.jp(:\d+)?$/.test(location.host)) {
            return 'admin';
        }
        if (globalData('blog')) {
            return 'blogs';
        }
        if (this.circleId) {
            return 'circle';
        }
        return 'global';
    },

    /**
     * proアップグレードへの導線を出すかどうか判定する
     */
    showUpgradePro: function showUpgradePro() {
        return this.pageCategory === 'admin' && globalData('pro') && globalData('pro') === 'false';
    },

    getBrand: function getBrand() {
        return globalData('brand');
    },

    getParams: function getParams() {
        var params = {};
        params.device = this.getDevice();

        if (this.circleId) {
            params.circle_id = this.circleId;
        }

        if (this.showUpgradePro()) {
            params['show_upgrade_pro'] = 'yes';
        }

        if (globalData('brand')) {
            params['brand'] = globalData('brand');
        }

        return params;
    },

    /**
     * グローバルヘッダのURLを組み立てる
     */
    getURL: function getURL() {
        return globalData('admin-domain') + '/-/globalheader/' + encodeURIComponent(this.color) + '/' + encodeURIComponent(this.bgColor) + '/' + this.pageCategory + '?' + $.param(this.params) + '#' + encodeURIComponent(location.href);
    },

    /**
     * コンストラクタ
     */
    init: function init() {
        this.globalheader = this.createGlobalHeader();

        this.color = this.getColor();
        this.bgColor = this.getBackgroundColor();
        this.circleId = this.getCircleId();
        this.pageCategory = this.getPageCategory();

        this.params = this.getParams();

        Messenger.listenToFrame(this.globalheader, this.getURL());

        Hatena.Diary.Pages.infoLoaded = $.Deferred();

        Messenger.addEventListener('init', function (info) {
            $(function () {
                Logger.LOG(['init', info]);
                Hatena.Diary.Pages.infoLoaded.resolve(info);
                SpeedTrack.record("globalHeaderLoaded");
            });
        });

        SpeedTrack.record("loadGlobalHeader");
    }
};

module.exports = function () {
    new GlobalHeader();
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152,"../Util/canonicalizeColor":161,"./Devices":33,"./Logger":44,"./SpeedTrack":47,"./globalData":52}],55:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../Messenger');
var Window = require('./Window');

var setupProModal = function setupProModal() {
    var openProModal = function openProModal(modalURL) {
        var iframeContainer = $('<div class="hatena-iframe-container pro-modal-container">').appendTo(document.body);
        var iframe = $('<iframe frameborder="0"></iframe>').appendTo(iframeContainer);

        var messenger = Messenger.createForFrame(iframe[0], modalURL);
        messenger.addEventListener('close', function () {
            Window.hide(iframeContainer);
        });

        Window.show(iframeContainer, {
            destroy: function destroy() {
                iframe.remove();
                messenger.destroy();
            },
            fixScroll: true,
            center: true,
            showBackground: true
        });
    };

    $('.open-pro-modal').css('visibility', 'visible');
    $(document.body).on('click', '.open-pro-modal', function () {
        var $self = $(this);
        var modalURL = $self.attr('data-guide-pro-modal-ad-url');
        openProModal(modalURL);
        return false;
    });
};

module.exports = setupProModal;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152,"./Window":49}],56:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var globalData = require('./globalData');
var Devices = require('./Devices');

var setupTouchViewSuggest = function setupTouchViewSuggest() {
    var suggest_touch_view = !globalData('no-suggest-touch-view');
    var has_touch_view = globalData('has-touch-view');
    var is_touch_agent = Devices.userAgent() === 'touch';

    if (suggest_touch_view && has_touch_view && is_touch_agent) {
        $('#sp-suggest-link').on('click', function () {
            Devices.use('touch');
            return false;
        });
        $('#sp-suggest').show();
    }
};

module.exports = setupTouchViewSuggest;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Devices":33,"./globalData":52}],57:[function(require,module,exports){
'use strict';

var TwitterText = require('twitter-text');

var validateTweetLength = function validateTweetLength(tweet) {
    var length = TwitterText.getTweetLength(tweet || '');
    // ツイートの最大文字数 - httpsのurl - httpsの画像url - 改行 = 95
    // 95よりオーバーしていた場合はfalse, オーバーしていない場合はtrueを返します
    // ここでのバリデーションは単純な文字数で行っているわけではなく、
    // 公式ライブラリを用いてtwitterの仕様に合わせてよしなにやってくれます
    // 例えば凄い長いurlを貼ってもhttpsのurlだと23文字でカウントしてくれます。
    return length < 140 - 23 - 23 - 1;
};

module.exports = validateTweetLength;

},{"twitter-text":3}],58:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Logger = require('../Base/Logger');

var EntryModuleCarousel = function EntryModuleCarousel($container, opts) {
    this.init($container, opts);
};

EntryModuleCarousel.prototype = {
    init: function init($container, opts) {
        if (!opts) opts = {};

        var self = this;
        self.moveInProgress = false;
        self.$containerElem = $container;
        self.$goBackElem = $($.parseHTML('<a class="module-entries-carousel-button back"><span>Back</span<</a>'));
        self.$goForwardElem = $($.parseHTML('<a class="module-entries-carousel-button forward"><span>Forward</span></a>'));

        self.isAutoScroll = opts.isAutoScroll || false;
        self.autoScrollInterval = opts.autoScrollInterval || 5000;
        // 同時に表示される要素の個数
        self.displayEntrySizeAtOnce = opts.displayEntrySizeAtOnce || 2;

        if (self.isAutoScroll) {
            self.autoScrollIntervalId = window.setInterval(function (self) {
                self.goForwardWithLoop();
            }, self.autoScrollInterval, self);
        }

        self.$containerElem.on('click', '.module-entries-carousel-button.back.active', function () {
            if (self.isAutoScroll) {
                window.clearInterval(self.autoScrollIntervalId);
            }
            self.goBack();
        });
        self.$containerElem.on('click', '.module-entries-carousel-button.forward.active', function () {
            if (self.isAutoScroll) {
                window.clearInterval(self.autoScrollIntervalId);
            }
            self.goForward();
        });
        self.currentPosition = 0;

        var $carouselBodyElem = self.getCarouselBodyElem();
        self.carouselList = $carouselBodyElem.find('.urllist-item');
        self.carouselElementsSize = self.carouselList.length;
        // 記事は1つずつ動くので, 移動する回数は`要素数 - (同時に表示される要素数 - 1)`となる
        self.carouselSize = self.carouselElementsSize - (self.displayEntrySizeAtOnce - 1);

        self.$directNavigationListElem = $($.parseHTML('<ol class="module-entries-carousel-navigation">'));
        var counter = 0;
        while (counter < self.carouselSize) {
            self.$directNavigationListElem.append($($.parseHTML('<li><a data-carousel-index="' + counter + '"><span>' + counter + '</span></a></li>')));
            counter++;
        }
        self.$containerElem.on('click', '.module-entries-carousel-navigation a.active', function (event) {
            // ユーザーが明示的にカルーセルの要素を選択したら、 ユーザーの操作を尊重して以後は勝手にスクロールしない
            if (self.isAutoScroll) {
                window.clearInterval(self.autoScrollIntervalId);
            }
            self.goToIndex(Number($(this).attr('data-carousel-index')));
        });

        self.updateNavigationElementsClass();

        self.$containerElem.append(self.$goBackElem);
        self.$containerElem.append(self.$goForwardElem);
        self.$containerElem.append(self.$directNavigationListElem);
    },
    canGoBack: function canGoBack() {
        var self = this;
        if (self.currentPosition > 0) {
            return true;
        }
        return false;
    },
    // 要素が6個の時はCarouselは5項目しかない
    canGoForward: function canGoForward() {
        var self = this;
        if (self.currentPosition < self.carouselSize - (self.displayEntrySizeAtOnce - 1)) {
            return true;
        }
        return false;
    },
    updateNavigationElementsClass: function updateNavigationElementsClass() {
        var self = this;
        self.$goBackElem.toggleClass('active', self.canGoBack());
        self.$goForwardElem.toggleClass('active', self.canGoForward());

        self.$directNavigationListElem.find('a').removeClass('current');
        self.$directNavigationListElem.find('a[data-carousel-index="' + self.currentPosition + '"]').addClass('current');

        self.$directNavigationListElem.find('a').addClass('active');
        self.$directNavigationListElem.find('a.current').removeClass('active');
    },
    // marginが設定されてる可能性があるので.width()とかではなく、隣の要素とのoffset違いを見る
    getUnitWidth: function getUnitWidth() {
        var self = this;
        var $bodyElem = self.getCarouselBodyElem();
        var $unitElem = $bodyElem.find('.urllist-item');
        if ($unitElem.length === 0) {
            Logger.BUG("Can't get unit width");return 200;
        } else if ($unitElem.length === 1) {
            return $unitElem.width();
        }
        return $($unitElem[1]).offset().left - $($unitElem[0]).offset().left;
    },
    getCarouselBodyElem: function getCarouselBodyElem() {
        var self = this;
        return $(self.$containerElem).find('.urllist-with-thumbnails');
    },
    goToIndex: function goToIndex(index) {
        var self = this;
        if (index < 0 || index >= self.carouselSize) {
            return;
        }
        if (self.moveInProgress) {
            return;
        }
        self.moveInProgress = true;

        var $bodyElem = self.getCarouselBodyElem();
        var originalOffset = $bodyElem.offset();

        var moveSize = self.getUnitWidth() * (index - self.currentPosition);
        var relativeOffset = '-=' + moveSize + 'px';
        $bodyElem.animate({
            left: relativeOffset
        }, 300, function () {
            self.currentPosition = index;
            self.updateNavigationElementsClass();
            self.moveInProgress = false;
        });
    },
    goBack: function goBack() {
        this.goToIndex(this.currentPosition - 1);
    },
    goForward: function goForward() {
        this.goToIndex(this.currentPosition + 1);
    },
    goForwardWithLoop: function goForwardWithLoop() {
        if (this.canGoForward()) {
            this.goForward();
        } else {
            this.goToIndex(0);
        }
    }
};

module.exports = EntryModuleCarousel;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Logger":44}],59:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var SpeedTrack = require('../../Base/SpeedTrack');
var URLGenerator = require('../../Base/URLGenerator');

var init = function init() {
    var $archives = $('.hatena-module-archive');
    if ($archives.length === 0) return;

    var detectDate = function detectDate() {
        // archiveのとき, 一番上の日付から年を読む
        if (Hatena.Diary.data('page') === 'archive') {
            var $entry = $('section.archive-entry:first');
            if ($entry.length > 0) {
                var year_month_day = $entry.find('div.date > a > time').attr('datetime');
                var year_str = year_month_day.split('-')[0];
                var month_str = year_month_day.split('-')[1];

                return { year: year_str, month: month_str };
            }

            return null;
        }

        // ページにエントリがあるとき, 一番上のエントリの日付から年を読む
        var $article = $('article.entry:first');
        if ($article.length > 0) {
            var date_year_str = $article.find('header time > span.date-year').text();
            var date_month_str = $article.find('header time > span.date-month').text();
            return { year: date_year_str, month: date_month_str };
        }

        return null;
    };

    // default
    var setupDefault = function setupDefault($archive) {
        var $open_year;
        var date = detectDate();
        if (date) {
            var year = date['year'];
            if (year) {
                var $year = $archive.find('li.archive-module-year[data-year="' + year + '"]');

                $open_year = $year.length > 0 ? $year : null;
            }
        }

        $open_year = $open_year || $('li.archive-module-year:first');
        $open_year.removeClass('archive-module-year-hidden');

        $archive.find('.archive-module-button').click(function (e) {
            e.preventDefault();

            var $year = $(this).parent('.archive-module-year');
            $year.toggleClass('archive-module-year-hidden');
        });
    };

    // calendarモジュールのセットアップ
    var setupCalendar = function setupCalendar($archive) {
        var $selector = $archive.find('.js-archive-module-calendar-selector');

        var updateCalendar = function updateCalendar() {
            var $date = $selector.find('option:selected');
            var year = $date.data('year');
            var month = $date.data('month');
            $.ajax({
                type: 'get',
                url: URLGenerator.user_blog_url('/archive_module_calendar'),
                data: { month: month, year: year }
            }).done(function (res) {
                // days object
                $archive.find('.js-archive-module-calendar-container').html(res);
            });
        };

        $selector.change(function () {
            updateCalendar();
        });

        // 表示ページに合わせてカレンダーを初期化
        var date = detectDate();
        if (date) {
            $selector.val(date['year'] + ' ' + date['month']);
        }
        updateCalendar();
    };

    // Archiveのtype( default, calendar )によって出し分け
    _.each($archives, function (archive) {
        var $archive = $(archive);
        var archiveType = $archive.data('archiveType');
        $.ajax({
            type: 'get',
            url: URLGenerator.user_blog_url('/archive_module'),
            data: { archive_type: archiveType },
            dataType: 'html'
        }).done(function (res) {
            $archive.find('.hatena-module-body').append(res);

            SpeedTrack.record("Pages.Blogs['*'].setupArchiveModule");

            if (archiveType == 'calendar') {
                setupCalendar($archive);
            } else {
                setupDefault($archive);
            }
        });
    });
};

module.exports = {
    init: init
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/SpeedTrack":47,"../../Base/URLGenerator":48,"underscore":4}],60:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var SpeedTrack = require('../../Base/SpeedTrack');
var URLGenerator = require('../../Base/URLGenerator');

var init = function init() {
    var $circles = $('.hatena-module-circles');
    if ($circles.length === 0) return;

    // 更新があったグループはJSで表示を変更する
    var mtime = 0,
        circleIds = [],
        elems = {};
    $circles.find('[data-circle-id][data-circle-mtime]').each(function () {
        var $elem = $(this);
        var circleId = $elem.attr('data-circle-id');
        circleIds.push(circleId);
        elems[circleId] = $elem;
        var m = Number($elem.attr('data-circle-mtime'));
        if (m > mtime) mtime = m;
    });

    $.ajax({
        type: 'GET',
        url: URLGenerator.user_blog_url('/api/module/circles'),
        data: { mtime: mtime, circle_id: circleIds },
        traditional: true,
        dataType: 'json'
    }).done(function (data) {
        for (var circleId in data.circles) {
            elems[circleId].replaceWith($.parseHTML(data.circles[circleId].html || ' '));
        }

        SpeedTrack.record("Pages.Blogs['*'].setupCirclesModule");
    });
};

module.exports = {
    init: init
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/SpeedTrack":47,"../../Base/URLGenerator":48}],61:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var URLGenerator = require('../../Base/URLGenerator');

var init = function init() {
    var $entriesAccessRanking = $('.hatena-module-entries-access-ranking');
    if ($entriesAccessRanking.length === 0) return;

    $entriesAccessRanking.each(function () {
        var $self = $(this);
        var queryParams = {};
        // `data-`のprefixがついた属性をすべて取得し，クエリパラメータにする
        _.each($self[0].attributes, function (attr) {
            if (!attr.name.match(/^data-/)) return;
            // `data-`のprefixはクエリパラメータのkeyには不要なので取り除く
            queryParams[attr.name.replace(/^data\-/, '')] = attr.value;
        });

        $.ajax({
            type: 'GET',
            url: URLGenerator.user_blog_url('/entries_access_ranking_module'),
            data: queryParams,
            dataType: 'html'
        }).done(function (res) {
            $self.find('.hatena-module-body').append(res);
        });
    });
};

module.exports = {
    init: init
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/URLGenerator":48,"underscore":4}],62:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var SpeedTrack = require('../../Base/SpeedTrack');
var URLGenerator = require('../../Base/URLGenerator');

var init = function init() {
    var $recentComments = $('.hatena-module-recent-comments');
    if ($recentComments.length === 0) return;
    var template = _.template($('.recent-comments-template').html());

    var max_count = 0;
    // コメントモジュールが複数ある場合があるので、最大の数のコメントを取得する
    $recentComments.each(function () {
        var $moduleBody = $(this).find('.hatena-module-body');
        var count = $moduleBody.attr('data-count');
        max_count = _.max([max_count, count]);
    });
    if (max_count === 0) return;

    $.ajax({
        url: URLGenerator.user_blog_url('/api/recent_comments'),
        dataType: 'json',
        data: {
            count: max_count
        }
    }).done(function (comments) {
        $recentComments.each(function () {
            var $container = $(this);
            var $moduleBody = $container.find('.hatena-module-body');
            var count = $moduleBody.attr('data-count');
            var comment_source = '';
            for (var i = 0; i < count; i++) {
                if (!comments[i]) break;
                comment_source += template({
                    comment: comments[i]
                });
            }
            $container.find('.recent-comments').html(comment_source);
            Hatena.Diary.Util.updateDynamicPieces($container);
        });

        SpeedTrack.record("Pages.Blogs['*'].setupRecentCommentsModule");
    });
};

module.exports = {
    init: init
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/SpeedTrack":47,"../../Base/URLGenerator":48,"underscore":4}],63:[function(require,module,exports){
'use strict';

var Archive = require('./Archive');
var Circles = require('./Circles');
var EntriesAccessRanking = require('./EntriesAccessRanking');
var RecentComments = require('./RecentComments');

var init = function init() {
    var modules = [Archive, Circles, EntriesAccessRanking, RecentComments];
    modules.forEach(function (module) {
        module.init();
    });
};

module.exports = {
    init: init
};

},{"./Archive":59,"./Circles":60,"./EntriesAccessRanking":61,"./RecentComments":62}],64:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../Messenger');

var ReQuote = function ReQuote() {
    this.init();
};

ReQuote.prototype = {
    init: function init() {
        this.quote = {
            body: '',
            url: '',
            title: ''
        };

        this.$reQuoteButton = $($('#js-requote-button-template').html().trim());

        this.bindEvents();
    },

    // Ten.base.js の関数getSelectedTextと同じもの
    getSelectedText: function getSelectedText() {
        if (window.getSelection) {
            return '' + (window.getSelection() || '');
        }
        if (document.getSelection) {
            return document.getSelection();
        }
        if (document.selection) {
            return document.selection.createRange().text;
        }
        return '';
    },

    selectedTextExists: function selectedTextExists() {
        return this.getSelectedText().length > 0;
    },

    bindEvents: function bindEvents() {
        var self = this;

        $(document).on('mouseenter', 'blockquote', function (e) {
            // 選択中の文字列がない場合のみボタンを表示
            if (self.selectedTextExists() === false) {
                // 勢い良くhoverされたときなどに、e.targetが引用内部のaタグやpタグになることがあるので、
                // これらの外側のblockquoteタグをとる必要がある
                var $blockquote = $(e.target).closest('blockquote');
                // blockquoteタグの内部にblockquoteタグが含まれる場合はボタンを表示しない
                if ($blockquote.find('blockquote').length > 0) {
                    return;
                }

                self.focusOnBlockquote($blockquote);
                self.showButton();
            }
        });

        $(document).on('mouseleave', 'blockquote', function (e) {
            var $toElement = $(e.toElement);
            if ($toElement.hasClass('js-select_quote_panel') === false) {
                self.hideButton();
            }
        });

        // ReQuoteボタンを表示した後に、blockquote内の文字列が選択された場合
        // 引用ストックボタンを優先するため、ReQuoteボタンを非表示にする
        $(document).on('mouseup', 'blockquote', function () {
            if (self.selectedTextExists()) {
                self.hideButton();
            } else {
                self.showButton();
            }
        });

        // ReQuoteボタンが押されたとき
        self.$reQuoteButton.on('click', function () {
            // ReQuote -> admin
            Messenger.send('requote-edit-entry', { quote: self.quote });
            return false;
        });
    },

    focusOnBlockquote: function focusOnBlockquote($blockquote) {
        this.$blockquote = $blockquote;
        this.setButtonData($blockquote);
        this.$blockquote.append(this.$reQuoteButton);
    },

    setButtonData: function setButtonData($blockquote) {
        // 表示されているblockquoteの内容を引用ストックAPIに与えときに備えて
        // 必要なデータを取得し、ボタンにセットする
        // 対応している引用形式は test/Blogs/ReQuote.html を参照
        this.setQuoteBody($blockquote);
        this.setQuoteMeta($blockquote);

        // cite内に本文を書いてしまった場合など、引用本文が空であったとき
        if (this.quote.body === '') {
            this.quote.body = this.quote.title;
            this.quote.title = this.quote.url;
        }
    },

    // blockquoteタグから引用の内容を取得する
    setQuoteBody: function setQuoteBody($blockquote) {
        var $quoteBody = $blockquote.children(':not(cite, .js-requote-button)');

        if ($quoteBody.length <= 0) {
            this.quote.body = $blockquote.contents().get(0).nodeValue || '';
        } else {
            this.quote.body = $quoteBody.text();
        }
    },

    // blockquoteタグから引用の出典を取得する
    setQuoteMeta: function setQuoteMeta($blockquote) {
        var $cite = $blockquote.find('cite');
        var $a = $cite.find('a');

        var url = $blockquote.attr('cite') || $a.attr('href');

        if (url === undefined) {
            var $article = $blockquote.closest('article');
            var $metadata = $article.find('.entry-title .entry-title-link');

            url = $metadata.attr('href');
        }

        var title = $a.text() || $cite.text() || url;

        this.quote.url = url;
        this.quote.title = title;
    },

    showButton: function showButton() {
        this.$reQuoteButton.addClass('is-visible');
    },

    hideButton: function hideButton() {
        this.$reQuoteButton.removeClass('is-visible');
    }
};

module.exports = ReQuote;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152}],65:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../Messenger');
var globalData = require('../Base/globalData');
var SubscribeButton = require('../SubscribeButton');

// 購読する/しない ボタン
// - 自分のブログ : 非表示
// - 購読済ブログ : "読者をやめる"
// - 未購読ブログ : "読者になる"
// args:
//   isSubscribing : 閲覧者がブログを購読中かどうか
//   subscribers   : ブログの購読者数
var init = function init(isSubscribing, subscribers) {
    // 全て同じブログ、同じユーザーの講読ボタン
    var blogUrl = globalData('blog');
    var userData = {
        isSubscribing: isSubscribing,
        isGuest: globalData('rkm') && globalData('rkc') ? false : true
    };
    var blogData = {
        subscribersCount: subscribers,
        blogUrl: blogUrl,
        blogName: globalData('blog-name'),
        requestUrl: [globalData('admin-domain'), globalData('author'), blogUrl, 'subscribe'].join('/')
    };

    // ボタンとの通信に用いるMessenger
    var messenger = Messenger.createForCurrentWindow();

    // ボタンを生成
    var buttons = $('.hatena-follow-button-box').map(function () {
        return new SubscribeButton.Blogs($(this), userData, blogData, messenger);
    }).toArray();

    // 講読開始/中止の処理が完了したというメッセージを受け取った時の処理
    // iframe版との通信はglobalHeaderを通じて行う
    // admin -> blogs
    Messenger.addEventListener('subscription', function (data) {
        messenger.send('subscription', data);
    });
    // blogs -> admin
    messenger.addEventListener('subscription', function (data) {
        Messenger.send('subscription', data);
    });

    // globalHeaderからのsubscribeメッセージを受け取るためのボタン
    var $hiddenButton = $('#hidden-subscribe-button > .hatena-follow-button-box');
    this.subscribeButtonForMessage = new SubscribeButton.Blogs($hiddenButton, userData, blogData, messenger);

    var self = this;
    Messenger.addEventListener('subscribe', function (data) {
        var offset = { left: data.left + 5 };
        self.subscribeButtonForMessage.openSubscribeWindow(offset, true);
    });

    // 表示中のブログが講読されたら、globalheaderに「購読中です」のラベルを出す
    messenger.addEventListener('subscription', function (data) {
        if (data[blogUrl] === true) {
            Messenger.send('subscribed-current-blog');
        }
    });

    $(document).on('subscribe', function (e, data) {
        var offset = { left: data.left + 5 };
        self.subscribeButtonForMessage.openSubscribeWindow(offset, true);
    });
};

module.exports = {
    init: init
};

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/globalData":52,"../Messenger":152,"../SubscribeButton":159}],66:[function(require,module,exports){
'use strict';

module.exports = {
    Module: require('./Module'),
    trackBlogVisit: require('./trackBlogVisit'),
    EntryModuleCarousel: require('./EntryModuleCarousel'),
    ReQuote: require('./ReQuote'),
    SubscribeButtonSynchronizer: require('./SubscribeButtonSynchronizer')
};

},{"./EntryModuleCarousel":58,"./Module":63,"./ReQuote":64,"./SubscribeButtonSynchronizer":65,"./trackBlogVisit":67}],67:[function(require,module,exports){
'use strict';

var globalData = require('../Base/globalData');
var BUG = require('../Base/Logger').BUG;

/**
 * ブログへのアクセスをAnalyticsに送信する
 * ページ開いてすぐ帰ったときは送らないため，10杪待ってから送る
**/
var trackBlogVisit = function trackBlogVisit() {
    setTimeout(function () {
        if (!window.ga) {
            BUG('window.ga is not defined');
            return;
        }

        var type = globalData('plus-available') ? 'pro' : 'free';

        window.ga('HatenaBlogTracker.send', {
            'hitType': 'event',
            'eventCategory': 'PageView',
            'eventAction': 'VisitBlog',
            'eventLabel': type
        });
    }, 10 * 1000);
};

module.exports = trackBlogVisit;

},{"../Base/Logger":44,"../Base/globalData":52}],68:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var globalData = require('../../Base/globalData');
var IframeBox = require('./IframeBox');

/**
 * 記事
 */

var Comment = (function () {

    /**
     * @param {jQuery} $element
     */

    function Comment($element) {
        _classCallCheck(this, Comment);

        this.$element = $element;

        this.uuid = $element.attr('id');

        this.initDeleteButton();
    }

    /**
     * 削除ボタンがクリックされたらiframe作って削除ボックスをロードする
     */

    _createClass(Comment, [{
        key: 'initDeleteButton',
        value: function initDeleteButton() {
            var _this = this;

            this.deleteBox = new IframeBox(this.$element, this.getDeleteUrl());

            this.deleteBox.on('delete', function () {
                return _this['delete']();
            });

            this.$element.on('click', '.js-comment-delete-button', function () {
                _this.deleteBox.show();
                return false;
            });
        }
    }, {
        key: 'getDeleteUrl',
        value: function getDeleteUrl() {
            var adminDomain = globalData('admin-domain');
            var author = globalData('author');
            var blog = globalData('blog');
            var uuid = encodeURIComponent(this.uuid.slice(8));

            return adminDomain + '/' + author + '/' + blog + '/comment/delete?comment=' + uuid;
        }

        /**
         * コメント削除時に呼ばれる
         * 実際には要素は削除しない
         */
    }, {
        key: 'delete',
        value: function _delete() {
            this.$element.fadeOut();
        }
    }, {
        key: 'getElement',
        value: function getElement() {
            return this.$element;
        }
    }]);

    return Comment;
})();

module.exports = Comment;

},{"../../Base/globalData":52,"./IframeBox":70}],69:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Cookie = require('js-cookie');

var Logger = require('../../Base/Logger');
var URLGenerator = require('../../Base/URLGenerator');
var globalData = require('../../Base/globalData');
var replaceYoutubeURL = require('../../Util/replaceYoutubeURL');
var updateDynamicPieces = require('../../Util/updateDynamicPieces');

var Comment = require('./Comment');
var IframeBox = require('./IframeBox');

/**
 * 記事
 */

var Entry = (function () {

    /**
     * @param {jQuery} $element
     */

    function Entry($element) {
        _classCallCheck(this, Entry);

        replaceYoutubeURL($element);

        // 要素を取得
        this.$element = $element;
        this.$commentBox = $element.find('.js-comment-box');
        this.$commentList = $element.find('.js-comment-box .js-comment');
        this.$showCommentInputButton = $element.find('.js-leave-comment-title');

        // データを初期化
        this.uuid = this.$element.attr('data-uuid');
        this.comments = [];

        this.initComments();
        this.initCommentInputBox();
        this.initEditButton();
    }

    /**
     * 記事のコメントをHTML形式で取得する
     * 一度に複数回まとめて呼ばれる事を想定し、setTimeoutでまとめて取得するようになっている
     * @param {string} entryId
     */

    /**
     * 記事ページのコメントを表示
     */

    _createClass(Entry, [{
        key: 'initComments',
        value: function initComments() {
            var _this = this;

            // コメント情報のロード
            return Entry.loadEntryInfo(this.uuid).done(function (info) {
                if (!info.comments) {
                    return;
                }

                _this.comments = info.comments.entries.map(function (comment) {
                    return new Comment($(comment));
                });

                _this.renderComments();
            });
        }

        /**
         * 「コメントを書く」ボタンを押したらコメントボックスを表示する
         */
    }, {
        key: 'initCommentInputBox',
        value: function initCommentInputBox() {
            var _this2 = this;

            var inputUri = this.getCommentInputUrl();

            this.inputBox = new IframeBox(this.$commentBox, inputUri);
            this.inputBox.on('update', function (data) {
                _this2.addComment(new Comment($(data.comment)));
                _this2.renderComments();
            });

            this.$showCommentInputButton.on('click', function () {
                _this2.inputBox.show();
                return false;
            });
        }

        /**
         * 編集ボタンを初期化する
         */
    }, {
        key: 'initEditButton',
        value: function initEditButton() {
            var _this3 = this;

            var $buttonContainer = this.$element.find('.js-entry-edit-button-container');
            var $button = $buttonContainer.find('.js-entry-edit-button');

            Hatena.Diary.Pages.infoLoaded.done(function (info) {
                if (!info.editable) {
                    return;
                }

                $buttonContainer.show();
                $button.attr('href', _this3.getEditorUrl());
            });
        }

        /**
         * コメント入力iframe用のURLを生成
         * @return {String}
         */
    }, {
        key: 'getCommentInputUrl',
        value: function getCommentInputUrl() {
            var adminDomain = globalData('admin-domain');
            var author = globalData('author');
            var blog = globalData('blog');

            var params = $.param({
                entry: this.uuid,
                token: Cookie.get('bk')
            });

            return adminDomain + '/touch/' + author + '/' + blog + '/comment?' + params;
        }

        /**
         * コメント入力iframe用のURLを生成
         * @return {String}
         */
    }, {
        key: 'getEditorUrl',
        value: function getEditorUrl() {
            var adminDomain = globalData('admin-domain');
            var author = globalData('author');
            var blog = globalData('blog');

            return adminDomain + '/' + author + '/' + blog + '/edit?entry=' + this.uuid;
        }

        /**
         * コメント表示順に従ってコメントを追加
         * @param {Comment} comment
         */
    }, {
        key: 'addComment',
        value: function addComment(comment) {
            if (globalData('blog-comments-top-is-new')) {
                this.comments.unshift(comment);
            } else {
                this.comments.push(comment);
            }
        }

        /**
         * $commentList内にコメントを描画
         */
    }, {
        key: 'renderComments',
        value: function renderComments() {
            var _this4 = this;

            // コメント一覧にDOMを挿入
            // 既に存在する要素は変化しない
            this.comments.forEach(function (comment) {
                _this4.$commentList.append(comment.getElement());
            });

            // ユーザ名、はてなスターを初期化
            updateDynamicPieces(this.$commentList);
        }
    }]);

    return Entry;
})();

Entry.loadEntryInfo = (function () {

    var timer = undefined;
    var data = undefined;

    var clearData = function clearData() {
        data = {
            entries: [],
            deferred: {}
        };
    };

    return function (entryId) {
        if (!timer) {
            clearData();
            timer = setTimeout(function () {
                timer = null;

                var currentData = data;
                clearData();

                $.ajax({
                    url: URLGenerator.user_blog_url('/api/entry/info'),
                    type: 'get',
                    dataType: 'json',
                    cache: false,
                    data: {
                        e: currentData.entries
                    }
                }).then(function (res) {
                    var entries = res.entries;
                    for (var key in entries) {
                        if (entries.hasOwnProperty(key)) {
                            var val = entries[key];
                            currentData.deferred[key].resolve(val);
                        }
                    }
                });
            }, 0);
        }

        var ret = $.Deferred();

        data.entries.push(entryId);
        data.deferred[entryId] = ret;

        return ret.fail(Logger.REPORT_BUG('loadEntryInfo'));
    };
})();

module.exports = Entry;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/Logger":44,"../../Base/URLGenerator":48,"../../Base/globalData":52,"../../Util/replaceYoutubeURL":175,"../../Util/updateDynamicPieces":180,"./Comment":68,"./IframeBox":70,"js-cookie":2}],70:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var _ = require('underscore');

var Messenger = require('../../Messenger');
var URLGenerator = require('../../Base/URLGenerator');
var Locale = require('../../Locale');

/**
 * BlogsTouchでコメント編集に使うiframeコンポーネント
 */

var IframeBox = (function () {

    /**
     * @param {jQuery} $parent - $containerを挿入する親要素
     * @param {string} url     - iframeに表示するURL
     */

    function IframeBox($parent, url) {
        _classCallCheck(this, IframeBox);

        this.url = url;
        this.$container = $(IframeBox.TEMPLATE({
            image: URLGenerator.static_url('/images/loading.gif'),
            text: Locale.text('loading')
        })).css({
            position: 'relative',
            width: '100%',
            'margin-left': '-1px' }). // borderでずれる分
        appendTo($parent);

        this.$loading = this.$container.find('.js-loading');

        this.eventListeners = {};
    }

    /** @constant */

    _createClass(IframeBox, [{
        key: 'show',
        value: function show() {
            var _this = this;

            // resizeを捕捉するため、毎回iframeを生成する
            this.$iframe = $('<iframe frameborder="0"></iframe>');
            this.$container.append(this.$iframe);

            // setTimeout(function () { $loading.show(); }, 250);
            // $iframe.on('load', function () { $loading.remove(); });

            this.messenger = Messenger.createForFrame(this.$iframe[0], this.url);

            this.messenger.addEventListener('close', function () {
                _this.$container.fadeOut();
                _this.$iframe.remove();
                _this.messenger.destroy();
            });
            this.messenger.addEventListener('resize', function (css) {
                if (css) {
                    _this.$container.css(css);
                }
            });

            Object.keys(this.eventListeners).forEach(function (eventName) {
                var listeners = _this.eventListeners[eventName];
                listeners.forEach(function (listener) {
                    _this.messenger.addEventListener(eventName, listener);
                });
            });

            this.$container.fadeIn();
        }
    }, {
        key: 'on',
        value: function on(eventName, callback) {
            this.eventListeners[eventName] = this.eventListeners[eventName] || [];
            this.eventListeners[eventName].push(callback);
        }
    }]);

    return IframeBox;
})();

IframeBox.TEMPLATE = _.template('<div class="hatena-iframe-container" style="display: none;">' + '  <div class="loading js-loading" style="display: none;">' + '    <img src="<%- image %>" alt="loading"/>' + '    <%- text %>' + '  </div>' + '</div>');

module.exports = IframeBox;

},{"../../Base/URLGenerator":48,"../../Locale":151,"../../Messenger":152,"underscore":4}],71:[function(require,module,exports){
'use strict';

module.exports = require('./Entry');

},{"./Entry":69}],72:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var preventDuplicateSubmit = require('../../../Util/preventDuplicateSubmit');

/**
 * グループ作成ページ
 */
var CreatePage = {
    init: function init() {
        var $form = $('form#create-circle-form');

        $form.on('submit', function () {
            preventDuplicateSubmit($form);
        });
    }
};

module.exports = CreatePage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Util/preventDuplicateSubmit":174}],73:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../Messenger');
var Circle = require('../../../Base/Circle');

var MembershipDonePage = {
    init: function init() {
        Messenger.listenToParent();

        Messenger.send('resize', {
            // iframeの高さがうまくとれず、やむなく+50している..
            // *1はOpera対策 see also Hatena.Diary.Util.sendresizerequest
            height: ($(document.body).height() + 50) * 1
        });

        Messenger.send('done');

        $('.close').on('click', function (e) {
            Messenger.send('close', { name: window.name });
            return false;
        });

        var $container = $('.options');
        var $select = $container.find('.membership-category-select');
        var current = $select.find('option:selected').val();
        var $indicator = $container.find('.indicator');

        $select.change(function (e) {
            Circle.updateMembershipCategory($select).done(function (data) {
                $indicator.find('.success').show();
                $indicator.find('.fail').hide();
            }).error(function (data) {
                $select.val(current);
                $indicator.find('.success').hide();
                $indicator.find('.fail').show();
            });
        });
    }
};

module.exports = MembershipDonePage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Base/Circle":32,"../../../Messenger":152}],74:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../Messenger');
var sendResizeRequest = require('../../../Util/sendResizeRequest');

var MembershipPage = {
    init: function init() {
        Messenger.listenToParent();

        $('.close').on('click', function (e) {
            Messenger.send('close', { name: window.name });
            return false;
        });

        $('form').submit(function (e) {
            var $form = $(this);
            if (!confirm($form.attr('data-confirm-message'))) {
                return false;
            }
        });

        sendResizeRequest();
    }
};

module.exports = MembershipPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Messenger":152,"../../../Util/sendResizeRequest":176}],75:[function(require,module,exports){
'use strict';

var AmazonSearch = require('../../../Editor/Component/AmazonSearch');
var simulateSidebar = require('../../../Editor/Component/simulateSidebar');

var AmazonPage = {

    init: function init() {
        new AmazonSearch({
            container: $('#editor-amazon-search')
        });

        simulateSidebar();
    }

};

module.exports = AmazonPage;

},{"../../../Editor/Component/AmazonSearch":116,"../../../Editor/Component/simulateSidebar":141}],76:[function(require,module,exports){
'use strict';

var Flickr = require('../../../Editor/Component/Flickr');
var simulateSidebar = require('../../../Editor/Component/simulateSidebar');

var FlickrPage = {

    init: function init() {
        if ($('#editor-flickr.enabled').get(0)) {
            new Flickr({
                container: $('#editor-flickr')
            });

            simulateSidebar();
        }
    }

};

module.exports = FlickrPage;

},{"../../../Editor/Component/Flickr":117,"../../../Editor/Component/simulateSidebar":141}],77:[function(require,module,exports){
'use strict';

var Gourmet = require('../../../Editor/Component/Gourmet');
var simulateSidebar = require('../../../Editor/Component/simulateSidebar');

var GourmetPage = {

    init: function init() {
        if ($('#editor-gourmet.enabled').get(0)) {
            new Gourmet({
                container: $('#editor-gourmet')
            });

            simulateSidebar();
        }
    }

};

module.exports = GourmetPage;

},{"../../../Editor/Component/Gourmet":119,"../../../Editor/Component/simulateSidebar":141}],78:[function(require,module,exports){
'use strict';

var Instagram = require('../../../Editor/Component/Instagram');
var simulateSidebar = require('../../../Editor/Component/simulateSidebar');

var InstagramPage = {

    init: function init() {
        if ($('#editor-instagram.enabled').get(0)) {
            new Instagram({
                container: $('#editor-instagram')
            });

            simulateSidebar();
        }
    }

};

module.exports = InstagramPage;

},{"../../../Editor/Component/Instagram":121,"../../../Editor/Component/simulateSidebar":141}],79:[function(require,module,exports){
'use strict';

var Itunes = require('../../../Editor/Component/Itunes');
var simulateSidebar = require('../../../Editor/Component/simulateSidebar');

var ItunesPage = {

    init: function init() {
        new Itunes({
            container: $('#editor-itunes')
        });

        simulateSidebar();
    }

};

module.exports = ItunesPage;

},{"../../../Editor/Component/Itunes":122,"../../../Editor/Component/simulateSidebar":141}],80:[function(require,module,exports){
(function (global){
'use strict';

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var Logger = require('../../../Base/Logger');
var PromotionEntry = require('../../../Editor/Component/Promotion/PromotionEntry');
var PromotionTouch = require('../../../Editor/Component/Promotion/components/PromotionTouch');
var EntriesActions = require('../../../Editor/Component/Promotion/actions/EntriesActions');
var OdaiActions = require('../../../Editor/Component/Promotion/actions/OdaiActions');

var PromotionPage = {

    init: function init() {
        var modalElement = document.querySelector('#promotion');

        // PR記事表示ボタン、PR記事ウィンドウ作成
        // これらの要素は2箇所にバラけているため、1つのコンポーネントにできない
        React.render(React.createElement(PromotionTouch, null), modalElement);

        // HTMLに埋め込まれたJSONから、モデルのインスタンスを作成
        var entriesJson = modalElement.getAttribute('data-entries-json');
        var entries = [];
        try {
            entries = JSON.parse(entriesJson).map(function (e) {
                return new PromotionEntry(e);
            });
        } catch (e) {
            Logger.BUG(e, 'Cannot parse embedded PromotionEntry JSON data');
        }

        // データをStoreにロード
        EntriesActions.loadEntries(entries);
        OdaiActions.loadOdais();

        EntriesActions.showEntryAt(0);
    }

};

module.exports = PromotionPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Base/Logger":44,"../../../Editor/Component/Promotion/PromotionEntry":126,"../../../Editor/Component/Promotion/actions/EntriesActions":127,"../../../Editor/Component/Promotion/actions/OdaiActions":128,"../../../Editor/Component/Promotion/components/PromotionTouch":134}],81:[function(require,module,exports){
'use strict';

var Twitter = require('../../../Editor/Component/Twitter');
var simulateSidebar = require('../../../Editor/Component/simulateSidebar');

var TwitterPage = {

    init: function init() {
        if ($('#editor-twitter.enabled').get(0)) {
            new Twitter({
                container: $('#editor-twitter')
            });

            simulateSidebar();
        }
    }

};

module.exports = TwitterPage;

},{"../../../Editor/Component/Twitter":140,"../../../Editor/Component/simulateSidebar":141}],82:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../Messenger');
var sendResizeRequest = require('../../../Util/sendResizeRequest');

var BlogMenuPage = {

    init: function init() {
        Messenger.listenToParent();
        sendResizeRequest();

        Messenger.send('init');
        Messenger.addEventListener('init', function (init) {
            $('.subscribe').click(function () {
                Messenger.send('subscribe', {
                    left: init.left ? init.left : 0
                });
                return false;
            });
        });
        $('.edit-this-entry').click(function () {
            Messenger.send('edit-this-entry');
            return false;
        });
        $('.new-entry').click(function () {
            Messenger.send('new-entry');
            return false;
        });
    }

};

module.exports = BlogMenuPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Messenger":152,"../../../Util/sendResizeRequest":176}],83:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../Messenger');
var sendResizeRequest = require('../../../Util/sendResizeRequest');
var waitForResource = require('../../../Util/waitForResource');

var MyBlogMenuPage = {

    init: function init() {
        Messenger.listenToParent();

        // myblogmenuは初め非表示の状態であり、
        // 非表示要素のサイズをとるとFirefox等でおかしくなる．
        // 実際に表示されるのを待ってからresizeする

        waitForResource(function () {
            return $(document.body).is(':visible');
        }, function () {
            sendResizeRequest();
        }, 100);

        $(document.body).mouseenter(function () {
            Messenger.send('mouseenter');
        });
    }

};

module.exports = MyBlogMenuPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Messenger":152,"../../../Util/sendResizeRequest":176,"../../../Util/waitForResource":181}],84:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../Messenger');
var Browser = require('../../../Base/Browser');
var sendResizeRequest = require('../../../Util/sendResizeRequest');

var MyMenuPage = {

    init: function init() {
        Messenger.listenToParent();
        sendResizeRequest();

        $('.new-entry').click(function () {
            Messenger.send('new-entry');
            return false;
        });

        var $help = $('#help');
        $help.click(function () {
            Messenger.send('feedback', {
                uri: $help.attr('data-feedback-url')
            });
            return false;
        });

        // iPadなどのタブレットデバイスのときは、
        if (Browser.isTablet) {
            var last_submenu_blog_uri;

            $('a.myblog').on('touchstart touchmove', function () {
                return false;
            });

            $('a.myblog').on('touchend', function () {
                var blog_uri = $(this).attr('href');

                if (last_submenu_blog_uri) {
                    Messenger.send('myblogmenu.close', { blogUri: last_submenu_blog_uri });
                }

                Messenger.send('myblogmenu.open', { blogUri: blog_uri });

                last_submenu_blog_uri = blog_uri;
                return false;
            });
        } else {
            $('.dropdown-mymenu').menuAim({
                activate: function activate(li) {
                    var has_submenu = $(li).hasClass('dropdown-mymenu-submenu');
                    if (!has_submenu) return;

                    var blog_uri = $(li).find('a').attr('href');

                    Messenger.send('myblogmenu.open', { blogUri: blog_uri });
                },
                deactivate: function deactivate(li) {
                    var has_submenu = $(li).hasClass('dropdown-mymenu-submenu');
                    if (!has_submenu) return;

                    var blog_uri = $(li).find('a').attr('href');

                    Messenger.send('myblogmenu.close', { blogUri: blog_uri });
                },
                submenuDirection: 'left'
            });
        }

        $('a.myblog').each(function () {
            var top = $(this).position().top;
            var blog_uri = $(this).attr('href');
            Messenger.send('myblogmenu.init', { top: top, blogUri: blog_uri });
        });
    }

};

module.exports = MyMenuPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Base/Browser":31,"../../../Messenger":152,"../../../Util/sendResizeRequest":176}],85:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../Messenger');
var Locale = require('../../../Locale');
var sendResizeRequest = require('../../../Util/sendResizeRequest');

var ServicesPage = {

    init: function init() {
        Messenger.listenToParent();
        Messenger.addEventListener('init', function (data) {

            // data は危険な内容である可能性がある
            var BASE = data.BASE;
            var servicesInUse = data.info.services;

            var usernameWindow = $('#username-window');

            $('<dt class="label"><span>Services in Use</span></dt>').find('span').text(Locale.text('services_in_use')).end().appendTo(usernameWindow);

            // global headerに出すリストを作る
            var subdomainsForShow = [];
            for (var s in servicesInUse) {
                if (servicesInUse[s].is_beta) continue;
                if (!servicesInUse[s].portal_top_priority) continue;
                subdomainsForShow.push(s);
            }
            subdomainsForShow.sort(function (a, b) {
                return servicesInUse[b].portal_top_priority - servicesInUse[a].portal_top_priority;
            });

            for (var i = 0, length = subdomainsForShow.length; i < length; i++) {
                var subdomain = subdomainsForShow[i];
                var service = servicesInUse[subdomain];
                if (!service) continue;
                var url = 'http://www' + BASE + '/me/' + service.name + '/';
                var favicon = '//www.hatena.com/images/favicon/' + service.name + '.png';
                $('<dd><a href="" rel="noreferrer" target="_blank"><img alt="" width="16" height="16"/></a></dd>').find('a').find('img').attr('src', favicon).end().attr('href', url).append(document.createTextNode(service.text)).end().appendTo(usernameWindow);
            }

            $('<dt class="label"><span>Lang</span></td>').find('span').text(Locale.text('lang')).end().appendTo(usernameWindow);

            var langs = Locale.getAvailLangs();
            for (var i = 0; i < langs.length; i++) {
                var lang = langs[i];
                if (langs[i] == Locale.getTextLang()) {
                    $('<dd><span class="selected">lang</span></dd>').find('span').text(Locale.text('lang.' + lang + '.native')).end().appendTo(usernameWindow);
                } else {
                    $('<dd><a href="#">lang</a></dd>').find('a').attr('data-lang', lang).text(Locale.text('lang.' + lang + '.native')).end().appendTo(usernameWindow);
                }
            }
            usernameWindow.find('a[data-lang]').click(function () {
                var lang = $(this).attr('data-lang');
                Locale.setAcceptLang(lang);
                Messenger.send('reload');
                return false;
            });

            $('<dt class="label"><span>My Hatena</span></dt>').find('span').text(Locale.text('my_hatena')).end().appendTo(usernameWindow);

            $('<dd><a href="" rel="noreferrer" target="_blank"><img src="/images/favicon/my.png" width="16" height="16" alt=""></a></dd>').find('a').attr('href', 'http://www' + BASE + '/my/').append(Locale.text('profile')).end().appendTo(usernameWindow);

            $('<dd><a href="" rel="noreferrer" class="logout" target="_parent"><img width="16" height="16" src="/images/favicon/logout.gif"></a></dd>').find('a').attr('href', 'http://www' + BASE + '/logout?location=' + encodeURIComponent(data.location)).append(Locale.text('logout')).click(function () {
                return confirm(Locale.text('really_want_to_logout'));
            }).end().appendTo(usernameWindow);

            sendResizeRequest();
        });

        Messenger.send('init');
    }

};

module.exports = ServicesPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../Locale":151,"../../../Messenger":152,"../../../Util/sendResizeRequest":176}],86:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var PlusQuitPage = {

    init: function init() {
        $('form').submit(function () {
            $(this).find('input:submit').attr('disabled', 'disabled');
        });
    }

};

module.exports = PlusQuitPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],87:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var TopicShowPage = {

    init: function init() {
        $('#topic-entries-tabs').tabs({ active: 0 });
    }

};

module.exports = TopicShowPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],88:[function(require,module,exports){
'use strict';

var Messenger = require('../../../../../Messenger');

var DeletedPage = {

    init: function init() {
        Messenger.listenToParent();
        Messenger.send('delete');
    }

};

module.exports = DeletedPage;

},{"../../../../../Messenger":152}],89:[function(require,module,exports){
'use strict';

var Messenger = require('../../../../../Messenger');

// このファイル不要では？
var DeletePage = {

    init: function init() {
        Messenger.listenToParent();
    }

};

module.exports = DeletePage;

},{"../../../../../Messenger":152}],90:[function(require,module,exports){
'use strict';

var Messenger = require('../../../../../Messenger');

var DonePage = {

    init: function init() {
        Messenger.listenToParent();

        var comment = document.getElementById('posted').value;

        Messenger.send('update', { comment: comment });

        Messenger.send('close');
    }

};

module.exports = DonePage;

},{"../../../../../Messenger":152}],91:[function(require,module,exports){
(function (global){
// TODO: リファクタリングしたら 'use strict'; する

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

var globalData = require('../../../../../Base/globalData');
var Locale = require('../../../../../Locale');
var FormState = require('../../../../../Base/FormState');
var ModalWindow = require('../../../../../Base/Window');
var EditDesign = require('../../../../../Admin/EditDesign');

var ListItemSelector = require('../../../../../Admin/Design/ListItemSelector');
var Modules = require('../../../../../Admin/Design/Modules');
var ModuleEditor = require('../../../../../Admin/Design/ModuleEditor');
var CategoryEditor = require('../../../../../Admin/Design/CategoryEditor');
var PreviewUpdater = require('../../../../../Admin/Design/PreviewUpdater');
var TrimmingWindow = require('../../../../../Admin/Design/TrimmingWindow');
var HeaderImage = require('../../../../../Admin/Design/HeaderImage');
var HeaderImagePreview = require('../../../../../Admin/Design/HeaderImagePreview');

var DesignDetailPage = {

    init: function init() {
        var $css = $('#css');
        var $form = $('#form-design');
        var $preview = $('#preview');
        var $loading = $('#preview-loading');
        var $tabs = $('#tabs');
        var $foldButton = $('#form-design-fold-button');

        var formState = new FormState();
        formState.observeForm($form);
        formState.observeFormChange();

        var previewUpdater = new PreviewUpdater({
            $form: $form,
            $preview: $('#preview-iframe'),
            $loading: $loading,
            formState: formState
        });
        previewUpdater.requestPreview();

        $form.on('change', function () {
            previewUpdater.requestPreview();
        });

        ListItemSelector.init();
        DesignDetailPage.setupTabs({
            $tabs: $tabs,
            previewUpdater: previewUpdater
        });
        DesignDetailPage.setupFoldButton({
            $form: $form,
            $preview: $preview,
            $foldButton: $foldButton
        });
        DesignDetailPage.setupPreviewTypeButton(previewUpdater);

        _.each(['header-html', 'entry-header-html', 'entry-footer-html', 'footer-html', 'header-touch-html', 'entry-touch-header-html', 'entry-touch-footer-html', 'footer-touch-html', 'touch-under-pager-html'], function (name) {
            var selector = ':input[name = "' + name + '"]';
            var $target = $(selector);

            if (!$target.length) {
                return;
            }
            if ($target.prop('disabled')) {
                return;
            }

            DesignDetailPage.setupEditor({
                syntax: 'html',
                $textarea: $target
            });
        });

        DesignDetailPage.setupEditor({
            syntax: 'css',
            $textarea: $css
        });
        DesignDetailPage.setupBackgroundComponent({
            $css: $css
        });

        var trimmingWindow = new TrimmingWindow($('.js-header-modal-window'));
        DesignDetailPage.setupHeaderImageComponent({
            $container: $('.js-design-header .js-header-image-container'),
            previewUpdater: previewUpdater,
            trimmingWindow: trimmingWindow
        });

        DesignDetailPage.setupTouchHeaderImageComponent({
            $container: $('.js-design-header-touch .js-header-image-container'),
            previewUpdater: previewUpdater
        });

        DesignDetailPage.setupEntryComponent();

        var moduleEditor = new ModuleEditor($('.js-module-edit-modal-window'));
        var categoryEditor = new CategoryEditor();

        // 新規編集時とorder_type選択毎に更新
        $(moduleEditor).on('edit-new-module change-category-order-type', function () {
            categoryEditor.updateCategoryPreview();
        });

        _.each(['sidebar', 'top-page-main-column', 'top-page-header', 'top-page-sidebar', 'touch-top-page-header', 'touch-entry-header', 'touch-entry-footer-primary', 'touch-entry-footer-secondary', 'touch-footer'], function (type) {
            var $element = $('div[data-modules-type="' + type + '"].sidebar-box');
            if (!$element.length) {
                return;
            }

            var modules = new Modules($element, moduleEditor);
            $(modules).on('updated', function () {
                // FormState(ページ閉じる前にconfirm出すやつ)が$formのchangeイベントを見ている
                $form.trigger('change');
            });
        });
        DesignDetailPage.setupAccordion('.accordion-title');

        // プロフィールとサークルは通信してformを書き換える，書き換え終わった状態のフォームの値を初期状態としてセットする
        var profileUpdated = DesignDetailPage.updateProfileModule();
        var circlesUpdated = DesignDetailPage.updateCirclesModule();

        // カテゴリモジュール order_typeプレビュー初期状態
        categoryEditor.updateCategoryPreview();

        $.when(profileUpdated, circlesUpdated).always(function () {
            formState.setFormInitialState();
        });

        DesignDetailPage.setupThemesListSwitcher();

        // スマフォ用テキストエリア，不要なときには隠しておく
        DesignDetailPage.setupTextareaHider();

        // 背景画像もっと見る
        DesignDetailPage.setupSeeMoreBackgrounds();

        // スマフォ用アクセントカラー
        DesignDetailPage.setupTouchAccentColor({
            $form: $form
        });
    },

    setupAccordion: function setupAccordion(selector) {
        var $accordionTitle = $(selector);
        $accordionTitle.next().hide();

        $accordionTitle.click(function () {
            var $title = $(this);
            var $content = $title.next();

            if ($content.is(':visible')) {
                $content.hide();
                $title.removeClass('open');
            } else {
                $content.show();
                $title.addClass('open');
            }
        });
    },

    setupTabs: function setupTabs(args) {
        var $tabs = args.$tabs;
        var previewUpdater = args.previewUpdater;
        var $forcePcView = $('#force-pc-view');

        if (!$tabs[0]) {
            return;
        }

        // タブ切り替えたらプレビューするデバイス切り替える
        // ただし，スマフォにPCのデザインを仕様するときは表示が崩れるので，PC版をプレビュー
        var updateDevice = function updateDevice(event, ui) {
            var panelID = (ui.newPanel || ui.panel).attr('id');
            if (panelID === 'tab-customize-touch' && !$forcePcView.is(':checked')) {
                previewUpdater.setDeviceAsTouch();
            } else {
                previewUpdater.setDeviceAsPC();
            }
        };

        $tabs.on('tabsactivate', updateDevice).on('tabscreate', updateDevice);

        // PCのデザイン表示するかチェックボックスも監視する
        $forcePcView.on('change', function () {
            if ($forcePcView.is(':checked')) {
                previewUpdater.setDeviceAsPC();
            } else {
                previewUpdater.setDeviceAsTouch();
            }
        }).triggerHandler('change');

        $tabs.tabs();
    },

    // サイドバーを畳む機能
    setupFoldButton: function setupFoldButton(args) {
        var $form = args.$form;
        var $preview = args.$preview;
        var $foldButton = args.$foldButton;

        if (!$foldButton[0]) {
            return;
        }

        $foldButton.click(function () {
            if ($foldButton.hasClass('open')) {
                $foldButton.removeClass('open').addClass('close');
                $form.hide();
                $preview.addClass('fold-form');
            } else {
                $foldButton.removeClass('close').addClass('open');
                $form.show();
                $preview.removeClass('fold-form');
            }
        });
    },

    fadeInLoading: function fadeInLoading($loading) {
        $loading.fadeIn('fast');
    },

    fadeOutLoading: function fadeOutLoading($loading) {
        setTimeout(function () {
            $loading.fadeOut('fast');
        }, 1000);
    },

    setupPreviewTypeButton: function setupPreviewTypeButton(previewUpdater) {
        var $switchButton = $('.switch-button');

        $switchButton.click(function () {
            if (previewUpdater.getPageType() === 'index') {
                $switchButton.addClass('permalink').removeClass('index');
                $switchButton.text(Locale.text('admin.design.quit_preview_entry_page'));
                previewUpdater.setAsPermalinkPreview();
                previewUpdater.preview();
            } else {
                $switchButton.addClass('index').removeClass('permalink');
                $switchButton.text(Locale.text('admin.design.preview_entry_page'));
                previewUpdater.setAsIndexPreview();
                previewUpdater.preview();
            }
        });
    },

    setupBackgroundComponent: function setupBackgroundComponent(args) {
        var $css = args.$css;

        var $fileInput = $('input[type="file"].background-image');
        var $bgImage = $('#background-image');
        var $imageThumbnail = $('#background-image-thumbnail');
        var $deleteBgImage = $('a.delete-background-image');
        var $imageSrc = $('input[name="bg-image-src"]');
        var $imageId = $('input[name="bg-image-id"]');
        var $imageSelected = $('input[name="bg-image-selected"]');

        var styletemplate = _.template("body{ background-image: url('<%= image %>'); background-repeat: <%= repeat %>; background-color:<%= backgroundColor %>; background-attachment: <%= attachment %>; background-position: <%= position %> top;}");

        var $bgPosition = $('select[name="background-position"]');
        var $bgRepeat = $('select[name="background-repeat"]');
        var $bgAttachment = $('select[name="background-attachment"]');

        var showBackgroundImage = function showBackgroundImage() {
            $bgImage.show();
        };
        var hideBackgroundImage = function hideBackgroundImage() {
            $bgImage.hide();
        };

        $deleteBgImage.click(function () {
            if (confirm(Locale.text('admin.design.stop_header_image_confirm'))) {
                $imageId.val('');
                $imageSrc.val('');
                $imageSelected.val(0);
                setDesignCSS();

                hideBackgroundImage();
            }
            return false;
        });

        $imageThumbnail.click(function () {
            setDesignCSS();
            if (!$imageThumbnail.hasClass('ui-selected')) {
                // 背景画像の選択をはずす
                var backgroundListItems = $('#backgrounds li');
                backgroundListItems.removeClass('ui-selected');
                $imageThumbnail.addClass('ui-selected');
                $imageSelected.val(1);
            }
        });

        $bgPosition.change(function () {
            setDesignCSS();
        });

        $bgAttachment.change(function () {
            setDesignCSS();
        });

        $bgRepeat.change(function () {
            setDesignCSS();
        });

        // 背景画像のセット
        var setBackgroundImage = function setBackgroundImage(fid) {
            $imageId.val(fid);
            var match = fid.match(/f:id:([^:]+):(\d+)([jpg]):image/);
            if (!match) {
                return;
            }

            var name = match[1];
            var id = match[2];
            var type = match[3];

            var extension = {
                j: '.jpg',
                p: '.png',
                g: '.gif'
            };

            var path = [name.substring(0, 1), name, id.substring(0, 8), id].join('/');
            var image = 'http://cdn-ak.f.st-hatena.com/images/fotolife/' + path + extension[type];
            var thumbnail_src = 'http://cdn-ak.f.st-hatena.com/images/fotolife/' + path + '_120.jpg';

            $imageSrc.val(image);
            $imageThumbnail.attr('src', thumbnail_src);
            showBackgroundImage();
            $fileInput.prop('disabled', false);
            $imageThumbnail.trigger('click');

            // $fileInput.change契機でアップロードしている場合、$fileInput.valueを空にしておかないと同じファイルを選択した時にchangeイベントが発火しないため、がんばって空にする
            var isSupportedFile = typeof FormData !== 'undefined';
            if (isSupportedFile) {
                var $newFileInput = $fileInput.clone(true);
                $fileInput.replaceWith($newFileInput);
                $fileInput = $newFileInput;
            }
        };

        var setDesignCSS = function setDesignCSS() {
            var image = $imageSrc.val();
            var design = new EditDesign($css.val());

            var id;
            var style;

            if (image) {
                var $backgroundColorItem = $('#background-colors li.ui-selected');
                var backgroundColor = 'transparent';

                // 背景色が選択されていない場合はデフォルトを選択
                if ($backgroundColorItem.length === 0) {
                    $('#background-colors li[data-css=""]').addClass('ui-selected');
                } else if ($backgroundColorItem.attr('data-id') !== undefined) {
                    backgroundColor = '#' + $backgroundColorItem.attr('data-id');
                }

                id = 'custom';

                var repeat = $bgRepeat.find('option:selected').val();
                var position = $bgPosition.find('option:selected').val();
                var attachment = $bgAttachment.find('option:selected').val();

                style = styletemplate({
                    image: image,
                    backgroundColor: backgroundColor,
                    repeat: repeat,
                    position: position,
                    attachment: attachment
                });
            } else {
                // 画像外したときはデフォルトに戻す
                id = 'default';
                style = $('li[data-id="default"]').attr('data-css');
            }

            design.setData('background', id, style);
            $css.val(design.getCSS());
            $css.trigger('change');
        };

        var isSupportedFile = typeof FormData !== 'undefined';
        if (isSupportedFile) {
            $fileInput.on('change', function () {
                if (!this.files.length) {
                    return;
                }
                hideBackgroundImage();
                DesignDetailPage.uploadImage({
                    file: this,
                    folder: 'Hatena Blog',
                    fotosize: 3000,
                    $input: $fileInput,
                    callback: setBackgroundImage
                });
            });
        } else {
            DesignDetailPage.setIframeUploader({
                $fileinput: $fileInput,
                fotosize: 3000,
                callback: setBackgroundImage
            });
        }
    },

    // args: { $container, previewUpdater, trimmingWindow, imageSize: {width, height} }
    setupHeaderImageComponent: function setupHeaderImageComponent(args) {
        var $container = args.$container;
        var previewUpdater = args.previewUpdater;
        var trimmingWindow = args.trimmingWindow;

        var imageSize = {
            width: +$container.attr('data-max-width'),
            height: +$container.attr('data-max-height')
        };

        var image = new HeaderImage($container, imageSize);
        var thumbnail = new HeaderImagePreview($container.find('.js-header-image-item'));

        $(image).on('updated', function () {
            if (image.getImageSrc()) {
                thumbnail.render(image.getImageSrc(), image.getThumbnailSrc(), image.getDisplayArea());
            } else if (!image.getImageSrc()) {
                thumbnail.clear();
            }
            previewUpdater.requestPreview();
        });

        var uploaded = DesignDetailPage.setupFotoUpload({
            $input: $container.find('.js-header-image-input'),
            size: imageSize.width
        });

        // アップロードされたら値設定，トリミングはキャンセルされても初回は必ずエリア設定する
        uploaded.progress(function (foto) {
            image.setImage(foto.url, foto.fid);
            trimmingWindow.trim(image.getImageSrc(), image.getTrimmingArea()).always(function (area) {
                image.setDisplayArea(area);
            });
        });

        $container.on('click', '.js-header-image-thumbnail, .jcrop-holder, .js-resizer', function () {
            // アップロード済の画像のトリミング位置変更
            trimmingWindow.trim(image.getImageSrc(), image.getTrimmingArea()).done(function (area) {
                image.setDisplayArea(area);
            });

            return false;
        }).on('click', '.js-delete-header-image', function () {
            // 画像外す
            if (!confirm(Locale.text('admin.design.stop_header_image_confirm'))) {
                return false;
            }

            image.clear();
            return false;
        });
    },

    // スマフォ版のヘッダ画像，トリミング機構がないので単純
    setupTouchHeaderImageComponent: function setupTouchHeaderImageComponent(args) {
        var $container = args.$container;
        var previewUpdater = args.previewUpdater;

        var imageSize = {
            width: +$container.attr('data-max-width'),
            height: +$container.attr('data-max-height')
        };

        var image = new HeaderImage($container, imageSize);

        var $imageItem = $container.find('.js-header-image-item');
        var $thumbnail = $container.find('.js-header-image-thumbnail');

        $(image).on('updated', function () {
            if (image.getImageSrc()) {
                $thumbnail.attr('src', image.getThumbnailSrc()).show();
                $imageItem.show();
            } else {
                $thumbnail.hide();
                $imageItem.hide();
            }

            if (previewUpdater) {
                previewUpdater.requestPreview();
            }
        });

        var uploaded = DesignDetailPage.setupFotoUpload({
            $input: $container.find('.js-header-image-input'),
            size: imageSize.width
        });

        // アップロードされたら値設定
        uploaded.progress(function (foto) {
            image.setImage(foto.url, foto.fid);
        });

        $container.on('click', '.js-delete-header-image', function () {
            // 画像外す
            if (!confirm(Locale.text('admin.design.stop_header_image_confirm'))) {
                return false;
            }
            image.clear();
            return false;
        });
    },

    setupEntryComponent: function setupEntryComponent() {
        // 変数のヘルプ
        $('.js-variable-toggle').click(function () {
            $(this).siblings('.js-variable-help').slideToggle();
            return false;
        });
    },

    // フォトライフへ画像をアップロードの準備，コピペされまくってたののインターフェイス整理したやつ
    // args:
    //   $input: input type=fileのinput
    //   size: 画像の長辺
    // returns: アップロードが完了すると { syntax, url, thumbnail_url } がnotifyされるDeferred
    setupFotoUpload: function setupFotoUpload(args) {
        var $input = args.$input;
        var size = args.size;

        var uploaded = $.Deferred();
        var isSupportedFile = typeof FormData !== 'undefined';

        var callback = function callback(fid) {
            var match = fid.match(/f:id:([^:]+):(\d+)([jpg]):image/);
            if (!match) {
                return;
            }

            var name = match[1];
            var id = match[2];
            var type = match[3];

            var extension = {
                j: '.jpg',
                p: '.png',
                g: '.gif'
            };

            var path = [name.substring(0, 1), name, id.substring(0, 8), id].join('/');
            var url = 'http://cdn-ak.f.st-hatena.com/images/fotolife/' + path + extension[type];
            var thumbnail_url = 'http://cdn-ak.f.st-hatena.com/images/fotolife/' + path + '_120.jpg';

            uploaded.notify({
                fid: fid,
                url: url,
                thumbnail_url: thumbnail_url
            });
        };

        if (isSupportedFile) {
            $input.on('change', function () {
                var input = this;
                if (!this.files.length) {
                    return;
                }
                DesignDetailPage.uploadImage({
                    file: $input[0],
                    $input: $input,
                    folder: 'Hatena Blog',
                    fotosize: size,
                    callback: callback
                });
                return false;
            });
        } else {
            DesignDetailPage.setIframeUploader({
                $fileInput: $input,
                fotosize: size,
                callback: callback
            });
        }

        return uploaded.promise();
    },

    // フォトライフへ画像をアップロード
    uploadImage: function uploadImage(args) {
        var file = args.file;
        var folder = args.folder;
        var fotosize = args.fotosize;
        var $input = args.$input;
        var callback = args.callback;

        $input.prop('disabled', true);

        var data = new FormData();
        data.append('rkm', globalData('rkm'));
        data.append('append', 1);
        data.append('fototitle', '');
        data.append('folder', folder);
        data.append('fotosize', fotosize);
        data.append('image', file.files[0]);
        data.append('delete-gps', 1);

        var $grandparent = $(file).parent().parent();
        var $progress = $grandparent.find('.progress');
        $progress.show();

        var $bar = $progress.find('div.bar');
        $bar.width('0%');

        var $percent = $progress.find('div.percent');

        var updateProgress = function updateProgress(progress) {
            if (progress > 100) {
                progress = 100;
            }
            $bar.width(progress + '%');
            $percent.text(Locale.text('uploading'));
        };

        var xhr = new XMLHttpRequest();

        xhr.upload.addEventListener('progress', function (e) {
            var percent = e.lengthComputable ? e.loaded / e.total * 100 : NaN;
            updateProgress(percent);
        }, false);

        xhr.addEventListener('load', function (e) {
            $input.prop('disabled', false);
            $input.val('');
            updateProgress(100);
            callback(xhr.responseText);
            $progress.hide();
            _.defer(function () {
                updateProgress(0);
            });
        }, false);

        xhr.addEventListener("error", function (e) {
            $progress.addClass('error');
            $input.val('');
            $percent.text('error');
            $input.prop('disabled', false);
        }, false);

        xhr.open('POST', '/f/' + globalData('name') + '/upbysmart');
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        xhr.send(data);
    },

    // IE用にiframeを設置
    setIframeUploader: function setIframeUploader(args) {
        var $fileInput = args.$fileInput;
        var fotosize = args.fotosize;
        var callback = args.callback;

        var $iframe = $('<iframe/>');
        $fileInput.replaceWith($iframe);

        var src = "/api/upload/fotolife_smart";
        $iframe.attr('src', src);
        $iframe.addClass('uploader');

        $iframe.load(function () {
            var document;
            if ($iframe[0].contentDocument) {
                document = $iframe[0].contentDocument;
            } else if ($iframe[0].contentWindow) {
                document = $iframe[0].contentWindow.document;
            } else {
                return;
            }

            if (document.body.innerHTML.match(/^\s*(f:id:\S+)/)) {
                $iframe[0].contentWindow.location.replace(src);
            }

            callback(document.body.innerHTML);

            $(document).find('input[name="fotosize"]').val(fotosize);
            var images = $(document).find('input[type="file"]');
            $(images[0]).change(function () {
                $(document).find('#fotolife-upload-form').submit();
                $(images[0]).replaceWith($('<h5>').text(Locale.text('uploading')));
            });
        });
    },

    // FacebookやTwitterとの連携をしているかを確認し、プロフィールモジュールを更新
    // 更新が終わるとresolveされるDeferredを返す
    updateProfileModule: function updateProfileModule() {
        var updated = $.Deferred();

        $.ajax({
            type: 'GET',
            url: '/api/applications_data',
            dataType: 'json'
        }).done(function (res) {
            var data = res;
            var $profile_modules = $('.js-module-value-component-profile');

            $profile_modules.each(function () {
                var $profile_module = $(this);

                if (data.twitter) {
                    $profile_module.find('.cannot-twitter-button').remove();
                } else {
                    $profile_module.find('.can-twitter-button').remove();
                    $profile_module.find('.cannot-twitter-button').removeClass('cannot-twitter-button').addClass('cannot-twitter-button-display');
                }

                if (data.facebook) {
                    $profile_module.find('.cannot-facebook-follow').remove();
                    $profile_module.find('.cannot-facebook-subscribe').remove();
                } else {
                    $profile_module.find('.can-facebook-follow').remove();
                    $profile_module.find('.can-facebook-subscribe').remove();
                    $profile_module.find('.note').remove();
                    $profile_module.find('.cannot-facebook-follow').removeClass('.cannot-facebook-follow').addClass('.cannot-facebook-follow-display');
                    $profile_module.find('.cannot-facebook-subscribe').removeClass('cannot-facebook-subscribe').addClass('cannot-facebook-subscribe-display');
                }
            });

            updated.resolve();
        }).fail(function () {
            updated.reject();
        });

        return updated.promise();
    },

    // サークルモジュールを更新
    // 更新が終わるとresolveされるDeferredを返す
    updateCirclesModule: function updateCirclesModule() {
        var updated = $.Deferred();
        if ($('#module-value-component-circles').length === 0) {
            updated.resolve();
            return updated.promise();
        }

        $.ajax({
            type: 'GET',
            url: '/api/circles',
            data: { blog: globalData('blogs-uri-base') },
            dataType: 'json'
        }).done(function (res) {
            var mkSelectCircle = _.template($('.js-module-circles-select-circles-template').html().replace(/^\s+|\s+$/g, ''));
            _.each(res.circles, function (circle) {
                $('.js-select-circles-container').each(function () {
                    $(this).append($(mkSelectCircle({ circle: circle })));
                });
            });
            updated.resolve();
        }).fail(function () {
            updated.reject();
        });

        return updated.promise();
    },

    setupEditor: function setupEditor(args) {
        var syntax = args.syntax;
        var $textarea = args.$textarea;

        if (!$textarea[0]) {
            return;
        }

        var container = document.createElement('div');
        $(container).css({
            position: 'absolute',
            top: 'auto',
            left: 0,
            bottom: 50,
            padding: 0,
            margin: 0,
            borderTop: '1px solid #ccc',
            borderBottom: '1px solid #ccc',
            width: '500px',
            height: '400px',
            zIndex: 9999,
            background: '#fff'
        }).appendTo(document.body).hide();

        $textarea.css({
            'font-size': '11px',
            'white-space': 'nowrap',
            'overflow': 'hidden'
        });

        var editor = ace.edit(container);
        editor.commands.removeCommand('gotoline'); // fucking default keybinding of ace
        editor.commands.removeCommand('indent');
        editor.commands.removeCommand('outdent');

        // editor.renderer.setShowGutter(false);
        editor.renderer.setHScrollBarAlwaysVisible(false);
        editor.renderer.setPadding(5);
        editor.renderer.setShowPrintMargin(false);

        editor.setFontSize("10px");
        editor.setHighlightActiveLine(false);

        var Mode = ace.require('ace/mode/' + syntax).Mode;
        var mode = new Mode();

        var session = editor.getSession();
        session.setMode(mode);
        session.setUseWrapMode(true);

        var editorState = new FormState();

        $textarea.focus(function () {
            $(container).show();
            editor.resize();
            editor.focus();
            editorState.enableConfirm();
        });

        editor.on('blur', function () {
            $textarea.val(session.getValue());
            $textarea.trigger('change');
            $(container).hide();
            editorState.disableConfirm();
        });

        $(container).mousedown(function () {
            return false;
        });

        session.setValue($textarea.val());

        $textarea.change(function () {
            session.setValue($textarea.val());
        });

        $('#tabs').on('tabsactivate', function () {
            setTimeout(function () {
                editor.resize();
            }, 0);
        });

        $(window).resize(function () {
            editor.resize();
        });
    },

    setupThemesListSwitcher: function setupThemesListSwitcher() {

        $('.switch-theme-list-types').on('blog:dropdown:selected', '[data-theme-list-type]', function () {
            var listType = $(this).attr('data-theme-list-type');

            $('#themes .themes-container').each(function () {
                $(this).toggle($(this).attr('data-theme-list-type') === listType);
            });
        });

        // 以下は同じような構造だったら使えるので
        // そのまま ['*'] に置いてもいいです。
        var $dropdown = $('.dropdown-container'),
            $dropdownList = $dropdown.find('.dropdown-list').hide();

        $dropdown.on('click', '.dropdown-button, .dropdown-selected', function () {
            var isShown = ModalWindow.toggle($dropdownList);
            $dropdownList.toggleClass('opened', isShown);
            return false;
        }).on('click', '.dropdown-list-item', function () {
            $dropdown.find('.dropdown-selected').text($(this).text());
            $(this).trigger('blog:dropdown:selected');
        }).find('.dropdown-list-item').eq(0).click();
    },

    // スマフォ用HTML編集欄の制御，設定によっては書ける，PC版と同じ内容を表示するモードのときはテキストエリア出さない
    setupTextareaHider: function setupTextareaHider() {
        _.each([['header-touch-show-html-for-pc', '.js-hide-on-header-touch-show-html-for-pc'], ['display-touch', '.js-hide-on-display-touch'], ['footer-touch-show-html-for-pc', '.js-hide-on-footer-touch-show-html-for-pc'], ['header-touch-show-image-for-pc', '.js-hide-on-header-touch-show-image-for-pc']], function (rule) {
            var input_selector = rule[0];
            var target_selector = rule[1];

            var $input = $(':input[name=' + input_selector + ']');
            if (!$input.length) {
                return;
            }

            var $target = $(target_selector);
            if (!$target.length) {
                return;
            }

            var updateVisibility = function updateVisibility() {
                var $checked_input = $(':checked[name=' + input_selector + ']');
                if (!$checked_input.length) {
                    return;
                }

                if (+$checked_input.val()) {
                    $target.hide();
                } else {
                    $target.show();
                }
            };

            // 変更を監視
            // IEではchangeイベントの直後に見ると古い値が取れることがあるのでちょっと待ってる
            $input.on('change', function () {
                _.defer(updateVisibility);
            });

            // 初期状態のセットアップ
            updateVisibility();
        });
    },

    // 昔の背景画像，最初は隠しておいて，もっと読む押したら見せる
    setupSeeMoreBackgrounds: function setupSeeMoreBackgrounds() {
        var $button = $('.js-show-more-background-images');
        $button.one('click', function () {
            $button.remove();
            $('#backgrounds li:hidden').show();
        });
    },

    // アクセントカラー設定UI
    setupTouchAccentColor: function setupTouchAccentColor(args) {
        var $form = args.$form;
        var $accent_color_input = $form.find(':input[name="touch-accent-color"]');

        var $colors = $('#touch-accent-colors');

        var select = function select($color) {
            $colors.find('.selected').removeClass('selected');
            $color.addClass('selected');

            var color = $color.attr('data-color');
            $accent_color_input.val(color);

            $form.trigger('change');
        };

        $colors.on('click', '[data-color]', function () {
            select($(this));
        });

        var first_value = $accent_color_input.val();
        select($colors.find('[data-color="' + first_value + '"]'));
    }

};

module.exports = DesignDetailPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../../Admin/Design/CategoryEditor":17,"../../../../../Admin/Design/HeaderImage":18,"../../../../../Admin/Design/HeaderImagePreview":19,"../../../../../Admin/Design/ListItemSelector":20,"../../../../../Admin/Design/ModuleEditor":22,"../../../../../Admin/Design/Modules":23,"../../../../../Admin/Design/PreviewUpdater":24,"../../../../../Admin/Design/TrimmingWindow":25,"../../../../../Admin/EditDesign":26,"../../../../../Base/FormState":40,"../../../../../Base/Window":49,"../../../../../Base/globalData":52,"../../../../../Locale":151,"underscore":4}],92:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var ConfigDetailPage = {

    init: function init() {
        $('.main-tab').find('.user-blog-config-detail').addClass('current-tab');

        $('#blog-config-custom-domain .check-validity').click(function (e) {
            var $this = $(this);
            $this.attr('disabled', 'disabled').addClass('disabled');
            $('#blog-config-custom-domain .validity-status').text('-');
            $.ajax({
                type: 'POST',
                url: '/api/custom_domain.check',
                data: $this.closest('form').serialize(),
                dataType: 'json',
                success: function success(data) {
                    $('#blog-config-custom-domain .validity-status').text(data.message);
                    $('#blog-config-custom-domain .validity-status.detail').text(data.detail || '');
                },
                complete: function complete() {
                    $this.removeAttr('disabled').removeClass('disabled');
                }
            });
            return false;
        });
    }

};

module.exports = ConfigDetailPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],93:[function(require,module,exports){
'use strict';

var Location = require('../../../../../Base/Location');

var ConfigExternalPage = {

    init: function init() {
        var withParentWindow = Location.param('with_parent_window');
        var callback = Location.param('callback');

        // 親windowがあって、OAuth認証から戻ってきた時はwindowを閉じる
        if (withParentWindow && callback) {
            window.close();
        }
    }

};

module.exports = ConfigExternalPage;

},{"../../../../../Base/Location":43}],94:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var BlogPermission = require('../../../../../Admin/BlogPermission');

var ConfigPermissionPage = {

    init: function init() {
        new BlogPermission($('#blog-permission-container'));
    }

};

module.exports = ConfigPermissionPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../../Admin/BlogPermission":11}],95:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var ThemePreviewPage = {

    init: function init() {
        var $previewForm = $('#theme-preview-form');
        var $saveForm = $('#theme-install-form');
        var noticeMessage = $saveForm.find('.notice').text();

        $saveForm.on('submit', function () {
            return confirm(noticeMessage);
        });

        $previewForm.submit();
    }

};

module.exports = ThemePreviewPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],96:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var AccessLog = require('../../../../Admin/AccessLog');

var AccessLogPage = {

    init: function init() {
        var table = $('#access-counts').remove();
        var counts = {};
        table.find('tr').each(function () {
            var $this = $(this);
            var time = +$this.find('td[data-time]').attr('data-time');
            var count = +$this.find('td[data-count]').attr('data-count');
            counts[time] = count;
        });

        AccessLog.showGraph(counts, {
            parent: $('#access-counts-daily'),
            timeformat: '%m/%d',
            minTickSize: [1, 'day'],
            unit: 24 * 60 * 60 * 1000,
            number: 31
        });

        AccessLog.showGraph(counts, {
            parent: $('#access-counts-hourly'),
            timeformat: '%d %H:%M',
            minTickSize: [1, 'hour'],
            unit: 60 * 60 * 1000,
            number: 48
        });

        $('#access-counts-tabs').tabs({ active: 0 });

        $('#summary-detail-tabs').tabs({ active: 0 });

        $('.summary-box .hosts').delegate('.host', 'click', function () {
            $('.summary-box .hosts .selected').removeClass('selected');
            $(this).addClass('selected');

            var host = $(this).attr('data-site-host');
            $('.summary-box .site.selected').removeClass('selected');
            $('.summary-box .sites').find('*[data-site-host="' + host + '"]').addClass('selected');
            return false;
        });
    }
};

module.exports = AccessLogPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Admin/AccessLog":5}],97:[function(require,module,exports){
'use strict';

var BreadcrumbEditor = require('../../../../Admin/BreadcrumbEditor');

/**
 * パンくずページ
 */
var BreadcrumbPage = {
    init: function init() {
        var container = document.querySelector('.js-rules-container');

        BreadcrumbEditor.init(container);
    }
};

module.exports = BreadcrumbPage;

},{"../../../../Admin/BreadcrumbEditor":16}],98:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Window = require('../../../../Base/Window');

var CategoriesPage = {

    init: function init() {
        var openRenameModalWindow = function openRenameModalWindow(category_name) {
            var $modal = $('.js-rename-modal-window[data-category-name="' + category_name + '"]');
            if ($modal.is(':visible')) return;
            Window.show($modal, {});
            $modal.find(':text').val(category_name).focus()[0].select();
        };
        $(document).on('click', '.js-show-rename-modal-window', function (event) {
            var category_name = $(event.target).attr('data-category-name');
            openRenameModalWindow(category_name);
        });

        // Hatena.Diary.Windowは，documentをclickすると，hideAllする．
        // .js-rename-modal-windowから外にclickイベントを伝播させないため，ここで止める．
        // モーダルウィンドウ内のclickイベントをdocument.on とかで待っていても，ここで止めているので，
        // 非効率ではあるが，closeボタンなど個別にイベントハンドラを設定している．
        // ボタンの数はあとから増えないので，これで問題ない．
        $('.js-rename-modal-window .js-icon-close').on('click', function () {
            Window.hideAll();
        });
        $('.js-rename-modal-window').on('click', function (event) {
            event.stopPropagation();
        });
    }
};

module.exports = CategoriesPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Base/Window":49}],99:[function(require,module,exports){
'use strict';

var Messenger = require('../../../../Messenger');
var sendResizeRequest = require('../../../../Util/sendResizeRequest');

var CommentPage = {

    init: function init() {
        Messenger.listenToParent();
        CommentPage.focusTextArea();
        sendResizeRequest();
    },

    focusTextArea: function focusTextArea() {
        // IE9でfocusできないことがあるので時間を置いて何度も試す
        try {
            $('#body').focus();
        } catch (e) {
            setTimeout(CommentPage.focusTextArea, 100);
        }
    }

};

module.exports = CommentPage;

},{"../../../../Messenger":152,"../../../../Util/sendResizeRequest":176}],100:[function(require,module,exports){
'use strict';

var Locale = require('../../../../Locale');
var updateDynamicPieces = require('../../../../Util/updateDynamicPieces');

var CommentsPage = {

    init: function init() {
        $('button[name="mode"][value="delete"]').click(function () {
            return confirm(Locale.text('admin.comments.delete.confirm'));
        });

        updateDynamicPieces($('.js-comments-table'));
    }

};

module.exports = CommentsPage;

},{"../../../../Locale":151,"../../../../Util/updateDynamicPieces":180}],101:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('../../../../Base/globalData');

var Export = function Export(downloadURL, reserveURL) {
    this.downloadURL = downloadURL;
    this.reserveURL = reserveURL;
};

Export.prototype = {
    // 現在のエクスポート状態を同期的に返す
    // 状態は，not-created, running, completed の3つである
    getStatus: function getStatus() {
        return this.status;
    },
    // 日付の文字列を返す
    // HTTPヘッダの値からYYYY/MM/DD形式の文字列を作ろうとするが，失敗したら，HTTPヘッダの値そのものを返す
    getDate: function getDate() {
        var date = this.date;

        if (!date) return null;

        var parsedDate;
        try {
            parsedDate = new Date(Date.parse(date));
            return [parsedDate.getFullYear(), parsedDate.getMonth() + 1, parsedDate.getDate()].join("/");
        } catch (ignore) {}
        return date;
    },
    // 状態をサーバーから取得して更新する
    // /downloadは，以下のレスポンスコードを返すので，それを見て判断する
    // - 200: エクスポート完了しているとき
    // - 404: 一度もエクスポートしていないか，エクスポート失敗したとき
    // - 503: エクスポート中のとき
    fetchStatus: function fetchStatus() {
        var self = this;
        $.ajax({
            url: self.downloadURL,
            method: 'HEAD',
            cache: false
        }).done(function (_ignore, __ignore, res) {
            self.date = res.getResponseHeader('Date');
            self.status = 'completed';
            self._updated();
        }).fail(function (res) {
            self.date = null;
            if (res.status === 503) {
                self.status = 'running';
                setTimeout(function () {
                    self.fetchStatus();
                }, 1000);
            } else {
                self.status = 'not-created';
            }
            self._updated();
        });
    },
    // エクスポートを予約する
    reserveExport: function reserveExport() {
        var self = this;
        $.ajax({
            url: self.reserveURL,
            method: 'POST',
            data: {
                rkm: globalData('rkm'),
                rkc: globalData('rkc')
            }
        }).always(function () {
            self.fetchStatus();
        });
        self.status = 'running';
        self._updated();
    },
    _updated: function _updated(data) {
        $(this).triggerHandler('updated');
    }
};

var ExportMovableTypePage = {

    init: function init() {
        var $container = $('.js-export-wrapper');
        var $panels = $container.find('.js-export-control-panel');
        var $reserveCompletedAt = $container.find('.js-reserve-completed-at');
        var $reserveButton = $container.find('.js-reserve-export-button');
        var $successMessage = $('.js-export-success-message');

        var statusToSelector = {
            'not-created': '.js-reserve-export-wrapper',
            'running': '.js-exporting-wrapper',
            'completed': '.js-export-completed-wrapper'
        };

        var exportModel = new Export($container.attr('data-download-url'), $container.attr('data-reserve-url'));

        $reserveButton.on('click', function () {
            exportModel.reserveExport();
        });

        $(exportModel).on('updated', function () {
            var status = exportModel.getStatus();
            $panels.hide();
            $container.find(statusToSelector[status]).show();
            $reserveCompletedAt.text(exportModel.getDate());
            if (status === 'completed') {
                $successMessage.show();
            } else {
                $successMessage.hide();
            }
        });

        exportModel.fetchStatus();
    }
};

module.exports = ExportMovableTypePage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Base/globalData":52}],102:[function(require,module,exports){
'use strict';

var Messenger = require('../../../../Messenger');

/**
 * はてなOneとの連携用ページ？のコントローラ
 * 不要なので削除予定
 * blog.hatena.ne.jp/my/friend
 */
var FriendPage = {

    init: function init() {
        Messenger.listenToParent();
    }
};

module.exports = FriendPage;

},{"../../../../Messenger":152}],103:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../../Messenger');

function showCategories(superCategory) {
    if (superCategory) {
        var $categories = $('.categories-container').filter(function () {
            return $(this).attr('data-super-category') === superCategory;
        }).show();

        if ($categories.length > 0) {
            $('#super-categories-container').hide();
            $('.submit-form-controls').show();
            location.hash = '#' + superCategory;
        }
        $('.back-button').show();
    } else {
        $('#super-categories-container').show();
        $('.categories-container').hide();
        $('.submit-form-controls').hide();
        $('.back-button').hide();
        location.hash = '#';
    }
}

/**
 * ブログ新規作成時、グループへの参加を促すダイアログページのコントローラ
 */
var GroupOfficialDialogPage = {

    init: function init() {
        $(window).hashchange(function () {
            var m = /^#((?:\w|-)+)$/.exec(location.hash);
            if (m) {
                showCategories(m[1]);
            } else {
                showCategories(false);
            }
        }).hashchange();

        $('#super-categories-container .select-super-category').click(function () {
            var superCategory = $(this).closest('[data-super-category]').attr('data-super-category');
            showCategories(superCategory);
            return false;
        });

        $('.back-button').click(function () {
            showCategories(false);
            return false;
        });

        Messenger.listenToParent();
        Messenger.send('resize', {
            height: 620,
            width: 620
        });

        $('.skip-button').click(function () {
            Messenger.send('close');
            return false;
        });

        $('form').submit(function () {
            var $form = $(this);

            $.ajax($form.attr('action'), {
                method: $form.attr('method'),
                data: $form.serialize()
            }).always(function () {
                Messenger.send('close');
            });

            Messenger.send('hide');

            return false;
        });
    }
};

module.exports = GroupOfficialDialogPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Messenger":152}],104:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../../../../Locale');
var ImportProgressBar = require('../../../../Admin/Import/ProgressBar');

var ImportPage = {

    init: function init() {
        var $progress = $('.js-import-progress');
        if (!$progress[0]) {
            return;
        }

        var $bar = $progress.find('.js-import-bar');
        var apiUrl = $progress.attr('data-api-url');
        var onCompleteUrl = $progress.attr('data-on-complete-url');

        ImportProgressBar.init($bar, apiUrl, onCompleteUrl);

        $('.js-revert-import').on('submit', function () {
            return confirm(Locale.text('admin.import.undo.confirm'));
        });
    }
};

module.exports = ImportPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Admin/Import/ProgressBar":27,"../../../../Locale":151}],105:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var MembersPage = {

    init: function init() {
        $('.js-manage-members-table').on('click', '.js-edit-role', function () {
            var $row = $(this).parents('.js-member-row');
            $row.find('.js-form-member-update').show();
            $row.find('.js-member-role').hide();
        }).on('click', '.js-edit-cancel', function () {
            var $row = $(this).parents('.js-member-row');
            $row.find('.js-member-role').show();
            $row.find('.js-form-member-update').hide();
        });
    }
};

module.exports = MembersPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],106:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../../../../Messenger');
var preventDuplicateSubmit = require('../../../../Util/preventDuplicateSubmit');
var sendResizeRequest = require('../../../../Util/sendResizeRequest');

var SubscribePage = {

    init: function init() {
        $('#subscribe-form').submit(function () {
            preventDuplicateSubmit($(this));
        });
        Messenger.listenToParent();
        sendResizeRequest();

        $('section input[type=checkbox]').focus();
    }
};

module.exports = SubscribePage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Messenger":152,"../../../../Util/preventDuplicateSubmit":174,"../../../../Util/sendResizeRequest":176}],107:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../../Locale');
var SubscribeButton = require('../../SubscribeButton');

var AntennaPage = {

    init: function init() {

        // 購読しているブログのセットアップ
        var setupEntryBox = function setupEntryBox($recentEntryBox) {
            var $recentEntries = $recentEntryBox.find('li.posts');
            var $moreButton = $recentEntryBox.find('li.more');
        };

        var $recentEntryBoxes = $('.entry-unit-older-post');
        $recentEntryBoxes.each(function () {
            setupEntryBox($(this));
        });

        $('.entry-unit').on('click', '.more', function (e) {
            var $button = $(this);
            var $recentEntries = $button.siblings('li.posts:hidden');
            $recentEntries.slideToggle('fast');
            $button.addClass('is-hidden');
        });

        var $closedBlogs = $('.closed-blog');
        $closedBlogs.each(function () {
            var $closedBlog = $(this);
            var antennaUrl = $closedBlog.data("antennaUrl");
            $.ajax({
                type: 'GET',
                url: antennaUrl,
                data: { device: 'pc' },
                dataType: 'html',
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                }
            }).done(function (res) {
                $closedBlog.empty();
                $closedBlog.append(res);
                setupEntryBox($closedBlog);
                var $blogContents = $closedBlog.find('.js-blog-content');
                Locale.updateTimestamps($blogContents[0]);
            });
        });

        // 先輩ブログのセットアップ
        var setUpRecommendedBlogs = function setUpRecommendedBlogs() {
            var $wrapper = $('.js-admin-subscribe-recommended-wrapper');
            var $recommendedBlogs = $wrapper.find('.recommend-blog');
            var $moreButton = $wrapper.find('.more');

            $recommendedBlogs.each(function (i) {
                var $li = $(this);
                var $el = $(this).find('.js-hatena-follow-button-box');

                var userData = {
                    isSubscribing: false,
                    isGuest: false
                };
                var blogUrl = $li.data('blogHost');
                var blogData = {
                    subscribersCount: parseInt($el.data('subscribers-count'), 10),
                    blogUrl: blogUrl,
                    requestUrl: [Hatena.Diary.data('admin-domain'), $li.data('author'), blogUrl, 'subscribe'].join('/')
                };

                new SubscribeButton.Admin($el, userData, blogData);
            });

            var unit = 10; // 一度に表示する件数

            var head = $recommendedBlogs.filter(':visible').length; // 現在表示されてる件数
            var tail = head + unit; // 次回表示する件数

            var showMoreBlogs = function showMoreBlogs() {
                $recommendedBlogs.filter(function (i) {
                    return head <= i && i < tail;
                }).fadeIn('fast');

                head = tail;
                tail += unit;
            };

            $moreButton.on('click', function (e) {
                showMoreBlogs();
                if ($recommendedBlogs.length < head) {
                    $moreButton.addClass('is-hidden');
                }
            });
        };
        setUpRecommendedBlogs();
    }

};

module.exports = AntennaPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Locale":151,"../../SubscribeButton":159}],108:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Circle = require('../../Base/Circle');

var CirclePage = {

    init: function init() {
        $('.membership-category').each(function (i, container) {
            var $container = $(container);
            var $select = $container.find('.membership-category-select');
            var current = $select.find('option:selected').val();
            var $indicator = $container.find('.indicator');

            $select.change(function (e) {
                Circle.updateMembershipCategory($select).done(function (data) {
                    $indicator.find('.success').show();
                    $indicator.find('.fail').hide();
                }).error(function (data) {
                    $select.val(current);
                    $indicator.find('.success').hide();
                    $indicator.find('.fail').show();
                });
            });
        });
    }

};

module.exports = CirclePage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/Circle":32}],109:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var ConfigPage = {

    init: function init() {
        Hatena.Diary.Util.updateDynamicPieces($('#user-config'));
    }

};

module.exports = ConfigPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],110:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('../../Base/globalData');
var Browser = require('../../Base/Browser');
var needComrule2013 = require('../../Util/needComrule2013');
var Pages = require('../../Base/Pages');
var inheritVia = require('../../Base/inheritVia');
var LOG = require('../../Base/Logger').LOG;
var BUG = require('../../Base/Logger').BUG;
var SubscribeButton = require('../../SubscribeButton');

/**
 * グローバルヘッダのコントローラ
 */
var GlobalHeaderPage = {

    init: function init() {
        Messenger.listenToParent();

        var BASE = location.hostname.match(/\.hatena\.[^:]+/)[0];

        var header = $('#header');
        var headerServices = $('#header-services');
        var headerNotify = $('#header-notify');
        var headerUnread = $('#header-unread');
        var headerLocale = $('#header-locale');

        var blogUri = decodeURIComponent(location.hash.substring(1));
        var loc = globalData('admin-domain') + '/go?blog=' + encodeURIComponent(blogUri);

        var publicUserInfo = $.ajax({
            type: 'get',
            dataType: 'jsonp',
            url: 'https://www' + BASE + '/notify/notices.count.json',
            data: {
                services: 1
            }
        });

        if (!Browser.isIE) {
            // IE以外のときはcanvasでドロップダウン画像を合成したりする
            var dropdownColor = document.body.getAttribute('data-color');
            GlobalHeaderPage.renderDropdown(dropdownColor);
        }

        header.delegate('.header-dropdown', {
            keypress: function keypress(event) {
                if (event.which !== 13) {
                    return;
                }

                $(event.currentTarget).click();
                event.preventDefault();
                event.stopPropagation();
            },
            mouseup: function mouseup(event) {
                event.currentTarget.blur();
            }
        });

        header.find('a.new-entry').on('click', function () {
            Messenger.send('new-entry', {});
            return false;
        });

        header.find('a.feedback').on('click', function (e) {
            var $feedback = $(e.currentTarget);
            Messenger.send('feedback', {
                left: $feedback.offset().left,
                uri: globalData('feedback')
            });
            return false;
        });

        header.find('.units a').on('click', function (e) {
            var $units = $(e.currentTarget);
            Messenger.send('units', {
                left: $units.offset().left,
                uri: '/-/units'
            });
            return false;
        });

        headerLocale.find('.header-dropdown').on('click', function () {
            Messenger.send('locale', {});
            return false;
        });

        headerServices.find('.header-dropdown').on('click', function (e) {
            var $dropdown = $(e.currentTarget);
            publicUserInfo.done(function (info) {
                Messenger.send('servicesmenu', {
                    BASE: BASE,
                    right: $dropdown.offset().left + $dropdown.width(),
                    info: info,
                    location: loc
                });
            });
            return false;
        });

        headerNotify.find('.header-dropdown').on('click', function (e) {
            var $dropdown = $(e.currentTarget);
            Messenger.send('notify', {
                BASE: BASE,
                left: $dropdown.offset().left
            });
            headerNotify.find('.notify-count').text('').hide();
            return false;
        });

        headerUnread.find('.header-button').on('click', function () {
            Messenger.send('unread');
            return false;
        });

        $('.locale .header-dropdown').on('click', function (e) {
            var $dropdown = $(e.currentTarget);
            Messenger.send('locale', {
                height: +$dropdown.attr('data-height-hint'),
                right: $dropdown.offset().left + $dropdown.width()
            });
            return false;
        });

        publicUserInfo.done(function (data) {
            if (data.count > 0) {
                headerNotify.find('.notify-count').text(data.count).show();
            } else {
                headerNotify.find('.notify-count').text('').hide();
            }
        });

        publicUserInfo.done(needComrule2013);

        // 未読カウント
        var adminDomain = globalData('admin-domain').replace(/https?\:/, '');
        var unreadUrl = adminDomain + '/api/recent_subscribing';

        if (globalData('rkm') && globalData('rkc')) {
            $.ajax({
                url: unreadUrl,
                type: 'get',
                cache: false,
                dataType: 'json'
            }).done(function (res) {
                if (res && res.count) {
                    var count = +res.count;
                    if (count === 0) {
                        return;
                    }

                    var badge = headerUnread.find('.unread-count');
                    badge.show();

                    // 未読20件以上はカウントしない
                    if (count > 20) {
                        badge.text('20');
                    } else {
                        badge.text(res.count);
                    }
                }
            });
        }

        Pages.loadInfo().done(function (info) {

            // 購読ボタン周りの処理
            // admin版とblogs版ボタンの同期のため、常に実行する
            GlobalHeaderPage.initSubscribe(info);

            // 引用ボタン周りの処理
            GlobalHeaderPage.initQuoteStock(info);

            // ユーザ名をクリックしたらmymenuを開く
            var $mymenu = $('#header-my');
            $mymenu.on('click', function () {
                Messenger.send('mymenu', {
                    BASE: BASE,
                    right: $mymenu.offset().left + $mymenu.width()
                });
                return false;
            });

            if (header.attr('data-page-category') === 'blogs') {
                // 非公開ブログなら鍵を表示
                // ブログタイトルはそのあとにappendする
                if (!info.is_public) {
                    $('.js-blog-private-badge').show();
                }

                // 特定のブログを見ている時はブログ名を表示
                if (info.blog_name) {
                    $('#current-blog .current-blog-title').append(document.createTextNode(info.blog_name));
                }

                GlobalHeaderPage.initBlogDropdown(BASE);
            }
            if (header.attr('data-page-category') === 'admin') {
                GlobalHeaderPage.initAdminDropdown();
            }
        });

        $('.login').attr('href', 'https://www.hatena.ne.jp/login?location=' + encodeURIComponent(loc));

        // globalheaderはキャッシュされているので、jsでviaの引き継ぎをする
        Messenger.addEventListener('inheritVia', function (via) {
            LOG(['inheritVia', via]);
            inheritVia(via);
        });

        Messenger.addEventListener('newEntryGeometry', function () {
            var $newEntry = $('a.new-entry');
            var offset = $newEntry.offset();

            Messenger.send('newEntryGeometry', {
                top: offset.top,
                left: offset.left,
                height: $newEntry.height(),
                width: $newEntry.width()
            });
        });
    },

    coloringSvgHeader: function coloringSvgHeader(img, callbackWithJqueryObj) {
        // ここまでに複数のeventがfireしてることがある?
        img.onload = null;

        try {
            var color = document.body.getAttribute('data-color');
            $(img).find('path').attr('fill', color);
        } catch (e) {
            BUG(e, 'render logo');
        }

        callbackWithJqueryObj($(img));
    },

    renderDropdown: function renderDropdown(color) {
        var img = new Image();
        img.src = '/images/header/dropdown@2x.png?version=' + globalData('version');

        img.onload = function () {
            try {
                img.onload = null;

                var canvas = document.createElement('canvas');
                canvas.setAttribute('width', 24);
                canvas.setAttribute('height', 24);
                if (!canvas.getContext) {
                    return;
                }

                var ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0);
                ctx.globalCompositeOperation = 'source-in';
                ctx.fillStyle = color;
                ctx.fillRect(0, 0, 24, 24);
                if (!canvas.toDataURL) {
                    return;
                }

                var data = canvas.toDataURL();

                var style = document.createElement('style');
                style.setAttribute('type', 'text/css');
                style.appendChild(document.createTextNode('\n                    #header span.header-dropdown,\n                    #header span.header-dropdown-custom {\n                        background: url(' + data + ') center right no-repeat; background-size: 12px 12px;\n                    }\n                '));
                document.body.appendChild(style);
            } catch (e) {
                BUG(e, 'render logo dropdown');
                img.src = '/images/header/dropdown.gif?version=' + globalData('version');
            }
        };
    },

    initAdminDropdown: function initAdminDropdown() {
        var $blogmenuButton = $('#current-blog');
        var $blogmenuTitle = $blogmenuButton.find('.current-blog-title');

        // 編集画面では、編集中のブログ名を表示する
        Messenger.addEventListener('showBlogInfo', function (data) {
            $blogmenuButton.show();
            $blogmenuTitle.text(data.blogName);
            if (!data.blogIsPublic) {
                $('.js-blog-private-badge').show();
            }

            // 「記事を書く」ボタンをダッシュボードボタンに変える
            $('.service-menu .edit').hide();
            $('.service-menu .admin-blog').show();

            // ブログ名をクリックしたらドロップダウン出す
            $('#current-blog, #my-blogs').on('click', function (e) {
                var $blog = $(e.currentTarget);
                Messenger.send('blogmenuAdmin', {
                    left: $blog.offset().left,
                    blogUri: data.blogUri
                });
                return false;
            });
        });
    },

    initBlogDropdown: function initBlogDropdown(BASE) {

        var $blogmenuButton = $('#current-blog');
        $blogmenuButton.show();

        $('#current-blog, #my-blogs').on('click', function (e) {
            var $blog = $(e.currentTarget);
            Messenger.send('blogmenu', {
                BASE: BASE,
                left: $blog.offset().left
            });
            return false;
        });
    },

    initSubscribe: function initSubscribe(info) {
        // グローバルヘッダにある購読ボタンの処理
        // 購読済なら出さない
        // 自分のブログ購読しても仕方ないので，このブログになんか書ける人にも出さない
        if (!info.subscribe && !info.can_open_editor) {
            (function () {
                var $subscribe = $('.js-globalheader-subscribe');
                var $done = $('.js-globalheader-subscribed-message');

                $subscribe.show();

                $subscribe.on('click', function () {
                    Messenger.send('subscribe', {
                        left: $subscribe.offset().left
                    });
                    return false;
                });

                // 購読完了したら「購読中です」出す
                Messenger.addEventListener('subscribed-current-blog', function () {
                    $subscribe.hide();
                    $done.show().delay(3000).fadeOut('slow');
                });
            })();
        }

        // 購読ボタンのadmin版とblogs版との同期を行う
        // admin -> blogs
        window.addEventListener('storage', function (event) {
            if (event.key !== 'subscription') {
                return;
            }
            Messenger.send('subscription', JSON.parse(event.newValue));
        });
        // blogs -> admin
        Messenger.addEventListener('subscription', function (data) {
            for (var key in data) {
                SubscribeButton.Admin.setSubscription(key, data[key]);
            }
        });
    },

    initQuoteStock: function initQuoteStock() {

        Messenger.addEventListener('stockQuote', function (data) {
            if (!data.uri || !data.selected_text) {
                Messenger.send('failStockQuote', {});
            }

            $.ajax({
                url: '/api/quotes',
                data: {
                    uri: data.uri,
                    body: data.selected_text,
                    rkm: globalData('rkm'),
                    rkc: globalData('rkc')
                },
                cache: false,
                type: 'post',
                dataType: 'json'
            }).done(function (res) {
                Messenger.send('successStockQuote', {
                    res: res
                });
            }).fail(function (res) {
                Messenger.send('failStockQuote', {
                    res: res
                });
            });
        });

        // 編集サイドバーの「引用貼り付け」を開き、かつ、
        // ストックした最新の引用を記事に埋め込んだ状態の編集画面を開く
        // admin -> blogs
        Messenger.addEventListener('quote-edit-entry', function () {
            Messenger.send('new-entry-with-quote');
        });

        Messenger.addEventListener('requote-edit-entry', function (data) {
            try {
                localStorage.setItem('ReQuote', JSON.stringify(data.quote));
            } catch (e) {}

            Messenger.send('new-entry-with-requote');
        });
    }

};

module.exports = GlobalHeaderPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/Browser":31,"../../Base/Logger":44,"../../Base/Pages":46,"../../Base/globalData":52,"../../Base/inheritVia":53,"../../SubscribeButton":159,"../../Util/needComrule2013":171}],111:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../../Locale');

var IndexPage = {

    init: function init() {

        $('.access-graph[itemscope]').each(function () {
            var $this = $(this);
            var i = 0;var data = $this.find('meta').map(function () {
                return [[i++, +this.getAttribute('content')]];
            });

            $.plot($this, [{
                data: data,
                bars: { show: true, lineWidth: 0.7 },
                points: { show: false },
                legend: { show: false },
                shadowSize: 0
            }], {
                xaxis: {
                    min: 0,
                    ticks: []
                },
                yaxis: {
                    min: 1,
                    autoscaleMargin: 0.1,
                    ticks: []
                },
                grid: {
                    show: false
                }
            });
        });
        $(document.body).click(function () {
            $('.config-dropdown-window').removeClass('open');
        });
        $('.dropdown-toggle').click(function () {
            var dropdown = $(this).closest('.myblog-box').find('.config-dropdown-window');
            if (dropdown.hasClass('open')) {
                dropdown.removeClass('open');
            } else {
                $('.config-dropdown-window').removeClass('open');
                dropdown.addClass('open');
            }
            return false;
        });

        // cookieもってたら非公開ブログの情報も表示するアンテナ
        var $closedBlogs = $('.closed-blog');
        $closedBlogs.each(function () {
            var $closedBlog = $(this);
            var antennaUrl = $closedBlog.data("antennaUrl");
            $.ajax({
                type: 'GET',
                url: antennaUrl,
                data: { lite: 1, device: 'pc' },
                dataType: 'html',
                crossDomain: true,
                xhrFields: {
                    withCredentials: true
                }
            }).done(function (res) {
                var $res = $($.parseHTML(res));
                $closedBlog = $closedBlog.replaceWith($res);
                var $blogContents = $res.find('.js-blog-content');
                Locale.updateTimestamps($blogContents[0]);
            });
        });

        this.getDashboardData();
    },

    getDashboardData: function getDashboardData() {
        $.ajax({
            type: 'GET',
            url: '/-/dashboard_data'
        }).done(function (data) {
            if ($('section.js-hot-entries-section').length) {
                $('section.js-hot-entries-section').append(data.hot_entries);
            }

            if ($('section.js-hot-blogs-section').length) {
                $('section.js-hot-blogs-section').append(data.hot_blogs);
            }

            if ($('section.js-recent-blogs-section').length) {
                $('section.js-recent-blogs-section').append(data.recent_blogs);
            }

            if ($('section.js-subscribing-blogs-section').length) {
                $('section.js-subscribing-blogs-section').append(data.subscribing_blogs);
            }

            Locale.updateTimestamps();
        });
    }

};

module.exports = IndexPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Locale":151}],112:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../../Locale');
var Messenger = require('../../Messenger');
var sendResizeRequest = require('../../Util/sendResizeRequest');

var LocalePage = {

    init: function init() {
        Messenger.listenToParent();

        $('#locale-window a').on('click', function () {
            var $this = $(this);
            var lang = $this.attr('data-lang');
            Locale.setAcceptLang(lang);
            Messenger.send('reload');
            return false;
        });

        sendResizeRequest();
    }

};

module.exports = LocalePage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Locale":151,"../../Messenger":152,"../../Util/sendResizeRequest":176}],113:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var globalData = require('../../Base/globalData');
var extend = require('../../Util/extend');

var RefusalPage = {

    init: function init() {

        var RefusedUser = function RefusedUser(name) {
            if (name.length < 2) throw "invalid name";
            this.name = name;
        };
        RefusedUser.prototype = {
            getName: function getName() {
                return this.name;
            },
            getProfileImage: function getProfileImage() {
                return 'http://cdn1.www.st-hatena.com/users/' + this.getName().substr(0, 2) + '/' + this.getName() + '/profile.gif';
            },
            getURL: function getURL() {
                return 'http://profile.hatena.ne.jp/' + this.getName() + '/';
            },
            getHatenaID: function getHatenaID() {
                return 'id:' + this.getName();
            },
            equals: function equals(user) {
                return this.name === user.name;
            }
        };
        RefusedUser.loadUserNames = function (userNames) {
            return _.map(userNames, function (name) {
                return new RefusedUser(name);
            });
        };

        var RefusalManager = function RefusalManager() {
            this.init.apply(this, arguments);
        };
        RefusalManager.prototype = {
            init: function init() {
                this.refusals = [];
            },
            load: function load(refusals) {
                this.refusals = refusals;
                $(this).trigger('refusalsChanged');
            },
            add: function add(refusal) {
                var self = this;
                if (self.isRefused(refusal)) return;

                var refusals = self.refusals.concat(refusal);
                this._save(refusals).done(function () {
                    $(self).trigger('refusalAdded');
                }).fail(function () {
                    $(self).trigger('refusalSaveFailed');
                });
            },
            remove: function remove(refusal) {
                var self = this;
                if (!self.isRefused(refusal)) return;

                var refusals = _.reject(self.refusals, function (target) {
                    return self.isEqual(refusal, target);
                });
                this._save(refusals).done(function () {
                    $(self).trigger('refusalRemoved');
                }).fail(function () {
                    $(self).trigger('refusalSaveFailed');
                });
            },
            isEqual: function isEqual(refusal, other) {
                return refusal === other;
            },
            isRefused: function isRefused(refusal) {
                var self = this;
                return _.find(this.refusals, function (target) {
                    return self.isEqual(refusal, target);
                });
            },
            getRefusals: function getRefusals() {
                return this.refusals;
            },
            _save_url: 'specify this',
            _getSaveParams: function _getSaveParams(refusals) {
                throw new Error('implement this');
            },
            _save: function _save(refusals) {
                var self = this;
                var saved = $.Deferred();
                $.ajax({
                    url: self._save_url,
                    type: 'POST',
                    data: _.extend(self._getSaveParams(refusals), {
                        rkm: globalData('rkm'),
                        rkc: globalData('rkc')
                    }),
                    traditional: true,
                    dataType: 'json'
                }).done(function () {
                    self.refusals = refusals;
                    $(self).trigger('refusalsChanged');
                    saved.resolve();
                }).fail(function () {
                    saved.reject();
                });
                return saved;
            }
        };

        var UserRefusalManager = function UserRefusalManager() {
            this.init.apply(this, arguments);
        };
        UserRefusalManager.prototype = {
            getUserNames: function getUserNames() {
                return _.map(this.refusals, function (user) {
                    return user.getName();
                });
            },
            isEqual: function isEqual(user, other) {
                return user.equals(other);
            },
            _save_url: '/-/refusal/save',
            _getSaveParams: function _getSaveParams(users) {
                return {
                    user_names: _.map(users, function (user) {
                        return user.getName();
                    })
                };
            }
        };
        extend(UserRefusalManager.prototype, RefusalManager.prototype);

        var IpRefusalManager = function IpRefusalManager() {
            this.init.apply(this, arguments);
        };
        IpRefusalManager.prototype = {
            _save_url: '/-/refusal/save_refused_ips',
            _getSaveParams: function _getSaveParams(ips) {
                return { ips: ips };
            }
        };
        extend(IpRefusalManager.prototype, RefusalManager.prototype);

        var RefusalManagerView = function RefusalManagerView($container) {
            this.$refusalsContainer = $container.find('.js-refusals-container');
            this.refusalsTemplate = _.template($container.find('.js-refusals-template').html());
            this.$alertAdded = $container.find('.js-alert-added');
            this.$alertRemoved = $container.find('.js-alert-removed');
            this.$alertNotFound = $container.find('.js-alert-not-found');
        };
        RefusalManagerView.prototype = {
            onChanged: function onChanged(manager) {
                this.$refusalsContainer.html(this.refusalsTemplate({ refusals: manager.getRefusals() }));
            },
            onAdded: function onAdded(manager) {
                this.showAlert(this.$alertAdded);
            },
            onRemoved: function onRemoved(manager) {
                this.showAlert(this.$alertRemoved);
            },
            onNotFound: function onNotFound(manager) {
                this.showAlert(this.$alertNotFound);
            },
            showAlert: function showAlert($alert) {
                _.each([this.$alertAdded, this.$alertRemoved, this.$alertNotFound], function ($elem) {
                    $elem.hide();
                });
                $alert.show();
                setTimeout(function () {
                    $alert.fadeOut('slow');
                }, 3000);
            }
        };

        var user_manager = new UserRefusalManager();
        var ip_manager = new IpRefusalManager();
        var user_manager_view = new RefusalManagerView($('.js-refuse-users'));
        var ip_manager_view = new RefusalManagerView($('.js-refuse-ips'));

        $(user_manager).on('refusalsChanged', function () {
            user_manager_view.onChanged(this);
        }).on('refusalAdded', function () {
            user_manager_view.onAdded(this);
        }).on('refusalRemoved', function () {
            user_manager_view.onRemoved(this);
        }).on('refusalSaveFailed', function () {
            user_manager_view.onNotFound(this);
        });

        $(ip_manager).on('refusalsChanged', function () {
            ip_manager_view.onChanged(this);
        }).on('refusalAdded', function () {
            ip_manager_view.onAdded(this);
        }).on('refusalRemoved', function () {
            ip_manager_view.onRemoved(this);
        }).on('refusalSaveFailed', function () {
            ip_manager_view.onNotFound(this);
        });

        // 読み込み
        var userNames = $('.js-refused-users-container').data('user-names');
        if (userNames.length > 0) {
            var users = RefusedUser.loadUserNames(userNames.split(','));
            user_manager.load(users);
        }

        var ips = $('.js-refused-ips-container').data('ips');
        if (ips.length > 0) {
            ip_manager.load(ips.split(','));
        }

        var isLikeIpAddress = function isLikeIpAddress(target) {
            // ipv6っぽいのにも一応マッチするが、厳密ではない
            return (/^(\d{1,3}(\.\d{1,3}){3})|([0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4})+)$/.test(target)
            );
        };

        // 追加
        $('.js-refuse-users').on('submit', function (event) {
            event.preventDefault();
            var $input = $('input[name="refusal_input"]');
            var name = $input.val();

            // IPアドレスには必ず':' '.'などの区切り記号が含まれるので, はてなIDとはぶつからない
            if (isLikeIpAddress(name)) {
                ip_manager.add(name);
            } else {
                var user;
                try {
                    user = new RefusedUser(name);
                } catch (ignore) {}
                if (user) user_manager.add(user);
            }
            $input.val('').focus();
            return false;
        });

        // 削除
        $('.js-refuse-users').on('click', '.js-delete-refused-user', function () {
            var name = $(this).closest('.refused-user').data('user-name');
            user_manager.remove(new RefusedUser(name));
        });

        $('.js-refuse-ips').on('click', '.js-delete-refusal', function () {
            var ip = $(this).closest('.refused-ip').data('ip');
            ip_manager.remove(ip);
        });
    }
};

module.exports = RefusalPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/globalData":52,"../../Util/extend":163,"underscore":4}],114:[function(require,module,exports){
'use strict';

var Admin = {
    'globalheader': require('./Admin/globalheader'),

    'circle': require('./Admin/circle'),
    'circle-create': require('./Admin/Circle/create'),
    'circle-membership': require('./Admin/Circle/membership'),
    'circle-membership-done': require('./Admin/Circle/membership-done'),

    'plus-quit': require('./Admin/Plus/quit'),
    'topic-show': require('./Admin/Topic/show'),
    'antenna': require('./Admin/antenna'),
    'config': require('./Admin/config'),
    'index': require('./Admin/index'),
    'locale': require('./Admin/locale'),
    'refusal': require('./Admin/refusal'),

    'menu-mymenu': require('./Admin/Menu/mymenu'),
    'menu-myblogmenu': require('./Admin/Menu/myblogmenu'),
    'menu-blogmenu': require('./Admin/Menu/blogmenu'),
    'menu-services': require('./Admin/Menu/services'),

    'curation-amazon': require('./Admin/Curation/amazon'),
    'curation-flickr': require('./Admin/Curation/flickr'),
    'curation-gourmet': require('./Admin/Curation/gourmet'),
    'curation-instagram': require('./Admin/Curation/instagram'),
    'curation-itunes': require('./Admin/Curation/itunes'),
    'curation-promotion': require('./Admin/Curation/promotion'),
    'curation-twitter': require('./Admin/Curation/twitter'),

    'user-blog-breadcrumb': require('./Admin/User/Blog/breadcrumb'),

    'user-blog-comment': require('./Admin/User/Blog/comment'),
    'user-blog-comments': require('./Admin/User/Blog/comments'),
    'user-blog-comment-done': require('./Admin/User/Blog/Comment/done'),
    'user-blog-comment-delete': require('./Admin/User/Blog/Comment/delete'),
    'user-blog-comment-delete-deleted': require('./Admin/User/Blog/Comment/delete-deleted'),

    'user-blog-config-theme-theme_id-preview': require('./Admin/User/Blog/Config/theme-theme_id-preview'),
    'user-blog-config-detail': require('./Admin/User/Blog/Config/detail'),
    'user-blog-config-external': require('./Admin/User/Blog/Config/external'),
    'user-blog-config-permission': require('./Admin/User/Blog/Config/permission'),
    'user-blog-config-design-detail': require('./Admin/User/Blog/Config/design-detail'),

    'user-blog-accesslog': require('./Admin/User/Blog/accesslog'),
    'user-blog-categories': require('./Admin/User/Blog/categories'),
    'user-blog-export-movable_type': require('./Admin/User/Blog/export-movable_type'),
    'user-blog-friend': require('./Admin/User/Blog/friend'),
    'user-blog-group-official-dialog': require('./Admin/User/Blog/group-official-dialog'),
    'user-blog-import': require('./Admin/User/Blog/import'),
    'user-blog-members': require('./Admin/User/Blog/members'),
    'user-blog-subscribe': require('./Admin/User/Blog/subscribe')
};

module.exports = {
    Admin: Admin,
    Blogs: {},
    AdminTouch: {},
    BlogsTouch: {}
};

},{"./Admin/Circle/create":72,"./Admin/Circle/membership":74,"./Admin/Circle/membership-done":73,"./Admin/Curation/amazon":75,"./Admin/Curation/flickr":76,"./Admin/Curation/gourmet":77,"./Admin/Curation/instagram":78,"./Admin/Curation/itunes":79,"./Admin/Curation/promotion":80,"./Admin/Curation/twitter":81,"./Admin/Menu/blogmenu":82,"./Admin/Menu/myblogmenu":83,"./Admin/Menu/mymenu":84,"./Admin/Menu/services":85,"./Admin/Plus/quit":86,"./Admin/Topic/show":87,"./Admin/User/Blog/Comment/delete":89,"./Admin/User/Blog/Comment/delete-deleted":88,"./Admin/User/Blog/Comment/done":90,"./Admin/User/Blog/Config/design-detail":91,"./Admin/User/Blog/Config/detail":92,"./Admin/User/Blog/Config/external":93,"./Admin/User/Blog/Config/permission":94,"./Admin/User/Blog/Config/theme-theme_id-preview":95,"./Admin/User/Blog/accesslog":96,"./Admin/User/Blog/breadcrumb":97,"./Admin/User/Blog/categories":98,"./Admin/User/Blog/comment":99,"./Admin/User/Blog/comments":100,"./Admin/User/Blog/export-movable_type":101,"./Admin/User/Blog/friend":102,"./Admin/User/Blog/group-official-dialog":103,"./Admin/User/Blog/import":104,"./Admin/User/Blog/members":105,"./Admin/User/Blog/subscribe":106,"./Admin/antenna":107,"./Admin/circle":108,"./Admin/config":109,"./Admin/globalheader":110,"./Admin/index":111,"./Admin/locale":112,"./Admin/refusal":113}],115:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var ColorPicker = function ColorPicker() {
    this.init.apply(this, arguments);
};

ColorPicker.prototype = {

    init: function init($container) {
        var self = this;
        this.$container = $container;

        this.on('click', '.js-color-chip', function () {
            var color = $(this).attr('data-color');
            self.$container.trigger('colorpick', color);
        });

        this.on('click', '.js-color-picker-cancel', function () {
            self.$container.trigger('colorpick');
        });

        this.$container.appendTo(document.body);
    },

    setPosition: function setPosition(position) {
        this.$container.css(position);
    },

    on: function on() {
        this.$container.on.apply(this.$container, arguments);
    }
};

module.exports = ColorPicker;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],116:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var keyString = require('../../keyString');
var trackEvent = require('../../Base/EventTracker').trackEvent;
var backupTab = require('../../Util/backupTab');
var extractSyntax = require('../../Base/extractSyntax');
var EditorConnector = require('../../Base/EditorConnector');
var Logger = require('../../Base/Logger');

/**
 * サイドバー: Amazon検索
 */
var AmazonSearch = function AmazonSearch() {
    this.init.apply(this, arguments);
};
AmazonSearch.prototype = {
    init: function init(args) {
        var self = this;

        self.$container = args.container;
        if (!self.$container.get(0)) return;
        self.$categorySelect = self.$container.find('.amazon-search-category');
        self.$keywordInput = self.$container.find('.amazon-search-keyword');
        self.$keywordSubmit = self.$container.find('.amazon-search-keyword-submit');
        self.$itemsContainer = self.$container.find('.amazon-search-items');
        self.itemTemplate = _.template($('.amazon-search-item-template').html());
        self.$indicator = self.$container.find('.indicator');
        self.$pasteButton = self.$container.find('.amazon-search-paste-button');
        self.$layoutType = self.$container.find('.amazon-search-layout-type');
        self.$layoutTypeContainer = self.$container.find('.amazon-search-layout-type-container');
        self.$resultIsEmpty = self.$container.find('.amazon-search-result-is-empty');
        self.$formats = self.$container.find('.amazon-search-formats input[name="amazon-search-format"]');
        self.$formatsContainer = self.$container.find('.amazon-search-formats');
        self.$welcomeMessage = self.$container.find('.amazon-search-welcome');

        self.$header = self.$container.find('.amazon-search-header');
        self.$footer = self.$container.find('.amazon-search-footer');

        self.bindEvents();
        self.resize();

        // 検索クエリ指定されていたら検索する
        if (self.$keywordInput.val()) {
            self.$keywordSubmit.click();
        }
    },
    bindEvents: function bindEvents() {
        var self = this;

        self.$keywordSubmit.click(function (event) {
            self.searchByInput();
            return false;
        });

        self.$categorySelect.change(function (event) {
            self.searchByInput();
            return false;
        });

        self.$keywordInput.keydown(function (event) {
            if (keyString(event) == 'RET') {
                self.searchByInput();
                return false;
            }
        });

        self.$keywordInput.focus(function () {
            // 下の貼り付けボタン表示されないことがある
            // 原因わからないけどリサイズしたらボタン出てくる
            // 検索ボックスにフォーカスしたときにダメ押しでもう1回リサイズ
            setTimeout(function () {
                self.resize();
            }, 0);
        });

        self.$itemsContainer.delegate('.amazon-search-item', 'click', function (event) {
            if ($(event.target).is('a')) return;
            $(this).toggleClass('selected');

            self.selectedItemsChanged();
        });

        self.$container.delegate('.amazon-search-item', 'dblclick', function (event) {
            if ($(event.target).is('a')) return;
            self.insertAsins([$(this).attr('data-asin')]);
            $(this).removeClass('selected');
            self.selectedItemsChanged();
            trackEvent(self.$pasteButton.attr('data-track-name'));
            return false;
        });

        self.$pasteButton.click(function (event) {
            var asins = [];
            self.$itemsContainer.find('.selected').each(function () {
                asins.push($(this).attr('data-asin'));
                $(this).removeClass('selected');
            });
            self.insertAsins(asins);
            self.selectedItemsChanged();
        });

        backupTab({
            $container: self.$formatsContainer,
            key: 'amazon-formats',
            onchange: function onchange($input) {
                self.$formatsContainer.find('label.selected').removeClass('selected');
                $input.closest('label').addClass('selected');
            }
        });

        backupTab({
            $container: self.$layoutTypeContainer,
            key: 'amazon-layout',
            onchange: function onchange($input) {
                self.$itemsContainer.removeClass('layout-thumbnail');
                self.$itemsContainer.removeClass('layout-list');

                var layout = $input.val();
                self.$itemsContainer.addClass('layout-' + layout);

                // label class
                self.$layoutTypeContainer.find('label.selected').removeClass('selected');
                $input.closest('label').addClass('selected');

                // リスト表示のときだけtipsy有効，サムネイル表示のときは出さない
                self.setTipsyEnabled(layout == 'thumbnail');
            }
        });

        $(window).on('EditorSidebar:resize EditorSidebar:tabChange', function () {
            self.resize();
        });
    },
    setTipsyEnabled: function setTipsyEnabled(enable) {
        var self = this;

        // tipsy-southwestクラスを付けたり外したりします

        var $items = self.$itemsContainer.find('.amazon-search-item');
        var className = 'tipsy-southeast';

        if (enable) {
            $items.addClass(className);
        } else {
            $items.removeClass(className);
        }
    },
    resize: function resize() {
        var self = this;

        var mainHeight = $(window).height();

        var padding = 0;
        padding += parseInt(self.$itemsContainer.css('padding-top'), 10) || 0;
        padding += parseInt(self.$itemsContainer.css('padding-bottom'), 10) || 0;
        self.$itemsContainer.height(mainHeight - self.$container.offset().top - self.$header.outerHeight(true) - self.$footer.outerHeight(true) - padding);
    },
    selectedItemsChanged: function selectedItemsChanged() {
        var self = this;

        if (self.$itemsContainer.find('.selected').length > 0) {
            self.$pasteButton.removeClass('disabled').addClass('enabled').prop('disabled', false);
        } else {
            self.$pasteButton.removeClass('enabled').addClass('disabled').prop('disabled', true);
        }
    },
    searchByInput: function searchByInput() {
        var self = this;

        self.search(self.$keywordInput.val(), self.$categorySelect.find('option:selected').val());
    },
    search: function search(keyword, category) {
        var self = this;

        if (typeof keyword != 'string') return false;

        keyword = keyword.replace(/^\s*/, '');
        keyword = keyword.replace(/\s*$/, '');

        if (keyword.length === 0) return false;

        if (self._searchingKeyword == keyword && self._searchingCategory == category) return false;

        // ここまで来たら検索開始

        self.$welcomeMessage.addClass('disable');

        if (self._searchDeferred) {
            self._searchDeferred.reject();
        }

        self.ajaxStarted();

        self._searchingKeyword = keyword;
        self._searchingCategory = category;

        var currentAjax;
        var dfd = $.Deferred().done(function () {}).fail(function () {
            if (currentAjax) {
                // セッション終了時に前のajaxをキャンセル
                currentAjax.abort();
            }
        }).always(function () {
            self.ajaxFinished();
        });

        self.$itemsContainer.find('.amazon-search-item').remove();

        var searchPage = function searchPage(page) {
            self.ajaxStarted();

            currentAjax = $.ajax({
                url: '/api/amazon',
                data: {
                    keyword: keyword,
                    category: category,
                    page: page
                }
            }).done(function (res) {
                self.showItems(res.items);

                if (res.page === 1 && res.items.length === 0) {
                    self.$resultIsEmpty.show();
                } else {
                    self.$resultIsEmpty.hide();
                }

                if (!res.has_next) {
                    dfd.resolve();
                    return;
                }

                if (res.page >= 5) {
                    dfd.resolve();
                    return;
                } else {
                    searchPage(res.page + 1);
                }
            }).fail(function (res) {
                dfd.reject(res);
            });
        };
        searchPage(1);

        self._searchDeferred = dfd;
    },
    showItems: function showItems(items) {
        var self = this;

        var source = '';
        _.each(items, function (item) {
            source += self.itemTemplate({
                item: item
            });
        });
        self.$indicator.before(source);

        self.setTipsyEnabled(self.$itemsContainer.hasClass('layout-thumbnail'));
    },
    insertAsins: function insertAsins(asins) {
        var self = this;

        var suffix = self.$container.find('[name="amazon-search-format"]:checked').val();

        var hatena_syntaxes = _.map(asins, function (asin) {
            return '[asin:' + asin + (suffix.length > 0 ? ':' + suffix : '') + ']';
        });

        var lines = {
            html: hatena_syntaxes,
            hatena: hatena_syntaxes,
            markdown: hatena_syntaxes
        };

        extractSyntax(hatena_syntaxes).done(function (data) {
            if (suffix === 'detail') {
                lines.html = ['', '<div class="freezed">' + data.html + '</div>', ''];
            } else {
                lines.html = [data.html];
            }
            EditorConnector.insertLines(lines);
        }).fail(function (error) {
            Logger.BUG(error);
            EditorConnector.insertLines(lines);
        });
    },
    ajaxStarted: function ajaxStarted() {
        var self = this;

        self.isAjaxing = true;

        self.$keywordSubmit.prop('disabled', true);
        self.$indicator.show();
        self.$resultIsEmpty.hide();
    },
    ajaxFinished: function ajaxFinished() {
        var self = this;

        self.isAjaxing = false;

        self.$keywordSubmit.prop('disabled', false);
        self.$indicator.hide();
    }
};

module.exports = AmazonSearch;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EditorConnector":36,"../../Base/EventTracker":37,"../../Base/Logger":44,"../../Base/extractSyntax":51,"../../Util/backupTab":160,"../../keyString":184,"underscore":4}],117:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Locale = require('../../Locale');
var keyString = require('../../keyString');
var BUG = require('../../Base/Logger').BUG;
var extractSyntax = require('../../Base/extractSyntax');
var EditorConnector = require('../../Base/EditorConnector');
var extend = require('../../Util/extend');
var MyCuration = require('./MyCuration');
var FlickrSearcher = require('./FlickrSearcher');

// flickr検索サイドバー
var Flickr = function Flickr() {
    this.init.apply(this, arguments);
};
Flickr.prototype = {
    parent: MyCuration,
    serviceName: 'Flickr',
    enableAutoPager: true,
    init: function init(args) {
        var self = this;

        self.$container = args.container;

        self.$searchInput = args.container.find('.flickr-keyword');
        var $searchSubmit = args.container.find('.flickr-keyword-submit');

        self.flickrSearcher = new FlickrSearcher({
            searchInput: self.$searchInput
        });

        $searchSubmit.on('click', function () {
            if (self.$searchInput.val() !== '') {
                self.requestReload();
            }
        });
        self.$searchInput.on('keydown', function (e) {
            if (keyString(e) === 'RET') {
                if (self.$searchInput.val() !== '') {
                    self.requestReload();
                }
                return false;
            }
            return true;
        });

        self.$searchInput.focus(function () {
            self.$container.find('.flickr-description').hide();
        });

        self.parent.prototype.init.call(self, args);
    },
    loadItems: function loadItems(is_more) {
        var self = this;

        var dfd = $.Deferred();

        if (is_more) {
            self.flickrSearcher.forward();
        } else {
            self.flickrSearcher.reset();
            self.itemsReachedEnd = false;
        }

        self.flickrSearcher.load().done(function (data) {
            dfd.resolve(data);
        }).fail(function () {
            dfd.reject();
        }).always(function () {
            self.itemsReachedEnd = !self.flickrSearcher.has_next;
        });

        return dfd;
    },
    getUserById: function getUserById(id) {
        var self = this;
        var dfd = $.Deferred();

        // ユーザ情報取得
        $.ajax({
            url: "/api/flickr/user",
            type: "GET",
            data: {
                user_id: id,
                page: self.page
            },
            dataType: "json"
        }).done(function (json) {
            var data = json.data;
            dfd.resolve(data);
        }).fail(function () {
            dfd.reject();
        });

        return dfd;
    },
    insertItems: function insertItems(items) {
        var self = this;

        var lines = {
            hatena: [],
            markdown: []
        };

        var deferreds = [];

        // 各itemの撮影者をajaxで取得し、dfdをdeferredsに登録
        // 全部取得できたら本文に挿入
        _.each(items, function ($item) {

            var item = {
                permalink: $item.attr('data-permalink'),
                title: $item.attr('data-title'),
                src: $item.attr('data-src'),
                user_id: $item.attr('data-user-id')
            };

            var dfd = $.Deferred();

            self.getUserById(item.user_id).done(function (user) {
                item.username = user.username._content;

                lines.hatena.push('[' + item.permalink + ':image=' + item.src + ']');
                lines.markdown.push('[![](' + item.src + ')](' + item.permalink + ')');

                lines.hatena.push('[' + item.permalink + ':title=photo by ' + item.username + ']');
                lines.markdown.push('[photo by ' + item.username + '](' + item.permalink + ')');
                dfd.resolve();
            });

            deferreds.push(dfd);
        });

        $.when.apply($, deferreds).done(function () {
            extractSyntax(lines.hatena).done(function (data) {
                lines.html = [data.html];
            }).fail(function (error) {
                lines.html = lines.hatena;
                BUG(error);
            }).always(function () {
                EditorConnector.insertLines(lines);
            });
        });
    },
    _requestLoadItems: function _requestLoadItems(is_more) {
        var self = this;

        if (self.$searchInput.val() === '') return;

        self.isLoading = true;
        self.$indicator.show();
        self.$errorMessage.hide();

        self.loadItems(is_more).done(function (feed) {
            if (feed.length === 0 && self.$itemsContainer.find('.item').length === 0) {
                self.$errorMessage.show();
            } else {
                self.showItems(feed);
            }
        }).fail(function (res) {
            self.$errorMessage.show();
        }).always(function () {
            self.$indicator.hide();
            self.isLoading = false;
        });
    },
    showItems: function showItems(items) {
        var self = this;

        var source = '';
        _.each(items, function (entry) {
            source += self.template({
                item: entry
            });
        });
        self.$indicator.before(source);
        Locale.updateTimestamps(self.$container[0]);
        $(self).triggerHandler('items-appended');
    },
    setupFormatSwitcher: function setupFormatSwitcher() {
        var self = this;
        var $formatsContainer = self.$container.find('.flickr-formats');
        $formatsContainer.on('change', function (e) {
            var $input = $(e.target);
            $formatsContainer.find('label.selected').removeClass('selected');
            $input.closest('label').addClass('selected');
        });
    }
};

extend(Flickr.prototype, MyCuration.prototype);

module.exports = Flickr;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EditorConnector":36,"../../Base/Logger":44,"../../Base/extractSyntax":51,"../../Locale":151,"../../Util/extend":163,"../../keyString":184,"./FlickrSearcher":118,"./MyCuration":123,"underscore":4}],118:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// Flickrの検索を管理するオブジェクト
// load() → forward() → load() みたいに順番に読むとページングできる
// resetすると、ページングや検索wordが設定し直される
var FlickrSearcher = function FlickrSearcher() {
    this.init.apply(this, arguments);
};
FlickrSearcher.prototype = {
    init: function init(args) {
        var self = this;
        self.$searchInput = args.searchInput;
        self.reset();
    },

    load: function load() {
        var self = this;
        var dfd = $.Deferred();

        var searchKeyword = self.searchKeyword;

        if (!searchKeyword) {
            dfd.reject();
            return dfd;
        }

        // キーワードで画像検索
        $.ajax({
            url: "/api/flickr/search",
            type: "GET",
            data: {
                word: searchKeyword,
                page: self.page
            },
            dataType: "json"
        }).done(function (json) {
            var data = json.data;
            if (data.length === 0) {
                // データが無くなったら次ページなし
                self.has_next = false;
            }
            dfd.resolve(data);
        }).fail(function () {
            // データが取得できなかったら次ページなし
            self.has_next = false;
            dfd.reject();
        });

        return dfd;
    },
    forward: function forward() {
        var self = this;
        self.page++;
    },
    reset: function reset() {
        var self = this;
        self.page = 1;
        self.has_next = true; // 次がなくなったらfalseに
        self.resetSearchKeyword();
    },
    resetSearchKeyword: function resetSearchKeyword() {
        var self = this;
        self.searchKeyword = self.$searchInput.val();
    }
};

module.exports = FlickrSearcher;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],119:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var keyString = require('../../keyString');
var EditorConnector = require('../../Base/EditorConnector');
var extend = require('../../Util/extend');
var MyCuration = require('./MyCuration');
var GourmetSearcher = require('./GourmetSearcher');

// レストラン検索サイドバー
var Gourmet = function Gourmet() {
    this.init.apply(this, arguments);
};
Gourmet.prototype = {
    parent: MyCuration,
    serviceName: 'Gourmet',
    enableAutoPager: true,
    init: function init(args) {
        var self = this;

        self.$container = args.container;

        var $searchInput = args.container.find('.gourmet-keyword');
        var $searchPref = args.container.find('.gourmet-pref');
        var $searchSubmit = args.container.find('.gourmet-keyword-submit');

        // localStorageに都道府県指定が保存されてたらrestoreする
        self.prefLocalStorageKey = 'MyCuration.Gourmet.Pref';
        try {
            if (localStorage[self.prefLocalStorageKey]) {
                var selector = 'option[value=' + localStorage[self.prefLocalStorageKey] + ']';
                $searchPref.find(selector).first().prop('selected', true);
            }
        } catch (ignore) {}

        // 都道府県指定が変わったときにlocalStorageに保存する
        $searchPref.on('change', function (e) {
            try {
                localStorage[self.prefLocalStorageKey] = $searchPref.val();
            } catch (ignore) {}
        });

        self.gourmetSearcher = new GourmetSearcher({
            searchInput: $searchInput,
            searchPref: $searchPref,
            type: 'gnavi' // 直下で初期状態にあわせて更新される
        });
        self.updateProvidorStatus();

        $searchSubmit.on('click', function () {
            self.requestReload();
        });
        $searchInput.on('keydown', function (e) {
            if (keyString(e) === 'RET') {
                self.requestReload();
                return false;
            }
            return true;
        });

        $searchInput.focus(function () {
            self.$container.find('.gourmet-description').hide();
        });

        self.setupFormatSwitcher(); // 貼り付け形式切替
        self.setupProvidorSwitcher(); // ぐるナビ/食べログ切り替え

        self.parent.prototype.init.call(self, args);
    },
    loadItems: function loadItems(is_more) {
        var self = this;

        var dfd = $.Deferred();

        if (is_more) {
            self.gourmetSearcher.forward();
        } else {
            self.gourmetSearcher.reset();
            self.itemsReachedEnd = false;
        }

        self.gourmetSearcher.load().done(function (data) {
            dfd.resolve(data);
        }).fail(function () {
            dfd.reject();
        }).always(function () {
            self.itemsReachedEnd = !self.gourmetSearcher.has_next;
        });

        return dfd;
    },
    insertItems: function insertItems(items) {
        var self = this;

        var lines = [];
        var suffix = self.$container.find('[name="gourmet-format"]:checked').val();
        _.each(items, function ($item) {
            var syntax = $item.attr('data-syntax');
            syntax = syntax.replace(/\]$/, ":" + suffix + "]");
            // tabelog検索でgnaviの店舗情報が返ってくることがあるのでリクエスト時のprovidorで書き換える
            var providor = self.$container.find('[name="gourmet-providor"]:checked').val();
            syntax = syntax.replace(/^\[.+?:/, "[" + providor + ":");
            lines.push(syntax);
        });

        EditorConnector.insertLines({
            hatena: lines,
            markdown: lines,
            html: lines
        });
    },
    setupFormatSwitcher: function setupFormatSwitcher() {
        var self = this;
        var $formatsContainer = self.$container.find('.gourmet-formats');
        $formatsContainer.on('change', function (e) {
            var $input = $(e.target);
            $formatsContainer.find('label.selected').removeClass('selected');
            $input.closest('label').addClass('selected');
        });
    },
    setupProvidorSwitcher: function setupProvidorSwitcher() {
        var self = this;
        var $providorsContainer = self.$container.find('.gourmet-providors');
        $providorsContainer.on('change', function (e) {
            var $input = $(e.target);
            $providorsContainer.find('label.selected').removeClass('selected');
            $input.closest('label').addClass('selected');

            // providorが変わったらreloadする
            self.updateProvidorStatus();
        });
    },
    updateProvidorStatus: function updateProvidorStatus() {
        var self = this;
        var providor = self.$container.find('[name="gourmet-providor"]:checked').val();

        if (providor !== self.gourmetSearcher.type) {
            self.gourmetSearcher.type = providor;
            self.requestReload();
        }
    },
    loadItemsFinishedHandler: function loadItemsFinishedHandler() {
        var self = this;
        // 初回ロードでも読み込まれるので、検索語が入ってるかどうか見る
        if (self.gourmetSearcher.$searchInput.val() && self.getItemsOnPage().length === 0) {
            self.$container.find('.no-result').show();
        }
    },
    requestReload: function requestReload() {
        var self = this;
        self.$container.find('.no-result').hide();
        self.parent.prototype.requestReload.call(self);
    }
};

extend(Gourmet.prototype, MyCuration.prototype);

module.exports = Gourmet;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EditorConnector":36,"../../Util/extend":163,"../../keyString":184,"./GourmetSearcher":120,"./MyCuration":123,"underscore":4}],120:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

// Gourmetの検索を管理するオブジェクト
// load() → forward() → load() みたいに順番に読むとページングできる
// resetすると、ページングや検索wordが設定し直される
var GourmetSearcher = function GourmetSearcher() {
    this.init.apply(this, arguments);
};
GourmetSearcher.prototype = {
    init: function init(args) {
        var self = this;
        self.$searchInput = args.searchInput;
        self.$searchPref = args.searchPref;
        self.type = args.type || 'gnavi';
        self.reset();
    },

    load: function load() {
        var self = this;
        var dfd = $.Deferred();

        var searchKeyword = self.searchKeyword;

        if (!searchKeyword) {
            dfd.reject();
            return dfd;
        }

        // レストラン検索APIから情報を取ってくる
        $.ajax({
            url: "/api/gourmet/search",
            type: "GET",
            data: {
                word: searchKeyword,
                pref: self.searchPref,
                page: self.page,
                type: self.type
            },
            dataType: "json"
        }).done(function (data) {
            if (data.entries.length === 0) {
                // データが無くなったら次ページなし
                self.has_next = false;
            }
            dfd.resolve(data);
        }).fail(function () {
            // データが取得できなかったら次ページなし
            self.has_next = false;
            dfd.reject();
        });

        return dfd;
    },
    forward: function forward() {
        var self = this;
        self.page++;
    },
    reset: function reset() {
        var self = this;
        self.page = 1;
        self.has_next = true; // 次がなくなったらfalseに
        self.resetSearchParameters();
    },
    resetSearchParameters: function resetSearchParameters() {
        var self = this;
        self.searchKeyword = self.$searchInput.val();
        self.searchPref = self.$searchPref.val();
    }
};

module.exports = GourmetSearcher;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],121:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var extractSyntax = require('../../Base/extractSyntax');
var BUG = require('../../Base/Logger').BUG;
var EditorConnector = require('../../Base/EditorConnector');
var extend = require('../../Util/extend');
var MyCuration = require('./MyCuration');

var Instagram = function Instagram() {
    this.init.apply(this, arguments);
};
Instagram.prototype = {
    parent: MyCuration,
    init: function init(args) {
        var self = this;

        self.parent.prototype.init.call(self, args);

        $(self).on('items-appended', function () {
            self.setPaddingLeft();
        });
    },
    serviceName: 'Instagram',
    enableAutoPager: true,
    pasteReverseOrder: true,
    loadItems: function loadItems(more) {
        var self = this;

        var data = {};

        if (more) {
            var $lastItem = self.$itemsContainer.find('.item:last');
            data.max_id = $lastItem.attr('data-next-max-id');
        }

        return $.ajax({
            url: '/api/instagram/recent',
            data: data,
            type: 'GET',
            dataType: 'json'
        }).fail(function () {
            self.pleaseReAuthorize();
        }).done(function (res) {
            if (res && res.data) {
                res.entries = res.data;
                // テンプレートにdata-max-id入れるので各エントリに入れる
                _.each(res.entries, function (entry) {
                    entry.next_max_id = res.next_max_id;
                });
            }

            // next_max_idなかったらこれで終わり(autopagerが無効になる)
            if (!res.next_max_id) {
                self.itemsReachedEnd = true;
            }

            return res;
        });
    },
    pleaseReAuthorize: function pleaseReAuthorize() {
        var self = this;
        self.$container.find('.disabled-box').show();
    },
    insertItems: function insertItems(items) {
        var self = this;

        var lines = {
            hatena: [],
            markdown: []
        };
        _.each(items, function ($item) {
            var item = {
                permalink: $item.attr('data-permalink'),
                caption: $item.attr('data-caption'),
                type: $item.attr('data-type')
            };

            var media_url = item.permalink + 'media/?size=l';

            // 動画はiframe(:embedで展開したらiframeになる)，写真はa>img
            if (item.type === 'video') {
                lines.hatena.push('[' + item.permalink + ':embed]');
                lines.markdown.push('[' + item.permalink + ':embed]');
            } else {
                lines.hatena.push('[' + item.permalink + ':image=' + media_url + ']');
                lines.markdown.push('[![](' + media_url + ')](' + item.permalink + ')');
            }

            // captionあったらcaptionでリンク，なかったら単なるリンク
            // captionないときmarkdownではタイトル取れないのではてな記法
            if (item.caption) {
                var caption = item.caption.replace(/\r?\n/g, '');
                lines.hatena.push('[' + item.permalink + ':title=' + caption + ']');
                lines.markdown.push('[' + caption + '](' + item.permalink + ')');
            } else {
                lines.hatena.push('[' + item.permalink + ':title]');
                lines.markdown.push('[' + item.permalink + ':title]');
            }
        });

        extractSyntax(lines.hatena).done(function (data) {
            lines.html = [data.html];
        }).fail(function (error) {
            lines.html = lines.hatena;
            BUG(error);
        }).always(function () {
            EditorConnector.insertLines(lines);
        });
    },
    setPaddingLeft: function setPaddingLeft() {
        var self = this;

        // itemsが中央に揃うよう幅を調整
        // 一列に表示されているitemsの幅の合計から，paddingLeftを決める
        //
        // |----|               |----|  padding
        // |-------------------------|  .itemsContainer
        //      |---| |---| |---|       .item
        //      ^itemsLeft
        //                      ^itemsRight
        //
        // padding = itemsContainerの幅 - (itemsRight - itemsLeft) / 2

        var $itemsContainer = self.$container.find('.items');
        var $items = $itemsContainer.find('.item');
        var $firstItem = $($items[0]);
        var firstItemTop = $firstItem.position().top;
        var itemsLeft = $firstItem.position().left;
        var itemsRight = itemsLeft + $firstItem.outerWidth();
        $items.each(function () {
            var $this = $(this);
            if ($this.position().top !== firstItemTop) return false;
            itemsRight = $this.position().left + $this.outerWidth();
        });

        var itemsWidthTotal = itemsRight - itemsLeft;
        var padding = ($itemsContainer.width() - itemsWidthTotal) / 2;

        $itemsContainer.css({
            'padding-left': padding + 'px'
        });
    }
};

extend(Instagram.prototype, MyCuration.prototype);

module.exports = Instagram;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EditorConnector":36,"../../Base/Logger":44,"../../Base/extractSyntax":51,"../../Util/extend":163,"./MyCuration":123,"underscore":4}],122:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var keyString = require('../../keyString');
var BUG = require('../../Base/Logger').BUG;
var extractSyntax = require('../../Base/extractSyntax');
var EditorConnector = require('../../Base/EditorConnector');
var extend = require('../../Util/extend');
var MyCuration = require('./MyCuration');

/**
 * サイドバーItunes貼り付け機能
 */
var Itunes = function Itunes() {
    this.init.apply(this, arguments);
};
Itunes.prototype = {
    parent: MyCuration,
    init: function init(args) {
        var self = this;

        self.parent.prototype.init.call(self, args);

        self._templatesByType = {
            'default': _.template(self.$container.find('.template').html()),
            'artist': _.template(self.$container.find('.template-artist').html()),
            'collection': _.template(self.$container.find('.template-collection').html()),
            'audiobook': _.template(self.$container.find('.template-collection').html())
        };
    },
    bindEvents: function bindEvents() {
        var self = this;

        self.parent.prototype.bindEvents.call(self);

        self.$submit = self.$container.find('.itunes-keyword-submit');
        self.$media = self.$container.find('.itunes-media');
        self.$keyword = self.$container.find('.itunes-keyword');
        self.$welcomeMessage = self.$container.find('.items-welcome');

        self.$submit.click(function (event) {
            self.requestReload();
            return false;
        });

        self.$media.change(function (event) {
            self.requestReload();
            return false;
        });

        self.$keyword.keydown(function (event) {
            if (keyString(event) == 'RET') {
                self.requestReload();
                return false;
            }
        });
    },
    serviceName: 'Itunes',
    enableAutoPager: false,
    pasteReverseOrder: false,
    willRequestLoadItems: function willRequestLoadItems(more) {
        var self = this;
        return self.$keyword.val() !== '';
    },
    loadItems: function loadItems(more) {
        var self = this;

        self.$welcomeMessage.addClass('disable');

        var term = self.$keyword.val();
        var queries = self.$media.val().split(':');
        var media = queries[0];
        var entity = queries[1];

        var data = {
            term: term,
            media: media,
            entity: entity
        };

        return $.ajax({
            url: '/api/itunes/search',
            data: data,
            type: 'GET',
            dataType: 'json'
        });
    },
    renderItem: function renderItem(item) {
        var self = this;

        var type = item.wrapperType || 'default';
        var template = self._templateByType(type);

        // 価格の表示をいい感じにする
        item._formattedPrice = '';
        if (item.formattedPrice !== undefined) {
            item._formattedPrice = item.formattedPrice;
        } else if (item.trackPrice !== undefined || item.collectionPrice !== undefined) {
            var amount = item.trackPrice || item.collectionPrice;
            var currency = item.currency;
            if (amount < 0) {
                // 販売されていないアイテムのとき価格が -1 になっているので無視
            } else if (currency === 'JPY') {
                    item._formattedPrice = '¥' + amount;
                } else {
                    item._formattedPrice = currency + ' ' + amount;
                }
        }

        // ジャンルをいろいろ考慮して出す
        item._genre = '';
        if (item.genres !== undefined && _.isArray(item.genres) && item.genres.length > 0) {
            item._genre = item.genres[0];
        } else if (item.primaryGenreName !== undefined) {
            item._genre = item.primaryGenreName;
        }

        return template({
            item: item
        });
    },
    _templateByType: function _templateByType(type) {
        var self = this;
        return self._templatesByType[type] || self._templatesByType['default'];
    },
    insertItems: function insertItems(items) {
        var self = this;

        var lines = {
            hatena: [],
            markdown: []
        };
        _.each(items, function ($item) {
            var item = {
                permalink: $item.attr('data-permalink')
            };

            lines.hatena.push('[' + item.permalink + ':embed]');
            lines.markdown.push('[' + item.permalink + ':embed]');
        });

        extractSyntax(lines.hatena).done(function (data) {
            lines.html = ['', data.html, ''];
        }).fail(function (error) {
            lines.html = lines.hatena;
            BUG(error);
        }).always(function () {
            if (EditorConnector.isiOS() || EditorConnector.isAndroid()) {
                // スマフォアプリのときうまく表示できないので記法そのままにしておく
                lines.html = lines.hatena;
            }
            EditorConnector.insertLines(lines);
        });
    }
};

extend(Itunes.prototype, MyCuration.prototype);

module.exports = Itunes;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EditorConnector":36,"../../Base/Logger":44,"../../Base/extractSyntax":51,"../../Util/extend":163,"../../keyString":184,"./MyCuration":123,"underscore":4}],123:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Locale = require('../../Locale');
var trackEvent = require('../../Base/EventTracker').trackEvent;
var Editor = require('../Editor');
var MyCurationTab = require('./MyCurationTab');

// マイキュレーション親クラス
// extendして使う
var MyCuration = function MyCuration() {
    this.init.apply(this, arguments);
};
MyCuration.prototype = {
    // args: { container }
    init: function init(args) {
        var self = this;

        self.$container = args.container;
        if (!self.$container.get(0)) return;
        self.$header = self.$container.find('.header');
        self.$itemsContainer = self.$container.find('.items');
        self.$tabsContainer = self.$container.find('.tab-container');
        self.$indicator = self.$container.find('.indicator');
        self.$errorMessage = self.$container.find('.error-message');
        self.$disabledMessage = self.$container.find('.disabled-message');
        self.$footer = self.$container.find('.footer');
        self.$pasteButton = self.$container.find('.paste-button');

        var $templateNode = self.$container.find('.template');
        if ($templateNode.get(0)) {
            self.template = _.template($templateNode.html());
        }

        var $editorTemplateNode = self.$container.find('.editor-template');
        if ($editorTemplateNode.get(0)) {
            self.editorTemplate = _.template($editorTemplateNode.html());
        }

        self.loadedPage = 0;

        self.bindEvents();
        self.resize();

        self.requestLoadItems();
    },
    // AutoPager使いたいときtrue
    // AutoPager有効にすると下までスクロールしたときloadItems(true)が呼ばれる
    enableAutoPager: false,
    // AutoPager最後まで受信したらtrueにしてください
    itemsReachedEnd: false,
    // 複数選択貼り付け時に逆順で貼り付けるかどうか
    pasteReverseOrder: false,
    bindEvents: function bindEvents() {
        var self = this;

        $(window).on('EditorSidebar:resize EditorSidebar:tabChange', function () {
            self.resize();
            self.requestLoadItems();
        });

        self.$itemsContainer.on('click', '.item', function (event) {
            if ($(event.target).is('a')) return;
            if ($(event.target).parents('a').length > 0) return;
            $(this).toggleClass('selected');

            self.selectedItemsChanged();
            return false;
        });

        self.$container.on('dblclick', '.item', function (event) {
            if ($(event.target).is('a')) return;
            if ($(event.target).parents('a').length > 0) return;
            self.insertItems([$(this)]);
            $(this).removeClass('selected');
            self.selectedItemsChanged();
            trackEvent(self.$pasteButton.attr('data-track-name'));
            return false;
        });

        self.$pasteButton.click(function (event) {
            var items = [];
            self.selectedItems().each(function () {
                items.push($(this));
                $(this).removeClass('selected');
            });
            self.insertItems(self.pasteReverseOrder ? items.reverse() : items);
            self.selectedItemsChanged();
        });

        self.tabs = new MyCurationTab({
            container: self.$tabsContainer,
            backupKey: self.serviceName
        });
        $(self.tabs).on('change', function () {
            self.removeItems();
            self.requestLoadItems();
        });

        if (self.enableAutoPager) {
            self.$itemsContainer.scroll(_.throttle(function () {
                var rate = (self.$itemsContainer.scrollTop() + self.$itemsContainer.height()) / self.$itemsContainer[0].scrollHeight;
                // 下のほうに行ったらもっと読む
                if (rate > 0.7 && !self.itemsReachedEnd) {
                    self.requestLoadItems(true);
                }
            }, 100));
        }
    },
    resize: function resize() {
        var self = this;

        var mainHeight = $(window).height();

        var padding = 0;
        padding += parseInt(self.$itemsContainer.css('padding-top'), 10) || 0;
        padding += parseInt(self.$itemsContainer.css('padding-bottom'), 10) || 0;
        self.$itemsContainer.height(mainHeight - self.$container.offset().top - self.$header.outerHeight(true) - self.$footer.outerHeight(true) - padding);
    },
    selectedItemsChanged: function selectedItemsChanged() {
        var self = this;

        if (self.selectedItems().length > 0) {
            self.$pasteButton.removeClass('disabled').addClass('enabled').prop('disabled', false);
        } else {
            self.$pasteButton.removeClass('enabled').addClass('disabled').prop('disabled', true);
        }
    },
    selectedItems: function selectedItems() {
        var self = this;

        return self.$itemsContainer.find('.selected');
    },
    requestLoadItems: function requestLoadItems(is_more) {
        var self = this;

        if (self.isLoading) return;
        if (!self.$container.is(':visible')) return;

        // 最初からrequestされたけどページ内に要素がある場合は何もしない
        if (!is_more && self.getItemsOnPage().length > 0) return;

        self._requestLoadItems(is_more);
    },
    willRequestLoadItems: function willRequestLoadItems(is_more) {
        var self = this;
        // 必要に応じてオーバーライドしてください
        // false を返すとリクエストするのをやめることができます
        return true;
    },
    _requestLoadItems: function _requestLoadItems(is_more) {
        var self = this;

        if (!self.willRequestLoadItems(is_more)) return;

        self.isLoading = true;
        self.$indicator.show();
        self.$errorMessage.hide();

        self.loadItems(is_more).done(function (feed) {
            self.showItems(feed.entries);
        }).fail(function (res) {
            self.$errorMessage.show();
        }).always(function () {
            self.$indicator.hide();
            self.isLoading = false;
            self.loadItemsFinishedHandler();
        });
    },
    loadItemsFinishedHandler: function loadItemsFinishedHandler() {
        // 必要なら上書きして使ってください
    },
    requestReload: function requestReload(is_more) {
        var self = this;

        if (self.isLoading) return;

        self.removeItems();
        self._requestLoadItems();
    },
    getItemsOnPage: function getItemsOnPage() {
        var self = this;
        return self.$itemsContainer.find('.item');
    },
    removeItems: function removeItems() {
        var self = this;
        self.getItemsOnPage().remove();
    },
    loadItems: function loadItems() {
        throw "not implemented";
        // 上書きして使ってください
    },
    showItems: function showItems(items) {
        var self = this;

        var source = '';
        _.each(items, function (entry) {
            source += self.renderItem(entry);
        });
        self.$indicator.before(source);
        Locale.updateTimestamps(self.$container[0]);
        $(self).triggerHandler('items-appended');
    },
    renderItem: function renderItem(item) {
        var self = this;
        return self.template({
            item: item
        });
    },
    insertItems: function insertItems(items) {
        // 必要なら上書きして使ってください
        var self = this;
        var lines = [];
        _.each(items, function ($item) {
            var permalink = $item.attr('data-permalink');
            lines.push('[' + permalink + ':embed]');
        });
        Editor.currentEditor.insertLines(lines);
    }
};

module.exports = MyCuration;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EventTracker":37,"../../Locale":151,"../Editor":143,"./MyCurationTab":124,"underscore":4}],124:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

// タブ切り替えイベントの管理
// 変更イベントのディスパッチ
// localStorageにバックアップ
// 変更されたらchangeイベントを発行する
// get()で値を取得
// set(value)で値を設定
// args:
//   container: inputを含む要素
//   backupKey: バックアップ用のキー localStorageのキーの一部になる
var MyCurationTab = function MyCurationTab() {
    this.init.apply(this, arguments);
};
MyCurationTab.prototype = {
    // args: { container backupKey }
    init: function init(args) {
        var self = this;

        self.$container = args.container;
        self.backupKey = args.backupKey;
        self.localStorageKey = 'MyCuration.Tab.' + self.backupKey;
        self.values = self.$container.find('input').map(function () {
            return $(this).val();
        }).toArray();

        self.$container.delegate('input', 'change', function () {
            self.$container.find('label.selected').removeClass('selected');
            $(this).closest('label').addClass('selected');

            var value = $(this).val();
            self.value = value;
            try {
                localStorage[self.localStorageKey] = value;
            } catch (ignore) {}

            $(self).triggerHandler('change');
        });

        try {
            if (localStorage[self.localStorageKey]) {
                self.set(localStorage[self.localStorageKey]);
            }
        } catch (ignore) {}
    },
    get: function get() {
        return this.value || this.values[0];
    },
    set: function set(value) {
        var self = this;
        if (!_.include(self.values, value)) return;
        var $input = self.$container.find('input[value="' + value + '"]');
        $input.click();
    }
};

module.exports = MyCurationTab;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],125:[function(require,module,exports){
'use strict';

var actions = {
    SET_EDITOR: 'PROMOTION:SET_EDITOR',

    LOAD_ENTRIES: 'ENTRIES:LOAD_ENTRIES',
    SHOW_ENTRY: 'ENTRIES:SHOW_ENTRY',
    SHOW_ENTRY_AT: 'ENTRIES:SHOW_ENTRY_AT',
    CLOSE_ENTRY: 'ENTRIES:CLOSE_ENTRY',
    FILL_KEYWORD: 'ENTRIES:FILL_KEYWORD',

    LOAD_ODAIS: 'ODAI:LOAD_ODAIS',
    SELECT_ODAI: 'ODAI:SELECT_ODAI',
    TURN_SLOT: 'ODAI:TURN_SLOT',
    KILL_ODAISLOT: 'ODAI:KILL_ODAISLOT',
    SET_INACTIVE: 'ODAI:SET_INACTIVE',

    SHOW_WINDOW: 'PROMOTION:SHOW_WINDOW',
    HIDE_WINDOW: 'PROMOTION:HIDE_WINDOW',
    SET_PAGE: 'PROMOTION:SET_PAGE'
};

var pageIds = {
    ENTRIES_PAGE: 'ENTRIES_PAGE',
    ODAI_SLOT_PAGE: 'ODAI_SLOT_PAGE'
};

module.exports = {
    actions: actions,
    pageIds: pageIds
};

},{}],126:[function(require,module,exports){
'use strict';

/**
 * PR記事1記事に対応するModel
 */

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var PromotionEntry = (function () {

    /**
     * @param {string} id
     * @param {string} title
     * @param {string} body
     */

    function PromotionEntry(args) {
        _classCallCheck(this, PromotionEntry);

        this.id = args.id;
        this.title = args.title;
        this.body = args.body;
    }

    _createClass(PromotionEntry, [{
        key: 'isRead',
        value: function isRead() {
            try {
                return localStorage[this.localStorageKey()];
            } catch (ignore) {}
        }
    }, {
        key: 'setAsRead',
        value: function setAsRead() {
            try {
                localStorage[this.localStorageKey()] = true;
            } catch (ignore) {}
        }
    }, {
        key: 'localStorageKey',
        value: function localStorageKey() {
            return 'Hatena.Diary.Promotion.Entry.read.' + this.id;
        }
    }, {
        key: 'isClosed',
        value: function isClosed() {
            try {
                return localStorage['Hatena.Diary.Promotion.Entry.closed.' + this.id];
            } catch (ignore) {}
        }
    }, {
        key: 'setAsClosed',
        value: function setAsClosed() {
            try {
                localStorage['Hatena.Diary.Promotion.Entry.closed.' + this.id] = true;
            } catch (ignore) {}
        }
    }]);

    return PromotionEntry;
})();

module.exports = PromotionEntry;

},{}],127:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var actions = require('../Constants').actions;
var Dispatcher = require('../../../../Base/Dispatcher');

var EntriesActions = (function (_Dispatcher$Actions) {
    _inherits(EntriesActions, _Dispatcher$Actions);

    function EntriesActions() {
        _classCallCheck(this, EntriesActions);

        _get(Object.getPrototypeOf(EntriesActions.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(EntriesActions, [{
        key: 'setEditor',
        value: function setEditor(editor) {
            this.emit(actions.SET_EDITOR, editor);
        }
    }, {
        key: 'loadEntries',
        value: function loadEntries(entries) {
            this.emit(actions.LOAD_ENTRIES, entries);
        }
    }, {
        key: 'showEntry',
        value: function showEntry(entryId) {
            this.emit(actions.SHOW_ENTRY, entryId);
        }
    }, {
        key: 'showEntryAt',
        value: function showEntryAt(index) {
            this.emit(actions.SHOW_ENTRY_AT, index);
        }
    }, {
        key: 'closeEntry',
        value: function closeEntry(entryId) {
            this.emit(actions.CLOSE_ENTRY, entryId);
        }
    }, {
        key: 'fillKeyword',
        value: function fillKeyword(keyword) {
            this.emit(actions.FILL_KEYWORD, keyword);
        }
    }]);

    return EntriesActions;
})(Dispatcher.Actions);

module.exports = new EntriesActions();

},{"../../../../Base/Dispatcher":34,"../Constants":125}],128:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var get = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null).get;
var actions = require('../Constants').actions;
var Dispatcher = require('../../../../Base/Dispatcher');

var OdaiActions = (function (_Dispatcher$Actions) {
    _inherits(OdaiActions, _Dispatcher$Actions);

    function OdaiActions() {
        _classCallCheck(this, OdaiActions);

        _get(Object.getPrototypeOf(OdaiActions.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(OdaiActions, [{
        key: 'setEditor',
        value: function setEditor(editor) {
            this.emit(actions.SET_EDITOR, editor);
        }
    }, {
        key: 'loadOdais',
        value: function loadOdais() {
            var _this = this;

            get('/api/odais').then(function (res) {
                _this.emit(actions.LOAD_ODAIS, res.odais);
            }).fail(function (error) {
                throw error;
            });
        }
    }, {
        key: 'selectOdai',
        value: function selectOdai(odaiId) {
            this.emit(actions.SELECT_ODAI, odaiId);
        }
    }, {
        key: 'turnSlot',
        value: function turnSlot() {
            this.emit(actions.TURN_SLOT);
        }
    }, {
        key: 'killOdaiSlot',
        value: function killOdaiSlot() {
            this.emit(actions.KILL_ODAISLOT);
        }
    }, {
        key: 'setInactive',
        value: function setInactive() {
            this.emit(actions.SET_INACTIVE);
        }
    }]);

    return OdaiActions;
})(Dispatcher.Actions);

module.exports = new OdaiActions();

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Base/Dispatcher":34,"../Constants":125}],129:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var actions = require('../Constants').actions;
var Dispatcher = require('../../../../Base/Dispatcher');

var PromotionActions = (function (_Dispatcher$Actions) {
    _inherits(PromotionActions, _Dispatcher$Actions);

    function PromotionActions() {
        _classCallCheck(this, PromotionActions);

        _get(Object.getPrototypeOf(PromotionActions.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(PromotionActions, [{
        key: 'setEditor',
        value: function setEditor(editor) {
            this.emit(actions.SET_EDITOR, editor);
        }
    }, {
        key: 'showWindow',
        value: function showWindow() {
            this.emit(actions.SHOW_WINDOW);
        }
    }, {
        key: 'hideWindow',
        value: function hideWindow() {
            this.emit(actions.HIDE_WINDOW);
        }
    }, {
        key: 'setPage',
        value: function setPage(pageId) {
            this.emit(actions.SET_PAGE, pageId);
        }
    }]);

    return PromotionActions;
})(Dispatcher.Actions);

module.exports = new PromotionActions();

},{"../../../../Base/Dispatcher":34,"../Constants":125}],130:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var EntriesActions = require('../actions/EntriesActions');
var PromotionContent = require('./PromotionContent');

/**
 * Promotionモーダル、記事を表示するページ
 * 記事切り替え、ページャの表示を行う
 */

var EntriesPage = (function (_React$Component) {
    _inherits(EntriesPage, _React$Component);

    function EntriesPage() {
        _classCallCheck(this, EntriesPage);

        _get(Object.getPrototypeOf(EntriesPage.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(EntriesPage, [{
        key: 'render',
        value: function render() {
            return React.createElement(
                'div',
                { className: 'promotion-entries ' + this.props.device },
                React.createElement(
                    'div',
                    { className: 'promotion-entries-wrapper ' + this.props.device },
                    this.renderEntries()
                ),
                React.createElement(
                    'div',
                    { className: 'promotion-entries-pagers center ' + this.props.device },
                    this.renderPagers()
                )
            );
        }
    }, {
        key: 'renderEntries',
        value: function renderEntries() {
            var _this = this;

            return this.props.entries.map(function (entry) {
                return React.createElement(PromotionContent, {
                    entry: entry,
                    key: entry.id,
                    device: _this.props.device,
                    isSelected: _this.isEntrySelected(entry) });
            });
        }
    }, {
        key: 'renderPagers',
        value: function renderPagers() {
            var _this2 = this;

            if (this.props.entries.length < 2) {
                return;
            }

            return this.props.entries.map(function (entry, i) {
                var className = 'promotion-entries-pager btn';
                className += _this2.isEntrySelected(entry) ? ' selected' : '';

                return React.createElement(
                    'span',
                    { className: className,
                        'data-target-promotion-index': i, tabIndex: '0',
                        ref: 'marker' + i,
                        key: entry.id,
                        onClick: function () {
                            return _this2.showEntryAt(i);
                        } },
                    i + 1
                );
            });
        }
    }, {
        key: 'isEntrySelected',
        value: function isEntrySelected(entry) {
            return !!(this.props.currentEntry && entry.id === this.props.currentEntry.id);
        }
    }, {
        key: 'showEntryAt',
        value: function showEntryAt(i) {
            EntriesActions.showEntryAt(i);
        }
    }]);

    return EntriesPage;
})(React.Component);

EntriesPage.propTypes = {
    entries: React.PropTypes.array.isRequired,
    currentEntry: React.PropTypes.object,
    device: React.PropTypes.string.isRequired
};

module.exports = EntriesPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../actions/EntriesActions":127,"./PromotionContent":133}],131:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var Locale = require('../../../../Locale');
var HtmlText = require('../../../../Base/HtmlText');
var OdaiActions = require('../actions/OdaiActions');
var PromotionActions = require('../actions/PromotionActions');

/**
 * 文字列が指定した行数に収まるよう短縮する
 * @param {string} className - 文字列を入れる要素のclass
 * @param {string} text      - 短縮したい文字列
 * @param {number} lines     - 収めたい行数
 * @returns {string}         - 短縮後の文字列
 */
var shortener = (function () {
  // window.load前に呼ばれたら空文字列を返す
  if (!document.body) {
    return '';
  }

  var mock = document.createElement('div');
  mock.style.top = '-9999px';
  mock.style.zIndex = '-9999';

  document.addEventListener('DOMContentLoaded', function () {
    document.body.appendChild(mock);
  });

  return function (className, text, lines) {
    mock.className = className;

    // 文字列を収めたい高さを取得する
    mock.innerHTML = 'a';
    var lineHeight = mock.offsetHeight;
    var height = lineHeight * lines;

    // 指定した行数まで短縮する
    mock.innerHTML = text;
    var i = 0;
    while (mock.offsetHeight > height) {
      i++;
      mock.innerHTML = text.slice(0, -i) + '…';
    }

    if (i === 0) {
      return text;
    }
    return text.slice(0, -i) + '…';
  };
})();

/**
 * Promotionモーダル、記事を表示するページ
 * 記事切り替え、ページャの表示を行う
 */

var OdaiSlotPage = (function (_React$Component) {
  _inherits(OdaiSlotPage, _React$Component);

  function OdaiSlotPage() {
    _classCallCheck(this, OdaiSlotPage);

    _get(Object.getPrototypeOf(OdaiSlotPage.prototype), 'constructor', this).apply(this, arguments);
  }

  _createClass(OdaiSlotPage, [{
    key: 'turnSlot',
    value: function turnSlot(i) {
      OdaiActions.turnSlot(i);
    }
  }, {
    key: 'selectOdai',
    value: function selectOdai() {
      OdaiActions.selectOdai(this.props.randomOdai.uuid);
      PromotionActions.hideWindow();
    }
  }, {
    key: 'renderOdaiSlot',
    value: function renderOdaiSlot() {
      var _this = this;

      if (!this.props.randomOdai) {
        return;
      }

      var descHead = Locale.text('admin.odai.slot_description_head');
      var descFoot = Locale.text('admin.odai.slot_description_foot');
      var descList = [Locale.text('admin.odai.slot_description_1'), Locale.text('admin.odai.slot_description_2')];

      var device = this.props.device;

      var shortenedTitle = shortener('promotion-odaislot-randomodai-title-inner ' + device, this.props.randomOdai.title, 2);

      return React.createElement(
        'div',
        null,
        React.createElement(
          'div',
          { className: 'promotion-odaislot-header' },
          React.createElement(
            'span',
            null,
            React.createElement('i', { className: 'blogicon-odaislot lg' }),
            Locale.text('admin.odai.odai_slot')
          )
        ),
        React.createElement(
          'div',
          { className: 'promotion-odaislot-tagline ' + device },
          React.createElement(
            'p',
            null,
            React.createElement(HtmlText, { body: descHead })
          )
        ),
        React.createElement(
          'div',
          { className: 'promotion-odaislot-description ' + device },
          React.createElement(
            'ul',
            null,
            descList.map(function (d) {
              return React.createElement(
                'li',
                null,
                React.createElement(HtmlText, { body: d })
              );
            })
          )
        ),
        React.createElement(
          'div',
          { className: 'promotion-odaislot-randomodai ' + device },
          React.createElement(
            'span',
            { className: 'promotion-odaislot-randomodai-title ' + device },
            React.createElement(
              'span',
              { className: 'promotion-odaislot-randomodai-title-inner ' + device },
              shortenedTitle
            )
          ),
          React.createElement(
            'div',
            { className: 'promotion-odaislot-randomodai-slotbutton ' + device,
              ref: 'slotButton',
              onClick: function () {
                return _this.turnSlot();
              } },
            React.createElement('i', { className: 'blogicon-repeat tipsy-top',
              title: Locale.text('admin.odai.turn') })
          )
        ),
        React.createElement(
          'button',
          { type: 'button', className: 'promotion-odaislot-insertbutton',
            ref: 'insertButton',
            onClick: function () {
              return _this.selectOdai();
            } },
          Locale.text('admin.odai.insert')
        ),
        React.createElement(
          'div',
          { className: 'promotion-odaislot-footer' },
          React.createElement(
            'p',
            null,
            descFoot
          )
        )
      );
    }
  }, {
    key: 'render',
    value: function render() {
      return React.createElement(
        'div',
        { className: 'promotion-odaislot ' + this.props.device },
        this.renderOdaiSlot()
      );
    }
  }]);

  return OdaiSlotPage;
})(React.Component);

OdaiSlotPage.propTypes = {
  randomOdai: React.PropTypes.object,
  selectedOdais: React.PropTypes.array.isRequired,
  device: React.PropTypes.string.isRequired
};

module.exports = OdaiSlotPage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Base/HtmlText":41,"../../../../Locale":151,"../actions/OdaiActions":128,"../actions/PromotionActions":129}],132:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var Locale = require('../../../../Locale');
var PromotionActions = require('../actions/PromotionActions');
var EntriesActions = require('../actions/EntriesActions');
var EntriesPage = require('./EntriesPage');
var OdaiSlotPage = require('./OdaiSlotPage');
var pageIds = require('../Constants').pageIds;

/**
 * Promotionモーダルに表示するページを決める
 * 一覧ページか、スロットページか
 */

var PageSwitcher = (function (_React$Component) {
    _inherits(PageSwitcher, _React$Component);

    function PageSwitcher() {
        _classCallCheck(this, PageSwitcher);

        _get(Object.getPrototypeOf(PageSwitcher.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(PageSwitcher, [{
        key: 'openOdaiSlotPage',
        value: function openOdaiSlotPage() {
            PromotionActions.setPage(pageIds.ODAI_SLOT_PAGE);
        }
    }, {
        key: 'openEntriesPage',
        value: function openEntriesPage() {
            EntriesActions.showEntryAt(0);
            PromotionActions.setPage(pageIds.ENTRIES_PAGE);
        }
    }, {
        key: 'renderPage',
        value: function renderPage() {
            if (this.props.currentPage === pageIds.ENTRIES_PAGE) {
                return React.createElement(EntriesPage, {
                    device: this.props.device,
                    entries: this.props.entries.entries,
                    currentEntry: this.props.entries.currentEntry });
            }
            if (this.props.currentPage === pageIds.ODAI_SLOT_PAGE) {
                return React.createElement(OdaiSlotPage, {
                    device: this.props.device,
                    randomOdai: this.props.odai.randomOdai,
                    selectedOdais: this.props.odai.selectedOdais });
            }
        }
    }, {
        key: 'renderSwitch',
        value: function renderSwitch() {
            if (this.props.currentPage === pageIds.ENTRIES_PAGE) {
                return this.renderOdaiSlotSwitch();
            }
            if (this.props.currentPage === pageIds.ODAI_SLOT_PAGE) {
                return this.renderEntriesSwitch();
            }
        }
    }, {
        key: 'renderOdaiSlotSwitch',
        value: function renderOdaiSlotSwitch() {
            var _this = this;

            if (this.props.odai.odais.length === 0) {
                return null;
            }

            return React.createElement(
                'div',
                { className: 'promotion-pages-switch' },
                React.createElement(
                    'div',
                    { className: 'promotion-pages-switch-link ' + this.props.device },
                    React.createElement(
                        'a',
                        { href: '#',
                            ref: 'switchToOdaiSlotPage',
                            onClick: function () {
                                return _this.openOdaiSlotPage();
                            } },
                        Locale.text('admin.odai.open_slot'),
                        ' >'
                    )
                )
            );
        }
    }, {
        key: 'renderEntriesSwitch',
        value: function renderEntriesSwitch() {
            var _this2 = this;

            if (this.props.entries.entries.length === 0) {
                return null;
            }

            return React.createElement(
                'div',
                { className: 'promotion-pages-switch' },
                React.createElement(
                    'div',
                    { className: 'promotion-pages-switch-link ' + this.props.device },
                    React.createElement(
                        'a',
                        { href: '#',
                            ref: 'switchToEntriesPage',
                            onClick: function () {
                                return _this2.openEntriesPage();
                            } },
                        '< ',
                        Locale.text('admin.odai.leave_slot')
                    )
                )
            );
        }
    }, {
        key: 'render',
        value: function render() {
            return React.createElement(
                'div',
                { className: 'promotion-pages ' + this.props.device },
                this.renderPage(),
                this.renderSwitch()
            );
        }
    }]);

    return PageSwitcher;
})(React.Component);

PageSwitcher.propTypes = {
    entries: React.PropTypes.object.isRequired,
    odai: React.PropTypes.object.isRequired,
    currentPage: React.PropTypes.string.isRequired,
    device: React.PropTypes.string.isRequired
};

module.exports = PageSwitcher;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../../../Locale":151,"../Constants":125,"../actions/EntriesActions":127,"../actions/PromotionActions":129,"./EntriesPage":130,"./OdaiSlotPage":131}],133:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var PromotionActions = require('../actions/PromotionActions');
var EntriesActions = require('../actions/EntriesActions');

/**
 * Promotionモーダルの中身
 */

var PromotionContent = (function (_React$Component) {
    _inherits(PromotionContent, _React$Component);

    function PromotionContent() {
        _classCallCheck(this, PromotionContent);

        _get(Object.getPrototypeOf(PromotionContent.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(PromotionContent, [{
        key: 'render',
        value: function render() {
            var _this = this;

            var className = 'promotion-entry';
            className += this.props.isSelected ? ' selected' : '';
            className += ' ' + this.props.device;

            var body = function body() {
                return { __html: _this.props.entry.body };
            };

            return React.createElement(
                'div',
                { className: className,
                    onClick: function (e) {
                        return _this.onClick(e);
                    } },
                React.createElement('div', { dangerouslySetInnerHTML: body() })
            );
        }

        /**
         * data-keyword属性のある要素をクリックしたら、キーワードをフィルインする
         */
    }, {
        key: 'onClick',
        value: function onClick(e) {
            var keyword = e.target.getAttribute('data-keyword');
            if (!keyword) {
                return;
            }

            EntriesActions.fillKeyword(keyword);
            PromotionActions.hideWindow();
        }
    }]);

    return PromotionContent;
})(React.Component);

PromotionContent.propTypes = {
    entry: React.PropTypes.object.isRequired,
    isSelected: React.PropTypes.bool.isRequired,
    device: React.PropTypes.string.isRequired
};

module.exports = PromotionContent;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../actions/EntriesActions":127,"../actions/PromotionActions":129}],134:[function(require,module,exports){
(function (global){
'use strict';

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = (typeof window !== "undefined" ? window['React'] : typeof global !== "undefined" ? global['React'] : null);
var PromotionStore = require('../stores/PromotionStore');
var EntriesStoreTouch = require('../stores/EntriesStoreTouch');
var OdaiStoreTouch = require('../stores/OdaiStoreTouch');
var PageSwitcher = require('./PageSwitcher');

/**
 * Promotionモーダルのルートコンポーネント
 */

var PromotionTouch = (function (_React$Component) {
    _inherits(PromotionTouch, _React$Component);

    function PromotionTouch() {
        _classCallCheck(this, PromotionTouch);

        _get(Object.getPrototypeOf(PromotionTouch.prototype), 'constructor', this).call(this);

        this.state = _extends({}, PromotionStore.getState(), {
            odai: OdaiStoreTouch.getState(),
            entries: EntriesStoreTouch.getState()
        });

        this.updateState = this._updateState.bind(this);
    }

    _createClass(PromotionTouch, [{
        key: 'componentDidMount',
        value: function componentDidMount() {
            PromotionStore.on('change', this.updateState);
            EntriesStoreTouch.on('change', this.updateState);
            OdaiStoreTouch.on('change', this.updateState);
        }
    }, {
        key: 'componentWillUnmount',
        value: function componentWillUnmount() {
            PromotionStore.removeListener('change', this.updateState);
            EntriesStoreTouch.removeListener('change', this.updateState);
            OdaiStoreTouch.removeListener('change', this.updateState);
        }
    }, {
        key: '_updateState',
        value: function _updateState() {
            this.setState(_extends({}, PromotionStore.getState(), {
                odai: OdaiStoreTouch.getState(),
                entries: EntriesStoreTouch.getState()
            }));
        }
    }, {
        key: 'render',
        value: function render() {
            return React.createElement(PageSwitcher, {
                entries: this.state.entries,
                odai: this.state.odai,
                device: 'Touch',
                currentPage: this.state.currentPage });
        }
    }]);

    return PromotionTouch;
})(React.Component);

module.exports = PromotionTouch;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../stores/EntriesStoreTouch":136,"../stores/OdaiStoreTouch":138,"../stores/PromotionStore":139,"./PageSwitcher":132}],135:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _ = require('underscore');

var trackEvent = require('../../../../Base/EventTracker').trackEvent;
var Dispatcher = require('../../../../Base/Dispatcher');
var actions = require('../Constants').actions;

var EntriesStore = (function (_Dispatcher$Store) {
    _inherits(EntriesStore, _Dispatcher$Store);

    function EntriesStore() {
        var _this = this;

        _classCallCheck(this, EntriesStore);

        _get(Object.getPrototypeOf(EntriesStore.prototype), 'constructor', this).call(this);

        this.state = {
            entries: [],
            activeEntries: [],
            currentEntry: null
        };

        Dispatcher.on(actions.LOAD_ENTRIES, function (data) {
            _this.loadEntries(data);
            _this.emit('change');
        });
        Dispatcher.on(actions.SHOW_ENTRY_AT, function (i) {
            _this.showEntryAt(i);
            _this.emit('change');
        });
        Dispatcher.on(actions.SHOW_ENTRY, function (entryId) {
            _this.showEntry(entryId);
            _this.emit('change');
        });
        Dispatcher.on(actions.FILL_KEYWORD, function (keyword) {
            _this.fillKeyword(keyword);
            _this.emit('change');
        });
    }

    /**
     * 記事をロードする
     * 編集画面上のボタンに表示する記事を選別し、activeEntriesに格納する
     *
     * @param {Array<PromotionEntry>} entries
     */

    _createClass(EntriesStore, [{
        key: 'loadEntries',
        value: function loadEntries(entries) {
            // 表示するエントリを 2件 用意する
            // まだ読まれていないエントリ優先
            var unreadEntries = entries.filter(function (e) {
                return !e.isRead() && !e.isClosed();
            });
            var readEntries = entries.filter(function (e) {
                return e.isRead() && !e.isClosed();
            });
            var activeEntries = _.first(unreadEntries.concat(_.shuffle(readEntries)), 2);

            this.state.entries = entries;
            this.state.activeEntries = activeEntries;
        }

        /**
         * IDで指定した記事を表示
         * @param {string} entryId - 表示する記事のID
         */
    }, {
        key: 'showEntry',
        value: function showEntry(entryId) {
            var i = _.findIndex(this.state.entries, function (entry) {
                return entry.id === entryId;
            });
            if (i === -1) {
                return;
            }
            this.showEntryAt(i);
        }

        /**
         * indexで指定した記事を表示
         * @param {number} index - 表示する記事のindex
         */
    }, {
        key: 'showEntryAt',
        value: function showEntryAt(i) {
            var entry = this.state.entries[i];
            entry.setAsRead();
            this.state.currentEntry = entry;
            trackEvent('Promotion.Entry.Show.' + entry.id);
        }

        /**
         * キーワードを挿入する
         * @abstract
         * @param {string} keyword
         */
    }, {
        key: 'fillKeyword',
        value: function fillKeyword(keyword) {
            throw new Error('Abstract method "EntriesStore.prototype.fillKeyword" was called');
        }
    }]);

    return EntriesStore;
})(Dispatcher.Store);

module.exports = EntriesStore;

},{"../../../../Base/Dispatcher":34,"../../../../Base/EventTracker":37,"../Constants":125,"underscore":4}],136:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var EntriesStore = require('./EntriesStore');
var EditorConnector = require('../../../../Base/EditorConnector');

/**
 * Touch版PromotionEntryの管理
 * PC版と違いEditorConnectorを使う
 */

var EntriesStoreTouch = (function (_EntriesStore) {
    _inherits(EntriesStoreTouch, _EntriesStore);

    function EntriesStoreTouch() {
        _classCallCheck(this, EntriesStoreTouch);

        _get(Object.getPrototypeOf(EntriesStoreTouch.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(EntriesStoreTouch, [{
        key: 'fillKeyword',

        /**
         * キーワードを挿入する
         * @override
         * @param {string} keyword
         */
        value: function fillKeyword(keyword) {
            var lines = [keyword];
            EditorConnector.insertLines({
                html: lines,
                hatena: lines,
                markdown: lines
            });
        }
    }]);

    return EntriesStoreTouch;
})(EntriesStore);

module.exports = new EntriesStoreTouch();

},{"../../../../Base/EditorConnector":36,"./EntriesStore":135}],137:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _ = require('underscore');
var Dispatcher = require('../../../../Base/Dispatcher');
var actions = require('../Constants').actions;

var OdaiStore = (function (_Dispatcher$Store) {
    _inherits(OdaiStore, _Dispatcher$Store);

    function OdaiStore() {
        var _this = this;

        _classCallCheck(this, OdaiStore);

        _get(Object.getPrototypeOf(OdaiStore.prototype), 'constructor', this).call(this);

        this.state = {
            odais: [],
            randomOdai: null,
            slotCount: 0,
            selectedOdais: [],
            isKilled: this.isKilled(),
            isActive: this.isActive()
        };

        Dispatcher.on(actions.LOAD_ODAIS, function (odais) {
            _this.loadOdais(odais);
            _this.emit('change');
        });
        Dispatcher.on(actions.SELECT_ODAI, function (odaiId) {
            _this.selectOdai(odaiId);
            _this.emit('change');
        });
        Dispatcher.on(actions.TURN_SLOT, function () {
            _this.turnSlot();
            _this.emit('change');
        });
    }

    _createClass(OdaiStore, [{
        key: 'isKilled',
        value: function isKilled() {
            try {
                return !!localStorage['Hatena.Diary.Promotion.OdaiSlot.isKilled'] || false;
            } catch (ignore) {}

            return false;
        }
    }, {
        key: 'isActive',
        value: function isActive() {
            try {
                var isActive = localStorage['Hatena.Diary.Promotion.OdaiSlot.isActive'];
                if (isActive === 'false') {
                    return false;
                }
            } catch (ignore) {}

            return true;
        }

        /**
         * お題スロットで使用するお題をロードする
         *
         * @param {Array<Odai>} odais
         */
    }, {
        key: 'loadOdais',
        value: function loadOdais(odais) {
            this.state.odais = _.shuffle(odais);
            this.turnSlot();
        }

        /**
         * エントリーに紐付けるお題を登録する
         * @param {string} odaiId
         * @abstract
         */
    }, {
        key: 'selectOdai',
        value: function selectOdai(odaiId) {
            throw new Error('Abstract method "OdaiStore.prototype.selectOdai" was called');
        }

        /**
         * お題スロットを回す
         * 事前にshuffleしたodaisを順番に返すことで、同じお題が連続することを回避している
         */
    }, {
        key: 'turnSlot',
        value: function turnSlot() {
            if (this.state.slotCount === this.state.odais.length) {
                this.state.slotCount = 0;
                this.state.odais = _.shuffle(this.state.odais);
            }

            this.state.randomOdai = this.state.odais[this.state.slotCount];
            this.state.slotCount += 1;
        }
    }]);

    return OdaiStore;
})(Dispatcher.Store);

module.exports = OdaiStore;

},{"../../../../Base/Dispatcher":34,"../Constants":125,"underscore":4}],138:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _ = require('underscore');
var Locale = require('../../../../Locale');
var globalData = require('../../../../Base/globalData');
var EditorConnector = require('../../../../Base/EditorConnector');
var Dispatcher = require('../../../../Base/Dispatcher');
var actions = require('../Constants').actions;
var OdaiStore = require('./OdaiStore');

var OdaiStoreTouch = (function (_OdaiStore) {
    _inherits(OdaiStoreTouch, _OdaiStore);

    function OdaiStoreTouch() {
        _classCallCheck(this, OdaiStoreTouch);

        _get(Object.getPrototypeOf(OdaiStoreTouch.prototype), 'constructor', this).apply(this, arguments);
    }

    _createClass(OdaiStoreTouch, [{
        key: 'selectOdai',

        /**
         * エントリーに紐付けるお題を登録する
         * @override
         * @param {string} odaiId
         */
        value: function selectOdai(odaiId) {
            var i = _.findIndex(this.state.odais, function (odai) {
                return odai.uuid === odaiId;
            });
            var odai = this.state.odais[i];
            if (!odai) {
                return;
            }

            // お題を内部的に記録する
            if (_.findIndex(this.state.selectedOdais, function (o) {
                return o.uuid === odaiId;
            }) === -1) {
                this.state.selectedOdais.push(odai);
            }

            // お題を本文にフィルインする
            var title = Locale.text('admin.odai.fillin', odai.title);
            var fillIn = '[' + globalData('admin-domain') + '/-/odai/' + odai.uuid + ':title=' + title + ']';

            var lines = [fillIn];
            EditorConnector.insertLines({
                html: lines,
                hatena: lines,
                markdown: lines
            });
        }
    }]);

    return OdaiStoreTouch;
})(OdaiStore);

module.exports = new OdaiStoreTouch();

},{"../../../../Base/Dispatcher":34,"../../../../Base/EditorConnector":36,"../../../../Base/globalData":52,"../../../../Locale":151,"../Constants":125,"./OdaiStore":137,"underscore":4}],139:[function(require,module,exports){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Dispatcher = require('../../../../Base/Dispatcher');
var actions = require('../Constants').actions;
var pageIds = require('../Constants').pageIds;

var PromotionStore = (function (_Dispatcher$Store) {
    _inherits(PromotionStore, _Dispatcher$Store);

    function PromotionStore() {
        var _this = this;

        _classCallCheck(this, PromotionStore);

        _get(Object.getPrototypeOf(PromotionStore.prototype), 'constructor', this).call(this);

        this.state = {
            isWindowVisible: false,
            currentPage: pageIds.ENTRIES_PAGE
        };

        Dispatcher.on(actions.SHOW_WINDOW, function () {
            _this.showWindow();
            _this.emit('change');
        });
        Dispatcher.on(actions.HIDE_WINDOW, function () {
            _this.hideWindow();
            _this.emit('change');
        });
        Dispatcher.on(actions.SET_PAGE, function (pageId) {
            _this.setPage(pageId);
            _this.emit('change');
        });
    }

    /**
     * Promotionモーダルを表示する
     */

    _createClass(PromotionStore, [{
        key: 'showWindow',
        value: function showWindow() {
            this.state.isWindowVisible = true;
        }

        /**
         * Promotionモーダルを非表示にする
         */
    }, {
        key: 'hideWindow',
        value: function hideWindow() {
            this.state.isWindowVisible = false;
        }
    }, {
        key: 'setPage',
        value: function setPage(pageId) {
            this.state.currentPage = pageId;
        }
    }]);

    return PromotionStore;
})(Dispatcher.Store);

module.exports = new PromotionStore();

},{"../../../../Base/Dispatcher":34,"../Constants":125}],140:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var trackEvent = require('../../Base/EventTracker').trackEvent;
var backupTab = require('../../Util/backupTab');
var EditorConnector = require('../../Base/EditorConnector');

// サイドバーのTwitter貼り付け
var Twitter = function Twitter() {
    this.init.apply(this, arguments);
};
Twitter.prototype = {
    pasteReverseOrder: true,
    // args: { container }
    init: function init(args) {
        var self = this;

        self.$container = args.container;
        if (!self.$container.get(0)) return;
        self.$itemsContainer = self.$container.find('.twitter-items');
        self.$indicator = self.$container.find('.indicator');
        self.itemTemplate = _.template($('.twitter-item-template').html());
        self.$pasteButton = self.$container.find('.twitter-paste-button');
        self.$listTypeContainer = self.$container.find('.twitter-list-type-container');
        self.$formatsContainer = self.$container.find('.twitter-formats');
        self.$reloadButton = self.$container.find('.reload');
        self.$errorMessage = self.$container.find('.error');
        self.$detailOnlyMessage = self.$container.find('.twitter-formats-detail-only');
        self.$header = self.$container.find('.twitter-header');
        self.$footer = self.$container.find('.twitter-footer');

        self.bindEvents();
        self.resize();

        self.loadTweets();
    },
    bindEvents: function bindEvents() {
        var self = this;

        $(window).on('EditorSidebar:resize EditorSidebar:tabChange', function () {
            self.resize();
            self.loadTweets();
        });

        self.$itemsContainer.delegate('.twitter-item', 'click', function (event) {
            if ($(event.target).is('a')) return;
            if ($(this).is('.private')) return;
            $(this).toggleClass('selected');

            self.selectedItemsChanged();
        });

        self.$container.delegate('.twitter-item', 'dblclick', function (event) {
            if ($(event.target).is('a')) return;
            if ($(this).is('.private')) return;
            self.insertSyntaxes([{
                id_str: $(this).attr('data-id-str'),
                screen_name: $(this).attr('data-screen-name'),
                text: $(this).attr('data-text')
            }]);
            $(this).removeClass('selected');
            self.selectedItemsChanged();
            trackEvent(self.$pasteButton.attr('data-track-name'));
            return false;
        });

        self.$pasteButton.click(function (event) {
            var id_strs = [];
            self.$itemsContainer.find('.selected').each(function () {
                id_strs.push({
                    id_str: $(this).attr('data-id-str'),
                    screen_name: $(this).attr('data-screen-name'),
                    text: $(this).attr('data-text')
                });
                $(this).removeClass('selected');
            });
            self.insertSyntaxes(id_strs);
            self.selectedItemsChanged();
        });

        // list type
        self.$listTypeContainer.delegate('input', 'change', function () {
            if (self.getListType == $(this).val()) return;
            self.setListType($(this).val());
            self.$listTypeContainer.find('label.selected').removeClass('selected');
            $(this).closest('label').addClass('selected');
            self.loadTweets();
        });

        backupTab({
            $container: self.$formatsContainer,
            key: 'twitter-format',
            onchange: function onchange($input) {
                self.$formatsContainer.find('label.selected').removeClass('selected');
                $input.closest('label').addClass('selected');
            }
        });

        backupTab({
            $container: self.$listTypeContainer,
            key: 'twitter-list-type',
            onchange: function onchange($input) {
                self.setListType($input.val());
                self.$listTypeContainer.find('label.selected').removeClass('selected');
                $input.closest('label').addClass('selected');
                self.loadTweets();

                // 自分のツイートのときだけ貼り付けフォーマット選べる
                if ($input.val() == 'tweets') {
                    self.$formatsContainer.css('visibility', 'visible');
                    self.$detailOnlyMessage.hide();
                } else {
                    self.$formatsContainer.css('visibility', 'hidden');
                    self.$detailOnlyMessage.show();
                }
            }
        });

        self.$reloadButton.click(function (event) {
            self.loadTweets(null, true);
        });

        // オートページャ
        self.$itemsContainer.scroll(_.throttle(function () {
            var rate = (self.$itemsContainer.scrollTop() + self.$itemsContainer.height()) / self.$itemsContainer[0].scrollHeight;
            if (rate > 0.7) {
                // 下のほうに行ったらもっと読む
                self.loadMore();
            }
        }, 100));
    },
    resize: function resize() {
        var self = this;

        var mainHeight = $(window).height();

        var padding = 0;
        padding += parseInt(self.$itemsContainer.css('padding-top'), 10) || 0;
        padding += parseInt(self.$itemsContainer.css('padding-bottom'), 10) || 0;
        self.$itemsContainer.height(mainHeight - self.$container.offset().top - self.$header.outerHeight(true) - self.$footer.outerHeight(true) - padding);
    },
    setListType: function setListType(type) {
        if (!type.match(/^(tweets|favorites|timeline)$/)) return;
        this.listType = type;
    },
    getListType: function getListType() {
        // さっき設定された？
        if (this.listType) {
            return this.listType;
        }
        // デフォルト値
        return 'tweets';
    },
    selectedItemsChanged: function selectedItemsChanged() {
        var self = this;

        if (self.$itemsContainer.find('.selected').length > 0) {
            self.$pasteButton.removeClass('disabled').addClass('enabled').prop('disabled', false);
        } else {
            self.$pasteButton.removeClass('enabled').addClass('disabled').prop('disabled', true);
        }
    },
    loadTweets: function loadTweets(max_id, force) {
        var self = this;

        if (self.isLoading) return;
        if (!self.$container.is(':visible')) return;

        self.isLoading = true;
        self.$indicator.show();

        if (!max_id) {
            self.$itemsContainer.find('.twitter-item').remove();
        }

        var data = {};

        if (max_id) {
            data.max_id = max_id;
        }

        var list_type = self.getListType();

        var url = '/api/twitter/' + list_type + (max_id ? '?max_id=' + max_id : '');

        self.ajaxGetOrCache(url, force).done(function (items) {
            // 通信中にタブ切り替えられてたら結果を捨てて再度通信する
            // _.deferしてるのはalwaysが終了してから実行するため
            if (self.getListType() != list_type) {
                _.defer(function () {
                    self.loadTweets();
                });
                return;
            }
            if (max_id) {
                // 1件目は重複
                items.shift();
            }
            self.showItems(items);

            self.$errorMessage.hide();
        }).fail(function (res) {
            self.$errorMessage.show();
        }).always(function () {
            self.$indicator.hide();
            self.isLoading = false;
        });
    },
    showItems: function showItems(items) {
        var self = this;

        var source = '';
        _.each(items, function (item) {
            source += self.itemTemplate({
                item: item
            });
        });
        self.$indicator.before(source);
    },
    loadMore: function loadMore() {
        var self = this;

        var $lastItem = self.$itemsContainer.find('.twitter-item:last');
        if (!$lastItem.length) return;

        var maxId = $lastItem.attr('data-id-str');

        self.loadTweets(maxId);
    },
    // tweet: { screen_name, id_str, text }
    insertSyntaxes: function insertSyntaxes(tweets) {
        var self = this;

        var format = self.getFormat();

        // markdownモード時はscreen_nameをescapeする必要があるので別に作っている
        var syntaxes = [];
        var syntaxes_for_markdown = [];
        _.each(tweets.reverse(), function (tweet) {
            syntaxes.push(self.createSyntax(tweet, format, false));
            syntaxes_for_markdown.push(self.createSyntax(tweet, format, true));
        });

        EditorConnector.insertLines({
            html: syntaxes,
            hatena: syntaxes,
            markdown: syntaxes_for_markdown
        });
    },
    createSyntax: function createSyntax(tweet, format, is_markdown) {
        if (format == "detail") {
            var screen_name = tweet.screen_name;

            // __hoge__みたいな名前だとmarkdownの強調表示に引っかかって崩れるので
            // markdownモードの時はエスケープするようにしてる
            if (is_markdown) screen_name = screen_name.replace(/_(.*?)_/g, '\\_$1\\_');

            var text = tweet.text;
            text = text.replace(/[\[\]\n]/g, '').replace(/([\*`_])/g, "\\$1");

            return "[https://twitter.com/" + screen_name + "/status/" + tweet.id_str + ":embed#" + text + "]";
        } else if (format == "text") {
            return tweet.text;
        }
    },
    getFormat: function getFormat() {
        if (this.getListType() == "tweets") {
            return this.$container.find('[name="twitter-format"]:checked').val();
        }
        return "detail";
    },
    ajaxGetOrCache: function ajaxGetOrCache(url, force_disable_cache) {
        // ajax getまたはキャッシュから返す
        // タブ切り替えて戻すだけで通信しないようにするためのやつ
        // jqXHRではなくDeferredオブジェクトが返ることがあるので使う側で注意すること
        var self = this;

        // forceじゃなくてキャッシュあったら返す
        if (!force_disable_cache && self.ajaxGetOrCacheCache[url]) {
            var dfd = $.Deferred();
            dfd.resolve(self.ajaxGetOrCacheCache[url]);
            return dfd.promise();
        }

        // thenを追加してキャッシュに保存するというのをやっています
        return $.ajax({
            url: url
        }).done(function (res) {
            self.ajaxGetOrCacheCache[url] = res;
        });
    },
    ajaxGetOrCacheCache: {}
};

module.exports = Twitter;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../../Base/EditorConnector":36,"../../Base/EventTracker":37,"../../Util/backupTab":160,"underscore":4}],141:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

/**
 * touch版で開く貼り付けコンポーネントをリサイズする
 * 1度だけ実行する
 */
var simulateSidebar = _.once(function () {
    $(window).on('resize', _.debounce(function () {
        $(window).trigger('EditorSidebar:resize');
    }, 100)).resize();

    $('input').on('blur', function () {
        $(window).trigger('EditorSidebar:resize');
    });
});

module.exports = simulateSidebar;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],142:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

/**
 * 全画面で表示する背景
 * クリックしたらドロップダウンを閉じる
 */
var $background = $('<div>').css({
    position: 'fixed',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%'
});
$background.hide().appendTo(document.body);

$background.on('click', function (e) {
    $background.hide();

    // クリックした位置にある要素を擬似的にクリックする
    var target = document.elementFromPoint(e.pageX, e.pageY);
    $(target).click();
});

/**
 * 編集画面のドロップダウン
 * show / hide のみを管理する
 * ドロップダウンメニュー内の要素をクリックした時の処理は管理しない
 */
var Dropdown = function Dropdown() {
    this.init.apply(this, arguments);
};
Dropdown.prototype = {

    init: function init($element, $window) {
        this.$element = $element;
        this.$window = $window;
        this.bindEvents();
    },

    bindEvents: function bindEvents() {
        var self = this;

        this.$element.on('click', function () {
            // 初期化時ではなく、表示する直前に位置を決める
            // 初期化時にボタンが非表示の場合、位置を取得できないため
            self.setPosition();

            $background.show();
            self.$window.show();
            $background.on('click', onClickBackground);
        });

        this.$window.on('click', function () {
            self.$window.hide();
            $background.hide();
        });

        var onClickBackground = function onClickBackground() {
            self.$window.hide();
            $background.off('click', onClickBackground);
        };
    },

    /**
     * ドロップダウンを表示する位置を決定する
     */
    setPosition: function setPosition() {
        var rect = this.$element[0].getBoundingClientRect();
        this.$window.css({
            top: rect.bottom,
            left: rect.left
        });
    }

};

module.exports = Dropdown;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],143:[function(require,module,exports){
(function (global){
'use strict';

var EventEmitter = require('events').EventEmitter;

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../Locale');
var Logger = require('../Base/Logger');
var Browser = require('../Base/Browser');
var EventTracker = require('../Base/EventTracker');
var decodeParam = require('../Util/decodeParam');

var ShareDraft = require('./ShareDraft');
var Preview = require('./Preview');
var ColorPicker = require('./ColorPicker');
var Dropdown = require('./Dropdown');

var Editor = function Editor() {
    this.init.apply(this, arguments);
};
Editor.prototype = {
    init: function init(form) {
        var self = this;
        self.id = 'editor-' + Math.random().toString(32).substring(2);
        self.form = $(form);

        self.eventEmitter = new EventEmitter();

        self.$editor = $('#editor');
        self.title = self.form.find('[name="title"]');
        self.body = self.form.find('textarea[name="body"]');
        self.mode = self.form.find('[name="syntax"]').val();
        self.datetime = self.form.find('[name="datetime"]');
        self.tabs = self.form.find('.tabs');
        self.toolbar = self.form.find('.toolbar');
        self.subToolbar = self.form.find('.toolbar-sub');
        self.$preview = self.form.find('#preview');
        self.$buttons = self.form.find('.buttons');
        self.impl = Editor.impl[self.mode];

        self.editarea = $('<div class="editarea"></div>').appendTo(self.body.parent());
        self.editareaHover = $('<div class="editarea-hover"><div class="editarea-hover-inner">' + Locale.text('epic.editarea.hover') + '</div></div>').appendTo(self.editarea);

        self.backup = Hatena.Diary.Backup.createMessage(self.form, self.editarea);
        self.form.bind('backup-save', function () {
            self.trigger('change');
        });
        self.form.bind('backup-message-close', function () {
            self.setHeight();
        });

        self.on('promotion-button-close', function () {
            self.setHeight();
        });

        Logger.LOG('init editor with mode: ' + self.mode);
        for (var key in self.impl) if (self.impl.hasOwnProperty(key)) {
            self[key] = self.impl[key];
        }

        self.initToolbar();

        // jQuery UI tabs
        self.tabs.tabs();

        // プレビュータブのドロップダウン初期化
        self.shareDraft = new ShareDraft(self);
        self.preview = new Preview(self);
        self.setupPreviewDropdown();

        // syntax切替
        self.setupSyntaxSwitcher();

        // initEditorはpreviewに依存する
        self.initEditor();

        if (Browser.isIE) {
            self.setupRestoreFocus();
        }
    },

    getBody: function getBody() {
        return this.body.val();
    },

    getCategories: function getCategories() {
        return this.form.find('input[name="category"]').map(function () {
            return this.value;
        });
    },

    getCategoriesAsParamsArray: function getCategoriesAsParamsArray() {
        return this.getCategories().map(function () {
            return { name: 'category', value: '' + this };
        }).toArray();
    },

    initToolbar: function initToolbar() {
        var self = this;

        self.toolbar.on('click', 'button', function () {
            var action = $(this).attr('data-action');
            if (action) {
                self.invokeAction(action);
            }

            return false;
        });

        self.toolbar.find('button[data-action]').each(function () {
            var $this = $(this);
            var action = $this.attr('data-action');
            if (!self.actions[action]) {
                $this.attr('disabled', 'disabled');
                $this.addClass('disabled');
            }
        });

        self.toolbar.find('.toolbar-select-button').each(function () {
            var dropdownWindowSelector = $(this).attr('data-dropdown-window-selector');
            var $dropdownWindow = $('#editor').find(dropdownWindowSelector);
            new Dropdown($(this), $dropdownWindow);
        });

        $('.toolbar-select-dropdown-window').on("mousedown", "[data-action]", function (event) {
            var $button = $(this);
            var action = $button.attr('data-action');
            self.invokeAction(action);
            $button.closest('.toolbar-select-dropdown-window').hide();

            EventTracker.trackEvent($button.attr('data-track-name'));

            return false;
        });

        this.setupColorPicker();
        this.setupToolbarMore();
    },

    // "ツールバーを全て表示する"ボタンのセットアップ
    setupToolbarMore: function setupToolbarMore() {
        var self = this;

        var $button_toolbar_more = $('.button-toolbar-more');

        var localStorageKey = 'Hatena.Diary.Editor.showSubToolbar';

        try {
            localStorage[localStorageKey] = localStorage[localStorageKey] || "true";
        } catch (ignore) {}

        $button_toolbar_more.click(function (e) {
            e.preventDefault();

            self.toggleSubToolbar();

            try {
                // localStorageに下段ツールバーを表示しているかどうか保存する
                var show_sub_toolbar_value = !JSON.parse(localStorage[localStorageKey]);

                localStorage[localStorageKey] = show_sub_toolbar_value.toString();
            } catch (ignore) {}
        });

        // 開く設定になってるか，localStorageが無効なとき，開く
        var should_open;
        try {
            should_open = localStorage[localStorageKey] === 'true';
        } catch (error) {
            should_open = true;
        }

        if (should_open) {
            self.toggleSubToolbar();
        }
    },

    toggleSubToolbar: function toggleSubToolbar() {
        var $button_toolbar_more = $('.button-toolbar-more');

        var sub_toolbar_is_shown = this.subToolbar.is(':visible');

        this.subToolbar.toggle();

        // IEではdisplay状態によってheightの値が変わるため,
        // はじめに補助ツールバーを開くときにheightの値を記憶する.
        Editor.SubToolbarHeight = Editor.SubToolbarHeight || this.subToolbar.outerHeight();

        $button_toolbar_more.toggleClass('is-hidden');

        this.setHeight();
    },

    setupColorPicker: function setupColorPicker() {
        var self = this;

        var $colorPickerWindow = $('.js-hatena-diary-color-picker');
        var $colorPickerButton = $('[data-action="color"]');

        this.colorPicker = new ColorPicker($colorPickerWindow);
        this.colorPicker.on('colorpick', function (e, color) {
            self.invokeAction('pickColor', color);
        });

        this.colorPickerDropdown = new Dropdown($colorPickerButton, $colorPickerWindow);
    },

    invokeAction: function invokeAction(action, data) {
        var self = this;
        try {
            Logger.LOG('invokeAction: ' + action);
            self.trigger('actionbefore', { action: action });
            self.actions[action].call(this, data);
            self.trigger('actionafter', { action: action });
        } catch (e) {
            Logger.BUG(e);
        }
    },

    bind: function bind(event, func) {
        var self = this;
        self.form.bind('editor.' + event, func);
    },

    trigger: function trigger(event, obj) {
        var self = this;
        self.form.trigger('editor.' + event, obj);
    },

    getCharacterCount: function getCharacterCount() {
        var self = this;
        return self.body.val().length;
    },

    getByteCount: function getByteCount() {
        var text = this.body.val();
        return encodeURIComponent(text).replace(/%../g, "x").length;
    },

    setupRestoreFocus: function setupRestoreFocus() {
        // IEではfocus外してfocusし直すとカーソル位置がリセットされるのでタイマーで監視して以前の場所に戻す

        var self = this;
        var range;

        // フォーカス中ならrangeを記録
        setInterval(function () {
            if (self.isFocused()) range = self.getSelectionRange();
        }, 100);

        // 編集サイドバークリックされたときinputでなかったらエディタにfocusしなおす
        $('#editor-support-container, .curation-tab-contents, .toolbar').on('click', function (event) {
            if ($(event.target).is('textarea, :text')) return;
            self.focus();
            if (range) self.setSelectionRange(range);
        });
    },

    // 新規投稿時のみ, 記事毎にsyntaxが設定できる
    setupSyntaxSwitcher: function setupSyntaxSwitcher() {
        var self = this;

        var query = location.search.slice(1);
        var params = decodeParam(query);

        var $syntaxSwitcher = self.$editor.find('.js-syntax-switcher');
        var $dropdownWindow = self.$editor.find('.js-select-dropdown-window-syntax');

        // 編集モードの時はsyntax変更不可
        if (params['entry']) {
            $syntaxSwitcher.addClass('syntax-switcher-disabled');
            return;
        }

        self.syntaxSwitcher = new Dropdown($syntaxSwitcher, $dropdownWindow);

        $dropdownWindow.find('.js-dropdown-syntax').on('click', function () {
            if (!confirm(Locale.text('epic.syntax_switch'))) {
                $dropdownWindow.toggle();
                return;
            }

            // 本文のバックアップを削除する
            $(document).trigger('clearBackup');
            params['syntax'] = $(this).data('syntax');
            location.href = Hatena.Diary.Util.locationWithParam(params);
        });
    },
    disableSyntaxSwitcher: function disableSyntaxSwitcher() {
        var $dropdownWindow = this.$editor.find('.js-select-dropdown-window-syntax');
        $dropdownWindow.hide();
        $('.js-syntax-switcher').addClass('syntax-switcher-hidden');
    },
    enableSyntaxSwitcher: function enableSyntaxSwitcher() {
        $('.js-syntax-switcher').removeClass('syntax-switcher-hidden');
    },

    setupPreviewDropdown: function setupPreviewDropdown() {
        var self = this;
        var $dropdownButton = self.tabs.find('.js-preview-dropdown');
        var $dropdownWindow = self.$editor.find('.js-select-dropdown-window-preview');

        self.previewDropdown = new Dropdown($dropdownButton, $dropdownWindow);

        $dropdownButton.on('click', function () {
            // 下書きプレビューURLボックスの位置を設定
            var marginTop = parseInt($dropdownWindow.css('margin-top'), 10);
            var rect = this.getBoundingClientRect();
            var base = $(this).offsetParent().offset();
            self.shareDraft.setWindowPosition({
                top: rect.bottom - base.top + marginTop,
                left: rect.left - base.left
            });
            return false;
        });
    },

    on: function on() {
        this.eventEmitter.on.apply(this.eventEmitter, arguments);
    },

    emit: function emit() {
        this.eventEmitter.emit.apply(this.eventEmitter, arguments);
    },

    URLPattern: /^https?:\/\/\S+$/
};

Editor.currentEditor = null;

Editor.impl = {
    html: require('./HTMLEditor'),
    hatena: require('./HatenaEditor'),
    markdown: require('./MarkdownEditor')
};

module.exports = Editor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Browser":31,"../Base/EventTracker":37,"../Base/Logger":44,"../Locale":151,"../Util/decodeParam":162,"./ColorPicker":115,"./Dropdown":142,"./HTMLEditor":144,"./HatenaEditor":145,"./MarkdownEditor":146,"./Preview":147,"./ShareDraft":149,"events":1}],144:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var tinymce = (typeof window !== "undefined" ? window['tinymce'] : typeof global !== "undefined" ? global['tinymce'] : null);
var ace = (typeof window !== "undefined" ? window['ace'] : typeof global !== "undefined" ? global['ace'] : null);

var keyString = require('../keyString');
var Locale = require('../Locale');
var LOG = require('../Base/Logger');
var URLGenerator = require('../Base/URLGenerator');
var Browser = require('../Base/Browser');

var Uploader = require('./Uploader');

/* WYSIWYG
 *  WYSIWYG と HTML ソースのタブ切替え
 */
var HTMLEditor = {
    initEditor: function initEditor() {
        var self = this;
        self.source = self.tabs.find('#source');

        self.initWYSIWYG();
        self.initAce();

        self.currentTab = 'wysiwyg'; // 'wysiwyg' | 'source' | 'preview'
        self.tabs.on('tabsactivate', function (event, ui) {
            var panelID = ui.newPanel.attr('id');
            self.currentTab = panelID;
            if (/source/.test(panelID)) {
                setTimeout(function () {
                    self.ace.resize();
                    self.ace.focus();
                }, 0);
                self.writeBack();
                self.setValue(self.body.val());
                self.disableSyntaxSwitcher();
            } else if (/preview/.test(panelID)) {
                self.writeBack();
                self.preview.previewInIframe();
                self.disableSyntaxSwitcher();
            } else {
                self.setValue(self.body.val());
                self.tinymce.focus();
                self.enableSyntaxSwitcher();
            }
            self.setHeight();
        });

        self.bind('actionafter', function () {
            self.writeBack();
        });

        self.form.bind('backup-restore', function () {
            self.setValue(self.body.val());
        });
    },

    initWYSIWYG: function initWYSIWYG() {
        var self = this;
        self.editarea.show();
        self.body.appendTo(self.editarea);

        // iframe中でTinyMCEを使うと, IE9においてTinyMCE内部でdocument.activeElementを呼んだとき`Unspecified error`例外が起きるようである
        // そこでtinymce.init直前でdocument.bodyにfocus()することでdocument.activeElementが存在する状態を作り, これを回避する
        document.body.focus();

        self.tinymce = tinymce.init({
            mode: "exact",
            elements: self.body.attr('id'),

            keep_styles: false,
            custom_shortcuts: false,

            height: '100%',
            width: '100%',

            body_class: ['preview', 'mce-inner-body'],

            theme: "modern",
            skin: "lightgray",

            toolbar: false,
            menubar: false,
            statusbar: false,

            content_css: URLGenerator.static_url('/css/editor-wysiwyg.css'),
            convert_urls: false,

            // 文字実体参照に変換しない
            entity_encoding: "raw",

            // 全ての要素と属性を許可する
            // valid_elementsで許可するとTinyMCEの挙動が変わるのでextended_valid_elementsで許可する
            extended_valid_elements: '*[*],#ins[*]',
            // body以下にstyle要素が入るのを許可する
            valid_children: "+body[style]",

            plugins: ["pagebreak", "paste"],
            paste_data_images: Browser.isChrome,
            pagebreak_separator: "<!-- more -->",
            paste_webkit_styles: "all",

            paste_preprocess: function paste_preprocess(plugin, event) {

                // 画像が貼り付けられたらfotolifeにアップロードする
                // Google Chromeのときだけうまく動く
                if (Browser.isChrome) {
                    try {
                        self.handleImagePasteEvent(event);
                    } catch (error) {
                        LOG.BUG(error, 'upload pasted image filed(wysiwyg)');
                    }
                }

                var content = event.content.replace(/^[\s]*/, '').replace(/[\s]*$/, '');

                // URLが貼り付けされたら貼り付けボックス開く
                if (content.match(self.URLPattern)) {
                    var url = event.content;
                    $(self).triggerHandler('paste-url', [url]);
                    event.content = '';

                    event.preventDefault();
                    event.stopPropagation();
                }

                // [:contents]を含むタグだったらplain textとしてペーストさせる
                if (content.match(/^(<[^>]+?>)+\[:contents\](<\/[^<]+?>)+$/)) {
                    event.content = '[:contents]';
                }
            },

            setup: function setup(ed) {
                ed.on('PreInit', function () {
                    // iframeのsrcにjavascript:書ける対策
                    // onerrorなどはSchema.jsに載ってないのでもとから書けない
                    // java&#9;script:みたいなスキームを，一度DOMに入れて取り出すことで正規化してる
                    var javascript_protocol = 'javascript:';
                    var data_protocol = 'data:'; // data:のとき自由にscript要素書ける上, Firefoxでsame originとして取り扱われるので禁止
                    var $dummy_div = $('<div>');
                    var $dummy_a = $('<a>');
                    ed.parser.addNodeFilter('iframe', function (nodes) {
                        _.each(nodes, function (node) {
                            var src = node.attr('src');
                            if (!src) return;
                            var normalized_src = $dummy_div.html(src).text();
                            var protocol = $dummy_a.attr('href', normalized_src)[0].protocol; // DOMにいれて，protocolがjavascript:だったらダメ
                            if (protocol === javascript_protocol || protocol === data_protocol) {
                                var escaped = 'ignored:' + src;
                                node.attr('src', escaped);
                            }
                        });
                    });

                    // freezedクラスのついたdivは見たまま編集で編集できないようにする．みたまま編集エリアに表示するときにcontenteditable = falseにして，HTMLに戻すときにcontenteditable消す
                    ed.parser.addNodeFilter('div', function (nodes) {
                        _.each(nodes, function (node) {
                            if (node.attr('class') && node.attr('class').match(/\bfreezed\b/)) {
                                node.attr('contenteditable', 'false');
                            }
                        });
                    });

                    ed.serializer.addNodeFilter('div', function (nodes) {
                        _.each(nodes, function (node) {
                            if (node.attr('class') && node.attr('class').match(/\bfreezed\b/)) {
                                node.attr('contenteditable', null);
                            }
                        });
                    });

                    ed.on('ObjectResized', function (e) {
                        // 編集エリアの幅を越えたリサイズするとアスペクト比変わる
                        // また，max-width: 100%しているので，heightも指定されると崩れるので，
                        // リサイズ完了時にheight属性がついてたら消す
                        if (e.target.hasAttribute('height')) {
                            e.target.removeAttribute('height');
                        }
                    });
                });

                ed.on('submit', function (e) {
                    var originalBody = self.tinymce.getContent();
                    var body = originalBody;

                    // ブラウザが実体参照化していれば元に戻す
                    if ($('<iframe><p></p></iframe>').html().match(/&lt;/)) {
                        body = self.unescapeEntities(body);
                        if (!body) {
                            body = originalBody;
                        }
                    }
                    $('<input type="hidden" name="unescaped_body"/>').val(body).appendTo(e.target);
                });
            },

            oninit: function oninit() {
                // http://www.tinymce.com/wiki.php/API4:class.tinymce.Editor
                self.tinymce = tinymce.get(self.body.attr('id'));

                // IMEの状態を保持しておく
                self.isIMEComposing = false;
                $(self.tinymce.getBody()).on('compositionstart', function () {
                    self.isIMEComposing = true;
                }).on('compositionend', function (e) {
                    self.isIMEComposing = false;
                });

                self.editarea.find('.mce-edit-area').css({
                    display: 'block',
                    width: '100%',
                    'min-height': '100%',
                    'border-width': '0px'
                });

                self.tinymce.on('KeyUp', function (e) {
                    var key = keyString(e);
                    if (key == 'RET') {
                        self.newLine(e);
                    } else if (key == 'BS') {
                        self.backspace(e);
                    }
                });

                self.tinymce.on('KeyUp', function (e) {
                    self.writeBack();
                    self.trigger('change');
                });

                // tinymceで生成されるiframe内のhtml要素のサイズをiframeにあわせる
                self.editorHTMLElement = $(self.tinymce.getDoc()).find('html').eq(0);
                self.editorHTMLElement.css({
                    height: '100%'
                });

                self.initDropper();
            }
        });
    },

    // Drag & Drop URL / images
    initDropper: function initDropper() {
        if (Browser.isIE && !Browser.isIE11) {
            return;
        }

        var self = this;
        var isDraggingInner = false;

        var isFile = function isFile(e) {
            return e.dataTransfer.files.length > 0;
        };

        var onDragEnter = _.debounce(function (e) {
            console.log('drag');
            if (isDraggingInner) {
                return;
            }
            self.editareaHover.addClass('dragging');
        }, 20);
        var onDragLeave = function onDragLeave(e) {
            console.log('dragleave');
            self.editareaHover.removeClass('dragging');
        };
        var onDrop = function onDrop(e) {
            console.log('drop');
            self.editareaHover.removeClass('dragging');
            if (isFile(e)) {
                // Fileの場合、fotolifeサイドバーを出してアップロード

                // ファイルのドロップとペーストを区別したいので，ドロップされた瞬間だけ，justImageHasDroppedをtrueにする
                self.justImageHasDropped = true;
                _.defer(function () {
                    self.justImageHasDropped = false;
                });

                Hatena.Diary.EditorComponent.EditorSidebar.openByType('editor-fotolife');
                Uploader.uploadDroppedFiles(e);
            } else {
                // テキストがURLなら貼り付けボックスだす
                var content = e.dataTransfer.getData('Text').trim();
                if (content.match(self.URLPattern)) {
                    $(self).triggerHandler('paste-url', [content]);
                }
            }
        };

        // 以下、tinyMCEのエディタ上で上でDragOverするためのコード
        var cancelEvent = function cancelEvent(e) {
            e.stopPropagation();
            e.preventDefault();
        };

        var leaveTimer = null;
        var cancelLeaving = function cancelLeaving() {
            clearTimeout(leaveTimer);
            leaveTimer = null;
        };
        var isDragging = false;
        var editorAce = $(self.tinymce.getDoc()); // 見たままタブの入力エリア
        var editorHTML = self.ace.container; // HTMLタブの入力エリア
        var editors = editorAce.add(editorHTML);
        editors.on('dragstart', function () {
            isDraggingInner = true;
        }).on('dragend', function () {
            isDraggingInner = false;
        }).on('dragenter', function (_e) {
            if (isDraggingInner) {
                return;
            }
            if (leaveTimer !== null) {
                return cancelLeaving();
            }
            if (isDragging) {
                return;
            }
            isDragging = true;

            var e = _e.originalEvent;
            cancelEvent(e);
            onDragEnter(e);
        }).on('dragenter', '*', function (_e) {
            if (isDraggingInner) {
                return;
            }
            if (leaveTimer !== null) {
                return cancelLeaving();
            }
            if (isDragging) {
                return;
            }
            isDragging = true;

            var e = _e.originalEvent;
            cancelEvent(e);
            onDragEnter(e);
        }).on('dragover', function (_e) {
            if (isDraggingInner) {
                return;
            }
            if (leaveTimer !== null) {
                return cancelLeaving();
            }
            var e = _e.originalEvent;
            cancelEvent(e);
        }).on('dragleave', function (_e) {
            if (isDraggingInner) {
                return;
            }
            var e = _e.originalEvent;
            cancelLeaving();
            leaveTimer = setTimeout(function () {
                isDragging = false;
                onDragLeave(e);
            }, 50);
        }).on('drop', function (_e) {
            if (isDraggingInner) {
                return;
            }
            isDragging = false;
            var e = _e.originalEvent;
            cancelEvent(e);
            onDrop(e);
        });
    },

    execCommand: function execCommand(command, value) {
        if (this.tinymce) {
            this.tinymce.execCommand(command, false, value);
        }
        this.writeBack();
    },

    newLine: function newLine(e) {
        var self = this;

        var window = self.tinymce.getWin();
        var document = self.tinymce.getDoc();

        var selection = self.tinymce.selection;
        var node = selection.getNode();
        var container = $(node).closest('div.hatena-embed')[0];

        if (container) {
            var p = container.nextSibling;
            if (!p || p.nodeName.toLowerCase() != 'p') {
                p = document.createElement('p');
                p.appendChild(document.createElement('br'));
                container.parentNode.insertBefore(p, container.nextSibling);
            }

            var range = selection.getRng();
            range.setStart(p, 0);
            range.setEnd(p, 0);
            selection.setRng(range);
            e.preventDefault();
        }
    },

    backspace: function backspace(e) {
        var self = this;

        var window = self.tinymce.getWin();
        var document = self.tinymce.getDoc();

        var selection = self.tinymce.selection;
        var node = selection.getNode();
        var container = $(node).closest('div.hatena-embed')[0];

        if (container) {
            var p = container.previousSibling || document.body;
            var range = selection.getRng();
            range.selectNodeContents(p);
            range.collapse(false);
            selection.setRng(range);
            e.preventDefault();

            container.parentNode.removeChild(container);
        }
    },

    initAce: function initAce() {
        var self = this;
        var container = document.createElement('div');

        $(container).css({
            position: 'absolute',
            height: '100%',
            width: '100%',
            padding: '0px',
            margin: '0px'
        });

        self.source.append(container);

        var editor = ace.edit(container);
        editor.commands.removeCommand('gotoline'); // fucking default keybinding of ace
        editor.commands.removeCommand('indent');
        editor.commands.removeCommand('outdent');

        editor.renderer.setShowGutter(false);
        editor.renderer.setHScrollBarAlwaysVisible(false);
        editor.renderer.setPadding(5);
        editor.renderer.setShowPrintMargin(false);

        editor.setHighlightActiveLine(false);

        var HtmlMode = ace.require('ace/mode/html').Mode;
        var mode = new HtmlMode();
        mode.$modes['js-'].$behaviour.remove('braces');
        mode.$modes['js-'].$behaviour.remove('parens');
        mode.$modes['js-'].$behaviour.remove('string_dquotes');

        var session = editor.getSession();
        session.setMode(mode);
        session.setUseWrapMode(true);
        session.setValue(self.body.val());
        session.on('change', function () {
            var val = session.getValue();
            self.body.val(val);
            if (self.tinymce) {
                self.tinymce.setContent(val);
            }
        });

        editor.$blockScrolling = Infinity;

        self.ace = editor;
    },

    setHeight: function setHeight() {
        this.currentTab = this.currentTab || 'wysiwyg';

        var withoutButtons = $(window).height() - this.$buttons.outerHeight();
        var tabTop = $('#' + this.currentTab).offset().top;

        this.editarea.height(withoutButtons - this.editarea.offset().top);
        this.$preview.height(withoutButtons - tabTop - 2); // subtract border width

        // HTMLソースタブはinitEditorされるまで未定義
        var $source = this.source || $('#source');
        $source.height(withoutButtons - tabTop - 2);
    },

    focus: function focus() {
        var self = this;
        self.writeBack();
        if (self.tinymce) self.tinymce.focus();
    },

    getSelectionRange: function getSelectionRange() {
        return this.tinymce.selection.getRng();
    },

    setSelectionRange: function setSelectionRange(range) {
        this.tinymce.selection.setRng(range);
    },

    isFocused: function isFocused() {
        return $(document.activeElement).is('#body_ifr');
    },

    setValue: function setValue(val) {
        var unescaped = this.unescapeEntities(val);
        this.body.val(unescaped);
        this.execCommand('mceSetContent', unescaped);
        this.ace.getSession().setValue(unescaped);
    },

    unescapeEntities: function unescapeEntities(val) {
        $.each(['style', 'script', 'xmp', 'iframe', 'noembed', 'noframes', 'plaintext', 'noscript'], function () {
            var tag = this;
            val = val.replace(new RegExp('<' + tag + '(.*?)>(.*?)<\\/' + tag + '>', 'g'), function (match, attr, content) {
                content = content.replace(/&lt;/g, '<');
                content = content.replace(/&gt;/g, '>');
                content = content.replace(/&quot;/g, '"');
                content = content.replace(/&amp;/g, '&');
                return '<' + tag + attr + '>' + content + '</' + tag + '>';
            });
        });
        return val;
    },

    insert: function insert(text) {
        this.execCommand('mceInsertContent', text);
    },

    insertLines: function insertLines(lines) {
        var syntax = _.map(lines, function (line) {
            return '<p>' + line + '</p>';
        });
        this.insert(syntax.join(''));
    },

    getCharacterCount: function getCharacterCount() {
        var self = this;
        var body = self.tinymce.getBody();
        var text = typeof body.textContent === 'undefined' ? body.innerText : body.textContent;
        text = text.replace(/\s+/g, ' ');
        return text.length;
    },

    insertAndSelectText: function insertAndSelectText(text) {
        var range = this.tinymce.selection.getRng(true);

        var text_node = this.tinymce.getDoc().createTextNode(text);

        range.insertNode(text_node);
        range.selectNode(text_node);

        this.setSelectionRange(range);
    },

    writeBack: function writeBack() {
        if (this.isIMEComposing) {
            // Modern UIのIE11においてIMEの変換中にTinyMCE内でDOMを操作すると変換が即座に確定される
            // このためModern UIのIE11でTinyMCE.Editor.save()をIMEの変換中に呼び出してはいけない
            // TinyMCEはIE11がiframe内の末尾にbrを挿入する問題を解消するためgetContentするときにDOMを操作する
            // 参考: https://github.com/tinymce/tinymce/commit/f9e8f02ed9c1122c5bf03c985e267dcaf16155dd
            return;
        }
        if (this.tinymce) this.tinymce.save();
    },

    isCollapsed: function isCollapsed() {
        return this.tinymce.selection.isCollapsed();
    },
    getSelectionText: function getSelectionText() {
        return this.tinymce.selection.getContent();
    },
    // 選択範囲を指定したurlへのリンクにする
    // TODO: IEで動く？
    createLink: function createLink(url) {
        this.tinymce.execCommand("CreateLink", false, url);
    },
    formatBlock: function formatBlock(tagName) {
        // IEでは行全体を選択していないとFormatBlockが動かなかった
        // なので，現在カーソルのある行のnodeをselectしてからFormatBlockしている
        // ただし，カーソルがbodyにあるときselectするとエディタ全体が選択されるので，body以外を選択してるときだけselectする
        var currentNode = this.tinymce.selection.getNode();
        if (currentNode.tagName.toLowerCase() !== "body") {
            this.tinymce.selection.select(currentNode);
        }

        // FormatBlockは2回実行するとトグルする
        // ドロップダウンのUIでトグルするのは変なので，まずpにしてから，目的のタグに変換している

        if (tagName !== "p") {
            this.execCommand('FormatBlock', 'p');
        }

        this.execCommand('FormatBlock', tagName);
    },

    replace: function replace(text) {
        this.tinymce.selection.setContent(text);
    },

    moveCaretToNodeEnd: function moveCaretToNodeEnd(node) {
        this.tinymce.selection.select(node);
        this.tinymce.selection.collapse(false);
    },

    // blockquoteを挿入し, 更にその下に空の<p>タグを挿入した後
    // blockquoteを選択した状態にする
    insertBlockQuoteWithNewLine: function insertBlockQuoteWithNewLine() {
        if (this.tinymce.selection.isCollapsed()) {
            this.insert('<blockquote><p>&nbsp;</p></blockquote><p>&nbsp;</p>');

            var node_in_blockquote = $(this.tinymce.selection.getNode()).prev('blockquote').find('p')[0];

            this.tinymce.selection.setCursorLocation(node_in_blockquote, 0);
        } else {
            this.insert('<blockquote><p>' + this.tinymce.selection.getContent() + '</p></blockquote><p>&nbsp;</p>');

            var blockquote_node = $(this.tinymce.selection.getNode()).prev('blockquote')[0];

            this.tinymce.selection.select(blockquote_node);
        }
    },

    formatBlockQuote: function formatBlockQuote() {
        // IEでは選択しないとblockquoteできない
        if (Browser.isIE && this.tinymce.selection.isCollapsed()) {
            var current_node = this.tinymce.selection.getNode();
            this.tinymce.selection.select(current_node);
        }

        this.execCommand('mceBlockQuote');
    },

    // 画像がドロップされた瞬間だけtrueにする
    justImageHasDropped: false,

    // 画像の貼り付けイベントから，fotolifeに画像をアップロードする
    // TinyMCEから直接Blobを取れないので，Data URLをパースしてBlobやFileを作る
    // http://stackoverflow.com/questions/4998908/convert-data-uri-to-file-then-append-to-formdata/5100158#5100158
    handleImagePasteEvent: function handleImagePasteEvent(event) {
        // ちょうど画像がドロップされたときは無視する
        // TinyMCE的にはファイルのドロップとクリップボードからのペーストを同列に扱っているが，ブログ側では別に実装している
        if (this.justImageHasDropped) {
            event.preventDefault();
            event.stopPropagation();

            return;
        }

        var content = event.content.replace(/^[\s]*/, '').replace(/[\s]*$/, '');

        var img = content.match(/^<img src="data:(.+);base64,(.*)">$/);
        if (!img) return;

        var contentType = img[1];
        var byteString = window.atob(img[2]);

        var bytesArray = new Uint8Array(byteString.length);
        for (var i = 0; i < byteString.length; i++) {
            bytesArray[i] = byteString.charCodeAt(i);
        }

        var blob = new Blob([bytesArray], { type: contentType });
        var ext = contentType.split(/\//)[1];
        var file = new File([blob], 'a.' + ext);

        Hatena.Diary.EditorComponent.EditorSidebar.openByType('editor-fotolife');
        $(document).trigger('uploadDroppedFiles', [[file]]);

        event.preventDefault();
        event.stopPropagation();
    },

    actions: {

        defaultParagraph: function defaultParagraph() {
            this.formatBlock('p');
        },

        largeHeading: function largeHeading() {
            this.formatBlock('h3');
        },

        middleHeading: function middleHeading() {
            this.formatBlock('h4');
        },

        smallHeading: function smallHeading() {
            this.formatBlock('h5');
        },

        bold: function bold() {
            // http://www.tinymce.com/wiki.php/Command_identifiers
            this.execCommand('Bold');
        },

        italic: function italic() {
            this.execCommand('Italic');
        },

        strike: function strike() {
            this.execCommand('StrikeThrough');
        },

        underline: function underline() {
            this.execCommand('Underline');
        },

        removeFormat: function removeFormat() {
            this.execCommand("removeFormat");
            this.execCommand("unlink");
        },

        veryLargeFontSize: function veryLargeFontSize() {
            this.execCommand('FontSize', '200%');
        },

        largeFontSize: function largeFontSize() {
            this.execCommand('FontSize', '150%');
        },

        defaultFontSize: function defaultFontSize() {
            this.execCommand("RemoveFormat", 'FontSize');
        },

        smallFontSize: function smallFontSize() {
            this.execCommand('FontSize', '80%');
        },

        unorderedList: function unorderedList() {
            this.execCommand("InsertUnorderedList");
        },

        orderedList: function orderedList() {
            this.execCommand("InsertOrderedList");
        },

        color: function color() {}, // noop

        pickColor: function pickColor(color) {
            var self = this;

            var rng = this.tinymce.selection.getRng();
            var mark;
            if (Browser.isIE) {
                this.tinymce.focus();
                mark = this.tinymce.selection.getBookmark(1);
                self.tinymce.selection.setRng(rng);
            }

            if (color) {
                self.execCommand("ForeColor", color);
            } else {
                // 選択範囲が空だとtinyMCEがエラー出すので握りつぶす
                try {
                    self.execCommand("RemoveFormat");
                } catch (e) {}
            }

            if (mark) {
                self.tinymce.selection.moveToBookmark(mark);
            }
        },

        link: function link() {
            $(document).trigger('show-embed-box');
        },

        insertSeeMore: function insertSeeMore() {
            this.insertLines(["<!-- more -->", ""]);
        },

        blockquote: function blockquote() {
            if (Browser.isIE) {
                this.tinymce.focus();
            }

            var current_node = this.tinymce.selection.getNode();
            var $current_node = $(current_node);
            var selection_is_in_blockquote = $current_node.closest('blockquote').length !== 0;
            var current_node_is_last_node = $current_node.next().length === 0;
            var current_node_is_empty = $current_node.text().length === 0;

            // [IE対策] bodyタグが選択されてるとき, 入力欄が空だとみなして改行とともにblockquoteを挿入する
            // ただし, 選択範囲がある場合はふつうにformatBlockする
            if (Browser.isIE && current_node.tagName.toLowerCase() === 'body') {
                if (this.tinymce.selection.isCollapsed()) {
                    this.insertBlockQuoteWithNewLine();
                } else {
                    this.formatBlockQuote();
                }
                return;
            }

            if (!current_node_is_last_node || selection_is_in_blockquote) {
                this.formatBlockQuote();
                return;
            }

            // 入力内容末尾でformatBlockすると, blockquote内から抜け出ることができないのでblockquoteの下に改行を挿入する
            if (!this.tinymce.selection.isCollapsed() || current_node_is_empty) {
                this.insertBlockQuoteWithNewLine();
            } else {
                this.moveCaretToNodeEnd(current_node);

                this.insert('<p>&nbsp;</p>');

                var prev_node = $(this.tinymce.selection.getNode()).prev()[0];
                this.tinymce.selection.select(prev_node);

                this.formatBlockQuote();
            }
        },

        footnote: function footnote() {
            var selection_text = this.tinymce.selection.getContent();
            if (selection_text.length) {
                this.replace('((' + selection_text + '))');
            } else {
                this.insert('((');
                var mark = this.tinymce.selection.getBookmark();
                this.insert('))');
                this.tinymce.selection.moveToBookmark(mark);

                this.insertAndSelectText(Locale.text('edit_form.footnote_message'));
            }
        }
    }
};

module.exports = HTMLEditor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Browser":31,"../Base/Logger":44,"../Base/URLGenerator":48,"../Locale":151,"../keyString":184,"./Uploader":150,"underscore":4}],145:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

var Locale = require('../Locale');
var Browser = require('../Base/Browser');
var EventTracker = require('../Base/EventTracker');
var LOG = require('../Base/Logger');

var Uploader = require('./Uploader');
var RealtimePreview = require('./RealtimePreview');

/* Hatena Syntax
 *  記法編集と、プレビューのタブ切替え
 *  プレビュー（新規window) アイコン切替え
 */
var HatenaEditor = {

    // プレビューの処理
    // markdownではhatena記法を継承しているので、これと同様のものが利用される

    initEditor: function initEditor() {
        var self = this;
        self.body.attr('style', 'position: absolute; height: 100%; width: 100%; padding: 0; margin: 0');
        self.body.appendTo(self.editarea);

        self.currentTab = 'textarea'; // 'textarea' | 'preview';
        self.tabs.on('tabsactivate', function (event, ui) {
            var panelID = ui.newPanel.attr('id');
            self.currentTab = panelID;
            if (/preview/.test(panelID) && !self.preview.isOpeningNewWindow()) {
                // previewInIframe により iframe のサイズが変わるため、
                // setHeight の前に呼ぶ
                self.preview.previewInIframe();
                self.disableSyntaxSwitcher();
            } else {
                // setHeight前のtextareaにfocusすると表示が崩れるため
                // focus は setHeight の後に呼ぶ
                setTimeout(function () {
                    self.focus();
                }, 0);
                self.enableSyntaxSwitcher();
            }
            self.setHeight();
        });

        self.bind('actionafter', function () {
            self.focus();
        });

        self.initRealtimePreview();

        self.body.on('paste', function (event) {

            // 画像がペーストされたらfotolifeにアップロードする
            try {
                var success = self.handleImagePasteEvent(event);
                if (success) return false;
            } catch (error) {
                LOG.BUG(error, 'upload pasted image filed(hatena or markdown)');
            }

            // URLが貼り付けされたら貼り付けボックス開く
            // IE以外ではイベントから取得，IEではwindowから取得する
            var originalEvent = event.originalEvent;
            var content = (originalEvent.clipboardData ? originalEvent.clipboardData.getData('text/plain') : window.clipboardData.getData("text")).replace(/^[\s]*/, '').replace(/[\s]*$/, '');
            if (content.match(self.URLPattern) && !self.onInsertingLink()) {
                var url = content;
                $(self).triggerHandler('paste-url', [url]);
                return false;
            }
        });

        self.initDropper();
    },

    // 画像がペーストされたらfotolifeにアップロードする
    // fotolifeはファイル名からファイル形式を決めるので，blob.typeをもとに新たなFileにwrapして，ファイル形式が判別できるファイル名を指定している
    // アップロードできたらtrueを返す
    handleImagePasteEvent: function handleImagePasteEvent(event) {
        var data = event.clipboardData || event.originalEvent.clipboardData;
        if (!data) return;

        // テキストと画像の両方があるとき(表計算ソフトなど)はテキストで貼る
        var textContent = data.getData('text/plain');
        if (textContent) return;

        var items = data.items;
        var files = [];
        for (var i in items) {
            var item = items[i];
            if (item.kind === 'file') {
                var blob = item.getAsFile();
                var ext = blob.type.split(/\//)[1];
                var file = new File([blob], 'a.' + ext);
                files.push(file);
            }
        }

        if (files.length > 0) {
            Hatena.Diary.EditorComponent.EditorSidebar.openByType('editor-fotolife');
            $(document).trigger('uploadDroppedFiles', [files]);
            return true;
        }
    },

    setHeight: function setHeight() {
        this.currentTab = this.currentTab || 'textarea';

        var withoutButtons = $(window).height() - this.$buttons.outerHeight();
        var tabTop = $('#' + this.currentTab).offset().top;

        this.editarea.height(withoutButtons - this.editarea.offset().top);
        this.$preview.height(withoutButtons - tabTop - 2); // subtract border width
    },

    focus: function focus() {
        this.body.focus();
    },

    isFocused: function isFocused() {
        return this.body.is(':focus');
    },

    setValue: function setValue(val) {
        this.body.val(val);
    },

    getSelectionRange: function getSelectionRange() {
        var textarea = this.body[0];

        // Operaでtextareaの入力内容が空のとき selectionStart, selectionEndの値がおかしいバグがある
        // (placeholderが入力されてるとみなされる???)
        // そのため, textareaが空のときは決め打ちで範囲を返す
        // 不具合が直ったらこの部分は消していい
        if (Browser.isOpera && !textarea.value) {
            return {
                start: 0,
                end: 0
            };
        }

        if ('selectionStart' in textarea) {
            return {
                start: textarea.selectionStart,
                end: textarea.selectionEnd
            };
        } else if (document.selection) {
            var range = document.selection.createRange();
            var clone = range.duplicate();
            clone.moveToElementText(textarea);
            clone.setEndPoint('EndToEnd', range);
            var range_length = range.text.replace(/\x0d/g, '').length;
            var start = clone.text.replace(/\x0d/g, '').length - range_length;
            return {
                start: start,
                end: start + range_length
            };
        }
    },

    setSelectionRange: function setSelectionRange(range) {
        var textarea = this.body[0];
        if (textarea.setSelectionRange) {
            textarea.setSelectionRange(range.start, range.end);
        } else if (textarea.createTextRange) {
            var rng = textarea.createTextRange();
            rng.collapse(true);
            rng.moveStart('character', range.start);
            rng.moveEnd('character', range.end - range.start);
            rng.select();
        }
    },

    getSelectionText: function getSelectionText(range) {
        range = range || this.getSelectionRange();
        return this.body.val().substring(range.start, range.end);
    },
    isCollapsed: function isCollapsed() {
        var range = this.getSelectionRange();
        return range.start === range.end;
    },
    getCharacterAtCursor: function getCharacterAtCursor(lines) {
        var range = this.getSelectionRange();

        return this.body.val()[range.start - 1];
    },
    // リンクを挿入中と思われるか
    // 直前の文字が[のとき，[$url:title]とか打とうとしている可能性がある
    // 直前の文字が>のとき，引用記法の可能性がある
    // 直前の文字が"のとき，HTML入力中の可能性がある
    onInsertingLink: function onInsertingLink() {
        return _.include(['[', '>', '"'], this.getCharacterAtCursor());
    },
    // 選択範囲を指定したurlへのリンクにする
    createLink: function createLink(url) {
        var range = this.getSelectionRange();
        var text = this.getSelectionText();

        var syntax;
        // 複数行なら，はてな記法では表現できないので，aタグに入れる
        // 1行なら，はてな記法
        if (text.match(/\n/)) {
            syntax = '<a href="' + url + '">' + text + '</a>';
        } else {
            syntax = '[' + url + ':title=' + text + ']';
        }

        var newRange = this.replace(syntax, range);
        this.setSelectionRange(newRange);
    },

    replace: function replace(text, range) {
        range = range || this.getSelectionRange();
        var textarea = this.body[0];
        var content = textarea.value;
        var t = textarea.scrollTop,
            l = textarea.scrollLeft;
        this.body.val(this.body.val().substring(0, range.start) + text + this.body.val().substring(range.end));
        textarea.scrollTop = t;textarea.scrollLeft = l;

        this.body.trigger("input");
        return { start: range.start, end: range.start + text.length };
    },

    insert: function insert(text) {
        var range = this.getSelectionRange();
        var textarea = this.body[0];
        var content = textarea.value;
        var t = textarea.scrollTop,
            l = textarea.scrollLeft;
        textarea.value = content.substring(0, range.end) + text + content.substring(range.end);
        textarea.scrollTop = t;textarea.scrollLeft = l;

        this.setSelectionRange({ start: range.end + text.length, end: range.end + text.length });
        this.body.trigger("input");
        return { start: range.end, end: range.end + text.length };
    },

    insertLines: function insertLines(lines) {
        var range = this.getSelectionRange();

        var lastChar = this.body.val()[range.start - 1];
        var prefix = '';
        if (lastChar === "\n" || lastChar === undefined) {
            // do nothing
        } else {
                prefix = "\n";
            }
        this.insert(prefix + lines.join("\n") + "\n");
    },

    modifyCurrentLine: function modifyCurrentLine(callback) {
        var range = this.getSelectionRange();
        var lines = this.body.val().split(/\r?\n/);

        var currentIndex = 0;
        var lastIndex = lines.length;
        var total = 0;
        while (lastIndex > currentIndex) {
            // 改行の分、+1 する
            total += lines[currentIndex].length + 1;
            if (total > range.start) break;
            currentIndex++;
        }

        var modifiedLine = callback(lines[currentIndex]);
        var lineHeadPosition = total - lines[currentIndex].length;
        var diff = modifiedLine.length - lines[currentIndex].length;
        lines[currentIndex] = modifiedLine;

        // 範囲選択していたときにカーソルが前の行にいかないように
        var modifiedRange = {
            start: Math.max(lineHeadPosition, range.start + diff),
            end: Math.max(lineHeadPosition, range.end + diff)
        };

        this.body.val(lines.join("\n"));
        this.setSelectionRange(modifiedRange);
    },

    wrapString: function wrapString(start, end) {
        var text = this.getSelectionText();
        var range;
        if (text.indexOf(start) === 0) {
            text = text.replace(start, '').replace(end, '');
            range = this.replace(text);
        } else {
            range = this.replace(start + text + end);
        }
        this.setSelectionRange(range);
        return range;
    },

    // 選択範囲が存在しないとき, 挿入後startとendの間にキャレットを置く
    // 選択範囲が存在する場合はwrapStringと同じ
    wrapStringAround: function wrapStringAround(start, end) {
        var selection_text = this.getSelectionText();

        this.wrapString(start, end);

        if (selection_text.length === 0) {
            this.moveCaret(start.length);
        }
    },

    // 選択範囲が存在しないとき, startとendの間でラベルを選択している状態にする
    // 選択範囲が存在する場合はwrapStringと同じ
    //
    // example:
    //  wrapStringAroundLabel('((', 'ここが選択される', '))')
    //=> "((ここが選択される))"
    //　    ￣￣￣￣￣￣￣￣
    wrapStringAroundLabel: function wrapStringAroundLabel(start, label, end) {
        var self = this;
        var selection_text = this.getSelectionText();

        this.wrapStringAround(start, end);

        if (selection_text.length === 0) {
            var range = this.replace(label);
            this.setSelectionRange(range);
        }
    },

    headingAction: function headingAction(replaceString) {
        this.modifyCurrentLine(function (line) {
            return line.replace(/^[*]*(\s+)*/, replaceString);
        });
    },

    moveCaret: function moveCaret(length) {
        var range = this.getSelectionRange();
        range.start += length;
        range.end = range.start;

        this.setSelectionRange(range);
    },

    toggleFontSize: function toggleFontSize(value) {
        var text = this.getSelectionText();
        var range;
        if (/^(<span style="font-size: (\d+)%">)/.test(text)) {
            var current_value = Math.floor(+RegExp.$2);
            if (current_value === value) {
                text = text.replace(RegExp.$1, '').replace(/<\/span>/, '');
            } else {
                text = text.replace(RegExp.$1, '<span style="font-size: ' + value + '%">');
            }
            range = this.replace(text);
        } else {
            range = this.replace('<span style="font-size: ' + value + '%">' + text + '</span>');
        }
        this.setSelectionRange(range);
    },

    removeFontSize: function removeFontSize() {
        var text = this.getSelectionText();
        var range;
        if (/^(<span style="font-size: \d+%">)/.test(text)) {
            text = text.replace(RegExp.$1, '').replace(/<\/span>/, '');

            range = this.replace(text);

            this.setSelectionRange(range);
        }
    },

    actions: {
        defaultParagraph: function defaultParagraph() {
            this.headingAction('');
        },

        largeHeading: function largeHeading() {
            this.headingAction('* ');
        },

        middleHeading: function middleHeading() {
            this.headingAction('** ');
        },

        smallHeading: function smallHeading() {
            this.headingAction('*** ');
        },

        italic: function italic() {
            this.wrapString('<i>', '</i>');
        },

        bold: function bold() {
            this.wrapString('<b>', '</b>');
        },

        underline: function underline() {
            this.wrapString('<u>', '</u>');
        },

        strike: function strike() {
            this.wrapString('<s>', '</s>');
        },

        veryLargeFontSize: function veryLargeFontSize() {
            this.toggleFontSize(200);
        },

        largeFontSize: function largeFontSize() {
            this.toggleFontSize(150);
        },

        defaultFontSize: function defaultFontSize() {
            this.removeFontSize();
        },

        smallFontSize: function smallFontSize() {
            this.toggleFontSize(80);
        },

        unorderedList: function unorderedList() {
            var text = this.getSelectionText();
            var range = this.replace("\n- " + text);
            range.start = range.end;
            this.setSelectionRange(range);
        },

        orderedList: function orderedList() {
            var text = this.getSelectionText();
            var range = this.replace("\n+ " + text);
            range.start = range.end;
            this.setSelectionRange(range);
        },

        color: function color() {}, // noop

        /**
         * カラーピッカーから色の指定を受け取る
         * @param {string} color - '#xxxxxx' 形式のカラーコード
         */
        pickColor: function pickColor(color) {
            var self = this;
            var range = self.getSelectionRange();
            var text = self.getSelectionText(range);

            if (/(<span style="color: [^;]+?">)/.test(text)) {
                if (color) {
                    text = text.replace(RegExp.$1, '<span style="color: ' + color + '">');
                } else {
                    text = text.replace(RegExp.$1, '').replace(/<\/span>/, '');
                }
                range = self.replace(text, range);
            } else {
                if (color) {
                    range = self.replace('<span style="color: ' + color + '">' + text + '</span>', range);
                }
            }
            self.setSelectionRange(range);
        },

        link: function link() {
            $(document).trigger('show-embed-box');
        },

        insertSeeMore: function insertSeeMore() {
            this.insertLines(['====', '']);
        },

        blockquote: function blockquote() {
            this.wrapStringAround('>>\n', '\n<<');
        },

        footnote: function footnote() {
            this.wrapStringAroundLabel('((', Locale.text('edit_form.footnote_message'), '))');
        }

    },

    initRealtimePreview: function initRealtimePreview() {
        var self = this;

        self.$rp = self.form.find('#realtime-preview');
        self.$rp_button = self.form.find('#realtime-preview-button');
        self.$rp_placeholder = self.form.find('#realtime-preview-placeholder');
        self.editarea.append(self.$rp).append(self.$rp_button).append(self.$rp_placeholder);

        self.realtime_preview = new RealtimePreview(self.$rp, self);

        self.$rp_button.click(function () {
            if (self.$rp.is(":visible")) {
                EventTracker.trackEvent('RealtimePreview.off');
                self.editarea.removeClass("realtime-preview");
                self.realtime_preview.hide();
            } else {
                EventTracker.trackEvent('RealtimePreview.on');
                self.editarea.addClass("realtime-preview");
                self.realtime_preview.show();
            }
        });
    },

    initDropper: function initDropper() {
        if (Browser.isIE && !Browser.isIE11) {
            return;
        }

        var self = this;
        var isFile = function isFile(e) {
            return e.dataTransfer.files.length > 0;
        };
        var onDrop = function onDrop(e) {
            console.log('drop');
            if (isFile(e)) {
                // Fileの場合、fotolife サイドバーを出してアップロード
                Hatena.Diary.EditorComponent.EditorSidebar.openByType('editor-fotolife');
                Uploader.uploadDroppedFiles(e);
            } else {
                // テキストがURLなら貼り付けボックスだす
                var content = e.dataTransfer.getData('Text').trim();
                if (content.match(self.URLPattern)) {
                    $(self).triggerHandler('paste-url', [content]);
                }
            }
        };

        // editarea内のテキストボックス
        self.editorTextbox = self.editarea.find('#body').eq(0);

        var isDragging = false;
        var isDraggingInner = false;
        var cancelEvent = function cancelEvent(e) {
            e.stopPropagation();
            e.preventDefault();
        };
        this.editarea.on('dragstart', function () {
            isDraggingInner = true;
        }).on('dragend', function () {
            isDraggingInner = false;
        }).on('dragenter', function () {
            if (isDraggingInner) {
                return;
            }
            isDragging = true;
            self.editareaHover.addClass('dragging');
        }).on('dragleave', function () {
            if (isDraggingInner) {
                return;
            }
            isDragging = false;
            self.editareaHover.removeClass('dragging');
        }).on('dragover', function (_e) {
            if (isDraggingInner) {
                return;
            }
            self.editareaHover.addClass('dragging');
            cancelEvent(_e.originalEvent);
        }).on('drop', function (_e) {
            if (isDraggingInner) {
                return;
            }
            isDragging = false;
            self.editareaHover.removeClass('dragging');

            var e = _e.originalEvent;
            cancelEvent(e);
            onDrop(e);
        });
    }
};

module.exports = HatenaEditor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Browser":31,"../Base/EventTracker":37,"../Base/Logger":44,"../Locale":151,"./RealtimePreview":148,"./Uploader":150,"underscore":4}],146:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

var HatenaEditor = require('./HatenaEditor');

/* Markdown
 *  記法編集と、プレビューのタブ切替え
 */

var MarkdownEditor = $.extend(true, {}, HatenaEditor, {
    insertLines: function insertLines(lines) {
        var range = this.getSelectionRange();

        var lastChars = this.body.val().substr(range.start - 2, range.start);
        var prefix = '';
        if (lastChars === "\n\n" || lastChars === "") {
            // do nothing
        } else if (lastChars.match(/\n$/)) {
                prefix = "\n";
            } else {
                prefix = "\n\n";
            }
        this.insert((prefix + lines.join("\n\n") + "\n\n").replace(/\n+$/, "\n\n"));
    },

    headingAction: function headingAction(replaceString) {
        this.modifyCurrentLine(function (line) {
            return line.replace(/^[#]*(\s+)*/, replaceString);
        });
    },
    // 選択範囲を指定したurlへのリンクにする
    createLink: function createLink(url) {
        var range = this.getSelectionRange();
        var text = this.getSelectionText();

        var syntax;
        // 複数行なら，Markdownでは表現できないので，aタグに入れる
        // 1行なら，Markdown
        if (text.match(/\n/)) {
            syntax = '<a href="' + url + '">' + text + '</a>';
        } else {
            syntax = '[' + text + '](' + url + ')';
        }

        var newRange = this.replace(syntax, range);
        this.setSelectionRange(newRange);
    },
    // リンクを挿入中と思われるか
    // 直前の文字が(のとき，[$title]($url)とか打とうとしている可能性がある
    // 直前の文字が[のとき，[$url:title]とか打とうとしている可能性がある
    // 直前の文字が"のとき，HTML入力中の可能性がある
    onInsertingLink: function onInsertingLink() {
        return _.include(['(', '[', '"'], this.getCharacterAtCursor());
    },

    // ↓はてな記法モードと挙動が違うものだけここに記述する
    actions: {
        largeHeading: function largeHeading() {
            this.headingAction('### ');
        },

        middleHeading: function middleHeading() {
            this.headingAction('#### ');
        },

        smallHeading: function smallHeading() {
            this.headingAction('##### ');
        },

        unorderedList: function unorderedList() {
            var text = this.getSelectionText();
            var range = this.replace("\n* " + text);
            range.start = range.end;
            this.setSelectionRange(range);
        },

        orderedList: function orderedList() {
            var text = this.getSelectionText();
            var range = this.replace("\n1. " + text);
            range.start = range.end;
            this.setSelectionRange(range);
        },

        color: function color() {}, // noop

        /**
         * カラーピッカーから色の指定を受け取る
         * @param {string} color - '#xxxxxx' 形式のカラーコード
         */
        pickColor: function pickColor(color) {
            var self = this;

            var range = self.getSelectionRange();
            var text = self.getSelectionText(range);

            if (/(<span style="color: [^;]+?">)/.test(text)) {
                if (color) {
                    text = text.replace(RegExp.$1, '<span style="color: ' + color + '">');
                } else {
                    text = text.replace(RegExp.$1, '').replace(/<\/span>/, '');
                }
                range = self.replace(text, range);
            } else {
                if (color) {
                    range = self.replace('<span style="color: ' + color + '">' + text + '</span>', range);
                }
            }
            self.setSelectionRange(range);
        },

        link: function link() {
            $(document).trigger('show-embed-box');
        },

        insertSeeMore: function insertSeeMore() {
            this.insertLines(['<!-- more -->', '']);
        },

        blockquote: function blockquote() {
            var selection_text = this.getSelectionText();

            if (selection_text.length === 0) {
                this.insert('\n> ');
                return;
            }

            var range;

            // 選択範囲が引用文の場合, 引用を解除する
            if (/^(> .*\r?\n)+(> .*)?$/.test(selection_text)) {
                var unquoted_text = selection_text.replace(/^> (.*)/mg, "$1");
                range = this.replace(unquoted_text);
            } else {
                // 選択範囲最後の改行を取り除いてるのは, 最後の行に余計な"> " がつかないようにするため
                var quoted_text = selection_text.replace(/\r?\n$/g, '').replace(/^(.*)/mg, "> $1");
                range = this.replace(quoted_text);
            }

            this.setSelectionRange(range);
        }
    }
});

module.exports = MarkdownEditor;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./HatenaEditor":145,"underscore":4}],147:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../Messenger');
var globalData = require('../Base/globalData');
var waitForResource = require('../Util/waitForResource');
var positionToString = require('../Util/positionToString');

// プレビュータブの処理
// 新窓プレビュー, Iframeプレビューの切り替え, ボタンのtoggleを行う
var Preview = function Preview() {
    this.init.apply(this, arguments);
};
Preview.prototype = {
    init: function init(editor) {
        var self = this;
        self.editor = editor;

        $('.js-dropdown-preview-in-new-window, .js-icon-preview-in-new-window-reload').on('click', function () {
            self.previewInNewWindow();
        });

        // iframeを閉じるとき新窓プレビューも閉じる
        var messenger = Messenger.createForParent();
        messenger.addEventListener("close-preview-window", function () {
            editor.preview.closePreviewNewWindow();
        });

        // pageLeaveEventが生じたとき新窓プレビュー閉じる
        $(window).on('close-preview-window', function () {
            editor.preview.closePreviewNewWindow();
        });
    },

    // Blogs::Preview#preview から返ってきたHTMLをtargetに表示する
    appendPreviewHTML: function appendPreviewHTML(target) {
        var self = this;
        var editor = self.editor;

        var title = editor.title.val();
        var body = editor.body.val();
        var datetime = editor.datetime.val();
        var syntax = $('#syntax').val();
        var id = editor.id;
        var categoryArray = editor.getCategoriesAsParamsArray();
        var categories = editor.getCategories();

        $.ajax({
            url: './preview',
            type: "post",
            dataType: 'json',
            data: [{ name: 'title', value: title }, { name: 'body', value: body }, { name: 'datetime', value: datetime }, { name: 'rkm', value: globalData('rkm') }, { name: 'rkc', value: globalData('rkc') }].concat(categoryArray),
            success: function success(res) {
                var form = $('<form method="POST" target=' + target + '></form>').attr('action', res.uri);
                $('<textarea/>').attr('name', 'title').val(title).appendTo(form);
                $('<textarea/>').attr('name', 'body').val(body).appendTo(form);
                $('<textarea/>').attr('name', 'syntax').val(syntax).appendTo(form);
                $('<textarea/>').attr('name', 'datetime').val(datetime).appendTo(form);
                $('<textarea/>').attr('name', 'datetime_tz').val(res.datetime_tz).appendTo(form);
                $('<textarea/>').attr('name', 'signature').val(res.signature).appendTo(form);
                $('<textarea/>').attr('name', 'editor_id').val(id).appendTo(form);
                categories.each(function () {
                    $('<textarea/>').attr('name', 'category').val(this).appendTo(form);
                });
                form.appendTo(document.body);
                form.submit();
                form.remove();
            }
        });
    },

    previewInNewWindow: function previewInNewWindow() {
        var self = this;

        // 新規windowでプレビューしていない時, 新しいwindowを用意
        if (!self.isOpeningNewWindow()) {
            var position = {
                width: screen.width / 2,
                height: screen.height,
                top: 0,
                left: screen.width / 2
            };

            var options = 'scrollbars=1,' + positionToString(position);
            self.previewNewWindow = window.open('', 'hatena-preview-new-window', options);
            // windowがcloseされたらiframeにプレビューを表示する
            waitForResource(function () {
                return self.previewNewWindow.closed;
            }, function () {
                self.swapPreviewIframe();
            });

            $('#js-new-window-close-btn').on('click', function () {
                self.previewNewWindow.close();
            });

            self.swapPreviewIframe();
        }

        self.appendPreviewHTML('hatena-preview-new-window');
        self.previewNewWindow.focus();
    },

    previewInIframe: function previewInIframe() {
        var self = this;

        self.appendPreviewHTML('hatena-preview-iframe');
    },

    closePreviewNewWindow: function closePreviewNewWindow() {
        var self = this;

        if (self.isOpeningNewWindow()) {
            self.previewNewWindow.close();
        }
    },

    togglePreviewIcon: function togglePreviewIcon() {
        var self = this;

        var $dropdownItem = $('.js-dropdown-preview-in-new-window');
        var $previewIcon = $('.js-icon-preview-in-new-window');
        var $reloadIcon = $('.js-icon-preview-in-new-window-reload');

        if (self.isOpeningNewWindow()) {
            $dropdownItem.css('display', 'none');
            $previewIcon.css('display', 'none');
            $reloadIcon.css('display', '');
        } else {
            $dropdownItem.css('display', '');
            $previewIcon.css('display', '');
            $reloadIcon.css('display', 'none');
        }
    },

    isOpeningNewWindow: function isOpeningNewWindow() {
        var self = this;
        if (self.previewNewWindow && !self.previewNewWindow.closed) return true;
        return false;
    },

    // iframeの表示を切り替える
    swapPreviewIframe: function swapPreviewIframe() {
        var self = this;
        if (self.isOpeningNewWindow()) {
            // 新窓でプレビューしている時は, iframeに新窓closeボタン出す
            $('iframe[name=hatena-preview-iframe]').css("display", 'none');
            $('.js-preview-placeholder').css("display", '');
        } else {
            // 新窓プレビューしていない時は, iframeにプレビュー出す
            $('.js-preview-placeholder').css('display', 'none');
            $('iframe[name=hatena-preview-iframe]').css('display', '');
            self.previewInIframe();
        }

        // アイコンをトグル
        self.togglePreviewIcon();
    }

};

module.exports = Preview;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/globalData":52,"../Messenger":152,"../Util/positionToString":173,"../Util/waitForResource":181}],148:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('../Base/globalData');

// リアルタイムプレビュー
var RealtimePreview = function RealtimePreview() {
    this.init.apply(this, arguments);
};
RealtimePreview.prototype = {
    init: function init($container, editor) {
        var self = this;
        self.$container = $container;
        self.$iframes = self.$container.find('.realtime-preview-iframe');

        self.is_visible = false;
        self.onEvent = function () {
            self._onEvent.apply(self);
        };

        self.count = 0;
        self.interval = 600;

        self.timer = setTimeout(function () {
            self.update();
        }, self.interval);
        self.editor = editor;
        self.editor.$rp_placeholder.css('z-index', '-1');
    },
    _onEvent: function _onEvent() {
        var self = this;
        clearTimeout(self.timer);
        self.timer = setTimeout(function () {
            self.update();
        }, self.interval);
    },
    show: function show() {
        this.editor.body.bind('input propertychange', this.onEvent);
        this.is_visible = true;
        this.update();
    },
    hide: function hide() {
        this.editor.body.unbind('input propertychange', this.onEvent);
        this.is_visible = false;
    },
    update: function update() {
        var self = this;

        if (!self.is_visible) return;

        var $current = $(self.$iframes[self.count % 2]);
        self.count++;
        var $next = $(self.$iframes[self.count % 2]);

        var editor = self.editor;
        var body = editor.body.val();
        var syntax = $('#syntax').val();

        $.ajax({
            url: './preview',
            type: "post",
            dataType: 'json',
            data: [{ name: 'body', value: body }, { name: 'editor_id', value: editor.id }, { name: 'rkm', value: globalData('rkm') }, { name: 'rkc', value: globalData('rkc') }],
            success: function success(res) {
                var form = $('<form method="POST" target="realtime-preview-iframe-' + self.count % 2 + '"></form>').attr('action', res.uri_realtime);

                $('<textarea/>').attr('name', 'body').val(body).appendTo(form);
                $('<textarea/>').attr('name', 'syntax').val(syntax).appendTo(form);
                $('<textarea/>').attr('name', 'signature').val(res.signature).appendTo(form);
                $('<textarea/>').attr('name', 'editor_id').val(self.editor.id).appendTo(form);

                // iframeへのsubmit時の処理を変更
                // successの外に出すとうまくいかない
                self.$iframes.unbind('load.ajaxsubmit').bind('load.ajaxsubmit', function () {
                    if (body.match(/^\s*$/)) {
                        self.editor.$rp_placeholder.css('z-index', '1');
                    } else {
                        self.editor.$rp_placeholder.css('z-index', '-1');
                    }
                    $next.css("z-index", 1);
                    $current.css("z-index", -1);
                });
                form.appendTo(document.body);
                form.submit();
                form.remove();
            }

        });
    }
};

module.exports = RealtimePreview;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/globalData":52}],149:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('../Base/globalData');

// 下書き共有機能
var ShareDraft = function ShareDraft() {
    this.init.apply(this, arguments);
};
ShareDraft.prototype = {
    init: function init(editor) {
        var self = this;
        self.editor = editor;

        self.$shareButton = $('.js-dropdown-share-draft');

        self.$shareBoxWrapper = $('.js-share-draft-box-wrapper');
        self.$shareBox = $('.js-share-draft-box');
        self.$tokenInput = self.$shareBox.find('input');
        self.$closeButton = self.$shareBox.find('.btn-close');
        self.$entryId = self.editor.form.find('input[name=entry]');
        self.$mask = self.$shareBoxWrapper.find('.mask');

        self.$shareButton.on('click', function (e) {
            self.openShareDraftWindow(e);
            return true;
        });

        self.$closeButton.on('click', function () {
            self.closeShareDraftWindow();
            return false;
        });

        self.$mask.on('click', function () {
            self.closeShareDraftWindow();
            return false;
        });
    },

    setWindowPosition: function setWindowPosition(pos) {
        this.$shareBox.css(pos);
    },

    openShareDraftWindow: function openShareDraftWindow(e) {
        var self = this;
        var editor = self.editor;

        // form内のinputの値を得る
        // categoryを複数設定するため、dataを {name: foo, value: bar} という形式の配列になっている
        var data = [];
        editor.form.find('input[name], textarea[name]').each(function () {

            // submitのvalueはボタンに表示する文字列なので無視
            if (this.type === 'submit') {
                return;
            }

            // checkboxはboolean_param
            // keyが存在するだけでtrueと判断されるため、falseの場合はdataに追加しない
            if (this.type === 'checkbox') {
                if (!this.checked) {
                    return;
                }
                data.push({
                    name: this.name,
                    value: this.checked
                });
            } else {
                data.push({
                    name: this.name,
                    value: this.value
                });
            }
        });
        data.draft = true;

        // 下書き保存
        $.ajax({
            url: './draft',
            type: "POST",
            dataType: 'json',
            data: data
        }).done(function (res) {
            self.$shareBoxWrapper.addClass('visible');

            var previewURL = globalData('blogs-uri-base') + '/draft/' + res.token;
            self.$tokenInput.val(previewURL).focus().select();

            // 下書きの記事IDを保存
            self.$entryId.val(res.entry_id);
        }).fail(function () {
            console.log('ajax error!!');
        });
    },

    closeShareDraftWindow: function closeShareDraftWindow() {
        this.$shareBoxWrapper.removeClass('visible');
    }
};

module.exports = ShareDraft;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/globalData":52}],150:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Logger = require('../Base/Logger');
var LOG = Logger.LOG;
var BUG = Logger.BUG;
var globalData = require('../Base/globalData');
var extractFotolifeSyntax = require('../Base/extractFotolifeSyntax');

/**
 * Fotolifeで対応するファイル形式かどうかを返す
 */
var isUploadableFile = function isUploadableFile(filename) {
    var uploadableImagePattern = /\.(jpg|jpeg|gif|png|bmp)$/i;
    var uploadableMoviePattern = /\.(mov|mpg|wmv|avi|flv|3gp|3g2)$/i;
    return !!filename.match(uploadableImagePattern) || !!filename.match(uploadableMoviePattern);
};

var defaultFolder = {
    fotolife: 'Hatena Blog',
    paint: 'Hatena Blog Illust'
};

/**
 * ファイルのアップロードとその進捗のハンドラを管理するクラス
 * 1ファイルにつき1インスタンス生成される
 * 以下のイベントを発行する
 * - progress  アップロードが進んだ { percent: 0〜100 }
 * - disk_full 容量がいっぱいだった
 * - success   アップロード成功した { html, syntax }
 * - error     アップロード失敗した
 */
var Uploader = function Uploader() {
    this.init.apply(this, arguments);
};
Uploader.prototype = {
    init: function init() {
        this.handlers = {};
        this.params = {};
    },

    on: function on(name, func) {
        if (!this.handlers[name]) this.handlers[name] = [];
        this.handlers[name].push(func);
    },

    emit: function emit(name, event) {
        var handlers = this.handlers[name] || [];
        for (var i = 0, len = handlers.length; i < len; i++) {
            try {
                handlers[i](event);
            } catch (e) {
                Logger.BUG('Error on emit[' + name + '] ' + e);
            }
        }
    },

    /**
     * アップロード時に追加のパラメータを指定
     * @param {Object} params - アップロード時に追加で指定したいパラメータ {size: 300} とかやるとsize=300が追加で送信される
     */
    setParams: function setParams(params) {
        this.params = params;
    },

    /**
     * ファイルのアップロード
     * @param {File} file     - アップロードするファイル
     * @param {string} folder - アップロード先のフォルダ名
     */
    upload: function upload(file, folder) {
        var self = this;
        var ret = $.Deferred();

        if (!isUploadableFile(file.name)) {
            var e = new TypeError('File not supported');
            ret.reject(e);
            self.emit('error', e);
            return;
        }

        if (folder === null || folder === undefined) {
            BUG(new Error('Uploader: invalid folder name'));
            folder = defaultFolder.fotolife;
        }

        var data = new FormData();
        data.append('rkm', globalData('rkm'));
        data.append('append', 1);
        data.append('fototitle', "");
        data.append('folder', folder);
        data.append('image', file);

        _.each(self.params, function (value, key) {
            data.append(key, value);
        });

        var xhr = new XMLHttpRequest();

        xhr.upload.addEventListener("progress", function (e) {
            var percent = e.lengthComputable ? e.loaded / e.total * 100 : NaN;
            self.emit('progress', { percent: percent });
            ret.notify(percent);
        }, false);

        xhr.addEventListener("load", function (e) {
            self.emit('progress', { percent: 100 });
            ret.notify(100);

            if (xhr.status !== 200) {
                if (xhr.status === 402) {
                    self.emit('disk_full', e);
                }
                self.emit('error', e);
                ret.reject(e);
                return;
            }

            extractFotolifeSyntax(xhr.responseText).done(function (data) {
                ret.resolve(data);
                self.emit('success', data);
            }).fail(function (e) {
                ret.reject(e);
            });
        }, false);

        xhr.addEventListener("error", function (e) {
            self.emit('error', e);
            ret.reject(e);
        }, false);

        xhr.addEventListener("abort", function (e) {
            self.emit('error', e);
            ret.reject(e);
        }, false);

        xhr.open("POST", "/f/" + globalData('name') + "/upbysmart");
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        xhr.send(data);

        return ret.promise();
    },

    uploadPaint: function uploadPaint(base64data, ext) {
        var self = this;
        var ret = $.Deferred();

        $.post("/f/" + globalData('name') + "/haiku", {
            rkm: globalData('rkm'),
            append: 1,
            fototitle: "",
            folder: defaultFolder.paint,
            image: base64data,
            ext: ext,
            model: 'hatenablog'
        }).done(function (data) {
            self.emit('progress', { percent: 100 });

            extractFotolifeSyntax(data).done(function (data) {
                ret.resolve(data);
                self.emit('success', data);
            }).fail(function (e) {
                ret.reject(e);
            });
        }).fail(function (e) {
            self.emit('error', e);
            ret.reject(e);
        });

        return ret;
    }
};

/** @static */
Uploader.uploadDroppedFiles = function (e) {
    // 画像ファイルじゃなくてもアップロード
    // エラー処理はuploaderに任せる
    var files = [].slice.call(e.dataTransfer.files);
    $(document).trigger('uploadDroppedFiles', [files]);
};

Uploader.DEFAULT_SIZE = 1024;

module.exports = Uploader;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Logger":44,"../Base/extractFotolifeSyntax":50,"../Base/globalData":52,"underscore":4}],151:[function(require,module,exports){
'use strict';

document.createElement('time'); // IE

var Locale = {
    /* --- Languages --- */

    // 現在のページを表示可能な言語一覧を取得する
    getAvailLangs: function getAvailLangs() {
        if (this._availLangs) return this._availLangs;
        var de = document.documentElement;
        var langs = de ? de.getAttribute('data-avail-langs') : '';
        if (langs) {
            langs = langs.split(/\s+/);
        } else {
            langs = [];
        }
        this._availLangs = langs;
        return langs;
    },

    // 表示言語の設定をcookieに保存する
    setAcceptLang: function setAcceptLang(newLang) {
        var cookie = new Cookie();
        cookie.set('Accept-Language', newLang, { domain: this.cookieDomain, expires: '+1y', path: '/' });
        cookie.set('_hatena_set_lang', 1, { domain: this.cookieDomain, expires: '+1d', path: '/' });
    },

    // 現在のページの表示言語を取得する
    getTextLang: function getTextLang() {
        var docEl = document.documentElement;
        if (!docEl) return 'ja';
        var lang = docEl.getAttribute('lang');
        return lang || 'ja';
    },

    loadTextData: function loadTextData() {
        var key = 'textDataLoaded' + this.textDataDirName + this.textDataFileNameStemSuffix;
        if (this[key]) return;
        this[key] = true;

        var self = this;
        var host = this.dataHost;
        var lang = this.getTextLang();
        var date = new Date();
        var url = 'http://' + host + '/js/' + this.textDataDirName + 'texts-' + lang + this.textDataFileNameStemSuffix + '.js?' + date.getFullYear() + date.getMonth() + date.getDate();

        if (typeof Ten != "undefined" && Ten.AsyncLoader) {
            Ten.AsyncLoader.loadScripts([url], function () {
                var key = 'Hatena.Locale,' + self.project + ',Text';
                Ten.AsyncLoader.registerObject(key, self);
            });
        } else {
            var script = document.createElement('script');
            script.src = url;
            document.getElementsByTagName('head')[0].appendChild(script);
        }
    },

    /**
     * msgidに対応する文言を取得する
     * @param  {String} msgid - 文言のID
     * @return {String}         msgidに対応する文言 存在しない場合はmsgidを返す
     */
    text: function text(msgid) {
        var allArgs = arguments;
        var lang = this.getTextLang();
        var project = Hatena.Locale.project;
        var entry;
        try {
            entry = Hatena[project].Locale.Data.Text[lang][msgid]; // XXX
        } catch (e) {}
        if (entry) {
            var v = entry.value;
            var args = entry.args;
            if (args) {
                var i = 0;
                return v.replace(/%s/g, function () {
                    return allArgs[parseInt(args[i++], 10)];
                });
            } else {
                return v;
            }
        } else {
            return msgid;
        }
    },

    textN: function textN(msgid, n) {
        var allArgs = arguments;
        var lang = this.getTextLang();
        n = n || 0;
        var project = Hatena.Locale.project;
        var entry;
        try {
            entry = Hatena[project].Locale.Data.Text[lang][msgid]; // XXX
        } catch (e) {}
        if (entry) {
            var qt = entry.quanttype || 'o';
            var v = entry.value;
            var args = entry.args;
            if (qt == '1_o') {
                if (n == 1) {
                    v = entry.value_1;
                    args = entry.args_1;
                }
            } else if (qt == '01_o') {
                if (n === 0 || n === 1) {
                    v = entry.value_1;
                    args = entry.args_1;
                }
            }

            if (args) {
                var i = 0;
                return v.replace(/%s/, function () {
                    return allArgs[1 + parseInt(args[i++], 10)];
                });
            } else {
                return v;
            }
        } else {
            return msgid;
        }
    },

    textFwN: function textFwN(msgid, n) {
        var lang = this.getTextLang();
        if (/^ja(?:-|$)$/.test(lang)) {
            //
        } else {
                n *= 2;
            }

        var args = [msgid, n, this.number(n)];
        for (var i = 2; i < arguments.length; i++) {
            args.push(arguments[i]);
        }

        return this.textN.apply(this, args);
    },

    // IE
    _period00: new RegExp('\\' + Number(0).toLocaleString().replace(/0/g, '') + '0+$'),

    number: function number(n) {
        return (n + 0).toLocaleString().replace(this._period00, '');
    },

    /* --- Regions --- */

    getAvailRegions: function getAvailRegions() {
        if (this._availRegions) return this._availRegions;
        var de = document.documentElement;
        var regions = de ? de.getAttribute('data-avail-regions') : '';
        if (regions) {
            regions = regions.split(/\s+/);
        } else {
            regions = [];
        }
        this._availRegions = regions;
        return regions;
    },

    getRegionCode: function getRegionCode() {
        var docEl = document.documentElement;
        if (!docEl) return 0;
        var region = docEl.getAttribute('data-region');
        return parseInt(region || 0, 10);
    },

    setRegionCode: function setRegionCode(newRegionCode) {
        var cookie = new Cookie();
        cookie.set('_hatena_region', newRegionCode, { domain: this.cookieDomain, expires: '+1y', path: '/' });
    },

    /* --- Date and Time --- */

    datetimeHTML: function datetimeHTML(dt) {
        var y = '000' + dt.getUTCFullYear();y = y.substring(y.length - 4);
        var M = '0' + (dt.getUTCMonth() + 1);M = M.substring(M.length - 2);
        var d = '0' + dt.getUTCDate();d = d.substring(d.length - 2);
        var h = '0' + dt.getUTCHours();h = h.substring(h.length - 2);
        var m = '0' + dt.getUTCMinutes();m = m.substring(m.length - 2);
        var s = '0' + dt.getUTCSeconds();s = s.substring(s.length - 2);
        var ms = '00' + dt.getUTCMilliseconds();ms = ms.substring(ms.length - 3);
        return '<time datetime="' + y + '-' + M + '-' + d + 'T' + h + ':' + m + ':' + s + '.' + ms + 'Z">' + dt.toLocaleString() + '</time>';
    },

    /* You have to add service name tags to msgids such as "minutes_n"
       in Hatena::Translator such that messages are included in
       data-??.js. */
    deltaDatetime: function deltaDatetime(dt) {
        function datetime_to_delta(date) {
            var diff = (new Date().getTime() - date.getTime()) / 1000;
            var future = diff < 0;
            if (future) diff = -diff;
            diff = Math.floor(diff / 60);
            if (diff < 60) {
                return { num: diff, unit: 'minutes_n', future: future };
            }
            diff = Math.floor(diff / 60);
            if (diff < 24) {
                return { num: diff, unit: 'hours_n', future: future };
            }
            diff = Math.floor(diff / 24);
            if (diff < 365) {
                return { num: diff, unit: 'days_n', future: future };
            }
            diff = Math.floor(diff / 365);
            return { num: diff, unit: 'years_n', future: future };
        }

        var delta = datetime_to_delta(dt);

        if (typeof delta.num != "undefined") {
            var text = this.textN(delta.unit, delta.num, delta.num);
            if (delta.future) {
                return this.text('datetime.later', text);
            } else {
                return this.text('datetime.ago', text);
            }
        } else {
            return dt.toLocaleString();
        }
    },

    updateTimestamps: function updateTimestamps(root) {
        var datetimePattern = /(\d+-\d+-\d+)T(\d+:\d+:\d+)(?:\.(\d+))?Z/;

        root = root || document;
        var targets = root.getElementsByTagName('time'); // XXX class=""
        for (var i = 0, len = targets.length; i < len; i++) {
            var time = targets[i];
            if (time._date) {
                continue;
            }

            // Check date type
            var isRelative = time.getAttribute('data-relative') !== null;
            var isLocal = time.getAttribute('data-local') !== null;
            if (!isRelative && !isLocal) {
                continue;
            }

            // Time attr -> Date object
            var datetime = time.getAttribute('datetime');
            var epoch = time.getAttribute('data-epoch');
            if (!datetime && !epoch) {
                continue;
            }

            var date;
            if (datetime && datetime.match(datetimePattern)) {
                date = new Date(datetime);
            } else if (epoch && epoch.match(/^\d+$/)) {
                date = new Date(+epoch);
            }
            if (!date) {
                continue;
            }

            // Set innerHTML
            if (isRelative) {
                try {
                    time.innerHTML = this.deltaDatetime(date);
                } catch (e) {}
            }
            if (isLocal) {
                time.innerHTML = date.toLocaleString();
            }
        }
    },

    setupTimestampUpdater: function setupTimestampUpdater() {
        if (this._timestampUpdaterEnabled) return;
        this._timestampUpdaterEnabled = true;

        this.updateTimestamps();
        setInterval(function () {
            Locale.updateTimestamps();
        }, 60 * 1000);
    },

    /* --- URLs and Navigation --- */

    reload: function reload(args) {
        var query = location.search;
        if (query) {
            args = args || {};
            var preserve = args.preserve || {};

            query = query.replace(/^\?/, '').split(/[&;]/);
            var changed = false;
            var newQuery = [];
            for (var i = 0; i < query.length; i++) {
                var qp = query[i];
                var m;
                if (m = qp.match(/^(locale.[^=]+)/)) {
                    if (preserve[m[1]]) {
                        newQuery.push(qp);
                    } else {
                        changed = true;
                    }
                } else {
                    newQuery.push(qp);
                }
            }

            if (changed) {
                location.search = '?' + newQuery.join('&');
                return;
            }
        }

        location.reload(true);
    },

    reloadIfWrongLocale: function reloadIfWrongLocale() {
        var cookie = new Cookie();

        if (/\blocale\.(?:lang|region|country)\b/.test(location.search)) {
            return;
        }

        if (cookie.get('_hatena_locale_reload')) {
            cookie.set('_hatena_locale_reload', '', { domain: this.cookieDomain, expires: '-1y', path: '/' });
            return;
        } else {
            var cookieLang = (cookie.get('Accept-Language') || '').split(/,/)[0].split(/;/)[0].replace(/[^A-Za-z0-9\-]/g, '').toLowerCase();
            var cookieRegion = cookie.get('_hatena_region');
            if (!cookieLang || cookieRegion === null || cookieRegion === '') return;
            cookieRegion = parseInt(cookieRegion, 10);

            var currentLang = this.getTextLang();
            var currentRegion = this.getRegionCode();
            if (currentLang == cookieLang && currentRegion == cookieRegion) return;

            var availLangs = this.getAvailLangs();
            var availRegions = this.getAvailRegions();
            if (availLangs.join(",").indexOf(cookieLang) == -1) return;
            if (availRegions.join(",").indexOf(cookieRegion) == -1) return;

            cookie.set('_hatena_locale_reload', 1, { domain: this.cookieDomain, path: '/' });
            location.reload(true);
            return;
        }
    },

    urlWithLangAndRegion: function urlWithLangAndRegion(url) {
        var q = [];
        if (/\?/.test(url)) {
            var u = url.split(/\?/, 2);
            var qp = u[1].split(/[&;]/);
            for (var i = 0; i < qp.length; i++) {
                if (!/^locale\.(lang|region)=/.test(qp[i])) {
                    q.push(qp[i]);
                }
            }
            url = u[0];
        }
        q.push('locale.lang=' + encodeURIComponent(this.getTextLang()));
        q.push('locale.region=' + encodeURIComponent(this.getRegionCode()));
        return url + '?' + q.join('&');
    },

    /* --- Cookie and remote data configuration --- */

    project: 'Default',
    textDataFileNameStemSuffix: '',
    textDataDirName: '',
    dataHost: location.host,
    cookieDomain: '.hatena.ne.jp'
};

if (/\.hatena\.com$/i.test(location.hostname)) {
    Locale.cookieDomain = '.hatena.com';
}

// Localeからのみ扱うCookieオブジェクト
var Cookie = function Cookie() {
    this.init.apply(this, arguments);
};
Cookie.prototype = {
    init: function init(string) {
        this.cookies = this.parse(string);
    },

    parse: function parse(string) {
        var cookies = {};

        var segments = (string || document.cookie).split(/;\s*/);
        while (segments.length) {
            try {
                var segment = segments.shift().replace(/^\s*|\s*$/g, '');
                if (!segment.match(/^([^=]*)=(.*)$/)) continue;
                var key = RegExp.$1,
                    value = RegExp.$2;
                if (value.indexOf('&') != -1) {
                    value = value.split(/&/);
                    for (var i = 0; i < value.length; i++) value[i] = decodeURIComponent(value[i]);
                } else {
                    value = decodeURIComponent(value);
                }
                key = decodeURIComponent(key);

                cookies[key] = value;
            } catch (e) {}
        }

        return cookies;
    },

    set: function set(key, value, option) {
        this.cookies[key] = value;

        if (value instanceof Array) {
            for (var i = 0; i < value.length; i++) value[i] = encodeURIComponent(value[i]);
            value = value.join('&');
        } else {
            value = encodeURIComponent(value);
        }
        var cookie = encodeURIComponent(key) + '=' + value;

        option = option || {};
        if (typeof option == 'string' || option instanceof Date) {
            // deprecated
            option = {
                expires: option
            };
        }

        if (!option.expires) {
            option.expires = this.defaultExpires;
        }
        if (/^\+?(\d+)([ymdh])$/.exec(option.expires)) {
            var count = parseInt(RegExp.$1, 10);
            var field = ({ y: 'FullYear', m: 'Month', d: 'Date', h: 'Hours' })[RegExp.$2];

            var date = new Date();
            date['set' + field](date['get' + field]() + count);
            option.expires = date;
        }

        if (option.expires) {
            if (option.expires.toUTCString) option.expires = option.expires.toUTCString();
            cookie += '; expires=' + option.expires;
        }
        if (option.domain) {
            cookie += '; domain=' + option.domain;
        }
        if (option.path) {
            cookie += '; path=' + option.path;
        } else {
            cookie += '; path=/';
        }

        return document.cookie = cookie;
    },
    get: function get(key) {
        return this.cookies[key];
    },
    has: function has(key) {
        return key in this.cookies && !(key in Object.prototype);
    },
    clear: function clear(key) {
        this.set(key, '', new Date(0));
        delete this.cookies[key];
    }
};

module.exports = Locale;

},{}],152:[function(require,module,exports){
(function (global){
'use strict';

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var keyString = require('./keyString');
var Logger = require('./Base/Logger');
var globalData = require('./Base/globalData');

var EventEmitter = require('events').EventEmitter;

/**
 * フレーム毎に1つ存在する
 * iframeの中からはcreateForParentで親frameへのMessengerを生成する
 * 親frameではcreateForFrameで各iframeへのMessengerを作ってメッセージを受け取る
 */

var Messenger = (function () {

    /**
     * @param {Object} opts.window - 対象frameのwindow
     * @param {string} opts.key    - frameの識別キー createKeyまたはwindow.nameから作成される
     */

    function Messenger(opts) {
        var _this = this;

        _classCallCheck(this, Messenger);

        this.window = opts.window;
        this.key = opts.key;

        this.eventEmitter = new EventEmitter();

        // this.receiveをpostMessageにバインド
        this.messageListener = function (e) {
            return _this.receive(e);
        };
        window.addEventListener('message', this.messageListener, false);
    }

    // Static methods

    /**
     * 現在接続しているMessengerにメッセージを送る
     * 送信先は明示されないが1つとは限らない
     * @param {string} type - イベント名
     * @param {Object} obj  - ペイロード
     */

    _createClass(Messenger, [{
        key: 'send',
        value: function send(type, obj) {
            this.window.postMessage(JSON.stringify({
                key: this.key,
                type: type,
                data: obj
            }), '*');
        }

        /**
         * postMessageのリスナ
         * keyがthis.keyと等しいとき、this.dispatchEvent()してイベントリスナを呼ぶ
         * @param {event} e
         */
    }, {
        key: 'receive',
        value: function receive(e) {
            try {
                var data = JSON.parse(e.data);
                if (data.key !== this.key) {
                    return;
                }
                this.eventEmitter.emit(data.type, data.data);
            } catch (err) {
                if (Messenger.ENABLE_DEBUG && window.console) {
                    console.log(err.name + ': ' + err.message);
                }
            }
        }
    }, {
        key: 'destroy',
        value: function destroy() {
            window.removeEventListener('message', this.messageListener, false);
        }
    }, {
        key: 'addEventListener',
        value: function addEventListener(type, listener) {
            if (!listener) {
                return;
            }
            this.eventEmitter.on(type, listener);
        }
    }, {
        key: 'removeEventListener',
        value: function removeEventListener(type, listener) {
            this.eventEmitter.removeListener(type, listener);
        }
    }, {
        key: 'dispatchEvent',
        value: function dispatchEvent() {
            var _eventEmitter;

            (_eventEmitter = this.eventEmitter).emit.apply(_eventEmitter, arguments);
        }
    }]);

    return Messenger;
})();

Messenger.SIGNATURE = 'MZ';

/**
 * ランダムな文字列を生成する
 * @static
 */
Messenger.createKey = function () {
    // 2821109907456 = 36 ** 8
    var key = Messenger.SIGNATURE + Math.floor(Math.random() * 2821109907456 + 2821109907456).toString(36).substring(1);
    return key + '@';
};

Messenger.createForParent = function () {
    var key = window.name;
    return new Messenger({
        key: key,
        window: window.opener || window.parent
    });
};

Messenger.createForFrame = function (frame, url) {
    return Messenger.createForWindow(frame.contentWindow, url);
};

Messenger.createForWindow = function (targetWindow, url) {
    var key = Messenger.createKey();

    targetWindow.name = key;
    targetWindow.location.replace(url);

    return new Messenger({
        key: key,
        window: targetWindow
    });
};

Messenger.createForCurrentWindow = function () {
    var key = window.name;
    if (key === '') {
        key = Messenger.createKey();
    }

    return new Messenger({
        key: key,
        window: window
    });
};

// window.Messengerを使ってグローバルなイベントを発行する
Messenger.messenger = null;
Messenger.send = function (type, obj) {
    Logger.LOG(['send', type, obj]);
    try {
        Messenger.messenger.send(type, obj);
    } catch (error) {
        Logger.BUG(error, 'Messenger.send(' + type + ')');
    }
};
Messenger.addEventListener = function (type, func) {
    try {
        Messenger.messenger.addEventListener(type, func);
    } catch (error) {
        Logger.BUG(error, 'Messenger.addEventListener(' + type + ')');
    }
};
Messenger.listenToParent = function () {
    Messenger.messenger = Messenger.createForParent();

    if (globalData('page') !== 'globalheader') {
        $('.close').on('click', function () {
            Messenger.send('close', { name: window.name });
            return false;
        });

        $(window).keyup(function (e) {
            if (keyString(e) === 'S-ESC') {
                Messenger.send('close', { name: window.name });
            }
        });
    }
};
Messenger.listenToFrame = function (iframe, url) {
    Messenger.messenger = Messenger.createForFrame(iframe, url);
};

module.exports = Messenger;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Base/Logger":44,"./Base/globalData":52,"./keyString":184,"events":1}],153:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Messenger = require('../Messenger');

var EventTracker = require('../Base/EventTracker');
var globalData = require('../Base/globalData');

var getSelected = require('../Util/getSelected');
var getSelectedText = require('../Util/getSelectedText');

var QUOTE_OFFSET = {
    LEFT: 60,
    MIN_LEFT: 10
};
var SELECT_STAR_SIZE = 40;

var Quote = {
    targetArticle: {
        $el: null,
        title: '',
        uri: '',
        uuid: ''
    },
    selectedText: '',

    init: function init() {
        var self = this;
        var $selectionStartArticleURI, $selectionEndArticleURI;

        // 引用ボックス本体を設定
        self.$el = $('.quote-box');

        // 選択開始位置の記事を記録する
        $(document).on('mousedown', 'body', function (e) {
            var $target = $(e.target);
            var $targetArticle = self.getClosestArticle($target);
            $selectionStartArticleURI = self.getArticleURI($targetArticle);
        });

        // 引用ボックスを出す処理
        $(document).on('mouseup', 'body', function (e) {
            var $target = $(e.target);
            var $targetArticle = self.getClosestArticle($target);
            $selectionEndArticleURI = self.getArticleURI($targetArticle);

            // スターボタンをおした時はボックスだけ隠して終了する
            // (選択範囲が解除されないように残すため)
            if ($target.closest($('.hatena-star-add-button')).length > 0) {
                e.preventDefault();
                self.hideQuoteBox();
                return;
            }

            _.defer(function () {
                var selectedText = getSelectedText();

                // 引用ボタンを押しているときは何もせずに終了する
                // ストック完了パネルのボタンを押している時も何もせずに終了する
                if ($target.closest(self.$el).length > 0) return;
                if ($target.closest($('.quote-stock-panel')).length > 0) return;

                // 複数記事をまたいでいる または 選択部分がおかしい 場合はボックスを隠して処理を終える
                if ($selectionStartArticleURI !== $selectionEndArticleURI || !self.isValidSelected($target, selectedText)) {
                    self.selectedText = '';
                    self.setTargetArticle(null);
                    self.hideQuoteBox();
                    return;
                }

                // 引用ボックスを表示
                self.selectedText = selectedText;
                self.setTargetArticle($targetArticle);
                self.showQuoteBox($targetArticle, e.pageY);
            });
        });
    },
    isValidSelected: function isValidSelected($target, selectedText) {
        var selectionIsBlank = selectedText.match(/^\s*$/);
        var isComment = $target.closest('.comment').length > 0;

        if (isComment || selectionIsBlank) return false;

        return true;
    },
    showQuoteBox: function showQuoteBox($targetArticle, y) {
        var self = this;
        var box = self.$el;

        // 位置調整
        var left = $targetArticle.offset().left - QUOTE_OFFSET.LEFT;
        left = Math.max(left, QUOTE_OFFSET.MIN_LEFT);
        box.css({ top: y, left: left });

        // 表示
        box.show();
    },
    hideQuoteBox: function hideQuoteBox() {
        var self = this;
        self.$el.hide();
    },

    // Util
    getClosestArticle: function getClosestArticle($target) {
        var $article = $target.closest('article');

        // articleタグの外側でmouseupされたときにarticleタグを特定するための処理
        // 選択箇所の祖先のarticleタグを見つける
        if ($article.length <= 0) {
            var selection = getSelected();
            if (selection.focusNode !== undefined) {
                $article = $(selection.focusNode).closest('article');
            }
        }
        return $article;
    },
    getArticleURI: function getArticleURI($article) {
        return $article.find('.entry-title .entry-title-link').attr('href');
    },
    getArticleTitle: function getArticleTitle($article) {
        return $article.find('.entry-title .entry-title-link').text();
    },
    getArticleUUID: function getArticleUUID($article) {
        return $article.attr('data-uuid');
    },
    setTargetArticle: function setTargetArticle($article) {
        var self = this;

        if ($article) {
            self.targetArticle = {
                $el: $article,
                uri: self.getArticleURI($article),
                title: self.getArticleTitle($article),
                uuid: self.getArticleUUID($article)
            };
        } else {
            self.targetArticle = {
                $el: null,
                uri: '',
                title: '',
                uuid: ''
            };
        }
    }
};

Quote.Star = {
    // methods
    init: function init() {
        if (!Hatena.Star) return;

        var self = this;
        var messageFadeoutTimer = null;

        // DOMを取得
        self.$starButton = $('.tooltip-quote-star');
        self.$starMessageBox = $('#quote-star-message-box');

        // Hatena.Starがあったら引用スターできるようにする
        self.$starButton.show();

        // スターをつけるときに引用を付加する
        Hatena.Star.AddButton.prototype.addStar = _.wrap(Hatena.Star.AddButton.prototype.addStar, function (func, e) {
            this.selectedText = Quote.selectedText.substr(0, 200);

            func.call(this, e);

            if (this.selectedText !== '') {
                EventTracker.trackEvent('hatena-star-add-quote');
            }
        });

        // スターをクリックしたらbeforeAddStarを発火するよう設定
        Hatena.Star.AddButton.prototype.setupObservers = _.wrap(Hatena.Star.AddButton.prototype.setupObservers, function (func) {
            func.call(this);

            new Ten.Observer(self.$starButton[0], 'onclick', this, 'beforeAddStar');
        });

        Hatena.Star.AddButton.prototype.beforeAddStar = function (e) {
            if (Quote.targetArticle.uuid === $(this.entry.entryNode).attr('data-uuid')) {
                this.addStar(e);
            }
        };

        // スター投稿のコールバック
        // ログイン時/非ログイン時で成功orログイン要求のパネルを出し分ける
        Hatena.Star.AddButton.prototype.receiveResult = _.wrap(Hatena.Star.AddButton.prototype.receiveResult, function (func, args) {
            // メッセージを出す位置
            var messageBoxOffset = {
                top: self.$starButton.offset().top,
                left: self.$starButton.offset().left + SELECT_STAR_SIZE
            };

            if (args.quote && self.$starButton.is(':visible')) {
                // ログインしてるときのみメッセージを出す
                if (args.isGuest) {
                    var pos = { x: messageBoxOffset.left, y: messageBoxOffset.top };

                    // HatenaStar.js本体でウィンドウ出す位置を調整されるので, その分足し引きして調整を打ち消す
                    pos.x += 10;
                    pos.y -= 25;

                    this.lastPosition = pos;
                } else {
                    self.$starMessageBox.stop().css(_.extend(messageBoxOffset, { opacity: 1.0 })).show();

                    if (messageFadeoutTimer) {
                        clearTimeout(messageFadeoutTimer);
                    }
                    messageFadeoutTimer = setTimeout(function () {
                        self.$starMessageBox.fadeOut(1000);
                    }, 1000);

                    EventTracker.trackEvent('hatena-star-add-select');
                }
            }

            func.call(this, args);
        });
    }
};

Quote.Stock = {
    init: function init(info) {
        var self = this;

        // DOMを取得
        self.$stockButton = $('.tooltip-quote-stock');
        self.$stockMessageBox = $('#quote-stock-message-box');
        self.$stockSuccessMessage = $('#quote-stock-succeeded-message');
        self.$stockFailMessage = $('#quote-stock-failed-message');
        self.$stockCloseMessageButton = $('.quote-stock-close-message-button');
        self.$stockShowEditorButton = $('#quote-stock-show-editor-button');
        self.$unstockableMessageBox = $('#unstockable-quote-message-box');
        self.$quoteLoginRequiredMessageBox = $('#quote-login-required-message');
        self.$quoteLoginButton = $('#quote-login-button');

        // 引用ストックボタンを表示する
        self.$stockButton.show();

        // 非ログイン時はボタン押下でログインに誘導するボックスを出す
        if (info.should_navigate_to_login) {
            self.$stockButton.on('click', function () {
                var messageBoxOffset = {
                    top: self.$stockButton.offset().top,
                    left: self.$stockButton.offset().left + SELECT_STAR_SIZE
                };
                self.$stockMessageBox.css(messageBoxOffset);
                self.$quoteLoginRequiredMessageBox.show();
            });

            self.$quoteLoginButton.on('click', function () {
                var redirectURI, loginURI;
                redirectURI = globalData('admin-domain') + '/go?blog=' + encodeURIComponent(Quote.targetArticle.uri);
                loginURI = 'https://www.hatena.ne.jp/login?location=' + encodeURIComponent(redirectURI);
                location.href = loginURI;
            });

            self.$stockCloseMessageButton.on('click', function () {
                self.$quoteLoginRequiredMessageBox.hide();
            });

            return false;
        }

        // 限定公開時はボタンを押すとその旨を出す
        if (!info.stockable) {
            // ストック出来ない場合のボタン挙動を定義
            self.$stockButton.on('mouseover', function () {
                var messageBoxOffset = {
                    top: self.$stockButton.offset().top,
                    left: self.$stockButton.offset().left + SELECT_STAR_SIZE
                };
                self.$stockMessageBox.css(messageBoxOffset);
                self.$unstockableMessageBox.show();
            });

            self.$stockButton.on('mouseout', function () {
                self.$unstockableMessageBox.hide();
            });

            return false;
        }

        self.setupQuoteStockButton();
    },
    setupQuoteStockButton: function setupQuoteStockButton() {
        var self = this;

        // ストック本体
        self.$stockButton.on('click', function () {
            // メッセージボックスの位置調整
            var messageBoxOffset = {
                top: self.$stockButton.offset().top,
                left: self.$stockButton.offset().left + SELECT_STAR_SIZE
            };
            self.$stockMessageBox.css(messageBoxOffset);

            // ストックする
            Messenger.send('stockQuote', {
                uri: Quote.targetArticle.uri,
                title: Quote.targetArticle.title,
                selected_text: Quote.selectedText
            });
        });

        Messenger.addEventListener('successStockQuote', function () {
            self.$stockSuccessMessage.show();
        });

        Messenger.addEventListener('failStockQuote', function () {
            self.$stockFailMessage.show();
        });

        self.$stockShowEditorButton.on('click', function () {
            self.$stockSuccessMessage.hide();
            Messenger.send('quote-edit-entry', {});
        });

        self.$stockCloseMessageButton.on('click', function () {
            // close all messages
            self.$stockSuccessMessage.hide();
            self.$stockFailMessage.hide();
        });
    }
};

module.exports = Quote;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/EventTracker":37,"../Base/globalData":52,"../Messenger":152,"../Util/getSelected":164,"../Util/getSelectedText":165,"underscore":4}],154:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Messenger = require('../Messenger');

var EventTracker = require('../Base/EventTracker');
var globalData = require('../Base/globalData');

var getSelected = require('../Util/getSelected');
var getSelectedText = require('../Util/getSelectedText');
var ShortenText = require('../Util/shortenText.js');

// テキスト省略 便利オブジェクトの初期化
var shortenText = new ShortenText($('#quote-text'), {});

// 文字列省略用関数
var setShortenedText = _.throttle(function () {
    shortenText.execute();
}, 800);

var Quote = {
    // properties
    targetArticle: {
        $el: null,
        uri: '',
        title: '',
        uuid: ''
    },
    selectedText: '',

    // methods
    init: function init(info) {
        var self = this;
        var selection = getSelected();

        // DOMを取得
        self.$el = $('#quote-base');
        self.$box = $('#quote-box');
        self.$quoteText = $('#quote-text');
        self.$loginRequiredLink = $('.quote-login-link');
        self.$loginRequiredMessage = $('#quote-login-required');

        // targetArticle初期化
        var article = $('article').first();
        self.targetArticle = {
            $el: article,
            uri: article.find('.entry-title a').attr('href'),
            title: article.find('.entry-title a').text(),
            uuid: article.attr('data-uuid')
        };

        // タッチイベント群
        self.$el.on('touchend', function (e) {
            e.preventDefault();
        });

        $(window).on('resize', function (e) {
            setShortenedText();
        });

        $('#container').on('click', function (e) {
            self.hideQuoteBox(e);
        });

        $(document).on('selectionchange', function () {
            // 何も選択していないならなにもしない
            if (selection.rangeCount < 1) return;

            // 本文でないまたはコメントであればなにもしない
            var isArticle = $(selection.anchorNode).parents('article').length > 0;
            var isComment = $(selection.anchorNode).parents('.comment').length > 0;
            if (!isArticle || isComment) return;

            self.selectedText = getSelectedText().replace(/(^\s+)|(\s+$)/g, '');
            if (self.selectedText.length === 0) return;

            self.showQuoteBox();
        });

        // 非ログイン時は誘導メッセージを出す
        // ので、閲覧中の記事に戻ってくるログインのリンクを生成してtouchendイベントで遷移するよう仕向ける
        // self.$elでpreventDefaultしているのでaを踏んだだけでは遷移しない
        var redirectURI, loginURI;
        if (info.should_navigate_to_login) {
            redirectURI = globalData('admin-domain') + '/go?blog=' + encodeURIComponent(self.targetArticle.uri);
            loginURI = 'https://www.hatena.ne.jp/login?location=' + encodeURIComponent(redirectURI);
            self.$loginRequiredLink.attr('href', loginURI);
            self.$loginRequiredLink.on('touchend', function () {
                location.href = loginURI;
            });
            self.$loginRequiredMessage.show();
        }

        QuoteStar.init(info);
        QuoteStock.init(info);
    },
    showQuoteBox: function showQuoteBox() {
        var self = this;

        self.$el.show();
        shortenText.init(self.selectedText);
        setShortenedText();
    },
    hideQuoteBox: function hideQuoteBox(e) {
        var self = this;

        // 引用スターボタンがタッチされたらなにもしない
        if (self.isBoxTouched(e.target)) return;

        self.$el.hide();
        self.$quoteText.text('');
        self.selectedText = '';
    },

    // Util
    isBoxTouched: function isBoxTouched(target) {
        return $(target).closest(this.$box).length > 0;
    }
};

var QuoteStar = {
    init: function init(info) {
        var self = this;
        var messageFadeoutTimer;

        // DOMを取得
        self.$starButton = $('#quote-star-button');
        self.$messageBox = $('#quote-star-result');
        self.$errorBox = $('#quote-star-error');

        // 非ログイン時, はてなスター非設置時は処理を終える
        if (info.should_navigate_to_login) {
            return false;
        }

        // はてなスター非設置時はボタンを押すとその旨を出す
        if (!info.star_addable) {
            self.$starButton.on('touchend', function () {
                self.$errorBox.show();

                if (messageFadeoutTimer) {
                    clearTimeout(messageFadeoutTimer);
                }

                messageFadeoutTimer = setTimeout(function () {
                    self.$errorBox.fadeOut(1000);
                }, 1000);
            });

            return false;
        }

        // ログイン時, はてなスター設置時はボタンを使えるようにする
        self.$starButton.addClass('available');
        self.setupQuoteStarButtonEvents();
    },
    setupQuoteStarButtonEvents: function setupQuoteStarButtonEvents() {
        var self = this;
        var messageFadeoutTimer;

        // スターをつけるときに引用を付加する
        Hatena.Star.AddButton.SmartPhone.prototype.addStar = _.wrap(Hatena.Star.AddButton.SmartPhone.prototype.addStar, function (func, e) {
            this.selectedText = Quote.selectedText.substr(0, 200);

            func.call(this, e);

            if (this.selectedText !== '') {
                EventTracker.trackEvent('hatena-star-add-quote-smartphone');
            }
        });

        // スターをクリックしたらbeforeAddStarを発火するよう設定
        Hatena.Star.AddButton.SmartPhone.prototype.setupObservers = _.wrap(Hatena.Star.AddButton.SmartPhone.prototype.setupObservers, function (func) {
            func.call(this);

            new Ten.Observer(self.$starButton[0], 'ontouchend', this, 'beforeAddStar');
        });

        Hatena.Star.AddButton.SmartPhone.prototype.beforeAddStar = function (e) {
            if ($(this.entry.entryNode).attr('data-uuid') === Quote.targetArticle.uuid) {
                Hatena.Star.AddButton.SmartPhone.AddStarPath = 'star.add.json';
                this.addStar(e);
                Hatena.Star.AddButton.SmartPhone.AddStarPath = 'star.add_multi.json';
            }
        };

        // スター投稿のコールバック
        // ログイン時/非ログイン時で成功orログイン要求のパネルを出し分ける
        Hatena.Star.AddButton.prototype.receiveResult = _.wrap(Hatena.Star.AddButton.prototype.receiveResult, function (func, args) {
            if (args.quote) {
                self.$messageBox.show();

                if (messageFadeoutTimer) {
                    clearTimeout(messageFadeoutTimer);
                }

                messageFadeoutTimer = setTimeout(function () {
                    self.$messageBox.fadeOut(1000);
                }, 1000);

                EventTracker.trackEvent('hatena-star-add-select-smartphone');
            }

            func.call(this, args);
        });
    }
};

var QuoteStock = {
    init: function init(info) {
        var self = this;
        var messageFadeoutTimer;

        // 非ログイン時は処理を終える
        if (info.should_navigate_to_login) {
            return false;
        }

        // DOMを取得
        self.$stockButton = $('#quote-stock-button');
        self.$successMessageBox = $('#quote-stock-result');
        self.$unstockableErrorBox = $('#quote-unstockable-error');
        self.$errorBox = $('#quote-stock-error');

        // 限定公開時はボタンを押すとその旨を出す
        if (!info.stockable) {
            self.$stockButton.on('touchend', function () {
                self.$unstockableErrorBox.show();

                if (messageFadeoutTimer) {
                    clearTimeout(messageFadeoutTimer);
                }

                messageFadeoutTimer = setTimeout(function () {
                    self.$unstockableErrorBox.fadeOut(1000);
                }, 1000);
            });

            return false;
        }

        // ログイン時, 記事が公開状態の時は引用ストックボタンを使えるようにする
        self.$stockButton.addClass('available');
        self.setupQuoteStockButtonEvents();
    },
    setupQuoteStockButtonEvents: function setupQuoteStockButtonEvents() {
        var self = this;
        var messageFadeoutTimer;

        self.$stockButton.on('touchend', function () {
            Messenger.send('stockQuote', {
                uri: Quote.targetArticle.uri,
                title: Quote.targetArticle.title,
                selected_text: Quote.selectedText
            });
        });

        Messenger.addEventListener('successStockQuote', function () {
            self.closeAllMessageBoxes();
            self.$successMessageBox.show();

            if (messageFadeoutTimer) {
                clearTimeout(messageFadeoutTimer);
            }

            messageFadeoutTimer = setTimeout(function () {
                self.$successMessageBox.fadeOut(1000);
            }, 1000);
        });

        Messenger.addEventListener('failStockQuote', function () {
            self.closeAllMessageBoxes();
            self.$errorBox.show();

            if (messageFadeoutTimer) {
                clearTimeout(messageFadeoutTimer);
            }

            messageFadeoutTimer = setTimeout(function () {
                self.$errorBox.fadeOut(1000);
            }, 1000);
        });
    },
    closeAllMessageBoxes: function closeAllMessageBoxes() {
        var self = this;
        self.$successMessageBox.hide();
    }
};

module.exports = Quote;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/EventTracker":37,"../Base/globalData":52,"../Messenger":152,"../Util/getSelected":164,"../Util/getSelectedText":165,"../Util/shortenText.js":178,"underscore":4}],155:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

var globalData = require('./Base/globalData');
var Locale = require('./Locale');
var URLGenerator = require('./Base/URLGenerator');
var EventTracker = require('./Base/EventTracker');

var ShortenText = require('./Util/shortenText.js');

var waitForResource = require('./Util/waitForResource');
var positionToString = require('./Util/positionToString');
var updateDynamicPieces = require('./Util/updateDynamicPieces');

var setupStar = function setupStar() {
    if (!Hatena.Star) return;

    var entryConfig = {
        entryNodes: {
            // PC, article
            'article.entry': {
                uri: '.hatena-star-metadata .hatena-star-permalink',
                title: '.hatena-star-metadata .hatena-star-permalink',
                container: 'div.hatena-star-container'
            },
            // PC, archive
            'section.archive-entry': {
                uri: '.hatena-star-metadata .hatena-star-permalink',
                title: '.hatena-star-metadata .hatena-star-permalink',
                container: 'span.star-container'
            },
            // touch, article
            '.entry-article': {
                uri: '.hatena-star-metadata .hatena-star-permalink',
                title: '.hatena-star-metadata .hatena-star-permalink',
                container: 'div.hatena-star-container'
            },
            // touch, comment
            'li.entry-comment': {
                uri: 'p.comment-metadata a.permalink',
                title: 'div.comment-content',
                container: '.comment-metadata'
            }
        }
    };

    var commentConfig = {
        entryNodes: {
            'li.entry-comment': {
                uri: 'p.comment-metadata a.permalink',
                title: 'div.comment-content::-ten-truncate',
                container: '.comment-metadata'
            }
        }
    };

    Hatena.Star.SiteConfig = entryConfig;

    Hatena.Star.EntryLoader.intoCommentScope = function (func) {
        Hatena.Star.SiteConfig = commentConfig;
        func();
        Hatena.Star.SiteConfig = entryConfig;
    };

    Hatena.Star.User.prototype.userPage = function () {
        var uri = globalData('admin-domain') + '/' + this.name + '/';
        return uri;
    };

    var img_src = URLGenerator.static_url('/images/theme/star/hatena-star-add-button.png');
    Hatena.Star.AddButton.ImgSrc = img_src;
    Hatena.Star.AddButton.SmartPhone.ImgSrc = img_src;
};

setupStar();

var Star = {
    // スター大きくしてプロフィールアイコン重ねる
    initBigStar: function initBigStar() {
        if (!Hatena.Star) return;

        // 体裁変更
        Hatena.Star.Star.prototype.generateImg = function () {
            var img, star_img, user_img, span, user_icon;

            user_icon = function (name) {
                return "http://cdn1.www.st-hatena.com/users/" + encodeURI(name.slice(0, 2)) + "/" + encodeURI(name) + "/profile.gif";
            };

            star_img = Hatena.Star.Star.getImage(this.container);
            star_img.alt = this.screen_name;
            star_img.title = '';

            if (this.color && this.color != 'yellow' && this.color != 'temp') {
                star_img.alt = star_img.alt + ' (' + this.color + ')';
            }

            this.img = star_img;

            if (this.screen_name) {
                if (!Hatena.Star.Star.gotImage[this.screen_name]) {
                    Hatena.Star.Star.gotImage[this.screen_name] = {};
                }

                if (!Hatena.Star.Star.gotImage[this.screen_name][this.color]) {
                    span = document.createElement('span');
                    span.className = 'hatena-big-star-star-container';
                    user_img = document.createElement('img');
                    user_img.src = user_icon(this.screen_name);
                    user_img.setAttribute('tabIndex', 0);
                    user_img.className = 'hatena-star-user';
                    user_img.style.padding = '0';
                    user_img.style.border = 'none';

                    span.appendChild(user_img);
                    span.appendChild(star_img);

                    Hatena.Star.Star.gotImage[this.screen_name][this.color] = span;
                }

                this.img = Hatena.Star.Star.gotImage[this.screen_name][this.color].cloneNode(true);
            }
        };

        // posの値の調整
        Hatena.Star.AddButton.prototype.showColorPallet = function (e) {
            this.clearSelectedColorTimer();
            if (!this.pallet) this.pallet = new Hatena.Star.Pallet();
            var pos = Ten.Geometry.getElementPosition(this.img);
            pos.x += 2;
            pos.y += 22;
            this.pallet.showPallet(pos, this);
        };

        Hatena.Star.AddButton.SmartPhone.prototype.showColorPallet = function (e) {
            this.clearSelectedColorTimer();

            if (!this.pallet) {
                this.pallet = new Hatena.Star.Pallet.SmartPhone();
            }

            var pos = Ten.Geometry.getElementPosition(this.img);
            pos.x = Ten.Browser.isDSi ? 5 : 15;
            pos.y += 30;
            this.pallet.showPallet(pos, this);
            this.pallet.show(Hatena.Star.UseAnimation ? { x: 0, y: 0 } : pos);
        };

        // スターボタン押されたら必要な情報をはてなブログのサーバーに送る
        Hatena.Star.AddButton.prototype.addStar = _.wrap(Hatena.Star.AddButton.prototype.addStar, function (fun, e) {
            fun.apply(this, [e]);
            EventTracker.trackEvent('hatena-star-add');
        });

        Hatena.Star.AddButton.SmartPhone.prototype.addStar = _.wrap(Hatena.Star.AddButton.SmartPhone.prototype.addStar, function (fun, e) {
            fun.apply(this, [e]);
            EventTracker.trackEvent('hatena-star-add-smartphone');
        });
    },

    // スター付けたことない場合、ツールチップを表示する
    initStarNavigation: function initStarNavigation() {

        if (!Hatena.Star) return;

        var $star_navigation_tooltip = $('<div>').addClass('star-navigation-tooltip').append($('<p>').text(Locale.text('star-navigation-message')));

        $.getJSON("https://www.hatena.ne.jp/notify/notices.count.json?services=1&callback=?", function (res) {

            // スター利用中ならなにもしない
            if (res.services.s) return;

            // はてなスター利用中ではないけどスターつけた
            Hatena.Star.AddButton.prototype.addStar = _.wrap(Hatena.Star.AddButton.prototype.addStar, function (fun, e) {
                fun.apply(this, [e]);
                EventTracker.trackEvent('hatena-star-add-first');
            });

            // 既読かどうかを localStorage に保存する
            var localStorageKey = 'Hatena.Diary.Blogs.StarNavigation.Read';

            var isRead = function isRead() {
                try {
                    return localStorage[localStorageKey] === 'already';
                } catch (ignore) {}
            };

            var setIsRead = function setIsRead(isRead) {
                try {
                    localStorage[localStorageKey] = isRead ? 'already' : 'not yet';
                } catch (ignore) {}
            };

            // 既読のとき tipsy 出す必要ない
            if (isRead()) return;

            var wait_for_star_load = function wait_for_star_load(func) {
                setTimeout(function () {
                    var $star_button = $('.hatena-star-add-button');

                    if ($star_button.length !== 0) {
                        func();
                        return;
                    }

                    wait_for_star_load(func);
                }, 200);
            };

            wait_for_star_load(function () {
                $('.hatena-star-container').after($star_navigation_tooltip);

                $('.star-navigation-tooltip').click(function () {
                    setIsRead(true);
                    $(this).fadeOut(1000);
                });

                $('.hatena-star-add-button').click(function () {
                    setIsRead(true);
                    $('.star-navigation-tooltip').fadeOut(1000);
                });
            });
        });
    },

    initDeleteStar: function initDeleteStar() {
        if (!Hatena.Star) return;

        Hatena.Star.Star.prototype.setImgObservers = function () {
            var self = this;
            new Ten.Observer(self.img, 'onmouseover', self, 'showName');
            new Ten.Observer(self.img, 'onmouseout', self, 'hideName');
        };

        Hatena.Star.Star.prototype.asElement = _.wrap(Hatena.Star.Star.prototype.asElement, function (func) {
            var self = this;
            var element = func.call(self);

            if (!Hatena.Star.Config.isStarDeletable) return element;

            // 以下はスターがdocumentにappendされてから実行

            // スター削除できるとき成功するDeferredを返す
            var checkCanDelete = _.once(function () {
                var dfd = $.Deferred();

                var uri = Hatena.Star.BaseURL.replace(/^http:/, Hatena.Star.BaseURLProtocol) + 'star.deletable.json';
                var data = {
                    name: self.name,
                    uri: self.entry.uri
                };
                if (self.color) data.color = self.color;
                if (self.quote) data.quote = self.quote;

                $.ajax({
                    type: 'get',
                    dataType: 'jsonp',
                    url: uri,
                    data: data
                }).done(function (res) {
                    var can_delete = res.result && (res.message || res.confirm_html);
                    if (can_delete) {
                        dfd.resolve(res);
                    } else {
                        dfd.reject(res);
                    }
                });

                return dfd;
            });

            var $star_container = $(self.anchor);

            $star_container.hover(function () {
                // 削除可能なとき，右上に削除ボタンを表示
                checkCanDelete().done(function (deletion_info) {
                    var $delete_button = $("<img>").addClass('star-delete-button').attr("src", URLGenerator.static_url('/images/theme/star/star-delete.png'));
                    $star_container.append($delete_button);
                    var button_position = $delete_button.position();
                    $delete_button.css({
                        left: button_position.left - 9,
                        top: button_position.top
                    });

                    //クリックされたら削除確認
                    $delete_button.click(function () {
                        if (deletion_info.confirm_html) {
                            var pos = Ten.Geometry.getElementPosition(self.anchor);
                            var scr = new Hatena.Star.DeleteConfirmScreen();
                            scr.showConfirm(deletion_info.confirm_html, self, pos);
                        } else if (confirm(deletion_info.message)) {
                            self.deleteStar();
                        }

                        return false;
                    });
                });
            }, function () {
                $(this).find(".star-delete-button").remove();
            });

            return element;
        });
    },

    // サードパーティクッキー送信されてないときmobile用のエントリページを新しいウィンドウで開く
    initStarForThirdPartyCookiesDisabled: function initStarForThirdPartyCookiesDisabled(info) {
        waitForResource(function () {
            return Hatena.Star;
        }, function () {
            _.extend(Hatena.Star.AddButton.prototype, {
                addStar: function addStar() {
                    var self = this;

                    // uri:      エントリのURI
                    // location: スターつけたあとのリダイレクト先
                    var url = 'http://s.hatena.ne.jp/star.add?' + $.param({
                        uri: self.entry.uri,
                        location: globalData('admin-domain') + '/-/close'
                    });

                    var position = {
                        width: 500,
                        height: 200
                    };
                    position.left = Math.floor((screen.width - position.width) / 2);
                    position.top = Math.floor((screen.height - position.height) / 2);

                    var position_string = positionToString(position);

                    var star_window = window.open(url, 'add_star', position_string);

                    // window閉じられたら読み込みなおす
                    waitForResource(function () {
                        return star_window.closed;
                    }, function () {
                        updateDynamicPieces([self.entry.entryNode.parentNode]);
                    });
                },
                // カラースターつけられないのでパレット開かなくする
                showColorPallet: function showColorPallet() {},
                showColorPalletDelay: function showColorPalletDelay() {}
            });
        });
    }
};

module.exports = Star;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./Base/EventTracker":37,"./Base/URLGenerator":48,"./Base/globalData":52,"./Locale":151,"./Util/positionToString":173,"./Util/shortenText.js":178,"./Util/updateDynamicPieces":180,"./Util/waitForResource":181,"underscore":4}],156:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var extend = require('../Util/extend');
var Base = require('./Base');

/**
 * admin版講読ボタン
 * Base を継承
 * ボタン間の同期には Messenger ではなく localStorage を使う
 */
var SubscribeButtonAdmin = function SubscribeButtonAdmin($el, userData, blogData) {
    this.initialize($el, userData, blogData);
};
extend(SubscribeButtonAdmin.prototype, Base.prototype);

/** @override */
SubscribeButtonAdmin.prototype.initialize = function ($el, userData, blogData, messenger) {
    Base.prototype.initialize.call(this, $el, userData, blogData);

    // メッセージ処理
    this.initMessages();
};

/** @override */
SubscribeButtonAdmin.prototype.initMessages = function () {
    // localStorageのstorageイベントで同期を行う
    var self = this;
    window.addEventListener("storage", function (event) {
        if (event.key !== 'subscription') {
            return;
        }
        var data = JSON.parse(event.newValue);
        var blogData = data[self.blog.blogUrl];

        // 変化が無いときは何もしない
        if (blogData === self.user.isSubscribing) {
            return;
        }

        // trueでもfalseでも無いときは何もしない (undefinedなど)
        if (blogData === true) {
            self.subscribe();
        }
        if (blogData === false) {
            self.unsubscribe();
        }
    });
};

/**
 * @override
 * @public
 */
SubscribeButtonAdmin.prototype.openSubscribeWindow = function () {
    var self = this;

    // ドメインにかかわらず、confirmを出す
    // クリックジャッキング対策
    var confirmMessage = Hatena.Locale.text(self.user.isSubscribing ? 'epic.confirm_unsubscribe' : 'epic.confirm_subscribe', self.blog.blogName, self.blog.blogUrl);
    var res = window.confirm(confirmMessage);
    if (!res) {
        return false;
    }

    // ゲストだったらポップアップでログイン画面を出す
    if (self.user.isGuest) {
        self.popupLoginWindow();
        return false;
    }

    // 購読成功したら状態更新
    self.blog.requestUpdate(self.user).success(function () {
        self.toggleState();
    });
};

SubscribeButtonAdmin.prototype.popupLoginWindow = function () {
    // 位置を指定
    var options = { width: 900, height: 600, scrollbars: 'yes' };
    options.left = Math.floor((screen.width - options.width) / 2);
    options.top = Math.floor((screen.height - options.height) / 2);

    // ログインURLを作成
    var targetURL = this.blog.requestUrl + '?iframe=1';
    var loginURL = 'http://www.hatena.ne.jp/login?location=' + encodeURIComponent(targetURL);

    // ポップアップを開く
    var loginWindow = window.open(loginURL, 'login', Hatena.Diary.Util.positionToPositionString(options));
};

/** @override */
SubscribeButtonAdmin.prototype.toggleState = function () {
    if (this.user.isSubscribing) {
        this.unsubscribe();
        SubscribeButtonAdmin.setSubscription(this.blog.blogUrl, false);
    } else {
        this.subscribe();
        SubscribeButtonAdmin.setSubscription(this.blog.blogUrl, true);
    }
};

/**
 * localStorageにブログ毎の講読に講読情報を保存する
 * @static
 */
SubscribeButtonAdmin.setSubscription = function (blogUrl, isSubscribing) {
    var value = JSON.parse(window.localStorage.getItem('subscription'));
    value = _.isObject(value) ? value : {};
    value[blogUrl] = isSubscribing;
    window.localStorage.setItem('subscription', JSON.stringify(value));
};

module.exports = SubscribeButtonAdmin;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Util/extend":163,"./Base":157,"underscore":4}],157:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var globalData = require('../Base/globalData');

/**
 * ユーザの情報
 *
 * @param {boolean} [userData.isSubscribing] - 購読中か否か
 * @param {boolean} [userData.isGuest]       - ゲストユーザか否か
 */
var User = function User(userData) {
    this.initialize(userData);
};
User.prototype = {
    initialize: function initialize(userData) {
        this.isSubscribing = userData.isSubscribing || false;
        this.isGuest = userData.isGuest || false;
    },
    toggle: function toggle() {
        this.isSubscribing = !this.isSubscribing;
    }
};

/**
 * ブログの情報
 * サーバとの通信も行う
 *
 * @param {number} [blogData.subscribersCount] - ブログの購読者数
 * @param {number} [blogData.blogUrl]          - ブログのURL
 * @param {string} [blogData.blogName]         - ブログ名
 * @param {number} [blogData.requestUrl]       - POSTリクエストを行うURL
 */
var Blog = function Blog(blogData) {
    this.initialize(blogData);
};
Blog.prototype = {
    initialize: function initialize(blogData) {
        this.subscribersCount = +blogData.subscribersCount || 0;
        this.blogUrl = blogData.blogUrl;
        this.blogName = blogData.blogName;
        this.requestUrl = blogData.requestUrl;
    },

    requestUpdate: function requestUpdate(user) {
        var ajax = $.ajax({
            type: "POST",
            url: this.requestUrl,
            data: {
                rkm: globalData('rkm'),
                rkc: globalData('rkc'),
                "delete": user.isSubscribing ? 1 : 0
            }
        });
        return ajax;
    },

    updateSubscribersCount: function updateSubscribersCount(user) {
        this.subscribersCount += user.isSubscribing ? 1 : -1;
    }
};

/**
 * 購読ボタンの抽象クラス
 * 外部からは openSubscribeWindow しか呼ばれない
 *
 * @param {$element}  [$el]       - 要素のjQueryオブジェクト
 * @param {Object}    [userData]  - Userクラスの引数
 * @param {Object}    [blogData]  - Blogクラスの引数
 */
var SubscribeButton = function SubscribeButton($el, userData, blogData) {
    this.initialize($el, userData, blogData);
};
SubscribeButton.prototype = {
    initialize: function initialize($el, userData, blogData) {
        var self = this;

        self.$el = $el;

        // モデル初期化
        self.user = new User(userData);
        self.blog = new Blog(blogData);

        // 要素の初期化
        self.$subscribeBtn = self.$el.find('.js-hatena-follow-button');
        self.$subscriptionCount = self.$el.find('.js-subscription-count');
        self.$subscriptionCountBox = self.$el.find('.js-subscription-count-box');

        self.updateViews();

        // マウスイベント処理
        self.initEvents();
    },

    // マウスイベントのハンドラを登録する
    initEvents: function initEvents() {
        var self = this;
        this.$subscribeBtn.on('mouseenter', function () {
            $(this).addClass('hover');
        }).on('mouseleave', function () {
            $(this).removeClass('hover');
        }).on('click', function (e) {
            var offset = self.$subscribeBtn.offset();
            offset.top += self.$subscribeBtn.height();
            self.openSubscribeWindow(offset);
            return false;
        });
    },

    /**
     * 購読ボタン間で同期するためのメッセージハンドラを登録する
     * @abstract
     */
    initMessages: function initMessages() {},

    // user, blogの状態に合わせて表示を更新する
    updateViews: function updateViews() {
        // 初期化時にも呼ばれるため、toggleClassは使わない
        var isSubscribing = this.user.isSubscribing;
        this.$subscribeBtn.addClass(isSubscribing ? 'subscribing' : 'unsubscribing').removeClass(isSubscribing ? 'unsubscribing' : 'subscribing');

        // hoverクラスを外す
        // 擬似クラスではなくクラスを使うことで、マウスのフォーカスが外れていても操作できる
        this.$subscribeBtn.removeClass('hover');

        this.updateCountBox();
    },

    // 購読者数バルーンを出す
    updateCountBox: function updateCountBox() {
        if (this.blog.subscribersCount >= 1) {
            this.$subscriptionCountBox.show();
            this.$subscriptionCount.text(this.blog.subscribersCount);
        } else {
            this.$subscriptionCountBox.hide();
        }
    },

    /**
     * 確認用のiframeやポップアップ、confirmなどを開く
     * 購読ボタンを押したら呼ばれる
     * @abstract
     * @public
     */
    openSubscribeWindow: function openSubscribeWindow(offset, isFixed) {},

    /**
     * 講読処理成功時に呼ばれる
     * @abstract
     */
    toggleState: function toggleState() {},

    // 講読時にmodel, viewを更新する
    subscribe: function subscribe() {
        this.user.isSubscribing = true;
        this.blog.subscribersCount++;
        this.updateViews();
    },

    // 講読解除時にmodel, viewを更新する
    unsubscribe: function unsubscribe() {
        this.user.isSubscribing = false;
        this.blog.subscribersCount--;
        this.updateViews();
    }
};

module.exports = SubscribeButton;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/globalData":52}],158:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var extend = require('../Util/extend');
var globalData = require('../Base/globalData');
var Browser = require('../Base/Browser');
var Base = require('./Base');
var Messenger = require('../Messenger');

/**
 * blogs版の購読ボタン
 * ボタン間の同期にはMessengerを使う
 *
 * @param {$element}  [$el]       - 要素のjQueryオブジェクト
 * @param {Object}    [userData]  - Userクラスの引数
 * @param {Object}    [blogData]  - Blogクラスの引数
 * @param {Messenger} [messenger] - ボタン間で同期する為、windowと通信するMessenger
 */
var SubscribeButtonBlogs = function SubscribeButtonBlogs($el, userData, blogData, messenger) {
    this.initialize($el, userData, blogData, messenger);
};
extend(SubscribeButtonBlogs.prototype, Base.prototype);

/** @override */
SubscribeButtonBlogs.prototype.initialize = function ($el, userData, blogData, messenger) {
    Base.prototype.initialize.call(this, $el, userData, blogData);

    // メッセージ処理
    this.messenger = messenger;
    this.initMessages();
};

/** @override */
SubscribeButtonBlogs.prototype.initMessages = function () {
    // 通常版ではlocalStorageは使わずにpostMessageを使って処理する
    // localStorageは同一ページ内ではstorageイベントを監視できない
    var self = this;
    self.messenger.addEventListener('subscription', function (data) {
        var blogData = data[self.blog.blogUrl];

        // 変化が無いときは何もしない
        if (blogData === self.user.isSubscribing) {
            return;
        }

        // trueでもfalseでも無いときは何もしない (undefinedなど)
        if (blogData === true) {
            self.subscribe();
        }
        if (blogData === false) {
            self.unsubscribe();
        }
    });
};

/**
 * 確認用のiframeまたはポップアップを開く
 * 購読ボタンを押したら呼ばれる
 *
 * @public
 * @param {Object}  [offset]  - 確認iframeを出す位置のoffset
 * @param {boolean} [isFixed] - 確認iframeを固定するかどうか
 */
SubscribeButtonBlogs.prototype.openSubscribeWindow = function (offset, isFixed) {
    var uri = '' + globalData('admin-domain') + '/' + globalData('author') + '/' + globalData('blog') + '/subscribe?iframe=1';

    var self = this;
    Browser.thirdPartyCookiesBlocked.done(function (blocked) {
        if (blocked) {
            self.subscribeButtonHandlerWindow(uri);
        } else {
            self.subscribeButtonHandlerIframe(uri, offset, isFixed);
        }
    });
};

// 講読確認iframeを出す
SubscribeButtonBlogs.prototype.subscribeButtonHandlerIframe = function (uri, offset, isFixed) {
    var $container = $('<div class="hatena-iframe-container popup"></div>');
    var $loading = $(['<div class="loading">', '<img src="', Hatena.Diary.URLGenerator.static_url('/images/loading.gif'), '" alt="loading"/>', Hatena.Locale.text('loading'), '</div>'].join(''));
    var $iframe = $('<iframe frameborder="0"></iframe>');

    // windowの大きさを計算
    var maxWidth = $(window).width();
    var winWidth = 300;
    var padding = 20;
    if (maxWidth - offset.left < winWidth + padding) {
        offset.left = maxWidth - (winWidth + padding);
    }

    // DOM組み立て
    $container.appendTo(document.body);
    $loading.appendTo($container);
    $iframe.appendTo($container);

    // スタイルをあてる
    $container.hide().css({
        width: winWidth,
        height: 155,
        position: isFixed ? 'fixed' : 'absolute'
    });
    if (offset) {
        $container.offset(offset); // offsetはcssの後に当てないとダメ
    }
    $loading.hide().delay(250).show();
    $iframe.on('load', function () {
        $loading.hide();
    });

    // message準備
    var iframeMessenger = Messenger.createForFrame($iframe[0], uri);

    iframeMessenger.addEventListener('resize', function (data) {
        if (data) {
            $container.css(data);
        }
    });

    iframeMessenger.addEventListener('close', function () {
        Hatena.Diary.Window.hide($container);
    });

    var self = this;
    iframeMessenger.addEventListener('done', function () {
        self.toggleState();
    });

    Hatena.Diary.Window.show($container, {
        destroy: function destroy() {
            $container.remove();
            iframeMessenger.destroy();
        }
    });
};

// 購読確認ポップアップを出す
SubscribeButtonBlogs.prototype.subscribeButtonHandlerWindow = function (uri) {
    // windowを表示する位置を求める
    var position = {
        width: 300,
        height: 150
    };
    position.left = Math.floor((screen.width - position.width) / 2);
    position.top = Math.floor((screen.height - position.height) / 2);

    // windowを作成
    var subscribeWindow = window.open('', 'subscribe', Hatena.Diary.Util.positionToPositionString(position));

    var popupMessenger = Messenger.createForWindow(subscribeWindow, uri);

    var self = this;
    popupMessenger.addEventListener('done', function () {
        self.toggleState();
        close();
    });

    var close = function close() {
        popupMessenger.destroy();
        subscribeWindow.close();
    };

    popupMessenger.addEventListener('close', close);

    // 親windowにフォーカスが移ったら閉じる
    $(document.body).one('focus', close);
};

/** @override */
SubscribeButtonBlogs.prototype.toggleState = function () {
    var data = {};
    data[this.blog.blogUrl] = !this.user.isSubscribing;
    this.messenger.send('subscription', data);
};

module.exports = SubscribeButtonBlogs;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Browser":31,"../Base/globalData":52,"../Messenger":152,"../Util/extend":163,"./Base":157,"underscore":4}],159:[function(require,module,exports){
'use strict';

var Admin = require('./Admin');
var Blogs = require('./Blogs');

module.exports = {
    Admin: Admin,
    Blogs: Blogs
};

},{"./Admin":156,"./Blogs":158}],160:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

/**
 * サイドバーのタブ形式のモジュールで、アクティブなタブをlocalStorageに記憶する
 * @param {jQuery}   args.$container - タブのコンテナ要素
 * @param {String}   args.key        - localStorageに保存するためのキー
 * @param {Function} args.onchange   - タブ切替時に呼ぶコールバック関数
 */
var backupTab = function backupTab(args) {
    var $container = args.$container;
    var key = args.key;
    var onchange = args.onchange;

    var isAvailable;

    try {
        isAvailable = localStorage;
    } catch (ignore) {}

    if (!isAvailable) return;

    var localStorageKey = 'Hatena.Diary.Util.backupTab.' + key;

    var getValue = function getValue() {
        return localStorage[localStorageKey];
    };

    var setValue = function setValue(value) {
        localStorage[localStorageKey] = value;
    };

    var restoreLastValue = function restoreLastValue() {
        var lastValue = getValue();
        if (lastValue === undefined) return;

        var $input = $container.find('input[value="' + lastValue + '"]');
        $input.trigger('click');
        onchange($input);
    };

    restoreLastValue();

    $container.delegate('input', 'change', function () {
        var $input = $(this);

        setValue($input.val());

        onchange($input);
    });
};

module.exports = backupTab;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],161:[function(require,module,exports){
'use strict';

var canonicalizeColor = function canonicalizeColor(color) {
    if (color.match(/#([0-9a-f]{6})/i)) {
        color = RegExp.$1;
    } else if (color.match(/#([0-9a-f])([0-9a-f])([0-9a-f])/i)) {
        color = RegExp.$1 + RegExp.$1 + RegExp.$2 + RegExp.$2 + RegExp.$3 + RegExp.$3;
    } else if (color.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*(\d+)\s*)?/)) {
        var transparent = RegExp.$4.length && +RegExp.$4 === 0;
        color = transparent ? null : ("0" + (+RegExp.$1).toString(16)).slice(-2) + ("0" + (+RegExp.$2).toString(16)).slice(-2) + ("0" + (+RegExp.$3).toString(16)).slice(-2);
    } else {
        color = null;
    }
    return color ? color.toLowerCase() : null;
};

module.exports = canonicalizeColor;

},{}],162:[function(require,module,exports){
'use strict';

// $.paramの逆
// input: key=value1&key=value2 形式のString
// output: { key: [value1, value2] }
var decodeParam = function decodeParam(data) {
    var params = {};
    var values = data.split('&');
    for (var i = 0, len = values.length; i < len; i++) {
        if (!values[i].match(/[=]/)) continue;
        var kv = values[i].split('=');
        var key = decodeURIComponent(kv[0]);
        var val = kv[1].replace(/\+/g, ' ');
        if (!params[key]) params[key] = [];
        params[key].push(decodeURIComponent(val));
    }

    return params;
};

module.exports = decodeParam;

},{}],163:[function(require,module,exports){
'use strict';

// parentのプロパティを順にtargetに移していく
// targetにすでに存在するときは移さない
// XXX: _.extendOwnで良いのでは？
var extend = function extend(target, parent) {
    for (var key in parent) if (parent.hasOwnProperty(key) && !target.hasOwnProperty(key)) {
        target[key] = parent[key];
    }
};

module.exports = extend;

},{}],164:[function(require,module,exports){
// Ten.base.jsの関数getSelectedTextとほぼ同じもの

module.exports = function () {
    if (window.getSelection) {
        return window.getSelection();
    } else if (document.getSelection) {
        return document.getSelection();
    } else {
        return {};
    }
};

},{}],165:[function(require,module,exports){
module.exports = function () {
    if (window.getSelection) {
        return '' + (window.getSelection() || '');
    } else if (document.getSelection) {
        return document.getSelection();
    } else if (document.selection) {
        return document.selection.createRange().text;
    } else {
        return '';
    }
};

},{}],166:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Logger = require('../Base/Logger');

// スクロールについてくる要素のセットアップ
// $container: 直下に子要素要素を1つだけ含む要素 先頭の1つだけ監視するので，複数の要素を監視したい場合は，この関数を複数回呼んでください
// enable_bottom: #containerの下に合わせて止めるときtrue
var initScrollFollowedElement = function initScrollFollowedElement($container, enable_bottom) {
    var $target = $($container.children()[0]);

    if ($target.length === 0) {
        Logger.BUG("ad element not found: " + $container.html(), 'followedAd');
        return;
    }

    var $document = $(document);
    var $page_container = $('#container');

    var onScroll = function onScroll() {
        var container_offset = $container.offset();
        var scroll_top = $document.scrollTop();
        var target_height = $target.height();
        var page_container_top = $page_container.offset().top;
        var page_container_height = $page_container.height();

        if (scroll_top + page_container_top < container_offset.top) {
            // 上で固定
            $target.css({
                position: 'static'
            });
        } else if (!enable_bottom || scroll_top < page_container_height - target_height) {
            // 真ん中 ついてくる

            $target.css({
                position: 'fixed',
                top: page_container_top,
                left: container_offset.left
            });
        } else {
            // 下で固定 #containerの底辺に合わせる
            $target.css({
                position: 'absolute',
                top: page_container_top + page_container_height - target_height,
                left: container_offset.left
            });
        }
    };

    var onResize = function onResize() {

        var container_offset = $container.offset();

        $target.css({
            left: container_offset.left
        });
    };

    $(window).scroll(onScroll).resize(onResize);
    onScroll();
};

module.exports = initScrollFollowedElement;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Logger":44}],167:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

// 指定したURLの画像リソースをロードするまで待つ
// ロードできたらresolve, 失敗するとrejectされるDeferredを返す
var loadImages = function loadImages(urls) {
    var loaded = $.Deferred();
    var images;

    var count = 0;
    var onload = function onload() {
        count++;
        if (count === urls.length) {
            loaded.resolve(images);
        }
    };
    var onerror = function onerror() {
        loaded.reject(images);
    };

    images = _.map(urls, function (url) {
        var $img = $('<img>');
        $img.on('load', onload).on('error', onerror).attr('src', url);
        return $img[0];
    });

    return loaded.promise();
};

module.exports = loadImages;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],168:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

// private
var template = _.template('<span class="user-name-nickname"><%- nickname %></span> <span class="user-name-paren">(</span><span class="user-name-hatena-id">id:<%- hatenaId %></span><span class="user-name-paren">)</span>');

// ユーザー名をニックネームに書き換える
var displayNicknames = function displayNicknames($elements, friendships) {
    $elements.each(function () {
        var $element = $(this);
        var username = $element.attr('data-user-name');
        if (friendships[username] && username != friendships[username].name) {
            var html = template({
                nickname: friendships[username].name,
                hatenaId: username
            });

            $element.html(html);
        }
    });
};

// JSONPの上限に逹しないため小分けにして通信
var request = function request($elements, usernames) {
    var usernamesCurrent = usernames.splice(0, 20);
    $.ajax({
        url: 'https://h.hatena.ne.jp/api/friendships/show.json',
        dataType: 'jsonp',
        data: {
            url_name: usernamesCurrent
        },
        traditional: true
    }).done(function (friendships) {
        displayNicknames($elements, friendships);
        if (usernames.length > 0) {
            request($elements, usernames);
        }
    });
};

// $container 内の data-load-nicknames のニックネームを取ってきて要素のテキストを差し替える
var loadNicknames = function loadNicknames($container) {
    var $elements = $container.find('[data-load-nickname]');
    var usernames = [];
    $elements.each(function () {
        var $element = $(this);
        var username = $element.attr('data-user-name');
        usernames.push(username);
    });
    usernames = _.uniq(usernames);
    if (usernames.length === 0) {
        return;
    }
    if (usernames.length === 1) {
        usernames.push('hatenablog');
    } // APIの仕様上usernamesは2つ以上必要

    request($elements, usernames);
};

module.exports = loadNicknames;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],169:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

// decodeParamで配列になったクエリパラメータをlocationに変換する
// decodeParamでは値が1つのときも配列を返すので, 配列の要素が1つのときはキーを変更しない
// input: { key: value1, key1: [value1], key2: [value1,value2] }
// output: location?key=value1&key1=value1&key2[]=value1&key2[]=value2
var locationWithParam = function locationWithParam(params) {
    _.each(params, function (value, key) {
        if (_.isArray(value) && value.length == 1) params[key] = value[0];
    });
    return location.pathname + '?' + $.param(params);
};

module.exports = locationWithParam;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],170:[function(require,module,exports){
'use strict';

var migrateOldStyleYoutubeURL = function migrateOldStyleYoutubeURL(url) {
    // XXX: /v/以下のURLはiframeに入れられなくなった．/embed/にしたら再生できる．パラメータも消す必要ある．
    // 旧: https://www.youtube.com/v/***&aaa=bbbb&
    // 新: https://www.youtube.com/embed/***
    // /embed/ でプレイリストを貼り付ける場合は?list= というパラメータが来るので，/v/じゃないときはパラメータ消してはいけない
    if (url.match(/\/v\//i)) {
        url = url.split(/[?&]/)[0];
        url = url.replace(/\/v\//i, '/embed/');
    }

    // XXX: youtube.googleapis.com はiPhoneで再生できなくなった．www.youtube.com/embed/ なら再生できる．
    url = url.replace('youtube.googleapis.com', 'www.youtube.com');

    // XXX: httpsも貼れなくなったので//で貼って現在のプロトコルと一致させる
    url = url.replace(/^https:/, '');
    return url;
};

module.exports = migrateOldStyleYoutubeURL;

},{}],171:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');

// 利用規約再同意 notices.count.jsonの返り値を受け取る
var needComrule2013 = function needComrule2013(data) {
    if (!data.need_comrule2013) {
        return;
    }
    _.defer(function () {
        var BASE = location.hostname.match(/\.hatena\.[^:]+/)[0];
        window.top.location.href = 'http://www' + BASE + '/login?need_comrule2013=1';
    });
};

module.exports = needComrule2013;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"underscore":4}],172:[function(require,module,exports){
'use strict';

// W3CDTF形式のStringをパースしてDateを返す
// IE8以前はnew Date( )でこの形式をパースできないので正規表現でなんとかする
// datetime: YYYY-MM-DDThh:mm:ss 形式のString
// returns: Date | null
var parseW3CDTF = function parseW3CDTF(datetime) {
    var matched = datetime.match(/(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)/);
    if (!matched) return null;
    return new Date(+matched[1], +matched[2] - 1, +matched[3], +matched[4], +matched[5], +matched[6]);
};

module.exports = parseW3CDTF;

},{}],173:[function(require,module,exports){
'use strict';

var _ = require('underscore');

// windowの座標を表すhashをwindow.openに指定できる文字列に変換
// position: { width, height, left, top } valueはint
// return: "width=\d,height=\d,left=\d,top=\d"
var positionToString = function positionToString(position) {
    return _.map(_.keys(position), function (key) {
        return key + '=' + position[key];
    }).join(',');
};

module.exports = positionToString;

},{"underscore":4}],174:[function(require,module,exports){
'use strict';

var _ = require('underscore');

var preventDuplicateSubmit = function preventDuplicateSubmit($form) {
    // 二重submit対策
    // submitボタンが複数あるときsubmit前にdisabledにすると値自体送られなくなってしまう対策で，submitが済んでからdisabledにしています
    _.defer(function () {
        $form.find(':submit').prop('disabled', true);
    });
};

module.exports = preventDuplicateSubmit;

},{"underscore":4}],175:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var migrateOldStyleYoutubeURL = require('./migrateOldStyleYoutubeURL');

var replaceYoutubeURL = function replaceYoutubeURL($entry) {
    // 以前貼り付けたyoutube動画が再生されないのでiframeのsrcのURLを表示時に書き換える
    $entry.find('iframe[src*="youtube.com/"],iframe[src*="youtube.googleapis.com/"]').each(function () {
        var $iframe = $(this);
        var src = $iframe.attr('src');
        $iframe.attr('src', migrateOldStyleYoutubeURL(src));
    });
};

module.exports = replaceYoutubeURL;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"./migrateOldStyleYoutubeURL":170}],176:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Messenger = require('../Messenger');

// iframeの高さがdocument.body.heightになるようメッセージを送る
// OperaのJSON.stringifyがバグってるので，ここで吸収 詳しくはRedmineのチケット615参照
// Operaのバグが直ったら*1は消してよい
var sendResizeRequest = function sendResizeRequest() {
    Messenger.send('resize', { // TODO: requireする
        height: $(document.body).height() * 1
    });
};

module.exports = sendResizeRequest;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Messenger":152}],177:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var _ = require('underscore');
var Browser = require('../Base/Browser');

var setupTipsy = function setupTipsy() {
    // touchデバイスでは一度タップしないとtipsy出ない，使い勝手下がるのでtipsy無効化
    if (Browser.isTouch) return;

    if (!$.fn.tipsy) return;

    //  n
    // w e
    //  s

    var rules = {
        left: 'e',
        right: 'w',
        bottom: 'n',
        top: 's',
        northwest: 'nw',
        southwest: 'sw',
        northeast: 'ne',
        southeast: 'se'
    };
    var $body = $(document.body);

    for (var rule in rules) if (rules.hasOwnProperty(rule)) {
        var selector = '.tipsy-' + rule;
        var gravity = rules[rule];

        $body.tipsy({
            gravity: gravity,
            fade: false,
            opacity: 1.0,
            live: selector
        });
    }
};

module.exports = setupTipsy;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Browser":31,"underscore":4}],178:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);

var ShortenText = function ShortenText($el, options) {
    this.options = $.extend({
        symbol: '...',
        reduce: 1
    }, options);

    this.$el = $el;
    this.$el.css({ overflow: 'hidden' });
};

ShortenText.prototype = {
    // original_textを設定する
    init: function init(original_text) {
        this.original_text = original_text;
    },

    // テキストをいい感じに省略する
    execute: function execute() {
        var options = this.options;
        var text = this.original_text;
        var $el = this.$el;

        // append invisible clone
        var $clone = $el.clone();
        $clone.attr('id', '').css({
            display: 'none',
            position: 'absolute',
            overflow: 'visible',
            width: $el.css('width'),
            height: 'auto'
        }).text(text);

        $el.after($clone);

        // shorten text
        var result,
            rawText = text,
            shortened = text;
        if ($clone.height() > $el.height()) {
            while (rawText.length > 0 && $clone.height() > $el.height()) {
                result = this._shorten(rawText);
                rawText = result[0];shortened = result[1];
                $clone.text(shortened);
            }
        }
        $el.text(shortened);
        $clone.remove();
    },

    // 1文字ずつ小さくしていく便利関数
    _shorten: function _shorten(text) {
        var rawText, shortened;
        var options = this.options;

        shortened = [text.slice(0, Math.floor((text.length - options.reduce) / 2)), options.symbol, text.slice(Math.floor((text.length - options.reduce) / 2) + options.reduce, text.length)];
        rawText = shortened[0] + shortened[2];
        shortened = shortened[0] + shortened[1] + shortened[2];

        return [rawText, shortened];
    }
};

module.exports = ShortenText;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{}],179:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Window = require('../Base/Window');

var showFlashMessage = function showFlashMessage(message) {
    var $container = $('<div class="hatena-globalheader-window message">' + '<div class="message">' + message + '</div>' + '</div>').css({
        width: 200,
        height: 'auto',
        right: 'auto',
        left: ($(window).width() - 200) / 2
    }).appendTo(document.body);

    Window.show($container, {
        destroy: function destroy() {
            $container.remove();
        }
    });
};

module.exports = showFlashMessage;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/Window":49}],180:[function(require,module,exports){
(function (global){
'use strict';

var $ = (typeof window !== "undefined" ? window['$'] : typeof global !== "undefined" ? global['$'] : null);
var Locale = require('../Locale');
// var Star          = require('../Star');  // TODO: Hatena.StarのCommonJSラッパー
var loadNicknames = require('./loadNicknames');
var MathJaxLoader = require('../Base/MathJaxLoader');

// コンテナ内のはてなスター、MathJaxをロードして書き換える
var updateDynamicPieces = function updateDynamicPieces(container) {
    container = $(container[0]);
    Locale.updateTimestamps(container[0]);
    if (Hatena.Star && Hatena.Star.WindowObserver.loaded) {
        container.find('span.hatena-star-comment-container, span.hatena-star-star-container').remove();
        Hatena.Star.EntryLoader.loadNewEntries(container[0]);
    }
    loadNicknames(container);
    MathJaxLoader.load(container);
};

module.exports = updateDynamicPieces;

}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../Base/MathJaxLoader":45,"../Locale":151,"./loadNicknames":168}],181:[function(require,module,exports){
'use strict';

/**
 * リソースのポーリングを行う
 * get_resource()が真になったら一度だけmain_fun()する
 *  一度同期的にチェックし，その後はpolling
 *
 * @param {Function} getResource - 繰り返し実行し、リソースをロードする関数
 * @param {Function} mainFun     - リソースのロード後に呼ばれる関数
 * @param {Number}   interval     - ポーリングの間隔 デフォルトは500msec
 */
var waitForResource = function waitForResource(getResource, mainFun, interval) {
    if (!interval) {
        interval = 500;
    }
    var role = function role() {
        if (getResource()) {
            mainFun();
            return true;
        }
        return false;
    };
    if (role()) {
        return;
    }
    var timer = setInterval(function () {
        if (role()) {
            clearInterval(timer);
        }
    }, interval);
};

module.exports = waitForResource;

},{}],182:[function(require,module,exports){
'use strict';

var _ = require('underscore');
window._ = _;

// window直下
window.EventEmitter = require('events').EventEmitter;
window.Messenger = require('./Messenger');
window.keyString = require('./keyString');
window.AccessLog = require('./Admin/AccessLog');
window.EditDesign = require('./Admin/EditDesign');

// Hatenaネームスペース下にライブラリをexportする
window.Hatena = _.extend(window.Hatena || {}, {
    Locale: require('./Locale'),

    // 外部ライブラリ
    // windowにexportすると何らかのJSとぶつかってたのでここに移動

    Cookie: require('js-cookie')
});

// Hatena.Diaryネームスペース
window.Hatena.Diary = _.extend(window.Hatena.Diary || {}, {
    Star: require('./Star'),
    LOG: require('./Base/Logger').LOG,
    BUG: require('./Base/Logger').BUG,
    REPORT_BUG: require('./Base/Logger').REPORT_BUG,
    data: require('./Base/globalData'),
    URLGenerator: require('./Base/URLGenerator'),
    EventTracker: require('./Base/EventTracker'),
    trackEvent: require('./Base/EventTracker').trackEvent,
    Location: require('./Base/Location'),
    extractSyntax: require('./Base/extractSyntax'),
    extractFotolifeSyntax: require('./Base/extractFotolifeSyntax'),
    AccessLog: require('./Base/AccessLog'),
    EditorConnector: require('./Base/EditorConnector'),
    Window: require('./Base/Window'),
    FixScroll: require('./Base/FixScroll'),
    LazyList: require('./Base/LazyList'),
    FormState: require('./Base/FormState'),
    Browser: require('./Base/Browser'),
    SpeedTrack: require('./Base/SpeedTrack'),
    Feedback: require('./Base/Feedback'),
    Devices: require('./Base/Devices'),
    Dropdown: require('./Base/Dropdown'),
    validationTweetLength: require('./Base/validateTweetLength'), // TODO:呼出側の名前を修正する
    setupMathJax: require('./Base/MathJaxLoader').load,
    loadGlobalHeader: require('./Base/loadGlobalHeader'),
    inheritVia: require('./Base/inheritVia'),
    setupProModal: require('./Base/setupProModal'),
    Circle: require('./Base/Circle'),
    setupTouchViewSuggest: require('./Base/setupTouchViewSuggest'),
    SocializeBox: require('./Admin/SocializeBox'),
    SubscribeButton: require('./SubscribeButton'),

    // 引用スター/ストック
    Quote: {
        PC: require('./Quote/PC'),
        Touch: require('./Quote/Touch')
    },

    // Adminドメイン専用
    Backup: require('./Admin/Backup'),
    BlogPermission: require('./Admin/BlogPermission'),
    ImportProgressBar: require('./Admin/Import/ProgressBar'),

    Blogs: require('./Blogs'),

    // BlogsTouchドメイン専用
    BlogsTouch: {
        Entry: require('./BlogsTouch/Entry')
    },

    // コントローラ
    Pages: require('./Base/Pages'),
    Controllers: require('./Controllers'),

    // static/jsから参照しているコントローラ置き場
    // 依存解消したら消したい
    Ctrl: {
        DesignDetail: require('./Controllers/Admin/User/Blog/Config/design-detail'),
        GlobalHeaderPage: require('./Controllers/Admin/globalheader')
    }
});

// Hatena.Diary.Utilネームスペース
window.Hatena.Diary.Util = _.extend(window.Hatena.Diary.Util || {}, {
    decodeParam: require('./Util/decodeParam'),
    canonicalizeColor: require('./Util/canonicalizeColor'),
    extend: require('./Util/extend'),
    backupTab: require('./Util/backupTab'),
    waitForResource: require('./Util/waitForResource'),
    loadNicknames: require('./Util/loadNicknames'),
    updateDynamicPieces: require('./Util/updateDynamicPieces'),
    positionToPositionString: require('./Util/positionToString'),
    preventDuplicateSubmit: require('./Util/preventDuplicateSubmit'),
    setupTipsy: require('./Util/setupTipsy'),
    locationWithParam: require('./Util/locationWithParam'),
    migrateOldStyleYoutubeURL: require('./Util/migrateOldStyleYoutubeURL'),
    replaceYoutubeURL: require('./Util/replaceYoutubeURL'),
    showFlashMessage: require('./Util/showFlashMessage'),
    initScrollFollowedElement: require('./Util/initScrollFollowedElement'),
    parseW3CDTF: require('./Util/parseW3CDTF'),
    loadImages: require('./Util/loadImages'),
    needComrule2013: require('./Util/needComrule2013'),
    sendResizeRequest: require('./Util/sendResizeRequest')
});

// jQuery plugins
require('./jQuery/jquery.hashchange.js'); // choさん版jquery.hashchange

},{"./Admin/AccessLog":5,"./Admin/Backup":10,"./Admin/BlogPermission":11,"./Admin/EditDesign":26,"./Admin/Import/ProgressBar":27,"./Admin/SocializeBox":29,"./Base/AccessLog":30,"./Base/Browser":31,"./Base/Circle":32,"./Base/Devices":33,"./Base/Dropdown":35,"./Base/EditorConnector":36,"./Base/EventTracker":37,"./Base/Feedback":38,"./Base/FixScroll":39,"./Base/FormState":40,"./Base/LazyList":42,"./Base/Location":43,"./Base/Logger":44,"./Base/MathJaxLoader":45,"./Base/Pages":46,"./Base/SpeedTrack":47,"./Base/URLGenerator":48,"./Base/Window":49,"./Base/extractFotolifeSyntax":50,"./Base/extractSyntax":51,"./Base/globalData":52,"./Base/inheritVia":53,"./Base/loadGlobalHeader":54,"./Base/setupProModal":55,"./Base/setupTouchViewSuggest":56,"./Base/validateTweetLength":57,"./Blogs":66,"./BlogsTouch/Entry":71,"./Controllers":114,"./Controllers/Admin/User/Blog/Config/design-detail":91,"./Controllers/Admin/globalheader":110,"./Locale":151,"./Messenger":152,"./Quote/PC":153,"./Quote/Touch":154,"./Star":155,"./SubscribeButton":159,"./Util/backupTab":160,"./Util/canonicalizeColor":161,"./Util/decodeParam":162,"./Util/extend":163,"./Util/initScrollFollowedElement":166,"./Util/loadImages":167,"./Util/loadNicknames":168,"./Util/locationWithParam":169,"./Util/migrateOldStyleYoutubeURL":170,"./Util/needComrule2013":171,"./Util/parseW3CDTF":172,"./Util/positionToString":173,"./Util/preventDuplicateSubmit":174,"./Util/replaceYoutubeURL":175,"./Util/sendResizeRequest":176,"./Util/setupTipsy":177,"./Util/showFlashMessage":179,"./Util/updateDynamicPieces":180,"./Util/waitForResource":181,"./jQuery/jquery.hashchange.js":183,"./keyString":184,"events":1,"js-cookie":2,"underscore":4}],183:[function(require,module,exports){
(function ($) {
    var last = location.hash;

    $.fn.hashchange = function (fun) {
        if (fun) {
            arguments.callee.setup.apply(this);
            return this.bind('hashchange', fun);
        } else {
            return this.trigger('hashchange');
        }
    };

    var setuped;
    $.fn.hashchange.setup = function () {
        if (setuped) return;setuped = true;
        var self = this;
        (function () {
            if (location.hash != last) {
                self.trigger('hashchange');
            }
            setTimeout(arguments.callee, 500);
        })();
    };

    $(window).hashchange(function () {
        last = location.hash;
    });
})(jQuery);

},{}],184:[function(require,module,exports){
'use strict';

var table1 = { 9: "TAB", 27: "ESC", 33: "PageUp", 34: "PageDown", 35: "End", 36: "Home", 37: "Left", 38: "Up", 39: "Right", 40: "Down", 45: "Insert", 46: "Delete", 112: "F1", 113: "F2", 114: "F3", 115: "F4", 116: "F5", 117: "F6", 118: "F7", 119: "F8", 120: "F9", 121: "F10", 122: "F11", 123: "F12" };
var table2 = { 8: "BS", 9: "TAB", 16: "", 17: "", 18: "", 27: "ESC", 13: "RET", 32: "SPC", 224: "" };

function keyString(e) {
	var ret = '';
	if (e.ctrlKey) ret += 'C-';
	if (e.altKey) ret += 'M-';
	if (e.metaKey) ret += 'W-';
	if (e.which === 0) {
		if (e.shiftKey) ret += 'S-';
		ret += table1[e.keyCode];
	} else {
		var key = table2[e.which];
		if (typeof key == "string") {
			if (e.shiftKey) ret += 'S-';
			ret += key;
		} else {
			if (e.ctrlKey && e.which <= 26) {
				e.which += 64;
			}
			if (65 <= e.which && e.which <= 90 || 97 <= e.which && e.which <= 122) {
				ret += String.fromCharCode(e.which)[e.shiftKey ? 'toUpperCase' : 'toLowerCase']();
			} else {
				if (e.keyCode && e.shiftKey) ret += 'S-';
				ret += String.fromCharCode(e.which);
			}
		}
	}
	return ret;
}

module.exports = keyString;

// Usage (with jQuery):
// var keyConfig = {
//     'M-1' : function () {},
//     'M-2' : function () {},
//     'M-3' : function () {},
//     'M-4' : function () {},
//     'M-0' : function () {},
//     '.'   : function () {},
//     'ESC' : function () {},
// };
// $(window).keydown(function (e) {
//     if (!e.altKey) return;
//     var key = keyString(e);
//     var handler = keyConfig[key];
//     handler && handler();
// });
// $(window).keypress(function (e) {
//     var key = keyString(e);
//     var handler = keyConfig[key];
//     handler && handler();
// });
//

},{}]},{},[182]);

(function($){

if (!window.Hatena) window.Hatena = {};
if (!Hatena.Diary) Hatena.Diary = {};

// グローバルヘッダ固定時にid指定のリンクを踏むとターゲットの要素がグローバルヘッダに隠れる問題の対応
// スクロール終わったあと，グローバルヘッダ分スクロールをちょっと戻す
// 他のJSがイベント見てるとかでスクロール位置変わらないこともあるので
// しばらくして変化なければあきらめる
var setupScrollAdjustForFixedGlobalHeader = function() {
    var $header = $('#globalheader-container');
    if ($header.css('position') !== 'fixed') return;

    var headerHeight = $('#globalheader-container').height();
    var $document = $(document);

    $document.on('click', 'a[href^="#"]', function() {
        var positionBefore = $document.scrollTop();
        var checkCount = 0;
        var check = function() {
            if ($document.scrollTop() !== positionBefore) {
                window.scrollBy(0, -headerHeight);
            } else if (checkCount++ < 10) {
                setTimeout(check, 0);
            }
        };
        setTimeout(check, 0);
    });
};

// スマートフォンアプリから使うエンドポイントです
Hatena.Diary.AppAPI = {
    _setup: function () {
        if (this._reloadStarImplement) return;

        // 1秒に1回までしか実行しない
        this._reloadStarImplement = _.throttle(function () {
            // スターを再読み込みする
            var $body          = $(document.body);
            var $starContainer = $body.find('span.hatena-star-comment-container, span.hatena-star-star-container');

            if ($starContainer.length > 0) {
                $starContainer.remove();
                Hatena.Star.EntryLoader.loadNewEntries($body[0]);
            }
        }, 1000);
    },
    reloadStar: function () {
        this._setup();
        this._reloadStarImplement();
    }
};

$(function() {
    if (arguments.callee.called) return; arguments.callee.called = true;


    Hatena.Diary.Pages.setControllers(Hatena.Diary.Controllers);
    Hatena.Diary.Pages.loadPage();

    Hatena.Diary.EventTracker.setupTrack();

    Hatena.Diary.Util.setupTipsy();

    setupScrollAdjustForFixedGlobalHeader();

    if (window != window.parent) {
        // クリックジャッキング対策
        //   iframe で読みこまれて・そのままクリックして送信されてしまうのが問題なので
        //   iframe の中で読みこまれたときは、submit 時に値の変更チェックをして、変更されてないなら submit できないようにする
        $('form').each(function () {
            var $this    = $(this);

            // リスクを承知で、あるいは別の手段によってクリックジャッキング対策が施されており、
            // なおかつ、クリックジャッキング対策の実装が衝突する場合に迂回することができる
            if ($this.attr('data-pass-through-click-jacking-validation')) return;

            var $buttons = $this.find('input[type=submit][name!=delete][name!=draft]');
            var $delete_button = $this.find('input[type=submit][name=delete], input[type=submit][name=draft]');
            var disable = function() {
                $this.addClass('unedited');
                $buttons.attr('disabled', 'disabled');
            };
            var enable = function() {
                $this.removeClass('unedited');
                $buttons.removeAttr('disabled');
            };
            var serialize = function($form) {
                return $({
                    elements: $form.find(':input:not([data-ignore-click-jacking])')
                }).serialize();
            };

            disable();
            $delete_button.attr('disabled', 'disabled');
            var init = serialize($this);
            var timer = setInterval(function () {
                $delete_button.removeAttr('disabled');
                if (init != serialize($this)) {
                    clearInterval(timer);
                    enable();
                }
            }, 1500);
        });
    }

});

// adminドメインで発生したエラーをサーバーサイドに送信する
// ユーザーブログではブログパーツなど貼られていることがあるので何もしない
if (Hatena.Diary.Location.domainType() === Hatena.Diary.Location.Admin) {
    window.onerror = _.once(function (message, url, line) {
        Hatena.Diary.BUG(message + " at line " + line, "window.onerror");
    });
}

})(jQuery);

(function($){

    Hatena.Diary.EditorAdmin = {
        id : 'hatena-diary-edit-in-place',

        showEditInPlace : function (entry, opts) {
            var editinplace = document.getElementById(Hatena.Diary.EditorAdmin.id);
            if (editinplace) {
                editinplace.parentNode.removeChild(editinplace);
            }

            var $container = $(
                '<div class="hatena-iframe-container">' +
                    '<div class="loading"><img src="' + Hatena.Diary.URLGenerator.static_url('/images/loading.gif') + '" alt=""/>' + Hatena.Locale.text('loading') + '</div>' +
                    '</div>').
                attr({
                    id: Hatena.Diary.EditorAdmin.id
                }).
                hide().
                appendTo(document.body);

            var iframe = $('<iframe frameborder="0"></iframe>').appendTo($container);

            var loading = $container.find('.loading').hide().click(function () {
                return false;
            });

            setTimeout(function () {
                loading.show();
            }, 250);

            var CONTAINER_MARGIN = 27;

            var resizeContainer = function() {
                $container.css({
                    width  : $(window).width() - (CONTAINER_MARGIN * 2),
                    height : $(window).height() - (CONTAINER_MARGIN * 2),
                    left: CONTAINER_MARGIN
                });
            };

            resizeContainer();
            $(window).resize(_.throttle(function() {
                resizeContainer();
            }, 100));

            editinplace = iframe[0];

            var uri = Hatena.Diary.data('admin-domain') +
                '/' + Hatena.Diary.data('author') + '/' + Hatena.Diary.data('blog') + '/edit?' +
                'editinplace=1';

            if (entry) uri += '&entry=' + encodeURIComponent(entry.attr('data-uuid'));
            if (opts.title) uri += '&title=' + encodeURIComponent(opts.title);
            if (opts.body)  uri += '&body='  + encodeURIComponent(opts.body);

            var updated;
            var messenger = Messenger.createForFrame(editinplace, uri);

            var closeContainerWindow = function () {
                // youtubeのiframeを削除せずに閉じると、IE11で表示が壊れる #8762
                $container.find('iframe').remove();
                Hatena.Diary.Window.hide($container);
            };

            var onClose = function () {
                if (updated && !confirm(Hatena.Locale.text('form.confirm.changed'))) {
                    return false; // 編集画面を閉じるイベントをキャンセルする
                } else {
                    closeContainerWindow();
                    messenger.send('close-preview-window'); // 新窓プレビューを閉じる
                }
            };
            messenger.addEventListener('close', onClose);

            messenger.addEventListener('ready', function () {
                loading.remove();
            });
            messenger.addEventListener('update', function (data) {
                messenger.removeEventListener('close', onClose);
                messenger.addEventListener('close', closeContainerWindow); // submitされたらconfirmを出す必要はない
                opts.update(data);
            });

            messenger.addEventListener('change', function (_updated) {
                updated = !!_updated;
            });

            Hatena.Diary.Window.show($container, {
                closeExplicitly: true,
                destroy : function () {
                    iframe.remove();
                    messenger.destroy();
                },
                fixScroll: true
            });

        }
    };

    Hatena.Diary.Pages.Admin['*'] = function () {
        Hatena.Locale.setupTimestampUpdater();

        Hatena.Diary.Pages.Blogs['*'].prepareForGlobalHeader();

        Hatena.Diary.setupTouchViewSuggest();

        $('.js-admin-menu-myblog-btn').click(function() {
            var $blog_list = $('.js-admin-menu-myblog-list');

            if ($blog_list.size() === 0) {
                return true;
            }

            if ($blog_list.is(":visible") === false) {
                $blog_list.show();
            } else {
                $blog_list.hide();
            }
            return false;
        });

        $(document).click(function(e) {
            var $blog_list = $(".js-admin-menu-myblog-list");
            if (!$.contains($blog_list, e.target)) {
                $blog_list.hide();
            }
        });
        Hatena.Diary.Pages.Admin['*'].setupSubscribeBadge();

        prepareForGlobalHeader();
    };

    /**
     * グローバルヘッダにブログ管理画面へのドロップダウンを表示する
     */
    var prepareForGlobalHeader = function () {
        if (window != window.parent) return null;
        if (!Messenger.messenger) return null;

        // ブログ情報を入手
        var blogUri  = Hatena.Diary.data('blogs-uri-base');
        var blogName = Hatena.Diary.data('blog-name');
        var blogIsPublic = Hatena.Diary.data('blog-is-public');
        if (!(blogUri && blogName)) { return; }

        // adminトップページがメインブログに紐付いてしまうのを阻止
        if (Hatena.Diary.data('page') === 'index') { return; }

        // グローバルヘッダにブログ情報を送信
        Hatena.Diary.Pages.infoLoaded.then(function () {
            Messenger.send('showBlogInfo', {
                blogName     : blogName,
                blogUri      : blogUri,
                blogIsPublic : blogIsPublic,
            });
        });

        // メッセージを受け取ってドロップダウンを表示する
        Messenger.addEventListener('blogmenuAdmin', function (data) {
            var params = {
                blog      : data.blogUri,
                isEditing : (Hatena.Diary.data('page') == 'user-blog-edit') ? 1 : 0,
            };

            var uri = '/-/menu/blogmenu_admin?' + $.param(params);
            Hatena.Diary.Dropdown.toggle(uri, data, 'blogmenu');
        });
    };

    Hatena.Diary.Pages.Admin['*'].setupSubscribeBadge = function () {
        if (window != window.parent) return null;  // globalheaderからはロードしない

        var unread_url = Hatena.Diary.data('admin-domain').replace(/https?\:/, '') + '/api/recent_subscribing';
        $.ajax({
            url      : unread_url,
            type     : 'get',
            cache    : false,
            dataType : 'json'
        }).done(function (res) {
            if (res && res.count) {
                var count = +res.count;
                if (count === 0) { return; }

                var badge = $('.badge-subscribe').addClass('visible');

                if (count > 20) {
                    badge.text('20+');    // 未読件数が21件以上の時は省略表示
                }
                else {
                    badge.text(res.count);
                }
            }
        });
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Admin['feedback-iframe'] = function () {
        Messenger.listenToParent();

        $('.close').on('click', function (e) {
            Messenger.send('close', { name : window.name });
            return false;
        });

        $('#button-feedback').on('click', function (e) {
            $('.js-show-on-send-feedback').show();
            $('#body').focus();
            $('.js-hide-on-send-feedback').hide();
            Hatena.Diary.Util.sendResizeRequest();
        });

        if(!!Hatena.Diary.Location.param('thankyou')){
            setTimeout(function () {
                $('#button-close').click();
            }, 3000);
        }

    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Admin['invite-new'] = function () {
        Hatena.Locale.setupTimestampUpdater();
    };

})(jQuery);
(function($){

    Hatena.Diary.Pages.Admin['register'] = function () {
        if (!Hatena.Diary.data('name')) return; // guest

        var dispatcher = Hatena.Diary.Pages.Admin['register'];
        dispatcher.submitButton = $('input[type=submit]');

        var $domain = $(':input[name="domain"]');
        var $blogIdInput = $('input[name="id"]');
        var requestThreshold = 1000;
        dispatcher.STATES = {
            progress: {
                className: 'progress',
                message: $('.domain-check-message.progress')
            },
            available: {
                className: 'check',
                message: $('.domain-check-message.check')
            },
            unavailable: {
                className: 'error',
                message: $('.domain-check-message.error')
            },
            invalid: {
                className: 'invalid',
                message: $('.domain-check-message.invalid')
            },
            invalidLength: {
                className: 'invalid-length',
                message: $('.domain-check-message.invalid-length')
            }
        };

        // このStateを見てsubmitButtonの有効化無効化を行う
        dispatcher.inputValidStates = {
            "id" : true,
            "import" : true
        };

        var fetchBlogIdAvailability = function () {
            var blogID = $blogIdInput.val();
            var topdomain = $domain.val();

            if ( ! blogID ) {
                return;
            } else if (blogID.length < 2 || blogID.length > 32) {
                Hatena.Diary.Pages.Admin['register'].changeAvailabilityState({
                    nextState: 'invalidLength'
                });
                return;
            } else if (! /^[a-zA-Z0-9][a-zA-Z0-9\-]+$/.test(blogID)) {
                Hatena.Diary.Pages.Admin['register'].changeAvailabilityState({
                    nextState: 'invalid'
                });
                return;
            }

            var brand_name = $('[data-brand-name]').attr('data-brand-name');
            $.ajax({
                url: '/api/blog/domain_registry',
                dataType: 'json',
                data: {
                    blog_ids: JSON.stringify([blogID]),
                    brand_name: brand_name
                }
            }).done(function (data) {
                var domain_statuses = data[blogID];

                if (domain_statuses !== undefined) {
                    dispatcher.checkBlogIdAvailability({
                        blogID: blogID,
                        topdomain: topdomain,
                        statuses: domain_statuses
                    });
                }
            });
        };

        fetchBlogIdAvailability();

        $domain.change(fetchBlogIdAvailability);
        $blogIdInput.
            keyup(_.debounce(fetchBlogIdAvailability, requestThreshold)).
            keyup(function () {
                dispatcher.changeAvailabilityState({
                    nextState: 'progress'
                });
            });

        var fillinDefault = function() {
            var user_name = Hatena.Diary.data('name').toLowerCase().replace(/_/, '-');
            var brand_name = $('[data-brand-name]').attr('data-brand-name');
            $.ajax({
                url: '/api/blog/domain_registry',
                dataType: 'json',
                data: {
                    blog_ids: JSON.stringify([user_name]),
                    brand_name: brand_name
                }
            }).done(function (data) {
                var domain_statuses = data[user_name];

                if (typeof domain_statuses === 'undefined' || typeof domain_statuses === null) {
                    domain_statuses = {};
                }

                var available_domains = Hatena.Diary.Pages.Admin['register'].availableDomains(domain_statuses);

                if (_.any(available_domains)) {
                    var $domain = $(':input[name="domain"]');
                    var current_domain = $domain.val();
                    if (! _.include(available_domains, current_domain)) {
                        $domain.val(available_domains[0]);
                    }

                    var idInput = $('input[name=id]');
                    if (idInput.val() === '') {
                        // idが空のときuser名からフィルイン
                        idInput.val(user_name);
                        Hatena.Diary.Pages.Admin['register'].changeAvailabilityState({
                            nextState: 'available'
                        });
                    }
                }
            });
        };

        fillinDefault();

        if ($('input[name=import]').length) {
            $('input[name=permission],input[name=import]').change(function () {
                dispatcher.changeImportAvailabilityState();
            });
            $('.import-error').hide();
            dispatcher.changeImportAvailabilityState();
        }
    };

    Hatena.Diary.Pages.Admin['register'].changeAvailabilityState = function (args) {
        var dispatcher = Hatena.Diary.Pages.Admin['register'];
        var nextState = args.nextState;

        if (nextState == 'unavailable' || nextState == 'invalid' || nextState == 'invalidLength') {
            dispatcher.inputValidStates['id'] = false;
        }
        else {
            dispatcher.inputValidStates['id'] = true;
        }
        dispatcher.changeSubmitButtonState();

        _.each(Hatena.Diary.Pages.Admin['register'].STATES, function (value, key) {
            if (key === nextState) {
                value.message.show();
            } else {
                value.message.hide();
            }
        });
    };

    Hatena.Diary.Pages.Admin['register'].checkBlogIdAvailability = function (args) {
        var topdomain = args.topdomain;
        var blogID    = args.blogID;
        var statuses  = args.statuses;

        var inputState = statuses[topdomain];
        var availableDomains = Hatena.Diary.Pages.Admin['register'].availableDomains(statuses);

        if (inputState === 'unavailable' && _.any(availableDomains)) {
            Hatena.Diary.Pages.Admin['register'].suggestAlternativeDomainNames({
                blogID: blogID,
                availableDomains: availableDomains
            });
        }

        Hatena.Diary.Pages.Admin['register'].changeAvailabilityState({
            nextState: inputState
        });
    };

    Hatena.Diary.Pages.Admin['register'].suggestAlternativeDomainNames = function (args) {
        var blogID = args.blogID;
        var availableDomains = args.availableDomains;
        var $message = $('.domain-recommend');
        var $domain = $(':input[name="domain"]');

        $('.requested-blog-id').text(blogID);

        $message.find('ul').detach();
        var $alternatives = $('<ul/>');
        _.each(availableDomains, function (domain) {
            $('<li/>').
                text(blogID + '.' + domain).
                click(function () { $domain.val(domain).change() }).
                appendTo($alternatives);
        });
        $message.append($alternatives).show();
    };

    // domain_statuses = {
    //   $domain: 'available' || 'unavailable' || 'invalid'
    //   ...
    // }
    Hatena.Diary.Pages.Admin['register'].availableDomains = function (domain_statuses) {
        var domains = _.keys(domain_statuses);
        var availableDomains = _.select(domains, function (domain) { return domain_statuses[domain] === 'available'; });

        return availableDomains;
    };

    Hatena.Diary.Pages.Admin['register'].changeImportAvailabilityState = function (args) {
        var dispatcher = Hatena.Diary.Pages.Admin['register'];

        var $checkedPermission = $('input[name=permission]:checked');
        var $selectedImport    = $('input[name=import]:checked');

        var blogPermission  = $checkedPermission.val();
        var diaryPermission = $selectedImport.attr('data-permission');

        var $errorMessage = $('.import-error');
        if (diaryPermission == 'private' && blogPermission == 'public') {
            $errorMessage.show();
            dispatcher.inputValidStates['import'] = false;
            dispatcher.changeSubmitButtonState();
        }
        else {
            $errorMessage.hide();
            dispatcher.inputValidStates['import'] = true;
            dispatcher.changeSubmitButtonState();
        }
    };

    Hatena.Diary.Pages.Admin['register'].changeSubmitButtonState = function (args) {
        var dispatcher = Hatena.Diary.Pages.Admin['register'];
        var submitButton = dispatcher.submitButton;

        var shouldEnabled = _.every(dispatcher.inputValidStates, function (valid) {
            return valid;
        });

        if (shouldEnabled) {
            submitButton.attr('disabled', false);
            submitButton.removeClass('disabled');
            submitButton.addClass('btn-blue');
        }
        else {
            submitButton.attr('disabled', true);
            submitButton.removeClass('btn-blue');
            submitButton.addClass('disabled');
        }
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Admin['register-iframe'] = function () {
        if (!Hatena.Diary.data('name')) return; // guest

        var fillinDefault = function() {
            var user_name = Hatena.Diary.data('name').toLowerCase().replace(/_/, '-');
            var idInput = $('input[name=id]');
            if (idInput.val() === '') {
                // idが空のときuser名からフィルイン
                idInput.val(user_name);
            }
        };

        fillinDefault();
    };

})(jQuery);
(function($){

    Hatena.Diary.Pages.Admin['store-theme-new'] = function () {
        var $availableLicenses = $('.available-licenses');
        var $showAvailableLicenses = $('.show-more').find('a');
        var expandAvailableLicenses = function () {
            $availableLicenses.show();
            $availableLicenses.attr('data-collapsed', 0);
            $showAvailableLicenses.text($showAvailableLicenses.attr('data-collapse-message'));
        };
        var collapseAvailableLicenses = function () {
            $availableLicenses.hide();
            $availableLicenses.attr('data-collapsed', 1);
            $showAvailableLicenses.text($showAvailableLicenses.attr('data-expand-message'));
        };

        $availableLicenses.hide();

        $showAvailableLicenses.on('click', function (e) {
            if ($availableLicenses.attr('data-collapsed') === '1') {
                expandAvailableLicenses();
            } else {
                collapseAvailableLicenses();
            }
            e.preventDefault();
        });

        $('.deed').hide();
        $('.show-deed').on('click', function (e) {
            $($(this).attr('data-target-selector')).toggle();
            return false;
        });

        // 選択してるやつが隠れてたら見せる
        if ($('input[name=license]:checked').is(':visible') === false) {
            $showAvailableLicenses.click();
        }
    };

})(jQuery);
(function($){

    Hatena.Diary.Pages.Admin['store-theme-theme_id'] = function () {
        if (Hatena.Star) {
            Hatena.Star.SiteConfig = {
                entryNodes: {
                    '#container' : {
                        uri: 'a.permalink',
                        title: 'h1.theme-name',
                        container: '.star-container'
                    }
                }
            };
        }

        var self = Hatena.Diary.Pages.Admin['store-theme-theme_id'];
        self.$themeContainer = $('#store-container');
        self.$installDialog = $('.blog-title-dropdown-window');
        self.$installButton = $('#sidebar').find('.install-theme-btn');

        self.$installDialog.hide();
        self.$installButton.click(function () {
            self.$installDialog.slideToggle();
        });

        $('#theme-detail-tabs').tabs({ active : 0});
    };

})(jQuery);
(function($){
    // コレクション(Entries, Categories)のインスタンスはページ内に高々1つしか存在せず，Collectionsから参照できる．
    // 個々のModelから参照したいときはここから呼べる．
    // コレクションと明らかに一対一で対応するものはコンストラクタで渡すべき(たとえばEntriesViewのコンストラクタにはentriesを渡す)
    var Collections = {
        entries: null,
        categories: null
    };
    // エントリ1つを表すオブジェクト
    var Entry = function(data){
        this.data = data;
    };
    Entry.prototype = {
        // 表示用のデータ
        getUUID: function() {
            return this.data.uuid;
        },
        getURL: function() {
            return this.data.url;
        },
        getEditURL: function() {
            return this.data.edit_url;
        },
        getTitle: function() {
            return this.data.title;
        },
        getSummary: function() {
            return this.data.summary;
        },
        getCreated: function() {
            return this.data.created;
        },
        getCreatedTime: function() {
            // epoch * 1000
            return this.getCreatedDate().getTime();
        },
        getCreatedDate: function() {
            return Hatena.Diary.Util.parseW3CDTF(this.data.created);
        },

        // datetimeはnullの場合があるので注意
        getDatetime: function() {
            return this.data.datetime;
        },
        getDatetimeTime: function() {
            // epoch * 1000
            var date = this.getDatetimeDate();

            if (date) {
                return date.getTime();
            } else {
                return null;
            }
        },
        getDatetimeDate: function() {
            return Hatena.Diary.Util.parseW3CDTF(this.data.datetime);
        },

        getAuthorName: function() {
            return this.data.author_name;
        },
        getCommentCount: function() {
            return this.data.comment_count;
        },
        getCategories: function() {
            return this.data.categories;
        },
        isPublic: function() {
            return this.data.is_public;
        },
        isScheduledEntry: function() {
            return this.data.is_scheduled_entry;
        },

        // 操作系
        select: function() {
            this.data.isSelected = true;
            $(this).triggerHandler('change');
        },
        unselect: function() {
            this.data.isSelected = false;
            $(this).triggerHandler('change');
        },
        isSelected: function() {
            return this.data.isSelected;
        },
        // このエントリを画面から消す
        // DBから消されるわけではない
        remove: function() {
            $(this).triggerHandler('remove');
        },
        // カテゴリを追加する
        addCategory: function(category_name) {
            if (_.contains(this.data.categories, category_name)) return;
            if (!this.data.categories) {
                this.data.categories = [];
            }
            this.data.categories.push(category_name);
            $(this).triggerHandler('change');
        },
        // 記事を編集できるかどうか
        canBeManageEntry: function() {
          return this.data.can_be_manage_entry;
        },
        // 下書きプレビューtoken作れるかどうか
        canCreateDraftPreviewToken : function () {
          return this.data.can_create_draft_preview_token;
        }
    };

    var EntryView = function(entry) {
        var self = this;
        self.entry = entry;

        self.rootTemplate = _.template($('.js-entry-root-template').html().replace(/^\s*/, '').replace(/\s*$/, ''));
        self.elementTemplate = _.template($('.js-entry-inner-template').html());

        self.render();
        $(self.entry).on('change', function() {
            self.render();
        }).on('remove', function() {
            self.remove();
        });
        self.$element.on('change', 'input', function() {
            var $input = $(this);
            if ($input.is(':checked')) {
                self.entry.select();
            } else {
                self.entry.unselect();
            }
            $(self.entry).triggerHandler('select');
        });
    };
    EntryView.prototype = {
        render: function() {
            // $elementは一度だけ作り，以後は最初に作った$elementの内容を更新する．
            if (!this.$element) {
                this.$element = $($.parseHTML(this.rootTemplate({entry: this.entry})));
            }

            this.$element.html(this.elementTemplate({entry: this.entry}));
            // 検索キーワード指定されていたらハイライトする
            if (Collections.entries && Collections.entries.getKeyword()) {
                var escapedKeyword = _.escape(Collections.entries.getKeyword());

                this.$element.find('.js-search-entry-title').html(function (i, html) {
                    return html.split(escapedKeyword).join('<span class="entry-search-keyword">' + escapedKeyword+ '</span>');
                });

                this.$element.find('.js-search-entry-body').html(function (i, html) {
                    return html.split(escapedKeyword).join('<span class="entry-search-keyword">' + escapedKeyword + '</span>');
                });
            }

            Hatena.Locale.updateTimestamps(this.$element[0]);
        },
        remove: function() {
            this.$element.remove();
        },
        getElement: function() {
            return this.$element;
        }
    };

    // エントリのコレクション，読み込み，クエリの管理
    var Entries = function() {
    };
    Entries.prototype = {
        // 指定したクエリで読み込む
        load: function() {
            var self = this;

            var data = {};
            if (self.keyword) {
                data.q = self.keyword;
            }
            if (self.category) {
                data.category = self.category;
            }

            if (self.getPermission() !== 'all') {
                data.permission = self.getPermission();
            }

            var lastEntry = _.last(self.entries);
            if (lastEntry) {
                data.until = lastEntry.getCreatedDate().getTime()/1000;
            }

            $.ajax({
                url: 'entries.json',
                data: data
            }).done(function(entries) {
                self.onLoaded(entries);
            });
        },
        onLoaded: function(data) {
            // data: { entries: [$entry], has_more: bool }
            var self = this;
            var $self = $(self);
            self.receivedEntries = [];
            self.receivedEntries = _.map(data.entries, function(entry_data) {
                return new Entry(entry_data);
            });
            $(self.receivedEntries).on('select', function() {
                $self.triggerHandler('select');
            }).on('remove', function() {
                $self.triggerHandler('remove');
            });
            if (!self.entries) self.entries = [];
            self.entries = self.entries.concat(self.receivedEntries);
            self.hasMore = data.has_more;
            $(self).triggerHandler('loaded');
        },
        // 最初から読み直す
        reset: function() {
            var self = this;
            _.each(self.entries, function(entry) {
                entry.remove();
            });
            self.entries = [];
            self.receivedEntries = [];
            self.hasMore = undefined;
            $(self).triggerHandler('reset');
            self.load();
        },
        // エントリを全て返す
        getEntries: function() {
            return this.entries;
        },
        // 最後に受信したEntryの配列を返す
        getReceivedEntries: function() {
            return this.receivedEntries;
        },
        // 続きあるかどうかを返す
        hasMoreEntries: function() {
            return this.hasMore;
        },
        // 検索キーワードを設定
        setKeyword: function(keyword) {
            this.keyword = keyword;
        },
        // 検索キーワードを返す
        getKeyword: function(keyword) {
            return this.keyword;
        },
        // 表示するカテゴリを設定
        setCategory: function(category) {
            this.category = category;
        },
        // permission: all|public|draft
        setPermission: function(permission) {
            this.permission = permission;
        },
        getPermission: function() {
            return this.permission;
        },
        getSelectedEntries: function() {
            return _.filter(this.entries, function(entry) { return entry.isSelected() });
        },
        // チェックをつけたエントリを削除
        // 操作が完了したらresolveするdeferredを返す
        deleteSelectedEntries: function() {
            var self = this;
            var entries_to_delete = self.getSelectedEntries();
            if (!entries_to_delete.length) return;

            var deleted = $.ajax({
                type: 'post',
                url: 'entries.delete.json',
                data: {
                    entry: _.map(entries_to_delete, function(entry) { return entry.getUUID() }),
                    rkm: Hatena.Diary.data('rkm'),
                    rkc: Hatena.Diary.data('rkc')
                },
                traditional: true
            });
            deleted.done(function() {
                self.entries = _.difference(self.entries, entries_to_delete);
                _.each(entries_to_delete, function(entry) {
                    entry.remove();
                });
            });
            return deleted;
        },
        // チェックをつけたエントリにカテゴリを追加
        // 操作が完了したらresolveするdeferredを返す
        addCategoryToSelectedEntries: function(category_name) {
            var self = this;
            var entries_to_add_category = self.getSelectedEntries();
            if (!entries_to_add_category.length) return;

            _.each(entries_to_add_category, function(entry) {
                entry.addCategory(category_name);
            });

            var categoryAdded = $.ajax({
                type: 'post',
                url: 'entries.add_category.json',
                data: {
                    entry: _.map(entries_to_add_category, function(entry) { return entry.getUUID() }),
                    category: category_name,
                    rkm: Hatena.Diary.data('rkm'),
                    rkc: Hatena.Diary.data('rkc')
                },
                traditional: true
            });
            return categoryAdded;
        }
    };

    var EntriesView = function(entries) {
        var self = this;
        self.entries = entries;
        var $entries = $(entries);

        self.$entriesContainer = $('.js-entries-container');

        self.$loadNextPage = $('.js-load-next-page');

        $entries.on('loaded', function() {
            self.render();
        });
        $entries.on('select remove', function() {
            self.renderButtons();
        });
        var $form = $('.js-entry-search-form');
        $('.js-categories-selector').on('change', function(event) {
            entries.setKeyword($form.find(':input[name="q"]').val());
            entries.setCategory($form.find(':input[name="category"]').val());
            entries.reset();
        });
        self.$loadNextPage.on('click', function(event) {
            self.entries.load();
        });
        $('.js-delete-entries-button').on('click', function() {
            if (!confirm(Hatena.Locale.text('epic.entry.delete.confirm'))) return;
            var deleted = self.entries.deleteSelectedEntries();
            deleted.always(function() {
                Collections.categories.reload();
            });
        });

        $('.js-entry-search-form').on('submit', function(event) {
            event.preventDefault();
            entries.setKeyword($form.find(':input[name="q"]').val());
            entries.setCategory($form.find(':input[name="category"]').val());
            entries.reset();
        });

        $('.js-entry-search-box-input').on('search', function() {
            var keyword = $form.find(':input[name="q"]').val();
            if (keyword !== '') return;
            entries.setKeyword('');
            entries.reset();
        });

        $('.js-select-all-entries').on('change', function() {
            if ($(this).is(':checked')) {
                _.each(entries.getEntries(), function(entry) {
                    entry.select();
                });
            } else {
                _.each(entries.getEntries(), function(entry) {
                    entry.unselect();
                });
            }
            self.renderButtons();
        });

    };
    EntriesView.prototype = {
        render: function() {
            var self = this;
            _.each(self.entries.getReceivedEntries(), function(entry) {
                var view = new EntryView(entry);
                self.$entriesContainer.append(view.getElement());
            });

            if (self.entries.hasMoreEntries()) {
                self.$loadNextPage.show();
            } else {
                self.$loadNextPage.hide();
            }
            self.renderButtons();
            $(self).triggerHandler('rendered');
        },
        // カテゴリ追加とエントリ削除のenable / disabled, クラス追加
        // エントリをチェックしたときと，エントリが消えたときに呼ばれる
        renderButtons: function() {
            var self = this;
            var $deleteButton = $('.js-delete-entries-button');
            var $categoryButton = $('.js-category-dropdown-toggle');

            var selectedEntriesCount = self.entries.getSelectedEntries().length;
            if (selectedEntriesCount > 0) {
                $deleteButton.prop('disabled', false).removeClass('disabled').addClass('btn-danger');
                $categoryButton.prop('disabled', false).removeClass('disabled');
            } else {
                $deleteButton.prop('disabled', true).addClass('disabled').removeClass('btn-danger');
                $categoryButton.prop('disabled', true).addClass('disabled');
            }
        }
    };

    var Category = function(data) {
        this.data = data;
    };
    Category.prototype = {
        getName: function() {
            return this.data.name;
        },
        getEntriesCount: function() {
            return this.data.count;
        },
        setEntriesCount: function(count) {
            this.data.count = count;
            $(this).triggerHandler('change');
        }
    };

    // エントリにカテゴリ追加するときのview
    var CategoryAppenderView = function(category, entries) {
        var self = this;
        self.category = category;
        self.entries = entries;
        self.render();

        self.$element.on('click', function() {
            var categoryAdded = self.entries.addCategoryToSelectedEntries(self.category.getName());
            categoryAdded.always(function() {
                Collections.categories.reload();
            });
        });

        $(self.category).on('change', function() {
            self.render();
        });
    };
    CategoryAppenderView.prototype = {
        render: function() {
            if (!this.$element) {
                this.$element = $('<li>');
            }
            this.$element.text(this.category.getName() + ' (' + this.category.getEntriesCount() + ')');
        },
        getElement: function() {
            return this.$element;
        }
    };

    // しぼりこみのview
    var CategorySelectorView = function(category) {
        var self = this;
        self.category = category;
        self.render();

        $(self.category).on('change', function() {
            self.render();
        });
    };
    CategorySelectorView.prototype = {
        render: function() {
            if (!this.$element) {
                this.$element = $('<option>').val(this.category.getName());
            }
            this.$element.text(this.category.getName() + ' (' + this.category.getEntriesCount() + ')');
        },
        getElement: function() {
            return this.$element;
        }
    };

    var Categories = function() {
        var self = this;
        self.load();
    };
    Categories.prototype = {
        load: function() {
            var self = this;
            $.ajax({
                url: 'categories.json'
            }).done(function(data) {
                self.onLoaded(data);
            });
        },
        // ユーザーがカテゴリ追加した後などは読み込み直すことができる．実装としてはloadと同じ．
        reload: function() {
            this.load();
        },
        onLoaded: function(data) {
            // data = { categories: [ { name, count } ] }
            var self = this;

            if (!self.categories) {
                // はじめて受信した
                self.categories = _.map(data.categories, function(category_data) {
                    return new Category(category_data);
                });
                self.newCategories = self.categories;
            } else {
                self.newCategories = [];
                // 記事数増えたり新しいカテゴリできたりする
                _.each(data.categories, function(category_data) {
                    var category = self.getCategory(category_data.name);
                    if (category) {
                        category.setEntriesCount(category_data.count);
                    } else {
                        category = new Category(category_data);
                        self.categories.push(category);
                        self.newCategories.push(category);
                    }
                });
            }
            $(self).triggerHandler('loaded');
        },
        getNewCategories: function() {
            return this.newCategories;
        },
        getCategory: function(categoryName) {
            return _.find(this.categories, function(category) {
                return category.getName() === categoryName;
            });
        }
    };

    // カテゴリのリストに関するView
    // カテゴリのViewは2つあるのでジャグリングみたいな感じ
    var CategoriesView = function(categories, entries) {
        var self = this;
        self.categories = categories;
        self.entries = entries;
        var $categories = $(categories);
        self.$categoriesSelector = $('.js-categories-selector');
        self.$createNewCategory  = $('.js-create-new-category');

        $categories.on('loaded', function() {
            self.render();
        });

        $('.js-create-new-category').on('click', function() {
            var categoryName = window.prompt(Hatena.Locale.text('create_category'));
            if (!categoryName) return;

            var categoryAdded = self.entries.addCategoryToSelectedEntries(categoryName);
            categoryAdded.always(function() {
                self.categories.reload();
            });
        });
    };

    CategoriesView.prototype = {
        render: function() {
            var self = this;
            _.each(self.categories.getNewCategories(), function(category) {
                var selector_view = new CategorySelectorView(category);
                self.$categoriesSelector.append(selector_view.getElement());

                var appender_view = new CategoryAppenderView(category, self.entries);
                self.$createNewCategory.before(appender_view.getElement());
            });
        }
    };

    // なんか汎用的なドロップダウンに見えなくもない
    var CategoriesDropdownView = function() {
        var self = this;
        self.$dropdown = $('.js-category-dropdown-list');
        self.$dropdownToggle = $('.js-category-dropdown-toggle');

        self.$dropdownToggle.on('click', function() {
            self.toggleDropdown();
            return false;
        });
        $(document).on('click', function(event) {
            self.hideDropdown();
        });
    };
    CategoriesDropdownView.prototype = {
        toggleDropdown: function() {
            this.$dropdown.toggle();
        },
        hideDropdown: function() {
            this.$dropdown.hide();
        }
    };

    var EntryTypeTabsView = function(entries) {
        var self = this;
        self.entries = entries;
        self.$tabs = $('.js-entry-type-select-tabs');
        self.$tabs.on('click', 'a', function (event) {
            self.clicked(event);
        });

        // デフォルトのpermissionをここで設定
        self.entries.setPermission(self.$tabs.find('.ui-tabs-active').find('a').attr('data-permission'));
    };
    EntryTypeTabsView.prototype = {
        clicked: function(event) {
            var self = this;
            event.preventDefault();
            self.$tabs.find('.ui-tabs-active').removeClass('ui-tabs-active');
            $(event.target).parents('li').addClass('ui-tabs-active');
            var permission = $(event.target).attr('data-permission');
            if (self.entries.getPermission() === permission) return;
            self.entries.setPermission(permission);
            self.entries.reset();
        }
    };

    var ShareDraftBox = function (entriesView) {
        var self = this;

        // 親要素
        self.section = $('section')[0];

        self.$shareBoxWrapper = $('.js-share-draft-box-wrapper');
        self.$shareBox        = $('.js-share-draft-box');
        self.$tokenInput      = self.$shareBox.find('input');
        self.$closeButton     = self.$shareBox.find('.btn-close');
        self.$mask            = self.$shareBoxWrapper.find('.mask');

        // URLボックスの初期位置
        self.pos = {
            top  : -9999,
            left : -9999
        };

        $(entriesView).on('rendered', function () {
            self.initEvent();
        });
    };
    ShareDraftBox.prototype = {
        initEvent: function () {
            var self = this;
            self.$shareButton = $('.js-icon-share-draft');

            self.$shareButton.on('click', function(e){
                // 要素の右下の座標を取得
                var sectionRect = self.section.getBoundingClientRect();
                var rect = this.getBoundingClientRect();

                self.setWindowPosition({
                    top  : rect.bottom - sectionRect.top,
                    left : rect.right - sectionRect.left
                });

                var entryId = $(this).data('entryId');
                self.openShareDraftWindow(e, entryId);
                return false;
            });

            self.$closeButton.on('click', function () {
                self.closeShareDraftWindow();
                return false;
            });

            self.$mask.on('click', function () {
                self.closeShareDraftWindow();
                return false;
            });
        },

        setWindowPosition: function (pos) {
            this.pos = pos;
        },

        openShareDraftWindow : function (e, entryId) {
            var self = this;
            var data = {
                rkm      : Hatena.Diary.data('rkm'),
                rkc      : Hatena.Diary.data('rkc'),
                entry_id : entryId
            };

            // 下書き保存
            $.ajax({
                url      : './share_existing_draft',
                type     : 'POST',
                dataType : 'json',
                data     : data
            }).done(function (res) {
                self.$shareBoxWrapper.addClass('visible');

                // 下の方の要素クリックした時にウィンドウがはみ出るの防止
                var offset = +self.$shareBox.css('margin').slice(0, -2);
                var over = (self.pos.top + self.$shareBox[0].getBoundingClientRect().height + offset * 2) - self.section.offsetHeight;

                if (over > 0) {
                    self.pos.top -= over + 10;
                }

                self.$shareBox.css(self.pos);

                var previewURL = Hatena.Diary.data('blogs-uri-base') + '/draft/' + res.token;
                self.$tokenInput.val(previewURL).focus().select();

            }).fail(function () {
                console.log('ajax error!!');
            });
        },

        closeShareDraftWindow: function () {
            this.$shareBoxWrapper.removeClass('visible');
        }
    };


    var onEntriesPage = function(){
        var entries = new Entries();
        Collections.entries = entries;
        var entriesView = new EntriesView(entries);
        var categories = new Categories();
        Collections.categories = categories;
        var categoriesView = new CategoriesView(categories, entries);
        var categoriesDropdownView = new CategoriesDropdownView();
        var entryTypeTabs = new EntryTypeTabsView(entries);

        var shareDraftBox = new ShareDraftBox(entriesView);

        entries.reset();
    };

    Hatena.Diary.Pages.Admin['user-blog-entries'] = function () {
        onEntriesPage();
    };

    Hatena.Diary.Pages.Admin['user-blog-drafts'] = function (){
        onEntriesPage();
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Admin['user-blog-import-hatena_diary-diary-diary_name'] = function () {
        var $progress = $('#import-hatena_diary-progress');
        var $bar      = $progress.find('.bar');
        if (!$progress[0] || !$bar[0]) { return; }

        var apiUrl        = $progress.attr('data-progress-api');
        var onCompleteUrl = $progress.attr('data-diary-page');

        Hatena.Diary.ImportProgressBar.init($bar, apiUrl, onCompleteUrl);
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Admin['user-blog-import-hatena_diary'] = function () {
        var $progress = $('#import-hatena_diary-progress');
        var $bar      = $progress.find('.bar');
        if (!$progress[0] || !$bar[0]) { return; }

        var apiUrl        = $progress.attr('data-progress-api');
        var onCompleteUrl = $progress.attr('data-diary-page');

        Hatena.Diary.ImportProgressBar.init($bar, apiUrl, onCompleteUrl);
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Admin['user-blog-subscribe-done'] = function () {
        Messenger.listenToParent();
        Hatena.Diary.Util.sendResizeRequest();
        Messenger.send('done');
    };

})(jQuery);

(function($, Hatena){
    'use strict';

    /**
     * iframe版購読ボタン
     * iframeの中身はSubscribeButton.Adminがあるだけ
     */
    Hatena.Diary.Pages.Admin['user-blog-subscribe-iframe'] = function () {
        var $el = $('.js-hatena-follow-button-box');

        var userData = {
            isSubscribing : $el.data('is-subscribing'),
            isGuest       : Hatena.Diary.data('rkm') && Hatena.Diary.data('rkc') ? false : true
        };
        var blogUrl = Hatena.Diary.data('blog-host');
        var blogData = {
            subscribersCount : parseInt($el.data('subscribers-count'), 10),
            blogName         : Hatena.Diary.data('blog-name'),
            blogUrl          : blogUrl,
            requestUrl       : [
                Hatena.Diary.data('admin-domain'),
                Hatena.Diary.data('author'),
                blogUrl,
                'subscribe'
            ].join('/')
        };

        var view = new Hatena.Diary.SubscribeButton.Admin($el, userData, blogData);
    };

})(jQuery, Hatena);

(function($){

    Hatena.Diary.Pages.Blogs['*'] = function () {
        // iframeからはアクセスログのapiを叩かない
        if (window.parent === window) {
            Hatena.Diary.AccessLog.ping();
            Hatena.Diary.Blogs.trackBlogVisit();
        }

        Hatena.Diary.Pages.infoLoaded.done(function(info) {
            Hatena.Diary.Pages.Blogs['*'].init(info);

            if (info.quote) {
                // 引用ボックスと引用ストックの初期化
                Hatena.Diary.Quote.PC.init(info.quote);
                Hatena.Diary.Quote.PC.Stock.init(info.quote);
            }
        });

        Hatena.Diary.Util.updateDynamicPieces([document]);

        $(document).on('click', 'img.hatena-fotolife, img.magnifiable, img.http-image', function () {
            var img = this;
            var $img = $(img);

            if ($img.data('colorbox')) {
                // colorbox is already set up
                return;
            }

            // a要素に含まれ，リンク先が画像のsrcと異なるときは拡大しない
            var closest_a = $img.closest('a').get(0);
            if (closest_a && closest_a.href !== img.src) {
                return;
            }

            $img.colorbox({
                maxWidth    : '95%',
                maxHeight   : '95%',
                transition : 'none',
                photo: true,
                href : $img.attr('src'),
                title : ' ',
                open : true
            });

            $('#cboxContent').click(function () {
                $.colorbox.close();
            });

            return false;
        });

        Hatena.Diary.Blogs.Module.init();

        Hatena.Diary.Pages.Blogs['*'].prepareForGlobalHeader();

        Hatena.Diary.Pages.Blogs['*'].setupOndemandCommentDeleteButton();

        Hatena.Diary.Pages.Blogs['*'].highlightKeyword();

        // archiveとはてなブックマークコメントではスターは小さいやつを使う
        if (! _.contains(['archive', 'hatena-bookmark-comment'], Hatena.Diary.data('page'))) {
            Hatena.Diary.Star.initBigStar();
            Hatena.Diary.Star.initStarNavigation();
            Hatena.Diary.Star.initDeleteStar();

            Hatena.Diary.Quote.PC.Star.init();
        }

        Hatena.Diary.setupTouchViewSuggest();

        Hatena.Diary.Pages.Blogs['*'].setupTumblrShareButtons();

        Hatena.Diary.Pages.Blogs['*'].setupFastClick();
    };

    // 記事検索で検索結果のタイトル・本文のキーワードをハイライトする
    Hatena.Diary.Pages.Blogs['*'].highlightKeyword = function () {

        if (!!Hatena.Diary.Location.params() && Hatena.Diary.Location.params()['q']){
            var keywords= $('.search-result').data("searchQueries");
            if (!keywords) return;

            $(".entry-title").highlight(keywords, { caseSensitive:false });
            $(".entry-description").highlight(keywords, { caseSensitive:false });
        }

    };

    function navigateToEditNewEntry () {
        Hatena.Diary.Pages.infoLoaded.done(function (info) {
            if (info.can_open_editor) {
                Hatena.Diary.Pages.Blogs['*'].newEntry();
            } else {
                location.href = Hatena.Diary.data('admin-domain') + '/my/?fragment=edit';
            }
        });
    }

    function navigateToEditNewEntryWithQuote () {
        Hatena.Diary.Pages.infoLoaded.done(function () {
            location.href = Hatena.Diary.data('admin-domain') + '/my/edit?sidebar=quote#auto_fillin';
        });
    }

    function navigateToEditNewEntryWithReQuote () {
        Hatena.Diary.Pages.infoLoaded.done(function () {
            location.href = Hatena.Diary.data('admin-domain') + '/my/edit';
        });
    }

    Hatena.Diary.Pages.Blogs['*'].toggleMyMenuDropdown = function(data) {
        Hatena.Diary.Dropdown.toggle(
            '/-/menu/mymenu?location=' + encodeURIComponent(location.href),
            data, 'mymenu', {
                callback: function (dropdown, messenger) {
                    var blog_to_$dropdown_container = {};

                    messenger.addEventListener('feedback', function (data) {
                        Hatena.Diary.Feedback.toggle(data.uri);
                    });

                    messenger.addEventListener('myblogmenu.init', function (data) {
                        var init = {
                            top: $(dropdown).offset().top + data.top,
                            right: $(dropdown).offset().left - 2,
                            height: 266
                        };
                        Hatena.Diary.Dropdown.toggle(
                            '/-/menu/myblogmenu?blog=' + encodeURIComponent(data.blogUri),
                            init,
                            null, {
                                callback: function (dropdown, messenger) {
                                    blog_to_$dropdown_container[data.blogUri] = $(dropdown).parent();

                                    // XXX: callbackが呼ばれるタイミングはshowされる前なのでそれを待ってから隠す
                                    _.delay(function () {
                                        $(dropdown).parent().hide();
                                    });
                                },
                                key: data.blogUri,
                                parent: 'mymenu',
                                className: 'hatena-diary-dropdown-myblogs'
                            }
                        );
                    });

                    messenger.addEventListener('myblogmenu.open', function (data) {
                        var $dropdown_container = blog_to_$dropdown_container[data.blogUri];
                        $dropdown_container.show();

                        var self = Hatena.Diary.Pages.Blogs['*'].toggleMyMenuDropdown;
                        self.$active_dropdown_container = $dropdown_container;
                    });

                    messenger.addEventListener('myblogmenu.close', function (data) {
                        var $dropdown_container = blog_to_$dropdown_container[data.blogUri];
                        $dropdown_container.hide();

                        var self = Hatena.Diary.Pages.Blogs['*'].toggleMyMenuDropdown;
                        self.$active_dropdown_container = null;
                    });

                    messenger.addEventListener('new-entry', function (data) {
                        navigateToEditNewEntry();
                    });
                }
            }
        );

        var $active_dropdown_container = Hatena.Diary.Pages.Blogs['*'].toggleMyMenuDropdown.$active_dropdown_container;

        // メニューを再度開くとき, サブメニューを開いている状態を復元する
        if ($active_dropdown_container && $active_dropdown_container.is(':hidden')) {
            $active_dropdown_container.fadeIn('fast');
        }
    };

    Hatena.Diary.Pages.Blogs['*'].prepareForGlobalHeader = function() {
        if (window != window.parent) return null;
        if (!Messenger.messenger) return null;

        var self = this;

        Messenger.addEventListener('new-entry', function (data) {
            navigateToEditNewEntry();
        });

        Messenger.addEventListener('new-entry-with-quote', function (data) {
            navigateToEditNewEntryWithQuote();
        });
        Messenger.addEventListener('new-entry-with-requote', function (data) {
            navigateToEditNewEntryWithReQuote();
        });

        Messenger.addEventListener('units', function (data) {
            Hatena.Diary.Dropdown.toggle(data.uri, data);
        });

        Messenger.addEventListener('feedback', function (data) {
            Hatena.Diary.Feedback.toggle(data.uri);
        });

        Messenger.addEventListener('mymenu', function (data) {
           Hatena.Diary.Pages.Blogs['*'].toggleMyMenuDropdown(data);
        });

        Messenger.addEventListener('servicesmenu', function (data) {
            Hatena.Diary.Dropdown.toggle('/-/menu/services', data);
        });

        Messenger.addEventListener('unread', function (data) {
            location.href = Hatena.Diary.data('admin-domain') + '/-/antenna';
        });

        var notifyWindow;
        Messenger.addEventListener('notify', function (data) {
            var BASE = data.BASE;

            if (notifyWindow) {
                if (notifyWindow.is(':visible')) {
                    Hatena.Diary.Window.hide(notifyWindow, function () {
                        notifyWindow.remove();
                        notifyWindow = null;
                    });
                    return;
                } else {
                    notifyWindow.remove();
                    notifyWindow = null;
                }
            }

            notifyWindow = $('<div id="notify-window" class="hatena-globalheader-window"></div>').
                css({
                    left : data.left - 250 + 32
                });

            notifyWindow.html("<img src='https://b.st-hatena.com/images/loading32.gif' class='loading' style='position:absolute;'/>");

            var iframe = $('<iframe style="border:none" frameBorder="0" class="notify" width="250" height="300"></iframe>').appendTo(notifyWindow);

            iframe.attr('src', 'https://www' + BASE + '/notify/notices.iframe?' + new Date().getTime());

            iframe.ready(function () {
                notifyWindow.find('img').remove();
            });

            notifyWindow.
                //            css({
                //                top: $(document.body).scrollTop() + 37
                //            }).
                hide().
                fadeIn('fast').
                appendTo(document.body);

            Hatena.Diary.Window.show(notifyWindow, {
                fixScroll: true
            });
        });

        Messenger.addEventListener('blogmenu', function (data) {
            var params = {};
            if (Hatena.Diary.data('blog')) {
                params['blog'] = location.href;
                if (
                    Hatena.Diary.data('page') === 'entry' &&
                    // 削除されてエントリがない or Not Found 状態 であれば対象のエントリがなくなるので
                    // パーマリンクフラグをたてない
                    $('article.entry:not([class~="no-entry"])').length > 0
                ) {
                    params['blog_permalink'] = 1;
                }
            }
            var uri = '/-/menu/blogmenu?' + $.param(params);
            Hatena.Diary.Dropdown.toggle(uri, data, 'blogmenu', {
                callback: function (dropdown, messenger) {
                    messenger.addEventListener('edit-this-entry', function (data) {
                        var $entry = $('article.entry').first();
                        Hatena.Diary.Pages.Blogs['*'].editEntry( $entry );
                    });
                    messenger.addEventListener('new-entry', function (data) {
                        navigateToEditNewEntry();
                    });
                    // ドロップダウンメニューの講読ボタンが押されたらblogs側で窓を開く
                    messenger.addEventListener('subscribe', function (data) {
                        $(document).trigger('subscribe', data);
                    });
                }
            });
        });

        Messenger.addEventListener('locale', function (data) {
            var uri = Hatena.Diary.data('admin-domain') + '/-/locale';

            Hatena.Diary.Dropdown.toggle(uri, data, 'locale');
        });
    };

    Hatena.Diary.Pages.Blogs['*'].init = function (info) {
        if (arguments.callee.called) return; arguments.callee.called = true;

        // globalhaederがキャッシュされているのでこちらからviaを送ってやる
        var via = Hatena.Diary.Location.param('via');
        if (via) {
            Messenger.send('inheritVia', via);
        }

        if (info.message) {
            Hatena.Diary.Util.showFlashMessage(info.message);
        }

        if (info.show_modal) {
            var $modalContainer = $('<div class="hatena-iframe-container"></div>').appendTo(document.body);
            var $iframe = $('<iframe frameborder="0"></iframe>').appendTo($modalContainer);

            var messenger = Messenger.createForFrame($iframe[0], info.show_modal.url);

            messenger.addEventListener('resize', function (data) {
                if (data) {
                    $modalContainer.css(data);
                    $(window).trigger('resize'); // reset position
                }
            });

            var destroyed = $.Deferred();

            // hide 時はただ隠すだけ、close が呼ばれてはじめて
            // iframe を消す
            messenger.addEventListener('hide', function () {
                Hatena.Diary.Window.hide($modalContainer);
            });

            messenger.addEventListener('close', function () {
                destroyed.done(function () {
                    $iframe.remove();
                    messenger.destroy();
                });
                Hatena.Diary.Window.hide($modalContainer);
            });

            Hatena.Diary.Window.show($modalContainer, {
                destroy: function () {
                    destroyed.resolve();
                },
                fixScroll: true,
                center: true,
                showBackground: true
            });
        }

        var self = this;

        Hatena.Diary.Browser.thirdPartyCookiesBlocked.resolve(!info.cookie_received);

        $('article.entry').each(function () {
            var $this = $(this);
            self.initEntry($this);
        });

        if (info.editable) {
            var $entry,
                timer,
                $menu = $('<div>').addClass('entry-header-menu'),
                create_edit_button = function ($entry) {
                    // エントリにカーソル合わせると出てくる「編集」ボタンを作る
                    return $('<a>')
                             .attr( 'href', 'javascript:void' )
                             .text( Hatena.Locale.text('edit') )
                             .on('click', function (e) {
                                 e.preventDefault();
                                 Hatena.Diary.Pages.Blogs['*'].editEntry( $entry );
                             });
                };

            $(document).on('mouseenter', 'article.entry', function () {
                var $hovered = $(this);
                if ( $hovered.is($entry) ) {
                    clearTimeout(timer);
                    return;
                }

                $entry = $hovered;
                if ( !$entry.attr('data-uuid') ) return;

                $menu
                  .empty()
                  .append( create_edit_button($entry) )
                  .appendTo( $entry.find('.entry-header') )
                  .show();
            });

            $(document).on('mouseleave', 'article.entry', function () {
                clearTimeout(timer);
                timer = setTimeout(function () {
                    $entry = null;
                    $menu.fadeOut('fast');
                }, 2000);
            });

            // 新規開設時
            if ( info.has_just_registered ) {
                _gaq.push(['_trackPageview', '/register.done']);
            }

            // インデックスページで，プレビューではなくて，グローバルヘッダ表示中のとき
            if (Hatena.Diary.data('page') === 'index' && ! Hatena.Diary.Location.param('preview') && $('#globalheader').is(':visible')) {
                Hatena.Diary.Pages.Blogs['*'].setupFirstEntry();
            }

            Hatena.Diary.setupProModal();

        }

        Hatena.Diary.Pages.Blogs['*'].renderGooglePlusOneButtons();
        // ブックマークコメントウィジェット
        Hatena.Diary.Pages.Blogs['*'].setupHatenaBookmarkComment($('#container'));

        // エントリー一覧のカルーセル
        Hatena.Diary.Pages.Blogs['*'].setupEntryModuleCarousel();

        // 購読ボタンと購読者数
        Hatena.Diary.Blogs.SubscribeButtonSynchronizer.init(info.subscribe, info.subscribes);

        // Re-引用機能
        if (info.is_public) {
            new Hatena.Diary.Blogs.ReQuote();
        }

        Hatena.Diary.Browser.thirdPartyCookiesBlocked.done(function(blocked) {
            if (blocked) {
                Hatena.Diary.Star.initStarForThirdPartyCookiesDisabled(info);
            }
        });

        Hatena.Diary.SpeedTrack.record("Pages.Blogs['*'].init");
    };

    Hatena.Diary.Pages.Blogs['*'].setupFirstEntry = function() {
        $('.entry-content').show();

        // 1記事もないとき，記事を書こうみたいなツールチップなどを表示する

        var $tooltip = $('.welcome-tooltip-newentry');
        $tooltip.click(function() {
            Hatena.Diary.Pages.Blogs['*'].newEntry();
        });
        Messenger.send('newEntryGeometry');
        Messenger.addEventListener('newEntryGeometry', function(geometry) {
            $tooltip.offset({
                left : (geometry.left + (geometry.width / 2)) - ($tooltip.outerWidth() / 2)
            });
            $tooltip.show();
        });
    };

    Hatena.Diary.Pages.Blogs['*'].newEntry = function (opts) {
        if (!opts) opts = {};

        Hatena.Diary.EditorAdmin.showEditInPlace(null, {
            update : function (data) {
                // data.entryは前後に空白を含むので消す
                var $newEntry = $(data.entry.replace(/^\s+/, '').replace(/\s+$/, ''));

                // 下書き投稿のときは何もしない
                if (!$newEntry.length) return;

                $newEntry.insertBefore('#main article.entry:first');
                Hatena.Diary.Pages.Blogs['*'].initEntry($newEntry);
                Hatena.Diary.Util.updateDynamicPieces($newEntry.parent());
                $('[data-remove-on-new-entry=1]').remove();
            }
        });
    };

    Hatena.Diary.Pages.Blogs['*'].editEntry = function ($entry) {
        if (!$entry) return;

        Hatena.Diary.EditorAdmin.showEditInPlace($entry, {
            update : function (data) {
                // data.entryは前後に空白を含むので消す
                var $newEntry = $(data.entry.replace(/^\s+/, '').replace(/\s+$/, ''));

                // 記事を削除した場合は, 削除エントリーを消す
                if (!$newEntry.length) {
                    $entry.remove();
                    return;
                }
                $entry.replaceWith($newEntry);
                Hatena.Diary.Pages.Blogs['*'].initEntry($newEntry);
                Hatena.Diary.Util.updateDynamicPieces($newEntry.parent());
            }
        });
    };

    Hatena.Diary.Pages.Blogs['*'].initEntry = function (entry) {
        var self = this;
        var uuid = entry.attr('data-uuid');

        Hatena.Diary.Util.replaceYoutubeURL(entry);

        var container = entry.find('.comment-box .comment');
        $(container).delegate('.comment-delete-button', 'click', function (e) {
            var $button = $(this);

            Hatena.Diary.Pages.Blogs['*'].deleteCommentHandler(entry, $button);

            return false;
        });

        var showEntryInfo = function (entry, container, maxCommentsCount) {
            return self.loadEntryInfo(entry).done(function (info) {

                if (info.comments) {

                    var $readMoreLine = entry.find('.read-more-comments');
                    var $readMoreButton = $readMoreLine.find('a');
                    // readMoreButtonが無いか、maxCommentsCountが0またはコメントの総数がmaxCommentsCountより少ないとき、全件表示
                    var commentsCount = info.comments.entries.length;
                    var expandedInThisSession = false;
                    try {
                        var entriesExpandedComments = JSON.parse(sessionStorage.getItem('entriesExpandedComments')) || {};
                        expandedInThisSession = entriesExpandedComments[entry.attr('data-uuid')];
                    } catch (_ignored) {
                    }
                    if ($readMoreLine.length === 0 || maxCommentsCount === 0 || commentsCount <= maxCommentsCount || expandedInThisSession) {
                        maxCommentsCount = commentsCount;

                        // すべてのコメントが表示される
                        // すでに表示されているコメントがあったら消す
                        // このとき「もっと読む」も消える
                        container.children().remove();
                        entry.attr('data-comments-expanded', true);
                    } else {
                        // まだ表示されていないコメントがあるから「もっと読む」を表示する
                        $readMoreLine.show();
                    }

                    // コメントのHTMLを連結して一括でDOMにする
                    var commentHTML = '';
                    for (var i = 0, len = maxCommentsCount; i < len; i++) {
                        commentHTML += info.comments.entries[i];
                    }
                    var $comments = $(commentHTML);

                    container.prepend($comments);

                    // 未表示のコメントの数を表示する
                    $readMoreButton.text(
                        Hatena.Locale.text('read_more_comments') + ' (' + (info.comments.entries.length - maxCommentsCount) + ')'
                    );

                    if (Hatena.Star) {
                        Hatena.Diary.Util.waitForResource(function() {
                            return Hatena.Star && Hatena.Star.WindowObserver.loaded;
                        }, function() {
                            Hatena.Star.EntryLoader.intoCommentScope(function () {
                                Hatena.Diary.Util.updateDynamicPieces(container);
                            });
                        });
                    } else {
                        Hatena.Diary.Util.updateDynamicPieces(container);
                    }
                }

                Hatena.Diary.SpeedTrack.record("Pages.Blogs['*'].init.showEntryInfo");
            }).
                fail( Hatena.Diary.REPORT_BUG('loadEntryInfo') );
        };

        var $readMoreLine = entry.find('.read-more-comments');
        var $readMoreButton = $readMoreLine.find('a');

        // コメント最初は3件まで表示
        showEntryInfo(entry, container, 3);

        $readMoreButton.click(function (e) {
            // 「もっと読む」がクリックされたらコメント全件表示
            showEntryInfo(entry, container, 0).done(function () {
                try {
                    // もっと読むがクリックされた場合 sessionStorage に状態を保存しておく
                    var map = {};
                    $('article[data-comments-expanded][data-uuid]').each(function () {
                        map[$(this).attr('data-uuid')] = true;
                    });
                    sessionStorage.setItem('entriesExpandedComments', JSON.stringify(map));
                } catch (_ignored) {
                }
            });
            return false;
        });

        Hatena.Diary.Pages.infoLoaded.done(function (info) {
            entry.find('.leave-comment-title').toggle(
                info.cookie_received ? info.commentable : true
            ).on('click', function () {
                var $button = $(this);
                Hatena.Diary.Pages.Blogs['*'].leaveCommentHandler(entry, $button);

                return false;
            });
        });

    };

    Hatena.Diary.Pages.Blogs['*'].deleteCommentHandler = function ($entry, $button) {
        var commentId = $button.closest('li.entry-comment').attr('id');

        var uri = Hatena.Diary.data('admin-domain') +
            '/' + Hatena.Diary.data('author') + '/' + Hatena.Diary.data('blog') +
            '/comment/delete?comment=' + encodeURIComponent(commentId.slice(8));

        Hatena.Diary.Browser.thirdPartyCookiesBlocked.done(function(blocked) {
            if (blocked) {
                Hatena.Diary.Pages.Blogs['*'].deleteCommentHandlerWindow($entry, $button, commentId, uri);
            } else {
                Hatena.Diary.Pages.Blogs['*'].deleteCommentHandlerIframe($entry, $button, commentId, uri);
            }
        });
    };

    Hatena.Diary.Pages.Blogs['*'].deleteCommentHandlerIframe = function ($entry, $button, commentId, uri) {
        var iframeContainer = $(
            '<div class="hatena-iframe-container"><div class="loading">' +
                '<img src="' + Hatena.Diary.URLGenerator.static_url('/images/loading.gif') + '" alt="loading"/>' +
                Hatena.Locale.text('loading') +
                '</div></div>').appendTo($entry);
        var iframe = $('<iframe frameborder="0"></iframe>').appendTo(iframeContainer);
        iframeContainer.
            css({
                width: 440,
                height: 120,
                position: 'absolute'
            }).
            offset( $button.offset() );

        var loading = iframeContainer.find('.loading').hide();
        setTimeout( function () { loading.show() }, 250);
        iframe.load(function () { loading.remove() });

        var messenger = Messenger.createForFrame(iframe[0], uri);
        messenger.addEventListener('delete', function (data) {
            $("#" + commentId).fadeOut();
        });
        messenger.addEventListener('close', function () {
            Hatena.Diary.Window.hide(iframeContainer);
        });

        Hatena.Diary.Window.show(iframeContainer, {
            destroy : function () {
                iframe.remove();
                messenger.destroy();
            }
        });
    };

    Hatena.Diary.Pages.Blogs['*'].deleteCommentHandlerWindow = function ($entry, $button, commentId, uri) {
        var position = {
            width:  300,
            height: 150
        };
        position.left = Math.floor((screen.width - position.width) / 2);
        position.top = Math.floor((screen.height - position.height) / 2);

        var position_string = Hatena.Diary.Util.positionToPositionString(position);

        var delete_comment_window = window.open('', 'delete_comment', position_string);

        var messenger = Messenger.createForWindow(delete_comment_window, uri);

        var close = function() {
            messenger.destroy();
            delete_comment_window.close();
        };

        messenger.addEventListener('delete', function (data) {
            $("#" + commentId).fadeOut();
        });

        messenger.addEventListener('close', close);

        $(document.body).one('focus', close);

    };


    Hatena.Diary.Pages.Blogs['*'].leaveCommentHandler = function ($entry, $button) {
        // viewable状態でコメント出来るかどうか決めるため
        // bkをtokenとして渡す
        var uri = Hatena.Diary.data('admin-domain') +
            '/' + Hatena.Diary.data('author') + '/' + Hatena.Diary.data('blog') + '/comment?' +
            $.param({
                entry : $entry.attr('data-uuid'),
                token : Hatena.Cookie.get('bk'),
            });

        Hatena.Diary.Browser.thirdPartyCookiesBlocked.done(function(blocked) {
            if (blocked) {
                Hatena.Diary.Pages.Blogs['*'].leaveCommentHandlerWindow($entry, $button, uri);
            } else {
                Hatena.Diary.Pages.Blogs['*'].leaveCommentHandlerIframe($entry, $button, uri);
            }
        });
    };

    Hatena.Diary.Pages.Blogs['*'].leaveCommentHandlerWindow = function($entry, $button, uri) {
        var position = {
            width:  400,
            height: 240
        };
        position.left = Math.floor((screen.width - position.width) / 2);
        position.top = Math.floor((screen.height - position.height) / 2);

        var position_string = Hatena.Diary.Util.positionToPositionString(position);

        var comment_window = window.open('', 'comment', position_string);

        var messenger = Messenger.createForWindow(comment_window, uri);

        messenger.addEventListener('close', function() {
            messenger.destroy();
            comment_window.close();
        });

        messenger.addEventListener('update', function (data) {
            Hatena.Diary.Pages.Blogs['*'].appendPostedComment($entry, data.comment);
        });
    };

    Hatena.Diary.Pages.Blogs['*'].leaveCommentHandlerIframe = function($entry, $button, uri) {
        var container = $(
            '<div class="hatena-iframe-container">' +
                '<div class="loading">' +
                '<img src="' + Hatena.Diary.URLGenerator.static_url('/images/loading.gif') + '" alt="loading"/>' +
                Hatena.Locale.text('loading') +
                '</div>' +
                '</div>').
            hide().
            appendTo(document.body);

        var iframe = $('<iframe frameborder="0"></iframe>').appendTo(container);

        var loading = container.find('.loading').hide();

        setTimeout(function () {
            loading.show();
        }, 250);

        iframe.load(function () {
            loading.remove();
        });

        var offset   = $button.offset();
        var maxWidth = $(window).width();
        var winWidth = 440;
        var padding  = 10;

        // コメントframe幅がmaxWindowより大きい場合は, 縮めて中央に表示
        if ( (winWidth + 2*padding) > maxWidth ) {
            winWidth = maxWidth - 2*padding;
            offset.left = padding;
        }

        var height = 235;

        // 上が新しいときコメント書くボタンの上にウィンドウ出す
        var top_is_new = Hatena.Diary.data('blog-comments-top-is-new');
        if (top_is_new) {
            offset.top -= height;
            offset.top += $button.height();
        }

        container.
            css({
                width: winWidth,
                height: height,
                position: 'absolute'
            }).
            offset(offset);

        var editinplace = iframe[0];

        var messenger = Messenger.createForFrame(editinplace, uri);

        messenger.addEventListener('update', function (data) {
            Hatena.Diary.Pages.Blogs['*'].appendPostedComment($entry, data.comment);
        });

        messenger.addEventListener('close', function () {
            Hatena.Diary.Window.hide(container);
        });

        messenger.addEventListener('resize', function (data) {
            if (data) {
                if (top_is_new && data.height  != height) {
                    data.top = container.css('top') + height - data.height;
                }
                container.css(data);
            }
        });

        Hatena.Diary.Window.show(container, {
            closeExplicitly : true,
            destroy : function () {
                iframe.remove();
                messenger.destroy();
            }
        });
    };

    Hatena.Diary.Pages.Blogs['*'].appendPostedComment = function($entry, comment_html) {
        var $container = $entry.find('.comment-box .comment');
        var top_is_new = Hatena.Diary.data('blog-comments-top-is-new');
        if (top_is_new) {
            $container.prepend(comment_html);
        } else {
            $container.append(comment_html);
        }

        if (Hatena.Star) {
            Hatena.Star.EntryLoader.intoCommentScope(function() {
                Hatena.Diary.Util.updateDynamicPieces($container);
            });
        } else {
            Hatena.Diary.Util.updateDynamicPieces($container);
        }
    };

    Hatena.Diary.Pages.Blogs['*'].loadEntryInfo = function me (entry) {
        if (!me.data) me.data = {
            timer : setTimeout(function () {
                var data = me.data;
                me.data = null;
                $.ajax({
                    url : Hatena.Diary.URLGenerator.user_blog_url('/api/entry/info'),
                    type : "get",
                    dataType : 'json',
                    cache : false,
                    data : {
                        e : data.entries
                    },
                    success : function (res) {
                        var entries = res.entries;
                        for (var key in entries) if (entries.hasOwnProperty(key)) {
                            var val = entries[key];
                            data.deferred[key].resolve(val);
                        }

                        Hatena.Diary.SpeedTrack.record("Pages.Blogs['*'].loadEntryInfo.ajax.success");
                    }
                });
            }, 0),
            entries : [],
            deferred : {}
        };

        var ret  = $.Deferred();
        var uuid = entry.attr('data-uuid');

        me.data.entries.push(uuid);
        me.data.deferred[uuid] = ret;

        return ret;
    };

    // スクロールで要素が表示されたときに何かする
    Hatena.Diary.Pages.Blogs['*'].elementDidAppear = function (element) {
        var deferred = $.Deferred();
        var _window = $(window);

        if (_window.scrollTop() > ($(element).offset().top - _window.height())) {
            deferred.resolve();
        } else {
            _window.scroll(_.throttle(function () {
                if (_window.scrollTop() > ($(element).offset().top - _window.height())) {
                    deferred.resolve();
                }
            }, 200));
        }
        return deferred.promise();
    };

    // Google+ボタンを描画 plusone.jsのロードに失敗してるようなら何もしない(なぜか読めてないことがある)
    // YouTubeのsubscribeボタンもplusone.jsに入ってるので描画
    // https://developers.google.com/+/web/+1button/?hl=ja
    Hatena.Diary.Pages.Blogs['*'].renderGooglePlusOneButtons = function() {
        if (!window.gapi) return;

        try {
            window.gapi.plusone.go('container');
            window.gapi.ytsubscribe.go('container');
        } catch(ignore) {
            // Google+ボタンはIE8以上のみ対応で，IE7では例外出るけど，無視する．
        }
    };

    Hatena.Diary.Pages.Blogs['*'].setupHatenaBookmarkComment = function ($superNode) {
        // 上位のノードを指定すること
        // ブックマークコメントウィジェットのサイズ調整
        var $bookmark_comment = $superNode.find('.hatena-bookmark-comment-iframe');

        if ($bookmark_comment.size() === 0) return;

        _.each($bookmark_comment, function (item) {
            var $item = $(item);
            var messenger = Messenger.createForFrame($item[0], $item.attr('data-src'));
            messenger.addEventListener('resize', function (height) {
                $item.css('height', height);
            });
        });
    };

    Hatena.Diary.Pages.Blogs['*'].setupOndemandCommentDeleteButton = function() {
        $(document).on('mouseenter', '.entry-comment', function(e) {
            var $comment = $(this);
            if ($comment.find('.comment-delete-button img').size() > 0)
                return;
            var comment_uuid = $comment.attr('data-comment-uuid');
            var blog_uuid = $comment.attr('data-blog-uuid');
            var url = Hatena.Diary.data('admin-domain') + '/api/comment.delete.image?comment=' + comment_uuid + '&blog=' + blog_uuid;
            var $img = $('<img>');
            $img.attr('src', url);
            var handler = function() {
                $img.attr('alt', 'delete');
            };
            $img.load(handler);
            $img.error(handler);
            $comment.find('.comment-delete-button').append($img);
        });
    };

    // Tumblr 提供のブックマークレット http://www.tumblr.com/apps#bookmarklet_window を
    // URL およびタイトルを明に指定できるように改造したもの
    Hatena.Diary.Pages.Blogs['*'].setupTumblrShareButtons = function (elem) {
        $(elem || document.body).find('a[data-hatenablog-tumblr-share-button]').on('click', function () {
            var selection = window.getSelection   ? window.getSelection()
                : document.getSelection ? document.getSelection()
                : document.selection    ? document.selection.createRange().text : 0;
            var url = 'http://www.tumblr.com/share?' + $.param({
                v: 3,
                u: $(this).attr('data-share-url') || location.href,
                t: $(this).attr('data-share-title') || document.title,
                s: selection + ''
            });
            var go = function () {
                if (!window.open(url, 't', 'toolbar=0,resizable=0,status=1,width=450,height=430')) {
                    location.href = url;
                }
            };
            if (/Firefox/.test(navigator.userAvent)) {
                setTimeout(go, 0);
            } else {
                go();
            }
            return false;
        });
    };

    Hatena.Diary.Pages.Blogs['*'].setupEntryModuleCarousel = function() {
        var $carouselScripts = $(document).find('script[type="text/x-hatenablog-carousel"]');

        _.each($carouselScripts, function (item) {
            var $item = $(item);
            var displayEntrySize = $item.attr('data-carousel-display-entry-size-at-once');
            var opts = {
                isAutoScroll: $item.attr('data-carousel-autoscroll') === 'true',
                displayEntrySizeAtOnce: displayEntrySize !== undefined ? Number(displayEntrySize) : undefined
            };
            if (opts.isAutoScroll) {
                var interval = $item.attr('data-carousel-autoscroll-interval');
                opts.autoScrollInterval = interval !== undefined ? Number(interval) : undefined;
            }
            new Hatena.Diary.Blogs.EntryModuleCarousel($(document).find($item.html()), opts);
        });

    };

    // レスポンシブデザインの場合、Touch用の処理をBlogsTouchではなくBlogsに書く必要がある
    // tap delay対策
    Hatena.Diary.Pages.Blogs['*'].setupFastClick = function () {
        FastClick.attach(document.body);
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['blog-count-limit-exceeded'] = function () {
        Hatena.Diary.Pages.infoLoaded.done(function (info) {
            var selector = info.editable ? '.js-message-author' : '.js-message-guest';
            $('#container').append($(selector).html());
        });
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['circle'] = function () {
        Hatena.Diary.Pages.Blogs['circle'].setupControls();
        Hatena.Diary.Pages.Blogs['circle'].setupSidebar();
        Hatena.Diary.Pages.Blogs['circle'].setupSpace();

        Hatena.Diary.Pages.infoLoaded.done(function (info) {
            if (info.flash && info.flash.has_just_created_circle) {
                var closeFlash = function () { $('#flash-created-circle').fadeOut('fast') };
                $('#flash-created-circle')
                    .find('.close').click(function () { closeFlash() }).end()
                    .show();
                $(document.body).on('click', function (e) {
                    if ($(e.target).closest('#flash-created-circle').length === 0) {
                        closeFlash();
                        $(document.body).off('click', arguments.callee);
                        return false;
                    }
                });
            }
        });

        Hatena.Diary.Util.initScrollFollowedElement($('.js-followed-ad-container'), false);
    };

    Hatena.Diary.Pages.Blogs['circle'].setupControls = function () {
        Hatena.Diary.Pages.infoLoaded.done(function (info) {
            if (info.is_admin) {
                $('.admin-control').addClass('admin-control-available');
            } else {
                $('.admin-control').addClass('admin-control-unavailable');
            }

            if (info.is_member) {
                $('.circle-member-control').addClass('circle-member-control-available');
            } else {
                $('.circle-member-control').addClass('circle-member-control-unavailable');
            }

            if (info.has_blogs) {
                $('.blog-user-control').addClass('blog-user-control-available');
            } else {
                $('.blog-user-control').addClass('blog-user-control-unavailable');
            }

            if (info.cookie_received === false) {
                // サードパーティークッキー無効のときに出す指定があるものは出るようにクラスをふり直す
                $('[data-user-unknown-overrides]')
                    .removeClass('admin-control-unavailable circle-member-control-unavailable blog-user-control-unavailable')
                    .addClass('admin-control-available circle-member-control-available blog-user-control-available');
            }
        });
    };

    // 可能なら汎用化したい
    function createMessenger (url, name, $container) {
        return Hatena.Diary.Browser.thirdPartyCookiesBlocked.pipe(function (blocked) {
            var messenger;

            if (blocked) {
                var size = { width: 300, height: 400 };
                size.left = Math.floor((screen.width - size.width) / 2);
                size.top  = Math.floor((screen.height - size.height) / 2);

                var subwindow = window.open('', name, Hatena.Diary.Util.positionToPositionString(size));
                messenger = Messenger.createForWindow(subwindow, url);

                messenger.addEventListener('close', function () {
                    messenger.destroy();
                    subwindow.close();
                });
            } else {
                var $iframe = $('<iframe frameborder=0>').appendTo($container);
                messenger = Messenger.createForFrame(
                    $iframe[0], url
                );

                messenger.addEventListener('close', function () {
                    Hatena.Diary.Window.hide($container);
                });

                messenger.addEventListener('resize', function (css) {
                    if (css) $iframe.css(css);
                });

                Hatena.Diary.Window.show($container, {
                    destroy: function () {
                        $iframe.remove();
                        messenger.destroy();
                    }
                });
            }

            return messenger;
        });
    }

    Hatena.Diary.Pages.Blogs['circle'].setupSidebar = function () {
        $('.manage-membership-button').click(function () {
            createMessenger(
                $('html').attr('data-admin-domain') + '/-/group/' + $('html').attr('data-circle-id') + '/membership',
                'manage-membership',
                $(this).siblings('.manage-membership-popup')
            );

            return false;
        });
    };

    Hatena.Diary.Pages.Blogs['circle'].setupSpace = function () {
        if (!$('.hatena-module.circle-space')[0]) return;
        $.getScript('http://space.hatena.ne.jp/js/interest.widget.js');
    };

    Hatena.Diary.Pages.Blogs['circle-blogs'] = function () {
        Hatena.Diary.Pages.Blogs['circle'].setupSidebar();
    };

    Hatena.Diary.Pages.Blogs['group-category'] = function () {
        Hatena.Diary.Util.initScrollFollowedElement($('.js-followed-ad-container'), true);
    };

    Hatena.Diary.Pages.Blogs['recent-groups'] = function () {
        Hatena.Diary.Util.initScrollFollowedElement($('.js-followed-ad-container'), true);
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['famous-blogs-top'] = function () {
        $(document).on('click', '.js-read-old-entries', function() {
            var $button = $(this);
            $button.closest('.js-category-container').find('.js-old-entry').show();
            $button.remove();
        });
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['global-top'] = function() {
        $('img[data-alternate-src]').one('error', function() {
            var $img = $(this);
            $img.attr('src', $img.attr('data-alternate-src'));
        });

        $('.js-category-wrapper').tabs({
            selected : 0
        });

        // 標準のタブのUIではなく，nav-barのスタイルを当てたいので，クラス消す
        $('.js-category-wrapper .ui-tabs-nav').removeClass('ui-tabs-nav');

        // globalトップはキャッシュされてるので、jsでviaの引き継ぎをする
        var via = Hatena.Diary.Location.param('via');
        if (via) {
            Hatena.Diary.inheritVia(via);
        }
    };

})(jQuery);
(function($){

    Hatena.Diary.Pages.Blogs['guide-pro-modal-ad'] = function () {
        Messenger.listenToParent();

        $('.close-window').on('click', function (e) {
            Messenger.send('close', { name : window.name });
            return false;
        });
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['hatena-bookmark-comment'] = function () {
        var messenger = Messenger.createForParent(),
        OFFSET = 30,        // iframeのbodyとの余白分, 十分大きい適当な値
        current_height = 0;

        var sendResize = function () {
            var next_height = $('body').height() + OFFSET;
            if (next_height !== current_height) {
                messenger.send('resize', next_height);
                current_height = next_height;
            }
        };

        // ボタンがクリックされたときサイズが変わる
        $(document).on('click', '.hatena-bookmark-span-button', function () {
            sendResize();
        });

        setInterval(function(){
            sendResize();
        }, 1000);
    };

})(jQuery);
(function($){

    Hatena.Diary.Pages.Blogs['index'] = function () {
        Hatena.Diary.Location.setup();

        $(window).hashchange(function () {
            if (location.hash == '#edit') {

                Hatena.Diary.Pages.infoLoaded.done(function (info) {
                    if (info.editable) {
                        Hatena.Diary.Pages.Blogs['*'].newEntry();
                    }
                }).
                    fail(function (e) {
                        Hatena.Diary.BUG(e);
                    });
            }
        }).hashchange();
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['preview'] = function() {
        try {
            if (!window.sessionStorage)
                return;
            var editor_id = $('#content').attr('data-editor-id');
            if (!editor_id)
                return;
            var $document = $(document);

            var pos = sessionStorage.previewed_scroll_position ? JSON.parse(sessionStorage.previewed_scroll_position) : null;
            if (pos && pos.editor_id == editor_id) {
                $document.scrollTop(pos.top);
                $document.scrollLeft(pos.left);
            }

            $document.scroll(_.throttle(function() {
                sessionStorage.previewed_scroll_position = JSON.stringify({
                    editor_id : editor_id,
                    top: $document.scrollTop(),
                    left: $document.scrollLeft()
                });
            }, 100));
        } catch (_ignored) {
        }
    };

})(jQuery);

(function($){
    Hatena.Diary.Pages.Blogs['preview_url_embed'] = function () {
        var messenger = Messenger.createForParent();

        // 最初の1回は必ずsendするために，nullにしておく．
        // IEでは，非表示な要素の高さ取れないため，最初高さ取ると0になる．
        // 0で送ると，親でiframeが表示されて，その後高さを取得すると，正しい高さになり，表示される．
        var current_height = null;

        var sendResize = function () {
            var next_height = $('html').height();
            if (next_height !== current_height) {
                messenger.send('resize', next_height);
                current_height = next_height;
            }
        };

        // 展開成功していたらこの要素がある．高さを親に伝える．失敗してたらiframe消してもらう．
        var embed_success = !! $('.js-embed-preview')[0];

        if (embed_success) {
            sendResize();
            setInterval(function(){
                sendResize();
            }, 1000);
        } else {
            // 展開失敗
            messenger.send('close');
        }
    };

})(jQuery);

(function ($) {

    Hatena.Diary.Pages.Blogs['realtime_preview'] = function() {
        try{
            if (!window.sessionStorage) { return; }

            var editor_id = $('#realtime-preview-content').attr('data-editor-id');
            if (!editor_id) { return; }

            var $wrapper = $('#realtime-preview-wrapper');

            var pos = sessionStorage.realtime_previewed_scroll_position ? JSON.parse(sessionStorage.realtime_previewed_scroll_position) : null;
            if (pos && pos.editor_id == editor_id) {
                $wrapper.scrollTop(pos.top);
                $wrapper.scrollLeft(pos.left);
            }

            $wrapper.scroll(_.throttle(function() {
                sessionStorage.realtime_previewed_scroll_position = JSON.stringify({
                    editor_id : editor_id,
                    top: $wrapper.scrollTop(),
                    left: $wrapper.scrollLeft()
                });
            }, 100));
        } catch (_ignored) {}
    };

})(jQuery);

(function($){

    Hatena.Diary.Pages.Blogs['preview-draft'] = function() {
        $(function () {
            // 記事情報のボックスを出す
            var $box         = $('.js-preview-draft-modal');
            var $closeButton = $box.find('.js-preview-draft-modal-btn');

            $closeButton
                .focus()
                .on('click', function () {
                    $box.addClass('is-hidden');
                });
        });
    };

})(jQuery);

// touch版の編集画面, 投稿完了画面でtwitterの文字数をバリデーションを行います
(function($) {
    Hatena.Diary.Touch  = Hatena.Diary.Touch || {};
    Hatena.Diary.Touch.TwitterValidator = function () { this.init.apply(this, arguments) };
    Hatena.Diary.Touch.TwitterValidator.prototype = {
        init: function ($el) {
            this.$el = $el;
            this.$textarea = $el.find('textarea');
            this.$errorMessage = $el.find('.js-twitter-length-error');
            this.$checkBox =  $el.find('input[name="post_to_twitter"]');
            this.$shareButton =  $el.find('.js-touch-share-button');
            this.bindEvents();
        },
        bindEvents: function () {
            var self = this;
            self.$textarea.keyup(function() {
                if (Hatena.Diary.validationTweetLength(self.$textarea.val()) === false) {
                    self.showErrorMessage();
                    self.disabledCheckBox();
                    self.disabledShareButton();
                }
                else {
                    self.hideErrorMessage();
                    self.enabledCheckBox();
                    self.enabledShareButton();
                }
            });
        },
        hideErrorMessage: function() {
            this.$errorMessage.hide();
        },
        showErrorMessage: function() {
            this.$errorMessage.show();
        },
        disabledCheckBox: function() {
            this.$checkBox.attr('disabled', true);
        },
        enabledCheckBox: function() {
            this.$checkBox.attr('disabled', false);
        },
        disabledShareButton: function() {
            this.$shareButton.attr('disabled', true);
        },
        enabledShareButton: function() {
            this.$shareButton.attr('disabled', false);
        }
    };
})(jQuery);

(function($){

Hatena.Diary.Pages.AdminTouch['*'] = function () {
    Hatena.Locale.setupTimestampUpdater();
    $('label').click(function () {}); // Mobile safari は onclick つけないと label が効かないらしい

    Hatena.Diary.Pages.AdminTouch['*'].androidAppBanner.init();
};

Hatena.Diary.Pages.AdminTouch['*'].androidAppBanner = {
    init : function () {
        // Androidアプリ用のバナー

        var self = this;

        var $banner = $('#android-app-banner');

        if ($banner.length === 0) {
            return;
        }
        var $closeButton = $('#android-app-banner-close');

        $closeButton.click(function (e) {
            $banner.slideToggle(400);
            self.setDismiss(true);
        });

        if (!self.isDismissed()) {
            setTimeout(function () {
                $banner.slideToggle(400);
            }, 0);
        }
    },

    _localStorageKey : 'Hatena.Diary.Pages.AdminTouch.dismissAndroidAppBanner',

    _localStorageEnabled : function () {
        try {
            if (window.localStorage) {
                return true;
            }
        } catch (ignore) {}
        return false;
    },

    isDismissed : function () {
        // 非表示に設定されているかどうか
        var self = this;
        if (self._localStorageEnabled()) {
            return localStorage.getItem(self._localStorageKey) === 'true';
        }
        return false;
    },

    setDismiss : function (dismissed) {
        // 非表示に設定する
        var self = this;
        if (self._localStorageEnabled()) {
            localStorage.setItem(self._localStorageKey, dismissed ? 'true' : 'false');
        }
    }
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['index'] = function () {
    var tabs   = $('#admin-top-tab');
    var navs   = $('#admin-top-tab .nav-cell');
    var panels = $('#config-container > .section');

    var loaded = false;
    $(window).load(function () { loaded = true });

    navs.click(function () {
        var $this = $(this);
        navs.removeClass('selected');
        navs.find('a img').each(function () {
            if (/-selected/.test(this.src)) {
                this.src = this.src.replace(/-selected/, '');
            }
        });
        panels.hide();

        var a = $this.find('a');
        $this.addClass('selected');
        a.find('img').each(function () {
            this.src = this.src.replace(/\.([^.\/]+)$/, '-selected.$1');
        });

        var panel = panels.filter(a.attr('href'));
        panel.show();

        tabs.trigger('tabsactivate', { panel : { id : panel.attr('id') } });

        if ('replaceState' in history && loaded) {
            var hash = (a.attr('href').match(/(#.+)/))[0];
            if (hash) {
                history.replaceState(null, document.title, hash);
            }
        }

        // antenna
        var $closedBlogs = $('.closed-blog');
        $closedBlogs.each(function(){
            var $closedBlog = $(this);
            var antennaUrl = $closedBlog.data("antennaUrl");
            $.ajax({
                type: 'GET',
                url: antennaUrl,
                data: { device: 'touch' },
                dataType: 'html',
                crossDomain: true,
                xhrFields: {
                        withCredentials: true
                }
            }).done(function(res){
                $closedBlog.empty();
                $closedBlog.append(res);
                var $blogContents = $closedBlog.find('.js-blog-content');
                Hatena.Locale.updateTimestamps($blogContents[0]);
            });
        });
        return false;
    });

    var BASE     = location.hostname.match(/\.hatena\.[^:]+/)[0];
    var notifyCount = $('#admin-top-tab .notify-count').hide();
    $.getJSON("https://www" + BASE + "/notify/notices.count.json?callback=?", function (res) {
        if (res.count) {
            notifyCount.text(res.count).show();
        }
        Hatena.Diary.Util.needComrule2013(res);
    });

    tabs.on('tabsactivate', function (e, ui) {
        if (ui.panel.id == 'notify') {
            notifyCount.hide();
            var notifyContainer = $('#notify').empty();
            var uri = 'https://www' + BASE + '/notify/notices.iframe?' + new Date().getTime();
            $('<iframe style="width: 100%; height: 340px; margin: 5px 0; padding: 0" frameborder="0"/>').attr('src', uri).appendTo(notifyContainer);
        }
    });

    var selected = navs.filter(function () {
        return $(this).find('a').filter(function () { return $(this).attr('href') == location.hash }).length !== 0;
    });
    (selected.length ? selected : navs.eq(0)).click();

    Hatena.Diary.Pages.AdminTouch['user-blog-entries'].setupEntryListLinks();

    Hatena.Diary.Pages.AdminTouch['index'].getDashboardData();
};

Hatena.Diary.Pages.AdminTouch['index'].getDashboardData = function () {
    $.ajax({
        type: 'GET',
        url: '/-/dashboard_data',
        data: { device: 'touch' }
    }).done(function(data) {
        $('section#subscribe').append(data.subscribing_blogs);
        $('section.js-hotentry-container').append(data.hot_entries);
    });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['antenna'] = function () {

    var $closedBlogs = $('.closed-blog');
    $closedBlogs.each(function(){
        var $closedBlog = $(this);
        var antennaUrl = $closedBlog.data("antennaUrl");
        $.ajax({
            type: 'GET',
            url: antennaUrl,
            data: { device: 'touch' },
            dataType: 'html',
            crossDomain: true,
            xhrFields: {
                withCredentials: true
            }
        }).done(function(res){
            $closedBlog.empty();
            $closedBlog.append(res);
            var $blogContents = $closedBlog.find('.js-blog-content');
            Hatena.Locale.updateTimestamps($blogContents[0]);
        });
    });

};

})(jQuery);

(function ($) {

    Hatena.Diary.Pages.AdminTouch['config'] = function () {
        Hatena.Diary.Util.updateDynamicPieces($('#user-config'));
    };

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['globalheader'] = function () {
    Messenger.listenToParent();

    Hatena.Diary.Pages.loadInfo().done(function (info, privateInfo) {
        Hatena.Diary.Pages.AdminTouch['globalheader'].initSubscribe(info);
        Hatena.Diary.Pages.AdminTouch['globalheader'].initQuoteStock(info);
    });
};

// スマフォグローバルヘッダの購読ボタン
Hatena.Diary.Pages.AdminTouch['globalheader'].initSubscribe = function (info) {
    // ブログがないときは何もしない
    // 自分のブログには読者になる出さない
    // 購読中も出さない
    if (!info.blog) return;
    if (info.can_open_editor) return;
    if (info.subscribe) return;

    var $container = $('.js-subscribe-container');
    var $link = $container.find('.js-subscribe-link');

    // リンク先設定
    $link.attr('href', info.subscribe_url);

    // 購読ボタン表示
    $container.show();
};

Hatena.Diary.Pages.AdminTouch['globalheader'].initQuoteStock = function (info) {

    Messenger.addEventListener('stockQuote', function (data) {
        if (!data.uri || !data.selected_text) {
            Messenger.send('failStockQuote', {});
        }

        $.ajax({
            url           : '/api/quotes',
            data: {
                uri  : data.uri,
                body : data.selected_text,
                rkm  : Hatena.Diary.data('rkm'),
                rkc  : Hatena.Diary.data('rkc')
            },
            cache         : false,
            type          : 'post',
            dataType      : 'json'
        }).done(function (res) {
            Messenger.send('successStockQuote', {
                res : res
            });
        }).fail(function (res) {
            Messenger.send('failStockQuote', {
                res : res
            });
        });
    });

    // 編集サイドバーの「引用貼り付け」を開き、かつ、
    // ストックした最新の引用を記事に埋め込んだ状態の編集画面を開く
    // admin -> blogs
    Messenger.addEventListener('quote-edit-entry', function (data) {
        if (data.quote !== undefined) {
            localStorage.setItem('reQuote', JSON.stringify(data.quote));
        }
        Messenger.send('new-entry-with-quote', {});
    });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['locale'] = function () {
  $('a.js-set-language').on('click', function () {
      var $this = $(this);
      var lang = $this.attr('data-lang');
      Hatena.Locale.setAcceptLang(lang);
      location.href = Hatena.Diary.Location.param('location') || '/';
      return false;
  });
};

})(jQuery);

(function () {

Hatena.Diary.Pages.AdminTouch['topic-show'] = function () {
    var $description = $('.description');
    var $topic_entries_tabs = $('#topic-entries-tabs');

    // 「続きを読む」をクリックすると説明文をすべて表示する
    $description.find('.read-more').on('click', function (e) {
        e.preventDefault();
        var $read_more_text = $description.find('.read-more-text');
        $description.html( $read_more_text.html() );
    });

    // 「注目」と「新着」タブの切替
    $topic_entries_tabs.tabs({ active : 0 });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['user-blog-action'] = function () {
    Messenger.listenToParent();
    Messenger.send('resize', {
        height: $(document.body).height()
    });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['user-blog-accesslog'] = function () {
    var table = $('#access-counts').remove();
    var counts = {};
    table.find('tr').each(function () {
        var $this = $(this);
        var time  = +$this.find('td[data-time]').attr('data-time');
        var count = +$this.find('td[data-count]').attr('data-count');
        counts[time] = count;
    });

    AccessLog.showGraph(counts, {
        parent : $('#access-counts-daily'),
        timeformat : '%m/%d',
        minTickSize : [1, 'day'],
        unit   : 24 * 60 * 60 * 1000,
        number : 14,
        graphAreaMarginRight : 20,
        barWidth : 15
    });

    AccessLog.showGraph(counts, {
        parent : $('#access-counts-hourly'),
        timeformat : '%d %H:%M',
        minTickSize : [1, 'hour'],
        unit   : 60 * 60 * 1000,
        number : 24,
        graphAreaMarginRight : 20,
        barWidth : 10
    });

    $('#access-counts-tabs').tabs({ active : 0 });

    $('#summary-detail-tabs').tabs({ active : 0 });

    $('.summary-box .hosts').delegate('.host', 'click', function() {
        $('.summary-box .hosts .selected').removeClass('selected');
        $(this).addClass('selected');

        var host = $(this).attr('data-site-host');
        $('.summary-box .site.selected').removeClass('selected');
        $('.summary-box .sites').find('*[data-site-host="' + host + '"]').addClass('selected');
        return false;
    });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['user-blog-comment'] = function () {
    Messenger.listenToParent();

    // CAPTCHAなど画像あるとき読み込むと高さ変わる
    var $img = $('img');
    if ($img.length > 0) {
        $('img').on('load', Hatena.Diary.Util.sendResizeRequest);
    }

    Hatena.Diary.Util.sendResizeRequest();
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['user-blog-comment-done'] = function () {
    Messenger.listenToParent();

    var comment = document.getElementById('posted').value;

    Messenger.send('update', { comment : comment });

    Messenger.send('close');
};

})(jQuery);

(function($){

    Hatena.Diary.Pages.AdminTouch['user-blog-config-permission'] = function () {
        new Hatena.Diary.BlogPermission($('#blog-permission-container'));
    };

})(jQuery);

(function($) {

    /**
     * TODO : PC版のDesignDetailPageの関数を呼んでるので
     * リファクタリング後に直接呼ぶようにする
     */
    Hatena.Diary.Pages.AdminTouch['user-blog-config-design-detail'] = function () {
        Hatena.Diary.Ctrl.DesignDetail.setupTextareaHider();
        Hatena.Diary.Ctrl.DesignDetail.setupTouchHeaderImageComponent({
            $container     : $('.js-header-image-container'),
            previewUpdater : null,
        });
    };
})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['user-blog-edit'] = function () {

    var editEntry = $('#edit-entry');

    if (Hatena.Diary.Pages.AdminTouch['user-blog-edit'].contentEditableEnabledAndEditorModeIsHTML()) {

        var textarea = editEntry.find('textarea#entry-body');
        var iframe = $('<iframe src="about:blank" frameborder="0">')
                     .attr('id', 'entry-html-body')
                     .prependTo('div.edit-body');

        var wysiwygDocument = iframe.prop('contentDocument');
        var body = textarea.val();
        // 初投稿の場合は <p> を入れておく
        if (!body && !$('form#edit-form input[name="entry"]').val()) {
            body = '<p><br/></p>';
        }
        var link = wysiwygDocument.createElement('link');
        link.setAttribute('type', 'text/css');
        link.setAttribute('rel',  'stylesheet');
        link.setAttribute('href', Hatena.Diary.data('admin-domain') + '/css/touch/blog-edit.css');

        wysiwygDocument.getElementsByTagName('head')[0].appendChild(link);
        wysiwygDocument.body.innerHTML = body;
        wysiwygDocument.body.contentEditable = true;
        wysiwygDocument.body.addEventListener('keyup', function () {
            textarea.val(wysiwygDocument.body.innerHTML);
        }, true);

        $('form#edit-form').append($('<input type="hidden" name="wysiwyg" value="1">')).submit(function () {
            $('textarea#entry-body').val(wysiwygDocument.body.innerHTML);
        }).bind('backup-restore', function () {
            wysiwygDocument.body.innerHTML = textarea.val();
        });

        // これしないと Safari で入力できなくなる
        $('input#entry-title').blur(function () {
            iframe.focus();
        });

        // 編集中にリンクをクリックすると別の画面に遷移しているためclickイベントを無効化してる
        $(wysiwygDocument).on('click', "a", function() {
            return false;
        });

        textarea.hide();
    }

    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupUpload();

    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupMyCuration();

    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupScheduledEntry();

    if (Hatena.Diary.Pages.AdminTouch['user-blog-edit'].dateTimeEditorEnabled()) {
        Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupDateTimeEditor();
    }

    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupOptionsToggle();
    new Hatena.Diary.Touch.TwitterValidator($('.js-touch-edit-socialize-box-li.twitter'));

    Hatena.Diary.Backup.createMessage($('#edit-form'));
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupOptionsToggle = function () {
    var $options = $('.post-options');
    $('.js-toggle-options').on('click', function() {
        $options.toggle();
        $(document).scrollTop($options.position().top);
        return false;
    });
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].execCommand = function (command, value) {
    var editor = tinymce.get('entry-body');
    editor.execCommand(command, false, value);
    editor.save();
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].contentEditableEnabledAndEditorModeIsHTML = function() {
    // Android のデフォルトブラウザは避ける
    // (Opera Mobile はそもそも contentEditable 非対応)
    var editEntry = $('#edit-entry');
    var ua = navigator.userAgent;
    var isMobileSafari = /\b(?:iPhone|iPad)\b/.exec(ua) && /\bVersion\/(\d+\.\d+)/.exec(ua) && Number(RegExp.$1) >= 5.1;
    var isAndroidChrome = /\bAndroid\b/.exec(ua) && /\bChrome\b/.exec(ua);
    return editEntry.attr('data-entry-syntax') == 'html' && 'contentEditable' in document.body &&
        (isMobileSafari || isAndroidChrome);
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].pickColor = function (callback) {
    var button = $('#edit-entry .toolbar button[data-action="color"]');
    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].ColorPicker.show(button.offset(), function (e, color) {
        callback(color);
    });
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].fontSize = function (delta) {
    var selection = tinymce.get('entry-body').selection;

    var span = selection.getNode();
    if (span.nodeName.toLowerCase() != 'span')  {
        span = document.createElement('span');
        span.setAttribute('style', 'font-size: ' + (100 + delta) + '%');

        var range = selection.getRng();
        range.surroundContents(span);
        selection.setRng(range);
    } else {
        var remove = false;
        span.setAttribute('style', span.getAttribute('style').replace(/font-size:\s*(\d+)%|$/, function (_, size) {
            if (typeof(size) == 'undefined') size = 100;
            size = +size + delta;
            if (size == 100) remove = true;
            return 'font-size:' + size + '%';
        }));

        if (remove) {
            var frag = document.createDocumentFragment();
            while (span.firstChild) frag.appendChild(span.firstChild);
            span.parentNode.insertBefore(frag, span);
            span.parentNode.removeChild(span);
        }
    }
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText = function(text) {
    if ($('iframe#entry-html-body').length > 0) {
        this.insertText.contentEditable(text);
    } else if (navigator.userAgent.match(/3DS/)) {
        this.insertText.textarea3DS(text);
    } else {
        this.insertText.textarea(text);
    }
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText.textarea = function(text) {
    var $textarea = $('textarea#entry-body');
    var textarea = $textarea[0];
    var val = $textarea.val();

    var range = {
        start: textarea.selectionStart,
        end: textarea.selectionEnd
    };

    $textarea.val(val.substring(0, range.start) + text + val.substring(range.end));
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText.textarea3DS = function(text) {
    // 3DSではselectionStartとか取れないので，必ずテキストエリアの最後に挿入する

    var $textarea = $('textarea#entry-body');
    var val = $textarea.val();

    var lastChar = val[val.length - 1];
    var middle = '';
    if (lastChar === "\n" || lastChar === undefined) {
        // do nothing
    } else {
        middle = "\n";
    }

    $textarea.val(val + middle + text + "\n");
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText.contentEditable = function(text) {
    // 雑談: focusしてからじゃないとexecCommandできない
    var contentDocument = $('#entry-html-body').prop('contentDocument');
    contentDocument.body.focus();
    contentDocument.execCommand('insertHTML', false, text);
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].EDITOR_ACTIONS = {
    bold : function () {
        // http://www.tinymce.com/wiki.php/Command_identifiers
        this.execCommand('Bold');
    },

    italic : function () {
        this.execCommand('Italic');
    },

    strike : function () {
        this.execCommand('StrikeThrough');
    },

    underline : function () {
        this.execCommand('Underline');
    },

    removeFormat : function () {
        this.execCommand("removeFormat");
        this.execCommand("unlink");
    },

    fontSizeIncl : function () {
        this.fontSize(+10);
    },

    fontSizeDecl : function () {
        this.fontSize(-10);
    },

    unorderedList : function () {
        this.execCommand("InsertUnorderedList");
    },

    orderedList : function () {
        this.execCommand("InsertOrderedList");
    },

    color : function () {
        var self = this;
        self.pickColor(function (color) {
            if (color) {
                self.execCommand("ForeColor", color);
            } else {
                self.execCommand("RemoveFormat");
            }
        });
    },

    link : function () {
        var url = prompt('URL');
        if (url) {
            url = url.toLowerCase();
        }
        this.execCommand("CreateLink", url);
    }
};

// from editor/editor.js
Hatena.Diary.Pages.AdminTouch['user-blog-edit'].ColorPicker = {
    show : function (position, callback) {
        var container = Hatena.Diary.Pages.AdminTouch['user-blog-edit'].ColorPicker.container;
        if (!container) {
            container = $('<div class="hatena-diary-color-picker" tabindex="0"><a href="#" class="color-chip default" data-color="">' + Hatena.Locale.text('default') + '</a></div>').appendTo(document.body).hide();
            container.delegate('.color-chip', 'click', function () {
                var color = $(this).attr('data-color');
                container.trigger('colorpick', color);
                container.hide();
                return false;
            });

            var padding = 8;
            var size    = 30;

            var colors = [
                ['#ffffff', '#cccccc', '#999999', '#666666', '#333333', '#000000'],
                ['#cc0000', '#cc00cc', '#0000cc', '#00cccc', '#00cc00', '#cccc00'],
                ['#990000', '#990099', '#000099', '#009999', '#008800', '#aaaa00'],
                ['#660000', '#660066', '#000066', '#006666', '#006600', '#666600'],
                ['#330000', '#330033', '#000033', '#003333', '#003300', '#333300']
            ];

            container.css({
                width: colors[0].length * (size + padding) + padding,
                height: (colors.length + 1) * (size + padding) + padding
            });

            var defcol = container.find("a").css({
                top: padding,
                left: padding,
                height: size,
                width: container.width() - padding * 2
            });

            var chip = $('<a href="#" class="color-chip"></a>');
            for (var i = 0, it; (it = colors[i]); i++) {
                for (var j = 0, col; (col = it[j]); j++) {
                    chip.clone().attr('data-color', col).css({
                        top: (i + 1) * (size + padding) + padding,
                        left: j * (size + padding) + padding,
                        background: col,
                        width : size,
                        height : size
                    }).appendTo(container);
                }
            }

            Hatena.Diary.Pages.AdminTouch['user-blog-edit'].ColorPicker.container = container;
        }

        container.unbind('colorpick');
        container.bind('colorpick', callback);

        container.css(position);
        container.fadeIn('fast');

        container.focus();
        $(container).one('blur', function () { container.hide() });
    }
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupUpload = function() {
    var can_upload_file = function() {
        // http://stackoverflow.com/questions/8077955/detect-if-input-type-file-is-supported
        var elem = document.createElement('input');
        elem.type = 'file';
        return !elem.disabled;
    };
    if (!can_upload_file()) return;

    var $container = $('.toolbar-container');
    $container.show();

    var can_use_form_data = (typeof FormData != 'undefined');

    if (can_use_form_data) {
        Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupAjaxUpload();
    } else {
        Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupIframeUpload();
    }
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupAjaxUpload = function() {
    var $container = $('.toolbar-container');
    var $file_input = $container.find('input[type=file]');

    $file_input.change(function () {
        if ( ! this.files.length > 0 ) return;
        Hatena.Diary.Pages.AdminTouch['user-blog-edit'].uploadImage({
            $input   : $file_input,
            $progress: $container.find('.progress')
        }).done(Hatena.Diary.Pages.AdminTouch['user-blog-edit'].uploadDone)
        .fail(function(res) {
            alert(Hatena.Locale.text('admin.blog.config.image_upload_failure'));
        });
        Hatena.Diary.EventTracker.trackEvent('upload-photo-smartphone');
    });
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupIframeUpload = function() {
    var $container = $('.toolbar-container');
    var $file_input = $container.find('input[type=file]');

    $container.addClass('iframe-uploader');

    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setIframeUploader({
        fileinput : $container.find('.file-container'),
        fotosize  : 1024,
        callback  : Hatena.Diary.Pages.AdminTouch['user-blog-edit'].uploadDone
    });
};

// admin.jsからコピペ→書き換え
Hatena.Diary.Pages.AdminTouch['user-blog-edit'].uploadImage = function (args) {
    var folder = args.folder || "Hatena Blog";
    var fotosize = args.fotosize || 1024;
    var $input = args.$input;
    var image = $input.prop('files')[0];
    var $progress = args.$progress;
    var dfd = $.Deferred();

    $input.prop('disabled', true);

    var data = new FormData();
    data.append('rkm', Hatena.Diary.data('rkm'));
    data.append('append', 1);
    data.append('fototitle', "");
    data.append('folder', folder);
    data.append('fotosize', fotosize);
    data.append('image', image);
    data.append('delete-gps', 1);

    $progress.show();
    var $bar = $progress.find('.bar');
    $bar.width('0%');
    var $percent = $progress.find('.percent');
    var updateProgress = function (percent) {
        if (percent > 100) percent = 100;
        $bar.width(percent + '%');
        $percent.text(Hatena.Locale.text('uploading'));
    };

    var xhr = new XMLHttpRequest();

    xhr.upload.addEventListener("progress", function (e) {
        var percent = e.lengthComputable ? (e.loaded / e.total * 100) : NaN;
        updateProgress( percent );
    }, false);

    xhr.addEventListener("load", function (e) {
        updateProgress( 100 );
        $progress.hide();
        $input.prop('disabled', false);

        if (xhr.status !== 200) {
            dfd.reject(xhr.responseText);
            return;
        }

        var fotolife_syntax = xhr.responseText;
        dfd.resolve(fotolife_syntax);

    }, false);

    xhr.addEventListener("error", function (e) {
        $progress.hide();
        $input.prop('disabled', false);
        dfd.reject(e);
    }, false);

    xhr.open("POST", "/f/" + Hatena.Diary.data('name') + "/upbysmart?dummy=" + (new Date()).getTime());
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.send(data);

    return dfd;
};

// admin.jsからコピペ→ちょっと書き換え(callback呼ぶかどうかのところ)
Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setIframeUploader = function (args) {
    var fileinput = args.fileinput;
    var fotosize = args.fotosize;
    var callback = args.callback;

    var iframe = $('<iframe/>');
    fileinput.replaceWith(iframe);
    var src = "/api/upload/fotolife_smart";
    iframe.attr('src', src);
    iframe.addClass('uploader');
    iframe.load(function () {
        var document;
        if (iframe[0].contentDocument) {
            document = iframe[0].contentDocument;
        } else if (iframe[0].contentWindow) {
            document = iframe[0].contentWindow.document;
        } else {
            return;
        }
        if (document.body.innerHTML.match(/^\s*(f:id:\S+)/)) {
            iframe[0].contentWindow.location.replace(src);
        }
        if (document.body.innerHTML.match(/f:id:([^:]+):(\d+)([jpg]):image/)) {
            callback(document.body.innerHTML);
        }

        $(document).find('input[name="fotosize"]').val(fotosize);
        var images = $(document).find('input[type="file"]');
        $(images[0]).change ( function () {
            $(document).find('#fotolife-upload-form').submit();
            $(images[0]).replaceWith($('<h5>').text(Hatena.Locale.text('uploading')));
        });
    });
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].uploadDone = function(fotolife_syntax) {
    Hatena.Diary.Pages.AdminTouch['user-blog-edit'].trackPhotoUpload();

    if (Hatena.Diary.Pages.AdminTouch['user-blog-edit'].contentEditableEnabledAndEditorModeIsHTML()) {
        // contentEditable有効なとき記法をHTMLに展開
        Hatena.Diary.extractFotolifeSyntax(fotolife_syntax).done(function(res) {
            Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText(res.html);
        });
    } else {
        Hatena.Diary.Pages.AdminTouch['user-blog-edit'].insertText('[' + fotolife_syntax.replace(/:image/, ':plain') + ']');
    }
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].trackPhotoUpload = function() {
    // アップロードされたときにfluentdに記録
    // XHRでアップロードかformでアップロードかでキーを変えています
    var track_name = (typeof FormData != 'undefined') ? 'photo-xhr-upload-touch' : 'photo-form-upload-touch';
    Hatena.Diary.EventTracker.trackEvent(track_name);
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupMyCuration = function() {
    $('[data-curation-action]').click(function() {
        var action = $(this).attr('data-curation-action');
        Hatena.Diary.EditorConnector.loadServiceOnChildWindow("/-/curation/" + action);
        Hatena.Diary.EventTracker.trackEvent('open-curation-' + action);
    });
};

// <input> type="date/time" が有効か
Hatena.Diary.Pages.AdminTouch['user-blog-edit'].dateTimeEditorEnabled = function() {
    var enable_list = _.map(['date', 'time'], function (type) {
        // 参照: http://stackoverflow.com/questions/10193294/how-can-i-tell-if-a-browser-supports-input-type-date
        var input = document.createElement('input');
        input.setAttribute('type', type);
        input.setAttribute('value', 'not-a-date');
        return input.type !== 'text' && input.value !== 'not-a-date';
    });

    return _.all(enable_list);
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupScheduledEntry = function() {
    // 日付あるとき，チェックボックス出す
    // チェックついてるとき，公開ボタン，下書きボタン，シェアUIを消して，予約投稿ボタン出す

    var $datetime = $('input[name=datetime]');
    var $checkbox = $('.js-scheduled-entry-checkbox');
    var $normalParts = $('.js-show-on-normal-post');
    var $scheduledParts = $('.js-show-on-scheduled-post');
    var $socializeBox = $('.js-touch-scheduled-socialize-box');

    // datetimeかcheckboxが更新されたら呼ばれる
    var updateParts = function() {
        if ($datetime.val()) {
            $checkbox.prop('disabled', false);
        } else {
            $checkbox.prop('disabled', true);
        }

        if ($datetime.val() && $checkbox.prop('checked')) {
            $normalParts.hide();
            $scheduledParts.show();
            $socializeBox.show();
        } else {
            $normalParts.show();
            $scheduledParts.hide();
            $socializeBox.hide();
        }
    };

    $datetime.on('change', updateParts);
    $checkbox.on('change', updateParts);

    updateParts();
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit'].setupDateTimeEditor = function() {
    $('.post-options .js-datetime').show();

    var $date = $('.js-datetime-input-date');
    var $time = $('.js-datetime-input-time');
    var $datetime = $('input[name=datetime]');

    // 値を設定するだけでなく,changeイベントも発行する．予約投稿JSがdatetimeのchangeイベント見てるため
    var setDatetime = function(value) {
        $datetime.val(value).trigger('change');
    };

    // admin-user-blog-edit.jsからのコピペ
    var todayString = function () {
        var now = new Date();
        var date = [];
        date.push((1900 + now.getYear()).toString());
        date.push(('0' + (1 + now.getMonth()).toString()).slice(-2));
        date.push(('0' + now.getDate().toString()).slice(-2));
        return date.join('-');
    };

    // 投稿日時があるとき(既に投稿されたエントリを編集するとき), フィルインする
    var entry_datetime = $datetime.val() || '';
    var match_data = entry_datetime.match(/^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2})\+(\d{2}:\d{2})$/);
    if (match_data) {
        var date = match_data[1];
        var time = match_data[2];

        $date.val(date);
        $time.val(time);
    }

    $date.change(function() {
        var date = $date.val();
        var time = $time.val();

        // 消去されたとき, 初期値に戻す
        if (!date) {
            setDatetime(entry_datetime);
            return;
        }

        if (!time) {
            $time.val('00:00');
            time = '00:00';
        }

        setDatetime(date + 'T' + time);
    });

    $time.change(function() {
        var date = $date.val();
        var time = $time.val();

        // 消去されたとき, 初期値に戻す
        if (!time) {
            setDatetime(entry_datetime);
            return;
        }

        if (!date) {
            var today = todayString();
            $date.val(today);
            date = today;
        }

        setDatetime(date + 'T' + time);
    });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.AdminTouch['user-blog-edit-done'] = function () {
    Hatena.Diary.Pages.AdminTouch['user-blog-edit-done'].postToSocialService();
    new Hatena.Diary.Touch.TwitterValidator($('.js-touch-edit-socialize-box-li.twitter'));
};

Hatena.Diary.Pages.AdminTouch['user-blog-edit-done'].postToSocialService = function () {
    var entry_id = $('.js-touch-socialize-box').data('entry-id');

    var PostToSocialService = function (entry_id) {
        this.init(entry_id);
    };
    PostToSocialService.prototype = {
        init: function (entry_id) {
            this.entry_id = entry_id;
        },
        setServiceName: function (service_name) {
            this.service_name = service_name;
        },
        setMessage: function (message) {
            this.message = message;
        },
        validateMessage: function () {
            var self = this;
            // twitterの場合文字数制限があるのでチェックする
            // 判定には公式ライブラリ使ってる
            if (self.service_name === 'twitter') {
                if (Hatena.Diary.validationTweetLength(self.message) === false) return false;
            }

            return true;
        },
        isAjaxRunning: false,
        post: function() {
            var self = this;

            var dfd = $.Deferred();

            // 連打されるとマルチポストになるので
            // 通信中かどうか見てrejectしてる
            if (self.isAjaxRunning === true) return dfd.reject();

            self.isAjaxRunning = true;

            $.ajax({
                url: 'post_to_social_service',
                type: 'POST',
                data: {
                    rkm: Hatena.Diary.data('rkm'),
                    rkc: Hatena.Diary.data('rkc'),
                    service_name: self.service_name,
                    entry_id: self.entry_id,
                    message: self.message
                }
            }).done(function () {
                dfd.resolve();
            }).fail(function() {
                dfd.reject();
            }).always(function () {
                self.isAjaxRunning = false;
            });

            return dfd.promise();
        }
    };

    var post_to_social_service = new PostToSocialService(entry_id);
    $('.js-touch-share-button').on('click', function (event) {

        var $el = $(event.target);

        if ($el.attr('disabled')) return false;

        var $li = $el.closest('li');

        var confirm_message = Hatena.Locale.text('blog.social.share.confirm', Hatena.Locale.text('blog.social.service.name.' + $el.data('service-name')));
        if (! confirm(confirm_message)) return false;

        var $validation_error_message = $li.find('.js-validation-error');
        var $share_success_message = $li.find('.js-share-success-message');

        // 複数回投稿した時にメッセージ残ってるので最初に消しておく
        $validation_error_message.hide();
        $share_success_message.hide();

        post_to_social_service.setServiceName($el.data('service-name'));
        post_to_social_service.setMessage($li.find('.js-share-message').val());

        // メッセージのvalidationに引っかからなかったら投稿する
        if (post_to_social_service.validateMessage()) {
            post_to_social_service.post().done(function () {
                $share_success_message.show();
            });
        }
        else {
            // validationに引っかかったらメッセージ出してあげる
            $validation_error_message.show();
        }

        return false;
    });
};

})(jQuery);

(function () {

Hatena.Diary.Pages.AdminTouch['user-blog-entries'] = function () {
    Hatena.Diary.Pages.AdminTouch['user-blog-entries'].setupEntryListLinks();
};

Hatena.Diary.Pages.AdminTouch['user-blog-entries'].setupEntryListLinks = function () {
    $('ul#entries li').click(function (e) {
        if ($(e.target).parents('a').length === 0) {
            location.href = $(this).find('a:first').attr('href');
        }
    });
};

})(jQuery);

(function($){

var BlogsTouch = function () {

    // iframeからはアクセスログのapiを叩かない
    if (window.parent === window ) {
        Hatena.Diary.AccessLog.ping();
        Hatena.Diary.Blogs.trackBlogVisit();
    }

    Hatena.Diary.Pages.infoLoaded.done(function(info) {
        BlogsTouch.init(info);

        // entryページのみで引用スターを有効化
        if (Hatena.Diary.data('page') === 'entry' && info.quote) {
            Hatena.Diary.Quote.Touch.init(info.quote);
        }
    });

    Hatena.Diary.Util.updateDynamicPieces([document]);

    BlogsTouch.initFooterAction();
    BlogsTouch.setupOndemandCommentDeleteButton();
    Hatena.Diary.Star.initBigStar();

    Hatena.Diary.Blogs.Module.init();
};

BlogsTouch.init = function (info) {
    // グローバルヘッダから情報もらえるので，使いたかったらここで使う

    Hatena.Diary.Browser.thirdPartyCookiesBlocked.resolve(!info.cookie_received);

    // globalhaederがキャッシュされているのでこちらからviaを送ってやる
    var via = Hatena.Diary.Location.param('via');
    if (via) {
        Messenger.send('inheritVia', via);
    }

    // 購読ボタンと購読者数の同期
    Hatena.Diary.Blogs.SubscribeButtonSynchronizer.init(info.subscribe, info.subscribes);
};

BlogsTouch.setupOndemandCommentDeleteButton = function() {
    $(document).on('mouseenter', '.js-entry-comment', function() {
        var $comment = $(this);
        if ($comment.find('.js-comment-delete-button .js-comment-delete-image').size() > 0)
            return;
        var comment_uuid = $comment.attr('data-comment-uuid');
        var blog_uuid = $comment.attr('data-blog-uuid');
        var url = Hatena.Diary.data('admin-domain') + '/api/comment.delete.image?comment=' + comment_uuid + '&blog=' + blog_uuid;
        var $img = $('<img>');
        $img.addClass('js-comment-delete-image');
        $img.attr('src', url);
        var handler = function() {
            $img.attr('alt', 'delete');
        };
        $img.load(handler);
        $img.error(handler);
        $comment.find('.js-comment-delete-button').append($img);
    });
};

BlogsTouch.initFooterAction = function () {
    var footerAction = $('iframe.js-footer-action');
    if (footerAction.length) {
        try {
            var messenger = Messenger.createForFrame(footerAction.get(0), footerAction.attr('data-src'));
            messenger.addEventListener('resize', function (css) {
                if (css) footerAction.css(css);
            });
        } catch(ignore) {
            // AndroidではMessenger作るのに失敗してSecurityErrorが発生する場合がある
            // 通信できなかったら仕方ないのであきらめる
        }
    }
};

Hatena.Diary.Pages.BlogsTouch['*'] = BlogsTouch;

})(jQuery);

(function ($) {

Hatena.Diary.Pages.BlogsTouch['entry'] = function () {
    var entries = $('.js-entry-article').toArray().map(function (entry) {
        return new Hatena.Diary.BlogsTouch.Entry($(entry));
    });
};

})(jQuery);

(function ($) {

Hatena.Diary.Pages.BlogsTouch['global-top'] = function () {
    // viaを引き継いでiframeを読み込む
    var via = Hatena.Diary.Location.param('via');
    var $dashboardLinks = $('iframe.js-dashboard-link');
    $dashboardLinks.each(function(index, element) {
        var $iframe = $(element);
        var src = $iframe.data('src').split(/\?/);
        var query = src[1] || '';

        var params = Hatena.Diary.Util.decodeParam(query);
        params['via'] = via;

        element.contentWindow.location.replace(src[0] + '?' + $.param(params, true));
    });

    $('img[data-alternate-src]').one('error', function() {
        var $img = $(this);
        $img.attr('src', $img.attr('data-alternate-src'));
    });

    $('.js-category-wrapper').tabs({
        selected : 0
    });

    // 標準のタブのUIではなく，nav-barのスタイルを当てたいので，クラス消す
    $('.js-category-wrapper .ui-tabs-nav').removeClass('ui-tabs-nav');
};

})(jQuery);
