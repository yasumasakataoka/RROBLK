var AS1={server:"http://as.asp.kbmj.com",service:null,config:function(a){$.extend(true,this,a)},htmlEscape:function(a){if(a){return String(a).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")}else{return""}},_encodeQuery:function(a){if(a){return encodeURIComponent(a.replace(/[\/~]/g,function(b){return"~"+b.charCodeAt(0).toString(16)}))}else{return""}},Form:{init:function(b){var a=this;this.searchPage=b.page;this.queryElement=b.query;this.qf=b.qf;$(b.form).submit(function(d){var c=null;if(b.qf){c=$(this).find(b.qf).attr("value")}a.searchFromForm($(this).find(b.query).attr("value"),c);d.preventDefault()});$(b.query).suggest(AS1.server+"/"+AS1.service+"/suggest.json",{minchars:2})},searchFromForm:function(c,a){$(this.queryElement).attr("value",c);if(AS1.Searcher){AS1.Searcher.searchFromForm(c,a)}else{var b=this.searchPage+"#q="+AS1._encodeQuery(c);if(a){b+="/qf="+AS1._encodeQuery(a)}location.href=b}}}};