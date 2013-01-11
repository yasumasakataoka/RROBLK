if (typeof(Jugem) == 'undefined') Jugem = {};
if (typeof(Jugem.ads) == 'undefined') Jugem.ads = {};

Jugem.ads.init = function() {
    if (typeof google_ad_slot != "undefined") { 
        google_ad_slot = null;
    }
    if (typeof google_ad_width != "undefined") {
        google_ad_width = null;
    }
    if (typeof google_ad_height != "undefined") {
        google_ad_height = null;
    }
    google_ad_client = 'ca-paperboy-jugem_js';
    google_ad_output = 'js';
    google_max_num_ads = '3';
    google_ad_type = 'text,image,flash,html';
    google_image_size = '300x250';
    google_language = 'ja';
    google_encoding = 'euc-jp';
    google_safe = 'high';
    google_feedback = 'on';
    google_ad_channel = 'bottom';
    google_ad_section = 'description';
    if (google_ad_type.indexOf(google_last_ad_type) > -1) {
        google_skip = google_num_ads;
    }
    //google_adtest = 'on';
};
Jugem.ads.init();
