var hatenadfp = hatenadfp || {};
hatenadfp._startTime = new Date().getTime();
hatenadfp.adUnits = hatenadfp.adUnits || [];

var googletag = googletag || {};
googletag.cmd = googletag.cmd || [];

hatenadfp.debug = hatenadfp.debug || false;

hatenadfp.unitSizeNGUnitNameMap = hatenadfp.unitSizeNGUnitNameMap || {
    '300x250' : 'NG',
    '336x280' : 'NG',
    '728x90'  : 'NG/728_90'
};

hatenadfp.isNGContent = typeof hatenadfp.isNGContent !== 'undefined' ? hatenadfp.isNGContent : function () {
    return false;
};

hatenadfp.enableSingleRequest = hatenadfp.enableSingleRequest || false;

hatenadfp.slotRenderEndedCallback = hatenadfp.slotRenderEndedCallback || function (event) {
    if (hatenadfp.debug || window.location.search.match('hatena_dfp_debug=1')) {
        console.log( 'Slot ' + event.slot.getAdUnitPath() + ' has been rendered in '
            + (new Date().getTime() - hatenadfp._startTime) + ' msec, with' +
            ' size: ' + event.size,
            ' creativeID: ' + event.creativeId +
            ' isEmpty: ' + event.isEmpty +
            ' lineItemId: ' + event.lineItemId +
            ' serviceName: ' + event.serviceName );
    }
};

hatenadfp._hasContentMatch = false;
for (var i = 0; i < hatenadfp.adUnits.length; i++) {
    if (hatenadfp.adUnits[i].allowContentMatch) {
        hatenadfp._hasContentMatch = true;
        break;
    }
}

hatenadfp._addScript = function(url) {
    var script = document.createElement("script");
    script.async = true;
    script.type = "text/javascript";
    var useSSL = "https:" == document.location.protocol;
    script.src = url;
    var node = document.getElementsByTagName("script")[0];
    node.parentNode.insertBefore(script, node);
};


hatenadfp._extractContent = function() {
    if (hatenadfp._pageText !== undefined) {
        return hatenadfp._pageText;
    }

    var selectors = [
        '#page-keyword div.keyword-body', /* keyword PC */
        '#question-content-container', /* question PC */
        '#hatena-anond div.section',  /* anond PC */
        '#news-container #entry-wrapper', /* bnews PC */
        '#news-container div.top-news', /* bnews PC top */
        '#hatena-www #s-bookmark', /* www top */
        '#hatena-bookmark-touch-index ul.list.entrylist', /* bookmark touch top */
        'div.section.entry-detail', /* bookmark touch entry */
        'div.entry-contents', /* bookmark PC */
        'div#page-content', /* bookmark userpage PC */
        'div#hatena-body div.main', /* bookmark user PC */
        'article div.entry-content', /* blog PC, blog touch */
        'article section.keyword-body', /* keyword touch */
        'div.day div.body div.section', /* diary PC */
        '#container div.section' /* anond touch */
    ];

    var contentNode = document.querySelector(selectors.join(',')) ||
        document.querySelectorAll('div.body div.section')[1] || /* diary touch */
        document.documentElement;

    var text = contentNode.innerHTML;

    text = text.replace(/\s+/g, ' ');
    text = text.replace(/<(script|noscript|style|iframe|select|blockquote|code|pre)[^>]*>.*?<\/\1>/ig, '');
    text = text.replace(/<a[^>]*>https?:\/\/.*?<\/a>/ig, '');
    text = text.replace(/\s*<("[^"]*"|'[^']*'|[^'">])*>\s*/g, '')
    text = text.replace(/[Ａ-Ｚａ-ｚ０-９]/g, function(s) { return String.fromCharCode(s.charCodeAt(0) - 0xFEE0) });

    hatenadfp._pageText = text;

    return text;
};

