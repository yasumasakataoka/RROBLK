var ad=jugemkey_ad_getList();
jugemkey_header_html = [
'<!-- UserBlogHeader -->',
'<div id="UserBlogHeader">',
'<!--<form action="http://jugem.jp/search/" name="search_form" method="get">-->',
'<input type="hidden" name="mode" value="blog" />',
'<input type="hidden" name="engine" value="2" />',
'<table summary="JUGEM�إå���" id="UBH_table">',
'<tr>',
'<td align="left">',
'',
'	<table class="UBH_left"><tr valign="middle">',
'',
'	<!-- JUGEM�� -->',
'	<td class="UBH_jugem">',
'	<a href="http://jugem.jp/?ref=userblogheader" title="JUGEM ̵���֥�" style="display:inline-block;"><img src="http://imaging.jugem.jp/jugemheader_blog/img/logo_jugem.gif" alt="JUGEM ̵���֥�" width="68" height="19" border="0" /></a>',
'	</td>',
'',
'	<!-- �����ե����� -->',
'	<!-- <td class="UBH_search_input"> -->',
'	<!-- <input class="jugem_search_input" type="text" name="keyword" /> -->',
'	<!-- </td> -->',
'',
'	<!-- <td class="UBH_search_select"> -->',
'	<!-- <select name="searchselect"> -->',
'	<!-- <option value="�֥����Τ���" selected="selected">�֥����Τ���</option> -->',
'	<!-- <option value="JUGEM�⤫��">JUGEM�⤫��</option> -->',
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
'	<a href="https://secure.jugem.jp/start/input.php">�֥���Ϥ����</a>',
'	</td>',
'',
'	<td class="UBH_paperboy" onmouseout="jugemkey_h_ShowMenu(0, \'Service_Paperboy\')" onmouseover="jugemkey_h_ShowMenu(1, \'Service_Paperboy\')">',
'	<a href="http://www.paperboy.co.jp/" title="�������paperboy&amp;co."><img src="http://imaging.jugem.jp/jugemheader_blog/img/logo_paperboy.gif" alt="paperboy&amp;co." width="101" height="23" border="0" /></a>',
'	<ul id="Service_Paperboy" style="display:none;">',
'	<li><a id="service_jugem" href="http://jugem.jp/">JUGEM</a></li>',
'	<li><a id="service_jugemplus" href="http://jugem.jp/service/plus/">JUGEM PLUS</a></li>',
'	<li><a id="service_logpi" href="http://logpi.jp/">����</a></li>',
'	<li><a id="service_muumuu" href="http://muumuu-domain.com/">�ࡼ�ࡼ�ɥᥤ��</a></li>',
'	<li><a id="service_booklog" href="http://booklog.jp/">�֥���</a></li>',
'	<li><a id="service_calamel" href="http://calamel.jp/">������</a></li>',
'	<li><a id="service_shoppro" href="http://shop-pro.jp/">���顼�ߡ�����å�</a></li>',
'	<li><a id="service_petit" href="http://www.petit.cc/">�ץ����ۡ���ڡ���</a></li>',
'	<li><a id="service_30d" href="http://30d.jp/">30days Album</a></li>',
'	<li><a id="service_lolipop" href="http://lolipop.jp/">���ݥåס�</a></li>',
'	<li><a id="service_chicappa" href="http://chicappa.jp/">�����åѡ�</a></li>',
'	<li><a id="service_heteml" href="http://heteml.jp/">heteml</a></li>',
'	<li><a id="service_goope" href="http://goope.jp/">������</a></li>',
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
				'���������ߥ�˥��������η�',
				'���襤������åפ˴����������',
				'���դǥޥå���ʥ�󥿥륵���С�',
				'��Υۡ���ڡ����֥ץ���',
				'�ɥᥤ��ǯ��651�ߤ���',
				'�ץ饤�١������ѥե��ȥ���Х�');
	var num   = Math.floor((Math.random() * 100)) % url.length;
	var adoff = 0;

	if("gmoheaderadoff" in window){
		adoff = gmoheaderadoff;
	}
	if(!adoff) str = '<a href="'+url[num]+'" target="_blank">'+title[num]+'</a>';
	return str;
}
/********************************************************************************
	�ؿ�̾		ShowMenu
	��ǽ		���֥�˥塼��ɽ�����롣
********************************************************************************/
function jugemkey_h_ShowMenu(bMode, sMenuId){
	
	// ɽ���⡼�ɤξ��
	if(bMode == 1){

		// ���֥�˥塼��ɽ������
		jugemkey_h_CntrlMenu('Open', sMenuId);
		
	// ��ɽ���⡼�ɤξ��
	} else {
		// ���֥�˥塼����ɽ���ˤ���
		jugemkey_h_CntrlMenu('Close', sMenuId);
		
	}
	
}

/********************************************************************************
	�ؿ�̾		CtrlEvent
	��ǽ		���٥�Ȥ��������
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
	�ؿ�̾		CntrlMenu
	��ǽ		���֥�˥塼��ɽ������
********************************************************************************/
//�����ޡ�����������
var jugemkey_h_MenuTimer = {};
function jugemkey_h_CntrlMenu(act, idname){
	// �����ޤǤ��Ԥ����� 
	var ActOpenT = 50;

	// �Ĥ���ޤǤ��Ԥ����� 
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