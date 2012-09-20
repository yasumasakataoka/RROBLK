/*jslint evil:true */
/**
 * Dynamic thread loader
 *
 * 
 * 
 * 
 * 
 * 
*/

// 
var DISQUS;
if (!DISQUS || typeof DISQUS == 'function') {
    throw "DISQUS object is not initialized";
}
// 

// json_data and default_json django template variables will close
// and re-open javascript comment tags

(function () {
    var jsonData, cookieMessages, session, key;

    /* */ jsonData = {"reactions": [], "reactions_limit": 10, "ordered_highlighted": [], "posts": {"247346625": {"edited": false, "author_is_moderator": false, "from_request_user": null, "up_voted": false, "ip": "", "last_modified_date": null, "dislikes": 0, "has_replies": false, "vote": false, "votable": true, "last_modified_by": null, "real_date": "2007-04-05_05:23:55", "date": "4 years ago", "message": "This article is an excerpt from the \"Ruby Cookbook,\" published by O'Reilly. We hope you found it to be enjoyable and educational. Please let us know what you thought of it, and if you would like to see more content of this nature.", "approved": true, "is_last_child": false, "can_edit": false, "can_reply": true, "likes": 0, "user_voted": null, "num_replies": 0, "down_voted": false, "is_first_child": false, "has_been_anonymized": false, "highlighted": false, "parent_post_id": null, "depth": 0, "points": 0, "user_key": "e8436d86d9b7e6e8d0c44643a95dcb65", "author_is_creator": false, "email": "", "killed": false, "is_realtime": false}, "247346626": {"edited": false, "author_is_moderator": false, "from_request_user": null, "up_voted": false, "ip": "", "last_modified_date": null, "dislikes": 0, "has_replies": false, "vote": false, "votable": true, "last_modified_by": null, "real_date": "2011-06-13_04:12:49", "date": "3 months ago", "message": "ADAudit Plus is a valuable security tool that will help you be compliant with all the IT regulatory acts. With this tool, you can monitor user activity such as logon, file access, etc. A configurable alert system warns you of potential threats.", "approved": true, "is_last_child": false, "can_edit": false, "can_reply": true, "likes": 0, "user_voted": null, "num_replies": 0, "down_voted": false, "is_first_child": false, "has_been_anonymized": false, "highlighted": false, "parent_post_id": null, "depth": 0, "points": 0, "user_key": "c92841288ad1bdc3550098eeed78e918", "author_is_creator": false, "email": "", "killed": false, "is_realtime": false}}, "ordered_posts": [247346626, 247346625], "realtime_enabled": false, "ready": true, "mediaembed": [], "has_more_reactions": false, "realtime_paused": true, "integration": {"receiver_url": null, "hide_user_votes": false, "reply_position": false, "disqus_logo": false}, "highlighted": {}, "reactions_start": 0, "media_url": "http://mediacdn.disqus.com/1316728242", "users": {"c92841288ad1bdc3550098eeed78e918": {"username": "Anonymous1204", "tumblr": "", "about": "", "display_name": "Anonymous1204", "url": "http://disqus.com/guest/c92841288ad1bdc3550098eeed78e918/", "registered": false, "remote_id": null, "linkedin": "", "blog": "http://www.aspfree.com", "remote_domain": "", "points": null, "facebook": "", "avatar": "http://mediacdn.disqus.com/1316728242/images/noavatar32.png", "delicious": "", "is_remote": false, "verified": false, "flickr": "", "twitter": "", "remote_domain_name": ""}, "e8436d86d9b7e6e8d0c44643a95dcb65": {"username": "TerriWells", "tumblr": "", "about": "", "display_name": "TerriWells", "url": "http://disqus.com/guest/e8436d86d9b7e6e8d0c44643a95dcb65/", "registered": false, "remote_id": null, "linkedin": "", "blog": "http://www.aspfree.com", "remote_domain": "", "points": null, "facebook": "", "avatar": "http://mediacdn.disqus.com/1316728242/images/noavatar32.png", "delicious": "", "is_remote": false, "verified": false, "flickr": "", "twitter": "", "remote_domain_name": ""}}, "messagesx": {"count": 0, "unread": []}, "thread": {"voters_count": 0, "offset_posts": 0, "slug": "httpwwwdevarticlescomcaruby_on_railslogin_systems_and_more_with_ruby_on_rails", "paginate": false, "num_pages": 1, "days_alive": 0, "moderate_none": false, "voters": {}, "total_posts": 2, "realtime_paused": true, "queued": false, "pagination_type": "append", "user_vote": null, "likes": 0, "num_posts": 2, "closed": false, "per_page": 0, "id": 354732982, "killed": false, "moderate_all": false}, "forum": {"use_media": true, "avatar_size": 32, "apiKey": "S5fta83M8bvrkLPChLBfIU8myOtinzxTEcE8zRl09u27OW4QUSJDZqMmGVBo58fu", "features": {}, "use_old_templates": false, "comment_max_words": 0, "mobile_theme_disabled": false, "linkbacks_enabled": true, "is_early_adopter": false, "allow_anon_votes": true, "revert_new_login_flow": false, "stylesUrl": "http://mediacdn.disqus.com/uploads/styles/90/6363/devarticles.css", "login_buttons_enabled": true, "streaming_realtime": false, "show_avatar": true, "reactions_enabled": true, "reply_position": false, "id": 906363, "name": "Dev Articles Web Development", "language": "en", "mentions_enabled": false, "url": "devarticles", "allow_anon_post": true, "disqus_auth_disabled": false, "thread_votes_disabled": false, "default_avatar_url": "http://mediacdn.disqus.com/1316728242/images/noavatar32.png", "ranks_enabled": false, "template": {"mobile": {"url": "http://mediacdn.disqus.com/1316728242/build/themes/newmobile.js", "css": "http://mediacdn.disqus.com/1316728242/build/themes/newmobile.css"}, "url": "http://mediacdn.disqus.com/1316728242/build/themes/t_b3e3e393c77e35a4a3f3cbd1e429b5dc.js?1", "api": "1.1", "name": "Houdini", "css": "http://mediacdn.disqus.com/1316728242/build/themes/t_b3e3e393c77e35a4a3f3cbd1e429b5dc.css?1"}, "hasCustomStyles": false, "max_depth": 0, "lastUpdate": "", "moderate_all": false}, "settings": {"realtimeHost": "qq.disqus.com", "uploads_url": "http://media.disqus.com/uploads", "ssl_media_url": "https://securecdn.disqus.com/1316728242", "realtime_url": "http://rt.disqus.com/forums/realtime-cached.js", "facebook_app_id": "52254943976", "minify_js": true, "recaptcha_public_key": "6LdKMrwSAAAAAPPLVhQE9LPRW4LUSZb810_iaa8u", "read_only": false, "facebook_api_key": "4aaa6c7038653ad2e4dbeba175a679ba", "realtimePort": "80", "debug": false, "disqus_url": "http://disqus.com", "media_url": "http://mediacdn.disqus.com/1316728242"}, "ranks": {}, "request": {"sort": 4, "is_authenticated": false, "user_type": "anon", "subscribe_on_post": 0, "missing_perm": null, "user_id": null, "remote_domain_name": "", "remote_domain": "", "is_verified": false, "email": "", "profile_url": "", "username": "", "is_global_moderator": false, "sharing": {}, "timestamp": "2011-09-24_20:49:04", "is_moderator": false, "forum": "devarticles", "is_initial_load": true, "display_username": "", "points": null, "moderator_can_edit": false, "is_remote": false, "userkey": "", "page": 1}, "context": {"use_twitter_signin": true, "use_fb_connect": true, "show_reply": true, "active_switches": ["bespin", "community_icon", "embedapi", "google_auth", "mentions", "new_facebook_auth", "realtime_cached", "show_captcha_on_links", "ssl", "static_reply_frame", "static_styles", "statsd_created", "upload_media", "use_rs_paginator_60m"], "sigma_chance": 10, "use_google_signin": true, "switches": {"olark_admin_addons": true, "listactivity_replies": true, "use_master_for_api": true, "google_auth": true, "html_email": true, "moderate_ascending": true, "community_icon": true, "show_captcha_on_links": true, "send_to_akismet": true, "olark_admin_packages": true, "static_styles": true, "stats": true, "realtime_cached": true, "statsd_created": true, "bespin": true, "olark_support": true, "olark_addons": true, "new_facebook_auth": true, "limit_get_posts_days_30d": true, "compare_spam": true, "use_akismet": true, "upload_media": true, "vip_read_slave": true, "embedapi": true, "train_akismet": true, "ssl": true, "send_to_impermium": true, "train_impermium": true, "listactivity_replies_30d": true, "statsd.timings": true, "use_rs_paginator_60m": true, "mentions": true, "olark_install": true, "static_reply_frame": true}, "forum_facebook_key": "", "use_yahoo": false, "subscribed": false, "active_gargoyle_switches": ["compare_spam", "html_email", "limit_get_posts_days_30d", "listactivity_replies", "listactivity_replies_30d", "moderate_ascending", "olark_addons", "olark_admin_addons", "olark_admin_packages", "olark_install", "olark_support", "send_to_akismet", "send_to_impermium", "show_captcha_on_links", "stats", "statsd.timings", "train_akismet", "train_impermium", "use_akismet", "use_master_for_api", "vip_read_slave"], "realtime_speed": 15000, "use_openid": true}}; /* */
    /* */ cookieMessages = {"user_created": null, "post_has_profile": null, "post_twitter": null, "post_not_approved": null}; session = {"url": null, "name": null, "email": null}; /* */

    DISQUS.jsonData = jsonData;
    DISQUS.jsonData.cookie_messages = cookieMessages;
    DISQUS.jsonData.session = session;

    if (DISQUS.useSSL) {
        DISQUS.useSSL(DISQUS.jsonData.settings);
    }

    // The mappings below are for backwards compatibility--before we port all the code that
    // accesses jsonData.settings to DISQUS.settings

    var mappings = {
        debug:                'disqus.debug',
        minify_js:            'disqus.minified',
        read_only:            'disqus.readonly',
        recaptcha_public_key: 'disqus.recaptcha.key',
        facebook_app_id:      'disqus.facebook.appId',
        facebook_api_key:     'disqus.facebook.apiKey'
    };

    var urlMappings = {
        disqus_url:    'disqus.urls.main',
        media_url:     'disqus.urls.media',
        ssl_media_url: 'disqus.urls.sslMedia',
        realtime_url:  'disqus.urls.realtime',
        uploads_url:   'disqus.urls.uploads'
    };

    if (DISQUS.jsonData.context.switches.realtime_setting_change) {
        urlMappings.realtimeHost = 'realtime.host';
        urlMappings.realtimePort = 'realtime.port';
    }
    for (key in mappings) {
        if (mappings.hasOwnProperty(key)) {
            DISQUS.settings.set(mappings[key], DISQUS.jsonData.settings[key]);
        }
    }

    for (key in urlMappings) {
        if (urlMappings.hasOwnProperty(key)) {
            DISQUS.jsonData.settings[key] = DISQUS.settings.get(urlMappings[key]);
        }
    }
}());