hatenadfp.displayAdsWithContentMatch = function (config) {
    if (hatenadfp.contentMatchWaitSelector && !document.querySelector(hatenadfp.contentMatchWaitSelector)) {
        (function (config) {
            setTimeout(hatenadfp.displayAdsWithContentMatch, 50, config);
        })(config);
        return;
    }

    var content = hatenadfp._extractContent();

    var scoresOfConfigs = new Array(config.contentMatchConfigs.length);
    for (var i = 0; i < config.contentMatchConfigs.length; i++) {
        var csvKeywordStr = config.contentMatchConfigs[i].keywords;
        csvKeywordStr = csvKeywordStr.replace(/[Ａ-Ｚａ-ｚ０-９]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
        });
        csvKeywordStr = csvKeywordStr.replace(/([.*+?^=!:${}()|[\]\/\\])/g, "\\$1");
        var keywords = csvKeywordStr.split(',');
        var validKeywords = [];
        for (var j = 0; j < keywords.length; j++) {
            if(keywords[j].length > 0) {
                validKeywords.push(keywords[j]);
            }
        }
        var regexp = new RegExp('(?:' + validKeywords.join('|') + ')', 'ig');
        scoresOfConfigs[i] = 0;
        while(regexp.exec(content)) {
            scoresOfConfigs[i]++;
        }
    }

    /* 複数のコンテンツマッチ枠がマッチすることを考慮して、得たスコアに応じて確率的に広告を出す */
    var totalScore = 0;
    for (var i = 0; i < scoresOfConfigs.length; i++) {
        totalScore += scoresOfConfigs[i];
    }
    /* キーワードを含まない時に広告をだす場合 */
    /* マッチした場合はscoreを0に、マッチしない場合は平均値をscoreとして与える */
    var avgScore = Math.floor(totalScore / scoresOfConfigs.length);
    if ( avgScore === 0 ) avgScore = 1;
    for (var i = 0; i < scoresOfConfigs.length; i++) {
        if ( !!config.contentMatchConfigs[i].rejects_match ) {
            if ( scoresOfConfigs[i] === 0 ) {
                totalScore += avgScore;
                scoresOfConfigs[i] = avgScore;
            } else {
                totalScore -= scoresOfConfigs[i];
                scoresOfConfigs[i] = 0;
            }
        }
    }

    var targetValue = Math.floor(Math.random() * totalScore);

    var targetConfigIndex;
    var valueRangeStart = 0;
    for (var i = 0; i < scoresOfConfigs.length; i++) {
        if (targetValue >= valueRangeStart && targetValue < valueRangeStart + scoresOfConfigs[i]) {
            targetConfigIndex = i;
            break;
        } else {
            valueRangeStart += scoresOfConfigs[i];
        }
    }

    hatenadfp._contentMatchedUnitName = targetConfigIndex !== undefined
        ? config.contentMatchConfigs[targetConfigIndex].dfp_channel
        : null;

    if (targetConfigIndex !== undefined && config.contentMatchConfigs[targetConfigIndex].div_ids) {
        var targetDivIds = config.contentMatchConfigs[targetConfigIndex].div_ids.split(',');
        if (targetDivIds.length > 0) {
            var targetDivIdMap = {};
            for (var i = 0; i < targetDivIds.length; i++) {
                targetDivIdMap[targetDivIds[i]] = true;
            }
            hatenadfp._contentMatchTargetDivIdMap = targetDivIdMap;
        }
    }

    googletag.cmd.push(hatenadfp.displayAds);
};

