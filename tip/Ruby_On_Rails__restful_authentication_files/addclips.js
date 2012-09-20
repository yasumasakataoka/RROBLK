var  AddClipsUrl   = '';
var  AddClipsTitle = '';
if (typeof AddClipsDefault=="undefined"||AddClipsDefault!="rss"){ var AddClipsDefault='bookmark';}
function AddClipsWindow(obj, str){
 var params  = 'http://www.addclips.org/addclips.php';
 params += '?id='+AddClipsId;
 params += '&url='+encodeURIComponent(AddClipsUrl);
 params += '&title='+encodeURIComponent(AddClipsTitle);
 params += '&type='+AddClipsDefault;
 params += '&plan=addclips';
 window.open(params,'addclips','scrollbars=yes,menubar=no,width=600,height=530,resizable=yes,toolbar=no,location=no,status=no,screenX=200,screenY=100,left=200,top=100');
 return false;
}
/*var mad_client_id='4028'; var mad_group_id='';var mad_host="http://track.send.microad.jp";if(document.location.protocol=="https:"){ mad_host="https://send.microad.jp";}var encode_url=escape(document.referrer);var mad_query="clientid="+mad_client_id+"&group="+mad_group_id+"&prereferrer="+encode_url;var mad_url=mad_host+"/track.cgi?"+mad_query;var mad_target=new Image();mad_target.src=mad_url;*/
