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
   // e.style.background = f ? '#ffffbb' : '';
   // e.style.color = f ? '#000000' : '';
   // e.style.border = f ? '1px solid #ffffbb' : '0';
   // e.style.padding = f ? '5px' : '5px';
   // e.className = f ? 'jg_ads_hover' : 'jg_ads_box';
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
    for (var i=0; i<ads.length; i++) {
        var title = ads[i].line1;
        var line2 = ads[i].line2;
        var line3 = ads[i].line3;
        var url = ads[i].url;
        var visible_url = ads[i].visible_url;
		str += '<style type="text/css">';
		str += '.jg_ads_hover a {color:#0000FE;} </style>';
		str += '<div style="margin: 2px 0pt 10px; padding:5px;" onmouseover="jg_ads_Hover(this,1);" onmouseout="jg_ads_Hover(this,0);">';
        str += '<div>';
        str += '<a href="' + url + '" style="text-decoration: underline;"><span style="font-size: 12px; font-weight:bold; line-height: 200%;">' + title + '</span></a>';
        str += '<a href="' + url + '" style="text-decoration: none;"><span style="margin-left: 10px; font-size: 12px; color:#FF6600;">' + visible_url + '</span></a>';
        str += '</div>';
        str += '<span style="font-size: 12px; font-weight: normal;">' + line2 + line3 + '</span>';
        str += '</div>';
    }
    str += '<div class="jugem_blog_ad_by" style="text-align: right;"><a href="' + google_info.feedback_url + '" target="_blank">Ads by Google</a></div>';

    if (elm) {
        if ('' != str) {
            elm.innerHTML = str;
            elm.style.display = 'block';
        } else {
            elm.style.display = 'none';
        }
    }
};