hatenadfp.displayAds = function() {
    for (var i = 0; i < hatenadfp.adUnits.length; i++) {
        var adUnit = hatenadfp.adUnits[i];
        var adUnitSizes = [];
        if (/_sp_/.test(adUnit.unitName) && typeof(adUnit.size[0]) === 'object') {
            var browserWidth = window.innerWidth;
            for (var j = 0; j < adUnit.size.length; j++) {
                if (adUnit.size[j][0] + 20 <= browserWidth) {
                    adUnitSizes.push(adUnit.size[j]);
                }
            }
        }
        if (adUnitSizes.length === 0) {
            adUnitSizes = adUnit.size;
        }

        if (typeof hatenadfp.isNGContent === 'function' ? hatenadfp.isNGContent() : hatenadfp.isNGContent) {
            for (var k = 0; k < adUnitSizes.length; k++) {
                if (hatenadfp.unitSizeNGUnitNameMap[adUnitSizes[k].join('x')]) {
                    adUnit.unitName = hatenadfp.unitSizeNGUnitNameMap[adUnitSizes[k].join('x')];
                    break;
                }
            }
        } else if (adUnit.allowContentMatch &&
                   hatenadfp._contentMatchedUnitName &&
                   (hatenadfp._contentMatchTargetDivIdMap === undefined ||
                    hatenadfp._contentMatchTargetDivIdMap[adUnit.divId])) {
            adUnit.unitName = hatenadfp._contentMatchedUnitName;
        }
        var adSlot = googletag.defineSlot('/4374287/' + adUnit.unitName, adUnitSizes, adUnit.divId).addService(googletag.pubads());

        var targetingKeyValuesMap = {};
        for (var clientName in hatenadfp._clientDfpTargetingKeyNameMap) {
            var internalClientName = clientName === 'fout' ? 'atrae' : clientName;
            var segmentIds = hatenadfp._getSegmentIdsForClient(internalClientName);
            var targetingKey = hatenadfp._clientDfpTargetingKeyNameMap[internalClientName];
            if (targetingKeyValuesMap[targetingKey] === undefined) {
                targetingKeyValuesMap[targetingKey] = [];
            }
            targetingKeyValuesMap[targetingKey].push.apply(targetingKeyValuesMap[targetingKey], segmentIds);
        }
        for (var targetingKey in targetingKeyValuesMap) {
            if (targetingKeyValuesMap[targetingKey].length > 0) {
                adSlot.setTargeting(targetingKey, targetingKeyValuesMap[targetingKey]);
            }
        }
    }

    googletag.pubads().addEventListener('slotRenderEnded', hatenadfp.slotRenderEndedCallback);
    if (hatenadfp.enableSingleRequest) {
        googletag.pubads().enableSingleRequest();
    }
    if (hatenadfp.centerAds !== undefined) {
        googletag.pubads().setCentering(hatenadfp.centerAds);
    }
    googletag.enableServices();

    /* ChromeのiOS版において、以下のMutationObserverを使った処理がページロード時の
       フリーズの原因になることがあった。そのため、Android版も含め、スマートフォン・タブレット向けの
       Chromeでは、MutationObserverが存在しても利用せず、これを使用しない処理にフォールバックする。 */
    if (window.MutationObserver && !window.navigator.userAgent.match(/(?:Android.+Chrome|CriOS)/)) {
        var observer = new MutationObserver(function(mutations) {
            var shouldWaitForMoreAdUnits = false;
            for (var i = 0; i < hatenadfp.adUnits.length; i++) {
                var adUnit = hatenadfp.adUnits[i];
                if (!adUnit.displayed) {
                    if (document.getElementById(adUnit.divId)) {
                        googletag.display(adUnit.divId);
                        adUnit.displayed = true;
                    } else {
                        shouldWaitForMoreAdUnits = true;
                    }
                }
            }
            if (!shouldWaitForMoreAdUnits) {
                observer.disconnect();
            }
        });
        observer.observe(document, { childList: true, subtree: true });
    } else {
        googletag.cmd.push(function() {
            for (var i = 0; i < hatenadfp.adUnits.length; i++) {
                (function(adUnit) {
                    if (document.getElementById(adUnit.divId)) {
                        googletag.display(adUnit.divId);
                    } else {
                        hatenadfp._onPageLoadComplete(function () {
                            googletag.display(adUnit.divId);
                        });
                    }
                })(hatenadfp.adUnits[i]);
            }
        });
    }
};

hatenadfp._onPageLoadComplete = function (func) {
    if (document.addEventListener) {
        document.addEventListener('DOMContentLoaded', function() {
            func();
        }, false);
    } else if (document.attachEvent) {
        document.attachEvent('onload', function() {
            func();
        });
    }
};

hatenadfp.getCookie = function (key) {
  var counter, _key, _val, cookies = document.cookie.split(";");
  for (counter = 0; counter < cookies.length; counter++) {
    if (_key = cookies[counter].substr(0, cookies[counter].indexOf("=")),
    _val = cookies[counter].substr(cookies[counter].indexOf("=") + 1),
    _key = _key.replace(/^\s+|\s+$/g, ""),
    _key === key) return unescape(_val);
  }
};

