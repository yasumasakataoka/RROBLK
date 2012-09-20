if (typeof HatenaGoogleAfc == 'undefined') {
    ad_num = 0;
    ad_line_count = 0;
    afc_tag_num = 1;
    // default properties
    google_ad_client = 'ca-hatena_js'; // client_id
    google_language = 'ja';
    google_ad_output = 'js';
    google_safe = 'high';
    if (typeof afc_view_limit == 'undefined')
        afc_view_limit = 5;
    if (typeof afc_title == 'undefined')
        afc_title = 'Ads by Google';
    if (typeof hatena_afc_lazy_load == 'undefined')
        hatena_afc_lazy_load = 0;
    if (typeof hatena_afc_lazy_load_id == 'undefined')
        hatena_afc_lazy_load_id = null;
    if (typeof hatena_afc_highlight_words == 'undefined')
        hatena_afc_highlight_words= null;
    if (typeof hatena_afc_highlight_order_words == 'undefined')
        hatena_afc_highlight_order_words = null;
    if (typeof hatena_afc_max == 'undefined')
        hatena_afc_max = 3;
    if (typeof google_max_num_ads == 'undefined')
        google_max_num_ads = 3;
    if (typeof google_encoding == 'undefined')
        google_encoding = 'utf8';
    if (typeof afc_format == 'undefined')
        afc_format = 'normal';

    var HatenaGoogleAfc = new function() {
        var self = this;

        // load CSS
        this.init = function () {
            var link = document.createElement('link');
            link.rel = 'stylesheet';
            link.type = 'text/css';
            link.href = "http://ad.hatena.ne.jp/css/google_afc.css";
            document.getElementsByTagName('head')[0].appendChild(link);

            // set callbacks
            window.afc_ad_request_done = window.google_ad_request_done = function (json_data, alt_title) {
                if (json_data.length < 1 || json_data[0].type == "html") {
                    if (self.alt_ad_called > 0) return;
                    document.write('<scri' + 'pt charset="utf-8" language="JavaScript" src="http://ad.hatena.ne.jp/data/alt.js"></scri' + 'pt>');
                    self.alt_ad_called = 1;
                    afc_title = "";
                    return;
                }
                if (alt_title) afc_title = alt_title;
                self.show_ads(json_data);
            };
        };
        this.call_api = function () {
            // call afc api
            document.write('<scri' + 'pt language="JavaScript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></scri' + 'pt>');
        };
        this.show_ads = function (json_data) {
            var jsonDataLength = ad_line_count = json_data.length;
            if (json_data.length < 1) return;

            if (json_data[0].type == "text") {
                ad_num = ad_num + jsonDataLength;
            }
            if (hatena_afc_lazy_load < 1 ) {
                document.write(this.create_ads(json_data));
            } else {
                if (jsonDataLength < 1) return;
                var afc_pos;
                if (hatena_afc_lazy_load_id) {
                    afc_pos = document.getElementById(hatena_afc_lazy_load_id);
                } else {
                    afc_pos = document.getElementById('google_afc_' + afc_tag_num);
                }
                if (afc_pos) {
                    var prop = afc_pos.className.substr(afc_pos.className.indexOf("google_afc_")).split(" ")[0].split("_");
                    if (prop[2]) afc_format = prop[2];
                    afc_pos.innerHTML = this.create_ads(json_data);
                }
            }
        };
        this.create_ads = function (json_data) {
            var afc_unit;
            if (json_data[0].type == "image" || json_data[0].type == "flash") {
                // image style banner
                var formatter = this.format_image;
                var classname = "google_afc_image";
                var container_tag = "div";

                if (json_data[0].type == "image" || json_data[0].type == "flash") {
                    afc_unit = [
                        '<div class="', classname, '">', 
                    ];
                }
            }
            else {
                // text banner
                if (afc_format == "rectangle") {
                    var formatter = this.format_rect;
                    var classname = "google_afc_rectangle";
                    var container_tag = "dl";
                } else if (afc_format == "blocklink") {
                    var formatter = this.format_blocklink;
                    var classname = "google_afc_blocklink";
                    var container_tag = "ul";
                } else if (afc_format == "blocklink-rectangle") {
                    var formatter = this.format_blocklink_rectangle;
                    var classname = "google_afc_blocklink_rectangle";
                    var container_tag = "ul";
                } else {
                    var formatter = this.format_normal;
                    var classname = "google_afc";
                    var container_tag = "dl";
                }

                afc_unit = [
                    '<div class="', classname, '">', 
                    '<div class="google_ads_by"><a href="https://www.google.com/adsense/support/bin/request.py?contact=abg_afc">', afc_title, '</a></div>',
                ];
            }
            if (typeof container_tag != 'undefined') {
                afc_unit.push('<', container_tag, '>');
            }
            for (var i = 0; i < afc_view_limit; ++i) {
                if (json_data.length < 1) break;
                var data = json_data.shift();

                if ( hatena_afc_highlight_order_words ) {
                    if (!(hatena_afc_highlight_order_words instanceof Array)) 
                        hatena_afc_highlight_order_words  = [hatena_afc_highlight_order_words];
                    try {
                        afc_unit.push(formatter(self.highlightOrder(data)));
                    } catch (e) {
                        afc_unit.push(formatter(data));
                    }
                } else if(hatena_afc_highlight_words && !self.isIE6() ) {
                    //do not highlight on IE6
                    try {
                        afc_unit.push(formatter(self.highlight(data)));
                    } catch (e) {
                        afc_unit.push(formatter(data));
                    }
                }else{
                    afc_unit.push(formatter(data));
                }
            }
            if (typeof container_tag != 'undefined') {
                afc_unit.push('</', container_tag, '>');
            }
            afc_unit.push('</div>');
            return afc_unit.join("");
        };
        this.format_normal = function (ad) {
            return [
                ad.n % 2 == 1 ? '<dt class="odd">' : '<dt>',
                '<a href="', ad.url, '">', ad.line1, '</a>',
                '<span class="visible_url"><a href="', ad.url, '">', ad.visible_url, '</a></span></dt>',
                ad.n % 2 == 1 ? '<dd class="odd">' : '<dd>',
                ad.line2, '&nbsp;', ad.line3, '</dd>'
            ].join("");

        };
        this.format_image = function (ad) {
            if (ad.type == "image") {
                return [
                    '<a href="' , ad.url,
                    '" target="_top" title="go to ' , ad.visible_url,
                    '"><img border="0" src="' , ad.image_url,
                    '" width="' , ad.image_width,
                    '" height="' , ad.image_height , ' "title="go to ', ad.visible_url, '"></a>',
                    '<table border="0" ',
                    'width="' , ad.image_width, '" ',
                    'height="11" cellspacing="0" cellpadding="0" style="width:', ad.image_width, ';" class="afc_footer"><tr><td>',
                    '<span class="visible_url"><a href="' , ad.url , '">',
                    ad.visible_url , '</a></span>',
                    '</td><td align="right"><span class="google_ads_by"><a href="https://www.google.com/adsense/support/bin/request.py?contact=abg_afc">',
                    afc_title, '</a></span></td></tr></table>'
                ].join("");
            } else if (ad.type == "flash") {
                return [
                    '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' ,
                    ' codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"' ,
                    ' WIDTH="' , ad.image_width ,
                    '" HEIGHT="' , ad.image_height , '">' ,
                    '<PARAM NAME="movie" VALUE="' , ad.image_url , '">' ,
                    '<PARAM NAME="quality" VALUE="high">' ,
                    '<PARAM NAME="AllowScriptAccess" VALUE="never">' ,
                    '<EMBED src="' , ad.image_url ,
                    '" WIDTH="' , ad.image_width ,
                    '" HEIGHT="' , ad.image_height ,
                    '" TYPE="application/x-shockwave-flash"' ,
                    ' AllowScriptAccess="never" ' ,
                    ' PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED></OBJECT>'
                ].join("");
            }
        };
        this.format_rect = function (ad) {
            return [
                ad.n % 2 == 1 ? '<dt class="odd">' : '<dt>',
                '<a href="', ad.url, '">', ad.line1, '</a></dt>',
                ad.n % 2 == 1 ? '<dd class="odd">' : '<dd>',
                ad.line2, '&nbsp;', ad.line3,
                '<div class="visible_url"><a href="', ad.url, '">', ad.visible_url, '</a></div></dd>'
            ].join("");
        };

        this.format_blocklink = function (ad) {
            return [
                ad.n % 2 == 1 ? '<li class="odd">' : '<li>',
                '<span class="title"><a href="', ad.url, '">', ad.line1, '</a></span>',
                '<span class="visible_url"><a href="', ad.url, '">', ad.visible_url, '</a></span>',
                '<span class="summary">', ad.line2, '&nbsp;', ad.line3, '</span></li>'
            ].join("");
        };

        this.format_blocklink_rectangle = function (ad) {
            return [
                ad.n % 2 == 1 ? '<li class="odd">' : '<li>',
                '<a href="', ad.url, '">',
                '<span class="title">', ad.line1, '</span>',
                '<span class="summary">', ad.line2, '&nbsp;', ad.line3, '</span>',
                '<span class="visible_url">', ad.visible_url, '</span></a></li>'
            ].join("");
        };

        this.highlight = function (ad) {
            for(var i = 0; i < hatena_afc_highlight_words.length; i++) {
                var regex = new RegExp(hatena_afc_highlight_words[i],"gi");
                ad.line1 = ad.line1.replace(regex,'<span style="background-color: #FFFF00">' + hatena_afc_highlight_words[i] + '</span>');
                ad.line2 = ad.line2.replace(regex,'<span style="background-color: #FFFF00">' + hatena_afc_highlight_words[i] + '</span>');
                ad.line3 = ad.line3.replace(regex,'<span style="background-color: #FFFF00">' + hatena_afc_highlight_words[i] + '</span>');
            }
            return ad;
        };

        // 優先順位付きハイライト
        // 最初にマッチした単語でハイライトを終わる
        this.highlightOrder = function (ad) {
            var words = hatena_afc_highlight_order_words;
            var escaper = function(word) {
                var res = [];
                for(var i = 0; i < word.length; i++) {
                    var cc = word.charCodeAt(i);
                    if (cc >= 255) {
                        res.push('&#' + cc + ';');
                    } else {
                        res.push(word.charAt(i));
                    }
                }
                word = res.join('');
                return word.replace(/\W/g,'\\$&');
            };
            for(var i = 0; i < words.length; i++) {
                var regex = new RegExp(escaper(words[i]),"gi");
                var matched = false;
                if (regex.test(ad.line1)) {
                    matched = true;
                    ad.line1 = ad.line1.replace(regex,'<span style="background-color: #FFFF00">' + words[i] + '</span>');
                }
                if (regex.test(ad.line2)) {
                    matched = true;
                    ad.line2 = ad.line2.replace(regex,'<span style="background-color: #FFFF00">' + words[i] + '</span>');
                }
                if (regex.test(ad.line3)) {
                    matched = true;
                    ad.line3 = ad.line3.replace(regex,'<span style="background-color: #FFFF00">' + words[i] + '</span>');
                }
                if (matched) break;
            }
            return ad;
        };

        this.isIE6 = function () {
            var version = parseFloat((/(?:Firefox\/|MSIE |Opera\/|Version\/)([\d.]+)/.exec(navigator.userAgent) || []).pop());
            if ( (navigator.userAgent.indexOf('MSIE') != -1) && (version < 7.0) ) {
                return true;
            } else {
                return false;
            }
        };

    };
    HatenaGoogleAfc.init();
    HatenaGoogleAfc.call_api();
}else{
    afc_tag_num += 1;
    ad_line_count = 0;
    // set default properties again since some properties become null after calling show_ads.js
    google_ad_client = 'ca-hatena_js';
    google_language = 'ja';
    google_ad_output = 'js';
    google_safe = 'high';
    if (typeof afc_view_limit == 'undefined')
        afc_view_limit = 5;
    if (typeof afc_title == 'undefined')
        afc_title = 'Ads by Google';
    if (typeof hatena_afc_lazy_load == 'undefined')
        hatena_afc_lazy_load = 0;
    if (typeof hatena_afc_lazy_load_id == 'undefined')
        hatena_afc_lazy_load_id = null;
    if (typeof hatena_afc_highlight_words == 'undefined')
        hatena_afc_highlight_words = null;
    if (typeof hatena_afc_highlight_order_words == 'undefined')
        hatena_afc_highlight_order_words = null;
    if (typeof hatena_afc_max == 'undefined')
        hatena_afc_max = 3;
    if (typeof google_max_num_ads == 'undefined')
        google_max_num_ads = 3;
    if (typeof google_encoding == 'undefined')
        google_encoding = 'utf8';
    if (typeof afc_format == 'undefined')
        afc_format = 'normal';
    if (typeof google_image_size == 'undefined')
        google_image_size = '300x250';
    google_skip = ad_num;

    HatenaGoogleAfc.call_api();
}