var ad=jugemkey_ad_getList();
jugemkey_header_html = [
'<!-- UserBlogHeader -->',
'<div id="UserBlogHeader">',
'<!--<form action="http://jugem.jp/search/" name="search_form" method="get">-->',
'<input type="hidden" name="mode" value="blog" />',
'<input type="hidden" name="engine" value="2" />',
'<table summary="JUGEMヘッダー" id="UBH_table">',
'<tr>',
'<td align="left">',
'',
'	<table class="UBH_left"><tr valign="middle">',
'',
'	<!-- JUGEMロゴ -->',
'	<td class="UBH_jugem">',
'	<a href="http://jugem.jp/?ref=userblogheader" title="JUGEM 無料ブログ" style="display:inline-block;"><img src="http://imaging.jugem.jp/jugemheader_blog/img/logo_jugem.gif" alt="JUGEM 無料ブログ" width="68" height="19" border="0" /></a>',
'	</td>',
'',
'	<!-- 検索フォーム -->',
'	<!-- <td class="UBH_search_input"> -->',
'	<!-- <input class="jugem_search_input" type="text" name="keyword" /> -->',
'	<!-- </td> -->',
'',
'	<!-- <td class="UBH_search_select"> -->',
'	<!-- <select name="searchselect"> -->',
'	<!-- <option value="ブログ全体から" selected="selected">ブログ全体から</option> -->',
'	<!-- <option value="JUGEM内から">JUGEM内から</option> -->',
'	<!-- </select>',
'	<!-- </td>',
'',
'	<!-- <td class="UBH_search_submit"> -->',
'	<!-- <input class="jugem_search_button" type="image" src="http://imaging.jugem.jp/gmoheader/img/key_search.gif" /> -->',
'	<!-- </td> -->',
'',
'	<!-- NEW -->',
'	<td class="UBH_new">',
		ad,
'	</td>',
'',
'	</tr></table>',
'',
'</td>',
'',
'',
'<td>',
'',
'	<table class="UBH_right"><tr valign="middle">',
'',
'	<!-- NEW -->',
'	<td class="UBH_start">',
'	<a href="https://secure.jugem.jp/start/input.php">ブログをはじめる</a>',
'	</td>',
'',
'	<td class="UBH_paperboy" onmouseout="jugemkey_h_ShowMenu(0, \'Service_Paperboy\')" onmouseover="jugemkey_h_ShowMenu(1, \'Service_Paperboy\')">',
'	<a href="http://www.paperboy.co.jp/" title="株式会社paperboy&amp;co."><img src="http://imaging.jugem.jp/jugemheader_blog/img/logo_paperboy.gif" alt="paperboy&amp;co." width="101" height="23" border="0" /></a>',
'	<ul id="Service_Paperboy" style="display:none;">',
'	<li><a id="service_jugem" href="http://jugem.jp/">JUGEM</a></li>',
'	<li><a id="service_jugemplus" href="http://jugem.jp/service/plus/">JUGEM PLUS</a></li>',
'	<li><a id="service_logpi" href="http://logpi.jp/">ログピ</a></li>',
'	<li><a id="service_muumuu" href="http://muumuu-domain.com/">ムームードメイン</a></li>',
'	<li><a id="service_booklog" href="http://booklog.jp/">ブクログ</a></li>',
'	<li><a id="service_calamel" href="http://calamel.jp/">カラメル</a></li>',
'	<li><a id="service_shoppro" href="http://shop-pro.jp/">カラーミーショップ</a></li>',
'	<li><a id="service_petit" href="http://www.petit.cc/">プチ・ホームページ</a></li>',
'	<li><a id="service_30d" href="http://30d.jp/">30days Album</a></li>',
'	<li><a id="service_lolipop" href="http://lolipop.jp/">ロリポップ！</a></li>',
'	<li><a id="service_chicappa" href="http://chicappa.jp/">チカッパ！</a></li>',
'	<li><a id="service_heteml" href="http://heteml.jp/">heteml</a></li>',
'	<li><a id="service_goope" href="http://goope.jp/">グーペ</a></li>',
'	</ul>',
'	</td>',
'',
'	</tr></table>',
'',
'</td>',
'</tr>',
'</table>',
'</form>',
'</div>',
'<!-- // JUGEM_Header -->',
'',
].join("");
document.write(jugemkey_header_html);