hatenadfp.setCookie = function(key, value, expire) {
    var d = new Date();
    d.setDate(d.getDate() + expire);
    value = escape(value) + "; domain=.hatena.ne.jp; path=/" + (null === expire ? "" : "; expires=" + d.toUTCString());
    document.cookie = key + "=" + value;
};

hatenadfp._getSyncSegmentIds = function () {
    var cookieEntryStr = hatenadfp.getCookie("_fout_segment");
    return cookieEntryStr !== undefined ? cookieEntryStr.split(",") : [];
};

hatenadfp._getAllSegmentIds = function () {
    var segmentIds = [];
    ['_fout_segment', '_nttcom_segment', '_vsn_segment', '_cri_segment', '_bsa_segment',
     '_recruit_birth_segment', '_recruit_startup_segment', '_recruit_it_segment'].forEach(function(key) {
        var cookieEntryStr = hatenadfp.getCookie(key);
        if (cookieEntryStr === undefined) return;
        segmentIds = segmentIds.concat(cookieEntryStr.split(","));
    });
    return segmentIds;
};
hatenadfp._getSegmentIdsForClient = function (clientName) {
    var segmentIds = [];
    if (clientName === 'atrae') {
        clientName = 'fout';
    }
    var cookieEntryStr = hatenadfp.getCookie('_' + clientName + '_segment');
    if (cookieEntryStr === undefined) return;
    segmentIds = segmentIds.concat(cookieEntryStr.split(","));
    return segmentIds;
};

