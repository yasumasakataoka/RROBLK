// 連想配列を文字列へ変換する関数
function toSource( elm )
{
    var out = '';
    for( var key in elm ){
        if( out != '' ) out += ',';
        out += "'"+key+"':'"+elm[key]+"'";
    }
    return '{' + out + '}';
}
 
var hoge_option = {}
hoge_option["short_cut1"] = "ctrl";
hoge_option["short_cut2"] = "shift";
localStorage.setItem( "hoge_option", toSource( hoge_option ) );

var arytest =  { "name" : "安部礼司", "age":39 , "nickname":"平均", "bloodtype":"A" };
jQuery.each(arytest, function(key, value) {
    if ( key == "bloodtype" ) return false; //ループを抜けるときはfalseを返す。
    alert("キー:" + key + " 値:" + value);
});

