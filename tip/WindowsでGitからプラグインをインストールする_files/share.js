(function(){function makeSharer(href){return function(event){window.open(href,"share",["width=632","height=456,","location=yes","resizable=yes","toolbar=no","menubar=no","scrollbars=no","status=no"].join(","));stopEvent(event||window.event);};}
function buildQueryParams(params){var queries=[];for(var i=0,n=0;i<params.length;){var key=params[i++];var value=params[i++];if(!value)continue;queries[n++]=key+"="+encodeURIComponent(value);}
return queries.join("&");}
function observeEvent(element,name,observer){if(element.addEventListener){element.addEventListener(name,observer,false);}else if(element.attachEvent){element.attachEvent("on"+name,observer);}else{element["on"+name]=observer;}}
function stopEvent(event){if(event.preventDefault){event.preventDefault();event.stopPropagation();}else{event.returnValue=false;event.cancelBubble=true;}}
function findButtons(element){var buttons=[];var elements=document.getElementsByTagName("a");for(var i=0,l=elements.length;i<l;i++){var element=elements[i];var className=element.className||"";var prefix=/(?:^|\s)mixi-check-button(?:\s|$)/.test(className)?"data-":element.getAttribute("check_key")?"check_":null;if(!prefix)continue;buttons.push({key:element.getAttribute(prefix+"key"),button:element.getAttribute(prefix+"button"),url:element.getAttribute(prefix+"url"),config:element.getAttribute(prefix+"config"),nocache:element.getAttribute(prefix+"nocache"),element:element});}
return buttons;}
var buttons=findButtons(document);for(var i=0,l=buttons.length;i<l;i++){var button=buttons[i];var type=(button["button"]||"button-1.png").split("-");var prefix=("https:"==document.location.protocol)?"https://mixi.jp/":"http://static.mixi.jp/";if(!type||type.length<2)type=["button","1.png"];if(type[1].indexOf(".")==-1)type[1]+=".png";var src=(type[0]=="button")?[prefix,"img/basic/mixicheck_entry/bt_check_",type[1]]:(type[0]=="icon")?[prefix,"img/basic/mixicheck_entry/icon_mixi_",type[1]]:[prefix,"img/basic/mixicheck_entry/bt_check_1.png"];src=src.join("");var query_params=buildQueryParams(["u",button["url"]||document.location.href,"k",button["key"],"c",button["config"],"nocache",button["nocache"]]);var href="http://mixi.jp/share.pl?"+query_params;var img=document.createElement("img");img.setAttribute("src",src);img.style.border="0";var element=button.element;for(var j=element.childNodes.length-1;j>=0;j--){element.removeChild(element.childNodes[j]);}
element.appendChild(img);element.setAttribute("target","_blank");element.setAttribute("href",href);observeEvent(element,"click",makeSharer(href));}})();