hatenadfp._keywordSegmentIdMap = {
    'atrae': {
        'java': 83206,
        'ruby': 83207,
        'php': 83208,
        'perl': 83209,
        'objective-c': 83210,
        'javascript': 83211,
        'html5': 83212,
        'ios': 83213,
        'iphone': 83214,
        'android': 83215,
        'oracle': 83216,
        'mysql': 83217,
        'インフラ': 83218,
        'クラウド': 83219,
        'プログラミング': 83220
    },
    'nttcom': {
        'アプリ開発': 36000,
        'object-c': 36000,
        'java': 36000,
        'java ee': 36000,
        'asp.net mvc': 36000,
        'ruby on rails': 36000,
        'php': 36000,
        'struts': 36000,
        'play': 36000,
        'node.js': 36000,
        '.net': 36000,
        'perl': 36000,
        'c#': 36000,
        'python': 36000,
        'c++': 36000,
        'c+': 36000,
        'ruby': 36000,
        'objective-C': 36000,
        'javascript': 36000,
        'coffeescript': 36000,
        'mysql': 36000,
        'プログラミング': 36000,
        'エンジニア': 36000
    },
    'vsn': {
        'java': 37000,
        'ruby': 37000,
        'php': 37000,
        'perl': 37000,
        'objective-C': 37000,
        'javascript': 37000,
        'html5': 37000,
        'ios': 37000,
        'iphone': 37000,
        'android': 37000,
        'oracle': 37000,
        'mySQL': 37000,
        'インフラ': 37000,
        'クラウド': 37000,
        'プログラミング': 37000,
        'cad': 37000,
        'cobol': 37000,
        'cr5000': 37000,
        'dbms': 37000,
        'fpga': 37000,
        'http': 37000,
        'lsiレイアウト': 37000,
        'mcframe': 37000,
        'oracleebs': 37000,
        'pcb処理': 37000,
        'plcプログラム': 37000,
        'verilog': 37000
    },
    'cri': {
        '求人': 38000,
        '求人サイト': 38001,
        '転職': 38002,
        '転職サイト': 38003,
        '正社員': 38004,
        '契約社員': 38005,
        'フリーランス': 38006,
        '求人情報': 38007,
        'デザイナー求人': 38008,
        'デザイナー転職': 38009,
        'webデザイナー求人': 38010,
        'webデザイナー転職': 38011,
        'web業界求人': 38012,
        'web業界転職': 38013,
        'ウェブ制作会社': 38014,
        'web制作会社': 38015,
        'ウェブデザイナー': 38016,
        'webデザイナー': 38017,
        'ウェブ業界': 38018,
        'web業界': 38019,
        'ウェブサイトデザイン': 38020,
        'webサイトデザイン': 38021,
        'モバイル業界': 38022,
        'ウェブディレクター': 38023,
        'webディレクター': 38024,
        'インフォメーションアーキテクト': 38025,
        'uxデザイナー': 38026,
        'uiデザイナー': 38027,
        'ux・uiデザイナー': 38028,
        'htmlコーダー': 38029,
        'コーダー': 38030,
        'webマーケティング': 38031,
        'ウェブマーケティング': 38032,
        'デザイン事務所': 38033
    },
    'bsa': {
        'bsa': 40000,
        'ビーエスエー': 40001,
        'ビジネスソフウトウェアアライアンス': 40002,
        'business software alliance': 40003,
        'business software': 40004,
        'ソフトウェアアライアンス': 40005,
        '著作権協会': 40006,
        'ザ・ソフトウェア・アライアンス': 40007,
        'the software alliance': 40008,
        '違法コピー': 40009,
        '違法インストール': 40010,
        '不正コピー': 40011,
        '不正インストール': 40012,
        '違法ソフト': 40013,
        '不正ソフト': 40014,
        '不法ソフト': 40015,
        '知財ブラック': 40016,
        '内部告発': 40017,
        '内部通報': 40018,
        '謝礼金': 40019,
        '報奨金': 40020,
        '知財侵害': 40021,
        '知的財産保護': 40022,
        '通報者保護法': 40023,
        '公益通報者保護': 40024,
        '公益通報社保護法': 40025,
        '通報者保護': 40026,
        '海賊版': 40027,
        'ソフトウェア': 40028,
        'office': 40029,
        'オフィス': 40030,
        '通報': 40031,
        'ライセンス': 40032,
        '著作権': 40033
    },
    'recruit_birth': {
        '出産': 41000,
        '子育て': 41001,
        '育児': 41002,
        '子供': 41003,
        '時短勤務': 41004,
        '時短': 41005,
        'パート': 41006,
        'お迎え': 41007,
        '育休': 41008,
        '産休': 41009,
        '復職': 41010,
        '共働き': 41011,
        '家庭の都合': 41012,
        '家計': 41013,
        '待機児童': 41014,
        '保育園': 41015,
        '幼稚園': 41016,
        '職場復帰': 41017,
        '仕事との両立': 41018,
        'ワーキングマザー': 41019,
        '育児支援': 41020,
        '福利厚生': 41021,
        'イクメン': 41022,
        '育児参加': 41023,
        '総合職': 41024,
        '育児ノイローゼ': 41025,
        '里帰り': 41026,
        '女性活用': 41027,
        '育児と仕事の両立': 41028,
        'ベビーシッター': 41029,
        'シッター': 41030,
        '家事': 41031,
        '専業主婦': 41032
    },
    'recruit_startup': {
        '起業': 42000,
        '副業': 42001,
        '開業': 42002,
        '独立': 42003,
        'アフィリエイト': 42004,
        'フランチャイズ': 42005,
        'ベンチャー': 42006,
        '資金0円': 42007,
        'ネット起業': 42008,
        '登記': 42009,
        '資金調達': 42010,
        '会社設立': 42011,
        '事業計画書': 42012,
        '事業アイデア': 42013,
        '独立資源': 42014,
        '助成金': 42015,
        '創業計画書': 42016,
        '起業資金': 42017,
        '資金繰り': 42018,
        '個人事業主': 42019,
        '定款': 42020,
        '自由業': 42021,
        'フリーランス': 42022,
        '青色申告': 42023,
        'リタイア': 42024,
        '通訳': 42025,
        '翻訳': 42026,
        'ライター': 42027,
        'カメラマン': 42028,
        'フリーエンジニア': 42029,
        'フリーデザイナー': 42030
    },
    'recruit_it': {
        '鬱': 38034,
        'うつ': 38035,
        '仕事つらい': 38036,
        '仕事できない': 38037,
        '仕事覚えられない': 38038,
        '仕事辞めたい': 38039,
        '仕事しんどい': 38040,
        'しんどい': 38041,
        '失敗ばかり': 38042,
        '失敗': 38043,
        '仕事行きたくない': 38044,
        '会社行きたくない': 38045,
        '仕事きつい': 38046,
        '居場所ない': 38047,
        '日曜日の夜': 38048,
        '月曜日の朝': 38049,
        'うまくいかない': 38050,
        'はかどらない': 38051,
        'ストレス': 38052,
        '仕事疲れた': 38053,
        'ついていけない': 38054,
        'もうダメだ': 38055,
        '向いてない': 38056
    }
};

