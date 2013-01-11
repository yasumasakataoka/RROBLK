if (typeof(Jugem) == 'undefined') Jugem = {};
if (typeof(Jugem.ads) == 'undefined') Jugem.ads = {};

var google_num_ads = 0;
var google_last_ad_type = '';
function google_ad_request_done(google_ads) {
    if (google_ads.length == 0) {
        return;
    }
    google_num_ads += google_ads.length;
    google_last_ad_type = google_ads[0].type;
    Jugem.ads.startRendering(google_ads);
}

function jg_ads_Hover(e,f){
    e.style.background = f ? '#ffffcc' : '';
    e.style.color = f ? '#000000' : '';
   // e.style.border = f ? '1px solid #ffffbb' : '0';
   // e.style.padding = f ? '5px' : '5px';
   e.className = f ? 'jg_ads_hover' : 'jg_ads_box';
}


Jugem.ads.inactiveRendered = false;

Jugem.ads.startRendering = function(ads) {
    var adAreaInactive = document.getElementById('gInactiveAdContainer');
    var adAreaEntry = document.getElementById('gEntryAdContainer');

    if (!adAreaInactive || Jugem.ads.inactiveRendered) {
        Jugem.ads.renderAds(ads, adAreaEntry);
    } else {
        Jugem.ads.inactiveRendered = true;
        Jugem.ads.renderAds(ads, adAreaInactive);
    }
}

Jugem.ads.renderAds = function(ads, elm) {
    var str = '';
    if (ads[0].type == "html") {
        str += ads[0].snippet;
    } else {
        str += '<div class="jugem_blog_ad_by" style="text-align: left;"><a href="' + google_info.feedback_url + '" target="_blank">Ads by Google</a></div>';
        for (var i=0; i<ads.length; i++) {
            var title = ads[i].line1;
            var line2 = ads[i].line2;
            var line3 = ads[i].line3;
            var url = ads[i].url;
            var visible_url = ads[i].visible_url;

            var image_url = ads[i].image_url;
            var image_width = ads[i].image_width;
            var image_height = ads[i].image_height;

            if (ads[i].type == "text") {
                str += '<style type="text/css">';
                str += '.jg_ads_hover a {color:#0000FE;} </style>';
                str += '<div style="margin: 2px 0pt 10px;" onmouseover="jg_ads_Hover(this,1);" onmouseout="jg_ads_Hover(this,0);">';
                str += '<div>';
                str += '<a href="' + url + '" style="text-decoration: underline;"><span style="font-size: 14px; font-weight:bold; line-height: 200%;">' + title + '</span></a>';
                str += '<a href="' + url + '" style="text-decoration: none;"><span style="margin-left: 10px; font-size: 12px; color:#33cc33; font-weight:bold;">' + visible_url + '</span></a>';
                str += '</div>';
                str += '<span style="font-size: 12px; font-weight: normal;">' + line2 + line3 + '</span>';
                str += '</div>';
            } else if (ads[i].type == "image") {
                str += '<div style="margin: 2px 0pt 10px;">';
                str += '<div>';
                str += '<a href="' + url + '" target="_top" title="' + visible_url + '">';
                str += '<img border="0" src="' + image_url + '" width="' + image_width + '" height="' + image_height + '" />';
                str += '</a>';
                str += '</div>';
                str += '</div>';
            } else if (ads[i].type == "flash") {
                str += '<div style="margin: 2px 0pt 10px;">';
                str += '<div>';
                str += '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"';
                str += ' codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"';
                str += ' WIDTH="' + google_ad.image_width + '"';
                str += ' HEIGHT="' + google_ad.image_height + '">';
                str += '<PARAM NAME="movie" VALUE="' + google_ad.image_url + '">';
                str += '<PARAM NAME="quality" VALUE="high">';
                str += '<PARAM NAME="AllowScriptAccess" VALUE="never">';
                str += '<EMBED src="' + google_ad.image_url + '"';
                str += ' WIDTH="' + google_ad.image_width + '"';
                str += ' HEIGHT="' + google_ad.image_height + '"';
                str += ' TYPE="application/x-shockwave-flash"';
                str += ' AllowScriptAccess="never" ';
                str += ' PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED></OBJECT>';
                str += '</div>';
                str += '</div>';
            }
        }
    }

    if (elm) {
        if ('' != str) {
            elm.innerHTML = str;
            elm.style.display = 'block';
        } else {
            elm.style.display = 'none';
        }
    }
};