if(document.search_form && document.search_form.keyword){
	document.search_form.keyword.focus();
}
function jugemkey_ad_getList(){
	var str   = '';
	var url   = new Array(
				'http://grouptube.jp/',
				'http://calamel.jp/',
				'http://heteml.jp/',
				'http://www.petit.cc/',
				'http://muumuu-domain.com/',
				'http://30d.jp/?ref=userheader');
	var title = new Array(
				'新しいコミュニケーションの形',
				'かわいいショップに感激☆カラメル',
				'タフでマッチョなレンタルサーバー',
				'紙のホームページ「プチ」',
				'ドメインが年間651円から',
				'プライベート専用フォトアルバム');
	var num   = Math.floor((Math.random() * 100)) % url.length;
	var adoff = 0;

	if("gmoheaderadoff" in window){
		adoff = gmoheaderadoff;
	}
	if(!adoff) str = '<a href="'+url[num]+'" target="_blank">'+title[num]+'</a>';
	return str;
}
/********************************************************************************
	関数名		ShowMenu
	機能		サブメニューを表示する。
********************************************************************************/
function jugemkey_h_ShowMenu(bMode, sMenuId){
	
	// 表示モードの場合
	if(bMode == 1){

		// サブメニューを表示する
		jugemkey_h_CntrlMenu('Open', sMenuId);
		
	// 非表示モードの場合
	} else {
		// サブメニューを非表示にする
		jugemkey_h_CntrlMenu('Close', sMenuId);
		
	}
	
}

/********************************************************************************
	関数名		CtrlEvent
	機能		イベントを管理する
********************************************************************************/
function jugemkey_h_CntrlEvent(act, obj, event, funcname, capture){
	switch(act){
		case 'add' :
			if(obj.addEventListener) obj.addEventListener(event, funcname, capture);
			else if(obj.attachEvent) obj.attachEvent("on" + event, funcname);
			break;
		case 'remove' :
			if(obj.removeEventListener) obj.removeEventListener(event, funcname, capture);
			else if(obj.detachEvent) obj.detachEvent("on" + event, funcname);
			break;
	}
}


/********************************************************************************
	関数名		CntrlMenu
	機能		サブメニューを表示する
********************************************************************************/
//タイマー管理用配列
var jugemkey_h_MenuTimer = {};
function jugemkey_h_CntrlMenu(act, idname){
	// 開くまでの待ち時間 
	var ActOpenT = 50;

	// 閉じるまでの待ち時間 
	var ActCloseT = 100;

	switch(act){
		case 'Open' :
			if(jugemkey_h_MenuTimer[idname]){ clearTimeout(jugemkey_h_MenuTimer[idname]); }
			jugemkey_h_MenuTimer[idname] = setTimeout("document.getElementById('"+idname+"').style.display = 'block';", ActOpenT);
			break;
		case 'Close' :
			if(jugemkey_h_MenuTimer[idname]){ clearTimeout(jugemkey_h_MenuTimer[idname]); }
			jugemkey_h_CntrlEvent('add', 'document.documentElement', 'click', '_CloseAll', true);
			jugemkey_h_MenuTimer[idname] = setTimeout("jugemkey_h_CntrlMenu('_Close', '"+idname+"')", ActCloseT);
			break;
		case '_Close' :
			document.getElementById(idname).style.display = 'none';
			break;
		case '_CloseAll' :
			for(i in jugemkey_h_MenuTimer){
				clearTimeout(jugemkey_h_MenuTimer[i]);
				document.getElementById(i).style.display = 'none';
			}
			jugemkey_h_CntrlEvent('remove', 'document.documentElement', 'click', '_CloseAll', true);
			break;
	}
}