hatenadfp._clientDfpTargetingKeyNameMap = {
    'atrae': 'IT',
    'nttcom': 'IT',
    'vsn': 'IT',
    'cri': '求人',
    'bsa': '違法コピー',
    'recruit_birth': '出産',
    'recruit_startup': '起業',
    'recruit_it': 'IT'
};

hatenadfp._keywordAdwordsRemarketingLabelMap = {
    'java': '0dMtCK_shFoQpYfa_gM',
    'php': 'ZJzoCPra_VkQpYfa_gM',
    'perl': 'nAt_COWYgloQpYfa_gM',
    'python': 'o1zYCP3a_VkQpYfa_gM',
    'ruby': 'fQutCKzlg1oQpYfa_gM',
    'objective-c': 'MNBcCITZ-lkQpYfa_gM',
    'javascript': 'NYwLCNj_g1oQpYfa_gM',
    'c#': 'hnXhCNv_g1oQpYfa_gM',
    'mysql': 'a1LHCMmZgVoQpYfa_gM',
    'プログラミング': 'nX_aCN7_g1oQpYfa_gM',
    'エンジニア': 'wPvCCNmAgloQpYfa_gM',
    '独立': 'vL5gCKeygFoQpYfa_gM',
    '起業': 'HCpLCOH_g1oQpYfa_gM',
    'フリーランス': 'LZPbCOT_g1oQpYfa_gM'
};

hatenadfp._keywordFreakoutMotherSegmentIdMap = {
    'japheego': {
        '独立': 121732,
        'java': 121733,
        'プログラミング': 121734,
        'エンジニア': 121735,
        'php': 121736,
        '起業': 121737,
        'ruby': 121738,
        'python': 121739,
        'perl': 121740,
        'c#': 121741,
        'c♯': 121741,
        'フリーランス': 121742,
        'mysql': 121743,
        'javascript': 121744,
        'objective-c': 121745,
        'アルバイト': 140646,
        'パート': 140647,
        '残業なし': 140648
    },
    'recruit': {
        '出産': 122677,
        '子育て': 122678,
        '育児': 122680,
        '子供': 122681,
        '時短勤務': 122682,
        '時短': 122683,
        'パート': 122684,
        'お迎え': 122685,
        '育休': 122686,
        '産休': 122687,
        '復職': 122688,
        '共働き': 122689,
        '家庭の都合': 122690,
        '家計': 122691,
        '待機児童': 122692,
        '保育園': 122693,
        '幼稚園': 122694,
        '職場復帰': 122695,
        '仕事との両立': 122696,
        'ワーキングマザー': 122697,
        '育児支援': 122698,
        '福利厚生': 122699,
        'イクメン': 122700,
        '育児参加': 122701,
        '総合職': 122702,
        '育児ノイローゼ': 122703,
        '里帰り': 122704,
        '女性活用': 122705,
        '育児と仕事の両立': 122706,
        'ベビーシッター': 122707,
        'シッター': 122708,
        '家事': 122709,
        '専業主婦': 122710,

        '起業': 122711,
        '副業': 122712,
        '開業': 122713,
        '独立': 122714,
        'アフィリエイト': 122715,
        'フランチャイズ': 122716,
        'ベンチャー': 122717,
        '資金0円': 122718,
        'ネット起業': 122719,
        '登記': 122720,
        '資金調達': 122721,
        '会社設立': 122722,
        '事業計画書': 122723,
        '事業アイデア': 122724,
        '独立資源': 122725,
        '助成金': 122726,
        '創業計画書': 122727,
        '起業資金': 122766,
        '資金繰り': 122767,
        '個人事業主': 122768,
        '定款': 122769,
        '自由業': 122770,
        'フリーランス': 122771,
        '青色申告': 122772,
        'リタイア': 122773,
        '通訳': 122774,
        '翻訳': 122775,
        'ライター': 122776,
        'カメラマン': 122777,
        'フリーエンジニア': 122778,
        'フリーデザイナー': 122779,

        '鬱': 122782,
        'うつ': 122783,
        '仕事つらい': 122784,
        '仕事できない': 122785,
        '仕事覚えられない': 122786,
        '仕事辞めたい': 122787,
        '仕事しんどい': 122788,
        'しんどい': 122789,
        '失敗ばかり': 122790,
        '失敗': 122791,
        '仕事行きたくない': 122792,
        '会社行きたくない': 122793,
        '仕事きつい': 122794,
        '居場所ない': 122795,
        '日曜日の夜': 122796,
        '月曜日の朝': 122797,
        'うまくいかない': 122798,
        'はかどらない': 122799,
        'ストレス': 122800,
        '仕事疲れた': 122801,
        'ついていけない': 122802,
        'もうダメだ': 122803,
        '向いてない': 122804
    }
};