DISQUS.jsonData.context.csrf_token = '21bc467119200cb06806902fa8e2f5b0';

DISQUS.jsonData.urls = {
    login: 'http://disqus.com/profile/login/',
    logout: 'http://disqus.com/logout/',
    upload_remove: 'http://devarticles.disqus.com/thread/httpwwwdevarticlescomcaruby_on_railslogin_systems_and_more_with_ruby_on_rails/async_media_remove/',
    request_user_profile: 'http://disqus.com/AnonymousUser/',
    request_user_avatar: 'http://mediacdn.disqus.com/1316728242/images/noavatar92.png',
    verify_email: 'http://disqus.com/verify/',
    remote_settings: 'http://devarticles.disqus.com/_auth/embed/remote_settings/',
    embed_thread: 'http://devarticles.disqus.com/thread.js',
    embed_vote: 'http://devarticles.disqus.com/vote.js',
    embed_thread_vote: 'http://devarticles.disqus.com/thread_vote.js',
    embed_thread_share: 'http://devarticles.disqus.com/thread_share.js',
    embed_queueurl: 'http://devarticles.disqus.com/queueurl.js',
    embed_hidereaction: 'http://devarticles.disqus.com/hidereaction.js',
    embed_more_reactions: 'http://devarticles.disqus.com/more_reactions.js',
    embed_subscribe: 'http://devarticles.disqus.com/subscribe.js',
    embed_highlight: 'http://devarticles.disqus.com/highlight.js',
    embed_block: 'http://devarticles.disqus.com/block.js',
    update_moderate_all: 'http://devarticles.disqus.com/update_moderate_all.js',
    update_days_alive: 'http://devarticles.disqus.com/update_days_alive.js',
    show_user_votes: 'http://devarticles.disqus.com/show_user_votes.js',
    forum_view: 'http://devarticles.disqus.com/httpwwwdevarticlescomcaruby_on_railslogin_systems_and_more_with_ruby_on_rails',
    cnn_saml_try: 'http://disqus.com/saml/cnn/try/',
    realtime: DISQUS.jsonData.settings.realtime_url,
    thread_view: 'http://devarticles.disqus.com/thread/httpwwwdevarticlescomcaruby_on_railslogin_systems_and_more_with_ruby_on_rails/',
    twitter_connect: DISQUS.jsonData.settings.disqus_url + '/_ax/twitter/begin/',
    yahoo_connect: DISQUS.jsonData.settings.disqus_url + '/_ax/yahoo/begin/',
    openid_connect: DISQUS.jsonData.settings.disqus_url + '/_ax/openid/begin/',
    googleConnect: DISQUS.jsonData.settings.disqus_url + '/_ax/google/begin/',
    community: 'http://devarticles.disqus.com/community.html',
    admin: 'http://devarticles.disqus.com/admin/moderate/',
    moderate: 'http://devarticles.disqus.com/admin/moderate/',
    moderate_threads: 'http://devarticles.disqus.com/admin/moderate-threads/',
    settings: 'http://devarticles.disqus.com/admin/settings/',
    unmerged_profiles: 'http://disqus.com/embed/profile/unmerged_profiles/',

    channels: {
        def:      'http://disqus.com/default.html', /* default channel */
        auth:     'https://secure.disqus.com/embed/login.html',
        tweetbox: 'http://disqus.com/forums/integrations/twitter/tweetbox.html?f=devarticles',
        edit:     'http://devarticles.disqus.com/embed/editcomment.html',

        
        
        reply:    'http://mediacdn.disqus.com/1316728242/build/system/reply.html',
        upload:   'http://mediacdn.disqus.com/1316728242/build/system/upload.html',
        sso:      'http://mediacdn.disqus.com/1316728242/build/system/sso.html',
        facebook: 'http://mediacdn.disqus.com/1316728242/build/system/facebook.html'
        
        
    }
};