hatenadfp._addSegmentsByKeywords = function (matchedKeywords) {
    var userSegmentIds = hatenadfp._getAllSegmentIds();
    var userSegmentIdMap = {};
    for (var i = 0; i < userSegmentIds.length; i++) {
        userSegmentIdMap[userSegmentIds[i]] = true;
    }
    for (var i = 0; i < matchedKeywords.length; i++) {
        for (var key in hatenadfp._keywordSegmentIdMap) {
            var matchedSegmentId = hatenadfp._keywordSegmentIdMap[key][matchedKeywords[i]];
            if (matchedSegmentId && userSegmentIdMap[matchedSegmentId] === undefined) {
                hatenadfp._addScript('//b.hatena.ne.jp/api/internal/v0/user.segment.json?keywords_csv=' + encodeURIComponent(matchedKeywords.join(',')));
                return;
            }
        }
    }
};

hatenadfp._assignAdTargetingSegments = function() {
    var text = hatenadfp._extractContent();

    var keywords = [];
    for (var key in hatenadfp._keywordSegmentIdMap) {
        for (var keyword in hatenadfp._keywordSegmentIdMap[key]) {
            keywords.push(hatenadfp._escapeStr(keyword));
        }
    }

    var keywordRegExp = new RegExp('(' + keywords.join('|') + ')', 'ig');
    var matched = keywordRegExp.exec(text);
    var matchedKeywordMap = {};
    while(matched) {
        matchedKeywordMap[matched[0].toLowerCase()] = true;
        matched = keywordRegExp.exec(text);
    }
    var matchedKeywords = [];
    for (var keyword in matchedKeywordMap) {
        matchedKeywords.push(keyword);
    }

    if (matchedKeywords.length > 0) {
        hatenadfp._addSegmentsByKeywords(matchedKeywords);
    }

    /* Google Adwords Remarketing */
    var adwordsKeywords = [];
    for (var adwordsKeyword in hatenadfp._keywordAdwordsRemarketingLabelMap) {
        adwordsKeywords.push(hatenadfp._escapeStr(adwordsKeyword));
    }
    var adwordsKeywordRegExp = new RegExp('(' + adwordsKeywords.join('|') + ')', 'ig');
    var adwordsMatched = adwordsKeywordRegExp.exec(text);
    var adwordsMatchedKeywordMap = {};
    while (adwordsMatched) {
        adwordsMatchedKeywordMap[adwordsMatched[0].toLowerCase()] = true;
        adwordsMatched = adwordsKeywordRegExp.exec(text);
    }
    if (Object.keys(adwordsMatchedKeywordMap).length > 0) {
        for (var adwordsKeyword in adwordsMatchedKeywordMap) {
            var conversionLabel = hatenadfp._keywordAdwordsRemarketingLabelMap[adwordsKeyword];
            if (conversionLabel) {
                (new Image()).src = '//googleads.g.doubleclick.net/pagead/viewthroughconversion/1071023013/?value=1.00&currency_code=JPY&label=' + conversionLabel + '&guid=ON&script=0'
            }
        }
    }

    /* Freakout/Mother user segmentation */
    var _fout_queue = _fout_queue || {};
    if (_fout_queue.segment === void 0) _fout_queue.segment = {};
    if (_fout_queue.segment.queue === void 0) _fout_queue.segment.queue = [];
    if (_fout_queue.redirect === void 0) _fout_queue.redirect = {};
    _fout_queue.redirect['is_redirect'] = true;

    for (var clientName in hatenadfp._keywordFreakoutMotherSegmentIdMap) {
        var clientKeywords = [];
        for (var clientKeyword in hatenadfp._keywordFreakoutMotherSegmentIdMap[clientName]) {
            clientKeywords.push(hatenadfp._escapeStr(clientKeyword));
        }
        var clientKeywordRegExp = new RegExp('(' + clientKeywords.join('|') + ')', 'ig');
        var clientMatched = clientKeywordRegExp.exec(text);
        var clientMatchedKeywordMap = {};
        while (clientMatched) {
            clientMatchedKeywordMap[clientMatched[0].toLowerCase()] = true;
            clientMatched = clientKeywordRegExp.exec(text);
        }
        if (Object.keys(clientMatchedKeywordMap).length > 0) {
            var clientSemgentIds = [];
            for (var clientKeyword in clientMatchedKeywordMap) {
                var segmentId = hatenadfp._keywordFreakoutMotherSegmentIdMap[clientName][clientKeyword];
                if (segmentId) {
                    _fout_queue.segment.queue.push({
                        'user_id': (clientName === 'japheego' ? 6902 : 6942),
                        'segment_id': segmentId,
                        'ex_url': 'http://hatena.ne.jp/'
                    });
                }
            }
        }
    }

    if (_fout_queue.segment.queue.length > 0) {
        window._fout_queue = _fout_queue;
        (function() {
            var el = document.createElement('script'); el.type = 'text/javascript'; el.async = true;
            el.src = (('https:' == document.location.protocol) ? 'https://' : 'http://') + 'js.fout.jp/segmentation.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(el, s);
        })();
    }
};

hatenadfp._escapeStr = function(str) {
    return str.replace(new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:\\' + '-]', 'g'), '\\$&');
};

hatenadfp._effectiveSegmentIdMap = {
    '3014': true,
    '3008': true,
    '13128': true,
    '10184': true
};

hatenadfp.displayAdsMayContentMatch = function () {
    if (hatenadfp._hasContentMatch) {
        hatenadfp._addScript('//b.hatena.ne.jp/api/dfp.config.json?callback=hatenadfp.displayAdsWithContentMatch');
    } else {
        googletag.cmd.push(hatenadfp.displayAds);
    }
}

hatenadfp.displayAdsWithSegmentSync = function(segmentData) {
    var segmentIds = hatenadfp._getSyncSegmentIds();
    var segmentIdMap = {};
    for (var i = 0; i < segmentIds.length; i++) {
        segmentIdMap[segmentIds[i]] = true;
    }
    if(segmentData.segments !== undefined) {
        for (var j = 0; j < segmentData.segments.length; j++) {
            if (hatenadfp._effectiveSegmentIdMap[segmentData.segments[j].segment_id]) {
                segmentIdMap[segmentData.segments[j].segment_id] = true;
            }
        }
    }
    var mergedSegmentIds = [];
    for (var segmentId in segmentIdMap) {
        mergedSegmentIds.push(segmentId);
    }

    hatenadfp.setCookie('_fout_segment', mergedSegmentIds.join(','), 365);
    hatenadfp.setCookie('_fout_segment_sync', '1', 1);

    hatenadfp.displayAdsMayContentMatch();
};

if (!hatenadfp.getCookie('_fout_segment_sync')) {
    hatenadfp._addScript('http://cnt.fout.jp/segapi/audience?cvid=mstR6EjxHmpIV1QDzg&callback=hatenadfp.displayAdsWithSegmentSync');
} else {
    hatenadfp.displayAdsMayContentMatch();
}

hatenadfp._addScript('//www.googletagservices.com/tag/js/gpt.js');

hatenadfp._onPageLoadComplete(hatenadfp._assignAdTargetingSegments);
